import 'dart:io';

import 'package:badminton_app/data/data_store.dart';
import 'package:badminton_app/logic/coach_context.dart';
import 'package:badminton_app/content/technique.dart';
import 'package:badminton_app/logic/goals.dart';
import 'package:badminton_app/logic/interval_timer.dart';
import 'package:badminton_app/logic/live_score.dart';
import 'package:badminton_app/logic/scoring.dart';
import 'package:badminton_app/logic/stats.dart';
import 'package:badminton_app/logic/technique_stats.dart';
import 'package:badminton_app/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

MatchRecord match(DateTime date, List<List<int>> games,
        {String opponents = 'Bo', MatchType type = MatchType.single}) =>
    MatchRecord(
      id: newId(),
      playerId: 'p',
      date: date,
      type: type,
      opponents: opponents,
      games: [for (final g in games) GameScore(g[0], g[1])],
    );

TrainingSession training(DateTime date, int minutes,
        [TrainingType type = TrainingType.technique]) =>
    TrainingSession(
      id: newId(),
      playerId: 'p',
      date: date,
      durationMinutes: minutes,
      type: type,
      intensity: 3,
    );

void main() {
  group('scoring', () {
    test('3x21 games', () {
      const s = ScoringSystem.to21;
      expect(isStandardGame(const GameScore(21, 19), s), isTrue);
      expect(isStandardGame(const GameScore(21, 0), s), isTrue);
      expect(isStandardGame(const GameScore(22, 20), s), isTrue);
      expect(isStandardGame(const GameScore(28, 30), s), isTrue);
      expect(isStandardGame(const GameScore(30, 29), s), isTrue);
      expect(isStandardGame(const GameScore(21, 20), s), isFalse);
      expect(isStandardGame(const GameScore(23, 20), s), isFalse);
      expect(isStandardGame(const GameScore(15, 10), s), isFalse);
      expect(isStandardGame(const GameScore(31, 29), s), isFalse);
    });

    test('3x15 games (Danmark fra 1. juli 2026, BWF fra 2027)', () {
      const s = ScoringSystem.to15;
      expect(isStandardGame(const GameScore(15, 0), s), isTrue);
      expect(isStandardGame(const GameScore(15, 13), s), isTrue);
      expect(isStandardGame(const GameScore(16, 14), s), isTrue);
      expect(isStandardGame(const GameScore(18, 20), s), isTrue);
      // Loft ved 21: ved 20-20 vinder næste point.
      expect(isStandardGame(const GameScore(21, 20), s), isTrue);
      expect(isStandardGame(const GameScore(21, 19), s), isTrue);
      expect(isStandardGame(const GameScore(15, 14), s), isFalse);
      expect(isStandardGame(const GameScore(17, 14), s), isFalse);
      expect(isStandardGame(const GameScore(21, 18), s), isFalse);
      expect(isStandardGame(const GameScore(22, 20), s), isFalse);
      expect(isStandardGame(const GameScore(14, 10), s), isFalse);
    });

    test('without a system a game is valid in either system', () {
      expect(isStandardGame(const GameScore(15, 10)), isTrue);
      expect(isStandardGame(const GameScore(21, 15)), isTrue);
      expect(isStandardGame(const GameScore(21, 20)), isTrue);
      expect(isStandardGame(const GameScore(11, 5)), isFalse);
    });

    test('valid best of three', () {
      final check = checkMatch(const [GameScore(21, 15), GameScore(21, 18)]);
      expect(check.canSave, isTrue);
      expect(check.warnings, isEmpty);

      final three = checkMatch(
          const [GameScore(21, 15), GameScore(19, 21), GameScore(21, 17)]);
      expect(three.warnings, isEmpty);

      final to15 = checkMatch(
          const [GameScore(15, 12), GameScore(13, 15), GameScore(21, 20)]);
      expect(to15.warnings, isEmpty);
    });

    test('errors block saving', () {
      expect(checkMatch(const []).errors, {ScoreError.noGames});
      expect(checkMatch(const [GameScore(21, 21)]).errors,
          contains(ScoreError.tiedGame));
      expect(
          checkMatch(const [GameScore(21, 15), GameScore(15, 21)]).errors,
          {ScoreError.noWinner});
    });

    test('non-standard scores only warn', () {
      final check = checkMatch(const [GameScore(11, 5)]);
      expect(check.canSave, isTrue);
      expect(check.warnings, {
        ScoreWarning.nonStandardGame,
        ScoreWarning.nonStandardGameCount,
      });
      // Tredje sæt spillet selvom kampen var afgjort efter to.
      final extra = checkMatch(
          const [GameScore(21, 15), GameScore(21, 15), GameScore(15, 21)]);
      expect(extra.warnings, {ScoreWarning.nonStandardGameCount});
      // Et sæt til 15 og et sæt til 21 i samme kamp passer ikke sammen.
      final mixed = checkMatch(const [GameScore(15, 10), GameScore(21, 15)]);
      expect(mixed.warnings, {ScoreWarning.nonStandardGame});
    });
  });

  group('stats', () {
    final d = DateTime(2026, 9, 1);
    final matches = [
      match(d, [[21, 10], [21, 12]], opponents: 'Bo'),
      match(addDays(d, 1), [[10, 21], [12, 21]], opponents: 'bo '),
      match(addDays(d, 2), [[21, 19], [21, 19]], opponents: 'Anders'),
      match(addDays(d, 3), [[21, 19], [19, 21], [21, 19]],
          opponents: 'Anders', type: MatchType.double),
      match(addDays(d, 4), [[21, 19], [21, 19]], opponents: 'Anders'),
    ];

    test('win stats', () {
      final s = WinStats.of(matches);
      expect(s.played, 5);
      expect(s.won, 4);
      expect(s.rate, 0.8);
      expect(WinStats.of(const []).rate, isNull);
      final byType = winStatsByType(matches);
      expect(byType[MatchType.double]!.played, 1);
      expect(byType[MatchType.mixed]!.rate, isNull);
    });

    test('streaks and form', () {
      expect(recentForm(matches, count: 3), [true, true, true]);
      final streak = currentStreak(matches)!;
      expect(streak.won, isTrue);
      expect(streak.length, 3);
      expect(longestWinStreak(matches), 3);
      expect(currentStreak(const []), isNull);
    });

    test('head to head groups names case-insensitively', () {
      final h2h = headToHead(matches);
      // Den nyeste stavemåde af navnet vises.
      expect(h2h.map((o) => o.name), ['Anders', 'bo']);
      expect(h2h[1].stats.played, 2);
      expect(h2h[1].stats.won, 1);
    });

    test('point diff series is chronological', () {
      expect(pointDiffSeries(matches), [20, -20, 4, 2, 4]);
      expect(pointDiffSeries(matches, last: 2), [2, 4]);
    });

    test('weekly training buckets start on monday', () {
      final now = DateTime(2026, 9, 30); // onsdag
      final weeks = weeklyTraining([
        training(DateTime(2026, 9, 28, 18), 60), // mandag denne uge
        training(DateTime(2026, 9, 27, 18), 90), // søndag sidste uge
        training(DateTime(2026, 9, 21), 30, TrainingType.physical),
        training(DateTime(2025, 1, 1), 999), // udenfor perioden
      ], weeks: 3, now: now);
      expect(weeks.map((w) => w.weekStart), [
        DateTime(2026, 9, 14),
        DateTime(2026, 9, 21),
        DateTime(2026, 9, 28),
      ]);
      expect(weeks.map((w) => w.totalMinutes), [0, 120, 60]);
      expect(weeks[1].minutesByType[TrainingType.physical], 30);
      expect(weeks[1].sessions, 2);
    });

    test('iso week numbers', () {
      expect(isoWeekNumber(DateTime(2026, 9, 29)), 40);
      expect(isoWeekNumber(DateTime(2027, 1, 1)), 53);
      expect(isoWeekNumber(DateTime(2026, 1, 1)), 1);
    });
  });

  group('goals', () {
    final now = DateTime(2026, 9, 30);
    final trainings = [
      training(DateTime(2026, 9, 28), 60),
      training(DateTime(2026, 9, 29), 45),
      training(DateTime(2026, 9, 20), 120),
    ];

    Goal goal(GoalType type, int target, [DateTime? created]) => Goal(
          id: 'g',
          playerId: 'p',
          type: type,
          target: target,
          createdAt: created ?? DateTime(2026, 9, 1),
        );

    test('weekly goals count only this week', () {
      final sessions = goalProgress(goal(GoalType.sessionsPerWeek, 3),
          matches: const [], trainings: trainings, now: now);
      expect(sessions.current, 2);
      expect(sessions.reached, isFalse);

      final minutes = goalProgress(goal(GoalType.minutesPerWeek, 100),
          matches: const [], trainings: trainings, now: now);
      expect(minutes.current, 105);
      expect(minutes.reached, isTrue);
      expect(minutes.fraction, 1.0);
    });

    test('win rate goal counts matches since creation', () {
      final matches = [
        match(DateTime(2026, 8, 1), [[10, 21], [10, 21]]),
        match(DateTime(2026, 9, 10), [[21, 10], [21, 10]]),
        match(DateTime(2026, 9, 11), [[10, 21], [10, 21]]),
      ];
      final p = goalProgress(goal(GoalType.winRate, 60),
          matches: matches, trainings: const [], now: now);
      expect(p.current, 50);
      final none = goalProgress(
          goal(GoalType.winRate, 60, DateTime(2026, 9, 20)),
          matches: matches,
          trainings: const [],
          now: now);
      expect(none.current, isNull);
      expect(none.fraction, 0);
    });
  });

  test('json file store round trip', () async {
    final dir = await Directory.systemTemp.createTemp('badminton_test');
    addTearDown(() => dir.delete(recursive: true));
    final store = JsonFileStore(directory: dir);

    expect((await store.load()).players, isEmpty);

    final data = AppData(
      players: [Player(id: 'p', name: 'Mette', createdAt: DateTime(2026))],
      matches: [match(DateTime(2026, 9, 1), [[21, 18], [21, 15]])],
      trainings: [training(DateTime(2026, 9, 2), 90, TrainingType.footwork)],
      goals: [
        Goal(
            id: 'g',
            playerId: 'p',
            type: GoalType.winRate,
            target: 60,
            createdAt: DateTime(2026, 9, 1)),
      ],
      activePlayerId: 'p',
    );
    await store.save(data);
    final loaded = await store.load();
    expect(loaded.activePlayerId, 'p');
    expect(loaded.players.single.name, 'Mette');
    expect(loaded.matches.single.games,
        const [GameScore(21, 18), GameScore(21, 15)]);
    expect(loaded.trainings.single.type, TrainingType.footwork);
    expect(loaded.goals.single.type, GoalType.winRate);
  });

  group('practice matches and technique tags', () {
    test('old data without new fields still loads', () {
      final m = MatchRecord.fromJson({
        'id': 'm',
        'playerId': 'p',
        'date': '2026-09-01T00:00:00.000',
        'type': 'single',
        'games': [
          [21, 10],
          [21, 12],
        ],
      });
      expect(m.practice, isFalse);
      final t = TrainingSession.fromJson({
        'id': 't',
        'playerId': 'p',
        'date': '2026-09-01T00:00:00.000',
        'durationMinutes': 60,
        'type': 'technique',
        'intensity': 3,
      });
      expect(t.techniqueIds, isEmpty);
      expect(t.drillIds, isEmpty);
    });

    test('new fields survive a json round trip', () {
      final m = MatchRecord(
        id: 'm',
        playerId: 'p',
        date: DateTime(2026, 9, 1),
        type: MatchType.single,
        opponents: 'Bo',
        games: const [GameScore(15, 10)],
        practice: true,
      );
      expect(MatchRecord.fromJson(m.toJson()).practice, isTrue);
      final t = TrainingSession(
        id: 't',
        playerId: 'p',
        date: DateTime(2026, 9, 1),
        durationMinutes: 60,
        type: TrainingType.technique,
        intensity: 3,
        techniqueIds: const ['clear', 'drop'],
        drillIds: const ['clear_duel'],
      );
      final back = TrainingSession.fromJson(t.toJson());
      expect(back.techniqueIds, ['clear', 'drop']);
      expect(back.drillIds, ['clear_duel']);
    });

    MatchRecord practice(DateTime date, bool won) => MatchRecord(
          id: newId(),
          playerId: 'p',
          date: date,
          type: MatchType.single,
          opponents: 'Bo',
          games: [won ? const GameScore(15, 5) : const GameScore(5, 15)],
          practice: true,
        );

    test('competitiveOnly removes practice matches', () {
      final real = match(DateTime(2026, 9, 1), [
        [21, 10],
        [21, 10],
      ]);
      final all = [real, practice(DateTime(2026, 9, 2), false)];
      expect(competitiveOnly(all), [real]);
    });

    test('win rate goal ignores practice matches', () {
      final goal = Goal(
        id: 'g',
        playerId: 'p',
        type: GoalType.winRate,
        target: 60,
        createdAt: DateTime(2026, 9, 1),
      );
      final matches = [
        match(DateTime(2026, 9, 2), [
          [21, 10],
          [21, 10],
        ]),
        practice(DateTime(2026, 9, 3), false),
        practice(DateTime(2026, 9, 4), false),
      ];
      final p = goalProgress(goal,
          matches: matches, trainings: const [], now: DateTime(2026, 9, 5));
      expect(p.current, 100);
    });

    test('technique usage counts sessions, minutes and last trained', () {
      TrainingSession tagged(DateTime date, int minutes, List<String> ids) =>
          TrainingSession(
            id: newId(),
            playerId: 'p',
            date: date,
            durationMinutes: minutes,
            type: TrainingType.technique,
            intensity: 3,
            techniqueIds: ids,
          );
      final sessions = [
        tagged(DateTime(2026, 6, 1), 60, ['clear']),
        tagged(DateTime(2026, 9, 1), 90, ['clear', 'drop']),
        tagged(DateTime(2026, 9, 10), 30, ['clear', 'clear']),
      ];
      final all = techniqueUsage(sessions);
      expect(all['clear']!.sessions, 3);
      expect(all['clear']!.minutes, 180);
      expect(all['clear']!.lastTrained, DateTime(2026, 9, 10));
      expect(all['drop']!.sessions, 1);
      expect(all.containsKey('smash'), isFalse);

      final recent = techniqueUsage(sessions, since: DateTime(2026, 8, 1));
      expect(recent['clear']!.sessions, 2);
      expect(recent['clear']!.minutes, 120);
      // Sidst trænet gælder uanset periode.
      expect(recent['clear']!.lastTrained, DateTime(2026, 9, 10));
    });
  });

  test('shared preferences store round trip (webudgaven)', () async {
    SharedPreferences.setMockInitialValues({});
    final store = SharedPreferencesStore();
    expect((await store.load()).players, isEmpty);
    await store.save(AppData(
      players: [Player(id: 'p', name: 'Mette', createdAt: DateTime(2026))],
      matches: [match(DateTime(2026, 9, 1), [[15, 10], [15, 12]])],
      activePlayerId: 'p',
    ));
    final loaded = await SharedPreferencesStore().load();
    expect(loaded.players.single.name, 'Mette');
    expect(loaded.matches.single.won, isTrue);
  });

  test('newId gives unique ids', () {
    final ids = {for (var i = 0; i < 1000; i++) newId()};
    expect(ids, hasLength(1000));
  });

  group('AI coach summary', () {
    final now = DateTime(2026, 9, 30);
    final player = Player(id: 'p', name: 'Mette', createdAt: DateTime(2026));

    test('summarises matches, training, techniques and goals', () {
      final practice = MatchRecord(
        id: newId(),
        playerId: 'p',
        date: DateTime(2026, 9, 29),
        type: MatchType.single,
        opponents: 'Træner',
        games: const [GameScore(15, 2), GameScore(15, 3)],
        practice: true,
      );
      final summary = coachPlayerSummary(
        player: player,
        matches: [
          match(DateTime(2026, 9, 20), [[15, 12], [15, 13]], opponents: 'Bo'),
          match(DateTime(2026, 9, 25), [[10, 15], [12, 15]], opponents: 'Ib'),
          practice,
        ],
        trainings: [
          TrainingSession(
            id: newId(),
            playerId: 'p',
            date: DateTime(2026, 9, 28),
            durationMinutes: 60,
            type: TrainingType.footwork,
            intensity: 4,
            techniqueIds: const ['lunge'],
            drillIds: const ['lunge_series'],
          ),
        ],
        goals: [
          Goal(
            id: newId(),
            playerId: 'p',
            type: GoalType.sessionsPerWeek,
            target: 3,
            createdAt: DateTime(2026, 9, 1),
          ),
        ],
        now: now,
      );

      expect(summary, contains('Spiller: Mette'));
      expect(summary, contains('Dato i dag: 2026-09-30'));
      // Træningskampen tæller ikke med i sejrsprocenten.
      expect(summary, contains('2 rigtige kampe og 1 træningskampe'));
      expect(summary, contains('Sejrsprocent i alt: 50 %'));
      expect(summary, contains('Aktuel stime: 1 nederlag'));
      expect(summary, contains('2026-09-25 single mod Ib: tabt 10-15, 12-15'));
      expect(summary, isNot(contains('Træner')));
      expect(summary, contains('fokus: Udfald (lunge), Udfaldsserier'));
      expect(summary, contains('footwork 60'));
      expect(summary, contains('Udfald (lunge) 1'));
      expect(summary, contains('Ikke trænet de seneste 30 dage: Greb'));
      expect(summary, contains('3 træningspas pr. uge: nu 1'));
    });

    test('works for a new player without data', () {
      final summary = coachPlayerSummary(
        player: player,
        matches: const [],
        trainings: const [],
        goals: const [],
        now: now,
      );
      expect(summary, contains('0 rigtige kampe og 0 træningskampe'));
      expect(summary, contains('0 pas og 0 minutter'));
      expect(summary, contains('Der er ikke logget slag eller benarbejde'));
      expect(summary, isNot(contains('Mål:')));
    });
  });

  group('live score (kamptæller)', () {
    LiveMatch play(LiveMatch m, String rallies) {
      for (final c in rallies.split('')) {
        m = m.pointTo(c == 'u' ? Side.us : Side.them);
      }
      return m;
    }

    const start = LiveMatch(
      system: ScoringSystem.to15,
      type: MatchType.single,
      firstServer: Side.us,
    );

    test('a game to 15 ends at 15-0 and the winner serves next', () {
      final m = play(start, 'u' * 15);
      expect(m.games, [const GameScore(15, 0)]);
      expect(m.ourPoints, 0);
      expect(m.server, Side.us);
      expect(m.lastEvent, LiveEvent.gameEnded);
      expect(m.isFinished, isFalse);
    });

    test('14-14 needs two points, and 20-20 is decided by the next point', () {
      var m = play(start, 'ut' * 14); // 14-14
      expect((m.ourPoints, m.theirPoints), (14, 14));
      m = play(m, 'u'); // 15-14: ikke slut
      expect(m.games, isEmpty);
      m = play(m, 'u'); // 16-14
      expect(m.games, [const GameScore(16, 14)]);

      var cap = play(start, 'ut' * 20); // 20-20
      expect(cap.games, isEmpty);
      cap = play(cap, 't');
      expect(cap.games, [const GameScore(20, 21)]);
      expect(cap.server, Side.them);
    });

    test('3x21 is capped at 30', () {
      const m21 = LiveMatch(
        system: ScoringSystem.to21,
        type: MatchType.double,
        firstServer: Side.them,
      );
      final m = play(m21, '${'ut' * 29}u');
      expect(m.games, [const GameScore(30, 29)]);
    });

    test('server and service court follow the rally winner and score', () {
      var m = start;
      expect((m.server, m.serviceCourt), (Side.us, Court.right)); // 0-0
      m = play(m, 'u'); // 1-0
      expect((m.server, m.serviceCourt), (Side.us, Court.left));
      m = play(m, 't'); // 1-1
      expect((m.server, m.serviceCourt), (Side.them, Court.left));
      m = play(m, 't'); // 1-2
      expect((m.server, m.serviceCourt), (Side.them, Court.right));
    });

    test('interval at 8 only once, with change of ends in game 3', () {
      var m = play(start, 'u' * 7);
      expect(m.lastEvent, isNull);
      m = play(m, 'u'); // 8-0
      expect(m.lastEvent, LiveEvent.interval);
      m = play(m, 't'); // 8-1
      expect(m.lastEvent, isNull);
      // Til 8-8 og 9-8: ingen ny pause.
      m = play(m, 't' * 7);
      expect(m.lastEvent, isNull);

      // 1-1 i sæt, så i 3. sæt er der sideskift ved 8.
      var decider = play(start, '${'u' * 15}${'t' * 15}${'t' * 7}');
      expect(decider.games, hasLength(2));
      decider = play(decider, 't');
      expect(decider.lastEvent, LiveEvent.intervalAndChangeEnds);
    });

    test('3x21 has the interval at 11', () {
      const m21 = LiveMatch(
        system: ScoringSystem.to21,
        type: MatchType.single,
        firstServer: Side.us,
      );
      expect(play(m21, 'u' * 8).lastEvent, isNull);
      expect(play(m21, 'u' * 11).lastEvent, LiveEvent.interval);
    });

    test('match ends after two games and ignores further points', () {
      var m = play(start, '${'u' * 15}${'t' * 15}${'u' * 15}');
      expect(m.isFinished, isTrue);
      expect(m.winner, Side.us);
      expect(m.lastEvent, LiveEvent.matchEnded);
      expect(m.gamesForSaving, const [
        GameScore(15, 0),
        GameScore(0, 15),
        GameScore(15, 0),
      ]);
      expect(identical(m.pointTo(Side.them), m), isTrue);

      final lost = play(start, 't' * 30);
      expect(lost.winner, Side.them);
      expect(lost.games, hasLength(2));
    });

    test('undo removes the last point, also across a finished game', () {
      var m = play(start, 'u' * 15);
      expect(m.games, hasLength(1));
      m = m.undo();
      expect(m.games, isEmpty);
      expect((m.ourPoints, m.theirPoints), (14, 0));
      expect(start.undo(), same(start));
      expect(start.canUndo, isFalse);
    });

    test('unfinished game is included when saving early', () {
      final m = play(start, '${'u' * 15}uttuu');
      expect(m.gamesForSaving, const [GameScore(15, 0), GameScore(3, 2)]);
    });

    test('json round trip keeps settings and every rally', () {
      final m = play(
        const LiveMatch(
          system: ScoringSystem.to21,
          type: MatchType.mixed,
          firstServer: Side.them,
        ),
        'uttuu',
      );
      final copy = LiveMatch.fromJson(m.toJson());
      expect(copy.system, ScoringSystem.to21);
      expect(copy.type, MatchType.mixed);
      expect(copy.firstServer, Side.them);
      expect(copy.rallies, m.rallies);
      expect((copy.ourPoints, copy.theirPoints), (3, 2));
    });
  });

  group('AI coach plan from reply', () {
    test('finds app drills in order and sums the listed minutes', () {
      final plan = coachPlanFromReply(
        'Her er et forslag:\n'
        '- Opvarmning (10 min): let løb og Hop og landing\n'
        '- Clear-duel (15 min)\n'
        '- Kamp med kun kort serv (20 min)\n'
        '- Nedvarmning (5 min)\n'
        'I alt 50 minutter.',
      )!;
      expect(plan.drillIds, ['jump_basics', 'clear_duel', 'low_serve_game']);
      expect(plan.minutes, 50);
      expect(plan.techniqueIds, containsAll(['clear', 'serve_short']));
      expect(plan.techniqueIds.toSet(), hasLength(plan.techniqueIds.length));
    });

    test('uses the drills\' own minutes when no times are given', () {
      final plan = coachPlanFromReply('Prøv Clear-duel og Net-duel.')!;
      expect(plan.drillIds, ['clear_duel', 'net_duel']);
      expect(plan.minutes, 10 + 8);
    });

    test('returns null when no drill is mentioned', () {
      expect(coachPlanFromReply('Spil mere på baghånden.'), isNull);
    });
  });

  group('interval timer', () {
    const plan = DrillTimer(workSeconds: 10, restSeconds: 20, rounds: 2);
    TimerState at(double seconds) => timerStateAt(
      plan,
      Duration(milliseconds: (seconds * 1000).round()),
      readySeconds: 5,
    );

    test('ready, work, rest, last work without rest, done', () {
      expect(at(0), const TimerState(TimerPhase.ready, 0, 5));
      expect(at(4.2), const TimerState(TimerPhase.ready, 0, 1));
      expect(at(5), const TimerState(TimerPhase.work, 1, 10));
      expect(at(14.5), const TimerState(TimerPhase.work, 1, 1));
      expect(at(15), const TimerState(TimerPhase.rest, 1, 20));
      expect(at(35), const TimerState(TimerPhase.work, 2, 10));
      // Ingen pause efter sidste runde.
      expect(at(45), const TimerState(TimerPhase.done, 2, 0));
      expect(at(500).phase, TimerPhase.done);
      expect(totalDuration(plan), const Duration(seconds: 40));
    });
  });

  group('drill search and filters', () {
    test('search matches name, purpose and technique names', () {
      expect(filterDrills(query: 'clear-duel').map((d) => d.id),
          contains('clear_duel'));
      // Ord kan stå i vilkårlig rækkefølge, og store/små bogstaver er lige.
      expect(filterDrills(query: 'DUEL clear').map((d) => d.id),
          contains('clear_duel'));
      expect(filterDrills(query: 'findes ikke xyz'), isEmpty);
      expect(filterDrills(), hasLength(drills.length));
    });

    test('group, level and time filters', () {
      expect(filterDrills(group: DrillGroup.solo).every((d) => d.minPlayers == 1),
          isTrue);
      expect(filterDrills(group: DrillGroup.pair).every((d) => d.minPlayers <= 2),
          isTrue);
      expect(filterDrills(group: DrillGroup.group).every((d) => d.minPlayers >= 3),
          isTrue);
      final short = filterDrills(maxMinutes: 10, level: DrillLevel.beginner);
      expect(short, isNotEmpty);
      expect(short.every((d) => d.minutes <= 10 && d.level == DrillLevel.beginner),
          isTrue);
    });

    test('technique search', () {
      expect(techniqueMatches(techniqueById('net_kill')!, 'kill'), isTrue);
      expect(techniqueMatches(techniqueById('net_kill')!, 'smash'), isFalse);
    });
  });

  group('player profile', () {
    test('old player json without level or hand still loads', () {
      final p = Player.fromJson(
          {'id': 'p', 'name': 'Mette', 'createdAt': '2026-01-01T00:00:00.000'});
      expect(p.level, isNull);
      expect(p.leftHanded, isFalse);
      expect(p.toJson().containsKey('level'), isFalse);
    });

    test('level and hand round trip, and unknown level is ignored', () {
      final p = Player(
        id: 'p',
        name: 'Mette',
        createdAt: DateTime(2026),
        level: PlayerLevel.elite,
        leftHanded: true,
      );
      final copy = Player.fromJson(p.toJson());
      expect(copy.level, PlayerLevel.elite);
      expect(copy.leftHanded, isTrue);
      expect(
          Player.fromJson({...p.toJson(), 'level': 'verdensmester'}).level,
          isNull);
      expect(p.copyWith(level: () => null).level, isNull);
    });

    test('AI summary includes level and hand', () {
      final summary = coachPlayerSummary(
        player: Player(
          id: 'p',
          name: 'Mette',
          createdAt: DateTime(2026),
          level: PlayerLevel.beginner,
          leftHanded: true,
        ),
        matches: const [],
        trainings: const [],
        goals: const [],
        now: DateTime(2026, 9, 30),
      );
      expect(summary, contains('Niveau: begynder'));
      expect(summary, contains('Hånd: venstrehåndet'));
    });
  });
}


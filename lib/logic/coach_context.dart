import '../content/technique.dart';
import '../models/models.dart';
import 'goals.dart';
import 'stats.dart';
import 'technique_stats.dart';

String _date(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

String _percent(double? rate) =>
    rate == null ? 'ingen kampe' : '${(rate * 100).round()} %';

const _matchTypes = {
  MatchType.single: 'single',
  MatchType.double: 'double',
  MatchType.mixed: 'mixed',
};

const _trainingTypes = {
  TrainingType.technique: 'teknik',
  TrainingType.physical: 'fysisk',
  TrainingType.matchPlay: 'kamptræning',
  TrainingType.footwork: 'footwork',
  TrainingType.other: 'andet',
};

/// Et kort, tekstbaseret overblik over spillerens data til AI-træneren.
/// Det sendes med hver besked i en samtale, så det holdes kort.
String coachPlayerSummary({
  required Player player,
  required List<MatchRecord> matches,
  required List<TrainingSession> trainings,
  required List<Goal> goals,
  required DateTime now,
}) {
  final b = StringBuffer()
    ..writeln('Spiller: ${player.name}')
    ..writeln('Dato i dag: ${_date(now)}');

  // Kampe
  final competitive = competitiveOnly(matches).toList();
  final practiceCount = matches.length - competitive.length;
  b.writeln();
  b.writeln(
    'Kampe: ${competitive.length} rigtige kampe og $practiceCount '
    'træningskampe logget.',
  );
  if (competitive.isNotEmpty) {
    b.writeln('Sejrsprocent i alt: ${_percent(WinStats.of(competitive).rate)}');
    final byType = winStatsByType(competitive);
    for (final e in byType.entries) {
      if (e.value.played == 0) continue;
      b.writeln(
        '- ${_matchTypes[e.key]}: ${e.value.won} vundet af '
        '${e.value.played} (${_percent(e.value.rate)})',
      );
    }
    final streak = currentStreak(competitive);
    if (streak != null) {
      b.writeln(
        'Aktuel stime: ${streak.length} ${streak.won ? 'sejre' : 'nederlag'} '
        'i træk. Længste sejrsstime: ${longestWinStreak(competitive)}.',
      );
    }
    b.writeln('Seneste kampe (nyeste først):');
    for (final m in newestFirst(competitive).take(10)) {
      final score = m.games.map((g) => '${g.own}-${g.opponent}').join(', ');
      final who = [
        if (m.opponents.trim().isNotEmpty) 'mod ${m.opponents.trim()}',
        if (m.partner.trim().isNotEmpty) 'med ${m.partner.trim()}',
      ].join(' ');
      b.writeln(
        '- ${_date(m.date)} ${_matchTypes[m.type]} $who: '
        '${m.won ? 'vundet' : 'tabt'} $score'
        '${m.notes.trim().isEmpty ? '' : ' (note: ${m.notes.trim()})'}',
      );
    }
  }

  // Træning
  final weeks = weeklyTraining(trainings, weeks: 12, now: now);
  final sessions12 = weeks.fold(0, (sum, w) => sum + w.sessions);
  final minutesByType = <TrainingType, int>{};
  for (final w in weeks) {
    w.minutesByType.forEach((type, minutes) {
      minutesByType[type] = (minutesByType[type] ?? 0) + minutes;
    });
  }
  final minutes12 = minutesByType.values.fold(0, (a, b) => a + b);
  b.writeln();
  b.writeln(
    'Træning de seneste 12 uger: $sessions12 pas og $minutes12 minutter '
    '(i snit ${(minutes12 / 12).round()} minutter pr. uge).',
  );
  if (minutesByType.isNotEmpty) {
    b.writeln(
      'Minutter pr. type: ${[for (final e in minutesByType.entries) '${_trainingTypes[e.key]} ${e.value}'].join(', ')}.',
    );
  }
  b.writeln(
    'Minutter pr. uge, ældste først: '
    '${weeks.map((w) => w.totalMinutes).join(', ')}.',
  );
  final recent = [...trainings]..sort((a, b) => b.date.compareTo(a.date));
  if (recent.isNotEmpty) {
    b.writeln('Seneste træningspas (nyeste først):');
    for (final t in recent.take(5)) {
      final focus = [
        for (final id in t.techniqueIds) ?techniqueById(id)?.name,
        for (final id in t.drillIds) ?drillById(id)?.name,
      ];
      b.writeln(
        '- ${_date(t.date)} ${_trainingTypes[t.type]}, '
        '${t.durationMinutes} min, intensitet ${t.intensity}/5'
        '${focus.isEmpty ? '' : ', fokus: ${focus.join(', ')}'}'
        '${t.notes.trim().isEmpty ? '' : ' (note: ${t.notes.trim()})'}',
      );
    }
  }

  // Slag og benarbejde
  final usage = techniqueUsage(trainings, since: addDays(now, -7 * 12));
  final trained = [
    for (final t in techniques)
      if ((usage[t.id]?.sessions ?? 0) > 0) (t.name, usage[t.id]!.sessions),
  ]..sort((a, b) => b.$2.compareTo(a.$2));
  final staleBefore = addDays(now, -30);
  final stale = [
    for (final t in techniques)
      if (usage[t.id]?.lastTrained?.isBefore(staleBefore) ?? true) t.name,
  ];
  b.writeln();
  b.writeln(
    trained.isEmpty
        ? 'Der er ikke logget slag eller benarbejde i træningen endnu.'
        : 'Mest trænede slag og benarbejde (antal pas, 12 uger): '
              '${trained.take(8).map((e) => '${e.$1} ${e.$2}').join(', ')}.',
  );
  if (trained.isNotEmpty) {
    b.writeln('Ikke trænet de seneste 30 dage: ${stale.join(', ')}.');
  }

  // Mål
  if (goals.isNotEmpty) {
    b.writeln();
    b.writeln('Mål:');
    for (final g in goals) {
      final p = goalProgress(
        g,
        matches: matches,
        trainings: trainings,
        now: now,
      );
      final what = switch (g.type) {
        GoalType.sessionsPerWeek => '${g.target} træningspas pr. uge',
        GoalType.minutesPerWeek => '${g.target} træningsminutter pr. uge',
        GoalType.winRate => '${g.target} % sejre',
      };
      b.writeln(
        '- $what: nu ${p.current ?? 'ingen data'}'
        '${p.reached ? ' (nået)' : ''}',
      );
    }
  }
  return b.toString().trimRight();
}

/// Et træningspas fundet i et svar fra AI-træneren.
class CoachPlan {
  const CoachPlan({
    required this.drillIds,
    required this.techniqueIds,
    required this.minutes,
  });

  final List<String> drillIds;
  final List<String> techniqueIds;
  final int minutes;
}

final _minutesPattern = RegExp(r'(\d{1,3})\s*min', caseSensitive: false);

/// Finder appens øvelser i et svar fra AI-træneren, så passet kan logges med
/// ét tryk. Returnerer null, hvis svaret ikke nævner nogen øvelse.
///
/// Tiden er summen af minuttal i svarets listepunkter (fx "- Clear-duel
/// (10 min)"). Står der ingen tider, bruges øvelsernes standardtid.
CoachPlan? coachPlanFromReply(String reply) {
  final text = reply.toLowerCase();
  // Længste navne først, så et kort navn ikke tæller i et længere.
  final byLength = [...drills]
    ..sort((a, b) => b.name.length.compareTo(a.name.length));
  var remaining = text;
  final found = <Drill>[];
  for (final d in byLength) {
    final name = d.name.toLowerCase();
    if (remaining.contains(name)) {
      found.add(d);
      remaining = remaining.replaceAll(name, ' ');
    }
  }
  if (found.isEmpty) return null;
  // Rækkefølgen som i svaret.
  found.sort(
    (a, b) => text
        .indexOf(a.name.toLowerCase())
        .compareTo(text.indexOf(b.name.toLowerCase())),
  );

  var minutes = 0;
  for (final line in reply.split('\n')) {
    if (!line.trimLeft().startsWith('-')) continue;
    final match = _minutesPattern.firstMatch(line);
    if (match != null) minutes += int.parse(match.group(1)!);
  }
  if (minutes == 0 || minutes > 300) {
    minutes = found.fold(0, (sum, d) => sum + d.minutes);
  }

  return CoachPlan(
    drillIds: [for (final d in found) d.id],
    techniqueIds: {for (final d in found) ...d.techniqueIds}.toList(),
    minutes: minutes,
  );
}

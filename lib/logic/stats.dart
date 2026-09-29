import '../models/models.dart';

/// Mandag kl. 00:00 i den uge [date] ligger i (dansk ugestart).
DateTime startOfWeek(DateTime date) =>
    addDays(date, -(date.weekday - DateTime.monday));

/// Lægger [days] kalenderdage til. Bruger DateTime-konstruktøren i stedet for
/// Duration, så skift til/fra sommertid ikke flytter datoen.
DateTime addDays(DateTime date, int days) =>
    DateTime(date.year, date.month, date.day + days);

class WinStats {
  const WinStats(this.played, this.won);

  final int played;
  final int won;

  int get lost => played - won;

  /// Sejrsprocent mellem 0 og 1, eller null hvis ingen kampe er spillet.
  double? get rate => played == 0 ? null : won / played;

  static WinStats of(Iterable<MatchRecord> matches) {
    var played = 0, won = 0;
    for (final m in matches) {
      played++;
      if (m.won) won++;
    }
    return WinStats(played, won);
  }
}

class OpponentStats {
  const OpponentStats(this.name, this.stats);

  final String name;
  final WinStats stats;
}

class Streak {
  const Streak(this.won, this.length);

  final bool won;
  final int length;
}

class WeekTraining {
  WeekTraining(this.weekStart);

  final DateTime weekStart;
  final Map<TrainingType, int> minutesByType = {};
  int sessions = 0;

  int get totalMinutes => minutesByType.values.fold(0, (a, b) => a + b);
}

/// Kampe sorteret med den nyeste først.
List<MatchRecord> newestFirst(Iterable<MatchRecord> matches) =>
    matches.toList()..sort((a, b) => b.date.compareTo(a.date));

Map<MatchType, WinStats> winStatsByType(Iterable<MatchRecord> matches) => {
      for (final type in MatchType.values)
        type: WinStats.of(matches.where((m) => m.type == type)),
    };

/// Statistik pr. modstander, sorteret efter flest spillede kampe.
/// Navne sammenlignes uden hensyn til store/små bogstaver og mellemrum.
List<OpponentStats> headToHead(Iterable<MatchRecord> matches) {
  final groups = <String, List<MatchRecord>>{};
  final names = <String, String>{};
  for (final m in newestFirst(matches)) {
    final name = m.opponents.trim();
    if (name.isEmpty) continue;
    final key = name.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    names.putIfAbsent(key, () => name);
    groups.putIfAbsent(key, () => []).add(m);
  }
  final result = [
    for (final e in groups.entries)
      OpponentStats(names[e.key]!, WinStats.of(e.value)),
  ];
  result.sort((a, b) {
    final byPlayed = b.stats.played.compareTo(a.stats.played);
    return byPlayed != 0 ? byPlayed : a.name.compareTo(b.name);
  });
  return result;
}

/// Resultaterne af de seneste [count] kampe, nyeste først (true = sejr).
List<bool> recentForm(Iterable<MatchRecord> matches, {int count = 10}) =>
    newestFirst(matches).take(count).map((m) => m.won).toList();

/// Den nuværende stime regnet fra den seneste kamp, eller null uden kampe.
Streak? currentStreak(Iterable<MatchRecord> matches) {
  final sorted = newestFirst(matches);
  if (sorted.isEmpty) return null;
  final won = sorted.first.won;
  final length = sorted.takeWhile((m) => m.won == won).length;
  return Streak(won, length);
}

int longestWinStreak(Iterable<MatchRecord> matches) {
  var best = 0, current = 0;
  for (final m in newestFirst(matches).reversed) {
    current = m.won ? current + 1 : 0;
    if (current > best) best = current;
  }
  return best;
}

/// Pointforskel pr. kamp i kronologisk rækkefølge (ældste først).
List<int> pointDiffSeries(Iterable<MatchRecord> matches, {int? last}) {
  final chronological = newestFirst(matches).reversed.toList();
  final start = last == null || chronological.length <= last
      ? 0
      : chronological.length - last;
  return chronological.sublist(start).map((m) => m.pointDiff).toList();
}

/// Træning grupperet pr. uge for de seneste [weeks] uger inkl. denne uge.
/// Ældste uge først.
List<WeekTraining> weeklyTraining(
  Iterable<TrainingSession> sessions, {
  int weeks = 12,
  required DateTime now,
}) {
  final thisWeek = startOfWeek(now);
  final buckets = [
    for (var i = weeks - 1; i >= 0; i--)
      WeekTraining(addDays(thisWeek, -7 * i)),
  ];
  final first = buckets.first.weekStart;
  final end = addDays(thisWeek, 7);
  for (final s in sessions) {
    if (s.date.isBefore(first) || !s.date.isBefore(end)) continue;
    final week = startOfWeek(s.date);
    final bucket = buckets.firstWhere((b) => b.weekStart == week);
    bucket.sessions++;
    bucket.minutesByType[s.type] =
        (bucket.minutesByType[s.type] ?? 0) + s.durationMinutes;
  }
  return buckets;
}

/// Træningsminutter i alt inden for de seneste [days] dage.
int trainingMinutesSince(
  Iterable<TrainingSession> sessions, {
  required int days,
  required DateTime now,
}) {
  final today = DateTime(now.year, now.month, now.day);
  final from = addDays(today, -(days - 1));
  return sessions
      .where((s) => !s.date.isBefore(from))
      .fold(0, (sum, s) => sum + s.durationMinutes);
}

/// ISO-8601 ugenummer (som bruges i Danmark).
int isoWeekNumber(DateTime date) {
  // Ugen hører til det år, dens torsdag ligger i.
  final thursday =
      DateTime.utc(date.year, date.month, date.day + 4 - date.weekday);
  final jan1 = DateTime.utc(thursday.year, 1, 1);
  return thursday.difference(jan1).inDays ~/ 7 + 1;
}

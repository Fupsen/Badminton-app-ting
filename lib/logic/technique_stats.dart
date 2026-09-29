import '../models/models.dart';

class TechniqueUsage {
  int sessions = 0;
  int minutes = 0;
  DateTime? lastTrained;
}

/// Hvor meget hvert slag/benarbejde er trænet, opgjort pr. teknik-id.
/// Med [since] tælles antal pas og minutter kun fra den dato, men
/// [TechniqueUsage.lastTrained] er altid den seneste dato uanset periode.
/// Hele passets varighed tælles med for hver teknik, der er trænet i passet.
Map<String, TechniqueUsage> techniqueUsage(
  Iterable<TrainingSession> sessions, {
  DateTime? since,
}) {
  final usage = <String, TechniqueUsage>{};
  for (final s in sessions) {
    for (final id in s.techniqueIds.toSet()) {
      final u = usage.putIfAbsent(id, TechniqueUsage.new);
      if (u.lastTrained == null || s.date.isAfter(u.lastTrained!)) {
        u.lastTrained = s.date;
      }
      if (since == null || !s.date.isBefore(since)) {
        u.sessions++;
        u.minutes += s.durationMinutes;
      }
    }
  }
  return usage;
}

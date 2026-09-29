import '../models/models.dart';
import 'stats.dart';

class GoalProgress {
  const GoalProgress({required this.current, required this.target});

  /// Nuværende værdi, eller null hvis der endnu ikke er data (fx ingen kampe
  /// ved et sejrsprocent-mål).
  final int? current;
  final int target;

  /// Fremskridt mellem 0 og 1.
  double get fraction {
    if (current == null || target <= 0) return 0;
    return (current! / target).clamp(0.0, 1.0);
  }

  bool get reached => current != null && current! >= target;
}

GoalProgress goalProgress(
  Goal goal, {
  required Iterable<MatchRecord> matches,
  required Iterable<TrainingSession> trainings,
  required DateTime now,
}) {
  final weekStart = startOfWeek(now);
  final weekEnd = addDays(weekStart, 7);
  bool inThisWeek(DateTime d) => !d.isBefore(weekStart) && d.isBefore(weekEnd);

  switch (goal.type) {
    case GoalType.sessionsPerWeek:
      final count = trainings.where((t) => inThisWeek(t.date)).length;
      return GoalProgress(current: count, target: goal.target);
    case GoalType.minutesPerWeek:
      final minutes = trainings
          .where((t) => inThisWeek(t.date))
          .fold(0, (sum, t) => sum + t.durationMinutes);
      return GoalProgress(current: minutes, target: goal.target);
    case GoalType.winRate:
      final since = DateTime(
          goal.createdAt.year, goal.createdAt.month, goal.createdAt.day);
      final rate =
          WinStats.of(matches.where((m) => !m.date.isBefore(since))).rate;
      return GoalProgress(
        current: rate == null ? null : (rate * 100).round(),
        target: goal.target,
      );
  }
}

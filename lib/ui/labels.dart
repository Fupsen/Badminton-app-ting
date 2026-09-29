import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/models.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String formatDate(DateTime date) =>
      DateFormat.yMMMd(l10n.localeName).format(date);

  String formatShortDate(DateTime date) =>
      DateFormat.MMMd(l10n.localeName).format(date);
}

extension MatchTypeLabel on MatchType {
  String label(AppLocalizations l) => switch (this) {
        MatchType.single => l.matchTypeSingle,
        MatchType.double => l.matchTypeDouble,
        MatchType.mixed => l.matchTypeMixed,
      };
}

extension TrainingTypeLabel on TrainingType {
  String label(AppLocalizations l) => switch (this) {
        TrainingType.technique => l.trainingTypeTechnique,
        TrainingType.physical => l.trainingTypePhysical,
        TrainingType.matchPlay => l.trainingTypeMatchPlay,
        TrainingType.footwork => l.trainingTypeFootwork,
        TrainingType.other => l.trainingTypeOther,
      };

  IconData get icon => switch (this) {
        TrainingType.technique => Icons.sports_tennis,
        TrainingType.physical => Icons.fitness_center,
        TrainingType.matchPlay => Icons.sports_score,
        TrainingType.footwork => Icons.directions_run,
        TrainingType.other => Icons.more_horiz,
      };

  /// Fast farve pr. type, så graf og liste matcher hinanden.
  Color get color => switch (this) {
        TrainingType.technique => const Color(0xFF2A78D6),
        TrainingType.physical => const Color(0xFFE0782A),
        TrainingType.matchPlay => const Color(0xFF3A9D5D),
        TrainingType.footwork => const Color(0xFF8E5BD0),
        TrainingType.other => const Color(0xFF8A8F98),
      };
}

extension GoalTypeLabel on GoalType {
  String label(AppLocalizations l) => switch (this) {
        GoalType.sessionsPerWeek => l.goalTypeSessionsPerWeek,
        GoalType.minutesPerWeek => l.goalTypeMinutesPerWeek,
        GoalType.winRate => l.goalTypeWinRate,
      };

  IconData get icon => switch (this) {
        GoalType.sessionsPerWeek => Icons.event_repeat,
        GoalType.minutesPerWeek => Icons.timer_outlined,
        GoalType.winRate => Icons.emoji_events_outlined,
      };
}

String intensityLabel(AppLocalizations l, int value) => switch (value) {
      1 => l.intensity1,
      2 => l.intensity2,
      3 => l.intensity3,
      4 => l.intensity4,
      _ => l.intensity5,
    };

String formatScore(List<GameScore> games) =>
    games.map((g) => '${g.own}-${g.opponent}').join(', ');

/// Viser en bekræftelsesdialog for sletning. Returnerer true ved "Slet"
/// (eller [confirmLabel], hvis angivet).
Future<bool> confirmDelete(BuildContext context, String title,
    {String? body, String? confirmLabel}) async {
  final l = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: body == null ? null : Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel ?? l.delete),
        ),
      ],
    ),
  );
  return result ?? false;
}

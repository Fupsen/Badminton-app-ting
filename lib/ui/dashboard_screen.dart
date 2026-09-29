import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/stats.dart';
import '../state/app_state.dart';
import 'goals_screen.dart';
import 'labels.dart';
import 'matches_screen.dart';
import 'training_screen.dart';
import 'widgets/common.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.onNavigate});

  /// Skifter til en anden fane (index i hovednavigationen).
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final matches = state.activeMatches;
    final trainings = state.activeTrainings;
    final goals = state.activeGoals;
    final l = context.l10n;
    final theme = Theme.of(context);
    final overall = WinStats.of(matches);
    final streak = currentStreak(matches);
    final minutes7d =
        trainingMinutesSince(trainings, days: 7, now: DateTime.now());

    return ContentWidth(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () => openMatchForm(context),
                  icon: const Icon(Icons.sports_tennis),
                  label: Text(l.logMatch),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => openTrainingForm(context),
                  icon: const Icon(Icons.fitness_center),
                  label: Text(l.logTraining),
                ),
              ],
            ),
          ),
          ResponsiveGrid(
            children: [
              StatTile(
                icon: Icons.emoji_events_outlined,
                label: l.statWinRate,
                value: percent(overall.rate, l.noData),
                detail: l.statsWonLost(overall.won, overall.lost),
              ),
              StatTile(
                icon: Icons.sports_tennis,
                label: l.statMatchesPlayed,
                value: '${overall.played}',
              ),
              StatTile(
                icon: Icons.timer_outlined,
                label: l.statTraining7d,
                value: l.minutesShort(minutes7d),
              ),
              StatTile(
                icon: Icons.local_fire_department_outlined,
                label: l.statCurrentStreak,
                value: streak == null
                    ? l.noData
                    : streak.won
                        ? l.streakWins(streak.length)
                        : l.streakLosses(streak.length),
              ),
            ],
          ),
          if (matches.isNotEmpty)
            SectionCard(
              title: l.recentForm,
              subtitle: l.recentFormHint,
              child: FormRow(results: recentForm(matches)),
            ),
          if (goals.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(l.yourGoals, style: theme.textTheme.titleMedium),
                  ),
                  TextButton(
                    onPressed: () => onNavigate(3),
                    child: Text(l.navGoals),
                  ),
                ],
              ),
            ),
            for (final g in goals) GoalCard(goal: g, compact: true),
          ],
        ],
      ),
    );
  }
}

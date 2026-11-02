import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/live_match_store.dart';
import '../logic/live_score.dart';
import '../logic/stats.dart';
import '../state/app_state.dart';
import 'backup_screen.dart';
import 'goals_screen.dart';
import 'labels.dart';
import 'live_score_screen.dart';
import 'matches_screen.dart';
import 'plans_screen.dart';
import 'training_screen.dart';
import 'widgets/common.dart';

/// Påmindelse om backup efter så mange dage. På iPhone (webudgaven) kan
/// Safari slette data, så der mindes der oftere.
const backupReminderDays = kIsWeb ? 14 : 30;

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    // Træningskampe tæller ikke med i nøgletal og form.
    final matches = competitiveOnly(state.activeMatches).toList();
    final trainings = state.activeTrainings;
    final goals = state.activeGoals;
    final l = context.l10n;
    final theme = Theme.of(context);
    final overall = WinStats.of(matches);
    final streak = currentStreak(matches);
    final minutes7d = trainingMinutesSince(
      trainings,
      days: 7,
      now: DateTime.now(),
    );

    return ContentWidth(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (state.needsBackupReminder(
            DateTime.now(),
            days: backupReminderDays,
          ))
            BackupReminderCard(neverBackedUp: state.lastBackupAt == null),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (state.activePlayer case final player?)
                  _LiveScoreShortcut(
                    key: ValueKey(player.id),
                    playerId: player.id,
                  ),
                if (trainings.isNotEmpty)
                  ActionChip(
                    avatar: const Icon(Icons.replay),
                    label: Text(l.shortcutRepeatTraining),
                    onPressed: () => openTrainingForm(
                      context,
                      prefill: TrainingPrefill.fromSession(trainings.first),
                    ),
                  ),
                if (state.plans.isNotEmpty)
                  ActionChip(
                    avatar: const Icon(Icons.list_alt),
                    label: Text(l.shortcutPlans),
                    onPressed: () => openPlans(context),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(l.yourGoals, style: theme.textTheme.titleMedium),
                ),
                TextButton.icon(
                  onPressed: () => openGoalForm(context),
                  icon: const Icon(Icons.add),
                  label: Text(l.newGoal),
                ),
              ],
            ),
          ),
          if (goals.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
              child: Text(
                l.noGoalsDashboard,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          for (final g in goals) GoalCard(goal: g, compact: true),
        ],
      ),
    );
  }
}

/// Påmindelse om at tage backup, vist øverst på oversigten.
class BackupReminderCard extends StatelessWidget {
  const BackupReminderCard({super.key, required this.neverBackedUp});

  final bool neverBackedUp;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Row(
          children: [
            Icon(Icons.backup_outlined, color: colors.onTertiaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                neverBackedUp
                    ? l.backupReminderNever
                    : l.backupReminderOld(backupReminderDays),
                style: TextStyle(color: colors.onTertiaryContainer),
              ),
            ),
            TextButton(
              onPressed: () => openBackupScreen(context),
              child: Text(l.backupReminderAction),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Kamptæller", eller "Fortsæt kampen 8-5", når en kamp er i gang.
class _LiveScoreShortcut extends StatefulWidget {
  const _LiveScoreShortcut({super.key, required this.playerId});

  final String playerId;

  @override
  State<_LiveScoreShortcut> createState() => _LiveScoreShortcutState();
}

class _LiveScoreShortcutState extends State<_LiveScoreShortcut> {
  LiveMatch? _match;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final match = await const LiveMatchStore().load(widget.playerId);
    if (mounted) setState(() => _match = match);
  }

  Future<void> _open() async {
    await openLiveScore(context);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final match = _match;
    if (match == null || match.rallies.isEmpty) {
      return ActionChip(
        avatar: const Icon(Icons.scoreboard_outlined),
        label: Text(l.shortcutLiveScore),
        onPressed: _open,
      );
    }
    // Mellem to sæt står det nye sæt i 0-0, så vis det seneste sæt.
    final games = match.games;
    final betweenGames =
        match.ourPoints == 0 && match.theirPoints == 0 && games.isNotEmpty;
    final (us, them) = betweenGames
        ? (games.last.own, games.last.opponent)
        : (match.ourPoints, match.theirPoints);
    return ActionChip(
      avatar: const Icon(Icons.play_arrow),
      label: Text(l.shortcutContinueMatch(us, them)),
      onPressed: _open,
    );
  }
}

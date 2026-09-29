import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../logic/goals.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import 'labels.dart';
import 'widgets/common.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goals = context.watch<AppState>().activeGoals;
    if (goals.isEmpty) {
      return EmptyState(icon: Icons.flag, message: context.l10n.noGoals);
    }
    return ContentWidth(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
        children: [for (final g in goals) GoalCard(goal: g)],
      ),
    );
  }
}

/// Kort der viser et mål og hvor langt spilleren er nået.
class GoalCard extends StatelessWidget {
  const GoalCard({super.key, required this.goal, this.compact = false});

  final Goal goal;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final state = context.watch<AppState>();
    final progress = goalProgress(
      goal,
      matches: state.matchesFor(goal.playerId),
      trainings: state.trainingsFor(goal.playerId),
      now: DateTime.now(),
    );
    final since = context.formatShortDate(goal.createdAt);
    final title = switch (goal.type) {
      GoalType.sessionsPerWeek => l.goalTargetSessions(goal.target),
      GoalType.minutesPerWeek => l.goalTargetMinutes(goal.target),
      GoalType.winRate => l.goalTargetWinRate(goal.target),
    };
    final status = switch (goal.type) {
      GoalType.sessionsPerWeek =>
        l.goalProgressSessions(progress.current!, goal.target),
      GoalType.minutesPerWeek =>
        l.goalProgressMinutes(progress.current!, goal.target),
      GoalType.winRate => progress.current == null
          ? l.goalNoMatchesYet(goal.target, since)
          : l.goalProgressWinRate(progress.current!, goal.target, since),
    };
    final color =
        progress.reached ? ResultBadge.winColor : theme.colorScheme.primary;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => openGoalForm(context, existing: goal),
        child: Padding(
          padding: EdgeInsets.all(compact ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(goal.type.icon, color: color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(title, style: theme.textTheme.titleMedium),
                  ),
                  if (progress.reached)
                    Chip(
                      label: Text(l.goalReached),
                      avatar: const Icon(Icons.check, size: 16),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress.fraction,
                color: color,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(status, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> openGoalForm(BuildContext context, {Goal? existing}) =>
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => GoalForm(existing: existing),
    ));

class GoalForm extends StatefulWidget {
  const GoalForm({super.key, this.existing});

  final Goal? existing;

  @override
  State<GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  static const _defaults = {
    GoalType.sessionsPerWeek: 3,
    GoalType.minutesPerWeek: 180,
    GoalType.winRate: 60,
  };

  final _formKey = GlobalKey<FormState>();
  late GoalType _type;
  late final TextEditingController _target;

  @override
  void initState() {
    super.initState();
    _type = widget.existing?.type ?? GoalType.sessionsPerWeek;
    _target = TextEditingController(
        text: (widget.existing?.target ?? _defaults[_type]).toString());
  }

  @override
  void dispose() {
    _target.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final state = context.read<AppState>();
    if (!_formKey.currentState!.validate()) return;
    final existing = widget.existing;
    await state.saveGoal(Goal(
      id: existing?.id ?? newId(),
      playerId: existing?.playerId ?? state.activePlayer!.id,
      type: _type,
      target: int.parse(_target.text),
      createdAt: existing?.createdAt ?? DateTime.now(),
    ));
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final state = context.read<AppState>();
    if (await confirmDelete(context, context.l10n.deleteGoalTitle)) {
      await state.deleteGoal(widget.existing!.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? l.newGoal : l.editGoal),
        actions: [
          if (widget.existing != null)
            IconButton(
              tooltip: l.delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
          TextButton(onPressed: _save, child: Text(l.save)),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ContentWidth(
          maxWidth: 600,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DropdownButtonFormField<GoalType>(
                initialValue: _type,
                decoration: InputDecoration(
                  labelText: l.goalTypeLabel,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  for (final t in GoalType.values)
                    DropdownMenuItem(value: t, child: Text(t.label(l))),
                ],
                onChanged: (t) {
                  if (t == null) return;
                  setState(() {
                    _type = t;
                    _target.text = _defaults[t].toString();
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _target,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: InputDecoration(
                  labelText: l.goalTargetLabel,
                  suffixText: switch (_type) {
                    GoalType.sessionsPerWeek => null,
                    GoalType.minutesPerWeek => 'min',
                    GoalType.winRate => '%',
                  },
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n <= 0) return l.invalidNumber;
                  if (_type == GoalType.winRate && n > 100) {
                    return l.goalWinRateRange;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

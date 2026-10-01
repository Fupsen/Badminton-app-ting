import 'package:flutter/material.dart';

import '../content/technique.dart';
import '../models/models.dart';
import 'labels.dart';
import 'technique_screen.dart';
import 'training_screen.dart';
import 'widgets/interval_timer_panel.dart';
import 'widgets/keep_screen_on.dart';

Future<void> openPlanRun(BuildContext context, TrainingPlan plan) =>
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PlanRunScreen(plan: plan)));

/// Kører en plan én øvelse ad gangen. Øvelser med intervaller bruger deres
/// egen timer, de andre en nedtælling af de planlagte minutter. Timeren er
/// en hjælp: "Næste øvelse" kan trykkes når som helst, og "Spring over"
/// tæller ikke øvelsen med, når passet logges.
class PlanRunScreen extends StatefulWidget {
  const PlanRunScreen({super.key, required this.plan});

  final TrainingPlan plan;

  @override
  State<PlanRunScreen> createState() => _PlanRunScreenState();
}

class _PlanRunScreenState extends State<PlanRunScreen> {
  late final List<(PlanItem, Drill)> _steps = [
    for (final item in widget.plan.items)
      if (drillById(item.drillId) case final drill?) (item, drill),
  ];
  final _done = <PlanItem>[];
  var _index = 0;

  bool get _finished => _index >= _steps.length;

  void _next({required bool completed}) {
    setState(() {
      if (completed) _done.add(_steps[_index].$1);
      _index++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeepScreenOn(child: _finished ? _summary(context) : _step(context));
  }

  Widget _step(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final (item, drill) = _steps[_index];
    final timer =
        drill.timer ??
        DrillTimer(workSeconds: item.minutes * 60, restSeconds: 0, rounds: 1);
    final last = _index == _steps.length - 1;
    final nextLabel = last ? l.planFinish : l.planNext;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(l.planStep(_index + 1, _steps.length)),
        actions: [
          IconButton(
            tooltip: l.planShowDrill,
            icon: const Icon(Icons.info_outline),
            onPressed: () => openDrill(context, drill),
          ),
          TextButton(
            onPressed: () => _next(completed: false),
            child: Text(l.planSkip),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IntervalTimerPanel(
        key: ValueKey(_index),
        plan: timer,
        autoStart: false,
        header: Column(
          children: [
            Text(
              drill.name,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              drill.timer == null
                  ? l.minutesShort(item.minutes)
                  : l.timerPlan(
                      timer.workSeconds,
                      timer.restSeconds,
                      timer.rounds,
                    ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        footer: TextButton(
          onPressed: () => _next(completed: true),
          child: Text(nextLabel),
        ),
        done: FilledButton.icon(
          icon: Icon(last ? Icons.flag : Icons.skip_next),
          label: Text(nextLabel),
          onPressed: () => _next(completed: true),
        ),
      ),
    );
  }

  Widget _summary(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final minutes = _done.fold(0, (sum, i) => sum + i.minutes);
    return Scaffold(
      appBar: AppBar(title: Text(widget.plan.name)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.flag, size: 64, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(l.planFinished, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                _done.isEmpty
                    ? l.planNothingDone
                    : l.planFinishedSummary(
                        _done.length,
                        _steps.length,
                        minutes,
                      ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.fitness_center),
                label: Text(l.planLog),
                onPressed: _done.isEmpty
                    ? null
                    : () => openTrainingForm(
                        context,
                        prefill: TrainingPrefill.forPlan(widget.plan, _done),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../content/technique.dart';
import '../logic/interval_timer.dart';
import 'labels.dart';
import 'training_screen.dart';
import 'widgets/keep_screen_on.dart';

Future<void> openTimer(BuildContext context, Drill drill) =>
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => TimerScreen(drill: drill)));

/// Intervaltimer til en øvelse: arbejde, pause og runder. Skærmen holdes
/// tændt, og der vibreres og lyder et klik, når fasen skifter.
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key, required this.drill});

  final Drill drill;

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final _stopwatch = Stopwatch();
  Timer? _ticker;
  TimerPhase? _lastPhase;

  DrillTimer get _plan => widget.drill.timer!;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _stopwatch.start();
    _ticker ??= Timer.periodic(
      const Duration(milliseconds: 200),
      (_) => _tick(),
    );
  }

  void _tick() {
    final state = timerStateAt(_plan, _stopwatch.elapsed);
    if (state.phase != _lastPhase) {
      if (_lastPhase != null) {
        HapticFeedback.heavyImpact();
        SystemSound.play(SystemSoundType.click);
      }
      _lastPhase = state.phase;
    }
    if (state.phase == TimerPhase.done) {
      _stopwatch.stop();
      _ticker?.cancel();
      _ticker = null;
    }
    setState(() {});
  }

  void _toggle() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
      } else {
        _start();
      }
    });
  }

  void _restart() {
    _stopwatch
      ..reset()
      ..start();
    _lastPhase = null;
    _start();
    setState(() {});
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final state = timerStateAt(_plan, _stopwatch.elapsed);
    final (label, background, foreground) = switch (state.phase) {
      TimerPhase.ready => (
        l.timerReady,
        scheme.surfaceContainerHighest,
        scheme.onSurface,
      ),
      TimerPhase.work => (
        l.timerWork,
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      TimerPhase.rest => (
        l.timerRest,
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
      TimerPhase.done => (
        l.timerDone,
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
    };
    final done = state.phase == TimerPhase.done;

    return KeepScreenOn(
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          title: Text(widget.drill.name),
          actions: [
            IconButton(
              tooltip: l.timerRestartTooltip,
              icon: const Icon(Icons.replay),
              onPressed: _restart,
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              // Fylder hele bredden, så alt står midt på skærmen.
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.timerPlan(
                    _plan.workSeconds,
                    _plan.restSeconds,
                    _plan.rounds,
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: foreground),
                ),
                const Spacer(),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!done)
                  Expanded(
                    flex: 4,
                    child: FittedBox(
                      child: Text(
                        '${state.secondsLeft}',
                        style: TextStyle(
                          fontSize: 200,
                          fontWeight: FontWeight.bold,
                          color: foreground,
                        ),
                      ),
                    ),
                  ),
                if (state.round > 0)
                  Text(
                    l.timerRound(state.round, _plan.rounds),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(color: foreground),
                  ),
                const Spacer(),
                if (done)
                  FilledButton.icon(
                    icon: const Icon(Icons.fitness_center),
                    label: Text(l.timerLogDrill),
                    onPressed: () => openTrainingForm(
                      context,
                      prefill: TrainingPrefill.forDrill(widget.drill),
                    ),
                  )
                else
                  Center(
                    child: IconButton.filled(
                      iconSize: 48,
                      tooltip: _stopwatch.isRunning
                          ? l.timerPauseTooltip
                          : l.timerResumeTooltip,
                      icon: Icon(
                        _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: _toggle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

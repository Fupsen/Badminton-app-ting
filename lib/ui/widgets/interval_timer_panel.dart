import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../content/technique.dart';
import '../../logic/interval_timer.dart';
import '../labels.dart';

/// Stor nedtælling med arbejde, pause og runder. Farven skifter med fasen,
/// og der vibreres og lyder et klik, når fasen skifter. Panelet fylder hele
/// den plads, det får, og tegner også bag en gennemsigtig app-bar.
///
/// Start forfra ved at give panelet en ny `key`.
class IntervalTimerPanel extends StatefulWidget {
  const IntervalTimerPanel({
    super.key,
    required this.plan,
    this.header,
    this.done,
    this.footer,
    this.autoStart = true,
  });

  final DrillTimer plan;

  /// Vises øverst, fx øvelsens navn eller planens tider.
  final Widget? header;

  /// Vises i stedet for pause-knappen, når timeren er færdig.
  final Widget? done;

  /// Vises under pause-knappen, mens timeren ikke er færdig.
  final Widget? footer;

  /// Hvis false, venter timeren på et tryk på start.
  final bool autoStart;

  @override
  State<IntervalTimerPanel> createState() => _IntervalTimerPanelState();
}

class _IntervalTimerPanelState extends State<IntervalTimerPanel> {
  final _stopwatch = Stopwatch();
  Timer? _ticker;
  TimerPhase? _lastPhase;

  @override
  void initState() {
    super.initState();
    if (widget.autoStart) _start();
  }

  void _start() {
    _stopwatch.start();
    _ticker ??= Timer.periodic(
      const Duration(milliseconds: 200),
      (_) => _tick(),
    );
  }

  void _tick() {
    final state = timerStateAt(widget.plan, _stopwatch.elapsed);
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

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final plan = widget.plan;
    final state = timerStateAt(plan, _stopwatch.elapsed);
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
    final started = _stopwatch.elapsed > Duration.zero;

    return ColoredBox(
      color: background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: foreground),
            textAlign: TextAlign.center,
            child: Column(
              // Fylder hele bredden, så alt står midt på skærmen.
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ?widget.header,
                const Spacer(),
                Text(
                  label,
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
                        formatClock(state.secondsLeft),
                        style: TextStyle(
                          fontSize: 200,
                          fontWeight: FontWeight.bold,
                          color: foreground,
                        ),
                      ),
                    ),
                  ),
                if (state.round > 0 && plan.rounds > 1)
                  Text(
                    l.timerRound(state.round, plan.rounds),
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(color: foreground),
                  ),
                const Spacer(),
                if (done)
                  Center(child: widget.done ?? const SizedBox.shrink())
                else
                  Center(
                    child: IconButton.filled(
                      iconSize: 48,
                      tooltip: _stopwatch.isRunning
                          ? l.timerPauseTooltip
                          : started
                          ? l.timerResumeTooltip
                          : l.timerStartTooltip,
                      icon: Icon(
                        _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: _toggle,
                    ),
                  ),
                if (!done && widget.footer != null) ...[
                  const SizedBox(height: 8),
                  Center(child: widget.footer),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

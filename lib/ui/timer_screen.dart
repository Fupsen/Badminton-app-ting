import 'package:flutter/material.dart';

import '../content/technique.dart';
import 'labels.dart';
import 'training_screen.dart';
import 'widgets/interval_timer_panel.dart';
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
  /// Skiftes for at starte timeren forfra.
  var _run = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final plan = widget.drill.timer!;
    return KeepScreenOn(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.drill.name),
          actions: [
            IconButton(
              tooltip: l.timerRestartTooltip,
              icon: const Icon(Icons.replay),
              onPressed: () => setState(() => _run++),
            ),
          ],
        ),
        body: IntervalTimerPanel(
          key: ValueKey(_run),
          plan: plan,
          // Med extendBodyBehindAppBar lægger Scaffold app-barens højde til
          // panelets SafeArea, så teksten havner under app-baren.
          header: Text(
            l.timerPlan(plan.workSeconds, plan.restSeconds, plan.rounds),
          ),
          done: FilledButton.icon(
            icon: const Icon(Icons.fitness_center),
            label: Text(l.timerLogDrill),
            onPressed: () => openTrainingForm(
              context,
              prefill: TrainingPrefill.forDrill(widget.drill),
            ),
          ),
        ),
      ),
    );
  }
}

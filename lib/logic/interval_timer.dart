import '../content/technique.dart';

enum TimerPhase { ready, work, rest, done }

class TimerState {
  const TimerState(this.phase, this.round, this.secondsLeft);

  final TimerPhase phase;

  /// Runden (1, 2, ...) som arbejdet eller pausen hører til. 0 under
  /// nedtællingen før start.
  final int round;

  /// Hele sekunder tilbage af fasen, rundet op (så "1" vises indtil 0).
  final int secondsLeft;

  @override
  bool operator ==(Object other) =>
      other is TimerState &&
      other.phase == phase &&
      other.round == round &&
      other.secondsLeft == secondsLeft;

  @override
  int get hashCode => Object.hash(phase, round, secondsLeft);

  @override
  String toString() => 'TimerState($phase, $round, $secondsLeft)';
}

/// Hvor langt et intervalforløb er nået efter [elapsed]. Forløbet er:
/// nedtælling ([readySeconds]), og så arbejde og pause for hver runde. Der er
/// ingen pause efter sidste runde.
TimerState timerStateAt(
  DrillTimer plan,
  Duration elapsed, {
  int readySeconds = 5,
}) {
  var ms = elapsed.inMilliseconds;
  int left(int phaseSeconds) => ((phaseSeconds * 1000 - ms) / 1000).ceil();

  if (ms < readySeconds * 1000) {
    return TimerState(TimerPhase.ready, 0, left(readySeconds));
  }
  ms -= readySeconds * 1000;
  for (var round = 1; round <= plan.rounds; round++) {
    if (ms < plan.workSeconds * 1000) {
      return TimerState(TimerPhase.work, round, left(plan.workSeconds));
    }
    ms -= plan.workSeconds * 1000;
    if (round == plan.rounds) break;
    if (ms < plan.restSeconds * 1000) {
      return TimerState(TimerPhase.rest, round, left(plan.restSeconds));
    }
    ms -= plan.restSeconds * 1000;
  }
  return TimerState(TimerPhase.done, plan.rounds, 0);
}

/// Samlet tid for forløbet uden nedtællingen.
Duration totalDuration(DrillTimer plan) => Duration(
  seconds:
      plan.workSeconds * plan.rounds + plan.restSeconds * (plan.rounds - 1),
);

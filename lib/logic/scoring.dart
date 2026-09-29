import '../models/models.dart';

/// Problemer der forhindrer en kamp i at blive gemt.
enum ScoreError {
  /// Ingen sæt indtastet.
  noGames,

  /// Et sæt er uafgjort, hvilket ikke kan ske i badminton.
  tiedGame,

  /// Kampen har ingen vinder (lige mange vundne sæt).
  noWinner,
}

/// Afvigelser fra de officielle BWF-regler. Kampen kan stadig gemmes, fx
/// hvis man har spillet til 15 til træning.
enum ScoreWarning {
  /// Et sæt følger ikke 21-point-reglen (2 point forspring, maks. 30).
  nonStandardGame,

  /// En officiel kamp er bedst af 3 sæt.
  nonStandardGameCount,
}

/// Tjekker om ét sæt følger BWF-reglerne: først til 21 med mindst 2 points
/// forspring; ved 29-29 vinder den, der først når 30.
bool isStandardGame(GameScore game) {
  final hi = game.own > game.opponent ? game.own : game.opponent;
  final lo = game.own > game.opponent ? game.opponent : game.own;
  if (lo < 0) return false;
  if (hi == 21) return lo <= 19;
  if (hi > 21 && hi < 30) return hi - lo == 2;
  if (hi == 30) return lo == 28 || lo == 29;
  return false;
}

class ScoreCheck {
  const ScoreCheck(this.errors, this.warnings);

  final Set<ScoreError> errors;
  final Set<ScoreWarning> warnings;

  bool get canSave => errors.isEmpty;
}

ScoreCheck checkMatch(List<GameScore> games) {
  final errors = <ScoreError>{};
  final warnings = <ScoreWarning>{};

  if (games.isEmpty) {
    errors.add(ScoreError.noGames);
    return ScoreCheck(errors, warnings);
  }
  if (games.any((g) => g.own == g.opponent)) errors.add(ScoreError.tiedGame);

  final won = games.where((g) => g.own > g.opponent).length;
  final lost = games.where((g) => g.own < g.opponent).length;
  if (won == lost) errors.add(ScoreError.noWinner);

  if (games.any((g) => !isStandardGame(g))) {
    warnings.add(ScoreWarning.nonStandardGame);
  }
  // Bedst af 3: kampen slutter, når en side har vundet 2 sæt.
  final standardCount = (won == 2 && lost <= 1) || (lost == 2 && won <= 1);
  final decidedAfterTwo = games.length == 3 && games[0].won == games[1].won;
  if (!standardCount || decidedAfterTwo) {
    warnings.add(ScoreWarning.nonStandardGameCount);
  }

  return ScoreCheck(errors, warnings);
}

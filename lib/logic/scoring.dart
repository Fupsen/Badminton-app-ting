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

/// Afvigelser fra de officielle regler. Kampen kan stadig gemmes, fx hvis
/// man har spillet til 11 til træning.
enum ScoreWarning {
  /// Sættene følger ikke ét af de officielle pointsystemer.
  nonStandardGame,

  /// En officiel kamp er bedst af 3 sæt.
  nonStandardGameCount,
}

/// Officielle pointsystemer. Se docs/viden/regler.md.
enum ScoringSystem {
  /// 3×15: til 15, ved 14-14 skal man vinde med 2, loft ved 21.
  /// Standard i Danmark fra 1. juli 2026 og hos BWF fra 4. januar 2027.
  to15(target: 15, cap: 21),

  /// 3×21: til 21, ved 20-20 skal man vinde med 2, loft ved 30.
  /// Tidligere standard; stadig tilladt som alternativt system.
  to21(target: 21, cap: 30);

  const ScoringSystem({required this.target, required this.cap});

  final int target;
  final int cap;
}

/// Tjekker om ét sæt har et gyldigt slutresultat. Uden [system] er sættet
/// gyldigt, hvis det passer med ét af de officielle pointsystemer.
bool isStandardGame(GameScore game, [ScoringSystem? system]) {
  if (system == null) {
    return ScoringSystem.values.any((s) => isStandardGame(game, s));
  }
  final hi = game.own > game.opponent ? game.own : game.opponent;
  final lo = game.own > game.opponent ? game.opponent : game.own;
  if (lo < 0) return false;
  if (hi == system.target) return lo <= system.target - 2;
  if (hi > system.target && hi < system.cap) return hi - lo == 2;
  if (hi == system.cap) return lo == system.cap - 1 || lo == system.cap - 2;
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

  // Alle sæt i en kamp skal følge samme pointsystem.
  final followsOneSystem = ScoringSystem.values
      .any((system) => games.every((g) => isStandardGame(g, system)));
  if (!followsOneSystem) warnings.add(ScoreWarning.nonStandardGame);
  // Bedst af 3: kampen slutter, når en side har vundet 2 sæt.
  final standardCount = (won == 2 && lost <= 1) || (lost == 2 && won <= 1);
  final decidedAfterTwo = games.length == 3 && games[0].won == games[1].won;
  if (!standardCount || decidedAfterTwo) {
    warnings.add(ScoreWarning.nonStandardGameCount);
  }

  return ScoreCheck(errors, warnings);
}

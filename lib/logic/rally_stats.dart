import '../models/models.dart';
import 'live_score.dart';

/// Vundne ud af spillede dueller.
class RallyCount {
  const RallyCount(this.won, this.played);

  final int won;
  final int played;

  /// Andel vundet mellem 0 og 1, eller null uden dueller.
  double? get rate => played == 0 ? null : won / played;
}

/// Statistik fra kampe, der er talt med kamptælleren.
class RallyStats {
  const RallyStats({
    required this.matches,
    required this.onServe,
    required this.onReceive,
    required this.close,
    required this.longestRun,
    required this.comebacks,
  });

  /// Antal kampe med et brugbart forløb.
  final int matches;

  /// Dueller, hvor vi servede.
  final RallyCount onServe;

  /// Dueller, hvor de servede.
  final RallyCount onReceive;

  /// Dueller ved tæt stilling (se [closeFrom]).
  final RallyCount close;

  /// Flest point i træk i én kamp.
  final int longestRun;

  /// Sæt vundet efter at have været bagud med mindst [comebackDeficit] point.
  final int comebacks;
}

/// Bagud med så mange point tæller som et comeback, hvis sættet vindes.
const comebackDeficit = 5;

/// Stillingen er tæt, når begge sider har mindst dette antal point: 13 i
/// 3×15 og 19 i 3×21, altså 2 point før målet. Det er appens egen grænse.
int closeFrom(LiveMatch match) => match.system.target - 2;

/// Genskaber forløbet, eller null hvis det mangler eller ikke passer med de
/// gemte sæt (så statistikken aldrig modsiger resultatet).
LiveMatch? replayOf(MatchRecord record) {
  final log = record.rallyLog;
  if (log == null) return null;
  final live = LiveMatch.fromRallyLog(log, record.type);
  if (live == null) return null;
  final games = live.gamesForSaving;
  if (games.length != record.games.length) return null;
  for (var i = 0; i < games.length; i++) {
    if (games[i] != record.games[i]) return null;
  }
  return live;
}

/// Statistik over [matches], eller null hvis ingen af dem har et forløb.
RallyStats? rallyStats(Iterable<MatchRecord> matches) {
  var count = 0;
  var serveWon = 0, served = 0, receiveWon = 0, received = 0;
  var closeWon = 0, closePlayed = 0;
  var longestRun = 0, comebacks = 0;

  for (final record in matches) {
    final live = replayOf(record);
    if (live == null) continue;
    count++;
    final close = closeFrom(live);
    final rallies = live.rallyInfo;
    var run = 0;
    var game = -1, worstDeficit = 0;
    for (var i = 0; i < rallies.length; i++) {
      final r = rallies[i];
      final won = r.winner == Side.us;
      if (r.server == Side.us) {
        served++;
        if (won) serveWon++;
      } else {
        received++;
        if (won) receiveWon++;
      }
      if (r.us >= close && r.them >= close) {
        closePlayed++;
        if (won) closeWon++;
      }
      run = won ? run + 1 : 0;
      if (run > longestRun) longestRun = run;

      if (r.game != game) {
        game = r.game;
        worstDeficit = 0;
      }
      if (r.them - r.us > worstDeficit) worstDeficit = r.them - r.us;
      final last = i == rallies.length - 1 || rallies[i + 1].game != r.game;
      final gameWon =
          last && won && r.game < live.games.length && live.games[r.game].won;
      if (gameWon && worstDeficit >= comebackDeficit) comebacks++;
    }
  }
  if (count == 0) return null;
  return RallyStats(
    matches: count,
    onServe: RallyCount(serveWon, served),
    onReceive: RallyCount(receiveWon, received),
    close: RallyCount(closeWon, closePlayed),
    longestRun: longestRun,
    comebacks: comebacks,
  );
}

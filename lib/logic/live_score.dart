import '../models/models.dart';
import 'scoring.dart';

/// Den ene eller den anden side af nettet, set fra spilleren i appen.
enum Side {
  us,
  them;

  Side get other => this == us ? them : us;
}

enum Court { right, left }

/// Noget, der skal gøres efter den seneste duel.
enum LiveEvent {
  /// Den førende side har nået 8 (3×15) eller 11 (3×21): pause på højst 60 s.
  interval,

  /// Som [interval], men i 3. sæt, hvor man også skifter side.
  intervalAndChangeEnds,

  /// Et sæt er slut: pause på højst 120 s, og man skifter side.
  gameEnded,

  /// Kampen er slut.
  matchEnded,
}

/// En kamp, der tælles undervejs. Kampen gemmes som rækken af duel-vindere,
/// og alt andet regnes ud fra den. Så er fortryd og gem/hent nemt og sikkert.
///
/// Reglerne følger docs/viden/regler.md: rally point, vinderen af en duel
/// server næste gang, vinderen af et sæt server først i næste sæt, den
/// servende side server fra højre ved lige point og fra venstre ved ulige,
/// og bedst af 3 sæt.
class LiveMatch {
  const LiveMatch({
    required this.system,
    required this.type,
    required this.firstServer,
    this.rallies = const [],
  });

  final ScoringSystem system;
  final MatchType type;
  final Side firstServer;

  /// Hvem der vandt hver duel, i rækkefølge.
  final List<Side> rallies;

  /// Pause og sideskift i 3. sæt, når den førende når dette pointtal.
  int get intervalAt => system == ScoringSystem.to15 ? 8 : 11;

  bool _gameOver(int a, int b) {
    final hi = a > b ? a : b;
    final lo = a > b ? b : a;
    return hi == system.cap || (hi >= system.target && hi - lo >= 2);
  }

  _State _replay(List<Side> rallies) {
    final games = <GameScore>[];
    var us = 0, them = 0;
    var server = firstServer;
    LiveEvent? event;
    for (final winner in rallies) {
      if (_finished(games)) break;
      event = null;
      final before = us > them ? us : them;
      if (winner == Side.us) {
        us++;
      } else {
        them++;
      }
      server = winner;
      if (_gameOver(us, them)) {
        games.add(GameScore(us, them));
        us = them = 0;
        event = _finished(games) ? LiveEvent.matchEnded : LiveEvent.gameEnded;
      } else {
        final after = us > them ? us : them;
        if (before == intervalAt - 1 && after == intervalAt) {
          event = games.length == 2
              ? LiveEvent.intervalAndChangeEnds
              : LiveEvent.interval;
        }
      }
    }
    return _State(games, us, them, server, event);
  }

  static bool _finished(List<GameScore> games) {
    final won = games.where((g) => g.won).length;
    return won == 2 || games.length - won == 2;
  }

  _State get _state => _replay(rallies);

  /// Færdigspillede sæt, set fra vores side.
  List<GameScore> get games => _state.games;

  /// Point i det sæt, der er i gang.
  int get ourPoints => _state.us;
  int get theirPoints => _state.them;

  /// Hvem der server nu.
  Side get server => _state.server;

  /// Hvilket felt den servende side server fra.
  Court get serviceCourt {
    final s = _state;
    final points = s.server == Side.us ? s.us : s.them;
    return points.isEven ? Court.right : Court.left;
  }

  /// Det der skal ske efter den seneste duel, eller null.
  LiveEvent? get lastEvent => _state.event;

  bool get isFinished => _finished(games);

  /// Vinderen af kampen, når den er slut.
  Side? get winner {
    if (!isFinished) return null;
    return games.where((g) => g.won).length == 2 ? Side.us : Side.them;
  }

  bool get canUndo => rallies.isNotEmpty;

  /// Sættene til en kampformular: de færdige sæt plus det igangværende, hvis
  /// der er spillet point i det.
  List<GameScore> get gamesForSaving {
    final s = _state;
    return [
      ...s.games,
      if (!isFinished && (s.us > 0 || s.them > 0)) GameScore(s.us, s.them),
    ];
  }

  LiveMatch pointTo(Side side) => isFinished
      ? this
      : LiveMatch(
          system: system,
          type: type,
          firstServer: firstServer,
          rallies: [...rallies, side],
        );

  LiveMatch undo() => canUndo
      ? LiveMatch(
          system: system,
          type: type,
          firstServer: firstServer,
          rallies: rallies.sublist(0, rallies.length - 1),
        )
      : this;

  Map<String, dynamic> toJson() => {
    'system': system.name,
    'type': type.name,
    'firstServer': firstServer.name,
    'rallies': rallies.map((s) => s == Side.us ? 'u' : 't').join(),
  };

  factory LiveMatch.fromJson(Map<String, dynamic> json) => LiveMatch(
    system: ScoringSystem.values.byName(json['system'] as String),
    type: MatchType.values.byName(json['type'] as String),
    firstServer: Side.values.byName(json['firstServer'] as String),
    rallies: [
      for (final c in (json['rallies'] as String? ?? '').split(''))
        c == 'u' ? Side.us : Side.them,
    ],
  );
}

class _State {
  const _State(this.games, this.us, this.them, this.server, this.event);

  final List<GameScore> games;
  final int us;
  final int them;
  final Side server;
  final LiveEvent? event;
}

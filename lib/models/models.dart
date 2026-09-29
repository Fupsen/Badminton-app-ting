/// Datamodeller for appen. Alle modeller kan serialiseres til/fra JSON, så de
/// både kan gemmes lokalt og senere synkroniseres til en cloud-tjeneste.
library;

import 'dart:math';

final _random = Random();

/// Genererer et unikt id uden eksterne afhængigheder.
String newId() {
  final time = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  // Højst 2^30 pr. kald: i webudgaven er `1 << 32` lig 0 (32-bit
  // bitoperationer i JavaScript), og nextInt(0) kaster en fejl.
  String part() => _random.nextInt(1 << 30).toRadixString(36).padLeft(6, '0');
  return '$time${part()}${part()}';
}

class Player {
  Player({required this.id, required this.name, required this.createdAt});

  final String id;
  final String name;
  final DateTime createdAt;

  Player copyWith({String? name}) =>
      Player(id: id, name: name ?? this.name, createdAt: createdAt);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json['id'] as String,
    name: json['name'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

enum MatchType { single, double, mixed }

/// Resultatet af ét sæt set fra spillerens side.
class GameScore {
  const GameScore(this.own, this.opponent);

  final int own;
  final int opponent;

  bool get won => own > opponent;

  List<int> toJson() => [own, opponent];

  factory GameScore.fromJson(List<dynamic> json) =>
      GameScore(json[0] as int, json[1] as int);

  @override
  bool operator ==(Object other) =>
      other is GameScore && other.own == own && other.opponent == opponent;

  @override
  int get hashCode => Object.hash(own, opponent);
}

class MatchRecord {
  MatchRecord({
    required this.id,
    required this.playerId,
    required this.date,
    required this.type,
    required this.opponents,
    required this.games,
    this.partner = '',
    this.notes = '',
    this.practice = false,
  });

  final String id;
  final String playerId;
  final DateTime date;
  final MatchType type;

  /// Træningskamp. Tæller som standard ikke med i sejrsprocent og form.
  final bool practice;

  /// Modstander(e) som fri tekst, fx "Anders" eller "Anders / Bo".
  final String opponents;

  /// Makker ved double/mixed. Tom ved single.
  final String partner;
  final List<GameScore> games;
  final String notes;

  int get gamesWon => games.where((g) => g.won).length;
  int get gamesLost => games.length - gamesWon;
  bool get won => gamesWon > gamesLost;
  int get pointsFor => games.fold(0, (sum, g) => sum + g.own);
  int get pointsAgainst => games.fold(0, (sum, g) => sum + g.opponent);
  int get pointDiff => pointsFor - pointsAgainst;

  Map<String, dynamic> toJson() => {
    'id': id,
    'playerId': playerId,
    'date': date.toIso8601String(),
    'type': type.name,
    'opponents': opponents,
    'partner': partner,
    'games': games.map((g) => g.toJson()).toList(),
    'notes': notes,
    'practice': practice,
  };

  factory MatchRecord.fromJson(Map<String, dynamic> json) => MatchRecord(
    id: json['id'] as String,
    playerId: json['playerId'] as String,
    date: DateTime.parse(json['date'] as String),
    type: MatchType.values.byName(json['type'] as String),
    opponents: json['opponents'] as String? ?? '',
    partner: json['partner'] as String? ?? '',
    games: (json['games'] as List<dynamic>)
        .map((g) => GameScore.fromJson(g as List<dynamic>))
        .toList(),
    notes: json['notes'] as String? ?? '',
    practice: json['practice'] as bool? ?? false,
  );
}

enum TrainingType { technique, physical, matchPlay, footwork, other }

class TrainingSession {
  TrainingSession({
    required this.id,
    required this.playerId,
    required this.date,
    required this.durationMinutes,
    required this.type,
    required this.intensity,
    this.notes = '',
    this.techniqueIds = const [],
    this.drillIds = const [],
  });

  final String id;
  final String playerId;
  final DateTime date;
  final int durationMinutes;
  final TrainingType type;

  /// Oplevet intensitet fra 1 (let) til 5 (maksimal).
  final int intensity;
  final String notes;

  /// Slag og benarbejde der blev trænet (id'er fra teknik-biblioteket).
  final List<String> techniqueIds;

  /// Øvelser fra teknik-biblioteket der blev lavet.
  final List<String> drillIds;

  Map<String, dynamic> toJson() => {
    'id': id,
    'playerId': playerId,
    'date': date.toIso8601String(),
    'durationMinutes': durationMinutes,
    'type': type.name,
    'intensity': intensity,
    'notes': notes,
    'techniqueIds': techniqueIds,
    'drillIds': drillIds,
  };

  factory TrainingSession.fromJson(Map<String, dynamic> json) =>
      TrainingSession(
        id: json['id'] as String,
        playerId: json['playerId'] as String,
        date: DateTime.parse(json['date'] as String),
        durationMinutes: json['durationMinutes'] as int,
        type: TrainingType.values.byName(json['type'] as String),
        intensity: json['intensity'] as int,
        notes: json['notes'] as String? ?? '',
        techniqueIds: _stringList(json['techniqueIds']),
        drillIds: _stringList(json['drillIds']),
      );
}

List<String> _stringList(Object? value) =>
    (value as List<dynamic>? ?? const []).cast<String>().toList();

enum GoalType {
  /// Antal træningspas i indeværende uge.
  sessionsPerWeek,

  /// Træningsminutter i indeværende uge.
  minutesPerWeek,

  /// Sejrsprocent for kampe spillet siden målet blev oprettet.
  winRate,
}

class Goal {
  Goal({
    required this.id,
    required this.playerId,
    required this.type,
    required this.target,
    required this.createdAt,
  });

  final String id;
  final String playerId;
  final GoalType type;
  final int target;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'playerId': playerId,
    'type': type.name,
    'target': target,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json['id'] as String,
    playerId: json['playerId'] as String,
    type: GoalType.values.byName(json['type'] as String),
    target: json['target'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

/// Hele appens data samlet ét sted.
class AppData {
  AppData({
    List<Player>? players,
    List<MatchRecord>? matches,
    List<TrainingSession>? trainings,
    List<Goal>? goals,
    this.activePlayerId,
    this.lastBackupAt,
  }) : players = players ?? [],
       matches = matches ?? [],
       trainings = trainings ?? [],
       goals = goals ?? [];

  static const schemaVersion = 1;

  final List<Player> players;
  final List<MatchRecord> matches;
  final List<TrainingSession> trainings;
  final List<Goal> goals;
  String? activePlayerId;

  /// Hvornår der sidst blev eksporteret en backup fra denne enhed.
  DateTime? lastBackupAt;

  Map<String, dynamic> toJson() => {
    'schemaVersion': schemaVersion,
    'activePlayerId': activePlayerId,
    'lastBackupAt': lastBackupAt?.toIso8601String(),
    'players': players.map((p) => p.toJson()).toList(),
    'matches': matches.map((m) => m.toJson()).toList(),
    'trainings': trainings.map((t) => t.toJson()).toList(),
    'goals': goals.map((g) => g.toJson()).toList(),
  };

  factory AppData.fromJson(Map<String, dynamic> json) {
    List<T> list<T>(String key, T Function(Map<String, dynamic>) f) =>
        (json[key] as List<dynamic>? ?? [])
            .map((e) => f(e as Map<String, dynamic>))
            .toList();
    final lastBackupAt = json['lastBackupAt'] as String?;
    return AppData(
      activePlayerId: json['activePlayerId'] as String?,
      lastBackupAt: lastBackupAt == null ? null : DateTime.parse(lastBackupAt),
      players: list('players', Player.fromJson),
      matches: list('matches', MatchRecord.fromJson),
      trainings: list('trainings', TrainingSession.fromJson),
      goals: list('goals', Goal.fromJson),
    );
  }
}

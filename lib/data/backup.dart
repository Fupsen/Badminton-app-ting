import 'dart:convert';

import '../models/models.dart';

/// Filen kunne ikke læses som en backup fra denne app.
class BackupFormatException implements Exception {
  const BackupFormatException(this.reason, {this.tooNew = false});

  final String reason;

  /// Sand hvis filen er lavet af en nyere version af appen.
  final bool tooNew;

  @override
  String toString() => 'BackupFormatException: $reason';
}

/// Serialiserer alle data til en læsbar JSON-backup.
String encodeBackup(AppData data, {required DateTime exportedAt}) {
  final json = {
    'app': 'badminton-logbog',
    'exportedAt': exportedAt.toIso8601String(),
    ...data.toJson(),
  };
  return const JsonEncoder.withIndent('  ').convert(json);
}

/// Læser en backup. Kaster [BackupFormatException] hvis filen ikke er en
/// gyldig backup.
AppData decodeBackup(String text) {
  final Object? json;
  try {
    json = jsonDecode(text);
  } on FormatException catch (e) {
    throw BackupFormatException('not json: ${e.message}');
  }
  if (json is! Map<String, dynamic>) {
    throw const BackupFormatException('not a json object');
  }
  final version = json['schemaVersion'];
  if (version is! int || json['players'] is! List) {
    throw const BackupFormatException('missing schemaVersion or players');
  }
  if (version > AppData.schemaVersion) {
    throw BackupFormatException('schema $version is newer', tooNew: true);
  }
  try {
    return AppData.fromJson(json);
  } catch (e) {
    throw BackupFormatException('invalid content: $e');
  }
}

/// Fletter [incoming] ind i [current]: rækker med nyt id tilføjes, og rækker
/// med samme id erstattes af versionen fra [incoming]. Intet slettes.
AppData mergeData(AppData current, AppData incoming) {
  List<T> merge<T>(List<T> a, List<T> b, String Function(T) id) {
    final byId = {for (final e in a) id(e): e};
    for (final e in b) {
      byId[id(e)] = e;
    }
    return byId.values.toList();
  }

  return AppData(
    players: merge(current.players, incoming.players, (p) => p.id),
    matches: merge(current.matches, incoming.matches, (m) => m.id),
    trainings: merge(current.trainings, incoming.trainings, (t) => t.id),
    goals: merge(current.goals, incoming.goals, (g) => g.id),
    plans: merge(current.plans, incoming.plans, (p) => p.id),
    activePlayerId: current.activePlayerId ?? incoming.activePlayerId,
    lastBackupAt: current.lastBackupAt,
  );
}

String backupFileName(DateTime now) {
  String two(int n) => n.toString().padLeft(2, '0');
  return 'badminton-backup-${now.year}-${two(now.month)}-${two(now.day)}.json';
}

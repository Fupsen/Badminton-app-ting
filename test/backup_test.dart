import 'dart:convert';

import 'package:badminton_app/data/backup.dart';
import 'package:badminton_app/data/data_store.dart';
import 'package:badminton_app/models/models.dart';
import 'package:badminton_app/state/app_state.dart';
import 'package:flutter_test/flutter_test.dart';

Player player(String id, String name) =>
    Player(id: id, name: name, createdAt: DateTime(2026));

MatchRecord match(String id, String playerId, {String opponents = 'Bo'}) =>
    MatchRecord(
      id: id,
      playerId: playerId,
      date: DateTime(2026, 9, 1),
      type: MatchType.single,
      opponents: opponents,
      games: const [GameScore(21, 15), GameScore(21, 17)],
    );

void main() {
  final exportedAt = DateTime(2026, 9, 29, 12);

  test('round trip keeps all data', () {
    final data = AppData(
      players: [player('p1', 'Mette')],
      matches: [match('m1', 'p1')],
      trainings: [
        TrainingSession(
          id: 't1',
          playerId: 'p1',
          date: DateTime(2026, 9, 2),
          durationMinutes: 90,
          type: TrainingType.footwork,
          intensity: 4,
          notes: 'Fokus på clear',
        ),
      ],
      goals: [
        Goal(
          id: 'g1',
          playerId: 'p1',
          type: GoalType.minutesPerWeek,
          target: 180,
          createdAt: DateTime(2026, 9, 1),
        ),
      ],
      activePlayerId: 'p1',
    );
    final text = encodeBackup(data, exportedAt: exportedAt);
    expect(jsonDecode(text)['exportedAt'], exportedAt.toIso8601String());

    final back = decodeBackup(text);
    expect(back.players.single.name, 'Mette');
    expect(back.matches.single.games, data.matches.single.games);
    expect(back.trainings.single.notes, 'Fokus på clear');
    expect(back.goals.single.target, 180);
    expect(back.activePlayerId, 'p1');
  });

  test('invalid files are rejected', () {
    for (final text in [
      'ikke json',
      '[]',
      '{"players": []}',
      '{"schemaVersion": 1}',
      '{"schemaVersion": 1, "players": [{"id": 1}]}',
    ]) {
      expect(() => decodeBackup(text), throwsA(isA<BackupFormatException>()),
          reason: text);
    }
  });

  test('backup from a newer app version is rejected as too new', () {
    final text = jsonEncode({
      'schemaVersion': AppData.schemaVersion + 1,
      'players': [],
    });
    expect(
      () => decodeBackup(text),
      throwsA(isA<BackupFormatException>()
          .having((e) => e.tooNew, 'tooNew', isTrue)),
    );
  });

  test('old data files without lastBackupAt still load', () {
    final data = AppData.fromJson({
      'schemaVersion': 1,
      'players': [player('p1', 'Mette').toJson()],
    });
    expect(data.lastBackupAt, isNull);
    expect(data.players, hasLength(1));
  });

  test('merge adds new rows, updates same id and deletes nothing', () {
    final current = AppData(
      players: [player('p1', 'Mette')],
      matches: [match('m1', 'p1'), match('m2', 'p1')],
      activePlayerId: 'p1',
      lastBackupAt: DateTime(2026, 9, 1),
    );
    final incoming = AppData(
      players: [player('p1', 'Mette H.'), player('p2', 'Jonas')],
      matches: [match('m2', 'p1', opponents: 'Anders'), match('m3', 'p2')],
      activePlayerId: 'p2',
    );
    final merged = mergeData(current, incoming);
    expect(merged.players.map((p) => p.name), ['Mette H.', 'Jonas']);
    expect(merged.matches.map((m) => m.id), ['m1', 'm2', 'm3']);
    expect(merged.matches[1].opponents, 'Anders');
    expect(merged.activePlayerId, 'p1');
    expect(merged.lastBackupAt, DateTime(2026, 9, 1));

    // At flette den samme backup ind to gange giver ingen dubletter.
    expect(mergeData(merged, incoming).matches, hasLength(3));
  });

  test('file name contains the date', () {
    expect(backupFileName(DateTime(2026, 3, 7)),
        'badminton-backup-2026-03-07.json');
  });

  group('AppState', () {
    Future<AppState> loaded(AppData data) async {
      final state = AppState(MemoryStore(data));
      await state.load();
      return state;
    }

    test('backup reminder', () async {
      final now = DateTime(2026, 9, 29);
      final empty = await loaded(AppData(players: [player('p1', 'Mette')]));
      expect(empty.needsBackupReminder(now), isFalse);

      final state = await loaded(AppData(
        players: [player('p1', 'Mette')],
        matches: [match('m1', 'p1')],
      ));
      expect(state.needsBackupReminder(now), isTrue);
      await state.markBackedUp(DateTime(2026, 9, 1));
      expect(state.needsBackupReminder(now), isFalse);
      expect(state.needsBackupReminder(DateTime(2026, 10, 2)), isTrue);
    });

    test('replace keeps this device\'s backup time and fixes active player',
        () async {
      final state = await loaded(AppData(
        players: [player('p1', 'Mette')],
        activePlayerId: 'p1',
        lastBackupAt: DateTime(2026, 9, 1),
      ));
      await state.importBackup(
        AppData(
          players: [player('p9', 'Jonas')],
          activePlayerId: 'findes-ikke',
          lastBackupAt: DateTime(2020),
        ),
        replace: true,
      );
      expect(state.players.single.name, 'Jonas');
      expect(state.activePlayer!.id, 'p9');
      expect(state.lastBackupAt, DateTime(2026, 9, 1));
    });

    test('export includes the new backup time', () async {
      final state = await loaded(AppData(players: [player('p1', 'Mette')]));
      final text = state.exportBackup(exportedAt);
      expect(decodeBackup(text).lastBackupAt, exportedAt);
      // Tidspunktet gemmes først, når filen faktisk er gemt.
      expect(state.lastBackupAt, isNull);
    });
  });
}

import 'package:badminton_app/data/backup.dart';
import 'package:badminton_app/data/backup_files.dart';
import 'package:badminton_app/data/data_store.dart';
import 'package:badminton_app/main.dart';
import 'package:badminton_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Falske fildialoger: husker det gemte og returnerer [toPick] ved åbning.
class FakeBackupFiles implements BackupFiles {
  String? savedName;
  String? savedContents;
  String? toPick;

  @override
  Future<bool> save(String fileName, String contents,
      {Rect? sharePositionOrigin}) async {
    savedName = fileName;
    savedContents = contents;
    return true;
  }

  @override
  Future<String?> pickAndRead() async => toPick;
}

MatchRecord sampleMatch(String id, String playerId) => MatchRecord(
      id: id,
      playerId: playerId,
      date: DateTime(2026, 9, 1),
      type: MatchType.single,
      opponents: 'Bo',
      games: const [GameScore(21, 15), GameScore(21, 17)],
    );

void main() {
  testWidgets('first run: create player, log a match, see stats',
      (tester) async {
    final store = MemoryStore();
    await tester.pumpWidget(BadmintonApp(store: store));
    await tester.pumpAndSettle();

    // Velkomstskærm
    expect(find.text('Velkommen til Badminton-logbog'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Mette');
    await tester.pump();
    await tester.tap(find.text('Kom i gang'));
    await tester.pumpAndSettle();

    // Oversigt
    expect(find.text('Velkommen til Badminton-logbog'), findsNothing);
    expect(find.text('Mette'), findsOneWidget);
    await tester.tap(find.text('Log kamp'));
    await tester.pumpAndSettle();

    // Kampformular
    expect(find.text('Ny kamp'), findsOneWidget);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Modstander(e)'), 'Anders');
    final scoreFields = find.byWidgetPredicate((w) =>
        w is TextField &&
        (w.decoration?.labelText == 'Mig/os' ||
            w.decoration?.labelText == 'Modstander'));
    await tester.enterText(scoreFields.at(0), '21');
    await tester.enterText(scoreFields.at(1), '17');
    await tester.enterText(scoreFields.at(2), '21');
    await tester.enterText(scoreFields.at(3), '19');
    await tester.tap(find.text('Gem'));
    await tester.pumpAndSettle();

    // Tilbage på oversigten med opdateret statistik
    expect(find.text('Ny kamp'), findsNothing);
    expect(find.text('100 %'), findsOneWidget);
    expect(find.text('1 vundet · 0 tabt'), findsOneWidget);

    final saved = await store.load();
    expect(saved.players.single.name, 'Mette');
    expect(saved.matches.single.opponents, 'Anders');
    expect(saved.matches.single.won, isTrue);
  });

  testWidgets('non-standard score asks for confirmation', (tester) async {
    final store = MemoryStore(AppData(
      players: [Player(id: 'p', name: 'Mette', createdAt: DateTime(2026))],
      activePlayerId: 'p',
    ));
    await tester.pumpWidget(BadmintonApp(store: store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log kamp'));
    await tester.pumpAndSettle();
    final scoreFields = find.byWidgetPredicate((w) =>
        w is TextField &&
        (w.decoration?.labelText == 'Mig/os' ||
            w.decoration?.labelText == 'Modstander'));
    await tester.enterText(scoreFields.at(0), '15');
    await tester.enterText(scoreFields.at(1), '10');
    await tester.tap(find.text('Gem'));
    await tester.pumpAndSettle();

    expect(find.text('Usædvanligt resultat'), findsOneWidget);
    await tester.tap(find.text('Gem alligevel'));
    await tester.pumpAndSettle();
    expect((await store.load()).matches.single.pointDiff, 5);
  });

  testWidgets('wide screens use a navigation rail', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final store = MemoryStore(AppData(
      players: [Player(id: 'p', name: 'Mette', createdAt: DateTime(2026))],
      activePlayerId: 'p',
    ));
    await tester.pumpWidget(BadmintonApp(store: store));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    // Alle faner kan åbnes uden fejl, også uden data.
    for (final tab in ['Kampe', 'Træning', 'Mål', 'Statistik', 'Oversigt']) {
      await tester.tap(find.text(tab).first);
      await tester.pumpAndSettle();
    }
  });

  testWidgets('export and merge-import a backup', (tester) async {
    final files = FakeBackupFiles();
    final store = MemoryStore(AppData(
      players: [Player(id: 'p', name: 'Mette', createdAt: DateTime(2026))],
      matches: [sampleMatch('m1', 'p')],
      activePlayerId: 'p',
    ));
    await tester.pumpWidget(BadmintonApp(store: store, backupFiles: files));
    await tester.pumpAndSettle();

    // Påmindelse vises, fordi der er data uden backup.
    expect(find.text('Tag backup'), findsOneWidget);
    await tester.tap(find.text('Tag backup'));
    await tester.pumpAndSettle();
    expect(find.text('Der er endnu ikke taget backup på denne enhed.'),
        findsOneWidget);

    // Eksport
    await tester.tap(find.widgetWithText(FilledButton, 'Eksportér backup'));
    await tester.pumpAndSettle();
    expect(files.savedName, startsWith('badminton-backup-'));
    expect(decodeBackup(files.savedContents!).matches, hasLength(1));
    expect(find.textContaining('Sidste backup:'), findsOneWidget);
    expect((await store.load()).lastBackupAt, isNotNull);
    // Vent til beskeden "Backup gemt" er væk, så den ikke dækker knappen.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Import af en fil med én ny kamp og den eksisterende kamp: flet ind.
    files.toPick = encodeBackup(
      AppData(
        players: [Player(id: 'p', name: 'Mette', createdAt: DateTime(2026))],
        matches: [sampleMatch('m1', 'p'), sampleMatch('m2', 'p')],
      ),
      exportedAt: DateTime(2026, 9, 29),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Importér backup'));
    await tester.pumpAndSettle();
    expect(find.text('Importér backup?'), findsOneWidget);
    expect(find.textContaining('1 spiller, 2 kampe'), findsOneWidget);
    await tester.tap(find.text('Flet ind'));
    await tester.pumpAndSettle();
    expect(find.text('Backup indlæst'), findsOneWidget);
    expect((await store.load()).matches, hasLength(2));

    // Påmindelsen er væk på oversigten.
    await tester.tap(find.byTooltip('Tilbage'));
    await tester.pumpAndSettle();
    expect(find.text('Tag backup'), findsNothing);
  });

  testWidgets('invalid backup file shows an error', (tester) async {
    final files = FakeBackupFiles()..toPick = 'ikke en backup';
    final store = MemoryStore(AppData(
      players: [Player(id: 'p', name: 'Mette', createdAt: DateTime(2026))],
      activePlayerId: 'p',
    ));
    await tester.pumpWidget(BadmintonApp(store: store, backupFiles: files));
    await tester.pumpAndSettle();

    // Åbn backup via spiller-menuen.
    await tester.tap(find.text('Mette'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Backup og gendannelse'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Importér backup'));
    await tester.pumpAndSettle();
    expect(find.text('Filen er ikke en gyldig backup fra Badminton-logbog.'),
        findsOneWidget);
    expect((await store.load()).players, hasLength(1));
  });

  testWidgets('restore from backup on a new device', (tester) async {
    final files = FakeBackupFiles()
      ..toPick = encodeBackup(
        AppData(
          players: [Player(id: 'p', name: 'Mette', createdAt: DateTime(2026))],
          matches: [sampleMatch('m1', 'p')],
          activePlayerId: 'p',
        ),
        exportedAt: DateTime(2026, 9, 29),
      );
    final store = MemoryStore();
    await tester.pumpWidget(BadmintonApp(store: store, backupFiles: files));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gendan fra backup'));
    await tester.pumpAndSettle();

    expect(find.text('Velkommen til Badminton-logbog'), findsNothing);
    expect(find.text('Mette'), findsOneWidget);
    expect(find.text('Backup indlæst'), findsOneWidget);
    expect((await store.load()).matches, hasLength(1));
  });
}

import 'package:badminton_app/data/backup.dart';
import 'package:badminton_app/data/backup_files.dart';
import 'package:badminton_app/data/data_store.dart';
import 'package:badminton_app/l10n/app_localizations.dart';
import 'package:badminton_app/main.dart';
import 'package:badminton_app/models/models.dart';
import 'package:badminton_app/ui/widgets/common.dart';
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
    await tester.enterText(scoreFields.at(0), '11');
    await tester.enterText(scoreFields.at(1), '5');
    await tester.tap(find.text('Gem'));
    await tester.pumpAndSettle();

    expect(find.text('Usædvanligt resultat'), findsOneWidget);
    await tester.tap(find.text('Gem alligevel'));
    await tester.pumpAndSettle();
    expect((await store.load()).matches.single.pointDiff, 6);
  });

  testWidgets('a normal 3x15 match saves without warning', (tester) async {
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
    for (final (i, v) in ['15', '12', '21', '20'].indexed) {
      await tester.enterText(scoreFields.at(i), v);
    }
    await tester.tap(find.text('Gem'));
    await tester.pumpAndSettle();

    expect(find.text('Usædvanligt resultat'), findsNothing);
    expect((await store.load()).matches.single.won, isTrue);
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
    for (final tab in ['Kampe', 'Træning', 'Teknik', 'Statistik', 'Oversigt']) {
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

  AppData onePlayer() => AppData(
        players: [Player(id: 'p', name: 'Mette', createdAt: DateTime(2026))],
        activePlayerId: 'p',
      );

  Finder navItem(String label) => find.descendant(
      of: find.byType(NavigationBar), matching: find.text(label));

  testWidgets('practice match skips warning and is excluded from stats',
      (tester) async {
    final store = MemoryStore(onePlayer());
    await tester.pumpWidget(BadmintonApp(store: store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log kamp'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Træningskamp'));
    await tester.pumpAndSettle();
    final scoreFields = find.byWidgetPredicate((w) =>
        w is TextField &&
        (w.decoration?.labelText == 'Mig/os' ||
            w.decoration?.labelText == 'Modstander'));
    await tester.enterText(scoreFields.at(0), '15');
    await tester.enterText(scoreFields.at(1), '10');
    await tester.tap(find.text('Gem'));
    await tester.pumpAndSettle();

    // Ingen advarsel om pointsystemet for en træningskamp.
    expect(find.text('Usædvanligt resultat'), findsNothing);
    expect((await store.load()).matches.single.practice, isTrue);

    // Oversigten tæller den ikke med.
    expect(find.text('100 %'), findsNothing);
    expect(find.text('0 vundet · 0 tabt'), findsOneWidget);

    // Kamplisten viser den som træningskamp.
    await tester.tap(navItem('Kampe'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Træningskamp'), findsOneWidget);

    // Statistik: kun med når filteret er slået til.
    await tester.tap(navItem('Statistik'));
    await tester.pumpAndSettle();
    expect(find.text('100 %'), findsNothing);
    await tester.tap(find.text('Medtag træningskampe'));
    await tester.pumpAndSettle();
    expect(find.text('100 %'), findsWidgets);
  });

  testWidgets('technique tab: stroke, drill and log the drill',
      (tester) async {
    final store = MemoryStore(onePlayer());
    await tester.pumpWidget(BadmintonApp(store: store));
    await tester.pumpAndSettle();

    await tester.tap(navItem('Teknik'));
    await tester.pumpAndSettle();
    expect(find.text('Greb'), findsOneWidget);
    expect(find.text('Kort serv'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Clear'), 200,
        scrollable: find.byType(Scrollable).last);
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    expect(find.text('Teknikpunkter'), findsOneWidget);
    expect(find.text('Ikke trænet endnu'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Clear-duel'), 200,
        scrollable: find.byType(Scrollable).last);
    await tester.tap(find.text('Clear-duel'));
    await tester.pumpAndSettle();
    expect(find.text('Sådan gør du'), findsOneWidget);

    await tester.tap(find.text('Log denne øvelse'));
    await tester.pumpAndSettle();
    expect(find.text('Nyt træningspas'), findsOneWidget);
    final clearChip =
        tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'Clear'));
    expect(clearChip.selected, isTrue);
    await tester.tap(find.text('Gem'));
    await tester.pumpAndSettle();

    final saved = (await store.load()).trainings.single;
    expect(saved.drillIds, ['clear_duel']);
    expect(saved.techniqueIds, containsAll(['clear', 'split_step']));
    expect(saved.durationMinutes, 10);

    // Tilbage på slaget kan man se, at det er trænet.
    await tester.tap(find.byTooltip('Tilbage'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.textContaining('Sidst trænet'), -200,
        scrollable: find.byType(Scrollable).last);
    expect(find.textContaining('Sidst trænet'), findsOneWidget);
    expect(find.text('Ikke trænet endnu'), findsNothing);
  });

  testWidgets('goals are created from the overview', (tester) async {
    final store = MemoryStore(onePlayer());
    await tester.pumpWidget(BadmintonApp(store: store));
    await tester.pumpAndSettle();

    expect(navItem('Mål'), findsNothing);
    expect(find.text('Sæt et mål, fx 3 træningspas om ugen.'), findsOneWidget);
    await tester.tap(find.text('Nyt mål'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gem'));
    await tester.pumpAndSettle();

    expect(find.text('3 pas om ugen'), findsOneWidget);
    expect((await store.load()).goals, hasLength(1));
  });

  testWidgets('rules tab shows the 3x15 rules', (tester) async {
    // Højt vindue som en telefon, så sektionerne kan ses uden at scrolle.
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final store = MemoryStore(onePlayer());
    await tester.pumpWidget(BadmintonApp(store: store));
    await tester.pumpAndSettle();

    await tester.tap(navItem('Teknik'));
    await tester.pumpAndSettle();
    // Fanerne kan scrolles; testskriften er bredere end rigtig skrift.
    await tester.ensureVisible(find.widgetWithText(Tab, 'Regler'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(Tab, 'Regler'));
    await tester.pumpAndSettle();

    expect(find.textContaining('3×15 i alle kampe fra 1. juli 2026'),
        findsOneWidget);
    // Pointsystemet er foldet ud, de andre sektioner er lukkede.
    expect(find.textContaining('Ved 14-14'), findsOneWidget);
    expect(find.textContaining('under 1,15 m'), findsNothing);
    await tester.tap(find.text('Serv'));
    await tester.pumpAndSettle();
    expect(find.textContaining('under 1,15 m'), findsOneWidget);
  });

  testWidgets('web install hint is hidden outside the browser',
      (tester) async {
    await tester.pumpWidget(BadmintonApp(store: MemoryStore()));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.add_to_home_screen), findsNothing);

    // Med force vises tippet (sådan ser det ud i webudgaven).
    await tester.pumpWidget(const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: WebInstallHint(force: true)),
    ));
    await tester.pumpAndSettle();
    expect(find.textContaining('Føj til hjemmeskærm'), findsOneWidget);
  });
}

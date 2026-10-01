import 'dart:convert';

import 'package:badminton_app/data/backup.dart';
import 'package:badminton_app/data/backup_files.dart';
import 'package:badminton_app/data/coach_client.dart';
import 'package:badminton_app/data/data_store.dart';
import 'package:badminton_app/data/live_match_store.dart';
import 'package:badminton_app/l10n/app_localizations.dart';
import 'package:badminton_app/main.dart';
import 'package:badminton_app/models/models.dart';
import 'package:badminton_app/ui/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    // Listen (ikke søgefeltet, som også kan scrolles).
    await tester.scrollUntilVisible(find.text('Clear'), 200,
        scrollable: find
            .ancestor(of: find.text('Greb'), matching: find.byType(Scrollable))
            .first);
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

  testWidgets('AI coach: add key, recover from an error, get an answer',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final requests = <http.Request>[];
    var keyWorks = false;
    final coach = CoachService(
      client: MockClient((request) async {
        requests.add(request);
        if (!keyWorks) {
          return http.Response(
              jsonEncode({
                'type': 'error',
                'error': {
                  'type': 'authentication_error',
                  'message': 'invalid x-api-key',
                },
              }),
              401);
        }
        return http.Response.bytes(
            utf8.encode(jsonEncode({
              'content': [
                {'type': 'text', 'text': 'Start med 10 minutters opvarmning.'},
              ],
              'stop_reason': 'end_turn',
            })),
            200);
      }),
    );
    await tester.pumpWidget(
        BadmintonApp(store: MemoryStore(onePlayer()), coach: coach));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('AI-træner'));
    await tester.pumpAndSettle();
    expect(find.text('Brug en AI som træner'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'sk-ant-test');
    await tester.tap(find.text('Gem nøgle'));
    await tester.pumpAndSettle();
    expect(await coach.loadApiKey(), 'sk-ant-test');

    // Første forsøg fejler: fejlen vises, og spørgsmålet ligger i feltet igen.
    await tester.tap(find.text('Foreslå et træningspas'));
    await tester.pumpAndSettle();
    expect(find.textContaining('API-nøglen virker ikke'), findsOneWidget);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, startsWith('Foreslå et træningspas til mig'));

    keyWorks = true;
    await tester.tap(find.byTooltip('Send'));
    await tester.pumpAndSettle();
    expect(find.text('Start med 10 minutters opvarmning.'), findsOneWidget);
    expect(find.textContaining('API-nøglen virker ikke'), findsNothing);

    expect(requests.last.headers['x-api-key'], 'sk-ant-test');
    final body = jsonDecode(requests.last.body) as Map<String, dynamic>;
    expect(body['system'][1]['text'], contains('Spiller: Mette'));
    expect(body['messages'], hasLength(1));
  });

  testWidgets('AI coach: plan can be logged and the chat is kept',
      (tester) async {
    SharedPreferences.setMockInitialValues({'coach_api_key': 'sk-ant-test'});
    final coach = CoachService(
      client: MockClient((request) async => http.Response.bytes(
          utf8.encode(jsonEncode({
            'content': [
              {
                'type': 'text',
                'text': 'Forslag:\n- Opvarmning (10 min)\n'
                    '- Clear-duel (15 min)\n- Nedvarmning (5 min)',
              },
            ],
            'stop_reason': 'end_turn',
          })),
          200)),
    );
    final store = MemoryStore(onePlayer());
    await tester.pumpWidget(BadmintonApp(store: store, coach: coach));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('AI-træner'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Foreslå et træningspas'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Clear-duel (15 min)'), findsOneWidget);

    // Samtalen er der stadig, når skærmen åbnes igen.
    await tester.tap(find.byTooltip('Tilbage'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('AI-træner'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Clear-duel (15 min)'), findsOneWidget);

    await tester.tap(find.text('Log som træningspas'));
    await tester.pumpAndSettle();
    expect(find.text('Nyt træningspas'), findsOneWidget);
    await tester.tap(find.text('Gem'));
    await tester.pumpAndSettle();
    final saved = (await store.load()).trainings.single;
    expect(saved.drillIds, ['clear_duel']);
    expect(saved.durationMinutes, 30);

    // Ny samtale sletter den gemte samtale.
    await tester.tap(find.byTooltip('Vis menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ny samtale'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Clear-duel (15 min)'), findsNothing);
    expect(await coach.loadChat('p'), isNull);
  });

  testWidgets('live score: count a match, undo, and save it', (tester) async {
    final semantics = tester.ensureSemantics();
    SharedPreferences.setMockInitialValues({});
    final store = MemoryStore(onePlayer());
    await tester.pumpWidget(BadmintonApp(store: store));
    await tester.pumpAndSettle();

    await tester.tap(navItem('Kampe'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kamptæller'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start kampen'));
    await tester.pumpAndSettle();

    final me = find.bySemanticsLabel(RegExp(r'^Mig \d+$'));
    final them = find.bySemanticsLabel(RegExp(r'^Modstander \d+$'));
    expect(find.text('Server · højre felt'), findsOneWidget);

    Future<void> points(Finder side, int n) async {
      for (var i = 0; i < n; i++) {
        await tester.tap(side);
        await tester.pump();
      }
    }

    await points(me, 8);
    expect(find.text('Pause: højst 60 sekunder.'), findsOneWidget);
    // Et forkert point fortrydes.
    await points(them, 1);
    await tester.tap(find.byTooltip('Fortryd sidste point'));
    await tester.pump();
    expect(find.bySemanticsLabel('Modstander 0'), findsOneWidget);

    // Kampen tælles stadig, hvis skærmen lukkes og åbnes igen.
    await tester.tap(find.byTooltip('Tilbage'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kamptæller'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Mig 8'), findsOneWidget);

    await points(me, 7); // 15-0
    expect(find.textContaining('Sættet er slut'), findsOneWidget);
    await points(me, 15); // 15-0, 15-0
    expect(find.textContaining('sejr 15-0, 15-0'), findsOneWidget);

    await tester.tap(find.text('Gem kampen'));
    await tester.pumpAndSettle();
    expect(find.text('Ny kamp'), findsOneWidget);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Modstander(e)'), 'Bo');
    await tester.tap(find.text('Gem'));
    await tester.pumpAndSettle();

    final saved = (await store.load()).matches.single;
    expect(saved.games.map((g) => (g.own, g.opponent)), [(15, 0), (15, 0)]);
    expect(saved.opponents, 'Bo');
    // Forløbet gemmes med kampen (det fortrudte point er ikke med).
    expect(saved.rallyLog!.sequence, 'u' * 30);
    expect(saved.rallyLog!.system, 'to15');
    // Tilbage på Kampe-fanen, og den gemte tælling er ryddet.
    expect(find.text('Kamptæller'), findsOneWidget);
    expect(await const LiveMatchStore().load('p'), isNull);
    expect(find.textContaining('Talt med kamptælleren'), findsOneWidget);

    // Statistik viser kampforløbet.
    await tester.tap(navItem('Statistik'));
    await tester.pumpAndSettle();
    final section = find.text('Kampforløb');
    await tester.scrollUntilVisible(section, 300,
        scrollable: find.byType(Scrollable).first);
    expect(find.textContaining('Vundne dueller i 1 kamp'), findsOneWidget);
    expect(find.text('Egen serv'), findsOneWidget);
    expect(find.text('30 af 30 dueller'), findsOneWidget);

    // Rettes resultatet bagefter, passer forløbet ikke længere og droppes.
    await tester.tap(navItem('Kampe'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('mod Bo'));
    await tester.pumpAndSettle();
    final theirScore = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Modstander');
    await tester.enterText(theirScore.first, '3'); // 15-3
    await tester.tap(find.text('Gem'));
    await tester.pumpAndSettle();
    final edited = (await store.load()).matches.single;
    expect(edited.games.first, const GameScore(15, 3));
    expect(edited.rallyLog, isNull);
    semantics.dispose();
  });

  testWidgets('drills: search, filter and start the timer', (tester) async {
    final store = MemoryStore(onePlayer());
    await tester.pumpWidget(BadmintonApp(store: store));
    await tester.pumpAndSettle();

    await tester.tap(navItem('Teknik'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.widgetWithText(Tab, 'Øvelser'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(Tab, 'Øvelser'));
    await tester.pumpAndSettle();
    expect(find.text('Clear-duel'), findsOneWidget);

    // Filteret "Alene" fjerner øvelser, der kræver en makker.
    await tester.tap(find.widgetWithText(FilterChip, 'Alene'));
    await tester.pumpAndSettle();
    expect(find.text('Clear-duel'), findsNothing);
    expect(find.text('Serv på mål'), findsOneWidget);

    // Søgning.
    await tester.enterText(find.widgetWithText(TextField, 'Søg'), 'stige');
    await tester.pumpAndSettle();
    expect(find.text('Stigeøvelse: afsæt-1-2'), findsOneWidget);
    expect(find.text('Serv på mål'), findsNothing);

    await tester.tap(find.text('Stigeøvelse: afsæt-1-2'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start timer'));
    // Timeren tikker hele tiden, så pumpAndSettle ville aldrig blive færdig.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Gør klar'), findsOneWidget);
    expect(find.text('20 sek. arbejde, 40 sek. pause, 6 runder'),
        findsOneWidget);
    await tester.tap(find.byTooltip('Sæt på pause'));
    await tester.pump();
    expect(find.byTooltip('Fortsæt'), findsOneWidget);
    await tester.tap(find.byTooltip('Tilbage'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Gør klar'), findsNothing);
  });

  testWidgets('player profile: level and left hand are saved and used',
      (tester) async {
    final store = MemoryStore(onePlayer());
    await tester.pumpWidget(BadmintonApp(store: store));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Aktiv spiller'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Administrér spillere'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Rediger spiller'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ikke valgt'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Begynder').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Venstrehåndet'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gem'));
    await tester.pumpAndSettle();

    final player = (await store.load()).players.single;
    expect(player.level, PlayerLevel.beginner);
    expect(player.leftHanded, isTrue);
    expect(find.text('Aktiv spiller · Begynder · Venstrehåndet'),
        findsOneWidget);

    await tester.tap(find.byTooltip('Tilbage'));
    await tester.pumpAndSettle();
    await tester.tap(navItem('Teknik'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Du skal spejle dem'), findsOneWidget);

    // Øvelserne starter på spillerens niveau.
    await tester.ensureVisible(find.widgetWithText(Tab, 'Øvelser'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(Tab, 'Øvelser'));
    await tester.pumpAndSettle();
    final chip = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, 'Begynder'));
    expect(chip.selected, isTrue);
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

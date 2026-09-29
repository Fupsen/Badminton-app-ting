import 'package:badminton_app/data/data_store.dart';
import 'package:badminton_app/main.dart';
import 'package:badminton_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
}

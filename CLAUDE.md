# CLAUDE.md

## Brugeren

- Skriv og svar på **dansk**.
- Brugeren vil have, at du **siger fra, når du er uenig, og forklarer hvorfor**.
  Gør det tydeligt og tidligt, også om brugerens egne idéer.
- Stil spørgsmål, når kravene er uklare. Giv en anbefaling i stedet for en
  lang liste af muligheder.
- Indholdet skal passe til **alle niveauer**: begynder, klubspiller, elite og
  trænere for børn og unge.

## Badminton-viden

- **Læs de relevante filer i `docs/viden/`**, før du skriver badminton-indhold
  (fx `lib/content/technique_da.dart`, pointregler, øvelser) eller svarer på
  spørgsmål om badminton. Start i `docs/viden/README.md`.
- Følg kilderne dér frem for din egen hukommelse. Reglerne ændrer sig:
  **3×15 gælder i Danmark fra 1. juli 2026 og hos BWF fra 4. januar 2027.**
- Mangler der viden, eller er noget forældet: research i primære kilder (BWF,
  Badminton Danmark, Team Danmark, forskning), og **opdatér vidensbanken** med
  kilde, dato og niveau-markering. Skriv tydeligt, når noget er praksis eller
  tolkning.
- Appens indhold og vidensbanken skal stemme overens. Ændrer du det ene, så
  tjek det andet.
- Højrehåndet spiller er standard i beskrivelserne. Ingen lægefaglige råd ud
  over at henvise til læge eller fysioterapeut.

## Projektet

Flutter-app (Android, iOS, Windows, macOS, Linux) med én kodebase og dansk
UI. Se `README.md` for funktioner.

```
lib/models   datamodeller + JSON (nye felter skal være valgfrie, så gamle
             data og backups kan læses)
lib/data     DataStore (lokal JSON-fil), backup-format, fildialoger,
             coach_client.dart (AI-træner: Claude API med brugerens egen
             nøgle, kaldt direkte fra appen, også på web)
lib/state    AppState (ChangeNotifier)
lib/logic    ren Dart: pointregler (scoring.dart), statistik, mål,
             coach_context.dart (spillerdata til AI-træneren)
lib/content  teknik-bibliotek (technique*.dart; id'er må ikke ændres),
             regler (rules*.dart, skal stemme med docs/viden/regler.md) og
             AI-trænerens instruktioner (coach_da.dart)
lib/ui       skærme og widgets
lib/l10n     app_da.arb (alle UI-tekster) + genereret kode
docs/viden   badminton-vidensbank med kilder. Pakkes med i appen og sendes
             til AI-træneren (listen står i coach_da.dart)
```

## Udgivelse

- **iPhone:** webudgave (PWA) på GitHub Pages, bygget af
  `.github/workflows/web.yml` ved push til `main`. Web bruger
  `SharedPreferencesStore` og `WebBackupFiles` (se `lib/main.dart`). Undgå
  `dart:io` i kode, der kører på web, og husk, at bitoperationer er 32-bit i
  browseren (fx er `1 << 32` lig 0).
- **Windows:** `.github/workflows/release.yml` (manuel) bygger en zip til
  Releases.

## Kommandoer

```bash
flutter pub get
flutter gen-l10n        # efter ændringer i lib/l10n/app_da.arb
flutter analyze         # skal give "No issues found!"
flutter test            # alle tests skal bestå
flutter build web --release --no-web-resources-cdn --base-href /Badminton-app-ting/
```

- UI-tekster skrives aldrig direkte i koden. De ligger i `app_da.arb`.
- Kør kun `dart format` på filer, du selv ændrer, så diffen ikke svulmer op.
- Nye funktioner skal have tests (logik i `test/logic_test.dart`, indhold i
  `test/content_test.dart`, UI-flows i `test/app_test.dart`).

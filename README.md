# Badminton-logbog

En app til badmintonspillere og trænere: log kampe og træningspas, sæt mål
og følg udviklingen med statistik. Skrevet i Flutter, så **én kodebase**
kører på Android, iOS, Windows, macOS og Linux.

| Oversigt (mobil) | Kamp (mobil) | Statistik (computer) |
| --- | --- | --- |
| ![](docs/screenshots/oversigt-mobil.png) | ![](docs/screenshots/kamp-mobil.png) | ![](docs/screenshots/statistik-desktop.png) |

## Funktioner

- **Spillere**: Bruger du appen selv, har du én profil. Er du træner, kan du
  oprette flere, skifte mellem dem og sammenligne dem i en tabel.
- **Kampe**: single/double/mixed, modstander(e), makker og sætresultater.
  Resultatet tjekkes mod BWF-reglerne (til 21 med 2 points forspring, maks.
  30, bedst af 3). Et afvigende resultat, fx til 15 til træning, giver en
  advarsel men kan stadig gemmes.
- **Træning**: dato, varighed, type (teknik, fysisk, kamptræning,
  footwork, andet), intensitet 1–5 og noter.
- **Mål**: træningspas pr. uge, træningsminutter pr. uge eller sejrsprocent,
  med fremskridtsbjælke.
- **Statistik**: sejrsprocent samlet og pr. kamptype, træningsminutter pr.
  uge (12 uger, fordelt på type), form over de seneste 10 kampe, aktuel og
  længste stime, pointforskel pr. kamp og resultater mod hver modstander.
- **Backup og gendannelse**: eksportér alle data til en JSON-fil og
  importér den igen. Du kan flette filen ind eller erstatte alt. Oversigten
  minder dig om at tage backup, hvis det er over 30 dage siden.
- **Responsivt layout**: bundnavigation på telefon og sidemenu på bredere
  skærme.

## Kom i gang

Kræver [Flutter](https://docs.flutter.dev/get-started/install) 3.47 eller nyere.

```bash
flutter pub get
flutter run              # vælg en tilsluttet enhed/emulator
flutter run -d windows   # eller macos / linux
flutter test
```

Byg til de enkelte platforme med `flutter build apk`, `flutter build ios`,
`flutter build windows`, `flutter build macos` eller `flutter build linux`.
iOS- og macOS-builds kræver en Mac med Xcode, og Windows-builds kræver
Windows.

## Opbygning

```
lib/
  models/      Datamodeller (spiller, kamp, træning, mål) med JSON
  data/        DataStore (lokal JSON-fil), backup-format og fildialoger
  state/       AppState (ChangeNotifier) som skærmene lytter på
  logic/       Ren Dart: pointregler, statistik og mål (unit-testet)
  ui/          Skærme og widgets
  l10n/        Tekster (app_da.arb) og genereret oversættelseskode
```

### Data

Alt gemmes lokalt i én JSON-fil i appens support-mappe. Data synkroniseres
ikke automatisk, så **tag backup jævnligt** via spiller-menuen →
*Backup og gendannelse*:

- **Eksportér**: på computeren vælger du, hvor filen gemmes. På telefonen
  åbner delingsmenuen, så du kan gemme i Filer, sende på mail, lægge i Drev
  osv.
- **Importér**: vælg en backup-fil. *Flet ind* tilføjer det, der mangler,
  uden at slette noget. *Erstat alt* overskriver alle data på enheden.
- **Ny telefon**: tryk på *Gendan fra backup* på velkomstskærmen.
- **Flyt data mellem enheder**: eksportér på den ene enhed og importér med
  *Flet ind* på den anden.

![Backup](docs/screenshots/backup-desktop.png)

Cloud-sync er planlagt. Det tilføjes ved at lave en ny implementation af
`DataStore` i `lib/data/data_store.dart`, uden at skærmene skal ændres.

### Sprog

Appen er på dansk. Alle tekster ligger i `lib/l10n/app_da.arb`. Engelsk
tilføjes ved at oprette `lib/l10n/app_en.arb` med de samme nøgler, køre
`flutter gen-l10n` og fjerne den faste `locale` i `lib/main.dart`.

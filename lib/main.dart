import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'data/backup_files.dart';
import 'data/coach_client.dart';
import 'data/data_store.dart';
import 'l10n/app_localizations.dart';
import 'state/app_state.dart';
import 'ui/home_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    kIsWeb
        // I browseren er der intet filsystem.
        ? BadmintonApp(
            store: SharedPreferencesStore(),
            backupFiles: const WebBackupFiles(),
          )
        : BadmintonApp(store: JsonFileStore()),
  );
}

class BadmintonApp extends StatelessWidget {
  const BadmintonApp({
    super.key,
    required this.store,
    this.backupFiles = const PlatformBackupFiles(),
    this.coach,
  });

  final DataStore store;
  final BackupFiles backupFiles;

  /// AI-træneren. Tests giver en med en falsk HTTP-klient.
  final CoachService? coach;

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF1B7F5B);
    return MultiProvider(
      providers: [
        Provider<BackupFiles>.value(value: backupFiles),
        Provider<CoachService>(create: (_) => coach ?? CoachService()),
        ChangeNotifierProvider(create: (_) => AppState(store)..load()),
      ],
      child: MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        // Kun dansk indtil videre. Engelsk tilføjes ved at lægge en
        // app_en.arb ved siden af app_da.arb.
        locale: const Locale('da'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: seed),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: seed,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const HomeShell(),
      ),
    );
  }
}

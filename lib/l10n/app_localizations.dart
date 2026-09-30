import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_da.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('da')];

  /// No description provided for @appTitle.
  ///
  /// In da, this message translates to:
  /// **'Badminton-logbog'**
  String get appTitle;

  /// No description provided for @navOverview.
  ///
  /// In da, this message translates to:
  /// **'Oversigt'**
  String get navOverview;

  /// No description provided for @navMatches.
  ///
  /// In da, this message translates to:
  /// **'Kampe'**
  String get navMatches;

  /// No description provided for @navTraining.
  ///
  /// In da, this message translates to:
  /// **'Træning'**
  String get navTraining;

  /// No description provided for @navStats.
  ///
  /// In da, this message translates to:
  /// **'Statistik'**
  String get navStats;

  /// No description provided for @welcomeTitle.
  ///
  /// In da, this message translates to:
  /// **'Velkommen til Badminton-logbog'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In da, this message translates to:
  /// **'Log dine kampe og træningspas, sæt mål og følg din udvikling. Er du træner, kan du oprette flere spillere bagefter.'**
  String get welcomeBody;

  /// No description provided for @welcomeNameLabel.
  ///
  /// In da, this message translates to:
  /// **'Dit navn'**
  String get welcomeNameLabel;

  /// No description provided for @welcomeStart.
  ///
  /// In da, this message translates to:
  /// **'Kom i gang'**
  String get welcomeStart;

  /// No description provided for @save.
  ///
  /// In da, this message translates to:
  /// **'Gem'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In da, this message translates to:
  /// **'Annullér'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In da, this message translates to:
  /// **'Slet'**
  String get delete;

  /// No description provided for @saveAnyway.
  ///
  /// In da, this message translates to:
  /// **'Gem alligevel'**
  String get saveAnyway;

  /// No description provided for @notesLabel.
  ///
  /// In da, this message translates to:
  /// **'Noter'**
  String get notesLabel;

  /// No description provided for @dateLabel.
  ///
  /// In da, this message translates to:
  /// **'Dato'**
  String get dateLabel;

  /// No description provided for @fieldRequired.
  ///
  /// In da, this message translates to:
  /// **'Skal udfyldes'**
  String get fieldRequired;

  /// No description provided for @invalidNumber.
  ///
  /// In da, this message translates to:
  /// **'Skriv et helt tal større end 0'**
  String get invalidNumber;

  /// No description provided for @saveFailed.
  ///
  /// In da, this message translates to:
  /// **'Kunne ikke gemme data: {error}'**
  String saveFailed(String error);

  /// No description provided for @playersTitle.
  ///
  /// In da, this message translates to:
  /// **'Spillere'**
  String get playersTitle;

  /// No description provided for @managePlayers.
  ///
  /// In da, this message translates to:
  /// **'Administrér spillere'**
  String get managePlayers;

  /// No description provided for @addPlayer.
  ///
  /// In da, this message translates to:
  /// **'Tilføj spiller'**
  String get addPlayer;

  /// No description provided for @renamePlayer.
  ///
  /// In da, this message translates to:
  /// **'Omdøb spiller'**
  String get renamePlayer;

  /// No description provided for @playerNameLabel.
  ///
  /// In da, this message translates to:
  /// **'Navn'**
  String get playerNameLabel;

  /// No description provided for @activePlayer.
  ///
  /// In da, this message translates to:
  /// **'Aktiv spiller'**
  String get activePlayer;

  /// No description provided for @deletePlayerTitle.
  ///
  /// In da, this message translates to:
  /// **'Slet {name}?'**
  String deletePlayerTitle(String name);

  /// No description provided for @deletePlayerBody.
  ///
  /// In da, this message translates to:
  /// **'Alle kampe, træningspas og mål for spilleren bliver også slettet. Det kan ikke fortrydes.'**
  String get deletePlayerBody;

  /// No description provided for @comparePlayers.
  ///
  /// In da, this message translates to:
  /// **'Sammenlign spillere'**
  String get comparePlayers;

  /// No description provided for @compareTitle.
  ///
  /// In da, this message translates to:
  /// **'Sammenligning'**
  String get compareTitle;

  /// No description provided for @compareColPlayer.
  ///
  /// In da, this message translates to:
  /// **'Spiller'**
  String get compareColPlayer;

  /// No description provided for @compareColMatches.
  ///
  /// In da, this message translates to:
  /// **'Kampe'**
  String get compareColMatches;

  /// No description provided for @compareColWinRate.
  ///
  /// In da, this message translates to:
  /// **'Sejr %'**
  String get compareColWinRate;

  /// No description provided for @compareColTraining4w.
  ///
  /// In da, this message translates to:
  /// **'Træning (4 uger)'**
  String get compareColTraining4w;

  /// No description provided for @compareColSessions4w.
  ///
  /// In da, this message translates to:
  /// **'Pas (4 uger)'**
  String get compareColSessions4w;

  /// No description provided for @compareColForm.
  ///
  /// In da, this message translates to:
  /// **'Form (seneste 5)'**
  String get compareColForm;

  /// No description provided for @matchTypeSingle.
  ///
  /// In da, this message translates to:
  /// **'Single'**
  String get matchTypeSingle;

  /// No description provided for @matchTypeDouble.
  ///
  /// In da, this message translates to:
  /// **'Double'**
  String get matchTypeDouble;

  /// No description provided for @matchTypeMixed.
  ///
  /// In da, this message translates to:
  /// **'Mixed'**
  String get matchTypeMixed;

  /// No description provided for @newMatch.
  ///
  /// In da, this message translates to:
  /// **'Ny kamp'**
  String get newMatch;

  /// No description provided for @editMatch.
  ///
  /// In da, this message translates to:
  /// **'Redigér kamp'**
  String get editMatch;

  /// No description provided for @deleteMatchTitle.
  ///
  /// In da, this message translates to:
  /// **'Slet kampen?'**
  String get deleteMatchTitle;

  /// No description provided for @opponentsLabel.
  ///
  /// In da, this message translates to:
  /// **'Modstander(e)'**
  String get opponentsLabel;

  /// No description provided for @partnerLabel.
  ///
  /// In da, this message translates to:
  /// **'Makker'**
  String get partnerLabel;

  /// No description provided for @gameLabel.
  ///
  /// In da, this message translates to:
  /// **'{number}. sæt'**
  String gameLabel(int number);

  /// No description provided for @ownPoints.
  ///
  /// In da, this message translates to:
  /// **'Mig/os'**
  String get ownPoints;

  /// No description provided for @opponentPoints.
  ///
  /// In da, this message translates to:
  /// **'Modstander'**
  String get opponentPoints;

  /// No description provided for @optionalThirdGame.
  ///
  /// In da, this message translates to:
  /// **'3. sæt spilles kun ved 1-1 i sæt'**
  String get optionalThirdGame;

  /// No description provided for @scoreErrorNoGames.
  ///
  /// In da, this message translates to:
  /// **'Indtast mindst ét sæt.'**
  String get scoreErrorNoGames;

  /// No description provided for @scoreErrorTiedGame.
  ///
  /// In da, this message translates to:
  /// **'Et sæt kan ikke ende uafgjort.'**
  String get scoreErrorTiedGame;

  /// No description provided for @scoreErrorNoWinner.
  ///
  /// In da, this message translates to:
  /// **'Kampen skal have en vinder (flest vundne sæt).'**
  String get scoreErrorNoWinner;

  /// No description provided for @scoreWarningTitle.
  ///
  /// In da, this message translates to:
  /// **'Usædvanligt resultat'**
  String get scoreWarningTitle;

  /// No description provided for @scoreWarningGame.
  ///
  /// In da, this message translates to:
  /// **'Sættene følger ikke et officielt pointsystem: til 15 (ved 14-14 vinder man med 2, maks. 21) eller til 21 (ved 20-20 vinder man med 2, maks. 30). Alle sæt i en kamp skal følge samme system.'**
  String get scoreWarningGame;

  /// No description provided for @scoreWarningGameCount.
  ///
  /// In da, this message translates to:
  /// **'En officiel kamp er bedst af 3 sæt og slutter, når én side har vundet 2.'**
  String get scoreWarningGameCount;

  /// No description provided for @scoreWarningFooter.
  ///
  /// In da, this message translates to:
  /// **'Det er fint, hvis I fx har spillet til 11 til træning. Så kan du også markere kampen som træningskamp. Vil du gemme alligevel?'**
  String get scoreWarningFooter;

  /// No description provided for @matchVs.
  ///
  /// In da, this message translates to:
  /// **'mod {opponents}'**
  String matchVs(String opponents);

  /// No description provided for @matchWithPartner.
  ///
  /// In da, this message translates to:
  /// **'med {partner}'**
  String matchWithPartner(String partner);

  /// No description provided for @resultWonShort.
  ///
  /// In da, this message translates to:
  /// **'V'**
  String get resultWonShort;

  /// No description provided for @resultLostShort.
  ///
  /// In da, this message translates to:
  /// **'T'**
  String get resultLostShort;

  /// No description provided for @noMatches.
  ///
  /// In da, this message translates to:
  /// **'Ingen kampe endnu. Tryk på + for at logge din første kamp.'**
  String get noMatches;

  /// No description provided for @unknownOpponent.
  ///
  /// In da, this message translates to:
  /// **'ukendt modstander'**
  String get unknownOpponent;

  /// No description provided for @trainingTypeTechnique.
  ///
  /// In da, this message translates to:
  /// **'Teknik'**
  String get trainingTypeTechnique;

  /// No description provided for @trainingTypePhysical.
  ///
  /// In da, this message translates to:
  /// **'Fysisk'**
  String get trainingTypePhysical;

  /// No description provided for @trainingTypeMatchPlay.
  ///
  /// In da, this message translates to:
  /// **'Kamptræning'**
  String get trainingTypeMatchPlay;

  /// No description provided for @trainingTypeFootwork.
  ///
  /// In da, this message translates to:
  /// **'Footwork'**
  String get trainingTypeFootwork;

  /// No description provided for @trainingTypeOther.
  ///
  /// In da, this message translates to:
  /// **'Andet'**
  String get trainingTypeOther;

  /// No description provided for @newTraining.
  ///
  /// In da, this message translates to:
  /// **'Nyt træningspas'**
  String get newTraining;

  /// No description provided for @editTraining.
  ///
  /// In da, this message translates to:
  /// **'Redigér træningspas'**
  String get editTraining;

  /// No description provided for @deleteTrainingTitle.
  ///
  /// In da, this message translates to:
  /// **'Slet træningspasset?'**
  String get deleteTrainingTitle;

  /// No description provided for @durationLabel.
  ///
  /// In da, this message translates to:
  /// **'Varighed (minutter)'**
  String get durationLabel;

  /// No description provided for @trainingTypeLabel.
  ///
  /// In da, this message translates to:
  /// **'Type'**
  String get trainingTypeLabel;

  /// No description provided for @intensityLabel.
  ///
  /// In da, this message translates to:
  /// **'Intensitet'**
  String get intensityLabel;

  /// No description provided for @intensity1.
  ///
  /// In da, this message translates to:
  /// **'Meget let'**
  String get intensity1;

  /// No description provided for @intensity2.
  ///
  /// In da, this message translates to:
  /// **'Let'**
  String get intensity2;

  /// No description provided for @intensity3.
  ///
  /// In da, this message translates to:
  /// **'Moderat'**
  String get intensity3;

  /// No description provided for @intensity4.
  ///
  /// In da, this message translates to:
  /// **'Hård'**
  String get intensity4;

  /// No description provided for @intensity5.
  ///
  /// In da, this message translates to:
  /// **'Maksimal'**
  String get intensity5;

  /// No description provided for @minutesShort.
  ///
  /// In da, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @intensityShort.
  ///
  /// In da, this message translates to:
  /// **'intensitet {value}/5'**
  String intensityShort(int value);

  /// No description provided for @thisWeekSummary.
  ///
  /// In da, this message translates to:
  /// **'Denne uge: {sessions, plural, =1{1 pas} other{{sessions} pas}} · {minutes} min'**
  String thisWeekSummary(int sessions, int minutes);

  /// No description provided for @noTrainings.
  ///
  /// In da, this message translates to:
  /// **'Ingen træningspas endnu. Tryk på + for at logge dit første.'**
  String get noTrainings;

  /// No description provided for @goalTypeSessionsPerWeek.
  ///
  /// In da, this message translates to:
  /// **'Træningspas pr. uge'**
  String get goalTypeSessionsPerWeek;

  /// No description provided for @goalTypeMinutesPerWeek.
  ///
  /// In da, this message translates to:
  /// **'Træningsminutter pr. uge'**
  String get goalTypeMinutesPerWeek;

  /// No description provided for @goalTypeWinRate.
  ///
  /// In da, this message translates to:
  /// **'Sejrsprocent'**
  String get goalTypeWinRate;

  /// No description provided for @newGoal.
  ///
  /// In da, this message translates to:
  /// **'Nyt mål'**
  String get newGoal;

  /// No description provided for @editGoal.
  ///
  /// In da, this message translates to:
  /// **'Redigér mål'**
  String get editGoal;

  /// No description provided for @deleteGoalTitle.
  ///
  /// In da, this message translates to:
  /// **'Slet målet?'**
  String get deleteGoalTitle;

  /// No description provided for @goalTypeLabel.
  ///
  /// In da, this message translates to:
  /// **'Type mål'**
  String get goalTypeLabel;

  /// No description provided for @goalTargetLabel.
  ///
  /// In da, this message translates to:
  /// **'Mål'**
  String get goalTargetLabel;

  /// No description provided for @goalWinRateRange.
  ///
  /// In da, this message translates to:
  /// **'Skriv et tal mellem 1 og 100'**
  String get goalWinRateRange;

  /// No description provided for @goalProgressSessions.
  ///
  /// In da, this message translates to:
  /// **'{current} af {target} pas denne uge'**
  String goalProgressSessions(int current, int target);

  /// No description provided for @goalProgressMinutes.
  ///
  /// In da, this message translates to:
  /// **'{current} af {target} min denne uge'**
  String goalProgressMinutes(int current, int target);

  /// No description provided for @goalProgressWinRate.
  ///
  /// In da, this message translates to:
  /// **'{current} % sejre siden {date} (mål {target} %)'**
  String goalProgressWinRate(int current, int target, String date);

  /// No description provided for @goalNoMatchesYet.
  ///
  /// In da, this message translates to:
  /// **'Ingen kampe siden {date} (mål {target} %)'**
  String goalNoMatchesYet(int target, String date);

  /// No description provided for @goalReached.
  ///
  /// In da, this message translates to:
  /// **'Nået!'**
  String get goalReached;

  /// No description provided for @goalTargetSessions.
  ///
  /// In da, this message translates to:
  /// **'{target} pas om ugen'**
  String goalTargetSessions(int target);

  /// No description provided for @goalTargetMinutes.
  ///
  /// In da, this message translates to:
  /// **'{target} min om ugen'**
  String goalTargetMinutes(int target);

  /// No description provided for @goalTargetWinRate.
  ///
  /// In da, this message translates to:
  /// **'Vind {target} % af kampene'**
  String goalTargetWinRate(int target);

  /// No description provided for @logMatch.
  ///
  /// In da, this message translates to:
  /// **'Log kamp'**
  String get logMatch;

  /// No description provided for @logTraining.
  ///
  /// In da, this message translates to:
  /// **'Log træning'**
  String get logTraining;

  /// No description provided for @statWinRate.
  ///
  /// In da, this message translates to:
  /// **'Sejrsprocent'**
  String get statWinRate;

  /// No description provided for @statMatchesPlayed.
  ///
  /// In da, this message translates to:
  /// **'Kampe spillet'**
  String get statMatchesPlayed;

  /// No description provided for @statTraining7d.
  ///
  /// In da, this message translates to:
  /// **'Træning, 7 dage'**
  String get statTraining7d;

  /// No description provided for @statCurrentStreak.
  ///
  /// In da, this message translates to:
  /// **'Aktuel stime'**
  String get statCurrentStreak;

  /// No description provided for @streakWins.
  ///
  /// In da, this message translates to:
  /// **'{count, plural, =1{1 sejr} other{{count} sejre}}'**
  String streakWins(int count);

  /// No description provided for @streakLosses.
  ///
  /// In da, this message translates to:
  /// **'{count, plural, =1{1 nederlag} other{{count} nederlag}}'**
  String streakLosses(int count);

  /// No description provided for @noData.
  ///
  /// In da, this message translates to:
  /// **'–'**
  String get noData;

  /// No description provided for @recentForm.
  ///
  /// In da, this message translates to:
  /// **'Form'**
  String get recentForm;

  /// No description provided for @recentFormHint.
  ///
  /// In da, this message translates to:
  /// **'Seneste kampe, nyeste til venstre'**
  String get recentFormHint;

  /// No description provided for @yourGoals.
  ///
  /// In da, this message translates to:
  /// **'Dine mål'**
  String get yourGoals;

  /// No description provided for @statsWinRateSection.
  ///
  /// In da, this message translates to:
  /// **'Sejrsprocent'**
  String get statsWinRateSection;

  /// No description provided for @statsOverall.
  ///
  /// In da, this message translates to:
  /// **'Samlet'**
  String get statsOverall;

  /// No description provided for @statsWonLost.
  ///
  /// In da, this message translates to:
  /// **'{won} vundet · {lost} tabt'**
  String statsWonLost(int won, int lost);

  /// No description provided for @statsTrainingSection.
  ///
  /// In da, this message translates to:
  /// **'Træningsmængde'**
  String get statsTrainingSection;

  /// No description provided for @statsTrainingHint.
  ///
  /// In da, this message translates to:
  /// **'Minutter pr. uge de seneste 12 uger'**
  String get statsTrainingHint;

  /// No description provided for @statsWeekLabel.
  ///
  /// In da, this message translates to:
  /// **'Uge {week}'**
  String statsWeekLabel(int week);

  /// No description provided for @statsFormSection.
  ///
  /// In da, this message translates to:
  /// **'Form og stimer'**
  String get statsFormSection;

  /// No description provided for @statsLongestWinStreak.
  ///
  /// In da, this message translates to:
  /// **'Længste sejrsstime'**
  String get statsLongestWinStreak;

  /// No description provided for @statsPointDiff.
  ///
  /// In da, this message translates to:
  /// **'Pointforskel pr. kamp (seneste 20)'**
  String get statsPointDiff;

  /// No description provided for @statsOpponentsSection.
  ///
  /// In da, this message translates to:
  /// **'Mod modstandere'**
  String get statsOpponentsSection;

  /// No description provided for @statsNoMatches.
  ///
  /// In da, this message translates to:
  /// **'Log nogle kampe for at se statistik her.'**
  String get statsNoMatches;

  /// No description provided for @statsNoTraining.
  ///
  /// In da, this message translates to:
  /// **'Log nogle træningspas for at se udviklingen her.'**
  String get statsNoTraining;

  /// No description provided for @backupTitle.
  ///
  /// In da, this message translates to:
  /// **'Backup og gendannelse'**
  String get backupTitle;

  /// No description provided for @backupIntro.
  ///
  /// In da, this message translates to:
  /// **'Dine data ligger kun på denne enhed. Tag backup jævnligt, så du ikke mister dem, hvis telefonen bliver væk eller udskiftes. En backup kan også bruges til at flytte data mellem telefon og computer.'**
  String get backupIntro;

  /// No description provided for @backupLast.
  ///
  /// In da, this message translates to:
  /// **'Sidste backup: {date}'**
  String backupLast(String date);

  /// No description provided for @backupNever.
  ///
  /// In da, this message translates to:
  /// **'Der er endnu ikke taget backup på denne enhed.'**
  String get backupNever;

  /// No description provided for @backupExport.
  ///
  /// In da, this message translates to:
  /// **'Eksportér backup'**
  String get backupExport;

  /// No description provided for @backupExportHint.
  ///
  /// In da, this message translates to:
  /// **'Gem en fil med alle spillere, kampe, træningspas og mål.'**
  String get backupExportHint;

  /// No description provided for @backupExportDone.
  ///
  /// In da, this message translates to:
  /// **'Backup gemt'**
  String get backupExportDone;

  /// No description provided for @backupExportFailed.
  ///
  /// In da, this message translates to:
  /// **'Kunne ikke eksportere: {error}'**
  String backupExportFailed(String error);

  /// No description provided for @backupImport.
  ///
  /// In da, this message translates to:
  /// **'Importér backup'**
  String get backupImport;

  /// No description provided for @backupImportHint.
  ///
  /// In da, this message translates to:
  /// **'Hent data fra en backup-fil, fx fra din anden enhed.'**
  String get backupImportHint;

  /// No description provided for @backupImportTitle.
  ///
  /// In da, this message translates to:
  /// **'Importér backup?'**
  String get backupImportTitle;

  /// No description provided for @backupImportContains.
  ///
  /// In da, this message translates to:
  /// **'Filen indeholder {summary}.'**
  String backupImportContains(String summary);

  /// No description provided for @backupImportMergeInfo.
  ///
  /// In da, this message translates to:
  /// **'Flet ind: tilføjer det, der mangler, og opdaterer ændrede rækker. Intet bliver slettet.'**
  String get backupImportMergeInfo;

  /// No description provided for @backupImportReplaceInfo.
  ///
  /// In da, this message translates to:
  /// **'Erstat alt: sletter alle nuværende data på denne enhed og bruger kun filens.'**
  String get backupImportReplaceInfo;

  /// No description provided for @backupMerge.
  ///
  /// In da, this message translates to:
  /// **'Flet ind'**
  String get backupMerge;

  /// No description provided for @backupReplace.
  ///
  /// In da, this message translates to:
  /// **'Erstat alt'**
  String get backupReplace;

  /// No description provided for @backupReplaceConfirmTitle.
  ///
  /// In da, this message translates to:
  /// **'Erstat alle data?'**
  String get backupReplaceConfirmTitle;

  /// No description provided for @backupReplaceConfirmBody.
  ///
  /// In da, this message translates to:
  /// **'Alle nuværende spillere, kampe, træningspas og mål på denne enhed bliver slettet og erstattet af filens indhold. Det kan ikke fortrydes.'**
  String get backupReplaceConfirmBody;

  /// No description provided for @backupImportDone.
  ///
  /// In da, this message translates to:
  /// **'Backup indlæst'**
  String get backupImportDone;

  /// No description provided for @backupImportFailed.
  ///
  /// In da, this message translates to:
  /// **'Kunne ikke læse filen: {error}'**
  String backupImportFailed(String error);

  /// No description provided for @backupInvalidFile.
  ///
  /// In da, this message translates to:
  /// **'Filen er ikke en gyldig backup fra Badminton-logbog.'**
  String get backupInvalidFile;

  /// No description provided for @backupTooNew.
  ///
  /// In da, this message translates to:
  /// **'Backuppen er lavet med en nyere version af appen. Opdatér appen og prøv igen.'**
  String get backupTooNew;

  /// No description provided for @backupReminderNever.
  ///
  /// In da, this message translates to:
  /// **'Du har ikke taget backup endnu. Dine data findes kun på denne enhed.'**
  String get backupReminderNever;

  /// No description provided for @backupReminderOld.
  ///
  /// In da, this message translates to:
  /// **'Det er over 30 dage siden, du sidst tog backup.'**
  String get backupReminderOld;

  /// No description provided for @backupReminderAction.
  ///
  /// In da, this message translates to:
  /// **'Tag backup'**
  String get backupReminderAction;

  /// No description provided for @countPlayers.
  ///
  /// In da, this message translates to:
  /// **'{count, plural, =1{1 spiller} other{{count} spillere}}'**
  String countPlayers(int count);

  /// No description provided for @countMatches.
  ///
  /// In da, this message translates to:
  /// **'{count, plural, =1{1 kamp} other{{count} kampe}}'**
  String countMatches(int count);

  /// No description provided for @countTrainings.
  ///
  /// In da, this message translates to:
  /// **'{count, plural, =1{1 træningspas} other{{count} træningspas}}'**
  String countTrainings(int count);

  /// No description provided for @countGoals.
  ///
  /// In da, this message translates to:
  /// **'{count, plural, =1{1 mål} other{{count} mål}}'**
  String countGoals(int count);

  /// No description provided for @welcomeRestore.
  ///
  /// In da, this message translates to:
  /// **'Gendan fra backup'**
  String get welcomeRestore;

  /// No description provided for @navTechnique.
  ///
  /// In da, this message translates to:
  /// **'Teknik'**
  String get navTechnique;

  /// No description provided for @practiceMatch.
  ///
  /// In da, this message translates to:
  /// **'Træningskamp'**
  String get practiceMatch;

  /// No description provided for @practiceMatchHint.
  ///
  /// In da, this message translates to:
  /// **'Tæller ikke med i sejrsprocent og form'**
  String get practiceMatchHint;

  /// No description provided for @statsIncludePractice.
  ///
  /// In da, this message translates to:
  /// **'Medtag træningskampe'**
  String get statsIncludePractice;

  /// No description provided for @noGoalsDashboard.
  ///
  /// In da, this message translates to:
  /// **'Sæt et mål, fx 3 træningspas om ugen.'**
  String get noGoalsDashboard;

  /// No description provided for @techniqueStrokes.
  ///
  /// In da, this message translates to:
  /// **'Slag'**
  String get techniqueStrokes;

  /// No description provided for @techniqueFootwork.
  ///
  /// In da, this message translates to:
  /// **'Benarbejde'**
  String get techniqueFootwork;

  /// No description provided for @techniqueDrills.
  ///
  /// In da, this message translates to:
  /// **'Øvelser'**
  String get techniqueDrills;

  /// No description provided for @techniqueRules.
  ///
  /// In da, this message translates to:
  /// **'Regler'**
  String get techniqueRules;

  /// No description provided for @rulesSource.
  ///
  /// In da, this message translates to:
  /// **'Kilde: {source}'**
  String rulesSource(String source);

  /// No description provided for @webInstallHint.
  ///
  /// In da, this message translates to:
  /// **'Læg appen på hjemmeskærmen: tryk på Del og vælg Føj til hjemmeskærm. Ellers kan Safari slette dine data, hvis appen ikke bruges i 7 dage. Tag også backup jævnligt.'**
  String get webInstallHint;

  /// No description provided for @rulesDisclaimer.
  ///
  /// In da, this message translates to:
  /// **'Et sammendrag af BWF\'s og Badminton Danmarks regler. Ved tvivl gælder de officielle regler.'**
  String get rulesDisclaimer;

  /// No description provided for @techniqueDisclaimer.
  ///
  /// In da, this message translates to:
  /// **'Beskrivelserne er generel træningsviden for højrehåndede spillere og erstatter ikke en træner.'**
  String get techniqueDisclaimer;

  /// No description provided for @lastTrained.
  ///
  /// In da, this message translates to:
  /// **'Sidst trænet {date}'**
  String lastTrained(String date);

  /// No description provided for @neverTrained.
  ///
  /// In da, this message translates to:
  /// **'Ikke trænet endnu'**
  String get neverTrained;

  /// No description provided for @techniqueWhenToUse.
  ///
  /// In da, this message translates to:
  /// **'Hvornår bruges det'**
  String get techniqueWhenToUse;

  /// No description provided for @techniqueKeyPoints.
  ///
  /// In da, this message translates to:
  /// **'Teknikpunkter'**
  String get techniqueKeyPoints;

  /// No description provided for @techniqueMistakes.
  ///
  /// In da, this message translates to:
  /// **'Typiske fejl'**
  String get techniqueMistakes;

  /// No description provided for @techniqueYourTraining.
  ///
  /// In da, this message translates to:
  /// **'Din træning'**
  String get techniqueYourTraining;

  /// No description provided for @techniqueSessions12w.
  ///
  /// In da, this message translates to:
  /// **'{count, plural, =0{Ikke trænet de seneste 12 uger} =1{1 træningspas de seneste 12 uger} other{{count} træningspas de seneste 12 uger}}'**
  String techniqueSessions12w(int count);

  /// No description provided for @drillPlayers.
  ///
  /// In da, this message translates to:
  /// **'{count, plural, =1{Kan laves alene} other{{count} spillere}}'**
  String drillPlayers(int count);

  /// No description provided for @drillLevelBeginner.
  ///
  /// In da, this message translates to:
  /// **'Begynder'**
  String get drillLevelBeginner;

  /// No description provided for @drillLevelIntermediate.
  ///
  /// In da, this message translates to:
  /// **'Øvet'**
  String get drillLevelIntermediate;

  /// No description provided for @drillLevelAdvanced.
  ///
  /// In da, this message translates to:
  /// **'Avanceret'**
  String get drillLevelAdvanced;

  /// No description provided for @drillAllLevels.
  ///
  /// In da, this message translates to:
  /// **'Alle'**
  String get drillAllLevels;

  /// No description provided for @drillSteps.
  ///
  /// In da, this message translates to:
  /// **'Sådan gør du'**
  String get drillSteps;

  /// No description provided for @drillTips.
  ///
  /// In da, this message translates to:
  /// **'Tips'**
  String get drillTips;

  /// No description provided for @drillTrains.
  ///
  /// In da, this message translates to:
  /// **'Træner'**
  String get drillTrains;

  /// No description provided for @logThisDrill.
  ///
  /// In da, this message translates to:
  /// **'Log denne øvelse'**
  String get logThisDrill;

  /// No description provided for @trainingFocusTitle.
  ///
  /// In da, this message translates to:
  /// **'Hvad trænede du?'**
  String get trainingFocusTitle;

  /// No description provided for @addDrill.
  ///
  /// In da, this message translates to:
  /// **'Tilføj øvelse'**
  String get addDrill;

  /// No description provided for @chooseDrill.
  ///
  /// In da, this message translates to:
  /// **'Vælg øvelse'**
  String get chooseDrill;

  /// No description provided for @statsTechniqueSection.
  ///
  /// In da, this message translates to:
  /// **'Slag og benarbejde'**
  String get statsTechniqueSection;

  /// No description provided for @statsTechniqueHint.
  ///
  /// In da, this message translates to:
  /// **'Antal træningspas de seneste 12 uger'**
  String get statsTechniqueHint;

  /// No description provided for @statsTechniqueNone.
  ///
  /// In da, this message translates to:
  /// **'Vælg slag og benarbejde, når du logger træning, så kan du se her, hvad du træner mest.'**
  String get statsTechniqueNone;

  /// No description provided for @statsNotTrained30.
  ///
  /// In da, this message translates to:
  /// **'Ikke trænet i over 30 dage'**
  String get statsNotTrained30;

  /// No description provided for @coachTitle.
  ///
  /// In da, this message translates to:
  /// **'AI-træner'**
  String get coachTitle;

  /// No description provided for @coachOpen.
  ///
  /// In da, this message translates to:
  /// **'AI-træner'**
  String get coachOpen;

  /// No description provided for @coachSetupTitle.
  ///
  /// In da, this message translates to:
  /// **'Brug en AI som træner'**
  String get coachSetupTitle;

  /// No description provided for @coachSetupBody.
  ///
  /// In da, this message translates to:
  /// **'AI-træneren svarer på spørgsmål om teknik, regler, øvelser og taktik, foreslår træningspas og kommenterer din statistik. Svarene bygger på appens vidensbank.'**
  String get coachSetupBody;

  /// No description provided for @coachSetupKeyInfo.
  ///
  /// In da, this message translates to:
  /// **'Den bruger Claude fra Anthropic og kræver din egen API-nøgle. Opret en konto og en nøgle på console.anthropic.com, og sæt et beløb ind. Hvert spørgsmål koster typisk under 1 kr.'**
  String get coachSetupKeyInfo;

  /// No description provided for @coachSetupPrivacy.
  ///
  /// In da, this message translates to:
  /// **'Nøglen gemmes kun på denne enhed og kommer ikke med i backups. Når du spørger, sendes spørgsmålet og et overblik over dine kampe, træning og mål til Anthropic.'**
  String get coachSetupPrivacy;

  /// No description provided for @coachKeyLabel.
  ///
  /// In da, this message translates to:
  /// **'API-nøgle'**
  String get coachKeyLabel;

  /// No description provided for @coachKeyHint.
  ///
  /// In da, this message translates to:
  /// **'sk-ant-…'**
  String get coachKeyHint;

  /// No description provided for @coachKeySave.
  ///
  /// In da, this message translates to:
  /// **'Gem nøgle'**
  String get coachKeySave;

  /// No description provided for @coachChangeKey.
  ///
  /// In da, this message translates to:
  /// **'Skift API-nøgle'**
  String get coachChangeKey;

  /// No description provided for @coachRemoveKey.
  ///
  /// In da, this message translates to:
  /// **'Fjern API-nøgle'**
  String get coachRemoveKey;

  /// No description provided for @coachNewChat.
  ///
  /// In da, this message translates to:
  /// **'Ny samtale'**
  String get coachNewChat;

  /// No description provided for @coachModelOpus.
  ///
  /// In da, this message translates to:
  /// **'Model: bedst (Opus)'**
  String get coachModelOpus;

  /// No description provided for @coachModelSonnet.
  ///
  /// In da, this message translates to:
  /// **'Model: hurtigere og billigere (Sonnet)'**
  String get coachModelSonnet;

  /// No description provided for @coachIntro.
  ///
  /// In da, this message translates to:
  /// **'Spørg om alt fra greb og regler til træningsplaner. Jeg kender dine kampe, din træning og dine mål.'**
  String get coachIntro;

  /// No description provided for @coachInputHint.
  ///
  /// In da, this message translates to:
  /// **'Skriv et spørgsmål'**
  String get coachInputHint;

  /// No description provided for @coachSend.
  ///
  /// In da, this message translates to:
  /// **'Send'**
  String get coachSend;

  /// No description provided for @coachThinking.
  ///
  /// In da, this message translates to:
  /// **'Tænker …'**
  String get coachThinking;

  /// No description provided for @coachDisclaimer.
  ///
  /// In da, this message translates to:
  /// **'AI\'en kan tage fejl. Tjek vigtige ting med en træner, og spørg en læge eller fysioterapeut ved skader.'**
  String get coachDisclaimer;

  /// No description provided for @coachTruncated.
  ///
  /// In da, this message translates to:
  /// **'(Svaret blev for langt og er skåret af.)'**
  String get coachTruncated;

  /// No description provided for @coachQuickPlan.
  ///
  /// In da, this message translates to:
  /// **'Foreslå et træningspas'**
  String get coachQuickPlan;

  /// No description provided for @coachQuickPlanPrompt.
  ///
  /// In da, this message translates to:
  /// **'Foreslå et træningspas til mig på 60-90 minutter ud fra mine data, mit niveau og det, jeg ikke har trænet længe. Brug øvelser fra appen, og skriv, hvor lang tid hver del tager.'**
  String get coachQuickPlanPrompt;

  /// No description provided for @coachQuickFocus.
  ///
  /// In da, this message translates to:
  /// **'Hvad skal jeg træne mere?'**
  String get coachQuickFocus;

  /// No description provided for @coachQuickFocusPrompt.
  ///
  /// In da, this message translates to:
  /// **'Se på mine kampe og min træning. Hvad bør jeg træne mere, og hvorfor?'**
  String get coachQuickFocusPrompt;

  /// No description provided for @coachQuickForm.
  ///
  /// In da, this message translates to:
  /// **'Hvordan er min form?'**
  String get coachQuickForm;

  /// No description provided for @coachQuickFormPrompt.
  ///
  /// In da, this message translates to:
  /// **'Hvordan går det med min form og mine mål lige nu?'**
  String get coachQuickFormPrompt;

  /// No description provided for @coachQuickRules.
  ///
  /// In da, this message translates to:
  /// **'Forklar 3×15'**
  String get coachQuickRules;

  /// No description provided for @coachQuickRulesPrompt.
  ///
  /// In da, this message translates to:
  /// **'Forklar kort pointsystemet 3×15, og hvad der ændrer sig i forhold til 3×21.'**
  String get coachQuickRulesPrompt;

  /// No description provided for @coachErrorInvalidKey.
  ///
  /// In da, this message translates to:
  /// **'API-nøglen virker ikke. Tjek, at du har kopieret hele nøglen, eller lav en ny på console.anthropic.com.'**
  String get coachErrorInvalidKey;

  /// No description provided for @coachErrorNoCredit.
  ///
  /// In da, this message translates to:
  /// **'Der er ikke flere penge på din Anthropic-konto. Sæt et beløb ind på console.anthropic.com.'**
  String get coachErrorNoCredit;

  /// No description provided for @coachErrorRateLimited.
  ///
  /// In da, this message translates to:
  /// **'Der er sendt for mange spørgsmål på kort tid. Vent et øjeblik, og prøv igen.'**
  String get coachErrorRateLimited;

  /// No description provided for @coachErrorOverloaded.
  ///
  /// In da, this message translates to:
  /// **'Anthropic har travlt lige nu. Prøv igen om lidt.'**
  String get coachErrorOverloaded;

  /// No description provided for @coachErrorNetwork.
  ///
  /// In da, this message translates to:
  /// **'Kunne ikke få forbindelse. Tjek internettet, og prøv igen.'**
  String get coachErrorNetwork;

  /// No description provided for @coachErrorRefused.
  ///
  /// In da, this message translates to:
  /// **'AI\'en ville ikke svare på det spørgsmål. Prøv at formulere det anderledes.'**
  String get coachErrorRefused;

  /// No description provided for @coachErrorOther.
  ///
  /// In da, this message translates to:
  /// **'Noget gik galt: {message}'**
  String coachErrorOther(String message);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['da'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'da':
      return AppLocalizationsDa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Badminton-logbog';

  @override
  String get navOverview => 'Oversigt';

  @override
  String get navMatches => 'Kampe';

  @override
  String get navTraining => 'Træning';

  @override
  String get navGoals => 'Mål';

  @override
  String get navStats => 'Statistik';

  @override
  String get welcomeTitle => 'Velkommen til Badminton-logbog';

  @override
  String get welcomeBody =>
      'Log dine kampe og træningspas, sæt mål og følg din udvikling. Er du træner, kan du oprette flere spillere bagefter.';

  @override
  String get welcomeNameLabel => 'Dit navn';

  @override
  String get welcomeStart => 'Kom i gang';

  @override
  String get save => 'Gem';

  @override
  String get cancel => 'Annullér';

  @override
  String get delete => 'Slet';

  @override
  String get saveAnyway => 'Gem alligevel';

  @override
  String get notesLabel => 'Noter';

  @override
  String get dateLabel => 'Dato';

  @override
  String get fieldRequired => 'Skal udfyldes';

  @override
  String get invalidNumber => 'Skriv et helt tal større end 0';

  @override
  String saveFailed(String error) {
    return 'Kunne ikke gemme data: $error';
  }

  @override
  String get playersTitle => 'Spillere';

  @override
  String get managePlayers => 'Administrér spillere';

  @override
  String get addPlayer => 'Tilføj spiller';

  @override
  String get renamePlayer => 'Omdøb spiller';

  @override
  String get playerNameLabel => 'Navn';

  @override
  String get activePlayer => 'Aktiv spiller';

  @override
  String deletePlayerTitle(String name) {
    return 'Slet $name?';
  }

  @override
  String get deletePlayerBody =>
      'Alle kampe, træningspas og mål for spilleren bliver også slettet. Det kan ikke fortrydes.';

  @override
  String get comparePlayers => 'Sammenlign spillere';

  @override
  String get compareTitle => 'Sammenligning';

  @override
  String get compareColPlayer => 'Spiller';

  @override
  String get compareColMatches => 'Kampe';

  @override
  String get compareColWinRate => 'Sejr %';

  @override
  String get compareColTraining4w => 'Træning (4 uger)';

  @override
  String get compareColSessions4w => 'Pas (4 uger)';

  @override
  String get compareColForm => 'Form (seneste 5)';

  @override
  String get matchTypeSingle => 'Single';

  @override
  String get matchTypeDouble => 'Double';

  @override
  String get matchTypeMixed => 'Mixed';

  @override
  String get newMatch => 'Ny kamp';

  @override
  String get editMatch => 'Redigér kamp';

  @override
  String get deleteMatchTitle => 'Slet kampen?';

  @override
  String get opponentsLabel => 'Modstander(e)';

  @override
  String get partnerLabel => 'Makker';

  @override
  String gameLabel(int number) {
    return '$number. sæt';
  }

  @override
  String get ownPoints => 'Mig/os';

  @override
  String get opponentPoints => 'Modstander';

  @override
  String get optionalThirdGame => '3. sæt spilles kun ved 1-1 i sæt';

  @override
  String get scoreErrorNoGames => 'Indtast mindst ét sæt.';

  @override
  String get scoreErrorTiedGame => 'Et sæt kan ikke ende uafgjort.';

  @override
  String get scoreErrorNoWinner =>
      'Kampen skal have en vinder (flest vundne sæt).';

  @override
  String get scoreWarningTitle => 'Usædvanligt resultat';

  @override
  String get scoreWarningGame =>
      'Mindst ét sæt følger ikke de officielle regler (til 21 med 2 points forspring, maks. 30).';

  @override
  String get scoreWarningGameCount =>
      'En officiel kamp er bedst af 3 sæt og slutter, når én side har vundet 2.';

  @override
  String get scoreWarningFooter =>
      'Det er fint, hvis I fx har spillet til 15 til træning. Vil du gemme alligevel?';

  @override
  String matchVs(String opponents) {
    return 'mod $opponents';
  }

  @override
  String matchWithPartner(String partner) {
    return 'med $partner';
  }

  @override
  String get resultWonShort => 'V';

  @override
  String get resultLostShort => 'T';

  @override
  String get noMatches =>
      'Ingen kampe endnu. Tryk på + for at logge din første kamp.';

  @override
  String get unknownOpponent => 'ukendt modstander';

  @override
  String get trainingTypeTechnique => 'Teknik';

  @override
  String get trainingTypePhysical => 'Fysisk';

  @override
  String get trainingTypeMatchPlay => 'Kamptræning';

  @override
  String get trainingTypeFootwork => 'Footwork';

  @override
  String get trainingTypeOther => 'Andet';

  @override
  String get newTraining => 'Nyt træningspas';

  @override
  String get editTraining => 'Redigér træningspas';

  @override
  String get deleteTrainingTitle => 'Slet træningspasset?';

  @override
  String get durationLabel => 'Varighed (minutter)';

  @override
  String get trainingTypeLabel => 'Type';

  @override
  String get intensityLabel => 'Intensitet';

  @override
  String get intensity1 => 'Meget let';

  @override
  String get intensity2 => 'Let';

  @override
  String get intensity3 => 'Moderat';

  @override
  String get intensity4 => 'Hård';

  @override
  String get intensity5 => 'Maksimal';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String intensityShort(int value) {
    return 'intensitet $value/5';
  }

  @override
  String thisWeekSummary(int sessions, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      sessions,
      locale: localeName,
      other: '$sessions pas',
      one: '1 pas',
    );
    return 'Denne uge: $_temp0 · $minutes min';
  }

  @override
  String get noTrainings =>
      'Ingen træningspas endnu. Tryk på + for at logge dit første.';

  @override
  String get goalTypeSessionsPerWeek => 'Træningspas pr. uge';

  @override
  String get goalTypeMinutesPerWeek => 'Træningsminutter pr. uge';

  @override
  String get goalTypeWinRate => 'Sejrsprocent';

  @override
  String get newGoal => 'Nyt mål';

  @override
  String get editGoal => 'Redigér mål';

  @override
  String get deleteGoalTitle => 'Slet målet?';

  @override
  String get goalTypeLabel => 'Type mål';

  @override
  String get goalTargetLabel => 'Mål';

  @override
  String get goalWinRateRange => 'Skriv et tal mellem 1 og 100';

  @override
  String goalProgressSessions(int current, int target) {
    return '$current af $target pas denne uge';
  }

  @override
  String goalProgressMinutes(int current, int target) {
    return '$current af $target min denne uge';
  }

  @override
  String goalProgressWinRate(int current, int target, String date) {
    return '$current % sejre siden $date (mål $target %)';
  }

  @override
  String goalNoMatchesYet(int target, String date) {
    return 'Ingen kampe siden $date (mål $target %)';
  }

  @override
  String get goalReached => 'Nået!';

  @override
  String goalTargetSessions(int target) {
    return '$target pas om ugen';
  }

  @override
  String goalTargetMinutes(int target) {
    return '$target min om ugen';
  }

  @override
  String goalTargetWinRate(int target) {
    return 'Vind $target % af kampene';
  }

  @override
  String get noGoals =>
      'Ingen mål endnu. Tryk på + for at sætte dit første mål.';

  @override
  String get logMatch => 'Log kamp';

  @override
  String get logTraining => 'Log træning';

  @override
  String get statWinRate => 'Sejrsprocent';

  @override
  String get statMatchesPlayed => 'Kampe spillet';

  @override
  String get statTraining7d => 'Træning, 7 dage';

  @override
  String get statCurrentStreak => 'Aktuel stime';

  @override
  String streakWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sejre',
      one: '1 sejr',
    );
    return '$_temp0';
  }

  @override
  String streakLosses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nederlag',
      one: '1 nederlag',
    );
    return '$_temp0';
  }

  @override
  String get noData => '–';

  @override
  String get recentForm => 'Form';

  @override
  String get recentFormHint => 'Seneste kampe, nyeste til venstre';

  @override
  String get yourGoals => 'Dine mål';

  @override
  String get statsWinRateSection => 'Sejrsprocent';

  @override
  String get statsOverall => 'Samlet';

  @override
  String statsWonLost(int won, int lost) {
    return '$won vundet · $lost tabt';
  }

  @override
  String get statsTrainingSection => 'Træningsmængde';

  @override
  String get statsTrainingHint => 'Minutter pr. uge de seneste 12 uger';

  @override
  String statsWeekLabel(int week) {
    return 'Uge $week';
  }

  @override
  String get statsFormSection => 'Form og stimer';

  @override
  String get statsLongestWinStreak => 'Længste sejrsstime';

  @override
  String get statsPointDiff => 'Pointforskel pr. kamp (seneste 20)';

  @override
  String get statsOpponentsSection => 'Mod modstandere';

  @override
  String get statsNoMatches => 'Log nogle kampe for at se statistik her.';

  @override
  String get statsNoTraining =>
      'Log nogle træningspas for at se udviklingen her.';
}

import 'package:flutter/foundation.dart';

import '../data/backup.dart';
import '../data/data_store.dart';
import '../models/models.dart';

/// Central tilstand for appen. Skærmene lytter på den og kalder dens metoder;
/// alle ændringer gemmes automatisk via [DataStore].
class AppState extends ChangeNotifier {
  AppState(this._store);

  final DataStore _store;
  AppData _data = AppData();
  bool _loaded = false;
  Object? _saveError;

  bool get loaded => _loaded;

  /// Sat hvis den seneste gemning fejlede.
  Object? get saveError => _saveError;

  List<Player> get players => List.unmodifiable(_data.players);

  Player? get activePlayer {
    final id = _data.activePlayerId;
    for (final p in _data.players) {
      if (p.id == id) return p;
    }
    return _data.players.isEmpty ? null : _data.players.first;
  }

  List<MatchRecord> matchesFor(String playerId) =>
      _data.matches.where((m) => m.playerId == playerId).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  List<TrainingSession> trainingsFor(String playerId) =>
      _data.trainings.where((t) => t.playerId == playerId).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  List<Goal> goalsFor(String playerId) =>
      _data.goals.where((g) => g.playerId == playerId).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  List<MatchRecord> get activeMatches =>
      activePlayer == null ? [] : matchesFor(activePlayer!.id);

  List<TrainingSession> get activeTrainings =>
      activePlayer == null ? [] : trainingsFor(activePlayer!.id);

  List<Goal> get activeGoals =>
      activePlayer == null ? [] : goalsFor(activePlayer!.id);

  Future<void> load() async {
    _data = await _store.load();
    _loaded = true;
    notifyListeners();
  }

  Future<void> _commit() async {
    notifyListeners();
    try {
      await _store.save(_data);
      _saveError = null;
    } catch (e) {
      _saveError = e;
      notifyListeners();
    }
  }

  // Spillere

  Future<Player> addPlayer(String name) async {
    final player =
        Player(id: newId(), name: name.trim(), createdAt: DateTime.now());
    _data.players.add(player);
    _data.activePlayerId ??= player.id;
    await _commit();
    return player;
  }

  Future<void> renamePlayer(String id, String name) async {
    final i = _data.players.indexWhere((p) => p.id == id);
    if (i < 0) return;
    _data.players[i] = _data.players[i].copyWith(name: name.trim());
    await _commit();
  }

  /// Opdaterer navn, niveau og hånd for en spiller.
  Future<void> updatePlayer(Player player) async {
    final i = _data.players.indexWhere((p) => p.id == player.id);
    if (i < 0) return;
    _data.players[i] = player.copyWith(name: player.name.trim());
    await _commit();
  }

  /// Sletter spilleren og alle spillerens kampe, træninger og mål.
  Future<void> deletePlayer(String id) async {
    _data.players.removeWhere((p) => p.id == id);
    _data.matches.removeWhere((m) => m.playerId == id);
    _data.trainings.removeWhere((t) => t.playerId == id);
    _data.goals.removeWhere((g) => g.playerId == id);
    if (_data.activePlayerId == id) {
      _data.activePlayerId =
          _data.players.isEmpty ? null : _data.players.first.id;
    }
    await _commit();
  }

  Future<void> setActivePlayer(String id) async {
    _data.activePlayerId = id;
    await _commit();
  }

  // Backup

  DateTime? get lastBackupAt => _data.lastBackupAt;

  /// Sand når der er data, som ikke er taget backup af i over 30 dage.
  bool needsBackupReminder(DateTime now) {
    if (_data.matches.isEmpty && _data.trainings.isEmpty) return false;
    final last = _data.lastBackupAt;
    return last == null || now.difference(last).inDays > 30;
  }

  /// Laver en backup af alle data. Kald [markBackedUp], når filen faktisk er
  /// gemt eller delt.
  String exportBackup(DateTime now) {
    final copy = AppData.fromJson(_data.toJson())..lastBackupAt = now;
    return encodeBackup(copy, exportedAt: now);
  }

  Future<void> markBackedUp(DateTime now) {
    _data.lastBackupAt = now;
    return _commit();
  }

  /// Indlæser en backup. Med [replace] erstattes alle data; ellers flettes
  /// backuppen ind uden at slette noget.
  Future<void> importBackup(AppData incoming, {required bool replace}) {
    final lastBackupAt = _data.lastBackupAt;
    _data = replace ? incoming : mergeData(_data, incoming);
    // Tidspunktet for sidste backup hører til denne enhed, ikke til filen.
    _data.lastBackupAt = lastBackupAt;
    if (!_data.players.any((p) => p.id == _data.activePlayerId)) {
      _data.activePlayerId =
          _data.players.isEmpty ? null : _data.players.first.id;
    }
    return _commit();
  }

  // Kampe, træning og mål. "save" opretter eller erstatter på id.

  Future<void> saveMatch(MatchRecord match) =>
      _upsert(_data.matches, match, (m) => m.id);

  Future<void> deleteMatch(String id) =>
      _remove(_data.matches, (m) => m.id == id);

  Future<void> saveTraining(TrainingSession session) =>
      _upsert(_data.trainings, session, (t) => t.id);

  Future<void> deleteTraining(String id) =>
      _remove(_data.trainings, (t) => t.id == id);

  Future<void> saveGoal(Goal goal) => _upsert(_data.goals, goal, (g) => g.id);

  Future<void> deleteGoal(String id) => _remove(_data.goals, (g) => g.id == id);

  Future<void> _upsert<T>(List<T> list, T item, String Function(T) id) {
    final i = list.indexWhere((e) => id(e) == id(item));
    if (i >= 0) {
      list[i] = item;
    } else {
      list.add(item);
    }
    return _commit();
  }

  Future<void> _remove<T>(List<T> list, bool Function(T) test) {
    list.removeWhere(test);
    return _commit();
  }
}

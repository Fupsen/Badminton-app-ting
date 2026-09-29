import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

/// Abstraktion over hvor data gemmes. I dag gemmes lokalt i en JSON-fil;
/// en cloud-implementation (fx Firebase) kan senere implementere samme
/// interface uden at resten af appen skal ændres.
abstract class DataStore {
  Future<AppData> load();
  Future<void> save(AppData data);
}

/// Gemmer alle data i én JSON-fil i appens support-mappe.
class JsonFileStore implements DataStore {
  JsonFileStore({this.fileName = 'badminton_data.json', this.directory});

  final String fileName;

  /// Mappen filen gemmes i. Standard er appens support-mappe.
  final Directory? directory;

  Future<File> _file() async {
    final dir = directory ?? await getApplicationSupportDirectory();
    await dir.create(recursive: true);
    return File('${dir.path}${Platform.pathSeparator}$fileName');
  }

  @override
  Future<AppData> load() async {
    final file = await _file();
    if (!await file.exists()) return AppData();
    final content = await file.readAsString();
    if (content.trim().isEmpty) return AppData();
    return AppData.fromJson(jsonDecode(content) as Map<String, dynamic>);
  }

  @override
  Future<void> save(AppData data) async {
    final file = await _file();
    // Skriv først til en midlertidig fil og omdøb bagefter, så en afbrudt
    // skrivning ikke efterlader en halv (korrupt) datafil.
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(jsonEncode(data.toJson()), flush: true);
    await tmp.rename(file.path);
  }
}

/// Gemmer alle data som JSON i SharedPreferences. Bruges i webudgaven, hvor
/// der ikke er et filsystem (i browseren ender det i localStorage).
class SharedPreferencesStore implements DataStore {
  SharedPreferencesStore({this.key = 'badminton_data'});

  final String key;

  @override
  Future<AppData> load() async {
    final prefs = await SharedPreferences.getInstance();
    final content = prefs.getString(key);
    if (content == null || content.trim().isEmpty) return AppData();
    return AppData.fromJson(jsonDecode(content) as Map<String, dynamic>);
  }

  @override
  Future<void> save(AppData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data.toJson()));
  }
}

/// Holder data i hukommelsen. Bruges i tests.
class MemoryStore implements DataStore {
  MemoryStore([AppData? initial]) : _json = initial?.toJson();

  Map<String, dynamic>? _json;

  @override
  Future<AppData> load() async =>
      _json == null ? AppData() : AppData.fromJson(jsonDecode(jsonEncode(_json)));

  @override
  Future<void> save(AppData data) async => _json = data.toJson();
}

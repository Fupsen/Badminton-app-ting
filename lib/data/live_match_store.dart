import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../logic/live_score.dart';

/// Gemmer en igangværende kamp fra kamptælleren, så den overlever, at
/// telefonen låser, eller appen lukkes. Én kamp pr. spiller.
class LiveMatchStore {
  const LiveMatchStore();

  String _key(String playerId) => 'live_match_$playerId';

  Future<LiveMatch?> load(String playerId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(playerId));
    if (raw == null) return null;
    try {
      return LiveMatch.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      // En ødelagt eller forældet kamp skal ikke spærre for en ny.
      await prefs.remove(_key(playerId));
      return null;
    }
  }

  Future<void> save(String playerId, LiveMatch match) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(playerId), jsonEncode(match.toJson()));
  }

  Future<void> clear(String playerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(playerId));
  }
}

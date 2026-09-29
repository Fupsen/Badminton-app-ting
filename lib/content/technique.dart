/// Modeller for teknik-biblioteket: slag, benarbejde og øvelser.
///
/// Indholdet er statisk og ligger i `technique_da.dart`. En engelsk version
/// kan senere lægges i `technique_en.dart` med samme id'er.
library;

import 'technique_da.dart' as da;

enum TechniqueKind { stroke, footwork }

enum DrillLevel { beginner, intermediate, advanced }

class Technique {
  const Technique({
    required this.id,
    required this.kind,
    required this.name,
    required this.category,
    required this.summary,
    required this.whenToUse,
    required this.keyPoints,
    required this.commonMistakes,
  });

  /// Stabilt id, der gemmes i træningsloggen. Må ikke ændres.
  final String id;
  final TechniqueKind kind;
  final String name;

  /// Gruppering i listen, fx "Net" eller "Bagbane".
  final String category;
  final String summary;
  final String whenToUse;
  final List<String> keyPoints;
  final List<String> commonMistakes;
}

class Drill {
  const Drill({
    required this.id,
    required this.name,
    required this.purpose,
    required this.techniqueIds,
    required this.minPlayers,
    required this.minutes,
    required this.level,
    required this.steps,
    required this.tips,
  });

  /// Stabilt id, der gemmes i træningsloggen. Må ikke ændres.
  final String id;
  final String name;
  final String purpose;

  /// Slag og benarbejde øvelsen træner.
  final List<String> techniqueIds;
  final int minPlayers;

  /// Forslag til varighed i minutter.
  final int minutes;
  final DrillLevel level;
  final List<String> steps;
  final List<String> tips;
}

/// Alle slag og alt benarbejde, i den rækkefølge de vises.
const List<Technique> techniques = [...da.strokes, ...da.footwork];

const List<Drill> drills = da.drills;

final Map<String, Technique> _techniqueIndex = {
  for (final t in techniques) t.id: t,
};

final Map<String, Drill> _drillIndex = {for (final d in drills) d.id: d};

/// Slår en teknik op. Returnerer null for ukendte id'er, fx hvis indholdet er
/// ændret siden data blev gemt.
Technique? techniqueById(String id) => _techniqueIndex[id];

Drill? drillById(String id) => _drillIndex[id];

List<Technique> techniquesOfKind(TechniqueKind kind) =>
    techniques.where((t) => t.kind == kind).toList();

/// Øvelser der træner [techniqueId].
List<Drill> drillsFor(String techniqueId) =>
    drills.where((d) => d.techniqueIds.contains(techniqueId)).toList();

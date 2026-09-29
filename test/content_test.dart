import 'package:badminton_app/content/technique.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ids are unique', () {
    final techniqueIds = techniques.map((t) => t.id).toList();
    expect(techniqueIds.toSet(), hasLength(techniqueIds.length));
    final drillIds = drills.map((d) => d.id).toList();
    expect(drillIds.toSet(), hasLength(drillIds.length));
  });

  test('every drill refers to existing techniques', () {
    for (final d in drills) {
      expect(d.techniqueIds, isNotEmpty, reason: d.id);
      for (final id in d.techniqueIds) {
        expect(techniqueById(id), isNotNull, reason: '${d.id} -> $id');
      }
    }
  });

  test('every technique has at least one drill', () {
    for (final t in techniques) {
      expect(drillsFor(t.id), isNotEmpty, reason: t.id);
    }
  });

  test('no empty texts', () {
    for (final t in techniques) {
      expect(t.name.trim(), isNotEmpty);
      expect(t.category.trim(), isNotEmpty, reason: t.id);
      expect(t.summary.trim(), isNotEmpty, reason: t.id);
      expect(t.whenToUse.trim(), isNotEmpty, reason: t.id);
      expect(t.keyPoints, isNotEmpty, reason: t.id);
      expect(t.commonMistakes, isNotEmpty, reason: t.id);
    }
    for (final d in drills) {
      expect(d.purpose.trim(), isNotEmpty, reason: d.id);
      expect(d.steps, isNotEmpty, reason: d.id);
      expect(d.tips, isNotEmpty, reason: d.id);
      expect(d.minPlayers, greaterThan(0), reason: d.id);
      expect(d.minutes, greaterThan(0), reason: d.id);
    }
  });

  test('both kinds are present and categories are grouped', () {
    for (final kind in TechniqueKind.values) {
      final list = techniquesOfKind(kind);
      expect(list, isNotEmpty);
      // Samme kategori skal stå samlet, så listen kan vise overskrifter.
      final seen = <String>[];
      for (final t in list) {
        if (seen.isEmpty || seen.last != t.category) {
          expect(seen, isNot(contains(t.category)), reason: t.id);
          seen.add(t.category);
        }
      }
    }
  });

  test('unknown ids return null', () {
    expect(techniqueById('findes_ikke'), isNull);
    expect(drillById('findes_ikke'), isNull);
  });
}

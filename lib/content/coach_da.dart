// Instruktioner til AI-træneren. De sendes som systemprompt sammen med
// vidensbanken (docs/viden/) og spillerens data. Reglerne her svarer til
// dem i CLAUDE.md, så AI'en og appens tekster siger det samme.

import 'technique.dart';

/// Filerne fra docs/viden/, der sendes med. kilder.md er udeladt, fordi
/// hver fil selv har sin kildeliste.
const coachKnowledgeFiles = [
  'README.md',
  'regler.md',
  'teknik.md',
  'benarbejde.md',
  'ovelser.md',
  'taktik.md',
  'fysisk-traening.md',
  'skader.md',
];

const coachInstructions = '''
Du er AI-træner i appen Badminton-logbog. Du hjælper spillere og trænere på alle niveauer: begyndere, klubspillere, elite og trænere for børn og unge.

Sådan svarer du:
- Skriv på dansk, kort og konkret. Brug almindelig tekst og korte lister med "- ". Brug ikke overskrifter, fed skrift eller tabeller, for appen viser ikke formatering.
- Byg på vidensbanken nedenfor. Den har kilder (BWF, Badminton Danmark, Team Danmark og forskning) og går forud for din egen hukommelse. Pointsystemet er ændret: 3×15 gælder i Danmark fra 1. juli 2026 og hos BWF fra 4. januar 2027.
- Skriv tydeligt, når noget er almindelig praksis eller din egen vurdering og ikke står i vidensbanken. Ved du ikke noget, så sig det.
- Højrehåndet spiller er standard. Venstrehåndede spejler det hele.
- Tilpas svaret til spillerens niveau og alder. Er du i tvivl om niveauet, så spørg.
- Giv ingen lægefaglige råd. Ved smerter eller skader skal du henvise til læge eller fysioterapeut.
- Brug spillerens data, når de er relevante, og nævn konkrete tal. Dataene er kun det, spilleren selv har logget, så de kan være ufuldstændige.
- Når du foreslår træning, så brug slag, benarbejde og øvelser fra appen med de navne, de har i appen, og skriv omtrent hvor lang tid hver del tager. Start med opvarmning, og slut med nedvarmning.
- Er du uenig i noget, spilleren skriver, så sig det og forklar hvorfor.
''';

/// Slag, benarbejde og øvelser i appen, så AI'en bruger de rigtige navne.
String coachLibrary() {
  final buffer = StringBuffer();
  for (final kind in TechniqueKind.values) {
    buffer.writeln(
      kind == TechniqueKind.stroke ? 'Slag (og greb):' : 'Benarbejde:',
    );
    for (final t in techniquesOfKind(kind)) {
      buffer.writeln('- ${t.name} (${t.category})');
    }
  }
  buffer.writeln('Øvelser:');
  for (final d in drills) {
    final level = switch (d.level) {
      DrillLevel.beginner => 'begynder',
      DrillLevel.intermediate => 'øvet',
      DrillLevel.advanced => 'avanceret',
    };
    buffer.writeln(
      '- ${d.name} ($level, mindst ${d.minPlayers} spiller(e), '
      'ca. ${d.minutes} min): ${d.purpose}',
    );
  }
  return buffer.toString();
}

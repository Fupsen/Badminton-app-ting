// Dansk regelindhold. Skal stemme med docs/viden/regler.md, som har kilderne
// (BWF Laws of Badminton v5.0 fra 2025, BWF's og Badminton Danmarks
// meddelelser om 3×15).

import 'rules.dart';

const highlight =
    'I Danmark spilles der 3×15 i alle kampe fra 1. juli 2026: bedst af 3 sæt '
    'til 15 point. Internationalt (BWF) gælder det fra 4. januar 2027.';

const sections = <RuleSection>[
  RuleSection(
    id: 'scoring',
    title: 'Pointsystem',
    intro:
        'Der gives point i hver duel. Vinderen af et sæt server først i '
        'næste sæt.',
    points: [
      '3×15 (standard): bedst af 3 sæt til 15 point.',
      'Ved 14-14 skal sættet vindes med 2 point.',
      'Loft ved 21: ved 20-20 vinder den, der får næste point.',
      'Gyldige slutresultater: 15-0 til 15-13, 16-14 til 20-18, 21-19 og '
          '21-20.',
      'Pause på højst 60 sekunder, når den førende når 8 point. Højst 120 '
          'sekunder mellem sættene.',
      'Man skifter side efter 1. sæt, før 3. sæt, og i 3. sæt når en side '
          'når 8 point.',
      '3×21 (tidligere standard, nu tilladt alternativ): til 21, ved 20-20 '
          'vindes med 2, loft ved 30. Pause og sideskift i 3. sæt ved 11.',
    ],
    source: 'Badminton Danmark 28-05-2026, BWF 26-04-2026, BWF Laws §7-8, §16',
  ),
  RuleSection(
    id: 'service',
    title: 'Serv',
    points: [
      'Server og modtager står i diagonalt modsatte servefelter uden at røre '
          'linjerne.',
      'En del af begge fødder skal røre gulvet og stå stille, indtil bolden '
          'er ramt.',
      'Hele fjerbolden skal være under 1,15 m over gulvet, når ketsjeren '
          'rammer den.',
      'Fjerbolden skal slippes uden spin, og ketsjeren skal ramme korken '
          'først. Spin-serv er forbudt siden 2025.',
      'Ketsjeren skal bevæge sig fremad hele vejen, fra serven starter, til '
          'bolden er ramt. Stop eller tøven er fejl.',
      'Fjerboldens bane skal gå opad fra ketsjeren og lande i modtagerens '
          'servefelt. En bold på linjen er inde.',
      'Man må ikke serve, før modtageren er klar. Forsøger modtageren at '
          'returnere, regnes modtageren for at have været klar.',
    ],
    source: 'BWF Laws §9, BWF 02-05-2025',
  ),
  RuleSection(
    id: 'serving_order',
    title: 'Hvem server hvorfra',
    points: [
      'Single: server fra højre felt, når serverens eget pointtal er lige '
          '(0, 2, 4 …), og fra venstre, når det er ulige.',
      'Single: vinder serveren duellen, server serveren igen fra det andet '
          'felt. Vinder modtageren, bliver modtageren ny server.',
      'Double: den servende side server fra højre, når sidens pointtal er '
          'lige, og fra venstre, når det er ulige.',
      'Double: spillerne skifter kun felt, når deres side vinder et point på '
          'egen serv. Modtagerne bliver stående.',
      'Double: modtageren er den spiller, der står diagonalt over for '
          'serveren.',
      'Serveres der i forkert rækkefølge eller fra forkert felt, rettes det, '
          'når bolden ikke er i spil. Stillingen står ved magt.',
    ],
    source: 'BWF Laws §10-12',
  ),
  RuleSection(
    id: 'faults',
    title: 'Fejl',
    points: [
      'Bolden lander uden for banen eller går ikke over nettet. En bold på '
          'linjen er inde.',
      'Bolden rammer loft, vægge, en spiller eller spillerens tøj.',
      'Samme spiller rammer to gange i træk, eller to makkere rammer lige '
          'efter hinanden. Det er ikke fejl, hvis bolden rammer ramme og '
          'strenge i ét slag.',
      'Bolden bliver fanget og slynget af ketsjeren.',
      'En spiller rører nettet eller stolperne med ketsjer, krop eller tøj.',
      'En spiller kommer ind over nettet. Men man må følge bolden over med '
          'ketsjeren, hvis træffet var på egen side.',
      'En spiller kommer ind under nettet og generer modstanderen, spærrer '
          'for et lovligt slag eller forstyrrer bevidst, fx ved at råbe.',
      'Ved serv: bolden bliver hængende oven på nettet eller i nettet, eller '
          'modtagerens makker rører den.',
    ],
    source: 'BWF Laws §13',
  ),
  RuleSection(
    id: 'lets',
    title: 'Let (omspil)',
    intro:
        'Ved let spilles duellen om, og den, der servede sidst, server igen.',
    points: [
      'Der serves, før modtageren er klar.',
      'Både server og modtager laver fejl i serven.',
      'Bolden bliver hængende på eller i nettet, efter at serven er '
          'returneret.',
      'Fjerbolden går i stykker, og korken falder helt af.',
      'En træner forstyrrer spillet, eller noget uforudset sker.',
    ],
    source: 'BWF Laws §14',
  ),
  RuleSection(
    id: 'court',
    title: 'Bane og udstyr',
    points: [
      'Banen er 13,40 × 6,10 m i double. Singlebanen er 5,18 m bred.',
      'Den korte servelinje ligger 1,98 m fra nettet. I double ligger den '
          'lange servelinje 0,76 m inden for baglinjen.',
      'Nettet er 1,524 m højt på midten og 1,55 m ved double-sidelinjerne.',
      'Linjerne hører til det felt, de afgrænser.',
      'Fjerbolden vejer 4,74-5,50 g. Plastbolde er tilladt, hvis de flyver '
          'som fjerbolde.',
      'Ketsjeren må højst være 680 mm lang og 230 mm bred.',
    ],
    source: 'BWF Laws §1-4',
  ),
  RuleSection(
    id: 'conduct',
    title: 'Pauser, råd og opførsel',
    points: [
      'Spillet er uafbrudt bortset fra de faste pauser. Man må ikke trække '
          'tiden for at puste ud.',
      'Råd fra træneren må kun gives, når bolden ikke er i spil, og indtil '
          'spillerne står klar til serv og modtagelse.',
      'Man må ikke forlade banen uden dommerens tilladelse, bortset fra i '
          'pauserne.',
      'Usportslig opførsel giver advarsel, derefter fejl, og i grove '
          'tilfælde bortvisning.',
    ],
    source: 'BWF Laws §16',
  ),
];

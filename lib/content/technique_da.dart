// Dansk indhold til teknik-biblioteket. Beskrivelserne tager udgangspunkt i
// en højrehåndet spiller. De er generel træningsviden og erstatter ikke en
// træner.

import 'technique.dart';

const strokes = <Technique>[
  // Serv
  Technique(
    id: 'serve_short',
    kind: TechniqueKind.stroke,
    name: 'Kort serv',
    category: 'Serv',
    summary:
        'En lav serv, der lige går over nettet og lander i forreste del af '
        'modstanderens servefelt. Det mest brugte serv i double.',
    whenToUse:
        'Standard i double og mixed, og som variation i single, så '
        'modstanderen ikke kan angribe serven.',
    keyPoints: [
      'Kort baghåndsgreb med tommelfingeren bag skaftet.',
      'Hold fjerbolden ved fjerene foran kroppen under taljen.',
      'Skub ketsjeren frem med en rolig bevægelse fra underarm og tommel, '
          'ikke med et sving fra skulderen.',
      'Fjerbolden skal toppe på din side af nettet og falde ned over det.',
      'Stå klar i en let fremadlænet position, så du er klar til næste slag.',
    ],
    commonMistakes: [
      'Serven går for højt over nettet og bliver angrebet.',
      'For stort sving giver ujævn længde.',
      'Ketsjerhovedet er over taljen ved træffet (regelfejl).',
    ],
  ),
  Technique(
    id: 'serve_long',
    kind: TechniqueKind.stroke,
    name: 'Lang serv',
    category: 'Serv',
    summary:
        'En høj forhåndsserv, der lander tæt på den bagerste linje og falder '
        'lodret ned.',
    whenToUse:
        'Mest i single, hvor den presser modstanderen helt tilbage. I '
        'double bruges en fladere, hurtigere variant (flick) som '
        'overraskelse.',
    keyPoints: [
      'Stå sidelæns med venstre fod forrest og vægten på højre ben.',
      'Slip fjerbolden, og sving ketsjeren i en lang bue under og op.',
      'Flyt vægten fremad under svinget, og drej hofte og skulder med.',
      'Afslut svinget højt over venstre skulder.',
      'Sigt højt, så fjerbolden falder lodret ned ved baglinjen.',
    ],
    commonMistakes: [
      'For kort serv, som modstanderen kan smashe.',
      'Kun armen bruges, så der mangler kraft.',
      'Man ser efter serven i stedet for at gå i grundposition.',
    ],
  ),
  // Bagbane
  Technique(
    id: 'clear',
    kind: TechniqueKind.stroke,
    name: 'Clear',
    category: 'Bagbane',
    summary:
        'Et højt og langt overhåndsslag fra egen bagbane til modstanderens '
        'bagbane.',
    whenToUse:
        'Høj (defensiv) clear giver dig tid til at komme tilbage i '
        'position. En fladere angrebsclear presser en modstander, der står '
        'langt fremme.',
    keyPoints: [
      'Kom bag fjerbolden, så du slår den foran og over hovedet.',
      'Stå sidelæns med venstre arm pegende op mod fjerbolden.',
      'Kast-bevægelse: albuen føres op og frem, underarmen roterer '
          '(pronation) i træffet.',
      'Træf fjerbolden så højt som muligt med strakt arm.',
      'Flyt vægten fra bagerste til forreste ben under slaget.',
    ],
    commonMistakes: [
      'Træffer fjerbolden bag hovedet, så den går kort og lav.',
      'Står med front mod nettet i stedet for sidelæns.',
      'Bruger håndleddet i stedet for underarmsrotation.',
    ],
  ),
  Technique(
    id: 'drop',
    kind: TechniqueKind.stroke,
    name: 'Drop',
    category: 'Bagbane',
    summary:
        'Et blødt slag fra bagbanen, der falder lige over nettet og lander i '
        'modstanderens forreste område.',
    whenToUse:
        'Til at trække en modstander, der står bagerst, frem mod nettet, eller '
        'som variation mellem clears og smash. Et hurtigt (skåret) drop '
        'lander længere fremme og giver mindre tid.',
    keyPoints: [
      'Samme forberedelse som clear og smash, så modstanderen ikke kan '
          'læse slaget.',
      'Brems ketsjerens fart lige før træffet, eller skær fjerbolden med '
          'en vinklet ketsjerflade.',
      'Træf foran kroppen og så højt som muligt.',
      'Gå straks frem mod midten efter slaget.',
    ],
    commonMistakes: [
      'Anden forberedelse end ved clear, så dropet bliver afsløret.',
      'Dropet lander midt på banen og kan angribes.',
      'Dropet er for højt over nettet.',
    ],
  ),
  Technique(
    id: 'smash',
    kind: TechniqueKind.stroke,
    name: 'Smash',
    category: 'Bagbane',
    summary: 'Et hårdt, nedadgående overhåndsslag. Det vigtigste angrebsslag.',
    whenToUse:
        'Når fjerbolden er høj og ikke for langt tilbage. En smash fra '
        'baglinjen er mindre farlig og koster meget energi.',
    keyPoints: [
      'Kom hurtigt bag og lidt til siden af fjerbolden.',
      'Træf foran kroppen, så slaget går nedad.',
      'Brug hele kroppen: ben, hofte og skulderrotation før armen.',
      'Kraftig underarmsrotation og håndled i træffet.',
      'Sigt efter kroppen eller sidelinjerne, ikke midt på banen.',
      'Følg med frem mod nettet klar til næste slag.',
    ],
    commonMistakes: [
      'Træffer bag hovedet, så smashen bliver flad og lang.',
      'Smasher fra for langt tilbage og bliver kontret.',
      'Bliver stående efter slaget.',
    ],
  ),
  Technique(
    id: 'backhand',
    kind: TechniqueKind.stroke,
    name: 'Baghånd i bagbanen',
    category: 'Bagbane',
    summary:
        'Clear eller drop slået med baghånd fra baghåndshjørnet, når du ikke '
        'kan nå at komme rundt om fjerbolden.',
    whenToUse:
        'Når fjerbolden er langt ude i baghåndshjørnet, og du ikke kan tage '
        'den med forhånd (rundt om hovedet).',
    keyPoints: [
      'Drej ryggen mod nettet, og gå sidste skridt med højre ben.',
      'Baghåndsgreb med tommelfingeren flad på skaftet.',
      'Albuen peger op, og slaget kommer fra underarmsrotation (supination) '
          'og et kort, hurtigt håndled.',
      'Træf fjerbolden højt og lidt foran kroppen.',
      'Drej straks rundt og kom tilbage mod midten.',
    ],
    commonMistakes: [
      'Træffer for lavt og for sent, så slaget bliver kort.',
      'Bruger forhåndsgreb.',
      'Står med front mod nettet i stedet for ryggen.',
    ],
  ),
  // Midtbane
  Technique(
    id: 'drive',
    kind: TechniqueKind.stroke,
    name: 'Drive',
    category: 'Midtbane',
    summary:
        'Et fladt, hurtigt slag i nethøjde, der går parallelt med gulvet ind '
        'over nettet.',
    whenToUse:
        'Mest i double, når fjerbolden er i skulderhøjde ved siden af '
        'kroppen. Det holder tempoet højt og tvinger modstanderen til at '
        'løfte.',
    keyPoints: [
      'Ketsjeren oppe foran kroppen, klar i begge sider.',
      'Kort, kompakt slag fra underarm og håndled, intet stort sving.',
      'Træf fjerbolden foran kroppen i nethøjde.',
      'Skift hurtigt mellem forhånds- og baghåndsgreb.',
    ],
    commonMistakes: [
      'For stort sving, så man ikke når næste slag.',
      'Ketsjeren falder ned mellem slagene.',
      'Slaget går opad og kan smashes.',
    ],
  ),
  Technique(
    id: 'defence',
    kind: TechniqueKind.stroke,
    name: 'Smashforsvar (block)',
    category: 'Midtbane',
    summary:
        'Forsvar mod en smash: enten et kort block, der falder lige over '
        'nettet, eller et langt løft tilbage.',
    whenToUse:
        'Når modstanderen smasher. Et kort block tvinger smasheren frem, et '
        'fladt kontra-slag kan vende forsvar til angreb.',
    keyPoints: [
      'Lav, bred forsvarsstilling med knæene bøjet.',
      'Ketsjeren foran kroppen i baghåndsgreb (dækker det meste af kroppen).',
      'Brug smashens fart: block ved blot at holde ketsjeren fast.',
      'Træf foran kroppen, ikke ved siden af.',
      'Split step lige når modstanderen slår.',
    ],
    commonMistakes: [
      'Står for højt og for oprejst.',
      'For stort sving, så fjerbolden går ud.',
      'Træffer bag kroppen og mister kontrollen.',
    ],
  ),
  Technique(
    id: 'push',
    kind: TechniqueKind.stroke,
    name: 'Push',
    category: 'Midtbane',
    summary:
        'Et kontrolleret, fladt skub fra midtbanen ned i modstanderens '
        'midtbane.',
    whenToUse:
        'Mod en kort serv eller et halvhøjt slag, når du ikke kan angribe '
        'nedad, men vil undgå at løfte.',
    keyPoints: [
      'Træf fjerbolden så tidligt og højt som muligt.',
      'Kort bevægelse, mest tommel og fingre.',
      'Sigt mellem modstanderne eller bag netspilleren.',
    ],
    commonMistakes: [
      'Pusher for højt, så modstanderen kan angribe.',
      'Pusher for langt, så det bliver et nemt slag fra bagbanen.',
    ],
  ),
  // Net
  Technique(
    id: 'net_shot',
    kind: TechniqueKind.stroke,
    name: 'Netdrop',
    category: 'Net',
    summary:
        'Et blødt slag ved nettet, der lige går over og falder tæt på nettet '
        'hos modstanderen.',
    whenToUse:
        'Når fjerbolden er under nethøjde ved nettet. Et godt netdrop '
        'tvinger modstanderen til at løfte.',
    keyPoints: [
      'Gå frem med et udfald på højre ben.',
      'Ketsjeren oppe foran, så du træffer fjerbolden så højt som muligt.',
      'Blød hånd: fingrene styrer, ikke armen.',
      'Et spinnende netdrop (skåret) er svært at returnere.',
      'Kom tilbage fra udfaldet med et skub fra forreste ben.',
    ],
    commonMistakes: [
      'Træffer for lavt og for sent.',
      'Fjerbolden går for højt over nettet og bliver dræbt.',
      'Forreste knæ går ind over tæerne i udfaldet.',
    ],
  ),
  Technique(
    id: 'net_kill',
    kind: TechniqueKind.stroke,
    name: 'Net kill',
    category: 'Net',
    summary:
        'Et hurtigt nedadgående slag ved nettet, når modstanderens slag er '
        'for højt.',
    whenToUse:
        'Når fjerbolden kommer over nettet i god højde. Det afslutter ofte '
        'duellen.',
    keyPoints: [
      'Ketsjeren skal være oppe, klar ved nettet.',
      'Kort, hurtigt slag: prik eller "tip" fjerbolden ned.',
      'Stop ketsjeren efter træffet, så du ikke rører nettet.',
      'Sigt efter gulvet mellem modstanderne eller mod kroppen.',
    ],
    commonMistakes: [
      'Svinger for meget og rammer nettet.',
      'Ketsjeren er nede og når ikke op i tide.',
    ],
  ),
  Technique(
    id: 'lift',
    kind: TechniqueKind.stroke,
    name: 'Lift (løft)',
    category: 'Net',
    summary:
        'Et højt slag fra forreste del af banen helt tilbage til '
        'modstanderens bagbane.',
    whenToUse:
        'Når fjerbolden er for lav til et netdrop. Et højt lift giver tid, et '
        'fladere angrebslift presser modstanderen bagud.',
    keyPoints: [
      'Udfald frem med højre ben.',
      'Kort sving fra underarm og håndled, ikke et stort armsving.',
      'Sigt højt og helt tilbage til baglinjen.',
      'Brug samme forberedelse som til netdrop, så modstanderen ikke kan '
          'læse slaget.',
    ],
    commonMistakes: [
      'For kort lift, som bliver smashet.',
      'Store sving, så man ikke kommer tilbage i tide.',
    ],
  ),
];

const footwork = <Technique>[
  Technique(
    id: 'split_step',
    kind: TechniqueKind.footwork,
    name: 'Grundposition og split step',
    category: 'Grundlag',
    summary:
        'Et lille hop på stedet, lige når modstanderen slår, så du lander '
        'klar til at starte i alle retninger.',
    whenToUse: 'Før hvert eneste af modstanderens slag.',
    keyPoints: [
      'Stå i midten af banen med fødderne i skulderbreddes afstand.',
      'Let bøjede knæ, vægten på forfødderne.',
      'Lav et lille hop, så du lander præcis når modstanderen træffer.',
      'Land lidt bredere end du stod, og skub fra i den retning, fjerbolden '
          'går.',
    ],
    commonMistakes: [
      'Hopper for tidligt eller for sent.',
      'Hopper for højt, så du hænger i luften.',
      'Står på hælene.',
    ],
  ),
  Technique(
    id: 'chasse',
    kind: TechniqueKind.footwork,
    name: 'Chassé (sideskridt)',
    category: 'Bevægelse',
    summary:
        'Sideskridt hvor den bagerste fod lukker op til den forreste, uden at '
        'fødderne krydser.',
    whenToUse:
        'Til at bevæge sig hurtigt sidelæns og til de fleste bevægelser frem '
        'og tilbage på banen.',
    keyPoints: [
      'Hold kroppen lav og front i bevægelsesretningen.',
      'Bagerste fod lukker op til forreste, derefter skubber forreste fod '
          'videre.',
      'Små, hurtige skridt frem for store.',
    ],
    commonMistakes: [
      'Fødderne samles helt eller krydser.',
      'Rejser sig op mellem skridtene.',
    ],
  ),
  Technique(
    id: 'crossover',
    kind: TechniqueKind.footwork,
    name: 'Løbe- og krydsskridt',
    category: 'Bevægelse',
    summary:
        'Almindelige løbeskridt, hvor fødderne krydser. Dækker længere '
        'afstande hurtigt.',
    whenToUse:
        'Til lange bevægelser, fx fra bagbanen helt frem til nettet, eller '
        'når du er presset.',
    keyPoints: [
      'Start eksplosivt fra split step.',
      'Sidste skridt skal altid være med ketsjerbenet (højre).',
      'Tæl dine skridt til hvert hjørne, så de sidder automatisk.',
    ],
    commonMistakes: [
      'Ender med forkert fod forrest.',
      'For mange små skridt, så du bliver langsom.',
    ],
  ),
  Technique(
    id: 'lunge',
    kind: TechniqueKind.footwork,
    name: 'Udfald (lunge)',
    category: 'Til nettet',
    summary:
        'Et langt sidste skridt frem med ketsjerbenet, så du når fjerbolden '
        'ved nettet og hurtigt kan komme tilbage.',
    whenToUse: 'Ved alle slag i forreste del af banen: netdrop, lift og kill.',
    keyPoints: [
      'Land på hælen, og rul frem på foden.',
      'Knæet peger samme vej som foden og er over anklen, ikke foran tæerne.',
      'Bagerste fod bliver på gulvet og trækkes med.',
      'Overkroppen er rank; ræk med ketsjeren, ikke med ryggen.',
      'Skub kraftigt tilbage fra forreste ben.',
    ],
    commonMistakes: [
      'Knæet falder indad eller langt frem over tæerne (belaster knæet).',
      'Overkroppen læner sig langt frem.',
      'For kort udfald, så man ikke når fjerbolden.',
    ],
  ),
  Technique(
    id: 'scissor_kick',
    kind: TechniqueKind.footwork,
    name: 'Saksehop',
    category: 'Til bagbanen',
    summary:
        'Et hop ved slag i bagbanen, hvor benene skifter plads i luften, så '
        'du lander med vægten fremad.',
    whenToUse: 'Ved clear, drop og smash fra forhåndssiden i bagbanen.',
    keyPoints: [
      'Gå baglæns med chassé, så du står sidelæns bag fjerbolden.',
      'Sæt af på højre ben.',
      'Benene skifter i luften: venstre går bagud, højre frem.',
      'Land på venstre ben og skub straks frem mod midten.',
    ],
    commonMistakes: [
      'Lander på begge ben og mister farten fremad.',
      'Kommer ikke bag fjerbolden før hoppet.',
    ],
  ),
  Technique(
    id: 'backhand_corner',
    kind: TechniqueKind.footwork,
    name: 'Baghåndshjørnet',
    category: 'Til bagbanen',
    summary:
        'Bevægelsen til det bagerste venstre hjørne: enten rundt om hovedet '
        'med forhånd eller med ryggen til nettet med baghånd.',
    whenToUse:
        'Når modstanderen spiller langt til din baghåndsside. Vælg forhånd '
        'rundt om hovedet, når du kan nå det, ellers baghånd.',
    keyPoints: [
      'Rundt om hovedet: drej kroppen, og gå baglæns med chassé.',
      'Baghånd: drej ryggen mod nettet, og tag sidste skridt med højre ben.',
      'Beslut dig tidligt, så du ikke står og tøver.',
      'Kom hurtigt tilbage til midten efter slaget.',
    ],
    commonMistakes: [
      'Tøver mellem forhånd og baghånd.',
      'Går for langt tilbage og slår fjerbolden bag kroppen.',
    ],
  ),
  Technique(
    id: 'six_corner',
    kind: TechniqueKind.footwork,
    name: '6-hjørne-mønster og retur til midten',
    category: 'Mønstre',
    summary:
        'Bevægelse til banens seks punkter (to ved nettet, to i siderne og to '
        'bagerst) og tilbage til midten efter hvert slag.',
    whenToUse:
        'Grundlaget for al bevægelse på banen. Trænes især som skygge-'
        'badminton uden fjerbold.',
    keyPoints: [
      'Start og slut altid i midten med split step.',
      'Samme antal skridt til samme hjørne hver gang.',
      'Sidste skridt mod hjørnet med ketsjerbenet.',
      'Returen er lige så vigtig som vejen ud.',
    ],
    commonMistakes: [
      'Bliver stående i hjørnet efter slaget.',
      'Står for langt tilbage i "midten", så nettet bliver langt væk.',
    ],
  ),
];

const drills = <Drill>[
  Drill(
    id: 'clear_duel',
    name: 'Clear-duel',
    purpose: 'Træner længde og højde i clear og at komme bag fjerbolden.',
    techniqueIds: ['clear', 'scissor_kick', 'split_step'],
    minPlayers: 2,
    minutes: 10,
    level: DrillLevel.beginner,
    steps: [
      'Begge spillere står i hver sin bagbane.',
      'Spil høje clears frem og tilbage, lige over hinanden.',
      'Gå tilbage i midten med split step mellem hvert slag.',
      'Variér: skift til krydsclear efter 5 minutter.',
    ],
    tips: [
      'Tæl hvor mange clears der lander bag den bagerste double-servelinje.',
      'Fokusér på at træffe fjerbolden foran kroppen.',
    ],
  ),
  Drill(
    id: 'clear_drop_net',
    name: 'Clear, drop og net',
    purpose:
        'Klassisk rutine der kombinerer bagbane og net og træner '
        'bevægelsen mellem dem.',
    techniqueIds: ['clear', 'drop', 'net_shot', 'lift'],
    minPlayers: 2,
    minutes: 15,
    level: DrillLevel.intermediate,
    steps: [
      'A slår clear, B clearer tilbage.',
      'A slår drop, B spiller netdrop.',
      'A løfter til B\'s bagbane, og rutinen starter forfra med B som '
          'clearer.',
      'Kør 5 minutter, og byt så roller.',
    ],
    tips: [
      'Brug samme forberedelse til clear og drop.',
      'Kom tilbage til midten efter hvert slag, også selvom du ved, hvor '
          'næste slag kommer.',
    ],
  ),
  Drill(
    id: 'smash_defence',
    name: 'Smash og forsvar',
    purpose: 'Træner både angreb (smash) og forsvar (block og lift).',
    techniqueIds: ['smash', 'defence', 'lift'],
    minPlayers: 2,
    minutes: 10,
    level: DrillLevel.intermediate,
    steps: [
      'A løfter højt til B.',
      'B smasher.',
      'A forsvarer med et langt løft, og B smasher igen.',
      'Efter 10 smash: A skal i stedet blocke kort, og B går frem og løfter.',
      'Byt roller.',
    ],
    tips: [
      'Smasheren skal træffe foran kroppen og sigte mod sidelinjerne.',
      'Forsvareren laver split step, når smasheren slår.',
    ],
  ),
  Drill(
    id: 'drive_duel',
    name: 'Drive-duel',
    purpose: 'Træner hurtige hænder og korte slag i midtbanen.',
    techniqueIds: ['drive', 'push', 'split_step'],
    minPlayers: 2,
    minutes: 8,
    level: DrillLevel.beginner,
    steps: [
      'Stå i hver sin midtbane tæt på servelinjen.',
      'Spil flade drives frem og tilbage i nethøjde.',
      'Skift mellem forhånd og baghånd.',
      'Afslut en duel med et push, når en af jer får et højt slag.',
    ],
    tips: [
      'Hold ketsjeren oppe foran kroppen hele tiden.',
      'Små sving: det er tempoet, der gør det svært.',
    ],
  ),
  Drill(
    id: 'net_duel',
    name: 'Net-duel',
    purpose: 'Træner blød hånd ved nettet og at dræbe for høje net-slag.',
    techniqueIds: ['net_shot', 'net_kill', 'lunge'],
    minPlayers: 2,
    minutes: 8,
    level: DrillLevel.beginner,
    steps: [
      'Begge står ved nettet i hver sin forreste del af banen.',
      'Spil netdrop frem og tilbage.',
      'Hvis et slag går for højt, må modstanderen dræbe det.',
      'Tæl point: hvem vinder først 11?',
    ],
    tips: [
      'Træf fjerbolden så højt som muligt.',
      'Gå tilbage et lille skridt mellem slagene, og brug udfald ud.',
    ],
  ),
  Drill(
    id: 'serve_targets',
    name: 'Serv på mål',
    purpose: 'Træner præcision i kort og lang serv. Kan laves alene.',
    techniqueIds: ['serve_short', 'serve_long'],
    minPlayers: 1,
    minutes: 10,
    level: DrillLevel.beginner,
    steps: [
      'Læg et mål (fx et håndklæde eller en kegle) i hjørnerne af '
          'servefeltet.',
      'Serv 20 korte serv mod forreste hjørner og tæl træffere.',
      'Serv 20 lange serv mod bagerste hjørner.',
      'Notér antal træffere, så du kan se udviklingen.',
    ],
    tips: [
      'Brug samme rutine før hver serv.',
      'En snor spændt 10-15 cm over nettet viser, om den korte serv er lav '
          'nok.',
    ],
  ),
  Drill(
    id: 'serve_receive',
    name: 'Serv og returnering',
    purpose: 'Træner serv og det vigtige første angreb på modtagers side.',
    techniqueIds: ['serve_short', 'serve_long', 'push', 'net_kill'],
    minPlayers: 2,
    minutes: 10,
    level: DrillLevel.intermediate,
    steps: [
      'A server skiftevis kort og langt, uden at sige hvad.',
      'B returnerer: kort serv med push eller kill, lang serv med clear '
          'eller smash.',
      'Spil duellen ud til 3 slag, og start forfra.',
      'Byt roller efter 10 serv.',
    ],
    tips: [
      'Modtager står med ketsjeren oppe og vægten fremme.',
      'Server varierer rytmen, så modtager ikke kan gætte.',
    ],
  ),
  Drill(
    id: 'lift_accuracy',
    name: 'Lift til baglinjen',
    purpose:
        'Træner at løfte helt tilbage fra nettet, så løftet ikke bliver '
        'angrebet.',
    techniqueIds: ['lift', 'lunge'],
    minPlayers: 2,
    minutes: 10,
    level: DrillLevel.beginner,
    steps: [
      'B står i bagbanen og slår drop til A.',
      'A går frem med udfald og løfter højt tilbage.',
      'Løft skiftevis lige og på kryds.',
      'Byt efter 5 minutter.',
    ],
    tips: [
      'Et løft der lander foran den bagerste double-servelinje er for kort.',
      'Kort sving: kraften kommer fra underarm og håndled.',
    ],
  ),
  Drill(
    id: 'multi_feed_net',
    name: 'Multi-fjer ved nettet',
    purpose:
        'Mange gentagelser af netspil og udfald på kort tid. Kræver en '
        'fodrer med mange fjerbolde.',
    techniqueIds: ['net_shot', 'net_kill', 'lunge', 'chasse'],
    minPlayers: 2,
    minutes: 10,
    level: DrillLevel.intermediate,
    steps: [
      'Fodreren står ved nettet med 20-30 fjerbolde og kaster dem skiftevis '
          'til forhånd og baghånd.',
      'Spilleren starter i midten, går frem med udfald og spiller netdrop.',
      'Hver 4. fjerbold kastes højere, og spilleren dræber den.',
      'Serier på 20 fjerbolde med pause imellem.',
    ],
    tips: [
      'Kom helt tilbage til midten mellem hver fjerbold.',
      'Fodreren styrer tempoet efter spillerens niveau.',
    ],
  ),
  Drill(
    id: 'multi_feed_rear',
    name: 'Multi-fjer i bagbanen',
    purpose: 'Mange gentagelser af slag fra begge bagerste hjørner.',
    techniqueIds: ['clear', 'smash', 'drop', 'scissor_kick', 'backhand_corner'],
    minPlayers: 2,
    minutes: 10,
    level: DrillLevel.intermediate,
    steps: [
      'Fodreren står på den anden side af nettet og slår højt skiftevis til '
          'forhånds- og baghåndshjørnet.',
      'Spilleren skifter mellem clear, drop og smash.',
      'Brug saksehop i forhåndshjørnet og rundt om hovedet i '
          'baghåndshjørnet.',
      'Serier på 15-20 fjerbolde.',
    ],
    tips: [
      'Retur til midten efter hvert slag.',
      'Kvalitet før tempo: hellere færre slag, der sidder rigtigt.',
    ],
  ),
  Drill(
    id: 'shadow_six',
    name: 'Skyggebadminton, 6 hjørner',
    purpose:
        'Træner benarbejde og kondition uden fjerbold. Kan laves alene og '
        'næsten hvor som helst.',
    techniqueIds: [
      'six_corner',
      'split_step',
      'chasse',
      'crossover',
      'lunge',
      'scissor_kick',
    ],
    minPlayers: 1,
    minutes: 10,
    level: DrillLevel.beginner,
    steps: [
      'Start i midten med split step.',
      'Bevæg dig til et hjørne, lav slag-bevægelsen, og kom tilbage.',
      'Tag hjørnerne i fast rækkefølge først, derefter tilfældigt.',
      'Arbejd 30 sekunder og hold 30 sekunders pause. 8-10 runder.',
    ],
    tips: [
      'En makker kan pege på hjørnerne, så det bliver tilfældigt.',
      'Tjek at sidste skridt mod hvert hjørne er med ketsjerbenet.',
    ],
  ),
  Drill(
    id: 'split_step_reaction',
    name: 'Split-step-reaktion',
    purpose: 'Træner timing af split step og hurtig første bevægelse.',
    techniqueIds: ['split_step', 'chasse'],
    minPlayers: 2,
    minutes: 8,
    level: DrillLevel.beginner,
    steps: [
      'Spilleren står i midten. Makkeren står på den anden side af nettet.',
      'Makkeren laver en slag-bevægelse og peger på et hjørne.',
      'Spilleren laver split step i det øjeblik makkeren "slår", og starter '
          'mod hjørnet.',
      'Tag 2-3 skridt, og kom tilbage.',
    ],
    tips: [
      'Hoppet skal være lille og lande præcis på "slaget".',
      'Variér rytmen, så spilleren ikke kan gætte timingen.',
    ],
  ),
  Drill(
    id: 'lunge_series',
    name: 'Udfaldsserier',
    purpose:
        'Styrke og teknik i udfaldet, som er den mest belastende bevægelse '
        'for knæet.',
    techniqueIds: ['lunge'],
    minPlayers: 1,
    minutes: 8,
    level: DrillLevel.beginner,
    steps: [
      'Stå ved servelinjen.',
      'Lav udfald frem med ketsjerbenet, skiftevis lige frem og ud til '
          'siderne.',
      'Skub tilbage til startpositionen.',
      '3 serier af 10 udfald til hver retning.',
    ],
    tips: [
      'Brug et spejl eller film dig selv: knæet skal pege samme vej som '
          'foden.',
      'Stop hvis det gør ondt i knæet.',
    ],
  ),
  Drill(
    id: 'backhand_corner_drill',
    name: 'Baghåndshjørnet',
    purpose:
        'Træner bevægelsen til baghåndshjørnet og valget mellem rundt om '
        'hovedet og baghånd.',
    techniqueIds: ['backhand', 'backhand_corner', 'crossover'],
    minPlayers: 2,
    minutes: 10,
    level: DrillLevel.advanced,
    steps: [
      'Makkeren slår høje slag til dit baghåndshjørne.',
      'Tag dem skiftevis rundt om hovedet og med baghånd.',
      'Spil clear eller drop lige frem.',
      'Makkeren skruer op for tempoet, så du bliver tvunget til baghånd.',
    ],
    tips: [
      'Beslut dig tidligt.',
      'Baghånd: ryggen mod nettet og sidste skridt med højre ben.',
    ],
  ),
  Drill(
    id: 'two_vs_one_defence',
    name: '2 mod 1: forsvar',
    purpose:
        'Én spiller forsvarer mod to angribere. Hård træning af forsvar, '
        'split step og kondition.',
    techniqueIds: ['defence', 'lift', 'drive', 'split_step'],
    minPlayers: 3,
    minutes: 15,
    level: DrillLevel.advanced,
    steps: [
      'To spillere angriber fra den ene side (en bagerst, en ved nettet).',
      'Forsvareren står alene på den anden side og skal løfte, blocke eller '
          'drive alt tilbage.',
      'Serier på 1-2 minutter, derefter bytter en ny ind som forsvarer.',
    ],
    tips: [
      'Forsvareren holder sig lav og træffer foran kroppen.',
      'Angriberne varierer mellem smash, drop og kill.',
    ],
  ),
  Drill(
    id: 'drop_kill',
    name: 'Drop og afslutning ved nettet',
    purpose: 'Træner at følge op på sit eget drop og afslutte ved nettet.',
    techniqueIds: ['drop', 'net_kill', 'crossover', 'lunge'],
    minPlayers: 2,
    minutes: 10,
    level: DrillLevel.intermediate,
    steps: [
      'B løfter til A\'s bagbane.',
      'A slår drop og løber straks frem.',
      'B spiller et lidt for højt netdrop.',
      'A dræber ved nettet og går tilbage til midten.',
    ],
    tips: [
      'Første skridt frem skal komme allerede i landingen efter dropet.',
      'Ketsjeren op, mens du løber frem.',
    ],
  ),
];

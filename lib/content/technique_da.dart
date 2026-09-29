// Dansk indhold til teknik-biblioteket. Beskrivelserne tager udgangspunkt i
// en højrehåndet spiller. De er generel træningsviden og erstatter ikke en
// træner. Indholdet skal stemme med vidensbanken i docs/viden/ (teknik.md,
// benarbejde.md og regler.md), som har kilderne.

import 'technique.dart';

const strokes = <Technique>[
  // Grundlag
  Technique(
    id: 'grips',
    kind: TechniqueKind.stroke,
    name: 'Greb',
    category: 'Grundlag',
    summary:
        'De fire greb, som alle slag bygger på: basisgreb, tommelgreb, '
        'hjørnegreb og stegepandegreb.',
    whenToUse:
        'Hele tiden. Basisgrebet er udgangspunktet mellem slagene, og du '
        'skifter greb efter, hvor fjerbolden er i forhold til kroppen.',
    keyPoints: [
      'Basisgreb (V-greb): tommel og pegefinger danner et V på skaftet, som '
          'når man giver hånd. Til forhånd og til slag ved siden af kroppen.',
      'Tommelgreb: tommelfingeren på skaftets brede, flade side. Til baghånd '
          'foran kroppen: kort serv, netdrop, lift, net kill og drive.',
      'Hjørnegreb: tommelfingeren på skaftets skrå kant. Til baghånd ved '
          'siden af eller lidt bag kroppen, fx clear og drop fra '
          'baghåndshjørnet.',
      'Stegepandegreb: ketsjerfladen vender mod nettet. Til forhånd langt '
          'foran kroppen, fx net kill, og til baghånd langt bag kroppen.',
      'Hold løst mellem slagene, og klem først til i træffet. Så kan '
          'fingrene dreje grebet hurtigt.',
    ],
    commonMistakes: [
      'Bruger stegepandegreb til alt. Det gør især baghånden og slag bagfra '
          'svage.',
      'Klemmer hårdt hele tiden, så grebsskift bliver langsomme, og armen '
          'bliver træt.',
    ],
  ),
  // Serv
  Technique(
    id: 'serve_short',
    kind: TechniqueKind.stroke,
    name: 'Kort serv',
    category: 'Serv',
    summary:
        'En lav serv, der lige går over nettet og lander i forreste del af '
        'modstanderens servefelt. Den mest brugte serv i double.',
    whenToUse:
        'Standard i double og mixed, og som variation i single, så '
        'modstanderen ikke kan angribe serven.',
    keyPoints: [
      'Kort tommelgreb: tommelfingeren på skaftets brede, flade side, og hold '
          'højt oppe på grebet.',
      'Hold fjerbolden ved fjerene foran kroppen. Hele fjerbolden skal være '
          'under 1,15 m, når du rammer den.',
      'Slip fjerbolden uden at give den spin, og ram korken først. Spin-serv '
          'er forbudt siden 2025.',
      'Skub ketsjeren frem med en rolig bevægelse fra underarm og tommel, '
          'ikke med et sving fra skulderen.',
      'Fjerbolden skal toppe på din side af nettet og falde ned over det.',
      'Stå klar i en let fremadlænet position, så du er klar til næste slag.',
    ],
    commonMistakes: [
      'Serven går for højt over nettet og bliver angrebet.',
      'For stort sving giver ujævn længde.',
      'Fjerbolden er over 1,15 m ved træffet (servefejl).',
      'Ketsjeren stopper eller tøver i fremadbevægelsen (servefejl).',
    ],
  ),
  Technique(
    id: 'serve_forehand_low',
    kind: TechniqueKind.stroke,
    name: 'Kort forhåndsserv',
    category: 'Serv',
    summary:
        'En lav serv med forhånd, der lige går over nettet og lander forrest '
        'i modstanderens servefelt.',
    whenToUse:
        'Mest i single, hvor den er et alternativ til den høje serv. I double '
        'bruges næsten altid den korte baghåndsserv.',
    keyPoints: [
      'Stå sidelæns i servefeltet med vægten på bagerste ben. Basisgreb, og '
          'hold ketsjer og fjerbold højt.',
      'Flyt vægten frem, og slip fjerbolden til siden og lidt foran dig.',
      'Bøj håndleddet bagud, og hold det bøjet, mens du skubber fjerbolden '
          'over. Intet slag fra håndleddet.',
      'Hele fjerbolden skal være under 1,15 m, når du rammer den, og den må '
          'ikke få spin.',
      'Lad den korte, den høje og flick-serven ligne hinanden, så '
          'modtageren ikke kan læse dig.',
    ],
    commonMistakes: [
      'Håndleddet knækker frem i træffet, så serven bliver for høj eller for '
          'lang.',
      'Fjerbolden er over 1,15 m ved træffet (servefejl).',
      'Står med front mod nettet, så vægtoverførslen mangler.',
    ],
  ),
  Technique(
    id: 'serve_flick',
    kind: TechniqueKind.stroke,
    name: 'Flick-serv',
    category: 'Serv',
    summary:
        'En serv, der ligner en kort serv, men i sidste øjeblik bliver '
        'flicket op over modtageren og bagud.',
    whenToUse:
        'Mod en modtager, der står langt fremme og angriber den korte serv. '
        'Mest i double, men også i single. I double skal den lande inden for '
        'den lange servelinje for double.',
    keyPoints: [
      'Samme greb, stilling og forberedelse som den korte serv. Det er hele '
          'pointen.',
      'Kort bagsving med bøjet håndled og åben ketsjerflade.',
      'Accelerér ketsjerhovedet pludseligt frem og op i sidste øjeblik.',
      'Sigt lige over modtagerens ketsjer. Den skal ikke være så høj som en '
          'lang serv, men modtageren må ikke kunne nå den i luften.',
      'De samme serveregler gælder: under 1,15 m, ingen spin og ingen pause '
          'i fremadbevægelsen.',
    ],
    commonMistakes: [
      'Forberedelsen afslører serven, fx med et længere bagsving.',
      'For lav, så modtageren kan smashe den.',
      'Bruges så tit, at modtageren står og venter på den.',
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
      'Slip fjerbolden, og sving ketsjeren i en lang bue under og op. Ram '
          'under fjerbolden med underarmsrotation og et strakt håndled.',
      'Hele fjerbolden skal være under 1,15 m, når du rammer den.',
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
      'Træf fjerbolden så højt som muligt, over og lidt foran slagskulderen.',
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
    id: 'pulled_drop',
    kind: TechniqueKind.stroke,
    name: 'Trukket drop',
    category: 'Bagbane',
    summary:
        'Et roligt drop fra et presset bagerste hjørne, hvor fjerbolden '
        '"trækkes" over nettet med mindre armrotation.',
    whenToUse:
        'Når du er presset, og fjerbolden er bag dig i et af de bagerste '
        'hjørner. Den lander i modstanderens forreste midtbane, lige bag den '
        'korte servelinje, og gør det svært at angribe dig.',
    keyPoints: [
      'Bøj albuen, og drej grebet mod tommelgreb (forhånd) eller mod '
          'hjørne- eller stegepandegreb (baghånd). Jo mere kryds, jo mere '
          'drejer du.',
      'Ræk afslappet ud, og kom med hånden ind under fjerbolden.',
      'Mindsk armrotationen lige før træffet, og skub igennem fjerbolden.',
      'Træffet sker lidt bag kroppen. Brug udsvinget til hurtigt at vende '
          'dig mod nettet.',
      'Sæt forreste fod i gulvet samtidig med eller lige før træffet.',
    ],
    commonMistakes: [
      'Slår for hårdt, så dropet bliver langt og kan angribes.',
      'Kommer for sent bagud og rammer fjerbolden alt for langt bag kroppen.',
      'Bliver stående med ryggen til banen efter slaget.',
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
    id: 'jump_smash',
    kind: TechniqueKind.stroke,
    name: 'Hop-smash',
    category: 'Bagbane',
    summary:
        'En smash, hvor du hopper og drejer i luften, så du rammer højere og '
        'tidligere og får en stejlere vinkel.',
    whenToUse:
        'For øvede og elite. Når fjerbolden er høj og ikke for langt '
        'tilbage, og du har tid til at komme bag den. Den koster meget '
        'energi og belaster benene, så brug den til at afslutte, ikke i hver '
        'duel.',
    keyPoints: [
      'Tag et skridt bagud, så bagerste ben er ladet, og stå sidelæns.',
      'Hop op, og begynd at dreje kroppen i luften.',
      'Albuen op og frem, og underarmen drejet udad, som når man reder hår.',
      'Kast ketsjerhovedet frem med kraftig indadrotation, og ræk op, så du '
          'rammer foran slagskulderen.',
      'Land blødt på forfoden med bøjede ankler, knæ og hofter, og gå '
          'straks frem.',
    ],
    commonMistakes: [
      'Hopper for tidligt eller står under fjerbolden, så træffet sker bag '
          'hovedet.',
      'Lander hårdt på stive ben (belaster knæ og ankel).',
      'Hopper så højt, at du ikke når tilbage til næste slag.',
      'Laver mange gentagelser, før landingen sidder.',
    ],
  ),
  Technique(
    id: 'around_the_head',
    kind: TechniqueKind.stroke,
    name: 'Rundt om hovedet',
    category: 'Bagbane',
    summary:
        'Et forhåndsslag over hovedet fra baghåndssiden. Du bøjer '
        'overkroppen til venstre og rammer fjerbolden over eller lidt til '
        'venstre for hovedet.',
    whenToUse:
        'Når fjerbolden kommer højt til dit baghåndshjørne, og du kan nå at '
        'komme bag den. Det giver et stærkere slag end baghånd, fordi du kan '
        'slå clear, drop og smash som med forhånd.',
    keyPoints: [
      'Drej kroppen, og gå baglæns med chassé, så du kommer bag fjerbolden.',
      'Bøj overkroppen til venstre, og før albuen højt op over hovedet.',
      'Ram med underarmsrotation over eller lidt til venstre for hovedet og '
          'lige så højt som ved en clear.',
      'Samme forberedelse til clear, drop og smash.',
      'Brug et saksehop, og skub straks tilbage mod midten.',
    ],
    commonMistakes: [
      'Kommer ikke bag fjerbolden og rammer den bag hovedet.',
      'Vælger rundt om hovedet, når fjerbolden er for dyb, i stedet for '
          'baghånd.',
      'Går så langt ud i hjørnet, at det er svært at komme tilbage.',
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
      'Basisgreb eller hjørnegreb, ikke det flade tommelgreb, som bruges til '
          'slag foran kroppen.',
      'Albuen løftes og peger op, og slaget kommer fra underarmsrotation: et '
          'kort "punch", hvor hånden stopper brat.',
      'Træf fjerbolden højt, ved siden af eller lidt bag kroppen.',
      'Drej straks rundt og kom tilbage mod midten.',
    ],
    commonMistakes: [
      'Træffer for lavt og for sent, så slaget bliver kort.',
      'Bruger forhåndsgreb eller det flade tommelgreb.',
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
      'Forhånd evt. i stegepandegreb, baghånd i tommelgreb. Skift hurtigt.',
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
      'Block: åben ketsjerflade, ram lidt under fjerbolden, og skub den blødt '
          'over. Brug smashens fart i stedet for at svinge.',
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
      'Har du tid, så giv fjerbolden spin (se Spin-netdrop).',
      'Kom tilbage fra udfaldet med et skub fra forreste ben.',
    ],
    commonMistakes: [
      'Træffer for lavt og for sent.',
      'Fjerbolden går for højt over nettet og bliver dræbt.',
      'Forreste knæ går ind over tæerne i udfaldet.',
    ],
  ),
  Technique(
    id: 'net_spin',
    kind: TechniqueKind.stroke,
    name: 'Spin-netdrop',
    category: 'Net',
    summary:
        'Et netdrop, hvor fjerbolden får spin, så den vælter rundt over '
        'nettet og er svær at ramme rent.',
    whenToUse:
        'Ved nettet, når fjerbolden er under nethøjde, og du har lidt tid. '
        'Spin er kun forbudt i serven, ikke i spillet.',
    keyPoints: [
      'Samme forberedelse som et almindeligt netdrop: udfald og ketsjeren '
          'frem.',
      'Ram på tværs under fjerbolden i en let buet bane, fx fra højre mod '
          'venstre.',
      'Lad fingrene styre ketsjeren. Bevægelsen er lille.',
      'Ram så højt og tæt på nettet som muligt.',
      'Få ketsjeren op efter slaget, klar til et svar ved nettet.',
    ],
    commonMistakes: [
      'For stor bevægelse, så fjerbolden går for højt.',
      'Forsøger spin fra for lav en position, så fjerbolden ikke når over.',
      'Bliver stående ved nettet og kommer for sent til næste slag.',
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
      'Forhånd: skift til stegepandegreb. Baghånd: tommelgreb.',
      'Kort, hurtigt slag: prik eller "tip" fjerbolden ned.',
      'Stop ketsjeren efter træffet, så du ikke rører nettet.',
      'Sigt efter gulvet mellem modstanderne eller mod kroppen.',
      'Få hurtigt ketsjeren op igen efter slaget.',
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
      'Stå i din basisposition, typisk omkring midten. Den flytter sig efter, '
          'hvor modstanderen kan slå hen.',
      'Fødderne i skulderbreddes afstand.',
      'Let bøjede knæ, vægten på forfødderne.',
      'Lav et lavt hop lige før modstanderen rammer, så du lander, når '
          'fjerbolden bliver ramt.',
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
    id: 'jump_landing',
    kind: TechniqueKind.footwork,
    name: 'Hop og landing',
    category: 'Grundlag',
    summary:
        'Sådan sætter du af og lander sikkert. Grundlaget for hop-smash, '
        'saksehop og hurtige retningsskift, og vigtigt for at undgå skader.',
    whenToUse:
        'Ved alle hop på banen. Træn det for sig, før du laver mange '
        'hop-smash eller saksehop. God for børn og begyndere.',
    keyPoints: [
      'Start fra en god squat: hælene nede, sid tilbage, brystet op, og hold '
          'ryg og skinneben parallelle.',
      'Sving armene ned og tilbage og derefter frem og op, når du sætter af.',
      'Stræk ankler, knæ og hofter helt ud i luften.',
      'Land på forfoden først, og bøj ankler, knæ og hofter for at tage '
          'stødet.',
      'Knæene peger samme vej som tæerne, også i landingen.',
    ],
    commonMistakes: [
      'Lander på stive ben eller på hælene.',
      'Knæene falder indad i landingen.',
      'Brystet falder frem, så balancen går tabt.',
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
      'Hold kroppen lav og hovedet i samme højde. Glid, og spring ikke op.',
      'Den ene fod "jager" den anden uden helt at nå den, og derefter skubber '
          'den forreste fod videre.',
      'Kort jordkontakt i hvert skridt.',
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
      'Fremad: hæl-tå og længere skridt. Baglæns: på tæerne, korte og hurtige '
          'skridt.',
      'Sidste skridt mod nettet (udfaldet) er med ketsjerbenet (højre).',
      'Tæl dine skridt til hvert hjørne, så de sidder automatisk.',
    ],
    commonMistakes: [
      'Ender med forkert fod forrest.',
      'For mange små skridt, så du bliver langsom.',
    ],
  ),
  Technique(
    id: 'cross_behind',
    kind: TechniqueKind.footwork,
    name: 'Bagom-skridt (cross-behind)',
    category: 'Bevægelse',
    summary:
        'Et skridt, hvor det frie ben (venstre) føres bag om ketsjerbenet. '
        'Dækker afstand til siden og bagud.',
    whenToUse:
        'Når du skal hurtigt ud til siden eller bagud, fx mod forhåndssiden '
        'i bagbanen. Det er sjældent mere end ét ad gangen.',
    keyPoints: [
      'Start fra split step.',
      'Før venstre ben bag om højre, og hold hofterne drejet mod siden.',
      'Tag kun ét bagom-skridt, og fortsæt med chassé eller et hop.',
      'Hold overkroppen rank og hovedet i samme højde.',
    ],
    commonMistakes: [
      'Flere bagom-skridt i træk, så balancen går tabt.',
      'Krydser foran i stedet for bagom og vender forkert.',
    ],
  ),
  Technique(
    id: 'hop_pivot',
    kind: TechniqueKind.footwork,
    name: 'Hop og pivot',
    category: 'Bevægelse',
    summary:
        'Små hop, hvor du sætter af og lander på samme fod, ofte med en '
        'drejning. Vender kroppen hurtigt og dækker afstand.',
    whenToUse:
        'Fx mod baghåndsnettet (pivot om venstre fod) og mod '
        'baghåndshjørnet, hvor kroppen skal drejes hurtigt.',
    keyPoints: [
      'Sæt af og land på samme fod.',
      'Drej i luften eller på forfoden, så kroppen peger derhen, hvor du '
          'skal.',
      'Hoppet skal mest give afstand, ikke højde.',
      'Øv pivot på begge ben og i begge retninger.',
    ],
    commonMistakes: [
      'Hopper op i stedet for hen ad gulvet.',
      'Drejer på hælen og mister farten.',
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
      'Forreste fod peger mod fjerbolden, og knæet peger samme vej som foden.',
      'Bøj bagerste knæ. Bagerste fod bliver på gulvet og trækkes med.',
      'Stræk den bagerste arm ud for at holde balancen.',
      'Overkroppen er rank; ræk med ketsjeren, ikke med ryggen.',
      'Skub kraftigt tilbage fra forreste ben.',
    ],
    commonMistakes: [
      'Knæet falder indad eller peger en anden vej end foden (belaster knæet).',
      'Overkroppen læner sig langt frem.',
      'For kort udfald, så man ikke når fjerbolden.',
    ],
  ),
  Technique(
    id: 'forehand_net',
    kind: TechniqueKind.footwork,
    name: 'Til forhåndsnettet',
    category: 'Til nettet',
    summary:
        'Vejen fra midten frem til det forreste højre hjørne og tilbage '
        'igen.',
    whenToUse:
        'Når modstanderen spiller drop eller netdrop til din forhåndsside.',
    keyPoints: [
      'Split step, når modstanderen slår.',
      'Ketsjerbenet (højre) fører. Chassé frem mod hjørnet.',
      'Afslut med et udfald på højre ben, hvor foden peger mod fjerbolden.',
      'Ketsjeren oppe foran, så du rammer højt.',
      'Skub fra med højre ben, og kom tilbage med chassé eller et par '
          'skridt.',
    ],
    commonMistakes: [
      'Ender med venstre ben forrest.',
      'For mange små skridt, så du kommer for sent.',
      'Bliver stående ved nettet efter slaget.',
    ],
  ),
  Technique(
    id: 'backhand_net',
    kind: TechniqueKind.footwork,
    name: 'Til baghåndsnettet',
    category: 'Til nettet',
    summary:
        'Vejen fra midten frem til det forreste venstre hjørne og tilbage '
        'igen.',
    whenToUse:
        'Når modstanderen spiller drop eller netdrop til din baghåndsside.',
    keyPoints: [
      'Split step, når modstanderen slår.',
      'Det frie ben (venstre) fører. Lav et hop eller pivot om venstre fod, '
          'så kroppen drejer mod hjørnet.',
      'Afslut med et udfald på højre ben mod hjørnet.',
      'Skift til tommelgreb på vej frem.',
      'Skub fra med højre ben, og kom tilbage med chassé eller et par '
          'skridt.',
    ],
    commonMistakes: [
      'Laver udfaldet på venstre ben.',
      'Drejer ikke kroppen, så baghånden bliver kort.',
      'Forreste knæ peger en anden vej end foden.',
    ],
  ),
  Technique(
    id: 'side_defence',
    kind: TechniqueKind.footwork,
    name: 'Til siderne i midtbanen',
    category: 'Midtbane',
    summary:
        'Bevægelsen ud til siderne i midtbanen, fx i forsvar mod smash og '
        'drive, og hurtigt tilbage.',
    whenToUse:
        'Når fjerbolden kommer til siden i midtbanen, især i forsvar i single '
        'og når I står side om side i double.',
    keyPoints: [
      'Lav, bred forsvarsstilling og split step, når modstanderen slår.',
      'Et løbeskridt eller to og et udfald ud til siden. Mod baghånd krydser '
          'højre ben foran kroppen.',
      'Ketsjeren foran kroppen. Ram fjerbolden foran dig, ikke bag dig.',
      'Skub fra, og kom tilbage til midten med chassé.',
    ],
    commonMistakes: [
      'Står for højt og kommer for sent.',
      'Rækker kun med armen og rammer fjerbolden bag kroppen.',
      'Bliver ude i siden efter slaget.',
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
  Technique(
    id: 'doubles_rotation',
    kind: TechniqueKind.footwork,
    name: 'Rotation i double',
    category: 'Double',
    summary:
        'Sådan flytter makkerne sig mellem angreb (front-bag) og forsvar '
        '(side om side).',
    whenToUse:
        'I double og mixed, hver gang jeres side løfter eller får en chance '
        'for at slå nedad.',
    keyPoints: [
      'Angreb: front-bag. Den bagerste smasher eller dropper, og den '
          'forreste afslutter ved nettet.',
      'Forsvar: side om side. Hver spiller dækker sin halvdel.',
      'Når I løfter, går I til side om side. Den, der løftede fra nettet, '
          'går typisk bagud i samme side.',
      'Når I får en fjerbold, der kan slås nedad, går I til front-bag.',
      'Tal sammen, og sig "min" eller "din" ved bolde midt imellem jer.',
    ],
    commonMistakes: [
      'Begge står foran eller begge bagved efter et løft.',
      'Den forreste spiller trækker sig tilbage, mens makkeren smasher.',
      'Ingen tager fjerbolden i midten.',
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
    techniqueIds: [
      'clear',
      'smash',
      'drop',
      'around_the_head',
      'scissor_kick',
      'backhand_corner',
    ],
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
    techniqueIds: [
      'backhand',
      'around_the_head',
      'backhand_corner',
      'crossover',
    ],
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
  Drill(
    id: 'grip_wall',
    name: 'Grebsskift mod væggen',
    purpose:
        'Træner hurtige grebsskift og korte slag. Kan laves alene mod en '
        'væg.',
    techniqueIds: ['grips', 'drive'],
    minPlayers: 1,
    minutes: 8,
    level: DrillLevel.beginner,
    steps: [
      'Stå 2-3 meter fra en væg med ketsjeren oppe foran kroppen.',
      'Slå fjerbolden fladt mod væggen, skiftevis med forhånd og baghånd.',
      'Skift greb mellem hvert slag: basisgreb til forhånd og tommelgreb til '
          'baghånd.',
      'Tæl, hvor mange slag i træk du kan lave. Serier på 1 minut.',
    ],
    tips: [
      'Hold løst mellem slagene, så fingrene kan dreje ketsjeren.',
      'Gå tættere på væggen for at øge tempoet.',
    ],
  ),
  Drill(
    id: 'flick_or_short',
    name: 'Kort serv eller flick',
    purpose: 'Træner at skjule flick-serven, og at modtageren reagerer på den.',
    techniqueIds: ['serve_short', 'serve_flick', 'push', 'split_step'],
    minPlayers: 2,
    minutes: 10,
    level: DrillLevel.intermediate,
    steps: [
      'A server fra double-positionen, og B står klar til at modtage.',
      'A blander korte serv og flick-serv uden at sige hvad, fx 1 flick for '
          'hver 4 serv.',
      'B angriber den korte serv med push eller kill og går bagud på '
          'flicken.',
      'Spil duellen ud til 3 slag. Byt efter 12 serv.',
    ],
    tips: [
      'A: film serven forfra, og se, om forberedelsen afslører flicken.',
      'B: stå med vægten fremme, men klar til at skubbe bagud.',
    ],
  ),
  Drill(
    id: 'low_serve_game',
    name: 'Kamp med kun kort serv',
    purpose:
        'En kamp med særregler, der træner kort serv, returnering og de '
        'første slag efter serven.',
    techniqueIds: ['serve_short', 'serve_forehand_low', 'push', 'net_kill'],
    minPlayers: 2,
    minutes: 15,
    level: DrillLevel.intermediate,
    steps: [
      'Spil single eller double efter de normale regler, men kun kort serv '
          'er tilladt (forhånd eller baghånd).',
      'Vinder serverens side duellen på 3. eller 4. slag, giver det et '
          'ekstra point.',
      'Spil et sæt til 15.',
    ],
    tips: [
      'Serv lavt, og varier placeringen: på midten, ud mod sidelinjen og '
          'mod kroppen.',
      'Modtageren skal forsøge at komme først til fjerbolden og slå nedad.',
    ],
  ),
  Drill(
    id: 'around_head_feed',
    name: 'Rundt om hovedet med multi-fjer',
    purpose: 'Mange gentagelser af forhåndsslag fra baghåndshjørnet.',
    techniqueIds: ['around_the_head', 'backhand_corner', 'smash', 'drop'],
    minPlayers: 2,
    minutes: 10,
    level: DrillLevel.intermediate,
    steps: [
      'Fodreren står i den modsatte forbane og slår høje fjerbolde til '
          'spillerens baghåndshjørne.',
      'Spilleren starter i midten, kommer bag fjerbolden og slår rundt om '
          'hovedet.',
      'Skift mellem smash lige, drop på kryds og clear, 3 af hver.',
      'Tilbage til midten med split step mellem hvert slag. Serier på 12-15 '
          'fjerbolde.',
    ],
    tips: [
      'Kom bag fjerbolden, før du slår. Hellere et roligt slag end et sent.',
      'Fodreren kan gradvist slå dybere, så spilleren må vælge baghånd.',
    ],
  ),
  Drill(
    id: 'jump_basics',
    name: 'Hop og landing',
    purpose:
        'Lærer at sætte af og lande sikkert. Til begyndere og børn, og som '
        'opvarmning for alle.',
    techniqueIds: ['jump_landing', 'hop_pivot'],
    minPlayers: 1,
    minutes: 8,
    level: DrillLevel.beginner,
    steps: [
      'Hop på to ben frem og tilbage over en linje i 20 sekunder.',
      'Hop sidelæns frem og tilbage over sidegangen (mellem single- og '
          'double-sidelinjen) i 20 sekunder.',
      'Urhop: hop til klokkeslæt rundt om et midtpunkt (12, 3, 6 og 9) og '
          'tilbage til midten hver gang.',
      'Hop og drej: hop, drej en kvart omgang i luften, og land stille. '
          'Begge veje.',
      '30-40 sekunders pause mellem øvelserne. 2-3 runder.',
    ],
    tips: [
      'Land stille. Kan du høre et bump, er landingen for hård.',
      'Knæene peger samme vej som tæerne.',
    ],
  ),
  Drill(
    id: 'jump_smash_series',
    name: 'Hop-smash i serier',
    purpose: 'Træner hop-smash med god landing og hurtig vej frem. For øvede.',
    techniqueIds: ['jump_smash', 'jump_landing', 'scissor_kick'],
    minPlayers: 2,
    minutes: 10,
    level: DrillLevel.advanced,
    steps: [
      'Fodreren slår høje, ikke for dybe fjerbolde til spillerens '
          'forhåndsside i bagbanen.',
      'Spilleren hopper, smasher og lander på forfoden.',
      'Efter landingen tager spilleren 2 skridt frem, som om næste slag '
          'kommer ved nettet.',
      'Serier på 6-8 smash med 1 minuts pause. 3-4 serier.',
    ],
    tips: [
      'Kvalitet før mængde: stop serien, når landingen bliver tung.',
      'Vent med mange hop-smash, til landingen sidder (øvelsen Hop og '
          'landing). Stop ved smerter i knæ eller ankel.',
    ],
  ),
  Drill(
    id: 'pulled_drop_pressure',
    name: 'Ud af presset i bagbanen',
    purpose: 'Træner det trukne drop, når du er presset i de bagerste hjørner.',
    techniqueIds: ['pulled_drop', 'backhand', 'backhand_corner', 'crossover'],
    minPlayers: 2,
    minutes: 10,
    level: DrillLevel.advanced,
    steps: [
      'Fodreren slår hurtige, flade clears bag spilleren, skiftevis til '
          'forhånds- og baghåndshjørnet.',
      'Spilleren slår trukket drop lige eller på kryds, så det lander i '
          'fodrerens forreste midtbane.',
      'Fodreren løfter tilbage, mens spilleren kommer tilbage til midten.',
      'Serier på 10-12 fjerbolde.',
    ],
    tips: [
      'Brug udsvinget til at vende dig mod nettet lige efter træffet.',
      'Hellere et sikkert drop lidt længere inde på banen end et stramt drop '
          'i nettet.',
    ],
  ),
  Drill(
    id: 'net_variation',
    name: 'Netspil: lige, kryds og spin',
    purpose: 'Træner variation ved nettet, så modstanderen ikke kan læse dig.',
    techniqueIds: ['net_shot', 'net_spin', 'net_kill', 'lift', 'lunge'],
    minPlayers: 2,
    minutes: 10,
    level: DrillLevel.intermediate,
    steps: [
      'Begge står ved nettet i hver sin forbane.',
      'Spil netdrop frem og tilbage, både lige og på kryds.',
      'Brug spin, når du har tid. Går et slag for højt, må modstanderen '
          'dræbe det.',
      'Kommer du for sent, så løft til baglinjen, og start forfra.',
    ],
    tips: [
      'Ram fjerbolden så tidligt og højt som muligt.',
      'Brug samme forberedelse til netdrop og løft.',
    ],
  ),
  Drill(
    id: 'net_shadow',
    name: 'Skygge til nettet',
    purpose:
        'Træner vejen til begge nethjørner med de rigtige skridt. Kan laves '
        'alene.',
    techniqueIds: [
      'forehand_net',
      'backhand_net',
      'hop_pivot',
      'lunge',
      'chasse',
    ],
    minPlayers: 1,
    minutes: 8,
    level: DrillLevel.beginner,
    steps: [
      'Start i midten med split step.',
      'Forhåndsnettet: højre ben fører, chassé og udfald. Lav '
          'slagbevægelsen, og kom tilbage.',
      'Baghåndsnettet: hop eller pivot om venstre fod, udfald på højre ben, '
          'og tilbage.',
      'Skift mellem de to hjørner. 30 sekunders arbejde og 30 sekunders '
          'pause, 6-8 runder.',
    ],
    tips: [
      'Tæl skridtene, så det er det samme antal hver gang.',
      'Læg en fjerbold i hvert hjørne, og ræk ketsjeren ind over den i '
          'udfaldet.',
    ],
  ),
  Drill(
    id: 'side_defence_feed',
    name: 'Sideforsvar',
    purpose: 'Træner udfald til siderne og forsvar i midtbanen.',
    techniqueIds: ['side_defence', 'defence', 'drive'],
    minPlayers: 2,
    minutes: 10,
    level: DrillLevel.intermediate,
    steps: [
      'Fodreren står ved nettet på den anden side og kaster eller slår '
          'fjerbolde fladt og nedad, skiftevis til spillerens forhånds- og '
          'baghåndsside.',
      'Spilleren står i forsvarsstilling i midten, laver split step og går '
          'ud med et udfald.',
      'Spil et block til nettet eller et drive lige tilbage.',
      'Serier på 15-20 fjerbolde.',
    ],
    tips: [
      'Ram foran kroppen, og hold ketsjeren foran mellem slagene.',
      'Fodreren kan blande slag mod kroppen ind. De tages med baghånd.',
    ],
  ),
  Drill(
    id: 'agility_signal',
    name: 'Retningsskift på signal',
    purpose: 'Træner reaktion, første skridt og forskellige skridttyper.',
    techniqueIds: ['split_step', 'cross_behind', 'hop_pivot', 'chasse'],
    minPlayers: 2,
    minutes: 8,
    level: DrillLevel.intermediate,
    steps: [
      'Spilleren står i midten. Makkeren står foran og viser en retning med '
          'armen.',
      'Spilleren laver split step på signalet og tager 2-3 hurtige skridt i '
          'den retning.',
      'Brug chassé til siderne, bagom-skridt bagud mod forhåndssiden og hop '
          'eller pivot bagud mod baghåndssiden.',
      'Tilbage til midten. 20 sekunders arbejde og 40 sekunders pause, 6-8 '
          'runder.',
    ],
    tips: [
      'Makkeren varierer rytmen, så signalet ikke kan forudses.',
      'Første skridt skal være eksplosivt, resten korte og lette.',
    ],
  ),
  Drill(
    id: 'doubles_attack_defence',
    name: 'Double: fra forsvar til angreb',
    purpose:
        'Træner rotationen mellem side om side og front-bag i dueller, der '
        'ligner kamp.',
    techniqueIds: ['doubles_rotation', 'smash', 'defence', 'drive'],
    minPlayers: 4,
    minutes: 15,
    level: DrillLevel.intermediate,
    steps: [
      'Det ene par (angriberne) starter front-bag, det andet (forsvarerne) '
          'side om side.',
      'Forsvarerne starter med at løfte højt og dybt til et af angribernes '
          'bagerste hjørner.',
      'Spil duellen færdig. Kommer forsvarerne i angreb, skal de skifte til '
          'front-bag.',
      'Byt roller efter 10 dueller.',
    ],
    tips: [
      'Sig højt, når I skifter formation, fx "angreb" og "forsvar".',
      'Den forreste angriber bliver fremme og tager alt fladt ved nettet.',
    ],
  ),
  Drill(
    id: 'no_lift_doubles',
    name: 'Double uden løft',
    purpose:
        'Double med særregler, der træner at forsvare fladt og vende forsvar '
        'til angreb.',
    techniqueIds: ['defence', 'drive', 'push', 'doubles_rotation'],
    minPlayers: 4,
    minutes: 15,
    level: DrillLevel.advanced,
    steps: [
      'Spil almindelig double, men ingen må løfte på en smash.',
      'En smash skal returneres med et block til nettet eller et fladt '
          'drive.',
      'Løfter man alligevel, får modstanderne point.',
      'Spil et sæt til 15.',
    ],
    tips: [
      'Lav og bred forsvarsstilling og ketsjeren foran kroppen.',
      'Block på kryds eller drive mod smasherens baghånd giver ofte '
          'initiativet tilbage.',
    ],
  ),
  Drill(
    id: 'corners_game',
    name: 'Hjørnekamp i single',
    purpose:
        'Single med særregler, der træner præcision og at flytte '
        'modstanderen rundt.',
    techniqueIds: ['clear', 'drop', 'lift', 'net_shot', 'six_corner'],
    minPlayers: 2,
    minutes: 15,
    level: DrillLevel.intermediate,
    steps: [
      'Markér et område i hvert af banens fire hjørner på begge sider, fx '
          'med tape eller kegler. Gør dem store til at starte med.',
      'Spil single. En fjerbold, der lander uden for hjørneområderne, er '
          'ude.',
      'Gør områderne mindre, efterhånden som det går bedre.',
      'Spil et sæt til 15.',
    ],
    tips: [
      'Kom tilbage til midten efter hvert slag. Modstanderen spiller også i '
          'hjørnerne.',
      'Lige slag er de sikreste. Brug kryds, når modstanderen er ude af '
          'position.',
    ],
  ),
  Drill(
    id: 'interval_shadow',
    name: 'Intervaller i kamptempo',
    purpose:
        'Kondition til kamp: korte, hårde serier med pauser som i en kamp.',
    techniqueIds: ['six_corner', 'split_step', 'lunge', 'scissor_kick'],
    minPlayers: 1,
    minutes: 20,
    level: DrillLevel.advanced,
    steps: [
      'Varm grundigt op.',
      'Skyggebadminton eller multi-fjer til tilfældige hjørner i 5-10 '
          'sekunder i fuldt tempo.',
      'Hold 10-20 sekunders pause, så arbejde og pause er ca. 1:2 som i en '
          'kamp.',
      '10-20 gentagelser. Hold 3-5 minutters pause, og lav evt. en serie '
          'mere.',
    ],
    tips: [
      'Stop serien, når teknikken falder. Korte intervaller giver bedre '
          'teknik under træthed.',
      'Læg ikke hårde intervaller to dage i træk.',
    ],
  ),
  Drill(
    id: 'throwminton',
    name: 'Kastebadminton',
    purpose:
        'Leg for børn og begyndere. Lærer kastebevægelsen fra clear og '
        'smash og at bedømme fjerboldens flugt.',
    techniqueIds: ['clear', 'split_step'],
    minPlayers: 2,
    minutes: 10,
    level: DrillLevel.beginner,
    steps: [
      'Spil over nettet uden ketsjer: I kaster og griber fjerbolden.',
      'Kast med et overhåndskast: sidelæns, armen højt og albuen først, som '
          'når man kaster en bold langt.',
      'Grib fjerbolden så højt som muligt, og kast derfra.',
      'Tæl point: rammer fjerbolden gulvet inde på modstanderens side, får '
          'du point.',
    ],
    tips: [
      'Brug en mindre bane til de yngste.',
      'Kast mod de tomme områder for at flytte modstanderen.',
    ],
  ),
];

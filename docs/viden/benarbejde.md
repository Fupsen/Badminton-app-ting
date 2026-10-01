# Benarbejde

Hovedkilde: BWF *Level 1 Coaches' Manual*, modul 6 "Movement Skills", s.
51-70 [BWF-L1]. Beskrivelserne er for en højrehåndet spiller: ketsjerbenet er
højre, det andet ben er venstre. Id'er i `kode` svarer til
`lib/content/technique_da.dart`.

## Bevægelsescyklussen

BWF deler al bevægelse på banen i fire dele (s. 51):

1. **Start**: reaktionen på modstanderens slag, typisk med et split step.
2. **Tilløb** (approach): vejen hen til bolden.
3. **Slag** (hit): bevægelsen i selve slaget, fx udfald eller hop.
4. **Retur** (recover): bevægelsen i den retning, modstanderens svar
   sandsynligvis kommer.

**Basisposition:** det sted på banen, hvor man bedst dækker modstanderens
*sandsynlige* svar. Den er flydende, altså ikke altid midten, og det er her,
man laver split step. *Tolkning:* efter et højt slag til modstanderens bagbane
ligger basis typisk lidt længere tilbage end efter et netdrop.

## Split step (`split_step`) (s. 53-56)

- Et lavt hop **lige før** modstanderen rammer bolden, så man kan sætte hurtigt
  af i en ny retning.
- Land med lidt bredere fodstilling og bøjede knæ.
- Overkroppen er afslappet og mellem fødderne.
- Eksplosivt fraspark med kort jordkontakt.
- Landingen sker samtidig med eller lige efter modstanderens slag.
- Split step læres med landing på begge fødder, men i virkeligheden lander den
  ene fod næsten altid først, og **den fod bestemmer retningen**: venstre
  først → mod højre, højre først → mod venstre, forreste først → bagud,
  bagerste først → frem. Med erfaring lærer man at lande, så man dækker de
  mest sandsynlige svar. Der findes intet split step, der dækker alle
  retninger lige godt.
- Typiske fejl: intet split step, eller det kommer for tidligt eller for sent.

## Skridttyper (s. 57-60)

- **Løbeskridt fremad**: hæl-tå og længere skridt. **Baglæns**: på tæerne,
  korte og hurtige skridt (`crossover`). Løber man baglæns i en let bue, ender
  man sidelæns.
- **Chassé** (`chasse`): den ene fod "jager" den anden uden helt at nå den.
  Kan laves med fødderne i 90° eller parallelt. Kort jordkontakt ("som om
  gulvet er varmt"), glid hurtigt hen over gulvet, og hold hovedet i samme
  højde. **Chassé kommer normalt enkeltvis eller to ad gangen.** Over lange
  afstande, fx på banens diagonal, er chassé langsomt og bør undgås. Brug
  løbeskridt.
- **Cross-behind** (`cross_behind`, i appen "bagom-skridt"): det frie ben
  føres bag om ketsjerbenet. Det er meget sjældent mere end ét ad gangen.
- **Hop/pivot** (`hop_pivot`): små hop, hvor man sætter af og lander på samme
  fod, ofte med en drejning. Kan give højde, men bruges mest til at dække
  afstand, især sammen med en pivot. Lær at pivotere på begge ben og i begge
  retninger (med og mod uret).

## Udfald (`lunge`) (s. 61-62)

Bruges ved nettet (netdrop, lift, kill), i midtbanen når bolden er ved siden af
kroppen, og i bagbanen når bolden er bag spilleren.

- De fleste udfald laves på ketsjerbenet, men udfald på det andet ben
  forekommer også.
- **Forreste fod peger mod bolden.** Ben, knæ og fod peger samme vej.
- Drej bagerste fod lidt udad for balance og bevægelighed.
- **Bøj bagerste knæ**. Det tager belastning af forreste ben.
- Stræk den bagerste arm ud for at holde balancen.
- Hold overkroppen rank.
- Typiske fejl: knæet falder indad eller peger en anden vej end foden, og
  balancen er dårlig.

## Hop og landing (s. 61 og 63)

Id i appen: `jump_landing`.

- Sæt af fra en god squat-stilling: hælene nede, sid tilbage, brystet op, og
  ryg og skinneben parallelle. Sving armene ned og tilbage, derefter frem og op.
- **Land på forfoden**, og bøj ankel, knæ og hofte for at tage stødet.
- **[Ø/E]** Hop-smash og saksehop kræver god landeteknik. Det bør trænes
  særskilt, før man laver mange gentagelser (se [skader.md](skader.md)).
- Hop kan varieres: to ben til to ben, to ben til ét, ét til to, ét til samme
  (hink) og ét til det andet (spring). Alle kan laves til siden, frem og
  tilbage og med drejning.
- Øvelser fra manualen: urhop (til klokkeslæt rundt om et midtpunkt), hop
  over sidegangen, hop og grib, hop og drej. De er samlet i øvelsen
  `jump_basics` (se [ovelser.md](ovelser.md)).

## Mønstre til hvert område (s. 64-69)

BWF understreger, at mønstrene **kan være ret personlige** og afhænger af
situationen. Tabellen viser almindelige varianter, ikke de eneste rigtige.

| Mod | Mønstre |
| --- | --- |
| Forhånd net (`forehand_net`) | Split step, ketsjerbenet fører, chassé, **udfald**, chassé og/eller skridt tilbage. Eller: split step, løbeskridt, udfald. Eller: split step, ketsjerbenet fører, bagom-skridt, udfald. |
| Baghånd net (`backhand_net`) | Split step, chassé, **udfald**, skridt eller chassé tilbage. Eller: split step, løbeskridt, udfald. Eller: split step, det frie ben fører, hop/pivot om det frie ben, udfald. |
| Midtbane, begge sider (`side_defence`) | Split step, løbeskridt, **udfald**, derefter chassé og/eller skridt tilbage (s. 61). Ved baghånds-drive kan ketsjerbenet føres ind foran kroppen, hvis bolden er meget bred (s. 113). |
| Forhånd bagbane (`scissor_kick`) | Split step, **chassé baglæns** i en bue, hop og drej i luften under slaget, chassé eller løb tilbage. Eller: split step, chassé, hop ud og slå i luften (en lige linje ud i hjørnet). Under pres: split step, bagom-skridt, **udfald** bagud. |
| Baghånd bagbane (`backhand_corner`) | Split step, pivot/hop om det frie ben (det skal give afstand), hop og drej i luften under slaget, chassé eller løb tilbage. Eller: løb baglæns i en let bue, så man står sidelæns. Med baghånd: chassé baglæns, ryggen mod nettet, halvt udfald, og drej hurtigt tilbage ind på banen. |

Jo mere presset man er, jo dybere bliver udfaldet, også i bagbanen (s. 65,
67). Mønstrene trænes bedst ved **kædning**: start med selve slaget, og byg
bevægelsen ind til og ud fra slaget på trin for trin (s. 68-69).

**6-hjørne-mønstret** (`six_corner`): to hjørner ved nettet, to sider i
midtbanen og to hjørner bagerst. Det er den almindelige måde at træne alle
mønstrene samlet, fx som skyggebadminton. *Almindelig træningspraksis. Navnet
bruges ikke i BWF-manualen.*

**Rotation i double** (`doubles_rotation`): skiftet mellem front-bag i
angreb og side om side i forsvar. Se [taktik.md](taktik.md#double-generelt).

## Træningsidéer

- **[B]** Skyggebadminton i fast rækkefølge. Fokus på split step og samme
  antal skridt hver gang.
- **[Ø]** Tilfældige hjørner: en makker peger, og man reagerer.
- **[E]** Multi-fjer i kamptempo og intervaller, der ligner kampens forhold
  mellem arbejde og pause (se [fysisk-traening.md](fysisk-traening.md)).
- Alle øvelserne i appen står i [ovelser.md](ovelser.md).

## Kilder

- [BWF-L1] BWF Coach Education: *Coaches' Manual Level 1*, 2. udgave 2017,
  modul 6, s. 51-71. <https://development.bwfbadminton.com/coaches/level-1>
  (læst fra
  <http://www.badminton-israel.co.il/newsNdata/General/CoachEducationBWF/BWF_Coach_Manual_Level_1.pdf>,
  det israelske forbunds kopi af BWF's PDF. Modul 6 er læst side for side
  01-10-2026).

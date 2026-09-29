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
- Typiske fejl: intet split step, eller det kommer for tidligt eller for sent.

## Skridttyper (s. 57-60)

- **Løbeskridt fremad**: hæl-tå og længere skridt. **Baglæns**: på tæerne,
  korte og hurtige skridt (`crossover`). Løber man baglæns i en let bue, ender
  man sidelæns.
- **Chassé** (`chasse`): den ene fod "jager" den anden uden helt at nå den.
  Kan laves med fødderne i 90° eller parallelt. Kort jordkontakt, glid hurtigt
  hen over gulvet, og hold hovedet i samme højde.
- **Cross-behind** (`cross_behind`, i appen "bagom-skridt"): det frie ben
  føres bag om ketsjerbenet. Det er meget sjældent mere end ét ad gangen.
- **Hop/pivot** (`hop_pivot`): små hop, hvor man sætter af og lander på samme
  fod, ofte med en drejning. Kan give højde, men bruges mest til at dække
  afstand, især sammen med en pivot. Lær at pivotere på begge ben og i begge
  retninger (med og mod uret).

## Udfald (`lunge`) (s. 61-63)

Bruges ved nettet (netdrop, lift, kill), i midtbanen når bolden er ved siden af
kroppen, og i bagbanen når bolden er bag spilleren.

- **Forreste fod peger mod bolden.** Ben, knæ og fod peger samme vej.
- **Bøj bagerste knæ**. Det tager belastning af forreste ben.
- Stræk den bagerste arm ud for at holde balancen.
- Hold overkroppen rank.
- Typiske fejl: knæet falder indad eller peger en anden vej end foden, og
  balancen er dårlig.

## Hop og landing (s. 61-62)

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

## Mønstre til hvert område (s. 67-70)

| Mod | Mønster |
| --- | --- |
| Forhånd net (`forehand_net`) | Split step, ketsjerbenet fører, chassé, **udfald**, derefter chassé og/eller skridt tilbage. |
| Baghånd net (`backhand_net`) | Split step, det frie ben fører, hop/pivot om det frie ben, **udfald**, derefter chassé og/eller skridt tilbage. |
| Midtbane, begge sider (`side_defence`) | Split step, løbeskridt, **udfald**, derefter chassé og/eller skridt tilbage. Ved baghånds-drive kan ketsjerbenet føres ind foran kroppen (modul 7). |
| Forhånd bagbane | Split step, **chassé baglæns**, hop og drej i luften under slaget (saksehop, `scissor_kick`), derefter chassé eller løb tilbage. |
| Baghånd bagbane (`backhand_corner`) | Split step, pivot/hop om det frie ben, hop og drej i luften under slaget, derefter chassé eller løb tilbage. |

**6-hjørne-mønstret** (`six_corner`): to hjørner ved nettet, to sider i
midtbanen og to hjørner bagerst. Det er den almindelige måde at træne alle
mønstrene samlet, fx som skyggebadminton. *Almindelig træningspraksis. Navnet
bruges ikke i BWF-udtrækket.*

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

- [BWF-L1] BWF Coach Education: *Coaches' Manual Level 1*, modul 6, s. 51-70.
  <https://development.bwfbadminton.com/coaches/level-1> (læst fra
  <http://www.badminton-israel.co.il/newsNdata/General/CoachEducationBWF/BWF_Coach_Manual_Level_1.pdf>,
  opslag 29-09-2026, målrettede udtræk).

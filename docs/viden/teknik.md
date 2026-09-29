# Teknik: greb og slag

Hovedkilde: BWF Coach Education *Level 1 Coaches' Manual*, modul 7 "Technical
(Hitting Skills)", s. 79-116 [BWF-L1]. Alt er beskrevet for en højrehåndet
spiller. Er man venstrehåndet, spejles det hele. Id'er i `kode` svarer til
`lib/content/technique_da.dart`.

Niveau-markering: **[B]** begynder, **[Ø]** øvet/klubspiller, **[E]**
konkurrence/elite. Uden markering gælder det for alle.

## De fire faser i et slag

BWF deler hvert slag op i fire faser, og de er gode at træne og rette ud fra:

1. **Preparation** (klarposition): grebet er klar, og ketsjeren er foran/oppe.
2. **Backswing** (optræk): ofte med udadrotation af overarm og underarm
   (supination).
3. **Forward swing** (slag): indadrotation (pronation) og håndled giver farten.
   Træffet sker foran kroppen, hvis intet andet står.
4. **Follow-through** (udsving og hurtig retur til klarposition).

## Greb (s. 79-82) (`grips`)

| Greb | Bruges til |
| --- | --- |
| **Basisgreb / V-greb** | Slag, hvor bolden er i højde med spilleren, i begge sider. Udgangsgreb for de fleste slag. |
| **Tommelgreb** (tommelfingeren på den brede, flade side af skaftet) | Baghåndsslag **foran** kroppen: netdrop, lift, net kill, baghåndsserv, baghåndsdrive. |
| **Hjørnegreb** (corner grip) | Baghåndsslag, hvor bolden er i højde med eller **lidt bag** kroppen: drive, block, clear, drop og smash med baghånd. *Tommelfingeren ligger på skaftets skrå kant (praksis-beskrivelse).* |
| **Stegepandegreb** (panhandle) | Forhånd langt **foran** kroppen (net kill) og baghånd langt **bag** kroppen (baghånds-drop). |

Typisk fejl [B]: man holder ketsjeren i stegepandegreb til alt. Det begrænser
især baghånden og slag bagfra. *(praksis)* Hold løst mellem slagene, så
fingrene kan skifte greb hurtigt.

## Serv (s. 84-94)

Husk reglerne: hele bolden skal være under 1,15 m, bolden må ikke få spin, og
ketsjeren skal ramme korken først (se [regler.md](regler.md#serv-9)).

- **Kort baghåndsserv** (`serve_short`): kort tommelgreb, ketsjeren ude foran,
  kort og afslappet bagsving med åben ketsjerflade. **Skub** ketsjeren gennem
  bolden, og fortsæt skubbet, så ketsjeren kommer op i klarposition.
- **Kort forhåndsserv** (`serve_forehand_low`): sidelæns, basisgreb,
  ketsjer og bold holdes højt, og vægten er på bagerste ben. Flyt vægten
  frem, slip bolden til siden og lidt foran, bøj håndleddet og hold det
  bøjet, mens du skubber bolden over. Bruges ifølge BWF mest i damesingle.
  Lad kort, høj og flick-serv ligne hinanden.
- **Flick-serv** (`serve_flick`) (forhånd og baghånd) **[Ø]**: samme
  forberedelse som den korte serv, så modstanderen ikke kan se forskel. Kort
  bagsving med bøjet håndled og åben ketsjerflade, og accelerér pludseligt i
  sidste øjeblik, så bolden går over modtageren og bagud. Formålet er at
  tvinge modtageren bagud og ud af balance. **I double skal den lande inden
  for den lange servelinje for double.** I single kan den serves med længere
  greb og længere tilbage i feltet.
- **Høj forhåndsserv** (`serve_long`): sidelæns, basisgreb, vægten på bagerste
  ben. Flyt vægten frem, slip bolden, supinér i bagsvinget, og pronér og stræk
  håndleddet i slaget. Ram **under** bolden, og lad udsvinget gå højt og langt.
  Bruges mest i single.

## Forbane / net (s. 96-102)

- **Netdrop** (`net_shot`), forhånd og baghånd: afslappet stræk frem, drej
  armen, så strengene vender mod bolden, og skub bolden over med farten fra
  bevægelsen. Baghånd i tommelgreb.
- **Spin-netdrop** (`net_spin`) **[Ø]**: slå på tværs under bolden i en let
  buet bane, fx fra højre mod venstre, så bolden vælter rundt over nettet og
  er svær at returnere. Spin er kun forbudt i serven (se
  [regler.md](regler.md#serv-9)).
- **Lift** (`lift`): med baghånd bruges tommelgreb og indadrotation, derefter
  udadrotation gennem bolden. Med forhånd bøjes håndleddet og strækkes gennem
  bolden. Armen roterer videre og slapper af i udsvinget. Et *angrebslift*
  (bolden lige under nethøjde) går lige højt nok til at komme over
  modstanderens ketsjer. Et *forsvarslift* (bolden langt under nethøjde) går
  højere. Kryds kræver en kortere bevægelse end lige. Lad løftet ligne et
  netdrop.
- **Net kill** (`net_kill`): med baghånd bruges tommelgreb, albuen løftes og
  bøjes, derefter strækkes armen med udadrotation, og der slås kraftigt nedad.
  Med forhånd **skiftes til stegepandegreb**. Få **hurtigt** ketsjeren op igen
  efter slaget. Tæt ved nettet er bevægelsen meget kort, og man slår på
  tværs af bolden for ikke at ramme nettet.

## Midtbane (s. 105-108)

- **Block ind til kroppen** (`defence`), baghånd: afslappet tommelgreb, albuen
  frem og bøjet, åben ketsjerflade. Ram lidt under bolden, og **skub** den over
  i stedet for at slå.
- **Drive** (`drive`): albuen op og frem, bøjet. Ved baghånd bruges eventuelt
  tommelgreb og rotation udad, ved forhånd eventuelt stegepandegreb og rotation
  indad. Slå hårdt gennem bolden foran eller ved siden af kroppen, og få
  **hurtigt** ketsjeren tilbage. Baghånds-drive kan slås med ketsjerbenet
  ført ind foran kroppen, og hjørnegreb bruges, når bolden er ved siden af
  kroppen eller skal på kryds.
- **Push** (`push`): kontrolleret og fladt ned i modstanderens midtbane.
  Manualens udtræk beskriver det ikke særskilt. *Beskrivelsen bygger på
  almindelig træningspraksis.*

## Bagbane (s. 110-116)

- **Forhånds-clear** (`clear`): basisgreb, klarposition over hovedet,
  frontarmen op, sidelæns. Sæt af op og frem fra bagerste ben, skub bagerste
  hofte frem, før albuen op og frem med udadrotation, og vend til
  indadrotation (pronation). Ram kraftigt **over og foran slagskulderen**.
  Bagerste fod lander foran.
- **Forhånds-smash** (`smash`): V-greb, afslappet klarposition, sidelæns. Tag
  et skridt bagud, så bagerste ben bliver ladet, **hop og drej i luften**,
  "kast" ketsjerhovedet med pronation, og ræk op for at ramme. Varier farten,
  og smash mod det tomme område eller mod kroppen.
- **Hop-smash** (`jump_smash`) **[Ø/E]**: manualen beskriver forhånds-smashen
  med hop og drejning i luften (se ovenfor). Appen har den som eget punkt,
  fordi den kræver god landeteknik og bør trænes i små serier (se
  [benarbejde.md](benarbejde.md#hop-og-landing-s-61-62) og
  [skader.md](skader.md)). *Serielængde og "afslutning, ikke i hver duel"
  er praksis.*
- **Forhånds-drop** (`drop`): **samme bevægelse som clear**, men stop
  armrotationen lige før træffet. Et skåret drop (fra højre mod venstre eller
  omvendt) giver variation og snyder modstanderen.
- **Trukket drop** (`pulled_drop`) **[Ø]**: bruges i forsvar, når bolden er
  bag spilleren i et bagerste hjørne. Det lindrer presset og begrænser
  modstanderens angreb og vinkler. Forhånd: albuen bøjet, grebet drejes mod
  tommelgreb (mere til kryds), hånden kommer ind under bolden, og
  rotationen mindskes lige før træffet, som sker lidt bag kroppen. Bolden
  lander i modstanderens midtbane. Brug udsvinget til hurtigt at vende mod
  nettet.
- **Rundt om hovedet** (`around_the_head`): forhåndsslag over hovedet fra
  baghåndssiden, hvor overkroppen bøjes til venstre, og bolden rammes over
  eller lidt til venstre for hovedet. *Hele beskrivelsen er praksis. BWF's
  udtræk beskriver ikke slaget særskilt.* Armens bevægelse er som i
  forhånds-clear, drop og smash.
- **Baghånds-clear** (`backhand`): **basisgreb eller hjørnegreb**, albuen nede
  og ketsjerhovedet oppe. Løft albuen, lad ketsjerhovedet falde, stræk armen med
  udadrotation, og ram **ved siden af eller lidt bag kroppen**. Slaget er et
  kort "punch": hånden stopper brat, ketsjerhovedet fortsætter og fjedrer
  tilbage.
- **Baghånds-trukket drop** **[Ø]** (en del af `pulled_drop`): hjørnegreb
  (stegepandegreb, jo dybere bolden er, eller jo mere kryds), samme
  forberedelse som baghånds-clear, og mindre rotation lige før træffet. Bolden
  lander lige bag modstanderens korte servelinje. Sæt forreste fod i gulvet
  samtidig med eller lige før træffet, så du hurtigt kan vende.
- **Baghånds-smash** **[E]**: samme "punch" som baghånds-clear, men med mere
  bøjet håndled, så bolden går nedad. *Ikke med i appen, fordi den sjældent
  bruges.*

## Typiske fejl

Fra manualens trænerpunkter (fejlene er udledt af punkterne) og almindelig
træningspraksis:

- Ketsjeren hænger ned mellem slagene i midtbane og ved nettet, så man kommer
  for sent.
- Bolden rammes bag kroppen i stedet for foran, hvilket giver korte clears og
  flade smash.
- Forskellig forberedelse til clear, drop og smash, så modstanderen kan læse
  slaget.
- Kraften kommer fra skulderen eller et stift håndled i stedet for rotation af
  underarmen.
- For stort sving på net- og midtbaneslag.

## Kilder

- [BWF-L1] BWF Coach Education: *Coaches' Manual Level 1* (282 s.), modul 7.
  Officiel side: <https://development.bwfbadminton.com/coaches/level-1>.
  Læst fra
  <http://www.badminton-israel.co.il/newsNdata/General/CoachEducationBWF/BWF_Coach_Manual_Level_1.pdf>
  (opslag 29-09-2026, målrettede udtræk og ikke læst side for side). Udtræk
  om flick-serv, forhåndsserv, trukket drop, spin-netdrop, lift, drive og
  kill tilføjet 29-09-2026.
- Serveregler: se [regler.md](regler.md).

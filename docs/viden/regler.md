# Regler

Kilde, hvis intet andet står: BWF *Laws of Badminton*, version 5.0, i kraft fra
26. april 2025 [L]. Paragrafnumre står i parentes, fx (§9.1.6). Pointsystemet
er ændret siden, se [Pointsystem](#pointsystem).

## Pointsystem

**I Danmark spilles der 3×15 i alle kampe fra 1. juli 2026.** Det gælder alle
aldersrækker, turneringer, holdturneringer og stævner under Badminton Danmark
og DGI Badminton [BD-3x15]. Internationale turneringer, der afvikles i
Danmark, spillede dog fortsat til 21 frem til 2027.

Internationalt (BWF) gælder 3×15 fra 4. januar 2027. Det blev vedtaget på
BWF's generalforsamling 25. april 2026 i Horsens [BWF-3x15]. 3×21 bevares som
alternativt pointsystem, og nationale forbund må vælge et godkendt alternativ
til egne turneringer.

| | 3×15 (standard fra 2026/27) | 3×21 (tidligere standard, nu alternativ) |
| --- | --- | --- |
| Kamp | Bedst af 3 sæt | Bedst af 3 sæt (§7.1) |
| Sæt vindes ved | 15 point | 21 point (§7.2) |
| Uafgjort sent i sættet | Ved 14-14 skal man vinde med 2 | Ved 20-20 skal man vinde med 2 (§7.4) |
| Loft | 21: ved 20-20 vinder næste point | 30: ved 29-29 vinder næste point (§7.5) |
| Pause midt i sættet | 60 s når den førende når 8 | 60 s når den førende når 11 (§16.2.1) |
| Sideskift i 3. sæt | Når en side når 8 | Når en side når 11 (§8.1.3) |
| Pause mellem sæt | 120 s | 120 s (§16.2.2) |

Gyldige slutresultater i ét sæt:

- **3×15:** 15-0 … 15-13, 16-14 … 20-18 (2 points forskel), 21-19 og 21-20.
- **3×21:** 21-0 … 21-19, 22-20 … 29-27 (2 points forskel), 30-28 og 30-29.

Fælles for begge systemer: der gives point i hver duel (rally point), og
vinderen af et sæt server først i næste sæt (§7.3, §7.6). Man skifter side
efter 1. sæt og før et eventuelt 3. sæt (§8.1). Glemmer man et sideskift,
skiftes der, så snart det opdages, og stillingen står ved magt (§8.2).

> Appen (`lib/logic/scoring.dart`) accepterer begge systemer, men alle sæt i
> én kamp skal følge samme system. Regel-sektionen i appen
> (`lib/content/rules_da.dart`) er et sammendrag af denne fil og skal
> opdateres sammen med den.

## Bane, net og udstyr

- Banen er 13,40 × 6,10 m (double). Singlebanen er 5,18 m bred. Den korte
  servelinje ligger 1,98 m fra nettet, og i double ligger den lange servelinje
  0,76 m inden for baglinjen. Diagonalen er 14,723 m (Diagram A) [L]. *Målene
  er aflæst af diagrammet. Tekstudtrækket bekræfter kun diagonalen, som passer
  med 13,40 × 6,10 m.*
- Linjerne er 40 mm brede og hører til det felt, de afgrænser. **En bold på
  linjen er inde** (§1.3, §13.3.1).
- Nettet er 1,524 m højt på midten og 1,55 m over double-sidelinjerne. Stolperne
  står på double-sidelinjerne, også i single (§1.4, §1.5, §1.10).
- Fjerbolden har 16 fjer og vejer 4,74-5,50 g. Plastbolde (nylon) er tilladt,
  hvis de flyver som en fjerbold (§2).
- Ketsjeren må højst være 680 mm lang og 230 mm bred (§4.1).
- Test af fjerboldens fart: slå et fuldt underhåndsslag fra baglinjen, parallelt
  med sidelinjen. En bold med korrekt fart lander 530-990 mm før den modsatte
  baglinje (§3).

## Lodtrækning

Vinderen af lodtrækningen vælger enten at serve eller modtage først eller
hvilken banehalvdel man starter på. Taberen tager det andet valg (§6).

## Serv (§9)

En korrekt serv kræver alt det her:

1. Server og modtager står i hvert sit diagonalt modsatte servefelt uden at
   røre linjerne (§9.1.3).
2. En del af begge fødder har kontakt med gulvet og står stille fra servens
   start, til bolden er ramt (§9.1.4).
3. **Fjerbolden skal slippes uden spin, og ketsjeren skal først ramme boldens
   bund (korken)** (§9.1.5). *Spin-serven blev forbudt permanent i 2025*
   [BWF-2025].
4. **Hele fjerbolden skal være under 1,15 m over gulvet**, når ketsjeren rammer
   den (§9.1.6). *Den faste højde blev indført som forsøg ved BWF-turneringer
   fra 1. marts 2018 [BWF-2018] og står nu i reglerne. Den afløste den gamle
   regel om "under taljen". Hvornår forsøget blev permanent, har jeg ikke
   fundet en kilde på.*
5. Ketsjeren bevæger sig kun fremad fra servens start, til bolden er ramt
   (§9.1.7). Et stop eller en pause i fremadbevægelsen er fejl.
6. Serveren må ikke ramme ved siden af bolden (§9.1.8).
7. Fjerboldens bane skal gå opad fra ketsjeren og lande i modtagerens servefelt,
   hvis ingen rører den (§9.1).
8. Ingen må forsinke serven unødigt. En pause efter bagsvinget tæller som
   forsinkelse (§9.1.1, §9.1.2).

Serven starter med ketsjerhovedets første fremadbevægelse og er leveret, når
bolden rammes eller misses (§9.2, §9.3). Serveren må ikke serve, før
modtageren er klar. Forsøger modtageren at returnere, regnes modtageren for at
have været klar (§9.4). I double må makkerne stå, hvor de vil på egen
banehalvdel, så længe de ikke skærmer for modstanderens server eller modtager
(§9.5).

## Hvem server hvorfra

**Single (§10):** Serverens eget pointtal bestemmer feltet. Ved lige pointtal
(0, 2, 4 …) serves der fra højre felt, ved ulige fra venstre. Vinder serveren
duellen, får serveren point og server igen fra det andet felt. Vinder
modtageren, får modtageren point og bliver ny server.

**Double (§11):**

- Den servende side server fra højre felt, når dens pointtal er lige, og fra
  venstre, når det er ulige.
- Spillerne skifter kun felt, når deres side vinder et point på egen serv.
  Modtagerne bliver stående.
- Modtageren er den spiller, der står diagonalt over for serveren.
- Serveretten går på skift: første server, derefter modtagerens makker, så
  første servers makker, så første modtager og så videre (§11.4).
- I et nyt sæt må begge spillere på vindersiden serve først, og begge på
  tabersiden må modtage først (§11.6).
- Er der servet eller modtaget i forkert rækkefølge eller fra forkert felt,
  rettes det, når bolden ikke er i spil. Stillingen står ved magt (§12).

## Fejl (§13)

**Ved serven:** serven er ikke korrekt (se ovenfor); bolden bliver hængende
oven på nettet eller i nettet efter at være kommet over; modtagerens makker
rører bolden.

**Mens bolden er i spil:**

- Bolden lander uden for banen, går ikke over nettet, rammer loft eller vægge,
  rammer en spiller eller spillerens tøj, eller rammer noget uden for banen.
- Bolden bliver fanget og slynget af ketsjeren. Samme spiller rammer to gange i
  træk, eller to makkere rammer lige efter hinanden. *Men det er ikke fejl,
  hvis bolden rammer både ramme og strenge i ét og samme slag (§13.3.7).*
- Bolden rører en spillers ketsjer og fortsætter ikke mod modstanderens side.
- En spiller rører nettet eller stolperne med ketsjer, krop eller tøj.
- En spiller kommer ind over nettet på modstanderens side. **Undtagelse:** man
  må følge bolden over nettet med ketsjeren i slagets forlængelse, hvis
  træffet skete på egen side (§13.4.2).
- En spiller kommer ind under nettet og generer eller forstyrrer modstanderen.
- En spiller spærrer for modstanderens lovlige slag eller forstyrrer bevidst,
  fx ved at råbe eller gestikulere.

## Let (omspil) (§14)

Der spilles om, og serveren fra sidste duel server igen, hvis:

- der serves, før modtageren er klar;
- både server og modtager laver fejl i serven;
- bolden bliver hængende oven på nettet eller i nettet **efter** at serven er
  returneret;
- fjerbolden går i stykker, og korken falder helt af;
- en træner forstyrrer spillet eller en modstander;
- linjedommeren ikke kunne se, og der ikke kan træffes en afgørelse;
- der sker noget uforudset.

## Bolden er ude af spil (§15)

Bolden er ude af spil, når den rammer nettet eller stolpen og begynder at
falde ned på slagmandens egen side, når den rammer gulvet, eller når der er
dømt fejl eller let.

## Pauser, råd og opførsel (§16)

- Spillet er uafbrudt bortset fra de faste pauser og afbrydelser, dommeren
  godkender. Man må ikke trække tiden for at puste ud eller få råd.
- **Råd fra træneren** må kun gives, når bolden ikke er i spil, og kun indtil
  spillerne har stillet sig op til serv og modtagelse (§16.5.1).
- Man må ikke forlade banen uden dommerens tilladelse, bortset fra i pauserne.
- Bevidst ødelæggelse af fjerbolden og usportslig opførsel straffes med
  advarsel, derefter fejl, og i grove tilfælde bortvisning (§16.6, §16.7).

## Kilder

- [L] BWF Statutes, Section 4.1: *Laws of Badminton*, v5.0, i kraft
  26-04-2025.
  <https://extranet.bwf.sport/docs/document-system/81/1466/1470/Section%204.1%20-%20Laws%20of%20Badminton%20-%2026%20April%202025%20V5.0%20(2)%20.pdf>
- [BWF-2025] BWF: *Updates to BWF Laws and Regulations*, 02-05-2025 (spin-serv
  forbudt).
  <https://corporate.bwfbadminton.com/news-single/2025/05/02/updates-to-bwf-laws-and-regulations-2>
- [BWF-3x15] BWF: *Key Changes Under the 3×15 Scoring System*, 26-04-2026.
  <https://bwfbadminton.com/news-single/2026/04/26/key-changes-under-the-3x15-scoring-system>
- [BD-3x15] Badminton Danmark: *3×15-pointsystem indføres efter
  sommerferien*, 28-05-2026.
  <https://badminton.dk/2026/05/28/3x15-pointsystem-indfoeres-efter-sommerferien/>
- [BWF-2018] BWF: *Experimental Service Law from March 2018*, 29-11-2017.
  <https://bwfbadminton.com/news-single/2017/11/29/experimental-service-law-from-march-2018>
- BWF: *Updates to BWF Laws and Regulations*, 27-11-2025. Kun ændringer i
  turneringsreglementet (ranglister, kontinentale mesterskaber, para), ingen
  ændringer i spillereglerne.
  <https://bwfbadminton.com/news-single/2025/11/27/updates-to-bwf-laws-and-regulations-4>

Alle kilder er slået op 29-09-2026.

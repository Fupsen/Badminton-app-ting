# Badminton-vidensbank

Viden om badminton, samlet fra gode kilder og skrevet på dansk. Den er lavet,
så Claude (og mennesker) har noget solidt at bygge appens indhold og svar på.
`CLAUDE.md` i roden af repoet peger hertil, så Claude læser den i nye
sessioner.

**Sidst opdateret:** 01-10-2026.

| Fil | Indhold |
| --- | --- |
| [regler.md](regler.md) | BWF-reglerne (v5.0, 2025) og **3×15-pointsystemet**, som gælder i Danmark fra 1. juli 2026 og internationalt fra 4. januar 2027. |
| [teknik.md](teknik.md) | Greb, slagets fire faser og alle slag med teknikpunkter. |
| [benarbejde.md](benarbejde.md) | Bevægelsescyklus, split step, skridttyper, udfald, landing og mønstre til hvert hjørne. |
| [ovelser.md](ovelser.md) | Alle øvelser i appen med niveau og kilde, og hvordan BWF organiserer træningen (fodring, multi-fjer, skygge, kampe med særregler). |
| [taktik.md](taktik.md) | Grundprincipper, single, double, mixed og situationstræning. |
| [fysisk-traening.md](fysisk-traening.md) | Kampens krav, opvarmning, træning af hver egenskab, børn og unge (BWF's udviklingstrin, Badminton Danmarks anbefalinger om træning, hvile og søvn), planlægning. |
| [skader.md](skader.md) | Hvor ofte og hvor skader sker, typiske skader og forebyggelse. |
| [kilder.md](kilder.md) | Alle kilder samlet. |

## Principper

1. **Kilder først.** Hver fil har en kildeliste med links og dato for opslag.
   Primære kilder går forud for alt andet: BWF's regler, BWF's
   trænermateriale, Badminton Danmark, Team Danmark og videnskabelige
   artikler.
2. **Mærk usikkerhed.** Det, der ikke har en direkte kilde, er markeret som
   *(praksis)* (almindelig træningspraksis) eller *Tolkning*. Tal, der kun er
   læst i et sammendrag eller abstract, er markeret sådan.
3. **Niveau:** [B] begynder, [Ø] øvet/klubspiller, [E] elite, [Børn] børn og
   unge. Uden markering gælder det for alle.
4. **Højrehåndet** som standard. Venstrehåndede spejler det.
5. **Egne ord.** Der er ingen lange citater fra kilderne.
6. **AI-træneren læser vidensbanken.** Filerne pakkes med i appen og sendes
   med hvert spørgsmål til AI-træneren (listen står i
   `lib/content/coach_da.dart`). Det, der står her, er altså også det, AI'en
   svarer ud fra.
7. **Appen følger vidensbanken.** Indholdet i `lib/content/technique_da.dart`
   (slag, benarbejde og øvelser) og reglerne i `lib/logic/scoring.dart` skal
   stemme med filerne her.
   Ændres det ene, skal det andet tjekkes.

## Kendte huller (til næste opdatering)

- BWF's Level 1-manual er læst side for side for modul 3-9 og 11 (01-10-2026).
  Modul 8 (taktik) er kun læst for de vigtigste sider. **Level 2-manualen**
  kræver registrering hos BWF, og **BWF Shuttle Time** (børn og skoler)
  blokerer automatiske opslag. Ingen af dem er læst.
- **"Rundt om hovedet"** er ikke beskrevet i Level 1-manualen og bygger
  stadig på praksis. Det samme gælder de fleste øvelsers tider og antal
  gentagelser.
- **BATK** (Badminton Danmark) er en bog, der ikke ligger frit, og den er ved
  at blive opdateret. Talentstrategien og siden om fysisk-motorisk
  basistræning er læst direkte.
- bwfbadminton.com afviser automatiske opslag (Cloudflare). Nyhederne om 3×15
  og spin-serv er læst tidligere via Firecrawl.
- Mental træning og udstyr (strenge, spænding, sko, fjerbold eller plast) er
  ikke dækket endnu.
- Forskningen er tjekket i PubMed 01-10-2026. Skadesoversigten [S2025] er
  læst i fuld tekst. Resten er abstracts.

# Badminton-vidensbank

Viden om badminton, samlet fra gode kilder og skrevet på dansk. Den er lavet,
så Claude (og mennesker) har noget solidt at bygge appens indhold og svar på.
`CLAUDE.md` i roden af repoet peger hertil, så Claude læser den i nye
sessioner.

**Sidst opdateret:** 29-09-2026.

| Fil | Indhold |
| --- | --- |
| [regler.md](regler.md) | BWF-reglerne (v5.0, 2025) og **3×15-pointsystemet**, som gælder i Danmark fra 1. juli 2026 og internationalt fra 4. januar 2027. |
| [teknik.md](teknik.md) | Greb, slagets fire faser og alle slag med teknikpunkter. |
| [benarbejde.md](benarbejde.md) | Bevægelsescyklus, split step, skridttyper, udfald, landing og mønstre til hvert hjørne. |
| [taktik.md](taktik.md) | Grundprincipper, single, double, mixed og situationstræning. |
| [fysisk-traening.md](fysisk-traening.md) | Kampens krav, opvarmning, træning af hver egenskab, børn og unge, planlægning. |
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
6. **Appen følger vidensbanken.** Indholdet i `lib/content/technique_da.dart`
   og reglerne i `lib/logic/scoring.dart` skal stemme med filerne her.
   Ændres det ene, skal det andet tjekkes.

## Kendte huller (til næste opdatering)

- BWF's Level 1-manual er kun læst som målrettede udtræk, ikke side for side.
  Level 2-manualen og BWF Shuttle Time (børn og skoler) er ikke læst.
- Badminton Danmarks BATK-materiale og talentstrategien er ikke læst direkte.
- Taktik til double og mixed bygger mest på praksis og bør suppleres med en
  trænerkilde.
- Mental træning og udstyr (strenge, spænding, sko, fjerbold eller plast) er
  ikke dækket endnu.
- De fleste forskningstal er fra abstracts. Fuld tekst var ikke tilgængelig
  fra dette miljø.

# 📗 En introduksjon til Git

---

## 📕 Systemet

Her ser vi strukturen Git-systemet bygger på. Man har

- **Working directory** (her kalt **TRE**)
- **Staging area** (her kalt **INDEKS**) og
- **Git directory** (her kalt **REPO**):

<!-- ![Git](./git.png-FJERN) -->

Dette korresponderer til de tre stadiene en fil  kan være i under Git:

- Modifisert: Filen er endret, men ennå ikke sendt videre i Git-systemet
- Sendt til INDEKS: Filen er markert i sin nåværende versjon for å bli med i neste *commit*
- *Comitted*: Filen er trygt lagret i REPO-databasen

Arbeidskatalogen utgjør den aktive, lokale utgaven av filtreet til prosjektet. Filene er hentet ut fra REPO og plassert på disken klar for bruk eller videre modifisering.

INDEKS er rent fysisk en fil og holder oversikt over om hva som skal med i neste *commit*.

REPO inneholder objektdatabasen for prosjektet og lagrer alle versjoner, all historikk og alt av relasjoner gjennom prosjektet.

Både INDEKS og REPO opererer på fulle øyeblikksbilder av prosjektet, såkalte *snapshots* eller *commits*. INDEKS inneholder øyeblikksbildet for neste *commit*, mens REPO inneholder hele følgen av øyeblikksbilder, hele historikken, fra oppstart til siste *commit*. Git lagrer selvsagt ikke hele filstrukturen i hver *commit*, men holder orden på endringer og sammenhenger for effektiv og plassbesparende utnyttelse.

<!-- ![Brancht](./branch.png) -->

Her ser vi en illustrasjon av et i prosjekt organisert to grener, Master og Feature, som består av hhv. fire og to øyeblikksbilder. Sistnevnte gren er forgrenet ut fra hovedgrenens andre øyeblikksbilde.

Vi ser også noen andre viktige elementer i Git, nemlig:

- pekeren HEAD, som peker på aktivt øyeblikksbilde, samt
- to gren-pekere (her kalt MAIN og FEATURE) som peker på de to grenene.

Vi kommer tilbake til hvordan disse egentlig er implementert.

 Den grunnleggende arbeidsflyten er som følger:

1. Brukeren endrer eller oppretter filer i arbeidskatalogen
2. Brukeren velger hvilke forandringer som skal være med i neste *commit* ved å legge disse til INDEKS
3. Bruker gjør en *commit*, hvilket tar filene slik de er i INDEKS og lagrer alt (hele øyeblikksbildet) i REPO.

Ved bruk av esktern versjonskontroll, som f.eks. ved bruk av GitHub, må man foreta et innledende `git pull` (for hente inn nyeste tre fra ekstartn REPO) og et avsluttende `git push` (for å synce lokalt REPO med ekstern REPO) i tillegg. GitHub vil ble behandlet spesielt senere i dokumentet.

Ettersom prosjektet vokser, kan prosjektet grene ut i flere versjoner. Disse vil likevel være lagret i samme REPO. Alt av data, alt av historikk og referanser for å kunne gjenskape ulike versjoner i sin helhet, er lagret der. Vi kommer tilbake til flere detaljer.

Vi bør i oppstarten også nevne at vi kan skjerme bestemte filer og kataloger fra Git ved å inkludere dem i en tekstfil **.gitignore** øverst i arbeidskatalogen. Avhengig av type prosjekt, kan man velge å ikke følge bestemt filer.

---

## 📕 Grunnleggende bruk

Før vi går inn på flere Git-detaljer og ser nærmere på hvordan ting henger sammen, kan vi vise noen eksempler og kommandoer for grunnleggende bruk. Dette dekker normal aktivitet, og mange vil klare seg kun med dette. Noen kommandoer fins i både eldre og nyere varianter, og vi skal prøve å benytte de nyere. Vi fokuserer først på lokal bruk, og tar for oss hvordan man kobler seg på eksterne systemer som GitHub, for backup, samarbeid eller fjernaksess senere.

---

### ▶️ Initialisering (init)

Man kan initialiser Git for et prosjekt med å gjøre

```nginx
git init
```

på toppen av aktuelle arbeidskatalog. Ved første initialisering, for aller første prosjekt, oppgis navn og e-postadresse. Senere benyttes disse valgene automatisk.

Default *branch name* ved initialisering er *master* eller *main*, avhenging av distro. Ønsker man å spesifisere navnet nærmere, kan man benytte **`-b`**-opsjonen.

```html
git init -b <grennavn>
```

---

### ▶️ Legge til indeks (add)

Man sender en bestemt fil til INDEKS ved:

```html
git  add <fil>
```

`add` tillater globbing, som f.eks. `*.md`, for å sende en familie av filer til INDEKS.

Man kan legge til alle modifiserte filer ved

```r
git  add -A
```

eller

```r
git  add .
```

Sistnevnte gjelder bare for **nåværende katalog**.

Man kan også foreta et *dry run* for å se hvilke filer som vil bli sendt til INDEKS ved:

```r
git add -n -A
```

Kommandoen

```r
git add -u
```

tar med endringer og slettinger, men ikke nye filer.

---

### ▶️ Se Git-infomasjon

Man kan til se hvilke filer som er *modifisert* og hvilke som er sendt til INDEKS ved `git status`. Under ser vi noen varianter. Disse viser hhv. alle slike filer i en long output eller i kort output, samt branch-info:

```nginx
git status
```

```r
git status -s
```

```html
git status -b <branch>
```

Vi kan få informasjon om øyeblikksbilder ved `git log`. Et eksempel på en output er også vist.

```nginx
git log
```

```yaml
commit bbf9a583e00cf19be7d7714a0d24be6af9ffc00b
Author: <navn> <e-post>
Date:   Wed Feb 11 10:29:13 2026 +0100

    On branch <gren>
    Your branch is up to date with 'origin/<gren>'.
    
    Changes to be committed:
            modified:   file-1.md
            modified:   file-4.md
    
    More details.
```

Alt under datolinjen her er brukerens beskrivelse, enten gitt ved `-m`-opsjonen til `commit` eller (mer sannsynnlig i dette tilfellet) via en editor som VSCode. Øverst ser vi hashen til øyeblikksbildet, som kan benyttes som entydig *commit*-refereranse (ofte bare i kortform, de 7 første tegnene).

Under ser vi flere `git log`-varianter. Disse viser hhv. nyeste øyeblikksbilde, de to nyeste bildene, en kort, fargeformatert output samt en som viser et spesifikt bilde med utvidet informasjon om bl.a. fil-endringer.


```r
git log -1
```

```r
git log -2
```

```r
git log --oneline --graph --decorate --all
```

```html
git log <hash> --stat
```

---

### ▶️ Endre filnavn

For å endre navnet til en fil i TRE, kan man gjøre:

```html
git mv <fil> <ny-fil>
```

Navnet endres på arbeidskatalogen, og endringen legges til på INDEKS, klar for neste *commit*.

Alternativt kan man navnendre filen og legge den til indeksen selv. Altså gjøre:

```html
mv <filnavn> <nytt-fil-navn>
git <ny-fil>
```

Kun dette blir endret:

```yaml
rename: TRE → INDEKS
```

så alt er klargjort for en oppfølgende *commit*.

---

### ▶️ Slette fil

For å slette en fil i TRE kan man gjøre

```bash
git rm <fil>
```

Dette krever at filen er *commited*. Kommandoen gjør to ting samtidig:

- Fjerner filen fra arbeidskatalogen
- Legger inn endringen på INDEKS

Man kan for så vidt også slette filen fra arbeidskatalogen (ved `rm`) og legge til INDEKS selv (ved `add`), med samme resultat.

Dersom man ønsker å beholde filen lokalt, men bare fjerne den fra Git, kan man dessuten gjøre

```bash
git rm --cached <fil>
```

(og deretter også oppdatere **.gitignore** tilsvarende).

Kun INDEKS blir endret

```yaml
delete: TRE → INDEKS
```

Prosessen krever en avsluttende *commit*.

---

### ▶️ Forgreninger (branch)

Man kan lage en ny gren ved:

```html
git branch <navn>
```

Man kan hoppe til en bestemt gren ved:

```html
git switch <navn>
```

Følgende kommando viser alle lokale grener:

```nginx
git branch
```

Denne viser i tillegg alle ikke-lokale:

```r
git branch -a
```

og denne bare de ikke-lokale:

```r
git branch -r
```

Mer spesifikk informasjon relatert til ekstern REPO fås fra:

```r
git branch -vv
```

Det følgende oppretter branch fra en bestemt commit;

```html
git branch <navn> <commit>
```

---

### ▶️ Se endringer (diff)

Man kan se forskjellen mellom to øyeblikksbilder ved:

```html
git diff <commit1> <commit2>
```

Denne baserer seg på den klassiske `diff`-kommadoen i Linux. Det fins bedre moderne alternativer, som `delta` `difft` (som begge må installeres spesielt), og det er mulig å sette opp GitHub til å bruke disse isteden. Piping fungerer dessuten også for `delta`, slik at det følgende gjerne er mer brukervennlig:

```html
git diff <commit1> <commit2> | delta
```

Man kan referer absolutt til *commit* med å angi hash-verdien (typisk i kortform) eller relativt som f.eks:

```nginx
git diff HEAD~3 HEAD
```

(her refereres siste commit (HEAD) og den tredje før det).

```nginx
git diff HEAD^ HEAD
```

(her refereres siste og den før det).

Ulike refereringsmåter er behandlet senere i dokumnetet.

For bare å se hvilke *filer* som skiller seg, kan man gjøre:

```html
git diff --name-only <commit1> <commit2>
```

Man kan også sammenlikne grener ved:

```html
git diff <gren-1> <gren-2>
```

Om man vil se hva som er endret siden siste commit, kan man gjøre:

```nginx
git diff HEAD
```

Om man vil sammenligne INDKES OG HEAD, kan man gjøre:

```r
git diff --staged
```

Disse eksemplene, som er på formen `git diff A B` sammenlikninger to *commits* A og B direkte. Man kan også gjøre

```nginx
git diff A...B
```

(kun aktuell i forgreninger) som sammenlikner B med siste felles *commit* for A og B.

---

### ▶️ Foreta commit

Man foretar *commit* ved:

```html
git commit -m "<Passende beskrivelse>"
```

Evt. kan man sende alt både til INDEKS og til *commit* samtidig ved:

```html
git commit -a -m "<Beskrivelse>"
```

Droppes opsjonen `-m`

```nginx
git commit
```

åpnes standard editor, og man kan skrive en lengre, mer detaljert melding som også støtter multiline *commit*-beskrivelser.

---

### ▶️ Merkalapper (tags)

Tags er merkelapper (pekere) til konkrete øyeblikksbilder. Man har to typer: *lightweight* og *annotated*. Førstnevnte er for korte tags, som v-1.0 og liknende. Denne gis ved:

```html
git tag <tag-navn> <commit-hash>
```

Den andre er for lengre, mer sammensatte tags, og er et eget Git-objekt med følgende innehold:

```yaml
-hvem som tager
-dato
-melding
-mulighet for kryptografisk signering
-peker på commit
```

Den settes vef:

```html
git tag -a <tag-navn> -m "melding" <commit>
```

Vi kan liste tags ved

```r
git tag
```

evt. ved

```r
git tag -l
```

der siste kan kombineres med et mønster som `v-2*` for å vise alle versjon 2-tags f.eks., altså slik:

```r
git tag -l "-2*"
```

Kommandoen

```nginx
git show <tag>
```

viser *commit*-tag og eventuelle annotasjoner.

Man sletter en bestemt tag ved:

```r
git tag -d <tag>
```

❗ Husk at alle tags er lokale. De kan oppfattes som lokale bokmerker, og er ikke en del av en *commit*/*push* og vil ikke være synlige eksternt (f.eks. på GitGub).

Man kan pushe en bestemt tag ved

```html
git push origin <tag>>
```

eller alle ved

```ngirnx
git push origin --tags
```

Etter dette kan man hente ned tags på en annen PC ved:

```ngirnx
git fetch --tags
```

---

### ▶️ Archive

`git archive` lar bruker pakke innholdet av en *commit*, *branch* eller *tag* i en arkivfil (f.eks. .zip eller .tar) uten å inkludere hele Git-historikken. Den brukes ofte for å dele kode som et snapshot, eller lage en kildekodepakke til en distribusjon.

Syntaksen er

```bash
git archive [options] <commit/branch/tag> [paths]
```

Her ser vi noen eksempler:

```bash
git archive -o project-main.zip main
```

```bash
git archive -o project.tar 1a2b3c4
```

```bash
git archive main | tar -x -C /tmp/project
```

---

### ▶️ Stash

`git stash` gjør at man kan legge til side endringer i arbeidsområdet uten å lage en ny *commit*. Dette er nyttig når man vil:

- bytte branch uten å *commite* halvferdige endringer
- teste noe midlertidig
- rydde arbeidsområdet midlertidig

Typisk pusher man en eller flere arbeidsfiler filer til et stash-område. Deretter kan man jobbe videre med resten av prsojektet som vanlig, gjerne *commite* endringer osv. uten at ednringer i arbeidsfilene har blitt med. Senere kan man poppe arbeidsfilene tilbake og jobbe/commite med disse filene inkludert.

Her ser vi push uten og med en beskrivelse:

```bash
git stash push <fil-1> <fil-2>
```

```bash
git stash push -m "Beskrivelse" <fil-1>
```

Globbing av filer er ikke støttet her.

Slik stashes alle modifiserte filer:

```bash
git stash
```

Dette lister alle:

```bash
git stash list
```

Her hentes arbeidsfilene tilbake: 

```bash
git stash pop
```

og det samme skjer her,  men man lar dem bli liggende på stash-området:
```bash
git stash apply
```

---

### ▶️ Hjelp

Man kan få hjelp via manualsider til ulike kommandoer, både i kort og langt format. Den første er for korte beskrivelser, de to andre for lengre (like) output:

```nginx
git <comand> -h
  ```

```html
git <comand> --help
  ```

```html
git help <comand>
```

Man kan også få en liste over alle kommandoer ved:

```r
git help -a
```

---

## 📕 Git: En detaljert kikk

For å forstå Git bedre og å kunne håndtere enkelte kommandoer riktig, trenger vi å dykke mer ned i detaljene. Vi må vite litt om hvordan et øyeblikksbilde egentlig ser ut og hvordan de ulike pekerne fungerer. Dessuten må se på hvordan man kan referere ting i git-kommandoer, hovedsaklig *commits*, og vi velger å starte der.

---

### ▶️ Hvordan referere?

Man kan generelt referer både absolutt og relativt, både utfra øyeblikksbilder, merkelapper og grener. Det grunnleggende (og i normaltilstander) er oppsummert under og kan typisk testes ved:

```html
git show -s <ref>
```

Her det mest grunnleggende:

```yaml
RELATIVE
  HEAD               : Aktiv commit
  HEAD^    HEAD~1    : Forelder
  HEAD^^   HEAD~2    : Besteforelder
  HEAD^^^  HEAD~3    : Oldeforelder
  osv
  <tag>^   <tag>~1   : Commit før den tag-refererte
  osv
  <gren>^  <gren>~1  : Commit før den gren-refererte
  osv

ABSOLUTTE
  Full hash
  Kort hash
  Tag
  Branch

REFLOG-BASERTE
  HEAD@{0}:   nåværende HEAD
  HEAD@{1}:   forrige posisjon ift. reflog
  HEAD@{2}:   posisjonen før det ift reflog
  osv
  <gren>@{1}: forrige commit gren pekte på ift reflog
  osv
```

Man kan ikke referere ut fra meldingstekst eller filinnhold, men man kan gjøre det indirekte ved:

```yaml
git log --grep="<mønster>"  : Meldingstekst
git log -S "<mønster>"      : Filinnhold
git log -G "<mønster>"      : Endret filinnhold
```

Refreansene `^` og `~` betyr ikke nøyaktig det samme. Den første teller antall foreldre bakover inklusive tilfeller der en *commit* har flere foreldre (som kan forekomme ifm `merge`). Den siste teller bare førsteforeldre bakover.

Når det gjelder `reflog`, så lagrer Git en lokal logg over

- checkout
- commit
- merge
- reset
- rebase

og dette kan vises med:

```nginx
git reflog
```

Output sier noe slikt:

```text
16c54e5 (HEAD -> NyMain, origin/<gren> ...
96d8ea0 HEAD@{1}: commit: On branch ...
bbf9a58 HEAD: clone: from github.com ...
```

og dette forklarer `@{n}`-notasjonen.

---

### ▶️ Innhold i øyeblikksbilder

Et øyeblikksbilde inneholder:

1. Tre-hash
2. Referanse til en eller flere forelderbilder
3. Metadata
   - Forfatter
   - Hvem som utførte *commit*
   - Tidsstempl
   - *Commit*-melding
4. Commit-hash

Bortsett fra den første er alle disse relativt selvforklarende. Normalt her et øyeblikksbilde bare ett forelderbilde, men ifm. sammenfletting av grener (*merge*), kan flere foreldre involvert, og dette fremkommer da her. Metadataene trenger ingen forklaring, og man kan også se disse dataene for ett bilde ved:

```html
git cat-file -p <commit-hash>
```

*Commit*-hash er hash-verdien av hele denne datastrukturen.

Tre-hashen er kort fortalt er hash av en binær serialisering av lister over filer og mapper, navn og typer, samt hash til BLOBs (*binary large objects*) og subtrær. Slik kan Git kan holde oversikt over filtrær og innhold, oppdage endringer og gjøre nye nye hash-beregninger etter behov. Trær og blobs gjenbrukes, og Git operer effektivt både mht til ytelse og lagringsmessig.

Et øyeblikksbilde kjenner sine foreldre, men ingen av sine besteforeldre osv. Historikken kan imildertid nøstes opp ved å følge rekker av foreldre bakover.

Det er mulig å grave enda dypere i dette, men dette holder trolig for vårt formål.

---

### ▶️ HEAD og gren-pekere

Vi må se litt nærmere på hvordan peker HEAD og gren-pekere er implementert og virker. Vi husker at HEAD (konseptuelt) peker på aktivt øyeblikksbilde, mens gren-pekere (konseptuelt) peker på hver sin gren. Begge deler er imidlertid vanlige tekstfiler. HEAD ligger på `.git`, mens de sistnevnt ligger på `.git/refs/heads` og har filnavn som tilsvarer grennavnet (én fil for hver gren).

En grenpeker, som f.eks. MAIN, inneholder hash-verdien til et øyeblikksbilde (normalt siste øyeblikksbilde på grenen), som f.eks:

```yaml
436ab61d81d052cd320f3a8a4dc532f33e5d1a13
```

HEAD, på sin side, inneholder (i normal tilstand) referanse til en gren i form av sti/filnavn til en grenpeker som eksemplifisert her:

```yaml
ref: refs/heads/main
```

I noen tilfeller (som vi skal se) inneholder den imidlertid bare hash-verdien til et bestemt øyeblikksbilde. HEAD sises da å være *detached* eller i *detached* tilstand, hvilket er utnyttes av enkelt kommandoer.

Men i normaltilstand, når man sier "HEAD peker på øyeblikksbilde D", så betyr det egentlig at HEAD peker på MAIN, som i sin tur peker på bilde D:

```yaml
HEAD → MAIN → D
```

---

### ▶️ Forutsetninger og antakelser videre

Vi skal nå se mer detaljer på hva som endrer seg og ikke ifm. viktige kommandoer. Dette er ofte helt avgørende for å forstå og se forskjeller på beslektede kommandoer. Konkret bør man se på hva som endres av 

- **TRE**
- **INDEKS**
- **REPO**
- **HEAD**
- **MAIN**

Vi antar her at MAIN er aktuell gren. VI antar videre at vi i utgansgpunktet er i normaltiltsand der MAIN og HEAD peker ut siste commit på aktiv gren.

Vi lar også

- **REPO.commit**

referer *commiten* det refereres til i kommandoer.

For å eksemplifisere: Vi har sett på kommandoene `add` og `commit`. Disse er enkle i denne sammenheng. `add` påvirker ikke REPO, HEAD, eller MAIN, men sørger for at et øyeblikksbilde av TRE sendes til INDEKS. *Commit* legger øyeblikksbildet på INDEKS over i følgen av øyeblikksbilder på REPO, mens HEAD her fortsatt peker på MAIN, og MAIN oppdateres til å peke på ny *commit*.

Dette kan vi da ha illustrere ved:

```yaml
add:
    TRE → INDEKS
commit:
    INDEKS → REPO, MAIN++
```

Det som ikke nevnes er altså uforandret.

---

### ▶️ Reset

`git reset` er en kommando med rike muligheter til å endre tingenes tilstand. Vi har tre grunnleggende versjoner: **soft**, **mixed** og **hard** (med flere mulige opsjoner).

Man kaller

```bash
git reset <styrke> <commit>
```

Vi kan oppsummere virkingen med:

```yaml
Soft reset:
    MAIN → commit

Mixed reset: 
    MAIN → commit, INDEKS ← REPO.commit

HARD reset:
    MAIN → commit, TRE ← INDEKS ← REPO.commit
```

HEAD peker fortsatt på MAIN.

Ved *hard reset* kan man dessuten benytte opsjonene `--Merged` og `--Keep`, som på to måterbeskytter filer i TRE fra overskrivelse.

Mixed er default.

La oss se nærmere hva som skjer også med pekerne i et annet `reset`-eksempel.

Anta vi har en følge av øyeblikksbilder A → B → C → D på MAIN, og at D er aktivt. Hva skjer om vi foretar:

```nginx
git reset soft <B>
```

Hele prosessen kan oppsummeres ved:

```yaml
HEAD → MAIN → B
```

Dvs. MAIN peker på øyeblikksbilde B, og HEAD peker på gren MAIN. Dette gjør B aktivt. Ved *soft reset* endres verken TRE eller INDEKS (slik at disse i utgangspunktet fortsatt har verdi D). REPO er uansett uforandret.

Merk nå at dersom vi commit'er modifiseringer, får vi en etterfølger vi kan betegn C' som vil være ulik C (uansett om modifiseringene skulle være identiske). C og D risikerer nå å bli hengende (selv om forgjenger B er uendret). Dersom intet annet refererer dem, en tag eller noe, risikerer disse (med tid og stunder, kanskje etter 30 dager) å bli slettet av *garbage collector* (GC). Disse risikerer å bli såkalt *unreachable*.

Dette betyr at *reset* primært er ment for å rulle tilbake i versjoner, kanskje angre en *commit* ved feilskrevet melding etc. Lite endres direkte (særlig ved *soft reset*), men etterfølgende modifisering vil endre historikken og gjøre kommandoene nokså gjennomgripende like fullt.

La oss nå se på den beslektede kommandoen `switch`.

---

### ▶️ Switch

Switch kommer i to varaienter: `git switch <gren>` som hopper til ny gren, og `git switch --detached <commit>` som hopper et spesifikt *commit*. I den første blir HEAD satt til å peke på ny gren, i den andre havner den i detached mode og peker på den aktuelle *commiten*.

Vi kan oppsummere virkningene ved

```yaml
git switch GREN:
    HEAD → GREN
    TRE ← INDEKS ← REPO.commit
```

og

```yaml
git switch --detached commit:
    HEAD → REPO.commit (detached)
    TRE ← INDEKS ← REPO.commit
```

I den første skjer det intet med MAIN. Den peker fortsatt på siste *commit* på sin gren. HEAD blir isteden satt til å peke på en annen gren, referert til med GREN, og denne igjen peker på sin siste *commit* på grenen. Dette øyeblikksbilde overføres så både til både INDEKS og TRE, slik totaltilstanden blir identisk med hva den var da det aktuelle øyeblikksbildet ble *commited*. Dette er nettopp hva man ønsker om man vil jobbe men en annen versjon av prosjektet.

I den andre skjer heller ingenting med MAIN. HEAD peker altså direkte på den spesifiserte *commiten* (HEAD-filen får hash-verdien som innhold, *detached*-mode), og øyeblikksbildet overføres både til INDEKS og TRE.

---

### ▶️ Restore

`git restore` er en kommando som kopierer filer fra en kilde til INDEKS og/eller TRE, styrt av opsjoner. Verken HEAD eller grenpeker endres av `restore`.

```yaml
git restore <fil>:
    TRE ← INDEKS

git restore --staged <fil>:
    INDEKS ← REPO.commit (HEAD)

git restore --source=<commit> <fil>:
    TRE ← REPO.commit

git restore --source=<commit> --staged --worktree <fil>:
    TRE ← INDEKS ← REPO.commit
```

Filer kan evt. spesifiseres med globbing som `*.md`. Uten filspesifisering vil alle filer i aktuell *commit* gjenskapes.

Uten `--source` er det *commit* utpekt av HEAD og aktiv gren som legges til grunn i utvelgelse av kildefiler. Man kan også si at INDEKS er default som kilde og TRE default som mål (når de ikke spesifisere og innenfor det som gir mening).

- I den første kommandoen, `git restore <fil>`, velges kildefilene fra INDEKS og kopieres til TRE (siden verken kilde eller mål er oppgitt).

- I `git restore --staged <fil>` er mål INDEKS oppgitt (`--staged`) oppgitt, så kildefiler velges nødvendigvis fra **commit.repo** og kopieres over i INDEKS.

- I `git restore --source=<commit> <fil>:` oppgis **REPO.commit** som kilde, men intet mål, så filer kopier fra derfra over i TRE.

- I `git restore --source=<commit> --staged --worktree <fil>:` oppgis to mål, både INDEKS og TRE. Kilde, en konkret *commit* på REPO, er oppgitt og kopieres dermed over som vist.

Man kan også benytte git restore opsjonen `---patch` for å få en interaktiv *restore*.

---

### ▶️ Merge

Kommandoen

```bash
git merge <gren-1> <gren-2>
```

*fletter* sammen to grener. Man kan godt tenke seg at Git *slår sammen* de to grenene til én, hvilket gjerne er det man ønsker. Fra en hovedversjon har man kanskje grenet seg ut for å eksperimentere med en ny funksjon. Og man kan ønske å slå disse sammen når funksjonen er moden for det. Men Git er tro mot sitt prinsipp om at alt skal kunne gjenskapes, så den fletter dem sammen til en gren hvor historikken ligger som en slags løkke i historikken. Vi skal først se på et lineært eksempel (**fast forward merge**) før to eksempler med overlappende grener i **no fast forward megre**.

#### 🔸 Fast forward merge

Anta vi har følgende tre av *commits*:

```text
A ── B ── C  ← MAIN ← HEAD
          \
           D ── E   ← FEATURE
```

Komandoene vi trenger her er:

```bash
git switch main
git merge feature
```

Her er det ingen konflikter og alt som skjer er at HEAD settes til å peke på MAIN, samt at TRE og INDEKS fylles med *commit* E.

```text
A ── B ── C ── D ── E ← MAIN ← HEAD
TRE ← INDEKS ← E
```

#### 🔸 No fast forward merge

Anta vi har følgende tre av *commits*:

```text      
      B   ← MAIN ← HEAD
     /
A ──
     \
      B' ── C' ← FEATURE
```

Vi kan flette sammen på to måter:

- *merge* FEATURE på MAIN:

```bash
git switch MAIN
git merge FEATURE
```

eller

- *merge* MAIN på FEATURE:

```bash
git switch FEATURE
git merge MAIN
```

Sammenflettinger kan medføre konflikter, som ikke er direkte vist her, men som vil være en del av bildet M, omtalt mer nedenfor. Sluttresultatet i de to tilfellene kan oppsummeres grafisk med

```text
      B ──────── M  ← MAIN ← HEAD
     /         /
A ──          /
     \       /
      B' → C'   ← FEATURE

TRE ← INDEX ← M
```

og

```text
      B   ← MAIN
     / \
A ──   M  ← FEATURE ← HEAD
     \ /
      B' → C'

TRE ← INDEX ← M
```

I begge tilfeller beregnes et øyeblikkesbilde **M** med to foreldre, som vist i figuren. Ved å følge linjene bakover kan man finne hele historikken, hele nodenettverket.

Ved konflikter blir dialogen en annen, og brukeren får dessuten ansvaret for å løse dem. I dette tilfellet må brukeren også utføre en etterfølgende.

```
git commit -m "Bedskrivelse"
```

Dette gjøres automatisk når det ikke er konflikter.

---

### ▶️ Cherry picks

En *cherry-pic*k tar endringer fra én *commit* og lager en ny *commit* med samme endringer på grenen man står på. Commiten kopieres ikke. Det lages en ny *commit* med nye foreldre (historikk) og ny hash.

Ant f.eks. vi har følge tre av commits:


```text
 A ── B ── C  ← MAIN ← HEAD
            \
             D ── E ← FEATURE
```

og ønsker å foreta *cherry-pick* av *commit* E fra FEATURE over på MIAN. Man må da forsikrer seg om at man står på MAIN, og så utfører `git cherry-pick` med referanse til commit E i form av en hash eller tag:

```bash
git switch main
git cherry-pick <E>

``` 

Sluttresultatet blir

```text
  A ── B ── C ── E'  ← MAIN ← HEAD
             \
              D ── E  ← FEATURE

TRE ← INDEKS ← E'
```

E' blir altså her den nye *commiten* som inneholder de samme endringene som E, men med ny hash og ny foelder (C).

---

### ▶️ Rebase

`git rebase` flytter en serie *commits* fra en gren til toppen av en annen. Historikken skrives om, *Committene* blir nye commit-objekter med nye hash-verdier og resultatet blir en lineær historie.

Om Git støter på konflikter underveis, stopper den og overlater til brukeren å løse opp. Deretter igangsettes prosessen igjen med:

```bash
git rebase --continue
```

Bruker kan når som helst abortere en *rebase* og gå tilbake til utgangspunktet med:

```bash
git rebase --abort
```

La oss se på detaljene. Anta f.eks. at vi har følgende commit-tre:

```text
      B' → C' → D' ← FEATURE ← HEAD 
     /
A ── B ── C  ← MAIN
```

og skal gjøre en rebase fra FEATURE over på MAIN. Man forsikrer seg da at at man står på FEATURe og gjør `rebase main`:

```bash
git switch feature
git rebase main
``` 

Sluttresultatet blir:

```text
A ── B ── C ── B'' ── C'' ── D''  ← FEATURE ← HEAD

TRE ← INDEKS ← D''
```

Legg merke til *commit*-rekkefølgen, og at det vil se ut som om FEATURE ble laget etter MAIN, selv om den opprinnelig forgrenet seg tidligere. *Committene* B', C' og D' får nye hash-verdier, så de er markert med B'', C'' og D'', men de inneholder de samme endringeme som B', C' og D' (som i utgangspunktet blir *unreachable*).

En *rebase* kan godt ses på som en serie av *cherry-picks*.

---

## 📕 GitHub

For å sette et prosjekt opp mot GitHub, må man først sørge for:

---

### 1️⃣ Opprette konto og nøkler

Dvs, man må

- Lage konto på [GitHub](https://github.com/).

- Generere SSH-nøkler lokalt. (Dette må senere også gjøre på andre PC-er man vil bruke)

```bash
ssh-keygen -t ed25519 -C <e-post>
```

Dette outputer informasjon om hvor nøklene lagres samt fingerprint til offentlig nøkkel og en såkalt *random art* av nøkkelen.

Fingerprint kan vises senere ved:

```nginx
ssh-keygen -lf ~/.ssh/id_ed25519.pub
```

og random art ved:

```nginx
ssh-keygen -lvf ~/.ssh/id_ed25519.pub
```

Deretter må man legge til den offentlige SSH-nøkkelen på GitHub. Man må kopiere sin lokale offentlige nøkkel ved hjelp av 

```nginx
cat ~/.ssh/id_ed25519.pub
```

finne fram på GotHub stedet man kan legge til SSH-vøkle, og deretter lime nøkkelkopien der. Om flere PC-er skal benyttes, må SSH-nøkler legges inn fra hver.

Man kan teste nøkkeloppsettet ved:

```nginx
ssh -T git@github.com
```
---

### 2️⃣ Opprette eksternt repository på GitHub

Neste steg er å opprette eksternt REPO. Velg et passende prosjektnavn, avgjør om det skal være privat eller offentlig tilgjengelig etc.

❗ IKKE huk av for:

- Add README
- Add .gitignore
- Add license

om du allerede har et prosjektet med slike filer allerede.


ℹ️ *Default branch* i prosjektet på GitGub forlanges fordi en av versjonene (grenene) av prosjektet må være prosjektet ansikt utad.

---

### 3️⃣ Forbinde remote med det lokale

Om du ikke har et lokalt Git-prosjket, lag ett på aktuell arbeidskatalog, f.eks. ved

```bash
echo "# <prosjektnavn>" >> README.md
git init -b <gren>
git add README.md
git commit -m "First commit"
```

  Om du har et lokalt Git-prosjekt, sørg for å gjøre `add` og `commit` og sjekk at du står på riktig gren.

Deretter gjør:

```bash
git remote add origin git@github.com:<brukernavn>/<prosjektnavn>.git
git push -u origin <gren>
```

Fordelen ved å benytte opsjonen `-u`, er at man:

1. siden slipper og angi gren i ``pull` og `push`
2. *Default branch* i prosjektet på GitHub settes iht. til dette.
3. 
Endelsen `.git` kan droppes i ovennevnte kommando.

For å eksemplifisere kommandoen, mitt brukernavn er `mailjaro`. For et REPO på GitHub med navnet f.eks. `git-doc`, blir kommandoen:

```nginx
git remote add origin git@github.com:mailjaro/git-doc
```

---

### ▶️ Vanlig bruk

Man kan foreta vanlige `push` og `pull` ved:

```nginx
git push
```

```nginx
git pull
```

Man kan også senere spesifisere gren spesifikt ved:

```nginx
git push origin <gren>
```

```nginx
git pull origin <gren>
```

For å se om noe er skjedd siden sist, før man evt. foretar en `pull`, kan man gjøre en `fetch`. Følgende henter nemlig informasjon om nye *commits* på GitHub:

```nginx
git fetch origin
```

Etter `fetch` kan man sjekke status ved:

```nginx
git status
```

Det følgende viser ekstern *commit*-log i kort format.

```nginx
git log origin/<gren> --oneline
```

og under ser du noen varianter med lengre output:

```nginx
git log origin/<gren>
```

```nginx
git log --pretty=fuller origin/<gren>
```

```nginx
git log --graph --decorate --all origin/<gren>
```

```nginx
git log -p origin/NyMain
```

---

### ▶️ Flere PC-er eller brukere

Om man vil jobbe med prosjektet på annen PC, bør man først ha initialisert Git med samme bruker og e-post som den opprinnelige PC-en. Deretter kan man klone prosjektet over fra GitHub med:

```nginx
git clone git@github.com:<bruker>/<prosjekt>.git
```

fra katalogen arbeidskatalogen (som blir opprettet i kallet) skal ligge på. Selve katalognavnet for prosjektet kan godt navnendres om prosjektnavnet ikke skal være katalognavnet.

Dersom man ønsker å samarbeide med eksterne brukere, må de først gis tilgang til GitHub-repoet. De må ha Git installert og ha SSH-nøkler etc. før prosjektet klones. Konflikter i filer kan forkeomme når flere modifiserer, commiter og pusher. Konflikter løses lokalt.

Har man mange Git-prosjekter, kan man over tid glemme hvilke som er lokale og hvilke som er ikke-lokale. Kommandoene

```nginx
git remote
```

```nginx
git remote -v
```

fra prosjektets hjemmekatalog sjekker dette. For ikke-lokale REPO gir førstnevnte `origin` som svar, den andre nærmere informasjon om navn mm. Lokale REPO gir ingen output.

Man kan også

For å se hvilke Git-prosjekter man har, både lokal og ikke-lokale, kan man utføre følgende (denne finner alle `.git`-kataloger)

```nginx
fd -u -t d '^\.git$' ~
```

Og når man er i gang, kan man godt lage en `fd`-kommando som ved opsjonen `-x` utfører `git remote` også, som denne:

fd -u -t d '^\.git$' ~ -x sh -c \
   'echo "Repo: $(dirname "$1")"; \
   git -C "$(dirname "$1")" remote; echo' sh {}

---

## 📕 Oppsummering

Langt fra ferdig. Må ha med HEAD og gren-peker, samt flere kommandoer

```yaml
add        : INDEKS  ←  TRE
commit     : REPO    ←  INDEKS
restore    : TRE     ←  INDEKS
unstage    : INDEKS  ←  REPO
reset      : TRE     ←  INDEKS ← REPO
```

Merk at disse Git-kommandoene ikke hopper over ledd i følgen:

```yaml
INDEKS  ↔  TRE  ↔  REPO
```

---

## 📕 Nettressurser

[Pro Git Book](https://git-scm.com/book/en/v2)

[Git in VSCode](https://code.visualstudio.com/docs/sourcecontrol/overview)

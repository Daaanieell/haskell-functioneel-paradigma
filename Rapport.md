# Rapport

Markdown naar HTML parser
- **Student:** Daniel Sung (2128145)
- **Datum:** 10 maart, 2026
- **Versie:** 1
- **Docent:** Michel Koolwaaij
- **Klas:** ITA-CNI-A-f 2025

## Inhoudopgave

- **[Inleiding](#inleiding)**
    - [Overview van opdracht](#overview-van-opdracht)
    - [Waarom Haskell?](#waarom-haskell)
- **[Onderzoek](#onderzoek)**
- **[Challenge](#challenge)**
    - [Opdrachtomschrijving](#opdrachtomschrijving)
    - [Uitdaging](#uitdaging)
- **[Implementatie](#implementatie)**
    - [MarkdownParser.hs](#markdownparserhs)
        - [checkForSyntax](#checkforsyntax)
        - [replaceHeadings](#replaceheadings)
        - [main](#main)
    - [MarkdownHelper.hs](#markdownhelperhs)
        - [isHorizontalLine](#ishorizontalline)
    - [InlineParser.hs](#inlineparserhs)
        - [replaceInlineSyntax](#replaceinlinesyntax)
- **[Reflectie](#reflectie)**
    - [Functionele paradigma](#functionele-paradigma)
- **[Conclusie](#conclusie)**
- **[Bronvermelding](#bronvermelding)**
    - [Markdown cheatsheet](#markdown-cheatsheet)
    - [Haskell basics](#haskell-basics)
    - [Pattern matching](#pattern-matching)
    - [Bestanden lezen](#bestanden-lezen)
    - [Commandline](#commandline)

## Inleiding

In dit rapport wordt een Markdown-naar-HTML parser beschreven, geïmplementeerd in Haskell. Het doel is om functionele concepten zoals pure functions, recursie en pattern matching toe te passen in een praktische context.

> WIP

Wat er in dit rapport wordt uitgelegd.
- Onderzoek: de concepten binnen Haskell en een koppeling aan mijn implementatie.
- Challenge: de opdrachtomschrijving en uitdagingen.
- Implementatie: welke bestanden er zijn en wat elke (belangrijke) functie doet.
- Reflectie: wat ik heb geleerd en welke problemen ik tegenkwam.
- Conclusie: korte samenvatting en mogelijke verbeterpunten.
- Bronvermelding: alle bronnen en links.


## Onderzoek
> TODO: scrhijf kort over de concepten, koppel het dan kort aan mijn code

In dit hoofdstuk worden de functionele concepten binnen Haskell kort uitgelegd en gekoppeld aan mijn implementatie. Zie hoofdstuk "[Implementatie](##Implementatie)" voor uitgebreidere uitleg.
### Zuiverheid (pure functions)

Binnen Haskell zijn functies puur: bij dezelfde input komt altijd dezelfde output terug en er zijn geen bijeffecten.  IO-acties zijn anders omdat ze met de buitenwereld werken. Bijvoorbeeld `getLine`.  Het resultaat hangt af van wat de gebruiker invoert, waardoor het niet puur is.

```haskell
getLine :: IO String  -- resultaat hangt af van wat de user input
```

In dit project is alleen de `main` niet puur, het maakt gebruik van `readFile`. Dit leest een bestand buiten de applicatie, en is dus niet puur. Met dezelfde aanroep kan je alsnog andere resultaten krijgen.

### First-class functions
> WIP

First-class functions betekent dat functies in behandeld worden als gewone waarden.  Je kunt ze opslaan in variabelen, doorgeven aan andere functies, en als resultaat teruggeven.

```haskell
map (add 1) [1,2,3] => [2,3,4]
--    ^ "add" wordt hier gebruikt als een first class function.
```

In dit project maakt de `main` gebruik van een first-class function. De `map` gebruikt `checkForSyntax` als first-class function.

### ### Higher-order functions

Higher-order functions zijn functies die een andere functie als parameter nemen of een functie teruggeven.

In dit project gebruikt `main` een higher-order functie. De functie `map` neemt een andere functie, `checkForSyntax`, als parameter en past deze toe op elk element van een lijst.

### Immutability

In Haskell zijn alle variabelen immutable. Dit betekent dat een waarde na initialisatie niet meer kan veranderen. In plaats van een variabele aan te passen, maak je een nieuwe variabele aan.

### Lazy evaluation

In Haskell worden expressies pas berekend wanneer hun waarde nodig is. Dit betekent dat berekeningen worden uitgesteld totdat ze gebruikt worden. Bijvoorbeeld `x = 1 + 2` wordt pas berekent wanneer `x` gebruikt wordt.

In dit project wordt er niet echt expliciet gebruik gemaakt van lazy evaluation, maar `isHorizontalLine` gebruikt `||`'s om te checken welke syntaxis gebruikt wordt voor een horizontal line, zodra 1 van de 3 een true returned, worden de anderen niet meer berekent. 
### Pattern matching
Pattern matching is een manier om een waarde te interpreteren binnen een functie, hiermee kan je op basis van een waarde, bijvoorbeeld een string, bepalen wat er mee gedaan wordt

```haskell
mijnFunctie :: String -> String
mijnFunctie ""       = "niks"
mijnFunctie [c]      = "1 karakter"
mijnFunctie (c:cs)   = "meer dan 1 karakter"
```

In dit project gebruik ik pattern matching voornamelijk als base-case binnen een recursieve functie.

## Challenge
> WIP

### Opdrachtomschrijving
Een .md naar .html parser in Haskell. Dit is een CLI-tool waarbij een gegeven bestand als args gegeven kan worden. 

Het moet de volgende syntaxis omzetten:
- Headings met grootte vanaf 1 t/m 6
- Horizontal lines
- Lists (Hier had ik wat problemen mee, wordt later uitgelegd)
- Inline syntax:
	- Bold
	- Italics

### Uitdaging
De grootste uitdaging voor mij ligt bij het 

Om markdown te parsen moet er gelet worden op:
- State tracking over meerdere regels
    - List items wrappen in `<ul>` of `<ol>` tags, je moet rekening houden met wat er in een list zit.
    - Het programma werkt line-by-line, maar moet onthouden of je in een list bent
- Overlappende syntax
    - Inline syntax (bold/italic) kan voorkomen in headings, lijstitems, paragrafen
    - Alles moet correct geparsed worden ongeacht context
- Prioriteit van regels
    - Bepalen welke syntax eerst gecheckt wordt (heading vs list vs paragraph)
    - Zeker stellen dat de juiste tag wordt toegepast
- Foutieve syntax
    - Gebroken inline syntax (`**bold*`)
    - Gemengde list syntax (`*` en `-` door elkaar)

En natuurlijk gebruik van Haskell/functionele programmeertalen, ik heb hier nog nooit eerder mee gewerkt, dus weet ik niet wat best practice is.

## Implementatie
> WIP, zet hier nog iets bij over problemen met lists en dergelijke?

In dit hoofdstuk wordt de implementatie uitgelegd per bestand. Elk sub-hoofdstuk heeft een samenvatting van wat het doet, gekoppeld aan functionele concepten. Ook is er een korte uitleg per functie. Niet elke functie wordt omschreven, alleen de interessante/relevante.

> Note: het parsen van lists en list-items had ik nog moeite mee, zie hoofdstuk [reflectie](##Reflectie) en [conclusie](##Conclusie)

In Haskell is alles immutable, dus wordt dit ook niet opgeschreven bij de 'kenmerken'.

Zie:
- [MarkdownParser.hs](markdown-to-html/MarkdownParser.hs): hoofdbestand, dit is wat je uitvoert. Het roept de helper en inline parser aan.
- [MarkdownHelper.hs](markdown-to-html/MarkdownHelper.hs): bevat voornamelijk check functies
- [InlineParser.hs](markdown-to-html/InlineParser.hs): is verantwoordelijk voor itereren door een line en Markdown syntax daarbinnen herkennen en parsen ervan.

Voor de implementatie heb ik de volgende regels vastgesteld:
- De parser zal niet foutieve syntax proberen om te zetten naar geldige syntax, bv: `##mijn heading` wordt niet gelezen als `## mijn heading`.
- De kleinste heading is h6

### MarkdownParser.hs
Dit is het hoofdbestand van de parser. Het roept de inline parser en helper bestand aan. Het parsed Markdown door het bestand op te splitsen in lijnen, vervolgens worden de lijnen geclassificeerd in 4 types:
1. Headings: `## Mijn heading`
2. Horizontal lines : `---` , `***` of `___`
3. Lists: een string die begint met `- mijn tekst` of `* mijn tekst`
4. Paragraphs: gewone tekst

Op basis van die 4 types worden functies aangeroepen die het parsen. Dit bestand gebruikt recursie voor het checken van headinggrootte en pattern matching binnen die recursie als base case.

Heeft de volgende functies:
- `checkForSyntax :: String -> String`
- `replaceHeadings :: String -> String`
- `main = do`

Overzicht:

| Concept                | `checkForSyntax` | `replaceHeadings` | `main` |
| ---------------------- | :--------------: | :---------------: | :----: |
| Pure functions         |        x         |         x         |        |
| First-class functions  |                  |                   |   x    |
| Higher-order functions |                  |                   |   x    |
| Immutability           |        x         |         x         |   x    |
| Recursie               |                  |         x         |        |
| Lazy evaluation        |                  |                   |        |
| Pattern matching       |        x         |         x         |        |

#### checkForSyntax
`checkForSyntax` checkt per lijn wat voor een type het is. Dit kan een heading, horizontal-line, list, of gewoon een paragraph zijn. Dit wordt gedaan met guards en helper functies om te bepalen wat een lijn bevat. Ook maakt het maakt gebruik van `replaceHeadings` om Markdown headings om te zetten naar HTML headings.

#### replaceHeadings
`replaceHeadings` is een recursieve functie, het looped vanaf `###### ` (h6) naar `# ` (h1) en checkt of het matched met de begin van een lijn. Het heeft lokale helper functies voor het weghalen van Markdown syntax en het parsen naar een HTML tag. Ook maakt het gebruikt patternmatching voor de base case; het heeft dan elke heading vanaf h6 gecheckt.
#### main
Gebruikt een `map` met `checkForSyntax` als parameter  om door de lijst van lines te itereren, dit is een higher order functie. De output van de map wordt naar een .html bestand geschreven. Ook gebruikt de main `checkForSyntax` als first class function in de `map`. 

### MarkdownHelper.hs
Dit bestand bevat voornamelijk checks, het heeft functies voor het checken voor inline syntax, of iets een list is, etc.  Wordt gebruikt in de andere twee bestanden. `isHorizontalLine` gebruikt recursie en pattern matching.

Heeft de volgende functies:
- `wrapWith :: String -> String -> String`
- `removeListSyntax :: String -> String`
- `checkForBold :: Char -> String -> Bool`
- `checkForItalics :: Char -> Bool`
- `isList :: String -> Bool`
- `isHorizontalLine :: String -> Bool`

Overzicht:

| Concept                | `wrapWith` | `removeListSyntax` | `checkForBold` | `checkForItalics` | `isList` | `isHorizontalLine` |
| ---------------------- | :--------: | :----------------: | :------------: | :---------------: | :------: | :----------------: |
| Pure functions         |     x      |         x          |       x        |         x         |    x     |         x          |
| First-class functions  |            |                    |                |                   |          |                    |
| Higher-order functions |            |                    |                |                   |          |                    |
| Immutability           |     x      |         x          |       x        |         x         |    x     |         x          |
| Recursie               |            |                    |                |                   |          |         x          |
| Lazy evaluation        |            |                    |                |                   |          |         x          |
| Pattern matching       |            |                    |       x        |                   |          |         x          |

#### isHorizontalLine
`isHorizontalLine` heeft een recursieve helper functie om bij te houden of iets een horizontal line is. Gebruikt pattern matching als base case om te herkennen of er meer dan 3 van dezelfde tekens zijn.  

### InlineParser.hs
Dit bestand is verantwoordelijk voor het parsen van inline Markdown syntax zoals bold en italics. Het exporteert alleen `replaceInlineSyntax`, die wordt aangeroepen vanuit `MarkdownParser.hs`.

Heeft de volgende functies:
- `replaceInlineSyntax :: String -> String`
#### replaceInlineSyntax
`replaceInlineSyntax` parsed een string letter voor letter via een recursieve helper functie `go`. Het gebruikt een accumulator om de output op te bouwen. Als een karakter bold of italics syntax is, wordt de juiste HTML tag toegevoegd via de lokale helper functie `openOrCloseTag`

Overzicht:

| Concept                | `replaceInlineSyntax` |
| ---------------------- | :-------------------: |
| pure functions         |           x           |
| First-class functions  |                       |
| Higher-order functions |                       |
| Immutability           |           x           |
| Recursie               |           x           |
| Lazy evaluation        |                       |
| Pattern matching       |           x           |

## Reflectie
> WIP

### Functionele paradigma

**Recursie en lokale helper functies**  
Tijdens het leren van Haskell was voor mij gebruik van recursie het meest interessant, er zijn geen echte for loops in Haskell vanwege immutability. Dit maakte het uitlezen en schrijven in een array moeilijker, je hebt geen `i` , je moet het doen met recursie.

Waar ik wel achter kwam was het gebruik van lokale helper functies (zie `isHorizontalLine` of `replaceInlineSyntax`) dit maakt recursie voor mij een stuk netter. De recursieve functie is gebundeld in een functie die je gemakkelijk kan aanroepen en hierdoor hoef je geen extra parameters te hebben.

**Moeilijkheden met immutability (en parsen van lists)**  
Waar ik moeite mee had was het missen van mutable variabelen. In andere talen zou ik een `Bool` opslaan om bij te houden of de parser zich binnen een `<ul>` of `<ol>` bevindt, en deze aanpassen per regel. In Haskell is dit niet mogelijk omdat variabelen immutable zijn. 

Omdat mijn logica gebaseerd is op het itereren door regels heen, was dit lastig op te lossen. Uiteindelijk heb ik besloten om alleen de `<li>` tag toe te voegen en de list items niet te wrappen in een `<ul>` of `<ol>` tag, omdat ik hier te veel tijd aan kwijt was.

Terugkijkend moest ik een stuk meer letten op hoe ik 'begin' met parsen, de `checkForSyntax` functie moest anders. In plaats van elke lijn itereren, moet het per letter parsen, dit zou de list-probleem voorkomen. Hierdoor zou ik gemakkelijker de state kunnen bijhouden, dus of iets in een list, bold of italics zit. Hier kwam ik te laat pas achter en was het niet meer waard om alles te refactoren.
## Conclusie
> WIP

Parsen van lists is veel moeilijker dan verwacht, mijn aanpak van het markdown bestand omzetten naar lines en door elke line itereren werkte hier niet goed voor. 

Ik moet meer letten op de algehele structuur i.p.v. focussen op een klein onderdeel.




## Bronvermelding
### Markdown cheatsheet
  - _Basic Syntax | Markdown Guide_. (z.d.). https://www.markdownguide.org/basic-syntax/ Geraadpleegd op 2026-02-18
### Haskell basics
  - Correct syntax for if statements in Haskell. (z.d.). Stack Overflow. https://stackoverflow.com/questions/15317895/correct-syntax-for-if-statements-in-haskell Geraadpleegd op 2026-02-09
  - Guards vs if-then-else vs cases in Haskell. (z.d.). Stack Overflow. https://stackoverflow.com/questions/9345589/guards-vs-if-then-else-vs-cases-in-haskell Geraadpleegd op 2026-02-17
  - fromMaybe — Zvon Haskell references. (z.d.). http://www.zvon.org/other/haskell/Outputmaybe/fromMaybe_f.html Geraadpleegd op 2026-02-18
  - Claude AI share (f343677d). (z.d.). https://claude.ai/share/f343677d-c70a-48be-b793-b8b9e35446b4 Geraadpleegd op 2026-02-28
  - findIndex — Zvon Haskell references. (z.d.). http://www.zvon.org/other/haskell/Outputlist/findIndex_f.html Geraadpleegd op 2026-02-28
  - Let vs. Where — Haskell Wiki. (z.d.). https://wiki.haskell.org/Let_vs._Where#:~:text=It%20is%20important%20to%20know,line%20of%20a%20function%20definition. Geraadpleegd op 2026-02-28
  - Claude AI share (6f47665d). (z.d.). https://claude.ai/share/6f47665d-c78b-48e2-a3ed-37f980ee7f44 Geraadpleegd op 2026-02-28
  - Haskell. (z.d.). https://www.haskell.org/tutorial/functions.html Geraadpleegd op 2026-03-11
   - Wikipedia. (z.d.). First‑class function. https://en.wikipedia.org/wiki/First-class_function Geraadpleegd op 2026-03-11
   - Haskell Wiki. (z.d.). Higher‑order function. https://wiki.haskell.org/Higher_order_function Geraadpleegd op 2026-03-11
   - Haskell Wiki. (z.d.). Lazy evaluation. https://wiki.haskell.org/Lazy_evaluation Geraadpleegd op 2026-03-11
### Pattern matching
  - Pattern matching — FP Block Academy. (z.d.). https://academy.fpblock.com/blog/pattern-matching/ Geraadpleegd op 2026-02-09
  - Is there a better way to write a string contains X method? (z.d.). Stack Overflow. https://stackoverflow.com/questions/8748660/is-there-a-better-way-to-write-a-string-contains-x-method Geraadpleegd op 2026-02-11
  - Claude AI share (85daaf36). (z.d.). https://claude.ai/share/85daaf36-782d-4146-85e6-9dcf640c8a82 Geraadpleegd op 2026-02-28
  - Claude AI share (f78c3152). (z.d.). https://claude.ai/share/f78c3152-d80e-491b-b0ef-3d61b38d4c81 Geraadpleegd op 2026-02-28
### Bestanden lezen
  - Prelude — readFile (Hackage). (z.d.). https://hackage-content.haskell.org/package/base-4.22.0.0/docs/Prelude.html#v:readFile Geraadpleegd op 2026-02-09
  - Haskell — read lines of file (Stack Overflow). (z.d.). https://stackoverflow.com/questions/11022163/haskell-read-lines-of-file Geraadpleegd op 2026-02-17
### Commandline
  - Friedbrice — Gist (ef852a5c). (z.d.). https://gist.github.com/friedbrice/ef852a5c61e80686d659024aad3cbd70 Geraadpleegd op 2026-02-09

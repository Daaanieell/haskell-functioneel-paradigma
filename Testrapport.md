# Testrapport

Markdown naar HTML parser - testrapport
- **Student:** Daniel Sung (2128145)
- **Datum:** 13 maart, 2026
- **Versie:** 1
- **Docent:** Michel Koolwaaij
- **Klas:** ITA-CNI-A-f 2025

---

In dit rapport worden 4 Markdown bestanden gebruikt om de parser te testen, het bevat:
- Headings en horizontal lines
- Lists
- Mix van lists, inline syntax, headings en horizontal lines
- Incorrecte syntax
## Commandos voor testen
Voor alle tests hieronder gebruik je de hoofdparser `MarkdownParser.hs`. 

Voorbeeldcommando's (voer uit vanaf de projectroot of binnen de `markdown-to-html` map):
- Headings test
```
cabal run markdown-to-html -- ./test-md-files/test1-headings.md
```
- Lists test
```
cabal run markdown-to-html -- ./test-md-files/test2-lists.md
```
- Inline syntax test
```
cabal run markdown-to-html -- ./test-md-files/test3-mixed.md
```
- Foutieve syntax
```bash
cabal run markdown-to-html -- ./test-md-files/test4-bad-syntax.md
```

---
## Testen tijdens de ontwikkelproces

Tijdens het ontwikkelen voerde ik regelmatig de applicatie uit voordat ik committe en lette ik op of `output.html` overeen komt met wat ik verwacht. Dit deed ik per feature, dus bijvoorbeeld de implementatie bold syntax herkenning/parsing. Hierbij probeerde ik een bepaald resultaat te bereiken, bijvoorbeeld `<b> Mijn bold test </b>`. Ik gebruikte hierbij een [markdown-guide](https://www.markdownguide.org/basic-syntax/) die ik online vond.

## Testcases
Hier staan testbestanden om de output van de Markdown parser te testen. Let op: test 4 is bedoelt om output te zien van slechte syntax, de parser probeert foutieve syntax niet te corrigeren.

### 1) Headings & horizontal line
Zie [bestand](./markdown-to-html/test-md-files/test1-headings.md)
```
# Heading 1 <- dit hoort "<h1> Heading 1 </h1>" te zijn

Heading 1 body <- dit hoort een "<p> Heading 1 body </p>" te zijn, etc.

## Heading 2

Heading 2 body

### Heading 3

Heading 3 body

--- <- horizontal line

#### Heading 4

Heading 4 body

##### Heading 5

Heading 5 body

###### Heading 6

Heading 6 body

```

Dit controleert of de parser headings van niveau 1 t/m 6 herkent en omzet naar de juiste HTML tags (`<h1>` t/m `<h6>`). Elke heading wordt gevolgd door een tekstregel om te controleren of gewone tekst correct wordt omgezet naar een `<p>` tag.

Daarnaast wordt ook gecontroleerd of de parser headings alleen herkent wanneer de juiste Markdown syntax wordt gebruikt, namelijk een # gevolgd door een spatie en de tekst van de heading. 

**Conclusie:** werkt zoals verwacht, headings en tekst wordt correct geparsed.

| Markdown (input)                     | Verwachte HTML (output) | Werkt correct?                                         |
| ------------------------------------ | ----------------------- | ------------------------------------------------------ |
| `# Heading 1` t/m `###### Heading 6` | `<h1>` t/m `<h6>`       | Ja, elke heading wordt omgezet naar de juiste HTML tag |
| Tekst onder een heading              | `<p>Heading 1 body</p>` | Ja, tekst wordt correct als `<p>` weergegeven          |
| Horizontal line                      | `<hr>`                  | Ja, de `---` wordt correct geparsed                    |

### 2) Lists
Zie [bestand](./markdown-to-html/test-md-files/test2-lists.md)
```
List 1 <- normale tekst moet niet beinvloed worden door lists

- Item one <- elke list item moet zijn eigen <li> tag hebben
- Item two
- Item three

Another list <- normale tekst moet niet beinvloed worden door lists

- Item one
- Item two
- Item three
```

Dit testvoorbeeld controleert of de parser list-items correct herkent. Elke regel die begint met `-` hoort te worden omgezet naar een `<li>` tag. De tekst erboven ("List 1" en "Another list") hoort als gewone tekst te worden omgezet naar een `<p>` tag.

Ideaal gezien zouden de list-items ook gewrapped moeten worden in een `<ul>` tag. In deze implementatie worden alleen de `<li>` tags toegevoegd. Ik had nog wat moeite ervaren bij het toepassen van de `<ul>` en `<ol>` tags (zie reflectie hoofdstuk in [rapport](./Rapport.md)).

**Conclusie:** werkt zoals verwacht, hoewel lists geen `<ul>` of `<ol>` tags hebben.

| Markdown (input)                 | Verwachte HTML (output) | Werkt correct?                                                                                   |
| -------------------------------- | ----------------------- | ------------------------------------------------------------------------------------------------ |
| Tekst rondom lists: `List 1`     | `<p>List 1</p>`         | Ja, gewone tekst wordt correct als paragraph weergegeven                                         |
| List items: `- Item one`         | `<li>Item one</li>`     | Ja, list item wordt correct herkend                                                              |
| `Another list`                   | `<p>Another list</p>`   | Ja, gewone tekst wordt correct als paragraph weergegeven                                         |
| Meerdere list items onder elkaar | `<ul> ... </ul>`        | Nee, `<ul>` wrapper is niet geïmplementeerd (zie reflectie hoofdstuk in [rapport](./Rapport.md)) |
### 3) Een mix
Zie [bestand](./markdown-to-html/test-md-files/test3-mixed.md)
```
# My Document 

This is a paragraph with **bold** and _italic_ text.

---

- First list item
- Second list item

Another paragraph here.

## Section Two

More content with **bold** text.

```

Dit testvoorbeeld controleert meerdere aspecten van de Markdown parser tegelijk. Het bevat headings van niveau 1 en 2, paragrafen met inline syntax zoals **bold** en _italic_, een horizontal line (`---`), en list-items die beginnen met `-`. 

De test laat ook zien dat de parser nog geen `<ul>` wrapper voor lists implementeert.

**Conclusie:** werkt zoals verwacht, hoewel lists geen `<ul>` of `<ol>` tags hebben.

| Markdown (input) | Verwachte HTML (output) | Werkt correct? |
|---|---|---|
| `# My Document` | `<h1>My Document</h1>` | Ja, heading wordt correct omgezet |
| `This is a paragraph with **bold** and _italic_ text.` | `<p>This is a paragraph with <b>bold</b> and <i>italic</i> text.</p>` | Ja, inline syntax wordt correct geparsed |
| `---` | `<hr>` | Ja, horizontal line wordt correct herkend |
| `- First list item` | `<li>First list item</li>` | Ja, list item wordt correct herkend |
| `- Second list item` | `<li>Second list item</li>` | Ja, list item wordt correct herkend |
| `Another paragraph here.` | `<p>Another paragraph here.</p>` | Ja, tekst wordt correct als paragraph weergegeven |
| `## Section Two` | `<h2>Section Two</h2>` | Ja, heading niveau 2 wordt correct toegepast |
| `More content with **bold** text.` | `<p>More content with <b>bold</b> text.</p>` | Ja, inline bold syntax wordt correct omgezet |
### 4) Bad syntax
Zie [bestand](./markdown-to-html/test-md-files/test4-bad-syntax.md)

```
# Valid Heading

This is text with mismatched bold: **bold text* that doesn't close properly.

This has italics: *italic text_ with mismatched delimiters.

---

* List item
- Mixed list markers
* Another item

This line has *** three asterisks *** which could be confusing.

## Another Heading

Text with __double underscores__ for bold.

---

This has a single * asterisk in the middle of text.

And this has _single underscore_ which should be italic.

# # Heading with space after hash

##No space after hashes

Text with **nested **bold** inside** bold.

- List item
This line continues without a list marker

* Another list
```


Dit test hoe de parser slechte syntax parsed, het bevat headings van verschillende niveaus, paragrafen met inline bold en italic syntax, horizontal lines, en list-items met zowel `*` als `-` als markers. Ook zijn er voorbeelden van mismatched of niet afgesloten bold- en italic-tags, nested bold, en headings die geen correcte spacing na de hashes hebben. 

**Conclusie:** *"werkt"* zoals verwacht, er was niet gekeken naar foutieve syntax.

> Note: de parser is **niet** gemaakt om slechte syntax om te zetten, de tabel hieronder is een overview van wat 'fout' gaat.

| Markdown (input)                                           | Verwachte HTML (output)                                                | Werkt correct?                                         |
| ---------------------------------------------------------- | ---------------------------------------------------------------------- | ------------------------------------------------------ |
| `# Valid Heading`                                          | `<h1>Valid Heading</h1>`                                               | Ja                                                     |
| `This is text with mismatched bold: **bold text*`          | `<p>This is text with mismatched bold: <b>bold text</b></p>`           | Nee, bold tag sluit niet correct                       |
| `This has italics: *italic text_`                          | `<p>This has italics: <i>italic text</i></p>`                          | Nee, italic tag sluit niet correct                     |
| `---`                                                      | `<hr>`                                                                 | Ja                                                     |
| `* List item` / `- Mixed list markers` / `* Another item`  | `<li>...</li>`                                                         | Ja, list items herkend, `<ul>` ontbreekt               |
| `This line has *** three asterisks ***`                    | `<p>This line has <b> three asterisks </b></p>`                        | Nee, extra asterisken soms verkeerd verwerkt           |
| `## Another Heading`                                       | `<h2>Another Heading</h2>`                                             | Ja                                                     |
| `Text with __double underscores__ for bold.`               | `<p>Text with <b>double underscores</b> for bold.</p>`                 | Ja                                                     |
| `This has a single * asterisk in the middle of text.`      | `<p>This has a single <i> asterisk in the middle of text.</p>`         | Nee, enkelvoudige * wordt als italic herkend           |
| `And this has _single underscore_ which should be italic.` | `<p>And this has <i>single underscore</i> which should be italic.</p>` | Ja                                                     |
| `# # Heading with space after hash`                        | `<h1># Heading with space after hash</h1>`                             | Ja                                                     |
| `##No space after hashes`                                  | `##No space after hashes`                                              | Nee, heading wordt niet herkend zonder spatie          |
| `Text with **nested **bold** inside** bold.`               | `<p>Text with <b>nested </b>bold<b> inside</b> bold.</p>`              | Nee                                                    |
| `This line continues without a list marker`                | `<p>This line continues without a list marker</p>`                     | Ja                                                     |
| `* Another list`                                           | `<li>Another list</li>`                                                | Nee, wordt als zowel als list en italics gedetecteert. |

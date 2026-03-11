
# Testrapport
> WIP

## Commandos voor testen
Voor alle tests hieronder gebruik je de hoofdparser `MarkdownParser.hs`. Voorbeeldcommando's (voer uit vanaf de projectroot):

- Headings test
```
runghc markdown-to-html/MarkdownParser.hs markdown-to-html/test-md-files/test1-headings.md > markdown-to-html/test-md-files/test1-headings.html
```

- Lists test
```
runghc markdown-to-html/MarkdownParser.hs markdown-to-html/test-md-files/test2-lists.md > markdown-to-html/test-md-files/test2-lists.html
```

- Inline syntax test
```
runghc markdown-to-html/MarkdownParser.hs markdown-to-html/test-md-files/test3-mixed.md > markdown-to-html/test-md-files/test3-mixed.html
```

Plaats de `.md` testbestanden in `markdown-to-html/test-md-files/` (of geef het pad naar je eigen testbestand).

---

## Testcases

### 1) Headings & horizontal line
```
# Heading 1

Heading 1 body

## Heading 2

Heading 2 body

### Heading 3

Heading 3 body

#### Heading 4

Heading 4 body

##### Heading 5

Heading 5 body

###### Heading 6

Heading 6 body

```

- Test: omzetten van headings (h1..h6) naar de correcte `<hN>` tags; controleren van een horizontale lijn (`---`) en normale paragrafen.

> WIP, licht toe wat de uitkomst is, en wat verwacht wordt

**Uitkomst:**
- 

### 2) Lists
```
List with '-'

- Item one
- Item two
- Item three

Second list with '*'

* Another item
* Second item

```

- Test: listitems die beginnen met `-` of `*`, behoud van inline syntax binnen lijstitems, en behandeling van paragrafen na lijsten.

### 3) Inline syntax (bold / italics / overlap)
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

- Test: parsing van inline-syntax (bold `**` en italics `*`)

### 4) Bad syntax

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

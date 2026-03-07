# .md to HTML

[Opdracht](https://aim-cni.github.io/app/docs/Paradigma%20challenge/opdracht_functioneel_programmeren#markdown-to-html-converter)

Links:
- [Rapport](./Reflectieverslag.md)
- [Testrapport](./Testrapport.md)

## Quickstart

Voor het uitvoeren van de MarkdownParser.hs kan je volgende doen
1. Open de `.../haskell-functioneel-paradigma/markdown-to-html` in je terminal
2. Voer MarkdownParser.hs uit met runghc: `runghc MarkdownParser.hs *jouw md bestand pad*`
3. Open de `output.html` in de root directory voor de resultaten

### Tests/voorbeeld uitvoeren

1. Headings en subheadings
```bash
runghc MarkdownParser.hs test-md-files/test1-headings.md
```

2. Lists
```bash
runghc MarkdownParser.hs test-md-files/test2-lists.md
```


3. Gemengde md bestand
```bash
runghc MarkdownParser.hs test-md-files/test3-mixe.md
```
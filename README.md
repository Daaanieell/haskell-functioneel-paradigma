# .md to HTML in Haskell

[Opdracht](https://aim-cni.github.io/app/docs/Paradigma%20challenge/opdracht_functioneel_programmeren#markdown-to-html-converter) (Zie rapport voor meer details)

Links:
- [Rapport](./Rapport.md) 
- [Testrapport](./Testrapport.md)

## Quickstart
> Dit project gebruikt Cabal

Voor het uitvoeren van de MarkdownParser.hs met cabal moet je het volgende doen
1. Open de `.../haskell-functioneel-paradigma/markdown-to-html` in je terminal, dit is waar de Cabal project zich bevindt.
2. Bouw en voer de executable uit met cabal, bijvoorbeeld:
   `cabal run markdown-to-html -- ./test-md-files/test1-headings.md`
3. Open de `output.html` in de `markdown-to-html` directory voor de resultaten

### Tests/voorbeeld uitvoeren

1. Headings en subheadings
```bash
cabal run markdown-to-html -- ./test-md-files/test1-headings.md
```

2. Lists
```bash
cabal run markdown-to-html -- ./test-md-files/test2-lists.md
```

3. Gemengde md bestand
```bash
cabal run markdown-to-html -- ./test-md-files/test3-mixed.md
```

4. Foutieve md syntax
```bash
cabal run markdown-to-html -- ./test-md-files/test4-bad-syntax.md
```

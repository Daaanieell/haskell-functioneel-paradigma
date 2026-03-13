module InlineParser
  ( replaceInlineSyntax,
  )
where

import Data.List (isInfixOf, isPrefixOf, stripPrefix)
import Data.Maybe (fromMaybe)
import MarkdownHelper (checkForBold, checkForItalics)

-- parsed recursief een string letter per letter, gebruikt een accumulator om de output in op te slaan
-- als een letter (of letters) gematched wordt de bold of list syntax, dan wordt dat gedeelte gewrapped met die html syntax
replaceInlineSyntax :: String -> String
replaceInlineSyntax inputString = go False "" inputString -- helper functie voor recursie
  where
    -- bool: houdt bij of de functie bij een opening of closing tag ('<b>' of '</b>') zit
    -- string: de accumulator, houdt output van de functie bij
    -- string: de huidige lijn waar het door heen aan het parsen is
    -- string: returnen van de accumulator
    go :: Bool -> String -> String -> String
    go _ acc [] = acc
    go inSyntax acc (char : rest) -- dit looped totdat de string volledig gelezen is
      | checkForBold char rest -- checked voor bold syntax
        =
          go (not inSyntax) (acc ++ openOrCloseTag inSyntax "b") (tail rest) -- zet de bijbehorende tag in accumulator, recurse ook met 'tail' om de 2e '*' over te slaan
      | checkForItalics char =
          go (not inSyntax) (acc ++ openOrCloseTag inSyntax "i") rest -- zet de bijbehorende tag in accumulator
      | otherwise = go inSyntax (acc ++ [char]) rest

    -- returned een opening- of closing-tag op basis van een bool
    -- dit heb ik zo gedaan omdat het checken van inline syntax gebruik maakt van een accumulator
    -- ik denk dat dit ook wel mogelijk zal zijn met de 'wrapWith', maar hier heb ik niet verder naar gekeken
    openOrCloseTag :: Bool -> String -> String
    openOrCloseTag open tag
      | not open = "<" ++ tag ++ ">"
      | open = "</" ++ tag ++ ">"

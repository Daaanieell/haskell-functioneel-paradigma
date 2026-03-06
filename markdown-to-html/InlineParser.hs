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
    go :: Bool -> String -> String -> String
    go _ acc [] = acc
    go inSyntax acc (char : rest) -- dit looped totdat de string volledig gelezen is
      | checkForBold char rest = -- checked voor bold syntax
          go (not inSyntax) (acc ++ openOrCloseTag inSyntax "b") (tail rest) -- zet de bijbehorende tag eraan
      | checkForItalics char =
          go (not inSyntax) (acc ++ openOrCloseTag inSyntax "i") rest
      | otherwise = go inSyntax (acc ++ [char]) rest

    -- returned een opening- of closing-tag op basis van een bool
    -- dit heb ik zo gedaan omdat het checken van inline syntax gebruik maakt van een accumulator
    -- ik denk dat dit ook wel mogelijk zal zijn met de 'wrapWith', maar hier heb ik niet verder naar gekeken
    openOrCloseTag :: Bool -> String -> String
    openOrCloseTag open tag
      | not open = "<" ++ tag ++ ">"
      | open = "</" ++ tag ++ ">"

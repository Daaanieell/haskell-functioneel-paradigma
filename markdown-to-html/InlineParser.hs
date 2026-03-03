module InlineParser
  ( replaceInlineSyntax,
  )
where

import Data.List (isInfixOf, isPrefixOf, stripPrefix)
import Data.Maybe (fromMaybe)
import MarkdownHelper (checkForBold, checkForItalics)

replaceInlineSyntax :: String -> String
replaceInlineSyntax inputString = go False "" inputString
  where
    go :: Bool -> String -> String -> String
    go _ acc [] = acc
    go inSyntax acc (char : rest)
      | checkForBold char rest =
          go (not inSyntax) (acc ++ openOrCloseTag inSyntax "b") (tail rest)
      | checkForItalics char =
          go (not inSyntax) (acc ++ openOrCloseTag inSyntax "i") rest
      | otherwise = go inSyntax (acc ++ [char]) rest

    openOrCloseTag :: Bool -> String -> String
    openOrCloseTag open tag
      | not open = "<" ++ tag ++ ">"
      | open = "</" ++ tag ++ ">"

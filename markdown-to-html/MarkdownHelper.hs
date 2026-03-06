module MarkdownHelper
  ( wrapWith,
    removeMarkdownSyntax,
    checkForBold,
    checkForItalics,
    isList,
    isHorizontalLine,
  )
where

import Data.List (isPrefixOf, stripPrefix)
import Data.Maybe (fromMaybe)

-- wrapped een gegeven string met een gegeven tag

-- voorbeeld:
-- input: wrapWith "Haskell!" "h1"
-- output: <h1> Haskell! </h1>
wrapWith :: String -> String -> String
wrapWith toWrap tag = "<" ++ tag ++ "> " ++ toWrap ++ " </" ++ tag ++ ">"

-- 2do verander dit?
-- haalt een gegeven prefix string weg uit input
removeMarkdownSyntax :: String -> String -> String
removeMarkdownSyntax input toRemove
  | isPrefixOf toRemove input = fromMaybe input (stripPrefix toRemove input)
  | otherwise = input

-- gegeven een (x:xs) checkt het of de eerste twee karakters een * of _ is
-- wordt gebruikt in de inline parser om te checken of iets bold is
checkForBold :: Char -> String -> Bool
checkForBold _ [] = False
checkForBold char rest
  | char == '*' && head rest == '*' || char == '_' && head rest == '_' = True
  | otherwise = False

-- checkt of karakter een * of _ is
-- wordt gebruikt in de inline parser om te checken of iets italics is
checkForItalics :: Char -> Bool
checkForItalics char = (char == '*' || char == '_')

-- checkt of lijn begint met * of -
isList :: String -> Bool
isList line
  | isPrefixOf "* " line = True
  | isPrefixOf "- " line = True
  | otherwise = False

-- telt *, - of _ op, als er meer dan 3 van dezelfde tekens zijn, dan is het een <hr>
isHorizontalLine :: String -> Bool
isHorizontalLine line = go line '-' 0 || go line '*' 0 || go line '_' 0
  where
    go :: String -> Char -> Int -> Bool -- helper functie voor recursie
    go [] _ count = count >= 3
    go (currentLetter : rest) lineSyntax count
      | currentLetter == lineSyntax = go rest lineSyntax (count + 1) -- als letter matched met de syntax, dan tel 1 op en recurse
      | otherwise = False
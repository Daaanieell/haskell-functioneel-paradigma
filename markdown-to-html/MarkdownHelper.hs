module MarkdownHelper
  ( wrapWith,
    checkForBold,
    checkForItalics,
    isList,
    isHorizontalLine,
    removeListSyntax,
  )
where

import Data.List (isInfixOf, isPrefixOf, stripPrefix)
import Data.Maybe (fromMaybe)

-- wrapped een gegeven string met een gegeven tag
wrapWith :: String -> String -> String
wrapWith toWrap tag = "<" ++ tag ++ "> " ++ toWrap ++ " </" ++ tag ++ ">"

-- verwijderd md lists, checkt eerst met guards welke type list matched, verwijdert dan de juiste
removeListSyntax :: String -> String
removeListSyntax ('-' : ' ' : rest) = rest -- matched of de eerste twee karakters een md list zijn '* ' of '- ', verwijderd je passende syntax
removeListSyntax ('*' : ' ' : rest) = rest
removeListSyntax line = line

-- gegeven een string checkt het of de eerste twee karakters een * of _ is
-- wordt gebruikt in de inline parser om te checken of iets bold is
checkForBold :: Char -> String -> Bool
checkForBold _ [] = False
checkForBold char rest
  | char == '*' && head rest == '*' || char == '_' && head rest == '_' = True -- bij een (x:xs) checkt het of de eerste karakter 'x' en eerste van de 'xs' hetzelfde is
  | otherwise = False

-- checkt of karakter een * of _ is, wordt gebruikt om te checken voor italic tags
checkForItalics :: Char -> Bool
checkForItalics '*' = True
checkForItalics '_' = True

-- checkt of lijn begint met * of -
isList :: String -> Bool
isList ('*' : ' ' : _) = True -- matched voor list syntax '* ' of '- '
isList ('-' : ' ' : _) = True
isList _ = False

-- telt *, - of _ op, als er meer dan 3 van dezelfde tekens zijn, dan is het een <hr>
isHorizontalLine :: String -> Bool
isHorizontalLine line = go line '-' 0 || go line '*' 0 || go line '_' 0
  where
    go :: String -> Char -> Int -> Bool -- helper functie voor recursie
    go [] _ count = count >= 3
    go (currentLetter : rest) lineSyntax count
      | currentLetter == lineSyntax = go rest lineSyntax (count + 1) -- als letter matched met de syntax, dan tel 1 op en recurse
      | otherwise = False
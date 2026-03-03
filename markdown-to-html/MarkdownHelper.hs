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

wrapWith :: String -> String -> String
wrapWith toWrap tag = "<" ++ tag ++ "> " ++ toWrap ++ " </" ++ tag ++ ">"

removeMarkdownSyntax :: String -> String -> String
removeMarkdownSyntax input toRemove
  | isPrefixOf toRemove input = fromMaybe input (stripPrefix toRemove input)
  | otherwise = input

checkForBold :: Char -> String -> Bool
checkForBold _ [] = False
checkForBold char rest
  | char == '*' && head rest == '*' || char == '_' && head rest == '_' = True
  | otherwise = False

checkForItalics :: Char -> Bool
checkForItalics char = (char == '*' || char == '_')

isList :: String -> Bool
isList line
  | isPrefixOf "* " line = True
  | isPrefixOf "- " line = True
  | otherwise = False

isHorizontalLine :: String -> Bool
isHorizontalLine line = go line '-' 0 || go line '*' 0 || go line '_' 0
  where
    go :: String -> Char -> Int -> Bool
    go [] _ count = count >= 3
    go (currentLetter : rest) lineSyntax count
      | currentLetter == lineSyntax = go rest lineSyntax (count + 1)
      | otherwise = False
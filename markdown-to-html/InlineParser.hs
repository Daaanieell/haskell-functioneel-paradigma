module InlineParser
  ( replaceInlineSyntax,
    checkForBold,
    checkForItalics,
    openOrCloseTag,
  )
where

import Data.List (isInfixOf)

-- calls itself when it matches, so it adds the closing </b> ??
checkForInlineSyntax :: String -> String
checkForInlineSyntax line
  | isInfixOf "**" line = "<br>"

-- 2do should call the find to check for the ending
-- there is ending? -> wrap whatever is inside with <b> and use the remove to clean it
-- no ending? return string
-- drop to make the string start from that position

-- check if its start with "**", then add the syntax
-- call the find, if there is a second match, add the closing syntax
-- else return string

-- this breaks everything..
-- -- string gets jumbled?

-- v2
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

checkForBold :: Char -> String -> Bool
checkForBold _ [] = False
checkForBold char rest
  | char == '*' && head rest == '*' || char == '_' && head rest == '_' = True
  | otherwise = False

checkForItalics :: Char -> Bool
checkForItalics char = (char == '*' || char == '_')

openOrCloseTag :: Bool -> String -> String
openOrCloseTag open tag
  | not open = "<" ++ tag ++ ">"
  | open = "</" ++ tag ++ ">"

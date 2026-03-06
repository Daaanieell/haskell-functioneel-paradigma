module MarkdownParser where

import Control.Monad (forM, forM_)
import Data.List (isInfixOf, isPrefixOf, stripPrefix)
import Data.Maybe
import Data.String (String)
import FileReader (maybeArg)
import InlineParser (replaceInlineSyntax)
import MarkdownHelper (isHorizontalLine, isList, removeMarkdownSyntax, wrapWith)
import System.Environment

ouputPath = "output.html"

-- dit is verantwoordelijk voor regel bij regel parsen
-- heeft checks per .md syntax: headings, horizontal line, lists en algemene inline parsing (bold en italics)
checkForSyntax :: String -> String
checkForSyntax [] = ""
checkForSyntax line
  | isPrefixOf "#" line = replaceHeadings line
  | isHorizontalLine line = "<hr>"
  | isList line = wrapWith (replaceInlineSyntax line) "li" -- 2do remove md list
  | otherwise = wrapWith (replaceInlineSyntax line) "p"

-- zet md headings om naar html headings
-- checkt voor de kleinste heading (h6) en gaat omlaag totdat het alles headings erboven heeft gecheckt
replaceHeadings :: String -> String
replaceHeadings line = go line "###### "
  where
    go :: String -> String -> String
    go line [] = line
    go line toMatchFor
      | isPrefixOf toMatchFor line =
          let content = removeMarkdownSyntax line toMatchFor
           in wrapWith content (headingTag toMatchFor)
      | otherwise = go line (drop 1 toMatchFor)

    -- wordt gebruikt om de heading nummer om te zetten naar iets wat 'wrapWith' kan gebruiken (bv 'h1')
    headingTag :: String -> String
    headingTag hashtags = "h" ++ show (length (filter (== '#') hashtags))

-- 2do, kan dit beter?
main = do
  args <- getArgs
  case maybeArg args of
    Nothing -> putStrLn "invalid args"
    Just foundPath -> do
      file <- readFile foundPath
      let fileLines = lines file
      htmlContent <- forM fileLines (\line -> return (checkForSyntax line))
      writeFile ouputPath (unlines htmlContent)
      putStrLn "finished"
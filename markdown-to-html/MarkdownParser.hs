module MarkdownParser where

import Control.Monad (forM, forM_)
import Data.List (isInfixOf, isPrefixOf, stripPrefix)
import Data.Maybe
import Data.String (String)
import GHC.Internal.Text.Read (Lexeme (String))
import InlineParser (replaceInlineSyntax)
import MarkdownHelper (isHorizontalLine, isList, removeListSyntax, wrapWith)
import System.Environment

outputPath = "output.html"

-- dit is verantwoordelijk voor regel bij regel parsen
-- heeft checks per .md syntax: headings, horizontal line, lists en algemene inline parsing (bold en italics)
checkForSyntax :: String -> String
checkForSyntax [] = ""
checkForSyntax line
  | isPrefixOf "#" line = replaceHeadings line
  | isHorizontalLine line = "<hr>"
  | isList line = wrapWith (removeListSyntax $ replaceInlineSyntax line) "li" -- 2do remove md list
  | otherwise = wrapWith (replaceInlineSyntax line) "p"

-- zet md headings om naar html headings
-- checkt voor de kleinste heading (h6) en gaat 'omhoog' totdat het alles headings erboven heeft gecheckt
replaceHeadings :: String -> String
replaceHeadings line = go line "###### "
  where
    go :: String -> String -> String
    go line [] = line -- basecase voor als er geen headings matchen
    go line toMatchFor
      | isPrefixOf toMatchFor line =
          let content = removeHeading line toMatchFor
           in wrapWith content (headingTag toMatchFor) -- er is een match, wrap
      | otherwise = go line (drop 1 toMatchFor) -- als er geen matches zijn, dan zoekt het naar een grotere heading (minder #'s)

    -- wordt gebruikt om de md headings om te zetten naar iets wat 'wrapWith' kan gebruiken (bv 'h1')
    headingTag :: String -> String
    headingTag hashtags = "h" ++ show (length (filter (== '#') hashtags))

    -- haalt een gegeven heading string weg uit input
    removeHeading :: String -> String -> String
    removeHeading line toRemove
      | isPrefixOf toRemove line = fromMaybe line (stripPrefix toRemove line)
      | otherwise = line

main = do
  args <- getArgs
  if null args
    then putStrLn "invalid args"
    else do
      let foundPath = head args
      htmlLines <- map checkForSyntax . lines <$> readFile foundPath
      writeFile outputPath (unlines htmlLines)
      putStrLn ("finished, see output: " ++ outputPath)

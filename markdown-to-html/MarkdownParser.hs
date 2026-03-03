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

checkForSyntax :: String -> String
checkForSyntax [] = ""
checkForSyntax line
  | isPrefixOf "#" line = replaceHeadings line
  | isHorizontalLine line = "<hr>"
  | isList line = wrapWith (replaceInlineSyntax line) "li"
  | otherwise = wrapWith (replaceInlineSyntax line) "p"

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

    headingTag :: String -> String
    headingTag hashtags = "h" ++ show (length (filter (== '#') hashtags))

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
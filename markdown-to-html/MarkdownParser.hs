module MarkdownParser where

import Control.Monad (forM, forM_)
import Data.List (isInfixOf, isPrefixOf, stripPrefix)
import Data.Maybe
import Distribution.Simple.Build (repl)
import FileReader (maybeArg)
import GHC.Generics (Generic (to))
import InlineParser (replaceInlineSyntax)
import System.Environment

-- import MyHelpers (printHelloWorld)

-- checkForFilepath :: String -> Bool
-- checkForFilepath path =
-- checkForFilepath path = isValid (path)
-- isEmpty :: [a] -> Bool
-- isEmpty array = case array of
--   [] -> True
--   [array] -> False
--   _ -> False

ouputPath = "output.html"

-- main = do
--   [args] <- getArgs
--   if not (isEmpty args)
--     then do
--       file <- readFile args
--       putStrLn file
--     else do
--       putStrLn "invalid path"

-- needs to filter for md symbols

-- 2do
-- check for other md syntax (!!! https://www.markdownguide.org/basic-syntax/)
-- lists, bold, italics and tips, code blocks, links, images, blockquotes, tables, etc ...
-- add body/html tags to the output file
-- remove the md syntax from the output file
checkForSyntax :: String -> String
checkForSyntax line -- check each line for inline syntax, then add the heading tags?
  | isPrefixOf "# " line = "<h1>" ++ removeMarkdownSyntax line "# " ++ "</h1>"
  | isPrefixOf "## " line = "<h2>" ++ removeMarkdownSyntax line "## " ++ "</h2>"
  | isPrefixOf "### " line = "<h3>" ++ removeMarkdownSyntax line "### " ++ "</h3>"
  | isPrefixOf "---" line || isPrefixOf "___" line || isPrefixOf "***" line = "<hr>"
  | isPrefixOf "- " line = "<li>" ++ removeMarkdownSyntax line "- " ++ "</li>"
  | isPrefixOf "* " line = "<li>" ++ removeMarkdownSyntax line "* " ++ "</li>"
  | null line = line
  | otherwise = "<p>" ++ replaceInlineSyntax line ++ "</p>" -- this should call the inline parse function

-- this wont work :(
-- parseForInlineSyntaxRecursive :: String -> String
-- parseForInlineSyntaxRecursive [] = ""
-- parseForInlineSyntaxRecursive (letter : rest) = parseLetter letter ++ parseForInlineSyntaxRecursive rest

-- parseLetter :: Char -> String
-- parseLetter letter
--   | isInfixOf "*" letter =

removeMarkdownSyntax :: String -> String -> String
removeMarkdownSyntax input toRemove
  | isPrefixOf toRemove input = fromMaybe input (stripPrefix toRemove input)
  | otherwise = input

main = do
  args <- getArgs
  case maybeArg args of
    Nothing -> putStrLn "invalid args"
    Just foundPath -> do
      file <- readFile foundPath
      let fileLines = lines file
      putStrLn "----------input file----------"
      putStrLn file

      putStrLn "----------parsing----------"
      htmlContent <- forM fileLines (\line -> return (checkForSyntax line))
      writeFile ouputPath (unlines htmlContent)

      putStrLn "----------output file----------"
      output <- readFile ouputPath
      putStrLn output

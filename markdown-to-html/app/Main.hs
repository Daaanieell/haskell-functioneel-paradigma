module Main where

import MarkdownParser (checkForSyntax)
import System.Environment (getArgs)

outputPath = "output.html"

main :: IO ()
main = do
  args <- getArgs -- lezen van cli args
  if null args
    then putStrLn "invalid args"
    else do
      let foundPath = head args
      file <- readFile foundPath
      let htmlLines = map checkForSyntax (lines file) -- de map gaat door elke lijn in de gegeven bestand en voert die in checkForSyntax
      writeFile outputPath (unlines htmlLines)
      putStrLn ("finished, see output: " ++ outputPath)

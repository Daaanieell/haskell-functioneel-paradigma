import Control.Monad (forM, forM_)
import Data.List (isInfixOf)
import Data.Maybe
import GHC.Generics (Generic (to))
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

-- i use this to check if there is an argument (needed for giving filepath to read)
maybeArg :: [String] -> Maybe String
maybeArg array
  | null array = Nothing
  | otherwise = Just (head array)

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
-- need to check if headings are FIRST in the line (otherwise the whole line will get a heading tag even if its in the middle of the line)
-- check for other md syntax (bold and italic)
-- add body/html tags to the output file
checkForSyntax :: String -> String
checkForSyntax line -- check each line for inline syntax, then add the heading tags?
  | isInfixOf "# " line = "<h1>" ++ line ++ "</h1>"
  | isInfixOf "## " line = "<h2>" ++ line ++ "</h2>"
  | null line = line
  | otherwise = "<p>" ++ line ++ "</p>"

-- checkForInlineSyntax :: String -> String
-- checkForInlineSyntax line
--   |

-- TODO: get output from checkForString and add it into here
addToHTML :: String -> String
addToHTML input = "<p>" ++ input ++ "</p>"

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

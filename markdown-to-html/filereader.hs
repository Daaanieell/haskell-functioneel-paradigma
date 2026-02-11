import Data.List (isInfixOf)
import Data.Maybe
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
maybeArg array =
  case array of
    [] -> Nothing
    x : _ -> Just x

-- need to check if array is empty or not, otherwise i cant use the just/nothing

-- main = do
--   [args] <- getArgs
--   if not (isEmpty args)
--     then do
--       file <- readFile args
--       putStrLn file
--     else do
--       putStrLn "invalid path"

checkForString :: String -> String -> String
checkForString input toCheckFor =
  if (isInfixOf toCheckFor input)
    then "something matched " ++ toCheckFor
    else "found nothing"

-- TODO: get output from checkForString and add it into here
addToHTML :: String -> String
addToHTML input = "<p>" ++ input ++ "</p>"

-- 2do
-- read .md file
-- check for some basic syntax
-- if there is a match, return the html version
-- somehow add it to a big string?
-- write the big string to a file

main = do
  -- printHelloWorld
  args <- getArgs
  case maybeArg args of
    Nothing -> putStrLn "invalid args"
    Just foundPath -> do
      file <- readFile foundPath
      putStrLn file
      putStrLn "----------check for string----------"
      putStrLn (checkForString file "#")
      htmlContent <- return "hey"
      writeFile ouputPath htmlContent

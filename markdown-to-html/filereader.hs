import Data.Maybe
import System.Environment
import MyHelpers (printHelloWorld)

-- checkForFilepath :: String -> Bool
-- checkForFilepath path =
-- checkForFilepath path = isValid (path)
isEmpty :: [a] -> Bool
isEmpty array = case array of
  [] -> True
  [array] -> False
  _ -> False

maybeArg :: [String] -> Maybe String
maybeArg array =
  if null array
    then Nothing
    else Just (head array) -- don't know how to get rid of that partial function warning

-- need to check if array is empty or not, otherwise i cant use the just/nothing

-- main = do
--   [args] <- getArgs
--   if not (isEmpty args)
--     then do
--       file <- readFile args
--       putStrLn file
--     else do
--       putStrLn "invalid path"

main = do
  printHelloWorld
  args <- getArgs
  case maybeArg args of
    Nothing -> putStrLn "invalid args"
    Just foundPath -> do
      file <- readFile foundPath
      putStrLn file

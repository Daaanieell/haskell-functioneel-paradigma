import Data.Maybe
import System.Environment

-- https://gist.github.com/friedbrice/ef852a5c61e80686d659024aad3cbd70
-- https://hackage-content.haskell.org/package/base-4.22.0.0/docs/Prelude.html#v:readFile
-- https://stackoverflow.com/questions/15317895/correct-syntax-for-if-statements-in-haskell

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
    else Just (head array) -- this line fucks it, don't know how to get rid fo that partial function warning

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
  args <- getArgs
  case maybeArg args of
    Nothing -> putStrLn "you fucked it"
    Just foundPath -> do
      file <- readFile foundPath
      putStrLn file

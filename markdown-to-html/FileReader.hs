module FileReader
  ( maybeArg,
  )
where

import Distribution.Simple.Test (test)

maybeArg :: [String] -> Maybe String
maybeArg array
  | null array = Nothing
  | otherwise = Just (head array)
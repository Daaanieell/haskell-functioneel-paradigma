module FileReader
  ( maybeArg,
  )
where

maybeArg :: [String] -> Maybe String
maybeArg array
  | null array = Nothing
  | otherwise = Just (head array)

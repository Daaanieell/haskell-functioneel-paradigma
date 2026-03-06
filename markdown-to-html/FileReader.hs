module FileReader
  ( maybeArg,
  )
where

-- 2do verander dit...
maybeArg :: [String] -> Maybe String
maybeArg array
  | null array = Nothing
  | otherwise = Just (head array)

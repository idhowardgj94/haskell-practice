{-# LANGUAGE OverloadedStrings #-}
module Model where

import Data.Text
-- data
data Address = Address
    { addressCity :: !Text
    , addressStreet :: !Text
    } deriving (Show)

data Person = Person
    { personAddress :: !Address
    , personName :: !Text
    } deriving (Show)


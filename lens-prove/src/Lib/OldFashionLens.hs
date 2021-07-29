{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Rank2Types #-}

module Lib.OldFashionLens (
    oldStyleLenses
) where

import Model
import Lib
import Data.Text

-- old style lens
-- if we have a function that define lensGetter and lensModify's behavior,
-- then we can just use this function with lensGetter and lensSetter
data Lens s a = Lens
    { lensGetter :: s -> a
    , lensModify :: (a -> a) -> s -> s
    }
-- getter and modify must be think carefully.
composeLens :: Lens a b -> Lens b c -> Lens a c
composeLens (Lens getter1 modify1) (Lens getter2 modify2) = Lens
    { lensGetter = getter2 . getter1
    , lensModify = modify1 . modify2
    }

-- "function is value"
personAddressL :: Lens Person Address
personAddressL = Lens
    { lensGetter = personAddress
    , lensModify = modifyPersonAddress
    }

-- practice
personCityL :: Lens Person Text
personCityL = Lens
     { lensGetter = addressCity . personAddress
     , lensModify = modifyPersonCity
     }

-- setPersonCityOL :: Text -> Person -> Person 
oldStyleLenses :: IO ()
oldStyleLenses = do
    putStrLn ""
    putStrLn  "===== old style lenses start ======"
    let address = Address { addressStreet = "guangfu lu", addressCity = "hsinchu" }
    let person = Person { personName = "Howard", personAddress = address }
    print (lensGetter personAddressL person)
    print (lensGetter personCityL person)
    let personToTaipei = lensModify personCityL (const "Taipei") person
    putStrLn "moveToTaipei: " <> print personToTaipei

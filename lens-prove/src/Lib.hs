{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Rank2Types #-}

module Lib  where

import Model
import Data.Text

someFunc :: IO ()
someFunc = putStrLn "someFunc"

-- Modifier function
modifyAddressCity :: (Text -> Text) -> Address -> Address
modifyAddressCity f address = address
    { addressCity = f (addressCity address)
    }

-- multiple layer modifier
modifyPersonAddress :: (Address -> Address) -> Person -> Person
modifyPersonAddress f person =  person
    { personAddress = f (personAddress person)
    }

modifyPersonCity :: (Text -> Text) -> Person -> Person
modifyPersonCity = modifyPersonAddress . modifyAddressCity

setPersonCity :: Text -> Person -> Person
setPersonCity city = modifyPersonCity (const city)

useModifyFunc :: IO ()
useModifyFunc = do
    putStrLn ""
    putStrLn "===== useModifyFunc start ====="
    let address = Address { addressStreet = "guangfu lu", addressCity = "hsinchu" }
    let person = Person { personName = "Howard", personAddress = address }
    let newAddress = modifyAddressCity (const "Taipei") address
    let newPerson = modifyPersonAddress (const newAddress) person
    let personUseSetter = setPersonCity "ZhongLi" newPerson
    print newAddress
    print newPerson
    print personUseSetter


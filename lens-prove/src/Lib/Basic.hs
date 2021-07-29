{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Rank2Types #-}

module Lib.Basic
    ( basic
    ) where

import Model 

-- basic use: declare record and use getter
basic :: IO ()
basic = do
    putStrLn ""
    putStrLn "===== basic use start =====" 
    let address = Address { addressStreet = "guangfu lu", addressCity = "hsinchu" }
    let person = Person { personName = "Howard", personAddress = address }
    print person
    -- gettter
    putStrLn $ "person: " <> show (personName person) <> ", street: " <> show (addressCity . personAddress $  person)
    putStrLn "set PersonCity to Taipei"
    -- setter
    let person2 = person { personAddress = (personAddress person)
                            { addressCity = "Taipei"
                            }
                         }
    print person2



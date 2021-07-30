{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveFunctor #-}
{-# OPTIONS_GHC -Wno-deferred-type-errors #-}

-- Van Laarhoven lense
-- :)

module Lib.LensProgress where

import Model
import Lib.Basic
import Lib

-- goal
-- 1. combine getter and modifier into a single value, without using product type.

-- ==== type signature ===
-- type Lens s a = <......>
-- view :: Lens s a -> s -> a
-- over :: Lens s a -> (a -> a) -> s -> s 
-- =======================

-- wrap type is a common skill in fp 
newtype Identity a = Identity { runIdentity :: a } deriving (Functor, Show)

type LensModify s a = (a -> Identity a) -> s -> Identity s

over :: LensModify s a -> (a -> a) -> s -> s
over lens f s = runIdentity (lens (Identity . f) s)
--  Identity . f :: Identity $ (a -> a) => (a -> Identity a) 
--  lens (Identity . f) :: s -> Identity s
--  lens (Identity . f) s :: Identity s #
--  SL means setter lens.
--  GL means getter lens.
personAddressSL :: LensModify Person Address
personAddressSL f person = Identity $ person
    { personAddress = runIdentity $ f $ personAddress person
    }
-- or use Functor:
-- fmap :: (a -> b) -> f a -> f b
personAddressSL' :: LensModify Person Address
-- f :: a -> Identity a 
personAddressSL' f person =
    (\address -> person { personAddress = address })
    <$> f (personAddress person)

modifyPersonAddress' :: (Address -> Address) -> Person -> Person
modifyPersonAddress' = over personAddressSL'

-- view :: Lens s a -> s -> a
newtype Const a b = Const { getConst :: a } deriving (Functor, Show)
type LensGetter s a = s -> Const a s

view :: LensGetter s a -> s -> a
view lens s = getConst (lens s)

personAddressGL :: LensGetter Person Address
personAddressGL person = Const (personAddress person )

-- type LensModify s a = (a -> Identity a) -> (s -> Identity s)
-- type LensGetter s a = s -> Const a s
-- we need to align the interface, so we redefine a new LensGetter
type LensGetter' s a = (a -> Const a a) -> (s -> Const a s)
view' :: LensGetter' s a -> s -> a 
view' lens s = getConst (lens Const s)

personAddressGL' :: LensGetter' Person Address
personAddressGL' f person = Const $ getConst $ f (personAddress person)

personAddressGL'' :: LensGetter' Person Address
personAddressGL'' f person = 
     (\address -> person { personAddress=address }) 
    <$> f (personAddress person)

-- TODO: practice -> personAddressGL to functor implementation
useLensPregress :: IO ()
useLensPregress = do
    putStrLn "===== use Laarhoven Lenses ====="
    let address = Address { addressCity = "Taipei", addressStreet = "Luosifu Road" }
    let person = Person { personAddress = address, personName = "Dager" }
    let correctp = over personAddressSL' (\address -> address { addressCity = "Xinbei" } ) person
    putStrLn ""
    putStrLn "here is ModifyLens:"
    putStrLn "person: " <> print person
    putStrLn "modify city to Xinbei use Functor version of personAddressL'" <> print correctp

{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveFunctor #-}

-- let put it all together
module Lib.Lens where

import Model

testLens = putStrLn "testLens"

type Lens s a = forall f. Functor f => (a -> f a) -> (s -> f s)
-- wrapper type
newtype Identity a = Identity { runIdentity :: a } deriving (Functor, Show)
newtype Const a b = Const { getConst :: a } deriving (Functor, Show)

-- getter and setter
over :: Lens s a -> (a -> a) -> s -> s
over lens f s = runIdentity (lens (Identity . f) s)

view :: Lens s a -> s -> a
view lens s = getConst (lens Const s)

personAddressL :: Lens Person Address
personAddressL f person =
    (\address -> person { personAddress = address })
    <$> f (personAddress person)

getPersonAddress :: Person -> Address
getPersonAddress = view personAddressL

modifyPersonAddress :: (Address -> Address) -> Person -> Person
modifyPersonAddress = over personAddressL

setPersonAddress :: Address -> Person -> Person
setPersonAddress address = modifyPersonAddress (const address)

-- compose lens
lens :: (s -> a) -> (s -> a -> s) -> Lens s a
lens getter setter f s = setter s <$> f (getter s)




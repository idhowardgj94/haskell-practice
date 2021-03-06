{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Rank2Types #-}

module Main where

import Lib
import Lib.Basic
import Lib.OldFashionLens
import Data.Text
import Model
import Lib.Lens
import Lib.LensProgress
main :: IO ()
main = do
    putStrLn "basic use: "
    basic
    useModifyFunc
    oldStyleLenses
    useLensPregress
    testLens 

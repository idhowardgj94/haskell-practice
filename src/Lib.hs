module Lib( 
    switchPlayer,
    randomNumber
) where

import Control.Monad.State
import Model
import System.Random

someFunc :: IO ()
someFunc = putStrLn "someFunc"

switchPlayer :: Player -> StateT Player IO Player
switchPlayer Player1 = do
    put Player2
    return Player2
switchPlayer Player2 = do
    put Player1
    return Player1

randomNumber ::  Int -> [Int]
randomNumber s = randoms (mkStdGen s) 


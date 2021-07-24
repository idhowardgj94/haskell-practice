{-# LANGUAGE BlockArguments #-}
{-# OPTIONS_GHC -Wno-deferred-type-errors #-}
module Main where

import Lib
import Model
import Control.Monad.State
import System.Random
import Control.Monad


judge :: Int -> Int -> Bool
judge a i
    | a == i = True
    | otherwise = False

data GuessDirection = LessThen | GreaterThen


instance Show GuessDirection where
    show LessThen = "less then"
    show GreaterThen = "greater then"

guessDirection :: Int -> Int -> GuessDirection
guessDirection ans input
    | input - ans > 0 = GreaterThen
    | otherwise = LessThen

gameLoop :: Int -> StateT Player IO ()
gameLoop answer = do
    curPlayer <- get
    input <- liftIO (do
        putStrLn $ "Current player is" <> show curPlayer
        getLine )
    continue <- liftIO (do
        let val = read input :: Int
        if not (judge answer val)
            then putStrLn $ show (guessDirection answer val) <> " answer!"
            else putStrLn $ "Correct answer! " <> show curPlayer <> " win!"
        return (not (judge answer $ read input) ) )
    switchPlayer curPlayer
    when continue (gameLoop answer)


main :: IO ()
main = do
    seed <- randomIO
    let curPlayer = Player1
    let answer = mod (head $ randomNumber seed) 100
    evalStateT  (gameLoop answer)  curPlayer
    putStrLn $ "The answer is " <> show answer
    putStrLn "Game Set"

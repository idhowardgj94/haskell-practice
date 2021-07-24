module Model (
    Player(..),
) where

import Control.Monad.State

data Player = Player1 | Player2 deriving (Show, Eq)

switchPlayer :: Player -> State Player Player
switchPlayer Player1 = do
    put Player2
    return Player2
switchPlayer Player2 = do
    put Player1
    return Player1


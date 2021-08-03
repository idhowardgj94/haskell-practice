{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE  DeriveGeneric #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators #-}
module Servers where

import Data.Text
import Data.Time (UTCTime)
import Servant.API
import GHC.Generics
import Prelude ()
import Prelude.Compat
import Control.Monad.Except
import Control.Monad.Reader
import Data.Aeson
import Data.Aeson.Types
import Data.Attoparsec.ByteString
import Data.ByteString (ByteString)
import Data.List
import Data.Maybe
import Data.String.Conversions
import Data.Time.Calendar
import Network.HTTP.Media ((//), (/:))
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import Text.Blaze
import Text.Blaze.Html.Renderer.Utf8
import Servant.Types.SourceT (source)
import qualified Data.Aeson.Parser
import qualified Text.Blaze.Html

data LoginRequest = LoginRequest {
    user :: String,
    password :: String
} deriving (Eq, Show, Generic)
instance FromJSON LoginRequest
data User = User {
    name :: String,
    age :: Int,
    email :: String,
    registration_date :: String 
} deriving (Eq, Show, Generic)
instance ToJSON User

users1 :: User
users1 = User {
    name = "Howard",
    age = 30,
    email = "idhowardgj94@gmail.com",
    registration_date = "2020/01/01"
}

users2 = User {
    name = "Ricky",
    age = 25,
    email = "ricky@gmail.com",
    registration_date = "2021/01/01"
}

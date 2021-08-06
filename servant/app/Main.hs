{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators #-}
module Main where

import Lib
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
import GHC.Generics
import Network.HTTP.Media ((//), (/:))
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import System.Directory
import Text.Blaze
import Text.Blaze.Html.Renderer.Utf8
import Servant.Types.SourceT (source)
import qualified Data.Aeson.Parser
import qualified Text.Blaze.Html
import Data.Pool
import Database.MySQL.Simple
    ( defaultConnectInfo,
      ConnectInfo(connectHost, connectUser, connectDatabase),
      Connection )
import Database.MySQL.Simple.Param
import SQLDatabase ( initConnectionPool )

connInfo :: ConnectInfo
connInfo = defaultConnectInfo {
              connectHost = "127.0.0.1",
              connectUser = "test",
              connectDatabase = "test"
            }


runApp :: Pool Connection -> Application
runApp conn = serve serverApi $ server conn

main :: IO ()
main = do
    -- todo: read from config
    pool <- initConnectionPool connInfo
    run 8080 (runApp pool)

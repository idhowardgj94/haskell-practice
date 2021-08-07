{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
module SQLDatabase where

import Data.ByteString (ByteString)
import Control.Exception (bracket)
import GHC.Generics
import Control.Monad.IO.Class ( MonadIO(liftIO) )
import Data.Pool
import Database.MySQL.Simple
import Network.HTTP.Client (newManager, defaultManagerSettings)
import Network.Wai.Handler.Warp
import Servant
import Servant.API
import Servant.Client
import Servant.API.ContentTypes
import Control.Applicative
type Message = String
type API = "db" :> ReqBody '[PlainText] Message :> Post '[JSON] NoContent
    :<|> "db" :> Get '[PlainText] String
    :<|> Get '[PlainText] String

initConnectionPool :: ConnectInfo -> IO (Pool Connection)
initConnectionPool conninfo =
    createPool (connect conninfo) close 2 60 10

data User = User {
    name :: String
  , password :: String
  , login_hash :: String
  } deriving (Generic, Show)

api :: Proxy API
api = Proxy

runApp ::  Pool Connection -> Application
runApp conn = serve api $ server conn
-- fmap (foldl (\p c -> p <> ", " <> c) "") 
server :: Pool Connection -> Server API
server conns =  postMessage :<|> getMessages :<|> helloworld
    where postMessage :: Message -> Handler NoContent
          postMessage msg = do
                liftIO  . withResource conns $ \conn ->
                    execute conn "INSERT INTO messages VALUES(?)" (Only msg)
                return NoContent
          getMessages :: Handler String
          getMessages =  liftIO $
            withResource conns $ \conn -> do
              xs <- query_ conn "SELECT * FROM users WHERE name='howardgj94'"
              return $ foldl (\p (id, name, password , login_hash) -> p <> ", " <> show (id :: Int) <> ", " <> (name :: String) <> (password :: String) <> (login_hash :: String )) "" xs
          helloworld :: Handler String
          helloworld = return "hello, world"

initDB :: ConnectInfo -> IO ()
initDB conninfo = bracket (connect conninfo) close $ \conn -> do
  execute_ conn
    "CREATE TABLE IF NOT EXISTS messages (msg text not null)"
  return ()


testConnInfo :: ConnectInfo
testConnInfo = defaultConnectInfo {
              connectHost = "127.0.0.1",
              connectUser = "root",
              connectDatabase = "blog",
              connectPassword = "example"
            }

testDb :: IO ()
testDb = do
  pool <- initConnectionPool testConnInfo
  run 8881 (runApp pool)
  putStrLn "hello, db, test!"
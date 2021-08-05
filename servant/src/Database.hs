{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module Database where 

import Data.ByteString (ByteString)
import Control.Concurrent
import Control.Exception (bracket)
import Control.Monad.IO.Class
import Data.Pool
import Database.PostgreSQL.Simple
import Network.HTTP.Client (newManager, defaultManagerSettings)
import Network.Wai.Handler.Warp
import Servant
import Servant.Client


type DBConnectionString = ByteString

type Message = String
type API = ReqBody '[PlainText] Message :> Post '[JSON] NoContent
    :<|> Get '[JSON] [Message]

api :: Proxy API
api = Proxy

server :: Pool Connection -> Server API 
server conns =  postMessage :<|> getMessages
    where postMessage :: Message -> Handler NoContent 
          postMessage msg = do
                liftIO  . withResource conns $ \conn ->
                    execute conn "INSERT INTO messages VALUES(?)" (Only msg)
                return NoContent
          getMessages :: Handler [Message]
          getMessages = fmap (map fromOnly) . liftIO $
            withResource conns $ \conn ->
                query_ conn "SELECT msg FROM messages"
            
initDB :: DBConnectionString -> IO ()
initDB connstr = bracket (connectPostgreSQL connstr) close $ \conn -> do
  execute_ conn
    "CREATE TABLE IF NOT EXISTS messages (msg text not null)"
  return ()

runApp :: Pool Connection -> IO ()
runApp conns = run 8080 (serve api $ server conns)

initConnectionPool :: DBConnectionString -> IO (Pool Connection)
initConnectionPool connStr =
  createPool (connectPostgreSQL connStr)
             close
             2 -- stripes
             60 -- unused connections are kept open for a minute
             10 -- max. 10 connections open per stripe
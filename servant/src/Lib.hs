{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE DeriveGeneric   #-}
{-# LANGUAGE OverloadedStrings #-}
module Lib where

import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import Servers ( User, LoginRequest, users1, users2 )
import GHC.Generics
import Data.Pool
import Database.MySQL.Simple ( Connection )
type ServerApi = UserApi :<|> LoginApi
serverApi :: Proxy ServerApi
serverApi = Proxy
server :: Pool Connection -> Server ServerApi
server conn = userService conn :<|> loginService conn

type UserApi = "users" :> QueryParam "sortby" String :> Get '[JSON] (Maybe User)

type LoginApi = "login" :> ReqBody '[JSON] LoginRequest :> Post '[JSON] Value

userService :: Pool Connection -> Server UserApi
userService conn = users 
    where users :: Maybe String -> Handler (Maybe User)
          users (Just "howard") = return $ Just users1
          users (Just "ricky") = return $ Just users2
          users _ = return Nothing 

loginService :: Pool Connection -> Server LoginApi
loginService conn = login
    where login :: LoginRequest -> Handler Value
          login r = return (object 
                    [ "status" .=  ("success" :: String)
                    , "message" .= ("hello, world" :: String)
                    ])
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
import Servers
import GHC.Generics

type ServerApi = UserApi :<|> LoginApi
serverApi :: Proxy ServerApi
serverApi = Proxy
services :: Server ServerApi
services = userService :<|> loginService

type UserApi = "users" :> QueryParam "sortby" String :> Get '[JSON] (Maybe User)

type LoginApi = "login" :> ReqBody '[JSON] LoginRequest :> Post '[JSON] Value

-- userApi :: Proxy UserApi 
-- userApi = Proxy 

userService :: Server UserApi
userService = users 
    where users :: Maybe String -> Handler (Maybe User)
          users (Just "howard") = return $ Just users1
          users (Just "ricky") = return $ Just users2
          users _ = return Nothing 

-- login service below
-- loginApi :: Proxy LoginApi
-- loginApi = Proxy

loginService :: Server LoginApi
loginService = login
    where login :: LoginRequest -> Handler Value
          login r = return (object 
                    [ "status" .=  ("success" :: String)
                    , "message" .= ("hello, world" :: String)
                    ])
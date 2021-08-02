{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module Lib where

import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import Servers


type UserApi = "users" :> QueryParam "sortby" String :> Get '[JSON] (Maybe User)

type LoginApi = "login" :> ReqBody '[JSON] LoginRequest :> Post '[JSON] Value

loginApi :: Proxy LoginApi
loginApi = Proxy

userApp :: Application
userApp = serve userApi userService

userApi :: Proxy UserApi 
userApi = Proxy 

userService :: Server UserApi
userService = users 
    where users :: Maybe String -> Handler (Maybe User)
          users (Just "howard") = return $ Just users1
          users (Just "ricky") = return $ Just users2
          users _ = return Nothing 
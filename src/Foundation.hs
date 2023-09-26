{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
module Foundation where

import Yesod.Core
import Control.Concurrent
import Model.Cache

data App = App {getCache :: MVar NewsCache}

mkYesodData "App" $(parseRoutesFile "routes.yesodroutes")

instance Yesod App

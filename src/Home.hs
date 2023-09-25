{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Home where

import Foundation
import Data.Text.Lazy.Encoding as LE
import Text.Taggy
import Text.Taggy.Lens

import Yesod.Core


getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    setTitle "Minimal Multifile"

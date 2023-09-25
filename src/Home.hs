{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Home where

import Foundation

import Control.Lens hiding (children, element, (.=))
import Control.Monad
import qualified Data.Text.Lazy.Encoding as LE
import qualified Data.Text.Lazy as LT
import Data.Aeson (object, (.=))

import Network.Wreq
import Data.Text

import Text.Taggy.Renderer
import Text.Taggy
import Text.Taggy.Lens

import Yesod.Core

allNews :: IO [Text]
allNews = do
    let url = "https://gnews.io/api/v4/search?q=example&lang=en&country=us&max=10&apikey=fb456ddbe7f03b12d69ee93d7f2d4191"
    respBody <- get url
    return $ respBody ^.. responseBody . to LE.decodeUtf8 . to LT.toStrict


getHomeR :: Handler Value
getHomeR = do
    news <- liftIO allNews
    forM_ news $ \item -> liftIO $ putStrLn (unpack item)

    returnJson $ object ["data" .= news]






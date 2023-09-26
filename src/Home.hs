{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Home where

import Foundation

import Control.Lens hiding (children, element, (.=))
import Control.Monad
import qualified Data.Text.Lazy.Encoding as LE
import qualified Data.Text.Lazy as LT
import Data.Aeson (object, (.=), eitherDecode')

import Network.Wreq
import Data.Text hiding (take, filter)
import Model.News
import Network.HTTP.Types.Status

import Text.Taggy.Renderer
import Text.Taggy

import Yesod.Core

allNews :: IO (Either String News)
allNews = do
    let url = "https://gnews.io/api/v4/search?q=example&lang=en&country=us&max=10&apikey=fb456ddbe7f03b12d69ee93d7f2d4191"
    respBody <- get url
    return $ eitherDecode' $ respBody ^. responseBody

getNewsByStringR :: String -> (Article -> String) -> Handler Value
getNewsByStringR keyword projection = do
    news <- liftIO allNews
    case news of
         Left err -> sendResponseStatus internalServerError500 (pack err)
         Right items ->
             let filteredArticles = filter (\article -> isInfixOf (pack keyword) (pack (projection article))) (articles items)
             in returnJson $ object ["data" .= filteredArticles]

getContentSearchR :: String -> Handler Value
getContentSearchR keyword = getNewsByStringR keyword content

getTitleSearchR :: String -> Handler Value
getTitleSearchR keyword = getNewsByStringR keyword title

getNnewsR :: Int -> Handler Value
getNnewsR n = do
    news <- liftIO allNews
    case news of
         Left err -> sendResponseStatus internalServerError500 (pack err)
         Right items -> returnJson $ object ["data" .= (take n (articles items))]


getAllNewsR :: Handler Value
getAllNewsR = do
    news <- liftIO allNews
    case news of
         Left err -> sendResponseStatus internalServerError500 (pack err)
         Right items -> do
             forM_ (articles items) $ \item -> liftIO $ putStrLn (show item)
             returnJson $ object ["data" .= items]


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

import qualified Data.Cache.LRU as LR
import Control.Concurrent

import Yesod.Core

type NewsCache = LR.LRU String News

allNews :: IO (Either String News)
allNews = do
    let url = "https://gnews.io/api/v4/search?q=example&lang=en&country=us&max=10&apikey=fb456ddbe7f03b12d69ee93d7f2d4191"
    respBody <- get url
    return $ eitherDecode' $ respBody ^. responseBody

-- Use cache to efficentely store, in memory, the news
cachedNews :: NewsCache -> IO (Either String News, NewsCache)
cachedNews cache = do
    let (updatedCache, maybeNews) = LR.lookup "cachedNews" cache
    case maybeNews of
        Just news -> return (Right news, updatedCache)
        Nothing -> do
            result <- allNews
            case result of
                Left err -> return (Left err, updatedCache)
                Right news ->
                    let newCache = LR.insert "cachedNews" news updatedCache
                    in return (Right news, newCache)

-- Continuation: DRY
cachedFunction :: (Either String News -> Handler a) -> Handler a
cachedFunction route = do
    app <- getYesod
    let mvarCache = getCache app
    cache <- liftIO $ takeMVar mvarCache
    (news, updatedCache) <- liftIO $ cachedNews cache
    liftIO $ putMVar mvarCache updatedCache
    route news

getNewsByStringR :: String -> (Article -> String) -> Handler Value
getNewsByStringR keyword projection = cachedFunction $ \news -> do
    case news of
         Left err -> sendResponseStatus internalServerError500 (pack err)
         Right items ->
             let filteredArticles = filter (\article -> isInfixOf (pack keyword) (pack (projection article))) (articles items)
             in returnJson $ object ["data" .= filteredArticles]

getContentSearchR :: String -> Handler Value
getContentSearchR keyword = getNewsByStringR keyword content

getTitleSearchR :: String -> Handler Value
getTitleSearchR keyword = getNewsByStringR keyword title

getLatestR :: Int -> Handler Value
getLatestR n = cachedFunction $ \news -> do
    case news of
         Left err -> sendResponseStatus internalServerError500 (pack err)
         Right items -> returnJson $ object ["data" .= (take n (articles items))]


getAllNewsR :: Handler Value
getAllNewsR = cachedFunction $ \news -> do
    case news of
         Left err -> sendResponseStatus internalServerError500 (pack err)
         Right items -> do
             forM_ (articles items) $ \item -> liftIO $ putStrLn (show item)
             returnJson $ object ["data" .= items]


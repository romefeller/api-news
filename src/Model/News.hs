{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE DeriveGeneric #-}

module Model.News where

import Data.Aeson (FromJSON, ToJSON, withObject)
import GHC.Generics (Generic)

import Yesod.Core

data Article = Article
    { title       :: String
    , description :: String
    , content     :: String
    , url         :: String
    , image       :: String
    , publishedAt :: String
    , source      :: Source
    } deriving (Show, Generic)

data Source = Source
    { name       :: String
    , urlSource  :: String
    } deriving (Show, Generic)

data News = News
    { totalArticles :: Int
    , articles      :: [Article]
    } deriving (Show, Generic)

instance FromJSON Article
instance ToJSON Article

instance FromJSON Source where
    parseJSON = withObject "Source" $ \v -> Source
        <$> v .: "name"
        <*> v .: "url"

instance ToJSON Source
instance FromJSON News
instance ToJSON News

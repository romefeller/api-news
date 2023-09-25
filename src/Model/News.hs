{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE DeriveGeneric #-}

module Model.News where

import Data.Aeson (FromJSON, ToJSON)
import Foundation
import GHC.Generics (Generic)

import Yesod.Core

data Article = Article
    { title       :: String
    , description :: String
    , content     :: String
    , urlArticle  :: String
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
instance FromJSON Source
instance ToJSON Source
instance FromJSON News
instance ToJSON News

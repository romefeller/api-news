module Model.Cache where

import qualified Data.Cache.LRU as LR
import Model.News

type NewsCache = LR.LRU String News

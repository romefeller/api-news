import Application () -- for YesodDispatch instance
import Foundation
import Yesod.Core
import Home
import Control.Concurrent.MVar
import qualified Data.Cache.LRU as LR

-- Caching
initCache :: IO NewsCache
initCache = return $ LR.newLRU (Just 10)

main :: IO ()
main = do
    cacheVar <- initCache >>= newMVar
    warp 3000 (App cacheVar)

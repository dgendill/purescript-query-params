module QueryParams (
    getParam,
    hasParam,
    runInEnv,
    runInBrowser,
    QueryParamAction,
    QueryParamActionF,
    BROWSERURL
  ) where

import Control.Monad.Eff (Eff)
import Control.Monad.Free (Free, liftF, runFree)
import Data.Function.Uncurried (Fn0, Fn2, Fn4, runFn0, runFn2, runFn4)
import Data.Maybe (Maybe(..))
import Prelude (class Functor, const, pure)

type URL = String

-- | runInBrowser requires the BROWSERURL effect
foreign import data BROWSERURL :: !

foreign import data QueryParams :: *

foreign import hasParam_ :: Fn2 String QueryParams Boolean
foreign import getParam_ :: Fn4 String QueryParams (String -> Maybe String) (String -> Maybe String) (Maybe String)
foreign import runInWindow_ :: Fn0 QueryParams
foreign import runInEnv_ :: URL -> QueryParams

-- A functor defining actions you can perform on
-- a url
data QueryParamActionF f
  = GetParam String (String -> QueryParams -> f)
  | HasParam String (String -> QueryParams -> f)

derive instance actionsFFunctor :: Functor QueryParamActionF

-- A type alias for a QueryParamAction program
type QueryParamAction a = Free QueryParamActionF a

-- | Run a a series of QueryParamActions on a particular url
-- | and return a value, e.g.
-- |
-- | ```purescript
-- | runInEnv "http://test.com?userid=john" $ do
-- |   userid <- getParam "userid"
-- |   case userid of
-- |     Just u -> pure "User is " <> u
-- |     Nothing -> pure "No user present"
-- | ```
runInEnv :: forall a. URL -> QueryParamAction a -> a
runInEnv url = runFree (actionsN url runInEnv_)

-- | Run a a series of QueryParamActions on the browser's
-- | current URL, and return a value e.g.
-- |
-- | ```purescript
-- | info <- (runInBrowser $ do
-- |   muserid <- getParam "userid"
-- |   mtimestamp <- getParam "timestamp"
-- |   pure $ ((\userid timestamp ->
-- |     "User " <> userid <> " was here at " <> timestamp
-- |   ) <$> muserid <*> mtimestamp)
-- | ```
runInBrowser :: forall e a. QueryParamAction a -> Eff ( browserurl :: BROWSERURL | e ) a
runInBrowser q = pure (runFree (actionsN "" (\url -> runFn0 runInWindow_)) q)

actionsN :: forall a. URL -> (URL -> QueryParams) -> QueryParamActionF a -> a
actionsN url qp a =
  case a of
    (GetParam param fn) ->
      (fn param params)
    (HasParam param fn) ->
      (fn param params)
  where
    params = qp url

-- | Get a query parameter value from a url
getParam :: String -> QueryParamAction (Maybe String)
getParam param = liftF (GetParam param (\param' params -> runFn4 getParam_ param' params Just (const Nothing)))

-- | Check if a url has a query parameter in it, e.g.
-- |
-- | ```purescript
-- | runInBrowser $ do
-- |   hasToken <- hasParam "token"
-- |   if hasToken == true
-- |     then pure "Has token"
-- |     else pure "Does not have token"
-- | ```
hasParam :: String -> QueryParamAction Boolean
hasParam param = liftF (HasParam param (\param' params -> runFn2 hasParam_ param' params))

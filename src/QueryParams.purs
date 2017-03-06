module QueryParams (
    getParam,
    hasParam,
    runInEnv,
    QueryParamAction,
    QueryParamActionF
  ) where

import Control.Monad.Free (Free, liftF, runFree)
import Data.Function.Uncurried (Fn2, Fn4, runFn2, runFn4)
import Data.Maybe (Maybe(..))
import Prelude (class Functor, const)

type URL = String

foreign import data QueryParams :: *

foreign import hasParam_ :: Fn2 String QueryParams Boolean
foreign import getParam_ :: Fn4 String QueryParams (String -> Maybe String) (String -> Maybe String) (Maybe String)
foreign import runInWindow_ :: QueryParams
foreign import runInEnv_ :: URL -> QueryParams

-- | A functor defining actions you can perform on
-- | a url
data QueryParamActionF f
  = GetParam String (String -> QueryParams -> f)
  | HasParam String (String -> QueryParams -> f)

derive instance actionsFFunctor :: Functor QueryParamActionF
type QueryParamAction a = Free QueryParamActionF a

-- | Run a QueryParamAction program on a particular url
-- | and return the result
runInEnv :: forall a. URL -> QueryParamAction a -> a
runInEnv url = runFree (actionsN url runInEnv_)

runInBrowser :: forall a. QueryParamAction a -> a
runInBrowser = runFree (actionsN "" (\_ -> runInWindow_))

actionsN :: forall a. URL -> (_ -> QueryParams) -> QueryParamActionF a -> a
actionsN url qp a =
  case a of
    (GetParam param fn) ->
      (fn param params)
    (HasParam param fn) ->
      (fn param params)
  where
    params = qp url--runInEnv_ url

-- | Get a query parameter value from a url
getParam :: String -> QueryParamAction (Maybe String)
getParam param = liftF (GetParam param (\param' params -> runFn4 getParam_ param' params Just (const Nothing)))

-- | Check if a url has a particular query parameter
hasParam :: String -> QueryParamAction Boolean
hasParam param = liftF (HasParam param (\param' params -> runFn2 hasParam_ param' params))

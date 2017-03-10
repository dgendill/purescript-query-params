module QueryParams (
    getParam,
    hasParam,
    runInEnv,
    runInBrowser,
    QueryParamAction,
    QueryParamActionF
  ) where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Free (Free, foldFree, liftF)
import Control.Monad.Reader (ask, runReader)
import Data.Function.Uncurried (Fn2, Fn4, runFn2, runFn4)
import Data.Maybe (Maybe(..))
import DOM (DOM)
import DOM.HTML (window) as DOM
import DOM.HTML.Location (search) as DOM
import DOM.HTML.Window (location) as DOM

type URL = String

foreign import data QueryParams :: *

foreign import hasParam_ :: Fn2 String QueryParams Boolean
foreign import getParam_ :: Fn4 String QueryParams (String -> Maybe String) (String -> Maybe String) (Maybe String)
foreign import runInEnv_ :: URL -> QueryParams

runInWindow :: forall eff. Eff (dom :: DOM | eff) QueryParams
runInWindow = runInEnv_ <$> (DOM.search =<< DOM.location =<< DOM.window)

-- A functor defining actions you can perform on
-- a url
data QueryParamActionF f
  = GetParam String (String -> QueryParams -> f)
  | HasParam String (String -> QueryParams -> f)

derive instance actionsFFunctor :: Functor QueryParamActionF

-- A type alias for a QueryParamAction program
type QueryParamAction a = Free QueryParamActionF a

-- | Run a QueryParamAction program on a particular url
-- | and return the result
runInEnv :: forall a. URL -> QueryParamAction a -> a
runInEnv url act = runReader (foldFree (actionsN ask) act) (runInEnv_ url)

-- | Run a QueryParamAction program in the browser
-- | and use the browser's current url
runInBrowser :: forall a eff. QueryParamAction a -> Eff (dom :: DOM | eff) a
runInBrowser = foldFree (actionsN runInWindow)

actionsN :: forall f. Functor f => f QueryParams -> QueryParamActionF ~> f
actionsN params = case _ of
  GetParam param fn -> fn param <$> params
  HasParam param fn -> fn param <$> params

-- | Get a query parameter value from a url
getParam :: String -> QueryParamAction (Maybe String)
getParam param = liftF (GetParam param (\param' params -> runFn4 getParam_ param' params Just (const Nothing)))

-- | Check if a url has a particular query parameter
hasParam :: String -> QueryParamAction Boolean
hasParam param = liftF (HasParam param (\param' params -> runFn2 hasParam_ param' params))

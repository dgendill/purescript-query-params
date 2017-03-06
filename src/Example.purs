module Example where

import Prelude (Unit, bind, (<>), show, ($))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import QueryParams (getParam, runInBrowser, hasParam)

main :: Eff (console :: CONSOLE) Unit
main = do
  log "test"
  
  let
    value = runInBrowser do
      getParam "test"
  let
    has = runInBrowser do
      hasParam "test"

  log $ "Query Param ?test is: " <> (show value)
  case has of
    true -> log $ "URL has ?test in it"
    false -> log $ "URL does not have ?test in it"

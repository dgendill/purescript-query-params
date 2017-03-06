module Example where

import Control.Monad.Eff.Console (CONSOLE, log)
import QueryParams (getParam, runInBrowser)

main :: Eff (console :: CONSOLE) Unit
main = do
  let value = runInBrowser getParam "test"
  let has = runInBrowser hasParam "test"

  log <> "Query Param ?test is: " <> (show value)
  case has of
    true -> log "URL has ?test in it"
    false -> log "URL does not have ?test in it"

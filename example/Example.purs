module Example where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import DOM (DOM)
import Prelude (Unit, bind, (<>), show, ($))
import QueryParams (BROWSERURL, getParam, hasParam, runInBrowser, runInEnv)

main :: Eff (dom :: DOM, console :: CONSOLE) Unit
main = do

  browserHasParam <- runInBrowser $ hasParam "test"

  -- Get a query parameter from the browser's current url
  browserValue <- runInBrowser $ getParam "test"

  -- Get a query parameter from a specific url
  let envValue = (runInEnv "http://test.com?test=abc") $ getParam "test"

  log $ "Query Param ?test in browser: " <> (show browserValue)
  log $ "Query Param ?test in env: " <> (show envValue)

  case browserHasParam of
    true -> log $ "URL has ?test in it"
    false -> log $ "URL does not have ?test in it"

  let
    info = (runInEnv "http://test.com?userid=abc&timestamp=123") $ do
      muserid <- getParam "userid"
      mtimestamp <- getParam "timestamp"
      pure $ ((\userid timestamp ->
        "User " <> userid <> " was here at " <> timestamp
      ) <$> muserid <*> mtimestamp)

  logShow info

  -- When visiting http://localhost:8000/?test=hedllddawefo the output is:
  --
  -- Query Param ?test in browser: (Just "hedllddawefo")
  -- Query Param ?test in env: (Just "abc")
  -- URL has ?test in it

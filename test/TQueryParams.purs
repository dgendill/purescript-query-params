module Test.QueryParams where

import Prelude
import Data.Maybe (Maybe(..))
import Test.QuickCheck (Result, (===))
import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.QuickCheck (quickCheck)
import QueryParams (getParam, hasParam, runInEnv)

-- This is a version of encodeURIComponent that catches
-- errors and returns the passed in value unchanged
-- if you try and encode a surrogate which is not
-- part of a high-low pair, e.g.,
foreign import encodeURIComponent :: String -> String

testUrl = "http://test.com"
test1 = "?p1=a&p2=b"
test1Expect = "ab"
test1Show = "quickcheck p1 <> p2 == " <> test1Expect <> " in " <> test1
test1Url = testUrl <> test1

makeUrl base p1 p2 =
  base <> "?p1=" <> (encodeURIComponent p1) <> "&p2=" <> (encodeURIComponent p2)

joinParams url = runInEnv url do
  p1 <- getParam "p1"
  p2 <- getParam "p2"
  pure (p1 <> p2)

paramsExist url = runInEnv url do
  p1 <- hasParam "p1"
  p2 <- hasParam "p2"
  pure (show p1 <> show p2)

hasUrlParamsWorks :: String -> String -> String -> Result
hasUrlParamsWorks base p1 p2 = result === "truetrue"
  where
    result = paramsExist (makeUrl base p1 p2)

joiningUrlParamsWorks :: String -> String -> String -> Result
joiningUrlParamsWorks base p1 p2 = result === (Just (p1 <> p2))
  where
    result = joinParams (makeUrl base p1 p2)

main = void $ runTest do
  suite "Query Parameter Tests" do
    test test1Show do
      quickCheck joiningUrlParamsWorks
    test ("quickcheck p1 exists and p2 exists in " <> test1) do
      quickCheck hasUrlParamsWorks

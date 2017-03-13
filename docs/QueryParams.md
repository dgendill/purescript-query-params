## Module QueryParams

#### `BROWSERURL`

``` purescript
data BROWSERURL :: Effect
```

runInBrowser requires the BROWSERURL effect

#### `runInEnv`

``` purescript
runInEnv :: forall a. URL -> QueryParamAction a -> a
```

Run a a series of QueryParamActions on a particular url
and return a value, e.g.

```purescript
runInEnv "http://test.com?userid=john" $ do
  userid <- getParam "userid"
  case userid of
    Just u -> pure "User is " <> u
    Nothing -> pure "No user present"
```

#### `runInBrowser`

``` purescript
runInBrowser :: forall e a. QueryParamAction a -> Eff (browserurl :: BROWSERURL | e) a
```

Run a a series of QueryParamActions on the browser's
current URL, and return a value e.g.

```purescript
info <- (runInBrowser $ do
  muserid <- getParam "userid"
  mtimestamp <- getParam "timestamp"
  pure $ ((\userid timestamp ->
    "User " <> userid <> " was here at " <> timestamp
  ) <$> muserid <*> mtimestamp)
```

#### `getParam`

``` purescript
getParam :: String -> QueryParamAction (Maybe String)
```

Get a query parameter value from a url

#### `hasParam`

``` purescript
hasParam :: String -> QueryParamAction Boolean
```

Check if a url has a query parameter in it, e.g.

```purescript
runInBrowser $ do
  hasToken <- hasParam "token"
  if hasToken == true
    then pure "Has token"
    else pure "Does not have token"
```

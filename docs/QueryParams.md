## Module QueryParams

#### `runInEnv`

``` purescript
runInEnv :: forall a. URL -> QueryParamAction a -> a
```

Run a series of `QueryParamActions` on a particular url
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
runInBrowser :: forall a eff. QueryParamAction a -> Eff (dom :: DOM | eff) a
```

Run a QueryParamAction program in the browser
and use the browser's current url

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

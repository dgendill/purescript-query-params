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

Run a QueryParamAction program on a particular url
and return the result

#### `runInBrowser`

``` purescript
runInBrowser :: forall e a. QueryParamAction a -> Eff (browserurl :: BROWSERURL | e) a
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

Check if a url has a particular query parameter

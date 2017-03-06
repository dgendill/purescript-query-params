## Module QueryParams

#### `QueryParamActionF`

``` purescript
data QueryParamActionF f
```

A functor defining actions you can perform on
a url

##### Instances
``` purescript
Functor QueryParamActionF
```

#### `QueryParamAction`

``` purescript
type QueryParamAction a = Free QueryParamActionF a
```

A type alias for a QueryParamAction program

#### `runInEnv`

``` purescript
runInEnv :: forall a. URL -> QueryParamAction a -> a
```

Run a QueryParamAction program on a particular url
and return the result

#### `runInBrowser`

``` purescript
runInBrowser :: forall a. QueryParamAction a -> a
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

Check if a url has a particular query parameter



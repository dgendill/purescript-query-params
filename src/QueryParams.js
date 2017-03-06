'use strict';

// if (!document) {
//   dom = require('node-dom').dom
//   window = dom(page,null,options);
//   document = window.document;
// }

var parseParams = function(search) {
  return (function(a) {
      if (a == "") return {};
      var b = {};
      for (var i = 0; i < a.length; ++i)
      {
          var p=a[i].split('=', 2);
          if (p.length == 1)
              b[p[0]] = "";
          else
              b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
      }
      return b;
  })(search.substr(1).split('&'));
}

// var params = parseParams();

exports.runInWindow_ = function() {
    return parseParams(window.location.search);
}

exports.runInEnv_ = function(url) {
  var parts = url.split("?");
  if (parts.length > 1) {
    return parseParams("?" + parts[1]);
  } else {
    return parseParams("");
  }
}

exports.hasParam_ = function(param, env) {
    return param in env;
}

exports.getParam_ = function(param, env, Just, Nothing) {
    if (exports.hasParam_(param, env)) {
      return Just(env[param]);
    } else {
      return Nothing();
    }
}

exports.stripUnmatchedSurrogates = function(str) {
    return str.replace(/[\uD800-\uDBFF](?![\uDC00-\uDFFF])/g, '').split('').reverse().join('').replace(/[\uDC00-\uDFFF](?![\uD800-\uDBFF])/g, '').split('').reverse().join('');
}

exports.encodeURIComponent = function(s) {
  try {
    return encodeURIComponent(s);
  } catch (e) {
    return s
  }
}

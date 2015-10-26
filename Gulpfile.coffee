# Capitalize method inject to string object.
# ------------------------------
String.prototype.capitalize = -> @replace(/(?:^|\s)\S/g, (a) -> a.toUpperCase())

require('require-dir')('./gulp/tasks', { recurse: true })
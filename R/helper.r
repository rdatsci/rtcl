messagef = function(msg, ...) {
  message(crayon::green(sprintf(msg, ...)))
}

collapse = function(..., sep = ",") {
  paste0(..., collapse = sep)
}

`%nin%` = function(x, y) {
  !match(x, y, nomatch = 0L)
}

getLibraryPath = function() {
  head(.libPaths(), 1L)
}

addClasses = function(x, classes) {
  class(x) = c(classes, class(x))
  x
}

vlapply = function(x, fun, ..., use.names = TRUE) {
  vapply(X = x, FUN = fun, ..., FUN.VALUE = NA, USE.NAMES = use.names)
}

vcapply = function(x, fun, ..., use.names = TRUE) {
  vapply(X = x, FUN = fun, ..., FUN.VALUE = NA_character_, USE.NAMES = use.names)
}

extract = function(li, what) {
  vapply(li, "[[", what, FUN.VALUE = NA_character_)
}

readPackageName = function(path) {
  as.character(read.dcf(file.path(path, "DESCRIPTION"), fields = "Package"))
}

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

updatePackageAttributes = function(path = ".") {
  assertDirectoryExists(path)
  path = pkgload::pkg_path(path)

  pkgload::load_all(path)
  desc = pkgload::pkg_desc(path = path)

  if (!is.na(desc$get("RoxygenNote"))) {
    messagef("Updating documentation for '%s'", pkgload::pkg_name(path = path))
    roxygen2::roxygenize(package.dir = pkgload::pkg_path(path = path))
  }

  if (!is.na(desc$get("LinkingTo")) && "Rcpp" %in% desc$get_deps()$package) {
    messagef("Updating Rcpp compile attributes")
    requireNamespace("Rcpp")
    Rcpp::compileAttributes(path = path, verbose = TRUE)
  }
}

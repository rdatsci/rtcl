packageToString = function(pkg) {
  UseMethod("packageToString")
}

#' @export
packageToString.default = function(pkg) {
  if (testString(pkg))
    return(pkg)
  stop("No method found to convert package to a string: ", pkg)
}

#' @export
packageToString.LocalPackage = function(pkg) {
  pkg$uri
}

#' @export
packageToString.CranPackage = function(pkg) {
  pkg$name
}

#' @export
packageToString.GitPackage = function(pkg) {
  pkg$uri
}

#' @export
packageToString.GitHubPackage = function(pkg) {
  pkg$repo
}

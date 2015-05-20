#' Check a package
#'
#' @description
#' Check a package located in \code{path} using \code{link[devtools]{check}}..
#'
#' @template path
#' @template return-itrue
#' @export
rcheck = function(path = getwd()) {
  pkg = devtools::as.package(path)
  messagef("Checking package '%s' ...", pkg$package)
  devtools::check(pkg)
  invisible(TRUE)
}

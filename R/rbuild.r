#' Build a package
#'
#' @description
#' Build a package located in \code{path} using \code{link[devtools]{build}}.
#'
#' @template path
#' @template return-itrue
#' @export
rbuild = function(path = getwd()) {
  pkg = devtools::as.package(path, create = FALSE)
  updatePackageAttributes(pkg)

  messagef("Building package '%s' ...", pkg$package)
  loc = devtools::build(pkg)
  messagef("The package has been bundled to '%s'.", normalizePath(loc))
  invisible(TRUE)
}

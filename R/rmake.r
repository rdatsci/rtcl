#' Make and install a package
#'
#' @description
#' Updates the documentation and then installs the package located at \code{path}, using
#' \code{link[devtools]{document}}, \code{link[devtools]{install_deps}} and \code{link[devtools]{install}}.
#'
#' @template path
#' @param deps [\code{logical(1)}]\cr
#' Also install all dependencies, including suggests? Default is \code{FALSE}.
#' @template return-itrue
#' @export
rmake = function(path = getwd(), deps = FALSE) {
  # pkg = devtools::as.package(path, create = FALSE)
  assertFlag(deps)

  pkgname = pkgload::pkg_name(path = path)
  
  if (deps) {
    messagef("Checking dependencies for '%s' in '%s'", pkgname, pkgload::pkg_path(path = path))
    remotes::install_deps(pkgdir = path, dependencies = TRUE, lib = getLibraryPath())
  }
  updatePackageAttributes(path = path)
  
  messagef("Installing package '%s'", pkgname)
  remotes::install_local(path = path)
  messagef("Package '%s' has been installed to '%s'", pkgname, getLibraryPath())
  invisible(TRUE)
}

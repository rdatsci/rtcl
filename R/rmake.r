#' Make and install a package
#'
#' @description
#' Updates the documentation and then installs the package located at \code{path}, using
#' \code{link[roxygen2]{roxygenize}}, \code{link[remotes]{install_deps}} and \code{link[remotes]{install_local}}.
#'
#' @template path
#' @template return-itrue
#' @export
rmake = function(path = getwd()) {
  pkgname = pkgload::pkg_name(path = path)

  updatePackageAttributes(path = path)

  messagef("Checking dependencies for '%s' in '%s'", pkgname, pkgload::pkg_path(path = path))
  remotes::install_deps(pkgdir = path, dependencies = TRUE, lib = getLibraryPath())


  messagef("Installing package '%s'", pkgname)
  remotes::install_local(path = path, force = TRUE)
  messagef("Package '%s' has been installed to '%s'", pkgname, getLibraryPath())
  invisible(TRUE)
}

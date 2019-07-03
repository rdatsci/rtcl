#' Make and install a package
#'
#' @description
#' Updates the documentation and then installs the package located at \code{path}, using
#' \code{\link[roxygen2]{roxygenize}}, \code{\link[remotes]{install_deps}} and \code{\link[remotes]{install_local}}.
#'
#' @template path
#' @param ... [\code{any}]\cr
#'   Passed to \code{\link[remotes]{install_local}}.
#' @template return-itrue
#' @export
rmake = function(path = getwd(), ...) {
  pkgname = pkgload::pkg_name(path = path)
  pkgdir = pkgload::pkg_path(path = path)

  messagef("Checking dependencies for '%s' in '%s'", pkgname, pkgdir)
  remotes::install_deps(pkgdir = pkgdir, dependencies = TRUE, lib = getLibraryPath(), build_opts = getDefaultBuildOpts(remotes::install_deps, "remotes"))

  updatePackageAttributes(path = pkgdir)

  messagef("Installing package '%s'", pkgname)
  remotes::install_local(path = pkgdir, force = TRUE, build_opts = getDefaultBuildOpts(remotes::install_local, "local"), ...)
  messagef("Package '%s' has been installed to '%s'", pkgname, getLibraryPath())
  invisible(TRUE)
}

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
  pkg = devtools::as.package(path, create = FALSE)
  assertFlag(deps)

  if (deps) {
    messagef("Checking dependencies for '%s' in '%s'", pkg$package, pkg$path)
    devtools::install_deps(pkg, lib = getLibraryPath())
  }
  updatePackageAttributes(pkg)

  messagef("Installing package '%s'", pkg$package)
  devtools::install(pkg, reload = !getOption("rt.cli", FALSE))
  messagef("Package '%s' has been installed to '%s'", pkg$package, getLibraryPath())
  invisible(TRUE)
}

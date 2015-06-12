#' Make and install a package
#'
#' @description
#' Updates the documenation and then installs the package located at \code{path}, using
#' \code{link[devtools]{document}}, \code{link[devtools]{install_deps}} and \code{link[devtools]{install}}.
#'
#' @template path
#' @param deps [\code{logical(1)}]\cr
#' Also install all dependencies, including suggests? Default is \code{FALSE}.
#' @template return-itrue
#' @export
rmake = function(path = getwd(), deps = FALSE) {
  pkg = devtools::as.package(path)
  assertFlag(deps)

  cli = getOption("rt.cli", FALSE)
  messagef("Making package '%s' in '%s'", pkg$package, pkg$path)
  devtools::document(pkg)
  if (deps)
    devtools::install_deps(pkg, dependencies = c("Depends", "Imports", "LinkingTo", "Suggests"))
  devtools::install(pkg, reload = !cli)
  messagef("Package '%s' has been installed to '%s'", pkg$package, getLibraryPath())
  invisible(TRUE)
}

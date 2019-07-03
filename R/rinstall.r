#' Installs R packages
#'
#' @description
#' Installs R packages from local directory, CRAN or Git.
#'
#' @param pkgs [\code{character}]\cr
#'  Strings convertible by \code{\link{stringToPackage}}.
#' @param add [\code{logical(1)}]\cr
#'  Append packages to your config file in \code{\link{getConfigPath}}.?
#'  Default is \code{FALSE}.
#' @param ... [\code{any}]\cr
#'   Passed to \code{remotes::install_*()}.
#' @template return-itrue
#' @export
rinstall = function(pkgs = character(0L), add = FALSE, ...) {
  pkgs = lapply(pkgs, stringToPackage)
  assertFlag(add)
  pn = extract(pkgs, "name")
  is.cran = vlapply(pkgs, inherits, "PackageCran")
  if (any(is.cran)) {
    messagef("Installing %i packages from CRAN: %s", sum(is.cran), collapse(pn[is.cran]))
    install.packages(pn[is.cran], INSTALL_opts = getDefaultBuildOpts(install.packages, "cran", "INSTALL_opts"), ...)
  }

  for (pkg in pkgs[!is.cran]) {
    installPackage(pkg, ...)
  }

  if (add) {
    addPackagesToCollection(pkgs)
  }
  invisible(TRUE)
}

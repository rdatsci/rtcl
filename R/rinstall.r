#' Installs R packages
#'
#' @description
#' Installs R packages from local directory, CRAN or Git.
#'
#' @param pkgs [\code{character}]\cr
#'  Strings convertible by \code{\link{stringToPackage}}.
#'  Default is the current directory: \dQuote{.}
#' @param add [\code{logical(1)}]\cr
#'  Append packages to your config file in \code{\link{getConfigPath}}.?
#'  Default is \code{FALSE}.
#' @param ... [\code{any}]\cr
#'   Passed to \code{remotes::install_*()}.
#' @template return-itrue
#' @export
rinstall = function(pkgs = ".", add = FALSE, ...) {
  pkgs = lapply(pkgs, stringToPackage)
  assertFlag(add)

  # FIXME: Do we need to specify the lib_path?

  pn = extract(pkgs, "name")
  is.cran = vlapply(pkgs, inherits, "PackageCran")
  if (any(is.cran)) {
    messagef("Installing %i packages from CRAN: %s", sum(is.cran), collapse(pn[is.cran]))
    remotes::install_cran(pn[is.cran], ...)
  }

  for (pkg in pkgs[!is.cran])
    installPackage(pkg, ...)

  if (add)
    addPackagesToCollection(pkgs)
  invisible(TRUE)
}

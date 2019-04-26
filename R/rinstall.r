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

  # FIXME: Do we need to specify the lib_path?

  pn = extract(pkgs, "name")
  is.cran = vlapply(pkgs, inherits, "PackageCran")
  if (any(is.cran)) {
    messagef("Installing %i packages from CRAN: %s", sum(is.cran), collapse(pn[is.cran]))
    remotes::install_cran(pn[is.cran], build_opts = getConfig()$build_opts_cran %??% formals(remotes::install_cran)$build_opts, ...)
  }

  dots = list(...)
  for (pkg in pkgs[!is.cran]) {
    dots$build_opts = getConfig()$build_opts_remotes #FIXME maybe this should be in the individial installPacakge functions
    do.call(installPackage, c(list(pkg = pkg), dots))
  }

  if (add) {
    addPackagesToCollection(pkgs)
  }
  invisible(TRUE)
}

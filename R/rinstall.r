#' Installs R packages
#'
#' @description
#' Installs R packages from local directory, CRAN or Git.
#'
#' @param pkgs [\code{character}]\cr
#'  Strings convertible by \code{\link{stringToPackage}}.
#' @param add [\code{logical(1)}]\cr
#'  Append packages to your \code{~/.rt/packages} file?
#'  Default is \code{FALSE}.
#' @param noquick [\code{logical(1)}]\cr
#'  Switch off devtools quick installation for git packages.
#'  See \code{?devtools::install}.
#'  Default is \code{FALSE}.
#' @template return-itrue
#' @export
rinstall = function(pkgs = character(0L), add = FALSE, noquick = FALSE) {
  pkgs = lapply(pkgs, stringToPackage)
  assertFlag(add)
  assertFlag(noquick)
  lib = getLibraryPath()

  pn = extract(pkgs, "name")
  is.cran = extract(pkgs, "type") == "cran"
  if (any(is.cran)) {
    messagef("Installing %i packages from CRAN: %s", sum(is.cran), collapse(pn[is.cran]))
    install.packages(pn[is.cran], lib = lib, INSTALL_opts = getOption("devtools.install.args"))
  }

  for (pkg in pkgs[!is.cran])
    installPackage(pkg, temp = !add, quick = !noquick)
  if (add)
    addPackagesToCollection(pkgs)
  invisible(TRUE)
}

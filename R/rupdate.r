#' Update packages
#'
#' @description
#' Update packages. This includes multiple steps:
#' \itemize{
#'   \item{1.}{All outdated CRAN packages will be updated.}
#'   \item{2.}{If \code{rebuild} is set to \code{TRUE}, all packages which
#'      are built under a different R version will be rebuilt with the current.}
#'   \item{3.}{CRAN packages which are listed in \code{~/.rt/packages} but are not
#'     found on the system will be installed.}
#'   \item{4.}{All packages with a git source listed in \code{~/.rt/packages} will be updated and
#'     re-installed if necessary.}
#' }
#' The collection file \code{~/.rt/packages} expects one package per line specified in a format
#' which is parseable by \code{\link{stringToPackage}}. Leading and trailing whitespace characters
#' will automatically be trimmed. Empty lines and lines starting with a \dQuote{#} will be ignored.
#'
#' @param rebuild [\code{logical(1)}]\cr
#'  Rebuild R packages which are built using a different version of R.
#' @template return-itrue
#' @export
rupdate = function(rebuild = FALSE) {
  assertFlag(rebuild)

  messagef("Checking for outdated packages ...")
  lib = getLibraryPath()
  pkgs = getCollectionContents(as.packages = TRUE)
  pkg.type = factor(extract(pkgs, "type"))

  messagef("Updating packages ...")
  remotes::update_packages(dependencies = TRUE, upgrade = "always")

  if (rebuild) {
    built = installed.packages()[, "Built"]
    pn = names(which(built < getRversion()))
    if (length(pn)) {
      messagef("Rebuilding %i outdated packages ...", length(pn))
      remotes::install_cran(pn, lib = lib)
    }
  }

  if ("cran" %in% levels(pkg.type)) {
    pn = extract(pkgs, "name")
    w = which(pkg.type == "cran" & pn %nin% rownames(installed.packages()))
    if (length(w)) {
      messagef("Installing %i missing cran packages ...", length(w))
      remotes::install_cran(pn[w], lib = lib)
    }
  }

  if ("git" %in% levels(pkg.type)) {
    lapply(pkgs[pkg.type == "git"], installPackage, temp = FALSE)
  }

  invisible(TRUE)
}

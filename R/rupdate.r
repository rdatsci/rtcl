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
#' @param only.cran [\code{logical(1)}]\cr
#'  Update CRAN packages only. Default is \code{FALSE}.
#' @param only.git [\code{logical(1)}]\cr
#'  Update Git packages only. Default is \code{FALSE}.
#' @param force [\code{logical(1)}]\cr
#'  Force installation of Git packages? Default is \code{FALSE}.
#' @template return-itrue
#' @export
rupdate = function(rebuild = FALSE, only.cran = FALSE, only.git = FALSE, force = FALSE) {
  assertFlag(rebuild)

  messagef("Checking for outdated packages ...")
  lib = getLibraryPath()
  pkgs = getCollectionContents(as.packages = TRUE)
  pkg.type = factor(extract(pkgs, "type"))


  if (!only.git) {
    fields = c("Package", "LibPath", "Version")
    installed = data.table(installed.packages(fields = fields), key = "Package")[, fields, with = FALSE]
    old = installed[data.table(old.packages()[, c("Package", "ReposVer")])]
    # reduce to max installed version
    old = old[, list(Version = max(package_version(Version)), ReposVer = package_version(head(ReposVer, 1L))), by = Package]
    old = old[Version < ReposVer, Package]
    if (length(old)) {
      messagef("Rebuilding %i outdated packages ...", length(old))
      install.packages(old, lib = lib)
    }
  }

  if (!only.git && "cran" %in% levels(pkg.type)) {
    pn = extract(pkgs, "name")
    w = which(pkg.type == "cran" & installed[, pn %nin% Package])
    if (length(w)) {
      messagef("Installing %i missing cran packages ...", length(w))
      install.packages(pn[w], lib = lib)
    }
  }

  if (!only.cran && "git" %in% levels(pkg.type)) {
    lapply(pkgs[pkg.type == "git"], installPackage, force = force)
  }
  invisible(TRUE)
}

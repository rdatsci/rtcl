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
#' @param neverupgrade [code{logical(1)}]\cr
#'  Passed to \code{\link[remotes]{update_packages}} as \code{upgrade = ifelse(neverupgrade, "never", "always")}.
#'  Default is \dQuote{FALSE} so all dependencies are upgraded.
#' @template return-itrue
#' @export
rupdate = function(rebuild = FALSE, neverupgrade = FALSE) {
  assertFlag(rebuild)
  assertFlag(neverupgrade)
  upgrade = ifelse(neverupgrade, "never", "always")

  messagef("Checking for outdated packages ...")
  lib = getLibraryPath()
  pkgs = getCollectionContents(as.packages = TRUE)
  pkgs_names = extract(pkgs, "name")
  pkgs_is_cran = vlapply(pkgs, inherits, "PackageCran")

  pkgs_installed_names = rownames(installed.packages())

  messagef("Updating packages ...")

  # update cran packages
  remotes::update_packages(dependencies = TRUE, upgrade = upgrade)

  # install packages that have not been update by above line
  # these are a) cran packages from the collection and b) all remote packages
  rinstall(pkgs[!(pkgs_is_cran & (pkgs_names %in% pkgs_installed_names))], upgrade = upgrade)

  # rebuild packages
  if (rebuild) {
    built = installed.packages()[, "Built"]
    names_rebuild = names(which(built < getRversion()))
    names_no_rebuild = names(which(built >= getRversion()))

    # update all packages except those that are specified as non-cran packages in the collection
    names_rebuild_cran = setdiff(names_rebuild, pkgs_names[!pkgs_is_cran])
    if (length(names_rebuild_cran) > 0) {
      messagef("Rebuilding %i outdated packages from CRAN: %s", length(names_rebuild_cran), collapse(names_rebuild_cran))
      remotes::update_packages(names_rebuild_cran, lib = lib, force = TRUE, upgrade = upgrade)
    }

    # update all non-cran packages in the collection for that we are not sure that they are up to date
    names_rebuild_remote = setdiff(pkgs_names[!pkgs_is_cran], names_no_rebuild)
    if (length(names_rebuild_remote) > 0) {
      messagef("Rebuilding %i outdated packages from remote: %s", length(names_rebuild_remote), collapse(names_rebuild_remote))
      rinstall(pkgs[pkgs_names %in% names_rebuild_remote], force = TRUE, upgrade = upgrade)
    }
  }


  invisible(TRUE)
}

#' Update packages
#'
#' @description
#' Update packages. This includes multiple steps:
#' \itemize{
#'   \item{1.}{All outdated CRAN packages will be updated.}
#'   \item{2.}{New packages from \code{\link{getConfigPath}("packages")} will be installed.}
#'   \item{3.}{Non-CRAN packages will be updated.}
#'   \item{4.}{If \code{rebuild} is set to \code{TRUE}, all packages which
#'      are built under a different R version will be rebuilt with the current.}
#' }
#' The collection file \code{\link{getConfigPath}("packages")} expects one package per line specified in a format
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
  pkgs_df = data.frame(
    rt_pkg = I(pkgs),
    rt_name = extract(pkgs, "name"),
    rt_class = vapply(pkgs, function(x) head(class(x), 1), character(1L))
  )
  pkgs_installed_names = rownames(installed.packages())
  pkgs_df$installed = pkgs_df$rt_name %in% pkgs_installed_names
  pkgs_df$meta = Map(getMeta, pkgs_df$rt_name, pkgs_df$installed)
  pkgs_df$meta_class = vapply(pkgs_df$meta, getMetaType, character(1L))
  pkgs_df$rebuild = FALSE

  # first we do the rebuild because we might not be able to update with broken packages
  if (rebuild) {
    built = installed.packages()[, "Built"]
    names_rebuild = names(which(built < getRversion()))
    names_no_rebuild = names(which(built >= getRversion()))

    # update all packages except those that are specified as non-cran packages in the collection
    names_rebuild_cran = setdiff(names_rebuild, pkgs_df[pkgs_df$rt_class != "PackageCran",]$rt_name)
    if (length(names_rebuild_cran) > 0) {
      messagef("Rebuilding %i outdated packages from CRAN: %s", length(names_rebuild_cran), collapse(names_rebuild_cran))
      remotes::update_packages(names_rebuild_cran, lib = lib, force = TRUE, upgrade = upgrade)
    }

    # update all non-cran packages in the collection for that we are not sure that they are up to date
    pkgs_df$rebuild = !(pkgs_df$rt_name %in% names_no_rebuild) & pkgs_df$rt_class != "PackageCran"
    if (length(pkgs_df$rebuild) > 0) {
      messagef("Adding %i packages to rebuild: %s", length(pkgs_df$rebuild),  collapse(pkgs_df[pkgs_df$rebuild == TRUE,]$rt_name))
    }
  }

  # force installation for new packages and those that changed their type (eg. CRAN->GitHub)
  pkgs_df$force_install = is.na(pkgs_df$meta_class) | (pkgs_df$meta_class != pkgs_df$rt_class) | pkgs_df$rebuild

  if (any(pkgs_df$force_install)) {
    messagef("Install %i new packages: %s", sum(pkgs_df$force_install), collapse(pkgs_df[pkgs_df$force_install == TRUE,]$rt_name))
    rinstall(pkgs_df[pkgs_df$force_install == TRUE,]$rt_pkg, upgrade = upgrade, force = TRUE)
  }

  messagef("Auto update packages...")
  pkgs_df$exclude_from_auto_update = pkgs_df$force_install == TRUE | pkgs_df$rt_class != "PackageCran"
  pkgs_to_auto_update = setdiff(pkgs_installed_names, pkgs_df[pkgs_df$exclude_from_auto_update == TRUE, ]$rt_name)
  remotes::update_packages(packages = pkgs_to_auto_update, dependencies = TRUE, upgrade = upgrade)

  # install packages that have not been update by above line
  # these are a) cran packages from the collection and b) all remote packages
  pkgs_df$manual_update = !pkgs_df$force_install & pkgs_df$exclude_from_auto_update
  if (any(pkgs_df$manual_update)) {
    messagef("Update %i packages manually: %s", sum(pkgs_df$manual_update), collapse(pkgs_df[pkgs_df$manual_update == TRUE,]$rt_name))
    rinstall(pkgs_df[pkgs_df$manual_update == TRUE,]$rt_pkg, upgrade = upgrade, force = FALSE)
  }

  invisible(TRUE)
}

# helpers
getMeta = function(name, installed = TRUE) {
  if (!installed) {
    NULL
  } else {
    utils::packageDescription(name)
  }
}

getMetaType = function(meta) {
  if (is.null(meta)) {
    return(NA_character_)
  } else {
    if (!is.null(meta$RemoteType)) {
      switch(meta$RemoteType,
        github = "PackageGitHub",
        gitlab = "PackageGitLab",
        cran = "PackageCran",
        xgit = "PackageGit",
        git2r = "PackageGit",
        bitbucket = "PackageBitbucket",
        local = "PackageLocal"
      )
    } else if (isTRUE(meta$Repository == "CRAN")) {
      return("PackageCran")
    } else {
      return(NA_character_)
    }
  }
}

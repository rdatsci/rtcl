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
#' @param savemode [code{logical(1)}]\cr
#'  Works slower but should handle most conflicts.
#'  Might be helpful after R-Version update or if packages are removed from CRAN.
#' @template return-itrue
#' @export
rupdate = function(rebuild = FALSE, neverupgrade = FALSE, savemode = FALSE) {
  assertFlag(rebuild)
  assertFlag(neverupgrade)
  assertFlag(savemode)
  upgrade = ifelse(neverupgrade, "never", "always")

  messagef("Checking for outdated packages ...")
  lib = getLibraryPath()
  pkgs = getCollectionContents(as.packages = TRUE)
  pkgs_df = data.frame(
    rt_pkg = I(pkgs),
    rt_name = extract(pkgs, "name"),
    rt_class = vapply(pkgs, function(x) head(class(x), 1), character(1L))
  )
  pkgs_installed = as.data.table(installed.packages())
  pkgs_installed$meta = lapply(pkgs_installed$Package, getMeta)
  pkgs_installed$meta_class = vapply(pkgs_installed$meta, getMetaType, character(1L))
  pkgs_installed$status = "installed_local"
  pkgs_df$Package = pkgs_df$rt_name
  pkgs_df = merge(pkgs_df, pkgs_installed, all.x = TRUE, all.y = TRUE)
  pkgs_df$status[is.na(pkgs_df$status)] = "requested_rt"

  # Obtain package remote information
  pkgs_deps = remotes::package_deps(as.character(pkgs_df$Package))


  # Packages we want to install from CRAN:
  # 1) New CRAN packages in rt file
  # 2) If rebuilt: Packages that are build with an old R version
  # 3) CRAN Packages with a new version available

  # STEP: Rebuild cran packages, because we might not be able to update with broken packages

  selector = !is.na(pkgs_df$meta_class) & pkgs_df$meta_class == "PackageCran" & pkgs_df$rebuild == TRUE & (pkgs_df$rt_class = "PackageCran" | is.na(pkgs_df$rt_class))

  names_rebuild_cran = pkgs_df[selector, ]$Package
  pkgs_df$status[selector] = "rebuilt_cran"
  if (length(names_rebuild_cran) > 0) {
    messagef("Rebuilding %i outdated packages from CRAN: %s", length(names_rebuild_cran), collapse(names_rebuild_cran))
    # Do not use update because it does not rebuild (even with force)!
    remotes::install_cran(as.character(names_rebuild_cran), lib = lib, force = TRUE, upgrade = upgrade)
  }

  # STEP: update all non-cran packages in the collection for that we are not sure that they are up to date
  selector = is.na(pkgs_df$meta_class) | pkgs_df$meta_class != "PackageCran" & pkgs_df$rebuild == TRUE
  pkgs_df$rebuild = !(pkgs_df$rt_name %in% names_no_rebuild) & pkgs_df$rt_class != "PackageCran"
  if (length(pkgs_df$rebuild) > 0) {
    messagef("Adding %i packages to rebuild: %s", length(pkgs_df$rebuild),  collapse(pkgs_df[pkgs_df$rebuild == TRUE,]$rt_name))
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
  if (!savemode) {
    tryCatch({
      remotes::update_packages(packages = pkgs_to_auto_update, upgrade = upgrade)
    }, error = function(e) {
      stop("remotes::update_packages failed with error:", "\n", as.character(e), "\n", "You can try to call rupdate with savemode.")
    })
  } else {
    messagef("Update each package step by step in safemode...")
    error_stack = list()
    for (pkg_this in pkgs_to_auto_update) {
      message("Package: ", pkg_this, appendLF = FALSE)
      tryCatch({
        remotes::update_packages(pkg_this, upgrade = upgrade)
      }, error = function(e) {
        er = as.character(e)
        message(substr(er, 0, 25), "...", matchRegex(er, ".{1,25}$")[[1]], appendLF = FALSE)
        error_stack <<- c(error_stack, list(list(package = pkg_this, error = er)))
      })
      message("")
    }
    if (length(error_stack)>0) {
      stop("Failed with the following errors:", "\n", paste0(extract(error_stack, "package"), ": ", extract(error_stack, "error"), collapse = "\n"))
    }
  }


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
        local = "PackageLocal",
        bioc_git2r = "PackageBioc"
      )
    } else if (isTRUE(meta$Repository == "CRAN")) {
      return("PackageCran")
    } else {
      return(NA_character_)
    }
  }
}

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

  pkgs = getCollectionContents(as.packages = TRUE)
  pkgs_df = data.frame(
    rt_pkg = I(pkgs),
    rt_name = extract(pkgs, "name"),
    rt_class = vapply(pkgs, function(x) head(class(x), 1), character(1L)),
    status = rep(NA_character_, length(pkgs)),
    stringsAsFactors = FALSE
  )
  pkgs_df$Package = pkgs_df$rt_name

  x = list(done = FALSE, rebuild = rebuild, upgrade = upgrade, savemode = savemode, pkgs_df = pkgs_df, step = 0)
  messagef("Checking for outdated packages ...")
  while (!x$done & x$step < 100) {
    x = rupdate2(x)
  }
  messagef("Everything up to date!")
  invisible(x$done)
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

rupdate_result = function(x, pkgs_df, done = FALSE) {
  x$pkgs_df = pkgs_df
  x$done = done
  x$step = x$step + 1
  return(x)
}

# x - left df
# y - right df
# by - id column
# protect - column in x that cannot be overwritten by column in y
#
# merges x and y. if columns except "by" exist in both df's we always take the ones from y except it is in "protect"
merge_left_overwrites = function(x, y, by = "Package" , protect = "status") {
  update_columns = setdiff(colnames(y), protect)
  constant_columns = c(by, setdiff(colnames(x), update_columns))
  z = merge(x = x[, constant_columns, drop = FALSE], y = y[, update_columns, drop = FALSE], all.x = TRUE, all.y = TRUE, by = by)
}

built_compare = function(x) {
  r_version = getRversion()
  vapply(x, function(x) !is.na(x) && x < r_version, logical(1))
}

rupdate2 = function(x) {
  # Collect information about r packages in rt config
  lib = getLibraryPath()
  pkgs_df = x$pkgs_df

  # ... and about installed r packages
  pkgs_installed = as.data.frame(installed.packages(), stringsAsFactors = FALSE)
  pkgs_installed$meta = lapply(pkgs_installed$Package, getMeta)
  pkgs_installed$meta_class = vapply(pkgs_installed$meta, getMetaType, character(1L))
  pkgs_df = merge_left_overwrites(x = pkgs_df, y = pkgs_installed)

  selector = with(pkgs_df, !is.na(rt_class) & !is.na(meta_class) & meta_class != rt_class)
  if (any(selector)) {
    messagef("These %i packages: %s are installed in a different version then specified in the rt collection an will be removed (before they will be installed accordingly).", sum(selector), collapse(pkgs_df$Package[selector]))
    remove.packages(pkgs = pkgs_df$Package[selector])
    pkgs_df$status[selector] = "removed_for_rt_update"
    return(rupdate_result(x, pkgs_df))
  }

  # Obtain package remote information (cached because slow)
  if (is.null(x$pkgs_deps) || !identical(x$pkgs_df$Package, pkgs_df$Package)) {
    messagef("Obtaining remote version information for %i packages", nrow(pkgs_df))
    pkgs_deps = as.data.frame(remotes::package_deps(pkgs_df$Package))
    colnames(pkgs_deps)[colnames(pkgs_deps) == "package"] = "Package"
    x$pkgs_deps = pkgs_deps
    pkgs_df = merge_left_overwrites(pkgs_df, pkgs_deps)
  }


  # Packages we want to install from CRAN:
  # 1) New CRAN packages in rt file
  # 2) If rebuild == TRUE: Packages that are build with an old R version
  # 3) CRAN Packages with a new version available

  # STEP: Rebuild cran packages, because we might not be able to update with broken packages

  selector = with(pkgs_df, {
    (is.na(meta_class) & !is.na(rt_class) & rt_class == "PackageCran") | #(1)
    (x$rebuild & !is.na(meta_class) & meta_class == "PackageCran" & built_compare(Built)) | #(2)
    ((!is.na(meta_class) & meta_class == "PackageCran") & !(!is.na(status) & status == "updated") & (!is.na(diff) & diff < 0)) #(3)
  })

  if (any(selector)) {
    messagef("Updating, re-/installing %i Packages from CRAN: %s", sum(selector), collapse(pkgs_df$Package[selector]))
    # Do not use update because it does not rebuild (even with force)!
    remotes::install_cran(pkgs_df$Package[selector], lib = lib, force = TRUE, upgrade = x$upgrade, build_opts = getDefaultBuildOpts(remotes::install_cran, "cran"))
    pkgs_df$status[selector] = "updated"
    return(rupdate_result(x, pkgs_df))
  }

  # Packages that we want to install from remotes
  # 1) New not cran packages in rt file
  selector = with(pkgs_df, {
    (is.na(meta_class) & !is.na(rt_class) & rt_class != "PackageCran") #(1)
  })

  if (any(selector)) {
    messagef("Installing %i new packages from remotes: %s", sum(selector), collapse(pkgs_df$Package[selector]))
    rinstall(pkgs_df$rt_pkg[selector], upgrade = x$upgrade, force = TRUE)
    pkgs_df$status[selector] = "updated"
    return(rupdate_result(x, pkgs_df))
  }

  # Packages that we want to install from remotes
  # 2) If rebuild == TRUE: Packages with no version change that are build with an old R version but exist remotely
  selector = with(pkgs_df, {
    (x$rebuild & !is.na(meta_class) & meta_class != "PackageCran" & !(!is.na(status) & status == "updated") & built_compare(Built) & !is.na(diff) & diff == 0) #(2)
  })

  if (any(selector)) {
    messagef("The following %i packages are built with an old R-Version and not from CRAN. They can only be updated if added to the rt collection at the time: %s", sum(selector), collapse(pkgs_df$Package[selector]))
  }

  # Packages that we can auto update
  # 3) Installed remote packages with new version available
  selector = with(pkgs_df, {
    (!is.na(meta_class) & meta_class != "PackageCran" & !(!is.na(status) & status == "updated")) #(2)
  })

  if (any(selector)) {
    messagef("The following %i packages will be automatically updated: %s", sum(selector), collapse(pkgs_df$Package[selector]))
    if (!x$savemode) {
      tryCatch({
        remotes::update_packages(packages = pkgs_df$Package[selector], upgrade = x$upgrade, build_opts = getDefaultBuildOpts(remotes::update_packages, "remotes"))
      }, error = function(e) {
        stop("remotes::update_packages failed with error:", "\n", as.character(e), "\n", "You can try to call rupdate with savemode.")
      })
    } else {
      messagef("Update each package step by step in safemode...")
      error_stack = list()
      for (pkg_this in pkgs_df$Package[selector]) {
        message("Package: ", pkg_this, appendLF = FALSE)
        tryCatch({
          remotes::update_packages(pkg_this, upgrade = x$upgrade, build_opts = getDefaultBuildOpts(remotes::install_git, "remotes"))
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
  }

  return(rupdate_result(x, pkgs_df, TRUE))
}

#' Upload package to winbuilder
#'
#' @description
#' Uploads a package located in \code{path} to the winbuilder service. Uses
#' \code{\link[devtools]{build_win}} internally.
#'
#' @template path
#' @param devel [\code{logical(1)}]\cr
#'  Upload to check against the R-devel branch instead of the stable branch.
#' @param oldrelease [\code{logical(1)}]\cr
#'  Upload to check against the R-oldrelease branch instead of the stable branch.
#' @template return-itrue
#' @export
rwinbuild = function(path = getwd(), devel = FALSE, oldrelease = FALSE) {
  pkg = devtools::as.package(path, create = FALSE)
  assertFlag(devel)
  assertFlag(oldrelease)
  if (devel && oldrelease) {
    stop("Just enable devel OR oldrelease at the same time.")
  }

  maintainer = getOption("rt.maintainer", NULL)
  if (!is.null(maintainer)) {
    desc = read.dcf(file.path(pkg$path, "DESCRIPTION"))
    if ("Maintainer" %in% colnames(desc)) {
      desc[1L, "Maintainer"] = maintainer
    } else {
      desc = cbind(desc, Maintainer = maintainer)
    }

    path = tempfile("tmp-package")
    if (!dir.create(path, recursive = TRUE) || !file.copy(pkg$path, path, recursive = TRUE))
      stop(sprintf("Unable to copy package to %s", path))
    pkg = devtools::as.package(file.path(path, basename(pkg$path)), create = FALSE)
    write.dcf(desc, file = file.path(pkg$path, "DESCRIPTION"))
  }

  messagef("Building package '%s' in '%s' and uploading to the winbuilder", pkg$package, pkg$path)
  updatePackageAttributes(pkg)
  if (devel) {
    devtools::check_win_devel(pkg)
  } else if (oldrelease) {
    devtools::check_win_oldrelease(pkg)
  } else {
    devtools::check_win_release(pkg)
  }
}

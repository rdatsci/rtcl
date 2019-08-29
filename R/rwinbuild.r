#' Upload package to winbuilder
#'
#' @description
#' Uploads a package located in \code{path} to the winbuilder service.
#' Uses \code{\link[devtools:check_win]{check_win_release}}, \code{\link[devtools:check_win]{check_win_devel}}
#' or \code{\link[devtools:check_win]{check_win_oldrelease}} internally.
#'
#' @template path
#' @param devel [\code{logical(1)}]\cr
#'  Upload to check against the R-devel branch instead of the stable branch.
#' @param oldrel [\code{logical(1)}]\cr
#'  Upload to check against the R-oldrelease branch instead of the stable branch.
#' @template return-itrue
#' @export
rwinbuild = function(path = getwd(), devel = FALSE, oldrel = FALSE) {
  pkgname = pkgload::pkg_name(path = path)
  pkgdir = pkgload::pkg_path(path = path)

  assertFlag(devel)
  assertFlag(oldrel)
  if (devel && oldrel) {
    stop("Just enable devel OR oldrel at the same time.")
  }

  pkgdir = changeMaintainer(pkgdir)

  messagef("Building package in '%s' and uploading to winbuilder", pkgdir)

  if (devel) {
    devtools::check_win_devel(pkgdir)
  } else if (oldrel) {
    devtools::check_win_oldrelease(pkgdir)
  } else {
    devtools::check_win_release(pkgdir)
  }
}

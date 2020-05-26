#' Upload package to rhub
#'
#' @description
#' Uploads a package located in \code{path} to the rhub service via \code{\link[rhub]{check}}.
#'
#' @param platform [\code{character(1)}]\cr
#'   Check on the platform specified here. For details see \code{\link[rhub]{platforms}}
#' @param checkforcran [\code{logical(1L)}]\cr
#'   Use \code{\link[rhub]{check_for_cran}} instead.
#' @param rdevel [\code{logical(1L)}]\cr
#'   Use \code{\link[rhub]{check_with_rdevel}} instead. This switch is only taken into account 
#'   with \code{checkforcran = FALSE}. It automatically selects one devel platform.
#' @template path
#' @template return-itrue
#' @export
rhub = function(platform = NULL, checkforcran = FALSE, rdevel = FALSE, path = getwd()) {
  requireNamespace("rhub")
  assertSubset(platform, rhub::platforms()$name)
  assertFlag(checkforcran)
  assertFlag(rdevel)

  pkgpath = pkgload::pkg_path(path = path)
  pkgpath = changeMaintainer(pkgpath)

  if (checkforcran) {
    rhub::check_for_cran(pkgpath, platform = platform)
  } else {
    if (rdevel) {
      rhub::check_with_rdevel(path = pkgpath)
    } else {
      rhub::check(pkgpath, platform = platform)
    }
  }
}

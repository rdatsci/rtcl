#' Upload package to rhub
#'
#' @description
#' Uploads a package located in \code{path} to the rhub service via \code{link[rhub]{check}}.
#'
#' @param platform [\code{character(1)}]\cr
#'   Check on the platform specified here.
#' @param checkforcran [\code{logical(1L)}]\cr
#'   Use \code{link[rhub]{check_for_cran}} instead.
#' @template path
#' @template return-itrue
#' @export
rhub = function(platform = NULL, checkforcran = FALSE, path = getwd()) {
  requireNamespace("rhub")
  assertFlag(checkforcran)
  assertSubset(platform, rhub::platforms()$name)

  pkgpath = pkgload::pkg_path(path = path)
  if (checkforcran) {
    rhub::check_for_cran(pkgpath, platform = platform)
  } else {
    rhub::check(pkgpath, platform = platform)
  }
}

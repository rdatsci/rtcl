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
  if (!requireNamespace("rhub"))
    stop("Install 'rhub' to use rhub")
  assertFlag(checkforcran)
  pkg = devtools::as.package(path, create = FALSE)
  assertSubset(platform, rhub::platforms()$name)
  
  if (checkforcran) {
    rhub::check_for_cran(pkg$path, platform = platform)
  } else {
    rhub::check(pkg$path, platform = platform)
  }
}

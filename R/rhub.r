#' Upload package to rhub
#'
#' @description
#' Uploads a package located in \code{path} to the rhub service.
#'
#' @template path
#' @param platform [\code{character(1)}]\cr
#'  Check on the platform specified here.
#' @template return-itrue
#' @export
rhub = function(path = getwd(), platform) {
  if (!requireNamespace("rhub"))
    stop("Install 'rhub' to use rhub")
  pkg = devtools::as.package(path, create = FALSE)
  assertSubset(platform, rhub::platforms()$name)

  rhub::check(pkg$path, platform = platform)
}

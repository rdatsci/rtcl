#' Build vignettes
#'
#' @description
#' Build vignettes of the package located in \code{path} using \code{\link[devtools]{build_vignette}}.
#'
#' @template path
#' @template return-itrue
#' @export
rvignettes = function(path = getwd()) {
  pkg = devtools::as.package(path, create = FALSE)
  messagef("Building vignettes for package '%s' ...", pkg$package)
  devtools::clean_vignettes(pkg)
  devtools::build_vignettes(pkg)
  invisible(TRUE)
}

#' Remove temporary files from a package
#'
#' @description
#' Cleanup temporary files for a package located in \code{path} using \code{link[pkgbuild]{clean_dll}}.
#'
#' @template path
#' @template return-itrue
#' @export
rclean = function(path = getwd()) {
  messagef("Cleaning package '%s'", pkgload::pkg_name(path = path))
  pkgbuild::clean_dll(pkg)
  invisible(TRUE)
}

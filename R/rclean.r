#' Remove temporary files from a package
#'
#' @description
#' Cleanup temporary files for a package located in \code{path} using \code{link[devtools]{check}}.
#'
#' @template path
#' @template return-itrue
#' @export
rclean = function(path = getwd()) {
  pkg = devtools::as.package(path)
  messagef("Cleaning package '%s' ...", pkg$package)
  devtools::clean_dll(pkg)
  invisible(TRUE)
}

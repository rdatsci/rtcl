#' Check variable usage
#'
#' @description
#' Checks the package using \code{link[codetools]{checkUsagePackage}}
#'
#' @template path
#' @template return-itrue
#' @export
rusage = function(path = getwd()) {
  pkg = devtools::as.package(path, create = FALSE)
  devtools::load_all(pkg)

  codetools::checkUsagePackage(pkg$package)
  invisible(TRUE)
}

#' Check variable usage
#'
#' @description
#' Checks the package using \code{link[codetools]{checkUsagePackage}}
#'
#' @template path
#' @template return-itrue
#' @export
rusage = function(path = getwd()) {
  pkgload::load_all(path = path)
  requireNamespace("codetools")

  messagef("Checking usage for package '%s' ...", pkgload::pkg_name(path))
  codetools::checkUsagePackage(pkgload::pkg_name(path))
  invisible(TRUE)
}

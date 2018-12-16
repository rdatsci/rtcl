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

  if (!requireNamespace("codetools"))
    stop("Please install package 'codetools'")

  messagef("Checking usage for package '%s' ...", pkg$package)
  codetools::checkUsagePackage(pkg$package)
  invisible(TRUE)
}

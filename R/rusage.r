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

  if (!requireNamespace("codetools"))
    stop("Please install package 'codetools'")

  messagef("Checking usage for package '%s' ...", pkg$package)
  codetools::checkUsagePackage(pkg$package)
  invisible(TRUE)
}

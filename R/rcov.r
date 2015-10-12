#' Test the coverage of a package
#'
#' @description
#' Uses the \code{covr} package (\url{https://github.com/jimhester/covr}) to
#' test the code coverage.
#'
#' @template path
#' @template return-itrue
#' @export
rcov = function(path = getwd(), shine = FALSE) {
  pkg = devtools::as.package(path, create = FALSE)
  messagef("Checking code coverage of package '%s' ...", pkg$package)
  coverage = covr::package_coverage(pkg)
  print(coverage)
  if (shine)
    covr::shine(coverage)
  invisible(TRUE)
}

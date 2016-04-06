#' Test the coverage of a package
#'
#' @description
#' Uses the \code{covr} package (\url{https://github.com/jimhester/covr}) to
#' test the code coverage.
#'
#' @template path
#' @param shine [\code{logical(1)}]\cr
#'  Use the function \code{link[covr]{shine}} to display the coverage information.
#' @template return-itrue
#' @export
rcov = function(path = getwd(), shine = FALSE) {
  pkg = devtools::as.package(path, create = FALSE)

  if (!requireNamespace("covr"))
    stop("Please install package 'covr'")

  messagef("Checking code coverage of package '%s' ...", pkg$package)
  coverage = covr::package_coverage(pkg$path)
  print(coverage)
  if (shine)
    covr::shine(coverage)
  invisible(TRUE)
}

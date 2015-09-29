#' Test the coverage of a package
#'
#' @description
#' Uses the \code{covr} package (\url{https://github.com/jimhester/covr}) to
#' test the code coverage.
#'
#' @template path
#' @template return-itrue
#' @export
rcov = function(path = getwd()) {
  pkg = devtools::as.package(path, create = FALSE)
  messagef("Checking code coverage of package '%s' ...", pkg$package)
  found = length(find.package("covr", quiet = TRUE)) > 0L
  if (!found) {
    messagef("Installing missing GitHub package 'covr' ...")
    rinstall("jimhester/covr")
  }
  requireNamespace("covr", quietly = TRUE)
  print(covr::package_coverage(pkg))
  invisible(TRUE)
}

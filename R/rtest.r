#' @title
#'  Run unit tests for a package
#'
#' @description
#'  Tests a package located in \code{path} using tests in \code{tests/testthat} via
#'  \code{\link[testthat]{test_dir}}.
#'
#' @template path
#' @param filter [\code{character(1)}]\cr
#'  Filter tests (on a file name basis) using this pattern.
#'  Default is \dQuote{NULL}, which means no filter is applied.
#' @template return-itrue
#' @export
rtest = function(path = getwd(), filter = NULL) {
  path = pkgload::pkg_path(path)
  pkgname = pkgload::pkg_name(path)
  updatePackageAttributes(path = path)

  messagef("Testing package '%s'", pkgname)
  assertString(filter, null.ok = TRUE)
  testpath = file.path(path, "tests", "testthat")
  res = as.data.frame(testthat::test_dir(path = testpath, filter = coalesceString(filter)))
  if (sum(res$failed) > 0) {
    return(invisible(FALSE))
  } else {
    return(invisible(TRUE))
  }
}

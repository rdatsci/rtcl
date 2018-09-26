#' @title
#'  Run unit tests for a package
#'
#' @description
#'  Tests a package located in \code{path} using \code{\link[devtools]{test}}.
#'
#' @template path
#' @param filter [\code{FALSE} || \code{character(1)}]\cr
#'  Filter tests (on a file name basis) using this pattern.
#' @template return-itrue
#' @export
rtest = function(path = getwd(), filter = FALSE) {
  updatePackageAttributes(path = path)
  pkgname = pkgload::pkg_name(path = path)
  
  messagef("Testing package '%s'", pkgname)
  if (identical(filter, FALSE)) {
    filter = NULL
  } else {
    assertString(filter)
  }
  testpath = file.path(path, "tests", "testthat")
  res = as.data.frame(testthat::test_dir(path = testpath, filter = filter))
  if (sum(res$failed) > 0) {
    return(invisible(FALSE))
  } else {
    return(invisible(TRUE))
  }
}

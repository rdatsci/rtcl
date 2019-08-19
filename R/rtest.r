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
  assertString(filter, null.ok = TRUE)

  path = pkgload::pkg_path(path)
  pkgname = pkgload::pkg_name(path)
  updatePackageAttributes(path = path)
  framework = getTestFramework(path)

  messagef("Testing package '%s' with %s", pkgname, framework)

  if (framework == "testthat") {
    testpath = file.path(path, "tests", "testthat")
    res = as.data.frame(testthat::test_dir(path = testpath, filter = coalesceString(filter)))
    ret = sum(res$failed) == 0L
  } else {
    testpath = file.path(path, "inst", "tinytest")
    res = tinytest::run_test_dir(testpath, pattern = coalesceString(filter, "^test.*\\.[rR]"))
    ret = all(sapply(res, isTRUE))
  }

  invisible(ret)
}

getTestFramework = function(path) {
  suggests = read.dcf(file.path(path, "DESCRIPTION"), fields = "Suggests", keep.white = FALSE)
  if (is.na(suggests))
    return("testthat")
  suggests = trimws(strsplit(suggests, split = ",", fixed = TRUE)[[1L]])
  if ("tinytest" %in% suggests) "tinytest" else "testthat"
}

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
    testpath =
    args = list(dir = file.path(path, "inst", "tinytest"))
    if (!is.null(coalesceString(filter)))
      args$filter = filter
    res = do.call(tinytest::run_test_dir, args)
    ret = all(sapply(res, isTRUE))
  }

  invisible(ret)
}

getTestFramework = function(path) {
  pkgs = read.dcf(file.path(path, "DESCRIPTION"), fields = c("Imports", "Suggests"), keep.white = FALSE)
  pkgs = paste(pkgs[!is.na(pkgs)], collapse = ",")
  pkgs = trimws(strsplit(pkgs, split = ",", fixed = TRUE)[[1L]])
  if ("tinytest" %in% pkgs) "tinytest" else "testthat"
}

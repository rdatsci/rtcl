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
  pkg = devtools::as.package(path, create = FALSE)
  messagef("Testing package '%s' ...", pkg$package)
  if (identical(filter, FALSE)) {
    filter = NULL
  } else {
    assertString(filter)
  }
  res = as.data.frame(devtools::test(pkg, filter = filter))
  if (sum(res$failed) > 0) {
    return(invisible(FALSE))
  } else {
    return(invisible(TRUE))
  }
}

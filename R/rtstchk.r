#' Run unit tests and check a package
#'
#' @description
#'  First test than check a package located in \code{path}
#'  using \code{\link[testthat]{test}} and \code{link[rcmdcheck]{rcmdcheck}}.
#'
#' @template path
#' @template return-itrue
#' @export
rtstchk = function(path = getwd()) {
  if (!rtest(path)) {
    messagef("Unit test(s) failed. Check canceled.")
    return(invisible(FALSE))
  }
  invisible(rcheck(path))
}

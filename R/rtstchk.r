#' Run unit tests and check a package
#'
#' @description
#'  First test than check a package located in \code{path}
#'  using \code{\link[devtools]{test}} and \code{link[devtools]{check}}.
#'
#' @template path
#' @template return-itrue
#' @export
rtstchk = function(path = getwd()) {
  if (!rtest(path)) {
    messagef("Unit test(s) failed. Check canceled.")
    return(invisible(FALSE))
  }
  if (!rcheck(path)) {
    messagef("Check failed.")
    return(invisible(FALSE))
  }
  invisible(TRUE)
}

#' Check a package
#'
#' @description
#' Check a package located in \code{path} using \code{\link[rcmdcheck]{rcmdcheck}}.
#'
#' @template path
#' @param cleanup [\code{logical(1L)}]\cr
#'   Clean up the log directory, even if check failed or issued warnings. Default is \code{FALSE}.
#' @template return-itrue
#' @export
rcheck = function(path = getwd(), cleanup = FALSE) {
  updatePackageAttributes(path = path)
  pkgname = pkgload::pkg_name(path = path)

  now = strftime(Sys.time(), format = "%Y%m%d-%H%M%S")
  log.path = file.path(dirname(tempdir()), sprintf("rcheck-%s-%s", pkgname, now))
  dir.create(log.path, recursive = TRUE)
  messagef("Checking package '%s':", pkgname)
  res = FALSE
  res = try(rcmdcheck::rcmdcheck(path = path, check_dir = log.path))
  if (cleanup) {
    if (file.exists(log.path)) unlink(log.path, recursive = TRUE)
    messagef("You ran 'rcheck --cleanup'. Logfiles are deleted.")
  }
  if (length(res$test_fail) > 0) {
    return(invisible(FALSE))
  } else {
    return(invisible(TRUE))
  }
}

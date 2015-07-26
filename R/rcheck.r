#' Check a package
#'
#' @description
#' Check a package located in \code{path} using \code{link[devtools]{check}}..
#'
#' @template path
#' @param nocleanup [\code{logical(1L)}]\cr
#'   Do not clean up the log directory. Default is \code{FALSE}.
#' @template return-itrue
#' @export
rcheck = function(path = getwd(), nocleanup = FALSE) {
  Sys.setenv(R_MAKEVARS_USER = system.file("Makevars-template", package = "rt"))
  on.exit(Sys.unsetenv("R_MAKEVARS_USER"))
  pkg = devtools::as.package(path)
  now = strftime(Sys.time(), format = "%Y%m%d-%H%M%S")
  log.path = file.path(dirname(tempdir()), sprintf("rcheck-%s-%s", pkg$package, now))
  dir.create(log.path, recursive = TRUE)
  messagef("Checking package '%s' ...", pkg$package)
  devtools::check(pkg, check_dir = log.path, cleanup = !nocleanup)
  invisible(TRUE)
}

#' Check a package
#'
#' @description
#' Check a package located in \code{path} using \code{link[devtools]{check}}..
#'
#' @template path
#' @param cleanup [\code{logical(1L)}]\cr
#'   Clean up the log directory, even if check failed or issued warnings. Default is \code{FALSE}.
#' @template return-itrue
#' @export
rcheck = function(path = getwd(), cleanup = FALSE) {
  pkg = devtools::as.package(path, create = FALSE)
  if (!is.null(pkg$roxygennote)) {
    messagef("Updating documentation for '%s'", pkg$package)
    devtools::document(pkg)
  }

  Sys.setenv(R_MAKEVARS_USER = system.file("Makevars-template", package = "rt"))
  on.exit(Sys.unsetenv("R_MAKEVARS_USER"))
  now = strftime(Sys.time(), format = "%Y%m%d-%H%M%S")
  log.path = file.path(dirname(tempdir()), sprintf("rcheck-%s-%s", pkg$package, now))
  dir.create(log.path, recursive = TRUE)
  messagef("Checking package '%s' ...", pkg$package)
  res = FALSE
  res = try(devtools::check(pkg, check_dir = log.path))
  if (cleanup) {
    if (file.exists(log.path)) unlink(log.path, recursive = TRUE)
    messagef("You ran 'rcheck --cleanup'. Logfiles are deleted.")
  }
  invisible(res)
}

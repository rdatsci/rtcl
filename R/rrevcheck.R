#' Make and install a package
#'
#' @description
#' Updates the documentation and then installs the package located at \code{path}, using
#' \code{link[devtools]{document}}, \code{link[devtools]{install_deps}} and \code{link[devtools]{install}}.
#'
#' @template path
#' @param deps [\code{logical(1)}]\cr
#' Also install all dependencies, including suggests? Default is \code{FALSE}.
#' @template return-itrue
#' @export

# FIXME: maybe we want to clean up all files?
# FIXME: maybe out some summary?
# FIXME:  we need to make sure we run all checks for all packs and dont stop on error

rrevcheck = function(path = getwd(), check.logs = NULL) {
  pkg = devtools::as.package(path, create = FALSE)

  if (is.null(check.logs)) {
    check.logs = file.path("/tmp", sprintf("%s.revchecks", basename(path)))
    unlink(check.logs, recursive = TRUE)
    dir.create(check.logs)
  } else {
    dir.create(check.logs)
  }

  rdeps = devtools::revdep(pkg)

  messagef("Running reverse checks for:\n%s", collapse(rdeps))
  messagef("Logs for package checks are in: %s", check.logs)

  for (p in rdeps) {
    messagef("Starting reverse check for: %s", p)
    tmppath = file.path("/tmp", p)
    messagef("Removing path (if exists): %s", tmppath)
    unlink(tmppath, recursive = TRUE)
    rclone(p, temp = TRUE)
    messagef("Making sure dependencies are avail for: %s", p)
    devtools::install_deps(tmppath)
    system2("R", c("CMD", "build", tmppath))
    check.logoption = sprintf("-o %s", check.logs)
    system2("R", c("CMD", "check", "--as-cran", "--no-clean", check.logoption, paste0(p, "*.tar.gz")))
  }
}


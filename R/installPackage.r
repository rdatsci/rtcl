installPackage = function(pkg, ...) {
  UseMethod("installPackage")
}

#' @export
installPackage.default = function(pkg, ...) {
  installPackage(stringToPackage(pkg))
}

#' @export
installPackage.LocalPackage = function(pkg, ...) {
  rmake(pkg$uri, deps = TRUE)
}

#' @export
installPackage.CranPackage = function(pkg, ...) {
  messagef("Installing cran package '%s' ...", pkg$name)
  install.packages(pkg$name, lib = getLibraryPath(), INSTALL_opts = getOption("devtools.install.args"))
}

#' @export
installPackage.GitPackage = function(pkg, temp = TRUE, force = FALSE, quick = TRUE, ...) {
  path = if (temp) file.path(tempdir(), pkg$name) else file.path("~", ".rt", "git", pkg$name)
  path = normalizePath(path, mustWork = FALSE)
  pkg.path = if (is.na(pkg$subdir)) path else file.path(path, pkg$subdir)
  cli = getOption("rt.cli", FALSE)
  if (!dir.exists(path)) {
    messagef("Fetching and installing new git package '%s' ...", pkg$name)
    dir.create(path, recursive = TRUE)
    branch = if (!is.na(pkg$tag)) pkg$tag else NULL
    git2r::clone(pkg$uri, local_path = path, progress = FALSE, branch = branch)
    devtools::install(pkg.path, reload = !cli, quick = quick, keep_source = FALSE)
  } else {
    messagef("Updating git package '%s' ...", packageToString(pkg))
    repo = git2r::repository(path)
    fetched = git2r::fetch(repo, "origin")
    if (force || fetched@total_objects > 0L) {
      git2r::pull(repo)
      devtools::install(pkg = pkg.path, reload = !cli, quick = quick, keep_source = FALSE)
    }
  }
}

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
  cli = getOption("rt.cli", FALSE)
  if (temp) {
    pkg = stringToPackage("r-lib/withr")
    devtools::install_git(stri_replace_first_regex(pkg$uri, "^https://", "git://"), reload = !cli, quick = quick, keep_source = FALSE)
  } else {
    path = normalizePath(file.path("~", ".rt", "git", pkg$name), mustWork = FALSE)
    pkg.path = if (is.na(pkg$subdir)) path else file.path(path, pkg$subdir)
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
}

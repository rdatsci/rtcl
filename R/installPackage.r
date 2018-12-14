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
  install.packages(pkg$name, lib = getLibraryPath())
}

#' @export
installPackage.GitPackage = function(pkg, temp = TRUE, force = FALSE, ...) {
  if (temp) {
    pkg = stringToPackage(pkg)
    remotes::install_git(url = stri_replace_first_regex(pkg$uri, "^https://", "git://"))
  } else {
    path = normalizePath(file.path("~", ".rt", "git", pkg$name), mustWork = FALSE)
    pkg.path = if (is.na(pkg$subdir)) path else file.path(path, pkg$subdir)
    if (!dir.exists(path)) {
      messagef("Fetching and installing new git package '%s' ...", pkg$name)
      dir.create(path, recursive = TRUE)
      branch = if (!is.na(pkg$tag)) pkg$tag else NULL
      git2r::clone(pkg$uri, local_path = path, progress = FALSE, branch = branch)
      remotes::install_local(path = pkg.path, force = TRUE)
    } else {
      messagef("Updating git package '%s' ...", packageToString(pkg))
      repo = git2r::repository(path)
      fetched = git2r::fetch(repo, "origin")
      if (force || fetched$total_objects > 0L) {
        git2r::pull(repo)
        remotes::install_local(path = pkg.path, force = TRUE)
      }
    }
  }
}

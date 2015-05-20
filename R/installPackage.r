installPackage = function(pkg) {
  UseMethod("installPackage")
}

#' @export
installPackage.default = function(pkg) {
  installPackage(stringToPackage(pkg))
}

#' @export
installPackage.LocalPackage = function(pkg) {
  devtools::install(pkg$uri)
}

#' @export
installPackage.CranPackage = function(pkg) {
  messagef("Installing cran package '%s' ...", pkg$name)
  install.packages(pkg$name, lib = getLibraryPath())
}

#' @export
installPackage.GitPackage = function(pkg) {
  path = normalizePath(file.path("~", ".rt", "git", pkg$name), mustWork = FALSE)
  if (!dir.exists(path)) {
    messagef("Fetching and installing new git package '%s' ...", pkg$name)
    dir.create(path, recursive = TRUE)
    git2r::clone(pkg$uri, local_path = path, progress = FALSE)
    devtools::install(path)
  } else {
    messagef("Updating git package '%s' ...", packageToString(pkg))
    repo = git2r::repository(path)
    fetched = git2r::fetch(repo, "origin")
    if (fetched@total_objects > 0L) {
      git2r::pull(repo)
      devtools::install(pkg = path)
    }
  }
}

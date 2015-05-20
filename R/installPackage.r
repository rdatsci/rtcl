installPackage = function(pkg) {
  UseMethod("installPackage")
}

#' @export
installPackage.default = function(pkg) {
  installPackage(stringToPackage(pkg))
}

#' @export
installPackage.LocalPackage = function(pkg) {
  cli = getOption("rt.cli", FALSE)
  devtools::install(pkg$uri, reload = !cli)
}

#' @export
installPackage.CranPackage = function(pkg) {
  messagef("Installing cran package '%s' ...", pkg$name)
  install.packages(pkg$name, lib = getLibraryPath())
}

#' @export
installPackage.GitPackage = function(pkg) {
  path = normalizePath(file.path("~", ".rt", "git", pkg$name), mustWork = FALSE)
  cli = getOption("rt.cli", FALSE)
  lib = getLibraryPath()
  if (!dir.exists(path)) {
    messagef("Fetching and installing new git package '%s' ...", pkg$name)
    dir.create(path, recursive = TRUE)
    git2r::clone(pkg$uri, local_path = path, progress = FALSE)
    devtools::install(path, reload = !cli, quick = TRUE, keep_source = FALSE, lib = lib)
  } else {
    messagef("Updating git package '%s' ...", packageToString(pkg))
    repo = git2r::repository(path)
    fetched = git2r::fetch(repo, "origin")
    if (fetched@total_objects > 0L) {
      git2r::pull(repo)
      devtools::install(pkg = path, reload = !cli, quick = TRUE, keep_source = FALSE, lib = lib)
    }
  }
}

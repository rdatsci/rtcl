installPackage = function(pkg, ...) {
  UseMethod("installPackage")
}

#' @export
installPackage.default = function(pkg, ...) {
  installPackage(stringToPackage(pkg))
}

#' @export
installPackage.LocalPackage = function(pkg, ...) {
  rmake(pkg$uri)
}

#' @export
installPackage.CranPackage = function(pkg, ...) {
  messagef("Installing cran package '%s' ...", pkg$name)
  remotes::install_cran(pkg$name, lib = getLibraryPath())
}

#' @export
installPackage.GitPackage = function(pkg, force = FALSE, ...) {
  pkg = stringToPackage(pkg)
  remotes::install_git(url = pkg$uri, force = force)
}

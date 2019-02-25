installPackage = function(pkg, ...) {
  UseMethod("installPackage")
}

#' @export
installPackage.default = function(pkg, ...) {
  installPackage(stringToPackage(pkg), ...)
}

#' @export
installPackage.PackageLocal = function(pkg, ...) {
  remotes::install_local(path = pkg$file_path, ...)
}

#' @export
installPackage.PackageCran = function(pkg, ...) {
  remotes::install_cran(pkg$name, ...)
}

#' @export
installPackage.PackageGit = function(pkg, ...) {
  remotes::install_git(url = pkg$repo, ref = nanz2null(pkg$ref), subdir = nanz2null(pkg$subdir), ...)
}

#' @export
installPackage.PackageGitHub = function(pkg, ...) {
  remotes::install_github(repo = pkg$handle, ...)
}

#' @export
installPackage.PackageGitLab = function(pkg, ...) {
  remotes::install_gitlab(repo = pkg$handle, host = pkg$host, ...)
}

#' @export
installPackage.PackageBitbucket = function(pkg, ...) {
  remotes::install_bitbucket(repo = pkg$handle, ...)
}

#' @export
installPackage.PackageBioc = function(pkg, ...) {
  remotes::install_bioc(repo = pkg$handle, ...)
}

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
  remotes::install_git(url = pkg$repo, ref = coalesceString(pkg$ref), subdir = coalesceString(pkg$subdir), ...)
}

#' @export
installPackage.PackageGitHub = function(pkg, ...) {
  remotes::install_github(repo = pkg$handle, ...)
}

#' @export
installPackage.PackageGitLab = function(pkg, ...) {
  remotes::install_gitlab(repo = pkg$handle, host = coalesceString(pkg$host, "gitlab.com"), ...)
}

#' @export
installPackage.PackageBitbucket = function(pkg, ...) {
  remotes::install_bitbucket(repo = pkg$handle, ...)
}

#' @export
installPackage.PackageBioc = function(pkg, ...) {
  remotes::install_bioc(repo = pkg$handle, ...)
}

installPackage = function(pkg, ...) {
  UseMethod("installPackage")
}

#' @export
installPackage.default = function(pkg, ...) {
  installPackage(stringToPackage(pkg), ...)
}

#' @export
installPackage.PackageLocal = function(pkg, ...) {
  remotes::install_local(path = pkg$file_path, build_opts = getDefaultBuildOpts(remotes::install_local, "local"), ...)
}

#' @export
installPackage.PackageCran = function(pkg, ...) {
  remotes::install_cran(pkg$name, build_opts = getDefaultBuildOpts(remotes::install_cran, "cran"), ...)
}

#' @export
installPackage.PackageGit = function(pkg, ...) {
  remotes::install_git(url = pkg$repo, ref = coalesceString(pkg$ref), subdir = coalesceString(pkg$subdir), build_opts = getDefaultBuildOpts(remotes::install_git, "git"), ...)
}

#' @export
installPackage.PackageGitHub = function(pkg, ...) {
  remotes::install_github(repo = pkg$handle, build_opts = getDefaultBuildOpts(remotes::install_github, "git"), ...)
}

#' @export
installPackage.PackageGitLab = function(pkg, ...) {
  remotes::install_gitlab(repo = pkg$handle, host = coalesceString(pkg$host, "gitlab.com"), build_opts = getDefaultBuildOpts(remotes::install_gitlab, "git"), ...)
}

#' @export
installPackage.PackageBitbucket = function(pkg, ...) {
  remotes::install_bitbucket(repo = pkg$handle, build_opts = getDefaultBuildOpts(remotes::install_bitbucket, "git"), ...)
}

#' @export
installPackage.PackageBioc = function(pkg, ...) {
  remotes::install_bioc(repo = pkg$handle, build_opts = getDefaultBuildOpts(remotes::install_bioc, "bioc"), ...)
}

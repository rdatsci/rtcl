#' Clone a package
#'
#' @description
#' Clones a package from GitHub.
#' Also works for CRAN packages (CRAN mirror is used in this case, \url{http://cran.github.io/}).
#' Great to have a quick peek with your favorite editor or to grep package sources.
#'
#' @param pkg [\code{character(1)}]\cr
#'  String interpretable by \code{\link{stringToPackage}}.
#' @param temp [\code{logical(1)}]\cr
#'  Clone to temp directory instead of current working directory?
#'  Default is \code{FALSE}.
#' @template return-itrue
#' @export
rclone = function(pkg, temp = FALSE) {
  pkg = stringToPackage(pkg)
  assertFlag(temp)

  # retrieve cran packages from github
  if (pkg$type == "cran") {
    pkg = GitHubPackage(name = pkg$name, repo = sprintf("cran/%s", pkg$name))
  } else if (pkg$type == "local") {
    stop("Cannot clone local repositories")
  }

  dest = if (temp) dirname(tempdir()) else getwd()
  dest = file.path(dest, pkg$name)

  messagef("Cloning '%s' to '%s'", pkg$name, dest)
  git2r::clone(pkg$uri, dest, progress = FALSE)
}

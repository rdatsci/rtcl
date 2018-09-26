#' Build a package
#'
#' @description
#' Build a package located in \code{path} using \code{link[pkgbuild]{build}}.
#'
#' @template path
#' @template return-itrue
#' @export
rbuild = function(path = getwd()) {
  loc = pkgbuild::build(path)

  messagef("The package has been bundled to '%s'.", normalizePath(loc))
  invisible(TRUE)
}

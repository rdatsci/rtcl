#' Build a package
#'
#' @description
#' Build a package located in \code{path} using \code{link[devtools]{build}}.
#'
#' @template path
#' @template return-itrue
#' @export
rbuild = function(path = getwd()) {
  
  # support of current CRAN and GitHub version needs loop way devtools
  # use pkgbuild directly, when released on CRAN
  # loc = pkgbuild::build(path)
  loc = devtools::build(path)

  messagef("The package has been bundled to '%s'.", normalizePath(loc))
  invisible(TRUE)
}

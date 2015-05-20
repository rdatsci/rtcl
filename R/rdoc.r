#' Create documentation for a package
#'
#' @description
#' Documents a package located in \code{path} using \code{\link[roxygen2]{roxygen-package}}
#' or rather \code{link[devtools]{document}}.
#'
#' @template path
#' @template return-itrue
#' @export
rdoc = function(path = getwd()) {
  pkg = devtools::as.package(path)
  messagef("Documenting package '%s' ...", pkg$package)
  devtools::document(pkg)
  invisible(TRUE)
}

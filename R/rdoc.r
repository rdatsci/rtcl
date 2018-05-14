#' Create documentation for a package
#'
#' @description
#' Documents a package located in \code{path} using \code{\link[roxygen2]{roxygen2-package}}
#' or rather \code{link[devtools]{document}}.
#'
#' @template path
#' @template return-itrue
#' @export
rdoc = function(path = getwd()) {
  pkg = devtools::as.package(path, create = FALSE)
  updatePackageAttributes(pkg)

  invisible(TRUE)
}

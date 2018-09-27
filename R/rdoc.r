#' Create documentation for a package
#'
#' @description
#' Documents a package located in \code{path} using \code{\link[roxygen2]{roxygen2-package}}.
#'
#' @template path
#' @template return-itrue
#' @export
rdoc = function(path = getwd()) {
  updatePackageAttributes(path = path)
  
  invisible(TRUE)
}

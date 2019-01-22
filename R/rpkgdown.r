#' Create static documentation with pkgdown
#'
#' @description
#' Build static documentation with \url{https://github.com/hadley/pkgdown} in the
#' \dQuote{doc} subdirectory of the package root.
#'
#' @template path
#' @template return-itrue
#' @export
rpkgdown = function(path = getwd()) {
  path = pkgload::pkg_path(path = path)
  requireNamespace("pkgdown")

  messagef("Generating static docs in '%s'...", file.path(path, "docs"))
  pkgdown::build_site(pkgload::pkg_path(path), preview = FALSE)

  invisible(TRUE)
}

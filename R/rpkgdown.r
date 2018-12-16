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
  dest = file.path(pkgload::pkg_path(path = path), "docs")

  if (!requireNamespace("pkgdown"))
    stop("Please install package 'hadley/pkgdown'")

  messagef("Generating static docs in '%s'...", dest)
  pkgdown::build_site(pkg$path, preview = FALSE)

  invisible(TRUE)
}

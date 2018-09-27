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

  messagef("Removing old docs in '%s'", dest)
  if (dir.exists(dest))
    unlink(dest, recursive = TRUE)
  dir.create(dest)

  messagef("Generating static docs in '%s'", dest)
  pkgdown::build_site(pkg = path, preview = FALSE)

  invisible(TRUE)
}

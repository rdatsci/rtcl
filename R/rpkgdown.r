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
  pkg = devtools::as.package(path, create = FALSE)
  updatePackageAttributes(pkg)
  dest = file.path(pkg$path, "docs")


  if (!requireNamespace("pkgdown"))
    stop("Please install package 'hadley/pkgdown'")

  messagef("Removing old docs in '%s'...", dest)
  if (dir.exists(dest))
    unlink(dest, recursive = TRUE)
  dir.create(dest)

  messagef("Generating static docs in '%s'...", dest)
  pkgdown::build_site(pkg$path, preview = FALSE)

  invisible(TRUE)
}

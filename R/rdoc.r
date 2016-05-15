#' Create documentation for a package
#'
#' @description
#' Documents a package located in \code{path} using \code{\link[roxygen2]{roxygen-package}}
#' or rather \code{link[devtools]{document}}.
#'
#' @param staticdocs [\code{logical(1)}]\cr
#'  Also run \code{staticdocs} (\url{https://github.com/hadley/staticdocs}) on the
#'  generated man pages.
#' @template path
#' @template return-itrue
#' @export
rdoc = function(path = getwd(), staticdocs = FALSE) {
  pkg = devtools::as.package(path, create = FALSE)
  updatePackageAttributes(pkg)

  if (staticdocs) {
    if (!requireNamespace("staticdocs"))
      stop("Please install package 'hadley/staticdocs'")
    messagef("Generating static docs ...")
    staticdocs::build_site(pkg = pkg$path)
  }

  invisible(TRUE)
}

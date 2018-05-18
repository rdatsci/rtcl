#' Render a markdown document with rmarkdown
#'
#' @description
#' Calls \code{\link[rmarkdown]{render}} on a file.
#'
#' @param file [\code{character(1)}]\cr
#'   Document to render.
#' @param html [\code{logical(1)}]\cr
#'   \code{FALSE} (default), it generates a PDF.
#'   \code{TRUE}, the function will generate HTML output.
#' @template return-itrue
#' @export
rmarkdown = function(file, html = FALSE) {
  assertFileExists(file, extension = "Rmd", access = "r")
  assertFlag(html)
  if (!requireNamespace("rmarkdown"))
    stop("Please install package 'rmarkdown'")

  messagef("Rendering '%s' into %s ...", file, ifelse(html, "html", "pdf"))
  rmarkdown::render(file, output_format = ifelse(html, "html_document", "pdf_document"))

  invisible(TRUE)
}

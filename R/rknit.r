#' Knit a document with knitr
#'
#' @description
#' Calls \code{\link[knitr]{knit2pdf}} on a file.
#'
#' @param file [\code{character(1)}]\cr
#'   Document to knit.
#' @param html [\code{logical(1)}]\cr
#'   \code{FALSE} (default), it generates a PDF.
#'   \code{TRUE}, the function will generate HTML output.
#' @template return-itrue
#' @export
rknit = function(file, html = FALSE) {
  assertFileExists(file, extension = c("Rnw", "Rrst"), access = "r")
  assertFlag(html)
  if (!requireNamespace("knitr"))
    stop("Please install package 'knitr'")

  messagef("Knitting '%s' into %s ...", file, ifelse(html, "html", "pdf"))
  if (html) {
    knitr::knit2html(file)
  } else {
    knitr::knit2pdf(file)
  }

  invisible(TRUE)
}

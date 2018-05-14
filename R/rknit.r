#' Knit a document with knitr
#'
#' @description
#' Calls \code{\link[knitr]{knit2pdf}} on a file.
#'
#' @param file [\code{character(1)}]\cr
#'   Document to knit.
#' @template return-itrue
#' @export
rknit = function(file) {
  assertFileExists(file, extension = c("Rnw", "Rrst"), access = "r")
  if (!requireNamespace("knitr"))
    stop("Please install package 'knitr'")

  messagef("Knit to pdf '%s'...", file)
  knitr::knit2pdf(file)

  invisible(TRUE)
}

#' Compile an R markdown or R noweb (Sweave) document
#'
#' @description
#' Uses \code{rmarkdown} or \code{knitr} to compile its input argument
#' into an HTML or PDF file.
#'
#' @param files [\code{character}]\cr
#'  List of knitr (.Rnw, .Rrst) and Rmarkdown (.Rmd) files to compile.
#' @param html [\code{logical(1)}]\cr
#'  If \code{FALSE} (default), it generates a PDF.
#'  If \code{TRUE}, the function will generate HTML output.
#' @template return-itrue
#' @export
rcompile = function(files = character(0L), html = FALSE) {
  for (infile in files) {
    if (!testFileExists(infile, access = "r", extension = c("Rnw", "Rrst", "Rmd"))) {
      warning(sprintf("Skip file '%s'. Does it exist and has the extension 'Rnw', 'Rrst', or 'Rmd'?", infile))
      next
    }

    if (testFileExists(infile, extension = "Rmd")) {
      rmarkdown(infile, html)
    } else {
      rknit(infile, html)
    }
  }
  invisible(TRUE)
}

#' Compile an R markdown or R noweb (Sweave) document
#'
#' @description
#' Uses \code{rmarkdown} or \code{knitr} to compile its input argument
#' into an HTML or PDF file.
#'
#' @param files [\code{character}]\cr
#'  List of Sweave (.Rnw) and Rmarkdown (.Rmd) files to compile.
#' @param html [\code{logical(1)}]\cr
#'  If \code{TRUE}, the function will generate HTML output for Rmarkdown files.
#'  If \code{FALSE} (default), it generates a PDF.
#' @template return-itrue
#' @export
rcompile = function(files = character(0L), html = FALSE) {
  for (infile in files) {
    ext = tolower(stri_extract_last_regex(infile, "\\.[a-zA-Z0-9]+$"))
    ext = substr(ext, 2, nchar(ext))
    if (is.na(ext) || ext %nin% c("rmd", "rnw"))
      stop(sprintf("File extension for file '%s' not recognized. Must be either 'Rmd' or 'Rnw'", infile))

    if (ext == "rmd") {
      if (!requireNamespace("rmarkdown", quietly = TRUE))
        stop("To compile markdown, please install the package 'rmarkdown'")
      messagef("Compiling %s into %s ...", infile, ifelse(html, "html", "pdf"))
      rmarkdown::render(infile, output_format = ifelse(html, "html_document", "pdf_document"))
    } else {
      if (html)
        stop("Conversion from sweave to HTML is not supported")
      if (!requireNamespace("knitr", quietly = TRUE))
        stop("To compile sweave, please install the package 'knitr'")
      messagef("Knitting %s into pdf ...", infile)
      knitr::knit2pdf(infile)
    }
  }
  invisible(TRUE)
}

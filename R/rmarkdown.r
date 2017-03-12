#' Render a markdown document with rmarkdown
#'
#' @description
#' Calls \code{\link[rmarkdown]{render}} on a file.
#'
#' @param file [\code{character(1)}]\cr
#'   Document to render.
#' @template return-itrue
#' @export
rmarkdown = function(file) {
  assertFileExists(file, extension = "Rmd", access = "r")
  if (!requireNamespace("rmarkdown"))
    stop("Please install package 'rmarkdown")

  messagef("Rendering '%s'...", file)
  rmarkdown::render(file)

  invisible(TRUE)
}


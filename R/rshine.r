#' Run a shiny app
#'
#' @description
#' Runs a shiny app.
#'
#' @template path
#' @param port [\code{integer(1)}]\cr
#'   Port for \code{\link[shiny]{runApp}}.
#' @template return-itrue
#' @export
rshine = function(path = ".", port = 0L) {
  requireNamespace("shiny")

  if (!is.integer(port))
    port = as.integer(port)

  if (port == 0L) {
    shiny::runApp(path)
  } else {
    shiny::runApp(path, port = port)
  }
}

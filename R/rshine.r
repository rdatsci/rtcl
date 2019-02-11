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
rshine = function(path = ".", port = NULL) {
  requireNamespace("shiny")

  port = assertInt(port, null.ok = TRUE)

  if (is.null(port)) {
    shiny::runApp(path)
  } else {
    shiny::runApp(path, port = port)
  }
}

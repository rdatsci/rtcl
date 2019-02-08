cli.call = function(fun, doc, args = commandArgs(TRUE)) {
  fun = get(fun, mode = "function", envir = getNamespace("rt"))

  tryCatch({
    x = docopt::docopt(doc, args = args, strict = TRUE, quoted_args = TRUE)
  }, error = function(e) {
    cat(e$message, "\n", file = stderr())
    quit(save = "no", status = 1L)
  })

  x = x[!vlapply(x, is.null)]
  names(x) = sub(x = names(x), pattern = "--", replacement = "", fixed = TRUE)
  names(x) = gsub(x = names(x), pattern = "-", replacement = ".", fixed = TRUE)
  names(x) = gsub(x = names(x), pattern = "[()<>\\[\\]]", replacement = "", perl = TRUE)

  tryCatch({
    do.call(fun, x)
  },
  error = function(e) {
    cat(crayon::red(sprintf("Error: %s\n", e$message)), file = stderr())
    quit(save = "no", status = 2L)
  })

  quit(save = "no", status = 0L)
}

cli.call = function(fun, doc, args = commandArgs(TRUE)) {
  fun = get(fun, mode = "function", envir = getNamespace("rt"))
  options(rt.cli = TRUE)

  tryCatch({
    x = docopt::docopt(doc, args = args, strict = TRUE)
  }, error = function(e) {
    cat(e$message, "\n", file = stderr())
    quit(save = "no", status = 1L)
  })

  x = x[!vlapply(x, is.null)]
  names(x) = stri_replace_first_fixed(names(x), "--", "")
  names(x) = stri_replace_all_fixed(names(x), "-", ".")
  names(x) = stri_replace_all_regex(names(x), "[()<>\\[\\]]", "")

  tryCatch({
    do.call(fun, x)
  },
  error = function(e) {
    cat(crayon::red(sprintf("Error: %s\n", e$message)), file = stderr())
    quit(save = "no", status = 2L)
  })

  quit(save = "no", status = 0L)
}

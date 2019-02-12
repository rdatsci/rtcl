#' Maintainace operations for rt
#'
#' @param init [\code{logical(1)}]\cr
#'  Initialize for first use: create directory \code{\link{getConfigPath}} and
#'  create an empty package collection file \code{getConfigPath("packages")}.
#' @param edit [\code{logical(1)}]\cr
#'  Edit the \dQuote{packages} file?
#' @template return-itrue
rt = function(init = FALSE, edit = FALSE) {
  assertFlag(init)
  assertFlag(edit)

  if (init) {
    fn = getConfigPath("packages")
    dn = dirname(fn)
    if (!dir.exists(dn)) {
      dir.create(dn, recursive = TRUE)
      messagef("Created directory '%s'", dn)
    }
    if (!file.exists(fn)) {
      writeLines(c("## Uncomment to let rt update itself:", "# rdatsci/rt"), con = fn)
      messagef("Written initial collection file '%s'", fn)
    }
  }

  if (edit) {
    utils::file.edit(getConfigPath("packages"))
  }

  invisible(TRUE)
}

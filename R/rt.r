#' Maintainace operations for rt
#'
#' @param init [\code{logical(1)}]\cr
#'  Initialize for first use: create directory \code{\link{getConfigPath}} and
#'  create an empty package collection file \code{getConfigPath("packages")}.
#' @param edit [\code{logical(1)}]\cr
#'  Edit the \dQuote{packages} file?
#' @param maintainer [\code{logical(1)}]\cr
#'  Set a default maintainer to be used with \code{\link{rwinbuild}} and \code{\link{rhub}} e.g. \dQuote{Joe Developer <Joe.Developer@some.domain.net>}.
#'  Opens an editor.
#' @template return-itrue
rt = function(init = FALSE, edit = FALSE, maintainer = FALSE) {
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

  if (maintainer) {
    fn = getConfigPath("maintainer")
    if (!file.exists(fn)) {
      assertString(maintainer, pattern = ".* <.*@.*>")
      writeLines(c("## Maintainer", "# Joe Developer <Joe.Developer@some.domain.net>"), con = fn)
    }
    utils::file.edit(fn)
  }

  invisible(TRUE)
}

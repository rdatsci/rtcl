#' Maintainace operations for rt
#'
#' @param init [\code{logical(1)}]\cr
#'  Initialize for first use: create directory \code{~/.rt} and
#'  create an empty package collection file \code{~/.rt/packages}.
#' @param cleanup [\code{logical(1)}]\cr
#'  Remove git repositories in \code{~/.rt/git} which are not
#'  referenced in the collection file.
#' @template return-itrue
rt = function(init = FALSE, cleanup = FALSE) {
  assertFlag(init)
  assertFlag(cleanup)

  if (init) {
    fn = getConfigPath("packages")
    dn = dirname(fn)
    if (!dir.exists(dn)) {
      dir.create(dn, recursive = TRUE)
      messagef("Created directory %s", dn)
    }
    if (!file.exists(fn)) {
      writeLines(c("## Uncomment to let rt update itself:", "# rdatsci/rt"), con = fn)
      messagef("Written initial collection file '%s'", fn)
    }
  }

  if (cleanup) {
    pkgs = getCollectionContents(as.packages = TRUE)
    pkgs = extract(pkgs[extract(pkgs, "type") == "git"], "name")
    cached = list.dirs(getConfigPath("git"), recursive = FALSE)
    obsolete = cached[pkgs %nin% basename(cached)]

    if (length(obsolete) > 0L) {
      messagef("Removing %i obsolete git repos from disc: %s", length(obsolete), collapse(basename(obsolete)))
      unlink(obsolete, recursive = TRUE)
    }
  }
  invisible(TRUE)
}

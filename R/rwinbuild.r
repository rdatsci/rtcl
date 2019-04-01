#' Upload package to winbuilder
#'
#' @description
#' Uploads a package located in \code{path} to the winbuilder service.
#' Uses \code{\link[devtools]{check_win_release}}, \code{\link[devtools]{check_win_devel}} or \code{\link[devtools]{check_win_oldrelease} internally.
#'
#' @template path
#' @param devel [\code{logical(1)}]\cr
#'  Upload to check against the R-devel branch instead of the stable branch.
#' @param oldrel [\code{logical(1)}]\cr
#'  Upload to check against the R-oldrelease branch instead of the stable branch.
#' @template return-itrue
#' @export
rwinbuild = function(path = getwd(), devel = FALSE, oldrel = FALSE) {
  path = normalizePath(path)
  assertFlag(devel)
  assertFlag(oldrel)
  if (devel && oldrel) {
    stop("Just enable devel OR oldrel at the same time.")
  }

  # change maintainer temporarily
  maintainer = getOption("rt.maintainer", NULL)
  if (!is.null(maintainer)) {
    desc = read.dcf(file.path(path, "DESCRIPTION"))
    if ("Maintainer" %in% colnames(desc)) {
      desc[1L, "Maintainer"] = maintainer
    } else {
      desc = cbind(desc, Maintainer = maintainer)
    }

    new_path = file.path(tempfile("tmp-package"), basename(path))
    if (!dir.create(dirname(new_path), recursive = TRUE) || !file.copy(path, dirname(new_path), recursive = TRUE)) {
      stop(sprintf("Unable to copy package to %s", path))
    }
    write.dcf(desc, file = file.path(new_path, "DESCRIPTION"))
    path = new_path
  }

  messagef("Building package in '%s' and uploading to winbuilder", path)

  if (devel) {
    devtools::check_win_devel(path)
  } else if (oldrel) {
    devtools::check_win_oldrelease(path)
  } else {
    devtools::check_win_release(path)
  }
}

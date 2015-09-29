#' Upload package to winbuilder
#'
#' @description
#' Uploads a package located in \code{path} to the winbuilder service. Uses
#' \code{\link[devtools]{build_win}} internally.
#'
#' @template path
#' @param devel [\code{logical(1)}]\cr
#'  Upload to check against the R-devel branch instead of the stable branch.
#' @template return-itrue
#' @export
rwinbuild = function(path = getwd(), devel = FALSE) {
  pkg = devtools::as.package(path, create = FALSE)
  assertFlag(devel)

  maintainer = getOption("rt.maintainer", NULL)
  if (!is.null(maintainer)) {
    desc = read.dcf(file.path(pkg$path, "DESCRIPTION"))
    if ("Maintainer" %in% colnames(desc)) {
      desc[1L, "Maintainer"] = maintainer
    } else {
      desc = cbind(desc, Maintainer = maintainer)
    }

    path = tempfile("tmp-package")
    if (!dir.create(path, recursive = TRUE) || !file.copy(pkg$path, path, recursive = TRUE))
      stop(sprintf("Unable to copy package to %s", path))
    pkg = devtools::as.package(file.path(path, basename(pkg$path)), create = FALSE)
    write.dcf(desc, file = file.path(pkg$path, "DESCRIPTION"))
  }

  messagef("Building and uploading package '%s' in '%s' to the winbuilder", pkg$package, pkg$path)
  devtools::document(pkg)
  devtools::build_win(pkg, version = ifelse(devel, "R-devel", "R-release"))
}

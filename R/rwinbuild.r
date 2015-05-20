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
rwinbuilt = function(path = getwd(), devel = FALSE) {
  pkg = devtools::as.package(path)
  assertFlag(devel)

  messagef("Building and uploading package '%s' in '%s' to the winbuilder", pkg$package, pkg$path)
  devtools::document(pkg)
  devtools::build_win(pkg, version = ifelse(devel, "R-devel", "R-release"))
}

#' Check spelling in generated Rd files
#'
#' @template path
#' @template return-itrue
#' @export
rspell = function(path = getwd()) {
  requireNamespace("utils")
  updatePackageAttributes(path = path)

  messagef("Checking spelling for package '%s'", pkgload::pkg_name(path = path))
  ctrl = "-d en_US" # --extra-dicts=en_GB"
  res = utils::aspell_package_Rd_files(dir = pkgload::pkg_path(path = path), control = ctrl)
  print(res)
  invisible(TRUE)
}

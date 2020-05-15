#' Check spelling in generated Rd files
#'
#' @template path
#' @template return-itrue
#' @export
rspell = function(path = getwd()) {
  requireNamespace("utils")
  updatePackageAttributes(path = path)

  messagef("Checking spelling for package '%s'", pkgload::pkg_name(path = path))
  res = spelling::spell_check_package(pkg = path)
  print(res)
  invisible(TRUE)
}

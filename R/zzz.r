#' @import checkmate
#' @import utils
#' @importFrom tools file_ext
#' @importFrom rappdirs app_dir
NULL

.onLoad = function(libname, pkgname) {
  backports::import(pkgname)
}

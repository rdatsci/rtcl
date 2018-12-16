#' @import checkmate
#' @import stringi
#' @import utils
NULL

.onLoad = function(libname, pkgname) {
  backports::import(pkgname)
}

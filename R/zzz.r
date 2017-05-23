#' @import checkmate
#' @import stringi
#' @import data.table
NULL

.onLoad = function(libname, pkgname) {
  backports::import(pkgname)
}

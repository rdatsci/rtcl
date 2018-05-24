#' @import checkmate
#' @import stringi
#' @import data.table
#' @import utils
NULL

.onLoad = function(libname, pkgname) {
  backports::import(pkgname)
}

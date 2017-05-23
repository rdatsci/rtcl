#' @import checkmate
#' @import stringi
#' @import data.table
NULL

.onAttach = function(libname, pkgname) {
  backports::import(pkgname)
}

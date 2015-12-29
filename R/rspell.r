#' Check spelling in generated Rd files
#'
#' @template path
#' @template return-itrue
#' @export
rspell = function(path = getwd()) {
  pkg = devtools::as.package(path, create = FALSE)
  if (!is.null(pkg$roxygennote)) {
    messagef("Updating documentation for '%s'", pkg$package)
    devtools::document(pkg)
  }

  messagef("Checking spelling for package '%s'", pkg$package)
  if (!requireNamespace("utils"))
    stop("Package utils not installed")
  ctrl = "-d en_US" # --extra-dicts=en_GB"
  res = utils::aspell_package_Rd_files(pkg$path, control = ctrl)
  print(res)
  invisible(TRUE)
}

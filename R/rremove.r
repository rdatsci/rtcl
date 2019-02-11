#' Remove R packages
#'
#' @description
#' Removes (uninstalls) R packages.
#'
#' @param pkgs [\code{character}]\cr
#'  Strings convertible by \code{\link{stringToPackage}}.
#' @template return-itrue
#' @export
rremove = function(pkgs = character(0L)) {
  lib = getLibraryPath()

  for (pkg in pkgs) {
    if (length(find.package(pkg, lib.loc = lib, quiet = TRUE)) == 0L) {
      messagef("Package '%s' not found", pkg)
    } else {
      messagef("Removing package '%s' from '%s' ...", pkg, lib)
      remove.packages(pkg, lib = lib)
    }
  }
  invisible(TRUE)
}

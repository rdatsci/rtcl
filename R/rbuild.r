#' Build a package
#'
#' @description
#' Build a package located in \code{path} using \code{link[devtools]{build}}.
#'
#' @template path
#' @param cran.license [\code{logical(1L)}]\cr
#'   Replace the LICENSE File with a CRAN compatible version containing only: \cr
#'   \code{YEAR: (current year)} \cr
#'   \code{COPYRIGHT HOLDER: (first author found in the DESCRIPTION)}
#' @template return-itrue
#' @export
rbuild = function(path = getwd(), cran.license = FALSE) {
  pkg = devtools::as.package(path, create = FALSE)
  updatePackageAttributes(pkg)

  messagef("Building package '%s' ...", pkg$package)
  if (dir.exists(file.path(pkg$path, "inst", "doc")))
    devtools::clean_vignettes(pkg)

  if (cran.license) {
    year = format(Sys.Date(), "%Y")
    if (!is.null(pkg$`authors@r`)) {
      copyright.holder = format(eval(parse(text = pkg$`authors@r`))[[1]], include = c("given", "family"))
    } else {
      copyright.holder = stri_match_first(pkg$author, regex = ".+?(?= <| \\[)")
    }
    tempfile = tempfile()
    license.file = file.path(pkg$path, "LICENSE")
    file.copy(license.file, tempfile)
    writeLines(sprintf("YEAR: %s\nCOPYRIGHT HOLDER: %s", year, copyright.holder), con = license.file)
  }

  loc = devtools::build(pkg)

  if (cran.license) {
    file.copy(tempfile, license.file)
    file.remove(tempfile)
  }
  messagef("The package has been bundled to '%s'.", normalizePath(loc))
  invisible(TRUE)
}

#' Path to rt configuration
#'
#' @description
#' Returns the path to the rt configuration files
#'
#' @param element [\code{character(1)}]\cr
#'   Which file within the configuration directory to access.
#'   Use \dQuote{.} for the directory itself.
#'   Uses \code{\link[rappdirs:user_data_dir]{user_config_dir}} to determine the path.
#' @return Returns the path as character.
#' @export
getConfigPath = function(element = ".") {
  file.path(rappdirs::user_config_dir("rt", "rdatsci"), element)
}

getCollectionContents = function(as.packages = FALSE) {
  assertFlag(as.packages)
  pkgs = readPackages()
  if (is.null(pkgs))
    return(character(0L))
  if (as.packages) {
    pkgs = lapply(pkgs, stringToPackage)
    names(pkgs) = extract(pkgs, "name")
  }
  return(pkgs)
}

addPackagesToCollection = function(pkgs) {
  assertList(pkgs, types = "Package")
  fn = getConfigPath("packages")
  w = which(extract(pkgs, "name") %nin% extract(getCollectionContents(as.packages = TRUE), "name"))
  messagef("Adding %i new package%s to '%s'", length(w), ifelse(length(w) > 1L, "s", ""), fn)

  if (length(w)) {
    rt(init = TRUE)
    fp = file(fn, open = "at")
    on.exit(close(fp))
    writeLines(vcapply(pkgs[w], packageToString), con = fp)
  }
}

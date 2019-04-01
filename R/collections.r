#' Path to rt configuration
#'
#' @description
#' Returns the path to the rt configuration files
#'
#' @param element [\code{character(1)}]\cr
#'   Which file whithin the config dir to acess.
#'   Use \dQuote{.} for the directory itself.
#'   Uses \code{\link[rappdirs]{user_config_dir}} to determine the path.
#' @return Returns the path as character.
#' @export
getConfigPath = function(element = ".") {
  file.path(rappdirs::user_config_dir("rt", "rdatsci"), element)
}

getCollectionContents = function(as.packages = FALSE, fn = getConfigPath("packages")) {
  assertFlag(as.packages)
  pkgs = readConfigLines(fn)
  if (is.null(pkgs))
    return(character(0L))
  if (as.packages) {
    pkgs = lapply(pkgs, stringToPackage)
    names(pkgs) = extract(pkgs, "name")
  }
  return(pkgs)
}

addPackagesToCollection = function(pkgs, fn = getConfigPath("packages")) {
  assertList(pkgs, types = "Package")
  w = which(extract(pkgs, "name") %nin% extract(getCollectionContents(as.packages = TRUE, fn = fn), "name"))
  messagef("Adding %i new package%s to '%s'", length(w), ifelse(length(w) > 1L, "s", ""), fn)

  if (length(w)) {
    rt(init = TRUE)
    fp = file(fn, open = "at")
    on.exit(close(fp))
    writeLines(vcapply(pkgs[w], packageToString), con = fp)
  }
}

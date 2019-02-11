getConfigPath = function(element = ".") {
  normalizePath(file.path("~", ".rt", element), mustWork = FALSE)
}

getCollectionContents = function(as.packages = FALSE, fn = getConfigPath("packages")) {
  assertFlag(as.packages)
  if (!file.exists(fn))
    return(character(0L))
  pkgs = trimws(readLines(fn))
  pkgs = pkgs[nzchar(pkgs) & !startsWith(pkgs, "#")]
  if (as.packages) {
    pkgs = lapply(pkgs, stringToPackage)
    setNames(pkgs, extract(pkgs, "name"))
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

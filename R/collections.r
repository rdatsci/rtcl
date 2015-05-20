getConfigPath = function(element = ".") {
  normalizePath(file.path("~", ".rt", element), mustWork = FALSE)
}

getCollectionContents = function(as.packages = FALSE, fn = getConfigPath("packages")) {
  assertFlag(as.packages)
  if (!file.exists(fn))
    return(character(0L))
  pkgs = stri_trim_both(readLines(fn))
  pkgs = pkgs[nzchar(pkgs) & !stri_startswith_fixed(pkgs, "#")]
  if (as.packages)
    pkgs = lapply(pkgs, stringToPackage)
  return(pkgs)
}

addPackagesToCollection = function(pkgs, fn = getConfigPath("packages")) {
  assertList(pkgs, types = "Package")
  w = which(extract(pkgs, "name") %nin% extract(getCollectionContents(as.packages = TRUE, fn = fn), "name"))
  messagef("Adding %i new package%s to '%s'", length(w), ifelse(length(w) > 1L, "s", ""), fn)

  if (length(w)) {
    dn = dirname(fn)
    if (!dir.exists(dn))
      dir.create(dn, recursive = TRUE)
    fp = file(fn, open = "at")
    on.exit(close(fp))
    writeLines(vcapply(pkgs[w], packageToString), con = fp)
  }
}

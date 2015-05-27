rdepclean = function() {
  base = c("R", "base", "compiler", "datasets", "graphics", "grDevices", "grid", "methods", "parallel", "splines", "stats", "stats4", "tcltk")
  requested = extract(getCollectionContents(as.packages = TRUE), "name")
  deps = tools::package_dependencies(requested, db = available.packages(), recursive = TRUE)
  deps = unique(c(names(deps), unlist(deps, use.names = FALSE)))
  installed = unname(installed.packages()[, "Package"])
  writeLines(installed[installed %nin% c(deps, base)])
}

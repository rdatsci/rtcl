Package = function(name, repo, type, uri, subdir = NA_character_) {
  x = list(name = name, repo = repo, type = type, uri = uri, subdir = subdir)
  class(x) = "Package"
  return(x)
}

#' @export
print.Package = function(x, ...) {
  cat("Package", x$name, "\n")
  cat("Type:", x$type, "\n")
  cat("URI: ", x$uri, "\n")
}

LocalPackage = function(name, uri) {
  addClasses(Package(name = name, repo = NA_character_, type = "local", uri = normalizePath(uri)), "LocalPackage")
}

CranPackage = function(name) {
  addClasses(Package(name = name, repo = NA_character_, type = "cran", uri = sprintf("http://cran.r-project.org/web/packages/%s/", name)), "CranPackage")
}

GitPackage = function(name, repo, uri) {
  addClasses(Package(name = name, repo = repo, type = "git", uri = uri), "GitPackage")
}

GitHubPackage = function(name, repo, subdir) {
  addClasses(Package(name = name, repo = repo, type = "git", uri = sprintf("https://github.com/%s.git", repo), subdir = subdir), c("GitHubPackage", "GitPackage"))
}

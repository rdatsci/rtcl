Package = function(name) {
  x = list(
    name = name
  )
  class(x) = "Package"
  return(x)
}

#' @export
print.Package = function(x, ...) {
  cat("Package: ", x$name, "\n")
}

## Cran Package
PackageCran= function(name) {
  pkg = Package(name)
  addClasses(pkg, "PackageCran")
}

## Local Package
PackageLocal = function(name, file_path) {
  pkg = Package(name)
  pkg$file_path = normalizePath(file_path) #/... or ./... or ~/... or (X:/)?
  addClasses(pkg, "PackageLocal")
}

#' @export
print.PackageLocal = function(x, ...) {
  NextMethod()
  cat("File Path: ", x$file_path, "\n")
}

## Git Package
# branch can be branch name or commit hash (or tag?)
PackageGit = function(name, repo, ref = NA_character_, subdir = NA_character_) {
  pkg = Package(name)
  pkg$repo = repo # http(s):|//.*\.git
  pkg$ref = ref #tag or branch or sha
  pkg$subdir = subdir #starts with /
  addClasses(pkg, "PackageGit")
}

print.PackageGit = function(x, ...) {
  NextMethod()
  cat("Repository: ", x$repo, "\n")
  cat("Ref: ", x$ref, "\n")
  cat("Subdir: ", x$subdir, "\n")
}

## GitHub Package
PackageGitHub = function(name, handle) {
  pkg = Package(name)
  pkg$handle = handle #orga/repo/subdir@ref
  addClasses(pkg, "PackageGitHub")
}

print.PackageGitHub = function(x, ...) {
  NextMethod()
  cat("GitHub Handle: ", x$handle, "\n")
}

## GitLab Package
PackageGitLab = function(name, handle, host = NA_character_) {
  pkg = Package(name)
  pkg$handle = handle #orga/repo/subdir@ref
  pkg$host = host #gitlab.com or can run on any domain *.*
  addClasses(pkg, "PackageGitHub")
}

print.PackageGitLab = function(x, ...) {
  NextMethod()
  cat("GitLab URL: ", x$host, "\n")
  cat("GitLab Handle: ", x$handle, "\n")
}

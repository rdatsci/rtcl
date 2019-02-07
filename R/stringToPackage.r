#' Convert a string to an object of type 'Package'
#'
#' @description
#' This function converts the string to one of the following objects:
#' \itemize{
#'   \item{LocalPackage: }{\code{pkg} points to an existing directory.}
#'   \item{GitPackage: }{\code{pkg} starts with \dQuote{https://} or \dQuote{git} and ends with \dQuote{.git}.}
#'   \item{GitHubPackage: }{\code{pkg} matches the pattern \dQuote{[user]/[repo]}.}
#'   \item{CranPackage: }{\code{pkg} is a single string without any special characters except dots ([a-zA-Z0-9.]).}
#' }
#' @param pkg [\code{character(1)} | \code{NULL}]\cr
#'   String to convert to an object of class Package.
#' @export
stringToPackage = function(pkg) {
  if (inherits(pkg, "Package"))
    return(pkg)
  assertString(pkg)

  funs = list(
    Cran = isPackageCran,
    Local = isPackageLocal,
    Git = isPackageGit,
    GitHub = isPackageGitHub,
    GitLab = isPackageGitLab
  )

  check_res = vapply(funs, function(x) x(pkg), logical(1))

  if (sum(check_res) > 1L) {
    stop(sprintf("Package String '%s' is ambigous!", pkg))
  } else if (sum(check_res) == 0L) {
    stop(sprintf("Type for Package String '%s' is unknown!", pkg))
  }

  switch(names(which(check_res)),
    "Local" = asPackageLocal(pkg),
    "Cran" = asPackageCran(pkg),
    "Git"  = asPackageGit(pkg),
    "GitHub"  = asPackageGitHub(pkg),
    "GitLab"  = asPackageGitLab(pkg),
    stop("Unknown package type: ", parts[1L])
  )
}

# functions have to work vectorized
isPackageCran = function(xs) {
  grepl(pattern = "^[[:alnum:].]+$", x = xs)
}

isPackageLocal = function(xs) {
  # FIXME: Windows?
  grepl(pattern = "^(\\/|\\.\\/|~\\/|[A-Z]:/).+$", x = xs) & dir.exists(xs)
}

isPackageGit = function(xs) {
  grepl(pattern = "^(git@|http(s)?://).+\\.git(@[[:alnum:]._-]+)?[[:alnum:]/]*?$", x = xs)
}

isPackageGitHub = function(xs) {
  grepl(pattern = "^(github:)?[[:alnum:]_-]+/[[:alnum:]_.-]+(@[[:alnum:]._-]+)?[[:alnum:]/]*?$", x = xs)
}

isPackageGitLab = function(xs) {
  grepl(pattern = "^gitlab:(\\([[:alnum:]_.-]+\\):)?[[:alnum:]_-]+/[[:alnum:]_.-]+(@[[:alnum:]._-]+)?[[:alnum:]/]*?$", x = xs)
}

asPackageCran = function(xs) {
  PackageCran(xs)
}

asPackageLocal = function(xs) {
  if (!dir.exists(xs))
    stop(sprintf("'%s' must point to an existing directory for a local package", xs))
  PackageLocal(name = readPackageName(xs), file_path = xs)
}

asPackageGit = function(xs) {
  matches = matchRegexGroups(xs, "^(.+\\.git)@?([[:alnum:]._-]+)?/?([[:alnum:]/]+)?$")[[1]]
  PackageGit(
    name =  matchRegex(matches[2], "[[:alnum:]._-]+(?=\\.git$)")[[1]],
    repo =  matches[2],
    ref = matches[3],
    subdir = matches[4]
  )
}

asPackageGitHub = function(xs) {
  xs = gsub("^github:", "", x = xs)
  matches = matchRegex(xs, "(?<=/)[[:alnum:]._-]+")[[1]]
  PackageGitHub(name = matches[1], handle = xs)
}

asPackageGitLab = function(xs) {
  xs = gsub("^gitlab:", "", x = xs)
  host = matchRegex(xs, "(?<=\\()[[:alnum:]_.-]+(?=\\):)")[[1]]
  matches = matchRegex(xs, "(?<=/)[[:alnum:]._-]+")[[1]]
  PackageGitHub(name = matches[1], handle = xs, host = host)
}



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
  stri_detect_regex(xs, "^[[:alnum:].]+$")
}

isPackageLocal = function(xs) {
  # FIXME: Windows?
  stri_detect_regex(xs, "^(\\/|\\.\\/|~\\/|[A-Z]:/).+$") & dir.exists(xs)
}

isPackageGit = function(xs) {
  stri_detect_regex(xs, "^(git@|http(s)?://).+\\.git(@[[:alnum:]._-]+)?[[:alnum:]/]*?$")
}

isPackageGitHub = function(xs) {
  stri_detect_regex(xs, "^(github:)?[[:alnum:]_-]+/[[:alnum:]_.-]+(@[[:alnum:]._-]+)?[[:alnum:]/]*?$")
}

isPackageGitLab = function(xs) {
  stri_detect_regex(xs, "^gitlab:(\\([[:alnum:]_.-]+\\):)?[[:alnum:]_-]+/[[:alnum:]_.-]+(@[[:alnum:]._-]+)?[[:alnum:]/]*?$")
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
  matches = stri_match_all_regex(xs, "^(.+\\.git)@?([[:alnum:]._-]+)?([[:alnum:]/]+)?$")[[1]]
  repo = matches[1,2]
  repo_name = stri_match_all_regex(repo, "[[:alnum:]._-]+(?=\\.git$)")[[1]][[1]]
  ref = stri_sub(matches[1,3], 2) #removes @
  subdir = stri_sub(matches[1,4], 2) #removes /
  name = ifelse(!is.na(subdir) & subdir != "R", subdir, repo_name)

  PackageGit(
    name = name,
    repo = repo,
    ref = ref,
    subdir = subdir
  )
}

asPackageGitHub = function(xs) {
  xs = stri_replace_all_regex(xs, "^github:", "")
  matches = stri_match_all_regex(xs, "(?<=/)[[:alnum:]._-]{2,}")[[1]] #one letter matches are likely R subfolders that we do not want to match
  name = tail(matches, 1)[[1]]
  PackageGitHub(name = name, handle = xs)
}

asPackageGitLab = function(xs) {
  xs = "gitlab:(gitlab.com):keks/blub@master/baems"
  xs = "gitlab:keks/blub@master/baems"
  xs = stri_replace_all_regex(xs, "^gitlab:", "")
  matches = stri_match_all_regex(xs, "^\\(([[:alnum:]_.-]+)\\):")[[1]]
  host = matches[1,2]
  matches = stri_match_all_regex(xs, "(?<=/)[[:alnum:]._-]{2,}")[[1]] #one letter matches are likely R subfolders that we do not want to match
  name = tail(matches, 1)[[1]]
  PackageGitHub(name = name, handle = xs, host = host)
}



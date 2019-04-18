#' Convert a string to an object of type 'Package'
#'
#' @description
#' This function converts the string to one of the following objects:
#' \itemize{
#'   \item{PackageCran: }{
#'     \code{pkg} is a single string without any special characters except dots.
#'   }
#'   \item{PackageLocal: }{
#'     \code{pkg} points to an existing directory.
#'     Path to local directory and starts with \dQuote{./}, \dQuote{../}, \dQuote{~/}, \dQuote{/} or \dQuote{X:/}.
#'     Or path to a compressed file (tar, zip, tar.gz, tar.bz2, tgz or tbz)
#'   }
#'   \item{PackageGit: }{
#'     \code{pkg} starts with \dQuote{http(s)://} or \dQuote{git@} and ends with \dQuote{.git}.
#'     Additionally a reference (branch, tag or SHA reference) can be specified with the prefix \dQuote{@}.
#'     If the package resides in a subdirectory it can be specified with the prefix \dQuote{/}.
#'     Example: \dQuote{http://gitserver.domain/repo.git/subfolder@branch}
#'   }
#'   \item{PackageGitHub: }{
#'     \code{pkg} matches the pattern \dQuote{[user]/[repo]}.
#'     Additional prefixes can be given as for GitPackage (see above).
#'     Example: \dQuote{user/repo/subfolder@branch}
#'   }
#'   \item{PackageGitLab: }{
#'     \code{pkg} matches the pattern \dQuote{gitlab::[user]/[repo]} or \dQuote{gitlab::(host):[user]/[repo]}.
#'     Additional prefixes can be given as for GitPackage (see above).
#'     Example: \dQuote{gitlab::(mygitlab.com):user/repo/subfolder@branch}
#'   }
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
    GitLab = isPackageGitLab,
    Bitbucket = isPackageBitbucket,
    Bioc = isPackageBioc
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
    "Bitbucket"  = asPackageBitbucket(pkg),
    "Bioc" = asPackageBioc(pkg),
    stop("Unknown package type: ", which(check_res))
  )
}

# functions have to work vectorized
isPackageCran = function(xs) {
  grepl(pattern = "^[[:alnum:].]+$", x = xs)
}

isPackageLocal = function(xs) {
  # FIXME: Windows?
  is.path = grepl(pattern = "^(\\/|\\.{1,2}\\/|~\\/|[A-Z]:/).+$", x = xs)
  is.file = grepl(pattern = ".*\\.(tar|zip|tar.gz|tar.bz2|tgz|tbz)$", x = xs)
  if ((is.file || is.path) && !(file.exists(xs) || dir.exists(xs))) {
    warning("Local package detected, but location at path does not exist!")
  }
  (is.path && dir.exists(xs)) || (is.file && file.exists(xs))
}

isPackageGit = function(xs) {
  grepl(pattern = "^(git@|http(s)?://).+\\.git[[:alnum:]_/-]*(@[[:alnum:]._-]+)?$", x = xs)
}

isPackageGitHub = function(xs) {
  grepl(pattern = "^(github::)?[[:alnum:]_-]+/[[:alnum:]_.-]+[[:alnum:]_/-]*(@[[:alnum:]._-]+)?$", x = xs)
}

isPackageGitLab = function(xs) {
  grepl(pattern = "^gitlab::(\\([[:alnum:]_.-/]+\\):)?[[:alnum:]_-]+/[[:alnum:]_.-]+[[:alnum:]_/-]*(@[[:alnum:]._-]+)?$", x = xs)
}

isPackageBitbucket = function(xs) {
  grepl(pattern = "^bitbucket::?[[:alnum:]_-]+/[[:alnum:]_.-]+[[:alnum:]_/-]*(@[[:alnum:]._-]+)?$", x = xs)
}

isPackageBioc = function(xs) {
  grepl(pattern = "^bioc::(.+@)?([[:alnum:]._-]+/)?[[:alnum:]_-]+(#[[:alnum:]._-]+)?$", x = xs)
}

asPackageCran = function(xs) {
  PackageCran(xs)
}

asPackageLocal = function(xs) {
  if (!dir.exists(xs) && !file.exists(xs))
    stop(sprintf("'%s' must point to an existing directory or file for a local package", xs))
  if (dir.exists(xs)) {
    name = readPackageName(xs)
  } else {
    name = matchRegex(xs, "(?<=/)[[:alnum:]._-]+(?=_[0-9])")[[1]]
  }
  PackageLocal(name = name, file_path = xs)
}

asPackageGit = function(xs) {
  matches = matchRegexGroups(xs, "^(.+\\.git)/?([[:alnum:]_/-]+)?@?([[:alnum:]._-]+)?$")[[1]]
  PackageGit(
    name =  matchRegex(matches[2], "[[:alnum:]._-]+(?=\\.git$)")[[1]],
    repo =  matches[2],
    subdir = matches[3],
    ref = matches[4]
  )
}

asPackageGitHub = function(xs) {
  xs = gsub("^github::", "", x = xs)
  matches = matchRegex(xs, "(?<=/)[[:alnum:]._-]+")[[1]]
  PackageGitHub(name = matches[1], handle = xs)
}

asPackageGitLab = function(xs) {
  xs = gsub("^gitlab::", "", x = xs)
  host = matchRegexGroups(xs, "(?<=\\()[[:alnum:]_.-/]+(?=\\):)")[[1]]
  matches =  matchRegexGroups(xs, "([[:alnum:]_-]+/([[:alnum:]_.-]+))([[:alnum:]_/-]*)(@[[:alnum:]._-]+)?$")[[1]]
  PackageGitLab(name = matches[3], handle = matches[1], host = host)
}

asPackageBitbucket = function(xs) {
  xs = gsub("^bitbucket::", "", x = xs)
  matches = matchRegex(xs, "(?<=/)[[:alnum:]._-]+")[[1]]
  PackageBitbucket(name = matches[1], handle = xs)
}

asPackageBioc = function(xs) {
  xs = gsub("^bioc::", "", x = xs)
  matches = matchRegexGroups(xs, "^(.+@)?([[:alnum:]._-]+/)?([[:alnum:]_-]+)(#[[:alnum:]._-]+)?$")[[1]]
  PackageBioc(name = matches[4], handle = xs)
}



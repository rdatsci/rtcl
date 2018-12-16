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

  parts = stri_split_fixed(pkg, "::", n = 2L, tokens_only = TRUE)[[1L]]
  if (length(parts) == 1L)
    parts = c(detectPackageType(parts), parts)


  switch(parts[1L],
    "local" = asLocalPackage(parts[2L]),
    "cran" = asCranPackage(parts[2L]),
    "git"  = asGitPackage(parts[2L]),
    "gh"  = asGitHubPackage(parts[2L]),
    stop("Unknown package type: ", parts[1L])
  )
}

detectPackageType = function(xs) {
  if (dir.exists(xs))
    return("local")
  if (any(startsWith(xs, c("https://", "git@"))) && endsWith(xs, ".git"))
    return("git")
  if (grepl("^[[:alnum:]_-]+/[[:alnum:]_.-]+(@[[:alnum:]._-]+)?[[:alnum:]/]*?$", xs))
    return("gh")
  if (grepl("^[[:alnum:].]+$", xs))
    return("cran")
  stop("Unknown package type: ", xs)
}

asLocalPackage = function(xs) {
  if (!dir.exists(xs))
    stop(sprintf("'%s' must point to an existing directory for a local package", xs))
  LocalPackage(name = readPackageName(xs), uri = xs)
}

asGitPackage = function(xs) {
  matches = tail(drop(stri_match_last_regex(xs, "([[:alnum:]_]+)/([[:alnum:]_]+)\\.git")), -1L)
  if (anyNA(matches) || length(matches) == 0L)
    stop("Malformed Git URI")
  GitPackage(name = matches[2L], repo = sprintf("%s/%s", matches[1L], matches[2L]), uri = xs)
}

asGitHubPackage = function(xs) {
  parts = stri_split_fixed(xs, pattern = "/", n = 3L)[[1L]]
  repotag = stri_split_fixed(parts[2], pattern = "@", n = 2)[[1L]]
  parts[2L] = repotag[1L]
  GitHubPackage(name = parts[2L], repo = stri_join(parts[1:2], collapse = "/"), subdir = parts[3L], tag = repotag[2L])
}

asCranPackage = function(xs) {
  CranPackage(xs)
}

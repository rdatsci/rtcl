#' Maintainace operations for rtcl
#'
#' @param init [\code{logical(1)}]\cr
#'  Initialize for first use: create directory \code{\link{getConfigPath}} and
#'  create an empty package collection file \code{getConfigPath("packages")}.
#' @param packages [\code{logical(1)}]\cr
#'  Edit the \dQuote{packages} file to define the packages rtcl should manage?
#' @param config [\code{logical(1)}]\cr
#' Edit the \dQuote{config} file to:
#'  \itemize{
#'    \item set a default maintainer to be used with \code{\link{rwinbuild}} and \code{\link{rhub}} e.g. \dQuote{Joe Developer <Joe.Developer@some.domain.net>}
#'    \item set default \code{build_opts} to be used when packages are built.
#'  }
#'  Edit the \dQuote{config} file toset a default maintainer to be used with \code{\link{rwinbuild}} and \code{\link{rhub}} e.g. \dQuote{Joe Developer <Joe.Developer@some.domain.net>}.
#'  Opens an editor.
#' @template return-itrue
rtcl = function(init = FALSE, packages = FALSE, config = FALSE) {
  assertFlag(init)
  assertFlag(packages)
  assertFlag(config)

  file_packages = getConfigPath("packages")
  file_config = getConfigPath("config")
  path_rtcl = dirname(file_packages)

  if (init) {
    if (!dir.exists(path_rtcl)) {
      dir.create(path_rtcl, recursive = TRUE)
      messagef("Created directory '%s'", path_rtcl)
    }
    if (!file.exists(file_packages)) {
      writeLines(c(
        "## Uncomment to let rtcl update itself:",
        "# rdatsci/rtcl"
        ), con = file_packages)
      messagef("Written initial collection file '%s'", file_packages)
    }
    if (!file.exists(file_config)) {
      writeLines(c(
        '# maintainer = "Joe Developer <Joe.Developer@some.domain.net>"',
        'maintainer = NULL',
        '# build_opts$default = c("--no-resave-data", "--no-manual", "--no-build-vignettes")',
        'build_opts$default = NULL',
        'build_opts$local = build_opts$default # local sources (rmake etc.)',
        'build_opts$git = build_opts$default # git sources (github etc.)',
        'build_opts$cran = build_opts$default # cran sources',
        'build_opts$bioc = build_opts$default # bioconductor sources'
        ), con = file_config)
      messagef("Written initial config file '%s'", file_config)
    }

  }

  if (packages) {
    utils::file.edit(file_packages)
  }

  if (config) {
    utils::file.edit(file_config)
  }

  invisible(TRUE)
}

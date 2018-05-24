#' Release a package
#' 
#' @description
#'   Release the package located at \code{path}, using \code{link[devtools]{release}}.
#' 
#' @template path
#' @param directsubmit [\code{logical(1)}]\cr
#'   Submit package without questions and pause to CRAN.
#'   Default is \code{FALSE}.
#' @template return-itrue
#' @export
rrelease = function(path = getwd(), directsubmit = FALSE) {
  # the code in this function follows 'devtools::release()'
  pkg = devtools::as.package(path, create = FALSE)
  assertFlag(directsubmit)
  cran_version = devtools:::cran_pkg_version(pkg$package)
  new_pkg = is.null(cran_version)
  
  messagef("Releasing package '%s'\n", pkg$package)
  
  if (!directsubmit) {
    # Questions from 'devtools::release()'
    messagef("Have you checked for spelling errors (with 'rspell')?")
    messagef("Have you run `R CMD check` locally (with 'rcheck')?")
    if (!new_pkg) {
      messagef("Have you fixed all existing problems at \n%s"
               , paste0(devtools:::cran_mirror(), "/web/checks/check_results_", pkg$package, ".html")
               )
    }
    messagef("Have you checked on R-hub (with 'rhub')?")
    messagef("Have you checked on win-builder (with 'rwinbuild')?")
    deps = ifelse(new_pkg, 0, length(devtools::revdep(pkg$package)))
    if (deps > 0) {
      messagef("Have you checked the %s reverse dependencies (with 'revdepcheck' package)?", deps)
    }
    messagef("Have you updated 'NEWS.md' and 'DESCRIPTION' file?")
    if (dir.exists("docs/")) {
      messagef("Have you updated websites in 'docs/'?")
    }
    
    # Pause
    messagef("\nRelease proceeds automatically in 10 seconds. Press 'Ctrl-C' to interrupt.\n")
    Sys.sleep(10)
  }
  
  # submit to CRAN (following 'devtools::submit_cran()')
  messagef("Submitting now to CRAN:")
  built_path = devtools:::build_cran(pkg, args = NULL)
  devtools:::upload_cran(pkg, built_path)
  messagef("Package '%s' has been released to CRAN.", pkg$package)
  invisible(TRUE)
}

messagef = function(msg, ...) {
  message(crayon::green(sprintf(msg, ...)))
}

collapse = function(..., sep = ",") {
  paste0(..., collapse = sep)
}

`%nin%` = function(x, y) {
  !match(x, y, nomatch = 0L)
}

getLibraryPath = function() {
  head(.libPaths(), 1L)
}

addClasses = function(x, classes) {
  class(x) = c(classes, class(x))
  x
}

vlapply = function(x, fun, ..., use.names = TRUE) {
  vapply(X = x, FUN = fun, ..., FUN.VALUE = NA, USE.NAMES = use.names)
}

vcapply = function(x, fun, ..., use.names = TRUE) {
  vapply(X = x, FUN = fun, ..., FUN.VALUE = NA_character_, USE.NAMES = use.names)
}

extract = function(li, what) {
  vapply(li, "[[", what, FUN.VALUE = NA_character_)
}

readPackageName = function(path) {
  as.character(read.dcf(file.path(path, "DESCRIPTION"), fields = "Package"))
}

updatePackageAttributes = function(path = ".") {
  assertDirectoryExists(path)
  path = pkgload::pkg_path(path)

  pkgload::load_all(path) #recompiles, generates o files
  desc = pkgload::pkg_desc(path = path)

  if (!is.na(desc$get("RoxygenNote"))) {
    messagef("Updating documentation for '%s'", pkgload::pkg_name(path = path))
    roxygen2::roxygenize(package.dir = pkgload::pkg_path(path = path))
  }

  if (!is.na(desc$get("LinkingTo")) && "Rcpp" %in% desc$get_deps()$package) {
    messagef("Updating Rcpp compile attributes")
    requireNamespace("Rcpp")
    Rcpp::compileAttributes(path, verbose = TRUE)
  }
}

coalesceString = function(x, to = NULL) {
  if (is.null(x) || is.na(x) || all(!nzchar(x))) {
    to
  } else {
    x
  }
}

matchRegex = function(str, pattern, ...) {
  reg_match = gregexpr(pattern =  pattern, text = str, perl = TRUE, ...)
  regmatches(x = str, m = reg_match)
}

matchRegexGroups = function(str, pattern, ...) {
  reg_match = regexec(pattern =  pattern, text = str, perl = TRUE, ...)
  regmatches(x = str, m = reg_match)
}

changeMaintainer = function(path) {
  # change maintainer temporarily
  maintainer_conf = readConfig()$maintainer
  if (!is.null(maintainer)) {
    desc = read.dcf(file.path(path, "DESCRIPTION"))
    if ("Maintainer" %in% colnames(desc)) {
      desc[1L, "Maintainer"] = maintainer
    } else {
      desc = cbind(desc, Maintainer = maintainer)
    }

    new_path = file.path(tempfile("tmp-package"), basename(path))
    if (!dir.create(dirname(new_path), recursive = TRUE) || !file.copy(path, dirname(new_path), recursive = TRUE)) {
      stop(sprintf("Unable to copy package to %s", path))
    }
    write.dcf(desc, file = file.path(new_path, "DESCRIPTION"))
    path = new_path
  }
  return(path)
}

readConfig = function() {
  env = new.env()
  source(getConfigPath("config"), local = env)
  config = as.list(env)
  # compatibility
  config$maintainer = getOption("rt.maintainer", NULL) %??% config$maintainer
  # check config
  assert_string(config$maintainer, null.ok = TRUE, pattern = ".*<[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+>")
  assert_character(config$build_opts, null.ok = TRUE, pattern = "^--.*+", any.missing = FALSE)
  assert_character(config$build_opts_cran, null.ok = TRUE, pattern = "^--.*+", any.missing = FALSE)
  assert_character(config$build_opts_remotes, null.ok = TRUE, pattern = "^--.*+", any.missing = FALSE)
  assert_character(config$build_opts_make, null.ok = TRUE, pattern = "^--.*+", any.missing = FALSE)
  return(config)
}

readPackages = function() {
  path = getConfigPath("packages")
  if (!file.exists(path))
    return(NULL)
  res = trimws(readLines(path))
  res[nzchar(res) & !startsWith(res, "#")]
}

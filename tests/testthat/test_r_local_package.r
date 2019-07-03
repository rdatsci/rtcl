context("r* functions for local packages")


r_functions = c("rcheck", "rclean", "rcov", "rdoc", "rmake", "rpkgdown", "rspell", "rtest", "rusage")
pkg_path = file.path(".", "assets", "package")

for (r_fun in r_functions) {
  test_that(r_fun, {
    skip_on_cran()
    fun = get(r_fun)
    # execute
    expect_true(suppressMessages(fun(pkg_path)), info = r_functions)
    # cleanup
    if (r_fun == "rmake") {
      pkg = stringToPackage(pkg_path)
      rremove(pkg$name)
    }
    if (r_fun == "rpkgdown") {
      unlink(file.path(pkg_path, "docs"), recursive = TRUE)
    }
  })
}

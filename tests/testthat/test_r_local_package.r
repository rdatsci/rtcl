context("r* functions for local packages")


r_functions = c("rbuild", "rcheck", "rclean", "rcov", "rdoc", "rinstall", "rmake", "rpkgdown", "rspell", "rtest", "rusage")
pkg_path = file.path("..", "testpkg")

for (r_fun in r_functions) {
  test_that(r_fun, {
    fun = get(r_fun)
    # execute
    if (r_fun == "rcheck") {
      expect_class(suppressMessages(fun(pkg_path)), "rcmdcheck")
    } else {
      expect_true(suppressMessages(fun(pkg_path)))
    }
    # cleanup
    if (r_fun %in% c("rmake", "rinstall")) {
      pkg = stringToPackage(pkg_path)
      rremove(pkg$name)
    }
    if (r_fun == "rbuild") {
      file.remove(file.path("..", "testpkg_1.0.tar.gz"))
    }
    if (r_fun == "rpkgdown") {
      unlink(file.path(pkg_path, "docs"), recursive = TRUE)
    }
  })
}

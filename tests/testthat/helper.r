if (FALSE && !exists("SET_TEMP_LIB")) {
  SET_TEMP_LIB <<- TRUE
  lib = tempfile("rtlib")
  dir.create(lib)
  .libPaths(c(lib, .libPaths()))
}

with_wd = function(dir, expr) {
    old_wd = getwd()
    on.exit(setwd(old_wd))
    setwd(dir)
    evalq(expr)
}

# build package in location `s`, tries to install it and removes the builed file and the package
test_basic_rbuild = function(s, name, ...) {
  print(sprintf("Try to build package from %s", getwd()))
  expect_true(rbuild(s))
  pkg_file = file.path(s, "..", "testpkg_1.0.tar.gz")
  expect_true(file.exists(pkg_file))
  test_basic_rinstall(pkg_file, "testpkg")
  file.remove(pkg_file)
}

# installs package `s` with name `name` and removes it
test_basic_rinstall = function(s, name, ...) {
  expect_true(suppressMessages(rinstall(s, force = TRUE)), ...)
  expect_true(name %in% rownames(installed.packages()), ...)
  expect_true(suppressMessages(rremove(name)), ...)
  expect_true(!(name %in% rownames(installed.packages())), ...)
}

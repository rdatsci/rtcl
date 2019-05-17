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

# installs package `s` with name `name` and removes it
test_basic_rinstall = function(s, name, ...) {
  expect_true(suppressMessages(rinstall(s, force = TRUE)), ...)
  expect_true(name %in% rownames(installed.packages()), ...)
  expect_true(suppressMessages(rremove(name)), ...)
  expect_true(!(name %in% rownames(installed.packages())), ...)
}

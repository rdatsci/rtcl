context("rbuild")

# build package in location `s`, tries to install it and removes the builed file and the package
test_basic_rbuild = function(s, name, ...) {
  print(sprintf("Try to build package from %s", getwd()))
  expect_true(rbuild(s))
  pkg_file = file.path(s, "..", "testpkg_1.0.tar.gz")
  expect_true(file.exists(pkg_file))
  test_basic_rinstall(pkg_file, "testpkg")
  file.remove(pkg_file)
}

test_that("rbuild works for local packages", {
  skip_on_cran()
  test_basic_rbuild("./assets/package")
})

test_that("rbuild works for local packages on windows", {
  skip_on_os(c("mac", "linux", "solaris"))
  skip_on_cran()
  test_basic_rbuild(".\\assets\\package", "testpkg")
})

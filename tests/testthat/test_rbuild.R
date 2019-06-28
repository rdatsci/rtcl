context("rbuild")

test_that("rbuild works for local packages", {
  skip_on_cran()
  test_basic_rbuild("./assets/package")
})

test_that("rbuild works for local packages on windows", {
  skip_on_os(c("mac", "linux", "solaris"))
  skip_on_cran()
  test_basic_rbuild(".\\assets\\package", "testpkg")
})

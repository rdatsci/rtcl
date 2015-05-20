context("rmake")

test_that("rmake", {
  pkg = file.path("..", "testpkg")
  expect_true(suppressMessages(rmake(pkg)))
})

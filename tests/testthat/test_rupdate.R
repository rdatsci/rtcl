context("rupdate")


test_that("rupdate works at least in dryrun", {
  res = rupdate(dryrun = TRUE)
  expect_true(res)
})

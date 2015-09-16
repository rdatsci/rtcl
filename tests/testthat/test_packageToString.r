context("packageToString")

test_that("packageToString and vice versa", {
  s = "checkmate"
  p = stringToPackage(s)
  expect_is(p, "Package")
  expect_is(p, "CranPackage")
  expect_equal(p$repo, NA_character_)
  expect_equal(p$name, "checkmate")
  expect_equal(p$type, "cran")
  expect_equal(p$uri, "http://cran.r-project.org/web/packages/checkmate/")
  expect_equal(packageToString(p), s)

  s = "mllg/checkmate"
  p = stringToPackage(s)
  expect_is(p, "Package")
  expect_is(p, "GitPackage")
  expect_is(p, "GitHubPackage")
  expect_equal(p$repo, "mllg/checkmate")
  expect_equal(p$name, "checkmate")
  expect_equal(p$type, "git")
  expect_equal(p$uri, "https://github.com/mllg/checkmate.git")
  expect_equal(packageToString(p), s)

  s = "https://github.com/mllg/checkmate.git"
  p = stringToPackage(s)
  expect_is(p, "Package")
  expect_is(p, "GitPackage")
  expect_false(inherits(p, "GitHubPackage"))
  expect_equal(p$repo, "mllg/checkmate")
  expect_equal(p$name, "checkmate")
  expect_equal(p$type, "git")
  expect_equal(p$uri, "https://github.com/mllg/checkmate.git")
  expect_equal(packageToString(p), s)

  expect_identical(stringToPackage("cran::checkmate"), stringToPackage("checkmate"))
  expect_error(stringToPackage("git::checkmate"), "Malformed")
  expect_error(stringToPackage("foo::checkmate"), "package type")
})

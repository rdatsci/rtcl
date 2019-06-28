context("packageToString and stringToPackage")

# constructs package from string and does basic tests
test_basic_package = function(s, type, name, string_expect = s, ...) {
  p = stringToPackage(s)
  expect_is(p, "Package", ...)
  expect_is(p, type, ...)
  expect_output(print(p), type, ...)
  expect_equal(p$name, name, ...)
  if (!is.na(string_expect)) {
    p_string = packageToString(p)
    expect_equal(p_string, string_expect, ...)
  }
  invisible(p)
}

test_that("CRAN Packages", {
  s = "checkmate"
test_basic_package(s, "PackageCran", "checkmate")
})

test_that("Local Pacakges Unix", {

  # skip_on_os("windows") # should actually also run on windows
  sets = list(
    list(wd = ".", pkg = "./assets/package/"),
    list(wd = ".", pkg = "./assets/package"),
    list(wd = "assets", pkg = "./package/"),
    list(wd = "assets", pkg = "./package"),
    list(wd = "assets/package", pkg = "./"),
    list(wd = "assets/package", pkg = "."),
    list(wd = ".", pkg = "../testthat/assets/package/"),
    list(wd = ".", pkg = "../testthat/assets/package"),
    list(wd = ".", pkg = normalizePath("assets/package", mustWork = TRUE)),
    list(wd = ".", pkg = "./assets/testpkg_1.0.tar.gz"),
    list(wd = "assets", pkg = "./testpkg_1.0.tar.gz"),
    list(wd = ".", pkg = "./assets/testpkg.zip"),
    list(wd = "assets", pkg = "./testpkg.zip")
  )

  for (set in sets) {
    with_wd(set$wd, {
      p = test_basic_package(set$pkg, "PackageLocal", "testpkg", normalizePath(set$pkg), info = set$pkg)
    })
  }
})

test_that("Local Pacakges Windows", {
  skip_on_os(c("mac", "linux", "solaris"))

  sets = list(
    list(wd = ".", pkg = ".\\assets\\package\\"),
    list(wd = ".", pkg = ".\\assets\\package"),
    list(wd = "assets", pkg = ".\\package\\"),
    list(wd = "assets", pkg = ".\\package"),
    list(wd = "assets\\package", pkg = ".\\"),
    list(wd = "assets\\package", pkg = "."),
    list(wd = ".", pkg = "..\\testthat\\assets\\package\\"),
    list(wd = ".", pkg = "..\\testthat\\assets\\package"),
    list(wd = ".", pkg = normalizePath("assets\\package"))
  )

  for (set in sets) {
    with_wd(set$wd, {
      p = test_basic_package(set$pkg, "PackageLocal", "testpkg", normalizePath(set$pkg), info = set$pkg)
    })
  }
})


test_that("GitHub Packages", {
  s = "mllg/checkmate"
  p = test_basic_package(s, "PackageGitHub", "checkmate", paste0("github::", s))
  expect_equal(p$handle, "mllg/checkmate")

  s = "github::mllg/checkmate@v1.8.4"
  p = test_basic_package(s, "PackageGitHub", "checkmate")
  expect_equal(p$handle, "mllg/checkmate@v1.8.4")

  s = "github::mllg/checkmate/some_where/deep@v1.8.4"
  p = test_basic_package(s, "PackageGitHub", "checkmate")
  expect_equal(p$handle, "mllg/checkmate/some_where/deep@v1.8.4")

  s = "github::mllg/checkmate/some_where/deep"
  p = test_basic_package(s, "PackageGitHub", "checkmate")
  expect_equal(p$handle, "mllg/checkmate/some_where/deep")
})

test_that("GitLab Packages", {
  s = "gitlab::(sub.domain.com/dir):mllg/checkmate/some_where/deep@v1.8.4"
  p = test_basic_package(s, "PackageGitLab", "checkmate")
  expect_equal(p$handle, "mllg/checkmate/some_where/deep@v1.8.4")
  expect_equal(p$host, "sub.domain.com/dir")
})

test_that("Git Packages", {
  s = "https://github.com/mllg/checkmate.git"
  p = test_basic_package(s, "PackageGit", "checkmate")
  expect_false(inherits(p, "PackageGitHub"))
  expect_equal(p$repo, "https://github.com/mllg/checkmate.git")
  expect_equal(p$ref, "")
  expect_equal(p$subdir, "")

  s = "https://github.com/mllg/checkmate.git/some_where/deep@v1.8.4"
  p = test_basic_package(s, "PackageGit", "checkmate")
  expect_equal(p$repo, "https://github.com/mllg/checkmate.git")
  expect_equal(p$ref, "v1.8.4")
  expect_equal(p$subdir, "some_where/deep")

  s = "https://github.com/mllg/checkmate.git/some_where/deep"
  p = test_basic_package(s, "PackageGit", "checkmate")
  expect_equal(p$repo, "https://github.com/mllg/checkmate.git")
  expect_equal(p$ref, "")
  expect_equal(p$subdir, "some_where/deep")
})

test_that("Bitbucket Packages", {
  s = "bitbucket::mllg/checkmate/some_where/deep@v1.8.4"
  p = test_basic_package(s, "PackageBitbucket", "checkmate")
  expect_equal(p$handle, "mllg/checkmate/some_where/deep@v1.8.4")
})

test_that("BioConductor Pacakges", {
  s = "bioc::admin:admin@v1.8.4/checkmate#commit123"
p = test_basic_package(s, "PackageBioc", "checkmate")
  expect_equal(p$handle, "admin:admin@v1.8.4/checkmate#commit123")
})

test_that("Wrong Packages", {
  expect_error(stringToPackage("http://checkmate.de"), "unknown")
})

context("rinstall")

test_that("rinstall works for remote packages", {
  skip_on_cran()
  pkgs = list(
    list(str = "rdatsci/rt/tests/assets/package", name = "testpkg", type = "GitHub"),
    list(str = "rdatsci/rt/tests/assets/package@master", name = "testpkg", type = "GitHub"),
    list(str = "https://github.com/rdatsci/rt.git/tests/assets/package", name = "testpkg", type = "Git"),
    list(str = "https://github.com/rdatsci/rt.git/tests/assets/package@master", name = "testpkg", type = "Git")
  )
  for (pkg in pkgs) {
    expect_true(suppressMessages(rinstall(pkg$str, force = TRUE)), info = pkg$str)
    expect_true(pkg$name %in% rownames(installed.packages()), info = pkg$str)
    expect_true(suppressMessages(rremove(pkg$name)), info = pkg$str)
    expect_true(!(pkg$name %in% rownames(installed.packages())), info = pkg$str)
  }
})

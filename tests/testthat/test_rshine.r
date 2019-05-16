context("rshine")

test_that("rshine", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()

  shiny_path = file.path("assets", "shiny")

  runWithTimeOut = function() {
    setTimeLimit(cpu=5, elapsed=5, transient=TRUE)
    on.exit({
      setTimeLimit(cpu=Inf, elapsed=Inf, transient=FALSE)
    })
    rshine(shiny_path , launch.browser=TRUE)
  }

  a = runWithTimeOut()
  expect_true(is.null(a))
})

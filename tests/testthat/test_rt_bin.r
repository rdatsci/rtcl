context("rtcl bin")

test_that("rtcl bin executables make sense", {
  files = list.files(system.file("bin", package = "rtcl"), full.names = TRUE)
  expect_true(length(files) > 1)
  for (file in files) {
    lines = readLines(file)
    lines = paste(lines, collapse = "\n")
    pattern = '(?m)(?<=^doc = ")[A-Za-z \\s][^}"]*(?=")'
    doc = matchRegex(lines, pattern)[[1]]
    expect_match(doc, "Usage")
    expect_match(doc, basename(file))
    # can not be tested because it calls docopt calls quit() also we do but we could turn this off
    #expect_error(cli.call(basename(file), doc, args = "-h"), "^$", info = file)
    #expect_error(cli.call(basename(file), doc, args = "--notused"), "usage:", info = file)
  }
})

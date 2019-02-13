context("rt bin")

test_that("rt bin executables show help correctly", {
  files = list.files(file.path("..", "..", "inst", "bin"), full.names = TRUE)
  for (file in files) {
    lines = readLines(file)
    lines = paste(lines, collapse = "\n")
    pattern = '(?m)(?<=^doc = ")[A-Za-z \\s][^}"]*(?=")'
    doc = matchRegex(lines, pattern)[[1]]
    expect_error(cli.call("rshine", doc, args = "-h", quit = FALSE), "^$", info = file)
    expect_error(cli.call("rshine", doc, args = "--notused", quit = FALSE), "usage:", info = file)
  }
})

context("rknit")

test_that("rknit works for various files", {
  skip_on_cran()

  files_path = file.path("..", "testknit")

  for (knit_file in dir(files_path, full.names = TRUE)) {
    expect_true(rknit(knit_file, clean = TRUE))
    knit_format = matchRegex(basename(knit_file), "(?<=\\.).+$")[[1]]
    out_base = matchRegex(basename(knit_file), ".+(?=\\.)")[[1]]
    out_format = matchRegex(out_base, "(?<=_).+$")[[1]]
    out_file = paste0(out_base,".",out_format)
    expect_true(file.exists(out_file))
    # cleanup
    file.remove(out_file)
    if (knit_format == "Rnw") {
      unlink("figure", recursive = TRUE)
      file.remove(paste0(out_base, ".tex"))
    }
  }

})

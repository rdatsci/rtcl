context("changeMaintainer")


test_that("changeMaintainer works with options", {
  path = "assets/package"
  temp_maintainer = "Joe Developer <Joe.Developer@some.domain.net>"
  options(rt.maintainer = temp_maintainer)
  new_path = changeMaintainer(path)
  desc = read.dcf(file.path(new_path, "DESCRIPTION"))
  expect_setequal(desc[1, "Maintainer"], temp_maintainer) # setequal to avoid name error
})

test_that("changeMaintainer works with config", {
  path = "assets/package"
  options(rt.maintainer = NULL)
  config_path = getConfigPath("config")
  if (!file.exists(config_path)) {
    temp_maintainer = "Joanna Developer <Joanna.Developer@some.domain.net>"
    writeLines(text = paste0('maintainer = ', temp_maintainer), con = config_path)
    new_path = changeMaintainer(path)
    desc = read.dcf(file.path(new_path, "DESCRIPTION"))
    expect_setequal(desc[1, "Maintainer"], temp_maintainer) # setequal to avoid name error
    file.remove(config_path)
  } else {
    temp_maintainer = readConfig()$maintainer
    if (!is.null(temp_maintainer)) {
      new_path = changeMaintainer(path)
      desc = read.dcf(file.path(new_path, "DESCRIPTION"))
      expect_setequal(desc[1, "Maintainer"], temp_maintainer) # setequal to avoid name error
    }
  }
})

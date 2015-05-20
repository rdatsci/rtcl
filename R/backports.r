if (getRversion() < "3.2.0") {
  dir.exists = function(dirs) {
    assertCharacter(dirs, any.missing = FALSE)
    x = file.info(dirs)$isdir
    !is.na(x) & x
  }
}

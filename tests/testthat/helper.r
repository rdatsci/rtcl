if (!exists("SET_TEMP_LIB")) {
  SET_TEMP_LIB <<- TRUE
  lib = tempfile("rtlib")
  dir.create(lib)
  .libPaths(c(lib, .libPaths()))
}

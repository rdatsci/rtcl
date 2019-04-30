if (FALSE && !exists("SET_TEMP_LIB")) {
  SET_TEMP_LIB <<- TRUE
  lib = tempfile("rtlib")
  dir.create(lib)
  .libPaths(c(lib, .libPaths()))
}

with_wd = function(dir, expr) {
    old_wd = getwd()
    on.exit(setwd(old_wd))
    setwd(dir)
    evalq(expr)
}

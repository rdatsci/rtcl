@echo off
:: start help with "rpkgdown --help"

SET args=%*
Rscript %~dp0/../bin/rpkgdown %args%

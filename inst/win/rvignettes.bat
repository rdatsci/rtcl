@echo off
:: start help with "rvignettes --help"

SET args=%*
Rscript %~dp0/../bin/rvignettes %args%

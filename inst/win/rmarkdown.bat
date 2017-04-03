@echo off
:: start help with "rmarkdown --help"

SET args=%*
Rscript %~dp0/../bin/rmarkdown %args%

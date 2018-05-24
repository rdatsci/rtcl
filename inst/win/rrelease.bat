@echo off
:: start help with "rrelease --help"

SET args=%*
Rscript %~dp0/../bin/rrelease %args%

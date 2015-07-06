@echo off
:: start help with "rmake --help"

SET args=%*
Rscript %~dp0/../bin/rmake %args%

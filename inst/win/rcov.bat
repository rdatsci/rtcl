@echo off
:: start help with "rcov --help"

SET args=%*
Rscript %~dp0/../bin/rcov %args%

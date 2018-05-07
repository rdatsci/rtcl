@echo off
:: start help with "rcompile --help"

SET args=%*
Rscript %~dp0/../bin/rcompile %args%

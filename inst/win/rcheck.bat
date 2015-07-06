@echo off
:: start help with "rcheck --help"

SET args=%*
Rscript %~dp0/../bin/rcheck %args%

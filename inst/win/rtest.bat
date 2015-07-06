@echo off
:: start help with "rtest --help"

SET args=%*
Rscript %~dp0/../bin/rtest %args%

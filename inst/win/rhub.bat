@echo off
:: start help with "rhub --help"

SET args=%*
Rscript %~dp0/../bin/rhub %args%

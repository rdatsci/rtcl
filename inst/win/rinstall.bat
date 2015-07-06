@echo off
:: start help with "rinstall --help"

SET args=%*
Rscript %~dp0/../bin/rinstall %args%

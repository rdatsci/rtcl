@echo off
:: start help with "rwinbuild --help"

SET args=%*
Rscript %~dp0/../bin/rwinbuild %args%

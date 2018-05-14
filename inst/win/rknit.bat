@echo off
:: start help with "rknit --help"

SET args=%*
Rscript %~dp0/../bin/rknit %args%

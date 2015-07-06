@echo off
:: start help with "rt --help"

SET args=%*
Rscript %~dp0/../bin/rt %args%

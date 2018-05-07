@echo off
:: start help with "rremove --help"

SET args=%*
Rscript %~dp0/../bin/rremove %args%

@echo off
:: start help with "rspell --help"

SET args=%*
Rscript %~dp0/../bin/rspell %args%

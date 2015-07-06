@echo off
:: start help with "rbuild --help"

SET args=%*
Rscript %~dp0/../bin/rbuild %args%

@echo off
:: start help with "rtstchk --help"

SET args=%*
Rscript %~dp0/../bin/rtstchk %args%

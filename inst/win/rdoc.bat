@echo off
:: start help with "rdoc --help"

SET args=%*
Rscript %~dp0/../bin/rdoc %args%

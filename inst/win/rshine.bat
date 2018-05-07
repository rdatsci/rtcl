@echo off
:: start help with "rshine --help"

SET args=%*
Rscript %~dp0/../bin/rshine %args%

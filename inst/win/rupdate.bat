@echo off
:: start help with "rupdate --help"

SET args=%*
Rscript %~dp0/../bin/rupdate %args%

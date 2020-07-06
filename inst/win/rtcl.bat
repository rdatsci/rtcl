@echo off
:: start help with "rtcl --help"

SET args=%*
Rscript %~dp0/../bin/rtcl %args%

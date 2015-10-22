@echo off
:: start help with "rusage --help"

SET args=%*
Rscript %~dp0/../bin/rusage %args%

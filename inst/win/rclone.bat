@echo off
:: start help with "rclone --help"

SET args=%*
Rscript %~dp0/../bin/rclone %args%

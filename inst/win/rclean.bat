@echo off
:: start help with "rclean --help"

SET args=%*
Rscript %~dp0/../bin/rclean %args%

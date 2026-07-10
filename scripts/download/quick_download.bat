@echo off
REM KaiWu Office Suite V1.4.1 quick download entry
setlocal EnableExtensions
chcp 936 >nul 2>&1
cd /d "%~dp0\..\.."
echo Downloads must use approved sources and are verified against SHA256 when available.
call "scripts\download\download_all.bat"
exit /b %ERRORLEVEL%
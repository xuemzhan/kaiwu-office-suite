@echo off
REM KaiWu Office Suite V1.4.1 download wrapper
REM Network download is optional and requires an approved network connection.
setlocal EnableExtensions
chcp 936 >nul 2>&1
cd /d "%~dp0\..\.."
where powershell >nul 2>&1
if errorlevel 1 (
  echo [FAIL] PowerShell is unavailable
  exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\download\download_all.ps1"
exit /b %ERRORLEVEL%
@echo off
REM KaiWu Office Suite V1.4.1 - WPS summary capability gate
REM The real summarizer is not bundled. Never return a fake success result.
setlocal EnableExtensions DisableDelayedExpansion
chcp 936 >nul 2>&1
cd /d "%~dp0\..\.."
if not exist "logs" mkdir "logs"
set "DOCUMENT_PATH=%~1"
if not defined DOCUMENT_PATH (
  echo Usage: %~nx0 "document_path"
  exit /b 1
)
echo [%date% %time%] UNSUPPORTED document=%DOCUMENT_PATH%>>"logs\wps_summary.log"
echo [UNSUPPORTED] WPS document summarization is not installed.
echo Required: approved local model service and document parser.
exit /b 2
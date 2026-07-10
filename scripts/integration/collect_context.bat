@echo off
REM KaiWu Office Suite V1.4.1 - collect context (native Win7 WSH)
setlocal EnableExtensions DisableDelayedExpansion
chcp 936 >nul 2>&1
cd /d "%~dp0\..\.."
if not exist "runtime\logs" mkdir "runtime\logs"
if not exist "runtime\results" mkdir "runtime\results"
set "CONTEXT_TYPE=%~1"
set "OUTPUT_FILE=%~2"
if not defined CONTEXT_TYPE set "CONTEXT_TYPE=all"
if not defined OUTPUT_FILE set "OUTPUT_FILE=runtime\results\context.json"
echo [%date% %time%] collect context type=%CONTEXT_TYPE%>>"runtime\logs\collect_context.log"
cscript //nologo "scripts\utils\json_writer.js" context "%OUTPUT_FILE%" "%CONTEXT_TYPE%"
if errorlevel 1 (
  echo [FAIL] Context collection failed
  exit /b 1
)
if not exist "%OUTPUT_FILE%" exit /b 1
echo Context saved to %OUTPUT_FILE%
exit /b 0
@echo off
REM KaiWu Office Suite V1.4.1 - local file search (native Win7 fallback)
setlocal EnableExtensions DisableDelayedExpansion
chcp 936 >nul 2>&1
cd /d "%~dp0\..\.."
if not exist "logs" mkdir "logs"
if not exist "results" mkdir "results"
set "KEYWORD=%~1"
set "SEARCH_PATH=%~2"
set "OUTPUT_FILE=%~3"
if not defined KEYWORD exit /b 1
if not defined SEARCH_PATH set "SEARCH_PATH=%USERPROFILE%"
if not defined OUTPUT_FILE set "OUTPUT_FILE=results\file_search_result.json"
echo [%date% %time%] search started>>"logs\everything_search.log"
if exist "C:\Program Files\Everything\es.exe" (
  "C:\Program Files\Everything\es.exe" -path "%SEARCH_PATH%" "%KEYWORD%" >"results\temp_search.txt" 2>nul
) else (
  dir /s /b "%SEARCH_PATH%\*%KEYWORD%*" >"results\temp_search.txt" 2>nul
)
cscript //nologo "scripts\utils\json_writer.js" search "%OUTPUT_FILE%" "results\temp_search.txt" "%KEYWORD%" "%SEARCH_PATH%"
set "RC=%ERRORLEVEL%"
del /q "results\temp_search.txt" >nul 2>&1
if not "%RC%"=="0" exit /b 1
if not exist "%OUTPUT_FILE%" exit /b 1
echo Search saved to %OUTPUT_FILE%
exit /b 0
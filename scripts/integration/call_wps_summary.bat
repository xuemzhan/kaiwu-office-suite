@echo off
REM WPS document summary script
REM Function: WPS document summarization - 2026-07-07 placeholder
REM Target: Windows 7 SP1 64-bit
REM Generated: 2026-06-17, revised 2026-07-07
REM Status: experimental - accepts any input, exits 0

setlocal enabledelayedexpansion
REM Ensure log and output dirs exist (2026-07-07 fix)
if not exist "logs" mkdir "logs"
if not exist "results" mkdir "results"

REM Parse arguments
set "DOCUMENT_PATH=%~1"
set "SUMMARY_TYPE=%~2"
set "OUTPUT_FILE=%~3"

if "%DOCUMENT_PATH%"=="" (
    echo [ERROR] Document path required
    echo Usage: call_wps_summary.bat document_path summary_type output_file
    echo Summary type: brief / detailed / risk / todo
    exit /b 1
)

if "%SUMMARY_TYPE%"=="" set "SUMMARY_TYPE=brief"
if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=results\summary.txt"

REM Log start
echo [%date% %time%] Start summary: doc=%DOCUMENT_PATH% type=%SUMMARY_TYPE% >> "logs\wps_summary.log"

REM Check WPS registry
set "WPS_INSTALLED=0"
reg query "HKLM\SOFTWARE\Kingsoft\Office" >nul 2>&1
if %errorLevel% equ 0 set "WPS_INSTALLED=1"

REM Check document exists
set "DOC_EXISTS=0"
if exist "%DOCUMENT_PATH%" set "DOC_EXISTS=1"

REM === Real implementation TODO (2026-07-07) ===
REM Needs: Python 3.7+, python-docx, local LLM service
REM Enable: uncomment python call below when all three are present
REM   python "%~dp0call_wps_summary.py" "%DOCUMENT_PATH%" "%SUMMARY_TYPE%" "%OUTPUT_FILE%"

REM Write placeholder output (always succeed, honest status)
> "%OUTPUT_FILE%" echo # Document Summary - Placeholder
>> "%OUTPUT_FILE%" echo.
>> "%OUTPUT_FILE%" echo Generated: %date% %time%
>> "%OUTPUT_FILE%" echo Source: %DOCUMENT_PATH%
>> "%OUTPUT_FILE%" echo Type: %SUMMARY_TYPE%
>> "%OUTPUT_FILE%" echo WPS installed: !WPS_INSTALLED!  Document exists: !DOC_EXISTS!
>> "%OUTPUT_FILE%" echo.
>> "%OUTPUT_FILE%" echo ## Summary Content
>> "%OUTPUT_FILE%" echo.
>> "%OUTPUT_FILE%" echo [WPS summary is placeholder - 2026-07-07]
>> "%OUTPUT_FILE%" echo Real impl requires: Python + python-docx + local LLM
>> "%OUTPUT_FILE%" echo See release_note.md section 7 known issues
>> "%OUTPUT_FILE%" echo.
>> "%OUTPUT_FILE%" echo ## Meta
>> "%OUTPUT_FILE%" echo.
>> "%OUTPUT_FILE%" echo - Script: %~nx0
>> "%OUTPUT_FILE%" echo - Script size: %~z0 bytes

echo Summary complete (placeholder): %OUTPUT_FILE%

REM Log end
echo [%date% %time%] Summary done: out=%OUTPUT_FILE% WPS=!WPS_INSTALLED! doc=!DOC_EXISTS! >> "logs\wps_summary.log"

exit /b 0

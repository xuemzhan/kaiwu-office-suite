@echo off
REM WPS summary test script
REM Purpose: Test WPS document summarization
REM Platform: Windows 7 SP1 64-bit

setlocal enabledelayedexpansion
REM 确保日志与输出目录存在(2026-07-07 修复: 此前缺失 mkdir 导致 14 个 log 断言全 FAIL)
if not exist "logs" mkdir "logs"
if not exist "results" mkdir "results"
set "DOCUMENT_PATH=%~1"
set "SUMMARY_TYPE=%~2"
set "OUTPUT_FILE=%~3"

if "%DOCUMENT_PATH%"=="" (
    echo [ERROR] Document path required
    echo Usage: %0 "document_path" ["summary_type"]
    echo Summary types: brief, detailed, risk, todo
    exit /b 1
)

if "%SUMMARY_TYPE%"=="" set "SUMMARY_TYPE=brief"
if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=results\summary.txt"

if not exist "results" mkdir "results"

echo [%date% %time%] Starting WPS summary: doc=%DOCUMENT_PATH% type=%SUMMARY_TYPE% >> "logs\wps_summary.log"

REM Check WPS
reg query "HKLM\SOFTWARE\Kingsoft\Office" >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] WPS Office not installed
    echo Please install WPS Office
    exit /b 1
)

REM Check document
if not exist "%DOCUMENT_PATH%" (
    echo [ERROR] Document not found: %DOCUMENT_PATH%
    exit /b 1
)

REM Generate summary
echo # Document Summary > "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo **Generated:** %date% %time% >> "%OUTPUT_FILE%"
echo **Source:** %DOCUMENT_PATH% >> "%OUTPUT_FILE%"
echo **Summary type:** %SUMMARY_TYPE% >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo ## Summary >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo [Content pending analysis] >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo ## File Info >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo - Filename: %~nx1 >> "%OUTPUT_FILE%"
echo - File size: %~z1 bytes >> "%OUTPUT_FILE%"
echo - Modified: %~t1 >> "%OUTPUT_FILE%"

echo Summary saved to: %OUTPUT_FILE%

echo [%date% %time%] WPS summary complete: output=%OUTPUT_FILE% >> "logs\wps_summary.log"

exit /b 0

@echo off
REM Git status test script
REM Purpose: Test Git status reporting
REM Platform: Windows 7 SP1 64-bit

setlocal enabledelayedexpansion
REM 确保日志与输出目录存在(2026-07-07 修复: 此前缺失 mkdir 导致 14 个 log 断言全 FAIL)
if not exist "logs" mkdir "logs"
if not exist "results" mkdir "results"
set "REPO_PATH=%~1"
set "OUTPUT_FILE=%~2"

if "%REPO_PATH%"=="" set "REPO_PATH=."
if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=results\git_status.txt"

if not exist "results" mkdir "results"

echo [%date% %time%] Starting Git status check: repo_path=%REPO_PATH% >> "logs\git_status.log"

REM Check Git
git --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Git not installed
    echo Please install Git for Windows
    exit /b 1
)

REM Check if it is a Git repo
cd /d "%REPO_PATH%"
git rev-parse --git-dir >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Not a Git repo: %REPO_PATH%
    exit /b 1
)

REM Generate report
echo # Git Status Report > "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo **Generated:** %date% %time% >> "%OUTPUT_FILE%"
echo **Repo path:** %REPO_PATH% >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo ## Remote Info >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"

for /f "tokens=*" %%i in ('git remote -v') do (
    echo - Remote: %%i >> "%OUTPUT_FILE%"
)

echo. >> "%OUTPUT_FILE%"
echo ## Branch Info >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"

for /f "tokens=*" %%i in ('git branch --show-current') do (
    echo - Current branch: %%i >> "%OUTPUT_FILE%"
)

echo. >> "%OUTPUT_FILE%"
echo ## Changes >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"

for /f "tokens=*" %%i in ('git status --short') do (
    echo - %%i >> "%OUTPUT_FILE%"
)

echo. >> "%OUTPUT_FILE%"
echo ## Recent Commits >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"

for /f "tokens=*" %%i in ('git log --oneline -5') do (
    echo - %%i >> "%OUTPUT_FILE%"
)

echo Git status report saved to: %OUTPUT_FILE%

echo [%date% %time%] Git status report complete >> "logs\git_status.log"

exit /b 0

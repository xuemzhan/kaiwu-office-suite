@echo off
REM KaiWu Office Suite V1.0 - Installer SHA256 verification
REM Generated 2026-07-07
REM Purpose: Verify integrity of all files in packages\raw\ before install

setlocal enabledelayedexpansion
chcp 936 >nul 2>&1

if not exist "logs" mkdir "logs"
set "LOG_FILE=logs\verify_installers_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
echo [%date% %time%] === verify_installers started === > "%LOG_FILE%"

echo ========================================
echo  KaiWu Office Suite V1.0 - Installer Verification
echo  Target: Windows 7 SP1 64-bit
echo ========================================
echo.

REM Find Python (优先 Python 3.14, 退回 py)
where python >nul 2>&1
if %errorLevel% equ 0 (
    set "PY=python"
) else (
    where py >nul 2>&1
    if %errorLevel% equ 0 (
        set "PY=py -3"
    ) else (
        echo [FAIL] Python not found in PATH
        echo [%date% %time%] FAIL: Python missing >> "%LOG_FILE%"
        exit /b 1
    )
)

REM 调 Python 跑校验
%PY% "%~dp0verify_installers.py" 2> "%LOG_FILE%.stderr"
set "RC=%errorLevel%"

REM 把 stderr 显示到控制台
if exist "%LOG_FILE%.stderr" (
    type "%LOG_FILE%.stderr"
    del "%LOG_FILE%.stderr"
)

echo.
if %RC% neq 0 (
    echo [FAIL] SHA256 verification FAILED - some installers corrupted or missing
    echo [%date% %time%] FAIL: rc=%RC% >> "%LOG_FILE%"
    exit /b 1
)
echo [PASS] All installers verified - SHA256 matches manifest
echo [%date% %time%] PASS: all verified >> "%LOG_FILE%"
exit /b 0

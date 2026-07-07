@echo off
REM Agent component check test
REM Purpose: Check AionUI, Hermes Desktop, OpenCode status
REM Platform: Windows 7 SP1 64-bit

setlocal enabledelayedexpansion

REM Locale-stable ISO timestamp via wmic (avoid 12h " AM/PM" and locale-dependent %date% formats)
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value 2^>nul') do set "_DT=%%i"
set "LOG_FILE=logs\check_agent_%_DT:~0,8%_%_DT:~8,6%.log"
if not exist "logs" mkdir "logs"

echo [%date% %time%] Starting Agent component check >> "%LOG_FILE%"

set "INSTALL_DIR=%CD%"

set "TOTAL=0"
set "PASS=0"
set "FAIL=0"
set "WARN=0"

REM 1. Check AionUI
echo [STEP] Checking AionUI...
echo [%date% %time%] Checking AionUI >> "%LOG_FILE%"

set /a TOTAL+=1
set "AIONUI_EXE=%INSTALL_DIR%\installers\01_agent\AionUI.exe"
if exist "%AIONUI_EXE%" (
    echo [PASS] AionUI found: %AIONUI_EXE%
    echo [%date% %time%] [PASS] AionUI found >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [FAIL] AionUI not found: %AIONUI_EXE%
    echo [%date% %time%] [FAIL] AionUI not found >> "%LOG_FILE%"
    set /a FAIL+=1
)

REM 2. Check Hermes Desktop
echo [STEP] Checking Hermes Desktop...
echo [%date% %time%] Checking Hermes Desktop >> "%LOG_FILE%"

set /a TOTAL+=1
set "HERMES_EXE=%INSTALL_DIR%\installers\01_agent\HermesDesktop.exe"
if exist "%HERMES_EXE%" (
    echo [PASS] Hermes Desktop found: %HERMES_EXE%
    echo [%date% %time%] [PASS] Hermes Desktop found >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [FAIL] Hermes Desktop not found: %HERMES_EXE%
    echo [%date% %time%] [FAIL] Hermes Desktop not found >> "%LOG_FILE%"
    set /a FAIL+=1
)

REM 3. Check OpenCode
echo [STEP] Checking OpenCode...
echo [%date% %time%] Checking OpenCode >> "%LOG_FILE%"

set /a TOTAL+=1
set "OPENCODE_EXE=%INSTALL_DIR%\installers\01_agent\OpenCode.exe"
if exist "%OPENCODE_EXE%" (
    echo [PASS] OpenCode found: %OPENCODE_EXE%
    echo [%date% %time%] [PASS] OpenCode found >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [FAIL] OpenCode not found: %OPENCODE_EXE%
    echo [%date% %time%] [FAIL] OpenCode not found >> "%LOG_FILE%"
    set /a FAIL+=1
)

REM 4. Check config files
echo [STEP] Checking config files...
echo [%date% %time%] Checking config files >> "%LOG_FILE%"

set /a TOTAL+=1
set "CONFIG_FILE=%INSTALL_DIR%\config\aionui\aionui.json"
if exist "%CONFIG_FILE%" (
    echo [PASS] AionUI config found: %CONFIG_FILE%
    echo [%date% %time%] [PASS] AionUI config found >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [WARN] AionUI config not found: %CONFIG_FILE%
    echo [%date% %time%] [WARN] AionUI config not found >> "%LOG_FILE%"
    set /a WARN+=1
)

REM 5. Check log directory
echo [STEP] Checking log directory...
echo [%date% %time%] Checking log directory >> "%LOG_FILE%"

set /a TOTAL+=1
set "LOG_DIR=%INSTALL_DIR%\logs"
if exist "%LOG_DIR%" (
    echo [PASS] Log directory found: %LOG_DIR%
    echo [%date% %time%] [PASS] Log directory found >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [WARN] Log directory not found: %LOG_DIR%
    echo [%date% %time%] [WARN] Log directory not found >> "%LOG_FILE%"
    set /a WARN+=1
)

REM 6. Check scripts
echo [STEP] Checking scripts...
echo [%date% %time%] Checking scripts >> "%LOG_FILE%"

set /a TOTAL+=1
set "SCRIPT_DIR=%INSTALL_DIR%\scripts\integration"
if exist "%SCRIPT_DIR%" (
    echo [PASS] Integration scripts found: %SCRIPT_DIR%
    echo [%date% %time%] [PASS] Integration scripts found >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [WARN] Integration scripts not found: %SCRIPT_DIR%
    echo [%date% %time%] [WARN] Integration scripts not found >> "%LOG_FILE%"
    set /a WARN+=1
)

REM Summary
echo ========================================
echo Check Summary
echo ========================================
echo Total: %TOTAL%
echo Pass: %PASS%
echo Fail: %FAIL%
echo Warn: %WARN%
echo ========================================

echo [%date% %time%] Check complete: total=%TOTAL% pass=%PASS% fail=%FAIL% warn=%WARN% >> "%LOG_FILE%"

set /a "PASS_RATE=%PASS% * 100 / %TOTAL%"
echo Pass rate: %PASS_RATE%%

echo [%date% %time%] Pass rate: %PASS_RATE%%% >> "%LOG_FILE%"

if %FAIL% equ 0 (
    echo [OK] All agent components check passed
    echo [%date% %time%] [OK] All agent components check passed >> "%LOG_FILE%"
) else (
    echo [WARN] Some agent components have issues, see details above
    echo [%date% %time%] [WARN] Some agent components have issues >> "%LOG_FILE%"
)

echo [STEP] Detailed log saved to: %LOG_FILE%

exit /b 0

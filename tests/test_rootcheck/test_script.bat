@echo off
REM KaiWu Office Suite V1.0 Environment Check Script (root)
REM Purpose: One-click environment detection
REM Platform: Windows 7 SP1 64-bit

setlocal enabledelayedexpansion

echo ========================================
echo KaiWu Office Suite V1.0 Environment Check
echo Platform: Windows 7 SP1 64-bit
echo ========================================
echo.

if not exist "logs" mkdir "logs"
if not exist "reports" mkdir "reports"
REM Locale-stable ISO timestamp via wmic
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value 2^>nul') do set "_DT=%%i"
set "LOG_FILE=logs\check_%_DT:~0,8%_%_DT:~8,6%.log"
set "REPORT_FILE=reports\check_report_%_DT:~0,8%_%_DT:~8,6%.md"

echo Log file: %LOG_FILE%
echo Report: %REPORT_FILE%
echo.

echo [1/14] Checking .NET Framework 4.8...
reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" /v Version >nul 2>&1
if %errorLevel% equ 0 (
    echo [PASS] .NET Framework 4.8 installed
    echo [PASS] .NET Framework 4.8 installed >> "%REPORT_FILE%"
) else (
    echo [FAIL] .NET Framework 4.8 not found
    echo [FAIL] .NET Framework 4.8 not found >> "%REPORT_FILE%"
)

echo [2/14] Checking VC++ Runtime...
reg query "HKLM\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\X64" /v Version >nul 2>&1
if %errorLevel% equ 0 (
    echo [PASS] VC++ Runtime installed
    echo [PASS] VC++ Runtime installed >> "%REPORT_FILE%"
) else (
    echo [FAIL] VC++ Runtime not found
    echo [FAIL] VC++ Runtime not found >> "%REPORT_FILE%"
)

echo [3/14] Checking WebView2 Runtime...
reg query "HKLM\SOFTWARE\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BEB-23A24D792270}" /v pv >nul 2>&1
if %errorLevel% equ 0 (
    echo [PASS] WebView2 Runtime installed
    echo [PASS] WebView2 Runtime installed >> "%REPORT_FILE%"
) else (
    echo [FAIL] WebView2 Runtime not found
    echo [FAIL] WebView2 Runtime not found >> "%REPORT_FILE%"
)

echo [4/14] Checking Git for Windows...
git --version >nul 2>&1
if %errorLevel% equ 0 (
    echo [PASS] Git for Windows installed
    echo [PASS] Git for Windows installed >> "%REPORT_FILE%"
) else (
    echo [FAIL] Git for Windows not found
    echo [FAIL] Git for Windows not found >> "%REPORT_FILE%"
)

echo [5/14] Checking Everything...
sc query "Everything" >nul 2>&1
if %errorLevel% equ 0 (
    echo [PASS] Everything service running
    echo [PASS] Everything service running >> "%REPORT_FILE%"
) else (
    echo [FAIL] Everything service not running
    echo [FAIL] Everything service not running >> "%REPORT_FILE%"
)

echo [6/14] Checking Tesseract-OCR...
if exist "C:\Program Files\Tesseract-OCR\tesseract.exe" (
    echo [PASS] Tesseract-OCR installed
    echo [PASS] Tesseract-OCR installed >> "%REPORT_FILE%"
) else (
    echo [FAIL] Tesseract-OCR not found
    echo [FAIL] Tesseract-OCR not found >> "%REPORT_FILE%"
)

echo [7/14] Checking WPS Office...
reg query "HKLM\SOFTWARE\Kingsoft\Office" >nul 2>&1
if %errorLevel% equ 0 (
    echo [PASS] WPS Office installed
    echo [PASS] WPS Office installed >> "%REPORT_FILE%"
) else (
    echo [FAIL] WPS Office not found
    echo [FAIL] WPS Office not found >> "%REPORT_FILE%"
)

echo [8/14] Checking AionUI...
REM AionUI detection pending

echo [9/14] Checking Hermes Desktop...
REM Hermes Desktop detection pending

echo [10/14] Checking OpenCode...
REM OpenCode detection pending

echo [11/14] Checking Obsidian...
if exist "%LOCALAPPDATA%\Obsidian\Obsidian.exe" (
    echo [PASS] Obsidian installed
    echo [PASS] Obsidian installed >> "%REPORT_FILE%"
) else (
    echo [FAIL] Obsidian not found
    echo [FAIL] Obsidian not found >> "%REPORT_FILE%"
)

echo [12/14] Checking XMind...
REM XMind detection pending

echo [13/14] Checking tool registry...
if exist "scripts\integration\tool_registry.json" (
    echo [PASS] Tool registry exists
    echo [PASS] Tool registry exists >> "%REPORT_FILE%"
) else (
    echo [FAIL] Tool registry missing
    echo [FAIL] Tool registry missing >> "%REPORT_FILE%"
)

echo [14/14] Checking log directory...
if exist "logs" (
    echo [PASS] Log directory exists
    echo [PASS] Log directory exists >> "%REPORT_FILE%"
) else (
    echo [FAIL] Log directory missing
    echo [FAIL] Log directory missing >> "%REPORT_FILE%"
)

echo.
echo ========================================
echo Check Complete
echo ========================================
echo.
echo Log file: %LOG_FILE%
echo Report: %REPORT_FILE%
echo.
pause

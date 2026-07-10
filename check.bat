@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 936 >nul 2>&1
cd /d "%~dp0" || exit /b 1

REM KaiWu Office Suite V1.4.1 health check
REM Target runtime: Windows 7 SP1 64-bit
REM Keep this file ASCII-only for GBK/Win7 batch compatibility.

set "PASS_COUNT=0"
set "FAIL_COUNT=0"
set "WARN_COUNT=0"

if not exist logs mkdir logs >nul 2>nul
if not exist reports mkdir reports >nul 2>nul
set "STAMP=%RANDOM%_%RANDOM%"
set "LOG_FILE=logs\check_%STAMP%.log"
set "REPORT_FILE=reports\check_report_%STAMP%.md"

call :line "========================================"
call :line "KaiWu Office Suite V1.4.1 health check"
call :line "Target: Windows 7 SP1 64-bit"
call :line "Report: %REPORT_FILE%"
call :line "========================================"
call :line ""

>"%REPORT_FILE%" echo # KaiWu Office Suite V1.4.1 Health Check
>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo Target: Windows 7 SP1 64-bit
>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo ^| Status ^| Item ^| Detail ^|
>>"%REPORT_FILE%" echo ^|---^|---^|---^|

call :line "[1/20] Checking operating system version..."
ver | find "6.1." >nul 2>&1
if errorlevel 1 (call :warn "Windows version" "Not Windows 7 kernel 6.1; use only for build/dev checks") else (call :pass "Windows version" "Windows 7/Server 2008 R2 kernel detected")

call :line "[2/20] Checking .NET Framework 4.x..."
reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" /v Version >nul 2>&1
if errorlevel 1 (call :fail ".NET Framework" "v4 Full key missing") else (call :pass ".NET Framework" "v4 Full key exists")

call :line "[3/20] Checking VC++ Runtime..."
reg query "HKLM\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\X64" /v Version >nul 2>&1
if errorlevel 1 (call :fail "VC++ Runtime" "VisualStudio 14 X64 runtime key missing") else (call :pass "VC++ Runtime" "runtime key exists")

call :line "[4/20] Checking WebView2 Runtime..."
reg query "HKLM\SOFTWARE\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BEB-23A24D792270}" /v pv >nul 2>&1
if errorlevel 1 (call :fail "WebView2 Runtime" "Edge WebView2 runtime key missing") else (call :pass "WebView2 Runtime" "runtime key exists")

call :line "[5/20] Checking Git for Windows..."
git --version >nul 2>&1
if errorlevel 1 (call :fail "Git for Windows" "git.exe not found in PATH") else (call :pass "Git for Windows" "git.exe is available")

call :line "[6/20] Checking Everything..."
sc query "Everything" >nul 2>&1
if errorlevel 1 (
  if exist "%ProgramFiles%\Everything\Everything.exe" (call :pass "Everything" "executable exists; service not detected") else (call :fail "Everything" "service/executable not detected")
) else (call :pass "Everything" "service detected")

call :line "[7/20] Checking Tesseract-OCR..."
if exist "C:\Program Files\Tesseract-OCR\tesseract.exe" (call :pass "Tesseract-OCR" "default executable exists") else (call :fail "Tesseract-OCR" "default executable missing")

call :line "[8/20] Checking WPS Office..."
reg query "HKLM\SOFTWARE\Kingsoft\Office" >nul 2>&1
if errorlevel 1 (
  reg query "HKCU\SOFTWARE\Kingsoft\Office" >nul 2>&1
  if errorlevel 1 (call :fail "WPS Office" "Kingsoft Office registry key missing") else (call :pass "WPS Office" "HKCU registry key exists")
) else (call :pass "WPS Office" "HKLM registry key exists")

call :line "[9/20] Checking WPS/Kaiwu compatibility gate..."
if exist "%APPDATA%\kingsoft\wps\jsaddons\publish.xml" (
  findstr /I "kaiwu" "%APPDATA%\kingsoft\wps\jsaddons\publish.xml" >nul 2>&1
  if errorlevel 1 (call :warn "Kaiwu WPS addon" "publish.xml exists but Kaiwu entry not detected") else (call :warn "Kaiwu WPS addon" "entry detected; still requires Win7 real-machine validation")
) else (call :warn "Kaiwu WPS addon" "not registered; upstream requires Windows 10/11 and WPS 12.1.0.26375+")

call :line "[10/20] Checking AionUI..."
set "AIONUI_R=0"
if exist "%LOCALAPPDATA%\AionUI\AionUI.exe" set "AIONUI_R=1"
if exist "%LOCALAPPDATA%\Programs\AionUI\AionUI.exe" set "AIONUI_R=1"
if "%AIONUI_R%"=="1" (call :pass "AionUI" "standard path detected") else (call :fail "AionUI" "standard path missing")

call :line "[11/20] Checking Hermes Desktop..."
set "HERMES_R=0"
if exist "%LOCALAPPDATA%\Programs\Hermes.Agent.CN.Desktop\Hermes.Agent.CN.Desktop.exe" set "HERMES_R=1"
if exist "%LOCALAPPDATA%\Hermes.Agent.CN.Desktop\Hermes.Agent.CN.Desktop.exe" set "HERMES_R=1"
if "%HERMES_R%"=="1" (call :pass "Hermes Desktop" "standard path detected") else (call :fail "Hermes Desktop" "standard path missing")

call :line "[12/20] Checking OpenCode..."
set "OPENCODE_R=0"
if exist "%LOCALAPPDATA%\Programs\opencode\opencode.exe" set "OPENCODE_R=1"
if exist "%LOCALAPPDATA%\opencode\opencode.exe" set "OPENCODE_R=1"
if "%OPENCODE_R%"=="1" (call :pass "OpenCode" "standard path detected") else (call :fail "OpenCode" "standard path missing")

call :line "[13/20] Checking Obsidian..."
if exist "%LOCALAPPDATA%\Obsidian\Obsidian.exe" (call :pass "Obsidian" "standard path detected") else (call :fail "Obsidian" "standard path missing")

call :line "[14/20] Checking XMind optional component..."
set "XMIND_R=0"
if exist "%LOCALAPPDATA%\Programs\XMind\XMind.exe" set "XMIND_R=1"
if exist "%ProgramFiles%\XMind\XMind.exe" set "XMIND_R=1"
if "%XMIND_R%"=="1" (call :pass "XMind" "optional component detected") else (call :warn "XMind" "optional component not detected")

call :line "[15/20] Checking tool registry..."
if exist "scripts\integration\tool_registry.json" (call :pass "Tool registry" "tool_registry.json exists") else (call :fail "Tool registry" "tool_registry.json missing")

call :line "[16/20] Checking WPS summary gate..."
call scripts\integration\call_wps_summary.bat "C:\nonexistent.docx" >nul 2>&1
if errorlevel 3 (call :fail "WPS summary gate" "unexpected exit code") else if errorlevel 2 (call :pass "WPS summary gate" "unsupported exit code 2 as expected") else (call :fail "WPS summary gate" "did not return unsupported exit code 2")

call :line "[17/20] Checking PPT workflow gate..."
call scripts\integration\call_ppt_workflow.bat "Health check" >nul 2>&1
if errorlevel 3 (call :fail "PPT workflow gate" "unexpected exit code") else if errorlevel 2 (call :pass "PPT workflow gate" "unsupported exit code 2 as expected") else (call :fail "PPT workflow gate" "did not return unsupported exit code 2")

call :line "[18/20] Checking manifest hash file..."
if exist "manifest\SHA256SUMS.txt" (call :pass "SHA256 manifest" "manifest exists") else (call :fail "SHA256 manifest" "manifest missing")

call :line "[19/20] Checking KexStepup release blocker..."
if exist "packages\raw\KexStepup-setup.exe" (call :pass "KexStepup" "installer exists") else (call :fail "KexStepup" "required installer missing; release/install must stay blocked")

call :line "[20/20] Checking log/report directories..."
if exist logs (if exist reports (call :pass "Logs and reports" "directories exist") else (call :fail "Logs and reports" "reports directory missing")) else (call :fail "Logs and reports" "logs directory missing")

call :line ""
call :line "========================================"
call :line "Summary"
call :line "========================================"
call :line "PASS: !PASS_COUNT!"
call :line "FAIL: !FAIL_COUNT!"
call :line "WARN: !WARN_COUNT!"
call :line "Report: %REPORT_FILE%"

>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo Summary: PASS=!PASS_COUNT! FAIL=!FAIL_COUNT! WARN=!WARN_COUNT!

exit /b !FAIL_COUNT!

:line
if "%~1"=="" (
  echo(
  >>"%LOG_FILE%" echo(
) else (
  echo %~1
  >>"%LOG_FILE%" echo %~1
)
exit /b 0

:pass
echo [PASS] %~1 - %~2
>>"%LOG_FILE%" echo [PASS] %~1 - %~2
>>"%REPORT_FILE%" echo ^| PASS ^| %~1 ^| %~2 ^|
set /a PASS_COUNT+=1
exit /b 0

:fail
echo [FAIL] %~1 - %~2
>>"%LOG_FILE%" echo [FAIL] %~1 - %~2
>>"%REPORT_FILE%" echo ^| FAIL ^| %~1 ^| %~2 ^|
set /a FAIL_COUNT+=1
exit /b 0

:warn
echo [WARN] %~1 - %~2
>>"%LOG_FILE%" echo [WARN] %~1 - %~2
>>"%REPORT_FILE%" echo ^| WARN ^| %~1 ^| %~2 ^|
set /a WARN_COUNT+=1
exit /b 0
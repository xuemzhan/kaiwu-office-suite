@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 936 >nul 2>&1
cd /d "%~dp0" || exit /b 1

REM KaiWu Office Suite V1.4.1 release preflight
REM Read-only checks. Does not install, repair, uninstall, or package.
REM Target runtime: Windows 7 SP1 compatible batch syntax.

set "BLOCKERS=0"
set "WARNINGS=0"

echo ========================================
echo KaiWu Office Suite release preflight
echo Target version: V1.4.1
echo ========================================
echo.

call :need_file "README.md" "root README"
call :need_file "BUILD.md" "build guide"
call :need_file "install.bat" "installer"
call :need_file "check.bat" "health check"
call :need_file "verify_installers.bat" "installer verifier"
call :need_file "build_zip.bat" "release builder"
call :need_file "manifest\SHA256SUMS.txt" "SHA256 manifest"
call :need_file "manifest\package-info.json" "package metadata"
call :need_file "docs\09_*.md" "upstream audit report"
call :need_file "docs\10_*.md" "delivery blocker checklist"
call :need_file "scripts\integration\call_wps_summary.bat" "WPS summary gate"
call :need_file "scripts\integration\call_ppt_workflow.bat" "PPT workflow gate"

echo.
echo [CHECK] Installer manifest verification
call verify_installers.bat >nul 2>&1
if errorlevel 1 (call :block "Installer manifest verification failed") else (call :ok "Installer manifest verification passed")

echo.
echo [CHECK] KexStepup release blocker
if exist "packages\raw\KexStepup-setup.exe" (call :ok "KexStepup installer exists") else (call :block "KexStepup-setup.exe is missing")
findstr /I "KexStepup-setup.exe" "manifest\SHA256SUMS.txt" | findstr /V /B "#" >nul 2>&1
if errorlevel 1 (call :block "KexStepup has no active SHA256 entry") else (call :ok "KexStepup has active SHA256 entry")

echo.
echo [CHECK] Unsupported capability gates
call scripts\integration\call_wps_summary.bat "C:\nonexistent.docx" >nul 2>&1
if errorlevel 3 (call :block "WPS summary gate returned unexpected error") else if errorlevel 2 (call :ok "WPS summary gate returns unsupported=2") else (call :block "WPS summary gate did not return unsupported=2")
call scripts\integration\call_ppt_workflow.bat "Preflight" >nul 2>&1
if errorlevel 3 (call :block "PPT workflow gate returned unexpected error") else if errorlevel 2 (call :ok "PPT workflow gate returns unsupported=2") else (call :block "PPT workflow gate did not return unsupported=2")

echo.
echo [CHECK] Optional artifacts
if exist "packages\raw\XMind-23.11.exe" (call :ok "XMind optional installer exists") else (call :warn "XMind optional installer is missing")
if exist "tests\TEST_REPORT.md" (call :ok "Regression test report exists") else (call :warn "Regression test report not found; run tests before handoff")

echo.
echo ========================================
echo Preflight summary
echo ========================================
echo BLOCKERS: !BLOCKERS!
echo WARNINGS: !WARNINGS!
if !BLOCKERS! gtr 0 (
  echo RESULT: NOT READY FOR RELEASE
) else (
  echo RESULT: READY FOR RELEASE PACKAGING CHECKS
)
exit /b !BLOCKERS!

:need_file
if exist "%~1" (call :ok "%~2 exists") else (call :block "%~2 missing: %~1")
exit /b 0

:ok
echo [OK] %~1
exit /b 0

:warn
echo [WARN] %~1
set /a WARNINGS+=1
exit /b 0

:block
echo [BLOCK] %~1
set /a BLOCKERS+=1
exit /b 0
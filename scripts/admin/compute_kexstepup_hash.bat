@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 936 >nul 2>&1
cd /d "%~dp0\..\.." || exit /b 1

REM KaiWu Office Suite V1.4.1 - KexStepup hash helper
REM Read-only helper: computes SHA256 and writes a report. It does not edit manifests.
REM Windows 7 SP1 compatible: uses certutil.

set "TARGET=packages\raw\KexStepup-setup.exe"
set "REPORT=runtime\reports\kexstepup_hash_report.txt"
if not exist "runtime\reports" mkdir "runtime\reports" >nul 2>nul

if not exist "%TARGET%" (
  echo [MISSING] %TARGET%
  >"%REPORT%" echo KexStepup-setup.exe missing
  >>"%REPORT%" echo Expected path: %CD%\%TARGET%
  exit /b 1
)

set "HASH="
for /f "skip=1 tokens=* delims=" %%H in ('certutil -hashfile "%TARGET%" SHA256') do if not defined HASH set "HASH=%%H"
set "HASH=!HASH: =!"
if not defined HASH (
  echo [FAIL] Could not compute SHA256 for %TARGET%
  >"%REPORT%" echo Failed to compute SHA256 for %TARGET%
  exit /b 2
)

for %%F in ("%TARGET%") do set "SIZE=%%~zF"

>"%REPORT%" echo KexStepup hash report
>>"%REPORT%" echo Path: %CD%\%TARGET%
>>"%REPORT%" echo Size: !SIZE! bytes
>>"%REPORT%" echo SHA256: !HASH!
>>"%REPORT%" echo.
>>"%REPORT%" echo Manifest line to add after approval:
>>"%REPORT%" echo !HASH!  KexStepup-setup.exe  (size: !SIZE! bytes)
>>"%REPORT%" echo.
>>"%REPORT%" echo Required follow-up:
>>"%REPORT%" echo 1. Verify source approval and malware scan record.
>>"%REPORT%" echo 2. Add the manifest line to manifest\SHA256SUMS.txt.
>>"%REPORT%" echo 3. Replace KexStepup sha256 in manifest\software-lock.yaml / .md.
>>"%REPORT%" echo 4. Run verify_installers.bat, release_preflight.bat, tests\run_tests.ps1, then build_zip.bat.

echo [OK] SHA256 !HASH!
echo [OK] Report written to %REPORT%
exit /b 0
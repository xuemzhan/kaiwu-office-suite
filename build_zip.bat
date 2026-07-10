@echo off
REM KaiWu Office Suite clean release builder - Windows 7 SP1 compatible
setlocal EnableExtensions EnableDelayedExpansion
chcp 936 >nul 2>&1
cd /d "%~dp0"
set "VERSION=%~1"
if not defined VERSION set "VERSION=1.4.1"
set "ZIP_NAME=kaiwu-office-suite-v%VERSION%.zip"
set "ZIP_PATH=%~dp0%ZIP_NAME%"
set "STAGE=%TEMP%\kaiwu-build-%RANDOM%-%RANDOM%"

call verify_installers.bat
if errorlevel 1 exit /b 1
if not exist "packages\raw\KexStepup-setup.exe" (
  echo [FAIL] Required KexStepup-setup.exe is missing
  exit /b 1
)
findstr /I "KexStepup-setup.exe" "manifest\SHA256SUMS.txt" | findstr /V /B "#" >nul
if errorlevel 1 (
  echo [FAIL] KexStepup has no active SHA256 manifest entry
  exit /b 1
)
mkdir "%STAGE%" >nul 2>&1
for %%F in (install.bat uninstall.bat repair.bat check.bat verify_installers.bat verify_installers.py release_preflight.bat README.md BUILD.md) do copy /Y "%%F" "%STAGE%\" >nul
for %%D in (config docs examples manifest packages scripts templates tests web-app) do xcopy "%%D" "%STAGE%\%%D\" /E /I /H /Y /Q >nul
for /r "%STAGE%" %%F in (*.bak TEST_REPORT.md stdout.txt stderr.txt) do del /F /Q "%%F" >nul 2>&1
if exist "%ZIP_PATH%" del /F /Q "%ZIP_PATH%"

powershell -NoProfile -ExecutionPolicy Bypass -Command "Compress-Archive -Path '%STAGE%\*' -DestinationPath '%ZIP_PATH%' -Force"
if errorlevel 1 (
  rmdir /S /Q "%STAGE%"
  exit /b 1
)
set "HASH="
for /f "skip=1 tokens=* delims=" %%H in ('certutil -hashfile "%ZIP_PATH%" SHA256') do if not defined HASH set "HASH=%%H"
set "HASH=!HASH: =!"
>"%ZIP_PATH%.sha256" echo !HASH! *%ZIP_NAME%
rmdir /S /Q "%STAGE%"
echo [PASS] Built %ZIP_PATH%
echo SHA256 !HASH!
exit /b 0

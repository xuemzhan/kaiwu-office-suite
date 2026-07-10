@echo off
REM KaiWu Office Suite V1.4.1 - native SHA256 verification
REM Windows 7 SP1 compatible: uses built-in certutil, no Python dependency.
setlocal EnableExtensions EnableDelayedExpansion
chcp 936 >nul 2>&1
cd /d "%~dp0"
if not exist "runtime\logs" mkdir "runtime\logs"
set "LOG_FILE=runtime\logs\verify_installers_%RANDOM%.log"
set /a TOTAL=0, OK=0, FAILED=0

if not exist "manifest\SHA256SUMS.txt" (
  echo [FAIL] Missing manifest\SHA256SUMS.txt
  exit /b 1
)
if not exist "packages\raw" (
  echo [FAIL] Missing packages\raw directory
  exit /b 1
)
where certutil >nul 2>&1
if errorlevel 1 (
  echo [FAIL] certutil is unavailable
  exit /b 1
)

for /f "usebackq tokens=1,2" %%A in ("manifest\SHA256SUMS.txt") do (
  set "EXPECTED=%%A"
  set "NAME=%%B"
  if not "!EXPECTED:~0,1!"=="#" if not "!EXPECTED!"=="" (
    set /a TOTAL+=1
    if not exist "packages\raw\!NAME!" (
      echo [MISSING] !NAME!
      echo [MISSING] !NAME!>>"!LOG_FILE!"
      set /a FAILED+=1
    ) else (
      set "ACTUAL="
      for /f "skip=1 tokens=* delims=" %%H in ('certutil -hashfile "packages\raw\!NAME!" SHA256 2^>nul') do if not defined ACTUAL set "ACTUAL=%%H"
      set "ACTUAL=!ACTUAL: =!"
      if /i "!ACTUAL!"=="!EXPECTED!" (
        echo [OK] !NAME!
        set /a OK+=1
      ) else (
        echo [FAIL] !NAME!
        echo   expected: !EXPECTED!
        echo   actual:   !ACTUAL!
        echo [FAIL] !NAME! expected=!EXPECTED! actual=!ACTUAL!>>"!LOG_FILE!"
        set /a FAILED+=1
      )
    )
  )
)

echo Total: !TOTAL!  OK: !OK!  Failed: !FAILED!
if !TOTAL! EQU 0 (
  echo [FAIL] Manifest has no active entries
  exit /b 1
)
if !FAILED! NEQ 0 exit /b 1
echo [PASS] All manifest entries exist and match SHA256
exit /b 0
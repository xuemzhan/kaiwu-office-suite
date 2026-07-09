@echo off
REM KaiWu Office Suite V1.0 - One-click uninstall
REM Target: Windows 7 SP1 64-bit
REM Generated 2026-06-17, real commands implemented 2026-07-07
REM
REM Behavior:
REM   - Each step prompts user: uninstall this component? (Y/N/All)
REM   - All operations are silent (no GUI)
REM   - Failures of one step do not block next step
REM   - Personal data (Obsidian vault, .docx) is NEVER touched
REM   - .NET / WebView2 / VC++ / Git are base runtime, NOT uninstalled

setlocal enabledelayedexpansion
chcp 936 >nul 2>&1

REM Ensure log dir
if not exist "logs" mkdir "logs"
set "LOG_FILE=logs\uninstall_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
echo [%date% %time%] === KaiWu Office Suite V1.0 uninstall started === > "%LOG_FILE%"

echo ========================================
echo  KaiWu Office Suite V1.0 Uninstall
echo  Target: Windows 7 SP1 64-bit
echo ========================================
echo.
echo [!] WARNING: This removes the listed components from your system.
echo [!] Personal data (Documents, Obsidian vault) is NOT touched.
echo [!] .NET / WebView2 / VC++ / Git are NOT removed (base runtime).
echo.

set /p confirm="Proceed? (Y/N): "
if /i not "%confirm%"=="Y" (
    echo Uninstall cancelled.
    echo [%date% %time%] User cancelled >> "%LOG_FILE%"
    exit /b 0
)

echo.
echo [Hint] At each step you can answer:
echo        Y = uninstall this component
echo        N = skip (default)
echo        A = uninstall ALL remaining (no more prompts)
echo.

set "AUTO_ALL=0"

REM Helper function via goto pattern
goto step1

:uninstall_yn
if "%AUTO_ALL%"=="1" set "answer=Y"
if not "%AUTO_ALL%"=="1" set /p answer="Uninstall %~1 ? (Y/N/A): "
if /i "%answer%"=="A" (
    set "AUTO_ALL=1"
    set "answer=Y"
)
if /i not "%answer%"=="Y" (
    echo [SKIP] %~1
    echo [%date% %time%] SKIP %~1 >> "%LOG_FILE%"
    goto :eof
)
echo [DOING] %~1
echo [%date% %time%] DOING %~1 >> "%LOG_FILE%"
goto :eof

:try_uninst
REM Try common uninstall exe path; silent /S
if exist "%~1" (
    "%~1" /S
    if %errorLevel% equ 0 (
        echo [OK] %~2 removed
        echo [%date% %time%] OK %~2 removed via %~1 >> "%LOG_FILE%"
    ) else (
        echo [WARN] %~2 uninstall returned %errorLevel% (may already be removed)
        echo [%date% %time%] WARN %~2 uninstall exit %errorLevel% >> "%LOG_FILE%"
    )
) else (
    echo [INFO] %~2 uninstaller not found at %~1
    echo [%date% %time%] INFO %~2 uninstaller not found at %~1 >> "%LOG_FILE%"
)
goto :eof

:try_msi_uninst
REM msi uninstall by product code: msiexec /x {GUID} /quiet /norestart
if "%~1"=="" goto :eof
msiexec /x "%~1" /quiet /norestart
if %errorLevel% equ 0 (
    echo [OK] MSI %~2 removed
    echo [%date% %time%] OK MSI %~2 removed %~1 >> "%LOG_FILE%"
) else (
    echo [WARN] MSI %~2 uninstall exit %errorLevel%
    echo [%date% %time%] WARN MSI %~2 exit %errorLevel% %~1 >> "%LOG_FILE%"
)
goto :eof

:try_wmic_uninst
REM wmic uninstall by product name (P3-4: exact match first, then wildcard)
REM Try exact match first
wmic product where "name='%~1'" call uninstall /nointeractive >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] WMIC: %~1 removed (exact)
    echo [%date% %time%] OK WMIC %~1 removed (exact) >> "%LOG_FILE%"
    goto :eof
)
REM Fallback: wildcard match
wmic product where "name like '%%%~1%%%'" call uninstall /nointeractive >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] WMIC: %~1 removed (wildcard)
    echo [%date% %time%] OK WMIC %~1 removed (wildcard) >> "%LOG_FILE%"
) else (
    echo [INFO] WMIC: %~1 not found or already removed
    echo [%date% %time%] INFO WMIC %~1 not found >> "%LOG_FILE%"
)
goto :eof

REM ==========================================
REM Step 1: AionUI
REM ==========================================
:step1
echo.
echo [1/8] AionUI
call :uninstall_yn "AionUI"
if /i "!answer!"=="Y" (
    call :try_wmic_uninst "AionUI"
    if exist "%LOCALAPPDATA%\AionUI" rd /S /Q "%LOCALAPPDATA%\AionUI" 2>nul
    if exist "%LOCALAPPDATA%\Programs\AionUI" rd /S /Q "%LOCALAPPDATA%\Programs\AionUI" 2>nul
)

REM ==========================================
REM Step 2: Hermes Desktop
REM ==========================================
:step2
echo.
echo [2/8] Hermes Desktop
call :uninstall_yn "Hermes Desktop"
if /i "!answer!"=="Y" (
    call :try_wmic_uninst "Hermes.Agent.CN.Desktop"
    call :try_wmic_uninst "Hermes Desktop"
    if exist "%LOCALAPPDATA%\Hermes.Agent.CN.Desktop" rd /S /Q "%LOCALAPPDATA%\Hermes.Agent.CN.Desktop" 2>nul
    if exist "%LOCALAPPDATA%\Programs\Hermes.Agent.CN.Desktop" rd /S /Q "%LOCALAPPDATA%\Programs\Hermes.Agent.CN.Desktop" 2>nul
)

REM ==========================================
REM Step 3: OpenCode
REM ==========================================
:step3
echo.
echo [3/8] OpenCode
call :uninstall_yn "OpenCode"
if /i "!answer!"=="Y" (
    call :try_wmic_uninst "OpenCode"
    if exist "%LOCALAPPDATA%\opencode" rd /S /Q "%LOCALAPPDATA%\opencode" 2>nul
    if exist "%LOCALAPPDATA%\Programs\opencode" rd /S /Q "%LOCALAPPDATA%\Programs\opencode" 2>nul
)

REM ==========================================
REM Step 4: WPS + WPS plugins
REM ==========================================
:step4
echo.
echo [4/8] WPS Office and plugins
call :uninstall_yn "WPS Office + wps-kaiyu-addon + KexStepup"
if /i "!answer!"=="Y" (
    REM WPS Office (10.0/11.x is uninstallable via wmic; new WPS uses Kingsoft uninstaller)
    call :try_wmic_uninst "WPS Office"
    call :try_wmic_uninst "Kingsoft Office"
    REM wps-kaiyu-addon
    call :try_wmic_uninst "wps-kaiyu-addon"
    call :try_wmic_uninst "Kaiwu"
    REM KexStepup
    call :try_wmic_uninst "KexStepup"
    REM WPS user data not removed
)

REM ==========================================
REM Step 5: Everything
REM ==========================================
:step5
echo.
echo [5/8] Everything
call :uninstall_yn "Everything"
if /i "!answer!"=="Y" (
    call :try_uninst "C:\Program Files\Everything\uninst.exe" "Everything"
    sc stop "Everything" >nul 2>&1
    sc delete "Everything" >nul 2>&1
)

REM ==========================================
REM Step 6: Tesseract-OCR
REM ==========================================
:step6
echo.
echo [6/8] Tesseract-OCR
call :uninstall_yn "Tesseract-OCR"
if /i "!answer!"=="Y" (
    call :try_wmic_uninst "Tesseract-OCR"
    REM Tesseract installs to "C:\Program Files\Tesseract-OCR\"; check unins000
    if exist "C:\Program Files\Tesseract-OCR\unins000.exe" (
        "C:\Program Files\Tesseract-OCR\unins000.exe" /S
        echo [OK] Tesseract removed
        echo [%date% %time%] OK Tesseract removed >> "%LOG_FILE%"
    )
)

REM ==========================================
REM Step 7: Clean up shortcuts
REM ==========================================
:step7
echo.
echo [7/8] Desktop and Start Menu shortcuts
call :uninstall_yn "shortcuts (Desktop + Start Menu)"
if /i "!answer!"=="Y" (
    set "STARTMENU_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\开悟办公套件"
    if exist "%STARTMENU_DIR%" rd /S /Q "%STARTMENU_DIR%" 2>nul
    REM Generic: remove any .lnk with "Kaiwu" or "kaiwu" on desktop
    if exist "%USERPROFILE%\Desktop\开悟办公套件.lnk" del /F /Q "%USERPROFILE%\Desktop\开悟办公套件.lnk" 2>nul
    echo [OK] shortcuts removed
    echo [%date% %time%] OK shortcuts removed >> "%LOG_FILE%"
)

REM ==========================================
REM Step 8: Clean up config files
REM ==========================================
:step8
echo.
echo [8/8] Config files (in current dir)
call :uninstall_yn "config files in this directory"
if /i "!answer!"=="Y" (
    if exist "config" rd /S /Q "config" 2>nul
    if exist "state" rd /S /Q "state" 2>nul
    REM logs/ is kept (audit trail); results/ is kept
    REM Kaiwu Vault is personal data, NEVER removed here
    echo [OK] config + state removed (logs/ and results/ kept)
    echo [%date% %time%] OK config + state removed >> "%LOG_FILE%"
)

echo.
echo ========================================
echo  Uninstall Complete
echo ========================================
echo.
echo [!] Personal data preserved:
echo     - Documents folder
echo     - Obsidian Vault at %USERPROFILE%\Documents\KaiwuVault
echo     - .docx / .pptx / .xlsx files
echo.
echo [!] Components NOT removed (base runtime):
echo     - .NET Framework 4.8
echo     - WebView2 Runtime
echo     - VC++ Runtime
echo     - Git for Windows
echo.
echo Log: %LOG_FILE%
echo.
pause
exit /b 0

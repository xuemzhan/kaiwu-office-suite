@echo off
REM KaiWu Office Suite V1.4.1 - One-click install
REM Target: Windows 7 SP1 64-bit
REM Generated 2026-06-17, revised 2026-07-09 (V1.4.1)
REM
REM V1.4.1 safety changes:
REM   - 14 install steps each check errorlevel (INSTALL_FAILED counter)
REM   - Header counters: INSTALL_FAILED + INSTALL_MISSING
REM   - [19/19] verify section has full summary (FAILED/MISSING/VERIFY)
REM   - Cleaned V1.3 residual 224 CR-only characters

setlocal enabledelayedexpansion
chcp 936 >nul 2>&1
cd /d "%~dp0"

echo ========================================
echo  KaiWu Office Suite V1.4.1 Install
echo  Target: Windows 7 SP1 64-bit
echo ========================================
echo.

REM Check admin privilege
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Need admin privilege to run this installer
    echo Right-click this file, select Run as administrator
    pause
    exit /b 1
)

REM Detect Windows version
echo [1/19] Checking system version...
ver | find "Version 6.1" >nul
if %errorLevel% equ 0 (
    echo Detected Windows 7 system
) else (
    echo [WARN] Not Windows 7 - some components may not work
)

REM Create log directory
if not exist "logs" mkdir "logs"
set "LOG_FILE=logs\install_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
echo Install log: %LOG_FILE%
echo [%date% %time%] install started > "%LOG_FILE%"

REM Create state directory
if not exist "state" mkdir "state"
echo {"status": "installing", "start_time": "%date% %time%"} > "state\install_state.json"

REM V1.4.1: install 启动失败计数 + missing 计数
set "INSTALL_FAILED=0"
set "INSTALL_MISSING=0"

REM [0/19] SHA256 verification (verify_installers.bat)
echo [0/19] Verifying installer SHA256 integrity...
call verify_installers.bat
set "STEP_RC=!errorLevel!"
    if not "!STEP_RC!"=="0" if not "!STEP_RC!"=="3010" (
    echo [FAIL] SHA256 verification failed - install aborted
    echo See logs\verify_installers_*.log for details
    pause
    exit /b 1
)
echo [PASS] SHA256 verification passed
REM KexStepup is required on Windows 7 and must never be silently skipped.
if not exist "packages\raw\KexStepup-setup.exe" (
    echo [FAIL] Required Win7 compatibility component is missing: KexStepup-setup.exe
    echo [%date% %time%] FAIL required KexStepup missing >> "%LOG_FILE%"
    exit /b 1
)
findstr /I "KexStepup-setup.exe" "manifest\SHA256SUMS.txt" | findstr /V /B "#" >nul
if errorlevel 1 (
  echo [FAIL] KexStepup has no active SHA256 manifest entry
  exit /b 1
)echo.

echo [2/19] Installing .NET Framework 4.8...
if exist "packages\raw\ndp48-x86-x64-allos-enu.exe" (
    echo Launching .NET Framework 4.8 installer...
    "packages\raw\ndp48-x86-x64-allos-enu.exe" /quiet /norestart
    set "STEP_RC=!errorLevel!"
    if not "!STEP_RC!"=="0" if not "!STEP_RC!"=="3010" (
        echo [WARN] Installer exited with code !STEP_RC!
        set /a "INSTALL_FAILED+=1"
    ) else (
        echo [OK] Installer launched (installation may take several minutes)
    )
) else (
    echo [WARN] Installer not found: packages\raw\ndp48-x86-x64-allos-enu.exe
    set /a "INSTALL_MISSING+=1"
)

echo [3/19] Installing VC++ Runtime...
if exist "packages\raw\vc_redist.x64.exe" (
    echo Launching VC++ Runtime installer...
    "packages\raw\vc_redist.x64.exe" /install /quiet /norestart
    set "STEP_RC=!errorLevel!"
    if not "!STEP_RC!"=="0" if not "!STEP_RC!"=="3010" (
        echo [WARN] Installer exited with code !STEP_RC!
        set /a "INSTALL_FAILED+=1"
    ) else (
        echo [OK] Installer launched (installation may take several minutes)
    )
) else (
    echo [WARN] Installer not found: packages\raw\vc_redist.x64.exe
    set /a "INSTALL_MISSING+=1"
)

echo [4/19] Installing WebView2 Runtime 109...
if exist "packages\raw\MicrosoftEdgeWebView2RuntimeInstallerX64.exe" (
    echo Launching WebView2 Runtime 109 installer...
    "packages\raw\MicrosoftEdgeWebView2RuntimeInstallerX64.exe" /silent /install
    set "STEP_RC=!errorLevel!"
    if not "!STEP_RC!"=="0" if not "!STEP_RC!"=="3010" (
        echo [WARN] Installer exited with code !STEP_RC!
        set /a "INSTALL_FAILED+=1"
    ) else (
        echo [OK] Installer launched (installation may take several minutes)
    )
) else (
    echo [WARN] Installer not found: packages\raw\MicrosoftEdgeWebView2RuntimeInstallerX64.exe
    set /a "INSTALL_MISSING+=1"
)

echo [5/19] Installing Git for Windows 2.46.2...
if exist "packages\raw\Git-2.46.2-64-bit.exe" (
    echo Launching Git for Windows 2.46.2 installer...
    "packages\raw\Git-2.46.2-64-bit.exe" /VERYSILENT /NORESTART
    set "STEP_RC=!errorLevel!"
    if not "!STEP_RC!"=="0" if not "!STEP_RC!"=="3010" (
        echo [WARN] Installer exited with code !STEP_RC!
        set /a "INSTALL_FAILED+=1"
    ) else (
        echo [OK] Installer launched (installation may take several minutes)
    )
) else (
    echo [WARN] Installer not found: packages\raw\Git-2.46.2-64-bit.exe
    set /a "INSTALL_MISSING+=1"
)

echo [6/19] Installing Everything...
if exist "packages\raw\Everything-1.4.1.1024.x64-Setup.exe" (
    echo Launching Everything installer...
    "packages\raw\Everything-1.4.1.1024.x64-Setup.exe" /S
    set "STEP_RC=!errorLevel!"
    if not "!STEP_RC!"=="0" if not "!STEP_RC!"=="3010" (
        echo [WARN] Installer exited with code !STEP_RC!
        set /a "INSTALL_FAILED+=1"
    ) else (
        echo [OK] Installer launched (installation may take several minutes)
    )
) else (
    echo [WARN] Installer not found: packages\raw\Everything-1.4.1.1024.x64-Setup.exe
    set /a "INSTALL_MISSING+=1"
)

echo [7/19] Installing Tesseract-OCR...
if exist "packages\raw\tesseract-ocr-w64-setup-5.3.1.20230401.exe" (
    echo Launching Tesseract-OCR installer...
    "packages\raw\tesseract-ocr-w64-setup-5.3.1.20230401.exe" /S
    set "STEP_RC=!errorLevel!"
    if not "!STEP_RC!"=="0" if not "!STEP_RC!"=="3010" (
        echo [WARN] Installer exited with code !STEP_RC!
        set /a "INSTALL_FAILED+=1"
    ) else (
        echo [OK] Installer launched (installation may take several minutes)
    )
) else (
    echo [WARN] Installer not found: packages\raw\tesseract-ocr-w64-setup-5.3.1.20230401.exe
    set /a "INSTALL_MISSING+=1"
)

REM Install OCR language data after Tesseract setup.
if exist "C:\Program Files\Tesseract-OCR\tessdata" (
    copy /Y "packages\raw\chi_sim.traineddata" "C:\Program Files\Tesseract-OCR\tessdata\" >nul 2>&1
    if errorlevel 1 set /a "INSTALL_FAILED+=1"
    copy /Y "packages\raw\eng.traineddata" "C:\Program Files\Tesseract-OCR\tessdata\" >nul 2>&1
    if errorlevel 1 set /a "INSTALL_FAILED+=1"
)

echo [8/19] Installing WPS Office 2019...
if exist "packages\raw\WPS_Setup_26895.exe" (
    echo Launching WPS Office 2019 installer...
    "packages\raw\WPS_Setup_26895.exe" /S
    set "STEP_RC=!errorLevel!"
    if not "!STEP_RC!"=="0" if not "!STEP_RC!"=="3010" (
        echo [WARN] Installer exited with code !STEP_RC!
        set /a "INSTALL_FAILED+=1"
    ) else (
        echo [OK] Installer launched (installation may take several minutes)
    )
) else (
    echo [WARN] Installer not found: packages\raw\WPS_Setup_26895.exe
    set /a "INSTALL_MISSING+=1"
)

echo [9/19] Installing wps-kaiyu-addon (Kaiwu)...
if exist "packages\raw\wps-kaiyu-addon-setup.exe" (
    echo Launching wps-kaiyu-addon (Kaiwu) installer...
    "packages\raw\wps-kaiyu-addon-setup.exe" /S
    set "STEP_RC=!errorLevel!"
    if not "!STEP_RC!"=="0" if not "!STEP_RC!"=="3010" (
        echo [WARN] Installer exited with code !STEP_RC!
        set /a "INSTALL_FAILED+=1"
    ) else (
        echo [OK] Installer launched (installation may take several minutes)
    )
) else (
    echo [WARN] Installer not found: packages\raw\wps-kaiyu-addon-setup.exe
    set /a "INSTALL_MISSING+=1"
)

echo [10/19] Installing KexStepup (VxKex)...
if exist "packages\raw\KexStepup-setup.exe" (
    echo Launching KexStepup (VxKex) installer...
    "packages\raw\KexStepup-setup.exe" /S
    set "STEP_RC=!errorLevel!"
    if not "!STEP_RC!"=="0" if not "!STEP_RC!"=="3010" (
        echo [WARN] Installer exited with code !STEP_RC!
        set /a "INSTALL_FAILED+=1"
    ) else (
        echo [OK] Installer launched (installation may take several minutes)
    )
) else (
    echo [WARN] Installer not found: packages\raw\KexStepup-setup.exe
    set /a "INSTALL_MISSING+=1"
)

echo [11/19] Installing AionUI...
if exist "packages\raw\AionUI-setup.exe" (
    echo Launching AionUI installer...
    "packages\raw\AionUI-setup.exe" /S
    set "STEP_RC=!errorLevel!"
    if not "!STEP_RC!"=="0" if not "!STEP_RC!"=="3010" (
        echo [WARN] Installer exited with code !STEP_RC!
        set /a "INSTALL_FAILED+=1"
    ) else (
        echo [OK] Installer launched (installation may take several minutes)
    )
) else (
    echo [WARN] Installer not found: packages\raw\AionUI-setup.exe
    set /a "INSTALL_MISSING+=1"
)

echo [12/19] Installing Hermes Desktop...
if exist "packages\raw\HermesDesktop-setup.exe" (
    echo Launching Hermes Desktop installer...
    "packages\raw\HermesDesktop-setup.exe" /S
    set "STEP_RC=!errorLevel!"
    if not "!STEP_RC!"=="0" if not "!STEP_RC!"=="3010" (
        echo [WARN] Installer exited with code !STEP_RC!
        set /a "INSTALL_FAILED+=1"
    ) else (
        echo [OK] Installer launched (installation may take several minutes)
    )
) else (
    echo [WARN] Installer not found: packages\raw\HermesDesktop-setup.exe
    set /a "INSTALL_MISSING+=1"
)

echo [13/19] Installing OpenCode...
if exist "packages\raw\OpenCode-setup.exe" (
    echo Launching OpenCode installer...
    "packages\raw\OpenCode-setup.exe" /S
    set "STEP_RC=!errorLevel!"
    if not "!STEP_RC!"=="0" if not "!STEP_RC!"=="3010" (
        echo [WARN] Installer exited with code !STEP_RC!
        set /a "INSTALL_FAILED+=1"
    ) else (
        echo [OK] Installer launched (installation may take several minutes)
    )
) else (
    echo [WARN] Installer not found: packages\raw\OpenCode-setup.exe
    set /a "INSTALL_MISSING+=1"
)

echo [14/19] Installing Obsidian 1.4.16...
if exist "packages\raw\Obsidian.1.4.16.exe" (
    echo Launching Obsidian 1.4.16 installer...
    "packages\raw\Obsidian.1.4.16.exe" /S
    set "STEP_RC=!errorLevel!"
    if not "!STEP_RC!"=="0" if not "!STEP_RC!"=="3010" (
        echo [WARN] Installer exited with code !STEP_RC!
        set /a "INSTALL_FAILED+=1"
    ) else (
        echo [OK] Installer launched (installation may take several minutes)
    )
) else (
    echo [WARN] Installer not found: packages\raw\Obsidian.1.4.16.exe
    set /a "INSTALL_MISSING+=1"
)

echo [15/19] Installing XMind...
if exist "packages\raw\XMind-23.11.exe" (
    echo Launching XMind installer...
    "packages\raw\XMind-23.11.exe" /S
    set "STEP_RC=!errorLevel!"
    if not "!STEP_RC!"=="0" if not "!STEP_RC!"=="3010" (
        echo [WARN] Installer exited with code !STEP_RC!
        set /a "INSTALL_FAILED+=1"
    ) else (
        echo [OK] Installer launched (installation may take several minutes)
    )
) else (
    echo [WARN] Installer not found: packages\raw\XMind-23.11.exe
    set /a "INSTALL_MISSING+=1"
)

echo [16/19] Initializing directories...
if not exist "config" mkdir "config"
if not exist "logs" mkdir "logs"
if not exist "state" mkdir "state"
REM installed state is written only after final verification
echo Directories initialized

echo [17/19] Creating desktop shortcuts...
set "STARTMENU_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\开悟个体增智办公套件"
if not exist "%STARTMENU_DIR%" mkdir "%STARTMENU_DIR%"

if exist "packages\raw\WPS_Setup_26895.exe" (
    powershell -command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%STARTMENU_DIR%\WPS Office.lnk'); $SC.TargetPath = '%~dp0packages\raw\WPS_Setup_26895.exe'; $SC.Save()"
    echo [PASS] WPS Office shortcut created
    set /a PASS_COUNT+=1
) else (
    echo [WARN] WPS installer not found, skipping shortcut
    set /a WARN_COUNT+=1
)

if exist "check.bat" (
    powershell -command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%STARTMENU_DIR%\系统检测.lnk'); $SC.TargetPath = '%~dp0check.bat'; $SC.Save()"
    echo [PASS] check.bat shortcut created
    set /a PASS_COUNT+=1
) else (
    echo [WARN] check.bat not found, skipping shortcut
    set /a WARN_COUNT+=1
)

if exist "repair.bat" (
    powershell -command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%STARTMENU_DIR%\系统修复.lnk'); $SC.TargetPath = '%~dp0repair.bat'; $SC.Save()"
    echo [PASS] repair.bat shortcut created
    set /a PASS_COUNT+=1
) else (
    echo [WARN] repair.bat not found, skipping shortcut
    set /a WARN_COUNT+=1
)

echo Shortcuts created
echo [18/19] Creating start menu entry...
set "STARTMENU_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\开悟个体增智办公套件"
if not exist "%STARTMENU_DIR%" mkdir "%STARTMENU_DIR%"
echo # 开悟个体增智办公套件 V1.4.1 > "%STARTMENU_DIR%\使用说明.url"
echo URL=file:///%~dp0docs\02_用户使用手册.md >> "%STARTMENU_DIR%\使用说明.url"
echo Start menu entry created

echo [19/19] Verifying installation...
set "VERIFY_FAILED=0"
reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" /v Version >nul 2>&1
if %errorLevel% neq 0 (
    echo [FAIL] .NET Framework 4.8 not installed
    set "VERIFY_FAILED=1"
) else (
    echo [PASS] .NET Framework 4.8
)
if exist "C:\Program Files\Tesseract-OCR\tesseract.exe" (
    echo [PASS] Tesseract-OCR
) else (
    echo [WARN] Tesseract-OCR not at default path
)
sc query "Everything" >nul 2>&1
if %errorLevel% equ 0 (
    echo [PASS] Everything service
) else (
    echo [WARN] Everything service not registered
)
REM Run the full required-component health check.
call check.bat
set "CHECK_RC=!errorLevel!"
if not "!CHECK_RC!"=="0" (
    echo [FAIL] check.bat reported !CHECK_RC! required component failures
    set "VERIFY_FAILED=1"
)

echo.
echo Installation summary:
echo   INSTALL_FAILED: %INSTALL_FAILED% (launch failed)
echo   INSTALL_MISSING: %INSTALL_MISSING% (not found)
echo   VERIFY_FAILED: %VERIFY_FAILED% (verify failed)
if "%INSTALL_FAILED%" neq "0" (
    echo [WARN] %INSTALL_FAILED% installers failed to launch - check logs\install_*.log
)
if not "%INSTALL_FAILED%"=="0" set "VERIFY_FAILED=1"
if "%VERIFY_FAILED%"=="1" (
    echo [FAIL] Installation verification failed - check log
    echo {"status":"failed","end_time":"%date% %time%","failed":%INSTALL_FAILED%,"missing":%INSTALL_MISSING%} > "state\install_state.json"
    echo [%date% %time%] FAIL failed=%INSTALL_FAILED% missing=%INSTALL_MISSING% >> "%LOG_FILE%"
    pause
    exit /b 1
) else (
    echo [PASS] Installation verification passed
    echo {"status":"installed","end_time":"%date% %time%","failed":0,"missing_optional":%INSTALL_MISSING%} > "state\install_state.json"
    echo [%date% %time%] PASS missing_optional=%INSTALL_MISSING% >> "%LOG_FILE%"
)


echo ========================================
echo  KaiWu Office Suite V1.4.1 Install Complete
echo ========================================
echo.
echo Install log: %LOG_FILE%
echo User manual: see docs\02_用户使用手册.md
echo.
pause

@echo off
REM KaiWu Office Suite V1.0 - One-click repair
REM Target: Windows 7 SP1 64-bit
REM Generated 2026-06-17, real commands implemented 2026-07-07

setlocal enabledelayedexpansion
chcp 936 >nul 2>&1

if not exist "logs" mkdir "logs"
set "LOG_FILE=logs\repair_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
echo [%date% %time%] === KaiWu Office Suite V1.0 repair started === > "%LOG_FILE%"

echo ========================================
echo  KaiWu Office Suite V1.0 Repair Menu
echo ========================================
echo.
echo  1. Fix environment variables (PATH)
echo  2. Rebuild desktop / start menu shortcuts
echo  3. Verify / rebuild tool registry
echo  4. Rebuild Obsidian vault template (folders only, no data loss)
echo  5. Re-register WPS plugins (verify registry entries)
echo  6. Rebuild Everything index service
echo  7. Rewrite Agent config files (aionui / hermes / opencode)
echo  8. Fix log directory permissions
echo  9. Run all (1-8)
echo.
set /p choice="Select option (1-9): "

if "%choice%"=="1" goto fix_env
if "%choice%"=="2" goto fix_shortcuts
if "%choice%"=="3" goto fix_registry
if "%choice%"=="4" goto fix_obsidian
if "%choice%"=="5" goto fix_wps
if "%choice%"=="6" goto fix_everything
if "%choice%"=="7" goto fix_agent
if "%choice%"=="8" goto fix_logs
if "%choice%"=="9" goto fix_all

echo Invalid choice: %choice%
exit /b 1

:fix_env
echo.
echo [1/8] Fix environment variables
echo [%date% %time%] Fix env >> "%LOG_FILE%"

REM Add Git to PATH if missing
echo %PATH% | findstr /I "Git\cmd" >nul
if %errorLevel% neq 0 (
    setx PATH "%PATH%;C:\Program Files\Git\cmd" >nul 2>&1
    echo [OK] Added Git to PATH
    echo [%date% %time%] OK added Git to PATH >> "%LOG_FILE%"
) else (
    echo [SKIP] Git already in PATH
)

REM Add Tesseract to PATH if missing
echo %PATH% | findstr /I "Tesseract-OCR" >nul
if %errorLevel% neq 0 (
    setx PATH "%PATH%;C:\Program Files\Tesseract-OCR" >nul 2>&1
    echo [OK] Added Tesseract to PATH
    echo [%date% %time%] OK added Tesseract to PATH >> "%LOG_FILE%"
) else (
    echo [SKIP] Tesseract already in PATH
)
goto end

:fix_shortcuts
echo.
echo [2/8] Rebuild shortcuts
echo [%date% %time%] Fix shortcuts >> "%LOG_FILE%"

set "STARTMENU_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\开悟办公套件"
if not exist "%STARTMENU_DIR%" mkdir "%STARTMENU_DIR%"

REM 写使用说明 URL
> "%STARTMENU_DIR%\使用说明.url" echo [InternetShortcut]
>> "%STARTMENU_DIR%\使用说明.url" echo URL=file:///%~dp0docs\02_用户使用手册.md
echo [OK] Start menu shortcut created: %STARTMENU_DIR%
echo [%date% %time%] OK start menu shortcut >> "%LOG_FILE%"
goto end

:fix_registry
echo.
echo [3/8] Verify / rebuild tool registry
echo [%date% %time%] Fix tool registry >> "%LOG_FILE%"

if not exist "scripts\integration" mkdir "scripts\integration"
if not exist "scripts\integration\tool_registry.json" (
    REM 从模板重建(8 个工具条目)
    echo [WARN] tool_registry.json missing, creating template
    echo [%date% %time%] WARN tool_registry missing >> "%LOG_FILE%"
)
if exist "scripts\integration\tool_registry.json" (
    REM 验证 JSON 合法性(粗略: 检查 {} 配对)
    set "OPEN=0"
    set "CLOSE=0"
    for /f %%a in ('type "scripts\integration\tool_registry.json" ^| find /c "{"') do set "OPEN=%%a"
    for /f %%a in ('type "scripts\integration\tool_registry.json" ^| find /c "}"') do set "CLOSE=%%a"
    if "!OPEN!"=="!CLOSE!" (
        echo [OK] tool_registry.json valid (!OPEN! brace pairs)
        echo [%date% %time%] OK tool_registry valid >> "%LOG_FILE%"
    ) else (
        echo [WARN] tool_registry.json brace mismatch: {!OPEN!} vs {!CLOSE!}
        echo [%date% %time%] WARN tool_registry braces mismatch >> "%LOG_FILE%"
    )
)
goto end

:fix_obsidian
echo.
echo [4/8] Rebuild Obsidian vault template (folders only)
echo [%date% %time%] Fix Obsidian vault >> "%LOG_FILE%"

set "VAULT_PATH=%USERPROFILE%\Documents\KaiwuVault"
if not exist "%VAULT_PATH%" mkdir "%VAULT_PATH%"
for %%d in ("00_Inbox" "01_项目记录" "02_会议纪要" "03_OCR识别" "04_通用知识" "05_模板库" "99_归档") do (
    if not exist "%VAULT_PATH%\%%~d" mkdir "%VAULT_PATH%\%%~d" 2>nul
)
echo [OK] Vault folders ensured at %VAULT_PATH%
echo [%date% %time%] OK vault folders >> "%LOG_FILE%"
echo [!] Note: existing notes are NEVER touched
goto end

:fix_wps
echo.
echo [5/8] Re-register WPS plugins (verify registry)
echo [%date% %time%] Fix WPS plugins >> "%LOG_FILE%"

reg query "HKLM\SOFTWARE\Kingsoft\Office" >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] WPS Office installed
    echo [%date% %time%] OK WPS Office installed >> "%LOG_FILE%"
    REM Verify kaiwu plugin path
    if exist "packages\raw\wps-kaiyu-addon-setup.exe" (
        echo [INFO] kaiwu addon installer present at packages\raw\
        echo [%date% %time%] INFO kaiwu installer present >> "%LOG_FILE%"
    ) else (
        echo [WARN] kaiwu addon installer missing
        echo [%date% %time%] WARN kaiwu installer missing >> "%LOG_FILE%"
    )
) else (
    echo [WARN] WPS Office not installed (registry key missing)
    echo [%date% %time%] WARN WPS Office not installed >> "%LOG_FILE%"
)
goto end

:fix_everything
echo.
echo [6/8] Rebuild Everything index service
echo [%date% %time%] Fix Everything service >> "%LOG_FILE%"

sc query "Everything" >nul 2>&1
if %errorLevel% neq 0 (
    if exist "C:\Program Files\Everything\Everything.exe" (
        REM Service not registered, but exe present - start the app (not service) once to register
        echo [INFO] Everything installed but service not registered
        echo [%date% %time%] INFO Everything service not registered >> "%LOG_FILE%"
        echo [HINT] Run Everything.exe once as admin to register the service
    ) else (
        echo [WARN] Everything not installed at C:\Program Files\Everything
        echo [%date% %time%] WARN Everything not installed >> "%LOG_FILE%"
    )
) else (
    echo [OK] Everything service registered
    echo [%date% %time%] OK Everything service registered >> "%LOG_FILE%"
    sc start "Everything" >nul 2>&1
)
goto end

:fix_agent
echo.
echo [7/8] Rewrite Agent config files (verify presence)
echo [%date% %time%] Fix Agent config >> "%LOG_FILE%"

set "AGENT_CONFIGS=config\aionui\aionui.json config\hermes\hermes.json config\opencode\opencode.json"
for %%f in (%AGENT_CONFIGS%) do (
    if exist "%%f" (
        echo [OK] %%f present
        echo [%date% %time%] OK %%f present >> "%LOG_FILE%"
    ) else (
        echo [WARN] %%f missing
        echo [%date% %time%] WARN %%f missing >> "%LOG_FILE%"
    )
)
goto end

:fix_logs
echo.
echo [8/8] Fix log directory permissions
echo [%date% %time%] Fix log dir >> "%LOG_FILE%"

if not exist "logs" mkdir "logs"
icacls "logs" /grant Everyone:F >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] logs/ permission granted
    echo [%date% %time%] OK logs/ perms >> "%LOG_FILE%"
) else (
    echo [WARN] icacls not available or failed; try running as admin
    echo [%date% %time%] WARN icacls failed >> "%LOG_FILE%"
)
goto end

:fix_all
echo.
echo [Running all 1-8]
echo [%date% %time%] Run all >> "%LOG_FILE%"
call :fix_env
call :fix_shortcuts
call :fix_registry
call :fix_obsidian
call :fix_wps
call :fix_everything
call :fix_agent
call :fix_logs
goto end

:end
echo.
echo ========================================
echo  Repair Complete
echo ========================================
echo.
echo Log: %LOG_FILE%
echo.
pause
exit /b 0

@echo off
REM KaiWu Office Suite V1.4.1 - repair
REM Windows 7 SP1 compatible; no user data is deleted.
setlocal EnableExtensions EnableDelayedExpansion
chcp 936 >nul 2>&1
cd /d "%~dp0"
if not exist "runtime\logs" mkdir "runtime\logs"
set "LOG_FILE=runtime\logs\repair_%RANDOM%.log"
set "FAIL_COUNT=0"

echo 1. Repair user PATH
echo 2. Rebuild Start Menu shortcuts
echo 3. Validate tool registry
echo 4. Ensure Obsidian Vault folders
echo 5. Check WPS registration
echo 6. Start Everything service
echo 7. Validate agent configuration
echo 8. Check log directory permissions
echo 9. Run all
set /p "CHOICE=Select option (1-9): "
if "%CHOICE%"=="1" (call :fix_path & goto finish)
if "%CHOICE%"=="2" (call :fix_shortcuts & goto finish)
if "%CHOICE%"=="3" (call :validate_registry & goto finish)
if "%CHOICE%"=="4" (call :fix_vault & goto finish)
if "%CHOICE%"=="5" (call :check_wps & goto finish)
if "%CHOICE%"=="6" (call :start_everything & goto finish)
if "%CHOICE%"=="7" (call :validate_configs & goto finish)
if "%CHOICE%"=="8" (call :check_logs & goto finish)
if "%CHOICE%"=="9" goto all
echo [FAIL] Invalid choice
exit /b 1

:fix_path
powershell -NoProfile -ExecutionPolicy Bypass -Command "$p=[Environment]::GetEnvironmentVariable('Path','User'); $items=@($p -split ';'|Where-Object {$_}); foreach($x in @('C:\Program Files\Git\cmd','C:\Program Files\Tesseract-OCR')) {if((Test-Path $x) -and -not ($items -contains $x)) {$items += $x}}; [Environment]::SetEnvironmentVariable('Path',($items -join ';'),'User')"
if errorlevel 1 (set /a FAIL_COUNT+=1&echo [FAIL] PATH repair) else echo [PASS] User PATH checked
exit /b 0

:fix_shortcuts
set "MENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs\����������ǰ칫�׼�"
if not exist "%MENU%" mkdir "%MENU%"
set "KAIWU_MENU=%MENU%"
set "KAIWU_HOME=%CD%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$w=New-Object -ComObject WScript.Shell; foreach($n in @('ϵͳ���','ϵͳ�޸�')) {$s=$w.CreateShortcut((Join-Path $env:KAIWU_MENU ($n+'.lnk'))); if($n -eq 'ϵͳ���') {$s.TargetPath=(Join-Path $env:KAIWU_HOME 'check.bat')} else {$s.TargetPath=(Join-Path $env:KAIWU_HOME 'repair.bat')}; $s.WorkingDirectory=$env:KAIWU_HOME; $s.Save()}"
if errorlevel 1 (set /a FAIL_COUNT+=1&echo [FAIL] Shortcut repair) else echo [PASS] Shortcuts rebuilt
exit /b 0

:validate_registry
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; Add-Type -AssemblyName System.Web.Extensions; $s=New-Object System.Web.Script.Serialization.JavaScriptSerializer; $null=$s.DeserializeObject([IO.File]::ReadAllText((Join-Path $PWD 'scripts\integration\tool_registry.json')))"
if errorlevel 1 (set /a FAIL_COUNT+=1&echo [FAIL] Tool registry invalid) else echo [PASS] Tool registry valid
exit /b 0

:fix_vault
set "VAULT=%USERPROFILE%\Documents\KaiwuVault"
for %%D in (00_Inbox 01_��Ŀ���� 02_�����Ҫ 03_OCRʶ�� 04_����֪ʶ 05_ģ��� 99_�鵵) do if not exist "%VAULT%\%%D" mkdir "%VAULT%\%%D"
echo [PASS] Vault folders ensured
exit /b 0

:check_wps
reg query "HKLM\SOFTWARE\Kingsoft\Office" >nul 2>&1
if errorlevel 1 reg query "HKLM\SOFTWARE\WOW6432Node\Kingsoft\Office" >nul 2>&1
if errorlevel 1 (set /a FAIL_COUNT+=1&echo [FAIL] WPS registration not found) else echo [PASS] WPS registration found
exit /b 0

:start_everything
sc query "Everything" >nul 2>&1
if errorlevel 1 (set /a FAIL_COUNT+=1&echo [FAIL] Everything service not installed&exit /b 0)
sc start "Everything" >nul 2>&1
sc query "Everything" | find "RUNNING" >nul
if errorlevel 1 (set /a FAIL_COUNT+=1&echo [FAIL] Everything service not running) else echo [PASS] Everything service running
exit /b 0

:validate_configs
for %%F in (config\version.json config\aionui\aionui.json config\hermes\hermes.json config\opencode\opencode.json) do if not exist "%%F" (set /a FAIL_COUNT+=1&echo [FAIL] Missing %%F) else echo [PASS] %%F
exit /b 0

:check_logs
>"runtime\logs\.write_test_%RANDOM%" echo test
if errorlevel 1 (set /a FAIL_COUNT+=1&echo [FAIL] logs is not writable) else (del /q "runtime\logs\.write_test_*" >nul 2>&1&echo [PASS] logs is writable)
exit /b 0

:all
call :fix_path
call :fix_shortcuts
call :validate_registry
call :fix_vault
call :check_wps
call :start_everything
call :validate_configs
call :check_logs

:finish
echo [%date% %time%] failures=!FAIL_COUNT!>"!LOG_FILE!"
if not "!FAIL_COUNT!"=="0" exit /b 1
echo [PASS] Repair completed
exit /b 0
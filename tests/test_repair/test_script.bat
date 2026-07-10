@echo off
REM Agent repair test script
REM Purpose: Test repair for AionUI, Hermes Desktop, OpenCode
REM Platform: Windows 7 SP1 64-bit

setlocal enabledelayedexpansion

REM Locale-stable ISO timestamp via wmic
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value 2^>nul') do set "_DT=%%i"
set "LOG_FILE=runtime\logs\repair_agent_%_DT:~0,8%_%_DT:~8,6%.log"
if not exist "runtime\logs" mkdir "runtime\logs"

echo [%date% %time%] Starting Agent component repair >> "%LOG_FILE%"

REM Check admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Administrator privileges required
    echo [ERROR] Please right-click and select "Run as administrator"
    echo [%date% %time%] ERROR: Admin privileges required >> "%LOG_FILE%"
    exit /b 1
)

echo [PASS] Admin privileges confirmed >> "%LOG_FILE%"

set "INSTALL_DIR=%CD%"
set "BACKUP_DIR=%INSTALL_DIR%\backup"

REM 1. Create backup directory
echo [STEP] Creating backup directory...
echo [%date% %time%] Creating backup directory >> "%LOG_FILE%"

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
if not exist "%BACKUP_DIR%\agent" mkdir "%BACKUP_DIR%\agent"

REM 2. Backup existing Agent components
echo [STEP] Backing up Agent components...
echo [%date% %time%] Backing up Agent components >> "%LOG_FILE%"

set "AGENT_DIR=%INSTALL_DIR%\packages\raw\01_agent"
if exist "%AGENT_DIR%" (
    echo [INFO] Found Agent directory: %AGENT_DIR%
    echo [%date% %time%] Found Agent directory: %AGENT_DIR% >> "%LOG_FILE%"
    
    xcopy "%AGENT_DIR%" "%BACKUP_DIR%\agent\" /E /I /H /Y /Q >nul 2>&1
    if %errorLevel% equ 0 (
        echo [PASS] Backup complete
        echo [%date% %time%] Backup complete >> "%LOG_FILE%"
    ) else (
        echo [WARN] Backup failed
        echo [%date% %time%] WARN: Backup failed >> "%LOG_FILE%"
    )
)

REM 3. Verify directory structure
echo [STEP] Verifying directory structure...
echo [%date% %time%] Verifying directory structure >> "%LOG_FILE%"

for %%d in (
    packages\raw\00_runtime
    packages\raw\01_agent
    packages\raw\02_office
    packages\raw\03_tools
    packages\raw\04_knowledge
    packages\raw\05_optional
    config\aionui
    config\hermes
    config\opencode
    logs
    scripts\integration
    scripts\install
    scripts\uninstall
    scripts\check
    scripts\repair
    scripts\utils
    templates
    examples
) do (
    if not exist "%INSTALL_DIR%\%%d" (
        echo [INFO] Creating directory: %%d
        echo [%date% %time%] Creating directory: %%d >> "%LOG_FILE%"
        mkdir "%INSTALL_DIR%\%%d" >nul 2>&1
    )
)

REM 4. Verify config files
echo [STEP] Verifying config files...
echo [%date% %time%] Verifying config files >> "%LOG_FILE%"

for %%f in (
    config\aionui\aionui.json
    config\hermes\hermes.json
    config\opencode\opencode.json
    config\everything\everything.json
    config\tesseract\tesseract.json
    config\obsidian\obsidian.json
    config\wps-addon\wps_addon.json
) do (
    if not exist "%INSTALL_DIR%\%%f" (
        echo [WARN] Config file missing: %%f
        echo [%date% %time%] WARN: Config file missing: %%f >> "%LOG_FILE%"
    ) else (
        echo [PASS] Config file exists: %%f
        echo [%date% %time%] [PASS] Config file exists: %%f >> "%LOG_FILE%"
    )
)

REM 5. Verify log directories
echo [STEP] Verifying log directories...
echo [%date% %time%] Verifying log directories >> "%LOG_FILE%"

for %%d in (
    runtime\logs\aionui
    runtime\logs\hermes
    runtime\logs\opencode
    runtime\logs\everything
    runtime\logs\tesseract
    runtime\logs\obsidian
    runtime\logs\wps_addon
) do (
    if not exist "%INSTALL_DIR%\%%d" (
        echo [INFO] Creating log directory: %%d
        echo [%date% %time%] Creating log directory: %%d >> "%LOG_FILE%"
        mkdir "%INSTALL_DIR%\%%d" >nul 2>&1
    )
)

REM 6. Verify scripts
echo [STEP] Verifying scripts...
echo [%date% %time%] Verifying scripts >> "%LOG_FILE%"

for %%s in (
    call_everything_search.bat
    call_tesseract_ocr.bat
    call_wps_summary.bat
    call_obsidian_note.bat
    call_xmind_outline.bat
    call_git_status.bat
    open_project_folder.bat
    collect_context.bat
) do (
    if not exist "%INSTALL_DIR%\scripts\integration\%%s" (
        echo [WARN] Script missing: %%s
        echo [%date% %time%] WARN: Script missing: %%s >> "%LOG_FILE%"
    ) else (
        echo [PASS] Script exists: %%s
        echo [%date% %time%] [PASS] Script exists: %%s >> "%LOG_FILE%"
    )
)

REM 7. Verify tool registry
echo [STEP] Verifying tool registry...
echo [%date% %time%] Verifying tool registry >> "%LOG_FILE%"

set "TOOL_REGISTRY=%INSTALL_DIR%\scripts\integration\tool_registry.json"
if not exist "%TOOL_REGISTRY%" (
    echo [WARN] Tool registry missing: %TOOL_REGISTRY%
    echo [%date% %time%] WARN: Tool registry missing >> "%LOG_FILE%"
) else (
    echo [PASS] Tool registry found: %TOOL_REGISTRY%
    echo [%date% %time%] [PASS] Tool registry found >> "%LOG_FILE%"
)

echo [%date% %time%] Agent repair complete >> "%LOG_FILE%"
echo [STEP] Detailed log saved to: %LOG_FILE%

exit /b 0

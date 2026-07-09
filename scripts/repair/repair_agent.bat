@echo off
REM Agent组件修复脚本
REM 功能: 修复AionUI、Hermes Desktop、OpenCode
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion

REM 设置日志文件
set "LOG_FILE=logs\repair_agent_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
if not exist "logs" mkdir "logs"

echo [%date% %time%] 开始修复Agent组件 >> "%LOG_FILE%"

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 需要管理员权限运行此脚本
    echo [错误] 请右键点击"以管理员身份运行"
    echo [%date% %time%] 错误: 缺少管理员权限 >> "%LOG_FILE%"
    exit /b 1
)

echo [信息] 检查到管理员权限 >> "%LOG_FILE%"

REM 设置修复目录
set "INSTALL_DIR=%~dp0..\.."
set "BACKUP_DIR=%INSTALL_DIR%\backup"

REM 1. 创建备份目录
echo [信息] 创建备份目录...
echo [%date% %time%] 创建备份目录 >> "%LOG_FILE%"

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
if not exist "%BACKUP_DIR%\agent" mkdir "%BACKUP_DIR%\agent"

REM 2. 备份现有文件
echo [信息] 备份现有文件...
echo [%date% %time%] 备份现有文件 >> "%LOG_FILE%"

set "AGENT_DIR=%INSTALL_DIR%\packages\raw\01_agent"
if exist "%AGENT_DIR%" (
    echo [信息] 备份Agent目录: %AGENT_DIR%
    echo [%date% %time%] 备份Agent目录: %AGENT_DIR% >> "%LOG_FILE%"
    
    REM 使用xcopy备份
    xcopy "%AGENT_DIR%" "%BACKUP_DIR%\agent\" /E /I /H /Y /Q >nul 2>&1
    if %errorLevel% equ 0 (
        echo [成功] 备份完成
        echo [%date% %time%] 备份完成 >> "%LOG_FILE%"
    ) else (
        echo [警告] 备份可能不完整
        echo [%date% %time%] 警告: 备份可能不完整 >> "%LOG_FILE%"
    )
)

REM 3. 检查并创建目录结构
echo [信息] 检查目录结构...
echo [%date% %time%] 检查目录结构 >> "%LOG_FILE%"

set "REQUIRED_DIRS=(
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
)"

for %%d in (%REQUIRED_DIRS%) do (
    if not exist "%INSTALL_DIR%\%%d" (
        echo [信息] 创建目录: %%d
        echo [%date% %time%] 创建目录: %%d >> "%LOG_FILE%"
        mkdir "%INSTALL_DIR%\%%d" >nul 2>&1
    )
)

REM 4. 检查配置文件
echo [信息] 检查配置文件...
echo [%date% %time%] 检查配置文件 >> "%LOG_FILE%"

set "CONFIG_FILES=(
    config\aionui\aionui.json
    config\hermes\hermes.json
    config\opencode\opencode.json
    config\everything\everything.json
    config\tesseract\tesseract.json
    config\obsidian\obsidian.json
    config\wps-addon\wps_addon.json
)"

for %%f in (%CONFIG_FILES%) do (
    if not exist "%INSTALL_DIR%\%%f" (
        echo [警告] 配置文件不存在: %%f
        echo [%date% %time%] 警告: 配置文件不存在: %%f >> "%LOG_FILE%"
    ) else (
        echo [通过] 配置文件存在: %%f
        echo [%date% %time%] [通过] 配置文件存在: %%f >> "%LOG_FILE%"
    )
)

REM 5. 检查日志目录
echo [信息] 检查日志目录...
echo [%date% %time%] 检查日志目录 >> "%LOG_FILE%"

set "LOG_DIRS=(
    logs\aionui
    logs\hermes
    logs\opencode
    logs\everything
    logs\tesseract
    logs\obsidian
    logs\wps_addon
)"

for %%d in (%LOG_DIRS%) do (
    if not exist "%INSTALL_DIR%\%%d" (
        echo [信息] 创建日志目录: %%d
        echo [%date% %time%] 创建日志目录: %%d >> "%LOG_FILE%"
        mkdir "%INSTALL_DIR%\%%d" >nul 2>&1
    )
)

REM 6. 检查集成脚本
echo [信息] 检查集成脚本...
echo [%date% %time%] 检查集成脚本 >> "%LOG_FILE%"

set "INTEGRATION_SCRIPTS=(
    call_everything_search.bat
    call_tesseract_ocr.bat
    call_wps_summary.bat
    call_obsidian_note.bat
    call_xmind_outline.bat
    call_git_status.bat
    open_project_folder.bat
    collect_context.bat
)"

for %%s in (%INTEGRATION_SCRIPTS%) do (
    if not exist "%INSTALL_DIR%\scripts\integration\%%s" (
        echo [警告] 集成脚本不存在: %%s
        echo [%date% %time%] 警告: 集成脚本不存在: %%s >> "%LOG_FILE%"
    ) else (
        echo [通过] 集成脚本存在: %%s
        echo [%date% %time%] [通过] 集成脚本存在: %%s >> "%LOG_FILE%"
    )
)

REM 7. 检查工具注册表
echo [信息] 检查工具注册表...
echo [%date% %time%] 检查工具注册表 >> "%LOG_FILE%"

set "TOOL_REGISTRY=%INSTALL_DIR%\scripts\integration\tool_registry.json"
if not exist "%TOOL_REGISTRY%" (
    echo [警告] 工具注册表不存在: %TOOL_REGISTRY%
    echo [%date% %time%] 警告: 工具注册表不存在 >> "%LOG_FILE%"
) else (
    echo [通过] 工具注册表存在: %TOOL_REGISTRY%
    echo [%date% %time%] [通过] 工具注册表存在 >> "%LOG_FILE%"
)

echo [%date% %time%] Agent组件修复完成 >> "%LOG_FILE%"
echo [信息] 修复完成，请查看日志文件: %LOG_FILE%

exit /b 0

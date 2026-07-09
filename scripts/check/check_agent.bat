@echo off
REM Agent组件检测脚本
REM 功能: 检测AionUI、Hermes Desktop、OpenCode状态
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion

REM 设置日志文件
set "LOG_FILE=logs\check_agent_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
if not exist "logs" mkdir "logs"

echo [%date% %time%] 开始检测Agent组件 >> "%LOG_FILE%"

REM 设置检测目录
set "INSTALL_DIR=%~dp0..\.."

REM 初始化计数器
set "TOTAL=0"
set "PASS=0"
set "FAIL=0"
set "WARN=0"

REM 1. 检测 AionUI
echo [信息] 检测 AionUI...
echo [%date% %time%] 检测 AionUI >> "%LOG_FILE%"

set /a TOTAL+=1
set "AIONUI_EXE=%INSTALL_DIR%\packages\raw\01_agent\AionUI.exe"
if exist "%AIONUI_EXE%" (
    echo [通过] AionUI 存在: %AIONUI_EXE%
    echo [%date% %time%] [通过] AionUI 存在 >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [失败] AionUI 不存在: %AIONUI_EXE%
    echo [%date% %time%] [失败] AionUI 不存在 >> "%LOG_FILE%"
    set /a FAIL+=1
)

REM 2. 检测 Hermes Desktop
echo [信息] 检测 Hermes Desktop...
echo [%date% %time%] 检测 Hermes Desktop >> "%LOG_FILE%"

set /a TOTAL+=1
set "HERMES_EXE=%INSTALL_DIR%\packages\raw\01_agent\HermesDesktop.exe"
if exist "%HERMES_EXE%" (
    echo [通过] Hermes Desktop 存在: %HERMES_EXE%
    echo [%date% %time%] [通过] Hermes Desktop 存在 >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [失败] Hermes Desktop 不存在: %HERMES_EXE%
    echo [%date% %time%] [失败] Hermes Desktop 不存在 >> "%LOG_FILE%"
    set /a FAIL+=1
)

REM 3. 检测 OpenCode
echo [信息] 检测 OpenCode...
echo [%date% %time%] 检测 OpenCode >> "%LOG_FILE%"

set /a TOTAL+=1
set "OPENCODE_EXE=%INSTALL_DIR%\packages\raw\01_agent\OpenCode.exe"
if exist "%OPENCODE_EXE%" (
    echo [通过] OpenCode 存在: %OPENCODE_EXE%
    echo [%date% %time%] [通过] OpenCode 存在 >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [失败] OpenCode 不存在: %OPENCODE_EXE%
    echo [%date% %time%] [失败] OpenCode 不存在 >> "%LOG_FILE%"
    set /a FAIL+=1
)

REM 4. 检测配置文件
echo [信息] 检测配置文件...
echo [%date% %time%] 检测配置文件 >> "%LOG_FILE%"

set /a TOTAL+=1
set "CONFIG_FILE=%INSTALL_DIR%\config\aionui\aionui.json"
if exist "%CONFIG_FILE%" (
    echo [通过] AionUI配置文件存在: %CONFIG_FILE%
    echo [%date% %time%] [通过] AionUI配置文件存在 >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [警告] AionUI配置文件不存在: %CONFIG_FILE%
    echo [%date% %time%] [警告] AionUI配置文件不存在 >> "%LOG_FILE%"
    set /a WARN+=1
)

REM 5. 检测日志目录
echo [信息] 检测日志目录...
echo [%date% %time%] 检测日志目录 >> "%LOG_FILE%"

set /a TOTAL+=1
set "LOG_DIR=%INSTALL_DIR%\logs"
if exist "%LOG_DIR%" (
    echo [通过] 日志目录存在: %LOG_DIR%
    echo [%date% %time%] [通过] 日志目录存在 >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [警告] 日志目录不存在: %LOG_DIR%
    echo [%date% %time%] [警告] 日志目录不存在 >> "%LOG_FILE%"
    set /a WARN+=1
)

REM 6. 检测集成脚本
echo [信息] 检测集成脚本...
echo [%date% %time%] 检测集成脚本 >> "%LOG_FILE%"

set /a TOTAL+=1
set "SCRIPT_DIR=%INSTALL_DIR%\scripts\integration"
if exist "%SCRIPT_DIR%" (
    echo [通过] 集成脚本目录存在: %SCRIPT_DIR%
    echo [%date% %time%] [通过] 集成脚本目录存在 >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [警告] 集成脚本目录不存在: %SCRIPT_DIR%
    echo [%date% %time%] [警告] 集成脚本目录不存在 >> "%LOG_FILE%"
    set /a WARN+=1
)

REM 输出统计信息
echo ========================================
echo 检测统计
echo ========================================
echo 总检测项: %TOTAL%
echo 通过: %PASS%
echo 失败: %FAIL%
echo 警告: %WARN%
echo ========================================

echo [%date% %time%] 检测统计: 总计=%TOTAL% 通过=%PASS% 失败=%FAIL% 警告=%WARN% >> "%LOG_FILE%"

REM 计算通过率
set /a "PASS_RATE=%PASS% * 100 / %TOTAL%"
echo 通过率: %PASS_RATE%%%

echo [%date% %time%] 通过率: %PASS_RATE%%% >> "%LOG_FILE%"

REM 判断整体状态
if %FAIL% equ 0 (
    echo [状态] Agent组件检测通过
    echo [%date% %time%] [状态] Agent组件检测通过 >> "%LOG_FILE%"
) else (
    echo [状态] Agent组件检测失败，需要修复
    echo [%date% %time%] [状态] Agent组件检测失败，需要修复 >> "%LOG_FILE%"
)

echo [信息] 检测完成，请查看日志文件: %LOG_FILE%

exit /b 0

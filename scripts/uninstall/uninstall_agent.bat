@echo off
REM Agent组件卸载脚本
REM 功能: 卸载AionUI、Hermes Desktop、OpenCode
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion

REM 设置日志文件
set "LOG_FILE=logs\uninstall_agent_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
if not exist "logs" mkdir "logs"

echo [%date% %time%] 开始卸载Agent组件 >> "%LOG_FILE%"

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 需要管理员权限运行此脚本
    echo [错误] 请右键点击"以管理员身份运行"
    echo [%date% %time%] 错误: 缺少管理员权限 >> "%LOG_FILE%"
    exit /b 1
)

echo [信息] 检查到管理员权限 >> "%LOG_FILE%"

REM 设置卸载目录
set "INSTALL_DIR=C:\KaiwuOfficeSuite"

REM 1. 卸载 AionUI
echo [信息] 卸载 AionUI...
echo [%date% %time%] 卸载 AionUI >> "%LOG_FILE%"

set "AIONUI_EXE=%INSTALL_DIR%\installers\01_agent\AionUI.exe"
if exist "%AIONUI_EXE%" (
    echo [信息] 找到AionUI: %AIONUI_EXE%
    echo [%date% %time%] 找到AionUI: %AIONUI_EXE% >> "%LOG_FILE%"
    
    REM 删除AionUI可执行文件
    del /f "%AIONUI_EXE%" >nul 2>&1
    if %errorLevel% equ 0 (
        echo [成功] AionUI 卸载完成
        echo [%date% %time%] AionUI 卸载完成 >> "%LOG_FILE%"
    ) else (
        echo [错误] AionUI 卸载失败
        echo [%date% %time%] AionUI 卸载失败 >> "%LOG_FILE%"
    )
) else (
    echo [警告] 未找到AionUI
    echo [%date% %time%] 警告: 未找到AionUI >> "%LOG_FILE%"
)

REM 2. 卸载 Hermes Desktop
echo [信息] 卸载 Hermes Desktop...
echo [%date% %time%] 卸载 Hermes Desktop >> "%LOG_FILE%"

set "HERMES_EXE=%INSTALL_DIR%\installers\01_agent\HermesDesktop.exe"
if exist "%HERMES_EXE%" (
    echo [信息] 找到Hermes Desktop: %HERMES_EXE%
    echo [%date% %time%] 找到Hermes Desktop: %HERMES_EXE% >> "%LOG_FILE%"
    
    REM 删除Hermes Desktop可执行文件
    del /f "%HERMES_EXE%" >nul 2>&1
    if %errorLevel% equ 0 (
        echo [成功] Hermes Desktop 卸载完成
        echo [%date% %time%] Hermes Desktop 卸载完成 >> "%LOG_FILE%"
    ) else (
        echo [错误] Hermes Desktop 卸载失败
        echo [%date% %time%] Hermes Desktop 卸载失败 >> "%LOG_FILE%"
    )
) else (
    echo [警告] 未找到Hermes Desktop
    echo [%date% %time%] 警告: 未找到Hermes Desktop >> "%LOG_FILE%"
)

REM 3. 卸载 OpenCode
echo [信息] 卸载 OpenCode...
echo [%date% %time%] 卸载 OpenCode >> "%LOG_FILE%"

set "OPENCODE_EXE=%INSTALL_DIR%\installers\01_agent\OpenCode.exe"
if exist "%OPENCODE_EXE%" (
    echo [信息] 找到OpenCode: %OPENCODE_EXE%
    echo [%date% %time%] 找到OpenCode: %OPENCODE_EXE% >> "%LOG_FILE%"
    
    REM 删除OpenCode可执行文件
    del /f "%OPENCODE_EXE%" >nul 2>&1
    if %errorLevel% equ 0 (
        echo [成功] OpenCode 卸载完成
        echo [%date% %time%] OpenCode 卸载完成 >> "%LOG_FILE%"
    ) else (
        echo [错误] OpenCode 卸载失败
        echo [%date% %time%] OpenCode 卸载失败 >> "%LOG_FILE%"
    )
) else (
    echo [警告] 未找到OpenCode
    echo [%date% %time%] 警告: 未找到OpenCode >> "%LOG_FILE%"
)

REM 4. 清理配置文件
echo [信息] 清理配置文件...
echo [%date% %time%] 清理配置文件 >> "%LOG_FILE%"

set "CONFIG_DIRS=config\aionui config\hermes config\opencode"
for %%d in (%CONFIG_DIRS%) do (
    if exist "%INSTALL_DIR%\%%d" (
        rmdir /s /q "%INSTALL_DIR%\%%d" >nul 2>&1
        echo [信息] 已清理: %%d
        echo [%date% %time%] 已清理: %%d >> "%LOG_FILE%"
    )
)

REM 5. 清理日志文件
echo [信息] 清理日志文件...
echo [%date% %time%] 清理日志文件 >> "%LOG_FILE%"

set "LOG_DIRS=logs\aionui logs\hermes logs\opencode"
for %%d in (%LOG_DIRS%) do (
    if exist "%INSTALL_DIR%\%%d" (
        rmdir /s /q "%INSTALL_DIR%\%%d" >nul 2>&1
        echo [信息] 已清理: %%d
        echo [%date% %time%] 已清理: %%d >> "%LOG_FILE%"
    )
)

echo [%date% %time%] Agent组件卸载完成 >> "%LOG_FILE%"
echo [信息] 卸载完成，请查看日志文件: %LOG_FILE%

exit /b 0

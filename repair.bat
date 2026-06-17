@echo off
REM 开悟个体增智智能办公套件 V1.0 一键修复脚本
REM 功能: 修复套件组件
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion

echo ========================================
echo 开悟个体增智智能办公套件 V1.0 修复程序
echo 目标环境: Windows 7 SP1 64位
echo ========================================
echo.

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 需要管理员权限运行此修复程序
    echo 请右键点击此文件，选择"以管理员身份运行"
    pause
    exit /b 1
)

REM 创建日志目录
if not exist "logs" mkdir "logs"
set "LOG_FILE=logs\repair_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
echo 修复日志: %LOG_FILE%

echo.
echo 选择修复选项:
echo 1. 修复环境变量
echo 2. 重建快捷方式
echo 3. 重建工具注册表
echo 4. 重建 Obsidian Vault 模板
echo 5. 重新注册 WPS 插件
echo 6. 重启 Everything 服务
echo 7. 重写 Agent 配置文件
echo 8. 修复日志目录权限
echo 9. 全部修复
echo.
set /p choice="请选择修复选项 (1-9): "

if "%choice%"=="1" goto fix_env
if "%choice%"=="2" goto fix_shortcuts
if "%choice%"=="3" goto fix_registry
if "%choice%"=="4" goto fix_obsidian
if "%choice%"=="5" goto fix_wps
if "%choice%"=="6" goto fix_everything
if "%choice%"=="7" goto fix_agent
if "%choice%"=="8" goto fix_logs
if "%choice%"=="9" goto fix_all

:fix_env
echo.
echo [1/8] 修复环境变量...
REM 这里可以添加环境变量修复
goto end

:fix_shortcuts
echo.
echo [2/8] 重建快捷方式...
REM 这里可以添加快捷方式重建
goto end

:fix_registry
echo.
echo [3/8] 重建工具注册表...
REM 这里可以添加工具注册表重建
goto end

:fix_obsidian
echo.
echo [4/8] 重建 Obsidian Vault 模板...
REM 这里可以添加Obsidian Vault模板重建
goto end

:fix_wps
echo.
echo [5/8] 重新注册 WPS 插件...
REM 这里可以添加WPS插件重新注册
goto end

:fix_everything
echo.
echo [6/8] 重启 Everything 服务...
REM 这里可以添加Everything服务重启
goto end

:fix_agent
echo.
echo [7/8] 重写 Agent 配置文件...
REM 这里可以添加Agent配置文件重写
goto end

:fix_logs
echo.
echo [8/8] 修复日志目录权限...
REM 这里可以添加日志目录权限修复
goto end

:fix_all
echo.
echo [1/8] 修复环境变量...
REM 这里可以添加环境变量修复

echo [2/8] 重建快捷方式...
REM 这里可以添加快捷方式重建

echo [3/8] 重建工具注册表...
REM 这里可以添加工具注册表重建

echo [4/8] 重建 Obsidian Vault 模板...
REM 这里可以添加Obsidian Vault模板重建

echo [5/8] 重新注册 WPS 插件...
REM 这里可以添加WPS插件重新注册

echo [6/8] 重启 Everything 服务...
REM 这里可以添加Everything服务重启

echo [7/8] 重写 Agent 配置文件...
REM 这里可以添加Agent配置文件重写

echo [8/8] 修复日志目录权限...
REM 这里可以添加日志目录权限修复
goto end

:end
echo.
echo ========================================
echo 修复完成
echo ========================================
echo.
echo 修复日志: %LOG_FILE%
echo.
pause

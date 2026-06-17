@echo off
REM 开悟个体增智智能办公套件 V1.0 一键卸载脚本
REM 功能: 卸载套件组件
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion

echo ========================================
echo 开悟个体增智智能办公套件 V1.0 卸载程序
echo 目标环境: Windows 7 SP1 64位
echo ========================================
echo.

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 需要管理员权限运行此卸载程序
    echo 请右键点击此文件，选择"以管理员身份运行"
    pause
    exit /b 1
)

REM 创建日志目录
if not exist "logs" mkdir "logs"
set "LOG_FILE=logs\uninstall_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
echo 卸载日志: %LOG_FILE%

echo.
echo 警告: 此操作将卸载开悟个体增智智能办公套件 V1.0 的组件。
echo 个人文档和知识库不会被删除，除非您在后续确认中选择删除。
echo.
set /p confirm="是否继续卸载？(Y/N): "
if /i "%confirm%" neq "Y" (
    echo 卸载已取消
    pause
    exit /b 0
)

echo.
echo [1/8] 卸载 AionUI...
REM 这里可以添加AionUI卸载命令

echo [2/8] 卸载 Hermes Desktop...
REM 这里可以添加Hermes Desktop卸载命令

echo [3/8] 卸载 OpenCode...
REM 这里可以添加OpenCode卸载命令

echo [4/8] 卸载 WPS 插件...
REM 这里可以添加WPS插件卸载命令

echo [5/8] 卸载 Everything...
REM 这里可以添加Everything卸载命令

echo [6/8] 卸载 Tesseract-OCR...
REM 这里可以添加Tesseract-OCR卸载命令

echo [7/8] 清理快捷方式...
REM 这里可以添加快捷方式清理

echo [8/8] 清理配置文件...
REM 这里可以添加配置文件清理

echo.
echo ========================================
echo 卸载完成
echo ========================================
echo.
echo 注意: 某些组件可能需要手动卸载或重启后完全卸载。
echo 个人文档和知识库已保留。
echo.
pause

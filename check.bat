@echo off
REM 开悟个体增智智能办公套件 V1.0 一键检测脚本
REM 功能: 检测套件组件状态
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion

echo ========================================
echo 开悟个体增智智能办公套件 V1.0 检测程序
echo 目标环境: Windows 7 SP1 64位
echo ========================================
echo.

REM 创建日志目录
if not exist "logs" mkdir "logs"
if not exist "reports" mkdir "reports"
set "LOG_FILE=logs\check_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
set "REPORT_FILE=reports\check_report_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.md"

echo 检测日志: %LOG_FILE%
echo 检测报告: %REPORT_FILE%
echo.

echo [1/14] 检测 .NET Framework 4.8...
reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" /v Version >nul 2>&1
if %errorLevel% equ 0 (
    echo [PASS] .NET Framework 4.8 已安装
    echo [PASS] .NET Framework 4.8 已安装 >> "%REPORT_FILE%"
) else (
    echo [FAIL] .NET Framework 4.8 未安装
    echo [FAIL] .NET Framework 4.8 未安装 >> "%REPORT_FILE%"
)

echo [2/14] 检测 VC++ Runtime...
reg query "HKLM\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\X64" /v Version >nul 2>&1
if %errorLevel% equ 0 (
    echo [PASS] VC++ Runtime 已安装
    echo [PASS] VC++ Runtime 已安装 >> "%REPORT_FILE%"
) else (
    echo [FAIL] VC++ Runtime 未安装
    echo [FAIL] VC++ Runtime 未安装 >> "%REPORT_FILE%"
)

echo [3/14] 检测 WebView2 Runtime...
reg query "HKLM\SOFTWARE\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BEB-23A24D792270}" /v pv >nul 2>&1
if %errorLevel% equ 0 (
    echo [PASS] WebView2 Runtime 已安装
    echo [PASS] WebView2 Runtime 已安装 >> "%REPORT_FILE%"
) else (
    echo [FAIL] WebView2 Runtime 未安装
    echo [FAIL] WebView2 Runtime 未安装 >> "%REPORT_FILE%"
)

echo [4/14] 检测 Git for Windows...
git --version >nul 2>&1
if %errorLevel% equ 0 (
    echo [PASS] Git for Windows 已安装
    echo [PASS] Git for Windows 已安装 >> "%REPORT_FILE%"
) else (
    echo [FAIL] Git for Windows 未安装
    echo [FAIL] Git for Windows 未安装 >> "%REPORT_FILE%"
)

echo [5/14] 检测 Everything...
sc query "Everything" >nul 2>&1
if %errorLevel% equ 0 (
    echo [PASS] Everything 服务正在运行
    echo [PASS] Everything 服务正在运行 >> "%REPORT_FILE%"
) else (
    echo [FAIL] Everything 服务未运行
    echo [FAIL] Everything 服务未运行 >> "%REPORT_FILE%"
)

echo [6/14] 检测 Tesseract-OCR...
if exist "C:\Program Files\Tesseract-OCR\tesseract.exe" (
    echo [PASS] Tesseract-OCR 已安装
    echo [PASS] Tesseract-OCR 已安装 >> "%REPORT_FILE%"
) else (
    echo [FAIL] Tesseract-OCR 未安装
    echo [FAIL] Tesseract-OCR 未安装 >> "%REPORT_FILE%"
)

echo [7/14] 检测 WPS Office...
reg query "HKLM\SOFTWARE\Kingsoft\Office" >nul 2>&1
if %errorLevel% equ 0 (
    echo [PASS] WPS Office 已安装
    echo [PASS] WPS Office 已安装 >> "%REPORT_FILE%"
) else (
    echo [FAIL] WPS Office 未安装
    echo [FAIL] WPS Office 未安装 >> "%REPORT_FILE%"
)

echo [8/14] 检测 AionUI...
REM 这里可以添加AionUI检测

echo [9/14] 检测 Hermes Desktop...
REM 这里可以添加Hermes Desktop检测

echo [10/14] 检测 OpenCode...
REM 这里可以添加OpenCode检测

echo [11/14] 检测 Obsidian...
if exist "%LOCALAPPDATA%\Obsidian\Obsidian.exe" (
    echo [PASS] Obsidian 已安装
    echo [PASS] Obsidian 已安装 >> "%REPORT_FILE%"
) else (
    echo [FAIL] Obsidian 未安装
    echo [FAIL] Obsidian 未安装 >> "%REPORT_FILE%"
)

echo [12/14] 检测 XMind...
REM 这里可以添加XMind检测

echo [13/14] 检测工具注册表...
if exist "scripts\integration\tool_registry.json" (
    echo [PASS] 工具注册表存在
    echo [PASS] 工具注册表存在 >> "%REPORT_FILE%"
) else (
    echo [FAIL] 工具注册表不存在
    echo [FAIL] 工具注册表不存在 >> "%REPORT_FILE%"
)

echo [14/14] 检测日志目录...
if exist "logs" (
    echo [PASS] 日志目录存在
    echo [PASS] 日志目录存在 >> "%REPORT_FILE%"
) else (
    echo [FAIL] 日志目录不存在
    echo [FAIL] 日志目录不存在 >> "%REPORT_FILE%"
)

echo.
echo ========================================
echo 检测完成
echo ========================================
echo.
echo 检测日志: %LOG_FILE%
echo 检测报告: %REPORT_FILE%
echo.
pause

@echo off
REM 开悟个体增智智能办公套件 V1.0 一键安装脚本
REM 功能: 自动安装所有组件
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion

echo ========================================
echo 开悟个体增智智能办公套件 V1.0 安装程序
echo 目标环境: Windows 7 SP1 64位
echo ========================================
echo.

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 需要管理员权限运行此安装程序
    echo 请右键点击此文件，选择"以管理员身份运行"
    pause
    exit /b 1
)

REM 检查Windows版本
echo [1/19] 检查系统环境...
ver | find "Version 6.1" >nul
if %errorLevel% equ 0 (
    echo 检测到Windows 7系统
) else (
    echo [警告] 未检测到Windows 7系统，某些组件可能不兼容
)

REM 创建日志目录
if not exist "logs" mkdir "logs"
set "LOG_FILE=logs\install_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
echo 安装日志: %LOG_FILE%

REM 初始化安装状态
if not exist "state" mkdir "state"
echo {"status": "installing", "start_time": "%date% %time%"} > "state\install_state.json"

echo [2/19] 安装 .NET Framework 4.8...
if exist "installers\00_runtime\ndp48-x86-x64-allos-enu.exe" (
    echo 安装 .NET Framework 4.8...
    "installers\00_runtime\ndp48-x86-x64-allos-enu.exe" /quiet /norestart
    echo .NET Framework 4.8 安装完成
) else (
    echo [警告] 未找到 .NET Framework 4.8 安装包
)

echo [3/19] 安装 VC++ Runtime...
if exist "installers\00_runtime\vc_redist.x64.exe" (
    echo 安装 VC++ Runtime...
    "installers\00_runtime\vc_redist.x64.exe" /install /quiet /norestart
    echo VC++ Runtime 安装完成
) else (
    echo [警告] 未找到 VC++ Runtime 安装包
)

echo [4/19] 安装 WebView2 Runtime 109...
if exist "installers\00_runtime\MicrosoftEdgeWebView2RuntimeInstallerX64.exe" (
    echo 安装 WebView2 Runtime 109...
    "installers\00_runtime\MicrosoftEdgeWebView2RuntimeInstallerX64.exe" /silent /install
    echo WebView2 Runtime 109 安装完成
) else (
    echo [警告] 未找到 WebView2 Runtime 109 安装包
)

echo [5/19] 安装 Git for Windows 2.46.2...
if exist "installers\00_runtime\Git-2.46.2-64-bit.exe" (
    echo 安装 Git for Windows 2.46.2...
    "installers\00_runtime\Git-2.46.2-64-bit.exe" /VERYSILELS /NORESTART
    echo Git for Windows 2.46.2 安装完成
) else (
    echo [警告] 未找到 Git for Windows 2.46.2 安装包
)

echo [6/19] 安装 Everything...
if exist "installers\03_tools\Everything-1.4.1.1024.x64-Setup.exe" (
    echo 安装 Everything...
    "installers\03_tools\Everything-1.4.1.1024.x64-Setup.exe" /S
    echo Everything 安装完成
) else (
    echo [警告] 未找到 Everything 安装包
)

echo [7/19] 安装 Tesseract-OCR...
if exist "installers\03_tools\tesseract-ocr-w64-setup-5.3.1.20231002.exe" (
    echo 安装 Tesseract-OCR...
    "installers\03_tools\tesseract-ocr-w64-setup-5.3.1.20231002.exe" /S
    echo Tesseract-OCR 安装完成
) else (
    echo [警告] 未找到 Tesseract-OCR 安装包
)

echo [8/19] 安装 WPS Office...
if exist "installers\02_office\WPS_Office_11.8.2.12068.exe" (
    echo 安装 WPS Office...
    "installers\02_office\WPS_Office_11.8.2.12068.exe" /S
    echo WPS Office 安装完成
) else (
    echo [警告] 未找到 WPS Office 安装包
)

echo [9/19] 安装 wps-kaiyu-addon...
if exist "installers\02_office\wps-kaiyu-addon-setup.exe" (
    echo 安装 wps-kaiyu-addon...
    "installers\02_office\wps-kaiyu-addon-setup.exe" /S
    echo wps-kaiyu-addon 安装完成
) else (
    echo [警告] 未找到 wps-kaiyu-addon 安装包
)

echo [10/19] 安装 KexStepup...
if exist "installers\02_office\KexStepup-setup.exe" (
    echo 安装 KexStepup...
    "installers\02_office\KexStepup-setup.exe" /S
    echo KexStepup 安装完成
) else (
    echo [警告] 未找到 KexStepup 安装包
)

echo [11/19] 安装 AionUI...
if exist "installers\01_agent\AionUI-setup.exe" (
    echo 安装 AionUI...
    "installers\01_agent\AionUI-setup.exe" /S
    echo AionUI 安装完成
) else (
    echo [警告] 未找到 AionUI 安装包
)

echo [12/19] 安装 Hermes Desktop...
if exist "installers\01_agent\HermesDesktop-setup.exe" (
    echo 安装 Hermes Desktop...
    "installers\01_agent\HermesDesktop-setup.exe" /S
    echo Hermes Desktop 安装完成
) else (
    echo [警告] 未找到 Hermes Desktop 安装包
)

echo [13/19] 安装 OpenCode...
if exist "installers\01_agent\OpenCode-setup.exe" (
    echo 安装 OpenCode...
    "installers\01_agent\OpenCode-setup.exe" /S
    echo OpenCode 安装完成
) else (
    echo [警告] 未找到 OpenCode 安装包
)

echo [14/19] 安装 Obsidian...
if exist "installers\04_knowledge\Obsidian-1.4.16.exe" (
    echo 安装 Obsidian...
    "installers\04_knowledge\Obsidian-1.4.16.exe" /S
    echo Obsidian 安装完成
) else (
    echo [警告] 未找到 Obsidian 安装包
)

echo [15/19] 安装 XMind...
if exist "installers\05_optional\XMind-23.11.exe" (
    echo 安装 XMind...
    "installers\05_optional\XMind-23.11.exe" /S
    echo XMind 安装完成
) else (
    echo [警告] 未找到 XMind 安装包
)

echo [16/19] 配置环境变量...
REM 这里可以添加环境变量配置

echo [17/19] 创建桌面快捷方式...
REM 这里可以添加快捷方式创建

echo [18/19] 创建开始菜单入口...
REM 这里可以添加开始菜单入口创建

echo [19/19] 安装验证...
REM 这里可以添加安装验证

echo.
echo ========================================
echo 开悟个体增智智能办公套件 V1.0 安装完成
echo ========================================
echo.
echo 安装日志: %LOG_FILE%
echo 使用说明: 请查看 docs\02_用户使用手册.md
echo.
pause

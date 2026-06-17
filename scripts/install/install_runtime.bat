@echo off
REM 运行环境安装脚本
REM 功能: 安装.NET Framework、VC++ Runtime、WebView2 Runtime
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion

REM 设置日志文件
set "LOG_FILE=logs\install_runtime_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
if not exist "logs" mkdir "logs"

echo [%date% %time%] 开始安装运行环境 >> "%LOG_FILE%"

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 需要管理员权限运行此脚本
    echo [错误] 请右键点击"以管理员身份运行"
    echo [%date% %time%] 错误: 缺少管理员权限 >> "%LOG_FILE%"
    exit /b 1
)

echo [信息] 检查到管理员权限 >> "%LOG_FILE%"

REM 创建安装目录
set "INSTALL_DIR=C:\KaiwuOfficeSuite"
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%INSTALL_DIR%\logs" mkdir "%INSTALL_DIR%\logs"

REM 1. 安装 .NET Framework 4.8
echo [信息] 安装 .NET Framework 4.8...
echo [%date% %time%] 安装 .NET Framework 4.8 >> "%LOG_FILE%"

set "DOTNET_INSTALLER=installers\00_runtime\ndp48-web_x86_x64_en_us.exe"
if exist "%DOTNET_INSTALLER%" (
    echo [信息] 找到安装程序: %DOTNET_INSTALLER%
    echo [%date% %time%] 找到安装程序: %DOTNET_INSTALLER% >> "%LOG_FILE%"
    
    REM 静默安装
    "%DOTNET_INSTALLER%" /quiet /norestart /log "%INSTALL_DIR%\logs\dotnet_install.log"
    
    if %errorLevel% equ 0 (
        echo [成功] .NET Framework 4.8 安装完成
        echo [%date% %time%] .NET Framework 4.8 安装完成 >> "%LOG_FILE%"
    ) else (
        echo [错误] .NET Framework 4.8 安装失败，错误码: %errorLevel%
        echo [%date% %time%] .NET Framework 4.8 安装失败，错误码: %errorLevel% >> "%LOG_FILE%"
    )
) else (
    echo [警告] 未找到 .NET Framework 4.8 安装程序
    echo [信息] 请从以下地址下载:
    echo https://go.microsoft.com/fwlink/?LinkId=2085488
    echo [%date% %time%] 警告: 未找到 .NET Framework 4.8 安装程序 >> "%LOG_FILE%"
)

REM 2. 安装 VC++ Runtime
echo [信息] 安装 VC++ Runtime...
echo [%date% %time%] 安装 VC++ Runtime >> "%LOG_FILE%"

set "VC_INSTALLER=installers\00_runtime\vc_redist.x64.exe"
if exist "%VC_INSTALLER%" (
    echo [信息] 找到安装程序: %VC_INSTALLER%
    echo [%date% %time%] 找到安装程序: %VC_INSTALLER% >> "%LOG_FILE%"
    
    REM 静默安装
    "%VC_INSTALLER%" /install /quiet /norestart
    
    if %errorLevel% equ 0 (
        echo [成功] VC++ Runtime 安装完成
        echo [%date% %time%] VC++ Runtime 安装完成 >> "%LOG_FILE%"
    ) else (
        echo [错误] VC++ Runtime 安装失败，错误码: %errorLevel%
        echo [%date% %time%] VC++ Runtime 安装失败，错误码: %errorLevel% >> "%LOG_FILE%"
    )
) else (
    echo [警告] 未找到 VC++ Runtime 安装程序
    echo [信息] 请从以下地址下载:
    echo https://aka.ms/vs/17/release/vc_redist.x64.exe
    echo [%date% %time%] 警告: 未找到 VC++ Runtime 安装程序 >> "%LOG_FILE%"
)

REM 3. 安装 WebView2 Runtime
echo [信息] 安装 WebView2 Runtime...
echo [%date% %time%] 安装 WebView2 Runtime >> "%LOG_FILE%"

set "WEBVIEW2_INSTALLER=installers\00_runtime\MicrosoftEdgeWebview2Setup.exe"
if exist "%WEBVIEW2_INSTALLER%" (
    echo [信息] 找到安装程序: %WEBVIEW2_INSTALLER%
    echo [%date% %time%] 找到安装程序: %WEBVIEW2_INSTALLER% >> "%LOG_FILE%"
    
    REM 静默安装
    "%WEBVIEW2_INSTALLER%" /silent /install
    
    if %errorLevel% equ 0 (
        echo [成功] WebView2 Runtime 安装完成
        echo [%date% %time%] WebView2 Runtime 安装完成 >> "%LOG_FILE%"
    ) else (
        echo [错误] WebView2 Runtime 安装失败，错误码: %errorLevel%
        echo [%date% %time%] WebView2 Runtime 安装失败，错误码: %errorLevel% >> "%LOG_FILE%"
    )
) else (
    echo [警告] 未找到 WebView2 Runtime 安装程序
    echo [信息] 请从以下地址下载:
    echo https://go.microsoft.com/fwlink/p/?LinkId=2124703
    echo [%date% %time%] 警告: 未找到 WebView2 Runtime 安装程序 >> "%LOG_FILE%"
)

echo [%date% %time%] 运行环境安装完成 >> "%LOG_FILE%"
echo [信息] 安装完成，请查看日志文件: %LOG_FILE%

exit /b 0

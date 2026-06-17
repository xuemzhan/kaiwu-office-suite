@echo off
REM 开悟个体增智智能办公套件 V1.0 快速下载脚本
REM 功能: 下载所有Win7 SP1兼容的安装包
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion

echo ========================================
echo 开悟个体增智智能办公套件 V1.0 快速下载工具
echo 目标环境: Windows 7 SP1 64位
echo ========================================
echo.

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [警告] 建议以管理员权限运行此脚本
    echo.
)

REM 创建目录
if not exist "packages\raw" mkdir "packages\raw"
if not exist "logs" mkdir "logs"

set "LOG_FILE=logs\quick_download_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
echo 下载日志: %LOG_FILE%
echo.

echo 开始下载Win7 SP1兼容的安装包...
echo.

REM 下载 .NET Framework 4.8
echo [1/8] 下载 .NET Framework 4.8...
powershell -Command "Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?LinkId=2085155' -OutFile 'packages\raw\ndp48-x86-x64-allos-enu.exe'" >nul 2>&1
if %errorLevel% equ 0 (
    echo ? .NET Framework 4.8 下载完成
) else (
    echo ? .NET Framework 4.8 下载失败
)

REM 下载 WebView2 Runtime 109
echo [2/8] 下载 WebView2 Runtime 109...
powershell -Command "Invoke-WebRequest -Uri 'https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/12d7cf13-854e-42e9-aa1b-5180dd88e09a/MicrosoftEdgeWebView2RuntimeInstallerX64.exe' -OutFile 'packages\raw\MicrosoftEdgeWebView2RuntimeInstallerX64.exe'" >nul 2>&1
if %errorLevel% equ 0 (
    echo ? WebView2 Runtime 109 下载完成
) else (
    echo ? WebView2 Runtime 109 下载失败
)

REM 下载 VC++ Runtime
echo [3/8] 下载 VC++ Runtime...
powershell -Command "Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vc_redist.x64.exe' -OutFile 'packages\raw\vc_redist.x64.exe'" >nul 2>&1
if %errorLevel% equ 0 (
    echo ? VC++ Runtime 下载完成
) else (
    echo ? VC++ Runtime 下载失败
)

REM 下载 Git for Windows 2.46.2
echo [4/8] 下载 Git for Windows 2.46.2...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.46.2.windows.1/Git-2.46.2-64-bit.exe' -OutFile 'packages\raw\Git-2.46.2-64-bit.exe'" >nul 2>&1
if %errorLevel% equ 0 (
    echo ? Git for Windows 2.46.2 下载完成
) else (
    echo ? Git for Windows 2.46.2 下载失败
)

REM 下载 Everything
echo [5/8] 下载 Everything...
powershell -Command "Invoke-WebRequest -Uri 'https://www.voidtools.com/Everything-1.4.1.1024.x64-Setup.exe' -OutFile 'packages\raw\Everything-1.4.1.1024.x64-Setup.exe'" >nul 2>&1
if %errorLevel% equ 0 (
    echo ? Everything 下载完成
) else (
    echo ? Everything 下载失败
)

REM 下载 Tesseract-OCR
echo [6/8] 下载 Tesseract-OCR...
powershell -Command "Invoke-WebRequest -Uri 'https://digi.bib.uni-mannheim.de/tesseract/tesseract-ocr-w64-setup-5.3.1.20231002.exe' -OutFile 'packages\raw\tesseract-ocr-w64-setup-5.3.1.20231002.exe'" >nul 2>&1
if %errorLevel% equ 0 (
    echo ? Tesseract-OCR 下载完成
) else (
    echo ? Tesseract-OCR 下载失败
)

REM 下载 WPS Office
echo [7/8] 下载 WPS Office...
powershell -Command "Invoke-WebRequest -Uri 'https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/16478/WPS_Office_11.8.2.12068.exe' -OutFile 'packages\raw\WPS_Office_11.8.2.12068.exe'" >nul 2>&1
if %errorLevel% equ 0 (
    echo ? WPS Office 下载完成
) else (
    echo ? WPS Office 下载失败
)

REM 下载 Obsidian
echo [8/8] 下载 Obsidian...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/obsidianmd/obsidian-releases/releases/download/v1.4.16/Obsidian.1.4.16.exe' -OutFile 'packages\raw\Obsidian-1.4.16.exe'" >nul 2>&1
if %errorLevel% equ 0 (
    echo ? Obsidian 下载完成
) else (
    echo ? Obsidian 下载失败
)

echo.
echo ========================================
echo 下载完成
echo ========================================
echo.
echo 下载文件位置: packages\raw\
echo 日志文件: %LOG_FILE%
echo.
echo 请检查下载文件是否完整。
echo.
pause

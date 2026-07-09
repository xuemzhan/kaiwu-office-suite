@echo off
REM 开悟个体增智智能办公套件 V1.3.3 下载脚本（批处理版本）
REM 功能: 调用PowerShell脚本下载所有软件安装包
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion

echo ========================================
echo 开悟个体增智智能办公套件 V1.3.3 下载工具
echo 目标环境: Windows 7 SP1 64位
echo ========================================
echo.

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [警告] 建议以管理员权限运行此脚本
    echo.
)

REM 设置参数
set "MANIFEST_PATH=manifest/software-lock.yaml"
set "OUTPUT_DIR=packages/raw"
set "LOG_DIR=logs"

REM 创建目录
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

REM 显示菜单
echo 请选择操作:
echo 1. 下载所有组件
echo 2. 下载指定组件
echo 3. 校验已下载文件
echo 4. 生成下载报告
echo 5. 退出
echo.
set /p choice="请输入选择 (1-5): "

if "%choice%"=="1" goto download_all
if "%choice%"=="2" goto download_one
if "%choice%"=="3" goto verify
if "%choice%"=="4" goto report
if "%choice%"=="5" goto exit

:download_all
echo.
echo 开始下载所有组件（Win7 SP1兼容版本）...
echo 检查PowerShell版本...
powershell -Command "$v = $PSVersionTable.PSVersion.Major; if ($v -lt 2) { Write-Host '错误: 需要PowerShell 2.0或更高版本' -ForegroundColor Red; exit 1 } else { Write-Host 'PowerShell版本: ' $v -ForegroundColor Green }"
if %errorLevel% neq 0 (
    echo [错误] PowerShell版本过低，请安装Windows Management Framework 3.0或更高版本
    goto end
)
powershell -ExecutionPolicy Bypass -File "scripts\download\download_all.ps1" -ManifestPath "%MANIFEST_PATH%" -OutputDir "%OUTPUT_DIR%" -LogDir "%LOG_DIR%"
goto end

:download_one
echo.
echo 可用组件（Win7 SP1兼容版本）:
echo 1. .NET Framework 4.8
echo 2. WebView2 Runtime 109
echo 3. VC++ Runtime
echo 4. Git for Windows 2.46.2
echo 5. Everything
echo 6. Tesseract-OCR
echo 7. WPS Office
echo 8. Obsidian
echo.
set /p component="请输入组件编号 (1-8): "

if "%component%"=="1" set "URL=https://go.microsoft.com/fwlink/?LinkId=2085155"
if "%component%"=="2" set "URL=https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/12d7cf13-854e-42e9-aa1b-5180dd88e09a/MicrosoftEdgeWebView2RuntimeInstallerX64.exe"
if "%component%"=="3" set "URL=https://aka.ms/vs/17/release/vc_redist.x64.exe"
if "%component%"=="4" set "URL=https://github.com/git-for-windows/git/releases/download/v2.46.2.windows.1/Git-2.46.2-64-bit.exe"
if "%component%"=="5" set "URL=https://www.voidtools.com/Everything-1.4.1.1024.x64-Setup.exe"
if "%component%"=="6" set "URL=https://digi.bib.uni-mannheim.de/tesseract/tesseract-ocr-w64-setup-5.3.1.20231002.exe"
if "%component%"=="7" set "URL=https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/16478/WPS_Office_11.8.2.12068.exe"
if "%component%"=="8" set "URL=https://github.com/obsidianmd/obsidian-releases/releases/download/v1.4.16/Obsidian.1.4.16.exe"

if defined URL (
    echo 正在下载组件...
    powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%OUTPUT_DIR%\download.tmp'"
) else (
    echo 无效的选择
)
goto end

:verify
echo.
echo 校验已下载文件...
powershell -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '%OUTPUT_DIR%' -Recurse -File | ForEach-Object { Write-Host \"$($_.FullName) - SHA256: $((Get-FileHash $_.FullName -Algorithm SHA256).Hash)\" }"
goto end

:report
echo.
echo 生成下载报告...
powershell -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '%OUTPUT_DIR%' -Recurse -File | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize | Out-File '%LOG_DIR%\file_list.txt'"
echo 报告已保存到: %LOG_DIR%\file_list.txt
goto end

:exit
echo.
echo 退出下载工具
exit /b 0

:end
echo.
echo 操作完成
pause

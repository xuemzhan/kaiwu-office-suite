@echo off
REM ============================================
REM 开悟个体增智智能办公套件 - 交付 ZIP 打包脚本
REM Version: V1.3.3
REM 说明: 将 kaiwu-office-suite-v1.0/ 打包为 ZIP
REM ============================================
setlocal enabledelayedexpansion

set "VERSION=v1.3.3"
set "SOURCE_DIR=%~dp0"
set "OUTPUT_DIR=%~dp0.."
set "ZIP_NAME=kaiwu-office-suite-%VERSION%.zip"
set "ZIP_PATH=%OUTPUT_DIR%\%ZIP_NAME%"

echo ========================================
echo  开悟个体增智智能办公套件 - 打包脚本
echo  版本: %VERSION%
echo  来源: %SOURCE_DIR%
echo  输出: %ZIP_PATH%
echo ========================================
echo.

REM 检查源目录
if not exist "%SOURCE_DIR%install.bat" (
    echo [ERROR] 源目录不正确：未找到 install.bat
    echo 请将本脚本放在 kaiwu-office-suite-v1.0/ 目录下运行
    exit /b 1
)

REM 检查 packages/raw/ 非空
dir /b "%SOURCE_DIR%packages\raw\*.exe" >nul 2>&1
if errorlevel 1 (
    echo [WARN] packages\raw\ 目录下未找到安装包
    echo 打包将继续，但生成的 ZIP 不含可运行安装包
)

REM 使用 PowerShell 的 Compress-Archive 打包
echo [1/3] 正在压缩套件目录...
powershell -Command "& {
    $source = '%SOURCE_DIR%'
    $dest = '%ZIP_PATH%'
    if (Test-Path $dest) { Remove-Item $dest -Force }
    Compress-Archive -Path ($source + '*') -DestinationPath $dest -Force
    Write-Host '  ZIP 已生成: ' $dest
}"

if errorlevel 1 (
    echo [ERROR] 打包失败
    exit /b 1
)

REM 计算 SHA256
echo [2/3] 正在计算 SHA256...
certutil -hashfile "%ZIP_PATH%" SHA256 > "%ZIP_PATH%.sha256"

REM 验证
echo [3/3] 验证打包结果...
for %%I in ("%ZIP_PATH%") do set "ZIP_SIZE=%%~zI"
echo   ZIP 大小: %ZIP_SIZE% 字节
echo   SHA256: 
type "%ZIP_PATH%.sha256"

echo.
echo ========================================
echo  ✓ 打包完成！
echo  输出文件: %ZIP_NAME%
echo  SHA256:    %ZIP_NAME%.sha256
echo ========================================
echo.
echo 交付物清单:
echo   1. %ZIP_NAME%
echo   2. %ZIP_NAME%.sha256
echo   3. kaiwu-office-suite-v1.0_release_note.md
echo.
echo 提示: 将上述 3 个文件分发给目标机器
echo.

endlocal

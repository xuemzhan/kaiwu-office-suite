@echo off
REM Git状态检查调用脚本
REM 功能: 检查Git仓库状态
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion

REM 参数设置
set "REPO_PATH=%~1"
set "OUTPUT_FILE=%~2"

if "%REPO_PATH%"=="" set "REPO_PATH=."
if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=results\git_status.txt"

REM 创建输出目录
if not exist "results" mkdir "results"

REM 记录日志
echo [%date% %time%] 开始检查Git状态: 仓库路径=%REPO_PATH% >> "logs\git_status.log"

REM 检查Git是否安装
git --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] Git未安装
    echo 请先安装Git for Windows
    exit /b 1
)

REM 检查是否是Git仓库
cd /d "%REPO_PATH%"
git rev-parse --git-dir >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 不是Git仓库: %REPO_PATH%
    exit /b 1
)

REM 创建状态文件
echo # Git仓库状态报告 > "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo **检查时间:** %date% %time% >> "%OUTPUT_FILE%"
echo **仓库路径:** %REPO_PATH% >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo ## 仓库信息 >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"

REM 获取远程仓库信息
for /f "tokens=*" %%i in ('git remote -v') do (
    echo - 远程仓库: %%i >> "%OUTPUT_FILE%"
)

echo. >> "%OUTPUT_FILE%"
echo ## 分支信息 >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"

REM 获取当前分支
for /f "tokens=*" %%i in ('git branch --show-current') do (
    echo - 当前分支: %%i >> "%OUTPUT_FILE%"
)

echo. >> "%OUTPUT_FILE%"
echo ## 状态信息 >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"

REM 获取状态
for /f "tokens=*" %%i in ('git status --short') do (
    echo - %%i >> "%OUTPUT_FILE%"
)

echo. >> "%OUTPUT_FILE%"
echo ## 最近提交 >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"

REM 获取最近5次提交
for /f "tokens=*" %%i in ('git log --oneline -5') do (
    echo - %%i >> "%OUTPUT_FILE%"
)

echo Git状态检查完成，结果已保存到: %OUTPUT_FILE%

REM 记录日志
echo [%date% %time%] Git状态检查完成 >> "logs\git_status.log"

exit /b 0

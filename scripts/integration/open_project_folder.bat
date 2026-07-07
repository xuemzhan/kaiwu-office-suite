@echo off
REM 打开项目文件夹调用脚本
REM 功能: 打开指定的项目文件夹
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion
REM 确保日志目录存在(2026-07-07 修复;本脚本无 results 输出)
if not exist "logs" mkdir "logs"


REM 参数设置
set "FOLDER_PATH=%~1"

if "%FOLDER_PATH%"=="" (
    echo [错误] 请提供文件夹路径
    echo 用法: %0 "文件夹路径"
    exit /b 1
)

REM 记录日志
echo [%date% %time%] 打开文件夹: 路径=%FOLDER_PATH% >> "logs\open_folder.log"

REM 检查文件夹是否存在
if not exist "%FOLDER_PATH%" (
    echo [错误] 文件夹不存在: %FOLDER_PATH%
    exit /b 1
)

REM 打开文件夹
echo 正在打开文件夹: %FOLDER_PATH%
explorer "%FOLDER_PATH%"

echo 文件夹已打开

REM 记录日志
echo [%date% %time%] 文件夹已打开 >> "logs\open_folder.log"

exit /b 0

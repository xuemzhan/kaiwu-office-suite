@echo off
REM 收集上下文信息调用脚本
REM 功能: 收集系统上下文信息
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion
REM 确保日志与输出目录存在(2026-07-07 修复: 此前缺失 mkdir 导致 14 个 log 断言全 FAIL)
if not exist "logs" mkdir "logs"
if not exist "results" mkdir "results"


REM 参数设置
set "CONTEXT_TYPE=%~1"
set "OUTPUT_FILE=%~2"

if "%CONTEXT_TYPE%"=="" set "CONTEXT_TYPE=all"
if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=results\context.json"

REM 创建输出目录
if not exist "results" mkdir "results"

REM 记录日志
echo [%date% %time%] 开始收集上下文: 类型=%CONTEXT_TYPE% >> "logs\collect_context.log"

REM Build JSON via PowerShell ConvertTo-Json (P2-3 hardening)
powershell -command "$ver = 'V1.3.3'; try { $v = Get-Content 'config\version.json' -Raw | ConvertFrom-Json; $ver = $v.version } catch {}; $obj = @{ context_info = @{ type='%CONTEXT_TYPE%', timestamp=(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), computer_name=$env:COMPUTERNAME, username=$env:USERNAME, user_domain=$env:USERDOMAIN }; system_info = @{ os_version='Windows', architecture=$env:PROCESSOR_ARCHITECTURE, processor_count=$env:NUMBER_OF_PROCESSORS, temp_folder=$env:TEMP, system_root=$env:SYSTEMROOT }; config_info = @{ suite_version=$ver, last_check=(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') } }; $obj | ConvertTo-Json -Depth 5 | Set-Content '%OUTPUT_FILE%' -Encoding UTF8"

echo 上下文收集完成，结果已保存到: %OUTPUT_FILE%

REM 记录日志
echo [%date% %time%] 上下文收集完成 >> "logs\collect_context.log"

exit /b 0

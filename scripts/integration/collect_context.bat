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

REM 创建上下文文件
echo { > "%OUTPUT_FILE%"
echo   "context_info": { >> "%OUTPUT_FILE%"
echo     "type": "%CONTEXT_TYPE%", >> "%OUTPUT_FILE%"
echo     "timestamp": "%date% %time%", >> "%OUTPUT_FILE%"
echo     "computer_name": "%COMPUTERNAME%", >> "%OUTPUT_FILE%"
echo     "username": "%USERNAME%", >> "%OUTPUT_FILE%"
echo     "user_domain": "%USERDOMAIN%" >> "%OUTPUT_FILE%"
echo   }, >> "%OUTPUT_FILE%"
echo   "system_info": { >> "%OUTPUT_FILE%"
echo     "os_version": "Windows", >> "%OUTPUT_FILE%"
echo     "architecture": "%PROCESSOR_ARCHITECTURE%", >> "%OUTPUT_FILE%"
echo     "processor_count": "%NUMBER_OF_PROCESSORS%", >> "%OUTPUT_FILE%"
echo     "temp_folder": "%TEMP%", >> "%OUTPUT_FILE%"
echo     "system_root": "%SYSTEMROOT%" >> "%OUTPUT_FILE%"
echo   }, >> "%OUTPUT_FILE%"
echo   "config_info": { >> "%OUTPUT_FILE%"
echo     "suite_version": "V1.0", >> "%OUTPUT_FILE%"
echo     "install_date": "2026-06-17", >> "%OUTPUT_FILE%"
echo     "last_check": "%date% %time%" >> "%OUTPUT_FILE%"
echo   } >> "%OUTPUT_FILE%"
echo } >> "%OUTPUT_FILE%"

echo 上下文收集完成，结果已保存到: %OUTPUT_FILE%

REM 记录日志
echo [%date% %time%] 上下文收集完成 >> "logs\collect_context.log"

exit /b 0

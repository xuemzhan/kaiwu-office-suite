@echo off
REM collect_context test script
REM Purpose: Test collect_context integration
REM Platform: Windows 7 SP1 64-bit

setlocal enabledelayedexpansion
REM 确保日志与输出目录存在(2026-07-07 修复: 此前缺失 mkdir 导致 14 个 log 断言全 FAIL)
if not exist "logs" mkdir "logs"
if not exist "results" mkdir "results"
set "CONTEXT_TYPE=%~1"
set "OUTPUT_FILE=%~2"

if "%CONTEXT_TYPE%"=="" set "CONTEXT_TYPE=all"
if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=results\context.json"

if not exist "results" mkdir "results"

echo [%date% %time%] Starting collect_context test: type=%CONTEXT_TYPE% >> "logs\collect_context.log"

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

echo Context info saved to: %OUTPUT_FILE%

echo [%date% %time%] collect_context test complete >> "logs\collect_context.log"

exit /b 0

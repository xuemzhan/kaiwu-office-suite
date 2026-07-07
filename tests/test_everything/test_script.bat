@echo off
REM Everything search test script
REM Purpose: Test Everything file search functionality
REM Platform: Windows 7 SP1 64-bit

setlocal enabledelayedexpansion
REM 确保日志与输出目录存在(2026-07-07 修复: 此前缺失 mkdir 导致 14 个 log 断言全 FAIL)
if not exist "logs" mkdir "logs"
if not exist "results" mkdir "results"
set "KEYWORD=%~1"
set "SEARCH_PATH=%~2"
set "OUTPUT_FILE=%~3"

if "%KEYWORD%"=="" (
    echo [ERROR] Keyword parameter required
    echo Usage: %0 "keyword" ["search_path"]
    exit /b 1
)

if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=results\file_search_result.json"

if not exist "results" mkdir "results"

echo [%date% %time%] Starting search: keyword=%KEYWORD% path=%SEARCH_PATH% >> "logs\everything_search.log"

REM Check Everything service
sc query "Everything" >nul 2>&1
if %errorLevel% neq 0 (
    echo [WARN] Everything service not running
    echo Falling back to PowerShell file search
)

REM Try es.exe first, fallback to PowerShell
if exist "C:\Program Files\Everything\es.exe" (
    echo Using es.exe for search...
    "C:\Program Files\Everything\es.exe" "%KEYWORD%" > "results\temp_search.txt"
) else (
    echo [WARN] es.exe not found, using PowerShell
    powershell -Command "Get-ChildItem -Path '%SEARCH_PATH%' -Recurse -Filter '*%KEYWORD%*' | Select-Object FullName, Length, LastWriteTime | ForEach-Object { '{0},{1},{2}' -f $_.FullName, $_.Length, $_.LastWriteTime }" > "results\temp_search.txt"
)

REM Generate JSON output
echo { > "%OUTPUT_FILE%"
echo   "search_info": { >> "%OUTPUT_FILE%"
echo     "keyword": "%KEYWORD%", >> "%OUTPUT_FILE%"
echo     "path": "%SEARCH_PATH%", >> "%OUTPUT_FILE%"
echo     "timestamp": "%date% %time%", >> "%OUTPUT_FILE%"
echo     "result_count": "%count%" >> "%OUTPUT_FILE%"
echo   }, >> "%OUTPUT_FILE%"
echo   "results": [ >> "%OUTPUT_FILE%"

REM Process results
set "count=0"
for /f "tokens=*" %%i in ('type "results\temp_search.txt"') do (
    if !count! gtr 0 echo , >> "%OUTPUT_FILE%"
    echo     { >> "%OUTPUT_FILE%"
    echo       "path": "%%i" >> "%OUTPUT_FILE%"
    echo     } >> "%OUTPUT_FILE%"
    set /a count+=1
)

echo   ] >> "%OUTPUT_FILE%"
echo } >> "%OUTPUT_FILE%"

REM Cleanup
del "results\temp_search.txt" 2>nul

echo Search results saved to: %OUTPUT_FILE%
echo Total results: %count%

echo [%date% %time%] Search complete: results_count=%count% >> "logs\everything_search.log"

exit /b 0

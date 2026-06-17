@echo off
REM Everything 文件搜索调用脚本
REM 功能: 调用Everything进行文件搜索
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion

REM 参数设置
set "KEYWORD=%~1"
set "PATH=%~2"
set "OUTPUT_FILE=%~3"

if "%KEYWORD%"=="" (
    echo [错误] 请提供搜索关键词
    echo 用法: %0 "关键词" ["路径"]
    exit /b 1
)

if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=results\file_search_result.json"

REM 创建输出目录
if not exist "results" mkdir "results"

REM 记录日志
echo [%date% %time%] 开始搜索: 关键词=%KEYWORD% 路径=%PATH% >> "logs\everything_search.log"

REM 检查Everything服务
sc query "Everything" >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] Everything服务未运行
    echo 请先启动Everything服务
    exit /b 1
)

REM 使用es.exe进行搜索（Everything命令行工具）
if exist "C:\Program Files\Everything\es.exe" (
    echo 使用es.exe进行搜索...
    "C:\Program Files\Everything\es.exe" "%KEYWORD%" > "results\temp_search.txt"
) else (
    echo [警告] 未找到es.exe，使用备选方案
    REM 备选方案：使用PowerShell调用Everything
    powershell -Command "Get-ChildItem -Path '%PATH%' -Recurse -Filter '*%KEYWORD%*' | Select-Object FullName, Length, LastWriteTime | ForEach-Object { '{0},{1},{2}' -f $_.FullName, $_.Length, $_.LastWriteTime }" > "results\temp_search.txt"
)

REM 转换为JSON格式
echo { > "%OUTPUT_FILE%"
echo   "search_info": { >> "%OUTPUT_FILE%"
echo     "keyword": "%KEYWORD%", >> "%OUTPUT_FILE%"
echo     "path": "%PATH%", >> "%OUTPUT_FILE%"
echo     "timestamp": "%date% %time%", >> "%OUTPUT_FILE%"
echo     "result_count": 0 >> "%OUTPUT_FILE%"
echo   }, >> "%OUTPUT_FILE%"
echo   "results": [ >> "%OUTPUT_FILE%"

REM 添加搜索结果
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

REM 更新结果数量
powershell -Command "$content = Get-Content '%OUTPUT_FILE%'; $content = $content -replace 'result_count: 0', 'result_count: %count%'; Set-Content '%OUTPUT_FILE%' $content"

REM 清理临时文件
del "results\temp_search.txt" 2>nul

echo 搜索完成，结果已保存到: %OUTPUT_FILE%
echo 搜索结果数量: %count%

REM 记录日志
echo [%date% %time%] 搜索完成: 结果数量=%count% >> "logs\everything_search.log"

exit /b 0

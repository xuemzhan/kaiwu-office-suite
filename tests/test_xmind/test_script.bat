@echo off
REM XMind outline test script
REM Purpose: Test creating XMind outlines
REM Platform: Windows 7 SP1 64-bit

setlocal enabledelayedexpansion
REM 确保日志与输出目录存在(2026-07-07 修复: 此前缺失 mkdir 导致 14 个 log 断言全 FAIL)
if not exist "logs" mkdir "logs"
if not exist "results" mkdir "results"
set "TOPIC=%~1"
set "SUBTOPICS=%~2"
set "OUTPUT_FILE=%~3"

if "%TOPIC%"=="" (
    echo [ERROR] Topic required
    echo Usage: %0 "topic" ["subtopic1,subtopic2,..."]
    exit /b 1
)

if "%SUBTOPICS%"=="" set "SUBTOPICS=Subtopic1,Subtopic2,Subtopic3"
if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=results\outline.txt"

if not exist "results" mkdir "results"

echo [%date% %time%] Creating outline: topic=%TOPIC% >> "logs\xmind_outline.log"

REM Generate outline
echo # %TOPIC% > "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo **Generated:** %date% %time% >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo ## Outline >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"

REM Process subtopics
set "subtopic_count=0"
for %%i in (%SUBTOPICS%) do (
    set /a subtopic_count+=1
    echo ### %%i >> "%OUTPUT_FILE%"
    echo. >> "%OUTPUT_FILE%"
    echo - Content to be filled >> "%OUTPUT_FILE%"
    echo. >> "%OUTPUT_FILE%"
)

REM Instructions
echo ## Next Steps >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo 1. Import outline into XMind >> "%OUTPUT_FILE%"
echo 2. Add details to each subtopic in XMind >> "%OUTPUT_FILE%"
echo 3. Export as needed >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo ## Summary >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo - Topic: %TOPIC% >> "%OUTPUT_FILE%"
echo - Subtopic count: %subtopic_count% >> "%OUTPUT_FILE%"
echo - Generated: %date% %time% >> "%OUTPUT_FILE%"

echo Outline saved to: %OUTPUT_FILE%
echo Subtopic count: %subtopic_count%

echo [%date% %time%] Outline complete: subtopic_count=%subtopic_count% >> "logs\xmind_outline.log"

exit /b 0

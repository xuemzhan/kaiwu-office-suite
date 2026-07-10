@echo off
REM XMind outline test script
REM Purpose: Test creating XMind outlines
REM Platform: Windows 7 SP1 64-bit

setlocal enabledelayedexpansion
REM ȷ����־�����Ŀ¼����(2026-07-07 �޸�: ��ǰȱʧ mkdir ���� 14 �� log ����ȫ FAIL)
if not exist "runtime\logs" mkdir "runtime\logs"
if not exist "runtime\results" mkdir "runtime\results"
set "TOPIC=%~1"
set "SUBTOPICS=%~2"
set "OUTPUT_FILE=%~3"

if "%TOPIC%"=="" (
    echo [ERROR] Topic required
    echo Usage: %0 "topic" ["subtopic1,subtopic2,..."]
    exit /b 1
)

if "%SUBTOPICS%"=="" set "SUBTOPICS=Subtopic1,Subtopic2,Subtopic3"
if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=runtime\results\outline.txt"

if not exist "runtime\results" mkdir "runtime\results"

echo [%date% %time%] Creating outline: topic=%TOPIC% >> "runtime\logs\xmind_outline.log"

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

echo [%date% %time%] Outline complete: subtopic_count=%subtopic_count% >> "runtime\logs\xmind_outline.log"

exit /b 0

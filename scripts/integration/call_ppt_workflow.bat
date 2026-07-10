@echo off
setlocal EnableExtensions
REM KaiWu Office Suite V1.4.1 - PPT workflow capability gate
REM Target: Windows 7 SP1 64-bit

cd /d "%~dp0\..\.." || exit /b 1
if not exist logs mkdir logs >nul 2>nul

if "%~1"=="" (
  echo Usage: call_ppt_workflow.bat ^<topic_or_input_dir^> [output_dir]
  echo [%date% %time%] Missing topic_or_input_dir>>logs\ppt_workflow.log
  exit /b 1
)

if not exist results mkdir results >nul 2>nul
>results\ppt_workflow_status.txt echo unsupported
>>results\ppt_workflow_status.txt echo PPT workflow is registered as an upstream reference only.
>>results\ppt_workflow_status.txt echo Upstream ppt-workflow requires Python 3.12+ and has not been ported or validated on Windows 7 SP1.

echo [UNSUPPORTED] PPT workflow is registered as an upstream reference only.
echo [UNSUPPORTED] Upstream ppt-workflow requires Python 3.12+ and has not been ported or validated on Windows 7 SP1.
echo [%date% %time%] Unsupported call: input=%~1 output=%~2>>logs\ppt_workflow.log
exit /b 2
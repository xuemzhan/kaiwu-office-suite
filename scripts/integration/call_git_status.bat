@echo off
REM KaiWu Office Suite V1.4.1 - Git status report
setlocal EnableExtensions DisableDelayedExpansion
chcp 936 >nul 2>&1
cd /d "%~dp0\..\.."
if not exist "runtime\logs" mkdir "runtime\logs"
if not exist "runtime\results" mkdir "runtime\results"
set "BASE_DIR=%CD%"
set "REPO_PATH=%~1"
set "OUTPUT_FILE=%~2"
if not defined REPO_PATH set "REPO_PATH=."
if not defined OUTPUT_FILE set "OUTPUT_FILE=runtime\results\git_status.txt"
for %%F in ("%OUTPUT_FILE%") do set "OUTPUT_FILE=%%~fF"
echo [%date% %time%] git status repo=%REPO_PATH%>>"runtime\logs\git_status.log"
where git >nul 2>&1
if errorlevel 1 exit /b 1
if not exist "%REPO_PATH%\.git" exit /b 1
pushd "%REPO_PATH%" 2>nul
if errorlevel 1 exit /b 1
git rev-parse --git-dir >nul 2>&1
if errorlevel 1 (popd&exit /b 1)
>"%OUTPUT_FILE%" echo # Git repository status
>>"%OUTPUT_FILE%" echo.
>>"%OUTPUT_FILE%" echo Checked: %date% %time%
>>"%OUTPUT_FILE%" echo Repository: %CD%
>>"%OUTPUT_FILE%" echo.
>>"%OUTPUT_FILE%" echo ## Branch
for /f "tokens=*" %%I in ('git branch --show-current 2^>nul') do >>"%OUTPUT_FILE%" echo %%I
>>"%OUTPUT_FILE%" echo.
>>"%OUTPUT_FILE%" echo ## Working tree
for /f "tokens=*" %%I in ('git status --short 2^>nul') do >>"%OUTPUT_FILE%" echo %%I
>>"%OUTPUT_FILE%" echo.
>>"%OUTPUT_FILE%" echo ## Recent commits
for /f "tokens=*" %%I in ('git log --oneline -5 2^>nul') do >>"%OUTPUT_FILE%" echo %%I
popd
if not exist "%OUTPUT_FILE%" exit /b 1
echo Git status saved to %OUTPUT_FILE%
exit /b 0
@echo off
REM Open folder test script
REM Purpose: Test opening project folder
REM Platform: Windows 7 SP1 64-bit

setlocal enabledelayedexpansion
REM ȷ����־�����Ŀ¼����(2026-07-07 �޸�: ��ǰȱʧ mkdir ���� 14 �� log ����ȫ FAIL)
if not exist "runtime\logs" mkdir "runtime\logs"
if not exist "runtime\results" mkdir "runtime\results"
set "FOLDER_PATH=%~1"

if "%FOLDER_PATH%"=="" (
    echo [ERROR] Folder path required
    echo Usage: %0 "folder_path"
    exit /b 1
)

echo [%date% %time%] Opening folder: path=%FOLDER_PATH% >> "runtime\logs\open_folder.log"

REM Check if folder exists
if not exist "%FOLDER_PATH%" (
    echo [ERROR] Folder not found: %FOLDER_PATH%
    exit /b 1
)

REM Open folder
echo Opening folder: %FOLDER_PATH%
explorer "%FOLDER_PATH%"

echo Folder opened

echo [%date% %time%] Folder opened >> "runtime\logs\open_folder.log"

exit /b 0

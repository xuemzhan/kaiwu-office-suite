@echo off
REM Obsidian note test script
REM Purpose: Test creating Obsidian notes
REM Platform: Windows 7 SP1 64-bit

setlocal enabledelayedexpansion
REM 确保日志与输出目录存在(2026-07-07 修复: 此前缺失 mkdir 导致 14 个 log 断言全 FAIL)
if not exist "logs" mkdir "logs"
if not exist "results" mkdir "results"
set "TITLE=%~1"
set "CONTENT=%~2"
set "TAGS=%~3"
set "FOLDER=%~4"
set "OUTPUT_FILE=%~5"

if "%TITLE%"=="" (
    echo [ERROR] Title required
    echo Usage: %0 "title" ["content"] ["tags"] ["folder"]
    exit /b 1
)

if "%CONTENT%"=="" set "CONTENT=No content"
if "%TAGS%"=="" set "TAGS=note"
if "%FOLDER%"=="" set "FOLDER=00_Inbox"
if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=results\note_path.txt"

if not exist "results" mkdir "results"

echo [%date% %time%] Creating note: title=%TITLE% >> "logs\obsidian_note.log"

REM Create Obsidian Vault structure
set "VAULT_PATH=%USERPROFILE%\Documents\KaiwuVault"
set "NOTE_PATH=%VAULT_PATH%\%FOLDER%\%TITLE%.md"

if not exist "%VAULT_PATH%" (
    echo [INFO] Obsidian Vault not found, creating structure...
    mkdir "%VAULT_PATH%"
    mkdir "%VAULT_PATH%\00_Inbox"
    mkdir "%VAULT_PATH%\01_Projects"
    mkdir "%VAULT_PATH%\02_References"
    mkdir "%VAULT_PATH%\03_OCR"
    mkdir "%VAULT_PATH%\04_Archive"
    mkdir "%VAULT_PATH%\05_Templates"
    mkdir "%VAULT_PATH%\99_Archive"
)

REM Create folder if needed
if not exist "%VAULT_PATH%\%FOLDER%" (
    echo [INFO] Creating folder: %FOLDER%
    mkdir "%VAULT_PATH%\%FOLDER%"
)

REM Create note
echo --- > "%NOTE_PATH%"
echo title: "%TITLE%" >> "%NOTE_PATH%"
echo date: %date% %time% >> "%NOTE_PATH%"
echo tags: [%TAGS%] >> "%NOTE_PATH%"
echo --- >> "%NOTE_PATH%"
echo. >> "%NOTE_PATH%"
echo # %TITLE% >> "%NOTE_PATH%"
echo. >> "%NOTE_PATH%"
echo %CONTENT% >> "%NOTE_PATH%"
echo. >> "%NOTE_PATH%"
echo ## Metadata >> "%NOTE_PATH%"
echo. >> "%NOTE_PATH%"
echo - Created: %date% %time% >> "%NOTE_PATH%"
echo - Path: %NOTE_PATH% >> "%NOTE_PATH%"
echo - Tags: %TAGS% >> "%NOTE_PATH%"

REM Save note path
echo %NOTE_PATH% > "%OUTPUT_FILE%"

echo Note created: %NOTE_PATH%

echo [%date% %time%] Note created: path=%NOTE_PATH% >> "logs\obsidian_note.log"

exit /b 0

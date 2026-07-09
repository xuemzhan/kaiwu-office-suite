@echo off
REM OCR to Obsidian script
REM Purpose: OCR an image and save result into Obsidian vault with YAML frontmatter
REM Target: Windows 7 SP1 64-bit
REM Created: 2026-07-09

setlocal enabledelayedexpansion
REM Ensure log and output directories exist
if not exist "logs" mkdir "logs"
if not exist "results" mkdir "results"

REM Parse arguments
set "IMAGE_PATH=%~1"
set "LANGUAGE=%~2"
set "NOTE_TITLE=%~3"

if "%IMAGE_PATH%"=="" (
    echo [ERROR] Please provide image path
    echo Usage: %0 "image_path" ["language"] ["note_title"]
    echo Language: chi_sim(Chinese), eng(English), chi_sim+eng(Chinese+English)
    exit /b 1
)

if "%LANGUAGE%"=="" set "LANGUAGE=chi_sim+eng"
if "%NOTE_TITLE%"=="" (
    REM Derive title from filename
    for %%f in ("%IMAGE_PATH%") do set "NOTE_TITLE=OCR_%%~nf"
)

REM Determine Obsidian vault path
set "VAULT_PATH=%USERPROFILE%\Documents\KaiwuVault"
if not exist "%VAULT_PATH%" (
    echo [WARN] Obsidian vault not found at %VAULT_PATH%
    echo Creating vault folder structure...
    mkdir "%VAULT_PATH%" 2>nul
    mkdir "%VAULT_PATH%\03_OCR" 2>nul
)

REM Ensure OCR folder exists
if not exist "%VAULT_PATH%\03_OCR" mkdir "%VAULT_PATH%\03_OCR"

REM Build output file path
set "OUTPUT_FILE=%VAULT_PATH%\03_OCR\%NOTE_TITLE%.md"

REM Log start
echo [%date% %time%] Start OCR to Obsidian: image=%IMAGE_PATH% lang=%LANGUAGE% title=%NOTE_TITLE% >> "logs\ocr_to_obsidian.log"

REM Check Tesseract is installed
if not exist "C:\Program Files\Tesseract-OCR\tesseract.exe" (
    echo [ERROR] Tesseract not installed
    echo Please install Tesseract-OCR first
    exit /b 1
)

REM Run OCR to temp file
echo Recognizing image...
"C:\Program Files\Tesseract-OCR\tesseract.exe" "%IMAGE_PATH%" "results\temp_ocr_obs" -l "%LANGUAGE%"

REM Check OCR result
if not exist "results\temp_ocr_obs.txt" (
    echo [ERROR] OCR recognition failed
    exit /b 1
)

REM Build Obsidian note with YAML frontmatter
(
    echo ---
    echo title: %NOTE_TITLE%
    echo source: %IMAGE_PATH%
    echo language: %LANGUAGE%
    echo tool: Tesseract OCR
    echo date: %date%
    echo tags:
    echo   - ocr
    echo   - source/%LANGUAGE%
    echo ---
    echo.
    echo # %NOTE_TITLE%
    echo.
    echo ## Source
    echo.
    echo - **Image:** %IMAGE_PATH%
    echo - **Language:** %LANGUAGE%
    echo - **Recognized:** %date% %time%
    echo.
    echo ## Content
    echo.
    type "results\temp_ocr_obs.txt"
    echo.
    echo.
    echo ## Actions
    echo.
    echo - [ ] Review and correct OCR errors
    echo - [ ] Add to relevant knowledge base
    echo - [ ] Link to related notes
) > "%OUTPUT_FILE%"

REM Cleanup temp files
del "results\temp_ocr_obs.txt" 2>nul
del "results\temp_ocr_obs.tsv" 2>nul

echo OCR to Obsidian complete. Note saved to: %OUTPUT_FILE%

REM Log completion
echo [%date% %time%] OCR to Obsidian complete: output=%OUTPUT_FILE% >> "logs\ocr_to_obsidian.log"

exit /b 0

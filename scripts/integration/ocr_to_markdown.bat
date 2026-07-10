@echo off
REM OCR to Markdown script
REM Purpose: OCR an image and save result as a Markdown file with metadata
REM Target: Windows 7 SP1 64-bit
REM Created: 2026-07-09

setlocal enabledelayedexpansion
REM Ensure log and output directories exist
if not exist "runtime\logs" mkdir "runtime\logs"
if not exist "runtime\results" mkdir "runtime\results"

REM Parse arguments
set "IMAGE_PATH=%~1"
set "LANGUAGE=%~2"
set "OUTPUT_FILE=%~3"

if "%IMAGE_PATH%"=="" (
    echo [ERROR] Please provide image path
    echo Usage: %0 "image_path" ["language"] ["output_file"]
    echo Language: chi_sim(Chinese), eng(English), chi_sim+eng(Chinese+English)
    exit /b 1
)

if "%LANGUAGE%"=="" set "LANGUAGE=chi_sim+eng"
if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=runtime\results\ocr_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%.md"

REM Ensure output directory exists
for %%f in ("%OUTPUT_FILE%") do if not exist "%%~dpf" mkdir "%%~dpf"

REM Log start
echo [%date% %time%] Start OCR to Markdown: image=%IMAGE_PATH% lang=%LANGUAGE% >> "runtime\logs\ocr_to_markdown.log"

REM Check Tesseract is installed
if not exist "C:\Program Files\Tesseract-OCR\tesseract.exe" (
    echo [ERROR] Tesseract not installed
    echo Please install Tesseract-OCR first
    exit /b 1
)

REM Run OCR to temp file
echo Recognizing image...
"C:\Program Files\Tesseract-OCR\tesseract.exe" "%IMAGE_PATH%" "runtime\results\temp_ocr_md" -l "%LANGUAGE%"

REM Check OCR result
if not exist "runtime\results\temp_ocr_md.txt" (
    echo [ERROR] OCR recognition failed
    exit /b 1
)

REM Build Markdown file with metadata
(
    echo # OCR Recognition Result
    echo.
    echo ## Metadata
    echo.
    echo - **Source:** %IMAGE_PATH%
    echo - **Language:** %LANGUAGE%
    echo - **Timestamp:** %date% %time%
    echo - **Tool:** Tesseract OCR
    echo.
    echo ## Content
    echo.
    type "runtime\results\temp_ocr_md.txt"
) > "%OUTPUT_FILE%"

REM Cleanup temp files
del "runtime\results\temp_ocr_md.txt" 2>nul
del "runtime\results\temp_ocr_md.tsv" 2>nul

echo OCR to Markdown complete. Output saved to: %OUTPUT_FILE%

REM Log completion
echo [%date% %time%] OCR to Markdown complete: output=%OUTPUT_FILE% >> "runtime\logs\ocr_to_markdown.log"

exit /b 0

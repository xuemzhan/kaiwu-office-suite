@echo off
REM Tesseract OCR test script
REM Purpose: Test Tesseract OCR functionality
REM Platform: Windows 7 SP1 64-bit

setlocal enabledelayedexpansion
REM ȷ����־�����Ŀ¼����(2026-07-07 �޸�: ��ǰȱʧ mkdir ���� 14 �� log ����ȫ FAIL)
if not exist "runtime\logs" mkdir "runtime\logs"
if not exist "runtime\results" mkdir "runtime\results"
set "IMAGE_PATH=%~1"
set "LANGUAGE=%~2"
set "OUTPUT_FORMAT=%~3"
set "OUTPUT_FILE=%~4"

if "%IMAGE_PATH%"=="" (
    echo [ERROR] Image path required
    echo Usage: %0 "image_path" ["language"] ["format"]
    echo Languages: chi_sim, eng, chi_sim+eng
    echo Formats: txt, md, json
    exit /b 1
)

if "%LANGUAGE%"=="" set "LANGUAGE=chi_sim+eng"
if "%OUTPUT_FORMAT%"=="" set "OUTPUT_FORMAT=txt"
if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=runtime\results\ocr_result.%OUTPUT_FORMAT%"

if not exist "runtime\results" mkdir "runtime\results"

echo [%date% %time%] Starting OCR: image=%IMAGE_PATH% lang=%LANGUAGE% >> "runtime\logs\tesseract_ocr.log"

REM Check Tesseract
if not exist "C:\Program Files\Tesseract-OCR\tesseract.exe" (
    echo [ERROR] Tesseract not installed
    echo Please install Tesseract-OCR
    exit /b 1
)

REM Run OCR
echo Running OCR...
"C:\Program Files\Tesseract-OCR\tesseract.exe" "%IMAGE_PATH%" "runtime\results\temp_ocr" -l "%LANGUAGE%"

REM Check output
if not exist "runtime\results\temp_ocr.txt" (
    echo [ERROR] OCR failed
    exit /b 1
)

REM Format output
if "%OUTPUT_FORMAT%"=="txt" (
    copy "runtime\results\temp_ocr.txt" "%OUTPUT_FILE%" >nul
) else if "%OUTPUT_FORMAT%"=="md" (
    echo # OCR Result > "%OUTPUT_FILE%"
    echo. >> "%OUTPUT_FILE%"
    echo **Generated:** %date% %time% >> "%OUTPUT_FILE%"
    echo **Language:** %LANGUAGE% >> "%OUTPUT_FILE%"
    echo **Source:** %IMAGE_PATH% >> "%OUTPUT_FILE%"
    echo. >> "%OUTPUT_FILE%"
    echo ## Extracted Text >> "%OUTPUT_FILE%"
    echo. >> "%OUTPUT_FILE%"
    type "runtime\results\temp_ocr.txt" >> "%OUTPUT_FILE%"
) else if "%OUTPUT_FORMAT%"=="json" (
    echo { > "%OUTPUT_FILE%"
    echo   "ocr_info": { >> "%OUTPUT_FILE%"
    echo     "image_path": "%IMAGE_PATH%", >> "%OUTPUT_FILE%"
    echo     "language": "%LANGUAGE%", >> "%OUTPUT_FILE%"
    echo     "timestamp": "%date% %time%", >> "%OUTPUT_FILE%"
    echo     "output_format": "%OUTPUT_FORMAT%" >> "%OUTPUT_FILE%"
    echo   }, >> "%OUTPUT_FILE%"
    echo   "content": " >> "%OUTPUT_FILE%"
    powershell -Command "$content = Get-Content 'runtime\results\temp_ocr.txt' -Raw; $content = $content.Replace('\', '\\').Replace('"', '\"').Replace([char]13, '\r').Replace([char]10, '\n'); Write-Output $content" >> "%OUTPUT_FILE%"
    echo " >> "%OUTPUT_FILE%"
    echo } >> "%OUTPUT_FILE%"
)

REM Cleanup
del "runtime\results\temp_ocr.txt" 2>nul
del "runtime\results\temp_ocr.tsv" 2>nul

echo OCR result saved to: %OUTPUT_FILE%

echo [%date% %time%] OCR complete: output=%OUTPUT_FILE% >> "runtime\logs\tesseract_ocr.log"

exit /b 0

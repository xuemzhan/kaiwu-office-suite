@echo off
REM KaiWu Office Suite V1.4.1 - Tesseract OCR
setlocal EnableExtensions DisableDelayedExpansion
chcp 936 >nul 2>&1
cd /d "%~dp0\..\.."
if not exist "runtime\logs" mkdir "runtime\logs"
if not exist "runtime\results" mkdir "runtime\results"
set "IMAGE_PATH=%~1"
set "LANGUAGE=%~2"
set "OUTPUT_FORMAT=%~3"
set "OUTPUT_FILE=%~4"
if not defined IMAGE_PATH exit /b 1
if not defined LANGUAGE set "LANGUAGE=chi_sim+eng"
if not defined OUTPUT_FORMAT set "OUTPUT_FORMAT=txt"
if not defined OUTPUT_FILE set "OUTPUT_FILE=runtime\results\ocr_result.%OUTPUT_FORMAT%"
echo [%date% %time%] OCR image=%IMAGE_PATH%>>"runtime\logs\tesseract_ocr.log"
if not exist "%IMAGE_PATH%" (
  echo [FAIL] Image not found
  exit /b 2
)
set "TESS=C:\Program Files\Tesseract-OCR\tesseract.exe"
if not exist "%TESS%" (
  echo [FAIL] Tesseract is not installed
  exit /b 3
)
"%TESS%" "%IMAGE_PATH%" "runtime\results\temp_ocr" -l "%LANGUAGE%"
if errorlevel 1 exit /b 4
if /i "%OUTPUT_FORMAT%"=="md" (
  >"%OUTPUT_FILE%" echo # OCR Result
  >>"%OUTPUT_FILE%" echo.
  type "runtime\results\temp_ocr.txt">>"%OUTPUT_FILE%"
) else (
  copy /Y "runtime\results\temp_ocr.txt" "%OUTPUT_FILE%" >nul
)
del /q "runtime\results\temp_ocr.txt" >nul 2>&1
if not exist "%OUTPUT_FILE%" exit /b 4
echo OCR saved to %OUTPUT_FILE%
exit /b 0
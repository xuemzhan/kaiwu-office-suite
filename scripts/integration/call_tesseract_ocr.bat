@echo off
REM Tesseract OCR 调用脚本
REM 功能: 调用Tesseract进行文字识别
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion
REM 确保日志与输出目录存在(2026-07-07 修复: 此前缺失 mkdir 导致 14 个 log 断言全 FAIL)
if not exist "logs" mkdir "logs"
if not exist "results" mkdir "results"


REM 参数设置
set "IMAGE_PATH=%~1"
set "LANGUAGE=%~2"
set "OUTPUT_FORMAT=%~3"
set "OUTPUT_FILE=%~4"

if "%IMAGE_PATH%"=="" (
    echo [错误] 请提供图片路径
    echo 用法: %0 "图片路径" ["语言"] ["格式"]
    echo 语言: chi_sim(中文), eng(英文), chi_sim+eng(中英混合)
    echo 格式: txt, md, json
    exit /b 1
)

if "%LANGUAGE%"=="" set "LANGUAGE=chi_sim+eng"
if "%OUTPUT_FORMAT%"=="" set "OUTPUT_FORMAT=txt"
if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=results\ocr_result.%OUTPUT_FORMAT%"

REM 创建输出目录
if not exist "results" mkdir "results"

REM 记录日志
echo [%date% %time%] 开始OCR识别: 图片=%IMAGE_PATH% 语言=%LANGUAGE% >> "logs\tesseract_ocr.log"

REM 检查Tesseract是否安装
if not exist "C:\Program Files\Tesseract-OCR\tesseract.exe" (
    echo [错误] Tesseract未安装
    echo 请先安装Tesseract-OCR
    exit /b 1
)

REM 执行OCR识别
echo 正在识别图片文字...
"C:\Program Files\Tesseract-OCR\tesseract.exe" "%IMAGE_PATH%" "results\temp_ocr" -l "%LANGUAGE%"

REM 检查识别结果
if not exist "results\temp_ocr.txt" (
    echo [错误] OCR识别失败
    exit /b 1
)

REM 根据格式转换结果
if "%OUTPUT_FORMAT%"=="txt" (
    copy "results\temp_ocr.txt" "%OUTPUT_FILE%" >nul
) else if "%OUTPUT_FORMAT%"=="md" (
    echo # OCR识别结果 > "%OUTPUT_FILE%"
    echo. >> "%OUTPUT_FILE%"
    echo **识别时间:** %date% %time% >> "%OUTPUT_FILE%"
    echo **识别语言:** %LANGUAGE% >> "%OUTPUT_FILE%"
    echo **源文件:** %IMAGE_PATH% >> "%OUTPUT_FILE%"
    echo. >> "%OUTPUT_FILE%"
    echo ## 识别内容 >> "%OUTPUT_FILE%"
    echo. >> "%OUTPUT_FILE%"
    type "results\temp_ocr.txt" >> "%OUTPUT_FILE%"
) else if "%OUTPUT_FORMAT%"=="json" (
    echo { > "%OUTPUT_FILE%"
    echo   "ocr_info": { >> "%OUTPUT_FILE%"
    echo     "image_path": "%IMAGE_PATH%", >> "%OUTPUT_FILE%"
    echo     "language": "%LANGUAGE%", >> "%OUTPUT_FILE%"
    echo     "timestamp": "%date% %time%", >> "%OUTPUT_FILE%"
    echo     "output_format": "%OUTPUT_FORMAT%" >> "%OUTPUT_FILE%"
    echo   }, >> "%OUTPUT_FILE%"
    echo   "content": " >> "%OUTPUT_FILE%"
    REM 读取文件内容并转义特殊字符
    powershell -Command "$content = Get-Content 'results\temp_ocr.txt' -Raw; $content = $content -replace '\"', '\"'; $content = $content -replace \"`n\", \"\\n\"; Write-Output $content" >> "%OUTPUT_FILE%"
    echo " >> "%OUTPUT_FILE%"
    echo } >> "%OUTPUT_FILE%"
)

REM 清理临时文件
del "results\temp_ocr.txt" 2>nul
del "results\temp_ocr.tsv" 2>nul

echo OCR识别完成，结果已保存到: %OUTPUT_FILE%

REM 记录日志
echo [%date% %time%] OCR识别完成: 输出文件=%OUTPUT_FILE% >> "logs\tesseract_ocr.log"

exit /b 0

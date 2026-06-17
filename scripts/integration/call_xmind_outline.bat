@echo off
REM XMind大纲生成调用脚本
REM 功能: 生成XMind大纲文本
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion

REM 参数设置
set "TOPIC=%~1"
set "SUBTOPICS=%~2"
set "OUTPUT_FILE=%~3"

if "%TOPIC%"=="" (
    echo [错误] 请提供主题
    echo 用法: %0 "主题" ["子主题1,子主题2,..."]
    exit /b 1
)

if "%SUBTOPICS%"=="" set "SUBTOPICS=子主题1,子主题2,子主题3"
if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=results\outline.txt"

REM 创建输出目录
if not exist "results" mkdir "results"

REM 记录日志
echo [%date% %time%] 开始生成大纲: 主题=%TOPIC% >> "logs\xmind_outline.log"

REM 创建大纲文件
echo # %TOPIC% > "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo **生成时间:** %date% %time% >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo ## 大纲结构 >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"

REM 解析子主题并生成大纲
set "subtopic_count=0"
for %%i in (%SUBTOPICS%) do (
    set /a subtopic_count+=1
    echo ### %%i >> "%OUTPUT_FILE%"
    echo. >> "%OUTPUT_FILE%"
    echo - 待补充内容 >> "%OUTPUT_FILE%"
    echo. >> "%OUTPUT_FILE%"
)

REM 添加备注
echo ## 使用说明 >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo 1. 将此大纲复制到XMind中 >> "%OUTPUT_FILE%"
echo 2. 或者使用XMind的导入功能导入此文件 >> "%OUTPUT_FILE%"
echo 3. 可以根据需要调整子主题内容 >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo ## 主题信息 >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"
echo - 主题: %TOPIC% >> "%OUTPUT_FILE%"
echo - 子主题数量: %subtopic_count% >> "%OUTPUT_FILE%"
echo - 生成时间: %date% %time% >> "%OUTPUT_FILE%"

echo 大纲生成完成，结果已保存到: %OUTPUT_FILE%
echo 子主题数量: %subtopic_count%

REM 记录日志
echo [%date% %time%] 大纲生成完成: 子主题数量=%subtopic_count% >> "logs\xmind_outline.log"

exit /b 0

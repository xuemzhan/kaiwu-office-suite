@echo off
REM Obsidian笔记创建调用脚本
REM 功能: 在Obsidian知识库中创建笔记
REM 目标环境: Windows 7 SP1 64位
REM 生成时间: 2026-06-17

setlocal enabledelayedexpansion
REM 确保日志与输出目录存在(2026-07-07 修复: 此前缺失 mkdir 导致 14 个 log 断言全 FAIL)
if not exist "logs" mkdir "logs"
if not exist "results" mkdir "results"


REM 参数设置
set "TITLE=%~1"
set "CONTENT=%~2"
set "TAGS=%~3"
set "FOLDER=%~4"
set "OUTPUT_FILE=%~5"

if "%TITLE%"=="" (
    echo [错误] 请提供笔记标题
    echo 用法: %0 "标题" ["内容"] ["标签"] ["文件夹"]
    exit /b 1
)

if "%CONTENT%"=="" set "CONTENT=无内容"
if "%TAGS%"=="" set "TAGS=笔记"
if "%FOLDER%"=="" set "FOLDER=00_Inbox"
if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=results\note_path.txt"

REM 创建输出目录
if not exist "results" mkdir "results"

REM 记录日志
echo [%date% %time%] 开始创建笔记: 标题=%TITLE% >> "logs\obsidian_note.log"

REM 设置Obsidian Vault路径
set "VAULT_PATH=%USERPROFILE%\Documents\KaiwuVault"
set "NOTE_PATH=%VAULT_PATH%\%FOLDER%\%TITLE%.md"

REM 检查Vault是否存在
if not exist "%VAULT_PATH%" (
    echo [警告] Obsidian Vault不存在，正在创建...
    mkdir "%VAULT_PATH%"
    mkdir "%VAULT_PATH%\00_Inbox"
    mkdir "%VAULT_PATH%\01_项目资料"
    mkdir "%VAULT_PATH%\02_会议纪要"
    mkdir "%VAULT_PATH%\03_OCR识别"
    mkdir "%VAULT_PATH%\04_个人知识"
    mkdir "%VAULT_PATH%\05_模板库"
    mkdir "%VAULT_PATH%\99_归档"
)

REM 检查目标文件夹是否存在
if not exist "%VAULT_PATH%\%FOLDER%" (
    echo [警告] 目标文件夹不存在，正在创建...
    mkdir "%VAULT_PATH%\%FOLDER%"
)

REM 创建笔记文件
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
echo ## 元信息 >> "%NOTE_PATH%"
echo. >> "%NOTE_PATH%"
echo - 创建时间: %date% %time% >> "%NOTE_PATH%"
echo - 文件路径: %NOTE_PATH% >> "%NOTE_PATH%"
echo - 标签: %TAGS% >> "%NOTE_PATH%"

REM 输出笔记路径
echo %NOTE_PATH% > "%OUTPUT_FILE%"

echo 笔记创建完成，路径: %NOTE_PATH%

REM 记录日志
echo [%date% %time%] 笔记创建完成: 路径=%NOTE_PATH% >> "logs\obsidian_note.log"

exit /b 0

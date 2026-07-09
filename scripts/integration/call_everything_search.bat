@echo off
REM Everything �ļ��������ýű�
REM ����: ����Everything�����ļ�����
REM Ŀ�껷��: Windows 7 SP1 64λ
REM ����ʱ��: 2026-06-17

setlocal enabledelayedexpansion
REM ȷ����־�����Ŀ¼����?2026-07-07 �޸�: ��ǰȱʧ mkdir ���� 14 �� log ����ȫ FAIL)
if not exist "logs" mkdir "logs"
if not exist "results" mkdir "results"


REM Parse arguments
set "KEYWORD=%~1"
set "SEARCH_PATH=%~2"
set "OUTPUT_FILE=%~3"

if "%KEYWORD%"=="" (
    echo [����] ���ṩ�����ؼ���
    echo �÷�: %0 "�ؼ���" ["·��"]
    exit /b 1
)

if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=results\file_search_result.json"

REM �������Ŀ�?
if not exist "results" mkdir "results"

REM ��¼��־
echo [%date% %time%] Start search: keyword=%KEYWORD% path=%SEARCH_PATH% >> "logs\everything_search.log"

REM ���Everything����
sc query "Everything" >nul 2>&1
if %errorLevel% neq 0 (
    echo [����] Everything����δ����
    echo ��������Everything����
    exit /b 1
)

REM ʹ��es.exe����������Everything�����й��ߣ�
if exist "C:\Program Files\Everything\es.exe" (
    echo ʹ��es.exe��������...
    "C:\Program Files\Everything\es.exe" "%KEYWORD%" > "results\temp_search.txt"
) else (
    echo [����] δ�ҵ�es.exe��ʹ�ñ�ѡ����
    REM ��ѡ������ʹ��PowerShell����Everything
    powershell -Command "Get-ChildItem -Path '%SEARCH_PATH%' -Recurse -Filter '*%KEYWORD%*' | Select-Object FullName, Length, LastWriteTime | ForEach-Object { '{0},{1},{2}' -f $_.FullName, $_.Length, $_.LastWriteTime }" > "results\temp_search.txt"
)

REM Build JSON via PowerShell ConvertTo-Json (P2-3 hardening)
powershell -command "$results = @(); foreach ($line in Get-Content 'results\temp_search.txt' -ErrorAction SilentlyContinue) { if ($line.Trim()) { $results += @{path=$line.Trim()} } }; $obj = @{ search_info = @{ keyword='%KEYWORD%', path='%SEARCH_PATH%', timestamp=(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), result_count=$results.Count }; results=$results }; $obj | ConvertTo-Json -Depth 5 | Set-Content '%OUTPUT_FILE%' -Encoding UTF8"
if %errorLevel% neq 0 (
    echo [ERROR] JSON build failed
    exit /b 1
)

REM ������ʱ�ļ�
del "results\temp_search.txt" 2>nul

echo ������ɣ�����ѱ��浽: %OUTPUT_FILE%
echo Search complete. Output saved to: %OUTPUT_FILE%

REM ��¼��־
echo Search complete. Output saved to: %OUTPUT_FILE%

exit /b 0

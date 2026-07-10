@echo off

REM XMind������ɵ��ýű�

REM ����: ����XMind����ı�

REM Ŀ�껷��: Windows 7 SP1 64λ

REM ����ʱ��: 2026-06-17


setlocal enabledelayedexpansion
REM ȷ����־�����Ŀ¼����(2026-07-07 �޸�: ��ǰȱʧ mkdir ���� 14 �� log ����ȫ FAIL)
if not exist "runtime\logs" mkdir "runtime\logs"
if not exist "runtime\results" mkdir "runtime\results"



REM ��������

set "TOPIC=%~1"

set "SUBTOPICS=%~2"

set "OUTPUT_FILE=%~3"


if "%TOPIC%"=="" (

    echo [����] ���ṩ����

    echo �÷�: %0 "����" ["������1,������2,..."]

    exit /b 1

)


if "%SUBTOPICS%"=="" set "SUBTOPICS=������1,������2,������3"

if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=runtime\results\outline.txt"


REM �������Ŀ¼

if not exist "runtime\results" mkdir "runtime\results"


REM ��¼��־

echo [%date% %time%] ��ʼ���ɴ��: ����=%TOPIC% >> "runtime\logs\xmind_outline.log"


REM ��������ļ�

echo # %TOPIC% > "%OUTPUT_FILE%"

echo. >> "%OUTPUT_FILE%"

echo **����ʱ��:** %date% %time% >> "%OUTPUT_FILE%"

echo. >> "%OUTPUT_FILE%"

echo ## ��ٽṹ >> "%OUTPUT_FILE%"

echo. >> "%OUTPUT_FILE%"


REM ���������Ⲣ���ɴ��

set "subtopic_count=0"

for %%i in (%SUBTOPICS%) do (

    set /a subtopic_count+=1

    echo ### %%i >> "%OUTPUT_FILE%"

    echo. >> "%OUTPUT_FILE%"

    echo - ���������� >> "%OUTPUT_FILE%"

    echo. >> "%OUTPUT_FILE%"

)


REM ���ӱ�ע

echo ## ʹ��˵�� >> "%OUTPUT_FILE%"

echo. >> "%OUTPUT_FILE%"

echo 1. ���˴�ٸ��Ƶ�XMind�� >> "%OUTPUT_FILE%"

echo 2. ����ʹ��XMind�ĵ��빦�ܵ�����ļ� >> "%OUTPUT_FILE%"

echo 3. ���Ը�����Ҫ�������������� >> "%OUTPUT_FILE%"

echo. >> "%OUTPUT_FILE%"

echo ## ������Ϣ >> "%OUTPUT_FILE%"

echo. >> "%OUTPUT_FILE%"

echo - ����: %TOPIC% >> "%OUTPUT_FILE%"

echo - ����������: %subtopic_count% >> "%OUTPUT_FILE%"

echo - ����ʱ��: %date% %time% >> "%OUTPUT_FILE%"


echo ���������ɣ�����ѱ��浽: %OUTPUT_FILE%

echo ����������: %subtopic_count%


REM ��¼��־

echo [%date% %time%] ����������: ����������=%subtopic_count% >> "runtime\logs\xmind_outline.log"


exit /b 0


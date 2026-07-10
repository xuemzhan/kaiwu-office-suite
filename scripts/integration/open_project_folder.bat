@echo off
REM ����Ŀ�ļ��е��ýű�
REM ����: ��ָ������Ŀ�ļ���
REM Ŀ�껷��: Windows 7 SP1 64λ
REM ����ʱ��: 2026-06-17

setlocal enabledelayedexpansion
REM ȷ����־Ŀ¼����(2026-07-07 �޸�;���ű��� results ���)
if not exist "runtime\logs" mkdir "runtime\logs"


REM ��������
set "FOLDER_PATH=%~1"

if "%FOLDER_PATH%"=="" (
    echo [����] ���ṩ�ļ���·��
    echo �÷�: %0 "�ļ���·��"
    exit /b 1
)

REM ��¼��־
echo [%date% %time%] ���ļ���: ·��=%FOLDER_PATH% >> "runtime\logs\open_folder.log"

REM ����ļ����Ƿ����
if not exist "%FOLDER_PATH%" (
    echo [����] �ļ��в�����: %FOLDER_PATH%
    exit /b 1
)

REM ���ļ���
echo ���ڴ��ļ���: %FOLDER_PATH%
explorer "%FOLDER_PATH%"

echo �ļ����Ѵ�

REM ��¼��־
echo [%date% %time%] �ļ����Ѵ� >> "runtime\logs\open_folder.log"

exit /b 0

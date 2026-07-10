@echo off
REM Obsidian�ʼǴ������ýű�
REM ����: ��Obsidian֪ʶ���д����ʼ�
REM Ŀ�껷��: Windows 7 SP1 64λ
REM ����ʱ��: 2026-06-17

setlocal enabledelayedexpansion
REM ȷ����־�����Ŀ¼����(2026-07-07 �޸�: ��ǰȱʧ mkdir ���� 14 �� log ����ȫ FAIL)
if not exist "runtime\logs" mkdir "runtime\logs"
if not exist "runtime\results" mkdir "runtime\results"


REM ��������
set "TITLE=%~1"
set "CONTENT=%~2"
set "TAGS=%~3"
set "FOLDER=%~4"
set "OUTPUT_FILE=%~5"

if "%TITLE%"=="" (
    echo [����] ���ṩ�ʼǱ���
    echo �÷�: %0 "����" ["����"] ["��ǩ"] ["�ļ���"]
    exit /b 1
)

if "%CONTENT%"=="" set "CONTENT=������"
if "%TAGS%"=="" set "TAGS=�ʼ�"
if "%FOLDER%"=="" set "FOLDER=00_Inbox"
if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=runtime\results\note_path.txt"

REM �������Ŀ¼
if not exist "runtime\results" mkdir "runtime\results"

REM ��¼��־
echo [%date% %time%] ��ʼ�����ʼ�: ����=%TITLE% >> "runtime\logs\obsidian_note.log"

REM ����Obsidian Vault·��
set "VAULT_PATH=%USERPROFILE%\Documents\KaiwuVault"
set "NOTE_PATH=%VAULT_PATH%\%FOLDER%\%TITLE%.md"

REM ���Vault�Ƿ����
if not exist "%VAULT_PATH%" (
    echo [����] Obsidian Vault�����ڣ����ڴ���...
    mkdir "%VAULT_PATH%"
    mkdir "%VAULT_PATH%\00_Inbox"
    mkdir "%VAULT_PATH%\01_��Ŀ����"
    mkdir "%VAULT_PATH%\02_�����Ҫ"
    mkdir "%VAULT_PATH%\03_OCRʶ��"
    mkdir "%VAULT_PATH%\04_����֪ʶ"
    mkdir "%VAULT_PATH%\05_ģ���"
    mkdir "%VAULT_PATH%\99_�鵵"
)

REM ���Ŀ���ļ����Ƿ����
if not exist "%VAULT_PATH%\%FOLDER%" (
    echo [����] Ŀ���ļ��в����ڣ����ڴ���...
    mkdir "%VAULT_PATH%\%FOLDER%"
)

REM �����ʼ��ļ�
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
echo ## Ԫ��Ϣ >> "%NOTE_PATH%"
echo. >> "%NOTE_PATH%"
echo - ����ʱ��: %date% %time% >> "%NOTE_PATH%"
echo - �ļ�·��: %NOTE_PATH% >> "%NOTE_PATH%"
echo - ��ǩ: %TAGS% >> "%NOTE_PATH%"

REM ����ʼ�·��
echo %NOTE_PATH% > "%OUTPUT_FILE%"

echo �ʼǴ�����ɣ�·��: %NOTE_PATH%

REM ��¼��־
echo [%date% %time%] �ʼǴ������: ·��=%NOTE_PATH% >> "runtime\logs\obsidian_note.log"

exit /b 0

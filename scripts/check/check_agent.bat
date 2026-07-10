@echo off
REM Agent������ű�
REM ����: ���AionUI��Hermes Desktop��OpenCode״̬
REM Ŀ�껷��: Windows 7 SP1 64λ
REM ����ʱ��: 2026-06-17

setlocal enabledelayedexpansion

REM ������־�ļ�
set "LOG_FILE=runtime\logs\check_agent_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
if not exist "runtime\logs" mkdir "runtime\logs"

echo [%date% %time%] ��ʼ���Agent��� >> "%LOG_FILE%"

REM ���ü��Ŀ¼
set "INSTALL_DIR=%~dp0..\.."

REM ��ʼ��������
set "TOTAL=0"
set "PASS=0"
set "FAIL=0"
set "WARN=0"

REM 1. ��� AionUI
echo [��Ϣ] ��� AionUI...
echo [%date% %time%] ��� AionUI >> "%LOG_FILE%"

set /a TOTAL+=1
set "AIONUI_EXE=%INSTALL_DIR%\packages\raw\01_agent\AionUI.exe"
if exist "%AIONUI_EXE%" (
    echo [ͨ��] AionUI ����: %AIONUI_EXE%
    echo [%date% %time%] [ͨ��] AionUI ���� >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [ʧ��] AionUI ������: %AIONUI_EXE%
    echo [%date% %time%] [ʧ��] AionUI ������ >> "%LOG_FILE%"
    set /a FAIL+=1
)

REM 2. ��� Hermes Desktop
echo [��Ϣ] ��� Hermes Desktop...
echo [%date% %time%] ��� Hermes Desktop >> "%LOG_FILE%"

set /a TOTAL+=1
set "HERMES_EXE=%INSTALL_DIR%\packages\raw\01_agent\HermesDesktop.exe"
if exist "%HERMES_EXE%" (
    echo [ͨ��] Hermes Desktop ����: %HERMES_EXE%
    echo [%date% %time%] [ͨ��] Hermes Desktop ���� >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [ʧ��] Hermes Desktop ������: %HERMES_EXE%
    echo [%date% %time%] [ʧ��] Hermes Desktop ������ >> "%LOG_FILE%"
    set /a FAIL+=1
)

REM 3. ��� OpenCode
echo [��Ϣ] ��� OpenCode...
echo [%date% %time%] ��� OpenCode >> "%LOG_FILE%"

set /a TOTAL+=1
set "OPENCODE_EXE=%INSTALL_DIR%\packages\raw\01_agent\OpenCode.exe"
if exist "%OPENCODE_EXE%" (
    echo [ͨ��] OpenCode ����: %OPENCODE_EXE%
    echo [%date% %time%] [ͨ��] OpenCode ���� >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [ʧ��] OpenCode ������: %OPENCODE_EXE%
    echo [%date% %time%] [ʧ��] OpenCode ������ >> "%LOG_FILE%"
    set /a FAIL+=1
)

REM 4. ��������ļ�
echo [��Ϣ] ��������ļ�...
echo [%date% %time%] ��������ļ� >> "%LOG_FILE%"

set /a TOTAL+=1
set "CONFIG_FILE=%INSTALL_DIR%\config\aionui\aionui.json"
if exist "%CONFIG_FILE%" (
    echo [ͨ��] AionUI�����ļ�����: %CONFIG_FILE%
    echo [%date% %time%] [ͨ��] AionUI�����ļ����� >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [����] AionUI�����ļ�������: %CONFIG_FILE%
    echo [%date% %time%] [����] AionUI�����ļ������� >> "%LOG_FILE%"
    set /a WARN+=1
)

REM 5. �����־Ŀ¼
echo [��Ϣ] �����־Ŀ¼...
echo [%date% %time%] �����־Ŀ¼ >> "%LOG_FILE%"

set /a TOTAL+=1
set "LOG_DIR=%INSTALL_DIR%\logs"
if exist "%LOG_DIR%" (
    echo [ͨ��] ��־Ŀ¼����: %LOG_DIR%
    echo [%date% %time%] [ͨ��] ��־Ŀ¼���� >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [����] ��־Ŀ¼������: %LOG_DIR%
    echo [%date% %time%] [����] ��־Ŀ¼������ >> "%LOG_FILE%"
    set /a WARN+=1
)

REM 6. ��⼯�ɽű�
echo [��Ϣ] ��⼯�ɽű�...
echo [%date% %time%] ��⼯�ɽű� >> "%LOG_FILE%"

set /a TOTAL+=1
set "SCRIPT_DIR=%INSTALL_DIR%\scripts\integration"
if exist "%SCRIPT_DIR%" (
    echo [ͨ��] ���ɽű�Ŀ¼����: %SCRIPT_DIR%
    echo [%date% %time%] [ͨ��] ���ɽű�Ŀ¼���� >> "%LOG_FILE%"
    set /a PASS+=1
) else (
    echo [����] ���ɽű�Ŀ¼������: %SCRIPT_DIR%
    echo [%date% %time%] [����] ���ɽű�Ŀ¼������ >> "%LOG_FILE%"
    set /a WARN+=1
)

REM ���ͳ����Ϣ
echo ========================================
echo ���ͳ��
echo ========================================
echo �ܼ����: %TOTAL%
echo ͨ��: %PASS%
echo ʧ��: %FAIL%
echo ����: %WARN%
echo ========================================

echo [%date% %time%] ���ͳ��: �ܼ�=%TOTAL% ͨ��=%PASS% ʧ��=%FAIL% ����=%WARN% >> "%LOG_FILE%"

REM ����ͨ����
set /a "PASS_RATE=%PASS% * 100 / %TOTAL%"
echo ͨ����: %PASS_RATE%%%

echo [%date% %time%] ͨ����: %PASS_RATE%%% >> "%LOG_FILE%"

REM �ж�����״̬
if %FAIL% equ 0 (
    echo [״̬] Agent������ͨ��
    echo [%date% %time%] [״̬] Agent������ͨ�� >> "%LOG_FILE%"
) else (
    echo [״̬] Agent������ʧ�ܣ���Ҫ�޸�
    echo [%date% %time%] [״̬] Agent������ʧ�ܣ���Ҫ�޸� >> "%LOG_FILE%"
)

echo [��Ϣ] �����ɣ���鿴��־�ļ�: %LOG_FILE%

exit /b 0

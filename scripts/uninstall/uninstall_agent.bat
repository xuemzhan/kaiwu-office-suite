@echo off
REM Agent���ж�ؽű�
REM ����: ж��AionUI��Hermes Desktop��OpenCode
REM Ŀ�껷��: Windows 7 SP1 64λ
REM ����ʱ��: 2026-06-17

setlocal enabledelayedexpansion

REM ������־�ļ�
set "LOG_FILE=runtime\logs\uninstall_agent_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
if not exist "runtime\logs" mkdir "runtime\logs"

echo [%date% %time%] ��ʼж��Agent��� >> "%LOG_FILE%"

REM ������ԱȨ��
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [����] ��Ҫ����ԱȨ�����д˽ű�
    echo [����] ���Ҽ����"�Թ���Ա��������"
    echo [%date% %time%] ����: ȱ�ٹ���ԱȨ�� >> "%LOG_FILE%"
    exit /b 1
)

echo [��Ϣ] ��鵽����ԱȨ�� >> "%LOG_FILE%"

REM ����ж��Ŀ¼
set "INSTALL_DIR=%~dp0..\.."

REM 1. ж�� AionUI
echo [��Ϣ] ж�� AionUI...
echo [%date% %time%] ж�� AionUI >> "%LOG_FILE%"

set "AIONUI_EXE=%INSTALL_DIR%\packages\raw\01_agent\AionUI.exe"
if exist "%AIONUI_EXE%" (
    echo [��Ϣ] �ҵ�AionUI: %AIONUI_EXE%
    echo [%date% %time%] �ҵ�AionUI: %AIONUI_EXE% >> "%LOG_FILE%"
    
    REM ɾ��AionUI��ִ���ļ�
    del /f "%AIONUI_EXE%" >nul 2>&1
    if %errorLevel% equ 0 (
        echo [�ɹ�] AionUI ж�����
        echo [%date% %time%] AionUI ж����� >> "%LOG_FILE%"
    ) else (
        echo [����] AionUI ж��ʧ��
        echo [%date% %time%] AionUI ж��ʧ�� >> "%LOG_FILE%"
    )
) else (
    echo [����] δ�ҵ�AionUI
    echo [%date% %time%] ����: δ�ҵ�AionUI >> "%LOG_FILE%"
)

REM 2. ж�� Hermes Desktop
echo [��Ϣ] ж�� Hermes Desktop...
echo [%date% %time%] ж�� Hermes Desktop >> "%LOG_FILE%"

set "HERMES_EXE=%INSTALL_DIR%\packages\raw\01_agent\HermesDesktop.exe"
if exist "%HERMES_EXE%" (
    echo [��Ϣ] �ҵ�Hermes Desktop: %HERMES_EXE%
    echo [%date% %time%] �ҵ�Hermes Desktop: %HERMES_EXE% >> "%LOG_FILE%"
    
    REM ɾ��Hermes Desktop��ִ���ļ�
    del /f "%HERMES_EXE%" >nul 2>&1
    if %errorLevel% equ 0 (
        echo [�ɹ�] Hermes Desktop ж�����
        echo [%date% %time%] Hermes Desktop ж����� >> "%LOG_FILE%"
    ) else (
        echo [����] Hermes Desktop ж��ʧ��
        echo [%date% %time%] Hermes Desktop ж��ʧ�� >> "%LOG_FILE%"
    )
) else (
    echo [����] δ�ҵ�Hermes Desktop
    echo [%date% %time%] ����: δ�ҵ�Hermes Desktop >> "%LOG_FILE%"
)

REM 3. ж�� OpenCode
echo [��Ϣ] ж�� OpenCode...
echo [%date% %time%] ж�� OpenCode >> "%LOG_FILE%"

set "OPENCODE_EXE=%INSTALL_DIR%\packages\raw\01_agent\OpenCode.exe"
if exist "%OPENCODE_EXE%" (
    echo [��Ϣ] �ҵ�OpenCode: %OPENCODE_EXE%
    echo [%date% %time%] �ҵ�OpenCode: %OPENCODE_EXE% >> "%LOG_FILE%"
    
    REM ɾ��OpenCode��ִ���ļ�
    del /f "%OPENCODE_EXE%" >nul 2>&1
    if %errorLevel% equ 0 (
        echo [�ɹ�] OpenCode ж�����
        echo [%date% %time%] OpenCode ж����� >> "%LOG_FILE%"
    ) else (
        echo [����] OpenCode ж��ʧ��
        echo [%date% %time%] OpenCode ж��ʧ�� >> "%LOG_FILE%"
    )
) else (
    echo [����] δ�ҵ�OpenCode
    echo [%date% %time%] ����: δ�ҵ�OpenCode >> "%LOG_FILE%"
)

REM 4. ���������ļ�
echo [��Ϣ] ���������ļ�...
echo [%date% %time%] ���������ļ� >> "%LOG_FILE%"

set "CONFIG_DIRS=config\aionui config\hermes config\opencode"
for %%d in (%CONFIG_DIRS%) do (
    if exist "%INSTALL_DIR%\%%d" (
        rmdir /s /q "%INSTALL_DIR%\%%d" >nul 2>&1
        echo [��Ϣ] ������: %%d
        echo [%date% %time%] ������: %%d >> "%LOG_FILE%"
    )
)

REM 5. ������־�ļ�
echo [��Ϣ] ������־�ļ�...
echo [%date% %time%] ������־�ļ� >> "%LOG_FILE%"

set "LOG_DIRS=runtime\logs\aionui runtime\logs\hermes runtime\logs\opencode"
for %%d in (%LOG_DIRS%) do (
    if exist "%INSTALL_DIR%\%%d" (
        rmdir /s /q "%INSTALL_DIR%\%%d" >nul 2>&1
        echo [��Ϣ] ������: %%d
        echo [%date% %time%] ������: %%d >> "%LOG_FILE%"
    )
)

echo [%date% %time%] Agent���ж����� >> "%LOG_FILE%"
echo [��Ϣ] ж����ɣ���鿴��־�ļ�: %LOG_FILE%

exit /b 0

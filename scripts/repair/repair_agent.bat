@echo off
REM Agent����޸��ű�
REM ����: �޸�AionUI��Hermes Desktop��OpenCode
REM Ŀ�껷��: Windows 7 SP1 64λ
REM ����ʱ��: 2026-06-17

setlocal enabledelayedexpansion

REM ������־�ļ�
set "LOG_FILE=runtime\logs\repair_agent_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
if not exist "runtime\logs" mkdir "runtime\logs"

echo [%date% %time%] ��ʼ�޸�Agent��� >> "%LOG_FILE%"

REM ������ԱȨ��
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [����] ��Ҫ����ԱȨ�����д˽ű�
    echo [����] ���Ҽ����"�Թ���Ա��������"
    echo [%date% %time%] ����: ȱ�ٹ���ԱȨ�� >> "%LOG_FILE%"
    exit /b 1
)

echo [��Ϣ] ��鵽����ԱȨ�� >> "%LOG_FILE%"

REM �����޸�Ŀ¼
set "INSTALL_DIR=%~dp0..\.."
set "BACKUP_DIR=%INSTALL_DIR%\backup"

REM 1. ��������Ŀ¼
echo [��Ϣ] ��������Ŀ¼...
echo [%date% %time%] ��������Ŀ¼ >> "%LOG_FILE%"

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
if not exist "%BACKUP_DIR%\agent" mkdir "%BACKUP_DIR%\agent"

REM 2. ���������ļ�
echo [��Ϣ] ���������ļ�...
echo [%date% %time%] ���������ļ� >> "%LOG_FILE%"

set "AGENT_DIR=%INSTALL_DIR%\packages\raw\01_agent"
if exist "%AGENT_DIR%" (
    echo [��Ϣ] ����AgentĿ¼: %AGENT_DIR%
    echo [%date% %time%] ����AgentĿ¼: %AGENT_DIR% >> "%LOG_FILE%"
    
    REM ʹ��xcopy����
    xcopy "%AGENT_DIR%" "%BACKUP_DIR%\agent\" /E /I /H /Y /Q >nul 2>&1
    if %errorLevel% equ 0 (
        echo [�ɹ�] �������
        echo [%date% %time%] ������� >> "%LOG_FILE%"
    ) else (
        echo [����] ���ݿ��ܲ�����
        echo [%date% %time%] ����: ���ݿ��ܲ����� >> "%LOG_FILE%"
    )
)

REM 3. ��鲢����Ŀ¼�ṹ
echo [��Ϣ] ���Ŀ¼�ṹ...
echo [%date% %time%] ���Ŀ¼�ṹ >> "%LOG_FILE%"

set "REQUIRED_DIRS=(
    packages\raw\00_runtime
    packages\raw\01_agent
    packages\raw\02_office
    packages\raw\03_tools
    packages\raw\04_knowledge
    packages\raw\05_optional
    config\aionui
    config\hermes
    config\opencode
    logs
    scripts\integration
    scripts\install
    scripts\uninstall
    scripts\check
    scripts\repair
    scripts\utils
    templates
    examples
)"

for %%d in (%REQUIRED_DIRS%) do (
    if not exist "%INSTALL_DIR%\%%d" (
        echo [��Ϣ] ����Ŀ¼: %%d
        echo [%date% %time%] ����Ŀ¼: %%d >> "%LOG_FILE%"
        mkdir "%INSTALL_DIR%\%%d" >nul 2>&1
    )
)

REM 4. ��������ļ�
echo [��Ϣ] ��������ļ�...
echo [%date% %time%] ��������ļ� >> "%LOG_FILE%"

set "CONFIG_FILES=(
    config\aionui\aionui.json
    config\hermes\hermes.json
    config\opencode\opencode.json
    config\everything\everything.json
    config\tesseract\tesseract.json
    config\obsidian\obsidian.json
    config\wps-addon\wps_addon.json
)"

for %%f in (%CONFIG_FILES%) do (
    if not exist "%INSTALL_DIR%\%%f" (
        echo [����] �����ļ�������: %%f
        echo [%date% %time%] ����: �����ļ�������: %%f >> "%LOG_FILE%"
    ) else (
        echo [ͨ��] �����ļ�����: %%f
        echo [%date% %time%] [ͨ��] �����ļ�����: %%f >> "%LOG_FILE%"
    )
)

REM 5. �����־Ŀ¼
echo [��Ϣ] �����־Ŀ¼...
echo [%date% %time%] �����־Ŀ¼ >> "%LOG_FILE%"

set "LOG_DIRS=(
    runtime\logs\aionui
    runtime\logs\hermes
    runtime\logs\opencode
    runtime\logs\everything
    runtime\logs\tesseract
    runtime\logs\obsidian
    runtime\logs\wps_addon
)"

for %%d in (%LOG_DIRS%) do (
    if not exist "%INSTALL_DIR%\%%d" (
        echo [��Ϣ] ������־Ŀ¼: %%d
        echo [%date% %time%] ������־Ŀ¼: %%d >> "%LOG_FILE%"
        mkdir "%INSTALL_DIR%\%%d" >nul 2>&1
    )
)

REM 6. ��鼯�ɽű�
echo [��Ϣ] ��鼯�ɽű�...
echo [%date% %time%] ��鼯�ɽű� >> "%LOG_FILE%"

set "INTEGRATION_SCRIPTS=(
    call_everything_search.bat
    call_tesseract_ocr.bat
    call_wps_summary.bat
    call_obsidian_note.bat
    call_xmind_outline.bat
    call_git_status.bat
    open_project_folder.bat
    collect_context.bat
)"

for %%s in (%INTEGRATION_SCRIPTS%) do (
    if not exist "%INSTALL_DIR%\scripts\integration\%%s" (
        echo [����] ���ɽű�������: %%s
        echo [%date% %time%] ����: ���ɽű�������: %%s >> "%LOG_FILE%"
    ) else (
        echo [ͨ��] ���ɽű�����: %%s
        echo [%date% %time%] [ͨ��] ���ɽű�����: %%s >> "%LOG_FILE%"
    )
)

REM 7. ��鹤��ע���
echo [��Ϣ] ��鹤��ע���...
echo [%date% %time%] ��鹤��ע��� >> "%LOG_FILE%"

set "TOOL_REGISTRY=%INSTALL_DIR%\scripts\integration\tool_registry.json"
if not exist "%TOOL_REGISTRY%" (
    echo [����] ����ע���������: %TOOL_REGISTRY%
    echo [%date% %time%] ����: ����ע��������� >> "%LOG_FILE%"
) else (
    echo [ͨ��] ����ע�������: %TOOL_REGISTRY%
    echo [%date% %time%] [ͨ��] ����ע������� >> "%LOG_FILE%"
)

echo [%date% %time%] Agent����޸���� >> "%LOG_FILE%"
echo [��Ϣ] �޸���ɣ���鿴��־�ļ�: %LOG_FILE%

exit /b 0

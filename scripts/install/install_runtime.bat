@echo off
REM ���л�����װ�ű�
REM ����: ��װ.NET Framework��VC++ Runtime��WebView2 Runtime
REM Ŀ�껷��: Windows 7 SP1 64λ
REM ����ʱ��: 2026-06-17

setlocal enabledelayedexpansion

REM ������־�ļ�
set "LOG_FILE=runtime\logs\install_runtime_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
if not exist "runtime\logs" mkdir "runtime\logs"

echo [%date% %time%] ��ʼ��װ���л��� >> "%LOG_FILE%"

REM ������ԱȨ��
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [����] ��Ҫ����ԱȨ�����д˽ű�
    echo [����] ���Ҽ����"�Թ���Ա��������"
    echo [%date% %time%] ����: ȱ�ٹ���ԱȨ�� >> "%LOG_FILE%"
    exit /b 1
)

echo [��Ϣ] ��鵽����ԱȨ�� >> "%LOG_FILE%"

REM ������װĿ¼
set "INSTALL_DIR=%~dp0..\.."
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%INSTALL_DIR%\logs" mkdir "%INSTALL_DIR%\logs"

REM 1. ��װ .NET Framework 4.8
echo [��Ϣ] ��װ .NET Framework 4.8...
echo [%date% %time%] ��װ .NET Framework 4.8 >> "%LOG_FILE%"

set "DOTNET_INSTALLER=packages\raw\ndp48-x86-x64-allos-enu.exe"
if exist "%DOTNET_INSTALLER%" (
    echo [��Ϣ] �ҵ���װ����: %DOTNET_INSTALLER%
    echo [%date% %time%] �ҵ���װ����: %DOTNET_INSTALLER% >> "%LOG_FILE%"
    
    REM ��Ĭ��װ
    "%DOTNET_INSTALLER%" /quiet /norestart /log "%INSTALL_DIR%\runtime\logs\dotnet_install.log"
    
    if %errorLevel% equ 0 (
        echo [�ɹ�] .NET Framework 4.8 ��װ���
        echo [%date% %time%] .NET Framework 4.8 ��װ��� >> "%LOG_FILE%"
    ) else (
        echo [����] .NET Framework 4.8 ��װʧ�ܣ�������: %errorLevel%
        echo [%date% %time%] .NET Framework 4.8 ��װʧ�ܣ�������: %errorLevel% >> "%LOG_FILE%"
    )
) else (
    echo [����] δ�ҵ� .NET Framework 4.8 ��װ����
    echo [��Ϣ] ������µ�ַ����:
    echo https://go.microsoft.com/fwlink/?LinkId=2085488
    echo [%date% %time%] ����: δ�ҵ� .NET Framework 4.8 ��װ���� >> "%LOG_FILE%"
)

REM 2. ��װ VC++ Runtime
echo [��Ϣ] ��װ VC++ Runtime...
echo [%date% %time%] ��װ VC++ Runtime >> "%LOG_FILE%"

set "VC_INSTALLER=packages\raw\vc_redist.x64.exe"
if exist "%VC_INSTALLER%" (
    echo [��Ϣ] �ҵ���װ����: %VC_INSTALLER%
    echo [%date% %time%] �ҵ���װ����: %VC_INSTALLER% >> "%LOG_FILE%"
    
    REM ��Ĭ��װ
    "%VC_INSTALLER%" /install /quiet /norestart
    
    if %errorLevel% equ 0 (
        echo [�ɹ�] VC++ Runtime ��װ���
        echo [%date% %time%] VC++ Runtime ��װ��� >> "%LOG_FILE%"
    ) else (
        echo [����] VC++ Runtime ��װʧ�ܣ�������: %errorLevel%
        echo [%date% %time%] VC++ Runtime ��װʧ�ܣ�������: %errorLevel% >> "%LOG_FILE%"
    )
) else (
    echo [����] δ�ҵ� VC++ Runtime ��װ����
    echo [��Ϣ] ������µ�ַ����:
    echo https://aka.ms/vs/17/release/vc_redist.x64.exe
    echo [%date% %time%] ����: δ�ҵ� VC++ Runtime ��װ���� >> "%LOG_FILE%"
)

REM 3. ��װ WebView2 Runtime
echo [��Ϣ] ��װ WebView2 Runtime...
echo [%date% %time%] ��װ WebView2 Runtime >> "%LOG_FILE%"

set "WEBVIEW2_INSTALLER=packages\raw\MicrosoftEdgeWebView2RuntimeInstallerX64.exe"
if exist "%WEBVIEW2_INSTALLER%" (
    echo [��Ϣ] �ҵ���װ����: %WEBVIEW2_INSTALLER%
    echo [%date% %time%] �ҵ���װ����: %WEBVIEW2_INSTALLER% >> "%LOG_FILE%"
    
    REM ��Ĭ��װ
    "%WEBVIEW2_INSTALLER%" /silent /install
    
    if %errorLevel% equ 0 (
        echo [�ɹ�] WebView2 Runtime ��װ���
        echo [%date% %time%] WebView2 Runtime ��װ��� >> "%LOG_FILE%"
    ) else (
        echo [����] WebView2 Runtime ��װʧ�ܣ�������: %errorLevel%
        echo [%date% %time%] WebView2 Runtime ��װʧ�ܣ�������: %errorLevel% >> "%LOG_FILE%"
    )
) else (
    echo [����] δ�ҵ� WebView2 Runtime ��װ����
    echo [��Ϣ] ������µ�ַ����:
    echo https://go.microsoft.com/fwlink/p/?LinkId=2124703
    echo [%date% %time%] ����: δ�ҵ� WebView2 Runtime ��װ���� >> "%LOG_FILE%"
)

echo [%date% %time%] ���л�����װ��� >> "%LOG_FILE%"
echo [��Ϣ] ��װ��ɣ���鿴��־�ļ�: %LOG_FILE%

exit /b 0

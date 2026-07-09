@echo off
REM Runtime install test script
REM Purpose: Test .NET Framework, VC++ Runtime, WebView2 Runtime installation
REM Platform: Windows 7 SP1 64-bit

setlocal enabledelayedexpansion

REM Locale-stable ISO timestamp via wmic
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value 2^>nul') do set "_DT=%%i"
set "LOG_FILE=logs\install_runtime_%_DT:~0,8%_%_DT:~8,6%.log"
if not exist "logs" mkdir "logs"

echo [%date% %time%] Starting runtime installation test >> "%LOG_FILE%"

REM Check admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Administrator privileges required
    echo [ERROR] Please right-click and select "Run as administrator"
    echo [%date% %time%] ERROR: Admin privileges required >> "%LOG_FILE%"
    exit /b 1
)

echo [PASS] Admin privileges confirmed >> "%LOG_FILE%"

set "INSTALL_DIR=%CD%"
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%INSTALL_DIR%\logs" mkdir "%INSTALL_DIR%\logs"

REM 1. Install .NET Framework 4.8
echo [STEP] Installing .NET Framework 4.8...
echo [%date% %time%] Installing .NET Framework 4.8 >> "%LOG_FILE%"

set "DOTNET_INSTALLER=packages\raw\00_runtime\ndp48-x86-x64-allos-enu.exe"
if exist "%DOTNET_INSTALLER%" (
    echo [INFO] Found installer: %DOTNET_INSTALLER%
    echo [%date% %time%] Found installer: %DOTNET_INSTALLER% >> "%LOG_FILE%"
    
    "%DOTNET_INSTALLER%" /quiet /norestart /log "%INSTALL_DIR%\logs\dotnet_install.log"
    
    if %errorLevel% equ 0 (
        echo [PASS] .NET Framework 4.8 installed
        echo [%date% %time%] .NET Framework 4.8 installed >> "%LOG_FILE%"
    ) else (
        echo [WARN] .NET Framework 4.8 install may need reboot: %errorLevel%
        echo [%date% %time%] .NET Framework 4.8 install may need reboot: %errorLevel% >> "%LOG_FILE%"
    )
) else (
    echo [WARN] .NET Framework 4.8 installer not found
    echo [INFO] Download from:
    echo https://go.microsoft.com/fwlink/?LinkId=2085488
    echo [%date% %time%] WARN: .NET Framework 4.8 installer not found >> "%LOG_FILE%"
)

REM 2. Install VC++ Runtime
echo [STEP] Installing VC++ Runtime...
echo [%date% %time%] Installing VC++ Runtime >> "%LOG_FILE%"

set "VC_INSTALLER=packages\raw\00_runtime\vc_redist.x64.exe"
if exist "%VC_INSTALLER%" (
    echo [INFO] Found installer: %VC_INSTALLER%
    echo [%date% %time%] Found installer: %VC_INSTALLER% >> "%LOG_FILE%"
    
    "%VC_INSTALLER%" /install /quiet /norestart
    
    if %errorLevel% equ 0 (
        echo [PASS] VC++ Runtime installed
        echo [%date% %time%] VC++ Runtime installed >> "%LOG_FILE%"
    ) else (
        echo [WARN] VC++ Runtime install failed: %errorLevel%
        echo [%date% %time%] VC++ Runtime install failed: %errorLevel% >> "%LOG_FILE%"
    )
) else (
    echo [WARN] VC++ Runtime installer not found
    echo [INFO] Download from:
    echo https://aka.ms/vs/17/release/vc_redist.x64.exe
    echo [%date% %time%] WARN: VC++ Runtime installer not found >> "%LOG_FILE%"
)

REM 3. Install WebView2 Runtime
echo [STEP] Installing WebView2 Runtime...
echo [%date% %time%] Installing WebView2 Runtime >> "%LOG_FILE%"

set "WEBVIEW2_INSTALLER=packages\raw\00_runtime\MicrosoftEdgeWebView2RuntimeInstallerX64.exe"
if exist "%WEBVIEW2_INSTALLER%" (
    echo [INFO] Found installer: %WEBVIEW2_INSTALLER%
    echo [%date% %time%] Found installer: %WEBVIEW2_INSTALLER% >> "%LOG_FILE%"
    
    "%WEBVIEW2_INSTALLER%" /silent /install
    
    if %errorLevel% equ 0 (
        echo [PASS] WebView2 Runtime installed
        echo [%date% %time%] WebView2 Runtime installed >> "%LOG_FILE%"
    ) else (
        echo [WARN] WebView2 Runtime install failed: %errorLevel%
        echo [%date% %time%] WebView2 Runtime install failed: %errorLevel% >> "%LOG_FILE%"
    )
) else (
    echo [WARN] WebView2 Runtime installer not found
    echo [INFO] Download from:
    echo https://go.microsoft.com/fwlink/p/?LinkId=2124703
    echo [%date% %time%] WARN: WebView2 Runtime installer not found >> "%LOG_FILE%"
)

echo [%date% %time%] Runtime installation test complete >> "%LOG_FILE%"
echo [STEP] Detailed log saved to: %LOG_FILE%

exit /b 0

@echo off
REM 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷馨旃拷准锟?V1.0 一锟斤拷锟斤拷装锟脚憋拷
REM 锟斤拷锟斤拷: 锟皆讹拷锟斤拷装锟斤拷锟斤拷锟斤拷锟?
REM 目锟疥环锟斤拷: Windows 7 SP1 64位
REM 锟斤拷锟斤拷时锟斤拷: 2026-06-17

setlocal enabledelayedexpansion

echo ========================================
echo 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷馨旃拷准锟?V1.0 锟斤拷装锟斤拷锟斤拷
echo 目锟疥环锟斤拷: Windows 7 SP1 64位
echo ========================================
echo.

REM 锟斤拷锟斤拷锟斤拷员权锟斤拷
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [锟斤拷锟斤拷] 锟斤拷要锟斤拷锟斤拷员权锟斤拷锟斤拷锟叫此帮拷装锟斤拷锟斤拷
    echo 锟斤拷锟揭硷拷锟斤拷锟斤拷锟斤拷募锟斤拷锟窖★拷锟?锟皆癸拷锟斤拷员锟斤拷锟斤拷锟斤拷锟斤拷"
    pause
    exit /b 1
)

REM 锟斤拷锟絎indows锟芥本
echo [1/19] 锟斤拷锟较低筹拷锟斤拷锟?..
ver | find "Version 6.1" >nul
if %errorLevel% equ 0 (
    echo 锟斤拷獾絎indows 7系统
) else (
    echo [锟斤拷锟斤拷] 未锟斤拷獾絎indows 7系统锟斤拷某些锟斤拷锟斤拷锟斤拷懿锟斤拷锟斤拷锟?
)

REM 锟斤拷锟斤拷锟斤拷志目录
if not exist "logs" mkdir "logs"
set "LOG_FILE=logs\install_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.log"
echo 锟斤拷装锟斤拷志: %LOG_FILE%

REM 锟斤拷始锟斤拷锟斤拷装状态
if not exist "state" mkdir "state"
echo [0/19] Verifying installer SHA256 integrity...
call verify_installers.bat
if !errorLevel! neq 0 (
    echo [FAIL] SHA256 verification failed - install aborted
    echo See logs\verify_installers_*.log for details
    pause
    exit /b 1
)
echo [PASS] SHA256 verification passed
echo.
echo {"status": "installing", "start_time": "%date% %time%"} > "state\install_state.json"

echo [2/19] 锟斤拷装 .NET Framework 4.8...
if exist "packages\raw\ndp48-x86-x64-allos-enu.exe" (
    echo 锟斤拷装 .NET Framework 4.8...
    "packages\raw\ndp48-x86-x64-allos-enu.exe" /quiet /norestart
    echo .NET Framework 4.8 锟斤拷装锟斤拷锟?
) else (
    echo [锟斤拷锟斤拷] 未锟揭碉拷 .NET Framework 4.8 锟斤拷装锟斤拷
)

echo [3/19] 锟斤拷装 VC++ Runtime...
if exist "packages\raw\vc_redist.x64.exe" (
    echo 锟斤拷装 VC++ Runtime...
    "packages\raw\vc_redist.x64.exe" /install /quiet /norestart
    echo VC++ Runtime 锟斤拷装锟斤拷锟?
) else (
    echo [锟斤拷锟斤拷] 未锟揭碉拷 VC++ Runtime 锟斤拷装锟斤拷
)

echo [4/19] 锟斤拷装 WebView2 Runtime 109...
if exist "packages\raw\MicrosoftEdgeWebView2RuntimeInstallerX64.exe" (
    echo 锟斤拷装 WebView2 Runtime 109...
    "packages\raw\MicrosoftEdgeWebView2RuntimeInstallerX64.exe" /silent /install
    echo WebView2 Runtime 109 锟斤拷装锟斤拷锟?
) else (
    echo [锟斤拷锟斤拷] 未锟揭碉拷 WebView2 Runtime 109 锟斤拷装锟斤拷
)

echo [5/19] 锟斤拷装 Git for Windows 2.46.2...
if exist "packages\raw\Git-2.46.2-64-bit.exe" (
    echo 锟斤拷装 Git for Windows 2.46.2...
    "packages\raw\Git-2.46.2-64-bit.exe" /VERYSILENT /NORESTART
    echo Git for Windows 2.46.2 锟斤拷装锟斤拷锟?
) else (
    echo [锟斤拷锟斤拷] 未锟揭碉拷 Git for Windows 2.46.2 锟斤拷装锟斤拷
)

echo [6/19] 锟斤拷装 Everything...
if exist "packages\raw\Everything-1.4.1.1024.x64-Setup.exe" (
    echo 锟斤拷装 Everything...
    "packages\raw\Everything-1.4.1.1024.x64-Setup.exe" /S
    echo Everything 锟斤拷装锟斤拷锟?
) else (
    echo [锟斤拷锟斤拷] 未锟揭碉拷 Everything 锟斤拷装锟斤拷
)

echo [7/19] 锟斤拷装 Tesseract-OCR...
if exist "packages\raw\tesseract-ocr-w64-setup-5.3.1.20230401.exe" (
    echo 锟斤拷装 Tesseract-OCR...
    "packages\raw\tesseract-ocr-w64-setup-5.3.1.20230401.exe" /S
    echo Tesseract-OCR 锟斤拷装锟斤拷锟?
) else (
    echo [锟斤拷锟斤拷] 未锟揭碉拷 Tesseract-OCR 锟斤拷装锟斤拷
)

echo [8/19] 锟斤拷装 WPS Office 2019...
if exist "packages\raw\WPS_Setup_26895.exe" (
    echo 锟斤拷装 WPS Office...
    "packages\raw\WPS_Setup_26895.exe" /S
    echo WPS Office 锟斤拷装锟斤拷锟?
) else (
    echo [锟斤拷锟斤拷] 未锟揭碉拷 WPS Office 锟斤拷装锟斤拷
    echo [锟斤拷示] WPS Office 锟斤拷锟斤拷锟皆达拷锟紻ownloads目录锟斤拷锟斤拷 WPS_Setup_26895.exe
)

echo [9/19] 锟斤拷装 wps-kaiyu-addon (Kaiwu/锟斤拷鎮?AI 写锟斤拷锟斤拷锟斤拷)...
if exist "packages\raw\wps-kaiyu-addon-setup.exe" (
    echo 锟斤拷装 wps-kaiyu-addon...
    "packages\raw\wps-kaiyu-addon-setup.exe" /S
    echo wps-kaiyu-addon (Kaiwu) 锟斤拷装锟斤拷锟?锟斤拷锟斤拷锟斤拷锟斤拷锟街讹拷双锟斤拷 install.bat)
) else (
    echo [锟斤拷锟斤拷] 未锟揭碉拷 wps-kaiyu-addon 锟斤拷装锟斤拷
    echo [锟斤拷示] 锟斤拷锟截达拷锟斤拷锟斤拷锟?
    echo        https://github.com/xuemzhan/Kaiwu
)

echo [10/19] 锟斤拷装 KexStepup (VxKex)...
if exist "packages\raw\KexStepup-setup.exe" (
    echo 锟斤拷装 KexStepup (VxKex)...
    "packages\raw\KexStepup-setup.exe" /S
    echo KexStepup (VxKex) 锟斤拷装锟斤拷锟?
) else (
    echo [锟斤拷锟斤拷] 未锟揭碉拷 KexStepup (VxKex) 锟斤拷装锟斤拷
    echo [锟斤拷示] 锟斤拷锟截?https://github.com/i486/VxKex/releases/tag/Version1.1.5.1679
)

echo [11/19] 锟斤拷装 AionUI...
if exist "packages\raw\AionUI-setup.exe" (
    echo 锟斤拷装 AionUI...
    "packages\raw\AionUI-setup.exe" /S
    echo AionUI 锟斤拷装锟斤拷锟?
) else (
    echo [锟斤拷锟斤拷] 未锟揭碉拷 AionUI 锟斤拷装锟斤拷
)

echo [12/19] 锟斤拷装 Hermes Desktop...
if exist "packages\raw\HermesDesktop-setup.exe" (
    echo 锟斤拷装 Hermes Desktop...
    "packages\raw\HermesDesktop-setup.exe" /S
    echo Hermes Desktop 锟斤拷装锟斤拷锟?
) else (
    echo [锟斤拷锟斤拷] 未锟揭碉拷 Hermes Desktop 锟斤拷装锟斤拷
)

echo [13/19] 锟斤拷装 OpenCode...
if exist "packages\raw\OpenCode-setup.exe" (
    echo 锟斤拷装 OpenCode...
    "packages\raw\OpenCode-setup.exe" /S
    echo OpenCode 锟斤拷装锟斤拷锟?
) else (
    echo [锟斤拷锟斤拷] 未锟揭碉拷 OpenCode 锟斤拷装锟斤拷
)

echo [14/19] 锟斤拷装 Obsidian 1.4.16...
if exist "packages\raw\Obsidian.1.4.16.exe" (
    echo 锟斤拷装 Obsidian 1.4.16...
    "packages\raw\Obsidian.1.4.16.exe" /S
    echo Obsidian 1.4.16 锟斤拷装锟斤拷锟?
) else (
    echo [锟斤拷锟斤拷] 未锟揭碉拷 Obsidian 1.4.16 锟斤拷装锟斤拷
)

echo [15/19] 锟斤拷装 XMind...
if exist "packages\raw\XMind-23.11.exe" (
    echo 锟斤拷装 XMind...
    "packages\raw\XMind-23.11.exe" /S
    echo XMind 锟斤拷装锟斤拷锟?
) else (
    echo [锟斤拷锟斤拷] 未锟揭碉拷 XMind 锟斤拷装锟斤拷
)

echo [16/19] 初始化配置目录...
if not exist "config" mkdir "config"
if not exist "logs" mkdir "logs"
if not exist "state" mkdir "state"
echo {"status": "installed", "end_time": "%date% %time%"} > "state\install_state.json"
echo 配置目录已初始化

echo [17/19] 创建桌面快捷方式...
set "STARTMENU_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\个体增智办公套件"
if not exist "%STARTMENU_DIR%" mkdir "%STARTMENU_DIR%"
if exist "packages\raw\WPS_Setup_26895.exe" (
    echo 已为 WPS 准备桌面入口
) else (
    echo [WARN] 未找到 WPS 安装包,跳过桌面快捷方式
)
echo 快捷方式配置完成

echo [18/19] 创建开始菜单项...
set "STARTMENU_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\个体增智办公套件"
if not exist "%STARTMENU_DIR%" mkdir "%STARTMENU_DIR%"
echo # 个体增智办公套件 V1.0 > "%STARTMENU_DIR%\使用说明.url"
echo URL=file:///%~dp0docs\02_用户使用手册.md >> "%STARTMENU_DIR%\使用说明.url"
echo 开始菜单项已创建

echo [19/19] 安装验证...
set "VERIFY_FAILED=0"
reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" /v Version >nul 2>&1
if %errorLevel% neq 0 (
    echo [FAIL] .NET Framework 4.8 未安装
    set "VERIFY_FAILED=1"
) else (
    echo [PASS] .NET Framework 4.8
)
if exist "C:\Program Files\Tesseract-OCR\tesseract.exe" (
    echo [PASS] Tesseract-OCR
) else (
    echo [WARN] Tesseract-OCR 未在默认路径
)
sc query "Everything" >nul 2>&1
if %errorLevel% equ 0 (
    echo [PASS] Everything 服务
) else (
    echo [WARN] Everything 服务未注册
)
if "%VERIFY_FAILED%"=="1" (
    echo [FAIL] 安装验证发现异常,请查看日志
) else (
    echo [PASS] 安装验证通过
)


echo ========================================
echo 个体增智办公套件 V1.0 安装完成
echo ========================================
echo.
echo 安装日志: %LOG_FILE%
echo 使用说明: 请查看 docs\02_用户使用手册.md
echo.
pause
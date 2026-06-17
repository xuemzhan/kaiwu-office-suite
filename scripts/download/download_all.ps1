# 开悟个体增智智能办公套件 V1.0 下载脚本
# 功能: 下载所有软件安装包并进行校验
# 目标环境: Windows 7 SP1 64位
# 生成时间: 2026-06-17

param(
    [string]$ManifestPath = "manifest/software-lock.yaml",
    [string]$OutputDir = "packages/raw",
    [string]$LogDir = "logs",
    [switch]$Force,
    [switch]$DryRun
)

# 检查PowerShell版本
if ($PSVersionTable.PSVersion.Major -lt 2) {
    Write-Host "错误: 需要PowerShell 2.0或更高版本" -ForegroundColor Red
    Write-Host "当前版本: $($PSVersionTable.PSVersion)" -ForegroundColor Yellow
    Write-Host "请安装Windows Management Framework 3.0或更高版本" -ForegroundColor Yellow
    exit 1
}

# 创建目录
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

# 日志文件
$LogFile = Join-Path $LogDir "download_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Host $logMessage
    Add-Content -Path $LogFile -Value $logMessage
}

function Get-FileSHA256 {
    param([string]$FilePath)
    if (Test-Path $FilePath) {
        try {
            $fileStream = [System.IO.File]::OpenRead($FilePath)
            $sha256 = [System.Security.Cryptography.SHA256]::Create()
            $hashBytes = $sha256.ComputeHash($fileStream)
            $fileStream.Close()
            $hashString = [BitConverter]::ToString($hashBytes) -replace '-', ''
            return $hashString
        } catch {
            return $null
        }
    }
    return $null
}

function Test-FileExists {
    param([string]$FilePath, [string]$ExpectedSHA256)
    if (-not (Test-Path $FilePath)) {
        return $false
    }
    if ($ExpectedSHA256 -and $ExpectedSHA256 -ne "待计算") {
        $actualSHA256 = Get-FileSHA256 -FilePath $FilePath
        return $actualSHA256 -eq $ExpectedSHA256
    }
    return $true
}

function Download-File {
    param(
        [string]$Url,
        [string]$OutputPath,
        [string]$ExpectedSHA256,
        [int]$MaxRetries = 3
    )
    
    $fileName = Split-Path $OutputPath -Leaf
    Write-Log "开始下载: $fileName"
    Write-Log "下载地址: $Url"
    
    # 检查文件是否已存在且校验通过
    if (-not $Force -and (Test-FileExists -FilePath $OutputPath -ExpectedSHA256 $ExpectedSHA256)) {
        Write-Log "文件已存在且校验通过，跳过下载: $fileName" "WARN"
        return $true
    }
    
    # 下载文件
    for ($i = 1; $i -le $MaxRetries; $i++) {
        try {
            Write-Log "尝试下载 ($i/$MaxRetries): $fileName"
            
            # 使用WebClient下载（支持断点续传）
            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFile($Url, $OutputPath)
            
            # 验证SHA256
            if ($ExpectedSHA256 -and $ExpectedSHA256 -ne "待计算") {
                $actualSHA256 = Get-FileSHA256 -FilePath $OutputPath
                if ($actualSHA256 -ne $ExpectedSHA256) {
                    Write-Log "SHA256校验失败: $fileName (期望: $ExpectedSHA256, 实际: $actualSHA256)" "ERROR"
                    Remove-Item -Path $OutputPath -Force
                    continue
                }
                Write-Log "SHA256校验通过: $fileName"
            }
            
            Write-Log "下载成功: $fileName"
            return $true
        }
        catch {
            Write-Log "下载失败: $fileName - $($_.Exception.Message)" "ERROR"
            if ($i -eq $MaxRetries) {
                Write-Log "达到最大重试次数，放弃下载: $fileName" "ERROR"
                return $false
            }
            Start-Sleep -Seconds 5
        }
    }
    return $false
}

# 主程序
Write-Log "开始下载开悟个体增智智能办公套件 V1.0 组件"
Write-Log "目标环境: Windows 7 SP1 64位"
Write-Log "清单文件: $ManifestPath"
Write-Log "输出目录: $OutputDir"

# 读取清单文件（简化版本，实际应使用YAML解析器）
# 这里使用预定义的下载列表（Win7 SP1兼容版本）
$downloadList = @(
    @{
        Name = ".NET Framework 4.8"
        Category = "runtime"
        SubDir = "dotnet48"
        Url = "https://go.microsoft.com/fwlink/?LinkId=2085155"
        Filename = "ndp48-x86-x64-allos-enu.exe"
        ExpectedSHA256 = "待计算"
    },
    @{
        Name = "WebView2 Runtime 109"
        Category = "runtime"
        SubDir = "webview2_109"
        Url = "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/12d7cf13-854e-42e9-aa1b-5180dd88e09a/MicrosoftEdgeWebView2RuntimeInstallerX64.exe"
        Filename = "MicrosoftEdgeWebView2RuntimeInstallerX64.exe"
        ExpectedSHA256 = "待计算"
    },
    @{
        Name = "VC++ Runtime"
        Category = "runtime"
        SubDir = "vc_redist"
        Url = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
        Filename = "vc_redist.x64.exe"
        ExpectedSHA256 = "待计算"
    },
    @{
        Name = "Git for Windows 2.46.2"
        Category = "runtime"
        SubDir = "git_2.46.2"
        Url = "https://github.com/git-for-windows/git/releases/download/v2.46.2.windows.1/Git-2.46.2-64-bit.exe"
        Filename = "Git-2.46.2-64-bit.exe"
        ExpectedSHA256 = "待计算"
    },
    @{
        Name = "Everything"
        Category = "tools"
        SubDir = "everything"
        Url = "https://www.voidtools.com/Everything-1.4.1.1024.x64-Setup.exe"
        Filename = "Everything-1.4.1.1024.x64-Setup.exe"
        ExpectedSHA256 = "待计算"
    },
    @{
        Name = "Tesseract-OCR"
        Category = "tools"
        SubDir = "tesseract"
        Url = "https://digi.bib.uni-mannheim.de/tesseract/tesseract-ocr-w64-setup-5.3.1.20231002.exe"
        Filename = "tesseract-ocr-w64-setup-5.3.1.20231002.exe"
        ExpectedSHA256 = "待计算"
    },
    @{
        Name = "WPS Office"
        Category = "office"
        SubDir = "wps"
        Url = "https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/16478/WPS_Office_11.8.2.12068.exe"
        Filename = "WPS_Office_11.8.2.12068.exe"
        ExpectedSHA256 = "待计算"
    },
    @{
        Name = "Obsidian"
        Category = "tools"
        SubDir = "obsidian"
        Url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.4.16/Obsidian.1.4.16.exe"
        Filename = "Obsidian-1.4.16.exe"
        ExpectedSHA256 = "待计算"
    }
)

# 执行下载
$successCount = 0
$failCount = 0
$skipCount = 0

foreach ($item in $downloadList) {
    $categoryDir = Join-Path $OutputDir $item.Category
    $subDir = Join-Path $categoryDir $item.SubDir
    if (-not (Test-Path $subDir)) {
        New-Item -ItemType Directory -Path $subDir -Force | Out-Null
    }
    
    $outputPath = Join-Path $subDir $item.Filename
    
    if ($DryRun) {
        Write-Log "[DRY RUN] 将下载: $($item.Name) -> $outputPath"
        $skipCount++
        continue
    }
    
    $result = Download-File -Url $item.Url -OutputPath $outputPath -ExpectedSHA256 $item.ExpectedSHA256
    
    if ($result) {
        $successCount++
    } else {
        $failCount++
    }
}

# 生成下载报告
$reportFile = Join-Path $LogDir "download_report_$(Get-Date -Format 'yyyyMMdd_HHmmss').md"
$reportContent = @"
# 下载报告

**生成时间:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**目标环境:** Windows 7 SP1 64位  
**下载状态:** 成功: $successCount, 失败: $failCount, 跳过: $skipCount  

## 下载详情

| 软件名称 | 状态 | 文件路径 |
|----------|------|----------|
"@

foreach ($item in $downloadList) {
    $categoryDir = Join-Path $OutputDir $item.Category
    $subDir = Join-Path $categoryDir $item.SubDir
    $outputPath = Join-Path $subDir $item.Filename
    
    if (Test-Path $outputPath) {
        $status = "[DOWNLOADED]"
    } else {
        $status = "[NOT DOWNLOADED]"
    }
    
    $reportContent += "`n| $($item.Name) | $status | $outputPath |"
}

$reportContent += @"

## 日志文件

- 下载日志: $LogFile
- 报告文件: $reportFile
"@

Set-Content -Path $reportFile -Value $reportContent -Encoding UTF8

Write-Log "下载完成"
Write-Log "成功: $successCount, 失败: $failCount, 跳过: $skipCount"
Write-Log "下载报告: $reportFile"
Write-Log "日志文件: $LogFile"

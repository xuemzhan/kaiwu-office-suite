# 开悟个体增智智能办公套件 V1.4.1 单文件下载脚本
# 功能: 下载指定的单个软件安装包
# 目标环境: Windows 7 SP1 64位
# 生成时间: 2026-06-17

param(
    [Parameter(Mandatory=$true)]
    [string]$Name,
    
    [Parameter(Mandatory=$true)]
    [string]$Url,
    
    [string]$OutputDir = "packages/raw",
    [string]$Filename = "",
    [string]$ExpectedSHA256 = "",
    [switch]$Force
)

# 创建输出目录
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# 日志文件
$LogFile = "logs/download_one_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

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
        $hash = Get-FileHash -Path $FilePath -Algorithm SHA256
        return $hash.Hash
    }
    return $null
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
    if (-not $Force -and (Test-Path $OutputPath)) {
        if ($ExpectedSHA256 -and $ExpectedSHA256 -ne "待计算") {
            $actualSHA256 = Get-FileSHA256 -FilePath $OutputPath
            if ($actualSHA256 -eq $ExpectedSHA256) {
                Write-Log "文件已存在且校验通过，跳过下载: $fileName" "WARN"
                return $true
            }
        } else {
            Write-Log "文件已存在，跳过下载: $fileName" "WARN"
            return $true
        }
    }
    
    # 下载文件
    for ($i = 1; $i -le $MaxRetries; $i++) {
        try {
            Write-Log "尝试下载 ($i/$MaxRetries): $fileName"
            
            # 使用WebClient下载
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
Write-Log "开始下载: $Name"
Write-Log "目标环境: Windows 7 SP1 64位"

# 确定文件名
if (-not $Filename) {
    # 从URL提取文件名
    $uri = [System.Uri]$Url
    $Filename = Split-Path $uri.LocalPath -Leaf
}

# 确定输出路径
$outputPath = Join-Path $OutputDir $Filename

# 执行下载
$result = Download-File -Url $Url -OutputPath $outputPath -ExpectedSHA256 $ExpectedSHA256

if ($result) {
    Write-Log "下载完成: $Name"
    Write-Log "文件路径: $outputPath"
    
    # 输出文件信息
    $fileInfo = Get-Item $outputPath
    Write-Log "文件大小: $($fileInfo.Length) bytes"
    Write-Log "最后修改: $($fileInfo.LastWriteTime)"
} else {
    Write-Log "下载失败: $Name" "ERROR"
    exit 1
}

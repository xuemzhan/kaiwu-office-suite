# 开悟个体增智智能办公套件 V1.0 通用工具函数库
# 功能: 提供通用的工具函数
# 目标环境: Windows 7 SP1 64位
# 生成时间: 2026-06-17

function Write-Log {
    param(
        [string]$Message,
        [string]$LogFile,
        [ValidateSet("INFO", "WARNING", "ERROR", "SUCCESS")]
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    if (-not (Test-Path $LogFile)) {
        $logDir = Split-Path $LogFile -Parent
        if (-not (Test-Path $logDir)) {
            New-Item -ItemType Directory -Path $logDir -Force | Out-Null
        }
    }
    
    Add-Content -Path $LogFile -Value $logMessage
    
    switch ($Level) {
        "INFO" { Write-Host $Message -ForegroundColor Cyan }
        "WARNING" { Write-Host $Message -ForegroundColor Yellow }
        "ERROR" { Write-Host $Message -ForegroundColor Red }
        "SUCCESS" { Write-Host $Message -ForegroundColor Green }
        default { Write-Host $Message }
    }
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-FileExists {
    param(
        [string]$FilePath,
        [string]$Description = ""
    )
    
    if (Test-Path $FilePath) {
        return $true
    } else {
        if ($Description) {
            Write-Host "$Description 不存在: $FilePath" -ForegroundColor Yellow
        }
        return $false
    }
}

function Get-FileSize {
    param(
        [string]$FilePath
    )
    
    if (Test-Path $FilePath) {
        $file = Get-Item $FilePath
        $size = $file.Length
        
        if ($size -gt 1GB) {
            return "{0:N2} GB" -f ($size / 1GB)
        } elseif ($size -gt 1MB) {
            return "{0:N2} MB" -f ($size / 1MB)
        } elseif ($size -gt 1KB) {
            return "{0:N2} KB" -f ($size / 1KB)
        } else {
            return "$size bytes"
        }
    } else {
        return "文件不存在"
    }
}

function Compare-FileHash {
    param(
        [string]$FilePath,
        [string]$ExpectedHash
    )
    
    if (Test-Path $FilePath) {
        $actualHash = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash
        return $actualHash -eq $ExpectedHash
    } else {
        return $false
    }
}

function Get-SystemInfo {
    $os = Get-WmiObject -Class Win32_OperatingSystem
    $processor = Get-WmiObject -Class Win32_Processor
    
    return @{
        OSVersion = $os.Caption
        OSServicePack = $os.ServicePackMajorVersion
        Architecture = $os.OSArchitecture
        ProcessorName = $processor.Name
        ProcessorCores = $processor.NumberOfCores
        TotalPhysicalMemory = "{0:N2} GB" -f ($os.TotalVisibleMemorySize / 1MB)
        FreePhysicalMemory = "{0:N2} GB" -f ($os.FreePhysicalMemory / 1MB)
        SystemDirectory = $os.SystemDirectory
        WindowsDirectory = $os.WindowsDirectory
    }
}

function Test-SoftwareInstalled {
    param(
        [string]$SoftwareName
    )
    
    $uninstallPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    
    foreach ($path in $uninstallPaths) {
        $software = Get-ItemProperty $path -ErrorAction SilentlyContinue | 
            Where-Object { $_.DisplayName -like "*$SoftwareName*" }
        
        if ($software) {
            return $true
        }
    }
    
    return $false
}

function New-SafeDirectory {
    param(
        [string]$Path
    )
    
    if (-not (Test-Path $Path)) {
        try {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
            return $true
        } catch {
            Write-Host "创建目录失败: $Path" -ForegroundColor Red
            return $false
        }
    }
    return $true
}

function Remove-SafeItem {
    param(
        [string]$Path,
        [switch]$Recurse
    )
    
    if (Test-Path $Path) {
        try {
            if ($Recurse) {
                Remove-Item -Path $Path -Recurse -Force
            } else {
                Remove-Item -Path $Path -Force
            }
            return $true
        } catch {
            Write-Host "删除失败: $Path" -ForegroundColor Red
            return $false
        }
    }
    return $true
}

function Copy-SafeItem {
    param(
        [string]$Source,
        [string]$Destination,
        [switch]$Recurse,
        [switch]$Force
    )
    
    if (Test-Path $Source) {
        try {
            $params = @{
                Path = $Source
                Destination = $Destination
                Force = $Force.IsPresent
            }
            
            if ($Recurse) {
                $params.Recurse = $true
            }
            
            Copy-Item @params
            return $true
        } catch {
            Write-Host "复制失败: $Source -> $Destination" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "源路径不存在: $Source" -ForegroundColor Yellow
        return $false
    }
}

function Export-JsonFile {
    param(
        [string]$Path,
        [object]$Data
    )
    
    try {
        # 检查PowerShell版本，使用兼容的方法
        if ($PSVersionTable.PSVersion.Major -ge 3) {
            $json = $Data | ConvertTo-Json -Depth 10
        } else {
            # PowerShell 2.0兼容：手动构建JSON
            $json = "{"
            foreach ($key in $Data.Keys) {
                $value = $Data[$key]
                if ($value -is [string]) {
                    $json += "`"$key`": `"$value`","
                } elseif ($value -is [int] -or $value -is [double]) {
                    $json += "`"$key`": $value,"
                } elseif ($value -is [bool]) {
                    $json += "`"$key`": $($value.ToString().ToLower()),"
                }
            }
            $json = $json.TrimEnd(',') + "}"
        }
        $json | Out-File -FilePath $Path -Encoding UTF8
        return $true
    } catch {
        Write-Host "导出JSON失败: $Path" -ForegroundColor Red
        return $false
    }
}

function Import-JsonFile {
    param(
        [string]$Path
    )
    
    if (Test-Path $Path) {
        try {
            # 检查PowerShell版本，使用兼容的方法
            if ($PSVersionTable.PSVersion.Major -ge 3) {
                $json = Get-Content -Path $Path -Raw
                return $json | ConvertFrom-Json
            } else {
                # PowerShell 2.0兼容：读取文件内容
                $content = Get-Content -Path $Path -Raw
                Write-Host "JSON文件内容（PowerShell 2.0不支持自动解析）:" -ForegroundColor Yellow
                return $content
            }
        } catch {
            Write-Host "导入JSON失败: $Path" -ForegroundColor Red
            return $null
        }
    } else {
        Write-Host "文件不存在: $Path" -ForegroundColor Yellow
        return $null
    }
}

# 检查PowerShell版本
if ($PSVersionTable.PSVersion.Major -lt 2) {
    Write-Host "错误: 需要PowerShell 2.0或更高版本" -ForegroundColor Red
    Write-Host "当前版本: $($PSVersionTable.PSVersion)" -ForegroundColor Yellow
    Write-Host "请安装Windows Management Framework 3.0或更高版本" -ForegroundColor Yellow
    exit 1
}

# 显示版本信息
Write-Host "PowerShell版本: $($PSVersionTable.PSVersion)" -ForegroundColor Cyan
if ($PSVersionTable.PSVersion.Major -lt 3) {
    Write-Host "警告: 某些功能可能在PowerShell 2.0中不可用" -ForegroundColor Yellow
}

Write-Host "通用工具函数库加载完成" -ForegroundColor Green

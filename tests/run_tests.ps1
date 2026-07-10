# KaiWu Office Suite V1.4.1 non-destructive regression tests
# Compatible with Windows PowerShell 2.0+ on Windows 7 SP1.
$ErrorActionPreference = 'Continue'
$base = if ($env:KAIWU_BASE) { $env:KAIWU_BASE } else { (Get-Location).Path }
$testProfile = Join-Path $env:TEMP ('kaiwu-test-profile-' + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $testProfile -Force | Out-Null
$results = @()
$passed = 0
$failed = 0

function Add-Result([string]$name, [bool]$ok, [string]$detail) {
    if ($ok) { $script:passed++ } else { $script:failed++ }
    $status = if ($ok) { 'PASS' } else { 'FAIL' }
    Write-Host "[$status] $name - $detail" -ForegroundColor $(if ($ok) { 'Green' } else { 'Red' })
    $script:results += New-Object PSObject -Property @{ Test=$name; Status=$status; Detail=$detail }
}

function Run-Bat([string]$relative, [string]$arguments) {
    $path = Join-Path $base $relative
    $psi = New-Object Diagnostics.ProcessStartInfo
    $psi.FileName = $env:COMSPEC
    $psi.Arguments = '/d /c ""' + $path + '"' + $(if ($arguments) { ' ' + $arguments } else { '' }) + '"'
    $psi.WorkingDirectory = $base
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $psi.EnvironmentVariables['USERPROFILE'] = $testProfile
    $p = New-Object Diagnostics.Process
    $p.StartInfo = $psi
    $null = $p.Start()
    $stdout = $p.StandardOutput.ReadToEnd()
    $stderr = $p.StandardError.ReadToEnd()
    $p.WaitForExit()
    return New-Object PSObject -Property @{ ExitCode=$p.ExitCode; Stdout=$stdout; Stderr=$stderr }
}

function Assert-Exit([string]$name, $run, [int]$expected) {
    Add-Result $name ($run.ExitCode -eq $expected) ("expected={0}, actual={1}" -f $expected,$run.ExitCode)
}
function Assert-File([string]$name, [string]$path) {
    Add-Result $name (Test-Path $path) $path
}
function Assert-Json([string]$name, [string]$path) {
    try {
        Add-Type -AssemblyName System.Web.Extensions
        $s = New-Object System.Web.Script.Serialization.JavaScriptSerializer
        $null = $s.DeserializeObject([IO.File]::ReadAllText($path))
        Add-Result $name $true 'valid JSON'
    } catch { Add-Result $name $false $_.Exception.Message }
}

foreach ($f in @('context.json','outline.txt','note_path.txt','git_status.txt','file_search_result.json')) {
    Remove-Item (Join-Path $base ('results\' + $f)) -Force -ErrorAction SilentlyContinue
}

$r = Run-Bat 'scripts\integration\collect_context.bat' ''
Assert-Exit 'collect_context exits 0' $r 0
Assert-File 'collect_context creates output' (Join-Path $base 'results\context.json')
Assert-Json 'collect_context JSON' (Join-Path $base 'results\context.json')

$r = Run-Bat 'scripts\integration\call_xmind_outline.bat' ''
Assert-Exit 'xmind rejects missing topic' $r 1
$r = Run-Bat 'scripts\integration\call_xmind_outline.bat' '"TestTopic" "Sub1,Sub2"'
Assert-Exit 'xmind creates outline' $r 0
Assert-File 'xmind output exists' (Join-Path $base 'results\outline.txt')

$r = Run-Bat 'scripts\integration\call_obsidian_note.bat' ''
Assert-Exit 'obsidian rejects missing title' $r 1
$r = Run-Bat 'scripts\integration\call_obsidian_note.bat' '"TestNote"'
Assert-Exit 'obsidian creates note' $r 0
Assert-File 'obsidian output path exists' (Join-Path $base 'results\note_path.txt')

$r = Run-Bat 'scripts\integration\call_wps_summary.bat' ''
Assert-Exit 'WPS summary rejects missing input' $r 1
$r = Run-Bat 'scripts\integration\call_wps_summary.bat' '"C:\nonexistent.docx"'
Assert-Exit 'WPS summary reports unsupported' $r 2

$r = Run-Bat 'scripts\integration\call_ppt_workflow.bat' ''
Assert-Exit 'PPT workflow rejects missing input' $r 1
$r = Run-Bat 'scripts\integration\call_ppt_workflow.bat' '"Quarterly report"'
Assert-Exit 'PPT workflow reports unsupported' $r 2

$gitRepo = Join-Path $env:TEMP ('kaiwu-git-test-' + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $gitRepo -Force | Out-Null
& git -C $gitRepo init | Out-Null
$r = Run-Bat 'scripts\integration\call_git_status.bat' ('"' + $gitRepo + '"')
Assert-Exit 'git status accepts repository' $r 0
Assert-File 'git status output exists' (Join-Path $base 'results\git_status.txt')

$r = Run-Bat 'scripts\integration\call_everything_search.bat' ''
Assert-Exit 'search rejects missing keyword' $r 1
$r = Run-Bat 'scripts\integration\call_everything_search.bat' ('"README" "' + $base + '"')
Assert-Exit 'search fallback succeeds' $r 0
Assert-Json 'search JSON' (Join-Path $base 'results\file_search_result.json')

$r = Run-Bat 'scripts\integration\call_tesseract_ocr.bat' ''
Assert-Exit 'OCR rejects missing input' $r 1
$r = Run-Bat 'scripts\integration\call_tesseract_ocr.bat' '"C:\nonexistent.png"'
Assert-Exit 'OCR rejects missing file' $r 2

$r = Run-Bat 'scripts\integration\open_project_folder.bat' '"C:\nonexistent_kaiwu_folder"'
Assert-Exit 'open folder rejects missing path' $r 1

foreach ($f in @('install.bat','repair.bat','uninstall.bat','verify_installers.bat','build_zip.bat','release_preflight.bat','scripts\\admin\\compute_kexstepup_hash.bat')) {
    Assert-File ($f + ' exists') (Join-Path $base $f)
}

$checkText = [IO.File]::ReadAllText((Join-Path $base 'check.bat'))
Add-Result 'check.bat includes WPS gate' ($checkText -match 'WPS/Kaiwu compatibility gate') 'WPS/Kaiwu gate is present'
Add-Result 'check.bat includes PPT gate' ($checkText -match 'call_ppt_workflow[.]bat') 'PPT unsupported gate is present'
$preflightText = [IO.File]::ReadAllText((Join-Path $base 'release_preflight.bat'))
Add-Result 'release_preflight checks KexStepup' ($preflightText -match 'KexStepup-setup[.]exe') 'KexStepup release blocker is present'
Add-Result 'release_preflight checks PPT gate' ($preflightText -match 'call_ppt_workflow[.]bat') 'PPT gate preflight is present'
$kexHelperText = [IO.File]::ReadAllText((Join-Path $base 'scripts\admin\compute_kexstepup_hash.bat'))
Add-Result 'KexStepup helper uses certutil' ($kexHelperText -match 'certutil -hashfile') 'certutil SHA256 helper is present'
Add-Result 'KexStepup helper is report-only' ($kexHelperText -match 'It does not edit manifests') 'helper is documented as report-only'

$total = $passed + $failed
$rate = if ($total) { [Math]::Round(100 * $passed / $total, 1) } else { 0 }
Write-Host ("Total={0} Passed={1} Failed={2} Rate={3}%" -f $total,$passed,$failed,$rate)
$report = "# KaiWu Office Suite Regression Report`r`n`r`nTotal: $total | Passed: $passed | Failed: $failed | Rate: $rate%`r`n`r`n| Test | Status | Detail |`r`n|---|---|---|`r`n"
foreach ($item in $results) {
    $detail = [string]$item.Detail -replace '\|','/' -replace '[\r\n]+',' '
    $report += "| $($item.Test) | $($item.Status) | $detail |`r`n"
}
[IO.Directory]::CreateDirectory((Join-Path $base 'tests')) | Out-Null
[IO.File]::WriteAllText((Join-Path $base 'tests\TEST_REPORT.md'),$report,(New-Object Text.UTF8Encoding($true)))
Remove-Item $gitRepo -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $testProfile -Recurse -Force -ErrorAction SilentlyContinue
if ($failed -gt 0) { exit 1 }
exit 0

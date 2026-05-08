<#
.SYNOPSIS
  可配置的 J-Link / RTT 操作脚本（擦写 / 烧录 / 打开 RTT 客户端）。

.DESCRIPTION
  本脚本提供通用入口，项目可以通过命令行参数或放置 `rtt-config.json` 在脚本目录或项目根目录来覆盖默认值。

.EXAMPLE
  # 使用默认配置打开 RTT 客户端查看日志
  .\script\jlink_rtt.ps1 -Action rtt

  # 指定设备并烧录 bin
  .\script\jlink_rtt.ps1 -Action flash -Bin build/bin/my_app.bin -Device AT32F437XYZ

.PARAMETER ACTION
  Action: erase | flash | rtt

#>

Param(
    [ValidateSet('erase','flash','rtt')]
    [string]$Action = 'rtt',

    [string]$JLinkPath = "C:\Program Files (x86)\SEGGER\JLink_V698e\JLink.exe",
    [string]$RTTClientPath = "C:\Program Files (x86)\SEGGER\JLink_V698e\JLinkRTTClient.exe",
    [string]$Device = "-AT32F435ZMT7",
    [string]$Interface = "SWD",
    [int]$Speed = 4000,
    [string]$Bin = "build/bin/AT32F435_LedToggle.bin",
    [string]$TempFile = "temp.jlink",
    [string]$CommandFile = "script/start_jlink_rtt.jlink"
)

function Load-ConfigIfExists {
    $candidates = @(
        (Join-Path $PSScriptRoot 'rtt-config.json'),
        (Join-Path (Get-Location) 'rtt-config.json')
    )
    foreach ($p in $candidates) {
        if (Test-Path $p) {
            try {
                return Get-Content $p -Raw | ConvertFrom-Json
            } catch {
                Write-Warning "无法解析配置文件: $p"
            }
        }
    }
    return $null
}

$cfg = Load-ConfigIfExists
if ($cfg) {
    if ($cfg.JLinkPath) { $JLinkPath = $cfg.JLinkPath }
    if ($cfg.RTTClientPath) { $RTTClientPath = $cfg.RTTClientPath }
    if ($cfg.Device) { $Device = $cfg.Device }
    if ($cfg.Interface) { $Interface = $cfg.Interface }
    if ($cfg.Speed) { $Speed = [int]$cfg.Speed }
}

# J-Link command line parsers treat leading '-' as an option. Many projects
# name devices like "-AT32F...". For J-Link calls we strip a single leading
# '-' so the device value becomes acceptable (e.g. "-AT32F435ZMT7" -> "AT32F435ZMT7").
$deviceForJlink = if ($Device -and $Device.StartsWith('-')) { $Device.TrimStart('-') } else { $Device }

switch ($Action) {
    'erase' {
        Stop-Process -Name JLink -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 200
        $content = @"
device $Device
erase 0x08000000, 0x08080000
q
"@
        # Ensure target is running after erase
        $content = $content -replace "q`n$", "g`nq`n"
        $content | Out-File -FilePath $TempFile -Encoding ASCII
        & $JLinkPath -if $Interface -speed $Speed -CommandFile $TempFile
        Remove-Item $TempFile -ErrorAction SilentlyContinue
    }

    'flash' {
        Stop-Process -Name JLink -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 200
        $content = @"
device $Device
loadbin $Bin, 0x08000000
r
q
"@
        # After reset, explicitly issue 'g' to resume execution (avoid halt-after-reset)
        $content = $content -replace "r`nq`n$", "r`ng`nq`n"
        $content | Out-File -FilePath $TempFile -Encoding ASCII
        & $JLinkPath -if $Interface -speed $Speed -CommandFile $TempFile
        Remove-Item $TempFile -ErrorAction SilentlyContinue
    }

    'rtt' {
        Stop-Process -Name JLink -Force -ErrorAction SilentlyContinue
        Stop-Process -Name JLinkRTTClient -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
        # 为了保证命令文件中使用正确的 device（可能以 '-' 开头），我们生成一个临时命令文件
        $rttTemp = "temp_rtt_connect.jlink"
        try {
            $base = Get-Content $CommandFile -Raw -ErrorAction Stop
        } catch {
            $base = ""
        }
        # Ensure target runs (g) before RTT client connects
        $rttContent = "device $Device`n" + "g`n" + $base
        $rttContent | Out-File -FilePath $rttTemp -Encoding ASCII
        Start-Process -FilePath $JLinkPath -ArgumentList '-if', $Interface, '-speed', $Speed, '-CommandFile', $rttTemp -NoNewWindow
        Start-Sleep -Seconds 1
        & $RTTClientPath
        # 清理临时 RTT 命令文件
        Remove-Item $rttTemp -ErrorAction SilentlyContinue -Force
    }
}

Write-Host "Action '$Action' completed."





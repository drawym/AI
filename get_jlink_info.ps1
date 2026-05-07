# J-Link 信息获取脚本
Write-Host "=== J-Link 信息获取 ===" -ForegroundColor Cyan

# 1. 获取 J-Link 版本信息
Write-Host "`n1. J-Link 版本信息:" -ForegroundColor Yellow
& "C:\Program Files\SEGGER\JLink_V810g\JLink.exe" /? 2>&1 | Select-Object -First 5

# 2. 检查 J-Link 连接状态
Write-Host "`n2. 检查 J-Link 硬件连接:" -ForegroundColor Yellow
"h" | & "C:\Program Files\SEGGER\JLink_V810g\JLink.exe"

Write-Host "`n=== 信息获取完成 ===" -ForegroundColor Green
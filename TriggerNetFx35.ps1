# 触发与公司软件相同的「Windows 功能 / .NET 3.5」安装对话框
$fondue = Join-Path $env:SystemRoot "System32\fondue.exe"
if (-not (Test-Path $fondue)) {
    Write-Error "找不到 fondue.exe"
    exit 1
}

$feature = Get-WindowsOptionalFeature -Online -FeatureName NetFx3 -ErrorAction SilentlyContinue
if ($feature) {
    Write-Host "当前 NetFx3 状态: $($feature.State)"
    if ($feature.State -eq "Enabled") {
        Write-Host ".NET Framework 3.5 已安装，无需再弹框。"
        exit 0
    }
    if ($feature.State -eq "DisabledWithPayloadRemoved") {
        Write-Host "警告: 安装包已被删除。弹框若走 Windows 更新可能失败，请改用 离线安装.bat"
    }
}

Write-Host "正在弹出安装框..."
Start-Process -FilePath $fondue -ArgumentList "/enable-feature:NetFx3" -Wait

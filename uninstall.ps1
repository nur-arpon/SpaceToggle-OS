Write-Host "🚀 SpaceToggle OS Uninstaller" -ForegroundColor Cyan
Write-Host "Stopping background engine..." -ForegroundColor Yellow
Stop-Process -Name "AutoHotkey64" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
Start-Sleep -Seconds 1

Write-Host "Removing Windows Startup shortcut..." -ForegroundColor Yellow
$StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\SpaceToggleV4.lnk"
if (Test-Path $StartupPath) { Remove-Item -Path $StartupPath -Force }

Write-Host "Deleting application files..." -ForegroundColor Yellow
$installDir = "$env:LOCALAPPDATA\SpaceToggleOS"
if (Test-Path $installDir) { Remove-Item -Path $installDir -Recurse -Force }

Write-Host "✅ SpaceToggle OS has been completely removed from your system!" -ForegroundColor Green

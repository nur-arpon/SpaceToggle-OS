#Requires -Version 5.1
<#
.SYNOPSIS
    SpaceToggle OS — One-Step Installer
.DESCRIPTION
    Downloads AutoHotkey v2, SpaceToggle.ahk, creates auto-start shortcut,
    and launches immediately. No admin required.
    This script is also the source for Install-SpaceToggle.exe (see Build-Exe.bat).
.NOTES
    Run directly:  powershell -ExecutionPolicy Bypass -File Install-SpaceToggle.ps1
    Or double-click Install-SpaceToggle.exe (built from this script via Build-Exe.bat)
#>

$ErrorActionPreference = "Stop"

# ── Config ─────────────────────────────────────────────────────────────────
$InstallDir   = Join-Path $env:USERPROFILE "SpaceToggle"
$AhkExe       = Join-Path $InstallDir "AutoHotkey64.exe"
$ScriptFile   = Join-Path $InstallDir "SpaceToggle.ahk"
$StartupDir   = [Environment]::GetFolderPath("Startup")
$ShortcutPath = Join-Path $StartupDir "SpaceToggle.lnk"

$AhkUrl    = "https://github.com/AutoHotkey/AutoHotkey/releases/latest/download/AutoHotkey64.exe"
$ScriptUrl = "https://raw.githubusercontent.com/nur-arpon/SpaceToggle-OS/main/SpaceToggle.ahk"
# ───────────────────────────────────────────────────────────────────────────

function Write-Step($n, $text) { Write-Host "  [$n/5] $text" -ForegroundColor Cyan }
function Write-OK($text)       { Write-Host "         $text  OK" -ForegroundColor Green }
function Write-Fail($text)     { Write-Host "`n  [ERROR] $text" -ForegroundColor Red }

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Clear-Host
Write-Host ""
Write-Host "  ==========================================" -ForegroundColor DarkCyan
Write-Host "   SpaceToggle OS  --  Installer            " -ForegroundColor White
Write-Host "  ==========================================" -ForegroundColor DarkCyan
Write-Host ""

# ── 1. Create install directory ────────────────────────────────────────────
Write-Step "1" "Creating install directory..."
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}
Write-OK $InstallDir

# ── 2. Download AutoHotkey v2 ──────────────────────────────────────────────
Write-Step "2" "Downloading AutoHotkey v2 engine..."
try {
    Invoke-WebRequest -Uri $AhkUrl -OutFile $AhkExe -UseBasicParsing
} catch {
    Write-Fail "Could not download AutoHotkey. Check your internet connection."
    Write-Host "  URL: $AhkUrl" -ForegroundColor DarkGray
    Read-Host "`n  Press Enter to exit"; exit 1
}
Write-OK "AutoHotkey64.exe"

# ── 3. Download SpaceToggle.ahk ────────────────────────────────────────────
Write-Step "3" "Downloading SpaceToggle.ahk..."
try {
    Invoke-WebRequest -Uri $ScriptUrl -OutFile $ScriptFile -UseBasicParsing
} catch {
    Write-Fail "Could not download SpaceToggle.ahk. Check your internet connection."
    Read-Host "`n  Press Enter to exit"; exit 1
}
Write-OK "SpaceToggle.ahk"

# ── 4. Create startup shortcut ─────────────────────────────────────────────
Write-Step "4" "Creating startup shortcut..."
try {
    $Shell                     = New-Object -ComObject WScript.Shell
    $Shortcut                  = $Shell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath       = $AhkExe
    $Shortcut.Arguments        = "`"$ScriptFile`""
    $Shortcut.WorkingDirectory = $InstallDir
    $Shortcut.WindowStyle      = 7
    $Shortcut.Description      = "SpaceToggle OS"
    $Shortcut.Save()
    Write-OK "Startup shortcut"
} catch {
    Write-Host "  [WARN] Could not create startup shortcut: $_" -ForegroundColor Yellow
}

# ── 5. Kill existing instance and launch ───────────────────────────────────
Write-Step "5" "Launching SpaceToggle..."
Get-Process -Name "AutoHotkey64" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 600
try {
    Start-Process -FilePath $AhkExe -ArgumentList "`"$ScriptFile`"" -WindowStyle Hidden
    Write-OK "SpaceToggle is now running"
} catch {
    Write-Fail "Failed to launch: $_"
    Read-Host "`n  Press Enter to exit"; exit 1
}

# ── Done ───────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ==========================================" -ForegroundColor DarkGreen
Write-Host "   SUCCESS!  SpaceToggle OS installed.      " -ForegroundColor Green
Write-Host "  ==========================================" -ForegroundColor DarkGreen
Write-Host ""
Write-Host "   Installed to : $InstallDir" -ForegroundColor White
Write-Host "   Auto-start   : Enabled (runs every login)" -ForegroundColor White
Write-Host "   Status       : Running now" -ForegroundColor White
Write-Host ""
Write-Host "   Hold Space + key to launch your apps:" -ForegroundColor DarkGray
Write-Host "   B=Brave  C=Chrome  D=Discord  F=Files" -ForegroundColor DarkGray
Write-Host "   Q=Steam  S=Spotify  V=VLC  W=WhatsApp" -ForegroundColor DarkGray
Write-Host "   Y=YouTube  Z=Zoom  ... (A-Z all mapped)" -ForegroundColor DarkGray
Write-Host ""
Read-Host "  Press Enter to close"

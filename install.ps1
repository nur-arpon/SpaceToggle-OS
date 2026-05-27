# ==============================================================================
# SpaceToggle OS (Universal Setup Script)
# ==============================================================================

# 0. Terminate stuck background processes to avoid "File in Use" errors
Write-Host "Cleaning up old instances..." -ForegroundColor Cyan
Stop-Process -Name "AutoHotkey64" -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

# 1. Setup Installation Directory
$installDir = "$env:LOCALAPPDATA\SpaceToggleOS"
if (!(Test-Path $installDir)) { New-Item -ItemType Directory -Force -Path $installDir | Out-Null }
$ahkExe = "$installDir\AutoHotkey64.exe"
$ahkScript = "$installDir\SpaceToggle.ahk"
$zipFile = "$installDir\ahk.zip"

# 2. Download AutoHotkey v2 Portable Engine Zip Archive
Write-Host "Verifying AutoHotkey Engine..." -ForegroundColor Yellow
$zipUrl = "https://github.com/AutoHotkey/AutoHotkey/releases/download/v2.0.18/AutoHotkey_2.0.18.zip"
if (!(Test-Path $ahkExe)) {
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $installDir -Force
    Remove-Item -Path $zipFile -Force
}

# 3. Create the Optimized SpaceToggle Script
$scriptContent = @"
#Requires AutoHotkey v2.0
SetTitleMatchMode 2

SmartLaunch(exeTarget, runCommand, webFallback := "") {
    if WinExist("ahk_exe " exeTarget) {
        if WinActive("ahk_exe " exeTarget) {
            WinMinimize("ahk_exe " exeTarget)
        } else {
            WinActivate("ahk_exe " exeTarget)
        }
        return
    }

    try {
        Run(runCommand)
    } catch {
        if (webFallback != "") {
            OpenInBrowser(webFallback)
        }
    }
}

OpenInBrowser(url) {
    try {
        Run(url)
    } catch {
        try {
            Run("brave.exe " url)
        } catch {
            Run("chrome.exe " url)
        }
    }
}

ToggleExplorer() {
    if WinExist("ahk_class CabinetWClass") {
        if WinActive("ahk_class CabinetWClass") {
            WinMinimize("ahk_class CabinetWClass")
        } else {
            WinActivate("ahk_class CabinetWClass")
        }
    } else {
        Run("explorer.exe")
    }
}

#HotIf GetKeyState("Space", "P")

; --- NATIVE APPS ---
b::SmartLaunch("brave.exe", "brave.exe")
c::SmartLaunch("chrome.exe", "chrome.exe")
d::SmartLaunch("Discord.exe", "discord://", "https://discord.com/app")
s::SmartLaunch("Spotify.exe", "spotify:", "https://open.spotify.com")
t::SmartLaunch("WindowsTerminal.exe", "wt.exe")
w::SmartLaunch("WhatsApp.exe", "whatsapp://", "https://web.whatsapp.com")
z::SmartLaunch("Zoom.exe", "zoommtg://", "https://zoom.us")
f::ToggleExplorer()

; --- WEB TARGETS ---
a::OpenInBrowser("https://gemini.google.com")
e::OpenInBrowser("https://sheets.google.com")
g::OpenInBrowser("https://mail.google.com")
h::OpenInBrowser("https://www.github.com")
i::OpenInBrowser("https://www.instagram.com")
j::OpenInBrowser("https://docs.google.com")
k::OpenInBrowser("https://calendar.google.com")
l::OpenInBrowser("https://www.linkedin.com")
m::OpenInBrowser("https://cinemaos.live/")
n::OpenInBrowser("https://keep.google.com")
o::OpenInBrowser("https://drive.google.com")
p::OpenInBrowser("https://photos.google.com")
q::OpenInBrowser("https://scholar.google.com")
r::OpenInBrowser("https://www.google.com")
u::OpenInBrowser("https://classroom.google.com")
v::OpenInBrowser("https://www.google.com/videohp")
x::OpenInBrowser("https://www.x.com")
y::OpenInBrowser("https://www.youtube.com")

#HotIf

~Space::Send("{Blind}{Space}{BS}")
"@

Set-Content -Path $ahkScript -Value $scriptContent -Encoding UTF8

# 4. Set to Run on Startup
Write-Host "Updating Windows Startup..." -ForegroundColor Yellow
$WshShell = New-Object -ComObject WScript.Shell
$StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\SpaceToggle.lnk"
$Shortcut = $WshShell.CreateShortcut($StartupPath)
$Shortcut.TargetPath = $ahkExe
$Shortcut.Arguments = "`"$ahkScript`""
$Shortcut.WorkingDirectory = $installDir
$Shortcut.IconLocation = "$ahkExe, 0"
$Shortcut.Save()

# 5. Launch Application
Write-Host "Starting SpaceToggle OS..." -ForegroundColor Yellow
Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkScript`""

Write-Host "SUCCESS! SpaceToggle OS is installed and running." -ForegroundColor Green

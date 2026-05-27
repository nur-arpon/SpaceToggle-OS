```markdown
# 🚀 SpaceToggle OS

**A lightning-fast, universal Windows app launcher that turns your Spacebar into the ultimate productivity modifier.**

SpaceToggle OS allows you to instantly open, minimize, and switch between your favorite native applications and websites using a simple `Space + Letter` shortcut. 

Built for absolute speed and minimal system impact, it requires **no complex installations**, **no administrator bloatware**, and **works out-of-the-box on any Windows 10/11 machine**.

---

## ✨ Features
* **Smart App Toggling:** If an app is closed, it opens it. If it's open, it brings it to the front. If it's already in front, it cleanly minimizes it.
* **Intelligent Web Fallback:** If a native desktop app (like Discord or Spotify) isn't installed on your computer, it seamlessly falls back to opening the web version in your browser.
* **Zero-Install Engine:** Automatically downloads a portable version of AutoHotkey directly to your local app data, completely bypassing strict system installation requirements.
* **Persistent:** Automatically adds a lightweight shortcut to your Windows Startup folder so it survives computer reboots.

---

## 🛠️ How to Install (One-Click Setup)

> **Why a PowerShell script instead of an `.exe`?** > Custom `.exe` files from independent developers are often falsely flagged as malware by Windows Defender, causing scary blue warning screens. We use a transparent PowerShell script instead so you (and your operating system) can see exactly what the code is doing. It's safe, clean, and open-source!

**Step 1:** Open your Windows Start Menu, type `PowerShell`, right-click **Windows PowerShell**, and select **Run as Administrator**.

**Step 2:** Copy the entire block of code below, paste it into the PowerShell window, and press **Enter**.

```powershell
# ==============================================================================
# SpaceToggle OS (Universal Setup Script)
# Run this in Windows PowerShell to automatically install and launch the system.
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
$zipUrl = "[https://github.com/AutoHotkey/AutoHotkey/releases/download/v2.0.18/AutoHotkey_2.0.18.zip](https://github.com/AutoHotkey/AutoHotkey/releases/download/v2.0.18/AutoHotkey_2.0.18.zip)"
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
d::SmartLaunch("Discord.exe", "discord://", "[https://discord.com/app](https://discord.com/app)")
s::SmartLaunch("Spotify.exe", "spotify:", "[https://open.spotify.com](https://open.spotify.com)")
t::SmartLaunch("WindowsTerminal.exe", "wt.exe")
w::SmartLaunch("WhatsApp.exe", "whatsapp://", "[https://web.whatsapp.com](https://web.whatsapp.com)")
z::SmartLaunch("Zoom.exe", "zoommtg://", "[https://zoom.us](https://zoom.us)")
f::ToggleExplorer()

; --- WEB TARGETS ---
a::OpenInBrowser("[https://gemini.google.com](https://gemini.google.com)")
e::OpenInBrowser("[https://sheets.google.com](https://sheets.google.com)")
g::OpenInBrowser("[https://mail.google.com](https://mail.google.com)")
h::OpenInBrowser("[https://www.github.com](https://www.github.com)")
i::OpenInBrowser("[https://www.instagram.com](https://www.instagram.com)")
j::OpenInBrowser("[https://docs.google.com](https://docs.google.com)")
k::OpenInBrowser("[https://calendar.google.com](https://calendar.google.com)")
l::OpenInBrowser("[https://www.linkedin.com](https://www.linkedin.com)")
m::OpenInBrowser("[https://cinemaos.live/](https://cinemaos.live/)")
n::OpenInBrowser("[https://keep.google.com](https://keep.google.com)")
o::OpenInBrowser("[https://drive.google.com](https://drive.google.com)")
p::OpenInBrowser("[https://photos.google.com](https://photos.google.com)")
q::OpenInBrowser("[https://scholar.google.com](https://scholar.google.com)")
r::OpenInBrowser("[https://www.google.com](https://www.google.com)")
u::OpenInBrowser("[https://classroom.google.com](https://classroom.google.com)")
v::OpenInBrowser("[https://www.google.com/videohp](https://www.google.com/videohp)")
x::OpenInBrowser("[https://www.x.com](https://www.x.com)")
y::OpenInBrowser("[https://www.youtube.com](https://www.youtube.com)")

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

```

---

## 🕹️ How to Use It

Your Spacebar still functions completely normally for typing. To trigger the launcher, **hold down the Spacebar** (like you would the Shift or Ctrl key), and tap a letter.

Here are a few of the default mappings:

* `Space + T` = Terminal
* `Space + C` = Chrome
* `Space + D` = Discord
* `Space + F` = File Explorer
* `Space + Y` = YouTube

---

## 🛑 How to Exit or Uninstall

**To temporarily close the launcher:**

1. Click the up-arrow `^` in your Windows system tray (bottom right, near the clock).
2. Right-click the green **"H"** icon.
3. Select **Exit**.

**To completely uninstall:**

1. Press `Win + R`, type `%localappdata%`, and press Enter.
2. Delete the `SpaceToggleOS` folder.
3. Press `Win + R`, type `shell:startup`, and press Enter.
4. Delete the `SpaceToggle` shortcut.

```

```

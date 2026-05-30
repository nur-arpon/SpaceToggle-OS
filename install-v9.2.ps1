# ==============================================================================
# SpaceToggle OS (Universal Setup Script - V9.2 Core Matrix Core)
# ==============================================================================

if (Test-Path ".git") {
    Write-Host "🔄 Step 1: Fetching latest cloud configurations from GitHub..." -ForegroundColor Cyan
    git pull origin main --rebase
}

Write-Host "⚙️ Step 2: Cleaning up old performance layers..." -ForegroundColor Cyan
Stop-Process -Name "AutoHotkey64" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
Start-Sleep -Seconds 1

$installDir = "$env:LOCALAPPDATA\SpaceToggleOS"
if (!(Test-Path $installDir)) { New-Item -ItemType Directory -Force -Path $installDir | Out-Null }
$ahkExe = "$installDir\AutoHotkey64.exe"
$ahkScript = "$installDir\SpaceToggleV9.ahk"
$zipFile = "$installDir\ahk.zip"

Write-Host "📦 Step 3: Verifying AutoHotkey Engine Runtime Core..." -ForegroundColor Yellow
$zipUrl = "https://github.com/AutoHotkey/AutoHotkey/releases/download/v2.0.18/AutoHotkey_2.0.18.zip"
if (!(Test-Path $ahkExe)) {
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $installDir -Force
    Remove-Item -Path $zipFile -Force
}

  $scriptContent = @'
#Requires AutoHotkey v2.0
SetTitleMatchMode 2
SingleInstance "Force"

if !A_IsAdmin {
    try {
        Run('*RunAs "' A_ScriptFullPath '"')
        ExitApp()
    }
}

global ProfileList := ["Founders", "Gamers", "Professionals"]
global CurrentProfileIndex := 1
global TargetTrans := 255
global PiPState := 0
global SavedX := 0, SavedY := 0, SavedW := 0, SavedH := 0, SavedStyle := 0
global HotkeyPressed := false

ShowHUD(Message) {
    ToolTip(Message, A_ScreenWidth // 2 - 100, A_ScreenHeight - 150)
    SetTimer(() => ToolTip(), -2500)
}

SmartLaunch(exeTarget, runCommand, webFallback := "") {
    if WinExist("ahk_exe " exeTarget) {
        if WinActive("ahk_exe " exeTarget) {
            WinMinimize("ahk_exe " exeTarget)
        } else {
            WinActivate("ahk_exe " exeTarget)
        }
    } else {
        try {
            Run(runCommand)
        } catch {
            if (webFallback != "") {
                Run(webFallback)
            }
        }
    }
}

OpenInBrowser(url) {
    if WinExist("ahk_exe brave.exe") {
        WinActivate("ahk_exe brave.exe")
        Run(url)
    } else if WinExist("ahk_exe chrome.exe") {
        WinActivate("ahk_exe chrome.exe")
        Run(url)
    } else {
        Run(url)
    }
}

#HotIf HookSpace()
HookSpace() => GetKeyState("Space", "P")

RAlt:: {
    global CurrentProfileIndex, ProfileList, HotkeyPressed
    HotkeyPressed := true
    CurrentProfileIndex := (CurrentProfileIndex == 3) ? 1 : CurrentProfileIndex + 1
    ShowHUD("Workspace Active: [" ProfileList[CurrentProfileIndex] "]")
}

Esc:: {
    global HotkeyPressed
    HotkeyPressed := true
    WinMinimizeAll()
    ShowHUD("Workspace Secured")
}

`:: {
    global PiPState, SavedX, SavedY, SavedW, SavedH, SavedStyle, HotkeyPressed
    HotkeyPressed := true
    hwnd := WinExist("A")
    if !hwnd return
    
    if (PiPState == 0) {
        WinGetPos(&SavedX, &SavedY, &SavedW, &SavedH, hwnd)
        SavedStyle := WinGetStyle(hwnd)
        WinSetStyle("-0xC00000", hwnd)
        WinSetAlwaysOnTop(1, hwnd)
        WinMove(A_ScreenWidth - 420, 20, 400, 250, hwnd)
        PiPState := 1
    } else if (PiPState == 1) {
        WinMove(20, 20, 400, 250, hwnd)
        PiPState := 2
    } else if (PiPState == 2) {
        WinMove(20, A_ScreenHeight - 300, 400, 250, hwnd)
        PiPState := 3
    } else {
        WinSetStyle(SavedStyle, hwnd)
        WinSetAlwaysOnTop(0, hwnd)
        WinMove(SavedX, SavedY, SavedW, SavedH, hwnd)
        PiPState := 0
    }
}

,:: {
    global HotkeyPressed
    HotkeyPressed := true
    if WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe brave.exe") {
        Send("^l")
    } else if WinActive("ahk_exe discord.exe") {
        Send("^k")
    } else {
        Send("{Tab}")
    }
}

WheelUp:: {
    global TargetTrans, HotkeyPressed
    HotkeyPressed := true
    TargetTrans := Min(TargetTrans + 15, 255)
    WinSetTransparent(TargetTrans, "A")
}
WheelDown:: {
    global TargetTrans, HotkeyPressed
    HotkeyPressed := true
    TargetTrans := Max(TargetTrans - 15, 40)
    WinSetTransparent(TargetTrans, "A")
}

a:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Founders") OpenInBrowser("https://gemini.google.com")
    else if (ProfileList[CurrentProfileIndex] == "Gamers") SmartLaunch("RadeonSoftware.exe", "RadeonSoftware.exe", "https://gemini.google.com")
    else SmartLaunch("photoshop.exe", "photoshop.exe")
}
b:: {
    global HotkeyPressed := true
    SmartLaunch("brave.exe", "brave.exe", "https://www.google.com")
}
c:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Founders") SmartLaunch("chrome.exe", "chrome.exe")
    else if (ProfileList[CurrentProfileIndex] == "Gamers") SmartLaunch("cs2.exe", "steam://rungameid/730")
    else SmartLaunch("canva.exe", "canva.exe", "https://www.canva.com")
}
d:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Professionals") SmartLaunch("resolve.exe", "resolve.exe")
    else SmartLaunch("discord.exe", EnvGet("LOCALAPPDATA") "\Discord\Update.exe --processStart Discord.exe")
}
e:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Founders") OpenInBrowser("https://sheets.google.com")
    else if (ProfileList[CurrentProfileIndex] == "Gamers") SmartLaunch("EpicGamesLauncher.exe", "EpicGamesLauncher.exe")
    else SmartLaunch("excel.exe", "excel.exe")
}
f:: {
    global HotkeyPressed := true
    SmartLaunch("explorer.exe", "explorer.exe")
}
g:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Founders") OpenInBrowser("https://mail.google.com")
    else if (ProfileList[CurrentProfileIndex] == "Gamers") SmartLaunch("NVIDIA GeForce Experience.exe", "NVIDIA GeForce Experience.exe")
    else OpenInBrowser("https://github.com")
}
h:: {
    global HotkeyPressed := true
    OpenInBrowser("https://github.com")
}
i:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Founders") OpenInBrowser("https://www.instagram.com")
    else if (ProfileList[CurrentProfileIndex] == "Gamers") SmartLaunch("itch.exe", EnvGet("LOCALAPPDATA") "\itch\itch.exe")
    else SmartLaunch("illustrator.exe", "illustrator.exe")
}
j:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Professionals") SmartLaunch("idea64.exe", "idea64.exe")
    else OpenInBrowser("https://docs.google.com")
}
k:: {
    global HotkeyPressed := true
    OpenInBrowser("https://calendar.google.com")
}
l:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Gamers") SmartLaunch("LeagueClient.exe", "LeagueClient.exe")
    else OpenInBrowser("https://www.linkedin.com")
}
m:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Gamers") SmartLaunch("MSIAfterburner.exe", "MSIAfterburner.exe")
    else OpenInBrowser("https://cinemaos.live/")
}
n:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Gamers") SmartLaunch("NVIDIA App.exe", "NVIDIA App.exe")
    else if (ProfileList[CurrentProfileIndex] == "Professionals") SmartLaunch("notion.exe", "notion.exe", "https://www.notion.so")
    else OpenInBrowser("https://keep.google.com")
}
o:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Gamers") SmartLaunch("obs64.exe", "obs64.exe")
    else if (ProfileList[CurrentProfileIndex] == "Professionals") SmartLaunch("outlook.exe", "outlook.exe")
    else OpenInBrowser("https://drive.google.com")
}
p:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Gamers") SmartLaunch("TslGame.exe", "steam://rungameid/578080")
    else if (ProfileList[CurrentProfileIndex] == "Professionals") SmartLaunch("powerpnt.exe", "powerpnt.exe")
    else OpenInBrowser("https://photos.google.com")
}
q:: {
    global HotkeyPressed := true
    OpenInBrowser("https://notebooklm.google")
}
r:: {
    global HotkeyPressed := true
    OpenInBrowser("https://www.reddit.com")
}
s:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Founders") SmartLaunch("spotify.exe", "spotify.exe", "https://open.spotify.com")
    else if (ProfileList[CurrentProfileIndex] == "Gamers") SmartLaunch("steam.exe", "steam.exe")
    else SmartLaunch("slack.exe", "slack.exe")
}
t:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Founders") SmartLaunch("wt.exe", "wt.exe")
    else if (ProfileList[CurrentProfileIndex] == "Gamers") OpenInBrowser("https://twitch.tv")
    else SmartLaunch("telegram.exe", "telegram.exe")
}
u:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Professionals") OpenInBrowser("https://drive.google.com")
    else SmartLaunch("uTorrent.exe", "uTorrent.exe")
}
v:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Gamers") SmartLaunch("vlr.exe", "vlr.exe")
    else SmartLaunch("vlc.exe", "vlc.exe")
}
w:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Professionals") OpenInBrowser("https://web.whatsapp.com")
    else SmartLaunch("WhatsApp.exe", "WhatsApp.exe", "https://web.whatsapp.com")
}
x:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Gamers") SmartLaunch("XboxPcApp.exe", "XboxPcApp.exe")
    else OpenInBrowser("https://www.x.com")
}
y:: {
    global HotkeyPressed := true
    if (ProfileList[CurrentProfileIndex] == "Gamers") OpenInBrowser("https://gaming.youtube.com")
    else OpenInBrowser("https://www.youtube.com")
}
z:: {
    global HotkeyPressed := true
    SmartLaunch("zoom.exe", "zoom.exe")
}

#HotIf

~Space Up:: {
    global HotkeyPressed
    if (!HotkeyPressed) {
        Send("{Space}")
    }
    HotkeyPressed := false
}
'@

$scriptContent | Set-Content -Path $ahkScript -Encoding UTF8 -Force

Write-Host "⚙️ Registering Window Manager to Startup Sequence..." -ForegroundColor Yellow
$WshShell = New-Object -ComObject WScript.Shell
$StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\SpaceToggleV9.lnk"
$Shortcut = $WshShell.CreateShortcut($StartupPath)
$Shortcut.TargetPath = $ahkExe
$Shortcut.Arguments = "`"$ahkScript`""
$Shortcut.WorkingDirectory = $installDir
$Shortcut.IconLocation = "`"$ahkExe`", 0"
$Shortcut.Save()

Write-Host "⚡ Firing up SpaceToggle OS V9.2 Core Matrix..." -ForegroundColor Green
Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkScript`""

if (Test-Path ".git") {
    Write-Host "📤 Step 4: Mirroring installation changes to GitHub Cloud..." -ForegroundColor Green
    $CurrentTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git add .
    git commit -m "Auto-Sync Engine Build V9.2.0: $CurrentTimestamp"
    git push origin main
}
Write-Host "✅ Deployment Completed Successfully!" -ForegroundColor Green

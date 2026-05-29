# ==============================================================================
# SpaceToggle OS (Universal Setup Script - V5.0.0 Ultimate Engine)
# ==============================================================================

# --- STEP 1: AUTOMATED TWO-WAY GIT PULL ---
Write-Host "🔄 Step 1: Fetching latest cloud configurations from GitHub..." -ForegroundColor Cyan
git pull origin main --rebase

# --- STEP 2: CLEANUP OLD INSTANCES ---
Write-Host "⚙️ Step 2: Cleaning up old performance layers..." -ForegroundColor Cyan
Stop-Process -Name "AutoHotkey64" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
Start-Sleep -Seconds 1

$installDir = "$env:LOCALAPPDATA\SpaceToggleOS"
if (!(Test-Path $installDir)) { New-Item -ItemType Directory -Force -Path $installDir | Out-Null }
$ahkExe = "$installDir\AutoHotkey64.exe"
$ahkScript = "$installDir\SpaceToggleV5.ahk"
$zipFile = "$installDir\ahk.zip"

# --- STEP 3: VERIFY AND MONITOR ENGINE DEPLOYMENT ---
Write-Host "📦 Verifying AutoHotkey Engine Runtime..." -ForegroundColor Yellow
$zipUrl = "https://github.com/AutoHotkey/AutoHotkey/releases/download/v2.0.18/AutoHotkey_2.0.18.zip"
if (!(Test-Path $ahkExe)) {
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $installDir -Force
    Remove-Item -Path $zipFile -Force
}

Clear-Host
Write-Host @"
=========================================================================================================
 ███████  ██████   █████  ██████ ███████     ████████  ██████  ██████   ██████   ██      ███████ 
██        ██   ██ ██   ██ ██     ██             ██    ██    ██ ██       ██       ██      ██      
 ███████  ██████  ███████ ██     █████          ██    ██    ██ ██  ███  ██  ███  ██      █████   
      ██  ██      ██   ██ ██     ██             ██    ██    ██ ██   ██  ██   ██  ██      ██      
 ███████  ██      ██   ██  ██████ ███████       ██     ██████   ██████   ██████  ███████ ███████ 
                                   V5.0.0 ULTIMATE ENGINE
=========================================================================================================
"@ -ForegroundColor Yellow

Write-Host "🚀 Building Unified V5 Engine with Space & RAlt Dynamic Hot-Swapping..." -ForegroundColor Cyan

$coreEngine = @"
#Requires AutoHotkey v2.0
SetTitleMatchMode 2
ListLines 0

; --- GLOBAL STATE MANAGEMENT ---
Global IsSpaceModifier := false
Global SpaceAborted    := false
Global CurrentProfile  := "Founders" ; Profiles: Founders, Gamers, Professionals
Global PathCache       := Map()
Global HUD_Gui         := ""

; --- PROTOCOL C: ABSOLUTE FAIL-SAFE ERROR GUARDING ---
OnError(LogFault)
LogFault(exception, mode) {
    try {
        localAppData := EnvGet("LOCALAPPDATA")
        FileAppend("Fault detected: " exception.Message " in " exception.What " at line " exception.Line ``n", localAppData "\SpaceToggleOS\faultsV5.log")
    }
    return 1
}

; --- PROTOCOL A: HARDWARE-ADAPTIVE RESOURCE MANAGEMENT ---
try {
    wmi := ComObject("WbemScripting.SWbemLocator").ConnectServer()
    for system in wmi.ExecQuery("Select TotalPhysicalMemory from Win32_ComputerSystem") {
        ramGB := system.TotalPhysicalMemory / 1073741824
        if (ramGB < 12) {
            ProcessSetPriority("Normal")
            SetTimer(OptimizeMemory, 1200000)
        } else {
            ProcessSetPriority("High")
        }
    }
} catch {
    ProcessSetPriority("Normal")
}

OptimizeMemory() {
    try {
        DllCall("psapi.dll\EmptyWorkingSet", "Ptr", -1)
    } catch {
        return
    }
}

; --- PROTOCOL B: ZERO DISK I/O BOOT PATH SCANNER ---
ResolvePath(exeTarget) {
    localAppData := EnvGet("LOCALAPPDATA")
    appData := EnvGet("APPDATA")
    programFiles := EnvGet("ProgramFiles")
    programFilesX86 := EnvGet("ProgramFiles(x86)")
    paths := []
    
    switch exeTarget {
        case "brave.exe": paths := [programFiles "\BraveSoftware\Brave-Browser\Application\brave.exe", localAppData "\BraveSoftware\Brave-Browser\Application\brave.exe", programFilesX86 "\BraveSoftware\Brave-Browser\Application\brave.exe"]
        case "chrome.exe": paths := [programFiles "\Google\Chrome\Application\chrome.exe", programFilesX86 "\Google\Chrome\Application\chrome.exe", localAppData "\Google\Chrome\Application\chrome.exe"]
        case "Discord.exe": paths := [localAppData "\Discord\Update.exe", programFiles "\Discord\Discord.exe", appData "\Discord\Update.exe"]
        case "Spotify.exe": paths := [appData "\Spotify\Spotify.exe", localAppData "\Microsoft\WindowsApps\Spotify.exe", programFiles "\Spotify\Spotify.exe"]
        case "WhatsApp.exe": paths := [localAppData "\WhatsApp\WhatsApp.exe", localAppData "\Microsoft\WindowsApps\WhatsApp.exe", programFiles "\WhatsApp\WhatsApp.exe"]
        case "Zoom.exe": paths := [appData "\Zoom\bin\Zoom.exe", localAppData "\Zoom\bin\Zoom.exe", programFiles "\Zoom\bin\Zoom.exe"]
        case "r5apex.exe": paths := [programFilesX86 "\Steam\steamapps\common\Apex Legends\r5apex.exe", programFiles "\Steam\steamapps\common\Apex Legends\r5apex.exe"]
        case "cs2.exe": paths := [programFilesX86 "\Steam\steamapps\common\Counter-Strike 2\game\bin\win64\cs2.exe", programFiles "\Steam\steamapps\common\Counter-Strike 2\game\bin\win64\cs2.exe"]
        case "EpicGamesLauncher.exe": paths := [programFilesX86 "\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe", programFiles "\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe"]
        case "FortniteClient-Win64-Shipping.exe": paths := [programFiles "\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe", programFilesX86 "\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe"]
        case "LeagueClient.exe": paths := ["C:\Riot Games\League of Legends\LeagueClient.exe"]
        case "Vortex.exe": paths := [programFiles "\Black Tree Gaming Ltd\Vortex\Vortex.exe", localAppData "\Programs\Vortex\Vortex.exe"]
        case "Palworld-Win64-Shipping.exe": paths := [programFilesX86 "\Steam\steamapps\common\Palworld\Pal\Binaries\Win64\Palworld-Win64-Shipping.exe"]
        case "RiotClientServices.exe": paths := ["C:\Riot Games\Riot Client\RiotClientServices.exe"]
        case "steam.exe": paths := [programFilesX86 "\Steam\steam.exe", programFiles "\Steam\steam.exe"]
        case "Acrobat.exe": paths := [programFiles "\Adobe\Acrobat DC\Acrobat\Acrobat.exe", programFilesX86 "\Adobe\Acrobat DC\Acrobat\Acrobat.exe"]
        case "excel.exe": paths := [programFiles "\Microsoft Office\root\Office16\EXCEL.EXE", programFilesX86 "\Microsoft Office\root\Office16\EXCEL.EXE"]
        case "outlook.exe": paths := [programFiles "\Microsoft Office\root\Office16\OUTLOOK.EXE", programFilesX86 "\Microsoft Office\root\Office16\OUTLOOK.EXE"]
        case "powerpnt.exe": paths := [programFiles "\Microsoft Office\root\Office16\POWERPNT.EXE", programFilesX86 "\Microsoft Office\root\Office16\POWERPNT.EXE"]
        case "slack.exe": paths := [localAppData "\slack\slack.exe", programFiles "\Slack\slack.exe"]
        case "telegram.exe": paths := [appData "\Telegram Desktop\Telegram.exe", localAppData "\Telegram Desktop\Telegram.exe"]
        case "obs64.exe": paths := [programFiles "\obs-studio\bin\64bit\obs64.exe", programFilesX86 "\obs-studio\bin\64bit\obs64.exe", localAppData "\Programs\obs-studio\bin\64bit\obs64.exe"]
        case "vlc.exe": paths := [programFiles "\VideoLAN\VLC\vlc.exe", programFilesX86 "\VideoLAN\VLC\vlc.exe"]
        case "uTorrent.exe": paths := [appData "\uTorrent\uTorrent.exe", programFilesX86 "\uTorrent\uTorrent.exe", localAppData "\Programs\uTorrent\uTorrent.exe"]
    }
    for p in paths {
        if FileExist(p)
            return p
    }
    return ""
}

BootScanner() {
    targets := ["brave.exe", "chrome.exe", "Discord.exe", "Spotify.exe", "WhatsApp.exe", "Zoom.exe", "r5apex.exe", "cs2.exe", "EpicGamesLauncher.exe", "FortniteClient-Win64-Shipping.exe", "LeagueClient.exe", "Vortex.exe", "Palworld-Win64-Shipping.exe", "RiotClientServices.exe", "steam.exe", "Acrobat.exe", "excel.exe", "outlook.exe", "powerpnt.exe", "slack.exe", "telegram.exe", "obs64.exe", "vlc.exe", "uTorrent.exe"]
    for t in targets {
        PathCache[t] := ResolvePath(t)
    }
}
BootScanner()

; --- ENGINE LAUNCH & STATE ACTIONS ---
SmartLaunch(exeTarget, runCommand, webFallback := "") {
    Global SpaceAborted := true
    resolved := PathCache.Has(exeTarget) ? PathCache[exeTarget] : ""
    actualExe := exeTarget
    if (resolved == "") {
        if (SubStr(runCommand, -4) = ".exe" || PathCache.Has(runCommand)) {
            actualExe := runCommand
            resolved := PathCache.Has(runCommand) ? PathCache[runCommand] : ""
        }
    }
    
    targetIdent := "ahk_exe " actualExe
    if (exeTarget = "WhatsApp.exe") {
        if WinExist("WhatsApp ahk_class ApplicationFrameWindow") {
            targetIdent := "WhatsApp ahk_class ApplicationFrameWindow"
        } else if WinExist("WhatsApp") {
            targetIdent := "WhatsApp"
        }
    }
    
    if (actualExe != "" && WinExist(targetIdent)) {
        if WinActive(targetIdent) {
            PostMessage(0x0112, 0xF020, 0, , targetIdent)
        } else {
            WinActivate(targetIdent)
        }
        return
    }
    if (resolved != "") {
        try {
            if (actualExe = "Discord.exe" && InStr(resolved, "Update.exe")) {
                Run('"' resolved '" --processStart Discord.exe')
            } else {
                Run('"' resolved '"')
            }
            return
        } catch {
            return
        }
    }
    try {
        if (SubStr(runCommand, 1, 4) = "http") {
            OpenInBrowser(runCommand)
        } else {
            Run(runCommand)
        }
    } catch {
        if (webFallback != "") {
            OpenInBrowser(webFallback)
        }
    }
}

OpenInBrowser(url) {
    Global SpaceAborted := true
    bravePath := PathCache.Has("brave.exe") ? PathCache["brave.exe"] : ""
    chromePath := PathCache.Has("chrome.exe") ? PathCache["chrome.exe"] : ""
    try {
        if (bravePath != "") {
            Run('"' bravePath '" "' url '"')
        } else if (chromePath != "") {
            Run('"' chromePath '" "' url '"')
        } else {
            Run(url)
        }
    } catch {
        Run(url)
    }
}

ToggleExplorer() {
    Global SpaceAborted := true
    if WinExist("ahk_class CabinetWClass") {
        if WinActive("ahk_class CabinetWClass") {
            PostMessage(0x0112, 0xF020, 0, , "ahk_class CabinetWClass")
        } else {
            WinActivate("ahk_class CabinetWClass")
        }
    } else {
        Run("explorer.exe")
    }
}

; --- V5 DYNAMIC HUD SYSTEM ---
CreateHUD() {
    Global HUD_Gui, CurrentProfile
    if (HUD_Gui) {
        HUD_Gui.Destroy()
    }
    HUD_Gui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    HUD_Gui.BackColor := "0B0B0E"
    HUD_Gui.SetFont("s12 c00FFCC", "Segoe UI Semibold")
    HUD_Gui.Add("Text", "w350 Center", "SPACE TOGGLE OS")
    HUD_Gui.SetFont("s10 cFFFFFF", "Segoe UI")
    HUD_Gui.Add("Text", "w350 Center", "Active Profile: " CurrentProfile)
    HUD_Gui.Show("NoActivate xCenter y900")
}

; --- ZERO-LATENCY DUAL-ROLE SPACE HOOK ---
*Space:: {
    Global IsSpaceModifier := true
    Global SpaceAborted    := false
}

*Space up:: {
    Global IsSpaceModifier := false
    if (!SpaceAborted) {
        Send("{Blind}{Space}")
    }
}

; --- V5 MANUAL PROFILE SWAPPER (Space + Right Alt) ---
#HotIf IsSpaceModifier
RAlt:: {
    Global CurrentProfile, SpaceAborted := true, HUD_Gui
    if (CurrentProfile == "Founders")
        CurrentProfile := "Gamers"
    else if (CurrentProfile == "Gamers")
        CurrentProfile := "Professionals"
    else
        CurrentProfile := "Founders"
    
    CreateHUD()
    SetTimer(() => (HUD_Gui ? (HUD_Gui.Destroy(), HUD_Gui := "") : ""), -2000)
}
#HotIf

; ==============================================================================
; INTENTIONAL PROFILE MATRIX
; ==============================================================================

; --- LAYER 1: FOUNDERS ---
#HotIf IsSpaceModifier && CurrentProfile == "Founders"
b::SmartLaunch("brave.exe", "brave.exe")
c::SmartLaunch("chrome.exe", "chrome.exe")
d::SmartLaunch("Discord.exe", "discord://", "https://discord.com/app")
s::SmartLaunch("Spotify.exe", "spotify:", "https://open.spotify.com")
t::SmartLaunch("WindowsTerminal.exe", "wt.exe")
w::SmartLaunch("WhatsApp.exe", "whatsapp://", "https://web.whatsapp.com")
z::SmartLaunch("Zoom.exe", "zoommtg://", "https://zoom.us")
f::ToggleExplorer()
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
o::SmartLaunch("obs64.exe", "obs")
p::OpenInBrowser("https://photos.google.com")
q::OpenInBrowser("https://notebooklm.google.com")
r::OpenInBrowser("https://www.reddit.com")
u::SmartLaunch("uTorrent.exe", "uTorrent.exe")
v::SmartLaunch("vlc.exe", "vlc.exe")
x::OpenInBrowser("https://www.x.com")
y::OpenInBrowser("https://www.youtube.com")

; --- LAYER 2: GAMERS ---
#HotIf IsSpaceModifier && CurrentProfile == "Gamers"
a::(PathCache["r5apex.exe"] != "") ? SmartLaunch("r5apex.exe", "r5apex.exe") : OpenInBrowser("https://gemini.google.com")
b::SmartLaunch("brave.exe", "brave.exe")
c::(PathCache["cs2.exe"] != "") ? SmartLaunch("cs2.exe", "cs2.exe") : SmartLaunch("chrome.exe", "chrome.exe")
d::SmartLaunch("Discord.exe", "discord://", "https://discord.com/app")
e::(PathCache["EpicGamesLauncher.exe"] != "") ? SmartLaunch("EpicGamesLauncher.exe", "EpicGamesLauncher.exe") : OpenInBrowser("https://sheets.google.com")
f::(PathCache["FortniteClient-Win64-Shipping.exe"] != "") ? SmartLaunch("FortniteClient-Win64-Shipping.exe", "FortniteClient-Win64-Shipping.exe") : ToggleExplorer()
g::OpenInBrowser("https://mail.google.com")
h::OpenInBrowser("https://www.github.com")
i::OpenInBrowser("https://www.instagram.com")
j::OpenInBrowser("https://docs.google.com")
k::OpenInBrowser("https://calendar.google.com")
l::(PathCache["LeagueClient.exe"] != "") ? SmartLaunch("LeagueClient.exe", "LeagueClient.exe") : OpenInBrowser("https://www.linkedin.com")
m::OpenInBrowser("https://cinemaos.live/")
n::(PathCache["Vortex.exe"] != "") ? SmartLaunch("Vortex.exe", "Vortex.exe") : OpenInBrowser("https://keep.google.com")
o::SmartLaunch("obs64.exe", "obs")
p::(PathCache["Palworld-Win64-Shipping.exe"] != "") ? SmartLaunch("Palworld-Win64-Shipping.exe", "Palworld-Win64-Shipping.exe") : OpenInBrowser("https://photos.google.com")
q::OpenInBrowser("https://notebooklm.google.com")
r::(PathCache["RiotClientServices.exe"] != "") ? SmartLaunch("RiotClientServices.exe", "RiotClientServices.exe") : OpenInBrowser("https://www.reddit.com")
s::(PathCache["steam.exe"] != "") ? SmartLaunch("steam.exe", "steam.exe") : SmartLaunch("Spotify.exe", "spotify:", "https://open.spotify.com")
t::OpenInBrowser("https://www.twitch.tv")
u::SmartLaunch("uTorrent.exe", "uTorrent.exe")
v::(PathCache["RiotClientServices.exe"] != "") ? SmartLaunch("RiotClientServices.exe", "RiotClientServices.exe --launch-product=valorant --launch-patchline=live") : SmartLaunch("vlc.exe", "vlc.exe")
w::SmartLaunch("WhatsApp.exe", "whatsapp://", "https://web.whatsapp.com")
x::{
    Global SpaceAborted := true
    Run("xbox:")
}
y::OpenInBrowser("https://www.youtube.com/gaming")

; --- LAYER 3: PROFESSIONALS ---
#HotIf IsSpaceModifier && CurrentProfile == "Professionals"
a::SmartLaunch("Acrobat.exe", "Acrobat.exe")
b::SmartLaunch("brave.exe", "brave.exe")
c::OpenInBrowser("https://calendar.google.com")
d::OpenInBrowser("https://www.dropbox.com")
e::SmartLaunch("excel.exe", "excel.exe")
f::ToggleExplorer()
g::OpenInBrowser("https://mail.google.com")
h::OpenInBrowser("https://www.hubspot.com")
i::OpenInBrowser("https://www.intercom.com")
j::OpenInBrowser("https://www.atlassian.com/software/jira")
k::OpenInBrowser("https://calendar.google.com")
l::OpenInBrowser("https://www.linkedin.com")
m::OpenInBrowser("https://cinemaos.live/")
n::OpenInBrowser("https://www.notion.so")
o::SmartLaunch("outlook.exe", "outlook.exe")
p::SmartLaunch("powerpnt.exe", "powerpnt.exe")
q::OpenInBrowser("https://notebooklm.google.com")
r::{
    Global SpaceAborted := true
    Run("mstsc.exe")
}
s::SmartLaunch("slack.exe", "slack.exe")
t::SmartLaunch("telegram.exe", "telegram.exe")
u::OpenInBrowser("https://drive.google.com")
v::{
    Global SpaceAborted := true
    Run("vmware.exe")
}
w::OpenInBrowser("https://web.whatsapp.com")
x::OpenInBrowser("https://www.x.com")
y::OpenInBrowser("https://www.youtube.com")

#HotIf
"@

$coreEngine | Set-Content -Path $ahkScript -Encoding UTF8 -Force

Write-Host "⚙️ Updating Windows Startup Shortcut..." -ForegroundColor Yellow
$WshShell = New-Object -ComObject WScript.Shell
$StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\SpaceToggleV5.lnk"
$Shortcut = $WshShell.CreateShortcut($StartupPath)
$Shortcut.TargetPath = $ahkExe
$Shortcut.Arguments = "`"$ahkScript`""
$Shortcut.WorkingDirectory = $installDir
$Shortcut.IconLocation = "`"$ahkExe`", 0"
$Shortcut.Save()

Write-Host "⚡ Starting SpaceToggle OS V5.0.0..." -ForegroundColor Yellow
Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkScript`""
Write-Host "✅ SUCCESS! SpaceToggle OS V5.0.0 Ultimate Engine is active." -ForegroundColor Green

# --- STEP 4: AUTOMATED TWO-WAY GIT PUSH ---
Write-Host "📤 Step 4: Automatically pushing your changes back to GitHub cloud..." -ForegroundColor Green
$CurrentTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git add .
git commit -m "Auto-Sync Engine Build V5.0.0 Ultimate: $CurrentTimestamp"
git push origin main
Write-Host "✅ SUCCESS! Configurations perfectly mirrored to GitHub." -ForegroundColor Green

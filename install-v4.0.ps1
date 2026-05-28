# ==============================================================================
# SpaceToggle OS (Universal Setup Script - V4.0.5 Custom Combination Core)
# ==============================================================================

Write-Host "Cleaning up old V4 instances..." -ForegroundColor Cyan
Stop-Process -Name "AutoHotkey64" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
Start-Sleep -Seconds 1

$installDir = "$env:LOCALAPPDATA\SpaceToggleOS"
if (!(Test-Path $installDir)) { New-Item -ItemType Directory -Force -Path $installDir | Out-Null }
$ahkExe = "$installDir\AutoHotkey64.exe"
$ahkScript = "$installDir\SpaceToggleV4.ahk"
$zipFile = "$installDir\ahk.zip"

Write-Host "Verifying AutoHotkey Engine..." -ForegroundColor Yellow
$zipUrl = "https://github.com/AutoHotkey/AutoHotkey/releases/download/v2.0.18/AutoHotkey_2.0.18.zip"
if (!(Test-Path $ahkExe)) {
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $installDir -Force
    Remove-Item -Path $zipFile -Force
}

Clear-Host
Write-Host @
=========================================================================================================
 ███████  ██████   █████  ██████ ███████     ████████  ██████  ██████   ██████   ██      ███████ 
██        ██   ██ ██   ██ ██     ██             ██    ██    ██ ██       ██       ██      ██      
 ███████  ██████  ███████ ██     █████          ██    ██    ██ ██  ███  ██  ███  ██      █████   
      ██  ██      ██   ██ ██     ██             ██    ██    ██ ██   ██  ██   ██  ██      ██      
 ███████  ██      ██   ██  ██████ ███████       ██     ██████   ██████   ██████  ███████ ███████ 
                                   V4.0.5 CUSTOM MATRIX
=========================================================================================================
"@ -ForegroundColor Yellow

$caption = "SpaceToggle OS Build Selector"
$message = "Please select your operational profile deployment strategy:"
$choices = [System.Management.Automation.Host.ChoiceDescription[]] @(
    New-Object System.Management.Automation.Host.ChoiceDescription "&Founders", "Standard optimized setup tailored for Arpon Tawhid baseline configurations."
    New-Object System.Management.Automation.Host.ChoiceDescription "&Gamers", "Adaptive hybrid gaming runtime layer with auto-morphic structural fallbacks."
    New-Object System.Management.Automation.Host.ChoiceDescription "&Professionals", "Corporate workflow configuration featuring enterprise app maps."
)
$result = $Host.UI.PromptForChoice($caption, $message, $choices, 0)

# --- CORE ENGINE LITERAL BLOCK ---
$coreEngine = @
#Requires AutoHotkey v2.0
SetTitleMatchMode 2

; --- PROTOCOL C: ABSOLUTE FAIL-SAFE ERROR GUARDING ---
OnError(LogFault)
LogFault(exception, mode) {
    try {
        localAppData := EnvGet("LOCALAPPDATA")
        FileAppend("Fault detected: " exception.Message " in " exception.What " at line " exception.Line "`n", localAppData "\SpaceToggleOS\faultsV4.log")
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
Global PathCache := Map()
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

SmartLaunch(exeTarget, runCommand, webFallback := "") {
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
            WinMinimize(targetIdent)
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
@

# --- MODULAR PROFILE BLOCKS ---
$profileBlock = if ($result -eq 0) {
@
; --- BUILD LAYER CONFIGURATION: FOUNDERS ---
Space & b::SmartLaunch("brave.exe", "brave.exe")
Space & c::SmartLaunch("chrome.exe", "chrome.exe")
Space & d::SmartLaunch("Discord.exe", "discord://", "https://discord.com/app")
Space & s::SmartLaunch("Spotify.exe", "spotify:", "https://open.spotify.com")
Space & t::SmartLaunch("WindowsTerminal.exe", "wt.exe")
Space & w::SmartLaunch("WhatsApp.exe", "whatsapp://", "https://web.whatsapp.com")
Space & z::SmartLaunch("Zoom.exe", "zoommtg://", "https://zoom.us")
Space & f::ToggleExplorer()
Space & a::OpenInBrowser("https://gemini.google.com")
Space & e::OpenInBrowser("https://sheets.google.com")
Space & g::OpenInBrowser("https://mail.google.com")
Space & h::OpenInBrowser("https://www.github.com")
Space & i::OpenInBrowser("https://www.instagram.com")
Space & j::OpenInBrowser("https://docs.google.com")
Space & k::OpenInBrowser("https://calendar.google.com")
Space & l::OpenInBrowser("https://www.linkedin.com")
Space & m::OpenInBrowser("https://cinemaos.live/")
Space & n::OpenInBrowser("https://keep.google.com")
Space & o::SmartLaunch("obs64.exe", "obs")
Space & p::OpenInBrowser("https://photos.google.com")
Space & q::OpenInBrowser("https://notebooklm.google.com")
Space & r::OpenInBrowser("https://www.reddit.com")
Space & u::SmartLaunch("uTorrent.exe", "uTorrent.exe")
Space & v::SmartLaunch("vlc.exe", "vlc.exe")
Space & x::OpenInBrowser("https://www.x.com")
Space & y::OpenInBrowser("https://www.youtube.com")
@
} elseif ($result -eq 1) {
@
; --- BUILD LAYER CONFIGURATION: GAMERS (MORPHIC DUAL-HYBRID SUB-SYSTEM) ---
Space & a::(PathCache["r5apex.exe"] != "") ? SmartLaunch("r5apex.exe", "r5apex.exe") : OpenInBrowser("https://gemini.google.com")
Space & b::SmartLaunch("brave.exe", "brave.exe")
Space & c::(PathCache["cs2.exe"] != "") ? SmartLaunch("cs2.exe", "cs2.exe") : SmartLaunch("chrome.exe", "chrome.exe")
Space & d::SmartLaunch("Discord.exe", "discord://", "https://discord.com/app")
Space & e::(PathCache["EpicGamesLauncher.exe"] != "") ? SmartLaunch("EpicGamesLauncher.exe", "EpicGamesLauncher.exe") : OpenInBrowser("https://sheets.google.com")
Space & f::(PathCache["FortniteClient-Win64-Shipping.exe"] != "") ? SmartLaunch("FortniteClient-Win64-Shipping.exe", "FortniteClient-Win64-Shipping.exe") : ToggleExplorer()
Space & g::OpenInBrowser("https://mail.google.com")
Space & h::OpenInBrowser("https://www.github.com")
Space & i::OpenInBrowser("https://www.instagram.com")
Space & j::OpenInBrowser("https://docs.google.com")
Space & k::OpenInBrowser("https://calendar.google.com")
Space & l::(PathCache["LeagueClient.exe"] != "") ? SmartLaunch("LeagueClient.exe", "LeagueClient.exe") : OpenInBrowser("https://www.linkedin.com")
Space & m::OpenInBrowser("https://cinemaos.live/")
Space & n::(PathCache["Vortex.exe"] != "") ? SmartLaunch("Vortex.exe", "Vortex.exe") : OpenInBrowser("https://keep.google.com")
Space & o::SmartLaunch("obs64.exe", "obs")
Space & p::(PathCache["Palworld-Win64-Shipping.exe"] != "") ? SmartLaunch("Palworld-Win64-Shipping.exe", "Palworld-Win64-Shipping.exe") : OpenInBrowser("https://photos.google.com")
Space & q::OpenInBrowser("https://notebooklm.google.com")
Space & r::(PathCache["RiotClientServices.exe"] != "") ? SmartLaunch("RiotClientServices.exe", "RiotClientServices.exe") : OpenInBrowser("https://www.reddit.com")
Space & s::(PathCache["steam.exe"] != "") ? SmartLaunch("steam.exe", "steam.exe") : SmartLaunch("Spotify.exe", "spotify:", "https://open.spotify.com")
Space & t::OpenInBrowser("https://www.twitch.tv")
Space & u::SmartLaunch("uTorrent.exe", "uTorrent.exe")
Space & v::(PathCache["RiotClientServices.exe"] != "") ? SmartLaunch("RiotClientServices.exe", "RiotClientServices.exe --launch-product=valorant --launch-patchline=live") : SmartLaunch("vlc.exe", "vlc.exe")
Space & w::SmartLaunch("WhatsApp.exe", "whatsapp://", "https://web.whatsapp.com")
Space & x::Run("xbox:")
Space & y::OpenInBrowser("https://www.youtube.com/gaming")
@
} else {
@
; --- BUILD LAYER CONFIGURATION: PROFESSIONALS ---
Space & a::SmartLaunch("Acrobat.exe", "Acrobat.exe")
Space & b::SmartLaunch("brave.exe", "brave.exe")
Space & c::OpenInBrowser("https://calendar.google.com")
Space & d::OpenInBrowser("https://www.dropbox.com")
Space & e::SmartLaunch("excel.exe", "excel.exe")
Space & f::ToggleExplorer()
Space & g::OpenInBrowser("https://mail.google.com")
Space & h::OpenInBrowser("https://www.hubspot.com")
i::OpenInBrowser("https://www.intercom.com")
Space & j::OpenInBrowser("https://www.atlassian.com/software/jira")
Space & k::OpenInBrowser("https://calendar.google.com")
Space & l::OpenInBrowser("https://www.linkedin.com")
Space & m::OpenInBrowser("https://cinemaos.live/")
Space & n::OpenInBrowser("https://www.notion.so")
Space & o::SmartLaunch("outlook.exe", "outlook.exe")
Space & p::SmartLaunch("powerpnt.exe", "powerpnt.exe")
Space & q::OpenInBrowser("https://notebooklm.google.com")
Space & r::Run("mstsc.exe")
Space & s::SmartLaunch("slack.exe", "slack.exe")
Space & t::SmartLaunch("telegram.exe", "telegram.exe")
Space & u::OpenInBrowser("https://drive.google.com")
Space & v::Run("vmware.exe")
Space & w::OpenInBrowser("https://web.whatsapp.com")
Space & x::OpenInBrowser("https://www.x.com")
Space & y::OpenInBrowser("https://www.youtube.com")
@
}

$footerBlock = @
; --- STABLE EXPLICIT SPACEBAR EVENT PASS-THROUGH MATRIX ---
Space:: {
    Send("{Space}")
}
@

# --- ATOMIC DISK WRITE ---
$finalScriptContent = -join ($coreEngine, "`n", $profileBlock, "`n", $footerBlock)
$finalScriptContent | Set-Content -Path $ahkScript -Encoding UTF8 -Force

Write-Host "Updating Windows Startup Shortcut..." -ForegroundColor Yellow
$WshShell = New-Object -ComObject WScript.Shell
$StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\SpaceToggleV4.lnk"
$Shortcut = $WshShell.CreateShortcut($StartupPath)
$Shortcut.TargetPath = $ahkExe
$Shortcut.Arguments = "`"$ahkScript`""
$Shortcut.WorkingDirectory = $installDir
$Shortcut.IconLocation = "`"$ahkExe`", 0"
$Shortcut.Save()

Write-Host "Starting SpaceToggle OS V4.0.5..." -ForegroundColor Yellow
Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkScript`""
Write-Host "SUCCESS! SpaceToggle OS V4.0.5 Precision Custom Core Engine is active." -ForegroundColor Green

<<<<<<< HEAD
# ==============================================================================
# SpaceToggle OS - V11.0 Flat Deployment Matrix (Hardened)
# ==============================================================================
Clear-Host
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
if ($PSVersionTable.PSVersion.Major -ge 5) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}
Write-Host "🚀 Initializing Secure SpaceToggle OS V11.0 Execution..." -ForegroundColor Cyan

# --- STEP 1: DIRECTORY SETUP & GIT PULL ---
$targetDir = "D:\GITHUB PROJECT\gemini 3.0"
$fallbackDir = Join-Path $env:USERPROFILE "SpaceToggle_Workspace"
$repoPath = if (Test-Path "D:\") { $targetDir } else { $fallbackDir }

if (!(Test-Path $repoPath)) {
    New-Item -ItemType Directory -Force -Path $repoPath | Out-Null
}
Set-Location -Path $repoPath -ErrorAction Stop

if (Test-Path ".git") {
    Write-Host "🔄 Fetching latest cloud configurations from GitHub..." -ForegroundColor Cyan
    git pull origin main --rebase 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "🧹 Pruning legacy scripts from tracking database..." -ForegroundColor Yellow
        git rm "install-v*.ps1" "Builder.ps1" --ignore-unmatch 2>$null
    }
}
Remove-Item -Path "install-v*.ps1", "Builder.ps1" -Force -ErrorAction SilentlyContinue

# --- STEP 2: ENGINE RUNTIME SETUP ---
Write-Host "⚙️ Step 2: Preparing Engine Runtime Environment..." -ForegroundColor Cyan
Get-Process "SpaceToggleRuntime" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

$installDir = "$env:LOCALAPPDATA\SpaceToggleOS"
if (!(Test-Path $installDir)) {
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
}

$ahkExe = "$installDir\SpaceToggleRuntime.exe"
$ahkScript = "$installDir\SpaceToggleV11.ahk"

if (!(Test-Path $ahkExe)) {
    Write-Host "📦 Downloading AutoHotkey Core..." -ForegroundColor Yellow
    $zipFile = "$installDir\ahk.zip"
    $zipUrl = "https://github.com/AutoHotkey/AutoHotkey/releases/download/v2.0.18/AutoHotkey_2.0.18.zip" 
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $installDir -Force
    Remove-Item -Path $zipFile -Force
    Rename-Item -Path "$installDir\AutoHotkey64.exe" -NewName "SpaceToggleRuntime.exe" -ErrorAction SilentlyContinue
}

# --- STEP 3: WRITING SECURE AHK PAYLOAD ---
Write-Host "🛠️ Step 3: Compiling Exception-Safe SpaceToggle Script..." -ForegroundColor Yellow

$scriptContent = @'
#Requires AutoHotkey v2.0
#SingleInstance Force
ListLines 0
KeyHistory 0
SendMode "Input"
SetWorkingDir A_ScriptDir

; --- Performance Tier Enhancements ---
SetWinDelay(-1)
ProcessSetPriority("High")

; --- Core Engine State (Super-Globals) ---
Global IsSpaceModifier := false
Global SpaceAborted    := false
Global ActiveProfile   := "Founders"
Global ProfilesList    := ["Founders", "Gamers", "Professionals"]
Global ProfileIndex    := 1
Global GuideHUD        := unset
Global NotificationHUD := unset
Global PiP_Cache       := Map()
Global BossKey_Cache   := []

Scale(pixels) {
    return Max(1, Round(pixels * (A_ScreenDPI / 96)))
}

ApplyLiquidGlassStyle(hwnd) {
    ; Attribute 33: Corner Preference (3 = Rounded)
    ; Attribute 38: Backdrop Type (3 = Acrylic Sheet)
    ; Attribute 34: Border Color (0x40FFFFFF = 25% Opacity White Specular Edge)
    ; Attribute 35: Caption Color (Deep Black)
    DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "UInt", 33, "Int*", 3, "UInt", 4)
    DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "UInt", 38, "Int*", 3, "UInt", 4)
    DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "UInt", 34, "Int*", 0x40FFFFFF, "UInt", 4)
    DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "UInt", 35, "Int*", 0x010101, "UInt", 4)
    WinSetTransparent(0, hwnd)
}

CreateGuideHUD() {
    global GuideHUD
    GuideHUD := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +Owner", "SpaceToggle Guide")
    GuideHUD.BackColor := "202020"
    
    GuideHUD.SetFont("s13 cWhite Bold", "Segoe UI")
    GuideHUD.Add("Text", "Center w" Scale(340) " y" Scale(15), "🚀 SpaceToggle OS V11.0")

    GuideHUD.SetFont("s10 c00FFCC Bold", "Segoe UI")
    GuideHUD.Add("Text", "Center w" Scale(340) " y" Scale(45), "Active Layer: " StrUpper(ActiveProfile))

    GuideHUD.SetFont("s9.5 cE0E0E0 norm", "Segoe UI")
    GuideHUD.Add("Text", "Left x" Scale(40) " w" Scale(300) " y" Scale(75), "[Space + RAlt] Cycle OS Profiles")
    GuideHUD.Add("Text", "Left x" Scale(40) " w" Scale(300) " y" Scale(95), "[Space + Esc] Toggle Boss Key (Hide All)")
    GuideHUD.Add("Text", "Left x" Scale(40) " w" Scale(300) " y" Scale(115), "[Space + ``] Multi-Corner PiP Mode")
    GuideHUD.Add("Text", "Left x" Scale(40) " w" Scale(300) " y" Scale(135), "[Space + ,] Contextual Search/Input")
    GuideHUD.Add("Text", "Left x" Scale(40) " w" Scale(300) " y" Scale(155), "[Space + Scroll] Layer Opacity")
    GuideHUD.Add("Text", "Left x" Scale(40) " w" Scale(300) " y" Scale(175), "[Space + Up/Dn x2] Scroll Top/Bottom")
    
    GuideHUD.Title := "SpaceToggle Guide"
    ApplyLiquidGlassStyle(GuideHUD.Hwnd)
}

AnimateGlassHUD(hwnd, targetAlpha := 235) {
    state := { alpha: 0, velocity: 0, lastT: A_TickCount }
    ; Mass-Spring-Damper Constants (k=stiffness, c=damping)
    kStiffness := 0.18, cDamping := 0.42, mMass := 1.0
    
    fadeTimer() {
        if !WinExist(hwnd) {
            return SetTimer(fadeTimer, 0)
        }

        deltaTime := (A_TickCount - state.lastT) / 1000
        state.lastT := A_TickCount

        if (deltaTime > 0.1 || deltaTime <= 0) {
            deltaTime := 0.016
        }

        ; Physics Integration Loop
        springForce := -kStiffness * (state.alpha - targetAlpha) - (cDamping * state.velocity)
        acceleration := springForce / mMass
        state.velocity += acceleration
        state.alpha += state.velocity

        if (Abs(state.alpha - targetAlpha) < 0.1 && Abs(state.velocity) < 0.1) {
            WinSetTransparent(targetAlpha, hwnd)
            SetTimer(fadeTimer, 0)
        } else {
            WinSetTransparent(Max(0, Min(255, Round(state.alpha))), hwnd)
        }
    }
    SetTimer(fadeTimer, 16)
}

AnimateElasticRestore(hwnd, tX, tY, tW, tH) {
    ; Mass-Spring-Damper Loop for Window Geometry
    kStiffness := 0.24, cDamping := 0.58, mMass := 1.0
    WinGetPos(&origX, &origY, &origW, &origH, hwnd)
    state := { x: origX, y: origY, w: origW, h: origH, vX: 0, vY: 0, vW: 0, vH: 0 }

    restoreLoop() {
        if !WinExist(hwnd) {
            return SetTimer(restoreLoop, 0)
        }

        fX := -kStiffness * (state.x - tX) - (cDamping * state.vX), aX := fX / mMass, state.vX += aX, state.x += state.vX
        fY := -kStiffness * (state.y - tY) - (cDamping * state.vY), aY := fY / mMass, state.vY += aY, state.y += state.vY
        fW := -kStiffness * (state.w - tW) - (cDamping * state.vW), aW := fW / mMass, state.vW += aW, state.w += state.vW
        fH := -kStiffness * (state.h - tH) - (cDamping * state.vH), aH := fH / mMass, state.vH += aH, state.h += state.vH

        if (Abs(state.x - tX) < 1 && Abs(state.vX) < 1) {
            WinMove(tX, tY, tW, tH, hwnd)
            SetTimer(restoreLoop, 0)
        } else {
            WinMove(Round(state.x), Round(state.y), Round(state.w), Round(state.h), hwnd)
        }
    }
    SetTimer(restoreLoop, 16)
}

ToggleGuideHUD(show) {
    global
    if (show) {
        if (IsSet(GuideHUD) && IsObject(GuideHUD)) {
            GuideHUD.Destroy()
        }
        CreateGuideHUD()
        activeHwnd := WinExist("A")
        currentMon := activeHwnd ? GetMonitorFromWindowOrigin(activeHwnd) : 1
        
        workLeft := 0, workTop := 0, workRight := 0, workBottom := 0
        MonitorGetWorkArea(currentMon, &workLeft, &workTop, &workRight, &workBottom)
        
        posX := workLeft + ((workRight - workLeft) / 2) - Scale(170)
        posY := workBottom - Scale(260) 
        
        if (IsSet(GuideHUD) && IsObject(GuideHUD)) {
            GuideHUD.Show("X" posX " Y" posY " W" Scale(340) " H" Scale(195) " NoActivate")
            AnimateGlassHUD(GuideHUD.Hwnd, 235)
        }
    } else {
        if (IsSet(GuideHUD) && IsObject(GuideHUD)) {
            GuideHUD.Destroy()
        }
    }
}

CreateNotificationHUD(message) {
    global
    if (IsSet(NotificationHUD) && IsObject(NotificationHUD)) {
        NotificationHUD.Destroy()
    }
    NotificationHUD := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +Owner", "SpaceToggle Alert")
    NotificationHUD.BackColor := "202020"
    NotificationHUD.SetFont("s11 cWhite Bold", "Segoe UI")
    NotificationHUD.Add("Text", "Center w" Scale(360) " y" Scale(12), message)

    ApplyLiquidGlassStyle(NotificationHUD.Hwnd)

    activeHwnd := WinExist("A")
    currentMon := activeHwnd ? GetMonitorFromWindowOrigin(activeHwnd) : 1

    workLeft := 0, workTop := 0, workRight := 0, workBottom := 0
    MonitorGetWorkArea(currentMon, &workLeft, &workTop, &workRight, &workBottom)
    
    posX := workLeft + ((workRight - workLeft) / 2) - Scale(180)
    posY := workBottom - Scale(100)
    NotificationHUD.Show("X" posX " Y" posY " W" Scale(360) " H" Scale(45) " NoActivate")
    AnimateGlassHUD(NotificationHUD.Hwnd, 245)

    SetTimer(() => (IsSet(NotificationHUD) && IsObject(NotificationHUD) ? NotificationHUD.Destroy() : ""), -1800)
}

GetSanitizedTitle(hwnd) {
    try {
        title := WinGetTitle(hwnd)
        if (title == "") {
            title := WinGetProcessName(hwnd)
        }
        if (StrLen(title) > 22) {
            title := SubStr(title, 1, 19) "..."
        }
        return title
    } catch Error {
        return "Unknown Target"
    }
}

HasProtocol(proto) {
    try {
        RegRead("HKCR\" proto, "URL Protocol")
        return true
    } catch Error {
        return false
    }
}

GetMonitorFromWindowOrigin(hwnd) {
    try {
        WinGetPos(&x, &y, &w, &h, hwnd)
        centerX := x + (w / 2)
        centerY := y + (h / 2)
        loop MonitorGetCount() {
            left := 0, top := 0, right := 0, bottom := 0
            MonitorGet(A_Index, &left, &top, &right, &bottom)
            if (centerX >= left && centerX < right && centerY >= top && centerY < bottom)
                return A_Index
        }
    } catch Error {
        return 1
    }
    return 1
}

ResolvePath(exeTarget) {
    if (exeTarget == "")
        return ""
    if (exeTarget = "Discord.exe" && HasProtocol("discord"))
        return "discord://"
    if (exeTarget = "Spotify.exe" && HasProtocol("spotify"))
        return "spotify://"
    if (exeTarget = "WhatsApp.exe" && HasProtocol("whatsapp"))
        return "whatsapp://"
    if (exeTarget = "steam.exe" && HasProtocol("steam"))
        return "steam://"

    l := EnvGet("LOCALAPPDATA"), a := EnvGet("APPDATA"), p := EnvGet("ProgramFiles"), p86 := EnvGet("ProgramFiles(x86)")
    paths := []

    switch exeTarget, false {
        case "brave.exe": paths := [p "\BraveSoftware\Brave-Browser\Application\brave.exe", l "\BraveSoftware\Brave-Browser\Application\brave.exe"]
        case "chrome.exe": paths := [p "\Google\Chrome\Application\chrome.exe", l "\Google\Chrome\Application\chrome.exe"]
        case "obs64.exe": paths := [p "\obs-studio\bin\64bit\obs64.exe", p86 "\obs-studio\bin\64bit\obs64.exe"]
        case "excel.exe": paths := [p "\Microsoft Office\root\Office16\EXCEL.EXE", p86 "\Microsoft Office\root\Office16\EXCEL.EXE"]
        case "powerpnt.exe": paths := [p "\Microsoft Office\root\Office16\POWERPNT.EXE"]
        case "outlook.exe": paths := [p "\Microsoft Office\root\Office16\OUTLOOK.EXE"]
        case "Photoshop.exe": paths := [p "\Adobe\Adobe Photoshop 2026\Photoshop.exe", p "\Adobe\Adobe Photoshop 2025\Photoshop.exe", p "\Adobe\Adobe Photoshop 2024\Photoshop.exe"]
        case "LeagueClient.exe": paths := ["C:\Riot Games\League of Legends\LeagueClient.exe"]
        case "EpicGamesLauncher.exe": paths := [p86 "\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe", p "\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe"]
        case "blender.exe": paths := [p "\Blender Foundation\Blender\blender.exe"]
        case "Canva.exe": paths := [l "\Programs\Canva\Canva.exe"]
        case "Resolve.exe": paths := [p "\Blackmagic Design\DaVinci Resolve\Resolve.exe"]
        case "slack.exe": paths := [l "\Programs\slack\slack.exe"]
        case "Telegram.exe": paths := [a "\Telegram Desktop\Telegram.exe"]
        case "uTorrent.exe": paths := [a "\uTorrent\uTorrent.exe"]
        case "vlc.exe": paths := [p "\VideoLAN\VLC\vlc.exe", p86 "\VideoLAN\VLC\vlc.exe"]
        case "Zoom.exe": paths := [a "\Zoom\bin\Zoom.exe"]
        case "notepad.exe": paths := ["C:\Windows\System32\notepad.exe"]
        case "Notion.exe": paths := [l "\Programs\Notion\Notion.exe"]
        case "wt.exe": paths := [l "\Microsoft\WindowsApps\wt.exe"]
        case "RadeonSoftware.exe": paths := [p "\AMD\CNext\CNext\RadeonSoftware.exe"]
        case "MSIAfterburner.exe": paths := [p86 "\MSI Afterburner\MSIAfterburner.exe"]
    }

    for path in paths {
        if FileExist(path)
            return path
    }

        ; Resilient fallback: try common vendor patterns dynamically (search highest-versioned folders)
        try {
            if (exeTarget = "Photoshop.exe") {
                Loop Files p "\Adobe\Adobe Photoshop *\Photoshop.exe", "R" {
                    return A_LoopFilePath
                }
            }
            if (exeTarget = "brave.exe") {
                Loop Files p "\BraveSoftware\Brave-Browser\Application\brave.exe", "R" {
                    return A_LoopFilePath
                }
            }
        } catch Error {
            ; ignore and continue to registry fallbacks
        }

    try {
        regPath := RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" exeTarget)
        if FileExist(regPath)
            return regPath
    } catch Error {
        ; Ignore Exception
    }
    
    try {
        regPath := RegRead("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" exeTarget)
        if FileExist(regPath)
            return regPath
    } catch Error {
        ; Ignore Exception
    }

    return ""
}

RunBrowser(url) {
    brave := ResolvePath("brave.exe")
    chrome := ResolvePath("chrome.exe")
    if (brave != "")
        Run('"' brave '" "' url '"')
    else if (chrome != "")
        Run('"' chrome '" "' url '"')
    else
        Run(url)
}

SmartCascade(TargetApp:="", TargetWeb:="", FoundersApp:="", FoundersWeb:="") {
    global
    SpaceAborted := true
    
    if (TargetApp != "") {
        if (TargetApp = "explorer.exe") {
            if WinExist("ahk_class CabinetWClass") {
                if WinActive("ahk_class CabinetWClass") {
                    WinMinimize("ahk_class CabinetWClass")
                    CreateNotificationHUD("🗕 Minimized: File Explorer")
                } else {
                    WinActivate("ahk_class CabinetWClass")
                    CreateNotificationHUD("🗖 Focused: File Explorer")
                }
                return
            } else {
                Run("explorer.exe")
                CreateNotificationHUD("🚀 Launched: File Explorer")
                return
            }
        }

        try {
            hwnds := WinGetList("ahk_exe " TargetApp)
            for hwnd in hwnds {
                if (WinGetStyle(hwnd) & 0x10000000) { 
                    cleanName := GetSanitizedTitle(hwnd)
                    if WinActive(hwnd) {
                        WinMinimize(hwnd)
                        CreateNotificationHUD("🗕 Minimized: " cleanName)
                    } else {
                        WinActivate(hwnd)
                        WinShow(hwnd)
                        CreateNotificationHUD("🗖 Focused: " cleanName)
                    }
                    return
                }
            }
        } catch Error {
            ; Ignore Error
        }
        
        resolved := (TargetApp != "") ? ResolvePath(TargetApp) : ""
        if (resolved != "") {
            try { 
                Run(InStr(resolved, "://") ? resolved : '"' resolved '"') 
                CreateNotificationHUD("🚀 Launched: " TargetApp)
                return
            } catch Error {
                ; Ignore Error
            }
        }
    }

    if (TargetWeb != "") {
        try { 
            RunBrowser(TargetWeb) 
            CreateNotificationHUD("🌐 Navigating: " SubStr(TargetWeb, 9, 20) "...")
            return
        } catch Error {
            ; Ignore Error
        }
    }

    if (FoundersApp != "") {
        try {
            fHwnds := WinGetList("ahk_exe " FoundersApp)
            for hwnd in fHwnds {
                if (WinGetStyle(hwnd) & 0x10000000) {
                    cleanName := GetSanitizedTitle(hwnd)
                    if WinActive(hwnd) {
                        WinMinimize(hwnd)
                        CreateNotificationHUD("🗕 Fallback Minimized: " cleanName)
                    } else {
                        WinActivate(hwnd)
                        WinShow(hwnd)
                        CreateNotificationHUD("🗖 Fallback Focused: " cleanName)
                    }
                    return
                }
            }
        } catch Error {
            ; Ignore Error
        }
        
        resolvedFounders := ResolvePath(FoundersApp)
        if (resolvedFounders != "") {
            try { 
                Run(InStr(resolvedFounders, "://") ? resolvedFounders : '"' resolvedFounders '"') 
                CreateNotificationHUD("🚀 Fallback Init: " FoundersApp)
                return
            } catch Error {
                ; Ignore Error
            }
        }
    }

    if (FoundersWeb != "") {
        try { 
            RunBrowser(FoundersWeb) 
            CreateNotificationHUD("🌐 Fallback Web: " SubStr(FoundersWeb, 9, 20) "...")
            return
        } catch Error {
            ; Ignore Error
        }
    }
}

RouteShortcut(key) {
    Static Founders := Map(
        "a", ["", "https://gemini.google.com"],
        "b", ["brave.exe", ""],
        "c", ["chrome.exe", ""],
        "d", ["Discord.exe", ""],
        "e", ["", "https://docs.google.com/spreadsheets"],
        "f", ["explorer.exe", ""],
        "g", ["", "https://mail.google.com"],
        "h", ["", "https://github.com"],
        "i", ["", "https://instagram.com"],
        "j", ["", "https://docs.google.com"],
        "k", ["", "https://calendar.google.com"],
        "l", ["", "https://linkedin.com"],
        "m", ["", "https://cinemaos.live/"],
        "n", ["", "https://keep.google.com"],
        "o", ["", "https://drive.google.com"],
        "p", ["", "https://photos.google.com"],
        "q", ["", "https://notebooklm.google.com"],
        "r", ["", "https://reddit.com"],
        "s", ["Spotify.exe", ""],
        "t", ["wt.exe", ""],
        "u", ["uTorrent.exe", ""],
        "v", ["vlc.exe", ""],
        "w", ["WhatsApp.exe", ""],
        "x", ["", "https://x.com"],
        "y", ["", "https://youtube.com"],
        "z", ["Zoom.exe", ""]
    )

    Static Gamers := Map(
        "a", ["RadeonSoftware.exe", ""],
        "b", ["Battle.net.exe", ""],
        "c", ["cs2.exe", ""],
        "d", ["Discord.exe", ""],
        "e", ["EpicGamesLauncher.exe", ""],
        "f", ["FortniteClient-Win64-Shipping.exe", ""],
        "g", ["NVIDIA GeForce Experience.exe", ""],
        "h", ["HaloInfinite.exe", ""],
        "i", ["itch.exe", ""],
        "j", ["", ""],
        "k", ["", ""],
        "l", ["LeagueClient.exe", ""],
        "m", ["MSIAfterburner.exe", ""],
        "n", ["NVIDIA app.exe", ""],
        "o", ["obs64.exe", ""],
        "p", ["TslGame.exe", ""],
        "q", ["", ""],
        "r", ["", "https://reddit.com"],
        "s", ["steam.exe", ""],
        "t", ["", "https://twitch.tv"],
        "u", ["uTorrent.exe", ""],
        "v", ["", ""],
        "w", ["", ""],
        "x", ["Xbox.exe", ""],
        "y", ["", "https://gaming.youtube.com"],
        "z", ["", ""]
    )

    Static Professionals := Map(
        "a", ["Photoshop.exe", ""],
        "b", ["blender.exe", ""],
        "c", ["Canva.exe", ""],
        "d", ["Resolve.exe", ""],
        "e", ["excel.exe", ""],
        "f", ["explorer.exe", ""],
        "g", ["", "https://github.com"],
        "h", ["", "https://github.com"],
        "i", ["Illustrator.exe", ""],
        "j", ["idea64.exe", ""],
        "k", ["", ""],
        "l", ["", "https://linkedin.com"],
        "m", ["", ""],
        "n", ["Notion.exe", ""],
        "o", ["outlook.exe", ""],
        "p", ["powerpnt.exe", ""],
        "q", ["", ""],
        "r", ["", "https://reddit.com"],
        "s", ["slack.exe", ""],
        "t", ["Telegram.exe", ""],
        "u", ["", ""],
        "v", ["", ""],
        "w", ["", ""],
        "x", ["", ""],
        "y", ["", ""],
        "z", ["", ""]
    )

    fApp := Founders.Has(key) ? Founders[key][1] : ""
    fWeb := Founders.Has(key) ? Founders[key][2] : ""

    if (ActiveProfile = "Founders" && Founders.Has(key)) {
        SmartCascade(Founders[key][1], Founders[key][2], "", "")
    } else if (ActiveProfile = "Gamers" && Gamers.Has(key)) {
        SmartCascade(Gamers[key][1], Gamers[key][2], fApp, fWeb)
    } else if (ActiveProfile = "Professionals" && Professionals.Has(key)) {
        SmartCascade(Professionals[key][1], Professionals[key][2], fApp, fWeb)
    }
}

TogglePiP() {
    global
    SpaceAborted := true
    hwnd := WinExist("A")
    if !hwnd
        return
    try {
        currentWindowClass := WinGetClass(hwnd)
        if (currentWindowClass = "WorkerW" || currentWindowClass = "Progman" || currentWindowClass = "Shell_TrayWnd" || currentWindowClass = "AutoHotkeyGUI")
            return
            
        cleanName := GetSanitizedTitle(hwnd)
        targetMonitor := GetMonitorFromWindowOrigin(hwnd)
        
        workLeft := 0, workTop := 0, workRight := 0, workBottom := 0
        MonitorGetWorkArea(targetMonitor, &workLeft, &workTop, &workRight, &workBottom)
        
        pipW := (workRight - workLeft) / 2
        pipH := (workBottom - workTop) / 2
            
        if PiP_Cache.Has(hwnd) {
            state := PiP_Cache[hwnd]
            state.PositionIndex += 1
            
            if (state.PositionIndex == 1) {
                WinMove(workLeft + pipW, workTop, pipW, pipH, hwnd)
                CreateNotificationHUD("📐 PiP Top-Right: " cleanName)
            } else if (state.PositionIndex == 2) {
                WinMove(workLeft + pipW, workTop + pipH, pipW, pipH, hwnd)
                CreateNotificationHUD("📐 PiP Bottom-Right: " cleanName)
            } else if (state.PositionIndex == 3) {
                WinMove(workLeft, workTop + pipH, pipW, pipH, hwnd)
                CreateNotificationHUD("📐 PiP Bottom-Left: " cleanName)
            } else {
                WinSetStyle(state.OriginalStyle, hwnd)
                WinSetAlwaysOnTop(0, hwnd)
                if (state.WasMaximized) {
                    WinMaximize(hwnd)
                } else {
                    WinMove(state.OriginalX, state.OriginalY, state.OriginalW, state.OriginalH, hwnd)
                }
                PiP_Cache.Delete(hwnd)
                CreateNotificationHUD("↩️ Frame Restored: " cleanName)
            }
        } else {
            style := WinGetStyle(hwnd)
            isMax := WinGetMinMax(hwnd)
            WinGetPos(&x, &y, &w, &h, hwnd)
            
            if (isMax = 1) {
                WinRestore(hwnd)
            }
            
            PiP_Cache[hwnd] := {OriginalStyle: style, OriginalX: x, OriginalY: y, OriginalW: w, OriginalH: h, PositionIndex: 0, WasMaximized: (isMax=1)}
            
            WinSetStyle("-0xC40000", hwnd) 
            WinSetAlwaysOnTop(1, hwnd)
            
            WinMove(workLeft, workTop, pipW, pipH, hwnd)
            CreateNotificationHUD("📺 PiP Top-Left: " cleanName)
        }
    } catch Error {
        return
    }
}

ToggleBossKey() {
    global
    SpaceAborted := true
    if (BossKey_Cache.Length > 0) {
        for item in BossKey_Cache {
            if WinExist(item.hwnd) {
                WinShow(item.hwnd)
                if (item.max)
                    WinMaximize(item.hwnd)
                else
                    AnimateElasticRestore(item.hwnd, item.x, item.y, item.w, item.h)
            }
        }
        BossKey_Cache := []
        CreateNotificationHUD("🔓 Workspace Restored")
    } else {
        winList := WinGetList()
        gHwnd := IsSet(GuideHUD) ? GuideHUD.Hwnd : 0
        nHwnd := IsSet(NotificationHUD) ? NotificationHUD.Hwnd : 0
        
        for hwnd in winList {
            if !WinExist(hwnd) || hwnd == gHwnd || hwnd == nHwnd
                continue
            try {
                style := WinGetStyle(hwnd)
                currentWindowClass := WinGetClass(hwnd)
                isMax := (WinGetMinMax(hwnd) == 1)
                WinGetPos(&x, &y, &w, &h, hwnd)
                
                if (style & 0x10000000) && (currentWindowClass != "WorkerW") && (currentWindowClass != "Progman") && (currentWindowClass != "Shell_TrayWnd") && (currentWindowClass != "AutoHotkeyGUI") {
                    BossKey_Cache.Push({hwnd: hwnd, x: x, y: y, w: w, h: h, max: isMax})
                    WinHide(hwnd)
                    WinMinimize(hwnd)
                }
            } catch Error {
                continue
            }
        }
        CreateNotificationHUD("🔒 Boss Key Engaged")
    }
}

FocusInputEngine() {
    global
    SpaceAborted := true
    if !(activeHwnd := WinExist("A"))
        return
        
    try {
        procName := WinGetProcessName(activeHwnd)
        winTitle := WinGetTitle(activeHwnd)
        
        ; Check for Web-App Context inside Browsers first
        if (InStr(procName, "chrome") || InStr(procName, "brave") || InStr(procName, "msedge") || InStr(procName, "firefox")) {
            if InStr(winTitle, "Gemini") {
                ; Gemini doesn't have a global search hotkey, usually Tab or clicking. 
                ; We send 'Escape' to clear focus, then 'Shift+Tab' often lands on the input.
                Send("{Esc}")
                Sleep(50)
                Send("i") ; Common shortcut for some AI inputs or just typing
                CreateNotificationHUD("✨ Gemini Input Focused")
                return
            } else if InStr(winTitle, "YouTube") {
                Send("/")
                CreateNotificationHUD("📺 YouTube Search Focused")
                return
            } else if InStr(winTitle, "Spotify") {
                Send("/")
                CreateNotificationHUD("🎵 Spotify Search Focused")
                return
            } else if (winTitle = "New Tab" || winTitle = "Home") {
                Send("^l") ; Address bar only on Home/New Tab
                CreateNotificationHUD("🌍 Browser Address Bar")
                return
            }
            ; Default for other websites: try common search shortcut
            Send("/")
        } else if InStr(procName, "WhatsApp") {
            Send("^f") ; WhatsApp App search
        } else if InStr(procName, "Discord") {
            Send("^k") ; Discord Quick Switcher / Search
        } else if InStr(procName, "explorer") {
            Send("^e") ; File Explorer Search
        } else {
            Send("^f") ; Generic Find/Search
        }
        CreateNotificationHUD("🎯 Search/Input Focused")
    } catch Error {
        return
    }
}

*Space:: {
    global
    if (IsSpaceModifier)
        return
    IsSpaceModifier := true
    SpaceAborted    := false
    SetTimer(() => (IsSpaceModifier && !SpaceAborted) ? ToggleGuideHUD(true) : "", -300)
}

*Space up:: {
    global
    IsSpaceModifier := false
    ToggleGuideHUD(false)
    if (!SpaceAborted)
        Send("{Blind}{Space}")
}

#HotIf IsSpaceModifier
*Up:: {
    Static LastUp := 0
    global SpaceAborted := true
    if (A_TickCount - LastUp < 400) {
        Send("^{Home}")
        CreateNotificationHUD("⤒ Scrolled to Top")
        LastUp := 0
    } else {
        LastUp := A_TickCount
    }
}

*Down:: {
    Static LastDn := 0
    global SpaceAborted := true
    if (A_TickCount - LastDn < 400) {
        Send("^{End}")
        CreateNotificationHUD("⤓ Scrolled to Bottom")
        LastDn := 0
    } else {
        LastDn := A_TickCount
    }
}

*RAlt:: {
    global
    SpaceAborted := true
    global ProfileIndex := (ProfileIndex >= ProfilesList.Length) ? 1 : ProfileIndex + 1
    global ActiveProfile := ProfilesList[ProfileIndex]
    CreateNotificationHUD("👤 OS Layer Active: " ActiveProfile)
}

*Esc::ToggleBossKey()
*SC029::TogglePiP()
*,::FocusInputEngine()

WheelUp:: {
    global
    SpaceAborted := true
    try {
        activeHwnd := WinExist("A")
        if !activeHwnd
            return
        currTrans := WinGetTransparent(activeHwnd)
        trans := (currTrans == "" || currTrans == -1) ? 255 : currTrans

        trans += 15
        if (trans > 255)
            trans := 255
        WinSetTransparent(trans, "A")
    } catch Error {
        return
    }
}

WheelDown:: {
    global
    SpaceAborted := true
    try {
        activeHwnd := WinExist("A")
        if !activeHwnd
            return
        currTrans := WinGetTransparent(activeHwnd)
        trans := (currTrans == "" || currTrans == -1) ? 255 : currTrans

        trans -= 15
        if (trans < 60)
            trans := 60
        WinSetTransparent(trans, "A")
    } catch Error {
        return
    }
}

*a::RouteShortcut("a")
*b::RouteShortcut("b")
*c::RouteShortcut("c")
*d::RouteShortcut("d")
*e::RouteShortcut("e")
*f::RouteShortcut("f")
*g::RouteShortcut("g")
*h::RouteShortcut("h")
*i::RouteShortcut("i")
*j::RouteShortcut("j")
*k::RouteShortcut("k")
*l::RouteShortcut("l")
*m::RouteShortcut("m")
*n::RouteShortcut("n")
*o::RouteShortcut("o")
*p::RouteShortcut("p")
*q::RouteShortcut("q")
*r::RouteShortcut("r")
*s::RouteShortcut("s")
*t::RouteShortcut("t")
*u::RouteShortcut("u")
*v::RouteShortcut("v")
*w::RouteShortcut("w")
*x::RouteShortcut("x")
*y::RouteShortcut("y")
*z::RouteShortcut("z")
#HotIf
'@
$scriptContent | Set-Content -Path $ahkScript -Encoding UTF8 -Force

Write-Host "⚙️ Step 4: Registering Native Startup Hooks..." -ForegroundColor Yellow
$WshShell = New-Object -ComObject WScript.Shell
$StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\SpaceToggleV11.lnk" 

$Shortcut = $WshShell.CreateShortcut($StartupPath)
$Shortcut.TargetPath = $ahkExe
$Shortcut.Arguments = "`"$ahkScript`""
$Shortcut.WorkingDirectory = $installDir
$Shortcut.IconLocation = "`"$ahkExe`", 0"
$Shortcut.Save()

Write-Host "⚡ Step 5: Activating SpaceToggle OS V11.0 Core Matrix..." -ForegroundColor Cyan
$argStr = "`"$ahkScript`""
Start-Process -FilePath $ahkExe -ArgumentList $argStr
Write-Host "✅ SUCCESS! Compiled Matrix Framework is active and loaded." -ForegroundColor Green

# --- STEP 6: README GENERATION & GIT PUSH ---
$cb = [char]96 + [char]96 + [char]96
$readmeContent = @"
# SpaceToggle OS 🚀 — V11.0 Flat Matrix

> **SPACE + INITIAL of your desired app = BOOM! It opens. Press the same combination again... BOOM! It closes.**

SpaceToggle OS is a lightning-fast, minimalist window manager for Windows, powered by the high-performance AutoHotkey v2 runtime layer.

## 🚀 The Core Matrix One-Liner

${cb}powershell
irm https://raw.githubusercontent.com/nur-arpon/SpaceToggle-OS/main/install.v.11.ps1 | iex
${cb}

### 🛠️ How to Install in 10 Seconds
1. Click on the Windows Search Bar, type **PowerShell**, right-click it, and select **Run as Administrator**.
2. Copy the single-line installation command from above.
3. Paste it directly into your terminal and hit **ENTER**.

### 🔄 Core Navigation & System Layer Modifiers
* **To Cycle Profiles:** Hold Space and tap Right Alt.
* **Secure Boss Key Sweep:** Hold Space and tap Esc.
* **Multi-Corner Fluid PiP:** Hold Space and tap Backtick.
* **Smart Field Auto-Focus:** Hold Space and tap Comma (,).
* **Dynamic Glass Opacity:** Hold Space and Scroll Wheel Up/Down.
"@
$readmeContent | Set-Content -Path "README.md" -Encoding UTF8 -Force

# We rename the current execution script state to a versioned installer for GitHub
$scriptSourcePath = $PSCommandPath
if ([string]::IsNullOrWhiteSpace($scriptSourcePath)) {
    $scriptSourcePath = $MyInvocation.MyCommand.Path
}
if ([string]::IsNullOrWhiteSpace($scriptSourcePath) -and $PSScriptRoot) {
    $candidate = Join-Path $PSScriptRoot (Split-Path -Leaf $PSCommandPath)
    if (Test-Path $candidate) { $scriptSourcePath = $candidate }
}
if (-not [string]::IsNullOrWhiteSpace($scriptSourcePath) -and (Test-Path $scriptSourcePath)) {
    Get-Content $scriptSourcePath -ErrorAction SilentlyContinue | Set-Content "install.v.11.ps1" -Encoding UTF8 -Force -ErrorAction SilentlyContinue
} else {
    # fallback: write the in-memory $scriptContent to an installer file so clones can use it
    try { $scriptContent | Set-Content -Path "install.v.11.ps1" -Encoding UTF8 -Force } catch { Write-Host "⚠️ Could not write installer file locally." -ForegroundColor Yellow }
}

if (Test-Path ".git") {
    # Determine whether this machine is the canonical host for the repo before pushing
    $gitRemoteUrl = ""
    try { $gitRemoteUrl = (git config --get remote.origin.url) -join "`n" } catch {}
    $isHost = $false
    if ($gitRemoteUrl -and $gitRemoteUrl -match "nur-arpon/SpaceToggle-OS") { $isHost = $true }

    if ($isHost) {
        Write-Host "📤 Step 6: Pushing changes back to GitHub from host..." -ForegroundColor Green
        $CurrentTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        git add .
        git commit -m "Auto-Sync Engine Build V11.0.0 (Flat Architecture Secure): $CurrentTimestamp" 2>&1 | Out-Null

        # Automated Tagging Logic
        git tag -a "V11.0" -m "Production Release V11.0" 2>$null

        git push origin main 2>&1 | Out-Null
        git push origin V11.0 2>&1 | Out-Null

        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ SUCCESS! Configurations perfectly mirrored to GitHub." -ForegroundColor Green
        } else {
            Write-Host "⚠️ Warning: Could not push to GitHub. Check your Git credentials or upstream status." -ForegroundColor Yellow
        }
    } else {
        Write-Host "ℹ️ Not the host device for this repository — skipping automatic pushes." -ForegroundColor Cyan
    }
=======
# ==============================================================================
# SpaceToggle OS - V11.0 Flat Deployment Matrix (Hardened)
# ==============================================================================
Clear-Host
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
if ($PSVersionTable.PSVersion.Major -ge 5) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}
Write-Host "🚀 Initializing Secure SpaceToggle OS V11.0 Execution..." -ForegroundColor Cyan

# --- STEP 1: DIRECTORY SETUP & GIT PULL ---
$targetDir = "D:\GITHUB PROJECT\gemini 3.0"
$fallbackDir = Join-Path $env:USERPROFILE "SpaceToggle_Workspace"
$repoPath = if (Test-Path "D:\") { $targetDir } else { $fallbackDir }

if (!(Test-Path $repoPath)) {
    New-Item -ItemType Directory -Force -Path $repoPath | Out-Null
}
Set-Location -Path $repoPath -ErrorAction Stop

if (Test-Path ".git") {
    Write-Host "🔄 Fetching latest cloud configurations from GitHub..." -ForegroundColor Cyan
    git pull origin main --rebase 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "🧹 Pruning legacy scripts from tracking database..." -ForegroundColor Yellow
        git rm "install-v*.ps1" "Builder.ps1" --ignore-unmatch 2>$null
    }
}
Remove-Item -Path "install-v*.ps1", "Builder.ps1" -Force -ErrorAction SilentlyContinue

# --- STEP 2: ENGINE RUNTIME SETUP ---
Write-Host "⚙️ Step 2: Preparing Engine Runtime Environment..." -ForegroundColor Cyan
Get-Process "SpaceToggleRuntime" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

$installDir = "$env:LOCALAPPDATA\SpaceToggleOS"
if (!(Test-Path $installDir)) {
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
}

$ahkExe = "$installDir\SpaceToggleRuntime.exe"
$ahkScript = "$installDir\SpaceToggleV11.ahk"

if (!(Test-Path $ahkExe)) {
    Write-Host "📦 Downloading AutoHotkey Core..." -ForegroundColor Yellow
    $zipFile = "$installDir\ahk.zip"
    $zipUrl = "https://github.com/AutoHotkey/AutoHotkey/releases/download/v2.0.18/AutoHotkey_2.0.18.zip" 
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $installDir -Force
    Remove-Item -Path $zipFile -Force
    Rename-Item -Path "$installDir\AutoHotkey64.exe" -NewName "SpaceToggleRuntime.exe" -ErrorAction SilentlyContinue
}

# --- STEP 3: WRITING SECURE AHK PAYLOAD ---
Write-Host "🛠️ Step 3: Compiling Exception-Safe SpaceToggle Script..." -ForegroundColor Yellow

$scriptContent = @'
#Requires AutoHotkey v2.0
#SingleInstance Force
ListLines 0
KeyHistory 0
SendMode "Input"
SetWorkingDir A_ScriptDir

; --- Performance Tier Enhancements ---
SetWinDelay(-1)
ProcessSetPriority("High")

; --- Core Engine State (Super-Globals) ---
Global IsSpaceModifier := false
Global SpaceAborted    := false
Global ActiveProfile   := "Founders"
Global ProfilesList    := ["Founders", "Gamers", "Professionals"]
Global ProfileIndex    := 1
Global GuideHUD        := unset
Global NotificationHUD := unset
Global PiP_Cache       := Map()
Global BossKey_Cache   := []

Scale(pixels) {
    return Max(1, Round(pixels * (A_ScreenDPI / 96)))
}

ApplyLiquidGlassStyle(hwnd) {
    ; Attribute 33: Corner Preference (3 = Rounded)
    ; Attribute 38: Backdrop Type (3 = Acrylic Sheet)
    ; Attribute 34: Border Color (0x40FFFFFF = 25% Opacity White Specular Edge)
    ; Attribute 35: Caption Color (Deep Black)
    DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "UInt", 33, "Int*", 3, "UInt", 4)
    DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "UInt", 38, "Int*", 3, "UInt", 4)
    DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "UInt", 34, "Int*", 0x40FFFFFF, "UInt", 4)
    DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "UInt", 35, "Int*", 0x010101, "UInt", 4)
    WinSetTransparent(0, hwnd)
}

CreateGuideHUD() {
    global GuideHUD
    GuideHUD := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +Owner", "SpaceToggle Guide")
    GuideHUD.BackColor := "202020"
    
    GuideHUD.SetFont("s13 cWhite Bold", "Segoe UI")
    GuideHUD.Add("Text", "Center w" Scale(340) " y" Scale(15), "🚀 SpaceToggle OS V11.0")

    GuideHUD.SetFont("s10 c00FFCC Bold", "Segoe UI")
    GuideHUD.Add("Text", "Center w" Scale(340) " y" Scale(45), "Active Layer: " StrUpper(ActiveProfile))

    GuideHUD.SetFont("s9.5 cE0E0E0 norm", "Segoe UI")
    GuideHUD.Add("Text", "Left x" Scale(40) " w" Scale(300) " y" Scale(75), "[Space + RAlt] Cycle OS Profiles")
    GuideHUD.Add("Text", "Left x" Scale(40) " w" Scale(300) " y" Scale(95), "[Space + Esc] Toggle Boss Key (Hide All)")
    GuideHUD.Add("Text", "Left x" Scale(40) " w" Scale(300) " y" Scale(115), "[Space + ``] Multi-Corner PiP Mode")
    GuideHUD.Add("Text", "Left x" Scale(40) " w" Scale(300) " y" Scale(135), "[Space + ,] Contextual Search/Input")
    GuideHUD.Add("Text", "Left x" Scale(40) " w" Scale(300) " y" Scale(155), "[Space + Scroll] Layer Opacity")
    GuideHUD.Add("Text", "Left x" Scale(40) " w" Scale(300) " y" Scale(175), "[Space + Up/Dn x2] Scroll Top/Bottom")
    
    GuideHUD.Title := "SpaceToggle Guide"
    ApplyLiquidGlassStyle(GuideHUD.Hwnd)
}

AnimateGlassHUD(hwnd, targetAlpha := 235) {
    state := { alpha: 0, velocity: 0, lastT: A_TickCount }
    ; Mass-Spring-Damper Constants (k=stiffness, c=damping)
    kStiffness := 0.18, cDamping := 0.42, mMass := 1.0
    
    fadeTimer() {
        if !WinExist(hwnd) {
            return SetTimer(fadeTimer, 0)
        }

        deltaTime := (A_TickCount - state.lastT) / 1000
        state.lastT := A_TickCount

        if (deltaTime > 0.1 || deltaTime <= 0) {
            deltaTime := 0.016
        }

        ; Physics Integration Loop
        springForce := -kStiffness * (state.alpha - targetAlpha) - (cDamping * state.velocity)
        acceleration := springForce / mMass
        state.velocity += acceleration
        state.alpha += state.velocity

        if (Abs(state.alpha - targetAlpha) < 0.1 && Abs(state.velocity) < 0.1) {
            WinSetTransparent(targetAlpha, hwnd)
            SetTimer(fadeTimer, 0)
        } else {
            WinSetTransparent(Max(0, Min(255, Round(state.alpha))), hwnd)
        }
    }
    SetTimer(fadeTimer, 16)
}

AnimateElasticRestore(hwnd, tX, tY, tW, tH) {
    ; Mass-Spring-Damper Loop for Window Geometry
    kStiffness := 0.24, cDamping := 0.58, mMass := 1.0
    WinGetPos(&origX, &origY, &origW, &origH, hwnd)
    state := { x: origX, y: origY, w: origW, h: origH, vX: 0, vY: 0, vW: 0, vH: 0 }

    restoreLoop() {
        if !WinExist(hwnd) {
            return SetTimer(restoreLoop, 0)
        }

        fX := -kStiffness * (state.x - tX) - (cDamping * state.vX), aX := fX / mMass, state.vX += aX, state.x += state.vX
        fY := -kStiffness * (state.y - tY) - (cDamping * state.vY), aY := fY / mMass, state.vY += aY, state.y += state.vY
        fW := -kStiffness * (state.w - tW) - (cDamping * state.vW), aW := fW / mMass, state.vW += aW, state.w += state.vW
        fH := -kStiffness * (state.h - tH) - (cDamping * state.vH), aH := fH / mMass, state.vH += aH, state.h += state.vH

        if (Abs(state.x - tX) < 1 && Abs(state.vX) < 1) {
            WinMove(tX, tY, tW, tH, hwnd)
            SetTimer(restoreLoop, 0)
        } else {
            WinMove(Round(state.x), Round(state.y), Round(state.w), Round(state.h), hwnd)
        }
    }
    SetTimer(restoreLoop, 16)
}

ToggleGuideHUD(show) {
    global
    if (show) {
        if (IsSet(GuideHUD) && IsObject(GuideHUD)) {
            GuideHUD.Destroy()
        }
        CreateGuideHUD()
        activeHwnd := WinExist("A")
        currentMon := activeHwnd ? GetMonitorFromWindowOrigin(activeHwnd) : 1
        
        workLeft := 0, workTop := 0, workRight := 0, workBottom := 0
        MonitorGetWorkArea(currentMon, &workLeft, &workTop, &workRight, &workBottom)
        
        posX := workLeft + ((workRight - workLeft) / 2) - Scale(170)
        posY := workBottom - Scale(260) 
        
        if (IsSet(GuideHUD) && IsObject(GuideHUD)) {
            GuideHUD.Show("X" posX " Y" posY " W" Scale(340) " H" Scale(195) " NoActivate")
            AnimateGlassHUD(GuideHUD.Hwnd, 235)
        }
    } else {
        if (IsSet(GuideHUD) && IsObject(GuideHUD)) {
            GuideHUD.Destroy()
        }
    }
}

CreateNotificationHUD(message) {
    global
    if (IsSet(NotificationHUD) && IsObject(NotificationHUD)) {
        NotificationHUD.Destroy()
    }
    NotificationHUD := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +Owner", "SpaceToggle Alert")
    NotificationHUD.BackColor := "202020"
    NotificationHUD.SetFont("s11 cWhite Bold", "Segoe UI")
    NotificationHUD.Add("Text", "Center w" Scale(360) " y" Scale(12), message)

    ApplyLiquidGlassStyle(NotificationHUD.Hwnd)

    activeHwnd := WinExist("A")
    currentMon := activeHwnd ? GetMonitorFromWindowOrigin(activeHwnd) : 1

    workLeft := 0, workTop := 0, workRight := 0, workBottom := 0
    MonitorGetWorkArea(currentMon, &workLeft, &workTop, &workRight, &workBottom)
    
    posX := workLeft + ((workRight - workLeft) / 2) - Scale(180)
    posY := workBottom - Scale(100)
    NotificationHUD.Show("X" posX " Y" posY " W" Scale(360) " H" Scale(45) " NoActivate")
    AnimateGlassHUD(NotificationHUD.Hwnd, 245)

    SetTimer(() => (IsSet(NotificationHUD) && IsObject(NotificationHUD) ? NotificationHUD.Destroy() : ""), -1800)
}

GetSanitizedTitle(hwnd) {
    try {
        title := WinGetTitle(hwnd)
        if (title == "") {
            title := WinGetProcessName(hwnd)
        }
        if (StrLen(title) > 22) {
            title := SubStr(title, 1, 19) "..."
        }
        return title
    } catch Error {
        return "Unknown Target"
    }
}

HasProtocol(proto) {
    try {
        RegRead("HKCR\" proto, "URL Protocol")
        return true
    } catch Error {
        return false
    }
}

GetMonitorFromWindowOrigin(hwnd) {
    try {
        WinGetPos(&x, &y, &w, &h, hwnd)
        centerX := x + (w / 2)
        centerY := y + (h / 2)
        loop MonitorGetCount() {
            left := 0, top := 0, right := 0, bottom := 0
            MonitorGet(A_Index, &left, &top, &right, &bottom)
            if (centerX >= left && centerX < right && centerY >= top && centerY < bottom)
                return A_Index
        }
    } catch Error {
        return 1
    }
    return 1
}

ResolvePath(exeTarget) {
    if (exeTarget == "")
        return ""
    if (exeTarget = "Discord.exe" && HasProtocol("discord"))
        return "discord://"
    if (exeTarget = "Spotify.exe" && HasProtocol("spotify"))
        return "spotify://"
    if (exeTarget = "WhatsApp.exe" && HasProtocol("whatsapp"))
        return "whatsapp://"
    if (exeTarget = "steam.exe" && HasProtocol("steam"))
        return "steam://"

    l := EnvGet("LOCALAPPDATA"), a := EnvGet("APPDATA"), p := EnvGet("ProgramFiles"), p86 := EnvGet("ProgramFiles(x86)")
    paths := []

    switch exeTarget, false {
        case "brave.exe": paths := [p "\BraveSoftware\Brave-Browser\Application\brave.exe", l "\BraveSoftware\Brave-Browser\Application\brave.exe"]
        case "chrome.exe": paths := [p "\Google\Chrome\Application\chrome.exe", l "\Google\Chrome\Application\chrome.exe"]
        case "obs64.exe": paths := [p "\obs-studio\bin\64bit\obs64.exe", p86 "\obs-studio\bin\64bit\obs64.exe"]
        case "excel.exe": paths := [p "\Microsoft Office\root\Office16\EXCEL.EXE", p86 "\Microsoft Office\root\Office16\EXCEL.EXE"]
        case "powerpnt.exe": paths := [p "\Microsoft Office\root\Office16\POWERPNT.EXE"]
        case "outlook.exe": paths := [p "\Microsoft Office\root\Office16\OUTLOOK.EXE"]
        case "Photoshop.exe": paths := [p "\Adobe\Adobe Photoshop 2026\Photoshop.exe", p "\Adobe\Adobe Photoshop 2025\Photoshop.exe", p "\Adobe\Adobe Photoshop 2024\Photoshop.exe"]
        case "LeagueClient.exe": paths := ["C:\Riot Games\League of Legends\LeagueClient.exe"]
        case "EpicGamesLauncher.exe": paths := [p86 "\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe", p "\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe"]
        case "blender.exe": paths := [p "\Blender Foundation\Blender\blender.exe"]
        case "Canva.exe": paths := [l "\Programs\Canva\Canva.exe"]
        case "Resolve.exe": paths := [p "\Blackmagic Design\DaVinci Resolve\Resolve.exe"]
        case "slack.exe": paths := [l "\Programs\slack\slack.exe"]
        case "Telegram.exe": paths := [a "\Telegram Desktop\Telegram.exe"]
        case "uTorrent.exe": paths := [a "\uTorrent\uTorrent.exe"]
        case "vlc.exe": paths := [p "\VideoLAN\VLC\vlc.exe", p86 "\VideoLAN\VLC\vlc.exe"]
        case "Zoom.exe": paths := [a "\Zoom\bin\Zoom.exe"]
        case "notepad.exe": paths := ["C:\Windows\System32\notepad.exe"]
        case "Notion.exe": paths := [l "\Programs\Notion\Notion.exe"]
        case "wt.exe": paths := [l "\Microsoft\WindowsApps\wt.exe"]
        case "RadeonSoftware.exe": paths := [p "\AMD\CNext\CNext\RadeonSoftware.exe"]
        case "MSIAfterburner.exe": paths := [p86 "\MSI Afterburner\MSIAfterburner.exe"]
    }

    for path in paths {
        if FileExist(path)
            return path
    }

        ; Resilient fallback: try common vendor patterns dynamically (search highest-versioned folders)
        try {
            if (exeTarget = "Photoshop.exe") {
                Loop Files p "\Adobe\Adobe Photoshop *\Photoshop.exe", "R" {
                    return A_LoopFilePath
                }
            }
            if (exeTarget = "brave.exe") {
                Loop Files p "\BraveSoftware\Brave-Browser\Application\brave.exe", "R" {
                    return A_LoopFilePath
                }
            }
        } catch Error {
            ; ignore and continue to registry fallbacks
        }

    try {
        regPath := RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" exeTarget)
        if FileExist(regPath)
            return regPath
    } catch Error {
        ; Ignore Exception
    }
    
    try {
        regPath := RegRead("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" exeTarget)
        if FileExist(regPath)
            return regPath
    } catch Error {
        ; Ignore Exception
    }

    return ""
}

RunBrowser(url) {
    brave := ResolvePath("brave.exe")
    chrome := ResolvePath("chrome.exe")
    if (brave != "")
        Run('"' brave '" "' url '"')
    else if (chrome != "")
        Run('"' chrome '" "' url '"')
    else
        Run(url)
}

SmartCascade(TargetApp:="", TargetWeb:="", FoundersApp:="", FoundersWeb:="") {
    global
    SpaceAborted := true
    
    if (TargetApp != "") {
        if (TargetApp = "explorer.exe") {
            if WinExist("ahk_class CabinetWClass") {
                if WinActive("ahk_class CabinetWClass") {
                    WinMinimize("ahk_class CabinetWClass")
                    CreateNotificationHUD("🗕 Minimized: File Explorer")
                } else {
                    WinActivate("ahk_class CabinetWClass")
                    CreateNotificationHUD("🗖 Focused: File Explorer")
                }
                return
            } else {
                Run("explorer.exe")
                CreateNotificationHUD("🚀 Launched: File Explorer")
                return
            }
        }

        try {
            hwnds := WinGetList("ahk_exe " TargetApp)
            for hwnd in hwnds {
                if (WinGetStyle(hwnd) & 0x10000000) { 
                    cleanName := GetSanitizedTitle(hwnd)
                    if WinActive(hwnd) {
                        WinMinimize(hwnd)
                        CreateNotificationHUD("🗕 Minimized: " cleanName)
                    } else {
                        WinActivate(hwnd)
                        WinShow(hwnd)
                        CreateNotificationHUD("🗖 Focused: " cleanName)
                    }
                    return
                }
            }
        } catch Error {
            ; Ignore Error
        }
        
        resolved := (TargetApp != "") ? ResolvePath(TargetApp) : ""
        if (resolved != "") {
            try { 
                Run(InStr(resolved, "://") ? resolved : '"' resolved '"') 
                CreateNotificationHUD("🚀 Launched: " TargetApp)
                return
            } catch Error {
                ; Ignore Error
            }
        }
    }

    if (TargetWeb != "") {
        try { 
            RunBrowser(TargetWeb) 
            CreateNotificationHUD("🌐 Navigating: " SubStr(TargetWeb, 9, 20) "...")
            return
        } catch Error {
            ; Ignore Error
        }
    }

    if (FoundersApp != "") {
        try {
            fHwnds := WinGetList("ahk_exe " FoundersApp)
            for hwnd in fHwnds {
                if (WinGetStyle(hwnd) & 0x10000000) {
                    cleanName := GetSanitizedTitle(hwnd)
                    if WinActive(hwnd) {
                        WinMinimize(hwnd)
                        CreateNotificationHUD("🗕 Fallback Minimized: " cleanName)
                    } else {
                        WinActivate(hwnd)
                        WinShow(hwnd)
                        CreateNotificationHUD("🗖 Fallback Focused: " cleanName)
                    }
                    return
                }
            }
        } catch Error {
            ; Ignore Error
        }
        
        resolvedFounders := ResolvePath(FoundersApp)
        if (resolvedFounders != "") {
            try { 
                Run(InStr(resolvedFounders, "://") ? resolvedFounders : '"' resolvedFounders '"') 
                CreateNotificationHUD("🚀 Fallback Init: " FoundersApp)
                return
            } catch Error {
                ; Ignore Error
            }
        }
    }

    if (FoundersWeb != "") {
        try { 
            RunBrowser(FoundersWeb) 
            CreateNotificationHUD("🌐 Fallback Web: " SubStr(FoundersWeb, 9, 20) "...")
            return
        } catch Error {
            ; Ignore Error
        }
    }
}

RouteShortcut(key) {
    Static Founders := Map(
        "a", ["", "https://gemini.google.com"],
        "b", ["brave.exe", ""],
        "c", ["chrome.exe", ""],
        "d", ["Discord.exe", ""],
        "e", ["", "https://docs.google.com/spreadsheets"],
        "f", ["explorer.exe", ""],
        "g", ["", "https://mail.google.com"],
        "h", ["", "https://github.com"],
        "i", ["", "https://instagram.com"],
        "j", ["", "https://docs.google.com"],
        "k", ["", "https://calendar.google.com"],
        "l", ["", "https://linkedin.com"],
        "m", ["", "https://cinemaos.live/"],
        "n", ["", "https://keep.google.com"],
        "o", ["", "https://drive.google.com"],
        "p", ["", "https://photos.google.com"],
        "q", ["", "https://notebooklm.google.com"],
        "r", ["", "https://reddit.com"],
        "s", ["Spotify.exe", ""],
        "t", ["wt.exe", ""],
        "u", ["uTorrent.exe", ""],
        "v", ["vlc.exe", ""],
        "w", ["WhatsApp.exe", ""],
        "x", ["", "https://x.com"],
        "y", ["", "https://youtube.com"],
        "z", ["Zoom.exe", ""]
    )

    Static Gamers := Map(
        "a", ["RadeonSoftware.exe", ""],
        "b", ["Battle.net.exe", ""],
        "c", ["cs2.exe", ""],
        "d", ["Discord.exe", ""],
        "e", ["EpicGamesLauncher.exe", ""],
        "f", ["FortniteClient-Win64-Shipping.exe", ""],
        "g", ["NVIDIA GeForce Experience.exe", ""],
        "h", ["HaloInfinite.exe", ""],
        "i", ["itch.exe", ""],
        "j", ["", ""],
        "k", ["", ""],
        "l", ["LeagueClient.exe", ""],
        "m", ["MSIAfterburner.exe", ""],
        "n", ["NVIDIA app.exe", ""],
        "o", ["obs64.exe", ""],
        "p", ["TslGame.exe", ""],
        "q", ["", ""],
        "r", ["", "https://reddit.com"],
        "s", ["steam.exe", ""],
        "t", ["", "https://twitch.tv"],
        "u", ["uTorrent.exe", ""],
        "v", ["", ""],
        "w", ["", ""],
        "x", ["Xbox.exe", ""],
        "y", ["", "https://gaming.youtube.com"],
        "z", ["", ""]
    )

    Static Professionals := Map(
        "a", ["Photoshop.exe", ""],
        "b", ["blender.exe", ""],
        "c", ["Canva.exe", ""],
        "d", ["Resolve.exe", ""],
        "e", ["excel.exe", ""],
        "f", ["explorer.exe", ""],
        "g", ["", "https://github.com"],
        "h", ["", "https://github.com"],
        "i", ["Illustrator.exe", ""],
        "j", ["idea64.exe", ""],
        "k", ["", ""],
        "l", ["", "https://linkedin.com"],
        "m", ["", ""],
        "n", ["Notion.exe", ""],
        "o", ["outlook.exe", ""],
        "p", ["powerpnt.exe", ""],
        "q", ["", ""],
        "r", ["", "https://reddit.com"],
        "s", ["slack.exe", ""],
        "t", ["Telegram.exe", ""],
        "u", ["", ""],
        "v", ["", ""],
        "w", ["", ""],
        "x", ["", ""],
        "y", ["", ""],
        "z", ["", ""]
    )

    fApp := Founders.Has(key) ? Founders[key][1] : ""
    fWeb := Founders.Has(key) ? Founders[key][2] : ""

    if (ActiveProfile = "Founders" && Founders.Has(key)) {
        SmartCascade(Founders[key][1], Founders[key][2], "", "")
    } else if (ActiveProfile = "Gamers" && Gamers.Has(key)) {
        SmartCascade(Gamers[key][1], Gamers[key][2], fApp, fWeb)
    } else if (ActiveProfile = "Professionals" && Professionals.Has(key)) {
        SmartCascade(Professionals[key][1], Professionals[key][2], fApp, fWeb)
    }
}

TogglePiP() {
    global
    SpaceAborted := true
    hwnd := WinExist("A")
    if !hwnd
        return
    try {
        currentWindowClass := WinGetClass(hwnd)
        if (currentWindowClass = "WorkerW" || currentWindowClass = "Progman" || currentWindowClass = "Shell_TrayWnd" || currentWindowClass = "AutoHotkeyGUI")
            return
            
        cleanName := GetSanitizedTitle(hwnd)
        targetMonitor := GetMonitorFromWindowOrigin(hwnd)
        
        workLeft := 0, workTop := 0, workRight := 0, workBottom := 0
        MonitorGetWorkArea(targetMonitor, &workLeft, &workTop, &workRight, &workBottom)
        
        pipW := (workRight - workLeft) / 2
        pipH := (workBottom - workTop) / 2
            
        if PiP_Cache.Has(hwnd) {
            state := PiP_Cache[hwnd]
            state.PositionIndex += 1
            
            if (state.PositionIndex == 1) {
                WinMove(workLeft + pipW, workTop, pipW, pipH, hwnd)
                CreateNotificationHUD("📐 PiP Top-Right: " cleanName)
            } else if (state.PositionIndex == 2) {
                WinMove(workLeft + pipW, workTop + pipH, pipW, pipH, hwnd)
                CreateNotificationHUD("📐 PiP Bottom-Right: " cleanName)
            } else if (state.PositionIndex == 3) {
                WinMove(workLeft, workTop + pipH, pipW, pipH, hwnd)
                CreateNotificationHUD("📐 PiP Bottom-Left: " cleanName)
            } else {
                WinSetStyle(state.OriginalStyle, hwnd)
                WinSetAlwaysOnTop(0, hwnd)
                if (state.WasMaximized) {
                    WinMaximize(hwnd)
                } else {
                    WinMove(state.OriginalX, state.OriginalY, state.OriginalW, state.OriginalH, hwnd)
                }
                PiP_Cache.Delete(hwnd)
                CreateNotificationHUD("↩️ Frame Restored: " cleanName)
            }
        } else {
            style := WinGetStyle(hwnd)
            isMax := WinGetMinMax(hwnd)
            WinGetPos(&x, &y, &w, &h, hwnd)
            
            if (isMax = 1) {
                WinRestore(hwnd)
            }
            
            PiP_Cache[hwnd] := {OriginalStyle: style, OriginalX: x, OriginalY: y, OriginalW: w, OriginalH: h, PositionIndex: 0, WasMaximized: (isMax=1)}
            
            WinSetStyle("-0xC40000", hwnd) 
            WinSetAlwaysOnTop(1, hwnd)
            
            WinMove(workLeft, workTop, pipW, pipH, hwnd)
            CreateNotificationHUD("📺 PiP Top-Left: " cleanName)
        }
    } catch Error {
        return
    }
}

ToggleBossKey() {
    global
    SpaceAborted := true
    if (BossKey_Cache.Length > 0) {
        for item in BossKey_Cache {
            if WinExist(item.hwnd) {
                WinShow(item.hwnd)
                if (item.max)
                    WinMaximize(item.hwnd)
                else
                    AnimateElasticRestore(item.hwnd, item.x, item.y, item.w, item.h)
            }
        }
        BossKey_Cache := []
        CreateNotificationHUD("🔓 Workspace Restored")
    } else {
        winList := WinGetList()
        gHwnd := IsSet(GuideHUD) ? GuideHUD.Hwnd : 0
        nHwnd := IsSet(NotificationHUD) ? NotificationHUD.Hwnd : 0
        
        for hwnd in winList {
            if !WinExist(hwnd) || hwnd == gHwnd || hwnd == nHwnd
                continue
            try {
                style := WinGetStyle(hwnd)
                currentWindowClass := WinGetClass(hwnd)
                isMax := (WinGetMinMax(hwnd) == 1)
                WinGetPos(&x, &y, &w, &h, hwnd)
                
                if (style & 0x10000000) && (currentWindowClass != "WorkerW") && (currentWindowClass != "Progman") && (currentWindowClass != "Shell_TrayWnd") && (currentWindowClass != "AutoHotkeyGUI") {
                    BossKey_Cache.Push({hwnd: hwnd, x: x, y: y, w: w, h: h, max: isMax})
                    WinHide(hwnd)
                    WinMinimize(hwnd)
                }
            } catch Error {
                continue
            }
        }
        CreateNotificationHUD("🔒 Boss Key Engaged")
    }
}

FocusInputEngine() {
    global
    SpaceAborted := true
    if !(activeHwnd := WinExist("A"))
        return
        
    try {
        procName := WinGetProcessName(activeHwnd)
        winTitle := WinGetTitle(activeHwnd)
        
        ; Check for Web-App Context inside Browsers first
        if (InStr(procName, "chrome") || InStr(procName, "brave") || InStr(procName, "msedge") || InStr(procName, "firefox")) {
            if InStr(winTitle, "Gemini") {
                ; Gemini doesn't have a global search hotkey, usually Tab or clicking. 
                ; We send 'Escape' to clear focus, then 'Shift+Tab' often lands on the input.
                Send("{Esc}")
                Sleep(50)
                Send("i") ; Common shortcut for some AI inputs or just typing
                CreateNotificationHUD("✨ Gemini Input Focused")
                return
            } else if InStr(winTitle, "YouTube") {
                Send("/")
                CreateNotificationHUD("📺 YouTube Search Focused")
                return
            } else if InStr(winTitle, "Spotify") {
                Send("/")
                CreateNotificationHUD("🎵 Spotify Search Focused")
                return
            } else if (winTitle = "New Tab" || winTitle = "Home") {
                Send("^l") ; Address bar only on Home/New Tab
                CreateNotificationHUD("🌍 Browser Address Bar")
                return
            }
            ; Default for other websites: try common search shortcut
            Send("/")
        } else if InStr(procName, "WhatsApp") {
            Send("^f") ; WhatsApp App search
        } else if InStr(procName, "Discord") {
            Send("^k") ; Discord Quick Switcher / Search
        } else if InStr(procName, "explorer") {
            Send("^e") ; File Explorer Search
        } else {
            Send("^f") ; Generic Find/Search
        }
        CreateNotificationHUD("🎯 Search/Input Focused")
    } catch Error {
        return
    }
}

*Space:: {
    global
    if (IsSpaceModifier)
        return
    IsSpaceModifier := true
    SpaceAborted    := false
    SetTimer(() => (IsSpaceModifier && !SpaceAborted) ? ToggleGuideHUD(true) : "", -300)
}

*Space up:: {
    global
    IsSpaceModifier := false
    ToggleGuideHUD(false)
    if (!SpaceAborted)
        Send("{Blind}{Space}")
}

#HotIf IsSpaceModifier
*Up:: {
    Static LastUp := 0
    global SpaceAborted := true
    if (A_TickCount - LastUp < 400) {
        Send("^{Home}")
        CreateNotificationHUD("⤒ Scrolled to Top")
        LastUp := 0
    } else {
        LastUp := A_TickCount
    }
}

*Down:: {
    Static LastDn := 0
    global SpaceAborted := true
    if (A_TickCount - LastDn < 400) {
        Send("^{End}")
        CreateNotificationHUD("⤓ Scrolled to Bottom")
        LastDn := 0
    } else {
        LastDn := A_TickCount
    }
}

*RAlt:: {
    global
    SpaceAborted := true
    global ProfileIndex := (ProfileIndex >= ProfilesList.Length) ? 1 : ProfileIndex + 1
    global ActiveProfile := ProfilesList[ProfileIndex]
    CreateNotificationHUD("👤 OS Layer Active: " ActiveProfile)
}

*Esc::ToggleBossKey()
*SC029::TogglePiP()
*,::FocusInputEngine()

WheelUp:: {
    global
    SpaceAborted := true
    try {
        activeHwnd := WinExist("A")
        if !activeHwnd
            return
        currTrans := WinGetTransparent(activeHwnd)
        trans := (currTrans == "" || currTrans == -1) ? 255 : currTrans

        trans += 15
        if (trans > 255)
            trans := 255
        WinSetTransparent(trans, "A")
    } catch Error {
        return
    }
}

WheelDown:: {
    global
    SpaceAborted := true
    try {
        activeHwnd := WinExist("A")
        if !activeHwnd
            return
        currTrans := WinGetTransparent(activeHwnd)
        trans := (currTrans == "" || currTrans == -1) ? 255 : currTrans

        trans -= 15
        if (trans < 60)
            trans := 60
        WinSetTransparent(trans, "A")
    } catch Error {
        return
    }
}

*a::RouteShortcut("a")
*b::RouteShortcut("b")
*c::RouteShortcut("c")
*d::RouteShortcut("d")
*e::RouteShortcut("e")
*f::RouteShortcut("f")
*g::RouteShortcut("g")
*h::RouteShortcut("h")
*i::RouteShortcut("i")
*j::RouteShortcut("j")
*k::RouteShortcut("k")
*l::RouteShortcut("l")
*m::RouteShortcut("m")
*n::RouteShortcut("n")
*o::RouteShortcut("o")
*p::RouteShortcut("p")
*q::RouteShortcut("q")
*r::RouteShortcut("r")
*s::RouteShortcut("s")
*t::RouteShortcut("t")
*u::RouteShortcut("u")
*v::RouteShortcut("v")
*w::RouteShortcut("w")
*x::RouteShortcut("x")
*y::RouteShortcut("y")
*z::RouteShortcut("z")
#HotIf
'@
$scriptContent | Set-Content -Path $ahkScript -Encoding UTF8 -Force

Write-Host "⚙️ Step 4: Registering Native Startup Hooks..." -ForegroundColor Yellow
$WshShell = New-Object -ComObject WScript.Shell
$StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\SpaceToggleV11.lnk" 

$Shortcut = $WshShell.CreateShortcut($StartupPath)
$Shortcut.TargetPath = $ahkExe
$Shortcut.Arguments = "`"$ahkScript`""
$Shortcut.WorkingDirectory = $installDir
$Shortcut.IconLocation = "`"$ahkExe`", 0"
$Shortcut.Save()

Write-Host "⚡ Step 5: Activating SpaceToggle OS V11.0 Core Matrix..." -ForegroundColor Cyan
$argStr = "`"$ahkScript`""
Start-Process -FilePath $ahkExe -ArgumentList $argStr
Write-Host "✅ SUCCESS! Compiled Matrix Framework is active and loaded." -ForegroundColor Green

# --- STEP 6: README GENERATION & GIT PUSH ---
$cb = [char]96 + [char]96 + [char]96
$readmeContent = @"
# SpaceToggle OS 🚀 — V11.0 Flat Matrix

> **SPACE + INITIAL of your desired app = BOOM! It opens. Press the same combination again... BOOM! It closes.**

SpaceToggle OS is a lightning-fast, minimalist window manager for Windows, powered by the high-performance AutoHotkey v2 runtime layer.

## 🚀 The Core Matrix One-Liner

${cb}powershell
irm https://raw.githubusercontent.com/nur-arpon/SpaceToggle-OS/main/install.v.11.ps1 | iex
${cb}

### 🛠️ How to Install in 10 Seconds
1. Click on the Windows Search Bar, type **PowerShell**, right-click it, and select **Run as Administrator**.
2. Copy the single-line installation command from above.
3. Paste it directly into your terminal and hit **ENTER**.

### 🔄 Core Navigation & System Layer Modifiers
* **To Cycle Profiles:** Hold Space and tap Right Alt.
* **Secure Boss Key Sweep:** Hold Space and tap Esc.
* **Multi-Corner Fluid PiP:** Hold Space and tap Backtick.
* **Smart Field Auto-Focus:** Hold Space and tap Comma (,).
* **Dynamic Glass Opacity:** Hold Space and Scroll Wheel Up/Down.
"@
$readmeContent | Set-Content -Path "README.md" -Encoding UTF8 -Force

# We rename the current execution script state to a versioned installer for GitHub
$scriptSourcePath = $PSCommandPath
if ([string]::IsNullOrWhiteSpace($scriptSourcePath)) {
    $scriptSourcePath = $MyInvocation.MyCommand.Path
}
if ([string]::IsNullOrWhiteSpace($scriptSourcePath) -and $PSScriptRoot) {
    $candidate = Join-Path $PSScriptRoot (Split-Path -Leaf $PSCommandPath)
    if (Test-Path $candidate) { $scriptSourcePath = $candidate }
}
if (-not [string]::IsNullOrWhiteSpace($scriptSourcePath) -and (Test-Path $scriptSourcePath)) {
    Get-Content $scriptSourcePath -ErrorAction SilentlyContinue | Set-Content "install.v.11.ps1" -Encoding UTF8 -Force -ErrorAction SilentlyContinue
} else {
    # fallback: write the in-memory $scriptContent to an installer file so clones can use it
    try { $scriptContent | Set-Content -Path "install.v.11.ps1" -Encoding UTF8 -Force } catch { Write-Host "⚠️ Could not write installer file locally." -ForegroundColor Yellow }
}

if (Test-Path ".git") {
    # Determine whether this machine is the canonical host for the repo before pushing
    $gitRemoteUrl = ""
    try { $gitRemoteUrl = (git config --get remote.origin.url) -join "`n" } catch {}
    $isHost = $false
    if ($gitRemoteUrl -and $gitRemoteUrl -match "nur-arpon/SpaceToggle-OS") { $isHost = $true }

    if ($isHost) {
        Write-Host "📤 Step 6: Pushing changes back to GitHub from host..." -ForegroundColor Green
        $CurrentTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        git add .
        git commit -m "Auto-Sync Engine Build V11.0.0 (Flat Architecture Secure): $CurrentTimestamp" 2>&1 | Out-Null

        # Automated Tagging Logic
        git tag -a "V11.0" -m "Production Release V11.0" 2>$null

        git push origin main 2>&1 | Out-Null
        git push origin V11.0 2>&1 | Out-Null

        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ SUCCESS! Configurations perfectly mirrored to GitHub." -ForegroundColor Green
        } else {
            Write-Host "⚠️ Warning: Could not push to GitHub. Check your Git credentials or upstream status." -ForegroundColor Yellow
        }
    } else {
        Write-Host "ℹ️ Not the host device for this repository — skipping automatic pushes." -ForegroundColor Cyan
    }
>>>>>>> f0f8c1d (Sync Engine Build V11.5: 2026-05-31 16:32:53)
}
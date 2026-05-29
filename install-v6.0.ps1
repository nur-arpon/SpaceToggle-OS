# ==============================================================================
# SpaceToggle OS (V6.1 Liquid Glass Apex Engine & Auto-Sync)
# ==============================================================================

Write-Host "🔄 Step 1: Syncing remote configurations via Git..." -ForegroundColor Cyan
if (Test-Path ".git") { git pull origin main --rebase }

Write-Host "⚙️ Step 2: Terminating active performance layers..." -ForegroundColor Cyan
Stop-Process -Name "AutoHotkey64" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
Start-Sleep -Seconds 1

$installDir = "$env:LOCALAPPDATA\SpaceToggleOS"
if (!(Test-Path $installDir)) { New-Item -ItemType Directory -Force -Path $installDir | Out-Null }
$ahkExe = "$installDir\AutoHotkey64.exe"
$ahkScript = "$installDir\SpaceToggleV6.ahk"
$zipFile = "$installDir\ahk.zip"

Write-Host "📦 Step 3: Verifying AutoHotkey Engine Runtime Core..." -ForegroundColor Yellow
$zipUrl = "https://github.com/AutoHotkey/AutoHotkey/releases/download/v2.0.18/AutoHotkey_2.0.18.zip"
if (!(Test-Path $ahkExe)) {
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $installDir -Force
    Remove-Item -Path $zipFile -Force
}

Clear-Host
Write-Host @"
=========================================================================================================
  ███████  ██████   █████  ██████  ███████       ████████  ██████   ██████   ██████  ██       ███████
 ██       ██   ██ ██   ██ ██      ██                ██    ██    ██ ██       ██       ██       ██
  ███████  ██████  ███████ ██      █████             ██    ██    ██ ██  ███  ██  ███  ██       █████
       ██ ██      ██   ██ ██      ██                ██    ██    ██ ██   ██  ██   ██  ██       ██
  ███████ ██      ██   ██  ██████ ███████           ██     ██████   ██████   ██████  ███████  ███████
                                V6.1.0 LIQUID GLASS APEX ENGINE
=========================================================================================================
"@ -ForegroundColor DarkCyan

Write-Host "🚀 Compiling Unified V6 Liquid Glass Engine with Nitro Purge..." -ForegroundColor Cyan

$coreEngine = @'
#Requires AutoHotkey v2.0
SetTitleMatchMode 2
ListLines 0
KeyHistory 0
A_KeyDelay := -1
A_MouseDelay := -1
SetWinDelay(-1)
SetControlDelay(-1)

; --- FORCE ADMINISTRATIVE ELEVATION ---
if !A_IsAdmin {
    try {
        Run('*RunAs "' A_ScriptFullPath '"')
        ExitApp()
    }
}

; --- GLOBAL STATE ENGINE ---
Global IsSpaceModifier := false
Global SpaceAborted    := false
Global CurrentProfile  := "Founders"
Global PathCache       := Map()
Global HUD_Gui         := ""
Global Guide_Gui       := ""
Global TargetTrans     := 255
Global GuideTextCtrl1  := ""
Global GuideTextCtrl2  := ""
Global GuideTitleCtrl  := ""

OnError(LogFault)
LogFault(exception, mode) {
    try {
        FileAppend("Fault: " exception.Message " Line: " exception.Line "`n", EnvGet("LOCALAPPDATA") "\SpaceToggleOS\faultsV6.log")
    }
    return 1
}

ProcessSetPriority("Realtime")

; --- APEX NITRO MEMORY PURGE LAYER ---
NitroPurge() {
    try {
        DllCall("psapi.dll\EmptyWorkingSet", "Ptr", -1)
        targets := ["chrome.exe", "brave.exe", "discord.exe", "whatsapp.exe", "teams.exe"]
        for processName in targets {
            for proc in ComObject("WbemScripting.SWbemLocator").ConnectServer().ExecQuery("Select * from Win32_Process Where Name='" processName "'") {
                try {
                    hProcess := DllCall("OpenProcess", "UInt", 0x1F0FFF, "Int", 0, "UInt", proc.ProcessId, "Ptr")
                    if hProcess {
                        DllCall("psapi.dll\EmptyWorkingSet", "Ptr", hProcess)
                        DllCall("CloseHandle", "Ptr", hProcess)
                    }
                }
            }
        }
    }
}

; --- DEEP REGISTRY PATH RESOLVER ---
ResolvePath(exeTarget) {
    l := EnvGet("LOCALAPPDATA"), a := EnvGet("APPDATA"), p := EnvGet("ProgramFiles"), p86 := EnvGet("ProgramFiles(x86)")
    paths := []
    switch exeTarget {
        case "brave.exe": paths := [p "\BraveSoftware\Brave-Browser\Application\brave.exe", l "\BraveSoftware\Brave-Browser\Application\brave.exe"]
        case "chrome.exe": paths := [p "\Google\Chrome\Application\chrome.exe", l "\Google\Chrome\Application\chrome.exe"]
        case "Discord.exe": paths := [l "\Discord\Update.exe", p "\Discord\Discord.exe"]
        case "Spotify.exe": paths := [a "\Spotify\Spotify.exe", l "\Microsoft\WindowsApps\Spotify.exe"]
        case "WhatsApp.exe": paths := [l "\WhatsApp\WhatsApp.exe", l "\Microsoft\WindowsApps\WhatsApp.exe"]
        case "steam.exe": paths := [p86 "\Steam\steam.exe", p "\Steam\steam.exe"]
        case "obs64.exe": paths := [p "\obs-studio\bin\64bit\obs64.exe"]
    }
    for path in paths {
        if FileExist(path)
            return path
    }
    try return RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" exeTarget, "")
    try return RegRead("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" exeTarget, "")
    return ""
}

BootScanner() {
    targets := ["brave.exe", "chrome.exe", "Discord.exe", "Spotify.exe", "WhatsApp.exe", "steam.exe", "obs64.exe"]
    for t in targets
        PathCache[t] := ResolvePath(t)
}
BootScanner()

; --- ADVANCED INTERACTION MANAGER ---
SmartLaunch(exeTarget, runCommand, webFallback := "") {
    Global SpaceAborted := true
    res := PathCache.Has(exeTarget) ? PathCache[exeTarget] : ""
    ident := "ahk_exe " exeTarget

    if (exeTarget = "WhatsApp.exe") {
        if WinExist("WhatsApp ahk_class ApplicationFrameWindow")
            ident := "WhatsApp ahk_class ApplicationFrameWindow"
        else if WinExist("WhatsApp")
            ident := "WhatsApp"
    }

    if (res != "" && WinExist(ident)) {
        if WinActive(ident)
            PostMessage(0x0112, 0xF020, 0, , ident)
        else
            WinActivate(ident)
        return
    }
    if (res != "") {
        try {
            if (exeTarget == "Discord.exe" && InStr(res, "Update.exe"))
                Run('"' res '" --processStart Discord.exe')
            else
                Run('"' res '"')
            return
        }
    }
    try {
        Run(runCommand)
    } catch {
        if (webFallback != "")
            Run(webFallback)
    }
}

; --- WINDOWS AUDIO SWAPPING LAYER ---
CycleAudioDevice() {
    Global SpaceAborted := true
    try {
        Run("control mmsys.cpl sounds")
        if WinWait("Sound", , 1) {
            WinActivate("Sound")
            Send("{Down}{Alt down}s{Alt up}{Enter}")
        }
    }
    CreateNotificationHUD("🔊 Audio Output Swapped")
}

; --- LIQUID GLASS DWM HUD ENGINE ---
ApplyLiquidGlassStyle(hwnd) {
    DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "UInt", 33, "Ptr*", 3, "UInt", 4)
    DllCall("user32\SetWindowLong", "Ptr", hwnd, "Int", -20, "Ptr", DllCall("user32\GetWindowLong", "Ptr", hwnd, "Int", -20) | 0x80000)
}

CreateNotificationHUD(MessageString) {
    Global HUD_Gui
    static Alpha := 0
    if (HUD_Gui) try HUD_Gui.Destroy()

    HUD_Gui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    HUD_Gui.BackColor := "111116"
    ApplyLiquidGlassStyle(HUD_Gui.Hwnd)

    HUD_Gui.SetFont("s12 c00FFCC", "Segoe UI Semibold")
    HUD_Gui.Add("Text", "w340 Center", MessageString)
    HUD_Gui.Show("NoActivate xCenter y840")

    Alpha := 0
    SetTimer(FadeIn, 10)

    FadeIn() {
        Alpha += 30
        if (Alpha >= 235) {
            Alpha := 235
            SetTimer(FadeIn, 0)
            SetTimer(() => SetTimer(FadeOut, 10), -1200)
        }
        DllCall("user32\SetLayeredWindowAttributes", "Ptr", HUD_Gui.Hwnd, "UInt", 0, "Byte", Alpha, "UInt", 2)
    }
    FadeOut() {
        Alpha -= 20
        if (Alpha <= 0) {
            SetTimer(FadeOut, 0)
            try HUD_Gui.Destroy()
        }
        try DllCall("user32\SetLayeredWindowAttributes", "Ptr", HUD_Gui.Hwnd, "UInt", 0, "Byte", Alpha, "UInt", 2)
    }
}

; --- DYNAMIC INTEGRATED CHEATSHEET MAPPER ---
ToggleGuideHUD(state) {
    Global Guide_Gui, CurrentProfile, GuideTextCtrl1, GuideTextCtrl2, GuideTitleCtrl
    if (!state) {
        if (Guide_Gui) {
            try Guide_Gui.Destroy()
            Guide_Gui := ""
        }
        return
    }

    t1 := "", t2 := ""
    if (CurrentProfile == "Founders") {
        t1 := "[B] Brave  •  [C] Chrome  •  [D] Discord  •  [S] Spotify  •  [W] WhatsApp"
        t2 := "[F] Files Explorer  •  [O] OBS Studio  •  [A] Gemini AI  •  [Y] YouTube"
    } else if (CurrentProfile == "Gamers") {
        t1 := "[S] Steam  •  [D] Discord  •  [O] OBS Studio  •  [A] Cycle Audio"
        t2 := "⚡ NITRO RAM PURGE ACTIVE  •  STABLE PERFORMANCE RUNTIME ⚡"
    } else {
        t1 := "[E] Excel  •  [P] PowerPoint  •  [N] Notion  •  [L] LinkedIn"
        t2 := "💼 ENTERPRISE WORKSPACE MAPPING ENGINE ACTIVE"
    }

    if (Guide_Gui) {
        GuideTitleCtrl.Value := "✨ SPACE TOGGLE LAYER: " StrUpper(CurrentProfile) " ✨"
        GuideTextCtrl1.Value := t1
        GuideTextCtrl2.Value := t2
        return
    }

    Guide_Gui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    Guide_Gui.BackColor := "111116"
    ApplyLiquidGlassStyle(Guide_Gui.Hwnd)

    Guide_Gui.SetFont("s13 c00E5FF", "Segoe UI Semibold")
    GuideTitleCtrl := Guide_Gui.Add("Text", "w520 Center Y+15", "✨ SPACE TOGGLE LAYER: " StrUpper(CurrentProfile) " ✨")
    Guide_Gui.SetFont("s9.5 cA0A5C0", "Segoe UI")
    GuideTextCtrl1 := Guide_Gui.Add("Text", "w520 Center Y+8", t1)
    GuideTextCtrl2 := Guide_Gui.Add("Text", "w520 Center Y+4", t2)

    Guide_Gui.Show("NoActivate xCenter y250")
    DllCall("user32\SetLayeredWindowAttributes", "Ptr", Guide_Gui.Hwnd, "UInt", 0, "Byte", 230, "UInt", 2)
}

; --- DUAL-ROLE HOTKEY HOOK MATRIX ---
*Space:: {
    Global IsSpaceModifier := true
    Global SpaceAborted    := false
    SetTimer(() => (IsSpaceModifier && !SpaceAborted) ? ToggleGuideHUD(true) : "", -300)
}

*Space up:: {
    Global IsSpaceModifier := false
    ToggleGuideHUD(false)
    if (!SpaceAborted) {
        Send("{Blind}{Space}")
    }
}

#HotIf IsSpaceModifier
; --- PROFILE SWITCHER WITH NITRO CONTROL ---
RAlt:: {
    Global CurrentProfile, SpaceAborted := true

    if (CurrentProfile == "Founders") {
        CurrentProfile := "Gamers"
        NitroPurge()
        CreateNotificationHUD("🚀 GAMER APEX MODE (RAM STRIPPED)")
    } else if (CurrentProfile == "Gamers") {
        CurrentProfile := "Professionals"
        CreateNotificationHUD("💼 PROFESSIONAL PLATFORM ENGINE")
    } else {
        CurrentProfile := "Founders"
        CreateNotificationHUD("⚡ FOUNDERS NAVIGATION LAYER")
    }
    if (Guide_Gui) {
        ToggleGuideHUD(true)
    }
}

; --- CORE INTERACTION HOTKEYS ---
a::(CurrentProfile == "Gamers") ? CycleAudioDevice() : Run("https://gemini.google.com")
b::SmartLaunch("brave.exe", "brave.exe")
c::SmartLaunch("chrome.exe", "chrome.exe")
d::SmartLaunch("Discord.exe", "discord://")
s::(CurrentProfile == "Gamers") ? SmartLaunch("steam.exe", "steam.exe") : SmartLaunch("Spotify.exe", "spotify:")
w::SmartLaunch("WhatsApp.exe", "whatsapp://")
o::SmartLaunch("obs64.exe", "obs")
f:: {
    Global SpaceAborted := true
    (WinExist("ahk_class CabinetWClass")) ? (WinActive("ahk_class CabinetWClass") ? PostMessage(0x0112, 0xF020, 0, , "ahk_class CabinetWClass") : WinActivate("ahk_class CabinetWClass")) : Run("explorer.exe")
}

; --- HARDWARE WINDOW ENGINE MANIPULATORS ---
Up:: {
    Global SpaceAborted := true
    SoundSetVolume("+4")
}
Down:: {
    Global SpaceAborted := true
    SoundSetVolume("-4")
}
MButton:: {
    Global SpaceAborted := true
    WinSetAlwaysOnTop(-1, "A")
}
WheelUp:: {
    Global SpaceAborted := true, TargetTrans
    TargetTrans := Min(TargetTrans + 15, 255)
    WinSetTransparent(TargetTrans, "A")
}
WheelDown:: {
    Global SpaceAborted := true, TargetTrans
    TargetTrans := Max(TargetTrans - 15, 60)
    WinSetTransparent(TargetTrans, "A")
}
#HotIf
'@

$coreEngine | Set-Content -Path $ahkScript -Encoding UTF8 -Force

Write-Host "⚙️ Aligning Startup parameters..." -ForegroundColor Yellow
$WshShell = New-Object -ComObject WScript.Shell
$StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\SpaceToggleV6.lnk"
$Shortcut = $WshShell.CreateShortcut($StartupPath)
$Shortcut.TargetPath = $ahkExe
$Shortcut.Arguments = "`"$ahkScript`""
$Shortcut.WorkingDirectory = $installDir
$Shortcut.IconLocation = "`"$ahkExe`", 0"
$Shortcut.Save()

Write-Host "⚡ Starting SpaceToggle OS V6.1.0 Liquid Glass Engine..." -ForegroundColor Cyan
Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkScript`""

Write-Host "📤 Step 4: Mirroring structural shifts back to GitHub Cloud..." -ForegroundColor Green
if (Test-Path ".git") {
    $CurrentTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git add .
    git commit -m "Engine Upgrade: V6.1.0 Apex Core - Zero-Flicker Liquid Glass HUD & Dynamic Profiling ($CurrentTimestamp)"
    git push origin main
}
Write-Host "✅ DEPLOYMENT COMPLETE & Cloud SYNCED!" -ForegroundColor Green

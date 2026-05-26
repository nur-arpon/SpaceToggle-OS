#Requires AutoHotkey v2.0
SetTitleMatchMode 2

; =========================================================================
; SpaceToggle OS - Universal App Launcher with Web Fallbacks
; Hold Spacebar + Press a letter to instantly toggle applications.
; Works regardless of where apps are installed!
; If app not found, opens web version in default browser.
; =========================================================================

; ── Toggle a desktop app by exe name ──────────────────────────────────────
LaunchApp(appName, protocol := "") {
    if WinExist("ahk_exe " appName) {
        if WinActive("ahk_exe " appName)
            WinMinimize("ahk_exe " appName)
        else
            WinActivate("ahk_exe " appName)
        return
    }
    try { Run(appName) ; direct execution (works if exe is in PATH)
          return }
    if (protocol != "") {
        try { Run(protocol)
              return }
    }
    commonPaths := [
        "C:\Program Files\" appName,
        "C:\Program Files (x86)\" appName,
        A_AppData "\..\Local\" appName,
        A_AppData "\" appName,
        A_ProgramFiles "\" appName
    ]
    for path in commonPaths {
        if FileExist(path) {
            try { Run(path)
                  return }
        }
    }
    result := SearchPath(appName)
    if (result != "") {
        try { Run(result) }
    }
}

; ── Search system PATH and common dirs for an exe ─────────────────────────
; FIX: was `loop parse, A_Temp` — A_Temp is the temp folder, not the PATH.
;      EnvGet("PATH") returns the actual system/user PATH variable.
SearchPath(exeName) {
    envPath := EnvGet("PATH")
    loop parse, envPath, ";" {
        if (A_LoopField = "")
            continue
        fullPath := A_LoopField "\" exeName
        if FileExist(fullPath)
            return fullPath
    }
    commonDirs := [
        "C:\Program Files",
        "C:\Program Files (x86)",
        A_AppData "\..\Local",
        A_AppData "\..\Roaming",
        A_ProgramFiles,
        A_DesktopCommon
    ]
    for dir in commonDirs {
        if DirExist(dir) {
            loop files, dir "\*\" exeName, "R" {
                return A_LoopFileFullPath
            }
        }
    }
    return ""
}

; ── Open a URL in the user's default browser ──────────────────────────────
OpenInBrowser(url) {
    try {
        Run(url)
    } catch {
        try { Run("brave.exe " url) }
        catch { try { Run("chrome.exe " url) } }
    }
}

; ==========================================================================
#HotIf GetKeyState("Space", "P")

; A ── Google Gemini (AI)
a:: { OpenInBrowser("https://gemini.google.com") }

; B ── Brave Browser  (falls back to Chrome if not installed)
b:: {
    if WinExist("ahk_exe brave.exe") {
        if WinActive("ahk_exe brave.exe") WinMinimize
        else WinActivate
    } else {
        result := SearchPath("brave.exe")
        if (result != "") Run(result)
        else LaunchApp("chrome.exe")
    }
}

; C ── Chrome
c:: {
    if WinExist("ahk_exe chrome.exe") {
        if WinActive("ahk_exe chrome.exe") WinMinimize
        else WinActivate
    } else {
        LaunchApp("chrome.exe")
    }
}

; D ── Discord  (web fallback)
d:: {
    if WinExist("ahk_exe Discord.exe") {
        if WinActive("ahk_exe Discord.exe") WinMinimize
        else WinActivate
    } else {
        result := SearchPath("Discord.exe")
        if (result != "") Run(result)
        else OpenInBrowser("https://discord.com/app")
    }
}

; E ── Google Sheets
e:: { OpenInBrowser("https://sheets.google.com") }

; F ── File Explorer
; NOTE: explorer.exe is always running (it IS the Windows shell), so we check
;       for the CabinetWClass window class instead of the process name.
f:: {
    if WinExist("ahk_class CabinetWClass") {
        if WinActive("ahk_class CabinetWClass") WinMinimize("ahk_class CabinetWClass")
        else WinActivate("ahk_class CabinetWClass")
    } else {
        Run("explorer.exe")
    }
}

; G ── Gmail
g:: { OpenInBrowser("https://mail.google.com") }

; H ── GitHub
h:: { OpenInBrowser("https://www.github.com") }

; I ── Instagram
i:: { OpenInBrowser("https://www.instagram.com") }

; J ── Google Docs
j:: { OpenInBrowser("https://docs.google.com") }

; K ── Google Calendar
k:: { OpenInBrowser("https://calendar.google.com") }

; L ── LinkedIn
l:: { OpenInBrowser("https://www.linkedin.com") }

; M ── Cinema OS
m:: { OpenInBrowser("https://cinemaos.live/") }

; N ── Google Keep (Notes)
n:: { OpenInBrowser("https://keep.google.com") }

; O ── Google Drive
o:: { OpenInBrowser("https://drive.google.com") }

; P ── Google Photos
p:: { OpenInBrowser("https://photos.google.com") }

; Q ── Steam  [App → steam:// protocol → Steam web store]
q:: {
    if WinExist("ahk_exe steam.exe") {
        if WinActive("ahk_exe steam.exe") WinMinimize
        else WinActivate
    } else {
        result := SearchPath("steam.exe")
        if (result != "") {
            Run(result)
        } else {
            try { Run("steam://open/main") }
            catch { OpenInBrowser("https://store.steampowered.com") }
        }
    }
}

; R ── Google Search
r:: { OpenInBrowser("https://www.google.com") }

; S ── Spotify  (web fallback)
s:: {
    if WinExist("ahk_exe Spotify.exe") {
        if WinActive("ahk_exe Spotify.exe") WinMinimize
        else WinActivate
    } else {
        result := SearchPath("Spotify.exe")
        if (result != "") Run(result)
        else OpenInBrowser("https://open.spotify.com")
    }
}

; T ── Terminal  (Windows Terminal → PowerShell → CMD fallback chain)
t:: {
    if WinExist("ahk_exe WindowsTerminal.exe") {
        if WinActive("ahk_exe WindowsTerminal.exe") WinMinimize
        else WinActivate
    } else if WinExist("ahk_exe powershell.exe") {
        if WinActive("ahk_exe powershell.exe") WinMinimize
        else WinActivate
    } else {
        try { Run("wt.exe") }
        catch {
            try { Run("powershell.exe") }
            catch { Run("cmd.exe") }
        }
    }
}

; U ── Google Classroom
u:: { OpenInBrowser("https://classroom.google.com") }

; V ── VLC / Windows 11 Media Player  (tries VLC first, then built-in)
v:: {
    if WinExist("ahk_exe vlc.exe") {
        if WinActive("ahk_exe vlc.exe") WinMinimize
        else WinActivate
    } else if WinExist("ahk_exe MediaPlayer.exe") {
        if WinActive("ahk_exe MediaPlayer.exe") WinMinimize
        else WinActivate
    } else if WinExist("ahk_exe wmplayer.exe") {
        if WinActive("ahk_exe wmplayer.exe") WinMinimize
        else WinActivate
    } else {
        result := SearchPath("vlc.exe")
        if (result != "") {
            Run(result)
        } else {
            ; ms-mediaplayer: launches the modern Windows 11 Media Player
            try { Run("ms-mediaplayer:") }
            catch { LaunchApp("wmplayer.exe") }
        }
    }
}

; W ── WhatsApp  (web fallback)
w:: {
    if WinExist("ahk_exe WhatsApp.exe") {
        if WinActive("ahk_exe WhatsApp.exe") WinMinimize
        else WinActivate
    } else {
        result := SearchPath("WhatsApp.exe")
        if (result != "") Run(result)
        else OpenInBrowser("https://web.whatsapp.com")
    }
}

; X ── Twitter / X
x:: { OpenInBrowser("https://www.x.com") }

; Y ── YouTube
y:: { OpenInBrowser("https://www.youtube.com") }

; Z ── Zoom  (web fallback)
z:: {
    if WinExist("ahk_exe Zoom.exe") {
        if WinActive("ahk_exe Zoom.exe") WinMinimize
        else WinActivate
    } else {
        result := SearchPath("Zoom.exe")
        if (result != "") Run(result)
        else OpenInBrowser("https://zoom.us")
    }
}

#HotIf

; Keeps the spacebar working normally while typing
~Space::Send("{Blind}{Space}{BS}")

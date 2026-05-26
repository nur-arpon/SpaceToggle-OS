#Requires AutoHotkey v2.0
SetTitleMatchMode 2

; =========================================================================
; SpaceToggle OS - Universal App Launcher with Web Fallbacks
; Hold Spacebar + Press a letter to instantly toggle applications.
; Works regardless of where apps are installed!
; If app not found, opens web version in default browser
; =========================================================================

; Helper function to find and launch app by executable name
LaunchApp(appName, protocol := "") {
    ; First, check if app is already running
    if WinExist("ahk_exe " appName) {
        if WinActive("ahk_exe " appName)
            WinMinimize("ahk_exe " appName)
        else
            WinActivate("ahk_exe " appName)
        return
    }
    
    ; If not running, try to launch it
    ; First try direct execution
    try {
        Run(appName)
        return
    }
    
    ; If that fails, try protocol (for apps like Spotify)
    if (protocol != "") {
        try {
            Run(protocol)
            return
        }
    }
    
    ; If both fail, search in common locations
    commonPaths := [
        "C:\Program Files\" appName,
        "C:\Program Files (x86)\" appName,
        A_AppData "\" appName,
        A_ProgramFiles "\" appName
    ]
    
    for path in commonPaths {
        if FileExist(path) {
            try {
                Run(path)
                return
            }
        }
    }
    
    ; Last resort: use SearchPath to find executable
    result := SearchPath(appName)
    if (result != "") {
        try {
            Run(result)
            return
        }
    }
}

; Helper function to search for executable in system PATH and common locations
SearchPath(exeName) {
    ; Search in system PATH
    envPath := A_Temp
    loop parse, A_Temp, ";"
    {
        fullPath := A_LoopField "\" exeName
        if FileExist(fullPath)
            return fullPath
    }
    
    ; Search common program directories
    commonDirs := [
        "C:\Program Files",
        "C:\Program Files (x86)",
        A_AppData,
        A_ProgramFiles,
        A_DesktopCommon
    ]
    
    for dir in commonDirs {
        if DirExist(dir) {
            loop files, dir "\*\" exeName, "R"
            {
                return A_LoopFileFullPath
            }
        }
    }
    
    return ""
}

; Helper function to open URL in default browser
OpenInBrowser(url) {
    try {
        Run(url)
    } catch {
        ; Fallback to try Brave
        try {
            Run("brave.exe " url)
        } catch {
            ; Fallback to try Chrome
            try {
                Run("chrome.exe " url)
            }
        }
    }
}

#HotIf GetKeyState("Space", "P")

; Space + A ➔ Google Gemini (AI)
a:: {
    OpenInBrowser("https://gemini.google.com")
}

; Space + B ➔ Brave Browser
b:: {
    if WinExist("ahk_exe brave.exe") {
        if WinActive("ahk_exe brave.exe")
            WinMinimize
        else
            WinActivate
    } else {
        LaunchApp("brave.exe")
    }
}

; Space + C ➔ Chrome Browser
c:: {
    if WinExist("ahk_exe chrome.exe") {
        if WinActive("ahk_exe chrome.exe")
            WinMinimize
        else
            WinActivate
    } else {
        LaunchApp("chrome.exe")
    }
}

; Space + D ➔ Discord (App) / Discord Web
d:: {
    if WinExist("ahk_exe Discord.exe") {
        if WinActive("ahk_exe Discord.exe")
            WinMinimize
        else
            WinActivate
    } else {
        ; Try desktop app first
        result := SearchPath("Discord.exe")
        if (result != "") {
            Run(result)
        } else {
            ; Fallback to web version
            OpenInBrowser("https://discord.com/app")
        }
    }
}

; Space + E ➔ Google Sheets (Excel Version)
e:: {
    OpenInBrowser("https://sheets.google.com")
}

; Space + F ➔ File Explorer
f:: {
    if WinExist("ahk_exe explorer.exe") {
        if WinActive("ahk_exe explorer.exe")
            WinMinimize
        else
            WinActivate
    } else {
        Run("explorer.exe")
    }
}

; Space + G ➔ Gmail
g:: {
    OpenInBrowser("https://mail.google.com")
}

; Space + H ➔ GitHub (Web)
h:: {
    OpenInBrowser("https://www.github.com")
}

; Space + I ➔ Instagram (Web)
i:: {
    OpenInBrowser("https://www.instagram.com")
}

; Space + J ➔ Google Docs
j:: {
    OpenInBrowser("https://docs.google.com")
}

; Space + K ➔ Google Calendar
k:: {
    OpenInBrowser("https://calendar.google.com")
}

; Space + L ➔ LinkedIn (Web)
l:: {
    OpenInBrowser("https://www.linkedin.com")
}

; Space + M ➔ Cinema OS (Movie Site)
m:: {
    OpenInBrowser("https://cinemaos.live/")
}

; Space + N ➔ Google Keep (Notes)
n:: {
    OpenInBrowser("https://keep.google.com")
}

; Space + O ➔ Google Drive
o:: {
    OpenInBrowser("https://drive.google.com")
}

; Space + P ➔ Google Photos
p:: {
    OpenInBrowser("https://photos.google.com")
}

; Space + Q ➔ Google Scholar
q:: {
    OpenInBrowser("https://scholar.google.com")
}

; Space + R ➔ Google Search
r:: {
    OpenInBrowser("https://www.google.com")
}

; Space + S ➔ Spotify (App) / Spotify Web
s:: {
    if WinExist("ahk_exe Spotify.exe") {
        if WinActive("ahk_exe Spotify.exe")
            WinMinimize
        else
            WinActivate
    } else {
        result := SearchPath("Spotify.exe")
        if (result != "") {
            Run(result)
        } else {
            ; Fallback to web version
            OpenInBrowser("https://open.spotify.com")
        }
    }
}

; Space + T ➔ Terminal (Command Prompt / PowerShell)
t:: {
    if WinExist("ahk_exe WindowsTerminal.exe") {
        if WinActive("ahk_exe WindowsTerminal.exe")
            WinMinimize
        else
            WinActivate
    } else if WinExist("ahk_exe powershell.exe") {
        if WinActive("ahk_exe powershell.exe")
            WinMinimize
        else
            WinActivate
    } else {
        LaunchApp("WindowsTerminal.exe")
    }
}

; Space + U ➔ Google Classroom
u:: {
    OpenInBrowser("https://classroom.google.com")
}

; Space + V ➔ Google Video Search
v:: {
    OpenInBrowser("https://www.google.com/videohp")
}

; Space + W ➔ WhatsApp (App) / WhatsApp Web
w:: {
    if WinExist("ahk_exe WhatsApp.exe") {
        if WinActive("ahk_exe WhatsApp.exe")
            WinMinimize
        else
            WinActivate
    } else {
        result := SearchPath("WhatsApp.exe")
        if (result != "") {
            Run(result)
        } else {
            ; Fallback to web version
            OpenInBrowser("https://web.whatsapp.com")
        }
    }
}

; Space + X ➔ Twitter / X (Web)
x:: {
    OpenInBrowser("https://www.x.com")
}

; Space + Y ➔ YouTube (Web)
y:: {
    OpenInBrowser("https://www.youtube.com")
}

; Space + Z ➔ Zoom (App) / Zoom Web
z:: {
    if WinExist("ahk_exe Zoom.exe") {
        if WinActive("ahk_exe Zoom.exe")
            WinMinimize
        else
            WinActivate
    } else {
        result := SearchPath("Zoom.exe")
        if (result != "") {
            Run(result)
        } else {
            ; Fallback to web version
            OpenInBrowser("https://zoom.us")
        }
    }
}

#HotIf

; Keeps your spacebar working normally for typing
~Space::Send("{Blind}{Space}{BS}")

#Requires AutoHotkey v2.0
SetTitleMatchMode 2

; =========================================================================
; SpaceToggle OS - Universal App Launcher
; Hold Spacebar + Press a letter to instantly toggle applications.
; Works regardless of where apps are installed!
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

#HotIf GetKeyState("Space", "P")

; Space + N ➔ Notepad
n:: {
    LaunchApp("notepad.exe")
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

; Space + S ➔ Spotify
s:: {
    if WinExist("ahk_exe Spotify.exe") {
        if WinActive("ahk_exe Spotify.exe")
            WinMinimize
        else
            WinActivate
    } else {
        LaunchApp("Spotify.exe", "spotify:")
    }
}

; Space + D ➔ Discord
d:: {
    if WinExist("ahk_exe Discord.exe") {
        if WinActive("ahk_exe Discord.exe")
            WinMinimize
        else
            WinActivate
    } else {
        LaunchApp("Discord.exe", "discord:")
    }
}

; Space + Y ➔ YouTube (Default Browser)
y:: {
    LaunchApp("brave.exe")
    sleep 1000
    Run("https://www.youtube.com")
}

; Space + W ➔ WhatsApp
w:: {
    if WinExist("ahk_exe WhatsApp.exe") {
        if WinActive("ahk_exe WhatsApp.exe")
            WinMinimize
        else
            WinActivate
    } else {
        LaunchApp("WhatsApp.exe")
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

; Space + G ➔ Google Gemini (Web)
g:: {
    LaunchApp("brave.exe")
    sleep 1000
    Run("https://gemini.google.com")
}

; Space + E ➔ Calculator
e:: {
    if WinExist("Calculator") {
        if WinActive("Calculator")
            WinMinimize
        else
            WinActivate
    } else {
        Run("calc.exe")
    }
}

#HotIf

; Keeps your spacebar working normally for typing
~Space::Send("{Blind}{Space}{BS}")

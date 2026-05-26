#Requires AutoHotkey v2.0
SetTitleMatchMode 2

; =========================================================================
; SpaceToggle OS - Minimalist Window Management
; Hold Spacebar + Press a letter to instantly toggle applications.
; =========================================================================

#HotIf GetKeyState("Space", "P")

; Space + N ➔ Notepad
n:: {
    if WinExist("ahk_exe notepad.exe") {
        if WinActive("ahk_exe notepad.exe")
            WinMinimize
        else
            WinActivate
    } else {
        Run("notepad.exe")
    }
}

; Space + B ➔ Default Browser (Chrome Example)
b:: {
    if WinExist("ahk_exe chrome.exe") {
        if WinActive("ahk_exe chrome.exe")
            WinMinimize
        else
            WinActivate
    } else {
        Run("chrome.exe")
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
        Run("spotify:") 
    }
}

; Space + C ➔ Calculator
c:: {
    if WinExist("Calculator ahk_exe ApplicationFrameHost.exe") {
        if WinActive("Calculator ahk_exe ApplicationFrameHost.exe")
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

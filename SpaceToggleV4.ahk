#Requires AutoHotkey v2.0
SetTitleMatchMode 2

OnError(LogFault)
LogFault(exception, mode) {
    try {
        FileAppend("Fault: " exception.Message " at line " exception.Line "`n", EnvGet("LOCALAPPDATA") "\SpaceToggleOS\faultsV4.log")
    }
    return 1
}

Global PathCache := Map()

ResolvePath(exeTarget) {
    l := EnvGet("LOCALAPPDATA")
    a := EnvGet("APPDATA")
    p := EnvGet("ProgramFiles")
    p86 := EnvGet("ProgramFiles(x86)")
    paths := []
    
    switch exeTarget {
        case "brave.exe": paths := [p "\BraveSoftware\Brave-Browser\Application\brave.exe", l "\BraveSoftware\Brave-Browser\Application\brave.exe"]
        case "chrome.exe": paths := [p "\Google\Chrome\Application\chrome.exe", l "\Google\Chrome\Application\chrome.exe"]
        case "WhatsApp.exe": paths := [l "\WhatsApp\WhatsApp.exe", l "\Microsoft\WindowsApps\WhatsApp.exe"]
        case "Discord.exe": paths := [l "\Discord\Update.exe", p "\Discord\Discord.exe"]
        case "steam.exe": paths := [p86 "\Steam\steam.exe", p "\Steam\steam.exe"]
    }
    
    for path in paths {
        if FileExist(path) {
            return path
        }
    }
    return ""
}

BootScanner() {
    targets := ["brave.exe", "chrome.exe", "Discord.exe", "WhatsApp.exe", "steam.exe"]
    for t in targets {
        PathCache[t] := ResolvePath(t)
    }
}
BootScanner()

SmartLaunch(exeTarget, runCommand, webFallback := "") {
    res := PathCache.Has(exeTarget) ? PathCache[exeTarget] : ""
    if (res != "" && WinExist("ahk_exe " exeTarget)) {
        if WinActive("ahk_exe " exeTarget) {
            WinMinimize("ahk_exe " exeTarget)
        } else {
            WinActivate("ahk_exe " exeTarget)
        }
        return
    }
    if (res != "") {
        try {
            if (exeTarget == "Discord.exe") {
                Run('"' res '" --processStart Discord.exe')
            } else {
                Run('"' res '"')
            }
            return
        }
    }
    try {
        Run(runCommand)
    } catch {
        if (webFallback != "") {
            Run(webFallback)
        }
    }
}

#HotIf GetKeyState("Space", "P")
b::SmartLaunch('brave.exe', 'brave.exe')
w::SmartLaunch('WhatsApp.exe', 'whatsapp://', 'https://web.whatsapp.com')
f::Run('explorer.exe')
#HotIf

*$Space:: {
    if !KeyWait("Space", "T0.2") {
        KeyWait("Space")
        return
    }
    if (A_PriorKey == "Space") {
        Send("{Space}")
    }
}

# ==============================================================================
# SpaceToggle OS - V11.0 Premium High-Curvature Monochrome Dashboard
# ==============================================================================
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- CORE DATA STRUCTURES (Sourced from install-v11_3.exe defaults) ---
$Profiles = @{
    "Founders" = @{};
    "Gamers" = @{};
    "Professionals" = @{}
}

# Pre-populate defaults
$Letters = [char[]](97..122) | ForEach-Object { [string]$_ }
foreach ($l in $Letters) {
    $Profiles["Founders"][$l] = @("", "")
    $Profiles["Gamers"][$l] = @("", "")
    $Profiles["Professionals"][$l] = @("", "")
}

# Populating specific known defaults from the install-v11_3.exe engine matrix
$Profiles["Founders"]["a"] = @("", "https://gemini.google.com")
$Profiles["Founders"]["b"] = @("brave.exe", "")
$Profiles["Founders"]["c"] = @("chrome.exe", "")
$Profiles["Founders"]["d"] = @("Discord.exe", "")
$Profiles["Founders"]["e"] = @("", "https://docs.google.com/spreadsheets")
$Profiles["Founders"]["f"] = @("explorer.exe", "")
$Profiles["Founders"]["g"] = @("", "https://mail.google.com")
$Profiles["Founders"]["h"] = @("", "https://github.com")
$Profiles["Founders"]["i"] = @("", "https://instagram.com")
$Profiles["Founders"]["j"] = @("", "https://docs.google.com")
$Profiles["Founders"]["k"] = @("", "https://calendar.google.com")
$Profiles["Founders"]["l"] = @("", "https://linkedin.com")
$Profiles["Founders"]["m"] = @("", "https://cinemaos.live/")
$Profiles["Founders"]["n"] = @("", "https://keep.google.com")
$Profiles["Founders"]["o"] = @("", "https://drive.google.com")
$Profiles["Founders"]["p"] = @("", "https://photos.google.com")
$Profiles["Founders"]["q"] = @("", "https://notebooklm.google.com")
$Profiles["Founders"]["r"] = @("", "https://reddit.com")
$Profiles["Founders"]["s"] = @("Spotify.exe", "")
$Profiles["Founders"]["t"] = @("wt.exe", "")
$Profiles["Founders"]["u"] = @("uTorrent.exe", "")
$Profiles["Founders"]["v"] = @("vlc.exe", "")
$Profiles["Founders"]["w"] = @("WhatsApp.exe", "")
$Profiles["Founders"]["x"] = @("", "https://x.com")
$Profiles["Founders"]["y"] = @("", "https://youtube.com")
$Profiles["Founders"]["z"] = @("Zoom.exe", "")

$Profiles["Gamers"]["a"] = @("RadeonSoftware.exe", "")
$Profiles["Gamers"]["b"] = @("Battle.net.exe", "")
$Profiles["Gamers"]["c"] = @("cs2.exe", "")
$Profiles["Gamers"]["d"] = @("Discord.exe", "")
$Profiles["Gamers"]["e"] = @("EpicGamesLauncher.exe", "")
$Profiles["Gamers"]["f"] = @("FortniteClient-Win64-Shipping.exe", "")
$Profiles["Gamers"]["g"] = @("NVIDIA GeForce Experience.exe", "")
$Profiles["Gamers"]["h"] = @("HaloInfinite.exe", "")
$Profiles["Gamers"]["i"] = @("itch.exe", "")
$Profiles["Gamers"]["r"] = @("", "https://reddit.com")
$Profiles["Gamers"]["s"] = @("steam.exe", "")
$Profiles["Gamers"]["t"] = @("", "https://twitch.tv")
$Profiles["Gamers"]["u"] = @("uTorrent.exe", "")
$Profiles["Gamers"]["x"] = @("Xbox.exe", "")
$Profiles["Gamers"]["y"] = @("", "https://gaming.youtube.com")

$Profiles["Professionals"]["a"] = @("Photoshop.exe", "")
$Profiles["Professionals"]["b"] = @("blender.exe", "")
$Profiles["Professionals"]["c"] = @("Canva.exe", "")
$Profiles["Professionals"]["d"] = @("Resolve.exe", "")
$Profiles["Professionals"]["e"] = @("excel.exe", "")
$Profiles["Professionals"]["f"] = @("explorer.exe", "")
$Profiles["Professionals"]["g"] = @("", "https://github.com")
$Profiles["Professionals"]["h"] = @("", "https://github.com")
$Profiles["Professionals"]["i"] = @("Illustrator.exe", "")
$Profiles["Professionals"]["j"] = @("idea64.exe", "")
$Profiles["Professionals"]["l"] = @("", "https://linkedin.com")
$Profiles["Professionals"]["n"] = @("Notion.exe", "")
$Profiles["Professionals"]["o"] = @("outlook.exe", "")
$Profiles["Professionals"]["p"] = @("powerpnt.exe", "")
$Profiles["Professionals"]["r"] = @("", "https://reddit.com")
$Profiles["Professionals"]["s"] = @("slack.exe", "")
$Profiles["Professionals"]["t"] = @("Telegram.exe", "")

# --- BUILD THE HIGH-CURVATURE INTERFACE CUSTOM FRAME ---
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "SpaceToggle OS v11.0 - Core Dashboard"
$Form.Size = New-Object System.Drawing.Size(460, 520)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = [System.Drawing.Color]::FromArgb(255, 28, 28, 30) # Premium Deep Dark Gray
$Form.ForeColor = [System.Drawing.Color]::White
$Form.FormBorderStyle = "None" # Removing native frame to enable custom extreme curvature

# --- Apply Custom Smooth Extreme Border Curvature Region (3x Curve Radius) ---
$Form.Add_Load({
    $Radius = 46 # High-profile smooth curvature radius
    $Path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $Path.StartFigure()
    $Path.AddArc(0, 0, $Radius, $Radius, 180, 90)
    $Path.AddArc(($Form.Width - $Radius), 0, $Radius, $Radius, 270, 90)
    $Path.AddArc(($Form.Width - $Radius), ($Form.Height - $Radius), $Radius, $Radius, 0, 90)
    $Path.AddArc(0, ($Form.Height - $Radius), $Radius, $Radius, 90, 90)
    $Path.CloseFigure()
    $Form.Region = New-Object System.Drawing.Region($Path)
})

# --- Fluid Window Drag Engine (Allows moving the borderless form cleanly) ---
$Global:Drag = $false
$Global:MousePos = [System.Drawing.Point]::Empty

$Drag_MouseDown = {
    if ($_.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
        $Global:Drag = $true
        $Global:MousePos = $_.Location
    }
}
$Drag_MouseMove = {
    if ($Global:Drag) {
        $screenPos = $Form.PointToScreen($_.Location)
        $Form.Location = New-Object System.Drawing.Point(($screenPos.X - $Global:MousePos.X), ($screenPos.Y - $Global:MousePos.Y))
    }
}
$Drag_MouseUp = { $Global:Drag = $false }

$Form.Add_MouseDown($Drag_MouseDown)
$Form.Add_MouseMove($Drag_MouseMove)
$Form.Add_MouseUp($Drag_MouseUp)

# --- Title Header (Monochrome Clean Styling) ---
$TitleLabel = New-Object System.Windows.Forms.Label
$TitleLabel.Text = "🚀 SPACETOGGLE OS CONTROLS"
$TitleLabel.Location = New-Object System.Drawing.Point(30, 22)
$TitleLabel.Size = New-Object System.Drawing.Size(350, 30)
$TitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$TitleLabel.ForeColor = [System.Drawing.Color]::White
$TitleLabel.Add_MouseDown($Drag_MouseDown)
$TitleLabel.Add_MouseMove($Drag_MouseMove)
$TitleLabel.Add_MouseUp($Drag_MouseUp)
$Form.Controls.Add($TitleLabel)

# --- Custom Premium Exit Node Button ---
$btnClose = New-Object System.Windows.Forms.Label
$btnClose.Text = "✕"
$btnClose.Location = New-Object System.Drawing.Point(405, 20)
$btnClose.Size = New-Object System.Drawing.Size(25, 25)
$btnClose.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$btnClose.ForeColor = [System.Drawing.Color]::DarkGray
$btnClose.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnClose.Add_MouseEnter({ $btnClose.ForeColor = [System.Drawing.Color]::White })
$btnClose.Add_MouseLeave({ $btnClose.ForeColor = [System.Drawing.Color]::DarkGray })
$btnClose.Add_Click({ $Form.Close() })
$Form.Controls.Add($btnClose)

# --- Features Group Box ---
$FeatureBox = New-Object System.Windows.Forms.GroupBox
$FeatureBox.Text = " System Features Modifiers "
$FeatureBox.Location = New-Object System.Drawing.Point(25, 65)
$FeatureBox.Size = New-Object System.Drawing.Size(408, 100)
$FeatureBox.ForeColor = [System.Drawing.Color]::LightGray
$FeatureBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)

$chkBossKey = New-Object System.Windows.Forms.CheckBox
$chkBossKey.Text = "Enable Workspace Secure Boss Key Sweep (Space + Esc)"
$chkBossKey.Location = New-Object System.Drawing.Point(20, 30)
$chkBossKey.Size = New-Object System.Drawing.Size(360, 25)
$chkBossKey.Checked = $true
$chkBossKey.ForeColor = [System.Drawing.Color]::White

$chkPiP = New-Object System.Windows.Forms.CheckBox
$chkPiP.Text = "Enable Multi-Corner Fluid PiP Window Frame (Space + ``)"
$chkPiP.Location = New-Object System.Drawing.Point(20, 60)
$chkPiP.Size = New-Object System.Drawing.Size(360, 25)
$chkPiP.Checked = $true
$chkPiP.ForeColor = [System.Drawing.Color]::White

$FeatureBox.Controls.Add($chkBossKey)
$FeatureBox.Controls.Add($chkPiP)
$Form.Controls.Add($FeatureBox)

# --- Mapping Configuration Group Box ---
$MapBox = New-Object System.Windows.Forms.GroupBox
$MapBox.Text = " Custom Matrix Mapping Engine "
$MapBox.Location = New-Object System.Drawing.Point(25, 185)
$MapBox.Size = New-Object System.Drawing.Size(408, 220)
$MapBox.ForeColor = [System.Drawing.Color]::LightGray
$MapBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)

# Profile Selector
$lblProfile = New-Object System.Windows.Forms.Label
$lblProfile.Text = "Target OS Profile Layer:"
$lblProfile.Location = New-Object System.Drawing.Point(20, 30)
$lblProfile.Size = New-Object System.Drawing.Size(150, 20)
$lblProfile.ForeColor = [System.Drawing.Color]::White

$cmbProfile = New-Object System.Windows.Forms.ComboBox
$cmbProfile.Location = New-Object System.Drawing.Point(185, 27)
$cmbProfile.Size = New-Object System.Drawing.Size(200, 25)
$cmbProfile.DropDownStyle = "DropDownList"
$cmbProfile.BackColor = [System.Drawing.Color]::FromArgb(255, 48, 48, 50)
$cmbProfile.ForeColor = [System.Drawing.Color]::White
[void]$cmbProfile.Items.AddRange(@("Founders", "Gamers", "Professionals"))
$cmbProfile.SelectedIndex = 0

# Key Trigger Selector
$lblKey = New-Object System.Windows.Forms.Label
$lblKey.Text = "Trigger Binding Key (Space + X):"
$lblKey.Location = New-Object System.Drawing.Point(20, 70)
$lblKey.Size = New-Object System.Drawing.Size(160, 20)
$lblKey.ForeColor = [System.Drawing.Color]::White

$cmbKey = New-Object System.Windows.Forms.ComboBox
$cmbKey.Location = New-Object System.Drawing.Point(185, 67)
$cmbKey.Size = New-Object System.Drawing.Size(200, 25)
$cmbKey.DropDownStyle = "DropDownList"
$cmbKey.BackColor = [System.Drawing.Color]::FromArgb(255, 48, 48, 50)
$cmbKey.ForeColor = [System.Drawing.Color]::White
[void]$cmbKey.Items.AddRange($Letters)
$cmbKey.SelectedIndex = 0

# Location Input Field (Pasting target path/URL)
$lblTarget = New-Object System.Windows.Forms.Label
$lblTarget.Text = "Paste Application Path OR Web URL:"
$lblTarget.Location = New-Object System.Drawing.Point(20, 110)
$lblTarget.Size = New-Object System.Drawing.Size(360, 20)
$lblTarget.ForeColor = [System.Drawing.Color]::White

$txtTarget = New-Object System.Windows.Forms.TextBox
$txtTarget.Location = New-Object System.Drawing.Point(20, 135)
$txtTarget.Size = New-Object System.Drawing.Size(360, 25)
$txtTarget.BackColor = [System.Drawing.Color]::FromArgb(255, 48, 48, 50)
$txtTarget.ForeColor = [System.Drawing.Color]::White

# Button to map the key inside the profile dictionary
$btnAssign = New-Object System.Windows.Forms.Button
$btnAssign.Text = "Apply Binding Configuration To Key"
$btnAssign.Location = New-Object System.Drawing.Point(20, 175)
$btnAssign.Size = New-Object System.Drawing.Size(365, 30)
$btnAssign.FlatStyle = "Flat"
$btnAssign.BackColor = [System.Drawing.Color]::FromArgb(255, 60, 60, 62)
$btnAssign.ForeColor = [System.Drawing.Color]::White
$btnAssign.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray

$MapBox.Controls.Add($lblProfile)
$MapBox.Controls.Add($cmbProfile)
$MapBox.Controls.Add($lblKey)
$MapBox.Controls.Add($cmbKey)
$MapBox.Controls.Add($lblTarget)
$MapBox.Controls.Add($txtTarget)
$MapBox.Controls.Add($btnAssign)
$Form.Controls.Add($MapBox)

# --- Master Save & Refresh Action Button (Polished Deep Solid Black Design) ---
$btnSave = New-Object System.Windows.Forms.Button
$btnSave.Text = "SAVE & ACTIVATE CHANGES"
$btnSave.Location = New-Object System.Drawing.Point(25, 425)
$btnSave.Size = New-Object System.Drawing.Size(408, 45)
$btnSave.FlatStyle = "Flat"
$btnSave.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnSave.BackColor = [System.Drawing.Color]::FromArgb(255, 12, 12, 12) # Deep Monochrome Black Accent
$btnSave.ForeColor = [System.Drawing.Color]::White
$btnSave.FlatAppearance.BorderColor = [System.Drawing.Color]::LightGray
$Form.Controls.Add($btnSave)

# --- SYSTEM DYNAMIC UPDATE LOGIC ---
$UpdateTextBox = {
    $prof = $cmbProfile.SelectedItem.ToString()
    $key  = $cmbKey.SelectedItem.ToString()
    $data = $Profiles[$prof][$key]
    if ($data[1] -ne "") { $txtTarget.Text = $data[1] }
    else { $txtTarget.Text = $data[0] }
}

$cmbProfile.Add_SelectedIndexChanged($UpdateTextBox)
$cmbKey.Add_SelectedIndexChanged($UpdateTextBox)

$btnAssign.Add_Click({
    $prof = $cmbProfile.SelectedItem.ToString()
    $key  = $cmbKey.SelectedItem.ToString()
    $val  = $txtTarget.Text.Trim()
    
    if ($val -match "^https?://") {
        $Profiles[$prof][$key] = @("", $val)
    } else {
        $Profiles[$prof][$key] = @($val, "")
    }
    [System.Windows.Forms.MessageBox]::Show("Key '$key' successfully re-mapped under the '$prof' runtime ecosystem layer!", "Matrix Assigned")
})

# Trigger initialization update loop
& $UpdateTextBox

# --- ENGINE REDEPLOYMENT LAYER ACTION ---
$btnSave.Add_Click({
    $installDir = "$env:LOCALAPPDATA\SpaceToggleOS"
    $ahkScript = "$installDir\SpaceToggleV11.ahk"
    $ahkExe = "$installDir\SpaceToggleRuntime.exe"

    if (!(Test-Path $installDir) -or !(Test-Path $ahkExe)) {
        [System.Windows.Forms.MessageBox]::Show("Could not find the core engine workspace elements at $installDir. Ensure SpaceToggle was fully run once.", "Workspace Error")
        return
    }

    # Generate the Map Block Text dynamically
    $MapBlockText = ""
    foreach ($p in "Founders", "Gamers", "Professionals") {
        $MapBlockText += "    Static $p := Map(`n"
        $lines = @()
        foreach ($k in $Letters) {
            $app = $Profiles[$p][$k][0]
            $web = $Profiles[$p][$k][1]
            $lines += "        `"$k`", [`"$app`", `"$web`"]"
        }
        $MapBlockText += ($lines -join ",`n") + "`n    )`n`n"
    }

    # Conditional Features Hook Flags
    $BossKeyHook = if ($chkBossKey.Checked) { "*Esc::ToggleBossKey()" } else { "; *Esc::ToggleBossKey() [Disabled via Dashboard]" }
    $PiPHook = if ($chkPiP.Checked) { "*SC029::TogglePiP()" } else { "; *SC029::TogglePiP() [Disabled via Dashboard]" }

    # Base Core Assembly Script (Ref: install-v11_3.exe codebase structure)
    $Payload = @"
#Requires AutoHotkey v2.0
#SingleInstance Force
ListLines 0
KeyHistory 0
SendMode "Input"
SetWorkingDir A_ScriptDir
SetWinDelay(-1)
ProcessSetPriority("High")

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
    DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "UInt", 33, "Int*", 1, "UInt", 4)
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
    GuideHUD.SetFont("s10 cFFFFFF Bold", "Segoe UI")
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
    kStiffness := 0.18, cDamping := 0.42, mMass := 1.0
    fadeTimer() {
        if !WinExist(hwnd) {
            return SetTimer(fadeTimer, 0)
        }
        deltaTime := (A_TickCount - state.lastT) / 1000
        state.lastT := A_TickCount
        if (deltaTime > 0.1 || deltaTime <= 0) { deltaTime := 0.016 }
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
    kStiffness := 0.24, cDamping := 0.58, mMass := 1.0
    WinGetPos(&origX, &origY, &origW, &origH, hwnd)
    state := { x: origX, y: origY, w: origW, h: origH, vX: 0, vY: 0, vW: 0, vH: 0 }
    restoreLoop() {
        if !WinExist(hwnd) { return SetTimer(restoreLoop, 0) }
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
        if (IsSet(GuideHUD) && IsObject(GuideHUD)) { GuideHUD.Destroy() }
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
        if (IsSet(GuideHUD) && IsObject(GuideHUD)) { GuideHUD.Destroy() }
    }
}

CreateNotificationHUD(message) {
    global
    if (IsSet(NotificationHUD) && IsObject(NotificationHUD)) { NotificationHUD.Destroy() }
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
        if (title == "") { title := WinGetProcessName(hwnd) }
        if (StrLen(title) > 22) { title := SubStr(title, 1, 19) "..." }
        return title
    } catch Error { return "Unknown Target" }
}

HasProtocol(proto) {
    try {
        RegRead("HKCR\" proto, "URL Protocol")
        return true
    } catch Error { return false }
}

GetMonitorFromWindowOrigin(hwnd) {
    try {
        WinGetPos(&x, &y, &w, &h, hwnd)
        centerX := x + (w / 2), centerY := y + (h / 2)
        loop MonitorGetCount() {
            left := 0, top := 0, right := 0, bottom := 0
            MonitorGet(A_Index, &left, &top, &right, &bottom)
            if (centerX >= left && centerX < right && centerY >= top && centerY < bottom)
                return A_Index
        }
    } catch Error { return 1 }
    return 1
}

ResolvePath(exeTarget) {
    if (exeTarget == "") { return "" }
    if (exeTarget = "Discord.exe" && HasProtocol("discord")) { return "discord://" }
    if (exeTarget = "Spotify.exe" && HasProtocol("spotify")) { return "spotify://" }
    if (exeTarget = "WhatsApp.exe" && HasProtocol("whatsapp")) { return "whatsapp://" }
    if (exeTarget = "steam.exe" && HasProtocol("steam")) { return "steam://" }
    l := EnvGet("LOCALAPPDATA"), a := EnvGet("APPDATA"), p := EnvGet("ProgramFiles"), p86 := EnvGet("ProgramFiles(x86)")
    paths := []
    switch exeTarget, false {
        case "brave.exe": paths := [p "\BraveSoftware\Brave-Browser\Application\brave.exe", l "\BraveSoftware\Brave-Browser\Application\brave.exe"]
        case "chrome.exe": paths := [p "\Google\Chrome\Application\chrome.exe", l "\Google\Chrome\Application\chrome.exe"]
        case "obs64.exe": paths := [p "\obs-studio\bin\64bit\obs64.exe", p86 "\obs-studio\bin\64bit\obs64.exe"]
        case "excel.exe": paths := [p "\Microsoft Office\root\Office16\EXCEL.EXE", p86 "\Microsoft Office\root\Office16\EXCEL.EXE"]
        case "powerpnt.exe": paths := [p "\Microsoft Office\root\Office16\POWERPNT.EXE"]
        case "outlook.exe": paths := [p "\Microsoft Office\root\Office16\OUTLOOK.EXE"]
        case "Photoshop.exe": paths := [p "\Adobe\Adobe Photoshop 2026\Photoshop.exe", p "\Adobe\Adobe Photoshop 2025\Photoshop.exe"]
        case "LeagueClient.exe": paths := ["C:\Riot Games\League of Legends\LeagueClient.exe"]
        case "EpicGamesLauncher.exe": paths := [p86 "\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe"]
        case "blender.exe": paths := [p "\Blender Foundation\Blender\blender.exe"]
        case "Canva.exe": paths := [l "\Programs\Canva\Canva.exe"]
        case "Resolve.exe": paths := [p "\Blackmagic Design\DaVinci Resolve\Resolve.exe"]
        case "slack.exe": paths := [l "\Programs\slack\slack.exe"]
        case "Telegram.exe": paths := [a "\Telegram Desktop\Telegram.exe"]
        case "uTorrent.exe": paths := [a "\uTorrent\uTorrent.exe"]
        case "vlc.exe": paths := [p "\VideoLAN\VLC\vlc.exe"]
        case "Zoom.exe": paths := [a "\Zoom\bin\Zoom.exe"]
        case "notepad.exe": paths := ["C:\Windows\System32\notepad.exe"]
        case "Notion.exe": paths := [l "\Programs\Notion\Notion.exe"]
        case "wt.exe": paths := [l "\Microsoft\WindowsApps\wt.exe"]
    }
    for path in paths {
        if FileExist(path) { return path }
    }
    try {
        regPath := RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" exeTarget)
        if FileExist(regPath) { return regPath }
    } catch Error {}
    return ""
}

RunBrowser(url) {
    brave := ResolvePath("brave.exe"), chrome := ResolvePath("chrome.exe")
    if (brave != "") { Run('"' brave '" "' url '"') }
    else if (chrome != "") { Run('"' chrome '" "' url '"') }
    else { Run(url) }
}

SmartCascade(TargetApp:="", TargetWeb:="", FoundersApp:="", FoundersWeb:="") {
    global
    SpaceAborted := true
    if (TargetApp != "") {
        if (TargetApp = "explorer.exe") {
            if WinExist("ahk_class CabinetWClass") {
                if WinActive("ahk_class CabinetWClass") {
                    WinMinimize("ahk_class CabinetWClass")
                    CreateNotificationHUD("📁 Minimized: File Explorer")
                } else {
                    WinActive("ahk_class CabinetWClass")
                    CreateNotificationHUD("📂 Focused: File Explorer")
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
                        CreateNotificationHUD("📉 Minimized: " cleanName)
                    } else {
                        WinActivate(hwnd)
                        WinShow(hwnd)
                        CreateNotificationHUD("📈 Focused: " cleanName)
                    }
                    return
                }
            }
        } catch Error {}
        resolved := (TargetApp != "") ? ResolvePath(TargetApp) : ""
        if (resolved != "") {
            try { 
                Run(InStr(resolved, "://") ? resolved : '"' resolved '"') 
                CreateNotificationHUD("🚀 Launched: " TargetApp)
                return
            } catch Error {}
        }
    }
    if (TargetWeb != "") {
        try { 
            RunBrowser(TargetWeb) 
            CreateNotificationHUD("🌐 Navigating: " SubStr(TargetWeb, 1, 25) "...")
            return
        } catch Error {}
    }
}

RouteShortcut(key) {
$MapBlockText
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
    if !hwnd { return }
    try {
        currentWindowClass := WinGetClass(hwnd)
        if (currentWindowClass = "WorkerW" || currentWindowClass = "Progman" || currentWindowClass = "Shell_TrayWnd" || currentWindowClass = "AutoHotkeyGUI")
            return
        cleanName := GetSanitizedTitle(hwnd)
        targetMonitor := GetMonitorFromWindowOrigin(hwnd)
        workLeft := 0, workTop := 0, workRight := 0, workBottom := 0
        MonitorGetWorkArea(targetMonitor, &workLeft, &workTop, &workRight, &workBottom)
        pipW := (workRight - workLeft) / 2, pipH := (workBottom - workTop) / 2
        if PiP_Cache.Has(hwnd) {
            state := PiP_Cache[hwnd]
            state.PositionIndex += 1
            if (state.PositionIndex == 1) { WinMove(workLeft + pipW, workTop, pipW, pipH, hwnd) }
            else if (state.PositionIndex == 2) { WinMove(workLeft + pipW, workTop + pipH, pipW, pipH, hwnd) }
            else if (state.PositionIndex == 3) { WinMove(workLeft, workTop + pipH, pipW, pipH, hwnd) }
            else {
                WinSetStyle(state.OriginalStyle, hwnd)
                WinSetAlwaysOnTop(0, hwnd)
                if (state.WasMaximized) { WinMaximize(hwnd) } 
                else { WinMove(state.OriginalX, state.OriginalY, state.OriginalW, state.OriginalH, hwnd) }
                PiP_Cache.Delete(hwnd)
                CreateNotificationHUD("🔄 Frame Restored: " cleanName)
            }
        } else {
            style := WinGetStyle(hwnd), isMax := WinGetMinMax(hwnd)
            WinGetPos(&x, &y, &w, &h, hwnd)
            if (isMax = 1) { WinRestore(hwnd) }
            PiP_Cache[hwnd] := {OriginalStyle: style, OriginalX: x, OriginalY: y, OriginalW: w, OriginalH: h, PositionIndex: 0, WasMaximized: (isMax=1)}
            WinSetStyle("-0xC40000", hwnd) 
            WinSetAlwaysOnTop(1, hwnd)
            WinMove(workLeft, workTop, pipW, pipH, hwnd)
            CreateNotificationHUD("📺 PiP Frame Bound: " cleanName)
        }
    } catch Error {}
}

ToggleBossKey() {
    global
    SpaceAborted := true
    if (BossKey_Cache.Length > 0) {
        for item in BossKey_Cache {
            if WinExist(item.hwnd) {
                WinShow(item.hwnd)
                if (item.max) { WinMaximize(item.hwnd) }
                else { AnimateElasticRestore(item.hwnd, item.x, item.y, item.w, item.h) }
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
                style := WinGetStyle(hwnd), currentWindowClass := WinGetClass(hwnd)
                isMax := (WinGetMinMax(hwnd) == 1)
                WinGetPos(&x, &y, &w, &h, hwnd)
                if (style & 0x10000000) && (currentWindowClass != "WorkerW") && (currentWindowClass != "Progman") && (currentWindowClass != "Shell_TrayWnd") && (currentWindowClass != "AutoHotkeyGUI") {
                    BossKey_Cache.Push({hwnd: hwnd, x: x, y: y, w: w, h: h, max: isMax})
                    WinHide(hwnd)
                    WinMinimize(hwnd)
                }
            } catch Error { continue }
        }
        CreateNotificationHUD("🔒 Workspace Swept Clean")
    }
}

FocusInputEngine() {
    global
    SpaceAborted := true
    if !(activeHwnd := WinExist("A")) { return }
    try {
        procName := WinGetProcessName(activeHwnd), winTitle := WinGetTitle(activeHwnd)
        if (InStr(procName, "chrome") || InStr(procName, "brave") || InStr(procName, "msedge")) {
            if InStr(winTitle, "Gemini") {
                Send("{Esc}")
                Sleep(50)
                Send("i")
                CreateNotificationHUD("✨ Gemini AI Input Ready")
                return
            } else if InStr(winTitle, "YouTube") || InStr(winTitle, "Spotify") {
                Send("/")
                CreateNotificationHUD("🔍 Media Context Search")
                return
            }
            Send("/")
        } else if InStr(procName, "WhatsApp") { Send("^f") }
        else if InStr(procName, "Discord") { Send("^k") }
        else if InStr(procName, "explorer") { Send("^e") }
        else { Send("^f") }
        CreateNotificationHUD("🎯 Navigation Input Active")
    } catch Error {}
}

*Space:: {
    global
    if (IsSpaceModifier) { return }
    IsSpaceModifier := true
    SpaceAborted    := false
    SetTimer(() => (IsSpaceModifier && !SpaceAborted) ? ToggleGuideHUD(true) : "", -300)
}

*Space up:: {
    global
    IsSpaceModifier := false
    ToggleGuideHUD(false)
    if (!SpaceAborted) { Send("{Blind}{Space}") }
}

#HotIf IsSpaceModifier
*Up:: {
    Static LastUp := 0
    global SpaceAborted := true
    if (A_TickCount - LastUp < 400) {
        Send("^{Home}")
        CreateNotificationHUD("⏫ Bound to Top")
        LastUp := 0
    } else { LastUp := A_TickCount }
}

*Down:: {
    Static LastDn := 0
    global SpaceAborted := true
    if (A_TickCount - LastDn < 400) {
        Send("^{End}")
        CreateNotificationHUD("⏬ Bound to Bottom")
        LastDn := 0
    } else { LastDn := A_TickCount }
}

*RAlt:: {
    global
    SpaceAborted := true
    global ProfileIndex := (ProfileIndex >= ProfilesList.Length) ? 1 : ProfileIndex + 1
    global ActiveProfile := ProfilesList[ProfileIndex]
    CreateNotificationHUD("👤 Layer Active: " ActiveProfile)
}

$BossKeyHook
$PiPHook
*,::FocusInputEngine()

WheelUp:: {
    global
    SpaceAborted := true
    try {
        activeHwnd := WinExist("A")
        if !activeHwnd { return }
        currTrans := WinGetTransparent(activeHwnd)
        trans := (currTrans == "" || currTrans == -1) ? 255 : currTrans
        trans += 15
        if (trans > 255) { trans := 255 }
        WinSetTransparent(trans, "A")
    } catch Error {}
}

WheelDown:: {
    global
    SpaceAborted := true
    try {
        activeHwnd := WinExist("A")
        if !activeHwnd { return }
        currTrans := WinGetTransparent(activeHwnd)
        trans := (currTrans == "" || currTrans == -1) ? 255 : currTrans
        trans -= 15
        if (trans < 60) { trans := 60 }
        WinSetTransparent(trans, "A")
    } catch Error {}
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
"@

    # Save changes directly down into the target AHK payload script file
    $Payload | Set-Content -Path $ahkScript -Encoding UTF8 -Force

    # Process Hot-Swap Core Reset Routine
    Get-Process "SpaceToggleRuntime" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Milliseconds 600

    if (Test-Path $ahkExe) {
        Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkScript`""
        [System.Windows.Forms.MessageBox]::Show("SpaceToggle Matrix Configurations re-compiled successfully! The active layer running in your background has been safely swapped.", "System Refreshed")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Configuration file saved, but the system executable runtime could not cycle automatically.", "Warning")
    }
})

# Display Window Layout Frame
[System.Windows.Forms.Application]::Run($Form)
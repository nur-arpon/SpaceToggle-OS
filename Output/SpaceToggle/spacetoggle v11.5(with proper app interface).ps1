<#
================================================================================
          SPACETOGGLE OS - V11.0 OMNI-INDUSTRIAL (ZERO-RECTANGLE + HARDENED KERNEL)
================================================================================
ARCHITECTURE: 100% Squircle Design | Liquid Glass Engine | Full Data Persistence
INTEGRATION: Auto-Downloads AHK | Generates App/Web Maps | Auto-Commits to GitHub
LOCATION: D:\GITHUB PROJECT\gemini  3.0
================================================================================
#>

# 1. SYSTEM INITIALIZATION & ENVIRONMENT SETUP
$ErrorActionPreference = "Stop"
Clear-Host
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
if ($PSVersionTable.PSVersion.Major -ge 5) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}
Write-Host "🚀 Initializing Secure SpaceToggle OS V11.0..." -ForegroundColor Cyan

$targetDir = "D:\GITHUB PROJECT\gemini  3.0"
if (!(Test-Path $targetDir)) {
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
}
Set-Location -Path $targetDir -ErrorAction Stop

if (Test-Path ".git") {
    Write-Host "🔄 Fetching latest cloud configurations from GitHub..." -ForegroundColor Cyan
    git pull origin main --rebase 2>&1 | Out-Null
}

Write-Host "⚙️ Preparing Engine Runtime Environment..." -ForegroundColor Cyan
$installDir = "$env:LOCALAPPDATA\SpaceToggleOS"
if (!(Test-Path $installDir)) { New-Item -ItemType Directory -Force -Path $installDir | Out-Null }

$ahkExe = "$installDir\SpaceToggleRuntime.exe"
if (!(Test-Path $ahkExe)) {
    Write-Host "📦 Downloading AutoHotkey Core..." -ForegroundColor Yellow
    $zipFile = "$installDir\ahk.zip"
    $zipUrl = "https://github.com/AutoHotkey/AutoHotkey/releases/download/v2.0.18/AutoHotkey_2.0.18.zip" 
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $installDir -Force
    Remove-Item -Path $zipFile -Force
    Rename-Item -Path "$installDir\AutoHotkey64.exe" -NewName "SpaceToggleRuntime.exe" -ErrorAction SilentlyContinue
}

# 2. GLOBAL OMNI-MATRIX (Full Data Persistence)
$Global:SpaceMatrix = [hashtable]::Synchronized(@{
    "Founders" = @{
        "a"=@("","https://gemini.google.com");"b"=@("brave.exe","");"c"=@("chrome.exe","");"d"=@("Discord.exe","")
        "e"=@("","https://docs.google.com/spreadsheets");"f"=@("explorer.exe","");"g"=@("","https://mail.google.com")
        "h"=@("","https://github.com");"i"=@("","https://instagram.com");"j"=@("","https://docs.google.com")
        "k"=@("","https://calendar.google.com");"l"=@("","https://linkedin.com");"m"=@("","https://cinemaos.live/")
        "n"=@("","https://keep.google.com");"o"=@("","https://drive.google.com");"p"=@("","https://photos.google.com")
        "q"=@("","https://notebooklm.google.com");"r"=@("","https://reddit.com");"s"=@("Spotify.exe","")
        "t"=@("wt.exe","");"u"=@("uTorrent.exe","");"v"=@("vlc.exe","");"w"=@("WhatsApp.exe","")
        "x"=@("","https://x.com");"y"=@("","https://youtube.com");"z"=@("Zoom.exe","")
    }
    "Gamers" = @{
        "a"=@("RadeonSoftware.exe","");"b"=@("Battle.net.exe","");"c"=@("cs2.exe","");"d"=@("Discord.exe","")
        "e"=@("EpicGamesLauncher.exe","");"f"=@("FortniteClient-Win64-Shipping.exe","");"g"=@("NVIDIA GeForce Experience.exe","")
        "h"=@("HaloInfinite.exe","");"i"=@("itch.exe","");"l"=@("LeagueClient.exe","");"m"=@("MSIAfterburner.exe","")
        "n"=@("NVIDIA app.exe","");"o"=@("obs64.exe","");"p"=@("TslGame.exe","");"s"=@("steam.exe","")
        "t"=@("","https://twitch.tv");"u"=@("uTorrent.exe","");"x"=@("Xbox.exe","");"y"=@("","https://gaming.youtube.com")
    }
    "Professionals" = @{
        "a"=@("Photoshop.exe","");"b"=@("blender.exe","");"c"=@("Canva.exe","");"d"=@("Resolve.exe","")
        "e"=@("excel.exe","");"f"=@("explorer.exe","");"i"=@("Illustrator.exe","");"j"=@("idea64.exe","")
        "n"=@("Notion.exe","");"o"=@("outlook.exe","");"p"=@("powerpnt.exe","");"s"=@("slack.exe","");"t"=@("Telegram.exe","")
    }
})

# 3. THE ZERO-RECTANGLE XAML
$xamlString = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="SpaceToggle OS" Height="850" Width="780" 
        WindowStyle="None" AllowsTransparency="True" Background="{x:Null}"
        WindowStartupLocation="CenterScreen" x:Name="UI">
    
    <Window.Resources>
        <Style x:Key="SquircleBtn" TargetType="Button">
            <Setter Property="Background" Value="#1A1A1F"/>
            <Setter Property="Foreground" Value="#E0E0E0"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="BorderBrush" Value="#25FFFFFF"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Name="box" Background="{TemplateBinding Background}" CornerRadius="22" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="box" Property="Background" Value="#2A2A2F"/><Setter TargetName="box" Property="BorderBrush" Value="#00FFCC"/></Trigger>
                            <Trigger Property="IsPressed" Value="True"><Setter TargetName="box" Property="Background" Value="#00FFCC"/><Setter Property="Foreground" Value="Black"/></Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="ComboBox">
            <Setter Property="Background" Value="#1C1C22"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="ComboBox">
                        <Grid>
                            <Border Name="Border" Background="#1C1C22" CornerRadius="20" BorderBrush="#33FFFFFF" BorderThickness="1"/>
                            <ToggleButton Name="ToggleButton" Background="Transparent" BorderThickness="0" IsChecked="{Binding IsDropDownOpen, Mode=TwoWay, RelativeSource={RelativeSource TemplatedParent}}">
                                <Path Fill="#00FFCC" Data="M 0 0 L 4 4 L 8 0 Z" HorizontalAlignment="Right" VerticalAlignment="Center" Margin="0,0,15,0"/>
                            </ToggleButton>
                            <ContentPresenter Margin="15,0,35,0" VerticalAlignment="Center" Content="{TemplateBinding SelectionBoxItem}" IsHitTestVisible="False"/>
                            <Popup Name="Popup" Placement="Bottom" IsOpen="{TemplateBinding IsDropDownOpen}" AllowsTransparency="True" PopupAnimation="Slide">
                                <Border Background="#1C1C22" CornerRadius="18" BorderThickness="1" BorderBrush="#33FFFFFF" MinWidth="{TemplateBinding ActualWidth}">
                                    <StackPanel IsItemsHost="True" />
                                </Border>
                            </Popup>
                        </Grid>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="ComboBoxItem">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="ComboBoxItem">
                        <Border Name="Bg" Background="{TemplateBinding Background}" CornerRadius="12" Margin="4" Padding="12">
                            <ContentPresenter />
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Bg" Property="Background" Value="#00FFCC"/><Setter Property="Foreground" Value="Black"/></Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Border Name="MainBorder" CornerRadius="50" Background="#0C0C0E" BorderBrush="#25FFFFFF" BorderThickness="2" ClipToBounds="True">
        <Grid Margin="24">
            <Grid.RowDefinitions>
                <RowDefinition Height="60"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="100"/>
            </Grid.RowDefinitions>

            <Grid Grid.Row="0" Name="TitleBar" Background="#01000000">
                <StackPanel Orientation="Horizontal" VerticalAlignment="Center" Margin="20,0">
                    <Ellipse Width="10" Height="10" Fill="#00FFCC"/>
                    <TextBlock Text="SPACETOGGLE OMNI V11.0" Foreground="#88FFFFFF" FontWeight="Bold" FontSize="11" Margin="15,0"/>
                </StackPanel>
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
                    <Button Name="BtnMin" Content="—" Width="42" Height="42" Style="{StaticResource SquircleBtn}" Margin="5,0"/>
                    <Button Name="BtnMax" Content="🗖" Width="42" Height="42" Style="{StaticResource SquircleBtn}" Margin="5,0"/>
                    <Button Name="BtnClose" Content="✕" Width="42" Height="42" Style="{StaticResource SquircleBtn}" Margin="5,0"/>
                </StackPanel>
            </Grid>

            <Grid Grid.Row="1">
                <StackPanel Name="EditView" Margin="20,10">
                    <TextBlock Text="Kernel Matrix" Foreground="White" FontSize="44" FontWeight="Bold" Margin="0,0,0,30"/>
                    <Border Background="#151519" CornerRadius="40" Padding="35">
                        <Grid>
                            <Grid.ColumnDefinitions><ColumnDefinition Width="1.618*"/><ColumnDefinition Width="1*"/></Grid.ColumnDefinitions>
                            <Grid.RowDefinitions><RowDefinition/><RowDefinition/></Grid.RowDefinitions>
                            <StackPanel Grid.Column="0" Margin="0,0,15,25">
                                <TextBlock Text="OS LAYER" Foreground="#555" FontWeight="Bold" FontSize="10" Margin="8"/>
                                <ComboBox Name="SelProf" Height="60"/>
                            </StackPanel>
                            <StackPanel Grid.Column="1" Margin="15,0,0,25">
                                <TextBlock Text="HOTKEY" Foreground="#555" FontWeight="Bold" FontSize="10" Margin="8"/>
                                <ComboBox Name="SelKey" Height="60"/>
                            </StackPanel>
                            <StackPanel Grid.Row="1" Grid.ColumnSpan="2">
                                <TextBlock Text="TARGET DESTINATION" Foreground="#555" FontWeight="Bold" FontSize="10" Margin="8"/>
                                <TextBox Name="InTarget" Height="65" Background="#1C1C22" Foreground="White" BorderBrush="#33FFFFFF" BorderThickness="1" VerticalContentAlignment="Center" Padding="25,0" FontSize="15">
                                    <TextBox.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="20"/></Style></TextBox.Resources>
                                </TextBox>
                            </StackPanel>
                        </Grid>
                    </Border>
                    <Button Name="BtnSync" Content="SYNC TO KERNEL" Height="70" Margin="0,30" Style="{StaticResource SquircleBtn}" FontWeight="ExtraBold" FontSize="16"/>
                </StackPanel>

                <Grid Name="GridView" Visibility="Collapsed">
                    <Grid.RowDefinitions><RowDefinition Height="80"/><RowDefinition Height="*"/></Grid.RowDefinitions>
                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Grid.Row="0">
                        <Button Name="GridF" Content="FOUNDERS" Width="150" Height="50" Style="{StaticResource SquircleBtn}" Margin="10,0"/>
                        <Button Name="GridG" Content="GAMERS" Width="150" Height="50" Style="{StaticResource SquircleBtn}" Margin="10,0"/>
                        <Button Name="GridP" Content="PROFESSIONALS" Width="150" Height="50" Style="{StaticResource SquircleBtn}" Margin="10,0"/>
                    </StackPanel>
                    <WrapPanel Name="AlphabetContainer" Grid.Row="1" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="10"/>
                </Grid>

                <Grid Name="PopupOverlay" Visibility="Collapsed" Background="#D8000000">
                    <Border Background="#151519" CornerRadius="45" Width="550" Height="350" VerticalAlignment="Center" BorderBrush="#00FFCC" BorderThickness="3">
                        <StackPanel VerticalAlignment="Center" Margin="40">
                            <TextBlock Name="PopupTitle" Text="EDIT ASSIGNMENT" Foreground="White" FontSize="26" FontWeight="Bold" Margin="0,0,0,25" HorizontalAlignment="Center"/>
                            <TextBox Name="PopupInput" Height="70" Background="#1C1C22" Foreground="White" Padding="25,0" VerticalContentAlignment="Center" FontSize="16">
                                <TextBox.Resources><Style TargetType="Border"><Setter Property="CornerRadius" Value="25"/></Style></TextBox.Resources>
                            </TextBox>
                            <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,35,0,0">
                                <Button Name="PopupSave" Content="SAVE MATRIX" Width="180" Height="55" Style="{StaticResource SquircleBtn}" Background="#00FFCC" Foreground="Black" Margin="15,0"/>
                                <Button Name="PopupCancel" Content="CANCEL" Width="180" Height="55" Style="{StaticResource SquircleBtn}" Margin="15,0"/>
                            </StackPanel>
                        </StackPanel>
                    </Border>
                </Grid>
            </Grid>

            <Grid Grid.Row="2" Margin="20,0">
                <Button Name="BtnCommit" Content="⚡ COMPILE APEX BUILD" Height="75" Style="{StaticResource SquircleBtn}" Background="#00FFCC" Foreground="Black" FontWeight="ExtraBold" FontSize="20"/>
            </Grid>
        </Grid>
    </Border>
</Window>
"@

# 4. INDUSTRIAL MULTI-RUNSPACE ENGINE
$ScriptBlock = {
    param($xaml, $matrix, $masterScriptPath, $gitRepoPath)
    Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase
    $DllCode = @"
    using System;
    using System.Runtime.InteropServices;
    public class DllCall {
        [DllImport("dwmapi.dll")]
        public static extern int DwmSetWindowAttribute(IntPtr hwnd, int attr, ref int val, int size);
    }
"@
    Add-Type -TypeDefinition $DllCode -ErrorAction SilentlyContinue

    $Window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader ([xml]$xaml)))

    # Bind UI Elements
    $UI_List = "BtnClose","BtnMin","BtnMax","BtnSync","BtnCommit","SelProf","SelKey","InTarget","EditView","GridView","AlphabetContainer","TitleBar","PopupOverlay","PopupTitle","PopupInput","PopupSave","PopupCancel","MainBorder","GridF","GridG","GridP"
    foreach($e in $UI_List) { Set-Variable -Name $e -Value $Window.FindName($e) -Scope Script }

    $Alphabet = [char[]](97..122) | ForEach-Object { [string]$_ }

    $SyncFields = {
        $P = $SelProf.SelectedItem; $K = $SelKey.SelectedItem
        if ($P -and $K) {
            $Data = $matrix[$P][$K]
            $InTarget.Text = if ($Data[1] -ne "") { $Data[1] } else { $Data[0] }
        }
    }

    # Populate Data
    "Founders", "Gamers", "Professionals" | ForEach-Object { [void]$SelProf.Items.Add($_) }
    $SelProf.SelectedIndex = 0
    $Alphabet | ForEach-Object { [void]$SelKey.Items.Add($_) }
    $SelKey.SelectedIndex = 0

    $SelProf.Add_SelectionChanged($SyncFields)
    $SelKey.Add_SelectionChanged($SyncFields)

    # 26-Letter Engine
    $UpdateGrid = {
        $AlphabetContainer.Children.Clear()
        $P = $SelProf.SelectedItem
        foreach ($K in $Alphabet) {
            $Map = $matrix[$P][$K]; $Path = if ($Map[1] -ne "") { $Map[1] } else { $Map[0] }
            $Card = New-Object System.Windows.Controls.Border
            $Card.Width = 175; $Card.Height = 120; $Card.Margin = 12; $Card.CornerRadius = 35; $Card.Background = "#151519"; $Card.BorderBrush = "#25FFFFFF"; $Card.BorderThickness = 1; $Card.Cursor = "Hand"
            
            $Stack = New-Object System.Windows.Controls.StackPanel; $Stack.VerticalAlignment = "Center"
            $KTxt = New-Object System.Windows.Controls.TextBlock; $KTxt.Text = $K.ToUpper(); $KTxt.Foreground = if($Path){"#00FFCC"}else{"#444"}; $KTxt.FontWeight = "Bold"; $KTxt.HorizontalAlignment = "Center"; $KTxt.FontSize = 26
            $PTxt = New-Object System.Windows.Controls.TextBlock; $PTxt.Text = if($Path){$Path}else{"---"}; $PTxt.Foreground = "#666"; $PTxt.FontSize = 10; $PTxt.HorizontalAlignment = "Center"; $PTxt.Margin = "12,6"; $PTxt.TextTrimming = "CharacterEllipsis"
            $Stack.Children.Add($KTxt); $Stack.Children.Add($PTxt); $Card.Child = $Stack
            $Card.Add_MouseDown({
                $script:ActiveK = $K
                $PopupTitle.Text = "ASSIGN KEY: " + $K.ToUpper(); $PopupInput.Text = if($Path){$Path}else{""}; $PopupOverlay.Visibility = "Visible"
            })
            $AlphabetContainer.Children.Add($Card)
        }
    }

    # Navigation & Interaction
    $GridF.Add_Click({ $SelProf.SelectedIndex = 0; & $UpdateGrid })
    $GridG.Add_Click({ $SelProf.SelectedIndex = 1; & $UpdateGrid })
    $GridP.Add_Click({ $SelProf.SelectedIndex = 2; & $UpdateGrid })

    $BtnSync.Add_Click({
        $P = $SelProf.SelectedItem; $K = $SelKey.SelectedItem; $V = $InTarget.Text.Trim()
        if ($V -match "^https?://") { $matrix[$P][$K] = @("", $V) } else { $matrix[$P][$K] = @($V, "") }
        [System.Windows.MessageBox]::Show("Matrix Memory Updated.")
    })

    $PopupSave.Add_Click({
        $P = $SelProf.SelectedItem; $K = $script:ActiveK; $V = $PopupInput.Text.Trim()
        if ($V -match "^https?://") { $matrix[$P][$K] = @("", $V) } else { $matrix[$P][$K] = @($V, "") }
        $PopupOverlay.Visibility = "Collapsed"; & $UpdateGrid; & $SyncFields
    })

    $PopupCancel.Add_Click({ $PopupOverlay.Visibility = "Collapsed" })
    $TitleBar.Add_MouseDown({ if ($_.LeftButton -eq "Pressed") { $Window.DragMove() } })
    $BtnClose.Add_Click({ $Window.Close() })
    $BtnMin.Add_Click({ $Window.WindowState = "Minimized" })
    $BtnMax.Add_Click({
        if ($Window.WindowState -eq "Maximized") {
            $Window.WindowState = "Normal"; $MainBorder.CornerRadius = 50; $EditView.Visibility = "Visible"; $GridView.Visibility = "Collapsed"
        } else {
            $Window.WindowState = "Maximized"; $MainBorder.CornerRadius = 0; $EditView.Visibility = "Collapsed"; $GridView.Visibility = "Visible"; & $UpdateGrid
        }
    })

    # AHK Kernel Compiler & Github Syncer
    $BtnCommit.Add_Click({
        $BtnCommit.Content = "COMPILING..."
        $BtnCommit.IsEnabled = $false

        $AhkDir = "$env:LOCALAPPDATA\SpaceToggleOS"
        $AhkExe = "$AhkDir\SpaceToggleRuntime.exe"
        if (!(Test-Path $AhkDir)) { New-Item $AhkDir -ItemType Directory | Out-Null }
        $Path = Join-Path $AhkDir "SpaceToggleV11.ahk"

        # Generate Dynamic Map Injection String
        $Maps = ""
        foreach ($P in "Founders", "Gamers", "Professionals") {
            $Maps += "    Static $($P) := Map(`n"
            $Entries = @()
            [char[]](97..122) | ForEach-Object { 
                $K = [string]$_; $A = $matrix[$P][$K][0].Replace("\","\\"); $W = $matrix[$P][$K][1]
                $Entries += "        `"$K`", [`"$A`", `"$W`"]" 
            }
            $Maps += ($Entries -join ",`n") + "`n    )`n`n"
        }

        # The Hardened V11.0 AHK Payload
        $Code = @"
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
    } catch Error { return 1 }
    return 1
}

ResolvePath(exeTarget) {
    if (exeTarget == "") return ""
    if (exeTarget = "Discord.exe" && HasProtocol("discord")) return "discord://"
    if (exeTarget = "Spotify.exe" && HasProtocol("spotify")) return "spotify://"
    if (exeTarget = "WhatsApp.exe" && HasProtocol("whatsapp")) return "whatsapp://"
    if (exeTarget = "steam.exe" && HasProtocol("steam")) return "steam://"

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

    try {
        if (exeTarget = "Photoshop.exe") {
            Loop Files p "\Adobe\Adobe Photoshop *\Photoshop.exe", "R" { return A_LoopFilePath }
        }
        if (exeTarget = "brave.exe") {
            Loop Files p "\BraveSoftware\Brave-Browser\Application\brave.exe", "R" { return A_LoopFilePath }
        }
    } catch Error { }

    try {
        regPath := RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" exeTarget)
        if FileExist(regPath)
            return regPath
    } catch Error { }
    
    try {
        regPath := RegRead("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" exeTarget)
        if FileExist(regPath)
            return regPath
    } catch Error { }

    return ""
}

RunBrowser(url) {
    brave := ResolvePath("brave.exe")
    chrome := ResolvePath("chrome.exe")
    if (brave != "") { Run('"' brave '" "' url '"') }
    else if (chrome != "") { Run('"' chrome '" "' url '"') }
    else { Run(url) }
}

SmartCascade(TargetApp:="", TargetWeb:="", FoundersApp:="", FoundersWeb:="") {
    global SpaceAborted := true
    
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
        } catch Error { }
        
        resolved := (TargetApp != "") ? ResolvePath(TargetApp) : ""
        if (resolved != "") {
            try { 
                Run(InStr(resolved, "://") ? resolved : '"' resolved '"') 
                CreateNotificationHUD("🚀 Launched: " TargetApp)
                return
            } catch Error { }
        }
    }

    if (TargetWeb != "") {
        try { 
            RunBrowser(TargetWeb) 
            CreateNotificationHUD("🌐 Navigating: " SubStr(TargetWeb, 9, 20) "...")
            return
        } catch Error { }
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
        } catch Error { }
        resolvedFounders := ResolvePath(FoundersApp)
        if (resolvedFounders != "") {
            try { 
                Run(InStr(resolvedFounders, "://") ? resolvedFounders : '"' resolvedFounders '"') 
                CreateNotificationHUD("🚀 Fallback Init: " FoundersApp)
                return
            } catch Error { }
        }
    }

    if (FoundersWeb != "") {
        try { 
            RunBrowser(FoundersWeb) 
            CreateNotificationHUD("🌐 Fallback Web: " SubStr(FoundersWeb, 9, 20) "...")
            return
        } catch Error { }
    }
}

RouteShortcut(key) {
$Maps
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
    global SpaceAborted := true
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
                if (state.WasMaximized) { WinMaximize(hwnd) } 
                else { WinMove(state.OriginalX, state.OriginalY, state.OriginalW, state.OriginalH, hwnd) }
                PiP_Cache.Delete(hwnd)
                CreateNotificationHUD("↩️ Frame Restored: " cleanName)
            }
        } else {
            style := WinGetStyle(hwnd)
            isMax := WinGetMinMax(hwnd)
            WinGetPos(&x, &y, &w, &h, hwnd)
            if (isMax = 1) { WinRestore(hwnd) }
            PiP_Cache[hwnd] := {OriginalStyle: style, OriginalX: x, OriginalY: y, OriginalW: w, OriginalH: h, PositionIndex: 0, WasMaximized: (isMax=1)}
            WinSetStyle("-0xC40000", hwnd) 
            WinSetAlwaysOnTop(1, hwnd)
            WinMove(workLeft, workTop, pipW, pipH, hwnd)
            CreateNotificationHUD("📺 PiP Top-Left: " cleanName)
        }
    } catch Error { }
}

ToggleBossKey() {
    global SpaceAborted := true
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
                style := WinGetStyle(hwnd)
                currentWindowClass := WinGetClass(hwnd)
                isMax := (WinGetMinMax(hwnd) == 1)
                WinGetPos(&x, &y, &w, &h, hwnd)
                if (style & 0x10000000) && (currentWindowClass != "WorkerW") && (currentWindowClass != "Progman") && (currentWindowClass != "Shell_TrayWnd") && (currentWindowClass != "AutoHotkeyGUI") {
                    BossKey_Cache.Push({hwnd: hwnd, x: x, y: y, w: w, h: h, max: isMax})
                    WinHide(hwnd)
                    WinMinimize(hwnd)
                }
            } catch Error { continue }
        }
        CreateNotificationHUD("🔒 Boss Key Engaged")
    }
}

FocusInputEngine() {
    global SpaceAborted := true
    if !(activeHwnd := WinExist("A"))
        return
    try {
        procName := WinGetProcessName(activeHwnd)
        winTitle := WinGetTitle(activeHwnd)
        if (InStr(procName, "chrome") || InStr(procName, "brave") || InStr(procName, "msedge") || InStr(procName, "firefox")) {
            if InStr(winTitle, "Gemini") {
                Send("{Esc}")
                Sleep(50)
                Send("i")
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
                Send("^l")
                CreateNotificationHUD("🌍 Browser Address Bar")
                return
            }
            Send("/")
        } else if InStr(procName, "WhatsApp") {
            Send("^f")
        } else if InStr(procName, "Discord") {
            Send("^k")
        } else if InStr(procName, "explorer") {
            Send("^e")
        } else {
            Send("^f")
        }
        CreateNotificationHUD("🎯 Search/Input Focused")
    } catch Error { }
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
    if (A_TickCount - LastUp < 400) { Send("^{Home}"); CreateNotificationHUD("⤒ Scrolled to Top"); LastUp := 0 }
    else { LastUp := A_TickCount }
}

*Down:: {
    Static LastDn := 0
    global SpaceAborted := true
    if (A_TickCount - LastDn < 400) { Send("^{End}"); CreateNotificationHUD("⤓ Scrolled to Bottom"); LastDn := 0 }
    else { LastDn := A_TickCount }
}

*RAlt:: {
    global SpaceAborted := true
    global ProfileIndex := (ProfileIndex >= ProfilesList.Length) ? 1 : ProfileIndex + 1
    global ActiveProfile := ProfilesList[ProfileIndex]
    CreateNotificationHUD("👤 OS Layer Active: " ActiveProfile)
}

*Esc::ToggleBossKey()
*SC029::TogglePiP()
*,::FocusInputEngine()

WheelUp:: {
    global SpaceAborted := true
    try {
        activeHwnd := WinExist("A")
        if !activeHwnd
            return
        currTrans := WinGetTransparent(activeHwnd)
        trans := (currTrans == "" || currTrans == -1) ? 255 : currTrans
        trans += 15
        if (trans > 255) { trans := 255 }
        WinSetTransparent(trans, "A")
    } catch Error { }
}

WheelDown:: {
    global SpaceAborted := true
    try {
        activeHwnd := WinExist("A")
        if !activeHwnd
            return
        currTrans := WinGetTransparent(activeHwnd)
        trans := (currTrans == "" || currTrans == -1) ? 255 : currTrans
        trans -= 15
        if (trans < 60) { trans := 60 }
        WinSetTransparent(trans, "A")
    } catch Error { }
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
        $Code | Set-Content $Path -Encoding UTF8 -Force

        # Stop Old Kernel
        Get-Process "SpaceToggleRuntime" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500

        # Register Startup Hook
        $WshShell = New-Object -ComObject WScript.Shell
        $StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\SpaceToggleV11.lnk" 
        $Shortcut = $WshShell.CreateShortcut($StartupPath)
        $Shortcut.TargetPath = $AhkExe
        $Shortcut.Arguments = "`"$Path`""
        $Shortcut.WorkingDirectory = $AhkDir
        $Shortcut.IconLocation = "`"$AhkExe`", 0"
        $Shortcut.Save()

        # Start Process
        Start-Process -FilePath $AhkExe -ArgumentList "`"$Path`""

        # Background GitHub Sync
        if (Test-Path $gitRepoPath) {
            Set-Location -Path $gitRepoPath
            
            # Generate README
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

            # Backup the Master Script to the Repo Directory
            if (-not [string]::IsNullOrWhiteSpace($masterScriptPath) -and (Test-Path $masterScriptPath)) {
                Get-Content $masterScriptPath -ErrorAction SilentlyContinue | Set-Content "install.v.11.ps1" -Encoding UTF8 -Force -ErrorAction SilentlyContinue
            }

            if (Test-Path ".git") {
                $CurrentTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                git add .
                git commit -m "Auto-Sync Engine Build V11.0.0 (Flat Architecture Secure): $CurrentTimestamp" 2>&1 | Out-Null
                git tag -a "V11.0" -m "Production Release V11.0" 2>$null
                git push origin main 2>&1 | Out-Null
                git push origin V11.0 2>&1 | Out-Null
            }
        }

        [System.Windows.MessageBox]::Show("Apex Kernel Synchronized and Configurations Pushed to GitHub.")
        
        $BtnCommit.Content = "⚡ COMPILE APEX BUILD"
        $BtnCommit.IsEnabled = $true
    })

    $Window.Add_SourceInitialized({
        $hwnd = (New-Object System.Windows.Interop.WindowInteropHelper($Window)).Handle
        $val = 3; [DllCall]::DwmSetWindowAttribute($hwnd, 38, [ref]$val, 4)
    })

    & $SyncFields
    $Window.ShowDialog() | Out-Null
}

# START ENGINE (INDUSTRIAL STA WRAPPER)
$rs = [runspacefactory]::CreateRunspace()
$rs.ApartmentState = "STA"
$rs.Open()

# Resolve correct script path for the backup mechanism
$scriptSourcePath = $PSCommandPath
if ([string]::IsNullOrWhiteSpace($scriptSourcePath)) { $scriptSourcePath = $MyInvocation.MyCommand.Path }

$ps = [powershell]::Create().AddScript($ScriptBlock).AddArgument($xamlString).AddArgument($Global:SpaceMatrix).AddArgument($scriptSourcePath).AddArgument($targetDir)
$ps.Runspace = $rs
$handle = $ps.BeginInvoke()

while (-not $handle.IsCompleted) { Start-Sleep -Milliseconds 100 }

Write-Host "================================================" -ForegroundColor Cyan
Write-Host " TERMINAL SAFE - EXIT PERMITTED" -ForegroundColor Green
Read-Host "Press ENTER to exit"
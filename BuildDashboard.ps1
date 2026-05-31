# ==============================================================================
# SpaceToggle OS - Ultimate Fluent WPF Diagnostic & Compilation Pipeline
# ==============================================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host

Write-Host "🚀 Running Direct Architecture Generation Pipeline..." -ForegroundColor Cyan

# Define exact paths
$ProjectDir   = "D:\GITHUB PROJECT\gemini  3.0"
$DashboardApp = "$ProjectDir\SpaceToggleDashboard.ps1"
$SetupOutput  = "$ProjectDir\SpaceToggleOS_Setup.exe"
$StagingDir   = "$env:TEMP\SpaceToggle_Staging"

# Resilient Inno Setup path resolution
$isccPath = "D:\GITHUB PROJECT\Inno Setup 6\ISCC.exe"
if (!(Test-Path $isccPath)) {
    $isccPath = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
}
if (!(Test-Path $isccPath)) {
    $isccPath = "C:\Program Files\Inno Setup 6\ISCC.exe"
}

# Ensure directories exist cleanly
if (Test-Path $StagingDir) { Remove-Item $StagingDir -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Path $StagingDir | Out-Null
if (!(Test-Path $ProjectDir)) { New-Item -ItemType Directory -Path $ProjectDir -Force | Out-Null }

# Write the WPF UI script using an un-expandable single-quoted block to prevent syntax breakage
$DashboardCode = @'
#Requires -Version 5.1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host

# Load required WPF and presentation assemblies
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Xaml

# --- STEP 1: CONFIGURE NATIVE WINDOW COMPOSITION ENGINE (P/INVOKE) ---
$NativeSignature = @"
using System;
using System.Runtime.InteropServices;
public class DwmEngine {
    [DllImport("dwmapi.dll")]
    public static extern int DwmSetWindowAttribute(IntPtr hwnd, int attr, ref int value, int attrSize);
    [DllImport("user32.dll")]
    public static extern bool SetProcessDPIAware();
}
"@
Add-Type -TypeDefinition $NativeSignature -ErrorAction SilentlyContinue
[DwmEngine]::SetProcessDPIAware()

# --- STEP 2: PATH SETUP ENGINE ---
$installDir = "$env:LOCALAPPDATA\SpaceToggleOS"
$ahkScript = "$installDir\SpaceToggleV11.ahk"
$ahkExe = "$installDir\SpaceToggleRuntime.exe"

# --- STEP 3: COMPLETE, UNABRIDGED PROFILE MATRIX DECLARATION ---
$Global:Profiles = @{
    "Founders" = @{
        "a" = @("", "https://gemini.google.com"); "b" = @("brave.exe", ""); "c" = @("chrome.exe", "")
        "d" = @("Discord.exe", ""); "e" = @("", "https://docs.google.com/spreadsheets"); "f" = @("explorer.exe", "")
        "g" = @("", "https://mail.google.com"); "h" = @("", "https://github.com"); "i" = @("", "https://instagram.com")
        "j" = @("", "https://docs.google.com"); "k" = @("", "https://calendar.google.com"); "l" = @("", "https://linkedin.com")
        "m" = @("", "https://cinemaos.live/"); "n" = @("", "https://keep.google.com"); "o" = @("", "https://drive.google.com")
        "p" = @("", "http://photos.google.com"); "q" = @("", "https://notebooklm.google.com"); "r" = @("", "https://reddit.com")
        "s" = @("Spotify.exe", ""); "t" = @("wt.exe", ""); "u" = @("uTorrent.exe", "")
        "v" = @("vlc.exe", ""); "w" = @("WhatsApp.exe", ""); "x" = @("", "https://x.com")
        "y" = @("", "https://youtube.com"); "z" = @("Zoom.exe", "")
    }
    "Gamers" = @{
        "a" = @("steam.exe", ""); "b" = @("epicgameslauncher.exe", ""); "c" = @("origin.exe", "")
        "d" = @("Discord.exe", ""); "e" = @("eaapp.exe", ""); "f" = @("ubisoftconnect.exe", "")
        "g" = @("", "https://vruniverse.com"); "h" = @("goggalaxy.exe", ""); "i" = @("", "https://twitch.tv")
        "j" = @("riotclient.exe", ""); "k" = @("battle.net.exe", ""); "l" = @("lunarclient.exe", "")
        "m" = @("minecraft.exe", ""); "n" = @("nvidia app.exe", ""); "o" = @("obs64.exe", "")
        "p" = @("", "https://tracker.gg"); "q" = @("qbit_gamer.exe", ""); "r" = @("", "https://reddit.com/r/gaming")
        "s" = @("Spotify.exe", ""); "t" = @("teamspeak.exe", ""); "u" = @("", "https://mod.io")
        "v" = @("vlc.exe", ""); "w" = @("WhatsApp.exe", ""); "x" = @("", "https://x.com")
        "y" = @("", "https://youtube.com"); "z" = @("curseforge.exe", "")
    }
    "Professionals" = @{
        "a" = @("Code.exe", ""); "b" = @("slack.exe", ""); "c" = @("Teams.exe", "")
        "d" = @("Discord.exe", ""); "e" = @("", "https://github.com"); "f" = @("sourcetree.exe", "")
        "g" = @("", "https://gmail.com"); "h" = @("notion.exe", ""); "i" = @("linear.exe", "")
        "j" = @("", "https://jira.atlassian.com"); "k" = @("", "https://confluence.atlassian.com"); "l" = @("", "https://linkedin.com")
        "m" = @("Figma.exe", ""); "n" = @("", "https://news.ycombinator.com"); "o" = @("outlook.exe", "")
        "p" = @("postman.exe", ""); "q" = @("", "https://stackoverflow.com"); "r" = @("", "https://reddit.com/r/programming")
        "s" = @("Spotify.exe", ""); "t" = @("wt.exe", ""); "u" = @("docker.exe", "")
        "v" = @("vlc.exe", ""); "w" = @("WhatsApp.exe", ""); "x" = @("", "https://x.com")
        "y" = @("", "https://youtube.com"); "z" = @("Zoom.exe", "")
    }
}

# Pre-populate empty bindings for any unmapped letters
$Letters = [char[]](97..122) | ForEach-Object { [string]$_ }
foreach ($p in "Founders", "Gamers", "Professionals") {
    foreach ($l in $Letters) {
        if (-not $Global:Profiles[$p].ContainsKey($l)) {
            $Global:Profiles[$p][$l] = @("", "")
        }
    }
}

# Load existing configurations from active script if it exists
if (Test-Path $ahkScript) {
    try {
        $content = Get-Content $ahkScript -Raw -Encoding utf8
        $profilesList = @("Founders", "Gamers", "Professionals")
        foreach ($p in $profilesList) {
            if ($content -match "Static\s+$p\s*:=\s*Map\((.*?)\)") {
                $mapBody = $Matches[1]
                # Match lines like "a", ["app", "web"]
                $matches_keys = [regex]::Matches($mapBody, '"([^"]+)"\s*,\s*\["([^"]*)"\s*,\s*"([^"]*)"\]')
                foreach ($m in $matches_keys) {
                    $key = $m.Groups[1].Value
                    $app = $m.Groups[2].Value
                    $web = $m.Groups[3].Value
                    $Global:Profiles[$p][$key] = @($app, $web)
                }
            }
        }
    } catch {
        Write-Host "⚠️ Warning: Failed to parse existing AHK configuration. Using defaults." -ForegroundColor Yellow
    }
}

# --- STEP 4: XAML DEFINITION (fluent design specifications) ---
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="SpaceToggle OS Controls"
        Height="570" Width="510"
        WindowStartupLocation="CenterScreen"
        AllowsTransparency="True" Background="Transparent" WindowStyle="None"
        ResizeMode="NoResize" x:Name="Form">
    <Window.Resources>
        <Style x:Key="TitleBarButton" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="#888888"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Width" Value="38"/>
            <Setter Property="Height" Value="32"/>
            <Setter Property="FontFamily" Value="Segoe UI Symbol"/>
            <Setter Property="FontSize" Value="10"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="bg" Background="{TemplateBinding Background}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="bg" Property="Background" Value="#2D2D32"/>
                                <Setter Property="Foreground" Value="White"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="bg" Property="Background" Value="#1C1C20"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="CloseButton" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="#888888"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Width" Value="38"/>
            <Setter Property="Height" Value="32"/>
            <Setter Property="FontFamily" Value="Segoe UI Symbol"/>
            <Setter Property="FontSize" Value="10"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="bg" Background="{TemplateBinding Background}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="bg" Property="Background" Value="#E81123"/>
                                <Setter Property="Foreground" Value="White"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="bg" Property="Background" Value="#F1707A"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="GroupBox">
            <Setter Property="BorderBrush" Value="#252528"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Margin" Value="0,8"/>
            <Setter Property="Padding" Value="13"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="GroupBox">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Border Grid.Row="0" Grid.RowSpan="2" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Background="#111113"/>
                            <ContentPresenter Grid.Row="0" ContentSource="Header" Margin="13,8,13,0" TextElement.Foreground="#A0A0A0" TextElement.FontFamily="Segoe UI Variable Text" TextElement.FontWeight="SemiBold" TextElement.FontSize="11.5"/>
                            <ContentPresenter Grid.Row="1" Margin="{TemplateBinding Padding}"/>
                        </Grid>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="CheckBox">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Margin" Value="0,7"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="FontFamily" Value="Segoe UI Variable Text"/>
            <Setter Property="FontSize" Value="11.5"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="CheckBox">
                        <BulletDecorator Background="Transparent" Cursor="Hand">
                            <BulletDecorator.Bullet>
                                <Border x:Name="bulletBorder" Width="16" Height="16" CornerRadius="3" Background="#1C1C20" BorderBrush="#3F3F46" BorderThickness="1">
                                    <Path x:Name="checkMark" Data="M 3,8 L 6,11 L 13,3" Stroke="#00FFCC" StrokeThickness="2" Visibility="Collapsed"/>
                                </Border>
                            </BulletDecorator.Bullet>
                            <ContentPresenter Margin="8,0,0,0" VerticalAlignment="Center"/>
                        </BulletDecorator>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsChecked" Value="True">
                                <Setter TargetName="checkMark" Property="Visibility" Value="Visible"/>
                                <Setter TargetName="bulletBorder" Property="Background" Value="#25252A"/>
                                <Setter TargetName="bulletBorder" Property="BorderBrush" Value="#00FFCC"/>
                            </Trigger>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="bulletBorder" Property="BorderBrush" Value="#52525B"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="TextBox">
            <Setter Property="Background" Value="#1C1C20"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderBrush" Value="#2D2D32"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="8,6"/>
            <Setter Property="CaretBrush" Value="#00FFCC"/>
            <Setter Property="FontFamily" Value="Segoe UI Variable Text"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border x:Name="border" CornerRadius="6" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}">
                            <ScrollViewer x:Name="PART_ContentHost" Margin="2,0"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsFocused" Value="True">
                                <Setter TargetName="border" Property="BorderBrush" Value="#00FFCC"/>
                                <Setter TargetName="border" Property="Background" Value="#222228"/>
                            </Trigger>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="BorderBrush" Value="#3F3F46"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="ComboBox">
            <Setter Property="Background" Value="#1C1C20"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderBrush" Value="#2D2D32"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="8,6"/>
            <Setter Property="FontFamily" Value="Segoe UI Variable Text"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="ComboBox">
                        <Grid>
                            <ToggleButton x:Name="ToggleButton" 
                                          BorderBrush="{TemplateBinding BorderBrush}" 
                                          BorderThickness="{TemplateBinding BorderThickness}" 
                                          Background="{TemplateBinding Background}" 
                                          Grid.Column="2" 
                                          Focusable="false"
                                          IsChecked="{Binding IsDropDownOpen, Mode=TwoWay, RelativeSource={RelativeSource TemplatedParent}}">
                                <ToggleButton.Template>
                                    <ControlTemplate TargetType="ToggleButton">
                                        <Border x:Name="border" CornerRadius="6" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}">
                                            <Grid HorizontalAlignment="Right" Width="24">
                                                <Path x:Name="Arrow" Fill="#A0A0A0" HorizontalAlignment="Center" VerticalAlignment="Center" Data="M 0 0 L 4 4 L 8 0 Z"/>
                                            </Grid>
                                        </Border>
                                        <ControlTemplate.Triggers>
                                            <Trigger Property="IsMouseOver" Value="True">
                                                <Setter TargetName="border" Property="BorderBrush" Value="#3F3F46"/>
                                            </Trigger>
                                        </ControlTemplate.Triggers>
                                    </ControlTemplate>
                                </ToggleButton.Template>
                            </ToggleButton>
                            <ContentPresenter Name="ContentSite" IsHitTestVisible="False" Content="{TemplateBinding SelectionBoxItem}" ContentTemplate="{TemplateBinding SelectionBoxItemTemplate}" ContentTemplateSelector="{TemplateBinding ItemTemplateSelector}" Margin="10,6,30,6" VerticalAlignment="Center" HorizontalAlignment="Left"/>
                            <TextBox x:Name="PART_EditableTextBox" Style="{x:Null}" HorizontalAlignment="Left" VerticalAlignment="Center" Margin="10,6,30,6" Focusable="True" Background="Transparent" Visibility="Hidden" IsReadOnly="{TemplateBinding IsReadOnly}"/>
                            <Popup Name="Popup" Placement="Bottom" IsOpen="{TemplateBinding IsDropDownOpen}" AllowsTransparency="True" Focusable="False" PopupAnimation="Slide">
                                <Grid Name="DropDown" SnapsToDevicePixels="True" MinWidth="{TemplateBinding ActualWidth}" MaxHeight="{TemplateBinding MaxDropDownHeight}">
                                    <Border Name="DropDownBorder" Background="#16161A" BorderBrush="#2D2D32" BorderThickness="1" CornerRadius="6"/>
                                    <ScrollViewer Margin="4,6,4,6" SnapsToDevicePixels="True">
                                        <StackPanel IsItemsHost="True" KeyboardNavigation.DirectionalNavigation="Contained"/>
                                    </ScrollViewer>
                                </Grid>
                            </Popup>
                        </Grid>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="BorderBrush" Value="#3F3F46"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="ComboBoxItem">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Padding" Value="8,6"/>
            <Setter Property="FontFamily" Value="Segoe UI Variable Text"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="ComboBoxItem">
                        <Border Name="Border" CornerRadius="4" Padding="{TemplateBinding Padding}" Background="Transparent">
                            <ContentPresenter/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="true">
                                <Setter TargetName="Border" Property="Background" Value="#2D2D32"/>
                            </Trigger>
                            <Trigger Property="IsSelected" Value="true">
                                <Setter TargetName="Border" Property="Background" Value="#00FFCC"/>
                                <Setter Property="Foreground" Value="Black"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="FluentButton" TargetType="Button">
            <Setter Property="Background" Value="#202024"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderBrush" Value="#2D2D32"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="12,8"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontFamily" Value="Segoe UI Variable Text"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" CornerRadius="6" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" SnapsToDevicePixels="True">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" Margin="{TemplateBinding Padding}"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#2A2A30"/>
                                <Setter TargetName="border" Property="BorderBrush" Value="#3F3F46"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#1C1C20"/>
                                <Setter TargetName="border" Property="RenderTransform">
                                    <Setter.Value>
                                        <ScaleTransform ScaleX="0.98" ScaleY="0.98"/>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="AccentButton" TargetType="Button">
            <Setter Property="Background">
                <Setter.Value>
                    <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                        <GradientStop Color="#00B4DB" Offset="0"/>
                        <GradientStop Color="#0083B0" Offset="1"/>
                    </LinearGradientBrush>
                </Setter.Value>
            </Setter>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Padding" Value="12,12"/>
            <Setter Property="FontFamily" Value="Segoe UI Variable Display"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="FontSize" Value="12.5"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" CornerRadius="6" Background="{TemplateBinding Background}" SnapsToDevicePixels="True">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" Margin="{TemplateBinding Padding}"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background">
                                    <Setter.Value>
                                        <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                                            <GradientStop Color="#00C9FF" Offset="0"/>
                                            <GradientStop Color="#92FE9D" Offset="1"/>
                                        </LinearGradientBrush>
                                    </Setter.Value>
                                </Setter>
                                <Setter Property="Foreground" Value="Black"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="RenderTransform">
                                    <Setter.Value>
                                        <ScaleTransform ScaleX="0.98" ScaleY="0.98"/>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
    
    <Border x:Name="WindowBorder" Background="#16161A" BorderBrush="#28282E" BorderThickness="1.5" CornerRadius="12">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/> <!-- Titlebar -->
                <RowDefinition Height="*"/>    <!-- Content Area -->
            </Grid.RowDefinitions>
            
            <Grid Grid.Row="0" Height="50" Background="Transparent" x:Name="TitleBar">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <StackPanel Orientation="Horizontal" Margin="21,0,0,0" VerticalAlignment="Center" Grid.Column="0">
                    <TextBlock Text="🚀" FontSize="16" Margin="0,0,8,0" VerticalAlignment="Center"/>
                    <TextBlock Text="SPACETOGGLE OS CONTROLS" FontFamily="Segoe UI Variable Display" FontWeight="SemiBold" FontSize="13" Foreground="White" VerticalAlignment="Center"/>
                </StackPanel>
                
                <StackPanel Orientation="Horizontal" VerticalAlignment="Top" HorizontalAlignment="Right" Grid.Column="1" Margin="0,0,6,0">
                    <Button Content="─" Style="{StaticResource TitleBarButton}" x:Name="btnMin"/>
                    <Button Content="🗖" Style="{StaticResource TitleBarButton}" x:Name="btnMax"/>
                    <Button Content="✕" Style="{StaticResource CloseButton}" x:Name="btnClose"/>
                </StackPanel>
            </Grid>
            
            <Grid Grid.Row="1" Margin="21,0,21,21">
                <Grid x:Name="MainPanel" Visibility="Visible">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    
                    <GroupBox Header=" System Features Modifiers " Grid.Row="0">
                        <StackPanel>
                            <CheckBox x:Name="chkBossKey" Content="Enable Workspace Secure Boss Key Sweep (Space + Esc)" IsChecked="True"/>
                            <CheckBox x:Name="chkPiP" Content="Enable Multi-Corner Fluid PiP Window Frame (Space + `)" IsChecked="True"/>
                            <CheckBox x:Name="chkContextInput" Content="Enable Contextual Input Engine (Space + ,)" IsChecked="True"/>
                            <CheckBox x:Name="chkOpacity" Content="Enable Layer Opacity Mouse-Wheel Adjustments" IsChecked="True"/>
                            <CheckBox x:Name="chkEdgeScroll" Content="Enable Double-Tap Page-Edge Quick Jump (Space + Up/Dn x2)" IsChecked="True"/>
                        </StackPanel>
                    </GroupBox>
                    
                    <GroupBox Header=" Custom Matrix Mapping Engine " Grid.Row="1">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                            </Grid.RowDefinitions>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            
                            <StackPanel Grid.Row="0" Grid.Column="0" Margin="0,0,8,8">
                                <TextBlock Text="Target OS Profile Layer:" Foreground="#A0A0A0" FontSize="11" Margin="0,0,0,4" FontFamily="Segoe UI Variable Text"/>
                                <ComboBox x:Name="cmbProfile">
                                    <ComboBoxItem Content="Founders"/>
                                    <ComboBoxItem Content="Gamers"/>
                                    <ComboBoxItem Content="Professionals"/>
                                </ComboBox>
                            </StackPanel>
                            
                            <StackPanel Grid.Row="0" Grid.Column="1" Margin="8,0,0,8">
                                <TextBlock Text="Trigger Binding Key (Space + Key):" Foreground="#A0A0A0" FontSize="11" Margin="0,0,0,4" FontFamily="Segoe UI Variable Text"/>
                                <ComboBox x:Name="cmbKey"/>
                            </StackPanel>
                            
                            <StackPanel Grid.Row="1" Grid.ColumnSpan="2" Margin="0,8,0,8">
                                <TextBlock Text="Application Path OR Web URL Link:" Foreground="#A0A0A0" FontSize="11" Margin="0,0,0,4" FontFamily="Segoe UI Variable Text"/>
                                <TextBox x:Name="txtTarget" FontSize="12"/>
                            </StackPanel>
                            
                            <Button x:Name="btnAssign" Content="Apply Binding to Local Matrix Map Memory" Style="{StaticResource FluentButton}" Grid.Row="2" Grid.ColumnSpan="2" Margin="0,8,0,0"/>
                        </Grid>
                    </GroupBox>
                    
                    <Button x:Name="btnSave" Content="⚡ SAVE ALL CHANGES &amp; HOT-SWAP RUNTIME" Style="{StaticResource AccentButton}" Grid.Row="2" VerticalAlignment="Bottom" Margin="0,13,0,0"/>
                </Grid>
                
                <Grid x:Name="GridPanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    
                    <TextBlock Text="📊 CORE MATRIX PROFILE DISCOVERY BOARD" Grid.Row="0" FontFamily="Segoe UI Variable Display" FontSize="16" FontWeight="SemiBold" Foreground="White" Margin="0,0,0,13"/>
                    
                    <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
                        <WrapPanel x:Name="GridContainer" HorizontalAlignment="Center"/>
                    </ScrollViewer>
                </Grid>
            </Grid>
        </Grid>
    </Border>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$Form = [Windows.Markup.XamlReader]::Load($reader)

$WindowBorder = $Form.FindName("WindowBorder")
$TitleBar = $Form.FindName("TitleBar")
$btnMin = $Form.FindName("btnMin")
$btnMax = $Form.FindName("btnMax")
$btnClose = $Form.FindName("btnClose")
$MainPanel = $Form.FindName("MainPanel")
$GridPanel = $Form.FindName("GridPanel")
$GridContainer = $Form.FindName("GridContainer")

$chkBossKey = $Form.FindName("chkBossKey")
$chkPiP = $Form.FindName("chkPiP")
$chkContextInput = $Form.FindName("chkContextInput")
$chkOpacity = $Form.FindName("chkOpacity")
$chkEdgeScroll = $Form.FindName("chkEdgeScroll")

$cmbProfile = $Form.FindName("cmbProfile")
$cmbKey = $Form.FindName("cmbKey")
$txtTarget = $Form.FindName("txtTarget")
$btnAssign = $Form.FindName("btnAssign")
$btnSave = $Form.FindName("btnSave")

$cmbProfile.SelectedIndex = 0
$Letters | ForEach-Object { $cmbKey.Items.Add($_) | Out-Null }
$cmbKey.SelectedIndex = 0

if (Test-Path $ahkScript) {
    try {
        $content = Get-Content $ahkScript -Raw -Encoding utf8
        $chkBossKey.IsChecked = $content -match "(?m)^\*Esc::ToggleBossKey\(\)"
        $chkPiP.IsChecked = $content -match "(?m)^\*SC029::TogglePiP\(\)"
        $chkContextInput.IsChecked = $content -match "(?m)^\*,::FocusInputEngine\(\)"
        $chkOpacity.IsChecked = $content -match "(?m)^WheelUp::"
        $chkEdgeScroll.IsChecked = $content -match "(?m)^\*Up::"
    } catch {}
}

$Form.add_SourceInitialized({
    try {
        $helper = New-Object System.Windows.Interop.WindowInteropHelper($Form)
        $hwnd = $helper.Handle
        $attr = 33; $val = 3
        [DwmEngine]::DwmSetWindowAttribute($hwnd, $attr, [ref]$val, 4) | Out-Null
        $attr = 38; $val = 3
        [DwmEngine]::DwmSetWindowAttribute($hwnd, $attr, [ref]$val, 4) | Out-Null
        $attr = 34; $val = 0x40FFFFFF
        [DwmEngine]::DwmSetWindowAttribute($hwnd, $attr, [ref]$val, 4) | Out-Null
    } catch {}
})

$TitleBar.add_MouseLeftButtonDown({
    try { $Form.DragMove() } catch {}
})

$btnMin.add_Click({
    $Form.WindowState = [System.Windows.WindowState]::Minimized
})

$btnMax.add_Click({
    if ($Form.WindowState -eq [System.Windows.WindowState]::Normal) {
        $Form.WindowState = [System.Windows.WindowState]::Maximized
    } else {
        $Form.WindowState = [System.Windows.WindowState]::Normal
    }
})

$btnClose.add_Click({
    $Form.Close()
})

$Form.add_StateChanged({
    if ($Form.WindowState -eq [System.Windows.WindowState]::Maximized) {
        $MainPanel.Visibility = [System.Windows.Visibility]::Collapsed
        $GridPanel.Visibility = [System.Windows.Visibility]::Visible
        $btnMax.Content = "🗗"
        $WindowBorder.CornerRadius = New-Object System.Windows.CornerRadius 0
        $WindowBorder.BorderThickness = New-Object System.Windows.Thickness 0
        & $RenderTacticalGrid
    } else {
        $MainPanel.Visibility = [System.Windows.Visibility]::Visible
        $GridPanel.Visibility = [System.Windows.Visibility]::Collapsed
        $btnMax.Content = "🗖"
        $WindowBorder.CornerRadius = New-Object System.Windows.CornerRadius 12
        $WindowBorder.BorderThickness = New-Object System.Windows.Thickness 1.5
    }
})

$UpdateFields = {
    if ($cmbProfile.SelectedItem -and $cmbKey.SelectedItem) {
        $prof = $cmbProfile.SelectedItem.Content.ToString()
        $key = $cmbKey.SelectedItem.ToString()
        $data = $Global:Profiles[$prof][$key]
        if ($data) {
            if ($data[1] -ne "") {
                $txtTarget.Text = $data[1]
            } else {
                $txtTarget.Text = $data[0]
            }
        }
    }
}
$cmbProfile.add_SelectionChanged($UpdateFields)
$cmbKey.add_SelectionChanged($UpdateFields)

$RenderTacticalGrid = {
    $GridContainer.Children.Clear()
    if ($cmbProfile.SelectedItem -eq $null) { return }
    $p = $cmbProfile.SelectedItem.Content.ToString()
    
    foreach ($l in $Letters) {
        $Card = New-Object System.Windows.Controls.Border
        $Card.Background = [System.Windows.Media.BrushConverter]::ConvertFromString("#1E1E22")
        $Card.CornerRadius = New-Object System.Windows.CornerRadius 6
        $Card.Margin = New-Object System.Windows.Thickness 6
        $Card.Width = 205
        $Card.Height = 85
        $Card.Cursor = [System.Windows.Input.Cursors]::Hand
        
        $Stack = New-Object System.Windows.Controls.StackPanel
        $Stack.Margin = New-Object System.Windows.Thickness 13
        $Stack.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
        
        $lblLtr = New-Object System.Windows.Controls.TextBlock
        $lblLtr.Text = $l.ToUpper()
        $lblLtr.FontFamily = "Segoe UI Variable Display"
        $lblLtr.FontWeight = [System.Windows.FontWeights]::Bold
        $lblLtr.FontSize = 15
        $lblLtr.Foreground = [System.Windows.Media.BrushConverter]::ConvertFromString("#00FFCC")
        
        $rawMap = $Global:Profiles[$p][$l]
        $displayVal = if ($rawMap[1] -ne "") { $rawMap[1] } else { $rawMap[0] }
        if ($displayVal -eq "") { $displayVal = "• Unmapped Node •" }
        
        $lblVal = New-Object System.Windows.Controls.TextBlock
        $lblVal.Text = $displayVal
        $lblVal.FontFamily = "Segoe UI Variable Text"
        $lblVal.FontSize = 10
        $lblVal.Foreground = [System.Windows.Media.BrushConverter]::ConvertFromString("#A0A0A0")
        $lblVal.Margin = New-Object System.Windows.Thickness 0,4,0,0
        $lblVal.TextTrimming = [System.Windows.TextTrimming]::CharacterEllipsis
        
        $Stack.Children.Add($lblLtr) | Out-Null
        $Stack.Children.Add($lblVal) | Out-Null
        $Card.Child = $Stack
        
        $Card.add_MouseEnter({
            $Card.Background = [System.Windows.Media.BrushConverter]::ConvertFromString("#2D2D32")
        })
        $Card.add_MouseLeave({
            $Card.Background = [System.Windows.Media.BrushConverter]::ConvertFromString("#1E1E22")
        })
        
        $targetLtr = $l
        $Card.add_MouseDown({
            $cmbKey.SelectedItem = $targetLtr
            & $UpdateFields
            $Form.WindowState = [System.Windows.WindowState]::Normal
        })
        
        $GridContainer.Children.Add($Card) | Out-Null
    }
}

$btnAssign.add_Click({
    $p = $cmbProfile.SelectedItem.Content.ToString()
    $k = $cmbKey.SelectedItem.ToString()
    $v = $txtTarget.Text.Trim()
    
    if ($v -match "\[.*?\]\((https?://.*?)\)") {
        $v = $Matches[1]
    }
    
    if ($v -match "^https?://") {
        $Global:Profiles[$p][$k] = @("", $v)
    } else {
        $Global:Profiles[$p][$k] = @($v, "")
    }
    
    [System.Windows.MessageBox]::Show("Key modifier configuration for '$k' successfully mapped under '$p' profile buffer memory!", "Matrix Assigned", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
})

$btnSave.add_Click({
    if (!(Test-Path $installDir)) {
        New-Item -ItemType Directory -Force -Path $installDir | Out-Null
    }
    
    $MapBlockText = ""
    foreach ($p in "Founders", "Gamers", "Professionals") {
        $MapBlockText += "    Static $p := Map(`n"
        $lines = @()
        foreach ($k in $Letters) {
            $app = $Global:Profiles[$p][$k][0]
            $web = $Global:Profiles[$p][$k][1]
            if ($web -match "\[.*?\]\((https?://.*?)\)") { $web = $Matches[1] }
            $appEscaped = $app -replace '\\', '\\' -replace '"', '\"'
            $webEscaped = $web -replace '\\', '\\' -replace '"', '\"'
            $lines += "        `"$k`", [`"$appEscaped`", `"$webEscaped`"]"
        }
        $MapBlockText += ($lines -join ",`n") + "`n    )`n`n"
    }

    $BossKeyHook = if ($chkBossKey.IsChecked) { "*Esc::ToggleBossKey()" } else { "; *Esc::ToggleBossKey() [Disabled]" }
    $PiPHook = if ($chkPiP.IsChecked) { "*SC029::TogglePiP()" } else { "; *SC029::TogglePiP() [Disabled]" }
    $ContextInputHook = if ($chkContextInput.IsChecked) { "*,::FocusInputEngine()" } else { "; *,::FocusInputEngine() [Disabled]" }
    
    $OpacityHook = if ($chkOpacity.IsChecked) {
        "WheelUp::`r`n{`r`n    global`r`n    SpaceAborted := true`r`n    try {`r`n        activeHwnd := WinExist('A')`r`n        if !activeHwnd`r`n            return`r`n        currTrans := WinGetTransparent(activeHwnd)`r`n        trans := (currTrans == '' || currTrans == -1) ? 255 : currTrans`r`n        trans += 15`r`n        if (trans > 255) { trans := 255 }`r`n        WinSetTransparent(trans, 'A')`r`n    } catch Error {}`r`n}`r`n`r`nWheelDown::`r`n{`r`n    global`r`n    SpaceAborted := true`r`n    try {`r`n        activeHwnd := WinExist('A')`r`n        if !activeHwnd`r`n            return`r`n        currTrans := WinGetTransparent(activeHwnd)`r`n        trans := (currTrans == '' || currTrans == -1) ? 255 : currTrans`r`n        trans -= 15`r`n        if (trans < 60) { trans := 60 }`r`n        WinSetTransparent(trans, 'A')`r`n    } catch Error {}`r`n}"
    } else { "; Opacity Adjustments Disabled" }
    
    $EdgeScrollHook = if ($chkEdgeScroll.IsChecked) {
        "*Up::`r`n{`r`n    Static LastUp := 0`r`n    global SpaceAborted := true`r`n    if (A_TickCount - LastUp < 400) {`r`n        Send('^{Home}')`r`n        CreateNotificationHUD('⏫ Scrolled to Top')`r`n        LastUp := 0`r`n    } else { LastUp := A_TickCount }`r`n}`r`n`r`n*Down::`r`n{`r`n    Static LastDn := 0`r`n    global SpaceAborted := true`r`n    if (A_TickCount - LastDn < 400) {`r`n        Send('^{End}')`r`n        CreateNotificationHUD('⏬ Scrolled to Bottom')`r`n        LastDn := 0`r`n    } else { LastDn := A_TickCount }`r`n}"
    } else { "; Double-Tap Edge Scroll Disabled" }

    $activeProfile = $cmbProfile.SelectedItem.Content.ToString()

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
Global ActiveProfile   := "$activeProfile"
Global ProfilesList    := ["Founders", "Gamers", "Professionals"]
Global ProfileIndex    := ActiveProfile == "Founders" ? 1 : (ActiveProfile == "Gamers" ? 2 : 3)
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
    } catch Error {}

    try {
        regPath := RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" exeTarget)
        if FileExist(regPath)
            return regPath
    } catch Error {}
    
    try {
        regPath := RegRead("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" exeTarget)
        if FileExist(regPath)
            return regPath
    } catch Error {}

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
        Run('"' url '"')
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
            CreateNotificationHUD("🌐 Navigating: " SubStr(TargetWeb, 9, 20) "...")
            return
        } catch Error {}
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
        } catch Error {}
        
        resolvedFounders := ResolvePath(FoundersApp)
        if (resolvedFounders != "") {
            try { 
                Run(InStr(resolvedFounders, "://") ? resolvedFounders : '"' resolvedFounders '"') 
                CreateNotificationHUD("🚀 Fallback Init: " FoundersApp)
                return
            } catch Error {}
        }
    }

    if (FoundersWeb != "") {
        try { 
            RunBrowser(FoundersWeb) 
            CreateNotificationHUD("🌐 Fallback Web: " SubStr(FoundersWeb, 9, 20) "...")
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
$BossKeyHook
$PiPHook
$ContextInputHook
$OpacityHook
$EdgeScrollHook

*RAlt:: {
    global
    SpaceAborted := true
    global ProfileIndex := (ProfileIndex >= ProfilesList.Length) ? 1 : ProfileIndex + 1
    global ActiveProfile := ProfilesList[ProfileIndex]
    CreateNotificationHUD("👤 OS Layer Active: " ActiveProfile)
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

    # Strict UTF-8 with BOM output writer to prevent text degradation
    [System.IO.File]::WriteAllText($ahkScript, $Payload, [System.Text.Encoding]::UTF8)

    # Process Hot-Swap Core Reset Routine
    Get-Process "SpaceToggleRuntime" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Milliseconds 500

    if (Test-Path $ahkExe) {
        # Launch AHK compiler / runtime in background hidden mode
        Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkScript`"" -WindowStyle Hidden
        [System.Windows.MessageBox]::Show("SpaceToggle Matrix OS Ecosystem re-compiled and hot-swapped successfully!", "Ecosystem Synchronized", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } else {
        [System.Windows.MessageBox]::Show("Ecosystem mappings saved locally, but background runtime could not be cycled automatiquement.", "Warning", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }
})

# Display and start WPF loop
& $UpdateFields
[System.Windows.Application]::Current.Run($Form) | Out-Null
'@

# Save the dashboard directly down into the workspace path safely
$utf8Bom = New-Object System.Text.UTF8Encoding $true
[System.IO.File]::WriteAllText($DashboardApp, $DashboardCode, $utf8Bom)
Write-Host "✅ Interface source code generated without leakage!" -ForegroundColor Green

# --- PREPARE EXTRACTED REPRODUCTION EMBEDDED ENGINE BINARIES ---
$AhkEngineCode = @'
; Requires AutoHotkey v2.0
#SingleInstance Force
ListLines 0
ProcessSetPriority "High"
Global SpacePressed := False
~*Space:: {
    Global SpacePressed := True
    KeyWait "Space"
    Global SpacePressed := False
}
#HotIf Global SpacePressed
a::Run("https://gemini.google.com")
#HotIf
'@
$AhkEngineCode | Set-Content -Path "$StagingDir\SpaceToggleV11.ahk" -Encoding UTF8 -Force

$RuntimeSource = "C:\Users\beamu\AppData\Local\SpaceToggleOS\SpaceToggleRuntime.exe"
if (Test-Path $RuntimeSource) {
    Copy-Item -Path $RuntimeSource -Destination "$StagingDir\SpaceToggleRuntime.exe" -Force
} else {
    New-Item -ItemType File -Path "$StagingDir\SpaceToggleRuntime.exe" -Force | Out-Null
}
Copy-Item -Path $DashboardApp -Destination "$StagingDir\SpaceToggleDashboard.ps1" -Force

# --- TRIGGER THE COMPILER PATTERN BUILD ---
$IssFile = "$StagingDir\ProductionRelease.iss"
$IssContent = @"
[Setup]
AppName=SpaceToggle OS
AppVersion=11.0.0
AppPublisher=SpaceToggle Architecture Group
DefaultDirName={localappdata}\SpaceToggleOS
OutputDir="$ProjectDir"
OutputBaseFilename=SpaceToggleOS_Setup
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
DirExistsWarning=no
DisableDirPage=no

[Files]
Source: "$StagingDir\SpaceToggleRuntime.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "$StagingDir\SpaceToggleV11.ahk"; DestDir: "{app}"; Flags: ignoreversion
Source: "$StagingDir\SpaceToggleDashboard.ps1"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{userdesktop}\SpaceToggle OS Dashboard"; Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -WindowStyle Hidden -File ""{app}\SpaceToggleDashboard.ps1"""
Name: "{userstartup}\SpaceToggle OS Engine"; Filename: "{app}\SpaceToggleRuntime.exe"; Parameters: """{app}\SpaceToggleV11.ahk"""

[Run]
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\SpaceToggleDashboard.ps1"""; Flags: nowait postinstall; Description: "Launch SpaceToggle OS"
"@
$IssContent | Set-Content -Path $IssFile -Encoding UTF8 -Force

Write-Host "⚙️ Compiling clean binary deployment target packages using $isccPath..." -ForegroundColor Magenta
if (Test-Path $isccPath) {
    $isccProcess = Start-Process -FilePath $isccPath -ArgumentList "`"$IssFile`"" -NoNewWindow -Wait -PassThru -RedirectStandardOutput "$StagingDir\stdout.txt" -RedirectStandardError "$StagingDir\stderr.txt"
    if ($isccProcess.ExitCode -eq 0) {
        Write-Host "`n🏁 PIPELINE COMPLETE! RUNNING LIVE DIAGNOSTIC IN CURRENT CONSOLE TRAILING..." -ForegroundColor Green
        # Copy generated setup to project folder (Inno does this via OutputDir)
        Write-Host "File generated successfully at: $SetupOutput" -ForegroundColor Yellow
        # Start dashboard
        & $DashboardApp
    } else {
        Write-Host "`n❌ Compiler build engine dropped handles with code: $($isccProcess.ExitCode)" -ForegroundColor Red
        if (Test-Path "$StagingDir\stderr.txt") { Get-Content "$StagingDir\stderr.txt" | ForEach-Object { Write-Host $_ -ForegroundColor Red } }
    }
} else {
    Write-Host "`n❌ Inno Setup Compiler ISCC.exe not found! Expected at $isccPath" -ForegroundColor Red
    Write-Host "Dashboard generated successfully at: $DashboardApp. Run it manually." -ForegroundColor Yellow
    # Still launch the dashboard
    & $DashboardApp
}
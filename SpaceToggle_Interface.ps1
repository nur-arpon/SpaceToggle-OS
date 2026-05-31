# ==============================================================================
# SpaceToggle OS - Premium XAML Interface (WinUI 3 Design Emulation)
# ==============================================================================
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# --- 1. DYNAMIC XAML GENERATION (GEOMETRY & SPACING MATRIX) ---
# Generating the input fields dynamically to respect the Golden Ratio spacing (8, 13, 21, 34)
$Letters = [char[]](97..122) | ForEach-Object { [string]$_ }
$InputsXaml = ""

foreach ($l in $Letters) {
    $InputsXaml += @"
    <Border Background="#1A1A1A" CornerRadius="6" Margin="8" Padding="13" Width="240">
        <StackPanel>
            <TextBlock Text="Space + $l" Foreground="#FFFFFF" FontFamily="Segoe UI Variable Display" FontWeight="SemiBold" FontSize="14" Margin="0,0,0,8"/>
            
            <TextBlock Text="App / Executable" Foreground="#A0A0A0" FontFamily="Segoe UI Variable Text" FontSize="11" Margin="0,0,0,4"/>
            <TextBox Name="exe_$l" Background="#2D2D2D" Foreground="#FFFFFF" BorderThickness="0" Padding="8,4" Margin="0,0,0,13"/>
            
            <TextBlock Text="Website URL" Foreground="#A0A0A0" FontFamily="Segoe UI Variable Text" FontSize="11" Margin="0,0,0,4"/>
            <TextBox Name="url_$l" Background="#2D2D2D" Foreground="#FFFFFF" BorderThickness="0" Padding="8,4"/>
        </StackPanel>
    </Border>
"@
}

# --- 2. THE LIQUID GLASS & STRUCTURAL XAML ---
[xml]$xaml = @"
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="SpaceToggle OS" Height="700" Width="1000"
    WindowStyle="None" AllowsTransparency="True" Background="Transparent"
    WindowStartupLocation="CenterScreen">
    
    <Window.Resources>
        <Style TargetType="Button" x:Key="WindowControlButton">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="#A0A0A0"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="FontFamily" Value="Segoe MDL2 Assets"/>
            <Setter Property="FontSize" Value="10"/>
            <Setter Property="Width" Value="46"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#2D2D2D"/>
                                <Setter Property="Foreground" Value="#FFFFFF"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        
        <Style TargetType="Button" x:Key="CloseControlButton" BasedOn="{StaticResource WindowControlButton}">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#C42B1C"/>
                                <Setter Property="Foreground" Value="#FFFFFF"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="Button" x:Key="PrimaryAction">
            <Setter Property="Background" Value="#FFFFFF"/>
            <Setter Property="Foreground" Value="#000000"/>
            <Setter Property="FontFamily" Value="Segoe UI Variable Text"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Padding" Value="21,8"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#E0E0E0"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter Property="RenderTransform">
                                    <Setter.Value>
                                        <ScaleTransform ScaleX="0.98" ScaleY="0.98" CenterX="50" CenterY="15"/>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Border Name="MainWindowBorder" Background="#111111" CornerRadius="12" BorderBrush="#333333" BorderThickness="1">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="34"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>

            <Grid Grid.Row="0" Name="TitleBar" Background="Transparent">
                <TextBlock Text="SpaceToggle OS" Foreground="#FFFFFF" FontFamily="Segoe UI Variable Display" FontWeight="SemiBold" FontSize="12" Margin="13,0,0,0" VerticalAlignment="Center"/>
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
                    <Button Name="MinBtn" Content="&#xE921;" Style="{StaticResource WindowControlButton}"/>
                    <Button Name="MaxBtn" Content="&#xE922;" Style="{StaticResource WindowControlButton}"/>
                    <Button Name="CloseBtn" Content="&#xE106;" Style="{StaticResource CloseControlButton}"/>
                </StackPanel>
            </Grid>

            <ScrollViewer Grid.Row="1" Margin="13,0,13,0" VerticalScrollBarVisibility="Auto">
                <WrapPanel Name="MappingContainer" Margin="8">
                    $InputsXaml
                </WrapPanel>
            </ScrollViewer>

            <Border Grid.Row="2" Background="#0A0A0A" CornerRadius="0,0,12,12" Padding="21" BorderBrush="#222222" BorderThickness="0,1,0,0">
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
                    <TextBlock Name="StatusText" Foreground="#A0A0A0" FontFamily="Segoe UI Variable Text" VerticalAlignment="Center" Margin="0,0,21,0"/>
                    <Button Name="SaveBtn" Content="Compile &amp; Apply Engine" Style="{StaticResource PrimaryAction}"/>
                </StackPanel>
            </Border>
        </Grid>
    </Border>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$Window = [Windows.Markup.XamlReader]::Load($reader)

# --- 3. WINDOW CONTROLS & PHYSICS ---
$TitleBar = $Window.FindName("TitleBar")
$MainWindowBorder = $Window.FindName("MainWindowBorder")
$MinBtn = $Window.FindName("MinBtn")
$MaxBtn = $Window.FindName("MaxBtn")
$CloseBtn = $Window.FindName("CloseBtn")
$SaveBtn = $Window.FindName("SaveBtn")
$StatusText = $Window.FindName("StatusText")

# Drag to move
$TitleBar.Add_MouseLeftButtonDown({
    if ($_.ClickCount -eq 2) {
        Toggle-Maximize
    } else {
        $Window.DragMove()
    }
})

function Toggle-Maximize {
    if ($Window.WindowState -eq 'Maximized') {
        $Window.WindowState = 'Normal'
        $MainWindowBorder.CornerRadius = "12"
        $MainWindowBorder.BorderThickness = "1"
    } else {
        $Window.WindowState = 'Maximized'
        $MainWindowBorder.CornerRadius = "0"
        $MainWindowBorder.BorderThickness = "0"
    }
}

$MinBtn.Add_Click({ $Window.WindowState = 'Minimized' })
$MaxBtn.Add_Click({ Toggle-Maximize })
$CloseBtn.Add_Click({ $Window.Close() })

# --- 4. PRELOAD KNOWN DEFAULT DEFAULTS ---
$Window.FindName("url_a").Text = "https://gemini.google.com"
$Window.FindName("exe_b").Text = "brave.exe"
$Window.FindName("exe_c").Text = "chrome.exe"
$Window.FindName("exe_d").Text = "Discord.exe"

# --- 5. COMPILER & AHK GENERATOR LOGIC ---
$SaveBtn.Add_Click({
    $StatusText.Text = "Compiling Payload..."
    
    # Base AHK v2 Directives
    $ahkPayload = @"
#Requires AutoHotkey v2.0
#SingleInstance Force

; Ensure space alone still functions as normal
~Space::Send "{Space}"

"@

    # Extract UI data and format URLs/Exes correctly to prevent errors
    foreach ($l in $Letters) {
        $exeVal = $Window.FindName("exe_$l").Text.Trim()
        $urlVal = $Window.FindName("url_$l").Text.Trim()

        if (![string]::IsNullOrEmpty($urlVal)) {
            # Fixes the website error: Forces strict string quoting for URLs
            $ahkPayload += "Space & $l::Run `"$urlVal`"`n"
        } 
        elseif (![string]::IsNullOrEmpty($exeVal)) {
            $ahkPayload += "Space & $l::Run `"$exeVal`"`n"
        }
    }

    # Save to the local directory
    $ahkPath = Join-Path $PSScriptRoot "SpaceToggleRuntime.ahk"
    $ahkPayload | Set-Content -Path $ahkPath -Encoding UTF8 -Force

    $StatusText.Text = "Applying Hot-Swap Core..."
    
    # Process Hot-Swap Reset
    Get-Process "AutoHotkey*" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Milliseconds 500

    # Execute the new file 
    Invoke-Item $ahkPath
    
    $StatusText.Text = "Engine Active."
})

# Launch Application
$Window.ShowDialog() | Out-Null
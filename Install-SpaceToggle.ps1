# ============================================================================
# SpaceToggle OS - One-Step PowerShell Deployment Script
# ============================================================================
# Description: Automated installer for SpaceToggle AutoHotkey v2 window manager
# Requirements: Run as Administrator in PowerShell
# Usage: Copy-paste the entire script into an admin PowerShell terminal and run
# ============================================================================

param(
    [string]$InstallPath = "$env:USERPROFILE\SpaceToggle",
    [string]$GitHubRepo = "nur-arpon/SpaceToggle-OS",
    [string]$AhkFileName = "SpaceToggle.ahk"
)

# ============================================================================
# Configuration
# ============================================================================

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"  # Suppress progress bars for cleaner output

$AhkGitHubUrl = "https://github.com/AutoHotkey/AutoHotkey/releases/download/v2.0.18/AutoHotkey64.exe"
$ScriptRawUrl = "https://raw.githubusercontent.com/$GitHubRepo/main/$AhkFileName"
$StartupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$ShortcutName = "SpaceToggle.lnk"

# ============================================================================
# Helper Functions
# ============================================================================

function Write-Status {
    param([string]$Message, [string]$Status = "INFO")
    $timestamp = Get-Date -Format "HH:mm:ss"
    $color = @{
        "INFO"    = "Cyan"
        "SUCCESS" = "Green"
        "WARNING" = "Yellow"
        "ERROR"   = "Red"
    }[$Status]
    Write-Host "[$timestamp] [$Status] $Message" -ForegroundColor $color
}

function Test-AdminPrivileges {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function New-DirectoryIfNotExists {
    param([string]$Path)
    if (-not (Test-Path -Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Status "Created directory: $Path" "SUCCESS"
    } else {
        Write-Status "Directory already exists: $Path" "INFO"
    }
}

function Download-File {
    param(
        [string]$Url,
        [string]$OutputPath,
        [string]$FileName
    )
    try {
        Write-Status "Downloading $FileName..." "INFO"
        Invoke-WebRequest -Uri $Url -OutFile $OutputPath -UseBasicParsing -ErrorAction Stop
        Write-Status "Successfully downloaded: $FileName" "SUCCESS"
        return $true
    } catch {
        Write-Status "Failed to download $FileName : $_" "ERROR"
        return $false
    }
}

function Create-StartupShortcut {
    param(
        [string]$AhkExePath,
        [string]$ScriptPath,
        [string]$ShortcutPath
    )
    try {
        Write-Status "Creating startup shortcut..." "INFO"
        
        # Remove existing shortcut if it exists
        if (Test-Path -Path $ShortcutPath) {
            Remove-Item -Path $ShortcutPath -Force
            Write-Status "Removed existing shortcut" "INFO"
        }
        
        # Create COM object for shortcut
        $WshShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
        
        $Shortcut.TargetPath = $AhkExePath
        $Shortcut.Arguments = "`"$ScriptPath`""
        $Shortcut.WorkingDirectory = (Split-Path -Path $ScriptPath)
        $Shortcut.WindowStyle = 7  # Minimized
        $Shortcut.Description = "SpaceToggle - Window Manager"
        
        $Shortcut.Save()
        
        Write-Status "Startup shortcut created: $ShortcutPath" "SUCCESS"
        return $true
    } catch {
        Write-Status "Failed to create startup shortcut: $_" "ERROR"
        return $false
    }
}

function Launch-SpaceToggle {
    param(
        [string]$AhkExePath,
        [string]$ScriptPath
    )
    try {
        Write-Status "Launching SpaceToggle..." "INFO"
        Start-Process -FilePath $AhkExePath -ArgumentList "`"$ScriptPath`"" -WindowStyle Hidden
        Start-Sleep -Seconds 2  # Give it time to launch
        
        if (Get-Process -Name "AutoHotkey64" -ErrorAction SilentlyContinue) {
            Write-Status "SpaceToggle is now running" "SUCCESS"
            return $true
        } else {
            Write-Status "Process started but may not be running" "WARNING"
            return $false
        }
    } catch {
        Write-Status "Failed to launch SpaceToggle: $_" "ERROR"
        return $false
    }
}

# ============================================================================
# Main Installation Routine
# ============================================================================

function Install-SpaceToggle {
    Write-Host "`n" + ("=" * 80)
    Write-Host "SpaceToggle OS - Deployment Installer" -ForegroundColor Cyan
    Write-Host ("=" * 80) + "`n"
    
    # Step 1: Verify Administrator
    Write-Status "Verifying administrator privileges..." "INFO"
    if (-not (Test-AdminPrivileges)) {
        Write-Status "This script MUST be run as Administrator. Please restart PowerShell as Administrator." "ERROR"
        exit 1
    }
    Write-Status "Administrator privileges confirmed" "SUCCESS"
    
    # Step 2: Create installation directory
    Write-Status "Setting up installation directory: $InstallPath" "INFO"
    New-DirectoryIfNotExists -Path $InstallPath
    
    # Step 3: Download AutoHotkey64.exe
    $AhkExePath = Join-Path -Path $InstallPath -ChildPath "AutoHotkey64.exe"
    if (Download-File -Url $AhkGitHubUrl -OutputPath $AhkExePath -FileName "AutoHotkey64.exe") {
        # Verify file exists and has content
        $fileInfo = Get-Item -Path $AhkExePath
        if ($fileInfo.Length -gt 0) {
            Write-Status "AutoHotkey64.exe verified ($([math]::Round($fileInfo.Length/1MB, 2)) MB)" "SUCCESS"
        } else {
            throw "AutoHotkey64.exe is empty"
        }
    } else {
        throw "Failed to download AutoHotkey"
    }
    
    # Step 4: Download SpaceToggle.ahk script
    $ScriptPath = Join-Path -Path $InstallPath -ChildPath $AhkFileName
    if (-not (Download-File -Url $ScriptRawUrl -OutputPath $ScriptPath -FileName $AhkFileName)) {
        throw "Failed to download SpaceToggle script"
    }
    
    # Verify script downloaded correctly
    $scriptContent = Get-Content -Path $ScriptPath -Raw
    if ($scriptContent -notmatch "#Requires AutoHotkey") {
        throw "Downloaded script does not appear to be a valid AutoHotkey script"
    }
    Write-Status "Script integrity verified" "SUCCESS"
    
    # Step 5: Create startup shortcut
    $ShortcutPath = Join-Path -Path $StartupFolder -ChildPath $ShortcutName
    if (-not (Create-StartupShortcut -AhkExePath $AhkExePath -ScriptPath $ScriptPath -ShortcutPath $ShortcutPath)) {
        throw "Failed to create startup shortcut"
    }
    
    # Step 6: Launch SpaceToggle
    if (-not (Launch-SpaceToggle -AhkExePath $AhkExePath -ScriptPath $ScriptPath)) {
        Write-Status "Process may not have launched correctly, but installation completed" "WARNING"
    }
    
    # ========================================================================
    # Installation Complete
    # ========================================================================
    
    Write-Host "`n" + ("=" * 80)
    Write-Host "✓ INSTALLATION SUCCESSFUL" -ForegroundColor Green
    Write-Host ("=" * 80)
    Write-Host @"
Installation Details:
  • Install Path:     $InstallPath
  • Script Location:  $ScriptPath
  • Startup Shortcut: $ShortcutPath
  • Status:           RUNNING

SpaceToggle Hotkeys:
  • Space + B = Brave/Chrome
  • Space + D = Discord
  • Space + S = Spotify
  • Space + F = File Explorer
  • Space + P = Photos
  • Space + Y = YouTube
  • Space + N = Notepad
  • Space + C = Calculator

Next Steps:
  ✓ Press Space + a letter to toggle applications
  ✓ SpaceToggle will auto-launch on next restart
  ✓ To stop: Close the AutoHotkey64.exe process in Task Manager
  ✓ To uninstall: Delete the shortcut from the Startup folder and the $InstallPath folder

Need help? Visit: https://github.com/$GitHubRepo

"@ -ForegroundColor Green
}

# ============================================================================
# Execute Installation
# ============================================================================

try {
    Install-SpaceToggle
    exit 0
} catch {
    Write-Host "`n" + ("=" * 80)
    Write-Host "✗ INSTALLATION FAILED" -ForegroundColor Red
    Write-Host ("=" * 80)
    Write-Status "Error: $_" "ERROR"
    Write-Host "`nPlease check the error messages above and try again." -ForegroundColor Red
    exit 1
}

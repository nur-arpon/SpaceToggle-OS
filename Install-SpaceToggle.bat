@echo off
REM SpaceToggle OS - Simple Installation Script
REM This script downloads and installs SpaceToggle automatically

setlocal enabledelayedexpansion

echo.
echo ============================================
echo   SpaceToggle OS - Installer
echo ============================================
echo.
echo IMPORTANT: Please disable antivirus/Windows Defender temporarily
echo This is normal for portable applications
echo.
pause

REM Create installation directory
set "INSTALL_DIR=%PROGRAMFILES%\SpaceToggle"
echo Creating installation directory...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

REM Download AutoHotkey
echo.
echo Downloading AutoHotkey v2 engine...
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://github.com/AutoHotkey/AutoHotkey/releases/download/v2.0.18/AutoHotkey64.exe' -OutFile '%INSTALL_DIR%\AutoHotkey64.exe' -UseBasicParsing"

if not exist "%INSTALL_DIR%\AutoHotkey64.exe" (
    echo.
    echo ERROR: Failed to download AutoHotkey
    echo Please check your internet connection and try again
    echo Also make sure Windows Defender/Antivirus is disabled
    pause
    exit /b 1
)

echo AutoHotkey downloaded successfully!

REM Download SpaceToggle script
echo.
echo Downloading SpaceToggle script...
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/nur-arpon/SpaceToggle-OS/main/SpaceToggle.ahk' -OutFile '%INSTALL_DIR%\SpaceToggle.ahk' -UseBasicParsing"

if not exist "%INSTALL_DIR%\SpaceToggle.ahk" (
    echo.
    echo ERROR: Failed to download SpaceToggle script
    echo Please check your internet connection and try again
    pause
    exit /b 1
)

echo SpaceToggle script downloaded successfully!

REM Create Desktop Shortcut
echo.
echo Creating Desktop shortcut...
powershell -NoProfile -Command "$DesktopPath = [Environment]::GetFolderPath('Desktop'); $WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut(\"$DesktopPath\SpaceToggle.lnk\"); $Shortcut.TargetPath = '%INSTALL_DIR%\AutoHotkey64.exe'; $Shortcut.Arguments = '\"%INSTALL_DIR%\SpaceToggle.ahk\"'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Save()"

echo Desktop shortcut created!

REM Create Startup Shortcut for Auto-launch
echo.
echo Setting up auto-launch on startup...
powershell -NoProfile -Command "$StartupPath = [Environment]::GetFolderPath('StartUp'); $WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut(\"$StartupPath\SpaceToggle.lnk\"); $Shortcut.TargetPath = '%INSTALL_DIR%\AutoHotkey64.exe'; $Shortcut.Arguments = '\"%INSTALL_DIR%\SpaceToggle.ahk\"'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Save()"

echo Auto-launch configured!

REM Launch SpaceToggle
echo.
echo Launching SpaceToggle...
start "" "%INSTALL_DIR%\AutoHotkey64.exe" "%INSTALL_DIR%\SpaceToggle.ahk"

REM Success message
echo.
echo ============================================
echo   Installation Complete!
echo ============================================
echo.
echo SpaceToggle is now running!
echo.
echo - Desktop shortcut created
echo - Auto-launch on startup enabled
echo.
echo You can now close this window.
echo.
pause

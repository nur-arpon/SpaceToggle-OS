@echo off
setlocal EnableDelayedExpansion
title SpaceToggle OS - Installer

:: =========================================================================
::  SpaceToggle OS — Batch Installer
::  Double-click to run. No admin required. No antivirus tricks needed.
::  Downloads AutoHotkey v2 and SpaceToggle.ahk, sets up auto-start,
::  and launches immediately.
:: =========================================================================

set "INSTALL_DIR=%USERPROFILE%\SpaceToggle"
set "AHK_EXE=%INSTALL_DIR%\AutoHotkey64.exe"
set "SCRIPT=%INSTALL_DIR%\SpaceToggle.ahk"
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "SHORTCUT=%STARTUP%\SpaceToggle.lnk"

set "AHK_URL=https://github.com/AutoHotkey/AutoHotkey/releases/latest/download/AutoHotkey64.exe"
set "SCRIPT_URL=https://raw.githubusercontent.com/nur-arpon/SpaceToggle-OS/main/SpaceToggle.ahk"

cls
echo.
echo  ==========================================
echo   SpaceToggle OS  --  Installer
echo  ==========================================
echo.

:: ── Step 1: Create install directory ─────────────────────────────────────
echo  [1/5] Creating install directory...
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
    if errorlevel 1 (
        echo  [ERROR] Could not create directory: %INSTALL_DIR%
        goto :fail
    )
)
echo         %INSTALL_DIR%
echo.

:: ── Step 2: Download AutoHotkey v2 ───────────────────────────────────────
echo  [2/5] Downloading AutoHotkey v2 engine...
curl -L --silent --show-error --output "%AHK_EXE%" "%AHK_URL%"
if errorlevel 1 goto :no_curl

if not exist "%AHK_EXE%" (
    echo  [ERROR] Download failed. Check your internet connection.
    goto :fail
)
echo         AutoHotkey64.exe  OK
echo.

:: ── Step 3: Download SpaceToggle.ahk ─────────────────────────────────────
echo  [3/5] Downloading SpaceToggle.ahk...
curl -L --silent --show-error --output "%SCRIPT%" "%SCRIPT_URL%"
if not exist "%SCRIPT%" (
    echo  [ERROR] Download failed. Check your internet connection.
    goto :fail
)
echo         SpaceToggle.ahk  OK
echo.

:: ── Step 4: Create startup shortcut (via VBScript, no admin needed) ──────
echo  [4/5] Creating startup shortcut...
set "VBS=%TEMP%\st_setup.vbs"
(
    echo Set oShell = CreateObject("WScript.Shell"^)
    echo Set oLink  = oShell.CreateShortcut("%SHORTCUT%"^)
    echo oLink.TargetPath       = "%AHK_EXE%"
    echo oLink.Arguments        = Chr(34^) ^& "%SCRIPT%" ^& Chr(34^)
    echo oLink.WorkingDirectory = "%INSTALL_DIR%"
    echo oLink.WindowStyle      = 7
    echo oLink.Description      = "SpaceToggle OS"
    echo oLink.Save
) > "%VBS%"
cscript //nologo "%VBS%"
del "%VBS%"
if not exist "%SHORTCUT%" (
    echo  [WARN] Could not create startup shortcut. You can add it manually.
) else (
    echo         Startup shortcut created  OK
)
echo.

:: ── Step 5: Kill any existing instance and launch ────────────────────────
echo  [5/5] Launching SpaceToggle...
taskkill /F /IM AutoHotkey64.exe >nul 2>&1
timeout /t 1 /nobreak >nul
start "" "%AHK_EXE%" "%SCRIPT%"
echo         SpaceToggle is now running  OK
echo.

:: ── Done ──────────────────────────────────────────────────────────────────
echo  ==========================================
echo   SUCCESS!  SpaceToggle OS installed.
echo  ==========================================
echo.
echo   Installed to : %INSTALL_DIR%
echo   Auto-start   : Enabled (runs every login^)
echo   Status       : Running now
echo.
echo   Hold Space + key to launch your apps:
echo     B=Brave  C=Chrome  D=Discord  F=Files
echo     Q=Steam  S=Spotify  V=VLC/Media  W=WhatsApp
echo     Y=YouTube  Z=Zoom  ...and A-Z all mapped!
echo.
pause
exit /b 0

:: ── Fallback: curl not found, use PowerShell ─────────────────────────────
:no_curl
echo  (curl not found, falling back to PowerShell...)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "[Net.ServicePointManager]::SecurityProtocol='Tls12';" ^
    "Invoke-WebRequest -Uri '%AHK_URL%' -OutFile '%AHK_EXE%' -UseBasicParsing"
if not exist "%AHK_EXE%" (
    echo  [ERROR] Could not download AutoHotkey. Check internet connection.
    goto :fail
)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Invoke-WebRequest -Uri '%SCRIPT_URL%' -OutFile '%SCRIPT%' -UseBasicParsing"
if not exist "%SCRIPT%" (
    echo  [ERROR] Could not download SpaceToggle.ahk.
    goto :fail
)
goto :after_download 2>nul || goto :step4

:fail
echo.
echo  Installation failed. See error above.
echo  Try running again, or visit: https://github.com/nur-arpon/SpaceToggle-OS
echo.
pause
exit /b 1

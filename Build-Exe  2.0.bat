@echo off
setlocal
title SpaceToggle OS - Build EXE

:: =========================================================================
::  Build-Exe.bat  —  DEVELOPER TOOL
::  Run this ONCE on your machine to create Install-SpaceToggle.exe
::  Then upload the .exe to your GitHub Releases.
::
::  Requirements: PowerShell 5.1+, internet connection
::  Uses: ps2exe (installed automatically from PowerShell Gallery)
:: =========================================================================

echo.
echo  ==========================================
echo   SpaceToggle OS  --  EXE Builder
echo  ==========================================
echo.

:: Check that the source ps1 exists
if not exist "%~dp0Install-SpaceToggle.ps1" (
    echo  [ERROR] Install-SpaceToggle.ps1 not found.
    echo  Make sure this .bat is in the same folder as the .ps1 file.
    pause & exit /b 1
)

:: Install ps2exe if not already installed
echo  [1/2] Installing ps2exe module (if needed^)...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "if (-not (Get-Module -ListAvailable -Name ps2exe)) { Install-Module ps2exe -Scope CurrentUser -Force -AllowClobber }"
echo.

:: Compile ps1 → exe
echo  [2/2] Compiling Install-SpaceToggle.ps1 → Install-SpaceToggle.exe ...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Invoke-PS2EXE" ^
    "-InputFile  '%~dp0Install-SpaceToggle.ps1'" ^
    "-OutputFile '%~dp0Install-SpaceToggle.exe'" ^
    "-Title      'SpaceToggle OS Installer'" ^
    "-Description 'One-click installer for SpaceToggle OS'" ^
    "-Company    'nur-arpon'" ^
    "-Version    '2.0.0.0'" ^
    "-NoConsole:$false"

echo.
if exist "%~dp0Install-SpaceToggle.exe" (
    echo  ==========================================
    echo   SUCCESS!  Install-SpaceToggle.exe built.
    echo  ==========================================
    echo.
    echo   Next steps:
    echo   1. Test it: double-click Install-SpaceToggle.exe
    echo   2. Upload to GitHub Releases as a release asset
    echo.
) else (
    echo  [ERROR] Build failed.
    echo  Make sure you have internet access and PowerShell 5.1+
    echo.
)
pause

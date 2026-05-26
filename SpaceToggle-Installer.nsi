; SpaceToggle OS - NSIS Installer Script
; This script creates a professional one-click installer for SpaceToggle
; Compile this with NSIS to generate SpaceToggle-Installer.exe

;================================
; Include Modern UI
;================================
!include "MUI2.nsh"
!include "x64.nsh"

;================================
; Installer Settings
;================================
Name "SpaceToggle OS"
OutFile "SpaceToggle-Installer.exe"
InstallDir "$PROGRAMFILES\SpaceToggle"
InstallDirRegKey HKCU "Software\SpaceToggle" "InstallDir"

; Request admin privileges
RequestExecutionLevel admin

; Compression
SetCompressor /SOLID lzma
ShowInstDetails show

;================================
; MUI Settings
;================================
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

;================================
; Installer Sections
;================================

Section "Install"
  SetOutPath "$INSTDIR"
  
  ; Download AutoHotkey64.exe
  DetailPrint "Downloading AutoHotkey v2 engine..."
  NSCurl::http GET "https://github.com/AutoHotkey/AutoHotkey/releases/download/v2.0.18/AutoHotkey64.exe" "$INSTDIR\AutoHotkey64.exe"
  Pop $0
  ${If} $0 != "OK"
    DetailPrint "Error downloading AutoHotkey: $0"
    Abort "Failed to download AutoHotkey. Please check your internet connection and disable antivirus/firewall temporarily."
  ${EndIf}
  DetailPrint "AutoHotkey downloaded successfully"
  
  ; Download SpaceToggle.ahk
  DetailPrint "Downloading SpaceToggle script..."
  NSCurl::http GET "https://raw.githubusercontent.com/nur-arpon/SpaceToggle-OS/main/SpaceToggle.ahk" "$INSTDIR\SpaceToggle.ahk"
  Pop $0
  ${If} $0 != "OK"
    DetailPrint "Error downloading SpaceToggle script: $0"
    Abort "Failed to download SpaceToggle script. Please check your internet connection and disable antivirus/firewall temporarily."
  ${EndIf}
  DetailPrint "SpaceToggle script downloaded successfully"
  
  ; Create Desktop Shortcut
  DetailPrint "Creating Desktop shortcut..."
  CreateShortCut "$DESKTOP\SpaceToggle.lnk" "$INSTDIR\AutoHotkey64.exe" "$INSTDIR\SpaceToggle.ahk"
  DetailPrint "Desktop shortcut created"
  
  ; Create Startup Shortcut for Auto-launch on Boot
  DetailPrint "Setting up auto-launch on startup..."
  CreateDirectory "$APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
  CreateShortCut "$APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\SpaceToggle.lnk" "$INSTDIR\AutoHotkey64.exe" "$INSTDIR\SpaceToggle.ahk"
  DetailPrint "Auto-launch configured"
  
  ; Save install directory to registry
  WriteRegStr HKCU "Software\SpaceToggle" "InstallDir" "$INSTDIR"
  
  ; Launch SpaceToggle immediately
  DetailPrint "Launching SpaceToggle..."
  Exec "$INSTDIR\AutoHotkey64.exe $INSTDIR\SpaceToggle.ahk"
  
SectionEnd

;================================
; Uninstaller Section
;================================

Section "Uninstall"
  ; Remove files
  Delete "$INSTDIR\AutoHotkey64.exe"
  Delete "$INSTDIR\SpaceToggle.ahk"
  RMDir "$INSTDIR"
  
  ; Remove shortcuts
  Delete "$DESKTOP\SpaceToggle.lnk"
  Delete "$APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\SpaceToggle.lnk"
  
  ; Remove registry
  DeleteRegKey HKCU "Software\SpaceToggle"
  
SectionEnd

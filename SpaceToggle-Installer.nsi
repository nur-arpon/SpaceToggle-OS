; SpaceToggle OS - NSIS Installer Script (Simple Version)
; This script creates a professional one-click installer for SpaceToggle
; No external plugins needed!

;================================
; Include Modern UI
;================================
!include "MUI2.nsh"

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
  
  ; Show warning about antivirus
  MessageBox MB_OKCANCEL "IMPORTANT:$\n$\nBefore continuing, please temporarily disable:$\n- Windows Defender$\n- Antivirus software$\n$\nThis is normal for portable applications.$\n$\nClick OK to continue, or CANCEL to abort." IDOK continue IDCANCEL abort
  
  abort:
    Abort "Installation cancelled"
  
  continue:
  
  ; Download AutoHotkey64.exe using PowerShell
  DetailPrint "Downloading AutoHotkey v2 engine..."
  nsExec::ExecToLog 'powershell -NoProfile -Command "Invoke-WebRequest -Uri ''https://github.com/AutoHotkey/AutoHotkey/releases/download/v2.0.18/AutoHotkey64.exe'' -OutFile ''$INSTDIR\AutoHotkey64.exe'' -UseBasicParsing"'
  Pop $0
  
  ${If} $0 != 0
    DetailPrint "Error downloading AutoHotkey"
    MessageBox MB_OK "Failed to download AutoHotkey. Please check:$\n- Internet connection$\n- Antivirus/Firewall settings$\n$\nTry disabling Windows Defender temporarily."
    Abort "Download failed"
  ${EndIf}
  DetailPrint "AutoHotkey downloaded successfully"
  
  ; Download SpaceToggle.ahk using PowerShell
  DetailPrint "Downloading SpaceToggle script..."
  nsExec::ExecToLog 'powershell -NoProfile -Command "Invoke-WebRequest -Uri ''https://raw.githubusercontent.com/nur-arpon/SpaceToggle-OS/main/SpaceToggle.ahk'' -OutFile ''$INSTDIR\SpaceToggle.ahk'' -UseBasicParsing"'
  Pop $0
  
  ${If} $0 != 0
    DetailPrint "Error downloading SpaceToggle script"
    MessageBox MB_OK "Failed to download SpaceToggle script. Please check your internet connection."
    Abort "Download failed"
  ${EndIf}
  DetailPrint "SpaceToggle script downloaded successfully"
  
  ; Create Desktop Shortcut
  DetailPrint "Creating Desktop shortcut..."
  CreateShortCut "$DESKTOP\SpaceToggle.lnk" "$INSTDIR\AutoHotkey64.exe" '"$INSTDIR\SpaceToggle.ahk"'
  DetailPrint "Desktop shortcut created"
  
  ; Create Startup Shortcut for Auto-launch on Boot
  DetailPrint "Setting up auto-launch on startup..."
  CreateDirectory "$APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
  CreateShortCut "$APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\SpaceToggle.lnk" "$INSTDIR\AutoHotkey64.exe" '"$INSTDIR\SpaceToggle.ahk"'
  DetailPrint "Auto-launch configured"
  
  ; Save install directory to registry
  WriteRegStr HKCU "Software\SpaceToggle" "InstallDir" "$INSTDIR"
  
  ; Launch SpaceToggle immediately
  DetailPrint "Launching SpaceToggle..."
  Exec '"$INSTDIR\AutoHotkey64.exe" "$INSTDIR\SpaceToggle.ahk"'
  
  DetailPrint "Installation Complete!"
  
SectionEnd

;================================
; Uninstaller Section
;================================

Section "Uninstall"
  ; Kill running process
  nsExec::Exec 'taskkill /IM AutoHotkey64.exe /F'
  
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

[Setup]
; These top lines are required by Inno Setup
AppName=SpaceToggle
AppVersion=11.5
DefaultDirName={autopf}\SpaceToggle
DefaultGroupName=SpaceToggle
OutputBaseFilename=SpaceToggle-Installer-v11
Compression=lzma
SolidCompression=yes
; This tells the compiler where to put your installer file
OutputDir=Output

[Files]
; Copy your actual script file to the install folder
Source: "spacetoggle v11.5(with proper app interface).ps1"; DestDir: "{app}"; Flags: ignoreversion
; Copy your icon file
Source: "space-rocket.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
; Create a shortcut that points to your script
Name: "{autodesktop}\SpaceToggle v11"; Filename: "pwsh.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\spacetoggle v11.5(with proper app interface).ps1"""; IconFilename: "{app}\space-rocket.ico"
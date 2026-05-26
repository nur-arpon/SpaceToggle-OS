# SpaceToggle OS 🚀

SPACE+INITIAL of your desired app= BOOM ! It opens , press same thing again and BOOM! it closes... A lightning-fast, minimalist window manager for Windows, powered by AutoHotkey v2.

Stop Alt-Tabbing through 20 windows. SpaceToggle turns your `Spacebar` into a hyper-modifier. Hold Spacebar and tap a letter to instantly summon or banish your most used apps.

## Features
- **Zero-Latency Toggling:** Instantly show, hide, or launch applications.
- **Smart Detection:** If the app is open but buried, it brings it to the front. If it's on top, it minimizes it. If it's closed, it launches it.
- **Non-Intrusive:** Your Spacebar still functions perfectly for normal typing.

## Installation
1. Download and install [AutoHotkey v2](https://www.autohotkey.com/).
2. Download the `SpaceToggle.ahk` file from this repository.
3. Double-click `SpaceToggle.ahk` to run it. (A green 'H' icon will appear in your system tray).

## Default Hotkeys
- `Space + B` = Toggle Browser
- `Space + N` = Toggle Notepad
- `Space + S` = Toggle Spotify
- `Space + C` = Toggle Calculator

## Customization
Right-click the script and select "Edit". You can easily copy and paste the blocks of code to add your own shortcuts. Just replace the `ahk_exe` names with the applications you want to control!

## Start with Windows
To have this run automatically when you turn on your PC:
1. Press `Win + R`, type `shell:startup`, and hit Enter.
2. Create a shortcut of the `SpaceToggle.ahk` file and place it in that folder.

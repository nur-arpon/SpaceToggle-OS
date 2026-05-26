# SpaceToggle OS ⚡

> **Hold `Space` + tap a letter → your app opens instantly.**  
> Tap the same combo again → it minimizes. It's that simple.

A lightning-fast, zero-overhead app launcher for Windows 10/11, powered by AutoHotkey v2.  
No Alt-Tab. No taskbar clicking. Just **Space + key**.

---

## ⬇️ Download & Install (One Step)

**Option 1 — EXE (Recommended, easiest)**

👉 **[Download Install-SpaceToggle.exe](../../releases/latest)**

Double-click it. Done. AutoHotkey downloads itself, the script installs, and it starts running immediately.

---

**Option 2 — BAT file (also one step)**

👉 **[Download Install-SpaceToggle.bat](../../releases/latest)**

Double-click it. Same result.

---

**Option 3 — PowerShell one-liner (advanced)**

```powershell
irm https://raw.githubusercontent.com/nur-arpon/SpaceToggle-OS/main/Install-SpaceToggle.ps1 | iex
```

Open PowerShell, paste, press Enter. Done.

---

### What the installer does automatically:
- ✅ Downloads AutoHotkey v2 engine (no separate install needed)
- ✅ Downloads `SpaceToggle.ahk` from this repo
- ✅ Creates a startup shortcut (auto-runs every time you log in)
- ✅ Launches immediately — no restart needed
- ✅ Installs to `%USERPROFILE%\SpaceToggle\` — **no admin required**

---

## ⌨️ Full Hotkey Map

Hold **`Space`**, then tap the key. Release Space when done.

| Key | App / Site | Key | App / Site |
|-----|-----------|-----|-----------|
| `A` | Google Gemini (AI) | `N` | Google Keep (Notes) |
| `B` | Brave Browser | `O` | Google Drive |
| `C` | Chrome | `P` | Google Photos |
| `D` | Discord | `Q` | Steam |
| `E` | Google Sheets | `R` | Google Search |
| `F` | File Explorer | `S` | Spotify |
| `G` | Gmail | `T` | Terminal |
| `H` | GitHub | `U` | Google Classroom |
| `I` | Instagram | `V` | VLC / Media Player |
| `J` | Google Docs | `W` | WhatsApp |
| `K` | Google Calendar | `X` | Twitter / X |
| `L` | LinkedIn | `Y` | YouTube |
| `M` | Cinema OS | `Z` | Zoom |

> **Desktop apps** (Discord, Spotify, Steam, VLC, WhatsApp, Zoom) open the installed app if found on your PC. If not installed, they fall back to the web version automatically.

---

## 🔄 How toggling works

```
App is closed          → Opens / Launches it
App is open (focused)  → Minimizes it  
App is open (hidden)   → Brings it to front
```

Your **spacebar still works normally** while typing. The hotkeys only fire when you hold Space before a key.

---

## 🗑️ Uninstall

1. Delete the folder: `C:\Users\YourName\SpaceToggle\`
2. Press `Win + R`, type `shell:startup`, delete the `SpaceToggle.lnk` shortcut

That's it. Nothing in the registry.

---

## 🛠️ Customize

Open `SpaceToggle.ahk` in any text editor and change the URLs or app names to whatever you want. Then re-run the installer (it replaces the old version).

---

## 📋 Requirements

- Windows 10 or 11 (64-bit)
- Internet connection for first install only

No AutoHotkey pre-installation needed. The installer handles it.

---

## 📄 License

MIT — free to use, modify, and share.

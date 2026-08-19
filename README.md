# Discord iGPU Preference

A lightweight Windows Batch script that automatically allocates **Discord**, **Discord PTB**, and **Discord Canary** to **Power Saving mode (iGPU)** in Windows Graphics Settings. 

Perfect for laptop users looking to save battery life, or gamers wanting to prevent Discord from hogging dedicated GPU (dGPU) resources and causing in-game stuttering.

## ✨ Features
- **Auto-Detection**: Automatically scans standard installation paths (`LocalAppData`, `ProgramData`, `Program Files`) to locate your Discord executables.
- **Multi-Version Support**: Supports Discord Stable, Discord PTB, and Discord Canary.
- **Interactive Menu**: Choose to apply the fix to a specific version or select all at once.
- **No GUI Hassle**: Skip manual clicking through Windows Settings > System > Display > Graphics.

## 🚀 How to Use
1. **Download** the [script](https://github.com/crystalglassesman/Discord-iGPU/releases/download/v1.0/discordigpu.bat) from this repository.
2. **Right-click** the file and select **Run as Administrator** (required to modify registry entries).
3. Select your preferred option (`1`, `2`, `3`, or `A` for All).
4. Press `Y` to automatically restart Discord and apply changes immediately, or `N` to restart manually later.

## 🛠️ How It Works (Technical Details)
Windows stores per-app GPU preferences inside the Registry. This script writes directly to the following key:
`HKCU\Software\Microsoft\DirectX\UserGpuPreferences`

It dynamically fetches the absolute path of your current `app-*` version folder and appends the `GpuPreference=1;` (Power Saving) value flag.

## ❓ How to Revert
If you wish to reset Discord back to Windows default graphics handling:
1. Open Windows **Settings** > **System** > **Display** > **Graphics**.
2. Find **Discord** in the app list.
3. Click on it and choose **Remove**, or click **Options** and set it back to "Let Windows decide".

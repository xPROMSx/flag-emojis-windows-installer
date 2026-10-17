<div align="center">

[🇷🇺 Русский](README.md) · 🇬🇧 **English** · [🇪🇬 العربية](README_AR.md) · [🇮🇷 فارسی](README_FA.md) · [🇨🇳 简体中文](README_ZH_CN.md) · [🇪🇸 Español](README_ES.md) · [🇹🇷 Türkçe](README_TR.md)

<img src="assets/branding/hero.svg" width="100%" alt="Flag Emojis Windows Installer: real country flags instead of FI, RU and DE letter codes">

<h1>Flag Emojis Windows Installer</h1>

### Country flag emojis on Windows 11 and Chrome. No more letter codes.

**One installer · Keep familiar Windows emoji · Safe rollback**

![Windows](https://img.shields.io/badge/Windows-11-0078D4?logo=windows11&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-247A65)

[Installation](#installation) · [Testing](docs/INSTALLER-TESTS.md) · [Support development](docs/SUPPORT.en.md) · [Issues](https://github.com/xPROMSx/flag-emojis-windows-installer/issues)

</div>

## ✨ Why this project?

Windows does not display most country flags as colorful emoji. Chrome may show letter pairs such as `FI` and `DE` instead of 🇫🇮 and 🇩🇪. A modified emoji font can solve this, but installing it through Windows does not always change the primary font registration used by Chromium.

**Flag Emojis Windows Installer** provides an easy way to enable flag emojis and, when needed, restore the original Microsoft font, without PowerShell commands or manual registry edits.

## ⚙️ Features

- **A few clicks to install.** A single EXE, an administrator prompt, and clear feedback.
- **Flags in browsers.** Set up Windows to display country flags in Chrome, Edge and other Chromium-based browsers.
- **Original font preserved.** The original Windows font is never overwritten or removed.
- **Install and remove with ease.** Run the installer again or restore your previous font settings when uninstalling.
- **Verified download.** Download the font from its original project and check the file before installing.
- **No background clutter.** No startup services, telemetry or forced updates.

<a id="installation"></a>

## 🚀 Installation and removal

**Installation**

1. Download `FlagEmojisSetup-vx.x.x.exe` from [GitHub Releases](https://github.com/xPROMSx/flag-emojis-windows-installer/releases).
2. Run the file, approve the Windows administrator prompt and follow the setup instructions. The installer downloads a verified font and configures country flags automatically.
3. **Restart Windows** to apply the changes.

**Uninstallation**

Open **Settings → Apps → Installed apps**, find **Flag Emojis Windows Installer**, and select **Uninstall**. The app restores your previous font settings and removes its own files without touching the original Windows font. **Restart Windows** after uninstalling.

## 📚 Technical notes

The first version targets **Windows 11** and Chromium-based browsers. System-wide installation will require administrator rights and a restart.

This repository is dedicated to the **installer**, not creating new emoji glyphs or building the font itself. Font provenance, usage considerations, and required copyright notices are explained in [NOTICE.md](NOTICE.md).

**Code license:** [MIT](LICENSE). Rights to the font components must be considered separately from the installer license.

## 💬 Feedback

Use [GitHub Issues](https://github.com/xPROMSx/flag-emojis-windows-installer/issues) for bug reports and suggestions.

---

## ❤️ Support development

If you find this project useful, you can voluntarily [support its development](docs/SUPPORT.en.md). The project and all its features remain free and open source regardless of donations.

<div align="center">

**Country flags on Windows and Chrome. Simple setup, no unnecessary steps.**

⭐ If you like this project, consider [giving it a Star](https://github.com/xPROMSx/flag-emojis-windows-installer). It helps others discover it.

[Installation](#installation) · [Releases](https://github.com/xPROMSx/flag-emojis-windows-installer/releases) · [Issues](https://github.com/xPROMSx/flag-emojis-windows-installer/issues)

</div>

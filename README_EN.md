<div align="center">

[Русский](README.md) · **English**

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
- **Correct registration.** Check the system's `Segoe UI Emoji (TrueType)` entry and point it to the installed flag-enabled font.
- **Original font preserved.** Never overwrite or delete Microsoft's `seguiemj.ttf`.
- **Repeatable install and uninstall.** Detect existing state, modify only owned files, and restore previous settings.
- **Verified downloads.** Pin the font version and validate its SHA-256 before making system changes; never execute remote scripts.
- **No background services.** No startup processes, telemetry, or forced updates.

<a id="installation"></a>

## 🚀 Installation

Download `FlagEmojisSetup-v0.1.0.exe` from [GitHub Releases](https://github.com/xPROMSx/flag-emojis-windows-installer/releases), run it with administrator rights, and follow the setup wizard. The installer downloads and verifies the pinned font before changing the Windows configuration.

**Restart Windows** after installation. To remove it, use Settings → Apps → Installed apps. The previous font mapping is restored during uninstall. See [testing and limitations](docs/INSTALLER-TESTS.md).

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

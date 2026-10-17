<div align="center">

[🇷🇺 Русский](README.md) · 🇬🇧 **English**

<h1>FLAG EMOJIS WINDOWS INSTALLER</h1>

### Country flag emojis on Windows and Chromium browsers, without manual fixes

**🇫🇮 🇷🇺 🇩🇪 🇺🇸 · Windows 11 · Simple setup · Safe rollback**

[Project status](#status) · [Report an issue](https://github.com/xPROMSx/flag-emojis-windows-installer/issues) · [License](LICENSE)

</div>

> **Work in progress.** No installer EXE has been released yet. Do not download or run files claiming to be an official release of this project.

## ✨ Why this project?

Windows does not display most country flags as colorful emoji. Chrome may show letter pairs such as `FI` and `DE` instead of 🇫🇮 and 🇩🇪. A modified emoji font can solve this, but installing it through Windows does not always change the primary font registration used by Chromium.

**Flag Emojis Windows Installer** aims to provide an easy way to enable flag emojis and, when needed, restore the original Microsoft font, without PowerShell commands or manual registry edits.

## ⚙️ Planned features

- **A few clicks to install.** A single EXE, an administrator prompt, and clear feedback.
- **Correct registration.** Check the system's `Segoe UI Emoji (TrueType)` entry and point it to the installed flag-enabled font.
- **Original font preserved.** Never overwrite or delete Microsoft's `seguiemj.ttf`.
- **Repeatable install and uninstall.** Detect existing state, modify only owned files, and restore previous settings.
- **Verified downloads.** Pin the font version and validate its SHA-256 before making system changes; never execute remote scripts.
- **No background services.** No startup processes, telemetry, or forced updates.

## 🚀 Installation

The installer **is not yet available**. After successful validation, it will be published in [GitHub Releases](https://github.com/xPROMSx/flag-emojis-windows-installer/releases).

The intended flow is simple: download the EXE, run it, approve the Windows prompt, and restart. Uninstall must restore the previous font selection.

## <a id="status"></a>🛠️ Development status

| Component | Status |
| --- | --- |
| Repository presentation and layout | In preparation |
| Install and repeat installation | Not implemented |
| Uninstall and rollback | Not implemented |
| Automated EXE build | Not configured |
| Windows 11 / Chrome installer testing | Not performed |

The project will not be presented as ready until install, repeat install, failed downloads, uninstall, and rollback have been tested.

## 📚 Technical notes

The first version targets **Windows 11** and Chromium-based browsers. System-wide installation will require administrator rights and a restart.

This repository is dedicated to the **installer**, not creating new emoji glyphs or building the font itself. Font provenance, usage considerations, and required copyright notices are explained in [NOTICE.md](NOTICE.md).

**Code license:** [MIT](LICENSE). Rights to the font components must be considered separately from the installer license.

## 💬 Feedback

Use [GitHub Issues](https://github.com/xPROMSx/flag-emojis-windows-installer/issues) for bug reports and suggestions. There is no testable installer EXE yet.

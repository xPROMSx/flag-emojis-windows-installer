# Flag Emojis Windows Installer v0.1.0

First release of the simple Windows 11 flag emoji installer.

### Included
- Single EXE with Russian/English interface and an administrator prompt.
- Automatic download of the pinned [upstream v2.3.0 font](https://github.com/Chasmical/flag-emojis-for-windows/releases/tag/v2.3.0), SHA-256 verified before installation.
- Safe replacement of the primary Segoe UI Emoji font registry mapping without overwriting the original Windows font.
- Reinstallation and automatic restore of a verified previous font registration when uninstalling.
- Windows 11 automated install/reinstall/uninstall/rollback and error-path tests in GitHub Actions.

### Installation
1. Download `FlagEmojisSetup-v0.1.0.exe` below.
2. Run the installer, confirm administrator permissions, and restart Windows.
3. Verify country flags in Chrome, Edge, Brave or other Chromium-based browsers.
4. To remove it, use Windows Settings > Apps > Installed apps.

### Notes
- Requires Windows 11 x64 and internet access to retrieve the pinned font.
- This EXE is unsigned; Windows SmartScreen may display an unknown publisher warning.
- No system font is bundled in the EXE. See [NOTICE.md](https://github.com/xPROMSx/flag-emojis-windows-installer/blob/main/NOTICE.md) for original authorship and third-party licensing considerations.
- SHA-256 for this installer is in the attached `SHA256SUMS.txt`.

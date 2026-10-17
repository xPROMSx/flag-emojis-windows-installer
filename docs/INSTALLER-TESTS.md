# Windows installer acceptance checklist

The installer is intentionally narrow: it changes only the primary Segoe UI Emoji font registration, and it must never overwrite Microsoft's `seguiemj.ttf`.

## CI coverage

GitHub Actions compiles `installer/setup.iss` with the Windows runner's Inno Setup compiler, checks the pinned upstream SHA-256 and verifies that the EXE is produced. **A successful build is not proof that installation or font rendering works.**

## Manual acceptance on a disposable Windows 11 VM

Use a test VM or a restorable snapshot. Do **not** use an active production machine as the first test.

1. Confirm `HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts\Segoe UI Emoji (TrueType)` points to `seguiemj.ttf`.
2. Install the EXE with elevation and internet access. Restart. Confirm Chrome displays 🇫🇮 🇷🇺 🇩🇪 and the original `C:\Windows\Fonts\seguiemj.ttf` remains unchanged.
3. Run the same EXE again. It should detect the verified installation and avoid downloading or duplicating the font.
4. Disconnect network on a clean snapshot and try installation. It must fail without changing the primary registry value or creating a font file.
5. On a clean snapshot, pre-set the primary mapping to a different font. The installer must refuse to overwrite it.
6. Uninstall using Windows Settings. Restart. Confirm the original primary mapping, font file and original Segoe UI Emoji behavior are restored.
7. Test an altered font hash and changed primary mapping after installation. Uninstall should refuse destructive cleanup.

### Safe verification commands

Run in PowerShell on the disposable test system:

```powershell
$key = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
Get-ItemPropertyValue -Path $key -Name 'Segoe UI Emoji (TrueType)'
Get-FileHash -Algorithm SHA256 "$env:WINDIR\Fonts\seguiemj.ttf"
Get-ChildItem "$env:WINDIR\Fonts\FEWI-SegoeEmoji-*" -ErrorAction SilentlyContinue
```

No Windows registry edits or privileged installation tests are executed on GitHub-hosted runners.

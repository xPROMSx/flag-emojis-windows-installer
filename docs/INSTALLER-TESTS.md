# Windows installer acceptance checklist

The installer is intentionally narrow: it changes only the primary Segoe UI Emoji font registration, and it must never overwrite Microsoft's `seguiemj.ttf`.

## CI coverage

GitHub Actions compiles `installer/setup.iss`, checks the pinned upstream SHA-256, and runs `tests/smoke-installer.ps1` on a disposable GitHub-hosted Windows runner. The smoke test exercises real installation from a pristine `seguiemj.ttf` mapping, checks the downloaded font SHA-256 and original font integrity, runs the installer again, verifies that altered font mappings are never overwritten or destructively removed, tests an unreachable font download, then uninstalls and verifies registry restoration. **This does not prove that Chrome visually renders flags after a reboot**; that part still needs one manual acceptance test.

## Manual acceptance on a disposable Windows 11 VM

Use a test VM or a restorable snapshot. Do **not** use an active production machine as the first test.

1. Confirm `HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts\Segoe UI Emoji (TrueType)` points to `seguiemj.ttf`.
2. Install the EXE with elevation and internet access. Restart. Confirm Chrome displays 🇫🇮 🇷🇺 🇩🇪 and the original `C:\Windows\Fonts\seguiemj.ttf` remains unchanged.
3. Run the same EXE again. It should detect the verified installation and avoid downloading or duplicating the font.
4. Disconnect network on a clean snapshot and try installation. It must fail without changing the primary registry value or creating a font file.
5. On a clean snapshot, switch the primary mapping to a known manually installed `Segoe.UI.Emoji.with.Twemoji.Flags.ttf` from upstream v2.2.0 or v2.3.0. The EXE must preserve this prior mapping, install its own verified font, and restore the manual mapping after uninstall without deleting the manually installed file.
6. On a clean snapshot, pre-set the primary mapping to an unknown or altered font. The installer must refuse to overwrite it.
7. Uninstall using Windows Settings. Restart. Confirm the previous primary mapping, original font file and previous Segoe UI Emoji behavior are restored.
8. Test an altered font hash and changed primary mapping after installation. Uninstall should refuse destructive cleanup.

### Safe verification commands

Run in PowerShell on the disposable test system:

```powershell
$key = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
Get-ItemPropertyValue -Path $key -Name 'Segoe UI Emoji (TrueType)'
Get-FileHash -Algorithm SHA256 "$env:WINDIR\Fonts\seguiemj.ttf"
Get-ChildItem "$env:WINDIR\Fonts\FEWI-SegoeEmoji-*" -ErrorAction SilentlyContinue
```

The automated test changes the system font **only inside the ephemeral GitHub-hosted runner**, refuses execution elsewhere, and requires administrator privileges. It never runs on a developer workstation.

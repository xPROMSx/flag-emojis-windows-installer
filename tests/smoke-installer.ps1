# Integration test on a disposable GitHub-hosted Windows runner.
# Never run this script on a workstation: it changes the system emoji font.
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$registry = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
$ownership = 'HKLM:\SOFTWARE\xPROMSx\FlagEmojisWindowsInstaller'
$original = 'seguiemj.ttf'
$installed = 'FEWI-SegoeEmoji-2.3.0.ttf'
$expectedHash = '83d29681ba6cb661500dbd1282f976cd4c498dc64479ba5d7a49877f40cabd19'
$originalPath = Join-Path $env:WINDIR 'Fonts\seguiemj.ttf'
$installedPath = Join-Path $env:WINDIR "Fonts\$installed"
$setup = Get-ChildItem -LiteralPath (Join-Path $PSScriptRoot '..\dist') -Filter 'FlagEmojisSetup-v*.exe' -File |
    Select-Object -First 1
if (-not $setup) { throw 'Installer EXE is missing' }

# Refuse to modify developer or self-hosted machines.
if ($env:GITHUB_ACTIONS -ne 'true' -or $env:RUNNER_ENVIRONMENT -ne 'github-hosted') {
    throw 'This integration test is restricted to GitHub-hosted Actions runners.'
}
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]::new($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'The runner must have administrator privileges for the installer test.'
}

function Get-ActiveFont {
    Get-ItemPropertyValue -LiteralPath $registry -Name 'Segoe UI Emoji (TrueType)' -ErrorAction Stop
}
function Assert-Condition([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw $Message }
}
function Invoke-Installer([string]$ExePath, [string]$LogPath) {
    $quote = [char]34
    $args = @('/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART', ('/LOG=' + $quote + $LogPath + $quote))
    $process = Start-Process -FilePath $ExePath -ArgumentList $args -Wait -PassThru
    Assert-Condition ($process.ExitCode -eq 0) "Installer/uninstaller exited $($process.ExitCode). See $LogPath"
}

Assert-Condition ((Get-ActiveFont) -eq $original) 'Runner is not in pristine Windows font state'
Assert-Condition (Test-Path -LiteralPath $originalPath) 'Microsoft Segoe UI Emoji was not found'
Assert-Condition (-not (Test-Path -LiteralPath $ownership)) 'Existing installer metadata in runner'
Assert-Condition (-not (Test-Path -LiteralPath $installedPath)) 'Existing installer font in runner'
$originalHash = (Get-FileHash -LiteralPath $originalPath -Algorithm SHA256).Hash

Write-Host 'PASS: pristine Windows registration verified'
Invoke-Installer $setup.FullName (Join-Path $env:RUNNER_TEMP 'flag-emojis-install.log')
Assert-Condition ((Get-ActiveFont) -eq $installed) 'Primary font mapping not switched'
Assert-Condition ((Get-ItemPropertyValue -LiteralPath $ownership -Name OriginalFont) -eq $original) 'Original mapping not backed up'
Assert-Condition (Test-Path -LiteralPath $installedPath) 'Installed TTF is missing'
Assert-Condition (((Get-FileHash -LiteralPath $installedPath -Algorithm SHA256).Hash).ToLowerInvariant() -eq $expectedHash) 'Installed TTF failed SHA-256 verification'
Assert-Condition ((Get-FileHash -LiteralPath $originalPath -Algorithm SHA256).Hash -eq $originalHash) 'Microsoft font changed unexpectedly'
Write-Host 'PASS: installation, font hash, registry backup, original integrity'

Invoke-Installer $setup.FullName (Join-Path $env:RUNNER_TEMP 'flag-emojis-reinstall.log')
Assert-Condition ((Get-ActiveFont) -eq $installed) 'Repeat install changed primary registration'
Assert-Condition ((Get-ItemPropertyValue -LiteralPath $ownership -Name OriginalFont) -eq $original) 'Repeat install changed original backup'
Assert-Condition (((Get-FileHash -LiteralPath $installedPath -Algorithm SHA256).Hash).ToLowerInvariant() -eq $expectedHash) 'Repeat install changed installed file'
Write-Host 'PASS: repeated install is idempotent'

$uninstaller = Join-Path $env:ProgramFiles 'Flag Emojis Windows Installer\unins000.exe'
Assert-Condition (Test-Path -LiteralPath $uninstaller) 'Expected uninstaller is missing'

# External registry tampering must NOT cause destructive uninstallation.
$foreign = 'foreign-font-not-installed.ttf'
try {
    Set-ItemProperty -LiteralPath $registry -Name 'Segoe UI Emoji (TrueType)' -Value $foreign
    $tamperArgs = @('/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART')
    $tamperResult = Start-Process -FilePath $uninstaller -ArgumentList $tamperArgs -Wait -PassThru
    Assert-Condition ((Get-ActiveFont) -eq $foreign) 'Tampered font setting was overwritten by uninstaller'
    Assert-Condition (Test-Path -LiteralPath $ownership) 'Uninstaller destroyed ownership metadata despite conflict'
    Assert-Condition (Test-Path -LiteralPath $installedPath) 'Uninstaller destroyed font despite conflict'
    Write-Host 'PASS: uninstaller rejects externally changed font registration'
} finally {
    Set-ItemProperty -LiteralPath $registry -Name 'Segoe UI Emoji (TrueType)' -Value $installed
}

Invoke-Installer $uninstaller (Join-Path $env:RUNNER_TEMP 'flag-emojis-uninstall.log')
Assert-Condition ((Get-ActiveFont) -eq $original) 'Original font mapping not restored'
Assert-Condition (-not (Test-Path -LiteralPath $ownership)) 'Installer metadata remains after uninstall'
Assert-Condition ((Get-FileHash -LiteralPath $originalPath -Algorithm SHA256).Hash -eq $originalHash) 'Original Segoe UI Emoji altered after uninstall'
if (Test-Path -LiteralPath $installedPath) {
    Write-Warning 'Owned TTF remains until reboot, as permitted when the font is in use'
} else {
    Write-Host 'PASS: owned TTF removed on uninstall'
}
Write-Host 'PASS: uninstall restored pristine font configuration'
'PASS: automated installation + repeat + rollback checks' | Add-Content -Path $env:GITHUB_STEP_SUMMARY

# Negative cases on the pristine runner after successfully verifying rollback.
try {
    Set-ItemProperty -LiteralPath $registry -Name 'Segoe UI Emoji (TrueType)' -Value 'foreign-font-not-installed.ttf'
    $badFontResult = Start-Process -FilePath $setup.FullName -ArgumentList @('/VERYSILENT','/SUPPRESSMSGBOXES','/NORESTART') -Wait -PassThru
    Assert-Condition ((Get-ActiveFont) -eq 'foreign-font-not-installed.ttf') 'Installer unexpectedly overwrote an unknown font'
    Assert-Condition (-not (Test-Path -LiteralPath $ownership)) 'Installer added metadata on conflict'
    Assert-Condition (-not (Test-Path -LiteralPath $installedPath)) 'Installer copied font on conflict'
    Write-Host 'PASS: installer refuses unknown active font'
} finally {
    Set-ItemProperty -LiteralPath $registry -Name 'Segoe UI Emoji (TrueType)' -Value $original
}

$offlineSetup = Join-Path $PSScriptRoot '..\dist\FlagEmojisSetup-UnreachableTest.exe'
Assert-Condition (Test-Path -LiteralPath $offlineSetup) 'Network failure test EXE is missing'
$networkResult = Start-Process -FilePath $offlineSetup -ArgumentList @('/VERYSILENT','/SUPPRESSMSGBOXES','/NORESTART') -Wait -PassThru
Assert-Condition ((Get-ActiveFont) -eq $original) 'Failed download changed primary font registration'
Assert-Condition (-not (Test-Path -LiteralPath $ownership)) 'Failed download wrote ownership metadata'
Assert-Condition (-not (Test-Path -LiteralPath $installedPath)) 'Failed download copied an owned font'
Assert-Condition ((Get-FileHash -LiteralPath $originalPath -Algorithm SHA256).Hash -eq $originalHash) 'Failed download modified Microsoft font'
Write-Host 'PASS: unavailable font download causes no font or registry changes'
'PASS: negative font conflict, tampered uninstall and download failure' | Add-Content -Path $env:GITHUB_STEP_SUMMARY

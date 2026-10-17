; Flag Emojis Windows Installer - 0.1.0
; The modified font is downloaded from a pinned upstream release, never bundled.
; Original Microsoft seguiemj.ttf is never replaced or deleted.

#define AppVersion "0.1.0"
#define FontVersion "2.3.0"

[Setup]
AppId={{0E77C4B7-AD07-4713-B2D7-029EA901D42F}
AppName=Flag Emojis Windows Installer
AppVersion={#AppVersion}
AppVerName=Flag Emojis Windows Installer {#AppVersion}
AppPublisher=xPROMSx
AppPublisherURL=https://github.com/xPROMSx/flag-emojis-windows-installer
AppSupportURL=https://github.com/xPROMSx/flag-emojis-windows-installer/issues
DefaultDirName={autopf}\Flag Emojis Windows Installer
DisableDirPage=yes
DisableProgramGroupPage=yes
PrivilegesRequired=admin
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0.22000
WizardStyle=modern
OutputDir=..\dist
OutputBaseFilename=FlagEmojisSetup-v{#AppVersion}
Compression=lzma
SolidCompression=yes
UninstallDisplayName=Flag Emojis Windows Installer
Uninstallable=yes
CloseApplications=no
SetupLogging=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Code]
const
  FontRegistryKey = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts';
  OwnershipKey = 'SOFTWARE\xPROMSx\FlagEmojisWindowsInstaller';
  FontRegistryValue = 'Segoe UI Emoji (TrueType)';
  DefaultFont = 'seguiemj.ttf';
  OwnedFont = 'FEWI-SegoeEmoji-2.3.0.ttf';
  TempFont = 'FEWI-upstream-2.3.0.ttf';
  FontUrl = 'https://github.com/Chasmical/flag-emojis-for-windows/releases/download/v2.3.0/Segoe.UI.Emoji.with.Twemoji.Flags.ttf';
  FontSHA256 = '83d29681ba6cb661500dbd1282f976cd4c498dc64479ba5d7a49877f40cabd19';

var
  AlreadyInstalled: Boolean;
  FontDownloaded: Boolean;
  InstalledByThisRun: Boolean;

function Same(const A, B: String): Boolean;
begin
  Result := Lowercase(A) = Lowercase(B);
end;

function FontFilePath: String;
begin
  Result := ExpandConstant('{fonts}\') + OwnedFont;
end;

function ValidFont(const FileName: String): Boolean;
begin
  Result := FileExists(FileName);
  if Result then
    Result := Same(GetSHA256OfFile(FileName), FontSHA256);
end;

function CheckState: String;
var
  Current, Original: String;
begin
  Result := '';
  AlreadyInstalled := False;

  if not RegQueryStringValue(HKLM64, FontRegistryKey, FontRegistryValue, Current) then
  begin
    Result := 'Cannot read the Windows Segoe UI Emoji registry entry.';
    exit;
  end;

  if RegKeyExists(HKLM64, OwnershipKey) then
  begin
    if not RegQueryStringValue(HKLM64, OwnershipKey, 'OriginalFont', Original) then
    begin
      Result := 'An incomplete prior installation was found. No system changes were made.';
      exit;
    end;

    if not Same(Original, DefaultFont) then
    begin
      Result := 'Unknown original font setting. Cannot safely continue.';
      exit;
    end;

    if not Same(Current, OwnedFont) then
    begin
      Result := 'The system font was changed after installation. No automatic overwrite is allowed.';
      exit;
    end;

    if not ValidFont(FontFilePath) then
    begin
      Result := 'The installed font is missing or has an unexpected SHA-256.';
      exit;
    end;

    AlreadyInstalled := True;
    exit;
  end;

  if not Same(Current, DefaultFont) then
  begin
    Result := 'A different system Emoji font is active (' + Current +
      '). Restore it manually before installing; it will not be overwritten.';
    exit;
  end;

  if FileExists(FontFilePath) then
  begin
    Result := 'The destination font file already exists without installer ownership.';
    exit;
  end;

  if not FileExists(ExpandConstant('{fonts}\') + DefaultFont) then
    Result := 'The original Microsoft Segoe UI Emoji font is missing.';
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
begin
  Result := CheckState;
  if Result <> '' then exit;

  if AlreadyInstalled then
  begin
    Log('Verified existing installation. No font download or replacement needed.');
    exit;
  end;

  try
    DownloadTemporaryFile(FontUrl, TempFont, FontSHA256, nil);
    FontDownloaded := True;
    if not ValidFont(ExpandConstant('{tmp}\') + TempFont) then
      RaiseException('Downloaded font failed SHA-256 verification.');
  except
    Result := 'Unable to download or verify the pinned upstream font: ' +
      GetExceptionMessage;
  end;
end;

procedure InstallFont;
var
  Current: String;
  Copied: Boolean;
begin
  if AlreadyInstalled then exit;

  if not FontDownloaded then
    RaiseException('The verified font was not downloaded.');

  if CheckState <> '' then
    RaiseException('The system font state changed during installation.');

  Copied := False;

  try
    if not FileCopy(ExpandConstant('{tmp}\') + TempFont, FontFilePath, True) then
      RaiseException('Unable to copy the font to the Windows Fonts directory.');
    Copied := True;

    if not ValidFont(FontFilePath) then
      RaiseException('Font SHA-256 mismatch after copying.');

    // Backup must be durable before changing the primary Windows font mapping.
    if not RegWriteStringValue(HKLM64, OwnershipKey, 'OriginalFont', DefaultFont) then
      RaiseException('Unable to save the original font registry setting.');

    if not RegWriteStringValue(HKLM64, FontRegistryKey, FontRegistryValue, OwnedFont) then
      RaiseException('Unable to switch the Windows Segoe UI Emoji font.');

    InstalledByThisRun := True;
    Log('Font installed and Windows font registry updated.');
  except
    // Only restore our own mapping and only remove our own verified file.
    if RegQueryStringValue(HKLM64, FontRegistryKey, FontRegistryValue, Current) then
      if Same(Current, OwnedFont) then
        RegWriteStringValue(HKLM64, FontRegistryKey, FontRegistryValue, DefaultFont);

    RegDeleteKeyIncludingSubkeys(HKLM64, OwnershipKey);

    if Copied and ValidFont(FontFilePath) then
      DeleteFile(FontFilePath);

    RaiseException('Font setup rolled back: ' + GetExceptionMessage);
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
    InstallFont;
end;

function NeedRestart: Boolean;
begin
  Result := InstalledByThisRun;
end;

function InitializeUninstall: Boolean;
var
  Current, Original: String;
begin
  Result := False;

  if not RegQueryStringValue(HKLM64, OwnershipKey, 'OriginalFont', Original) or
     not Same(Original, DefaultFont) then
  begin
    MsgBox('The original font backup is missing. Uninstall was stopped to protect Windows.',
      mbError, MB_OK);
    exit;
  end;

  if not RegQueryStringValue(HKLM64, FontRegistryKey, FontRegistryValue, Current) or
     not Same(Current, OwnedFont) then
  begin
    MsgBox('The active Windows emoji font no longer belongs to this installer. ' +
      'Uninstall was stopped to preserve your settings.', mbError, MB_OK);
    exit;
  end;

  if FileExists(FontFilePath) and not ValidFont(FontFilePath) then
  begin
    MsgBox('The installed font file has changed. Uninstall was stopped for safety.',
      mbError, MB_OK);
    exit;
  end;

  Result := True;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep <> usUninstall then exit;

  if not RegWriteStringValue(HKLM64, FontRegistryKey,
      FontRegistryValue, DefaultFont) then
    RaiseException('Failed to restore the original Microsoft font registration.');

  if FileExists(FontFilePath) then
  begin
    if not DeleteFile(FontFilePath) then
    begin
      // The font may remain loaded until reboot.
      RestartReplace(FontFilePath, '');
      Log('Owned font scheduled for deletion after reboot.');
    end;
  end;

  if not RegDeleteKeyIncludingSubkeys(HKLM64, OwnershipKey) then
    RaiseException('Failed to remove installer ownership metadata.');
end;

function UninstallNeedRestart: Boolean;
begin
  Result := True;
end;

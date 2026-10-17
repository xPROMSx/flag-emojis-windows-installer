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
#ifdef TEST_UNREACHABLE_FONT
OutputBaseFilename=FlagEmojisSetup-UnreachableTest
#else
OutputBaseFilename=FlagEmojisSetup-v{#AppVersion}
#endif
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
  LegacyFont = 'Segoe.UI.Emoji.with.Twemoji.Flags.ttf';
  LegacySHA256V22 = '7ab80ff5093f3381bfe837b2101020ec5c3bf348cf0387fdfa5bbba6d36c2ef9';
  OwnedFont = 'FEWI-SegoeEmoji-2.3.0.ttf';
  TempFont = 'FEWI-upstream-2.3.0.ttf';
#ifdef TEST_UNREACHABLE_FONT
  FontUrl = 'https://127.0.0.1:9/nonexistent.ttf';
#else
  FontUrl = 'https://github.com/Chasmical/flag-emojis-for-windows/releases/download/v2.3.0/Segoe.UI.Emoji.with.Twemoji.Flags.ttf';
#endif
  FontSHA256 = '83d29681ba6cb661500dbd1282f976cd4c498dc64479ba5d7a49877f40cabd19';

var
  AlreadyInstalled: Boolean;
  FontDownloaded: Boolean;
  InstalledByThisRun: Boolean;
  SavedOriginal: String;
  UninstallOriginal: String;

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

function IsValidPreviousFont(const FontName: String): Boolean;
var
  Hash, Path: String;
begin
  Result := False;
  Path := ExpandConstant('{fonts}\') + FontName;
  if not FileExists(Path) then exit;

  if Same(FontName, DefaultFont) then
  begin
    Result := True;
    exit;
  end;

  if Same(FontName, LegacyFont) then
  begin
    Hash := GetSHA256OfFile(Path);
    Result := Same(Hash, FontSHA256) or Same(Hash, LegacySHA256V22);
  end;
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

    if not IsValidPreviousFont(Original) then
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

  if not IsValidPreviousFont(Current) then
  begin
    Result := 'A different or unverified Segoe UI Emoji font is active (' + Current +
      '). Only the original Windows font or verified upstream v2.2/v2.3 is supported.';
    exit;
  end;
  SavedOriginal := Current;

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
    if not CopyFile(ExpandConstant('{tmp}\') + TempFont, FontFilePath, True) then
      RaiseException('Unable to copy the font to the Windows Fonts directory.');
    Copied := True;

    if not ValidFont(FontFilePath) then
      RaiseException('Font SHA-256 mismatch after copying.');

    // Backup must be durable before changing the primary Windows font mapping.
    if not RegWriteStringValue(HKLM64, OwnershipKey, 'OriginalFont', SavedOriginal) then
      RaiseException('Unable to save the original font registry setting.');

    if not RegWriteStringValue(HKLM64, FontRegistryKey, FontRegistryValue, OwnedFont) then
      RaiseException('Unable to switch the Windows Segoe UI Emoji font.');

    InstalledByThisRun := True;
    Log('Font installed and Windows font registry updated.');
  except
    // Only restore our own mapping and only remove our own verified file.
    if RegQueryStringValue(HKLM64, FontRegistryKey, FontRegistryValue, Current) then
      if Same(Current, OwnedFont) then
        RegWriteStringValue(HKLM64, FontRegistryKey, FontRegistryValue, SavedOriginal);

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

procedure ReportUninstallConflict(const MessageText: String);
begin
  Log('Uninstall refused: ' + MessageText);
  if not UninstallSilent then
    MsgBox(MessageText, mbError, MB_OK);
end;

function InitializeUninstall: Boolean;
var
  Current, Original: String;
begin
  Result := False;

  if not RegQueryStringValue(HKLM64, OwnershipKey, 'OriginalFont', Original) or
     not IsValidPreviousFont(Original) then
  begin
    ReportUninstallConflict('The original font backup is missing. Uninstall was stopped to protect Windows.');
    exit;
  end;

  if not RegQueryStringValue(HKLM64, FontRegistryKey, FontRegistryValue, Current) or
     not Same(Current, OwnedFont) then
  begin
    ReportUninstallConflict('The active Windows emoji font no longer belongs to this installer. ' +
      'Uninstall was stopped to preserve your settings.');
    exit;
  end;

  if FileExists(FontFilePath) and not ValidFont(FontFilePath) then
  begin
    ReportUninstallConflict('The installed font file has changed. Uninstall was stopped for safety.');
    exit;
  end;

  UninstallOriginal := Original;
  Result := True;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep <> usUninstall then exit;

  if not RegWriteStringValue(HKLM64, FontRegistryKey,
      FontRegistryValue, UninstallOriginal) then
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

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID <> wpFinished then exit;
  if ActiveLanguage = 'russian' then
    WizardForm.FinishedLabel.Caption :=
      'Шрифт с флагами установлен. Для применения изменений перезагрузите Windows. ' +
      'При необходимости удалить его можно через Параметры - Приложения.'
  else
    WizardForm.FinishedLabel.Caption :=
      'Country flag emojis are installed. Restart Windows to apply changes. ' +
      'You can uninstall this app later from Windows Settings - Apps.';
end;

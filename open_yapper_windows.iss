; Inno Setup script for building a one-click Windows installer for Open Yapper.
; Prerequisites:
; 1. Build the Windows release: flutter build windows --release
; 2. Install Inno Setup (https://jrsoftware.org/isinfo.php)
; 3. Compile this script with Inno Setup (or iscc.exe)

#define MyAppName "Open Yapper"
#define MyAppVersion "1.0.1"
#define MyAppPublisher "Open Yapper"
#define MyAppExeName "open_yapper.exe"

[Setup]
AppId={{1E4F522A-7E57-4F5A-9F48-58A9F08ADC01}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir=.
OutputBaseFilename=OpenYapperSetup
SetupIconFile=windows\runner\resources\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; GroupDescription: "Additional icons:"; Flags: unchecked

[Files]
; Bundle everything from the Flutter Windows release output.
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Launch {#MyAppName}"; Flags: nowait postinstall skipifsilent


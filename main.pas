unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ExtCtrls, EditBtn, IniFiles, Process, changes, frmPort;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnClose: TButton;
    btnApply: TButton;
    btnPortSel: TButton;
    cbRev: TCheckBox;
    cbFocus: TColorButton;
    cbOther: TColorButton;
    ePort: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    seSkip: TSpinEdit;
    seUse: TSpinEdit;
    seTot: TSpinEdit;
    procedure btnApplyClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnPortSelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmMain: TfrmMain;
  conf: TIniFile;
  iniFileName : string;


implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  {$IFDEF UNIX}
  iniFileName := '/etc/focusbar.conf';
  {$ENDIF}
  {$IFDEF WINDOWS}
  iniFileName := GetEnvironmentVariable('appdata') + '/focusbar/focusbar.conf';
  {$ENDIF}
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  focusCol, otherCol: string;
begin
    conf := TINIFile.Create(iniFileName);
  {$IFDEF UNIX}
  ePort.text := conf.ReadString ('connection', 'port', '/dev/ttyUSB0');
  {$ENDIF}
  {$IFDEF WINDOWS}
  ePort.text := conf.ReadString ('connection', 'port', 'COM1');
  {$ENDIF}

  seSkip.Value := conf.ReadInteger('leds', 'skip',   0);
  seUse.value  := conf.ReadInteger('leds', 'use',   30);
  seTot.value  := conf.ReadInteger('leds', 'total', 30);
  cbRev.Checked := conf.ReadBool('leds', 'reverse', false);

  focusCol := conf.ReadString ('colours', 'focus', '00ff00');
  otherCol := conf.ReadString ('colours', 'other', '000000');

  focusCol := focusCol[5] + focusCol[6] + focusCol[3] + focusCol[4] + focusCol[1] + focusCol[2];
  otherCol := otherCol[5] + otherCol[6] + otherCol[3] + otherCol[4] + otherCol[1] + otherCol[2];

  try
    cbFocus.buttonColor := TColor(strtoint('$' + focusCol ));
  except
    on Exception : EConvertError do
      cbFocus.buttonColor := TColor($00ff00);
  end;
  try
    cbother.buttonColor := TColor(strtoint('$' + otherCol ));
  except
    on Exception : EConvertError do
      cbother.buttonColor := TColor($000000);
  end;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  frmMain.Close;
end;

procedure TfrmMain.btnPortSelClick(Sender: TObject);
begin
  portEditBox := ePort;
  frmPorts.Show;
end;

procedure ForkProcess(executablePath: string);
var
  Process: TProcess;
  I: Integer;
begin
  Process := TProcess.Create(nil);
  try
    Process.InheritHandles := False;
    Process.Options := [];
    Process.ShowWindow := swoHide;

    // Copy default environment variables including DISPLAY variable
    for I := 1 to GetEnvironmentVariableCount do
      Process.Environment.Add(GetEnvironmentString(I));

    Process.Executable := executablePath;
    Process.Execute;
  finally
    Process.Free;
  end;
end;

procedure TfrmMain.btnApplyClick(Sender: TObject);
var
  focusCol, otherCol: string;
  ignore: string;
begin
  frmChanges.show;
  conf.WriteString ('connection', 'port', ePort.text);

  conf.WriteInteger('leds', 'skip',  seSkip.Value);
  conf.WriteInteger('leds', 'use',   seUse.value);
  conf.WriteInteger('leds', 'total', seTot.value);

  conf.WriteBool('leds', 'reverse', cbRev.Checked);

  focusCol := IntToHex(cbFocus.ButtonColor,6);
  otherCol := IntToHex(cbOther.ButtonColor,6);
  focusCol := focusCol[5] + focusCol[6] + focusCol[3] + focusCol[4] + focusCol[1] + focusCol[2];
  otherCol := otherCol[5] + otherCol[6] + otherCol[3] + otherCol[4] + otherCol[1] + otherCol[2];
  conf.WriteString ('colours', 'focus', focusCol);
  conf.WriteString ('colours', 'other', otherCol);

  // Config written, restart the focusterm
  {$IFDEF UNIX}
  // Argh, awful hack
  RunCommand('killall -9 focusterm', ignore);
  {$ENDIF}
  {$IFDEF WINDOWS}
  RunCommand('taskkill /f /im focusterm.exe', ignore);
  {$ENDIF}
  {$IFDEF UNIX}
  ForkProcess('./focusterm');
  {$ENDIF}
  {$IFDEF WINDOWS}
  ForkProcess('./focusterm.exe');
  {$ENDIF}
end;

end.


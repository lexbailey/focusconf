unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ExtCtrls, IniFiles;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnClose: TButton;
    btnApply: TButton;
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
    procedure btnCloseClick(Sender: TObject);
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

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin


end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  focusCol, otherCol: string;
begin
    conf := TINIFile.Create('focusbar.conf');
  ePort.text := conf.ReadString ('connection', 'port', '/dev/ttyUSB0');

  seSkip.Value := conf.ReadInteger('leds', 'skip',   0);
  seUse.value  := conf.ReadInteger('leds', 'use',   30);
  seTot.value  := conf.ReadInteger('leds', 'total', 30);

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

end.


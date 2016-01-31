unit frmPort;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TfrmPorts }

  TfrmPorts = class(TForm)
    btnSelect: TButton;
    btnCancel: TButton;
    lbPorts: TListBox;
    Panel1: TPanel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmPorts: TfrmPorts;
  portEditBox: TEdit;

implementation

{$R *.lfm}

{ TfrmPorts }

procedure TfrmPorts.FormShow(Sender: TObject);
var
  ports: TStringList;
begin
  {$IFDEF UNIX}
  ports := FindAllFiles('/dev', 'ttyUSB*;ttyS*;ttyACM*', false);
  {$ENDIF}
  {$IFDEF WINDOWS}
  // TODO: enumerate com ports on windows
  {$ENDIF}
  lbPorts.Clear;
  lbPorts.Items.AddStrings(ports);
  ports.free;

end;

procedure TfrmPorts.btnSelectClick(Sender: TObject);
var
  port: string;
begin
  port := lbPorts.GetSelectedText;
  if port <> '' then
  begin
    portEditBox.Text:=port;
    close;
  end else
  begin
    ShowMessage('Please select a port.');
  end;
end;

procedure TfrmPorts.btnCancelClick(Sender: TObject);
begin
  close;
end;

end.


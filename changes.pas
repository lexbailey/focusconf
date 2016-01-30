unit changes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls;

type

  { TfrmChanges }

  TfrmChanges = class(TForm)
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    tmrClose: TTimer;
    procedure FormShow(Sender: TObject);
    procedure tmrCloseTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmChanges: TfrmChanges;

implementation

{$R *.lfm}

{ TfrmChanges }

procedure TfrmChanges.tmrCloseTimer(Sender: TObject);
begin
  tmrClose.Enabled:=false;
  close;
end;

procedure TfrmChanges.FormShow(Sender: TObject);
begin
  tmrClose.Enabled:=true;
end;

end.


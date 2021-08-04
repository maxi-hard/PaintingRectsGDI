program PrjRectangles;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {FrmRectangles},
  UObjects in 'UObjects.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmRectangles, FrmRectangles);
  Application.Run;
end.

program GeraClassesSimpleORM;

uses
  Vcl.Forms,
  uGeraClassesSimpleORM in 'uGeraClassesSimpleORM.pas' {frmGeradorClassesSimpleORM};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmGeradorClassesSimpleORM, frmGeradorClassesSimpleORM);
  Application.Run;
end.

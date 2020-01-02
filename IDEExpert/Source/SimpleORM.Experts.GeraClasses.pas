unit SimpleORM.Experts.GeraClasses;

interface

uses
  ToolsAPI, System.Classes, System.SysUtils, uGeraClassesSimpleORM;

type TSimpleORMExpertGeraClasses = class(TNotifierObject, IOTAWizard,
                                                          IOTAProjectWizard,
                                                          IOTARepositoryWizard)
  public
    // IOTAWizard
    function GetIDString : string;
    function GetName     : string;
    function GetState    : TWizardState;
    procedure Execute;

    // IOTARepositoryWizard
    function GetAuthor  : string;
    function GetComment : string;
    function GetPage    : string;
    function GetGlyph   : Cardinal;

end;

implementation

{ TSimpleORMExpertGeraClasses }

procedure TSimpleORMExpertGeraClasses.Execute;
var
  form: TfrmGeradorClassesSimpleORM;
begin
  form := TfrmGeradorClassesSimpleORM.Create(nil);
  try
    form.ShowModal;
  finally
    form.Free;
  end;
end;

function TSimpleORMExpertGeraClasses.GetAuthor: string;
begin
  result := 'Gabriel Baltazar';
end;

function TSimpleORMExpertGeraClasses.GetComment: string;
begin
  result := 'Gerador de Classes para o SimpleORM';
end;

function TSimpleORMExpertGeraClasses.GetGlyph: Cardinal;
begin
  result := 0;
end;

function TSimpleORMExpertGeraClasses.GetIDString: string;
begin
  result := 'SimpleORM.Expert.GeraClasses';
end;

function TSimpleORMExpertGeraClasses.GetName: string;
begin
  result := 'SimpleORM Expert GeraClasses';
end;

function TSimpleORMExpertGeraClasses.GetPage: string;
begin
  Result := 'Simple ORM';
end;

function TSimpleORMExpertGeraClasses.GetState: TWizardState;
begin
  result := [wsEnabled];
end;

end.

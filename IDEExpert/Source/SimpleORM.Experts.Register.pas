unit SimpleORM.Experts.Register;

interface

uses
  ToolsAPI,
  SimpleORM.Experts.GeraClasses;

procedure Register;

implementation

procedure Register;
begin
  RegisterPackageWizard(TSimpleORMExpertGeraClasses.Create);
end;

end.

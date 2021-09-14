unit uGeraClassesSimpleORM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, Vcl.CheckLst,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB, FireDAC.DApt;

type
  TfrmGeradorClassesSimpleORM = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    script: TMemo;
    btnGerarClasses: TButton;
    edtCaminhoArquivos: TLabeledEdit;
    edtPrefixoEntidades: TLabeledEdit;
    edtCaminhoBanco: TLabeledEdit;
    edtUsuario: TLabeledEdit;
    edtSenha: TLabeledEdit;
    btnConectar: TButton;
    Panel5: TPanel;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    Panel6: TPanel;
    chkListaTabelas: TCheckListBox;
    Panel7: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    btnModelController: TButton;
    edtPrefixoModel: TLabeledEdit;
    procedure btnConectarClick(Sender: TObject);
    function EliminaBrancos(sTexto:String):String;
    function PrimeiraMaiuscula(Value: String): String;
    function maiusculas_sem_acento_e_cedilha(nome:string):string;
    procedure btnGerarClassesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnModelControllerClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGeradorClassesSimpleORM: TfrmGeradorClassesSimpleORM;
  caminho_banco : string;
  FConnection : TFDConnection;
  FQuery : TFDQuery;

implementation

{$R *.dfm}

procedure TfrmGeradorClassesSimpleORM.btnConectarClick(Sender: TObject);
var i : Integer;
begin
  caminho_banco := edtCaminhoBanco.Text;
  if not FileExists(caminho_banco) then
  begin
    ShowMessage('Base de dados não encontrada');
    Abort;
  end;
  try
    FConnection := TFDConnection.create(nil);
    FConnection.Params.Clear;
    FConnection.Params.Add('Password=masterkey');
    FConnection.Params.Add('User_Name=sysdba');
    FConnection.Params.Add('Database='+caminho_banco);
    FConnection.Params.Add('Server=localhost');
    FConnection.Params.Add('DriverID=FB');
    FConnection.Connected := True;
    FConnection.ResourceOptions.AutoReconnect := True;

    FQuery := TFDQuery.Create(nil);
    FQuery.Connection := FConnection;

    FQuery.Close;
    FQuery.SQL.Clear;

    chkListaTabelas.Items.Clear();
    with FQuery do
    begin
      SQL.Text := 'select rdb$relation_name from rdb$relations where rdb$system_flag = 0 order by rdb$relation_name;';
      Open();
      First();
      while not Eof do
      begin
        chkListaTabelas.Items.Add(EliminaBrancos(Fields[0].AsString));
        Next();
      end;
    end;

  for I := 0 to chkListaTabelas.Count -1 do
  begin
    chkListaTabelas.Checked[i] := True;
  end;
  finally
    FQuery.Free;
    FConnection.Free;
  end;

end;

procedure TfrmGeradorClassesSimpleORM.btnGerarClassesClick(Sender: TObject);
var tabela, campo : string;
    i, j : Integer;
begin
  try
  caminho_banco := Trim(edtCaminhoBanco.Text);
  if not FileExists(caminho_banco) then
  begin
    ShowMessage('Base de dados não encontrada');
    Abort;
  end;
  FConnection := TFDConnection.create(nil);
  FConnection.Params.Clear;
  FConnection.Params.Add('Password=masterkey');
  FConnection.Params.Add('User_Name=sysdba');
  FConnection.Params.Add('Database='+caminho_banco);
  FConnection.Params.Add('Server=localhost');
  FConnection.Params.Add('DriverID=FB');
  FConnection.Connected := True;
  FConnection.ResourceOptions.AutoReconnect := True;

  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FConnection;

  for j := 0 to chkListaTabelas.Count -1 do
  begin
    Application.ProcessMessages;
    if chkListaTabelas.Checked[j] then
    begin
      tabela := chkListaTabelas.Items[j].Trim;

      FQuery.Close;
      FQuery.SQL.Clear;
      FQuery.SQL.Add('select * from '+tabela);
      FQuery.Open;

      script.lines.Clear;
      script.Lines.Add('{');
      script.Lines.Add('Gerador de classes para SIMPLEORM');
      script.Lines.Add('Desenvolvido por Alan Petry - APNET INFORMATICA LTDA');
      script.Lines.Add('Fone: (54)98415-0888');
      script.Lines.Add('Email: alanpetry@alnet.eti.br ou alanpetry@outlook.com');
      script.Lines.Add('}');
      script.Lines.Add('');
      script.Lines.Add('');
      script.Lines.Add('unit '+edtPrefixoEntidades.Text+'.'+maiusculas_sem_acento_e_cedilha(tabela)+';');
      script.Lines.Add('');
      script.Lines.Add('interface');
      script.Lines.Add('');
      script.Lines.Add('uses');
      script.Lines.Add('  System.Generics.Collections, System.Classes, Rest.Json, System.JSON, SimpleAttributes;');
      script.Lines.Add('');
      script.Lines.Add('type');
      script.Lines.Add('  [Tabela('+QuotedStr(maiusculas_sem_acento_e_cedilha(tabela))+')]');
      script.Lines.Add('  T'+maiusculas_sem_acento_e_cedilha(tabela)+' = class');
      script.Lines.Add('  private');
      for I := 0 to FQuery.FieldCount -1 do
      begin
        if FQuery.Fields[i].ClassName = 'TIntegerField' then
          campo := 'integer;'
        else if FQuery.Fields[i].ClassName = 'TSmallintField' then
          campo := 'integer;'
        else if FQuery.Fields[i].ClassName = 'TLargeintField' then
          campo := 'integer;'
        else if FQuery.Fields[i].ClassName = 'TIBStringField' then
          campo := 'string;'
        else if FQuery.Fields[i].ClassName = 'TDateField' then
          campo := 'TDate;'
        else if FQuery.Fields[i].ClassName = 'TIBBCDField' then
          campo := 'real;'
        else if FQuery.Fields[i].ClassName = 'TFMTBCDField' then
          campo := 'real;'
        else if FQuery.Fields[i].ClassName = 'TCurrencyField' then
          campo := 'real;'
        else if FQuery.Fields[i].ClassName = 'TSingleField' then
          campo := 'real;'
        else if FQuery.Fields[i].ClassName = 'TStringField' then
          campo := 'string;'
        else
          campo := 'string;'+ '   {'+FQuery.Fields[i].ClassName+'}';
        script.Lines.Add('    F'+maiusculas_sem_acento_e_cedilha(FQuery.Fields[i].FieldName)+': '+campo );

    //FQuery.Fields[i].ClassName+' - '+FQuery.Fields[i].Size.ToString
      end;

      script.Lines.Add('');
      script.Lines.Add('  public');
      script.Lines.Add('    constructor Create;');
      script.Lines.Add('    destructor Destroy; override;');
      script.Lines.Add('');
      script.Lines.Add('  published');
      script.Lines.Add('{verificar os atributos do campo de chave primária}');
      script.Lines.Add('{Exemplo: [Campo('+QuotedStr('NOME_CAMPO')+'), PK, AutoInc] }');
      for I := 0 to FQuery.FieldCount -1 do
      begin
        if FQuery.Fields[i].ClassName = 'TIntegerField' then
          campo := 'integer'
        else if FQuery.Fields[i].ClassName = 'TSmallintField' then
          campo := 'integer'
        else if FQuery.Fields[i].ClassName = 'TLargeintField' then
          campo := 'integer'
        else if FQuery.Fields[i].ClassName = 'TIBStringField' then
          campo := 'string'
        else if FQuery.Fields[i].ClassName = 'TDateField' then
          campo := 'TDate'
        else if FQuery.Fields[i].ClassName = 'TIBBCDField' then
          campo := 'real'
        else if FQuery.Fields[i].ClassName = 'TFMTBCDField' then
          campo := 'real'
        else if FQuery.Fields[i].ClassName = 'TCurrencyField' then
          campo := 'real'
        else if FQuery.Fields[i].ClassName = 'TSingleField' then
          campo := 'real'
        else if FQuery.Fields[i].ClassName = 'TStringField' then
          campo := 'string'
        else
          campo := 'string';

        if I = 0 then
          script.Lines.Add('    [Campo('+quotedstr(maiusculas_sem_acento_e_cedilha(FQuery.Fields[i].FieldName))+'), PK, AutoInc]')
        else
          script.Lines.Add('    [Campo('+quotedstr(maiusculas_sem_acento_e_cedilha(FQuery.Fields[i].FieldName))+')]');
        script.Lines.Add('    property '+maiusculas_sem_acento_e_cedilha(FQuery.Fields[i].FieldName)
                                   +': '+campo+' read F'+maiusculas_sem_acento_e_cedilha(FQuery.Fields[i].FieldName)
                                   +' write F'+maiusculas_sem_acento_e_cedilha(FQuery.Fields[i].FieldName)+';');
      end;
      script.Lines.Add('');
      script.Lines.Add('    function ToJSONObject: TJsonObject;');
      script.Lines.Add('    function ToJsonString: string;');
      script.Lines.Add('');
      script.Lines.Add('  end;');
      script.Lines.Add('');
      script.Lines.Add('implementation');
      script.Lines.Add('');
      script.Lines.Add('constructor T'+maiusculas_sem_acento_e_cedilha(tabela)+'.Create;');
      script.Lines.Add('begin');
      script.Lines.Add('');
      script.Lines.Add('end;');
      script.Lines.Add('');
      script.Lines.Add('destructor T'+maiusculas_sem_acento_e_cedilha(tabela)+'.Destroy;');
      script.Lines.Add('begin');
      script.Lines.Add('');
      script.Lines.Add('  inherited;');
      script.Lines.Add('end;');
      script.Lines.Add('');
      script.Lines.Add('function T'+maiusculas_sem_acento_e_cedilha(tabela)+'.ToJSONObject: TJsonObject;');
      script.Lines.Add('begin');
      script.Lines.Add('  Result := TJson.ObjectToJsonObject(Self);');
      script.Lines.Add('end;');
      script.Lines.Add('');
      script.Lines.Add('function T'+maiusculas_sem_acento_e_cedilha(tabela)+'.ToJsonString: string;');
      script.Lines.Add('begin');
      script.Lines.Add('  result := TJson.ObjectToJsonString(self);');
      script.Lines.Add('end;');
      script.Lines.Add('');
      script.Lines.Add('end.');

      if not DirectoryExists(edtCaminhoArquivos.Text) then
        CreateDir(edtCaminhoArquivos.Text);
      script.Lines.SaveToFile(edtCaminhoArquivos.Text+'\'+edtPrefixoEntidades.Text+'.'+maiusculas_sem_acento_e_cedilha(tabela)+'.pas');

    end;
  end;
  finally
    FQuery.Free;
    FConnection.free;
  end;
  ShowMessage('Concluído');
end;

procedure TfrmGeradorClassesSimpleORM.btnModelControllerClick(
  Sender: TObject);
var tabela, campo : string;
    i, j : Integer;
begin
  for j := 0 to chkListaTabelas.Count -1 do
  begin
    Application.ProcessMessages;
    if chkListaTabelas.Checked[j] then
    begin
      tabela := chkListaTabelas.Items[j].Trim;
    end;
  end;
  script.Lines.Clear;
script.lines.add('unit SisCAV.Model.'+tabela+'.Interfaces;');
script.lines.add('');
script.lines.add('interface');
script.lines.add('');
script.lines.add('uses');
script.lines.add('  SisCAV.Entidades.'+tabela+', SimpleInterface, Data.DB;');
script.lines.add('');
script.lines.add('type');
script.lines.add('  iModel'+tabela+' = interface');
script.lines.add('    [gerar assinatura]');
script.lines.add('    function Entidade : T'+tabela+';');
script.lines.add('    function DAO : iSimpleDAO<T'+tabela+'>;');
script.lines.add('    function DataSource(aDataSource : TDataSource) : iModel'+tabela+';');
script.lines.add('  end;');
script.lines.add('');
script.lines.add('implementation');
script.lines.add('');
script.lines.add('end.');

      if not DirectoryExists(edtCaminhoArquivos.Text) then
        CreateDir(edtCaminhoArquivos.Text);
      script.Lines.SaveToFile(edtCaminhoArquivos.Text+'\'+edtPrefixoModel.Text+'.Model.'+maiusculas_sem_acento_e_cedilha(tabela)+'.Interfaces.pas');

script.Lines.Clear;
script.lines.add('unit SisCAV.Model.'+tabela+';');
script.lines.add('');
script.lines.add('interface');
script.lines.add('');
script.lines.add('uses');
script.lines.add('  SisCAV.Model.'+tabela+'.Interfaces, SisCAV.Entidades.'+tabela+', SimpleInterface,');
script.lines.add('  Data.DB, SimpleDAO, SimpleQueryRestDW;');
script.lines.add('');
script.lines.add('type');
script.lines.add('  TModel'+tabela+' = class(TInterfacedObject, iModel'+tabela+')');
script.lines.add('    private');
script.lines.add('      FEntidade : T'+tabela+';');
script.lines.add('      FDAO : iSimpleDAO<T'+tabela+'>;');
script.lines.add('      FDataSource : TDataSource;');
script.lines.add('    public');
script.lines.add('      constructor Create;');
script.lines.add('      destructor Destroy; override;');
script.lines.add('      class function New : iModel'+tabela+';');
script.lines.add('      function Entidade: T'+tabela+';');
script.lines.add('      function DAO: iSimpleDAO<T'+tabela+'>;');
script.lines.add('      function DataSource(aDataSource: TDataSource): iModel'+tabela+';');
script.lines.add('  end;');
script.lines.add('');
script.lines.add('implementation');
script.lines.add('');
script.lines.add('{ TModel'+tabela+' }');
script.lines.add('');
script.lines.add('uses System.SysUtils;');
script.lines.add('');
script.lines.add('constructor TModel'+tabela+'.Create;');
script.lines.add('begin');
script.lines.add('  FEntidade := T'+tabela+'.Create;');
script.lines.add('  FDAO := TSimpleDAO<T'+tabela+'>.New;');
script.lines.add('end;');
script.lines.add('');
script.lines.add('function TModel'+tabela+'.DAO: iSimpleDAO<T'+tabela+'>;');
script.lines.add('begin');
script.lines.add('  Result := FDAO;');
script.lines.add('end;');
script.lines.add('');
script.lines.add('function TModel'+tabela+'.DataSource(aDataSource: TDataSource): iModel'+tabela+';');
script.lines.add('begin');
script.lines.add('  Result := Self;');
script.lines.add('  FDataSource := aDataSource;');
script.lines.add('  FDAO.DataSource(FDatasource);');
script.lines.add('end;');
script.lines.add('');
script.lines.add('destructor TModel'+tabela+'.Destroy;');
script.lines.add('begin');
script.lines.add('  Freeandnil(FEntidade);');
script.lines.add('  inherited;');
script.lines.add('end;');
script.lines.add('');
script.lines.add('function TModel'+tabela+'.Entidade: T'+tabela+';');
script.lines.add('begin');
script.lines.add('  Result := FEntidade;');
script.lines.add('end;');
script.lines.add('');
script.lines.add('class function TModel'+tabela+'.New : iModel'+tabela+';');
script.lines.add('begin');
script.lines.add('  Result := Self.Create;');
script.lines.add('end;');
script.lines.add('');
script.lines.add('end.');
      if not DirectoryExists(edtCaminhoArquivos.Text) then
        CreateDir(edtCaminhoArquivos.Text);
      script.Lines.SaveToFile(edtCaminhoArquivos.Text+'\'+edtPrefixoModel.Text+'.Model.'+maiusculas_sem_acento_e_cedilha(tabela)+'.pas');

script.Lines.Clear;
script.lines.add('unit SisCAV.Controller.'+tabela+'.Interfaces;');
script.lines.add('');
script.lines.add('interface');
script.lines.add('');
script.lines.add('uses');
script.lines.add('  Data.DB, SisCAV.Entidades.'+tabela+', System.JSON, System.Generics.Collections, Vcl.Forms;');
script.lines.add('');
script.lines.add('type');
script.lines.add('  iController'+tabela+' = interface');
script.lines.add('    [GERAR ASSINATURA]');
script.lines.add('    function DataSource (aDataSource : TDataSource) : iController'+tabela+'; overload;');
script.lines.add('    function DataSource : TDataSource; overload;');
script.lines.add('    function Buscar : iController'+tabela+'; overload;');
script.lines.add('    function Buscar(aID : integer) : iController'+tabela+'; overload;');
script.lines.add('    function Buscar(aFiltro : TJsonobject; aOrdem : string) : iController'+tabela+'; overload;');
script.lines.add('    function Buscar(aSQL : string) : iController'+tabela+'; overload;');
script.lines.add('    function Insert : iController'+tabela+';');
script.lines.add('    function Delete : iController'+tabela+';');
script.lines.add('    function Update : iController'+tabela+';');
script.lines.add('    function Clear: iController'+tabela+';');
script.lines.add('    function Ultimo(where : string) : iController'+tabela+';');
script.lines.add('    function '+tabela+' : T'+tabela+';');
script.lines.add('    function FromJsonObject(aJson : TJsonObject) : iController'+tabela+';');
script.lines.add('    function List : TObjectList<T'+tabela+'>;');
script.lines.add('    function ExecSQL(sql : string) : iController'+tabela+';');
script.lines.add('    function BindForm(aForm : TForm) : iController'+tabela+';');
script.lines.add('  end;');
script.lines.add('');
script.lines.add('implementation');
script.lines.add('');
script.lines.add('end.');
      if not DirectoryExists(edtCaminhoArquivos.Text) then
        CreateDir(edtCaminhoArquivos.Text);
      script.Lines.SaveToFile(edtCaminhoArquivos.Text+'\'+edtPrefixoModel.Text+'.Controller.'+maiusculas_sem_acento_e_cedilha(tabela)+'.Interfaces.pas');

script.Lines.Clear;
script.lines.add('unit SisCAV.Controller.'+tabela+';');
script.lines.add('');
script.lines.add('interface');
script.lines.add('');
script.lines.add('uses');
script.lines.add('  SisCAV.Controller.'+tabela+'.Interfaces, Data.DB, SisCAV.Entidades.'+tabela+',');
script.lines.add('  SisCAV.Model.'+tabela+'.Interfaces, System.Generics.Collections,');
script.lines.add('  System.Json, REST.Json, Vcl.Forms, SimpleRTTI;');
script.lines.add('');
script.lines.add('type');
script.lines.add('  TController'+tabela+' = class(TInterfacedObject, iController'+tabela+')');
script.lines.add('  private');
script.lines.add('    FModel : iModel'+tabela+';');
script.lines.add('    FDataSource : TDataSource;');
script.lines.add('    FList : TObjectList<T'+tabela+'>;');
script.lines.add('    FEntidade : T'+tabela+';');
script.lines.add('  public');
script.lines.add('    constructor Create;');
script.lines.add('    destructor Destroy; override;');
script.lines.add('    class function New: iController'+tabela+';');
script.lines.add('    function DataSource(aDataSource: TDataSource): iController'+tabela+'; overload;');
script.lines.add('    function DataSource : TDataSource; overload;');
script.lines.add('    function Buscar: iController'+tabela+'; overload;');
script.lines.add('    function Buscar(aID : integer) : iController'+tabela+'; overload;');
script.lines.add('    function Buscar(aFiltro : TJsonobject; aOrdem : string) : iController'+tabela+'; overload;');
script.lines.add('    function Buscar(aSQL : string) : iController'+tabela+'; overload;');
script.lines.add('    function Insert: iController'+tabela+';');
script.lines.add('    function Delete: iController'+tabela+';');
script.lines.add('    function Update: iController'+tabela+';');
script.lines.add('    function Clear: iController'+tabela+';');
script.lines.add('    function Ultimo(where : string) : iController'+tabela+';');
script.lines.add('    function '+tabela+': T'+tabela+';');
script.lines.add('    function FromJsonObject(aJson : TJsonObject) : iController'+tabela+';');
script.lines.add('    function List : TObjectList<T'+tabela+'>;');
script.lines.add('    function ExecSQL(sql : string) : iController'+tabela+';');
script.lines.add('    function BindForm(aForm : TForm) : iController'+tabela+';');
script.lines.add('');
script.lines.add('  end;');
script.lines.add('');
script.lines.add('implementation');
script.lines.add('');
script.lines.add('uses');
script.lines.add('  SisCAV.Model, System.SysUtils;');
script.lines.add('');
script.lines.add('{ TController'+tabela+' }');
script.lines.add('');

script.lines.add('function TController'+tabela+'.Buscar: iController'+tabela+';');
script.lines.add('begin');
script.lines.add('  Result := Self;');
script.lines.add('');
script.lines.add('  if not Assigned(FList) then');
script.lines.add('    FList := TObjectList<T'+tabela+'>.Create;');
script.lines.add('');
script.lines.add('  FModel.DAO.Find(FList);');
script.lines.add('end;');
script.lines.add('');

script.lines.add('function TController'+tabela+'.Buscar(aID: integer): iController'+tabela+';');
script.lines.add('var aux : string;');
script.lines.add('begin');
script.lines.add('  Result := Self;');
script.lines.add('');
script.lines.add('  if Assigned(FEntidade) then');
script.lines.add('    Freeandnil(FEntidade);');
script.lines.add('');
script.lines.add('  FEntidade := FModel.DAO.Find(aID);');
script.lines.add('end;');
script.lines.add('');

script.lines.add('function TController'+tabela+'.Buscar(aFiltro : TJsonobject; aOrdem : string) : iController'+tabela+';');
script.lines.add('var');
script.lines.add('  Item: TJSONPair;');
script.lines.add('  sql : string;');
script.lines.add('begin');
script.lines.add('  Result := Self;');
script.lines.add('  if not Assigned(FList) then');
script.lines.add('    FList := TObjectList<T'+tabela+'>.Create;');
script.lines.add('  try');
script.lines.add('    for Item in afiltro do');
script.lines.add('    begin');
script.lines.add('      if item.JsonString.Value = ''SQL'' then');
script.lines.add('      begin');
script.lines.add('        sql := (Item.JsonValue.Value);');
script.lines.add('      end');
script.lines.add('      else');
script.lines.add('      begin');
script.lines.add('        if sql <> '' then');
script.lines.add('          sql := sql + '' and '';');
script.lines.add('');
script.lines.add('        if UpperCase(Item.JsonString.Value) = ''DESCRICAO'' then   // verificar o campo de descrição');
script.lines.add('          sql := sql + UpperCase(Item.JsonString.Value) + '' containing '' + Quotedstr(Item.JsonValue.Value)');
script.lines.add('        else');
script.lines.add('          sql := sql + UpperCase(Item.JsonString.Value) + '' = '' + Quotedstr(Item.JsonValue.Value);');
script.lines.add('      end;');
script.lines.add('    end;');
script.lines.add('    FModel.DAO.SQL.Where(sql).OrderBy(aOrdem).&End.Find(FList);');
script.lines.add('  finally');
script.lines.add('    Item.Free;');
script.lines.add('  end;');
script.lines.add('end;');
script.lines.add('');

script.lines.add('function TController'+tabela+'.Buscar(aSQL : string) : iController'+tabela+';');
script.lines.add('begin');
script.lines.add('  Result := Self;');
script.lines.add('  try');
script.lines.add('    FModel.DAO.Find(aSQL, FList);');
script.lines.add('  except');
script.lines.add('  end;');
script.lines.add('end;');
script.lines.add('');

script.lines.add('function TController'+tabela+'.BindForm(aForm: TForm): iController'+tabela+';');
script.lines.add('begin');
script.lines.add('  Result := Self;');
script.lines.add('  Clear;');
script.lines.add('  TSimpleRTTI<'+tabela+'>.New(nil).BindFormToClass(aForm, FEntidade);');
script.lines.add('end;');
script.lines.add('');

script.lines.add('function TController'+tabela+'.'+tabela+': T'+tabela+';');
script.lines.add('begin');
script.lines.add('  Result := FEntidade;');
script.lines.add('end;');
script.lines.add('');

script.lines.add('function TController'+tabela+'.Clear: iController'+tabela+';');
script.lines.add('begin');
script.lines.add('  if Assigned(FEntidade) then');
script.lines.add('    Freeandnil(FEntidade);');
script.lines.add('  FEntidade := T'+tabela+'.Create;');
script.lines.add('end;');
script.lines.add('');

script.lines.add('constructor TController'+tabela+'.Create;');
script.lines.add('begin');
script.lines.add('  FModel := TModel.New.'+tabela+';');
script.lines.add('  FList := TObjectList<T'+tabela+'>.Create;');
script.lines.add('  FEntidade := T'+tabela+'.Create;');
script.lines.add('end;');
script.lines.add('');

script.lines.add('function TController'+tabela+'.DataSource(');
script.lines.add('  aDataSource: TDataSource): iController'+tabela+';');
script.lines.add('begin');
script.lines.add('  Result := Self;');
script.lines.add('  FDataSource := aDataSource;');
script.lines.add('  FModel.DataSource(FDataSource);');
script.lines.add('end;');
script.lines.add('');

script.lines.add('function TController'+tabela+'.DataSource: TDataSource;');
script.lines.add('begin');
script.lines.add('  Result := FDataSource;');
script.lines.add('end;');
script.lines.add('');

script.lines.add('function TController'+tabela+'.Delete: iController'+tabela+';');
script.lines.add('begin');
script.lines.add('  Result := Self;');
script.lines.add('  try');
script.lines.add('    FModel.DAO.Delete(FEntidade);');
script.lines.add('  except');
script.lines.add('    raise Exception.Create(''Erro ao excluir o registro'');');
script.lines.add('  end;');
script.lines.add('end;');
script.lines.add('');

script.lines.add('destructor TController'+tabela+'.Destroy;');
script.lines.add('begin');
script.lines.add('  if Assigned(FList) then');
script.lines.add('    Freeandnil(FList);');
script.lines.add('');
script.lines.add('  if Assigned(FEntidade) then');
script.lines.add('    Freeandnil(FEntidade);');
script.lines.add('');
script.lines.add('  inherited;');
script.lines.add('end;');
script.lines.add('');

script.lines.add('function TController'+tabela+'.Insert: iController'+tabela+';');
script.lines.add('begin');
script.lines.add('  Result := Self;');
script.lines.add('  FModel.DAO.Insert(FEntidade);');
script.lines.add('end;');
script.lines.add('');

script.lines.add('function TController'+tabela+'.List : TObjectList<T'+tabela+'>;');
script.lines.add('begin');
script.lines.add('  Result := FList;');
script.lines.add('end;');
script.lines.add('');

script.lines.add('class function TController'+tabela+'.New: iController'+tabela+';');
script.lines.add('begin');
script.lines.add('  Result := Self.Create;');
script.lines.add('end;');
script.lines.add('');

script.lines.add('function TController'+tabela+'.ExecSQL(sql : string): iController'+tabela+';');
script.lines.add('begin');
script.lines.add('  FModel.DAO.ExecSQL(sql);');
script.lines.add('  Result := Self;');
script.lines.add('end;');
script.lines.add('');

script.lines.add('function TController'+tabela+'.Update: iController'+tabela+';');
script.lines.add('begin');
script.lines.add('  Result := Self;');
script.lines.add('  FModel.DAO.Update(FEntidade);');
script.lines.add('end;');
script.lines.add('');

script.lines.add('function TController'+tabela+'.Ultimo(where : string) : iController'+tabela+';');
script.lines.add('begin');
script.lines.add('  Result := Self;');
script.lines.add('  if not Assigned(FEntidade) then');
script.lines.add('    Freeandnil(FEntidade);');
script.lines.add('  if where = '' then');
script.lines.add('    where := '' xxx_CODIGO = (select max(xxx_CODIGO) from '+tabela+')'';');
script.lines.add('  FEntidade := FModel.DAO.Max(where);');
script.lines.add('end;');
script.lines.add('');

script.lines.add('function TController'+tabela+'.FromJsonObject(aJson : TJsonObject) : iController'+tabela+';');
script.lines.add('begin');
script.lines.add('  FEntidade := TJson.JsonToObject<T'+tabela+'>(aJson);');
script.lines.add('end;');
script.lines.add('');
script.lines.add('end.');
      if not DirectoryExists(edtCaminhoArquivos.Text) then
        CreateDir(edtCaminhoArquivos.Text);
      script.Lines.SaveToFile(edtCaminhoArquivos.Text+'\'+edtPrefixoModel.Text+'.Controller.'+maiusculas_sem_acento_e_cedilha(tabela)+'.pas');
script.Lines.Clear;


script.lines.add('Model Interfaces');
script.lines.add('');
script.lines.add('function '+tabela+' : iModel'+tabela+';');
script.lines.add('');
script.lines.add('Model');
script.lines.add('');
script.lines.add('function '+tabela+' : iModel'+tabela+';');
script.lines.add('');
script.lines.add('function TModel.'+tabela+' : iModel'+tabela+';');
script.lines.add('begin');
script.lines.add('  Result := TModel'+tabela+'.New;');
script.lines.add('end;');
script.lines.add('');
script.lines.add('');
script.lines.add('');
script.lines.add('Controller Interfaces');
script.lines.add('');
script.lines.add('function '+tabela+' : iController'+tabela+';');
script.lines.add('');
script.lines.add('Controller');
script.lines.add('');
script.lines.add('function '+tabela+' : iController'+tabela+';');
script.lines.add('');
script.lines.add('function TController.'+tabela+' : iController'+tabela+';');
script.lines.add('begin');
script.lines.add('  Result := TController'+tabela+'.New;');
script.lines.add('end;');
script.lines.add('');
script.lines.add('');


showmessage('Concluído');

end;

procedure TfrmGeradorClassesSimpleORM.Button1Click(Sender: TObject);
var
  i : integer;
begin
  for I := 0 to chkListaTabelas.Count -1 do
  begin
    chkListaTabelas.Checked[i] := True;
  end;
end;

procedure TfrmGeradorClassesSimpleORM.Button2Click(Sender: TObject);
var
  i : integer;
begin
  for I := 0 to chkListaTabelas.Count -1 do
  begin
    chkListaTabelas.Checked[i] := False;
  end;
end;

procedure TfrmGeradorClassesSimpleORM.Button3Click(Sender: TObject);
var tabela, campo : string;
    i, j : Integer;
begin
  try
    caminho_banco := 'D:\SisCAV\Fontes\Fontes_DataSnap\SisCAV_Server\Win32\Debug\BANCO.GDB';
    if not FileExists(caminho_banco) then
    begin
      ShowMessage('Base de dados não encontrada');
      Abort;
    end;
    FConnection := TFDConnection.create(nil);
    FConnection.Params.Clear;
    FConnection.Params.Add('Password=masterkey');
    FConnection.Params.Add('User_Name=sysdba');
    FConnection.Params.Add('Database='+caminho_banco);
    FConnection.Params.Add('Server=localhost');
    FConnection.Params.Add('DriverID=FB');
    FConnection.Connected := True;
    FConnection.ResourceOptions.AutoReconnect := True;

    FQuery := TFDQuery.Create(nil);
    FQuery.Connection := FConnection;

    FQuery.Close;
    FQuery.SQL.Clear;

    chkListaTabelas.Items.Clear();
    with FQuery do
    begin
      SQL.Text :=
        ' SELECT'
        +' A.RDB$FIELD_NAME NOME_DO_CAMPO,'
        +' C.RDB$TYPE_NAME TIPO,'
        +' B.RDB$FIELD_SUB_TYPE SUBTIPO,'
        +' B.RDB$FIELD_LENGTH TAMANHO,'
        +' B.RDB$SEGMENT_LENGTH SEGMENTO,'
        +' B.RDB$FIELD_PRECISION PRECISAO,'
        +' B.RDB$FIELD_SCALE CASAS_DECIMAIS,'
        +' A.RDB$DEFAULT_SOURCE VALOR_PADRAO,'
        +' A.RDB$NULL_FLAG OBRIGATORIO'
        +' FROM'
        +' RDB$RELATION_FIELDS A,'
        +' RDB$FIELDS B,'
        +' RDB$TYPES C'
        +' WHERE'
        +' (A.RDB$RELATION_NAME = ''NOME_DA_TABELA'')AND'   // AJUSTAR O NOME DA TABELA
        +' (B.RDB$FIELD_NAME = A.RDB$FIELD_SOURCE)AND'
        +' (C.RDB$TYPE = B.RDB$FIELD_TYPE)AND'
        +' (C.RDB$FIELD_NAME = ''RDB$FIELD_TYPE'')'
        +' ORDER BY'
        +' RDB$FIELD_NAME'
      ;
      Open();
      First();
      while not Eof do
      begin
        ShowMessage(FQuery.FieldByName('NOME_DO_CAMPO').Text+' - '+FQuery.FieldByName('TIPO').Text);
        Next();
      end;
    end;

  finally
    FQuery.Free;
    FConnection.Free;
  end;
end;

function TfrmGeradorClassesSimpleORM.EliminaBrancos(sTexto: String): String;
// Elimina todos os espaços em branco da string
//(inclusive os espaços entre as palavras)
var
nPos : Integer;
begin
  nPos := 1;
  while Pos(' ',sTexto) > 0 do
  begin
    nPos := Pos(' ',sTexto);
    (*Text[nPos] := ''; *)
    Delete(sTexto,nPos,1);
  end;
  Result := sTexto;
end;

procedure TfrmGeradorClassesSimpleORM.FormShow(Sender: TObject);
begin
  edtCaminhoArquivos.Text := ExtractFilePath(Application.ExeName)+'Entidades';
end;

function TfrmGeradorClassesSimpleORM.maiusculas_sem_acento_e_cedilha(nome: string): string;
var
  i : integer;
  aux, novo : string;
begin
  aux := AnsiUpperCase(nome);
    for i := 1 to length(aux) do
    begin
      case aux[i] of
      'Á', 'Â', 'Ã', 'À', 'Ä', 'á', 'â', 'ã', 'à', 'ä': aux[i] := 'A';
      'É', 'Ê', 'È', 'Ë', 'é', 'ê', 'è', 'ë', '&': aux[i] := 'E';
      'Í', 'Î', 'Ì', 'Ï', 'í', 'î', 'ì', 'ï': aux[i] := 'I';
      'Ó', 'Ô', 'Õ', 'Ò', 'Ö', 'ó', 'ô', 'õ', 'ò', 'ö': aux[i] := 'O';
      'Ú', 'Û', 'Ù', 'Ü', 'ú', 'û', 'ù', 'ü': aux[i] := 'U';
      'Ç', 'ç': aux[i] := 'C';
      'Ñ', 'ñ': aux[i] := 'N';
      'Ý', 'ý': aux[i] := 'Y';
      else
        if ord(aux[i]) > 127 then
          aux[i] := #32;
      end;
    end;
  maiusculas_sem_acento_e_cedilha := aux;
end;

function TfrmGeradorClassesSimpleORM.PrimeiraMaiuscula(Value: String): String;
var
P: Integer;
Word: String;
begin
Result := '';
Value := Trim(LowerCase(Value));
repeat
     P := Pos(' ', Value);
     if P <= 0 then
        begin
        P := Length(Value) + 1;
        end;
     Word := UpperCase(Copy(Value, 1, P-1));
     if (Length(Word) <= 2) or (Word = 'DAS') or (Word = 'DOS') then
        begin
        Result := Result + Copy(Value, 1, P-1)
        end
     else
        begin
        Result := Result + UpperCase(Value[1]) + Copy(Value, 2, P-2);
        end;
     Delete(Value, 1, P);
     if Value <> '' then
        begin
        Result := Result + ' ';
        end;
until Value = '';
end;

end.

unit Model.ConfiguracaoEmail;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.Generics.Collections, System.StrUtils, FireDAC.DApt, FireDAC.Stan.Param,
  System.JSON, Dataset.Serialize;

type
  TConfiguracaoemail = class
  private
    FConn: TFDConnection;
    Ftipo: string;
    Femail: string;
    Femailmaterial: string;
  public
    constructor Create;
    destructor Destroy; override;
    property tipo: string read Ftipo write Ftipo;
    property email: string read Femail write Femail;
    property emailmaterial: string read Femailmaterial write Femailmaterial;
    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
  end;

implementation

{ TConfiguracaoemail }

constructor TConfiguracaoemail.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TConfiguracaoemail.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
end;

function TConfiguracaoemail.Editar(out erro: string): Boolean;
var
  qry: TFDQuery;
begin
  Result := False;
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    FConn.StartTransaction;
    try
      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('SELECT id FROM gesemailconfiguracao');
        Open;
        if IsEmpty then
        begin
          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO gesemailconfiguracao ( emaildiaria, emailmaterial, criadoem, atualizadoem)');
          SQL.Add('VALUES ( :emails, emailmaterial, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)');
        end
        else
        begin
          Close;
          SQL.Clear;
          SQL.Add('UPDATE gesemailconfiguracao');
          SQL.Add('SET emaildiaria = :emails, emailmaterial= :emailmaterial, ');
          SQL.Add('    atualizadoem = CURRENT_TIMESTAMP ');
        end;

        ParamByName('emails').AsString := email;
        ParamByName('emailmaterial').AsString := emailmaterial;
        ExecSQL;
      end;

      erro := '';
      FConn.Commit;
      Result := True;
    except
      on ex: Exception do
      begin
        erro := 'Erro ao salvar configuração de e-mail: ' + ex.Message;
        FConn.Rollback;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TConfiguracaoemail.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('SELECT tipo, emaildiaria, emailmaterial FROM gesemailconfiguracao ');
      Active := True;
    end;
    erro := '';
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar configurações de e-mail: ' + ex.Message;
      Result := nil;
    end;
  end;
end;

end.

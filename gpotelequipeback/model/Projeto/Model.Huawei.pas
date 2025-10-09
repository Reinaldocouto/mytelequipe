unit Model.Huawei;

interface

uses
  System.Generics.Defaults, Horse, FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection, ComObj,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections, UtFuncao, FireDAC.Stan.Option,
  FireDAC.Stan.Param,   DateUtils, System.JSON, System.Classes, Model.Email, Variants;

type
  THuawei = class
  private
    FConn: TFDConnection;
    Fid: string;
    Fos: string;
    Fidcolaboradorpj: Integer;
    Fobservacaopj: string;
    Fpo: string;
    fvalornegociado: Double;
    Fporcentagempj: Double;
    Fdescricao: string;
    Fitemcode: string;
    Fsitename: string;
    Fsiteid: string;
    FbiddingArea: string;
    Fusuario: Integer;
    Fprojectno: string;
    Fregion: string;
    Fponumber: string;
    Fitemdescription: string;
    Fqty: Double;
    Fsitecode: string;
    FnegociadoSN: Integer;
    Fvo: string;

  public
    constructor Create;
    destructor Destroy; override;

    property id: string read Fid write Fid;
    property os: string read Fos write Fos;
    property idcolaboradorpj: Integer read Fidcolaboradorpj write Fidcolaboradorpj;
    property observacaopj: string read Fobservacaopj write Fobservacaopj;
    property po: string read Fpo write Fpo;
    property valornegociado: Double read Fvalornegociado write Fvalornegociado;
    property porcentagempj: Double read Fporcentagempj write Fporcentagempj;
    property descricao: string read Fdescricao write Fdescricao;
    property itemcode: string read Fitemcode write Fitemcode;
    property sitename: string read Fsitename write Fsitename;
    property siteid: string read Fsiteid write Fsiteid;
    property biddingArea: string read FbiddingArea write FbiddingArea;
    property usuario: Integer read Fusuario write Fusuario;
    property projectno: string read Fprojectno write Fprojectno;
    property region: string read Fregion write Fregion;
    property ponumber: string read Fponumber write Fponumber;
    property itemdescription: string read Fitemdescription write Fitemdescription;
    property qty: Double read Fqty write Fqty;
    property sitecode: string read Fsitecode write Fsitecode;
    property negociadoSN: Integer read FnegociadoSN write FnegociadoSN;
    property vo: string read Fvo write Fvo;

    function InserirHuawei(obj: TJSONObject; out erro: string): boolean;
    function Editar(out erro: string): Boolean;
    function ListarHuawei(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listapo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function PesquisarHuaweiPorObra(numeroObra: string; out erro: string): TFDQuery;
    function PesquisarHuaweiPorPrimaryKey(primaryKey: string; out erro: string): TFDQuery;
    function AtualizarHuawei(obj: TJSONObject; out erro: string): boolean;
    function Deletar(ID: Integer): boolean;
    function NovoCadastro(out erro: string): string;
    function Editaratividadepj(out erro: string): Boolean;
    function Listaacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function salvaacionamentopj(out erro: string): Boolean;
    function salvaacionamentoclt(out erro: string): Boolean;
    function Listaacionamentopj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaacionamentoclt(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function CriarTarefa(out erro: string): Boolean;
    function EditarEmMassa(const AJsonBody: string; out erro: string): Boolean;
    function InserirHuaweiRollout(obj: TJSONObject; out erro: string): boolean;
    function PesquisarHuaweiPorPrimaryKeyRollout(primaryKey: string; out erro: string): TFDQuery;
    function Listafechamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaconsolidado(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaDespesas(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function extratopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function totalacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function RolloutHuawei(const AQuery: TDictionary<string,string>;  out erro: string): TFDQuery;

  end;
implementation

constructor THuawei.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor THuawei.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function THuawei.InserirHuawei(obj: TJSONObject; out erro: string): boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.Editar(out erro: string): Boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.ListarHuawei(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  erro := '';
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    
    if AQuery.ContainsKey('agrupado') then
    begin
      qry.SQL.Text := 'SELECT manufactureSiteInfo, COUNT(*) AS occurrences FROM ProjetoHuawei';
      
      if AQuery.ContainsKey('busca') and (Length(AQuery.Items['busca']) > 0) then
      begin
        qry.SQL.Add(' WHERE (manufactureSiteInfo LIKE :busca OR poNumber LIKE :busca OR subProjectCode LIKE :busca)');
        qry.ParamByName('busca').AsString := '%' + AQuery.Items['busca'] + '%';
      end;
      
      qry.SQL.Add(' GROUP BY manufactureSiteInfo');
    end
    else
    begin
      qry.SQL.Text := 'SELECT * FROM ProjetoHuawei WHERE 1 = 1';
      
      if AQuery.ContainsKey('busca') and (Length(AQuery.Items['busca']) > 0) then
      begin
        qry.SQL.Add(' AND (manufactureSiteInfo LIKE :busca OR poNumber LIKE :busca OR subProjectCode LIKE :busca)');
        qry.ParamByName('busca').AsString := '%' + AQuery.Items['busca'] + '%';
      end;
    end;
    
    qry.SQL.Add(' ORDER BY poNumber DESC');
    qry.Open;
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao listar registros: ' + ex.Message;
      qry.Free;
      Result := nil;
    end;
  end;
end;

function THuawei.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.Listapo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.PesquisarHuaweiPorObra(numeroObra: string; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.connection := FConn;
  try
    qry.SQL.Text := 'SELECT * FROM ProjetoHuawei WHERE projectNo = :projectNo';
    qry.ParamByName('projectNo').AsString := numeroObra;
    qry.Open;
    erro := '';
    Result := qry;
  except
    on E: Exception do
    begin
      erro := 'Erro ao pesquisar pelo número da obra: ' + E.Message;
      qry.Free;
      Result := nil;
    end;
  end;
end;

function THuawei.PesquisarHuaweiPorPrimaryKey(primaryKey: string; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.AtualizarHuawei(obj: TJSONObject; out erro: string): boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.Deletar(ID: Integer): boolean;
begin
  Result := False;
end;

function THuawei.NovoCadastro(out erro: string): string;
begin
  Result := '';
  erro := 'Implementação pendente';
end;

function THuawei.Editaratividadepj(out erro: string): Boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.Listaacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.salvaacionamentopj(out erro: string): Boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.salvaacionamentoclt(out erro: string): Boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.Listaacionamentopj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.Listaacionamentoclt(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.CriarTarefa(out erro: string): Boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;


function THuawei.RolloutHuawei(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  keys: TArray<string>;
  key, value, dbField, whereSQL, sqlFinal: string;
  i: Integer;
  fieldMap: TDictionary<string, string>;
begin
  Result := nil;
  erro := '';
  whereSQL := '';
  sqlFinal := '';

  // --- 1. Garante que a conexão exista ---
  if not Assigned(FConn) then
  begin
    FConn := TFDConnection.Create(nil);
    FConn.DriverName := 'MySQL';
    FConn.Params.Clear;
    FConn.Params.Add('Server=localhost');    // troque pelo host correto
    FConn.Params.Add('Database=seuBanco');   // troque pelo banco correto
    FConn.Params.Add('User_Name=usuario');   // troque pelo usuário correto
    FConn.Params.Add('Password=senha');      // troque pela senha correta
    FConn.Params.Add('CharacterSet=utf8mb4');
    FConn.LoginPrompt := False;
  end;

  if not FConn.Connected then
  begin
    try
      FConn.Open;
    except
      on E: Exception do
      begin
        erro := 'Falha ao conectar ao banco: ' + E.Message;
        Exit;
      end;
    end;
  end;

  // --- 2. Valida parâmetros ---
  if not Assigned(AQuery) then
  begin
    erro := 'Parâmetros de consulta não fornecidos';
    Exit;
  end;

  // --- 3. Cria mapa de campos e WHERE ---
  fieldMap := TDictionary<string, string>.Create;
  try
    fieldMap.Add('name', 'Name');
    fieldMap.Add('projeto', 'Projeto');
    fieldMap.Add('endSite', 'End_Site');

    keys := AQuery.Keys.ToArray;
    for i := 0 to High(keys) do
    begin
      key := keys[i];
      value := AQuery.Items[key];
      if (value <> '') and fieldMap.ContainsKey(key) then
      begin
        if whereSQL = '' then
          whereSQL := ' WHERE '
        else
          whereSQL := whereSQL + ' AND ';

        dbField := fieldMap[key];
        whereSQL := whereSQL + dbField + ' = :' + key;
      end;
    end;

    // --- 4. Cria query ---
    qry := TFDQuery.Create(nil);
    try
      qry.Connection := FConn;
      qry.FetchOptions.Mode := fmOnDemand;
      qry.FetchOptions.RecsMax := 5000;
      qry.FetchOptions.RowsetSize := 50;

      // --- 5. Verifica se a tabela existe ---
      try
        qry.SQL.Text := 'SHOW TABLES LIKE ' + QuotedStr('rollouthuawei');
        qry.Open;
        if qry.RecordCount = 0 then
        begin
          erro := 'Tabela rollouthuawei não encontrada no banco';
          Exit;
        end;
        qry.Close;
      except
        on E: Exception do
        begin
          erro := 'Erro ao verificar tabela: ' + E.Message;
          Exit;
        end;
      end;

      // --- 6. Monta SQL final ---
      if whereSQL <> '' then
        sqlFinal := 'SELECT *, idgeral as id FROM rollouthuawei' + whereSQL
      else
        sqlFinal := 'SELECT *, idgeral as id FROM rollouthuawei';

      qry.SQL.Text := sqlFinal;
      
      // Configura limite via FetchOptions em vez de SQL LIMIT
      qry.FetchOptions.RecsMax := 100000;

      // --- 7. Define parâmetros dinamicamente ---
      for i := 0 to High(keys) do
      begin
        key := keys[i];
        value := AQuery.Items[key];
        if (value <> '') and fieldMap.ContainsKey(key) then
        begin
          if qry.Params.FindParam(key) = nil then
            qry.Params.CreateParam(ftString, key, ptInput);
          qry.ParamByName(key).AsString := value;
        end;
      end;

      // --- 8. Executa query ---
      try
        qry.Open;
        if qry.RecordCount = 0 then
          erro := 'Nenhum registro encontrado'
        else if qry.RecordCount >= 100000 then
          erro := 'Resultado limitado a 100000 registros. Use filtros para refinar a busca';

        Result := qry; // retorna query aberta
      except
        on E: Exception do
        begin
          erro := 'Erro ao executar consulta: ' + E.Message + ' | SQL: ' + sqlFinal;
          Writeln(erro);
          qry.Free;
          Exit;
        end;
      end;

    except
      on E: Exception do
      begin
        erro := 'Erro interno ao preparar query: ' + E.Message;
        qry.Free;
        Exit;
      end;
    end;

  finally
    fieldMap.Free;
  end;
end;


function THuawei.EditarEmMassa(const AJsonBody: string; out erro: string): Boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.InserirHuaweiRollout(obj: TJSONObject; out erro: string): boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.PesquisarHuaweiPorPrimaryKeyRollout(primaryKey: string; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.Listafechamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.Listaconsolidado(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.ListaDespesas(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.extratopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.totalacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

end.


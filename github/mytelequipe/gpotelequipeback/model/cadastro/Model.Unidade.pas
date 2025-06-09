unit Model.Unidade;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  Tunidade = class
  private
    FConn: TFDConnection;
    Fidunidade: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
    Fdescricao: string;
    Fsigla: string;

  public
    constructor Create;
    destructor Destroy; override;

    property idunidade: Integer read Fidunidade write Fidunidade;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property descricao: string read Fdescricao write Fdescricao;
    property sigla: string read Fsigla write Fsigla;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Inserir(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;

  end;

implementation

{ Tunidade }

constructor Tunidade.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor Tunidade.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function Tunidade.NovoCadastro(out erro: string): integer;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      FConn.StartTransaction;
      with qry do
      begin
        Active := false;
        sql.Clear;
        sql.add('update admponteiro set idunidade = idunidade+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idunidade from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idunidade := fieldbyname('idunidade').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idunidade;
    except
      on ex: exception do
      begin
        erro := 'Erro ao consultar : ' + ex.Message;
        Result := 0;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function Tunidade.Editar(out erro: string): Boolean;
var
  qry: TFDQuery;
  id: Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      FConn.StartTransaction;
      with qry do
      begin
        Active := false;
        sql.Clear;
        sql.add('select idunidade from gesunidade where idcliente=:idcliente and idloja=:idloja and idunidade=:idunidade ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ParamByName('IDunidade').AsInteger := IDunidade;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('INSERT INTO gesunidade(IDunidade,sigla,descricao,idcliente,idloja,deletado)');
          SQL.Add('             VALUES(:IDunidade,:sigla,:descricao,:idcliente,:idloja,:deletado)');
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gesunidade set DELETADO=:DELETADO,sigla=:sigla,descricao=:descricao');
          SQL.Add('where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDunidade =:IDunidade');
        end;
        ParamByName('idunidade').Value := idunidade;
        ParamByName('SIGLA').Value := SIGLA;
        ParamByName('DESCRICAO').Value := DESCRICAO;
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 0;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar unidade: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function Tunidade.Inserir(out erro: string): Boolean;
var
  qry: TFDQuery;
  id: Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      FConn.StartTransaction;
      with qry do
      begin
        Active := false;
        sql.Clear;
        SQL.Add('INSERT INTO gesunidade(IDunidade,sigla,DESCRICAO,');
        SQL.Add('IDCLIENTE,IDLOJA,DELETADO)');
        SQL.Add('       VALUES(:IDunidade,:sigla,:DESCRICAO,');
        SQL.Add(':IDCLIENTE,:IDLOJA,:DELETADO)');

        ParamByName('IDunidade').AsInteger := id;
        ParamByName('sigla').Value := sigla;
        ParamByName('DESCRICAO').Value := DESCRICAO;
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 0;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar unidade: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function Tunidade.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('gesunidade.idunidade as id, ');
      SQL.Add('gesunidade.descricao, ');
      SQL.Add('gesunidade.sigla ');

      SQL.Add('From  ');
      SQL.Add('gesunidade WHERE gesunidade.idunidade is not null ');

      if AQuery.ContainsKey('sigla') then
      begin
        if Length(AQuery.Items['sigla']) > 0 then
          SQL.Add('AND gesunidade.sigla like ''%' + AQuery.Items['sigla'] + '%'' ');
      end;

      if AQuery.ContainsKey('descricao') then
      begin
        if Length(AQuery.Items['descricao']) > 0 then
          SQL.Add('AND gesunidade.descricao like ''%' + AQuery.Items['descricao'] + '%'' ');
      end;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesunidade.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesunidade.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesunidade.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end;
      end;
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function Tunidade.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add(' * ');
      SQL.Add('From ');
      SQL.Add('gesunidade WHERE gesunidade.idunidade is not null and gesunidade.idunidade =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idunidadebusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesunidade.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesunidade.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesunidade.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end;
      end;
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

end.


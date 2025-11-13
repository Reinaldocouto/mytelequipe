unit Model.Planoconta;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TPlanoconta = class
  private
    FConn: TFDConnection;
    Fidplanoconta: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
    Fcodigo: string;
    Fdescricao: string;
    Ftipo: string;
    Fnaocontabilizado: string;

  public
    constructor Create;
    destructor Destroy; override;

    property idplanoconta: Integer read Fidplanoconta write Fidplanoconta;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property codigo: string read Fcodigo write Fcodigo;
    property descricao: string read Fdescricao write Fdescricao;
    property tipo: string read Ftipo write Ftipo;
    property naocontabilizado: string read Fnaocontabilizado write Fnaocontabilizado;

    function Listacredito(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listadebito(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro:string): TFDQuery;
    //function Inserir(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;

  end;

implementation

{ TPlanoconta }

constructor TPlanoconta.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TPlanoconta.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TPlanoconta.Editar(out erro: string): Boolean;
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
        sql.add('select idplanoconta from gesplanoconta where idcliente=:idcliente and idloja=:idloja and idplanoconta=:idplanoconta ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ParamByName('idplanoconta').AsInteger := idplanoconta;
        Open;
        if RecordCount = 0 then
        begin
        //id := fieldbyname('idplanoconta').AsInteger;
        Active := false;
        sql.Clear;
        SQL.Add('INSERT INTO gesplanoconta(IDPLANOCONTA,CODIGO,DESCRICAO,');
        SQL.Add('TIPO,NAOCONTABILIZADO,');
        SQL.Add('IDCLIENTE,IDLOJA,DELETADO)');
        SQL.Add('       VALUES(:IDPLANOCONTA,:CODIGO,:DESCRICAO,');
        SQL.Add(':TIPO,:NAOCONTABILIZADO,');
        SQL.Add(':IDCLIENTE,:IDLOJA,:DELETADO)');
        ParamByName('deletado').AsInteger := 0;
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gesplanoconta set DELETADO=:DELETADO,CODIGO=:CODIGO,DESCRICAO=:DESCRICAO,');
          SQL.Add('TIPO=:TIPO,NAOCONTABILIZADO=:NAOCONTABILIZADO');
          SQL.Add('where IDCLIENTE=:IDCLIENTE and IDLOJA=:IDLOJA and IDPLANOCONTA=:IDPLANOCONTA');
        end;
        ParamByName('IDPLANOCONTA').AsInteger := IDPLANOCONTA;
        ParamByName('CODIGO').Value := CODIGO;
        ParamByName('DESCRICAO').Value := DESCRICAO;
        ParamByName('TIPO').Value := TIPO;
        ParamByName('NAOCONTABILIZADO').Value := NAOCONTABILIZADO;
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
        erro := 'Erro ao cadastrar plano de conta: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TPlanoconta.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idplanoconta = idplanoconta+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idplanoconta from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idplanoconta := fieldbyname('idplanoconta').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idplanoconta;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao consultar : ' + ex.Message;
        Result := 0;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TPlanoconta.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select  ');
      SQL.Add('gesplanoconta.idplanoconta as id, ');
      SQL.Add('gesplanoconta.codigo, ');
      SQL.Add('gesplanoconta.descricao, ');
      SQL.Add('case gesplanoconta.tipo  ');
      SQL.Add('when 0 then ''SELECIONE''  ');
      SQL.Add('when 1 then ''RECEITA''  ');
      SQL.Add('when 2 then ''DESPESA''  ');
      SQL.Add('end as tipo, ');
      SQL.Add('gesplanoconta.naocontabilizado ');
      SQL.Add('From  ');
      SQL.Add('gesplanoconta WHERE gesplanoconta.idplanoconta is not null ');

     //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND(gesplanoconta.descricao like ''%' + AQuery.Items['busca'] + '%'' ');
        end;
      end;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesplanoconta.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesplanoconta.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesplanoconta.idloja = :idloja');
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

function TPlanoconta.Listacredito(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select  ');
      SQL.Add('gesplanoconta.idplanoconta as id, ');
      SQL.Add('gesplanoconta.codigo, ');
      SQL.Add('gesplanoconta.descricao, ');
      SQL.Add('gesplanoconta.tipo, ');
      SQL.Add('gesplanoconta.naocontabilizado ');
      SQL.Add('From  ');
      SQL.Add('gesplanoconta WHERE gesplanoconta.idplanoconta is not null and gesplanoconta.tipo = 1 ');

      if AQuery.ContainsKey('codigo') then
      begin
        if Length(AQuery.Items['codigo']) > 0 then
          SQL.Add('AND gesplanoconta.codigo like ''%' + AQuery.Items['codigo'] + '%'' ');
      end;
      if AQuery.ContainsKey('descricao') then
      begin
        if Length(AQuery.Items['descricao']) > 0 then
          SQL.Add('AND gesplanoconta.descricao like ''%' + AQuery.Items['descricao'] + '%'' ');
      end;

      if AQuery.ContainsKey('naocontabilizado') then
      begin
        if Length(AQuery.Items['naocontabilizado']) > 0 then
          SQL.Add('AND gesplanoconta.naocontabilizado like ''%' + AQuery.Items['naocontabilizado'] + '%'' ');
      end;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesplanoconta.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesplanoconta.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesplanoconta.idloja = :idloja');
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

function TPlanoconta.Listadebito(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select  ');
      SQL.Add('gesplanoconta.idplanoconta as id, ');
      SQL.Add('gesplanoconta.codigo, ');
      SQL.Add('gesplanoconta.descricao, ');
      SQL.Add('gesplanoconta.tipo, ');
      SQL.Add('gesplanoconta.naocontabilizado ');
      SQL.Add('From  ');
      SQL.Add('gesplanoconta WHERE gesplanoconta.idplanoconta is not null and gesplanoconta.tipo = 2  ');

      if AQuery.ContainsKey('codigo') then
      begin
        if Length(AQuery.Items['codigo']) > 0 then
          SQL.Add('AND gesplanoconta.codigo like ''%' + AQuery.Items['codigo'] + '%'' ');
      end;
      if AQuery.ContainsKey('descricao') then
      begin
        if Length(AQuery.Items['descricao']) > 0 then
          SQL.Add('AND gesplanoconta.descricao like ''%' + AQuery.Items['descricao'] + '%'' ');
      end;
      if AQuery.ContainsKey('naocontabilizado') then
      begin
        if Length(AQuery.Items['naocontabilizado']) > 0 then
          SQL.Add('AND gesplanoconta.naocontabilizado like ''%' + AQuery.Items['naocontabilizado'] + '%'' ');
      end;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesplanoconta.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesplanoconta.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesplanoconta.idloja = :idloja');
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

function TPlanoconta.Listaid(const AQuery: TDictionary<string, string>;
  out erro: string): TFDQuery;
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
      SQL.Add('gesplanoconta WHERE gesplanoconta.idplanoconta is not null and gesplanoconta.idplanoconta =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idplanocontabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesplanoconta.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesplanoconta.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesplanoconta.idloja = :idloja');
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


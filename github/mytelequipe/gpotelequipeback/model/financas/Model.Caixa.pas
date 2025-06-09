unit Model.Caixa;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TCaixa = class
  private
    FConn: TFDConnection;
    Fidcaixa: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fidpessoa: Integer;
    Fdeletado: Integer;

    Fcategoria: string;
    Ftipo: string;
    Fcliente: string;
    Fdata: string;
    Fvalor: Real;
    Fhistorico: string;
    Fanexos: Integer;
    Fmarcadores: string;

  public
    constructor Create;
    destructor Destroy; override;

    property idcaixa: Integer read Fidcaixa write Fidcaixa;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property idpessoa: Integer read Fidpessoa write Fidpessoa;

    property categoria: string read Fcategoria write Fcategoria;
    property tipo: string read Ftipo write Ftipo;
    property cliente: string read Fcliente write Fcliente;
    property data: string read Fdata write Fdata;
    property valor: Real read Fvalor write Fvalor;
    property historico: string read Fhistorico write Fhistorico;
    property anexos: Integer read Fanexos write Fanexos;
    property marcadores: string read Fmarcadores write Fmarcadores;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Inserir(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
  end;

implementation

{ TCaixa }

constructor TCaixa.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TCaixa.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TCaixa.Editar(out erro: string): Boolean;
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
        SQL.Add('update gescaixa set idpessoa=:idpessoa,');
		    SQL.Add('categoria=:categoria,');
		    SQL.Add('tipo=:tipo,');
		    SQL.Add('cliente=:cliente,');
		    SQL.Add('data=:data,');
		    SQL.Add('valor=:valor,');
		    SQL.Add('historico=:historico,');
		    SQL.Add('anexos=:anexos,');
        SQL.Add('marcadores=:marcadores, DELETADO=:DELETADO');

        SQL.Add('where IDCLIENTE=:IDCLIENTE and IDLOJA=:IDLOJA and IDCAIXA=:IDCAIXA');
        ParamByName('idcaixa').Value := idcaixa;
        ParamByName('idpessoa').Value := idpessoa;

				ParamByName('categoria').Value := categoria;
				ParamByName('tipo').Value := tipo;
				ParamByName('cliente').Value := cliente;
				ParamByName('data').Value := data;
				ParamByName('valor').Value := valor;
				ParamByName('historico').Value := historico;
				ParamByName('anexos').Value := anexos;
				ParamByName('marcadores').Value := marcadores;

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
        erro := 'Erro ao cadastrar caixa: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TCaixa.Inserir(out erro: string): Boolean;
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
        sql.add('update admponteiro set idcaixa = idcaixa+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idcaixa from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        id := fieldbyname('idcaixa').AsInteger;
        Active := false;
        sql.Clear;
        SQL.Add('INSERT INTO gescaixa(idcaixa,idpessoa,categoria,tipo,cliente,data,');
        SQL.Add('valor,historico,anexos,');
        SQL.Add('marcadores,IDCLIENTE,IDLOJA,DELETADO)');
        SQL.Add('               VALUES(:idcaixa,:idpessoa,:categoria,:tipo,:cliente,');
        SQL.Add(':data,:valor,:historico,:anexos, ');
        SQL.Add(':marcadores,:IDCLIENTE,:IDLOJA,:DELETADO)');

        ParamByName('idcaixa').Value := id;
        ParamByName('idpessoa').Value := idpessoa;
        ParamByName('categoria').Value := categoria;
        ParamByName('tipo').Value := tipo;
        ParamByName('cliente').Value := cliente;
        ParamByName('data').Value := data;
        ParamByName('valor').Value := valor;
        ParamByName('historico').Value := historico;
        ParamByName('anexos').Value := anexos;
        ParamByName('marcadores').Value := marcadores;

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
        erro := 'Erro ao cadastrar caixa: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TCaixa.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select   ');
      SQL.Add('gescaixa.idcaixa as id,   ');
      SQL.Add('gescaixa.idpessoa,   ');
      SQL.Add('gescaixa.categoria,   ');
      SQL.Add('gescaixa.tipo,   ');
      SQL.Add('gescaixa.cliente,   ');
      SQL.Add('DATE_FORMAT(gescaixa.data,''%d/%m/%Y'') as data,    ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gescaixa.valor, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valor, ');
      SQL.Add('gescaixa.historico,   ');
      SQL.Add('gescaixa.anexos,   ');
      SQL.Add('gescaixa.marcadores    ');
      SQL.Add('From   ');
      SQL.Add('gescaixa WHERE gescaixa.idcaixa is not null ');

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gescaixa.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gescaixa.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gescaixa.idloja = :idloja');
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

function TCaixa.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gescaixa WHERE gescaixa.idcaixa is not null and gescaixa.idcaixa =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idcaixabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gescaixa.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gescaixa.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gescaixa.idloja = :idloja');
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


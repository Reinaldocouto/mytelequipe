unit Model.ConfigOrdemCompra;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TConfigOrdemCompra = class
  private
    FConn: TFDConnection;
    Fopfornecedor: Integer;
    Fpreconaordemdecompra: Integer;
    Fstatusordemcompra: Integer;
    Flancarestoque: Integer;
    Flancarcontaspagar: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property opfornecedor: Integer read Fopfornecedor write  Fopfornecedor;
    property preconaordemdecompra: Integer read Fpreconaordemdecompra write Fpreconaordemdecompra;
    property statusordemcompra: Integer read Fstatusordemcompra write Fstatusordemcompra;
    property lancarestoque: Integer read Flancarestoque write Flancarestoque;
    property lancarcontaspagar: Integer read Flancarcontaspagar write Flancarcontaspagar;

    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Inserir(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;

  end;

implementation

{ TProduto }

constructor TConfigOrdemCompra.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TConfigOrdemCompra.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TConfigOrdemCompra.Editar(out erro: string): Boolean;
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
        sql.add('select * from gesconfigordemcompra where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO gesconfigordemcompra(fornecedor,preconaordemdecompra,statusordemcompra,lancarestoque,');
          SQL.Add('lancarcontaspagar,dataatualizacao,idcliente,idloja)');
          SQL.Add('                          VALUES(:fornecedor,:preconaordemdecompra,:statusordemcompra,:lancarestoque,');
          SQL.Add(':lancarcontaspagar,:dataatualizacao,:idcliente,:idloja)');
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gesconfigordemcompra Set ');
          SQL.Add('fornecedor=:fornecedor, ');
          SQL.Add('preconaordemdecompra=:preconaordemdecompra, ');
          SQL.Add('statusordemcompra=:statusordemcompra, ');
          SQL.Add('lancarestoque=:lancarestoque, ');
          SQL.Add('lancarcontaspagar=:lancarcontaspagar, ');
          SQL.Add('dataatualizacao=:dataatualizacao ');
          SQL.Add('where idcliente=:idcliente and idloja=:idloja ');
        end;
        ParamByName('fornecedor').Value :=   opfornecedor ;
        ParamByName('preconaordemdecompra').Value := preconaordemdecompra;
        ParamByName('statusordemcompra').Value :=  statusordemcompra;
        ParamByName('lancarestoque').Value :=   lancarestoque;
        ParamByName('lancarcontaspagar').Value := lancarcontaspagar;
        ParamByName('dataatualizacao').value := now;
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar cliente: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;























function TConfigOrdemCompra.Inserir(out erro: string): Boolean;
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

      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao cadastrar cliente: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TConfigOrdemCompra.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesconfigordemcompra.fornecedor, ');
      SQL.Add('gesconfigordemcompra.preconaordemdecompra, ');
      SQL.Add('gesconfigordemcompra.statusordemcompra, ');
      SQL.Add('gesconfigordemcompra.lancarestoque, ');
      SQL.Add('gesconfigordemcompra.lancarcontaspagar, ');
      SQL.Add('DATE_FORMAT(gesconfigordemcompra.dataatualizacao,''%d/%m/%Y'' '' - ''  ''%H %i'' ) as dataatualizacao ');
      SQL.Add('From gesconfigordemcompra where gesconfigordemcompra.idgeral is not null ');
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesconfigordemcompra.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesconfigordemcompra.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end;
      end;
      Active := true;
      Open();
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


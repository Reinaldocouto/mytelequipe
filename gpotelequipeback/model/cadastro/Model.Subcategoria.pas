unit Model.Subcategoria;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TSubcategoria = class
  private
    FConn: TFDConnection;
    Fidsubcategoria: Integer;
    Fidcategoria: Integer;
    Fdescricaosubcategoria: string;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;


  public
    constructor Create;
    destructor Destroy; override;

    property idsubcategoria: Integer read Fidsubcategoria write Fidsubcategoria;
    property idcategoria: Integer read Fidcategoria write Fidcategoria;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property descricaosubcategoria: string read Fdescricaosubcategoria write Fdescricaosubcategoria;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro:string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;

  end;

implementation

{ TSubcategoria }

constructor TSubcategoria.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TSubcategoria.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TSubcategoria.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idsubcategoria = idsubcategoria+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idsubcategoria from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idsubcategoria := fieldbyname('idsubcategoria').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idsubcategoria
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

function TSubcategoria.Editar(out erro: string): Boolean;
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
        sql.add('select idsubcategoria from gessubcategoria where idcliente=:idcliente and idloja=:idloja and idsubcategoria=:idsubcategoria ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ParamByName('IDsubcategoria').AsInteger := IDsubcategoria;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('INSERT INTO gessubcategoria(IDsubcategoria,descricaosubcategoria,idcliente,idloja,deletado,idcategoria)');
          SQL.Add('             VALUES(:IDsubcategoria,:descricaosubcategoria,:idcliente,:idloja,:deletado,:idcategoria)');
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gessubcategoria set DELETADO=:DELETADO,descricaosubcategoria=:descricaosubcategoria, IDCATEGORIA=:IDCATEGORIA ');
          SQL.Add('where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDsubcategoria =:IDsubcategoria');
        end;
        ParamByName('idsubcategoria').Value := idsubcategoria;
        ParamByName('idcategoria').Value := idcategoria;
        ParamByName('DESCRICAOSUBCATEGORIA').Value := DESCRICAOSUBCATEGORIA;
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 0;
        ExecSQL;
      end;
      FConn.Commit;
      erro := '';
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar Subcategoria: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TSubcategoria.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gessubcategoria.idsubcategoria as id, ');
      SQL.Add('gessubcategoria.descricaosubcategoria as subcategoria, ');
      SQL.Add('gescategoria.descricao as categoria');
      SQL.Add('From  ');
      SQL.Add('gessubcategoria Inner Join ');
      SQL.Add('gescategoria On gescategoria.idcategoria = gessubcategoria.idcategoria ');
      SQL.Add('WHERE ');
      SQL.Add('gessubcategoria.idsubcategoria is not null ');

     //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND(gessubcategoria.descricaosubcategoria like ''%' + AQuery.Items['busca'] + '%''');
          SQL.Add('or gescategoria.descricao like ''%' + AQuery.Items['busca'] + '%'' )');
        end;
      end;


      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gessubcategoria.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gessubcategoria.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gessubcategoria.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end;
      end;
      SQL.Add('order by descricaosubcategoria');
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

function TSubcategoria.Listaid(const AQuery: TDictionary<string, string>;
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
      SQL.Add('gessubcategoria WHERE gessubcategoria.idsubcategoria is not null and gessubcategoria.idsubcategoria =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idsubcategoriabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gessubcategoria.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gessubcategoria.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gessubcategoria.idloja = :idloja');
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


unit Model.Embalagem;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TEmbalagem = class
  private
    FConn: TFDConnection;
    Fidembalagem: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
    Fdescricao: string;
    Fcomprimento: Real;
    Flargura: Real;
    Fpeso: Real;
    Faltura: Real;
    Fdiametro: Real;
    Ftipo: string;

  public
    constructor Create;
    destructor Destroy; override;

    property idembalagem: Integer read Fidembalagem write Fidembalagem;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property descricao: string read Fdescricao write Fdescricao;
    property comprimento: Real read Fcomprimento write Fcomprimento;
    property largura: Real read Flargura write Flargura;
    property peso: Real read Fpeso write Fpeso;
    property altura: Real read Faltura write Faltura;
    property diametro: Real read Fdiametro write Fdiametro;
    property tipo: string read Ftipo write Ftipo;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro:string): TFDQuery;
    function Inserir(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;

  end;

implementation

{ TEmbalagem }

constructor TEmbalagem.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TEmbalagem.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TEmbalagem.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idembalagem = idembalagem+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idembalagem from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idembalagem := fieldbyname('idembalagem').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := id
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

function TEmbalagem.Editar(out erro: string): Boolean;
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
        SQL.Add('select idembalagem from gesembalagem where idcliente=:idcliente and idloja=:idloja and idembalagem=:idembalagem ');
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('IDEMBALAGEM').AsInteger := IDEMBALAGEM;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('INSERT INTO gesembalagem(IDEMBALAGEM,DESCRICAO,COMPRIMENTO,LARGURA,PESO,ALTURA,DIAMETRO,TIPO,');
          SQL.Add('IDCLIENTE,IDLOJA,DELETADO)');
          SQL.Add('       VALUES(:IDEMBALAGEM,:DESCRICAO,:COMPRIMENTO,:LARGURA,:PESO,:ALTURA,:DIAMETRO,:TIPO,');
          SQL.Add(':IDCLIENTE,:IDLOJA,:DELETADO)');
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gesembalagem set DELETADO=:DELETADO,descricao=:descricao,COMPRIMENTO=:COMPRIMENTO, ');
          SQL.Add('LARGURA=:LARGURA,PESO=:PESO,ALTURA=:ALTURA,DIAMETRO=:DIAMETRO,TIPO=:TIPO ');
          SQL.Add('where IDCLIENTE=:IDCLIENTE and IDLOJA=:IDLOJA and IDembalagem=:IDembalagem');
        end;
        ParamByName('IDEMBALAGEM').Value := idembalagem;
        ParamByName('DESCRICAO').Value := DESCRICAO;
        ParamByName('COMPRIMENTO').Value := COMPRIMENTO;
        ParamByName('LARGURA').Value := LARGURA;
        ParamByName('PESO').Value := PESO;
        ParamByName('ALTURA').Value := ALTURA;
        ParamByName('DIAMETRO').Value := DIAMETRO;
        ParamByName('TIPO').Value := TIPO;
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
        erro := 'Erro ao cadastrar embalagem: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TEmbalagem.Inserir(out erro: string): Boolean;
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
        SQL.Add('INSERT INTO gesembalagem(IDembalagem,DESCRICAO,comprimento,largura,peso,altura,diametro,tipo,');
        SQL.Add('IDCLIENTE,IDLOJA,DELETADO)');
        SQL.Add('       VALUES(:IDembalagem,:DESCRICAO,:comprimento,:largura,:peso,:altura,:diametro,:tipo,');
        SQL.Add(':IDCLIENTE,:IDLOJA,:DELETADO)');
        ParamByName('IDembalagem').AsInteger := id;
        ParamByName('DESCRICAO').Value := DESCRICAO;
        ParamByName('COMPRIMENTO').Value := COMPRIMENTO;
        ParamByName('LARGURA').Value := LARGURA;
        ParamByName('PESO').Value := PESO;
        ParamByName('ALTURA').Value := ALTURA;
        ParamByName('DIAMETRO').Value := DIAMETRO;
        ParamByName('TIPO').Value := TIPO;
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 0;
        execsql;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar embalagem: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TEmbalagem.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesembalagem.idembalagem as id, ');
      SQL.Add('gesembalagem.descricao, ');
      SQL.Add('gesembalagem.tipo, ');
      SQL.Add('gesembalagem.comprimento,  ');
      SQL.Add('gesembalagem.largura, ');
      SQL.Add('gesembalagem.peso, ');
      SQL.Add('gesembalagem.altura, ');
      SQL.Add('gesembalagem.diametro ');
      SQL.Add('From  ');
      SQL.Add('gesembalagem WHERE gesembalagem.idembalagem is not null ');

      if AQuery.ContainsKey('descricao') then
      begin
        if Length(AQuery.Items['descricao']) > 0 then
          SQL.Add('AND gesembalagem.descricao like ''%' + AQuery.Items['descricao'] + '%'' ');
      end;

      if AQuery.ContainsKey('tipo') then
      begin
        if Length(AQuery.Items['tipo']) > 0 then
          SQL.Add('AND gesembalagem.tipo like ''%' + AQuery.Items['tipo'] + '%'' ');
      end;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesembalagem.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesembalagem.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesembalagem.idloja = :idloja');
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

function TEmbalagem.Listaid(const AQuery: TDictionary<string, string>;
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
      SQL.Add('gesembalagem WHERE gesembalagem.idembalagem is not null and gesembalagem.idembalagem =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idembalagembusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesembalagem.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesembalagem.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesembalagem.idloja = :idloja');
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


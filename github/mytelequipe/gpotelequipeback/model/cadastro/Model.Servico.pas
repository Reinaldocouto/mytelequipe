unit Model.Servico;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TServico = class
  private
    FConn: TFDConnection;
    Fidservico: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
    Fdescricao: string;
    Fsituacao: Integer;
    Fvalor: string;
    Fcodigo: string;
    Funidade: string;
    Fcodigoservico: string;
    Fnomenclatura: string;
    Fdescricaocomplementar: string;
    Fobservacoes: string;

  public
    constructor Create;
    destructor Destroy; override;

    property idservico: Integer read Fidservico write Fidservico;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property descricao: string read Fdescricao write Fdescricao;
    property situacao: Integer read Fsituacao write Fsituacao;
    property valor: string read Fvalor write Fvalor;
    property codigo: string read Fcodigo write Fcodigo;
    property unidade: string read Funidade write Funidade;
    property codigoservico: string read Fcodigoservico write Fcodigoservico;
    property nomenclatura: string read Fnomenclatura write Fnomenclatura;
    property descricaocomplementar: string read Fdescricaocomplementar write Fdescricaocomplementar;
    property observacoes: string read Fobservacoes write Fobservacoes;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Inserir(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;

  end;

implementation

{ TServico}

constructor TServico.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TServico.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function Tservico.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idservico = idservico+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idservico from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idservico := fieldbyname('idservico').AsInteger;
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

function TServico.Editar(out erro: string): Boolean;
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
        sql.add('select idservico from gesservico  where idcliente=:idcliente and idloja=:idloja and idservico=:idservico ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ParamByName('idservico').AsInteger := IDSERVICO;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('INSERT INTO gesservico(IDSERVICO,DESCRICAO,SITUACAO,VALOR,CODIGO,UNIDADE,CODIGOSERVICO,NOMENCLATURA,');
          SQL.Add('DESCRICAOCOMPLEMENTAR,OBSERVACOES,IDCLIENTE,IDLOJA,DELETADO)');
          SQL.Add('       VALUES(:IDSERVICO,:DESCRICAO,:SITUACAO,:VALOR,:CODIGO,:UNIDADE,:CODIGOSERVICO,:NOMENCLATURA,');
          SQL.Add(':DESCRICAOCOMPLEMENTAR,:OBSERVACOES,:IDCLIENTE,:IDLOJA,:DELETADO)');
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gesservico set DELETADO=:DELETADO,DESCRICAO=:DESCRICAO,SITUACAO=:SITUACAO,VALOR=:VALOR,CODIGO=:CODIGO, ');
          SQL.Add('UNIDADE=:UNIDADE,CODIGOSERVICO=:CODIGOSERVICO,NOMENCLATURA=:NOMENCLATURA,DESCRICAOCOMPLEMENTAR=:DESCRICAOCOMPLEMENTAR,');
          SQL.Add('OBSERVACOES=:OBSERVACOES ');
          SQL.Add('where IDCLIENTE=:IDCLIENTE and IDLOJA=:IDLOJA and IDSERVICO=:IDSERVICO');
        end;
        ParamByName('idservico').AsInteger := IDSERVICO;
        ParamByName('DESCRICAO').Value := DESCRICAO;
        ParamByName('SITUACAO').Value := SITUACAO;
        ParamByName('VALOR').Value := VALOR;
        ParamByName('CODIGO').Value := CODIGO;
        ParamByName('UNIDADE').Value := UNIDADE;
        ParamByName('CODIGOSERVICO').Value := CODIGOSERVICO;
        ParamByName('NOMENCLATURA').Value := NOMENCLATURA;
        ParamByName('DESCRICAOCOMPLEMENTAR').Value := DESCRICAOCOMPLEMENTAR;
        ParamByName('OBSERVACOES').Value := OBSERVACOES;
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
        erro := 'Erro ao cadastrar serviço: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TServico.Inserir(out erro: string): Boolean;
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
        SQL.Add('INSERT INTO gesservico(IDSERVICO,DESCRICAO,SITUACAO,VALOR,CODIGO,UNIDADE,CODIGOSERVICO,NOMENCLATURA,');
        SQL.Add('DESCRICAOCOMPLEMENTAR,OBSERVACOES,IDCLIENTE,IDLOJA,DELETADO)');
        SQL.Add('       VALUES(:IDSERVICO,:DESCRICAO,:SITUACAO,:VALOR,:CODIGO,:UNIDADE,:CODIGOSERVICO,:NOMENCLATURA,');
        SQL.Add(':DESCRICAOCOMPLEMENTAR,:OBSERVACOES,:IDCLIENTE,:IDLOJA,:DELETADO)');

        ParamByName('IDSERVICO').AsInteger := id;
        ParamByName('DESCRICAO').Value := DESCRICAO;
        ParamByName('SITUACAO').Value := SITUACAO;
        ParamByName('VALOR').Value := VALOR;
        ParamByName('CODIGO').Value := CODIGO;
        ParamByName('UNIDADE').Value := UNIDADE;
        ParamByName('CODIGOSERVICO').Value := CODIGOSERVICO;
        ParamByName('NOMENCLATURA').Value := NOMENCLATURA;
        ParamByName('DESCRICAOCOMPLEMENTAR').Value := DESCRICAOCOMPLEMENTAR;
        ParamByName('OBSERVACOES').Value := OBSERVACOES;
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
        erro := 'Erro ao cadastrar serviço: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TServico.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesservico.idservico as id, ');
      SQL.Add('gesservico.descricao, ');
      SQL.Add('gesservico.valor, ');
      SQL.Add('gesservico.codigo ');
      SQL.Add('From ');
      SQL.Add('gesservico WHERE gesservico.idservico is not null ');

      if AQuery.ContainsKey('descricao') then
      begin
        if Length(AQuery.Items['descricao']) > 0 then
          SQL.Add('AND gesservico.descricao like ''%' + AQuery.Items['descricao'] + '%'' ');
      end;

      if AQuery.ContainsKey('codigo') then
      begin
        if Length(AQuery.Items['codigo']) > 0 then
          SQL.Add('AND gesservico.codigo like ''%' + AQuery.Items['codigo'] + '%'' ');
      end;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesservico.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesservico.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesservico.idloja = :idloja');
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

function TServico.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesservico WHERE gesservico.idservico is not null and gesservico.idservico =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idservicosbusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesservico.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesservico.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesservico.idloja = :idloja');
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


unit Model.Rh;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  Trh = class
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

    function ListaConvenio(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listafolhapagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listavaletransporte(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listamulta(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaticket(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listafolhaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
//    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
//    function Inserir(out erro: string): Boolean;
//    function Editar(out erro: string): Boolean;
//    function NovoCadastro(out erro: string): integer;

  end;

implementation

{ Trh }

constructor Trh.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor Trh.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;
{
function Trh.NovoCadastro(out erro: string): integer;
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

function Trh.Editar(out erro: string): Boolean;
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

function Trh.Inserir(out erro: string): Boolean;
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

}

function Trh.Listafolhaid(const AQuery: TDictionary<string, string>;
  out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a : string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      sql.add('SET @contador := 0; ');
      sql.add('SELECT ');
      sql.add('@contador := @contador + 1 AS id, ');
      sql.add('gesfolhapagamento.codlancamento, ');
      sql.add('gesfolhapagamento.lancamento, ');
      sql.add('gesfolhapagamento.referencia, ');
      sql.add('gesfolhapagamento.Provento, ');
      sql.add('gesfolhapagamento.Desconto, ');
      sql.add('gesfolhapagamento.Bases, ');
      sql.add('gesfolhapagamento.liquido ');
      sql.add('From ');
      sql.add('gesfolhapagamento ');
      sql.add('Where ');
      sql.add('gesfolhapagamento.codigo =:codigo and competencia=:periodo ');
      parambyname('periodo').asstring := AQuery.Items['datafolha'];
      parambyname('codigo').asstring := AQuery.Items['codigo'];
      a := AQuery.Items['codigo'];
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

function Trh.Listafolhapagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  Result := nil;
  erro := '';
  qry := TFDQuery.Create(nil);

  try
    qry.Connection := FConn;
    qry.SQL.BeginUpdate;
    try
      qry.SQL.Clear;

      // Consulta SQL otimizada
      qry.SQL.Add('SET @contador := 0;');
      qry.SQL.Add('SELECT');
      qry.SQL.Add('  @contador := @contador + 1 AS id,');
      qry.SQL.Add('  d.codigo,');
      qry.SQL.Add('  d.Nome,');
      qry.SQL.Add('  d.competencia,');
      qry.SQL.Add('  gespessoa.tipopessoa,');
      qry.SQL.Add('  gespessoa.dataadmissao,');
      qry.SQL.Add('  gespessoa.cargo,');
      qry.SQL.Add('  gespessoa.cbo,');
      qry.SQL.Add('  gespessoa.cpf,');
      qry.SQL.Add('  CONCAT(''R$ '', FORMAT(d.salario, 2, ''de_DE'')) AS salario,');
      qry.SQL.Add('  CONCAT(''R$ '', FORMAT(SUM(d.provento), 2, ''de_DE'')) AS provento,');
      qry.SQL.Add('  CONCAT(''R$ '', FORMAT(SUM(d.desconto), 2, ''de_DE'')) AS desconto,');
      qry.SQL.Add('  CONCAT(''R$ '', FORMAT(SUM(d.liquido), 2, ''de_DE'')) AS liquido');
      qry.SQL.Add('FROM (');
      qry.SQL.Add('  SELECT codigo, Nome, competencia, salario, 0 AS provento, 0 AS desconto, 0 AS liquido');
      qry.SQL.Add('  FROM gesfolhapagamento');
      qry.SQL.Add('  WHERE competencia = :periodo');
      qry.SQL.Add('  GROUP BY codigo');
      qry.SQL.Add('  UNION ALL');
      qry.SQL.Add('  SELECT codigo, Nome, competencia, salario, Provento, 0, 0');
      qry.SQL.Add('  FROM gesfolhapagamento');
      qry.SQL.Add('  WHERE competencia = :periodo AND lancamento = ''Proventos''');
      qry.SQL.Add('  UNION ALL');
      qry.SQL.Add('  SELECT codigo, Nome, competencia, salario, 0, Desconto, 0');
      qry.SQL.Add('  FROM gesfolhapagamento');
      qry.SQL.Add('  WHERE competencia = :periodo AND lancamento = ''Descontos''');
      qry.SQL.Add('  UNION ALL');
      qry.SQL.Add('  SELECT codigo, Nome, competencia, salario, 0, 0, liquido');
      qry.SQL.Add('  FROM gesfolhapagamento');
      qry.SQL.Add('  WHERE competencia = :periodo AND lancamento = ''líquido''');
      qry.SQL.Add(') AS d');
      qry.SQL.Add('INNER JOIN gespessoa ON gespessoa.nregistro = d.codigo');
      qry.SQL.Add('WHERE d.competencia = :periodo');
      qry.SQL.Add('GROUP BY d.codigo');
      qry.SQL.Add('ORDER BY d.Nome');

      qry.SQL.EndUpdate;

      // Parâmetro seguro
      if AQuery.ContainsKey('datafolha') then
        qry.ParamByName('periodo').AsString := AQuery['datafolha']
      else
        raise Exception.Create('Parâmetro "datafolha" não encontrado');

      qry.Open;
      Result := qry;

    except
      on E: Exception do
      begin
        qry.Free;
        raise;
      end;
    end;

  except
    on E: Exception do
    begin
      erro := 'Erro ao consultar folha de pagamento: ' + E.Message;
      if Assigned(qry) then
        qry.Free;
      Result := nil;
    end;
  end;
end;

function Trh.Listamulta(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin

end;


function Trh.ListaConvenio(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      qry.SQL.Add('SELECT idgeral as id, valorconvenio, descontocolaborador, valorempresa, periodo, idade, nome, nomeconvenio FROM convenio');

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


function Trh.Listaticket(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;

    with qry.SQL do
    begin
      Clear;
      Add('SELECT');
      Add('  ticket.idgeral AS idticket,');
      Add('  ticket.codigo,');
      Add('  gespessoa.nome,');
      Add('  ticket.projeto,');
      Add('  ticket.opcao,');
      Add('  ticket.beneficio,');
      Add('  ticket.desconto,');
      Add('  ticket.valorempresa,');
      Add('  ticket.periodo AS periodo,');
      Add('  ticket.dias,');
      Add('  ticket.observacao,');
      Add('  ticket.criado_em');
      Add('FROM ticket');
      Add('LEFT JOIN gespessoa ON gespessoa.nregistro = ticket.codigo');

      if AQuery.ContainsKey('datafolha') then
        Add('WHERE ticket.periodo = :periodo');

      Add('ORDER BY ticket.periodo');
    end;

    if AQuery.ContainsKey('datafolha') then
      qry.ParamByName('periodo').AsString := AQuery['datafolha'];

    qry.Open; // mais seguro que Active := True

    erro := '';
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar: ' + ex.Message;
      FreeAndNil(qry);
      Result := nil;
    end;
  end;
end;



function Trh.Listavaletransporte(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('SELECT ');
      SQL.Add('valetransporte.idgeral as idvaletransporte, ');
      SQL.Add('valetransporte.codigo, ');
      SQL.Add('gespessoa.nome, ');
      SQL.Add('valetransporte.projeto, ');
      SQL.Add('valetransporte.valordia, ');
      SQL.Add('valetransporte.dias, ');
      SQL.Add('valetransporte.beneficio, ');
      SQL.Add('valetransporte.porc6, ');
      SQL.Add('valetransporte.empresa, ');
      SQL.Add('valetransporte.estado, ');
      SQL.Add('valetransporte.periodo, ');
      SQL.Add('valetransporte.admissao, ');
      SQL.Add('valetransporte.cargo, ');
      SQL.Add('valetransporte.cbo, ');
      SQL.Add('valetransporte.salario, ');
      SQL.Add('valetransporte.observacao ');
      SQL.Add('FROM valetransporte ');
      SQL.Add('LEFT JOIN gespessoa ON gespessoa.nregistro = valetransporte.codigo ');

      if AQuery.ContainsKey('datafolha') then
        SQL.Add('WHERE valetransporte.periodo = :periodo');
      if AQuery.ContainsKey('datafolha') then
        qry.ParamByName('periodo').AsString := AQuery['datafolha'];
      SQL.Add('ORDER BY gespessoa.nome;');
      Active := True;
    end;
    erro := '';
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar Vale Transporte: ' + ex.Message;
      Result := nil;
    end;
  end;
end;

{
function Trh.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
}
end.


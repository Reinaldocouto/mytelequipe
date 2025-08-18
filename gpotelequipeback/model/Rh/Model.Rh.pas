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

    function Listafolhapagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listavaletransporte(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listamulta(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaticket(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaconvenio(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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

function Trh.Listaconvenio(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      sql.add('SET @contador := 0; ');
      sql.add('SELECT ');
      sql.add('@contador := @contador + 1 AS id, ');
      SQL.Add('convenio.codigo, ');
      SQL.Add('gespessoa.nome, ');
      SQL.Add('gespessoa.datanascimento, ');
      SQL.Add('YEAR(CURDATE()) - YEAR(gespessoa.datanascimento) - ');
      SQL.Add('(CASE ');
      SQL.Add('WHEN MONTH(CURDATE()) < MONTH(gespessoa.datanascimento) OR ');
      SQL.Add('(MONTH(CURDATE()) = MONTH(gespessoa.datanascimento) AND DAY(CURDATE()) < DAY(gespessoa.datanascimento)) ');
      SQL.Add('THEN 1 ');
      SQL.Add('ELSE 0 ');
      SQL.Add('END) AS idade, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(convenio.portototal, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as portototal, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(convenio.colaborador07, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as colaborador07, ');
      SQL.Add('convenio.dependente, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(convenio.descontocolaborador, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as descontocolaborador, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(convenio.valorempresa, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valorempresa, ');
      SQL.Add('convenio.periodo ');
      SQL.Add('From ');
      SQL.Add('convenio Left Join ');
      SQL.Add('gespessoa On gespessoa.nregistro = convenio.codigo ');
      SQL.Add('Where ');
      SQL.Add('gespessoa.empresa = 148 and periodo=:periodo order by gespessoa.nome  ');
      parambyname('periodo').asstring := AQuery.Items['datafolha'];
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
      sql.add('    d.codigo, ');
      sql.add('    d.Nome, ');
      sql.add('    d.competencia, ');
      sql.add('    gespessoa.tipopessoa, ');
      sql.add('    gespessoa.dataadmissao, ');
      sql.add('    gespessoa.cargo, ');
      sql.add('    gespessoa.cbo, ');
      sql.add('    gespessoa.cpf, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(d.salario, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As salario, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(Sum(d.provento), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As provento, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(Sum(d.desconto), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As desconto, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(Sum(d.liquido), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As liquido ');
      sql.add('From ');
      sql.add('    (Select ');
      sql.add('         gesfolhapagamento.codigo, ');
      sql.add('         gesfolhapagamento.Nome, ');
      sql.add('         gesfolhapagamento.competencia, ');
      sql.add('         gesfolhapagamento.salario, ');
      sql.add('         0 As provento, ');
      sql.add('         0 As desconto, ');
      sql.add('         0 As liquido ');
      sql.add('     From ');
      sql.add('         gesfolhapagamento ');
      sql.add('     Group By ');
      sql.add('         gesfolhapagamento.codigo ');
      sql.add('     Union All ');
      sql.add('     Select ');
      sql.add('         gesfolhapagamento.codigo, ');
      sql.add('         gesfolhapagamento.Nome, ');
      sql.add('         gesfolhapagamento.competencia, ');
      sql.add('         gesfolhapagamento.salario, ');
      sql.add('         gesfolhapagamento.Provento, ');
      sql.add('         0 As desconto, ');
      sql.add('         0 As liquido ');
      sql.add('     From ');
      sql.add('         gesfolhapagamento ');
      sql.add('     Where ');
      sql.add('         gesfolhapagamento.lancamento = ''Proventos'' ');
      sql.add('     Group By ');
      sql.add('         gesfolhapagamento.codigo ');
      sql.add('     Union All ');
      sql.add('     Select ');
      sql.add('         gesfolhapagamento.codigo, ');
      sql.add('         gesfolhapagamento.Nome, ');
      sql.add('         gesfolhapagamento.competencia, ');
      sql.add('         gesfolhapagamento.salario, ');
      sql.add('         0 As Provento, ');
      sql.add('         gesfolhapagamento.Desconto, ');
      sql.add('         0 As liquido ');
      sql.add('     From ');
      sql.add('gesfolhapagamento ');
      sql.add('     Where ');
      sql.add('         gesfolhapagamento.lancamento = ''Descontos'' ');
      sql.add('     Group By ');
      sql.add('         gesfolhapagamento.codigo ');
      sql.add('     Union All ');
      sql.add('     Select ');
      sql.add('         gesfolhapagamento.codigo, ');
      sql.add('         gesfolhapagamento.Nome, ');
      sql.add('         gesfolhapagamento.competencia, ');
      sql.add('         gesfolhapagamento.salario, ');
      sql.add('         0 As Provento, ');
      sql.add('         0 As desconto, ');
      sql.add('         gesfolhapagamento.liquido ');
      sql.add('     From ');
      sql.add('         gesfolhapagamento ');
      sql.add('     Where ');
      sql.add('         gesfolhapagamento.lancamento = ''líquido'' ');
      sql.add('     Group By ');
      sql.add('         gesfolhapagamento.codigo) As d Inner Join ');
      sql.add('    gespessoa On gespessoa.nregistro = d.codigo');
      sql.add('Where d.competencia=:periodo Group By d.codigo order by d.Nome ');
      parambyname('periodo').asstring := AQuery.Items['datafolha'];
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

function Trh.Listamulta(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin

end;

function Trh.Listaticket(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      sql.add('SET @contador := 0; ');
      sql.add('SELECT ');
      sql.add('@contador := @contador + 1 AS id, ');
      SQL.Add('ticket.codigo, ');
      SQL.Add('gespessoa.nome, ');
      SQL.Add('gespessoa.dataadmissao, ');
      SQL.Add('gespessoa.cargo, ');
      SQL.Add('ticket.projeto, ');
      SQL.Add('ticket.opcao, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(ticket.beneficio, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as beneficio, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(ticket.desconto, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as desconto, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(ticket.valorempresa, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valorempresa, ');
      SQL.Add('ticket.periodo ');
      SQL.Add('From ');
      SQL.Add('ticket left Join ');
      SQL.Add('gespessoa On gespessoa.nregistro = ticket.codigo ');
      SQL.Add('Where ');
      SQL.Add('gespessoa.empresa = 148 and periodo=:periodo order by gespessoa.nome  ');
      parambyname('periodo').asstring := AQuery.Items['datafolha'];
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

function Trh.Listavaletransporte(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      sql.add('SET @contador := 0; ');
      sql.add('SELECT ');
      sql.add('@contador := @contador + 1 AS id, ');
      SQL.Add('valetransporte.codigo, ');
      SQL.Add('gespessoa.nome, ');
      SQL.Add('gespessoa.dataadmissao, ');
      SQL.Add('gespessoa.cargo, ');
      SQL.Add('gespessoa.cbo, ');
      SQL.Add('valetransporte.projeto, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(valetransporte.valordia, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valordia, ');
      SQL.Add('valetransporte.dias, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(valetransporte.beneficio, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as beneficio, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(valetransporte.porc6, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as porc6, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(valetransporte.empresa, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as empresa, ');
      SQL.Add('valetransporte.estado, ');
      SQL.Add('valetransporte.periodo ');
      SQL.Add('From ');
      SQL.Add('valetransporte left Join ');
      SQL.Add('gespessoa On gespessoa.nregistro = valetransporte.codigo ');
      SQL.Add('Where ');
      SQL.Add('gespessoa.empresa = 148 and periodo=:periodo order by gespessoa.nome  ');
      parambyname('periodo').asstring := AQuery.Items['datafolha'];
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


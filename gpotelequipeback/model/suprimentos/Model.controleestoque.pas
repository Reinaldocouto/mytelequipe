unit Model.ControleEstoque;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections,
  Model.RegrasdeNegocio;

type
  Tcontroleestoque = class
  private
    FConn: TFDConnection;
    Fidcontroleestoque: Integer;
    Fidproduto: Integer;
    Fidusuario: integer;
    Fidtipomovimentacao: Integer;
    Fdataehora: string;
    Fentrada: Double;
    Fsaida: Double;
    Fbalanco: Double;
    Fvalor: Double;
    Fobservacao: string;

    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    property idcontroleestoque: Integer read Fidcontroleestoque write Fidcontroleestoque;
    property idproduto: Integer read Fidproduto write Fidproduto;
    property idusuario: Integer read Fidusuario write Fidusuario;
    property idtipomovimentacao: Integer read Fidtipomovimentacao write Fidtipomovimentacao;
    property dataehora: string read Fdataehora write Fdataehora;
    property entrada: double read Fentrada write Fentrada;
    property saida: double read Fsaida write Fsaida;
    property balanco: double read Fbalanco write Fbalanco;
    property valor: double read Fvalor write Fvalor;
    property observacao: string read Fobservacao write Fobservacao;

    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listadetalhe(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listadetalhestatus(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listalancamentotipo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;
    function RelatorioCustoSolicitacao(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
  end;

implementation

{ Tcontroleestoque }

constructor Tcontroleestoque.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor Tcontroleestoque.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function Tcontroleestoque.Editar(out erro: string): Boolean;
var
  regradenogocio: TRegraNegocios;
  qry: TFDQuery;
begin
  try
    regradenogocio := TRegraNegocios.Create;
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
    {  FConn.StartTransaction;
      with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('INSERT INTO gescontroleestoque(idcontroleestoque,idproduto,idtipomovimentacao,');
        SQL.Add('idcliente,idloja,deletado,dataehora,entrada,saida,balanco,valor,observacao)');
        SQL.Add('VALUES(:idcontroleestoque,:idproduto,:idtipomovimentacao,');
        SQL.Add(':idcliente,:idloja,:deletado,:dataehora,:entrada,:saida,:balanco,:valor,:observacao)');
        ParamByName('idcontroleestoque').Value := idcontroleestoque;
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 0;
        ParamByName('idproduto').Value := idproduto;
        ParamByName('idtipomovimentacao').Value := idtipomovimentacao;
        ParamByName('dataehora').Value := dataehora;
        ParamByName('entrada').Value := entrada;
        ParamByName('saida').Value := saida;
        ParamByName('balanco').Value := balanco;
        ParamByName('valor').Value := valor;
        ParamByName('observacao').Value := observacao;
        ExecSQL;
      end;  }

      if regradenogocio.gerenciadorENTRADAeSAIDA(idproduto, idcliente, idloja, idusuario, idtipomovimentacao, (entrada + saida + balanco),observacao,valor) then
      begin
        //FConn.Commit;
        erro := '';
        result := true;
      end
      else
      begin
        //FConn.Rollback;
        erro := 'Erro ao salvar lançamento: Problema ao atualizar estoque';
        Result := false;
      end;

    except
      on ex: exception do
      begin
       // FConn.Rollback;
        erro := 'Erro ao cadastrar Categoria: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
    regradenogocio.free;
  end;

end;

function Tcontroleestoque.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select ');
      SQL.Add('gesproduto.idproduto as id, ');
      SQL.Add('gesproduto.descricao, ');
      SQL.Add('gesproduto.codigosku, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesproduto.preco, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as preco, ');
      SQL.Add('gesproduto.custocomposto, ');
      SQL.Add('gesproduto.estoque, ');
      SQL.Add('gesproduto.reservadosaida, ');
      SQL.Add('gesproduto.reservadoentrada, ');
      SQL.Add('gesproduto.estoque - gesproduto.reservadosaida As estoquedisponivel, ');
      SQL.Add('gesproduto.unidade, ');
      SQL.Add('gesproduto.localizacao ');
      SQL.Add('From ');
      SQL.Add('gesproduto ');
      SQL.Add('WHERE gesproduto.idproduto is not null ');
     //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND(gesproduto.descricao like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or gesproduto.codigosku like ''%' + AQuery.Items['busca'] + '%'' )');
        end;
      end;
         a := AQuery.Items['busca'];
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesproduto.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
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

function Tcontroleestoque.Listadetalhe(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gescontroleestoque.idcontroleestoque as id, ');
      SQL.Add('DATE_FORMAT(gescontroleestoque.dataehora,''%d/%m/%Y'' '' - ''  ''%H %i'' ) as dataehora, ');
      SQL.Add('gescontroleestoque.entrada, ');
      SQL.Add('gescontroleestoque.saida, ');
      SQL.Add('gescontroleestoque.balanco, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gescontroleestoque.valor, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valor, ');
      SQL.Add('gescontroleestoque.observacao, ');
      SQL.Add('gertipomovimentacao.descricao as tipomovimento ');
      SQL.Add('From ');
      SQL.Add('gescontroleestoque Inner Join ');
      SQL.Add('gertipomovimentacao On gertipomovimentacao.idtipomovimentacao = gescontroleestoque.idtipomovimentacao ');
      SQL.Add('where gescontroleestoque.idproduto=:idproduto ');
      ParamByName('idproduto').AsInteger := AQuery.Items['idprodutobusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gescontroleestoque.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gescontroleestoque.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gescontroleestoque.idloja = :idloja');
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

function Tcontroleestoque.Listadetalhestatus(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Count(gescontroleestoque.idcontroleestoque) As lancamentos, ');
      SQL.Add('Sum(gescontroleestoque.entrada) As entradas, ');
      SQL.Add('Sum(gescontroleestoque.saida) As saidas, ');
      SQL.Add('gesproduto.estoque As saldofisico, ');
      SQL.Add('gesproduto.reservadosaida As reservados, ');
      SQL.Add('gesproduto.estoque - gesproduto.reservadosaida As estoquedisponivel ');
      SQL.Add('From ');
      SQL.Add('gescontroleestoque Inner Join ');
      SQL.Add('gesproduto On gesproduto.idproduto = gescontroleestoque.idproduto ');
      SQL.Add('And gesproduto.idcliente = gescontroleestoque.idcliente ');
      SQL.Add('And gesproduto.idloja = gescontroleestoque.idloja ');
      SQL.Add('And gesproduto.deletado = gescontroleestoque.deletado ');
      SQL.Add(' where gescontroleestoque.idproduto=:idproduto ');
      ParamByName('idproduto').AsInteger := AQuery.Items['idprodutobusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gescontroleestoque.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gescontroleestoque.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gescontroleestoque.idloja = :idloja');
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

function Tcontroleestoque.Listalancamentotipo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gertipomovimentacao.idtipomovimentacao, ');
      SQL.Add('gertipomovimentacao.descricao as tipomovimentacao ');
      SQL.Add('From ');
      SQL.Add('gertipomovimentacao order by idtipomovimentacao ');
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

function Tcontroleestoque.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idcontroleestoque = idcontroleestoque+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idcontroleestoque from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idcontroleestoque := fieldbyname('idcontroleestoque').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idcontroleestoque;
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

function Tcontroleestoque.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesmarca WHERE gesmarca.idmarca is not null and gesmarca.idmarca =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idmarcabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesmarca.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesmarca.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesmarca.idloja = :idloja');
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

function Tcontroleestoque.RelatorioCustoSolicitacao(
  const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  idClienteValue, idLojaValue: string;
  idCliente, idLoja: Integer;
begin
  Result := nil;
  erro := '';
  qry := nil;

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    AQuery.TryGetValue('idcliente', idClienteValue);
    AQuery.TryGetValue('idloja',    idLojaValue);
    idCliente := StrToIntDef(Trim(idClienteValue), 0);
    idLoja    := StrToIntDef(Trim(idLojaValue), 0);

    qry.SQL.BeginUpdate;
    try
      qry.SQL.Clear;
      qry.SQL.Add('SELECT');
      qry.SQL.Add('  COALESCE(NULLIF(TRIM(s.obra), ''''), '''')            AS obra,');
      qry.SQL.Add('  COALESCE(NULLIF(TRIM(s.projeto), ''''), ''AVULSO'')   AS projeto,');
      qry.SQL.Add('  SUM(COALESCE(e.entrada, 0))                           AS entrada,');
      qry.SQL.Add('  SUM(COALESCE(e.saida,   0))                           AS saida,');
      qry.SQL.Add('  SUM(CASE');
      qry.SQL.Add('        WHEN COALESCE(e.entrada,0) > 0 THEN COALESCE(e.entrada,0) * COALESCE(e.valor,0)');
      qry.SQL.Add('        WHEN COALESCE(e.saida,0)   > 0 THEN -COALESCE(e.saida,0)   * COALESCE(e.valor,0)');
      qry.SQL.Add('        ELSE 0');
      qry.SQL.Add('      END)                                              AS valortotal');
      qry.SQL.Add('FROM gescontroleestoque e');

      // 1) liga movimento -> item de solicitação (pela coluna comum idproduto)
      qry.SQL.Add('LEFT JOIN gessolicitacaoitens si');
      qry.SQL.Add('  ON si.idproduto = e.idproduto');
      qry.SQL.Add(' AND si.deletado = 0');

      // 2) liga item -> solicitação (onde estão obra/projeto)
      qry.SQL.Add('LEFT JOIN gessolicitacao s');
      qry.SQL.Add('  ON s.idgeral = si.idgeral');
      qry.SQL.Add(' AND s.deletado = 0');

      qry.SQL.Add('WHERE e.deletado = 0');

      // Multi-tenant: aplica filtros se vierem
      if idCliente > 0 then
      begin
        qry.SQL.Add('  AND e.idcliente = :idcliente');
        // se s existir, filtra também; se não existir (linha avulsa), não exclui
        qry.SQL.Add('  AND (s.idcliente = :idcliente OR s.idcliente IS NULL)');
      end;

      if idLoja > 0 then
      begin
        qry.SQL.Add('  AND e.idloja = :idloja');
        qry.SQL.Add('  AND (s.idloja = :idloja OR s.idloja IS NULL)');
      end;

      qry.SQL.Add('GROUP BY');
      qry.SQL.Add('  COALESCE(NULLIF(TRIM(s.obra), ''''), ''''),');
      qry.SQL.Add('  COALESCE(NULLIF(TRIM(s.projeto), ''''), ''AVULSO'')');

    finally
      qry.SQL.EndUpdate;
    end;

    if idCliente > 0 then
      qry.ParamByName('idcliente').AsInteger := idCliente;
    if idLoja > 0 then
      qry.ParamByName('idloja').AsInteger := idLoja;

    qry.Open;
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




end.


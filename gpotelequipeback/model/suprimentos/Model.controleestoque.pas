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

function Tcontroleestoque.RelatorioCustoSolicitacao(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('SELECT ');
      SQL.Add('  gessolicitacao.obra,');
      SQL.Add('  gessolicitacao.projeto,');
      SQL.Add('  SUM(gescontroleestoque.entrada) AS entrada,');
      SQL.Add('  SUM(gescontroleestoque.saida) AS saida,');
      SQL.Add('CONCAT(''R$ '', REPLACE(FORMAT(SUM(gescontroleestoque.valor), 2), ''.'', '','')) AS valor_total,');
      SQL.Add('  SUM(gescontroleestoque.valor) AS valor_total');
      SQL.Add('FROM ');
      SQL.Add('  gpo2desenvolvimento.gescontroleestoque');
      SQL.Add('JOIN ');
      SQL.Add('  gpo2desenvolvimento.gessolicitacaoitens');
      SQL.Add('  ON gessolicitacaoitens.idproduto = gescontroleestoque.idproduto');
      SQL.Add('JOIN ');
      SQL.Add('  gpo2desenvolvimento.gessolicitacao');
      SQL.Add('  ON gessolicitacao.idsolicitacao = gessolicitacaoitens.idsolicitacao');
      SQL.Add('WHERE ');
      SQL.Add('  gescontroleestoque.deletado = 0');
      SQL.Add('  AND gessolicitacaoitens.deletado = 0');
      SQL.Add('  AND gessolicitacao.deletado = 0');

      // filtros adicionais opcionais
      if AQuery.ContainsKey('obra') then
      begin
        if Length(AQuery.Items['obra']) > 0 then
        begin
          SQL.Add('  AND gessolicitacao.obra LIKE :obra');
          ParamByName('obra').Value := '%' + AQuery.Items['obra'] + '%';
        end;
      end;

      SQL.Add('GROUP BY ');
      SQL.Add('  gessolicitacao.obra, gessolicitacao.projeto');

      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar: ' + ex.Message;
      Result := nil;
    end;
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

end.


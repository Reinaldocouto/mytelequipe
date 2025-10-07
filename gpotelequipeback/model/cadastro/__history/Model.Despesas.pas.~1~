unit Model.Despesas;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TDespesas = class
  private
    FConn: TFDConnection;
    Fiddespesas: Integer;
    Fdatalancamento: string;
    Fvalordespesa: string;
    Fdescricao: string;
    Fcomprovante: string;
    Fobservacao: string;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
    Fidempresa: integer;
    Fidpessoa:Integer;
    Fidveiculo: integer;
    Ffuncionario: string;
    Fcategoria: string;
    Fperiodicidade: string;
    Fperiodo: string;
    Fparceladoem: string;
    Fvalordaparcela: string;
    Fdespesacadastradapor: string;
    FdataInicio: string;

  public
    constructor Create;
    destructor Destroy; override;

    property iddespesas: Integer read Fiddespesas write Fiddespesas;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property funcionario: string read Ffuncionario write Ffuncionario;
    property periodicidade: string read Fperiodicidade write Fperiodicidade;
    property categoria: string read Fcategoria write Fcategoria;
    property datalancamento: string read Fdatalancamento write Fdatalancamento;
    property valordespesa: string read Fvalordespesa write Fvalordespesa;
    property descricao: string read Fdescricao write Fdescricao;
    property periodo: string read Fperiodo write Fperiodo;
    property valordaparcela: string read Fvalordaparcela write Fvalordaparcela;
    property comprovante: string read Fcomprovante write Fcomprovante;
    property observacao: string read Fobservacao write Fobservacao;
    property idempresa: integer read Fidempresa write Fidempresa;
    property idpessoa: integer read Fidpessoa write Fidpessoa;
    property idveiculo: integer read Fidveiculo write Fidveiculo;
    property dataInicio: string read FdataInicio write FdataInicio;
    property parceladoEm: string read FparceladoEm write FparceladoEm;
    property despesacadastradapor: string read Fdespesacadastradapor write Fdespesacadastradapor;


    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;
  end;

implementation

{ TDespesas  }

constructor TDespesas.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TDespesas.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TDespesas.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set iddespesas = iddespesas+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select iddespesas from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        iddespesas := fieldbyname('iddespesas').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := iddespesas;
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

function TDespesas.Editar(out erro: string): Boolean;
var
  qry, qHist, qInsert: TFDQuery;
  id: Integer;
  IsInsert: Boolean;
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
        sql.add('select iddespesas from gesdespesas where idcliente=:idcliente and idloja=:idloja and iddespesas=:iddespesas ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ParamByName('iddespesas').Value := iddespesas;
        Open;
        IsInsert := (RecordCount = 0);
        Close;
        if IsInsert then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO gesdespesas(iddespesas, datalancamento, parceladoem, datainicio, valorparcela, despesacadastradapor, ');
          SQL.Add('valordespesa, descricao, comprovante, observacao, ');
          SQL.Add('idempresa, idpessoa, idveiculo, deletado, idcliente, idloja, ');
          SQL.Add('periodo, periodicidade, categoria, datadocadastro) ');
          SQL.Add('VALUES(:iddespesas, :datalancamento, :parceladoem, :datainicio, :valorparcela, :despesacadastradapor, ');
          SQL.Add(':valordespesa, :descricao, :comprovante, :observacao, ');
          SQL.Add(':idempresa, :idpessoa, :idveiculo, :deletado, :idcliente, :idloja, ');
          SQL.Add(':periodo, :periodicidade, :categoria, :datadocadastro)');
          Params.ParamByName('datadocadastro').AsDateTime := Now;

        end
        else
        begin
        Active := false;
        sql.Clear;
        SQL.Add('UPDATE gesdespesas SET ');
        SQL.Add('DELETADO = :DELETADO, ');
        SQL.Add('parceladoem = :parceladoem, ');
        SQL.Add('datainicio = :datainicio, ');
        SQL.Add('valorparcela = :valorparcela, ');
        SQL.Add('despesacadastradapor = :despesacadastradapor, ');
        SQL.Add('datalancamento = :datalancamento, ');
        SQL.Add('valordespesa = :valordespesa, ');
        SQL.Add('descricao = :descricao, ');
        SQL.Add('comprovante = :comprovante, ');
        SQL.Add('categoria = :categoria, ');
        SQL.Add('periodicidade = :periodicidade, ');
        SQL.Add('periodo = :periodo, ');
        SQL.Add('observacao = :observacao, ');
        SQL.Add('idempresa = :idempresa, ');
        SQL.Add('idpessoa = :idpessoa, ');
        SQL.Add('idveiculo = :idveiculo ');
        SQL.Add('WHERE idcliente = :idcliente AND idloja = :idloja AND iddespesas = :iddespesas');


        end;
        ParamByName('parceladoem').Value := parceladoem;
        ParamByName('datainicio').Value := datainicio;
        ParamByName('valorparcela').Value := valordaparcela;
        ParamByName('despesacadastradapor').Value := despesacadastradapor;
        ParamByName('iddespesas').AsInteger := iddespesas;
        ParamByName('datalancamento').Value := datalancamento;
        ParamByName('valordespesa').Value := valordespesa;
        ParamByName('descricao').Value := descricao;
        ParamByName('comprovante').Value := comprovante;
        ParamByName('observacao').Value := observacao;
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('periodicidade').Value := periodicidade;
        ParamByName('categoria').Value := categoria;
        ParamByName('DELETADO').Value := 0;
        ParamByName('idempresa').AsInteger := idempresa;
        ParamByName('idpessoa').AsInteger := idpessoa;
        ParamByName('idveiculo').AsInteger := idveiculo;
        ParamByName('periodo').Value := periodo;
        ExecSQL;
      end;
      // Se for um insert (novo registro), então insere no histórico
      if IsInsert then
      begin
        // Primeiro, busca dados do veículo e empresa
        qHist := TFDQuery.Create(nil);
        try
          qHist.Connection := FConn;
          qHist.SQL.Text :=
            'SELECT v.placa, v.iniciolocacao, v.fimlocacao, v.categoria, v.periodicidade, e.nome as empresa ' +
            'FROM gesveiculos v ' +
            'LEFT JOIN gesempresas e ON e.idempresa = v.idempresa ' +
            'WHERE v.idveiculo = :idveiculo';
          qHist.ParamByName('idveiculo').AsInteger := idveiculo;
          qHist.Open;
          if not qHist.IsEmpty then
          begin
            qInsert := TFDQuery.Create(nil);
            try
              qInsert.Connection := FConn;
              qInsert.SQL.Text := 'INSERT INTO historicoveiculo (' +
                'iniciolocacaohistorico, fimlocacaohistorico, valordespesa, descricao,placa, empresa, funcionario, categoria, periodicidade) ' +
                'VALUES (:iniciolocacaohistorico, :fimlocacaohistorico, :valordespesa, :descricao, :placa, :empresa, :funcionario, :categoria, :periodicidade)';
              qInsert.ParamByName('iniciolocacaohistorico').DataType := ftDate;
              qInsert.ParamByName('iniciolocacaohistorico').Value := qHist.FieldByName('iniciolocacao').Value;
              qInsert.ParamByName('fimlocacaohistorico').DataType := ftDate;

              qInsert.ParamByName('fimlocacaohistorico').Value := qHist.FieldByName('fimlocacao').Value;
              qInsert.ParamByName('valordespesa').Value := valordespesa;
              qInsert.ParamByName('descricao').DataType := ftString;
              if Trim(descricao) <> '' then
              begin
                qInsert.ParamByName('descricao').Value := descricao;
              end;

              qInsert.ParamByName('placa').Value := qHist.FieldByName('placa').AsString;
              qInsert.ParamByName('empresa').Value := qHist.FieldByName('empresa').AsString;
              // Caso não tenhamos info de funcionario, deixa nulo ou string vazia
              qInsert.ParamByName('funcionario').DataType := ftString;

              if qHist.FieldDefs.IndexOf('funcionario') <> -1 then
              begin
                if not qHist.FieldByName('funcionario').IsNull then
                begin
                  qInsert.ParamByName('funcionario').Value := qHist.FieldByName('funcionario').AsString
                end
                else
                  qInsert.ParamByName('funcionario').Clear;
              end
              else
                qInsert.ParamByName('funcionario').Clear; // ou .Value := ''; depende da sua lógica

              // categoria no histórico = classificacao em gesveiculos
              qInsert.ParamByName('categoria').Value := qHist.FieldByName('categoria').AsString;
              qInsert.ParamByName('periodicidade').Value := qHist.FieldByName('periodicidade').AsString;
              qInsert.ExecSQL;
            finally
              qInsert.Free;
            end;
          end;
        finally
          qHist.Free;
        end;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar despesas: ' + ex.Message;
        FConn.Rollback;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
 end;

function TDespesas.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesdespesas.iddespesas as id, ');
      SQL.Add('DATE_FORMAT(gesdespesas.datalancamento,''%d/%m/%Y'') as datalancamento, ');
      SQL.Add('DATE_FORMAT(gesdespesas.datadocadastro,''%d/%m/%Y'') as datadocadastro, ');
      SQL.Add('DATE_FORMAT(gesdespesas.datainicio,''%d/%m/%Y'') as datainicio, ');
      SQL.Add('gesdespesas.valordespesa, ');
      SQL.Add('gesdespesas.valorparcela, ');
      SQL.Add('gesdespesas.descricao, ');
      SQL.Add('gesdespesas.comprovante, ');
      SQL.Add('gesdespesas.observacao, ');
      SQL.Add('gesdespesas.idcliente, ');
      SQL.Add('gesdespesas.idloja, ');
      SQL.Add('gesdespesas.despesacadastradapor, ');
      SQL.Add('gesdespesas.parceladoem, ');
      SQL.Add('gesdespesas.categoria, ');
      SQL.Add('gesdespesas.periodicidade, ');
      SQL.Add('gesempresas.nome as empresa, ');
      SQL.Add('gespessoa.nome as funcionario, ');
      SQL.Add('gesveiculos.modelo as veiculo, '); //ver aqui depois
      SQL.Add('gesveiculos.placa');
      SQL.Add('FROM gesdespesas ');
      SQL.Add('LEFT JOIN gesveiculos ON gesveiculos.idveiculo = gesdespesas.idveiculo ');
      SQL.Add('LEFT JOIN gespessoa ON gesdespesas.idpessoa = gespessoa.idpessoa ');
      SQL.Add('LEFT JOIN gesempresas ON gesempresas.idempresa = gesdespesas.idempresa WHERE gesdespesas.iddespesas is not null ');


      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND (gesdespesas.datalancamento LIKE ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('OR gesdespesas.valordespesa LIKE ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('OR gesdespesas.comprovante LIKE ''%' + AQuery.Items['busca'] + '%'' )');
        end;
      end;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesdespesas.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesdespesas.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesdespesas.idcliente = :idcliente');
          ParamByName('idcliente').Value := 0;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesdespesas.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesdespesas.idloja = :idloja');
          ParamByName('idloja').Value := 0;
        end;
      end;
      if AQuery.ContainsKey('idveiculo') then
      begin
        if Length(AQuery.Items['idveiculo']) > 0 then
        begin
          SQL.Add('AND gesdespesas.idveiculo = :idveiculo');
          ParamByName('idveiculo').Value := AQuery.Items['idveiculo'].ToInteger;
        end;
      end;
      SQL.Add('order by id ');
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

function TDespesas.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('gesdespesas.*, ');
      SQL.Add('gesempresas.nome as empresa, ');
      SQL.Add('gespessoa.nome as funcionario, ');
      SQL.Add('gesveiculos.modelo as veiculo ');
      SQL.Add('From ');
      SQL.Add('gesdespesas left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = gesdespesas.idempresa left Join ');
      SQL.Add('gesveiculos On gesveiculos.idveiculo = gesdespesas.idveiculo left join gespessoa on gesdespesas.idpessoa = gespessoa.idpessoa');
      SQL.Add('WHERE gesdespesas.idveiculo is not null and gesdespesas.iddespesas=:id ');
      ParamByName('id').AsInteger := AQuery.Items['idpessoabusca'].ToInteger;
      a := AQuery.Items['idpessoabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesdespesas.deletado = :deletado');
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

end.


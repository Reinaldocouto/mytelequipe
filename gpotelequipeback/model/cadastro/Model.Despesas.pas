unit Model.Despesas;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.JSON,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.DApt,
  Model.Connection,
  System.StrUtils;

type
  TDespesaRateio = class
  private
    Fid: Integer;
    Fiddespesas: Integer;   // <- guarda o valor do idgeral da despesa (chave FK)
    Ftipo: string;          // 'DEPARTAMENTO' | 'SITE'
    Fdepartamento: string;
    Fidsite: string;
    Fpercentual: Double;
  public
    property id: Integer read Fid write Fid;
    property iddespesas: Integer read Fiddespesas write Fiddespesas; // = idgeral
    property tipo: string read Ftipo write Ftipo;
    property departamento: string read Fdepartamento write Fdepartamento;
    property idsite: string read Fidsite write Fidsite;
    property percentual: Double read Fpercentual write Fpercentual;
  end;

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
    Fidempresa: Integer;
    Fidpessoa: Integer;
    Fidveiculo: Integer;
    Ffuncionario: string;
    Fcategoria: string;
    Fperiodicidade: string;
    Fperiodo: string;
    Fparceladoem: string;
    Fvalordaparcela: string;
    Fdespesacadastradapor: string;
    FdataInicio: string;

    FRateios: TObjectList<TDespesaRateio>;

    function BuscarIdGeralAtual: Integer; // obtém idgeral da linha (pelo trio idcliente/idloja/iddespesas)
    procedure SalvarRateiosOrThrow(const AIdGeral: Integer); // grava rateio usando AIdGeral
    procedure CarregarRateiosIntoList(const AIdGeral: Integer); // lê rateio por AIdGeral

  public
    constructor Create;
    destructor Destroy; override;

    // Propriedades da despesa
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
    property idempresa: Integer read Fidempresa write Fidempresa;
    property idpessoa: Integer read Fidpessoa write Fidpessoa;
    property idveiculo: Integer read Fidveiculo write Fidveiculo;
    property dataInicio: string read FdataInicio write FdataInicio;
    property parceladoEm: string read FparceladoEm write FparceladoEm;
    property despesacadastradapor: string read Fdespesacadastradapor write Fdespesacadastradapor;

    // Rateio
    property Rateios: TObjectList<TDespesaRateio> read FRateios;
    procedure ClearRateios;
    procedure AddRateio_Departamento(const ANomeDepto: string; APercentual: Double);
    procedure AddRateio_Site(const AIdSite: string; APercentual: Double);
    procedure LoadRateiosFromJSONArray(const AJSONArray: TJSONArray);
    function CarregarRateios: Boolean; // resolve idgeral e preenche FRateios

    // API
    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): Integer;
  end;

implementation

constructor TDespesas.Create;
begin
  FConn := TConnection.CreateConnection;
  FRateios := TObjectList<TDespesaRateio>.Create(True);
  Fdeletado := 0;
end;

destructor TDespesas.Destroy;
begin
  FRateios.Free;
  FConn.Free;
  inherited;
end;

procedure TDespesas.ClearRateios;
begin
  FRateios.Clear;
end;

procedure TDespesas.AddRateio_Departamento(const ANomeDepto: string; APercentual: Double);
var
  R: TDespesaRateio;
begin
  R := TDespesaRateio.Create;
  R.id := 0;
  R.iddespesas := 0; // será setado com idgeral ao salvar
  R.tipo := 'DEPARTAMENTO';
  R.departamento := ANomeDepto;
  R.idsite := '';
  R.percentual := APercentual;
  FRateios.Add(R);
end;

procedure TDespesas.AddRateio_Site(const AIdSite: string; APercentual: Double);
var
  R: TDespesaRateio;
begin
  R := TDespesaRateio.Create;
  R.id := 0;
  R.iddespesas := 0; // será setado com idgeral ao salvar
  R.tipo := 'SITE';
  R.departamento := '';
  R.idsite := AIdSite;
  R.percentual := APercentual;
  FRateios.Add(R);
end;

procedure TDespesas.LoadRateiosFromJSONArray(const AJSONArray: TJSONArray);
var
  I: Integer;
  Obj: TJSONObject;
  Tipo, Depto, Site: string;
  Perc: Double;
  V: TJSONValue;
begin
  if not Assigned(AJSONArray) then Exit;
  ClearRateios;

  for I := 0 to AJSONArray.Count - 1 do
  begin
    if not (AJSONArray.Items[I] is TJSONObject) then
      Continue;

    Obj := TJSONObject(AJSONArray.Items[I]);

    Tipo  := Obj.GetValue<string>('tipo', '');
    Depto := Obj.GetValue<string>('departamento', '');
    if Depto = '' then
      Depto := Obj.GetValue<string>('iddepartamento', '');

    Site := Obj.GetValue<string>('idsite', '');

    V := Obj.GetValue('percentual');
    if Assigned(V) then
    begin
      if V is TJSONNumber then
        Perc := TJSONNumber(V).AsDouble
      else
        Perc := StrToFloatDef(V.Value.Replace(',', '.'), 0);
    end
    else
      Perc := 0;

    if SameText(Tipo, 'DEPARTAMENTO') and (Depto <> '') and (Perc > 0) then
      AddRateio_Departamento(Depto, Perc)
    else if SameText(Tipo, 'SITE') and (Site <> '') and (Perc > 0) then
      AddRateio_Site(Site, Perc);
  end;
end;

function TDespesas.BuscarIdGeralAtual: Integer;
var
  Q: TFDQuery;
begin
  Result := 0;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT idgeral FROM gesdespesas '+
      'WHERE idcliente = :idcliente AND idloja = :idloja AND iddespesas = :iddespesas';
    Q.ParamByName('idcliente').DataType := ftInteger;
    Q.ParamByName('idloja').DataType := ftInteger;
    Q.ParamByName('iddespesas').DataType := ftInteger;
    Q.ParamByName('idcliente').AsInteger := idcliente;
    Q.ParamByName('idloja').AsInteger := idloja;
    Q.ParamByName('iddespesas').AsInteger := iddespesas;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('idgeral').AsInteger;
  finally
    Q.Free;
  end;
end;

procedure TDespesas.SalvarRateiosOrThrow(const AIdGeral: Integer);
var
  qry: TFDQuery;
  r: TDespesaRateio;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;

    // Apaga (por idgeral)
    qry.SQL.Text := 'DELETE FROM gesdespesas_rateio WHERE iddespesas = :id';
    qry.ParamByName('id').DataType := ftInteger;
    qry.ParamByName('id').AsInteger := AIdGeral;
    qry.ExecSQL;

    // Reinsere usando idgeral
    for r in FRateios do
    begin
      qry.SQL.Text :=
        'INSERT INTO gesdespesas_rateio '+
        '(iddespesas, tipo, departamento, idsite, percentual) '+
        'VALUES (:iddespesas, :tipo, :departamento, :idsite, :percentual)';

      qry.ParamByName('iddespesas').DataType := ftInteger;  // <- idgeral
      qry.ParamByName('tipo').DataType := ftString;
      qry.ParamByName('departamento').DataType := ftString;
      qry.ParamByName('idsite').DataType := ftString;
      qry.ParamByName('percentual').DataType := ftFloat;

      qry.ParamByName('iddespesas').AsInteger := AIdGeral;
      qry.ParamByName('tipo').AsString := r.tipo;

      if SameText(r.tipo, 'DEPARTAMENTO') then
      begin
        qry.ParamByName('departamento').AsString := r.departamento;
        qry.ParamByName('idsite').Clear;
      end
      else
      begin
        qry.ParamByName('departamento').Clear;
        qry.ParamByName('idsite').AsString := r.idsite;
      end;

      qry.ParamByName('percentual').AsFloat := r.percentual;
      qry.ExecSQL;
    end;
  finally
    qry.Free;
  end;
end;

procedure TDespesas.CarregarRateiosIntoList(const AIdGeral: Integer);
var
  qry: TFDQuery;
  r: TDespesaRateio;
begin
  FRateios.Clear;

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    qry.SQL.Text :=
      'SELECT id, iddespesas, tipo, departamento, idsite, percentual '+
      'FROM gesdespesas_rateio WHERE iddespesas = :id';
    qry.ParamByName('id').DataType := ftInteger;
    qry.ParamByName('id').AsInteger := AIdGeral;
    qry.Open;

    while not qry.Eof do
    begin
      r := TDespesaRateio.Create;
      r.id          := qry.FieldByName('id').AsInteger;
      r.iddespesas  := qry.FieldByName('iddespesas').AsInteger; // = idgeral
      r.tipo        := qry.FieldByName('tipo').AsString;
      r.departamento:= qry.FieldByName('departamento').AsString;
      r.idsite      := qry.FieldByName('idsite').AsString;
      r.percentual  := qry.FieldByName('percentual').AsFloat;
      FRateios.Add(r);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TDespesas.CarregarRateios: Boolean;
var
  LIdGeral: Integer;
begin
  LIdGeral := BuscarIdGeralAtual;
  Result := LIdGeral > 0;
  if Result then
    CarregarRateiosIntoList(LIdGeral)
  else
    FRateios.Clear;
end;

function TDespesas.NovoCadastro(out erro: string): Integer;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    try
      FConn.StartTransaction;

      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('UPDATE admponteiro SET iddespesas = iddespesas + 1 ');
        SQL.Add('WHERE idcliente = :idcliente AND idloja = :idloja');
        ParamByName('idcliente').DataType := ftInteger;
        ParamByName('idloja').DataType := ftInteger;
        ParamByName('idcliente').AsInteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('SELECT iddespesas FROM admponteiro ');
        SQL.Add('WHERE idcliente = :idcliente AND idloja = :idloja');
        ParamByName('idcliente').AsInteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;

        iddespesas := FieldByName('iddespesas').AsInteger;
      end;

      FConn.Commit;
      erro := '';
      Result := iddespesas;
    except
      on ex: Exception do
      begin
        FConn.Rollback;
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
  IsInsert: Boolean;
  LIdGeral: Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    try
      FConn.StartTransaction;

      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('SELECT iddespesas FROM gesdespesas ');
        SQL.Add('WHERE idcliente = :idcliente AND idloja = :idloja AND iddespesas = :iddespesas');
        ParamByName('idcliente').DataType := ftInteger;
        ParamByName('idloja').DataType := ftInteger;
        ParamByName('iddespesas').DataType := ftInteger;
        ParamByName('idcliente').AsInteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ParamByName('iddespesas').Value := iddespesas;
        Open;

        IsInsert := (RecordCount = 0);
        Close;

        if IsInsert then
        begin
          Active := False;
          SQL.Clear;
          SQL.Add('INSERT INTO gesdespesas(');
          SQL.Add('  iddespesas, datalancamento, parceladoem, datainicio, valorparcela, despesacadastradapor,');
          SQL.Add('  valordespesa, descricao, comprovante, observacao,');
          SQL.Add('  idempresa, idpessoa, idveiculo, deletado, idcliente, idloja,');
          SQL.Add('  periodo, periodicidade, categoria, datadocadastro)');
          SQL.Add('VALUES(');
          SQL.Add('  :iddespesas, :datalancamento, :parceladoem, :datainicio, :valorparcela, :despesacadastradapor,');
          SQL.Add('  :valordespesa, :descricao, :comprovante, :observacao,');
          SQL.Add('  :idempresa, :idpessoa, :idveiculo, :deletado, :idcliente, :idloja,');
          SQL.Add('  :periodo, :periodicidade, :categoria, :datadocadastro)');
          Params.ParamByName('datadocadastro').AsDateTime := Now;
        end
        else
        begin
          Active := False;
          SQL.Clear;
          SQL.Add('UPDATE gesdespesas SET');
          SQL.Add('  DELETADO = :DELETADO,');
          SQL.Add('  parceladoem = :parceladoem,');
          SQL.Add('  datainicio = :datainicio,');
          SQL.Add('  valorparcela = :valorparcela,');
          SQL.Add('  despesacadastradapor = :despesacadastradapor,');
          SQL.Add('  datalancamento = :datalancamento,');
          SQL.Add('  valordespesa = :valordespesa,');
          SQL.Add('  descricao = :descricao,');
          SQL.Add('  comprovante = :comprovante,');
          SQL.Add('  categoria = :categoria,');
          SQL.Add('  periodicidade = :periodicidade,');
          SQL.Add('  periodo = :periodo,');
          SQL.Add('  observacao = :observacao,');
          SQL.Add('  idempresa = :idempresa,');
          SQL.Add('  idpessoa = :idpessoa,');
          SQL.Add('  idveiculo = :idveiculo');
          SQL.Add('WHERE idcliente = :idcliente AND idloja = :idloja AND iddespesas = :iddespesas');
        end;

        // Tipagem
        ParamByName('parceladoem').DataType := ftString;
        ParamByName('datainicio').DataType := ftString;
        ParamByName('valorparcela').DataType := ftString;
        ParamByName('despesacadastradapor').DataType := ftString;
        ParamByName('iddespesas').DataType := ftInteger;
        ParamByName('datalancamento').DataType := ftString;
        ParamByName('valordespesa').DataType := ftString;
        ParamByName('descricao').DataType := ftString;
        ParamByName('comprovante').DataType := ftString;
        ParamByName('observacao').DataType := ftString;
        ParamByName('IDCLIENTE').DataType := ftInteger;
        ParamByName('IDLOJA').DataType := ftInteger;
        ParamByName('periodicidade').DataType := ftString;
        ParamByName('categoria').DataType := ftString;
        ParamByName('DELETADO').DataType := ftInteger;
        ParamByName('idempresa').DataType := ftInteger;
        ParamByName('idpessoa').DataType := ftInteger;
        ParamByName('idveiculo').DataType := ftInteger;
        ParamByName('periodo').DataType := ftString;

        // Valores
        ParamByName('parceladoem').AsString := parceladoem;
        ParamByName('datainicio').AsString := datainicio;
        ParamByName('valorparcela').AsString := valordaparcela;
        ParamByName('despesacadastradapor').AsString := despesacadastradapor;
        ParamByName('iddespesas').AsInteger := iddespesas;
        ParamByName('datalancamento').AsString := datalancamento;
        ParamByName('valordespesa').AsString := valordespesa;
        ParamByName('descricao').AsString := descricao;
        ParamByName('comprovante').AsString := comprovante;
        ParamByName('observacao').AsString := observacao;
        ParamByName('IDCLIENTE').AsInteger := idcliente;
        ParamByName('IDLOJA').AsInteger := idloja;
        ParamByName('periodicidade').AsString := periodicidade;
        ParamByName('categoria').AsString := categoria;
        ParamByName('DELETADO').AsInteger := 0;
        ParamByName('idempresa').AsInteger := idempresa;
        ParamByName('idpessoa').AsInteger := idpessoa;
        ParamByName('idveiculo').AsInteger := idveiculo;
        ParamByName('periodo').AsString := periodo;

        ExecSQL;
      end;

      // Salvar rateios usando idgeral
      LIdGeral := BuscarIdGeralAtual;
      if LIdGeral <= 0 then
        raise Exception.Create('Não foi possível localizar idgeral da despesa para salvar o rateio.');
      SalvarRateiosOrThrow(LIdGeral);

      // Histórico (somente no insert)
      if IsInsert then
      begin
        qHist := TFDQuery.Create(nil);
        try
          qHist.Connection := FConn;
          qHist.SQL.Text :=
            'SELECT v.placa, v.iniciolocacao, v.fimlocacao, v.categoria, v.periodicidade, e.nome AS empresa '+
            'FROM gesveiculos v '+
            'LEFT JOIN gesempresas e ON e.idempresa = v.idempresa '+
            'WHERE v.idveiculo = :idveiculo';
          qHist.ParamByName('idveiculo').DataType := ftInteger;
          qHist.ParamByName('idveiculo').AsInteger := idveiculo;
          qHist.Open;

          if not qHist.IsEmpty then
          begin
            qInsert := TFDQuery.Create(nil);
            try
              qInsert.Connection := FConn;
              qInsert.SQL.Text :=
                'INSERT INTO historicoveiculo ('+
                'iniciolocacaohistorico, fimlocacaohistorico, valordespesa, descricao, placa, empresa, funcionario, categoria, periodicidade) '+
                'VALUES (:iniciolocacaohistorico, :fimlocacaohistorico, :valordespesa, :descricao, :placa, :empresa, :funcionario, :categoria, :periodicidade)';

              qInsert.ParamByName('iniciolocacaohistorico').DataType := ftDate;
              qInsert.ParamByName('iniciolocacaohistorico').Value := qHist.FieldByName('iniciolocacao').Value;

              qInsert.ParamByName('fimlocacaohistorico').DataType := ftDate;
              qInsert.ParamByName('fimlocacaohistorico').Value := qHist.FieldByName('fimlocacao').Value;

              qInsert.ParamByName('valordespesa').DataType := ftString;
              qInsert.ParamByName('valordespesa').AsString := valordespesa;

              qInsert.ParamByName('descricao').DataType := ftString;
              if Trim(descricao) <> '' then
                qInsert.ParamByName('descricao').AsString := descricao
              else
                qInsert.ParamByName('descricao').Clear;

              qInsert.ParamByName('placa').DataType := ftString;
              qInsert.ParamByName('placa').AsString := qHist.FieldByName('placa').AsString;

              qInsert.ParamByName('empresa').DataType := ftString;
              qInsert.ParamByName('empresa').AsString := qHist.FieldByName('empresa').AsString;

              qInsert.ParamByName('funcionario').DataType := ftString;
              qInsert.ParamByName('funcionario').Clear;

              qInsert.ParamByName('categoria').DataType := ftString;
              qInsert.ParamByName('categoria').AsString := qHist.FieldByName('categoria').AsString;

              qInsert.ParamByName('periodicidade').DataType := ftString;
              qInsert.ParamByName('periodicidade').AsString := qHist.FieldByName('periodicidade').AsString;

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
      Result := True;
    except
      on ex: Exception do
      begin
        erro := 'Erro ao cadastrar despesas: ' + ex.Message;
        FConn.Rollback;
        Result := False;
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
    qry.Connection := FConn;

    with qry do
    begin
      Active := False;
      SQL.Clear;

      SQL.Add('SELECT');
      SQL.Add('  gesdespesas.iddespesas AS id,');
      SQL.Add('  DATE_FORMAT(gesdespesas.datalancamento, ''%d/%m/%Y'') AS datalancamento,');
      SQL.Add('  DATE_FORMAT(gesdespesas.datadocadastro, ''%d/%m/%Y'') AS datadocadastro,');
      SQL.Add('  DATE_FORMAT(gesdespesas.datainicio, ''%d/%m/%Y'') AS datainicio,');
      SQL.Add('  gesdespesas.valordespesa,');
      SQL.Add('  gesdespesas.valorparcela,');
      SQL.Add('  gesdespesas.descricao,');
      SQL.Add('  gesdespesas.comprovante,');
      SQL.Add('  gesdespesas.observacao,');
      SQL.Add('  gesdespesas.idcliente,');
      SQL.Add('  gesdespesas.idloja,');
      SQL.Add('  gesdespesas.despesacadastradapor,');
      SQL.Add('  gesdespesas.parceladoem,');
      SQL.Add('  gesdespesas.categoria,');
      SQL.Add('  gesdespesas.periodicidade,');
      SQL.Add('  gesempresas.nome AS empresa,');
      SQL.Add('  gespessoa.nome AS funcionario,');
      SQL.Add('  gesveiculos.modelo AS veiculo,');
      SQL.Add('  gesveiculos.placa');
      SQL.Add('FROM gesdespesas');
      SQL.Add('LEFT JOIN gesveiculos ON gesveiculos.idveiculo = gesdespesas.idveiculo');
      SQL.Add('LEFT JOIN gespessoa ON gesdespesas.idpessoa = gespessoa.idpessoa');
      SQL.Add('LEFT JOIN gesempresas ON gesempresas.idempresa = gesdespesas.idempresa');
      SQL.Add('WHERE gesdespesas.iddespesas IS NOT NULL');

      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND (gesdespesas.datalancamento LIKE ''%' + AQuery.Items['busca'] + '%''');
          SQL.Add('OR gesdespesas.valordespesa LIKE ''%' + AQuery.Items['busca'] + '%''');
          SQL.Add('OR gesdespesas.comprovante LIKE ''%' + AQuery.Items['busca'] + '%'' )');
        end;
      end;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesdespesas.deletado = :deletado');
          ParamByName('deletado').DataType := ftInteger;
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;

      if AQuery.ContainsKey('idcliente') then
      begin
        SQL.Add('AND gesdespesas.idcliente = :idcliente');
        ParamByName('idcliente').DataType := ftInteger;
        if Length(AQuery.Items['idcliente']) > 0 then
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger
        else
          ParamByName('idcliente').Value := 0;
      end;

      if AQuery.ContainsKey('idloja') then
      begin
        SQL.Add('AND gesdespesas.idloja = :idloja');
        ParamByName('idloja').DataType := ftInteger;
        if Length(AQuery.Items['idloja']) > 0 then
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger
        else
          ParamByName('idloja').Value := 0;
      end;

      if AQuery.ContainsKey('idveiculo') then
      begin
        if Length(AQuery.Items['idveiculo']) > 0 then
        begin
          SQL.Add('AND gesdespesas.idveiculo = :idveiculo');
          ParamByName('idveiculo').DataType := ftInteger;
          ParamByName('idveiculo').Value := AQuery.Items['idveiculo'].ToInteger;
        end;
      end;

      SQL.Add('ORDER BY id');
      Active := True;
    end;

    erro := '';
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDespesas.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    with qry do
    begin
      Active := False;
      SQL.Clear;

      SQL.Add('SELECT');
      SQL.Add('  gesdespesas.*,');
      SQL.Add('  gesempresas.nome AS empresa,');
      SQL.Add('  gespessoa.nome AS funcionario,');
      SQL.Add('  gesveiculos.modelo AS veiculo');
      SQL.Add('FROM gesdespesas');
      SQL.Add('LEFT JOIN gesempresas ON gesempresas.idempresa = gesdespesas.idempresa');
      SQL.Add('LEFT JOIN gesveiculos ON gesveiculos.idveiculo = gesdespesas.idveiculo');
      SQL.Add('LEFT JOIN gespessoa ON gesdespesas.idpessoa = gespessoa.idpessoa');
      SQL.Add('WHERE gesdespesas.iddespesas = :id');

      ParamByName('id').DataType := ftInteger;
      ParamByName('id').AsInteger := AQuery.Items['idpessoabusca'].ToInteger;
      a := AQuery.Items['idpessoabusca'].ToInteger;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesdespesas.deletado = :deletado');
          ParamByName('deletado').DataType := ftInteger;
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;

      Active := True;
    end;

    erro := '';
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

end.


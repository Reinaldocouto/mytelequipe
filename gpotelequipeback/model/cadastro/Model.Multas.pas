unit Model.Multas;

interface

uses
  FireDAC.Comp.Client,
  Data.DB,
  System.SysUtils,
  System.DateUtils,
  model.connection,
  System.StrUtils,
  FireDAC.DApt,
  System.Generics.Collections,
  System.Variants,
  FireDAC.Stan.Param;

type
  TMultas = class
  private
    FConn: TFDConnection;
    Fidmultas: Integer;
    Fplaca: string;
    Fnumeroait: string;
    Fdatainfracao: string;
    Flocal: string;
    Finfracao: string;
    Fvalor: string;
    Fdataindicacao: string;
    Fnatureza: string;
    Fpontuacao: Integer;
    Fdatacolaborador: string;
    Fstatusmulta: string;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
    Fidempresa: Integer;
    Fidpessoa: Integer;
    FidsMultas: string;
    Fdepartamento: string; // usado só para rateio
    Fidsite: string;       // usado só para rateio
    Fnomeindicacao: string;

    function NextIdDespesas(out Erro: string): Integer;
    function ResolveIdVeiculoPorPlaca(const APlaca: string): Variant;
    function ParseValor(const S: string): Double;
    function TryStrToDateTimeInvariant(const S: string; out ADt: TDateTime): Boolean;

    // cria/atualiza a DESPESA da multa usando idgeral = idmultas
    function UpsertDespesaParaMulta(out Erro: string): Boolean;

    // ATENÇÃO: aqui AIdGeral = gesdespesas.idgeral (rateio.iddespesas referencia idgeral)
    procedure ReplaceRateioDespesa(const AIdGeral: Integer; const ATipo, ADepto, ASite: string; const APercentual: Double);
  public
    constructor Create;
    destructor Destroy; override;

    property idsMultas: string read FidsMultas write FidsMultas;
    property idmultas: Integer read Fidmultas write Fidmultas;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property placa: string read Fplaca write Fplaca;
    property numeroait: string read Fnumeroait write Fnumeroait;
    property datainfracao: string read Fdatainfracao write Fdatainfracao;
    property local: string read Flocal write Flocal;
    property infracao: string read Finfracao write Finfracao;
    property valor: string read Fvalor write Fvalor;
    property dataindicacao: string read Fdataindicacao write Fdataindicacao;
    property natureza: string read Fnatureza write Fnatureza;
    property pontuacao: Integer read Fpontuacao write Fpontuacao;
    property datacolaborador: string read Fdatacolaborador write Fdatacolaborador;
    property statusmulta: string read Fstatusmulta write Fstatusmulta;
    property idempresa: Integer read Fidempresa write Fidempresa;
    property idpessoa: Integer read Fidpessoa write Fidpessoa;
    property departamento: string read Fdepartamento write Fdepartamento;
    property idsite: string read Fidsite write Fidsite;
    property nomeindicacao: string read Fnomeindicacao write Fnomeindicacao;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): Integer;
    function TransformaDebitado(out erro: string): Boolean;
    function BuscaPorPlacaData(const APlaca, AData: string; out erro: string): TFDQuery;
  end;

implementation

function MyTryISO8601ToDate(const S: string; out ADateTime: TDateTime): Boolean;
var
  LDate, LTime: string; i: Integer;
  Y, M, D, HH, NN, SS: Word; Temp: string;
begin
  Result := False; ADateTime := 0;
  if S = '' then Exit;
  i := Pos('T', S);
  if i > 0 then
  begin
    LDate := Copy(S, 1, i-1);
    LTime := Copy(S, i+1, MaxInt);
  end
  else
  begin
    i := Pos(' ', S);
    if i > 0 then
    begin
      LDate := Copy(S, 1, i-1);
      LTime := Copy(S, i+1, MaxInt);
    end
    else
    begin
      LDate := S; LTime := '';
    end;
  end;
  if (Length(LDate) < 10) or (LDate[5] <> '-') or (LDate[8] <> '-') then Exit;
  Y := StrToIntDef(Copy(LDate,1,4),-1);
  M := StrToIntDef(Copy(LDate,6,2),-1);
  D := StrToIntDef(Copy(LDate,9,2),-1);
  if (Y<1) or (M<1) or (D<1) then Exit;
  HH := 0; NN := 0; SS := 0;
  if LTime <> '' then
  begin
    i := Pos(':', LTime);
    if i > 0 then
    begin
      HH := StrToIntDef(Copy(LTime,1,i-1),-1);
      Temp := Copy(LTime,i+1,MaxInt);
      i := Pos(':', Temp);
      if i > 0 then
      begin
        NN := StrToIntDef(Copy(Temp,1,i-1),-1);
        SS := StrToIntDef(Copy(Temp,i+1,MaxInt),-1);
      end
      else
        NN := StrToIntDef(Temp,-1);
      if (HH<0) or (NN<0) or (SS<0) then Exit;
    end
    else
    begin
      HH := StrToIntDef(LTime,-1);
      if HH<0 then Exit;
    end;
  end;
  try
    ADateTime := EncodeDateTime(Y,M,D,HH,NN,SS,0);
    Result := True;
  except
    Result := False;
  end;
end;

constructor TMultas.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TMultas.Destroy;
begin
  if Assigned(FConn) then FConn.Free;
  inherited;
end;

function TMultas.TryStrToDateTimeInvariant(const S: string; out ADt: TDateTime): Boolean;
var FS: TFormatSettings;
begin
  FS := TFormatSettings.Create;
  FS.DateSeparator := '-';
  FS.TimeSeparator := ':';
  FS.ShortDateFormat := 'yyyy-mm-dd';
  FS.LongTimeFormat := 'hh:nn:ss.zzz';
  Result := TryStrToDateTime(S, ADt, FS) or MyTryISO8601ToDate(S, ADt);
end;

function TMultas.ParseValor(const S: string): Double;
var FS: TFormatSettings; T: string;
begin
  FS := TFormatSettings.Create;
  FS.ThousandSeparator := '.';
  FS.DecimalSeparator := ',';
  if TryStrToFloat(S, Result, FS) then Exit;
  FS.ThousandSeparator := ',';
  FS.DecimalSeparator := '.';
  if TryStrToFloat(S, Result, FS) then Exit;
  T := StringReplace(S, '.', '', [rfReplaceAll]);
  T := StringReplace(T, ',', '.', [rfReplaceAll]);
  if not TryStrToFloat(T, Result, FS) then
    Result := 0.0;
end;

function TMultas.ResolveIdVeiculoPorPlaca(const APlaca: string): Variant;
var
  Q: TFDQuery;
  Pl: string;
begin
  Result := Null;
  Pl := Trim(APlaca);
  if Pl = '' then Exit;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT idveiculo FROM gesveiculos '+
      'WHERE placa = :placa AND idcliente = :idcliente AND idloja = :idloja AND COALESCE(deletado,0)=0 '+
      'ORDER BY idveiculo DESC LIMIT 1';
    Q.ParamByName('placa').AsString := Pl;
    Q.ParamByName('idcliente').AsInteger := idcliente;
    Q.ParamByName('idloja').AsInteger := idloja;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Result := Q.FieldByName('idveiculo').AsInteger;
      Exit;
    end;

    Q.Close;
    Q.SQL.Text :=
      'SELECT idveiculo FROM gesveiculos '+
      'WHERE placa = :placa AND COALESCE(deletado,0)=0 '+
      'ORDER BY idveiculo DESC LIMIT 1';
    Q.ParamByName('placa').AsString := Pl;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('idveiculo').AsInteger;
  finally
    Q.Free;
  end;
end;

function TMultas.NextIdDespesas(out Erro: string): Integer;
var
  Q: TFDQuery;
  Affected: Integer;
begin
  Result := 0;
  Erro := '';
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'UPDATE admponteiro ' +
      'SET iddespesas = COALESCE(iddespesas,0) + 1 ' +
      'WHERE idcliente = :idcliente AND idloja = :idloja';
    Q.ParamByName('idcliente').AsInteger := idcliente;
    Q.ParamByName('idloja').AsInteger := idloja;
    Q.ExecSQL;

    Affected := Q.RowsAffected;
    if Affected = 0 then
    begin
      Q.SQL.Text :=
        'INSERT INTO admponteiro (idcliente, idloja, iddespesas, idmultas) ' +
        'VALUES (:idcliente, :idloja, 1, COALESCE((SELECT MAX(idmultas) FROM gesmultas '+
        ' WHERE idcliente=:idcliente AND idloja=:idloja),0))';
      Q.ParamByName('idcliente').AsInteger := idcliente;
      Q.ParamByName('idloja').AsInteger := idloja;
      Q.ExecSQL;
    end;

    Q.SQL.Text :=
      'SELECT iddespesas FROM admponteiro '+
      'WHERE idcliente = :idcliente AND idloja = :idloja';
    Q.ParamByName('idcliente').AsInteger := idcliente;
    Q.ParamByName('idloja').AsInteger := idloja;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('iddespesas').AsInteger
    else
      Erro := 'admponteiro não retornou iddespesas após criar/atualizar.';
  except
    on E: Exception do
      Erro := 'NextIdDespesas falhou: ' + E.Message;
  end;
  Q.Free;
end;

// AIdGeral = gesdespesas.idgeral
procedure TMultas.ReplaceRateioDespesa(const AIdGeral: Integer; const ATipo, ADepto, ASite: string; const APercentual: Double);
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;

    // rateio.iddespesas referencia gesdespesas.idgeral
    Q.SQL.Text := 'DELETE FROM gesdespesas_rateio WHERE iddespesas = :id';
    Q.ParamByName('id').DataType := ftInteger;
    Q.ParamByName('id').AsInteger := AIdGeral;
    Q.ExecSQL;

    if (SameText(ATipo, 'DEPARTAMENTO') and (Trim(ADepto) <> '')) or
       (SameText(ATipo, 'SITE') and (Trim(ASite) <> '')) then
    begin
      Q.SQL.Text :=
        'INSERT INTO gesdespesas_rateio (iddespesas, tipo, departamento, idsite, percentual) '+
        'VALUES (:iddespesas, :tipo, :departamento, :idsite, :percentual)';
      Q.ParamByName('iddespesas').DataType := ftInteger;
      Q.ParamByName('tipo').DataType := ftString;
      Q.ParamByName('departamento').DataType := ftString;
      Q.ParamByName('idsite').DataType := ftString;
      Q.ParamByName('percentual').DataType := ftFloat;

      Q.ParamByName('iddespesas').AsInteger := AIdGeral;
      Q.ParamByName('tipo').AsString := ATipo;

      if SameText(ATipo, 'DEPARTAMENTO') then
      begin
        Q.ParamByName('departamento').AsString := ADepto;
        Q.ParamByName('idsite').Clear;
      end
      else
      begin
        Q.ParamByName('departamento').Clear;
        Q.ParamByName('idsite').AsString := ASite;
      end;

      Q.ParamByName('percentual').AsFloat := APercentual;
      Q.ExecSQL;
    end;
  finally
    Q.Free;
  end;
end;

function TMultas.UpsertDespesaParaMulta(out Erro: string): Boolean;
var
  Q: TFDQuery;
  DtBase, DtInicio: TDateTime;
  Vlr: Double;
  IdVeiculo: Variant;
  Descricao, Observacao: string;
  Existe: Boolean;
  Affected: Integer;
  TipoRateio, Depto, Site: string;
  LIdGeral, LIdDespesas: Integer;
  QLastId: TFDQuery;
begin
  Result := False; Erro := '';

  // Data base (preferir dataindicacao, senão datainfracao)
  if not TryStrToDateTimeInvariant(dataindicacao, DtBase) then
    if not TryStrToDateTimeInvariant(datainfracao, DtBase) then
    begin
      Erro := 'Nem dataindicacao nem datainfracao são válidas para gerar despesa.';
      Exit;
    end;

  DtInicio := Trunc(DtBase);
  Vlr := ParseValor(valor);
  IdVeiculo := ResolveIdVeiculoPorPlaca(placa);

  Descricao := 'Multa ' + Trim(numeroait) + ' - ' + Trim(placa);
  Observacao :=
    'Local: ' + Trim(local) + ' | Infração: ' + Trim(infracao) +
    ' | Natureza: ' + Trim(natureza) + ' | Indicado: ' + Trim(nomeindicacao);

  Q := TFDQuery.Create(nil);
  QLastId := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;
    QLastId.Connection := FConn;

    // 1) Existe despesa para esta multa? (agora por idmulta)
    Q.SQL.Text :=
      'SELECT idgeral, iddespesas FROM gesdespesas '+
      'WHERE idcliente=:idcliente AND idloja=:idloja '+
      '  AND idmulta=:idmulta AND categoria=''Multas'' '+
      'LIMIT 1';
    Q.ParamByName('idcliente').AsInteger := idcliente;
    Q.ParamByName('idloja').AsInteger := idloja;
    Q.ParamByName('idmulta').AsInteger := idmultas;
    Q.Open;

    Existe := not Q.IsEmpty;

    if Existe then
    begin
      // UPDATE por idmulta
      LIdGeral    := Q.FieldByName('idgeral').AsInteger;
      LIdDespesas := Q.FieldByName('iddespesas').AsInteger;

      Q.Close;
      Q.SQL.Text :=
        'UPDATE gesdespesas SET '+
        '  idmulta        = :idmulta, '+
        '  datalancamento = :datalancamento, '+
        '  valordespesa   = :valordespesa, '+
        '  descricao      = :descricao, '+
        '  idveiculo      = :idveiculo, '+
        '  observacao     = :observacao, '+
        '  deletado       = 0, '+
        '  idempresa      = :idempresa, '+
        '  idpessoa       = :idpessoa, '+
        '  periodo        = :periodo, '+
        '  periodicidade  = :periodicidade, '+
        '  despesacadastradapor = :usuario, '+
        '  comprovante    = :comprovante, '+
        '  parceladoem    = :parceladoem, '+
        '  datainicio     = :datainicio, '+
        '  valorparcela   = :valorparcela, '+
        '  datadocadastro = NOW() '+
        'WHERE idcliente=:idcliente AND idloja=:idloja AND idgeral=:idgeral';
      Q.ParamByName('idgeral').AsInteger := LIdGeral;
    end
    else
    begin
      // INSERT — NÃO seta idgeral (auto-increment); inclui idmulta
      LIdDespesas := NextIdDespesas(Erro); // se você quiser manter este contador próprio
      if (LIdDespesas = 0) or (Erro <> '') then Exit;

      Q.SQL.Text :=
        'INSERT INTO gesdespesas ('+
        '  iddespesas, idmulta, datalancamento, valordespesa, descricao, idveiculo, observacao, '+
        '  deletado, idloja, idcliente, comprovante, idempresa, idpessoa, '+
        '  periodicidade, categoria, periodo, despesacadastradapor, parceladoem, datainicio, valorparcela, datadocadastro '+
        ') VALUES ('+
        '  :iddespesas, :idmulta, :datalancamento, :valordespesa, :descricao, :idveiculo, :observacao, '+
        '  0, :idloja, :idcliente, :comprovante, :idempresa, :idpessoa, '+
        '  :periodicidade, :categoria, :periodo, :usuario, :parceladoem, :datainicio, :valorparcela, NOW() '+
        ')';
      Q.ParamByName('iddespesas').AsInteger := LIdDespesas;
      Q.ParamByName('categoria').AsString   := 'Multas';
    end;

    // parâmetros comuns
    Q.ParamByName('idmulta').AsInteger := idmultas;

    with Q.ParamByName('datalancamento') do
    begin
      DataType := ftDate;
      AsDate   := Trunc(DtBase);
    end;

    Q.ParamByName('valordespesa').AsFloat := Vlr;
    Q.ParamByName('descricao').AsString   := Descricao;
    Q.ParamByName('observacao').AsString  := Observacao;
    Q.ParamByName('idloja').AsInteger     := idloja;
    Q.ParamByName('idcliente').AsInteger  := idcliente;
    Q.ParamByName('idempresa').AsInteger  := idempresa;
    Q.ParamByName('idpessoa').AsInteger   := idpessoa;
    Q.ParamByName('periodicidade').AsString := 'Unica';
    Q.ParamByName('periodo').AsString       := '';
    Q.ParamByName('usuario').AsString       := 'Sistema';
    Q.ParamByName('parceladoem').AsInteger  := 1;
    Q.ParamByName('comprovante').AsString   := 'multa';
    Q.ParamByName('valorparcela').DataType  := ftFloat;
    Q.ParamByName('valorparcela').AsFloat   := Vlr;
    Q.ParamByName('datainicio').DataType    := ftDate;
    Q.ParamByName('datainicio').AsDate      := Trunc(DtInicio);

    with Q.ParamByName('idveiculo') do
    begin
      DataType := ftInteger;
      if VarIsNull(IdVeiculo) then Clear else AsInteger := Integer(IdVeiculo);
    end;

    Q.ExecSQL;
    Affected := Q.RowsAffected;
    if Affected = 0 then
      raise Exception.Create('Nenhuma linha afetada ao inserir/atualizar despesa.');

    // Se foi INSERT, precisamos descobrir o idgeral (auto-inc) recém gerado
    if not Existe then
    begin
      // MySQL/MariaDB: LAST_INSERT_ID()
      QLastId.SQL.Text := 'SELECT LAST_INSERT_ID() AS idgeral';
      QLastId.Open;
      if QLastId.IsEmpty then
        raise Exception.Create('Falha ao obter LAST_INSERT_ID() para gesdespesas.');
      LIdGeral := QLastId.FieldByName('idgeral').AsInteger;
      QLastId.Close;
    end;

    // 3) RATEIO — usar o idgeral (auto-increment) da despesa
    if SameText(Trim(departamento), 'site') then
    begin
      TipoRateio := 'SITE';
      Depto := '';
      Site  := Trim(idsite);
    end
    else
    begin
      TipoRateio := 'DEPARTAMENTO';
      Depto := Trim(departamento);
      Site  := '';
    end;

    ReplaceRateioDespesa(LIdGeral {= idgeral autoinc}, TipoRateio, Depto, Site, 100.0);

    Result := True;
  except
    on E: Exception do
    begin
      Erro := 'Erro ao criar/atualizar despesa da multa: ' + E.Message;
      Result := False;
    end;
  end;
  QLastId.Free;
  Q.Free;
end;

function TMultas.BuscaPorPlacaData(const APlaca, AData: string; out erro: string): TFDQuery;
var qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    with qry do
    begin
      Active := False; SQL.Clear;
      SQL.Add('SELECT * FROM gesmultas');
      SQL.Add('WHERE placa = :placa AND datainfracao = :datainfracao');
      ParamByName('placa').AsString := APlaca;
      ParamByName('datainfracao').AsString := AData;
      Open;
    end;
    erro := ''; Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao buscar por placa e data: ' + ex.Message; Result := nil;
    end;
  end;
end;

function TMultas.NovoCadastro(out erro: string): Integer;
var qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    try
      FConn.StartTransaction;
      qry.Active := False; qry.SQL.Clear;
      qry.SQL.Add('UPDATE admponteiro');
      qry.SQL.Add('SET idmultas = idmultas + 1');
      qry.SQL.Add('WHERE idcliente = :idcliente AND idloja = :idloja');
      qry.ParamByName('idcliente').AsInteger := idcliente;
      qry.ParamByName('idloja').AsInteger := idloja;
      qry.ExecSQL;

      qry.SQL.Clear;
      qry.SQL.Add('SELECT idmultas FROM admponteiro');
      qry.SQL.Add('WHERE idcliente = :idcliente AND idloja = :idloja');
      qry.ParamByName('idcliente').AsInteger := idcliente;
      qry.ParamByName('idloja').AsInteger := idloja;
      qry.Open;

      Fidmultas := qry.FieldByName('idmultas').AsInteger;
      FConn.Commit;
      erro := ''; Result := Fidmultas;
    except
      on ex: Exception do
      begin
        FConn.Rollback; erro := 'Erro ao consultar : ' + ex.Message; Result := 0;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TMultas.TransformaDebitado(out erro: string): Boolean;
var qry: TFDQuery; dt: TDateTime; dataBanco, sqlUpdate: string;
begin
  if Trim(datainfracao) = '' then dataBanco := ''
  else
  begin
    if not TryStrToDateTimeInvariant(datainfracao, dt) then
    begin
      erro := 'O campo Data/Hora da Infração está com um valor inválido: ' + datainfracao;
      Exit(False);
    end;
    dataBanco := FormatDateTime('yyyy-mm-dd hh:nn:ss', dt);
  end;

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    try
      FConn.StartTransaction;
      qry.Active := False; qry.SQL.Clear;

      if Length(idsMultas) = 0 then
        raise Exception.Create('A lista de multas está vazia.');

      sqlUpdate :=
        'UPDATE gesmultas SET debitado = :debitado '+
        'WHERE idmultas IN (' + idsMultas + ')';

      qry.SQL.Text := sqlUpdate;
      qry.ParamByName('debitado').AsString := 'Debitado';
      qry.ExecSQL;

      FConn.Commit; erro := ''; Result := True;
    except
      on ex: Exception do
      begin
        FConn.Rollback;
        if Pos('Incorrect datetime value', ex.Message) > 0 then
          erro := 'O campo Data/Hora da Infração é inválido.'
        else
          erro := 'Erro ao cadastrar multas: ' + ex.Message;
        Result := False;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TMultas.Editar(out erro: string): Boolean;
var
  qry: TFDQuery; dt: TDateTime; dataBanco: string;
  sqlInsert, sqlUpdate: string;
  jaExiste: Boolean;
  ErroDesp: string;
begin
  if Trim(datainfracao) = '' then dataBanco := ''
  else
  begin
    if not TryStrToDateTimeInvariant(datainfracao, dt) then
    begin
      erro := 'O campo Data/Hora da Infração é inválido: ' + datainfracao;
      Exit(False);
    end;
    dataBanco := FormatDateTime('yyyy-mm-dd hh:nn:ss', dt);
  end;

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    try
      FConn.StartTransaction;

      qry.Active := False;
      qry.SQL.Clear;
      qry.SQL.Add('SELECT idmultas FROM gesmultas');
      qry.SQL.Add('WHERE idcliente = :idcliente AND idloja = :idloja AND idmultas = :idmultas');
      qry.ParamByName('idcliente').AsInteger := idcliente;
      qry.ParamByName('idloja').AsInteger := idloja;
      qry.ParamByName('idmultas').AsInteger := idmultas;
      qry.Open;

      sqlInsert :=
        'INSERT INTO gesmultas (' +
        '  idmultas, placa, numeroait, datainfracao, local, infracao, valor, ' +
        '  dataindicacao, natureza, pontuacao, datacolaborador, statusmulta, ' +
        '  idempresa, idpessoa, deletado, idcliente, idloja, nomeindicacao' +
        ') VALUES (' +
        '  :idmultas, :placa, :numeroait, :datainfracao, :local, :infracao, :valor, ' +
        '  :dataindicacao, :natureza, :pontuacao, :datacolaborador, :statusmulta, ' +
        '  :idempresa, :idpessoa, :deletado, :idcliente, :idloja, :nomeindicacao' +
        ')';

      sqlUpdate :=
        'UPDATE gesmultas SET ' +
        '  DELETADO = :DELETADO, placa = :placa, numeroait = :numeroait, ' +
        '  datainfracao = :datainfracao, local = :local, infracao = :infracao, valor = :valor, ' +
        '  dataindicacao = :dataindicacao, natureza = :natureza, pontuacao = :pontuacao, ' +
        '  datacolaborador = :datacolaborador, idempresa = :idempresa, idpessoa = :idpessoa, ' +
        '  statusmulta = :statusmulta, nomeindicacao = :nomeindicacao ' +
        'WHERE idcliente = :idcliente AND idloja = :idloja AND idmultas = :idmultas';

      if qry.RecordCount = 0 then
      begin
        if (dataBanco <> '') then
        begin
          qry.Close;
          qry.SQL.Clear;
          qry.SQL.Add('SELECT idmultas FROM gesmultas');
          qry.SQL.Add('WHERE idcliente = :idcliente');
          qry.SQL.Add('  AND idloja = :idloja');
          qry.SQL.Add('  AND datainfracao = :datainfracao');
          qry.SQL.Add('  AND idpessoa = :idpessoa');
          qry.ParamByName('idcliente').AsInteger := idcliente;
          qry.ParamByName('idloja').AsInteger := idloja;
          qry.ParamByName('datainfracao').AsDateTime := dt;
          qry.ParamByName('idpessoa').AsInteger := idpessoa;
          qry.Open;

          jaExiste := not qry.IsEmpty;
          if jaExiste then
            raise Exception.Create('Já existe uma multa para essa pessoa nesse mesmo horário.')
          else
          begin
            qry.Close;
            qry.SQL.Text := sqlInsert;
          end;
        end
        else
          raise Exception.Create('Data de infração inválida.');
      end
      else
        qry.SQL.Text := sqlUpdate;

      qry.ParamByName('idmultas').AsInteger := idmultas;
      qry.ParamByName('placa').AsString := placa;
      qry.ParamByName('numeroait').AsString := numeroait;

      if (dataBanco <> '') then
      begin
        qry.ParamByName('datainfracao').DataType := ftDateTime;
        qry.ParamByName('datainfracao').AsDateTime := dt;
      end
      else
      begin
        qry.ParamByName('datainfracao').DataType := ftDateTime;
        qry.ParamByName('datainfracao').Clear;
      end;

      qry.ParamByName('local').AsString := local;
      qry.ParamByName('infracao').AsString := infracao;
      qry.ParamByName('valor').AsString := valor;
      qry.ParamByName('dataindicacao').AsString := dataindicacao;
      qry.ParamByName('natureza').AsString := natureza;
      qry.ParamByName('pontuacao').AsInteger := pontuacao;
      qry.ParamByName('datacolaborador').AsString := datacolaborador;
      qry.ParamByName('statusmulta').AsString := statusmulta;
      qry.ParamByName('idempresa').AsInteger := idempresa;
      qry.ParamByName('idpessoa').AsInteger := idpessoa;
      qry.ParamByName('idcliente').AsInteger := idcliente;
      qry.ParamByName('idloja').AsInteger := idloja;
      qry.ParamByName('DELETADO').AsInteger := 0;
      qry.ParamByName('nomeindicacao').AsString := nomeindicacao;

      qry.ExecSQL;

      // cria/atualiza a despesa vinculada (idgeral = idmultas) e grava rateio (iddespesas = idgeral)
      if not UpsertDespesaParaMulta(ErroDesp) then
        raise Exception.Create(ErroDesp);

      FConn.Commit; erro := ''; Result := True;
    except
      on ex: Exception do
      begin
        FConn.Rollback;
        if Pos('Incorrect datetime value', ex.Message) > 0 then
          erro := 'O campo Data/Hora da Infração é inválido.'
        else
          erro := 'Erro ao cadastrar multas: ' + ex.Message;
        Result := False;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TMultas.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var qry: TFDQuery;
begin
  Result := nil; erro := '';
  if not Assigned(AQuery) then
  begin
    erro := 'AQuery não foi inicializado.'; Exit;
  end;

  try
    qry := TFDQuery.Create(nil);
    try
      if not Assigned(FConn) then
      begin
        erro := 'Conexão FConn não foi inicializada.'; Exit;
      end;

      qry.Connection := FConn;
      with qry do
      begin
        Active := False; SQL.Clear;

        // multa + despesa (via idgeral) + rateio (via idgeral)
        SQL.Add('SELECT');
        SQL.Add('  m.idmultas AS id,');
        SQL.Add('  m.placa, m.numeroait,');
        SQL.Add('  DATE_FORMAT(m.datainfracao, ''%d/%m/%Y'') AS datainfracao,');
        SQL.Add('  m.local, m.infracao, m.valor,');
        SQL.Add('  DATE_FORMAT(m.dataindicacao, ''%d/%m/%Y'') AS dataindicacao,');
        SQL.Add('  m.natureza, m.pontuacao,');
        SQL.Add('  DATE_FORMAT(m.datacolaborador, ''%d/%m/%Y'') AS datacolaborador,');
        SQL.Add('  m.statusmulta, m.idcliente, m.idloja, m.nomeindicacao, m.debitado,');
        SQL.Add('  p.nome AS funcionario,');
        SQL.Add('  d.valordespesa,');
        SQL.Add('  r.percentual, r.tipo, r.departamento, r.idsite');
        SQL.Add('FROM gesmultas m');
        SQL.Add('LEFT JOIN gespessoa p ON p.idpessoa = m.idpessoa');
        SQL.Add('LEFT JOIN gesdespesas d ON d.idgeral = m.idmultas AND d.categoria = ''Multas''');
        SQL.Add('LEFT JOIN gesdespesas_rateio r ON r.iddespesas = d.idgeral');
        SQL.Add('WHERE m.idmultas IS NOT NULL');
        SQL.Add('  AND COALESCE(m.deletado,0) = 0');

        if AQuery.ContainsKey('busca') and (AQuery.Items['busca'] <> '') then
        begin
          SQL.Add('AND (m.placa LIKE :busca OR m.natureza LIKE :busca OR m.infracao LIKE :busca OR m.numeroait LIKE :busca OR p.nome LIKE :busca)');
          ParamByName('busca').AsString := '%' + AQuery.Items['busca'] + '%';
        end;

        if AQuery.ContainsKey('debitado') and (AQuery.Items['debitado'] <> '') then
        begin
          SQL.Add(' AND (m.debitado LIKE :debitado)');
          ParamByName('debitado').AsString := '%' + AQuery.Items['debitado'] + '%';
        end;

        Active := True;
      end;

      Result := qry;
    except
      on ex: Exception do
      begin
        erro := 'Erro ao consultar: ' + ex.Message; FreeAndNil(qry);
      end;
    end;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao criar a query: ' + ex.Message;
    end;
  end;
end;

function TMultas.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    with qry do
    begin
      Active := False; SQL.Clear;

      SQL.Add('SELECT');
      SQL.Add('  m.*, e.nome AS empresa, p.nome AS funcionario,');
      SQL.Add('  d.iddespesas, d.idgeral, d.valordespesa, d.categoria,');
      SQL.Add('  r.percentual, r.tipo, r.departamento, r.idsite');
      SQL.Add('FROM gesmultas m');
      SQL.Add('LEFT JOIN gesempresas e ON e.idempresa = m.idempresa');
      SQL.Add('LEFT JOIN gespessoa p ON p.idpessoa = m.idpessoa');
      SQL.Add('LEFT JOIN gesdespesas d ON d.idgeral = m.idmultas AND d.categoria = ''Multas''');
      SQL.Add('LEFT JOIN gesdespesas_rateio r ON r.iddespesas = d.idgeral');
      SQL.Add('WHERE m.idmultas IS NOT NULL AND m.idmultas = :id');

      ParamByName('id').AsInteger := StrToIntDef(AQuery.Items['idpessoabusca'], 0);

      if AQuery.ContainsKey('deletado') and (Length(AQuery.Items['deletado']) > 0) then
      begin
        SQL.Add('AND m.deletado = :deletado');
        ParamByName('deletado').AsInteger := StrToIntDef(AQuery.Items['deletado'], 0);
      end;

      Active := True;
    end;

    erro := ''; Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message; Result := nil;
    end;
  end;
end;

end.


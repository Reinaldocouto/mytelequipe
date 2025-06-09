unit Model.Multas;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, System.DateUtils,
  model.connection, System.StrUtils, FireDAC.DApt, System.Generics.Collections;

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
    Fidempresa: integer;
    Fidpessoa: integer;

  public
    constructor Create;
    destructor Destroy; override;

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
    property idempresa: integer read Fidempresa write Fidempresa;
    property idpessoa: integer read Fidpessoa write Fidpessoa;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;

    // Mantemos apenas UMA defini��o da fun��o:
    function BuscaPorPlacaData(const APlaca, AData: string; out erro: string): TFDQuery;
  end;

implementation

{------------------------------------------------------------------------------}
{               Fun��o auxiliar para converter ISO8601 em TDateTime            }
{------------------------------------------------------------------------------}

function MyTryISO8601ToDate(const S: string; out ADateTime: TDateTime): Boolean;
var
  LDate, LTime: string;
  i: Integer;
  Y, M, D, HH, NN, SS: Word;
  Temp: string;
begin
  Result := False;
  ADateTime := 0;

  if S = '' then
    Exit;

  i := Pos('T', S); // Exemplo: '2024-11-22T08:20'
  if i > 0 then
  begin
    LDate := Copy(S, 1, i - 1);
    LTime := Copy(S, i + 1, MaxInt);
  end
  else
  begin
    // Tenta achar espa�o se n�o tiver 'T'
    i := Pos(' ', S);
    if i > 0 then
    begin
      LDate := Copy(S, 1, i - 1);
      LTime := Copy(S, i + 1, MaxInt);
    end
    else
    begin
      LDate := S;
      LTime := '';
    end;
  end;

  // Espera 'YYYY-MM-DD'
  if (Length(LDate) < 10) or (LDate[5] <> '-') or (LDate[8] <> '-') then
    Exit;

  Y := StrToIntDef(Copy(LDate, 1, 4), -1);
  M := StrToIntDef(Copy(LDate, 6, 2), -1);
  D := StrToIntDef(Copy(LDate, 9, 2), -1);
  if (Y < 1) or (M < 1) or (D < 1) then
    Exit;

  HH := 0;
  NN := 0;
  SS := 0;

  if LTime <> '' then
  begin
    // Podem vir 'HH:NN' ou 'HH:NN:SS'
    i := Pos(':', LTime);
    if i > 0 then
    begin
      HH := StrToIntDef(Copy(LTime, 1, i - 1), -1);
      Temp := Copy(LTime, i + 1, MaxInt);
      i := Pos(':', Temp);
      if i > 0 then
      begin
        NN := StrToIntDef(Copy(Temp, 1, i - 1), -1);
        SS := StrToIntDef(Copy(Temp, i + 1, MaxInt), -1);
      end
      else
      begin
        NN := StrToIntDef(Temp, -1);
      end;
      if (HH < 0) or (NN < 0) or (SS < 0) then
        Exit;
    end
    else
    begin
      HH := StrToIntDef(LTime, -1);
      if HH < 0 then
        Exit;
    end;
  end;

  try
    ADateTime := EncodeDateTime(Y, M, D, HH, NN, SS, 0);
    Result := True;
  except
    // Falha no EncodeDateTime
    Result := False;
  end;
end;

{------------------------------------------------------------------------------}
{                              TMultas Implementation                           }
{------------------------------------------------------------------------------}

constructor TMultas.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TMultas.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TMultas.BuscaPorPlacaData(const APlaca, AData: string; out erro: string): TFDQuery;
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
      SQL.Add('SELECT * FROM gesmultas');
      SQL.Add('WHERE placa = :placa AND datainfracao = :datainfracao');
      ParamByName('placa').AsString := APlaca;
      ParamByName('datainfracao').AsString := AData;
      Open;
    end;
    erro := '';
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao buscar por placa e data: ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TMultas.NovoCadastro(out erro: string): integer;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    try
      FConn.StartTransaction;

      qry.Active := False;
      qry.SQL.Clear;
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

      erro := '';
      Result := Fidmultas;
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

function TMultas.Editar(out erro: string): Boolean;
var
  qry: TFDQuery;
  dt: TDateTime;
  dataBanco: string;
  formatBanco: string;
  sqlInsert, sqlUpdate: string;
  jaExiste: Boolean;
begin
  // Se datainfracao vier vazio, n�o vamos bloquear
  if Trim(datainfracao) = '' then
    dataBanco := ''
  else
  begin
    formatSettings := TFormatSettings.Create;
    formatSettings.ShortDateFormat := 'yyyy-mm-dd';
    formatSettings.LongTimeFormat := 'hh:nn:ss.zzz';
    formatSettings.DateSeparator := '-';
    formatSettings.TimeSeparator := ':';

    if not TryStrToDateTime(dataInfracao, dt, formatSettings) then
    begin
      erro := 'O campo Data/Hora da Infra��o est� com um valor inv�lido: ' + dataInfracao;
      Exit;
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
        '  idempresa, idpessoa, deletado, idcliente, idloja' +
        ') VALUES (' +
        '  :idmultas, :placa, :numeroait, :datainfracao, :local, :infracao, :valor, ' +
        '  :dataindicacao, :natureza, :pontuacao, :datacolaborador, :statusmulta, ' +
        '  :idempresa, :idpessoa, :deletado, :idcliente, :idloja' +
        ')';

      sqlUpdate :=
        'UPDATE gesmultas SET ' +
        '  DELETADO = :DELETADO, placa = :placa, numeroait = :numeroait, ' +
        '  datainfracao = :datainfracao, local = :local, infracao = :infracao, valor = :valor, ' +
        '  dataindicacao = :dataindicacao, natureza = :natureza, pontuacao = :pontuacao, ' +
        '  datacolaborador = :datacolaborador, idempresa = :idempresa, idpessoa = :idpessoa, ' +
        '  statusmulta = :statusmulta ' +
        'WHERE idcliente = :idcliente AND idloja = :idloja AND idmultas = :idmultas';

      if qry.RecordCount = 0 then
      begin
       if (dataBanco <> '') and TryStrToDateTime(dataBanco, dt) then
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
          begin
            raise Exception.Create('Já existe uma multa para essa pessoa nesse mesmo horário.');
            Exit;
          end
          else
          begin
            qry.Close;
            qry.SQL.Text := sqlInsert;
          end;
        end
        else
        begin
          raise Exception.Create('Data de infração inválida.');
        end;
      end
      else
        qry.SQL.Text := sqlUpdate;

      qry.ParamByName('idmultas').AsInteger := idmultas;
      qry.ParamByName('placa').AsString := placa;
      qry.ParamByName('numeroait').AsString := numeroait;
      if (dataBanco <> '') and TryStrToDateTime(dataBanco, dt) then
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

      qry.ExecSQL;
      FConn.Commit;
      erro := '';
      Result := True;
    except
      on ex: Exception do
      begin
        FConn.Rollback;
        // se vier "Incorrect datetime value" do MySQL, tratamos
        if Pos('Incorrect datetime value', ex.Message) > 0 then
          erro := 'O campo Data/Hora da Infra��o � inv�lido.'
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
var
  qry: TFDQuery;
begin
  Result := nil; // Inicializa o resultado como nil
  erro := '';    // Inicializa a mensagem de erro como vazia

  // Verifica se AQuery est� inicializado
  if not Assigned(AQuery) then
  begin
    erro := 'AQuery n�o foi inicializado.';
    Exit;
  end;

  try
    // Cria a query
    qry := TFDQuery.Create(nil);
    try
      // Verifica se a conex�o FConn est� inicializada
      if not Assigned(FConn) then
      begin
        erro := 'Conex�o FConn n�o foi inicializada.';
        Exit;
      end;

      qry.Connection := FConn; // Atribui a conex�o

      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('SELECT');
        SQL.Add('  gesmultas.idmultas as id,');
        SQL.Add('  gesmultas.placa,');
        SQL.Add('  gesmultas.numeroait,');
        SQL.Add('  DATE_FORMAT(gesmultas.datainfracao, ''%d/%m/%Y'') as datainfracao,');
        SQL.Add('  gesmultas.local,');
        SQL.Add('  gesmultas.infracao,');
        SQL.Add('  gesmultas.valor,');
        SQL.Add('  DATE_FORMAT(gesmultas.dataindicacao, ''%d/%m/%Y'') as dataindicacao,');
        SQL.Add('  gesmultas.natureza,');
        SQL.Add('  gesmultas.pontuacao,');
        SQL.Add('  DATE_FORMAT(gesmultas.datacolaborador, ''%d/%m/%Y'') as datacolaborador,');
        SQL.Add('  gesmultas.statusmulta,');
        SQL.Add('  gesmultas.idcliente,');
        SQL.Add('  gesmultas.idloja,');
        SQL.Add('  gesmultas.nomeindicacao,');
        SQL.Add('  gespessoa.nome as funcionario');
        SQL.Add('FROM gesmultas');
        SQL.Add('LEFT JOIN gespessoa ON gespessoa.idpessoa = gesmultas.idpessoa');
        SQL.Add('WHERE gesmultas.idmultas IS NOT NULL');
        SQL.Add(' AND gesmultas.DELETADO = 0');
        if AQuery.Items['busca'] <> '' then
        begin
          SQL.Add('AND (gesmultas.placa LIKE :busca');
          SQL.Add('OR gesmultas.natureza LIKE :busca');
          SQL.Add('OR gesmultas.infracao LIKE :busca');
          SQL.Add('OR gesmultas.numeroait LIKE :busca');
          SQL.Add('OR gespessoa.nome LIKE :busca)');
          ParamByName('busca').AsString := '%' + AQuery.Items['busca'] + '%';
        end;

        Active := True; // Executa a query
      end;

      Result := qry; // Retorna a query
    except
      on ex: Exception do
      begin
        erro := 'Erro ao consultar: ' + ex.Message;
        FreeAndNil(qry);
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
var
  qry: TFDQuery;
  a: integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('SELECT');
      SQL.Add('  gesmultas.*,');
      SQL.Add('  gesempresas.nome as empresa,');
      SQL.Add('  gespessoa.nome as funcionario');
      SQL.Add('FROM gesmultas');
      SQL.Add('LEFT JOIN gesempresas ON gesempresas.idempresa = gesmultas.idempresa');
      SQL.Add('LEFT JOIN gespessoa ON gespessoa.idpessoa = gesmultas.idpessoa');
      SQL.Add('WHERE gesmultas.idmultas IS NOT NULL AND gesmultas.idmultas = :id');
      ParamByName('id').AsInteger := AQuery.Items['idpessoabusca'].ToInteger;
      a := AQuery.Items['idpessoabusca'].ToInteger;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesmultas.deletado = :deletado');
          ParamByName('deletado').AsInteger := StrToIntDef(AQuery.Items['deletado'], 0);
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


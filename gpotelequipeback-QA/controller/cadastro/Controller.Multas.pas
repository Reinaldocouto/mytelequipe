unit Controller.Multas;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Multas, UtFuncao, Controller.Auth, System.DateUtils;

procedure Registry;
procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure BuscaMultaPorPlacaData(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DebitarMulta(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.Get('v1/multas', Lista);
  THorse.Get('v1/multasid', Listaid);
  THorse.Get('v1/multas/placadata', BuscaMultaPorPlacaData);
  THorse.Post('v1/multas', Salva);
  THorse.Post('v1/multas/debitados', DebitarMulta);
  THorse.Post('v1/multas/novocadastro', Novocadastro);
end;

function TentarConverterData(const DataStr: string; out DataConvertida: TDateTime): Boolean;
var
  FS: TFormatSettings;
begin
  Result := False;
  if DataStr = '' then Exit;

  FS := TFormatSettings.Create;
  FS.DateSeparator  := '/';
  FS.TimeSeparator  := ':';
  FS.ShortDateFormat := 'dd/mm/yyyy';
  FS.LongTimeFormat  := 'hh:nn:ss';
  try
    DataConvertida := StrToDateTime(DataStr, FS);
    Exit(True);
  except end;

  FS := TFormatSettings.Create;
  FS.DateSeparator  := '-';
  FS.TimeSeparator  := ':';
  FS.ShortDateFormat := 'yyyy-mm-dd';
  FS.LongTimeFormat  := 'hh:nn:ss';
  try
    DataConvertida := StrToDateTime(DataStr, FS);
    Exit(True);
  except end;

  {$IF Declared(TryISO8601ToDate)}
  if TryISO8601ToDate(DataStr, DataConvertida) then
    Exit(True);
  {$IFEND}

  try
    DataConvertida := ISO8601ToDate(DataStr);
    Exit(True);
  except
  end;
end;

procedure BuscaMultaPorPlacaData(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TMultas;
  qry: TFDQuery;
  erro, placa, datainfracao: string;
  arraydados: TJSONObject;
  DataConvertida: TDateTime;
begin
  try
    servico := TMultas.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  placa := Req.Query.Field('placa').AsString;
  datainfracao := Req.Query.Field('datainfracao').AsString;

  if (placa = '') or (datainfracao = '') then
  begin
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Placa e data da infração são obrigatórios')).Status(THTTPStatus.BadRequest);
    Exit;
  end;

  if not TentarConverterData(datainfracao, DataConvertida) then
  begin
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Formato de data inválido. Use DD/MM/AAAA')).Status(THTTPStatus.BadRequest);
    Exit;
  end;

  qry := servico.BuscaPorPlacaData(placa, FormatDateTime('yyyy-mm-dd hh:nn:ss', DataConvertida), erro);
  try
    if erro = '' then
    begin
      arraydados := qry.ToJSONObject;
      Res.Send<TJSONObject>(arraydados).Status(THTTPStatus.OK);
    end
    else
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
  finally
    qry.Free;
    servico.Free;
  end;
end;

procedure Novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TMultas;
  body: TJSONValue;
  erro: string;
begin
  servico := TMultas.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      servico.idcliente := body.GetValue<Integer>('idcliente', 0);
      servico.idloja := body.GetValue<Integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idmultas)).Status(THTTPStatus.Created)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TMultas;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
begin
  try
    servico := TMultas.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;
  qry := servico.Lista(Req.Query.Dictionary, erro);
  try
    try
      arraydados := qry.ToJSONArray();
      if erro = '' then
        Res.Send<TJSONArray>(arraydados).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    qry.Free;
    servico.Free;
  end;
end;

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TMultas;
  qry: TFDQuery;
  erro: string;
  obj: TJSONObject;
  rateios: TJSONArray;
  item: TJSONObject;
  first: Boolean;

  procedure AddIfField(const AName: string);
  begin
    if (qry.FindField(AName) <> nil) and (not qry.FieldByName(AName).IsNull) then
      obj.AddPair(AName, qry.FieldByName(AName).AsString);
  end;

  procedure AddIfInt(const AName: string);
  begin
    if (qry.FindField(AName) <> nil) and (not qry.FieldByName(AName).IsNull) then
      obj.AddPair(AName, TJSONNumber.Create(qry.FieldByName(AName).AsInteger));
  end;

begin
  try
    servico := TMultas.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  qry := servico.Listaid(Req.Query.Dictionary, erro);
  try
    if erro <> '' then
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
      Exit;
    end;

    obj := TJSONObject.Create;
    rateios := TJSONArray.Create;
    first := True;

    try
      qry.First;
      while not qry.Eof do
      begin
        if first then
        begin
          // Campos principais da multa
          AddIfInt('idmultas');         // m.idmultas
          AddIfField('placa');
          AddIfField('numeroait');
          AddIfField('datainfracao');
          AddIfField('local');
          AddIfField('infracao');
          AddIfField('valor');
          AddIfField('dataindicacao');
          AddIfField('natureza');
          AddIfInt('pontuacao');
          AddIfField('datacolaborador');
          AddIfField('statusmulta');
          AddIfInt('idcliente');
          AddIfInt('idloja');
          AddIfField('debitado');
          AddIfField('nomeindicacao');

          // Enriquecimentos / joins
          AddIfField('empresa');
          AddIfField('funcionario');

          // Despesa vinculada (se houver)
          AddIfInt('iddespesas');
          AddIfField('valordespesa');
          AddIfField('categoria');
          AddIfInt('idmulta'); // d.idmulta

          first := False;
        end;

        // Cada linha pode conter um item de rateio (r.*)
        if (qry.FindField('percentual') <> nil) and
           (not qry.FieldByName('percentual').IsNull) then
        begin
          item := TJSONObject.Create;
          item.AddPair('percentual', TJSONNumber.Create(qry.FieldByName('percentual').AsFloat));

          if (qry.FindField('tipo') <> nil) and (not qry.FieldByName('tipo').IsNull) then
            item.AddPair('tipo', qry.FieldByName('tipo').AsString);

          // Um dos dois pode vir preenchido
          if (qry.FindField('departamento') <> nil) and (not qry.FieldByName('departamento').IsNull) then
            item.AddPair('departamento', qry.FieldByName('departamento').AsString);

          if (qry.FindField('idsite') <> nil) and (not qry.FieldByName('idsite').IsNull) then
            item.AddPair('idsite', qry.FieldByName('idsite').AsString);

          rateios.AddElement(item);
        end;

        qry.Next;
      end;

      // Anexa o array de rateios (vazio se não houver)
      obj.AddPair('rateio', rateios);

      Res.Send<TJSONObject>(obj).Status(THTTPStatus.OK);
    except
      on ex: Exception do
      begin
        obj.Free; // rateios é liberado junto pois está anexado
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
      end;
    end;
  finally
    qry.Free;
    servico.Free;
  end;
end;

procedure DebitarMulta(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TMultas;
  body: TJSONValue;
  erro: string;
begin
  servico := TMultas.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      servico.idsMultas := body.GetValue<string>('ids', '');
      if servico.TransformaDebitado(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', 'Salvo com sucesso')).Status(THTTPStatus.Created)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TMultas;
  body: TJSONObject;
  erro: string;
  V: TJSONValue;
begin
  servico := TMultas.Create;
  try
    try
      body := Req.Body<TJSONObject>;

      servico.idcliente       := body.GetValue<Integer>('idcliente', 0);
      servico.idloja          := body.GetValue<Integer>('idloja', 0);
      servico.idmultas        := body.GetValue<Integer>('idmultas', 0);
      servico.idempresa       := body.GetValue<Integer>('idempresa', 0);
      servico.idpessoa        := body.GetValue<Integer>('idpessoa', 0);
      servico.numeroait       := body.GetValue<string>('numeroait', '');
      servico.pontuacao       := body.GetValue<Integer>('pontuacao', 0);
      servico.placa           := body.GetValue<string>('placa', '');
      servico.datainfracao    := body.GetValue<string>('datainfracao', '');
      servico.local           := body.GetValue<string>('local', '');
      servico.infracao        := body.GetValue<string>('infracao', '');
      servico.valor           := body.GetValue<string>('valor', '');
      servico.dataindicacao   := body.GetValue<string>('dataindicacao', '');
      servico.natureza        := body.GetValue<string>('natureza', '');
      servico.datacolaborador := body.GetValue<string>('datacolaborador', '');
      servico.statusmulta     := body.GetValue<string>('statusmulta', '');

      // nomeindicacao (aceita "nomeindicacao" ou "nomeindicado")
      V := body.GetValue('nomeindicacao');
      if not Assigned(V) then V := body.GetValue('nomeindicado');
      if Assigned(V) and not (V is TJSONNull) then
        servico.nomeindicacao := V.Value
      else
        servico.nomeindicacao := '';

      // rateio vem do corpo, mas será persistido em gesdespesas_rateio (não em gesmultas)
      V := body.GetValue('departamento');
      if Assigned(V) and not (V is TJSONNull) then
        servico.departamento := V.Value
      else
        servico.departamento := '';

      V := body.GetValue('idsite');
      if Assigned(V) and not (V is TJSONNull) then
        servico.idsite := V.Value
      else
        servico.idsite := '';

      if servico.Editar(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', 'Salvo com sucesso')).Status(THTTPStatus.Created)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

end.


unit Model.Tp;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.Generics.Collections, DateUtils, System.JSON;

type
  TTp = class
  private
    FConn: TFDConnection;
  public
    constructor Create;
    destructor Destroy; override;

    function ListaTP(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function EditarTP(const ABody: TJSONObject; out erro: string): Boolean;
  end;

implementation

constructor TTp.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TTp.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TTp.ListaTP(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  hasSiteId, hasTipo, hasStatus, hasDel, hasNumero, hasEmpresa, hasTipoRegistro: Boolean;
  siteId, tipo, status, deletadoStr, numero, empresa, tipoRegistro: string;
  deletadoInt: Integer;

  function GetStr(const K1, K2: string; out S: string): Boolean;
  begin
    Result := AQuery.TryGetValue(K1, S) or ((K2 <> '') and AQuery.TryGetValue(K2, S));
    if Result then
      S := Trim(S);
  end;

begin
  Result := nil;
  erro := '';
  qry := nil;

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('SELECT');
      SQL.Add('  id,');
      SQL.Add('  site_id,');
      SQL.Add('  tipo,');
      SQL.Add('  criado_em,');
      SQL.Add('  data_inicio,');
      SQL.Add('  hora_inicio,');
      SQL.Add('  data_fim,');
      SQL.Add('  hora_fim,');
      SQL.Add('  numero,');
      SQL.Add('  empresa,');
      SQL.Add('  tipo_registro,');
      SQL.Add('  sequencia_tp,');
      SQL.Add('  status,');
      SQL.Add('  itp_percent,');
      SQL.Add('  impacto,');
      SQL.Add('  descricao,');
      SQL.Add('  deletado,');
      SQL.Add('  created_at,');
      SQL.Add('  updated_at');
      SQL.Add('FROM tp');
      SQL.Add('WHERE 1=1');

      hasSiteId       := GetStr('site_id', 'siteId', siteId) and (siteId <> '');
      hasTipo         := GetStr('tipo', '', tipo) and (tipo <> '');
      hasStatus       := GetStr('status', '', status) and (status <> '');
      hasNumero       := GetStr('numero', '', numero) and (numero <> '');
      hasEmpresa      := GetStr('empresa', '', empresa) and (empresa <> '');
      hasTipoRegistro := GetStr('tipo_registro', 'tipoRegistro', tipoRegistro) and (tipoRegistro <> '');
      hasDel          := GetStr('deletado', '', deletadoStr);

      if hasSiteId       then SQL.Add('  AND site_id = :p_site_id');
      if hasTipo         then SQL.Add('  AND tipo = :p_tipo');
      if hasStatus       then SQL.Add('  AND status = :p_status');
      if hasNumero       then SQL.Add('  AND numero = :p_numero');
      if hasEmpresa      then SQL.Add('  AND empresa = :p_empresa');
      if hasTipoRegistro then SQL.Add('  AND tipo_registro = :p_tipo_registro');

      if hasDel then
        SQL.Add('  AND COALESCE(deletado,0) = :p_deletado')
      else
        SQL.Add('  AND COALESCE(deletado,0) = 0');

      SQL.Add('ORDER BY criado_em DESC, id DESC');

      if hasSiteId then
      begin
        ParamByName('p_site_id').DataType := ftString;
        ParamByName('p_site_id').AsString := siteId;
      end;

      if hasTipo then
      begin
        ParamByName('p_tipo').DataType := ftString;
        ParamByName('p_tipo').AsString := tipo;
      end;

      if hasStatus then
      begin
        ParamByName('p_status').DataType := ftString;
        ParamByName('p_status').AsString := status;
      end;

      if hasNumero then
      begin
        ParamByName('p_numero').DataType := ftString;
        ParamByName('p_numero').AsString := numero;
      end;

      if hasEmpresa then
      begin
        ParamByName('p_empresa').DataType := ftString;
        ParamByName('p_empresa').AsString := empresa;
      end;

      if hasTipoRegistro then
      begin
        ParamByName('p_tipo_registro').DataType := ftString;
        ParamByName('p_tipo_registro').AsString := tipoRegistro;
      end;

      if hasDel then
      begin
        deletadoInt := StrToIntDef(deletadoStr, 0);
        ParamByName('p_deletado').DataType := ftInteger;
        ParamByName('p_deletado').AsInteger := deletadoInt;
      end;

      Active := True;
    end;

    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar TP/CHG: ' + ex.Message;
      if Assigned(qry) then
        qry.Free;
      Result := nil;
    end;
  end;
end;

function TTp.EditarTP(const ABody: TJSONObject; out erro: string): Boolean;
var
  Qry: TFDQuery;
  hasId: Boolean;
  id: Integer;
  strId: string;

  siteId, tipo, status, criadoEm, dataInicio, horaInicio, dataFim, horaFim: string;
  sequenciaTp, numero, empresa, tipoRegistro: string;
  impacto, descricao: string;
  itpPercent, deletado: Integer;
  deletadoBool: Boolean;
  dtTmp: TDateTime;

  function TryGetIntValue(const Obj: TJSONObject; const Key1, Key2: string; out Value: Integer): Boolean;
  begin
    Result := Obj.TryGetValue<Integer>(Key1, Value) or Obj.TryGetValue<Integer>(Key2, Value);
  end;

  function TryGetStrValue(const Obj: TJSONObject; const Key1, Key2: string; out Value: string): Boolean;
  begin
    Result := Obj.TryGetValue<string>(Key1, Value) or Obj.TryGetValue<string>(Key2, Value);
  end;

  function ParseDateSafe(const S: string; out D: TDateTime): Boolean;
  var
    L: string;
    Y, M, Day: Integer;
  begin
    Result := False;
    L := Trim(S);
    if L = '' then
      Exit(False);
    if Length(L) = 10 then
    begin
      try
        Y := StrToInt(Copy(L, 1, 4));
        M := StrToInt(Copy(L, 6, 2));
        Day := StrToInt(Copy(L, 9, 2));
        D := EncodeDate(Y, M, Day);
        Exit(True);
      except
      end;
    end;
    Result := TryISO8601ToDate(L, D, False) or TryStrToDate(L, D);
  end;

  function CleanTime(const S: string): string;
  var
    T: string;
  begin
    T := Trim(S);
    if Length(T) >= 8 then
      Result := Copy(T, 1, 8)
    else
      Result := T;
  end;

  function AsIntOrZero(const S: string): Integer;
  begin
    Result := StrToIntDef(Trim(S), 0);
  end;

  procedure DefineParamTypes(const Q: TFDQuery; const IsUpdate: Boolean);
  begin
    if IsUpdate then
      Q.ParamByName('id').DataType := ftInteger;

    Q.ParamByName('site_id').DataType       := ftString;
    Q.ParamByName('tipo').DataType          := ftString;
    Q.ParamByName('criado_em').DataType     := ftDateTime;
    Q.ParamByName('data_inicio').DataType   := ftDate;
    Q.ParamByName('hora_inicio').DataType   := ftTime;
    Q.ParamByName('data_fim').DataType      := ftDate;
    Q.ParamByName('hora_fim').DataType      := ftTime;
    Q.ParamByName('numero').DataType        := ftString;
    Q.ParamByName('empresa').DataType       := ftString;
    Q.ParamByName('tipo_registro').DataType := ftString;
    Q.ParamByName('sequencia_tp').DataType  := ftString;
    Q.ParamByName('status').DataType        := ftString;
    Q.ParamByName('itp_percent').DataType   := ftInteger;
    Q.ParamByName('impacto').DataType       := ftMemo;
    Q.ParamByName('descricao').DataType     := ftMemo;
    Q.ParamByName('deletado').DataType      := ftInteger;
  end;

  procedure BindCommonParams(const Q: TFDQuery);
  begin
    Q.ParamByName('tipo').AsString          := Trim(tipo);
    Q.ParamByName('status').AsString        := Trim(status);
    Q.ParamByName('sequencia_tp').AsString  := Trim(sequenciaTp);
    Q.ParamByName('empresa').AsString       := Trim(empresa);
    Q.ParamByName('tipo_registro').AsString := Trim(tipoRegistro);
    Q.ParamByName('numero').AsString        := Trim(numero);
    Q.ParamByName('site_id').AsString       := Trim(siteId);
    Q.ParamByName('itp_percent').AsInteger  := itpPercent;
    Q.ParamByName('deletado').AsInteger     := deletado;

    if ParseDateSafe(criadoEm, dtTmp) then
      Q.ParamByName('criado_em').AsDateTime := dtTmp
    else
      Q.ParamByName('criado_em').Clear;

    if ParseDateSafe(dataInicio, dtTmp) then
      Q.ParamByName('data_inicio').AsDate := dtTmp
    else
      Q.ParamByName('data_inicio').Clear;

    if ParseDateSafe(dataFim, dtTmp) then
      Q.ParamByName('data_fim').AsDate := dtTmp
    else
      Q.ParamByName('data_fim').Clear;

    if Trim(horaInicio) <> '' then
      Q.ParamByName('hora_inicio').AsString := CleanTime(horaInicio)
    else
      Q.ParamByName('hora_inicio').Clear;

    if Trim(horaFim) <> '' then
      Q.ParamByName('hora_fim').AsString := CleanTime(horaFim)
    else
      Q.ParamByName('hora_fim').Clear;

    if Trim(impacto) <> '' then
      Q.ParamByName('impacto').AsString := Trim(impacto)
    else
      Q.ParamByName('impacto').Clear;

    if Trim(descricao) <> '' then
      Q.ParamByName('descricao').AsString := Trim(descricao)
    else
      Q.ParamByName('descricao').Clear;
  end;

begin
  Result := False;
  erro := '';

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;

    hasId := ABody.TryGetValue<Integer>('id', id) or ABody.TryGetValue<Integer>('tId', id);
    if not hasId then
    begin
      if ABody.TryGetValue<string>('id', strId) then
        id := AsIntOrZero(strId)
      else if ABody.TryGetValue<string>('tId', strId) then
        id := AsIntOrZero(strId)
      else
        id := 0;
      hasId := id > 0;
    end;

    TryGetStrValue(ABody, 'site_id', 'siteId', siteId);
    if not ABody.TryGetValue<string>('tipo', tipo) then
    begin
      erro := 'Campo "tipo" não encontrado';
      Exit;
    end;
    if not ABody.TryGetValue<string>('status', status) then
    begin
      erro := 'Campo "status" não encontrado';
      Exit;
    end;

    TryGetStrValue(ABody, 'criado_em', 'criadoEm', criadoEm);
    TryGetStrValue(ABody, 'data_inicio', 'dataInicio', dataInicio);
    TryGetStrValue(ABody, 'hora_inicio', 'horaInicio', horaInicio);
    TryGetStrValue(ABody, 'data_fim', 'dataFim', dataFim);
    TryGetStrValue(ABody, 'hora_fim', 'horaFim', horaFim);
    TryGetStrValue(ABody, 'sequencia_tp', 'sequenciaTp', sequenciaTp);
    TryGetStrValue(ABody, 'numero', 'numero', numero);
    TryGetStrValue(ABody, 'empresa', 'empresa', empresa);
    if not TryGetStrValue(ABody, 'tipo_registro', 'tipoRegistro', tipoRegistro) then
      tipoRegistro := '';

    TryGetStrValue(ABody, 'impacto', 'impacto', impacto);
    TryGetStrValue(ABody, 'descricao', 'descricao', descricao);

    if not TryGetIntValue(ABody, 'itp_percent', 'itpPercent', itpPercent) then
      itpPercent := 0;

    if not ABody.TryGetValue<Integer>('deletado', deletado) then
    begin
      if ABody.TryGetValue<Boolean>('deletado', deletadoBool) then
        deletado := Ord(deletadoBool)
      else
        deletado := 0;
    end;

    tipoRegistro := UpperCase(Trim(tipoRegistro));
    tipo         := Trim(tipo);
    status       := Trim(status);
    siteId       := Trim(siteId);
    numero       := Trim(numero);
    empresa      := Trim(empresa);
    impacto      := Trim(impacto);
    descricao    := Trim(descricao);

    if tipo = '' then
    begin
      erro := 'tipo não pode ser vazio';
      Exit;
    end;

    if status = '' then
    begin
      erro := 'status não pode ser vazio';
      Exit;
    end;

    if (itpPercent < 0) or (itpPercent > 100) then
    begin
      erro := 'itp_percent deve estar entre 0 e 100';
      Exit;
    end;

    if (tipoRegistro = '') or (tipoRegistro = 'TP') then
    begin
      if siteId = '' then
      begin
        erro := 'site_id não pode ser vazio';
        Exit;
      end;
    end
    else if tipoRegistro = 'CHG' then
    begin
      if numero = '' then
      begin
        erro := 'numero é obrigatório para CHG';
        Exit;
      end;
    end
    else if tipoRegistro = 'CRQ' then
    begin
      if siteId = '' then
      begin
        erro := 'site_id não pode ser vazio para CRQ';
        Exit;
      end;
    end
    else
    begin
      erro := 'tipo_registro inválido. Use "TP", "CHG" ou "CRQ".';
      Exit;
    end;

    if not FConn.InTransaction then
      FConn.StartTransaction;

    try
      if hasId and (id > 0) then
      begin
        Qry.SQL.Text :=
          'UPDATE tp SET ' +
          '  site_id = :site_id, ' +
          '  tipo = :tipo, ' +
          '  criado_em = :criado_em, ' +
          '  data_inicio = :data_inicio, ' +
          '  hora_inicio = :hora_inicio, ' +
          '  data_fim = :data_fim, ' +
          '  hora_fim = :hora_fim, ' +
          '  numero = :numero, ' +
          '  empresa = :empresa, ' +
          '  tipo_registro = :tipo_registro, ' +
          '  sequencia_tp = :sequencia_tp, ' +
          '  status = :status, ' +
          '  itp_percent = :itp_percent, ' +
          '  impacto = :impacto, ' +
          '  descricao = :descricao, ' +
          '  deletado = :deletado, ' +
          '  updated_at = NOW() ' +
          'WHERE id = :id';

        DefineParamTypes(Qry, True);
        BindCommonParams(Qry);
        Qry.ParamByName('id').AsInteger := id;
      end
      else
      begin
        Qry.SQL.Text :=
          'INSERT INTO tp (' +
          '  site_id, tipo, criado_em, data_inicio, hora_inicio, data_fim, hora_fim, ' +
          '  numero, empresa, tipo_registro, sequencia_tp, status, itp_percent, impacto, descricao, deletado, created_at, updated_at' +
          ') VALUES (' +
          '  :site_id, :tipo, :criado_em, :data_inicio, :hora_inicio, :data_fim, :hora_fim, ' +
          '  :numero, :empresa, :tipo_registro, :sequencia_tp, :status, :itp_percent, :impacto, :descricao, :deletado, NOW(), NOW()' +
          ')';

        DefineParamTypes(Qry, False);
        BindCommonParams(Qry);
        Qry.ParamByName('criado_em').AsDateTime := Now;
      end;

      Qry.ExecSQL;

      if Qry.RowsAffected = 0 then
      begin
        erro := 'Nenhuma linha afetada ao salvar TP/CHG';
        FConn.Rollback;
        Exit;
      end;

      FConn.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        if FConn.InTransaction then
          FConn.Rollback;
        erro := 'Erro ao salvar TP/CHG: ' + E.Message;
      end;
    end;
  finally
    Qry.Free;
  end;
end;

end.


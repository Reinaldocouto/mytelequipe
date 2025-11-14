unit Controller.Rollout;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  Horse,
  Horse.Request,
  Horse.Response,
  FireDAC.Comp.Client,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Param,
  FireDAC.Comp.DataSet,
  Data.DB,
  DataSet.Serialize,
  UtFuncao,
  Model.Projetotelefonica,
  Model.Projetoericsson;

procedure Registry;

implementation

function GetJsonStr(const O: TJSONObject; const Keys: array of string): string;
var
  k: string;
  V: TJSONValue;
begin
  Result := '';
  if O = nil then
    Exit;

  for k in Keys do
  begin
    V := O.Values[k];
    if (V <> nil) and (not V.Null) then
      Exit(V.Value.Trim);
  end;
end;

procedure EnsurePairStr(O: TJSONObject; const Key, Val: string);
begin
  if O = nil then
    Exit;
  if O.Values[Key] <> nil then
    O.RemovePair(Key).Free;
  O.AddPair(Key, Val);
end;

procedure EnsurePairInt(O: TJSONObject; const Key: string; const Val: Integer);
begin
  if O = nil then
    Exit;
  if O.Values[Key] <> nil then
    O.RemovePair(Key).Free;
  O.AddPair(Key, TJSONNumber.Create(Val));
end;

procedure RolloutUnificado(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  arrFinal: TJSONArray;
  servTEL: TProjetotelefonica;
  qryTEL: TFDQuery;
  erroTEL: string;
  servERI: TProjetoericsson;
  qryERI: TFDQuery;
  erroERI: string;
  q: string;
  obj: TJSONObject;
  chave: string;
begin
  if not Req.Query.TryGetValue('q', q) then
    q := '';
  q := System.SysUtils.Trim(q);

  arrFinal := TJSONArray.Create;
  try
    try
      servTEL := TProjetotelefonica.Create;
      qryTEL := nil;
      try
        erroTEL := '';
        qryTEL := servTEL.RolloutTelefonica(Req.Query.Dictionary, erroTEL);

        if (erroTEL = '') and Assigned(qryTEL) then
        begin
          if q <> '' then
          begin
            qryTEL.Close;
            qryTEL.SQL.Text :=
              'SELECT * FROM rolloutvivo ' +
              'WHERE (nomedosite LIKE :q OR UIDIDPMTS LIKE :q OR PMTS LIKE :q) ' +
              'LIMIT 100';
            qryTEL.ParamByName('q').AsString := '%' + q + '%';
            qryTEL.Open;
          end;

          while not qryTEL.Eof do
          begin
            obj := qryTEL.ToJSONObject;
            chave := GetJsonStr(obj, ['nomedosite', 'UIDIDPMTS', 'PMTS']);
            EnsurePairStr(obj, 'empresa', 'TELEFONICA');
            EnsurePairStr(obj, 'chave', chave);
            if (obj.Values['site'] = nil) and (chave <> '') then
              EnsurePairStr(obj, 'site', chave);
            arrFinal.AddElement(obj);
            qryTEL.Next;
          end;
        end
        else if erroTEL <> '' then
          raise Exception.Create(erroTEL);
      finally
        if Assigned(qryTEL) then
          qryTEL.Free;
        servTEL.Free;
      end;

      servERI := TProjetoericsson.Create;
      qryERI := nil;
      try
        erroERI := '';
        qryERI := servERI.Lista(Req.Query.Dictionary, erroERI);

        if (erroERI = '') and Assigned(qryERI) then
        begin
          if q <> '' then
          begin
            qryERI.Close;
            qryERI.SQL.Text :=
              'SELECT * FROM obraericsson ' +
              'WHERE (site LIKE :q OR enderecoSite LIKE :q OR numero LIKE :q) ' +
              'LIMIT 100';
            qryERI.ParamByName('q').AsString := '%' + q + '%';
            qryERI.Open;
          end;

          while not qryERI.Eof do
          begin
            obj := qryERI.ToJSONObject;
            chave := GetJsonStr(obj, ['site', 'enderecoSite', 'numero']);
            EnsurePairStr(obj, 'empresa', 'ERICSSON');
            EnsurePairStr(obj, 'chave', chave);
            if (obj.Values['site'] = nil) and (chave <> '') then
              EnsurePairStr(obj, 'site', chave);
            arrFinal.AddElement(obj);
            qryERI.Next;
          end;
        end
        else if erroERI <> '' then
          raise Exception.Create(erroERI);
      finally
        if Assigned(qryERI) then
          qryERI.Free;
        servERI.Free;
      end;

      Res
        .ContentType('application/json; charset=utf-8')
        .Send(arrFinal.ToJSON)
        .Status(THTTPStatus.OK);

    except
      on E: Exception do
      begin
        Res
          .Send<TJSONObject>(CreateJsonObj('erro', E.Message))
          .Status(THTTPStatus.InternalServerError);
      end;
    end;
  finally
    arrFinal.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/v1/rollout/unificado', RolloutUnificado);
end;

end.


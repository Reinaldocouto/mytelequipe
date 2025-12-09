unit Controller.Tp;

interface

uses
  Winapi.ActiveX, ComObj,
  System.NetEncoding,
  Horse.Commons,
  System.IOUtils, System.Classes,
  Variants,
  System.DateUtils,
  Horse, System.JSON, System.Generics.Collections, System.SysUtils, FireDAC.Comp.Client, Data.DB, Model.Email,
  DataSet.Serialize, Model.Tp, UtFuncao, Controller.Auth;

procedure Registry;
procedure EditarTP(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListaTP(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.Post('v1/acesso/tp', EditarTP);
  THorse.Get('v1/acesso/tp', ListaTP);
  THorse.Get('v1/acesso/:empresa/tp', ListaTP);
end;

procedure EditarTP(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TTp;
  erro: string;
  sucesso: Boolean;
  jsonBody: TJSONObject;
  resultado: TJSONObject;
  bodyUtf8: TBytes;
begin
  Res.ContentType('application/json; charset=utf-8');

  if Trim(Req.Body) = '' then
  begin
    resultado := TJSONObject.Create
      .AddPair('sucesso', TJSONBool.Create(False))
      .AddPair('erro', 'Body vazio');
    try
      Res.Status(THTTPStatus.BadRequest).Send(resultado.ToJSON);
    finally
      resultado.Free;
    end;
    Exit;
  end;

  bodyUtf8 := TEncoding.UTF8.GetBytes(Req.Body);
  jsonBody := TJSONObject(TJSONObject.ParseJSONValue(bodyUtf8, 0));
  if not Assigned(jsonBody) then
  begin
    resultado := TJSONObject.Create
      .AddPair('sucesso', TJSONBool.Create(False))
      .AddPair('erro', 'Body da requisição não é um JSON válido');
    try
      Res.Status(THTTPStatus.BadRequest).Send(resultado.ToJSON);
    finally
      resultado.Free;
    end;
    Exit;
  end;

  servico := TTp.Create;
  try
    try
      sucesso := servico.EditarTP(jsonBody, erro);

      if sucesso then
      begin
        resultado := TJSONObject.Create
          .AddPair('sucesso', TJSONBool.Create(True))
          .AddPair('mensagem', 'Registro salvo com sucesso');
        try
          Res.Status(THTTPStatus.OK).Send(resultado.ToJSON);
        finally
          resultado.Free;
        end;
      end
      else
      begin
        resultado := TJSONObject.Create
          .AddPair('sucesso', TJSONBool.Create(False))
          .AddPair('erro', erro);
        try
          Res.Status(THTTPStatus.BadRequest).Send(resultado.ToJSON);
        finally
          resultado.Free;
        end;
      end;

    except
      on E: Exception do
      begin
        resultado := TJSONObject.Create
          .AddPair('sucesso', TJSONBool.Create(False))
          .AddPair('erro', 'Erro ao processar requisição: ' + E.Message);
        try
          Res.Status(THTTPStatus.InternalServerError).Send(resultado.ToJSON);
        finally
          resultado.Free;
        end;
      end;
    end;
  finally
    jsonBody.Free;
    servico.Free;
  end;
end;

procedure ListaTP(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TTp;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  paramsDict: TDictionary<string, string>;
  srcDict: TDictionary<string, string>;
  empresaFromUrl: string;
  pair: TPair<string, string>;
begin
  Res.ContentType('application/json; charset=utf-8');

  try
    servico := TTp.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  paramsDict := TDictionary<string, string>.Create;
  try
    srcDict := Req.Query.Dictionary;
    for pair in srcDict do
      paramsDict.AddOrSetValue(pair.Key, pair.Value);

    empresaFromUrl := '';
    if Req.Params.Items['empresa'] <> '' then
      empresaFromUrl := Req.Params.Items['empresa'];

    if empresaFromUrl <> '' then
      paramsDict.AddOrSetValue('empresa', empresaFromUrl);

    qry := servico.ListaTP(paramsDict, erro);
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
    end;
  finally
    paramsDict.Free;
    servico.Free;
  end;
end;

end.


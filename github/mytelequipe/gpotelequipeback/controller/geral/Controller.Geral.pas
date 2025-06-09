unit Controller.Geral;

interface
uses Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize,UtFuncao,Model.Geral;


procedure Registry;
procedure listaestadosbrasil(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure listaestadosbrasilid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure listatipofrete(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.Get('v1/estadosbrasil', listaestadosbrasil);
  THorse.Get('v1/estadosbrasilid', listaestadosbrasilid);
  THorse.Get('v1/tipofrete', listatipofrete);
end;

procedure listaestadosbrasil(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TGeral;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TGeral.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.listaestadosbrasil(Req.Query.Dictionary, erro);
  try
    try
      arraydados := qry.ToJSONArray();
      if erro = '' then
        Res.Send<TJSONArray>(arraydados).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    qry.Free;
    servico.Free;
  end;
end;


procedure listatipofrete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TGeral;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TGeral.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.listatipofrete(Req.Query.Dictionary, erro);
  try
    try
      arraydados := qry.ToJSONArray();
      if erro = '' then
        Res.Send<TJSONArray>(arraydados).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    qry.Free;
    servico.Free;
  end;
end;


procedure listaestadosbrasilid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin

end;

end.

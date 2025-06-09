unit Controller.ConfigOrdemCompra;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.ConfigOrdemCompra, UtFuncao, Controller.Auth;

procedure Registry;

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/configordemcompraid', Listaid);
  THorse.post('v1/configordemcompra', salva);
end;

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TConfigOrdemCompra;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TConfigOrdemCompra.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaid(Req.Query.Dictionary, erro);
  try
    try
      arraydados := qry.ToJSONObject;
      if erro = '' then
        Res.Send<TJSONObject>(arraydados).Status(THTTPStatus.OK)
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

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TConfigOrdemCompra;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TConfigOrdemCompra.Create;
  try

    try
      body := Req.body<TJSONObject>;
      servico.opfornecedor := body.getvalue<integer>('opfornecedor', 0);
      servico.preconaordemdecompra := body.getvalue<integer>('preconaordemdecompra', 0);
      servico.statusordemcompra := body.getvalue<integer>('statusordemcompra', 0);
      servico.lancarestoque := body.getvalue<integer>('lancarestoque', 0);
      servico.lancarcontaspagar := body.getvalue<integer>('lancarcontaspagar', 0);
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.Editar(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', 'OK')).Status(THTTPStatus.Created)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);

    except
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

end.


unit Controller.Caixa;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.caixa, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/caixa', Lista);
  THorse.get('v1/caixaid', Listaid);
  THorse.post('v1/caixa', salva);

end;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tcaixa;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin

  try
    servico :=  Tcaixa.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
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
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    qry.Free;
    servico.Free;
  end;
end;

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tcaixa;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := Tcaixa.Create;
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
  servico: Tcaixa;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tcaixa.Create;
  try

    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idcaixa', '')) then
        servico.idcaixa := body.getvalue<integer>('idcaixa', 0)
      else
        servico.idcaixa := 0;

      if strisint(body.getvalue<string>('idpessoa', '')) then
        servico.idpessoa := body.getvalue<integer>('idpessoa', 0)
      else
        servico.idpessoa := 0;

      servico.categoria := body.getvalue<string>('categoria','');
      servico.tipo := body.getvalue<string>('tipo','');
      servico.cliente := body.getvalue<string>('cliente','');
      servico.data := body.getvalue<string>('data','');
      servico.valor := body.getvalue<Real>('valor',0);
      servico.historico := body.getvalue<string>('historico','');

      if strisint(body.getvalue<string>('anexos', '')) then
        servico.anexos := body.getvalue<integer>('anexos', 0)
      else
        servico.anexos := 0;

      servico.marcadores := body.getvalue<string>('marcadores','');

      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      if servico.idcaixa = 0 then
      begin
        if servico.Inserir(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idcaixa)).Status(THTTPStatus.Created)
        else
          Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
      end
      else
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idcaixa)).Status(THTTPStatus.Created)
        else
          Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
      end;

    except
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

end.


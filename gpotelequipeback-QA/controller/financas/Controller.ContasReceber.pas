unit Controller.ContasReceber;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.contasreceber, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/contasreceber', Lista);
  THorse.get('v1/contasreceberid', Listaid);
  THorse.post('v1/contasreceber', salva);
  THorse.Post('v1/contasreceber/novocadastro', novocadastro);

end;

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tcontasreceber;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tcontasreceber.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idcontasreceber)).Status(THTTPStatus.Created)
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

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tcontasreceber;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin

  try
    servico :=  Tcontasreceber.Create;
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
  servico: Tcontasreceber;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := Tcontasreceber.Create;
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
  servico: Tcontasreceber;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tcontasreceber.Create;
  try

    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idcontasreceber', '')) then
        servico.idcontasreceber := body.getvalue<integer>('idcontasreceber', 0)
      else
        servico.idcontasreceber := 0;

      if strisint(body.getvalue<string>('idclientelocal', '')) then
        servico.idpessoa := body.getvalue<integer>('idclientelocal', 0)
      else
        servico.idpessoa := 0;

      servico.documento := body.getvalue<string>('documento','');
      servico.historico := body.getvalue<string>('historico','');
      servico.pago := body.getvalue<Real>('pago', 0);
      servico.saldo := body.getvalue<Real>('saldo', 0);
      servico.valor := body.getvalue<Real>('valor',0);
      servico.vencimento := body.getvalue<string>('vencimento','');
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      servico.ocorrencia := body.getvalue<string>('ocorrencia','');
      servico.emissao := body.getvalue<string>('emissao','');
      servico.categoria := body.getvalue<string>('categoria','');

      if strisint(body.getvalue<string>('numeroparcelas', '')) then
        servico.numeroparcelas := body.getvalue<integer>('numeroparcelas', 0)
      else
        servico.numeroparcelas := 0;

      servico.marcadores := body.getvalue<string>('marcadores','');


      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idcontasreceber)).Status(THTTPStatus.Created)
        else
          Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
      end
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.BadRequest);

    except
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

end.


unit Controller.ContasPagar;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.contaspagar, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salvabaixa(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/contaspagar', Lista);
  THorse.get('v1/contaspagarid', Listaid);
  THorse.post('v1/contaspagar', salva);
  THorse.post('v1/contaspagarbaixa', Salvabaixa);
  THorse.Post('v1/contaspagar/novocadastro', novocadastro);
end;

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tcontaspagar;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tcontaspagar.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idcontaspagar)).Status(THTTPStatus.Created)
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
  servico: Tcontaspagar;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin

  try
    servico := Tcontaspagar.Create;
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
  servico: Tcontaspagar;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := Tcontaspagar.Create;
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
  servico: Tcontaspagar;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tcontaspagar.Create;
  try

    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idcontaspagar', '')) then
        servico.idcontaspagar := body.getvalue<integer>('idcontaspagar', 0)
      else
        servico.idcontaspagar := 0;

      if strisint(body.getvalue<string>('idfornecedor', '')) then
        servico.idfornecedor := body.getvalue<integer>('idfornecedor', 0)
      else
        servico.idfornecedor := 0;

      if strisint(body.getvalue<string>('idpessoa', '')) then
        servico.idpessoa := body.getvalue<integer>('idpessoa', 0)
      else
        servico.idpessoa := 0;

      servico.documento := body.getvalue<string>('documento', '');
      servico.historico := body.getvalue<string>('historico', '');
      servico.pago := body.getvalue<Real>('pago', 0);
      servico.saldo := body.getvalue<Real>('saldo', 0);
      servico.valor := body.getvalue<Real>('valor', 0);
      servico.vencimento := body.getvalue<string>('vencimento', '');
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      servico.ocorrencia := body.getvalue<string>('ocorrencia', '');
      servico.emissao := body.getvalue<string>('emissao', '');
      servico.categoria := body.getvalue<string>('categoria', '');

      if strisint(body.getvalue<string>('numeroparcelas', '')) then
        servico.numeroparcelas := body.getvalue<integer>('numeroparcelas', 0)
      else
        servico.numeroparcelas := 0;

      servico.marcadores := body.getvalue<string>('marcadores', '');

      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idcontaspagar)).Status(THTTPStatus.Created)
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

procedure Salvabaixa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tcontaspagar;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tcontaspagar.Create;
  try
    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idcontaspagarbaixa', '')) then
        servico.idcontaspagarbaixa := body.getvalue<integer>('idcontaspagarbaixa', 0)
      else
        servico.idcontaspagarbaixa := 0;

      if strisint(body.getvalue<string>('idcontaspagar', '')) then
        servico.idcontaspagar := body.getvalue<integer>('idcontaspagar', 0)
      else
        servico.idcontaspagar := 0;

      if strisint(body.getvalue<string>('idfornecedor', '')) then
        servico.idfornecedor := body.getvalue<integer>('idfornecedor', 0)
      else
        servico.idfornecedor := 0;

      if strisint(body.getvalue<string>('idcategoria', '')) then
        servico.idcategoria := body.getvalue<integer>('idcategoria', 0)
      else
        servico.idcategoria := 0;

      servico.documento := body.getvalue<string>('documento', '');
      servico.historico := body.getvalue<string>('historico', '');
      servico.valorpago := body.getvalue<real>('valorpago', 0);
      servico.datapagamento := body.getvalue<string>('datapagamento', '');
      servico.origem := body.getvalue<string>('origem', '');
      servico.formapagamento := body.getvalue<real>('formapagamento', 0);
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      if servico.Baixarconta(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idcontaspagarbaixa)).Status(THTTPStatus.Created)
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


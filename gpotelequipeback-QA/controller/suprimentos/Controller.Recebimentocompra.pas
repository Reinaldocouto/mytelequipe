unit Controller.Recebimentocompra;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Recebimentocompra, UtFuncao, UtXMLcompraSAURUSpTABELA,
  Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listadivergencia(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaitens(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaidqtd(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Contagem(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Reiniciarconferencia(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Reiniciarcontagem(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/recebimentocompra', Lista);
  THorse.get('v1/recebimentocompraid', Listaid);
  THorse.get('v1/recebimentocompraidqtd', Listaidqtd);
  THorse.get('v1/recebimentocompra/itens', Listaitens);
  THorse.get('v1/recebimentocompra/divergencia', Listadivergencia);
  THorse.get('v1/recebimentocompra/contagem', Contagem);
  THorse.get('v1/recebimentocompra/reiniciarconferencia', Reiniciarconferencia);
  THorse.post('v1/recebimentocompra/reiniciarcontagem', Reiniciarcontagem);
  THorse.post('v1/recebimentocompra', salva);

end;

procedure Reiniciarcontagem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TRecebimentocompra;
  body: TJSONValue;
  qry: TFDQuery;
  arraydados: TJSONArray;
  erro: string;
begin
  servico := TRecebimentocompra.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      servico.idproduto := body.getvalue<integer>('idproduto', 0);
      servico.idrecebimentocompra := body.getvalue<integer>('idrecebimentocompra', 0);
      qry := servico.Reiniciarcontagem(erro);
      if Length(erro) = 0 then
        Res.Send<TJSONArray>(arraydados).Status(THTTPStatus.OK)
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

procedure Reiniciarconferencia(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TRecebimentocompra;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TRecebimentocompra.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Reiniciarconferencia(Req.Query.Dictionary, erro);
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

procedure Contagem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TRecebimentocompra;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TRecebimentocompra.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Contagem(Req.Query.Dictionary, erro);
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

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TRecebimentocompra;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TRecebimentocompra.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idrecebimentocompra)).Status(THTTPStatus.Created)
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
  servico: TRecebimentocompra;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TRecebimentocompra.Create;
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

procedure Listadivergencia(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TRecebimentocompra;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TRecebimentocompra.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listadivergencia(Req.Query.Dictionary, erro);
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

procedure Listaitens(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TRecebimentocompra;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TRecebimentocompra.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listarecebimentoitens(Req.Query.Dictionary, erro);
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
  servico: TRecebimentocompra;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TRecebimentocompra.Create;
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

procedure Listaidqtd(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TRecebimentocompra;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TRecebimentocompra.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaidqtd(Req.Query.Dictionary, erro);
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
  servico: TRecebimentocompra;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TRecebimentocompra.Create;
  try

    try
      body := Req.body<TJSONObject>;

      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      servico.idrecebimentocompra := body.getvalue<integer>('idrecebimentocompra', 0);

      if Length(erro) = 0 then
      begin
        if servico.salvar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idrecebimentocompra)).Status(THTTPStatus.Created)
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


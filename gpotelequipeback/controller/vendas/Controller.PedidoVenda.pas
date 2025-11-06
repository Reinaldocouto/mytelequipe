unit Controller.PedidoVenda;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.pedidovenda, UtFuncao, Controller.Auth;

procedure Registry;

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/pedidovenda', Lista);
  THorse.get('v1/pedidovendaid', Listaid);
  THorse.post('v1/pedidovenda', salva);
  THorse.Post('v1/pedidovenda/novocadastro', novocadastro);
end;

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tpedidovenda;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tpedidovenda.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idpedidovenda)).Status(THTTPStatus.Created)
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
  servico: Tpedidovenda;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin

  try
    servico := Tpedidovenda.Create;
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
  servico: Tpedidovenda;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := Tpedidovenda.Create;
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
  servico: Tpedidovenda;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tpedidovenda.Create;
  try

    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idpedidovenda', '')) then
        servico.idpedidovenda := body.getvalue<integer>('idpedidovenda', 0)
      else
        servico.idpedidovenda := 0;

      if strisint(body.getvalue<string>('idclienteped', '')) then
        servico.idclienteped := body.getvalue<integer>('idclienteped', 0)
      else
        servico.idclienteped := 0;

      servico.dataenvio := body.getvalue<string>('dataenvio','');
      servico.dataprevista := body.getvalue<string>('dataprevista','');
      servico.datavenda := body.getvalue<string>('datavenda', '');

      if strisint(body.getvalue<string>('desconto', '')) then
        servico.desconto := body.getvalue<real>('desconto', 0)
      else
        servico.desconto := 0;

      servico.descricao := body.getvalue<string>('descricao','');

      if strisint(body.getvalue<string>('despesas', '')) then
        servico.despesas := body.getvalue<real>('despesas', 0)
      else
        servico.despesas := 0;

      servico.enviarexpedicao := body.getvalue<string>('enviarexpedicao','');
      servico.formaenvio := body.getvalue<string>('formaenvio', '');

      if strisint(body.getvalue<string>('fretecliente', '')) then
        servico.fretecliente := body.getvalue<real>('fretecliente', 0)
      else
        servico.fretecliente := 0;

      if strisint(body.getvalue<string>('icms', '')) then
        servico.icms := body.getvalue<integer>('icms', 0)
      else
        servico.icms := 0;

      if strisint(body.getvalue<string>('intermediador', '')) then
        servico.intermediador := body.getvalue<integer>('intermediador', 0)
      else
        servico.intermediador := 0;

      if strisint(body.getvalue<string>('ipi', '')) then
        servico.ipi := body.getvalue<integer>('ipi', 0)
      else
        servico.ipi := 0;

      servico.listapreco := body.getvalue<string>('listapreco', '');
      servico.marcadores := body.getvalue<string>('marcadores', '');
      servico.naturezaoperacao := body.getvalue<string>('naturezaoperacao','');

      if strisint(body.getvalue<string>('numero', '')) then
        servico.numero := body.getvalue<integer>('numero', 0)
      else
        servico.numero := 0;

      if strisint(body.getvalue<string>('numeroitem', '')) then
        servico.numeroitem := body.getvalue<integer>('numeroitem', 0)
      else
        servico.numeroitem := 0;

      if strisint(body.getvalue<string>('numeropedido', '')) then
        servico.numeropedido := body.getvalue<integer>('numeropedido', 0)
      else
        servico.numeropedido := 0;

      servico.observacoes := body.getvalue<string>('observacoes', '');
      servico.observacoesinternas := body.getvalue<string>('observacoesinternas', '');
      servico.pagamento := body.getvalue<string>('pagamento','');

      if strisint(body.getvalue<string>('pesobruto', '')) then
        servico.pesobruto := body.getvalue<real>('pesobruto', 0)
      else
        servico.pesobruto := 0;

      if strisint(body.getvalue<string>('pesoliquido', '')) then
        servico.pesoliquido := body.getvalue<real>('pesoliquido', 0)
      else
        servico.pesoliquido := 0;

      if strisint(body.getvalue<string>('precounico', '')) then
        servico.precounico := body.getvalue<real>('precounico', 0)
      else
        servico.precounico := 0;

      if strisint(body.getvalue<string>('qtd', '')) then
        servico.qtd := body.getvalue<integer>('qtd', 0)
      else
        servico.qtd := 0;

      if strisint(body.getvalue<string>('somaquantidade', '')) then
        servico.somaquantidade := body.getvalue<integer>('somaquantidade', 0)
      else
        servico.somaquantidade := 0;

      if strisint(body.getvalue<string>('totalproduto', '')) then
        servico.totalproduto  := body.getvalue<real>('totalproduto ', 0)
      else
        servico.totalproduto  := 0;

      if strisint(body.getvalue<string>('totalvenda', '')) then
        servico.totalvenda  := body.getvalue<real>('totalvenda', 0)
      else
        servico.totalvenda  := 0;

      if strisint(body.getvalue<string>('identificador', '')) then
        servico.identificador := body.getvalue<integer>('identificador', 0)
      else
        servico.identificador := 0;

      if strisint(body.getvalue<string>('numeropedidovenda', '')) then
        servico.numeropedidovenda := body.getvalue<integer>('numeropedidovenda', 0)
      else
        servico.numeropedidovenda := 0;

      servico.recebimento := body.getvalue<string>('recebimento','');
      servico.condicaopagamento := body.getvalue<string>('condicaopagamento','');
      servico.categoria := body.getvalue<string>('categoria','');
      servico.formafrete := body.getvalue<string>('formafrete','');

      if strisint(body.getvalue<string>('codigorastreamento', '')) then
        servico.codigorastreamento := body.getvalue<integer>('codigorastreamento', 0)
      else
        servico.codigorastreamento := 0;

      servico.urlrastreamento := body.getvalue<string>('urlrastreamento','');
      servico.nome := body.getvalue<string>('nome','');

      if strisint(body.getvalue<string>('freteconta', '')) then
        servico.freteconta := body.getvalue<real>('freteconta', 0)
      else
        servico.freteconta := 0;

      servico.anexos := body.getvalue<string>('anexos','');

      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idpedidovenda)).Status(THTTPStatus.Created)
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


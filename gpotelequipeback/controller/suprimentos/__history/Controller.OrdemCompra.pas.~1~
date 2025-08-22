unit Controller.OrdemCompra;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.ordemcompra, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaitens(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaitensid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaitenssoma(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastroitens(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salvaitens(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salvaitenssolicitacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure mudarstatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure lancarestoque(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure cancelarlancarestoque(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/ordemcompra', Lista);
  THorse.get('v1/ordemcompraid', Listaid);
  THorse.Post('v1/ordemcompra', salva);
  THorse.get('v1/ordemcompra/itens', Listaitens);
  THorse.get('v1/ordemcompra/itensid', Listaitensid);
  THorse.get('v1/ordemcompra/itens/soma', Listaitenssoma);
  THorse.Post('v1/ordemcompra/novocadastro', novocadastro);
  THorse.Post('v1/ordemcompra/novocadastroitens', novocadastroitens);
  THorse.Post('v1/ordemcompra/itens', salvaitens);
  THorse.Post('v1/ordemcompra/itenssolicitacao', Salvaitenssolicitacao);
  THorse.Post('v1/ordemcompra/mudarstatus', mudarstatus);
  THorse.Post('v1/ordemcompra/lancarestoque', lancarestoque);
  THorse.Post('v1/ordemcompra/cancelarlancarestoque', cancelarlancarestoque);
end;

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TOrdemCompra;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TOrdemCompra.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idordemcompra)).Status(THTTPStatus.Created)
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

procedure lancarestoque(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TOrdemCompra;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TOrdemCompra.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idordemcompra := body.getvalue<integer>('idordemcompra', 0);
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.lancarestoque(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idordemcompra)).Status(THTTPStatus.Created)
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

procedure cancelarlancarestoque(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TOrdemCompra;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TOrdemCompra.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idordemcompra := body.getvalue<integer>('idordemcompra', 0);
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.cancelarlancarestoque(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idordemcompra)).Status(THTTPStatus.Created)
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

procedure mudarstatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TOrdemCompra;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TOrdemCompra.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idordemcompra := body.getvalue<integer>('idordemcompra', 0);
      servico.situacao := body.getvalue<string>('situacao', '');
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.mudarstatus(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idordemcompra)).Status(THTTPStatus.Created)
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

procedure novocadastroitens(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TOrdemCompra;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TOrdemCompra.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      if servico.NovoCadastroitens(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idordemcompraitens)).Status(THTTPStatus.Created)
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
  servico: TOrdemCompra;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin

  try
    servico := TOrdemCompra.Create;
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

procedure Listaitensid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TOrdemCompra;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin

  try
    servico := TOrdemCompra.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaitensid(Req.Query.Dictionary, erro);
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

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TOrdemCompra;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin

  try
    servico := TOrdemCompra.Create;
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

procedure Listaitens(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TOrdemCompra;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin

  try
    servico := TOrdemCompra.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaitens(Req.Query.Dictionary, erro);
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

procedure Listaitenssoma(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TOrdemCompra;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin

  try
    servico := TOrdemCompra.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaitenssoma(Req.Query.Dictionary, erro);
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

procedure Salvaitenssolicitacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TOrdemCompra;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TOrdemCompra.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idproduto', '')) then
        servico.idproduto := body.getvalue<integer>('idproduto', 0)
      else
        servico.idproduto := 0;

      if strisint(body.getvalue<string>('idordemcompra', '')) then
        servico.idordemcompra := body.getvalue<integer>('idordemcompra', 0)
      else
        servico.idordemcompra := 0;

      if strisint(body.getvalue<string>('idordemcompraitens', '')) then
        servico.idordemcompraitens := body.getvalue<integer>('idordemcompraitens', 0)
      else
        servico.idordemcompraitens := 0;

      servico.quantidade := body.getvalue<double>('qtd', 0);
      servico.preco := body.getvalue<double>('preco', 0);
      servico.ipi := body.getvalue<double>('ipi', 0);
      servico.valorst := body.getvalue<double>('valorst', 0);
      servico.valortotal := body.getvalue<double>('valortotal', 0);
      servico.idusuario := body.getvalue<integer>('idusuario', 0);
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      if Length(erro) = 0 then
      begin
        if servico.EditarItenssolicitacao(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idordemcompraitens)).Status(THTTPStatus.Created)
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

procedure SalvaItens(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TOrdemCompra;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TOrdemCompra.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idproduto', '')) then
        servico.idproduto := body.getvalue<integer>('idproduto', 0)
      else
        servico.idproduto := 0;

      if strisint(body.getvalue<string>('idordemcompra', '')) then
        servico.idordemcompra := body.getvalue<integer>('idordemcompra', 0)
      else
        servico.idordemcompra := 0;

      if strisint(body.getvalue<string>('idordemcompraitens', '')) then
        servico.idordemcompraitens := body.getvalue<integer>('idordemcompraitens', 0)
      else
        servico.idordemcompraitens := 0;

      servico.quantidade := body.getvalue<double>('qtd', 0);
      servico.preco := body.getvalue<double>('preco', 0);
      servico.ipi := body.getvalue<double>('ipi', 0);
      servico.valorst := body.getvalue<double>('valorst', 0);
      servico.valortotal := body.getvalue<double>('valortotal', 0);
      servico.idusuario := body.getvalue<integer>('idusuario', 0);
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      if Length(erro) = 0 then
      begin
        if servico.EditarItens(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idordemcompraitens)).Status(THTTPStatus.Created)
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

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TOrdemCompra;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TOrdemCompra.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      if strisint(body.getvalue<string>('idordemcompra', '')) then
        servico.idordemcompra := body.getvalue<integer>('idordemcompra', 0)
      else
        servico.idordemcompra := 0;

      if strisint(body.getvalue<string>('idfornecedor', '')) then
        servico.idfornecedor := body.getvalue<integer>('idfornecedor', 0)
      else
        servico.idfornecedor := 0;

      if strisint(body.getvalue<string>('idtipofrete', '')) then
        servico.idtipofrete := body.getvalue<integer>('idtipofrete', 0)
      else
        servico.idtipofrete := 0;

      servico.nitens := body.getvalue<integer>('nitens', 0);
      servico.somaqtdes := body.getvalue<double>('somaqtdes', 0);
      servico.totalprodutos := body.getvalue<double>('totalprodutos', 0);
      servico.desconto := body.getvalue<double>('desconto', 0);
      servico.frete := body.getvalue<double>('frete', 0);
      servico.totalipi := body.getvalue<double>('totalipi', 0);
      servico.totalicmsst := body.getvalue<double>('totalicmsst', 0);
      servico.totalgeral := body.getvalue<double>('totalgeral', 0);
      servico.numerofornecedor := body.getvalue<string>('numerofornecedor', '');
      servico.datacompra := body.getvalue<string>('datacompra', '');
      servico.dataprevista := body.getvalue<string>('dataprevista', '');
      servico.observacao := body.getvalue<string>('observacao', '');

      servico.idusuario := body.getvalue<integer>('idusuario', 0);
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      if servico.idfornecedor = 0 then
        erro := 'Campo Fornecedor é Obrigatório';

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idordemcompraitens)).Status(THTTPStatus.Created)
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


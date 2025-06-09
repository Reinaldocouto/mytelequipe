unit Controller.Produto;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Produto, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure ListaSelect(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/produto', Lista);
  THorse.get('v1/produto/select', ListaSelect);
  THorse.get('v1/produtoid', Listaid);
  THorse.post('v1/produto', salva);
  THorse.Post('v1/produto/novocadastro', novocadastro);
end;

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProduto;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProduto.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idproduto)).Status(THTTPStatus.Created)
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
  servico: TProduto;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProduto.Create;
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

procedure ListaSelect(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProduto;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := Tproduto.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaSelect(Req.Query.Dictionary, erro);
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
  servico: TProduto;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProduto.Create;
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
  servico: TProduto;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProduto.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idproduto', '')) then
        servico.idproduto := body.getvalue<integer>('idproduto', 0)
      else
        servico.idproduto := 0;

      servico.descricao := body.getvalue<string>('descricao', '');

      servico.codigo := body.getvalue<string>('codigo', '');

      if strisint(body.getvalue<string>('origem', '')) then
        servico.origem := body.getvalue<integer>('origem', 0)
      else
        servico.origem := 0;

      servico.unidade := body.getvalue<string>('unidade', '');

      if strisint(body.getvalue<string>('controlarestoque', '')) then
        servico.controlarestoque := body.getvalue<integer>('controlarestoque', 0)
      else
        servico.controlarestoque := 0;

      if strisint(body.getvalue<string>('estoque', '')) then
        servico.estoque := body.getvalue<real>('estoque', 0)
      else
        servico.estoque := 0;

      if strisint(body.getvalue<string>('estoqueinicial', '')) then
        servico.estoqueinicial := body.getvalue<real>('estoqueinicial', 0)
      else
        servico.estoqueinicial := 0;

      if strisint(body.getvalue<string>('estminimo', '')) then
        servico.estminimo := body.getvalue<real>('estminimo', 0)
      else
        servico.estminimo := 0;

      if strisint(body.getvalue<string>('estmaximo', '')) then
        servico.estmaximo := body.getvalue<real>('estmaximo', 0)
      else
        servico.estmaximo := 0;

      if strisint(body.getvalue<string>('sobencomenda', '')) then
        servico.sobencomenda := body.getvalue<integer>('sobencomenda', 0)
      else
        servico.sobencomenda := 0;

      servico.categoria := body.getvalue<string>('categoria', '');

      servico.diasparapreparacao := body.getvalue<integer>('diasparapreparacao', 0);

      servico.localizacao := body.getvalue<string>('localizacao', '');


      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idproduto)).Status(THTTPStatus.Created)
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


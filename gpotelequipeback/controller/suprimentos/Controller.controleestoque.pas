unit Controller.controleestoque;

interface

uses
  Horse, System.JSON, System.SysUtils, System.Generics.Collections,
  FireDAC.Comp.Client, Data.DB, DataSet.Serialize, Model.controleestoque,
  UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listadetalhe(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listadetalhestatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listalancamentotipo(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salvalancamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure RelatorioCustoSolicitacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/controleestoque', Lista);
  THorse.get('v1/controleestoqueid', Listaid);
  THorse.get('v1/controleestoquedetalhe', Listadetalhe);
  THorse.get('v1/controleestoquedetalhestatus', Listadetalhestatus);
  THorse.get('v1/controleestoquelancamentotipo', Listalancamentotipo);
  THorse.post('v1/controleestoquelancamento', salvalancamento);
  THorse.post('v1/controleestoquelancamento/novocadastro', novocadastro);
  THorse.post('v1/controleestoque/relatorioCustoSolicitacao', RelatorioCustoSolicitacao);
end;

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tcontroleestoque;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tcontroleestoque.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idcontroleestoque)).Status(THTTPStatus.Created)
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

procedure Salvalancamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tcontroleestoque;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tcontroleestoque.Create;
  try

    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idcontroleestoque', '')) then
        servico.idcontroleestoque := body.getvalue<integer>('idcontroleestoque', 0)
      else
        servico.idcontroleestoque := 0;
      if strisint(body.getvalue<string>('idproduto', '')) then
        servico.idproduto := body.getvalue<integer>('idproduto', 0)
      else
        servico.idproduto := 0;

      if strisint(body.getvalue<string>('idusuario', '')) then
        servico.idusuario := body.getvalue<integer>('idusuario', 0)
      else
        servico.idusuario := 0;

      if strisint(body.getvalue<string>('idtipomovimentacao', '')) then
        servico.idtipomovimentacao := body.getvalue<integer>('idtipomovimentacao', 0)
      else
        servico.idtipomovimentacao := 0;

      servico.dataehora := body.getvalue<string>('dataehora', '');

      if StrIsdouble(body.getvalue<string>('entrada', '')) then
        servico.entrada := body.getvalue<Double>('entrada', 0)
      else
        servico.entrada := 0;
      if StrIsdouble(body.getvalue<string>('saida', '')) then
        servico.saida := body.getvalue<Double>('saida', 0)
      else
        servico.saida := 0;
      if StrIsdouble(body.getvalue<string>('balanco', '')) then
        servico.balanco := body.getvalue<Double>('balanco', 0)
      else
        servico.balanco := 0;
      if StrIsdouble(body.getvalue<string>('valor', '')) then
        servico.valor := body.getvalue<Double>('valor', 0)
      else
        servico.valor := 0;

      servico.observacao := body.getvalue<string>('observacao', '');

      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idcontroleestoque)).Status(THTTPStatus.Created)
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

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tcontroleestoque;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := Tcontroleestoque.Create;
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

procedure Listadetalhe(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tcontroleestoque;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := Tcontroleestoque.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listadetalhe(Req.Query.Dictionary, erro);
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


procedure RelatorioCustoSolicitacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tcontroleestoque;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONObject;
  params: TDictionary<string, string>;
  obra, idcliente, idloja: string;
begin
  try
    servico := Tcontroleestoque.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  body := Req.Body<TJSONObject>;
  if not body.TryGetValue<string>('idcliente', idcliente) or (idcliente = '') or
     not body.TryGetValue<string>('idloja', idloja) or (idloja = '') then
  begin
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Campos idcliente e idloja são obrigatórios')).Status(THTTPStatus.BadRequest);
    servico.Free;
    exit;
  end;
  body.TryGetValue<string>('obra', obra);

  params := TDictionary<string, string>.Create;
  try
    params.Add('idcliente', idcliente);
    params.Add('idloja', idloja);
    if obra <> '' then
      params.Add('obra', obra);

    qry := servico.RelatorioCustoSolicitacao(params, erro);
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
    params.Free;
    qry.Free;
    servico.Free;
  end;
end;

procedure Listadetalhestatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tcontroleestoque;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := Tcontroleestoque.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listadetalhestatus(Req.Query.Dictionary, erro);
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

procedure Listalancamentotipo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tcontroleestoque;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := Tcontroleestoque.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listalancamentotipo(Req.Query.Dictionary, erro);
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
  servico: Tcontroleestoque;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := Tcontroleestoque.Create;
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

end.


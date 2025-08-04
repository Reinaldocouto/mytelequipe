unit Controller.Solicitacao;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Solicitacao, UtFuncao, Controller.Auth;

procedure Registry;

//procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Listasolicitacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaidlista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaiditens(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Editardiaria(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure EditarItens(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaitens(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastrodiaria(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastroitens(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listarequisicao(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Atenderequisicao(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/solicitacao/lista', Listasolicitacao);
  THorse.get('v1/solicitacao/requisicao', Listarequisicao);
  THorse.post('v1/solicitacao/requisicao', Atenderequisicao);
  THorse.get('v1/solicitacaoid', Listaid);
  THorse.get('v1/solicitacaoid/lista', Listaidlista);
  THorse.get('v1/solicitacaoid/itens', Listaiditens);
  THorse.post('v1/solicitacao/editar', editar);
  THorse.post('v1/solicitacao/editaritens', editaritens);
  THorse.get('v1/solicitacao/listaitens', Listaitens);
  THorse.post('v1/solicitacao/novocadastro', novocadastro);
  THorse.post('v1/solicitacao/novocadastroitens', novocadastroitens);

  THorse.post('v1/solicitacao/novocadastrodiaria', novocadastrodiaria);
  THorse.post('v1/solicitacao/editardiaria', editardiaria);
end;

procedure Atenderequisicao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tsolicitacao;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tsolicitacao.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idusuario := body.getvalue<integer>('idusuario', 0);
      servico.idcliente:= body.getvalue<integer>('idcliente', 0);
      servico.idloja:= body.getvalue<integer>('idloja', 0);
      servico.idtipomovimentacao:= body.getvalue<integer>('idtipomovimentacao', 0);
      servico.entrada:= body.getvalue<Double>('entrada', 0);
      servico.saida:= body.getvalue<Double>('saida', 0);
      servico.balanco:= body.getvalue<Double>('balanco', 0);
      servico.idsolicitacao:= body.getvalue<integer>('idsolicitacao', 0);
      servico.idproduto:= body.getvalue<integer>('idproduto', 0);
      servico.evento := body.getvalue<string>('evento', '');

      if servico.Atendesolicitacao(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idsolicitacao)).Status(THTTPStatus.Created)
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

procedure Editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tsolicitacao;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tsolicitacao.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcolaborador := body.getvalue<integer>('idusuario', 0);
      servico.idsolicitacao := body.getvalue<integer>('idsolicitacao', 0);
      servico.obra := body.getvalue<string>('numero', '');
      servico.idusuario := body.getvalue<integer>('idusuario', 0);
      servico.observacao := body.getvalue<string>('observacao', '');
      servico.datasolicitacao := body.getvalue<string>('currentDate', '');
      servico.projeto := body.getvalue<string>('projetousual', '');
      if servico.Editar(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idsolicitacao)).Status(THTTPStatus.Created)
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

procedure Editardiaria(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tsolicitacao;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tsolicitacao.Create;
  try
    try
      body := Req.body<TJSONObject>;

      servico.numero := body.getvalue<integer>('idsolicitacao', 0);
      servico.datasolicitacao := body.getvalue<string>('datasol', '');
      servico.colaborador := body.getvalue<string>('idcolaboradorclt', '');
      servico.projeto := body.getvalue<string>('projeto', '');
      servico.siteid := body.getvalue<string>('siteid', '');
      servico.siglasite := body.getvalue<string>('siglasite', '');
      servico.podiaria := body.getvalue<string>('po', '');
      servico.local := body.getvalue<string>('local', '');
      servico.descricao := body.getvalue<string>('descricao', '');
      servico.cliente := body.getvalue<string>('cliente', '');
      servico.valoroutrassolicitacoes := body.getvalue<double>('valorsolicitacao',0);
      servico.diarias := body.getvalue<integer>('diaria', 0);
      servico.valortotal := body.getvalue<double>('total',0);
      servico.solicitante := body.getvalue<string>('solicitante', '');

      if servico.Editardiaria(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idsolicitacao)).Status(THTTPStatus.Created)
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


procedure EditarItens(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tsolicitacao;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tsolicitacao.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idsolicitacaoitens := body.getvalue<integer>('idsolicitacaoitens', 0);
      servico.idsolicitacao := body.getvalue<integer>('idsolicitacao', 0);
      servico.idproduto := body.getvalue<integer>('idproduto', 0);
      servico.quantidade := body.getvalue<double>('quantidade', 0);
      servico.idusuario := body.getvalue<integer>('idusuario', 0);
      if servico.EditarItens(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idsolicitacao)).Status(THTTPStatus.Created)
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

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tsolicitacao;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tsolicitacao.Create;
  try
    try
      body := Req.body<TJSONObject>;
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idsolicitacao)).Status(THTTPStatus.Created)
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

procedure novocadastrodiaria(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tsolicitacao;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tsolicitacao.Create;
  try
    try
      body := Req.body<TJSONObject>;
      if servico.NovoCadastrodiaria(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idsolicitacaodiaria)).Status(THTTPStatus.Created)
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
  servico: Tsolicitacao;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tsolicitacao.Create;
  try
    try
      body := Req.body<TJSONObject>;
      if servico.novocadastroitens(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idsolicitacaoitens)).Status(THTTPStatus.Created)
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

procedure Listaiditens(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tsolicitacao;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := Tsolicitacao.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaiditens(Req.Query.Dictionary, erro);
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

procedure Listaidlista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tsolicitacao;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := Tsolicitacao.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaidlista(Req.Query.Dictionary, erro);
  try
    try
      arraydados := qry.ToJSONObject();
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
  servico: Tsolicitacao;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := Tsolicitacao.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaid(Req.Query.Dictionary, erro);
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
  servico: Tsolicitacao;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := Tsolicitacao.Create;
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

procedure Listasolicitacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tsolicitacao;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := Tsolicitacao.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listasolicitacao(Req.Query.Dictionary, erro);
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

procedure Listarequisicao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tsolicitacao;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := Tsolicitacao.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listarequisicao(Req.Query.Dictionary, erro);
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

end.


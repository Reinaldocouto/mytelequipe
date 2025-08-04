unit Controller.Projetotelefonica;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Projetotelefonica, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure emailadicional(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listapmts(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listacodt2(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listat2(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Editart2(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaconsolidado(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listapacotes(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listatarefas(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listapo(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaiddocumentacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salvaacionamentopj(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salvaacionamentoclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salvatarefas(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaatividadepj(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure listalpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure listaacompanhamentofinanceiro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure listaatividade(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure listaacionamentopj(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure listaacionamentoclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salvar(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listafechamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaparadocumentacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listafechamentoporempresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Editarpagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure historicopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure extratopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure extratodesconto(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure extratopagamentototal(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure rollouttelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure totalacionamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaacionamentos(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaacionamentosf(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure ListaSelectpjtelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure marcadorestelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure marcadorestelefonicaatrasado(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure graficosituacoes(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure diaria(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salvapagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listastatuspmts(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure regionaltelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure listaidpmts(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure apagarpagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure editartarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salvadesconto(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/projetotelefonica', Lista);
  THorse.get('v1/projetotelefonicapo', Listapo);
  THorse.get('v1/projetotelefonicaid', Listaid);
  THorse.get('v1/projetotelefonica/tarefas', Listatarefas);
  THorse.post('v1/projetotelefonica/tarefas', salvatarefas);
  THorse.Post('v1/projetotelefonica/novocadastro', novocadastro);
  THorse.post('v1/projetotelefonica/acionamentopj', Salvaacionamentopj);
  THorse.post('v1/projetotelefonica/acionamentoclt', Salvaacionamentoclt);
  THorse.post('v1/projetotelefonica', editar);
  THorse.get('v1/projetotelefonica/listaatividadepj', Listaatividadepj);
  THorse.get('v1/projetotelefonica/listalpu', listalpu);
  THorse.get('v1/projetotelefonica/listaacionamentopj', listaacionamentopj);
  THorse.get('v1/projetotelefonica/listaacionamentoclt', listaacionamentoclt);
  THorse.get('v1/projetotelefonica/fechamento', Listafechamento);
  THorse.get('v1/projetotelefonica/fechamentoporempresa', ListaFechamentoporempresa);
  THorse.post('v1/projetotelefonica/fechamento/salvapagamento', Editarpagamento);
  THorse.get('v1/projetotelefonica/documentacao', Listaparadocumentacao);
  //THorse.get('v1/projetotelefonica/historicopagamento', historicopagamento);
  THorse.get('v1/projetotelefonicaid/extrato', extratopagamento);
  THorse.get('v1/projetotelefonica/extratodesconto', extratodesconto);
  THorse.get('v1/projetotelefonicaid/extratototal', extratopagamentototal);
  THorse.get('v1/rollouttelefonica', rollouttelefonica);
  THorse.get('v1/projetotelefonica/totalacionamento', totalacionamento);
  THorse.get('v1/projetotelefonica/pmts', Listapmts);
  THorse.get('v1/projetotelefonica/consolidado', Listaconsolidado);
  THorse.get('v1/projetotelefonica/acompanhamentofinanceiro', Listaacompanhamentofinanceiro);
  THorse.get('v1/projetotelefonica/listaatividade', listaatividade);
  THorse.get('v1/projetotelefonica/pacotes/:ihistorico', Listapacotes);
  THorse.get('v1/projetotelefonica/listacodt2', listacodt2);
  THorse.post('v1/projetotelefonica/gerardt2', Editart2);
  THorse.get('v1/projetotelefonica/listat2', listat2);
  THorse.get('v1/projetotelefonica/emailadicional', emailadicional);
  THorse.get('v1/projetotelefonica/listaacionamentos', Listaacionamentos);
  THorse.get('v1/projetotelefonica/listaSelectpjtelefonica', ListaSelectpjtelefonica);
  THorse.get('v1/projetotelefonica/listaacionamentosf', Listaacionamentosf);
  THorse.get('v1/projetotelefonica/marcadorestelefonica', marcadorestelefonica);
  THorse.get('v1/projetotelefonica/marcadorestelefonicaatrasado', marcadorestelefonicaatrasado);
  THorse.get('v1/projetotelefonica/graficosituacoes', graficosituacoes);
  THorse.get('v1/projetotelefonica/diaria', diaria);
  THorse.post('v1/projetotelefonica/salvapagamento', salvapagamento);
  THorse.get('v1/projetotelefonica/statuspmts', Listastatuspmts);
  THorse.get('v1/projetotelefonica/statuspmts', Listastatuspmts);
  THorse.get('v1/projetotelefonica/regionaltelefonica', regionaltelefonica);
  THorse.get('v1/projetotelefonica/listaidpmts', listaidpmts);
  THorse.post('v1/projetotelefonica/fechamento/apagapagamento', apagarpagamento);
  THorse.get('v1/projetotelefonica/listaacionamentoshistorico', historicopagamento);
  THorse.post('v1/projetotelefonica/editartarefa', editartarefa);
  THorse.post('v1/projetotelefonica/salvadesconto', salvadesconto);
end;


procedure listaidpmts(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.listaidpmts(Req.Query.Dictionary, erro);
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


procedure Listastatuspmts(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listastatuspmts(Req.Query.Dictionary, erro);
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

procedure marcadorestelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro,a: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;

  qry := servico.marcadorestelefonica(Req.Query.Dictionary, erro);
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


procedure extratodesconto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.extratodesconto(Req.Query.Dictionary, erro);
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

procedure marcadorestelefonicaatrasado(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.marcadorestelefonicaatrasado(Req.Query.Dictionary, erro);
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

procedure graficosituacoes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.graficosituacoes(Req.Query.Dictionary, erro);
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



procedure apagarpagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  JSONBody: TJSONObject;
  erro: string;
begin
  servico := TProjetotelefonica.Create;
  try
    erro := '';
    try
      // Lê o body como JSON
      JSONBody := Req.Body<TJSONObject>;

      // Chama o método com os dados do body (não da query string!)
      if servico.apagarpagamento(JSONBody, erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.numero)).Status(THTTPStatus.Created)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);

    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;


procedure regionaltelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.regionaltelefonicast(Req.Query.Dictionary, erro);
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

procedure diaria(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.diaria(Req.Query.Dictionary, erro);
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

procedure ListaSelectpjtelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaSelectpjtelefonica(Req.Query.Dictionary, erro);
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

procedure Listaacionamentos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaacionamentos(Req.Query.Dictionary, erro);
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

procedure Listaacionamentosf(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaacionamentosf(Req.Query.Dictionary, erro);
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

procedure totalacionamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.totalacionamento(Req.Query.Dictionary, erro);
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

procedure extratopagamentototal(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Extratopagamentototal(Req.Query.Dictionary, erro);
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

procedure emailadicional(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.regionaltelefonica(Req.Query.Dictionary, erro);
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


procedure extratopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.extratopagamento(Req.Query.Dictionary, erro);
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

procedure rollouttelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.rollouttelefonica(Req.Query.Dictionary, erro);
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

procedure historicopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaacionamentosfhistorico(Req.Query.Dictionary, erro);
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

procedure ListaFechamentoporempresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaFechamentoporempresa(Req.Query.Dictionary, erro);
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

procedure salvapagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetotelefonica.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.mesfechamento := body.getvalue<string>('mespagamento', '');
      servico.dataenviofechamento := body.getvalue<string>('dataenviofechamento', '');
      servico.idgeralfechamento := body.getvalue<integer>('idacionamentovivo', 0);
      servico.porcentagem := body.getvalue<integer>('porcentagem', 0);
      servico.valor := body.getvalue<double>('valor', 0);
      servico.tipopagamento := body.getvalue<string>('tipopagamento', '');
      servico.diapagamento := body.getvalue<string>('diapagamento', '');
      if Length(servico.mesfechamento) = 0 then
        erro := 'Falta selecionar o mes de pagamento!';
      if Length(servico.diapagamento) = 0 then
        erro := 'Falta selecionar o dia referencia do pagamento!';

      if Length(erro) = 0 then
      begin
        if servico.salvapagamento(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.iddescricaocod)).Status(THTTPStatus.Created)
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


procedure salvadesconto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetotelefonica.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;
      servico.mesfechamento := body.getvalue<string>('mespg', '');
      servico.valor := body.getvalue<double>('desconto', 0);
      servico.tipopagamento := body.getvalue<string>('tpagamento', '');
      servico.diapagamento := body.getvalue<string>('dpagamento', '');
      servico.idcolaboradorpj := body.getvalue<integer>('idempresalocal', 0);
      servico.idusuario := body.getvalue<string>('idusuario', '');
      if Length(erro) = 0 then
      begin
        if servico.salvadesconto(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.iddescricaocod)).Status(THTTPStatus.Created)
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


procedure editartarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetotelefonica.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.regiao := body.getvalue<string>('regiaolocal', '');
      servico.regionalocal := body.getvalue<string>('regionalocal', '');
      servico.brevedescricao := body.getvalue<string>('brevedescricao', '');
      servico.idusuario := body.getvalue<string>('idusuario', '');

      if Length(erro) = 0 then
      begin
        if servico.editartarefa(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.iddescricaocod)).Status(THTTPStatus.Created)
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

procedure Editarpagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetotelefonica.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.mesfechamento := body.getvalue<string>('fechamento', '');
      servico.dataenviofechamento := body.getvalue<string>('dataenviofechamento', '');
      servico.idgeralfechamento := body.getvalue<integer>('idfechamento', 0);
      servico.porcentagem := body.getvalue<integer>('porcentagem', 0);
      servico.valor := body.getvalue<double>('valor', 0);
      if Length(servico.mesfechamento) = 0 then
        erro := 'Falta selecionar o mes de pagamento!';

      if Length(erro) = 0 then
      begin

        if (servico.consultapagamento) then
        begin
          if servico.Editarpagamento(erro) then
            Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.numero)).Status(THTTPStatus.Created)
          else
            Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
        end
        else
        begin

          if (servico.repostaalteracao = 1) then
          begin
            if servico.editarpagamento(erro) then
              Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.numero)).Status(THTTPStatus.Created)
            else
              Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
          end
          else
            Res.Send<TJSONObject>(CreateJsonObj('erro', 'Já existe pagamento nesse periodo')).Status(THTTPStatus.BadRequest);

        end;
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

procedure Editart2(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetotelefonica.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.iddescricaocod := body.getvalue<string>('iddescricaocod', '');
      servico.quantidade := body.getvalue<double>('quantidade', 0);
      servico.obra := body.getvalue<string>('obra', '');
      servico.site := body.getvalue<string>('site', '');
      servico.idpmts := body.getvalue<string>('idmpts', '');
      servico.idusuario := body.getvalue<string>('idusuario', '');

      if Length(erro) = 0 then
      begin
        if servico.Editart2(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.iddescricaocod)).Status(THTTPStatus.Created)
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

procedure Listaacompanhamentofinanceiro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaacompanhamentofinanceiro(Req.Query.Dictionary, erro);
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

procedure Listaatividade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaatividade(Req.Query.Dictionary, erro);
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

procedure Listaatividades(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaatividades(Req.Query.Dictionary, erro);
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

procedure Listapacotes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  servico.historico := Req.Params['ihistorico'];
  qry := servico.Listapacotes(Req.Query.Dictionary, erro);
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

procedure Listafechamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaFechamento(Req.Query.Dictionary, erro);
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

procedure Listaparadocumentacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaparadocumentacao(Req.Query.Dictionary, erro);
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

procedure Listaacionamentopj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.listaacionamentopj(Req.Query.Dictionary, erro);
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

procedure Listaacionamentoclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.listaacionamentoclt(Req.Query.Dictionary, erro);
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

procedure Listatarefas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.listatarefas(Req.Query.Dictionary, erro);
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

procedure listacodt2(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.listacodt2(Req.Query.Dictionary, erro);
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

procedure listat2(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.listat2(Req.Query.Dictionary, erro);
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

procedure Listalpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  //servico.idcolaboradorpj := Req.Params['idc'].ToInteger;
  qry := servico.Listalpu(Req.Query.Dictionary, erro);
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

procedure Listaatividadepj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaatividadepj(Req.Query.Dictionary, erro);
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

procedure salvatarefas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  body: TJSONValue;
  JSONArray: TJSONArray;
  JSONObj: TJSONObject;
  JSONItem: TJSONValue;
  erro, retorno: string;
  i: integer;
begin
  servico := TProjetotelefonica.Create;
  try
    erro := '';
    retorno := '';
    try
      // Lê o corpo da requisição como TJSONObject
      body := Req.Body<TJSONObject>;
      servico.sitename := body.GetValue<string>('sitename', '');
      servico.sitenamefrom := body.GetValue<string>('sitenamefrom', '');
      servico.estado := body.GetValue<string>('estado', '');
      servico.siteid := body.GetValue<string>('siteid', '');

      // Lê o array de objetos (se existir)
      if body.TryGetValue<TJSONArray>('tarefas', JSONArray) then
      begin
        for i := 0 to JSONArray.Count - 1 do
        begin
          JSONObj := JSONArray.Items[i] as TJSONObject;

          try
          // Acessar os campos de cada item do array
            servico.ztecode := JSONObj.GetValue<string>('ztecode', '');
            servico.descricaoservico := JSONObj.GetValue<string>('servicedescription', '');
            servico.qtd := JSONObj.GetValue<double>('qtd', 0);
            servico.region := JSONItem.GetValue<string>('region', '');


          // Validar e salvar cada item
            if not servico.salvartarefa(erro) then
            begin
              erro := Format('Erro ao salvar tarefa com número "%s": %s', [servico.numero, erro]);
              Break;
            end;

          // Adicionar o ID do serviço salvo à resposta de sucesso
            if retorno <> '' then
              retorno := retorno + ', ';
            retorno := retorno + servico.id;
          except
            on ex: Exception do
            begin
              erro := Format('Erro ao processar tarefa com número "%s": %s', [servico.numero, ex.Message]);
              Break;
            end;
          end;


          // Processa cada objeto do array
          // Exemplo: JSONObj.GetValue<string>('campo') ou armazena em outra estrutura
          // Aqui você pode adicionar lógica para armazenar ou processar os dados
        end;
      end;


      // Retornar a resposta apropriada
      if erro = '' then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', retorno)).Status(THTTPStatus.Created)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);

    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

procedure editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  body: TJSONValue;
  JSONArray: TJSONArray;
  JSONObj: TJSONObject;
  JSONItem: TJSONValue;
  erro, retorno: string;
  i: integer;
begin
  servico := TProjetotelefonica.Create;
  try
    erro := '';
    retorno := '';
    try
      // Lê o corpo da requisição como TJSONObject
      body := Req.body<tjsonobject>;
      servico.infra := body.getvalue<string>('infra', '');
      servico.infravivo := body.getvalue<string>('infraviv', '');
      servico.acessoatividade := body.getvalue<string>('acessoatividade', '');
      servico.acessocomentario := body.getvalue<string>('acessocomentario', '');
      servico.acessooutros := body.getvalue<string>('acessooutros', '');
      servico.acessoformaacesso := body.getvalue<string>('acessoformaacesso', '');
      servico.ddd := body.getvalue<string>('ddd', '');
      servico.cidade := body.getvalue<string>('cidade', '');
      servico.nomedosite := body.getvalue<string>('nomedosite', '');
      servico.endereco := body.getvalue<string>('endereco', '');
      servico.latitude := body.getvalue<string>('latitude', '');
      servico.longitude := body.getvalue<string>('longitude', '');
      servico.acessoobs := body.getvalue<string>('acessoobs', '');
      servico.acessodatainicial := body.getvalue<string>('acessodatainicial', '');
      servico.acessodatafinal := body.getvalue<string>('acessodatafinal', '');
      servico.acessodatasolicitacao := body.getvalue<string>('acessodatasolicitacao', '');
      servico.acessosolicitacao := body.getvalue<string>('acessosolicitacao', '');
      servico.entregaplan := body.getvalue<string>('entregaplan', '');
      servico.entregareal := body.getvalue<string>('entregareal', '');
      servico.fiminstalacaoplan := body.getvalue<string>('fiminstalacaoplan', '');
      servico.fiminstalacaoreal := body.getvalue<string>('fiminstalacaoreal', '');
      servico.integracaoplan := body.getvalue<string>('integracaoplan', '');
      servico.integracaoreal := body.getvalue<string>('integracaoreal', '');
      servico.ativacao := body.getvalue<string>('ativacao', '');
      servico.documentacao := body.getvalue<string>('documentacao', '');
      servico.dtplan := body.getvalue<string>('dtplan', '');
      servico.dtreal := body.getvalue<string>('dtreal', '');
      servico.statusobra := body.getvalue<string>('statusobra', '');
      servico.docaplan := body.getvalue<string>('docaplan', '');
      servico.ov := body.getvalue<string>('ov', '');
      servico.uididcpomrf := body.getvalue<string>('uididcpomrf', '');
      servico.resumodafase := body.getvalue<string>('resumodafase', '');
      servico.rollout := body.getvalue<string>('rollout', '');
      servico.vistoriaplan := body.getvalue<string>('vistoriaplan', '');
      servico.vistoriareal := body.getvalue<string>('vistoriareal', '');
      servico.docplan := body.getvalue<string>('docplan', '');
      servico.docvitoriareal := body.getvalue<string>('docvitoriareal', '');
      servico.req := body.getvalue<string>('req', '');
      servico.acompanhamentofisicoobservacao := body.getvalue<string>('acompanhamentofisicoobservacao', '');
      servico.equipe := body.getvalue<string>('equipe', '');
      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.UIDIDCPOMRF)).Status(THTTPStatus.Created)
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

procedure salvaacionamentopj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  body: TJSONValue;
  JSONArray: TJSONArray;
  JSONObj: TJSONObject;
  JSONItem: TJSONValue;
  erro, retorno: string;
  i: integer;
begin
  servico := TProjetotelefonica.Create;
  try
    erro := '';
    retorno := '';
    try
      // Lê o corpo da requisição como TJSONObject
      body := Req.Body<TJSONObject>;
      servico.idrollout := body.GetValue<integer>('idrollout', 0);
      servico.idatividade := body.GetValue<integer>('idatividade', 0);
      servico.idpacote := body.GetValue<integer>('idpacote', 0);
      servico.idcolaborador := body.GetValue<integer>('idcolaborador', 0);
      servico.idpmts := body.GetValue<string>('idpmts', '');
      servico.lpuhistorico := body.GetValue<string>('lpuhistorico', '');
      servico.idfuncionario := body.GetValue<integer>('idfuncionario', 0);
      servico.observacaopj := body.GetValue<string>('observacaopj', '');
      servico.quantidade := body.GetValue<integer>('quantidade', 0);
      servico.valornegociado := body.GetValue<double>('valornegociado', 0);
      if servico.quantidade = 0 then
        servico.quantidade := 1;

      if Length(erro) = 0 then
      begin
        if servico.salvaacionamentopj(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idgeral)).Status(THTTPStatus.Created)
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

procedure salvaacionamentoclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  body: TJSONValue;
  JSONArray: TJSONArray;
  JSONObj: TJSONObject;
  JSONItem: TJSONValue;
  erro, retorno: string;
  i: integer;
  xData: string;
begin
  servico := TProjetotelefonica.Create;
  try
    erro := '';
    retorno := '';
    try
      // Lê o corpo da requisição como TJSONObject
      body := Req.Body<TJSONObject>;
      servico.idrollout := body.GetValue<integer>('idrollout', 0);
      servico.idatividade := body.GetValue<integer>('idatividade', 0);
      servico.idcolaborador := body.GetValue<integer>('idcolaborador', 0);
      servico.idpmts := body.GetValue<string>('idpmts', '');
      servico.idfuncionario := body.GetValue<integer>('idfuncionario', 0);
      servico.atividade := body.GetValue<string>('atividade', '');
      servico.datainicioclt := body.GetValue<string>('datainicioclt', '');
      servico.datafinalclt := body.GetValue<string>('datafinalclt', '');

      servico.totalhorasclt := body.GetValue<double>('totalhorasclt', 0);
      servico.observacaoclt := body.GetValue<string>('observacaoclt', '');
      servico.horanormalclt := body.GetValue<double>('horanormalclt', 0);
      servico.hora50clt := body.GetValue<double>('hora50clt', 0);
      servico.hora100clt := body.GetValue<double>('hora100clt', 0);

      if Length(erro) = 0 then
      begin
        if servico.salvaacionamentoclt(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idgeral)).Status(THTTPStatus.Created)
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

procedure Salvar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  body: TJSONValue;
  JSON: TJSONObject;
  erro, xData: string;
begin
  servico := TProjetotelefonica.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.os := body.getvalue<string>('os', '');
      servico.projeto := body.getvalue<string>('projeto', '');
      servico.supervisor := body.getvalue<string>('supervisor', '');
      servico.concentrador := body.getvalue<string>('concentrador', '');
      servico.tiposite := body.getvalue<string>('tiposite', '');
      xData := body.GetValue<string>('installplan', '');
      if xData <> '' then
      try
        servico.installplan := StrToDate(xData);
      except
        servico.installplan := StrToDate('30/12/1899');
      end;
      xData := body.GetValue<string>('installreal', '');
      if xData <> '' then
      try
        servico.installreal := StrToDate(xData);
      except
        servico.installreal := StrToDate('30/12/1899');
      end;
      servico.statusprojeto := body.getvalue<string>('statusprojeto', '');
      xData := body.GetValue<string>('gerenciaplan', '');
      if xData <> '' then
      try
        servico.gerenciaplan := StrToDate(xData);
      except
        servico.gerenciaplan := StrToDate('30/12/1899');
      end;
      xData := body.GetValue<string>('gerenciareal', '');
      if xData <> '' then
      try
        servico.gerenciareal := StrToDate(xData);
      except
        servico.gerenciareal := StrToDate('30/12/1899');
      end;
      servico.mos := body.getvalue<string>('mos', '');
      servico.mosresp := body.getvalue<string>('mosresp', '');
      servico.compliance := body.getvalue<string>('compliance', '');
      servico.complianceresp := body.getvalue<string>('complianceresp', '');
      servico.ehs := body.getvalue<string>('ehs', '');
      servico.ehsresp := body.getvalue<string>('ehsresp', '');
      servico.qualidade := body.getvalue<string>('qualidade', '');
      servico.qualidaderesp := body.getvalue<string>('qualidaderesp', '');
      servico.pdi := body.getvalue<string>('pdi', '');
      servico.pdiresp := body.getvalue<string>('pdiresp', '');
      servico.statusdoc := body.getvalue<string>('statusdoc', '');
      servico.observacaodoc := body.getvalue<string>('observacaodoc', '');
      servico.observacao := body.getvalue<string>('observacao', '');
      servico.po := body.getvalue<string>('po', '');
      servico.sitenamefrom := body.getvalue<string>('sitenamefrom', '');
      servico.docresp := body.getvalue<string>('docresp', '');

      if Length(erro) = 0 then
      begin
        if servico.editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idgeral)).Status(THTTPStatus.Created)
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

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetotelefonica.Create;
  try
    try
      body := Req.body<TJSONObject>;
      if servico.NovoCadastro(erro) <> '0' then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.id)).Status(THTTPStatus.Created)
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
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
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

procedure Listapmts(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listapmts(Req.Query.Dictionary, erro);
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

procedure Listaconsolidado(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaconsolidado(Req.Query.Dictionary, erro);
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

procedure Listapo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listapo(Req.Query.Dictionary, erro);
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
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
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

procedure Listaiddocumentacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaiddocumentacao(Req.Query.Dictionary, erro);
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


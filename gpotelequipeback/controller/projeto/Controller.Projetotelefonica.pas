unit Controller.Projetotelefonica;

interface

uses
  Winapi.ActiveX, ComObj,
  System.NetEncoding,
  Horse.Commons,
  System.IOUtils, System.Classes,
   Variants,
   System.DateUtils,
  Horse, System.JSON, System.Generics.Collections, System.SysUtils, FireDAC.Comp.Client, Data.DB, Model.Email,
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

procedure listaacionamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

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

procedure verificarduplicidaderollout(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure adicionarsitemanual(Req: THorseRequest; Res: THorseResponse; Next: TProc);

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

procedure ListPrevisaoFechamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure dashboardtelefonicaposicionamentofinanceiro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure historicopagamentogeral(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure EditarEmMassa(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure ListaDespesas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure listat4(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GerarTaf(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure AtualizarEmFaturamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure SalvarNotaFiscal(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GerarT4Excel(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GerarT4CSV(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure excluirsitemanual(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure marcaravulso(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure desmarcarComoAvulso(Req: THorseRequest; Res: THorseResponse; Next: TProc);

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
  THorse.get('v1/projetotelefonica/listaacionamento', listaacionamento);
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
  THorse.get('v1/rollouttelefonica/verificarduplicidade', verificarduplicidaderollout);
  THorse.post('v1/rollouttelefonica/adicionarmanual', adicionarsitemanual);
  THorse.get('v1/projetotelefonica/totalacionamento', totalacionamento);
  THorse.get('v1/projetotelefonica/pmts', Listapmts);
  THorse.get('v1/projetotelefonica/consolidado', Listaconsolidado);
  THorse.get('v1/projetotelefonica/acompanhamentofinanceiro', Listaacompanhamentofinanceiro);
  THorse.get('v1/projetotelefonica/listaatividade', listaatividade);
  THorse.get('v1/projetotelefonica/pacotes/:ihistorico', Listapacotes);
  THorse.get('v1/projetotelefonica/listacodt2', listacodt2);
  THorse.post('v1/projetotelefonica/gerardt2', Editart2);
  THorse.get('v1/projetotelefonica/listat2', listat2);
  THorse.get('v1/projetotelefonica/listat4', listat4);
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
  THorse.post('v1/projetotelefonica/gerartaf', GerarTaf);
  THorse.post('v1/projetotelefonica/emfaturamento', AtualizarEmFaturamento);
  THorse.post('v1/projetotelefonica/salvarnotafiscal', SalvarNotaFiscal);

  THorse.get('v1/projetotelefonica/previsaofechamento', ListPrevisaoFechamento);

  THorse.get('v1/projetotelefonica/dashboardtelefinicatiporatividades', dashboardtelefonicaposicionamentofinanceiro);
  THorse.get('v1/projetotelefonica/historicofechamento', historicopagamentogeral);
  THorse.Get('v1/gerart4excel', GerarT4Excel);
  THorse.Get('v1/gerart4csv', GerarT4CSV);

  THorse.get('v1/projetotelefonica/ListaDespesas', Listadespesas);
  THorse.post('v1/projetotelefonica/editaremmassa', EditarEmMassa);
  THorse.get('v1/projetotelefonica/verificarduplicidaderollout', verificarduplicidaderollout);
  THorse.post('v1/projetotelefonica/adicionarsitemanual', adicionarsitemanual);
  THorse.post('v1/projetotelefonica/excluirsitemanual/:id', excluirsitemanual);
  THorse.post('v1/projetotelefonica/marcaravulso', marcaravulso);
  THorse.post('v1/projetotelefonica/desmarcarComoAvulso', desmarcarComoAvulso);
end;

procedure excluirsitemanual(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  erro: string;
  idSite: string;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  
  try
    idSite := Req.Params['UIDIDPMTS'];
    
    if idSite = '' then
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'ID do site é obrigatório')).Status(400);
      exit;
    end;
    
    if servico.excluirsitemanual(idSite, erro) then
      Res.Send<TJSONObject>(CreateJsonObj('sucesso', 'Site manual excluído com sucesso')).Status(200)
    else
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(500);
  except
    on E: Exception do
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro interno: ' + E.Message)).Status(500);
  end;
  
  servico.Free;
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

procedure dashboardtelefonicaposicionamentofinanceiro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  jsonArray: TJSONArray;
  jsonObj: TJSONObject;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    on E: Exception do
    begin
      Res.Send<TJSONObject>(TJSONObject.Create(TJSONPair.Create('erro', 'Erro ao conectar com o banco: ' + E.Message)))
        .Status(THTTPStatus.InternalServerError);
      Exit;
    end;
  end;

  qry := servico.dashboardtelefonicaposicionamentofinanceiro(Req.Query.Dictionary, erro);
  try
    if Assigned(qry) then
    begin
      try
        jsonArray := TJSONArray.Create;

        if not qry.IsEmpty then
        begin
          qry.First;
          while not qry.Eof do
          begin
            jsonObj := TJSONObject.Create;

            // Adiciona todos os campos ao objeto JSON
            jsonObj.AddPair('TipoAtividade', qry.FieldByName('TipoAtividade').AsString);
            jsonObj.AddPair('PO_Preenchido', TJSONNumber.Create(qry.FieldByName('PO_Preenchido').AsInteger));
            jsonObj.AddPair('TIV_Emitidas', TJSONNumber.Create(qry.FieldByName('TIV_Emitidas').AsInteger));
            jsonObj.AddPair('TII_Emitidas', TJSONNumber.Create(qry.FieldByName('TII_Emitidas').AsInteger));
            jsonObj.AddPair('Carta_TAF_Emitida', TJSONNumber.Create(qry.FieldByName('Carta_TAF_Emitida').AsInteger));
            jsonObj.AddPair('TotalItens', TJSONNumber.Create(qry.FieldByName('TotalItens').AsInteger));
            jsonObj.AddPair('totalPMTS', TJSONNumber.Create(qry.FieldByName('totalPMTS').AsInteger));

            jsonArray.AddElement(jsonObj);
            qry.Next;
          end;
        end;

        if erro = '' then
        begin
          if jsonArray.Count > 0 then
            Res.Send<TJSONArray>(jsonArray).Status(THTTPStatus.OK)
          else
            Res.Send<TJSONObject>(TJSONObject.Create(TJSONPair.Create('aviso', 'Nenhum dado encontrado')))
              .Status(THTTPStatus.OK);
        end
        else
        begin
          jsonArray.Free;
          Res.Send<TJSONObject>(TJSONObject.Create(TJSONPair.Create('erro', erro)))
            .Status(THTTPStatus.InternalServerError);
        end;
      except
        on E: Exception do
        begin
          if Assigned(jsonArray) then
            jsonArray.Free;
          Res.Send<TJSONObject>(TJSONObject.Create(TJSONPair.Create('erro', 'Erro ao processar dados: ' + E.Message)))
            .Status(THTTPStatus.InternalServerError);
        end;
      end;
    end
    else
    begin
      Res.Send<TJSONObject>(TJSONObject.Create(TJSONPair.Create('erro', erro)))
        .Status(THTTPStatus.InternalServerError);
    end;
  finally
    if Assigned(qry) then
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


procedure EditarEmMassa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  erro: string;
  sucesso: Boolean;
  body: string;

begin
  try
    servico := TProjetotelefonica.Create;
    try
      body := Req.Body;

      if body.Trim = '' then
      begin
        erro := 'body vazio';
        Exit;
      end;

      sucesso := servico.EditarEmMassa(body, erro);

      if sucesso then
      begin

        Res.Send<TJSONObject>(
          TJSONObject.Create
            .AddPair('sucesso', 'true')
            .AddPair('mensagem', 'Registros atualizados com sucesso')
        ).Status(THTTPStatus.OK);
      end
      else
      begin
        // Retorna erro específico da operação
        Res.Send<TJSONObject>(
          TJSONObject.Create
            .AddPair('sucesso', 'false')
            .AddPair('erro', erro)
        ).Status(THTTPStatus.BadRequest);
      end;
    except
      on E: Exception do
      begin
        // Retorna erro inesperado
        Res.Send<TJSONObject>(
          TJSONObject.Create
            .AddPair('sucesso', 'false')
            .AddPair('erro', 'Erro inesperado: ' + E.Message)
        ).Status(THTTPStatus.InternalServerError);
      end;
    end;
  finally
    if Assigned(servico) then
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


procedure historicopagamentogeral(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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
  qry := servico.Listaacionamentoshistoricopagamento(Req.Query.Dictionary, erro);
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
      servico.observacao := body.getvalue<string>('observacao', '');
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

procedure Listaacionamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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
  qry := servico.Listaacionamento(Req.Query.Dictionary, erro);
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

procedure GerarTaf(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  numeroTAF, erro: string;
  resultado: TJSONObject;
  sucesso: Boolean;
  dadosDict: TDictionary<string, string>;
  jsonBody: TJSONObject;
  pair: TJSONPair;
  nomeArquivo: String;
begin
  resultado := nil;
  servico := TProjetotelefonica.Create;
  dadosDict := TDictionary<string, string>.Create;
  try
    try
      jsonBody := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
      if Assigned(jsonBody) then
      begin
        for pair in jsonBody do
          dadosDict.Add(pair.JsonString.Value, pair.JsonValue.Value);
      end
      else
      begin
        resultado := TJSONObject.Create;
        resultado.AddPair('erro', 'JSON de entrada inválido ou ausente.');
        Res.Send<TJSONObject>(resultado).Status(THTTPStatus.BadRequest);
        Exit;
      end;

      sucesso := servico.RegistrarCartaTAF(dadosDict, erro, NomeArquivo);
      if sucesso then
      begin
        resultado := TJSONObject.Create;
        resultado.AddPair('status', 'sucesso');
        resultado.AddPair('numeroTAF', nomeArquivo);
        Res.Send<TJSONObject>(resultado).Status(THTTPStatus.OK);
      end
      else
      begin
        resultado := TJSONObject.Create;
        resultado.AddPair('erro', erro);
        Res.Send<TJSONObject>(resultado).Status(THTTPStatus.InternalServerError);
      end;
    except
      on ex: Exception do
      begin
        if Assigned(resultado) then
          resultado.Free;
        resultado := TJSONObject.Create;
        resultado.AddPair('erro', ex.Message);
        Res.Send<TJSONObject>(resultado).Status(THTTPStatus.InternalServerError);
      end;
    end;
  finally
    servico.Free;
    dadosDict.Free;
    jsonBody.Free;
  end;
end;


procedure AtualizarEmFaturamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  erro: string;
  BodyJSON: TJSONObject;
  sucesso: Boolean;
  resultado: TJSONObject;

begin
  servico := TProjetotelefonica.Create;

  try
    try
      BodyJSON := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
      // Tenta atualizar para "Em Faturamento"
      sucesso := servico.AtualizarParaEmFaturamento(BodyJSON, erro);


      if sucesso then
      begin
        resultado := TJSONObject.Create
          .AddPair('sucesso', TJSONBool.Create(True))
          .AddPair('mensagem', 'Status atualizado para "Em Faturamento" com sucesso');
        Res.Send<TJSONObject>(resultado).Status(THTTPStatus.OK);
      end
      else
      begin
        resultado := TJSONObject.Create
          .AddPair('sucesso', TJSONBool.Create(False))
          .AddPair('erro', erro);
        Res.Send<TJSONObject>(resultado).Status(THTTPStatus.BadRequest);
      end;
    except
      on E: Exception do
      begin
        resultado := TJSONObject.Create
          .AddPair('sucesso', TJSONBool.Create(False))
          .AddPair('erro', 'Erro ao processar requisição: ' + E.Message);
        Res.Send<TJSONObject>(resultado).Status(THTTPStatus.InternalServerError);
      end;
    end;
  finally
    servico.Free;
  end;
end;



procedure SalvarNotaFiscal(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  erro: string;
  sucesso: Boolean;
  resultado: TJSONObject;
  jsonBody: TJSONObject;
begin
  servico := TProjetotelefonica.Create;
  try
    try
      // Pega o body e converte para JSON
      jsonBody := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
      try
        if not Assigned(jsonBody) then
        begin
          resultado := TJSONObject.Create
            .AddPair('sucesso', TJSONBool.Create(False))
            .AddPair('erro', 'Body da requisição não é um JSON válido');
          Res.Send<TJSONObject>(resultado).Status(THTTPStatus.BadRequest);
          Exit;
        end;

        // Chama seu serviço passando o body JSON
        sucesso := servico.SalvarNotaFiscalT4(jsonBody, erro);

        if sucesso then
        begin
          resultado := TJSONObject.Create
            .AddPair('sucesso', TJSONBool.Create(True))
            .AddPair('mensagem', 'Nota fiscal salva com sucesso');
          Res.Send<TJSONObject>(resultado).Status(THTTPStatus.OK);
        end
        else
        begin
          resultado := TJSONObject.Create
            .AddPair('sucesso', TJSONBool.Create(False))
            .AddPair('erro', erro);
          Res.Send<TJSONObject>(resultado).Status(THTTPStatus.BadRequest);
        end;
      finally
        jsonBody.Free; // libera o JSON do body
      end;
    except
      on E: Exception do
      begin
        resultado := TJSONObject.Create
          .AddPair('sucesso', TJSONBool.Create(False))
          .AddPair('erro', 'Erro ao processar requisição: ' + E.Message);
        Res.Send<TJSONObject>(resultado).Status(THTTPStatus.InternalServerError);
      end;
    end;
  finally
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



procedure listat4(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  jsonStr: string; // Variável auxiliar para debug
begin
  servico := nil;
  qry := nil;
  arraydados := nil;
  erro := '';

  try
    try
      servico := TProjetotelefonica.Create;
      qry := servico.listat4(Req.Query.Dictionary, erro);

      if not Assigned(qry) then
      begin
        if erro = '' then erro := 'Consulta não retornou dados';
        Res.Send<TJSONObject>(TJSONObject.Create.AddPair('erro', erro))
          .Status(THTTPStatus.InternalServerError);
        Exit;
      end;

      try
        // Converter para JSON e manter em variável temporária
        arraydados := qry.ToJSONArray();
        jsonStr := arraydados.ToString();

        // Debug seguro - limitar tamanho do log
        System.Writeln('JSON Size: ', arraydados.Count);
        System.Writeln('First 200 chars: ', Copy(jsonStr, 1, 200));

        if erro = '' then
        begin
          // Enviar resposta e LIBERAR IMEDIATAMENTE os recursos usados
          Res.Send<TJSONArray>(arraydados).Status(THTTPStatus.OK);
          arraydados := nil; // Impede que seja liberado no finally
        end
        else
        begin
          Res.Send<TJSONObject>(TJSONObject.Create.AddPair('erro', erro))
            .Status(THTTPStatus.InternalServerError);
        end;
      except
        on ex: Exception do
        begin
          erro := 'Erro ao converter dados: ' + ex.Message;
          Res.Send<TJSONObject>(TJSONObject.Create.AddPair('erro', erro))
            .Status(THTTPStatus.InternalServerError);
        end;
      end;
    except
      on ex: Exception do
      begin
        Res.Send<TJSONObject>(TJSONObject.Create.AddPair('erro', ex.Message))
          .Status(THTTPStatus.InternalServerError);
      end;
    end;
  finally
    // Liberação segura de recursos
    try
      if Assigned(arraydados) then
      begin
        System.Writeln('Liberando arraydados');
        arraydados.Free;
      end;
    except
      on ex: Exception do
        System.Writeln('Erro ao liberar arraydados: ', ex.Message);
    end;

    try
      if Assigned(qry) then
      begin
        System.Writeln('Liberando qry');
        FreeAndNil(qry);
      end;
    except
      on ex: Exception do
        System.Writeln('Erro ao liberar qry: ', ex.Message);
    end;

    try
      if Assigned(servico) then
      begin
        System.Writeln('Liberando serviço');
        FreeAndNil(servico);
      end;
    except
      on ex: Exception do
        System.Writeln('Erro ao liberar serviço: ', ex.Message);
    end;
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
      servico.acessostatus := body.getvalue<string>('acessostatus', '');
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
      servico.dataInventarioDesinstalacao := body.getvalue<string>('dataInventarioDesinstalacao', '');
      servico.aprovacaossv := body.getvalue<string>('aprovacaossv', '');
      servico.statusaprovacaossv := body.getvalue<string>('statusaprovacaossv', '');
      servico.initialtunningrealfinal := body.getvalue<string>('initialtunningrealfinal', '');
      servico.statusobra := body.getvalue<string>('statusobra', '');
      servico.docaplan := body.getvalue<string>('docaplan', '');
      servico.pmoaceitacaoplan := body.getvalue<string>('pmoaceitacaoplan', '');
      servico.pmoaceitacaoreal := body.getvalue<string>('pmoaceitacaoreal', '');
      servico.ov := body.getvalue<string>('ov', '');
      servico.uididcpomrf := body.getvalue<string>('uididcpomrf', '');
      servico.resumodafase := body.getvalue<string>('resumodafase', '');
      servico.rollout := body.getvalue<string>('rollout', '');
      servico.vistoriaplan := body.getvalue<string>('vistoriaplan', '');
      servico.vistoriareal := body.getvalue<string>('vistoriareal', '');
      servico.docplan := body.getvalue<string>('docplan', '');
      servico.docvitoriareal := body.getvalue<string>('docvitoriareal', '');
      servico.req := body.getvalue<string>('req', '');
      servico.dataimprodutiva := body.getvalue<string>('dataimprodutiva', '');
      servico.acompanhamentofisicoobservacao := body.getvalue<string>('acompanhamentofisicoobservacao', '');
      servico.equipe := body.getvalue<string>('equipe', '');
      servico.initialtunningstatus := body.getvalue<string>('initialtunningstatus', '');
      servico.initialtunningreal := body.getvalue<string>('initialtunningreal', '');

      servico.dataExecucaoDoc := body.getvalue<string>('dataExecucaoDoc', '');
      servico.dataPostagemDoc := body.getvalue<string>('dataPostagemDoc', '');
      servico.selectedOptionStatusDocumentacao := body.getvalue<string>('selectedOptionStatusDocumentacao', '');
      servico.dataExecucaoDocVDVM := body.getvalue<string>('dataExecucaoDocVDVM', '');
      servico.dataPostagemDocVDVM := body.getvalue<string>('dataPostagemDocVDVM', '');
      servico.observacaoDocumentacao := body.getvalue<string>('observacaoDocumentacao', '');

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
  body: TJSONObject;
  jsonValue: TJSONValue;
  erro: string;
  tempInt: Integer;
  tempStr: string;
  tempDouble: Double;
begin
  servico := TProjetotelefonica.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      erro := '';

      if body.TryGetValue<string>('idpmts', tempStr) then
        servico.idpmts := tempStr
      else
        servico.idpmts := '';


      if body.TryGetValue<integer>('idfuncionario', tempInt) then
        servico.idfuncionario := tempInt
      else
        servico.idfuncionario := 0;

      if body.TryGetValue<integer>('idcolaborador', tempInt) then
        servico.idcolaborador := tempInt
      else
        servico.idcolaborador := 0;

      if body.TryGetValue<integer>('idatividade', tempInt) then
        servico.idatividade := tempInt
      else
        servico.idatividade := 0;

     if body.TryGetValue<string>('po', tempStr) then
      servico.po := tempStr
     else
      servico.po := '';

      if body.TryGetValue<string>('atividade', tempStr) then
        servico.atividade := tempStr
      else
        servico.atividade := '';

      if body.TryGetValue<string>('idrollout', tempStr) then
        servico.rollout := tempStr
      else
        servico.rollout := '';


      jsonValue := body.GetValue('datainicioclt');
      if (jsonValue <> nil) and not (jsonValue is TJSONNull) then
        servico.datainicioclt := jsonValue.Value
      else
        servico.datainicioclt := '';

      jsonValue := body.GetValue('datafinalclt');
      if (jsonValue <> nil) and not (jsonValue is TJSONNull) then
        servico.datafinalclt := jsonValue.Value
      else
        servico.datafinalclt := '';

      if body.TryGetValue<integer>('totalhorasclt', tempInt) then
        servico.totalhorasclt := tempInt
      else
        servico.totalhorasclt := 0;

      if body.TryGetValue<string>('observacaoclt', tempStr) then
        servico.observacaoclt := tempStr
      else
        servico.observacaoclt := '';

      if body.TryGetValue<double>('horanormalclt', tempDouble) then
        servico.horanormalclt := tempDouble
      else
        servico.horanormalclt := 0;

      jsonValue := body.GetValue('hora50clt');
      if (jsonValue <> nil) and not (jsonValue is TJSONNull) and (jsonValue.Value <> '') then
        servico.hora50clt := jsonValue.AsType<double>
      else
        servico.hora50clt := 0;

      jsonValue := body.GetValue('hora100clt');
      if (jsonValue <> nil) and not (jsonValue is TJSONNull) and (jsonValue.Value <> '') then
        servico.hora100clt := jsonValue.AsType<double>
      else
        servico.hora100clt := 0;


      if servico.salvaacionamentoclt(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idgeral)).Status(THTTPStatus.Created)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);

    except
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro no processamento: ' + ex.Message)).Status(THTTPStatus.InternalServerError);
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

procedure ListPrevisaoFechamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  ds: TFDQuery;
  arr: TJSONArray;
  msgErro: string;
begin
  servico := TProjetotelefonica.Create;
  try
    ds := servico.ListPrevisaoFechamento(Req.Query.Dictionary, msgErro);
    try

      if ds.IsEmpty then
      begin
        Res.Send<TJSONObject>(
          TJSONObject.Create.AddPair('aviso', 'Nenhum registro encontrado')
        ).Status(THTTPStatus.NoContent); // 204 é mais adequado para resposta vazia
        Exit;
      end;

      arr := nil;
      try
        arr := ds.ToJSONArray;
        Res.Send<TJSONArray>(arr).Status(THTTPStatus.OK);
        arr := nil; // Impede que seja liberado pelo finally
      except
        on E: Exception do
        begin
          FreeAndNil(arr);
          Res.Send<TJSONObject>(
            TJSONObject.Create
              .AddPair('erro', 'Falha ao gerar resposta JSON')
              .AddPair('detalhes', E.Message)
          ).Status(THTTPStatus.InternalServerError);
        end;
      end;
    finally
      FreeAndNil(ds);
    end;
  finally
    FreeAndNil(servico);
  end;
end;

procedure ListaDespesas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  jsonResponse: TJSONObject;
  totalGeral: Double;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    on E: Exception do
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco: ' + E.Message)).Status(500);
      Exit;
    end;
  end;

  try
    qry := servico.ListaDespesas(Req.Query.Dictionary, erro, totalGeral);
    try
      if Assigned(qry) then
      begin
        arraydados := qry.ToJSONArray();

        jsonResponse := TJSONObject.Create;
        try
          jsonResponse.AddPair('dados', arraydados);
          jsonResponse.AddPair('total_geral', TJSONNumber.Create(totalGeral));

          if erro = '' then
            Res.Send<TJSONObject>(jsonResponse).Status(THTTPStatus.OK)
          else
            Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
        except
          jsonResponse.Free;
          raise;
        end;
      end
      else
      begin
        if erro <> '' then
          Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.NotFound)
        else
          Res.Send<TJSONObject>(CreateJsonObj('erro', 'Nenhum dado encontrado')).Status(THTTPStatus.NotFound);
      end;
    except
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    if Assigned(qry) then
      qry.Free;
    servico.Free;
  end;
end;


procedure GerarT4Excel(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  xlOpenXMLWorkbookMacroEnabled = 52; // formato .xlsm
var
  ExcelApp, Workbook, Sheet: OleVariant;
  TempFileName, TemplatePath: string;
  FileStream: TFileStream;
  FS: TFormatSettings;
  DataAcionamento: TDateTime;
  i: Integer;
  ParamName, ParamValue: string;
  ParamList: TStringList;
  TempDir: string;
  ErrorStage: string;
  FileBytes: TBytes;
  servico: TProjetotelefonica;
  id, statusfaturamento: string;

function ParseISODate(const ISODate: string): TDateTime;
  var
    DateTimeStr: string;
  begin
    DateTimeStr := StringReplace(ISODate, 'T', ' ', []);
    try
      Result := StrToDateTime(DateTimeStr, FS);
    except
      Result := EncodeDate(
        StrToIntDef(Copy(ISODate, 1, 4), 2025),
        StrToIntDef(Copy(ISODate, 6, 2), 1),
        StrToIntDef(Copy(ISODate, 9, 2), 1)
      );
    end;
  end;

begin
  FS := TFormatSettings.Create;
  FS.DecimalSeparator := '.';
  FS.DateSeparator := '/';
  FS.ShortDateFormat := 'dd/mm/yyyy';

  try
    // Stage 1: Log all received parameters
    ErrorStage := 'Logging parameters';
    ParamList := TStringList.Create;


    // Stage 2: Prepare temporary directory
    ErrorStage := 'Creating temp directory';
    TempDir := TPath.Combine(ExtractFilePath(ParamStr(0)), 'TempExcelFiles');
    if not DirectoryExists(TempDir) then
      ForceDirectories(TempDir);

    // Stage 3: Generate temp filename
    ErrorStage := 'Generating temp filename';
    TempFileName := TPath.Combine(TempDir, 'generatecartataf.xlsm');


    // Stage 4: Initialize COM and Excel
    ErrorStage := 'Initializing Excel';
    CoInitialize(nil);
    try
      ExcelApp := CreateOleObject('Excel.Application');
      ExcelApp.Visible := False;
      ExcelApp.DisplayAlerts := False;

      // Stage 5: Verify template exists
      ErrorStage := 'Checking template file';
      TemplatePath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'documents\cartataf.xlsm');
      if not FileExists(TemplatePath) then
        raise Exception.Create(Format('Template file not found: %s', [TemplatePath]));

      // Stage 6: Open workbook
      ErrorStage := 'Opening workbook';
      Workbook := ExcelApp.Workbooks.Open(TemplatePath);
      Sheet := Workbook.Worksheets[1];

      try
        // Stage 7: Process parameters
        ErrorStage := 'Processing parameters';

        // Parse date if provided
        if Req.Query.TryGetValue('dataacionamento', ParamValue) then
          DataAcionamento := ParseISODate(ParamValue);

        // Fill cells with parameter validation
        ErrorStage := 'Filling cell Z6';
        if Req.Query.TryGetValue('pepnivel3', ParamValue) then
        begin
          Sheet.Cells[6, 26].Value := ParamValue;
          Sheet.Name := ParamValue;
        end;

        ErrorStage := 'Filling cell E9';
        if Req.Query.TryGetValue('numerodocontrato', ParamValue) then
          Sheet.Cells[9, 5].Value := ParamValue;

        if Req.Query.TryGetValue('codfornecedor', ParamValue) then
        begin
          ErrorStage := 'Filling cells I7 and C16';
          Sheet.Cells[9, 8].Value := ParamValue;
          Sheet.Cells[17, 4].Value := ParamValue;
        end;

        ErrorStage := 'Filling cell K7';
        if Req.Query.TryGetValue('empresa', ParamValue) then
          Sheet.Cells[7, 11].Value := ParamValue;

        // Campo Estação/Lote - corrigindo para usar o SITE correto
        ErrorStage := 'Filling Estação/Lote field';
        if Req.Query.TryGetValue('site', ParamValue) then
          Sheet.Cells[17, 3].Value := ParamValue; // Assumindo coluna C (3) para Estação/Lote

        // Campo Operação - incluindo prefixo 'S' e número do elemento PEP
        ErrorStage := 'Filling Operação field';
        if Req.Query.TryGetValue('pepnivel3', ParamValue) then
        begin
          // Extrair o número do elemento PEP (assumindo formato como "IJE2" -> "S2")
          var operacao: string := 'S';
          if Length(ParamValue) > 3 then
            operacao := operacao + Copy(ParamValue, 4, Length(ParamValue) - 3);
          Sheet.Cells[17, 4].Value := operacao; // Assumindo coluna D (4) para Operação
        end;

        ErrorStage := 'Filling cell D16';
        // Campo Descrição - padronizando para 'M_REDE ACESSO RÁDIO-RAN-SERV-NAC'
        Sheet.Cells[17, 5].Value := 'M_REDE ACESSO RÁDIO-RAN-SERV-NAC';

        ErrorStage := 'Filling cell E16';
        if Req.Query.TryGetValue('t2codmatservsw', ParamValue) then
          Sheet.Cells[17, 6].Value := ParamValue;

        ErrorStage := 'Filling cell J16';
        if Req.Query.TryGetValue('quant', ParamValue) then
          Sheet.Cells[17, 14].Value := ParamValue
        else if Req.Query.TryGetValue('quantidade', ParamValue) then
          Sheet.Cells[17, 14].Value := ParamValue;

        ErrorStage := 'Filling cell M16';
        if Req.Query.TryGetValue('valor', ParamValue) then
          Sheet.Cells[17, 15].Value := ParamValue;

        // Campo Data Base - emissão T4 + 30 dias
        ErrorStage := 'Filling Data Base field';
        var dataBase := Now + 30; // Data atual + 30 dias
        Sheet.Cells[17, 16].Value := FormatDateTime('dd/mm/yyyy', dataBase); // Assumindo coluna P (16) para Data Base

       if Req.Query.TryGetValue('tid', ParamValue) then
          id := ParamValue;

       servico := TProjetotelefonica.Create;

        if Req.Query.TryGetValue('statusfaturamento', ParamValue) then
        begin
          if ParamValue = 'Retorno T2' then
            servico.UpdateStatusFaturamento(id, 'Gerada T4', ErrorStage);
        end;

        // Stage 8: Save workbook
        ErrorStage := 'Saving workbook';
        if FileExists(TempFileName) then
        begin
          try
            DeleteFile(TempFileName);
          except
            on E: Exception do
              raise Exception.CreateFmt('Erro ao tentar sobrescrever o arquivo "%s": %s', [TempFileName, E.Message]);
          end;
        end;
        Workbook.SaveAs(TempFileName, xlOpenXMLWorkbookMacroEnabled);
      except
        on E: Exception do
        begin
          // Add stage info to error message
          raise Exception.Create(Format('Error during %s: %s', [ErrorStage, E.Message]));
        end;
      end;

    finally
      // Stage 9: Cleanup Excel
      ErrorStage := 'Cleaning up Excel';
      if not VarIsEmpty(Sheet) then Sheet := Unassigned;
      if not VarIsEmpty(Workbook) then
      begin
        Workbook.Close(False);
        Workbook := Unassigned;
      end;
      if not VarIsEmpty(ExcelApp) then
      begin
        ExcelApp.Quit;
        ExcelApp := Unassigned;
      end;
      CoUninitialize;
    end;

    // Stage 10: Verify output file
    ErrorStage := 'Verifying output file';
    if not FileExists(TempFileName) then
      raise Exception.Create(Format('Output file not created: %s', [TempFileName]));

    // Stage 11: Send response
    ErrorStage := 'Sending response';
    try
      // Lê o arquivo como array de bytes e envia
        FileBytes := TFile.ReadAllBytes(TempFileName);

        // Configura os headers e envia a resposta
        Res.ContentType('application/vnd.ms-excel.sheet.macroEnabled.12');
        Res.AddHeader('Content-Disposition', 'attachment; filename="cartataf_gerado.xlsm"');
        Res.Status(THTTPStatus.OK);
        Res.SendFile(TempFileName);

    except
      on E: Exception do
      begin
        Writeln('Erro ao enviar arquivo: ' + E.Message);
        raise;
      end;
    end;
  except
    on E: Exception do
    begin
      // Stage 12: Error handling
      Writeln(Format('Error at stage "%s": %s', [ErrorStage, E.Message]));

      // Cleanup temp file if exists
      if (TempFileName <> '') and FileExists(TempFileName) then
        DeleteFile(TempFileName);

      // Return detailed error to client
      Res.Send(Format('Erro ao gerar carta TAF (etapa: %s): %s',
        [ErrorStage, E.Message]))
        .Status(THTTPStatus.InternalServerError);
    end;
  end;
end;

procedure GerarT4CSV(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  xlOpenXMLWorkbookMacroEnabled = 52; // formato .xlsm
var
  ExcelApp, Workbook, Sheet: OleVariant;
  TempFileName, TemplatePath: string;
  FileStream: TFileStream;
  FS: TFormatSettings;
  DataAcionamento: TDateTime;
  i: Integer;
  ParamName, ParamValue: string;
  ParamList: TStringList;
  TempDir: string;
  ErrorStage: string;
  FileBytes: TBytes;
  servico: TProjetotelefonica;
  id, statusfaturamento: string;

function ParseISODate(const ISODate: string): TDateTime;
  var
    DateTimeStr: string;
  begin
    DateTimeStr := StringReplace(ISODate, 'T', ' ', []);
    try
      Result := StrToDateTime(DateTimeStr, FS);
    except
      Result := EncodeDate(
        StrToIntDef(Copy(ISODate, 1, 4), 2025),
        StrToIntDef(Copy(ISODate, 6, 2), 1),
        StrToIntDef(Copy(ISODate, 9, 2), 1)
      );
    end;
  end;

begin
  FS := TFormatSettings.Create;
  FS.DecimalSeparator := '.';
  FS.DateSeparator := '/';
  FS.ShortDateFormat := 'dd/mm/yyyy';

  try
    // Stage 1: Log all received parameters
    ErrorStage := 'Logging parameters';
    ParamList := TStringList.Create;

    // Stage 2: Prepare temporary directory
    ErrorStage := 'Creating temp directory';
    TempDir := TPath.Combine(ExtractFilePath(ParamStr(0)), 'TempExcelFiles');
    if not DirectoryExists(TempDir) then
      ForceDirectories(TempDir);

    // Stage 3: Generate temp filename
    ErrorStage := 'Generating temp filename';
    TempFileName := TPath.Combine(TempDir, 'generatecartataf.csv');


    // Stage 4: Initialize COM and Excel
    ErrorStage := 'Initializing Excel';
    CoInitialize(nil);
    try
      ExcelApp := CreateOleObject('Excel.Application');
      ExcelApp.Visible := False;
      ExcelApp.DisplayAlerts := False;

      // Stage 5: Verify template exists
      ErrorStage := 'Checking template file';
      TemplatePath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'documents\cartatafcsv.csv');
      if not FileExists(TemplatePath) then
        raise Exception.Create(Format('Template file not found: %s', [TemplatePath]));

      // Stage 6: Open workbook
      ErrorStage := 'Opening workbook';
      Workbook := ExcelApp.Workbooks.Open(TemplatePath);
      Sheet := Workbook.Worksheets[1];

      try
        // Stage 7: Process parameters
        ErrorStage := 'Processing parameters';

        // Parse date if provided
        if Req.Query.TryGetValue('dataacionamento', ParamValue) then
          DataAcionamento := ParseISODate(ParamValue);

        // Fill cells with parameter validation
        ErrorStage := 'Filling cell Z6';
        if Req.Query.TryGetValue('pepnivel3', ParamValue) then
        begin
          Sheet.Cells[6, 26].Value := ParamValue;
          Sheet.Name := ParamValue;
        end;

        ErrorStage := 'Filling cell E9';
        if Req.Query.TryGetValue('numerodocontrato', ParamValue) then
          Sheet.Cells[9, 6].Value := ParamValue;

        if Req.Query.TryGetValue('codfornecedor', ParamValue) then
        begin
          ErrorStage := 'Filling cells I7 and C16';
          Sheet.Cells[9, 11].Value := ParamValue;
          Sheet.Cells[17, 4].Value := ParamValue;
        end;

        ErrorStage := 'Filling cell K7';
        if Req.Query.TryGetValue('empresa', ParamValue) then
          Sheet.Cells[7, 11].Value := ParamValue;

        ErrorStage := 'Filling cell D16';
        if Req.Query.TryGetValue('t2descricaocod', ParamValue) then
          Sheet.Cells[17, 5].Value := ParamValue;

        ErrorStage := 'Filling cell E16';
        if Req.Query.TryGetValue('t2codmatservsw', ParamValue) then
          Sheet.Cells[17, 6].Value := ParamValue;

        ErrorStage := 'Filling cell J16';
        if Req.Query.TryGetValue('quantidade', ParamValue) then
          Sheet.Cells[17, 14].Value := ParamValue;

        ErrorStage := 'Filling cell M16';
        if Req.Query.TryGetValue('valor', ParamValue) then
          Sheet.Cells[17, 15].Value := ParamValue;

        if Req.Query.TryGetValue('tid', ParamValue) then
          id := ParamValue;

        servico := TProjetotelefonica.Create;
        if Req.Query.TryGetValue('statusfaturamento', ParamValue) then
        begin
          if ParamValue = 'Retorno T2' then
            servico.UpdateStatusFaturamento(id, 'Gerada T4', ErrorStage);
        end;

        // Stage 8: Save workbook
        ErrorStage := 'Saving workbook';
        if FileExists(TempFileName) then
        begin
          try
            DeleteFile(TempFileName);
          except
            on E: Exception do
              raise Exception.CreateFmt('Erro ao tentar sobrescrever o arquivo "%s": %s', [TempFileName, E.Message]);
          end;
        end;
        Workbook.SaveAs(TempFileName, xlOpenXMLWorkbookMacroEnabled);
      except
        on E: Exception do
        begin
          // Add stage info to error message
          raise Exception.Create(Format('Error during %s: %s', [ErrorStage, E.Message]));
        end;
      end;

    finally
      // Stage 9: Cleanup Excel
      ErrorStage := 'Cleaning up Excel';
      if not VarIsEmpty(Sheet) then Sheet := Unassigned;
      if not VarIsEmpty(Workbook) then
      begin
        Workbook.Close(False);
        Workbook := Unassigned;
      end;
      if not VarIsEmpty(ExcelApp) then
      begin
        ExcelApp.Quit;
        ExcelApp := Unassigned;
      end;
      CoUninitialize;
    end;

    // Stage 10: Verify output file
    ErrorStage := 'Verifying output file';
    if not FileExists(TempFileName) then
      raise Exception.Create(Format('Output file not created: %s', [TempFileName]));

    // Stage 11: Send response
    ErrorStage := 'Sending response';
    try
      // Lê o arquivo como array de bytes e envia
        FileBytes := TFile.ReadAllBytes(TempFileName);

        // Configura os headers e envia a resposta
        Res.ContentType('application/vnd.ms-excel.sheet.macroEnabled.12');
        Res.AddHeader('Content-Disposition', 'attachment; filename="cartataf_gerado.csv"');
        Res.Status(THTTPStatus.OK);
        Res.SendFile(TempFileName);

    except
      on E: Exception do
      begin
        Writeln('Erro ao enviar arquivo: ' + E.Message);
        raise;
      end;
    end;
  except
    on E: Exception do
    begin
      // Stage 12: Error handling
      Writeln(Format('Error at stage "%s": %s', [ErrorStage, E.Message]));

      // Cleanup temp file if exists
      if (TempFileName <> '') and FileExists(TempFileName) then
        DeleteFile(TempFileName);

      // Return detailed error to client
      Res.Send(Format('Erro ao gerar carta TAF (etapa: %s): %s',
        [ErrorStage, E.Message]))
        .Status(THTTPStatus.InternalServerError);
    end;
  end;
end;

procedure verificarduplicidaderollout(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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
  qry := servico.verificarduplicidaderollout(Req.Query.Dictionary, erro);
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

procedure adicionarsitemanual(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  body: TJSONValue;
  erro: string;
  retorno: Boolean;
begin
  try
    servico := TProjetotelefonica.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body), 0);
    if body = nil then
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'JSON inválido')).Status(THTTPStatus.BadRequest);
      exit;
    end;

    // Preenche os dados do serviço com os valores do JSON
    servico.uididpmts := body.getvalue<string>('uididpmts', '');
    servico.ufsigla := body.getvalue<string>('ufsigla', '');
    servico.uididcpomrf := body.getvalue<string>('uididcpomrf', '');
    servico.pmouf := body.getvalue<string>('pmouf', '');
    servico.pmoregional := body.getvalue<string>('pmoregional', '');
    servico.idvivo := body.getvalue<string>('idVivo', '');
    servico.infra := body.getvalue<string>('infra', '');
    servico.detentora := body.getvalue<string>('detentora', '');
    servico.iddetentora := body.getvalue<string>('idDetentora', '');
    servico.fcu := body.getvalue<string>('fcu', '');
    servico.rsorsascistatus := body.getvalue<string>('rsoRsaSciStatus', '');
    servico.origem := 'Manual';

    retorno := servico.adicionarsitemanual(erro);
    
    if retorno then
      Res.Send<TJSONObject>(CreateJsonObj('sucesso', 'Site adicionado com sucesso')).Status(THTTPStatus.Created)
    else
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
      
  except
    on ex: exception do
      Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
  end;
  
  servico.Free;
  if Assigned(body) then
    body.Free;
end;

procedure marcaravulso(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  body: TJSONObject;
  erro: string;
  uuidps: string;
  sucesso: Boolean;
begin
  servico := TProjetotelefonica.Create;
  try
    body := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
    if not Assigned(body) then
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'Body inválido')).Status(400);
      Exit;
    end;

    uuidps := body.GetValue<string>('uuidps', '');
    if uuidps = '' then
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'uuidps obrigatório')).Status(400);
      Exit;
    end;

    sucesso := servico.marcarComoAvulso(uuidps, erro);
    if sucesso then
      Res.Send<TJSONObject>(CreateJsonObj('sucesso', 'Marcado como avulso')).Status(200)
    else
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(500);

    body.Free;
  finally
    servico.Free;
  end;
end;

procedure desmarcarComoAvulso(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetotelefonica;
  body: TJSONObject;
  erro: string;
  uuidps: string;
  sucesso: Boolean;
begin
  servico := TProjetotelefonica.Create;
  try
    body := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
    if not Assigned(body) then
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'Body inválido')).Status(400);
      Exit;
    end;

    uuidps := body.GetValue<string>('uuidps', '');
    if uuidps = '' then
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'uuidps obrigatório')).Status(400);
      Exit;
    end;

    sucesso := servico.desmarcarComoAvulso(uuidps, erro);
    if sucesso then
      Res.Send<TJSONObject>(CreateJsonObj('sucesso', 'Marcado como avulso')).Status(200)
    else
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(500);

    body.Free;
  finally
    servico.Free;
  end;
end;

end.


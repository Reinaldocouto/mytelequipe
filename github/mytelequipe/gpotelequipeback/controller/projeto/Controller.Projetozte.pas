unit Controller.Projetozte;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Projetozte, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listatarefas(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listapo(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaiddocumentacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salvaatividadepj(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salvatarefas(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaatividadepj(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure listalpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure listaacionamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salvar(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listafechamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaparadocumentacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listafechamentoporempresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Editarpagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure historicopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure extratopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure extratopagamentototal(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure rolloutzte(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure totalacionamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/projetozte', Lista);
  THorse.post('v1/projetozte', salvar);
  THorse.get('v1/projetoztepo', Listapo);
  THorse.get('v1/projetozteid', Listaid);
  THorse.get('v1/projetozte/tarefas', Listatarefas);
  THorse.post('v1/projetozte/tarefas', salvatarefas);
  THorse.Post('v1/projetozte/novocadastro', novocadastro);
  THorse.post('v1/projetozte/listaatividadepj/salva', Salvaatividadepj);
  THorse.get('v1/projetozte/listaatividadepj', Listaatividadepj);
  THorse.get('v1/projetozte/listalpu/:idc', listalpu);
  THorse.get('v1/projetozte/listaacionamento', listaacionamento);
  THorse.get('v1/projetozte/fechamento', Listafechamento);
  THorse.get('v1/projetozte/fechamentoporempresa', ListaFechamentoporempresa);
  THorse.post('v1/projetozte/fechamento/salvapagamento', Editarpagamento);
  THorse.get('v1/projetozte/documentacao', Listaparadocumentacao);
  THorse.get('v1/projetozte/historicopagamento', historicopagamento);
  THorse.get('v1/projetozteid/extrato', extratopagamento);
  THorse.get('v1/projetozteid/extratototal', extratopagamentototal);
  THorse.get('v1/rolloutzte', rolloutzte);
  THorse.get('v1/projetozte/totalacionamento', totalacionamento);
end;





procedure totalacionamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
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
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
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

procedure extratopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
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

procedure rolloutzte(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.rolloutzte(Req.Query.Dictionary, erro);
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
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.historicopagamento(Req.Query.Dictionary, erro);
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
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
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

procedure Editarpagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetozte;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetozte.Create;
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

procedure Listafechamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
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
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
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
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.listaacionamento(Req.Query.Dictionary, erro);
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
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
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

procedure Listalpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  servico.idcolaboradorpj := Req.Params['idc'].ToInteger;
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
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
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
  servico: TProjetozte;
  body: TJSONValue;
  JSONArray: TJSONArray;
  JSONObj: TJSONObject;
  JSONItem: TJSONValue;
  erro, retorno: string;
  i: integer;
begin
  servico := TProjetozte.Create;
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

procedure Salvar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetozte;
  body: TJSONValue;
  JSON: TJSONObject;
  erro, xData: string;
begin
  servico := TProjetozte.Create;
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

procedure Salvaatividadepj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetozte;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetozte.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.numero := body.getvalue<string>('numero', '');

      if strisint(body.getvalue<string>('idcolaboradorpj', '')) then
        servico.idcolaboradorpj := body.getvalue<integer>('idcolaboradorpj', 0)
      else
        servico.idcolaboradorpj := 0;

      servico.po := body.getvalue<string>('selecao', '');
      servico.region := body.getvalue<string>('region', '');
      servico.regiao := body.getvalue<string>('regiao', '');
      servico.area := body.getvalue<string>('area', '');

      servico.observacaopj := body.getvalue<string>('observacaopj', '');

      servico.lpuhistorico := body.getvalue<string>('lpuhistorico', '');
      servico.zona := body.getvalue<string>('zona', '');
      servico.estado := body.getvalue<string>('estado', '');

      try
        servico.valornegociado := StrToFloat(body.getvalue<string>('valornegociadonum', ''))
      except
        servico.valornegociado := 0;
      end;

      if Length(erro) = 0 then
      begin
        if servico.Editaratividadepj(erro) then
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
  servico: TProjetozte;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetozte.Create;
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
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
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

procedure Listapo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
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
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
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
  servico: TProjetozte;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetozte.Create;
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


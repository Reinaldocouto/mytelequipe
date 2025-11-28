unit Controller.Projetohuawei;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB, System.DateUtils,
  Model.Huawei, UtFuncao, Controller.Auth, DataSet.Serialize, System.Generics.Collections;

procedure Registry;

procedure ListarHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Listapo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure baixardados(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure AtualizarHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Deleta(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Listafechamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Listaconsolidado(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListaDespesas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure extratopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure totalacionamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
function InserirSeNaoExistir(id: string; obj: TJSONObject): Boolean;

procedure Listaacionamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Salvaacionamentopj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Salvaacionamentoclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Listaacionamentopj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Listaacionamentoclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Salvaatividadepj(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure criartarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure rollouthuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure EditarEmMassa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
function InserirSeNaoExistirRollout(id: string; obj: TJSONObject): Boolean;
procedure diaria(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure SalvarAcompanhamentoHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure AdicionarSiteManualHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure VerificarDuplicidadeRolloutHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure SalvarAcessoHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ExcluirSiteManualHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure MarcarAvulsoHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DesmarcarAvulsoHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.Get('v1/projetohuawei', ListarHuawei);
  THorse.Get('v1/projetohuaweiid', Listaid);
  THorse.Get('v1/projetohuaweipo', Listapo);
  THorse.Post('v1/projetohuawei/acesso', SalvarAcessoHuawei);
  THorse.Post('v1/projetohuawei', Salva);
  THorse.Post('v1/projetohuawei/baixardados', baixardados);
  THorse.Put('v1/projetohuawei/:id', AtualizarHuawei);
  THorse.Delete('v1/projetohuawei/:id', Deleta);
  THorse.Post('v1/projetohuawei/novocadastro', novocadastro);
  THorse.Get('v1/projetohuawei/listaacionamento', Listaacionamento);
  THorse.Post('v1/projetohuawei/acionamentopj', Salvaacionamentopj);
  THorse.Post('v1/projetohuawei/acionamentoclt', Salvaacionamentoclt);
  THorse.Get('v1/projetohuawei/listaacionamentopj', Listaacionamentopj);
  THorse.Get('v1/projetohuawei/listaacionamentoclt', Listaacionamentoclt);
  THorse.Post('v1/projetohuawei/listaatividadepj/salva', Salvaatividadepj);
  THorse.Post('v1/projetohuawei/criartarefa', criartarefa);
  THorse.Get('v1/rollouthuawei', rollouthuawei);
  THorse.Post('v1/rollouthuawei/editaremmassa', EditarEmMassa);
  THorse.get('v1/projetohuawei/diaria', diaria);
  THorse.Get('v1/projetohuawei/fechamento', Listafechamento);
  THorse.Get('v1/projetohuawei/consolidado', Listaconsolidado);
  THorse.Get('v1/projetohuawei/ListaDespesas', ListaDespesas);
  THorse.Get('v1/projetohuaweiid/extrato', extratopagamento);
  THorse.Get('v1/projetohuawei/totalacionamento', totalacionamento);
  THorse.Post('v1/projetohuawei/acompanhamento', SalvarAcompanhamentoHuawei);
  THorse.Post('v1/rollouthuawei/adicionarmanual', AdicionarSiteManualHuawei);
  THorse.Get('v1/rollouthuawei/verificarduplicidade', VerificarDuplicidadeRolloutHuawei);
  THorse.Post('v1/rollouthuawei/excluirmanual', ExcluirSiteManualHuawei);
  THorse.Post('v1/rollouthuawei/marcaravulso', MarcarAvulsoHuawei);
  THorse.Post('v1/rollouthuawei/desmarcaravulso', DesmarcarAvulsoHuawei);
end;

procedure criartarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  body: TJSONValue;
  erro, xData: string;
begin
  servico := THuawei.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;
      servico.os := body.GetValue<string>('os', '');
      servico.projectno := body.GetValue<string>('projectno', '');
      servico.sitecode := body.GetValue<string>('sitecode', '');
      servico.biddingArea := body.GetValue<string>('region', '');
      servico.sitename := body.GetValue<string>('sitename', '');
      servico.siteid := body.GetValue<string>('siteid', '');
      servico.ponumber := body.GetValue<string>('ponumber', '');
      servico.itemcode := body.GetValue<string>('itemcode', '');
      servico.vo := body.GetValue<string>('vo', '');
      servico.itemdescription := body.GetValue<string>('itemdescription', '');
      try servico.usuario := StrToInt(body.GetValue<string>('usuario', '')) except servico.usuario := 0; end;
      try servico.qty := StrToFloat(body.GetValue<string>('qty', '')) except servico.qty := 0; end;
      if servico.criartarefa(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.id)).Status(THTTPStatus.Created)
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

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  huaweiModel: THuawei;
  body: TJSONObject;
  erro: string;
  function HasAny(const JO: TJSONObject; const Keys: array of string): Boolean;
  var K: string;
  begin
    Result := False;
    for K in Keys do
      if JO.GetValue(K) <> nil then Exit(True);
  end;
const
  PROJ_KEYS: array[0..11] of string = (
    'primaryKey','sitecode','sitename','siteid','poNumber','projectNo',
    'biddingArea','os','observacaopj','idcolaboradorpj','valorpj','porcentagempj'
  );
  FISICO_KEYS: array[0..15] of string = (
    'id_projetohuawei','situacao_implantacao','situacao_integracao',
    'data_criacao_demanda','data_aceite_demanda','data_inicio_planejado',
    'data_entrega_planejado','data_recebimento_reportado','data_fim_instalacao_planejado',
    'data_conclusao_reportado','data_validacao_instalacao','data_integracao_planejado',
    'data_validacao_eribox','data_aceitacao_final','pendencias_obras','observacoes'
  );
var
  precisaProjeto, precisaFisico, algoFeito: Boolean;
begin
  huaweiModel := THuawei.Create;
  try
    try
      body := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
      if body = nil then
      begin
        Res.Send<TJSONObject>(CreateJsonObj('erro', 'JSON inválido')).Status(THTTPStatus.BadRequest);
        Exit;
      end;
      precisaProjeto := HasAny(body, PROJ_KEYS);
      precisaFisico  := HasAny(body, FISICO_KEYS);
      algoFeito      := False;
      if precisaProjeto then
      begin
        if not huaweiModel.InserirHuawei(body, erro) then
        begin
          Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.BadRequest);
          Exit;
        end;
        algoFeito := True;
      end;
      if precisaFisico then
      begin
        if not huaweiModel.InserirHuaweiAcompanhamentoFisico(body, erro) then
        begin
          Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao salvar acompanhamento físico: ' + erro))
            .Status(THTTPStatus.BadRequest);
          Exit;
        end;
        algoFeito := True;
      end;
      if not algoFeito then
      begin
        Res.Send<TJSONObject>(CreateJsonObj('erro',
          'Payload não contém campos de ProjetoHuawei nem de Acompanhamento Físico'))
          .Status(THTTPStatus.BadRequest);
        Exit;
      end;
      Res.Send<TJSONObject>(CreateJsonObj('retorno', 'OK')).Status(THTTPStatus.Created);
    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', 'Falha ao inserir: ' + ex.Message))
          .Status(THTTPStatus.InternalServerError);
    end;
  finally
    huaweiModel.Free;
  end;
end;

procedure Salvaatividadepj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  body: TJSONValue;
  erro: string;
begin
  servico := THuawei.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;
      servico.os := body.GetValue<string>('os', '');
      if StrIsInt(body.GetValue<string>('idcolaboradorpj', '')) then
        servico.idcolaboradorpj := body.GetValue<Integer>('idcolaboradorpj', 0)
      else
        servico.idcolaboradorpj := 0;
      servico.po := body.GetValue<string>('selecao', '');
      servico.observacaopj := body.GetValue<string>('observacaopj', '');
      servico.negociadoSN := Ord(body.GetValue<Boolean>('opnegociado', False));
      try servico.porcentagempj  := StrToFloat(body.GetValue<string>('porcentagempj', ''))  except servico.porcentagempj  := 0; end;
      try servico.valornegociado := StrToFloat(body.GetValue<string>('valornegociadonum', '')) except servico.valornegociado := 0; end;
      if servico.Editaratividadepj(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.id)).Status(THTTPStatus.Created)
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

procedure Listaacionamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
begin
  try
    servico := THuawei.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
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
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    qry.Free;
    servico.Free;
  end;
end;

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  body: TJSONValue;
  erro: string;
begin
  servico := THuawei.Create;
  try
    try
      body := Req.body<TJSONObject>;
      if servico.NovoCadastro(erro) <> '0' then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.id)).Status(THTTPStatus.Created)
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

procedure Listapo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
begin
  try
    servico := THuawei.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
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
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    qry.Free;
    servico.Free;
  end;
end;

procedure ListarHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  huaweiModel: THuawei;
  qry: TFDQuery;
  erro: string;
begin
  huaweiModel := THuawei.Create;
  qry := nil;
  try
    qry := huaweiModel.ListarHuawei(Req.Query.Dictionary, erro);
    if Assigned(qry) then
      Res.Send<TJSONArray>(qry.ToJSONArray()).Status(THTTPStatus.OK)
    else
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
  finally
    if Assigned(qry) then
      qry.Free;
    huaweiModel.Free;
  end;
end;

function InserirSeNaoExistirRollout(id: string; obj: TJSONObject): Boolean;
var
  huaweiModel: THuawei;
  qry: TFDQuery;
  erro: string;
begin
  Result := False;
  huaweiModel := THuawei.Create;
  try
    qry := huaweiModel.PesquisarHuaweiPorPrimaryKey(id, erro);
    if (qry = nil) or (erro <> '') then Exit;
    try
      qry.Open;
      if qry.IsEmpty then
      begin
        huaweiModel.InserirHuaweiRollout(obj, erro);
        Result := (erro = '');
      end;
    finally
      qry.Free;
    end;
  finally
    huaweiModel.Free;
  end;
end;

function InserirSeNaoExistir(id: string; obj: TJSONObject): Boolean;
var
  huaweiModel: THuawei;
  qry: TFDQuery;
  erro: string;
begin
  Result := False;
  huaweiModel := THuawei.Create;
  try
    qry := huaweiModel.PesquisarHuaweiPorPrimaryKey(id, erro);
    if (qry = nil) or (erro <> '') then Exit;
    try
      qry.Open;
      if qry.IsEmpty then
      begin
        huaweiModel.InserirHuawei(obj, erro);
        Result := (erro = '');
      end;
    finally
      qry.Free;
    end;
  finally
    huaweiModel.Free;
  end;
end;

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico : THuawei;
  qry     : TFDQuery;
  equipeQ : TFDQuery;
  erro    : string;
  obj     : TJSONObject;
  equipeArr: TJSONArray;
  acessoId: Integer;
begin
  servico := THuawei.Create;
  try
    qry := servico.Listaid(Req.Query.Dictionary, erro);
    try
      if (qry = nil) then
      begin
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
        Exit;
      end;
      obj := qry.ToJSONObject;
      acessoId := 0;
      if (qry.FindField('acesso_id') <> nil) and (not qry.FieldByName('acesso_id').IsNull) then
        acessoId := qry.FieldByName('acesso_id').AsInteger;
      if (acessoId = 0) then
      begin
        obj.TryGetValue<Integer>('acessoId', acessoId);
        if (acessoId = 0) then
          obj.TryGetValue<Integer>('acesso_id', acessoId);
      end;
      if (acessoId > 0) then
      begin
        equipeQ := servico.ListaEquipeAcesso(acessoId, erro);
        try
          if (equipeQ <> nil) then
          begin
            equipeArr := TJSONArray.Create;
            try
              while not equipeQ.Eof do
              begin
                equipeArr.Add(equipeQ.FieldByName('id_pessoa').AsInteger);
                equipeQ.Next;
              end;
              obj.AddPair('acesso_equipe', equipeArr);
            except
              equipeArr.Free;
              raise;
            end;
          end
          else
            obj.AddPair('acesso_equipe', TJSONArray.Create);
        finally
          if Assigned(equipeQ) then
            equipeQ.Free;
        end;
      end
      else
        obj.AddPair('acesso_equipe', TJSONArray.Create);
      if erro = '' then
        Res.Send<TJSONObject>(obj).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on E: Exception do
      begin
        Res.Send<TJSONObject>(CreateJsonObj('erro', E.Message)).Status(THTTPStatus.InternalServerError);
      end;
    end;
  finally
    if Assigned(qry) then
      qry.Free;
    servico.Free;
  end;
end;

procedure baixardados(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  huaweiModel: THuawei;
  body: TJSONObject;
  erro: string;
begin
  body := Req.Body<TJSONObject>;
  huaweiModel := THuawei.Create;
  try
    if huaweiModel.InserirHuawei(body, erro) then
      Res.Send<TJSONObject>(CreateJsonObj('retorno', 'Registro inserido com sucesso')).Status(THTTPStatus.Created)
    else
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
  finally
    huaweiModel.Free;
  end;
end;

procedure AtualizarHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  huaweiModel: THuawei;
  body: TJSONObject;
  id, erro: string;
begin
  id := Req.Params['id'];
  body := Req.Body<TJSONObject>;
  huaweiModel := THuawei.Create;
  try
    if huaweiModel.AtualizarHuawei(body, erro) then
      Res.Send<TJSONObject>(CreateJsonObj('retorno', 'Registro atualizado com sucesso')).Status(THTTPStatus.OK)
    else
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
  finally
    huaweiModel.Free;
  end;
end;

procedure Deleta(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  huaweiModel: THuawei;
  id: Integer;
  idStr: string;
begin
  idStr := Req.Params['id'];
  if not TryStrToInt(idStr, id) then
  begin
    Res.Send('ID inválido').Status(THTTPStatus.BadRequest);
    Exit;
  end;
  huaweiModel := THuawei.Create;
  try
    if huaweiModel.Deletar(id) then
      Res.Send('Registro deletado com sucesso').Status(THTTPStatus.OK)
    else
      Res.Send('Erro ao deletar o registro').Status(THTTPStatus.InternalServerError);
  finally
    huaweiModel.Free;
  end;
end;

procedure rollouthuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  qry: TFDQuery;
  erro: string;
begin
  servico := THuawei.Create;
  try
    qry := servico.Rollouthuawei(Req.Query.Dictionary, erro);
    try
      if Assigned(qry) then
      begin
        if (erro = '') or (erro = 'Nenhum registro ativo encontrado') then
          Res.Send<TJSONArray>(qry.ToJSONArray()).Status(THTTPStatus.OK)
        else
          Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
      end
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', 'Falha ao executar consulta')).Status(THTTPStatus.InternalServerError);
    finally
      if Assigned(qry) then
        qry.Free;
    end;
  finally
    servico.Free;
  end;
end;

procedure EditarEmMassa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  erro: string;
  sucesso: Boolean;
  body: string;
begin
  try
    servico := THuawei.Create;
    try
      body := Req.Body;
      if body.Trim = '' then
      begin
        Res.Send<TJSONObject>(TJSONObject.Create
          .AddPair('sucesso', 'false')
          .AddPair('erro', 'body vazio')).Status(THTTPStatus.BadRequest);
        Exit;
      end;
      sucesso := servico.EditarEmMassa(body, erro);
      if sucesso then
        Res.Send<TJSONObject>(TJSONObject.Create
          .AddPair('sucesso', 'true')
          .AddPair('mensagem', 'Registros atualizados com sucesso')).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(TJSONObject.Create
          .AddPair('sucesso', 'false')
          .AddPair('erro', erro)).Status(THTTPStatus.BadRequest);
    except
      on E: Exception do
        Res.Send<TJSONObject>(TJSONObject.Create
          .AddPair('sucesso', 'false')
          .AddPair('erro', 'Erro inesperado: ' + E.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    if Assigned(servico) then
      servico.Free;
  end;
end;

procedure Salvaacionamentoclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  body: TJSONObject;
  erro: string;
  tempInt: Integer;
  tempStr: string;
begin
  servico := THuawei.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      erro := '';
      if body.TryGetValue<Integer>('idcolaborador', tempInt) then
        servico.idcolaboradorpj := tempInt
      else
        servico.idcolaboradorpj := 0;
      if body.TryGetValue<string>('po', tempStr) then
        servico.po := tempStr
      else
        servico.po := '';
      if body.TryGetValue<string>('os', tempStr) then
        servico.os := tempStr
      else
        servico.os := '';
      if body.TryGetValue<string>('observacao', tempStr) then
        servico.observacaopj := tempStr
      else
        servico.observacaopj := '';
      if servico.salvaacionamentoclt(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.id)).Status(THTTPStatus.Created)
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

procedure SalvarAcompanhamentoHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  body: TJSONObject;
  erro: string;
begin
  body := Req.Body<TJSONObject>;
  servico := THuawei.Create;
  try
    if servico.InserirHuaweiAcompanhamentoFisico(body, erro) then
      Res.Send<TJSONObject>(TJSONObject.Create.AddPair('sucesso', 'true'))
    else
      Res.Send<TJSONObject>(TJSONObject.Create.AddPair('sucesso', 'false').AddPair('erro', erro))
        .Status(THTTPStatus.InternalServerError);
  finally
    servico.Free;
  end;
end;

procedure Listaacionamentopj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  qry: TFDQuery;
  erro: string;
  AQuery: TDictionary<string, string>;
  key, value: string;
begin
  servico := THuawei.Create;
  AQuery := TDictionary<string, string>.Create;
  try
    try
      for key in Req.Query.Dictionary.Keys do
      begin
        value := Req.Query.Dictionary.Items[key];
        AQuery.Add(key, value);
      end;
      qry := servico.Listaacionamentopj(AQuery, erro);
      if qry <> nil then
        Res.Send<TJSONArray>(qry.ToJSONArray()).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    AQuery.Free;
    servico.Free;
  end;
end;

procedure Listaacionamentoclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  qry: TFDQuery;
  erro: string;
  AQuery: TDictionary<string, string>;
  key, value: string;
begin
  servico := THuawei.Create;
  AQuery := TDictionary<string, string>.Create;
  try
    try
      for key in Req.Query.Dictionary.Keys do
      begin
        value := Req.Query.Dictionary.Items[key];
        AQuery.Add(key, value);
      end;
      qry := servico.Listaacionamentoclt(AQuery, erro);
      if qry <> nil then
        Res.Send<TJSONArray>(qry.ToJSONArray()).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    AQuery.Free;
    servico.Free;
  end;
end;

procedure Listafechamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  qry: TFDQuery;
  erro: string;
  AQuery: TDictionary<string, string>;
  key, value: string;
begin
  AQuery := TDictionary<string, string>.Create;
  try
    servico := THuawei.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;
  try
    try
      for key in Req.Query.Dictionary.Keys do
      begin
        value := Req.Query.Dictionary.Items[key];
        AQuery.Add(key, value);
      end;
      qry := servico.Listafechamento(AQuery, erro);
      if qry <> nil then
        Res.Send<TJSONArray>(qry.ToJSONArray()).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    AQuery.Free;
    servico.Free;
  end;
end;

procedure SalvarAcessoHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Body  : TJSONObject;
  Model : THuawei;
  Err   : string;
  R     : THuaweiAcessoSaveResult;
  JResp : TJSONObject;
begin
  Body  := nil;
  Model := THuawei.Create;
  FillChar(R, SizeOf(R), 0);
  try
    Body := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
    if Body = nil then
    begin
      Res.ContentType('application/json')
         .Status(THTTPStatus.BadRequest)
         .Send<TJSONObject>(TJSONObject.Create.AddPair('erro', 'JSON inválido'));
      Exit;
    end;
    try
      if Model.SalvarAcesso(Body, Err, R) then
      begin
        JResp := TJSONObject.Create;
        JResp.AddPair('ok', TJSONBool.Create(True));
        JResp.AddPair('id_acesso', TJSONNumber.Create(R.AcessoID));
        Res.ContentType('application/json')
           .Status(THTTPStatus.Created)
           .Send<TJSONObject>(JResp);
      end
      else
      begin
        JResp := TJSONObject.Create;
        JResp.AddPair('ok', TJSONBool.Create(False));
        JResp.AddPair('erro', Err);
        Res.ContentType('application/json')
           .Status(THTTPStatus.BadRequest)
           .Send<TJSONObject>(JResp);
      end;
    except
      on E: Exception do
      begin
        JResp := TJSONObject.Create;
        JResp.AddPair('ok', TJSONBool.Create(False));
        JResp.AddPair('erro', E.Message);
        Res.ContentType('application/json')
           .Status(THTTPStatus.InternalServerError)
           .Send<TJSONObject>(JResp);
      end;
    end;
  finally
    if Assigned(Body) then
      Body.Free;
    Model.Free;
  end;
end;

procedure Listaconsolidado(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  qry: TFDQuery;
  erro: string;
  AQuery: TDictionary<string, string>;
  key, value: string;
begin
  AQuery := TDictionary<string, string>.Create;
  try
    servico := THuawei.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;
  try
    try
      for key in Req.Query.Dictionary.Keys do
      begin
        value := Req.Query.Dictionary.Items[key];
        AQuery.Add(key, value);
      end;
      qry := servico.Listaconsolidado(AQuery, erro);
      if qry <> nil then
        Res.Send<TJSONArray>(qry.ToJSONArray()).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    AQuery.Free;
    servico.Free;
  end;
end;

procedure diaria(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := THuawei.Create;
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

procedure ListaDespesas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  qry: TFDQuery;
  erro: string;
  AQuery: TDictionary<string, string>;
  key, value: string;
begin
  AQuery := TDictionary<string, string>.Create;
  try
    servico := THuawei.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;
  try
    try
      for key in Req.Query.Dictionary.Keys do
      begin
        value := Req.Query.Dictionary.Items[key];
        AQuery.Add(key, value);
      end;
      qry := servico.ListaDespesas(AQuery, erro);
      if qry <> nil then
        Res.Send<TJSONArray>(qry.ToJSONArray()).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    AQuery.Free;
    servico.Free;
  end;
end;

procedure Salvaacionamentopj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  body: TJSONObject;
  erro: string;
  tmpI: Integer;
  tmpS: string;
  tmpB: Boolean;
  tmpF: Double;
begin
  servico := THuawei.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      erro := '';
      if body.TryGetValue<Integer>('idcolaboradorpj', tmpI) then
        servico.idcolaboradorpj := tmpI
      else if body.TryGetValue<Integer>('idcolaborador', tmpI) then
        servico.idcolaboradorpj := tmpI
      else
        servico.idcolaboradorpj := 0;
      if body.TryGetValue<string>('po', tmpS) then
        servico.po := tmpS
      else
        servico.po := '';
      if body.TryGetValue<string>('os', tmpS) then
        servico.os := tmpS
      else
        servico.os := '';
      if body.TryGetValue<string>('observacao', tmpS) then
        servico.observacaopj := tmpS
      else if body.TryGetValue<string>('observacaopj', tmpS) then
        servico.observacaopj := tmpS
      else
        servico.observacaopj := '';
      if body.TryGetValue<Boolean>('opnegociado', tmpB) then
        servico.negociadoSN := Ord(tmpB)
      else if body.TryGetValue<Integer>('negociadoSN', tmpI) then
        servico.negociadoSN := tmpI;
      if body.TryGetValue<Double>('porcentagempj', tmpF) then
        servico.porcentagempj := tmpF
      else if body.TryGetValue<string>('porcentagempj', tmpS) then
        servico.porcentagempj := StrToFloatDef(StringReplace(tmpS, ',', '.', [rfReplaceAll]), 0);
      if body.TryGetValue<Double>('valornegociadonum', tmpF) then
        servico.valornegociado := tmpF
      else if body.TryGetValue<string>('valornegociadonum', tmpS) then
        servico.valornegociado := StrToFloatDef(StringReplace(tmpS, ',', '.', [rfReplaceAll]), 0);
      if servico.salvaacionamentopj(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.id)).Status(THTTPStatus.Created)
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

procedure extratopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  qry: TFDQuery;
  erro: string;
  AQuery: TDictionary<string, string>;
  key, value: string;
begin
  AQuery := TDictionary<string, string>.Create;
  try
    servico := THuawei.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;
  try
    try
      for key in Req.Query.Dictionary.Keys do
      begin
        value := Req.Query.Dictionary.Items[key];
        AQuery.Add(key, value);
      end;
      qry := servico.extratopagamento(AQuery, erro);
      if qry <> nil then
        Res.Send<TJSONArray>(qry.ToJSONArray()).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    AQuery.Free;
    servico.Free;
  end;
end;

procedure totalacionamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  qry: TFDQuery;
  erro: string;
  AQuery: TDictionary<string, string>;
  key, value: string;
begin
  AQuery := TDictionary<string, string>.Create;
  servico := nil;
  try
    try
      servico := THuawei.Create;
      for key in Req.Query.Dictionary.Keys do
      begin
        value := Req.Query.Dictionary.Items[key];
        AQuery.Add(key, value);
      end;
      qry := servico.totalacionamento(AQuery, erro);
      if qry <> nil then
        Res.Send<TJSONArray>(qry.ToJSONArray()).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    if Assigned(AQuery) then
      AQuery.Free;
    if Assigned(servico) then
      servico.Free;
  end;
end;

{ *** ADIÇÃO MÍNIMA: normalização de datas para aceitar 'dd/MM/yyyy' ou ISO e até 'yyyy' *** }
function NormalizeSqlDate(const S: string): string;
var
  D: TDateTime;
  FS: TFormatSettings;
  STrim: string;
  Y: Integer;
begin
  Result := '';
  STrim := Trim(S);
  if STrim = '' then Exit;

  FS := TFormatSettings.Create;
  FS.DateSeparator := '/';
  FS.ShortDateFormat := 'dd/MM/yyyy';

  if TryStrToDate(STRim, D, FS) then
    Exit(FormatDateTime('yyyy-mm-dd', D));

  if TryISO8601ToDate(STRim, D) then
    Exit(FormatDateTime('yyyy-mm-dd', D));

  if (Length(STRim) = 4) and TryStrToInt(STRim, Y) then
    Exit(Format('%d-01-01', [Y]));
end;

procedure AdicionarSiteManualHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  body: TJSONObject;
  erro: string;
  jsonResponse: TJSONObject;
  rawFech: string; { <-- adição mínima }

  function GetStr(const JO: TJSONObject; const Keys: array of string; const Def: string = ''): string;
  var
    k: string;
    V: TJSONValue;
  begin
    Result := Def;
    if JO = nil then Exit;
    for k in Keys do
    begin
      V := JO.Values[k];
      if (V <> nil) and (not V.Null) then
        Exit(V.Value);
    end;
  end;

  function GetInt(const JO: TJSONObject; const Keys: array of string; const Def: Integer = 0): Integer;
  var
    s: string;
  begin
    s := GetStr(JO, Keys, '');
    Result := StrToIntDef(s, Def);
  end;

  function IsEmpty(const S: string): Boolean;
  begin
    Result := Trim(S) = '';
  end;

begin
  servico := THuawei.Create;
  body := nil;
  try
    body := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
    if body = nil then
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'JSON inválido')).Status(THTTPStatus.BadRequest);
      Exit;
    end;

    servico.name                 := GetStr(body, ['Name', 'name'], '');
    servico.projeto              := GetStr(body, ['Projeto', 'projeto'], '');
    servico.endSite              := GetStr(body, ['End_Site', 'endSite'], '');
    servico.du                   := GetStr(body, ['DU', 'du'], '');
    servico.statusGeral          := GetStr(body, ['Status_geral', 'statusGeral'], '');
    servico.liderResponsavel     := GetStr(body, ['Lider_responsavel', 'liderResponsavel'], '');
    servico.empresa              := GetStr(body, ['Empresa', 'empresa'], '');
    servico.ativoNoPeriodo       := GetStr(body, ['Ativo_no_periodo', 'ativoNoPeriodo'], '');

    rawFech                      := GetStr(body, ['Fechamento', 'fechamento'], '');
    servico.fechamento           := NormalizeSqlDate(rawFech); { <-- adição mínima }

    servico.anoSemanaFechamento  := GetStr(body, ['Ano_Semana_Fechamento', 'anoSemanaFechamento'], '');
    servico.pmoregional          := GetStr(body, ['Reg', 'reg'], '');
    servico.infra                := GetStr(body, ['Infra', 'infra'], '');
    servico.detentora            := GetStr(body, ['Detentora', 'detentora'], '');
    servico.iddetentora          := GetStr(body, ['ID_Dententora', 'idDetentora', 'idloja'], '');
    servico.fcu                  := GetStr(body, ['Forma_de_acesso', 'formaDeAcesso'], '');
    servico.sitecode             := GetStr(body, ['Site_Code', 'siteCode', 'End_Site', 'endSite'], '');
    servico.sitename             := GetStr(body, ['Site_Name', 'siteName', 'Name', 'name'], '');
    servico.siteid               := GetStr(body, ['Site_ID', 'siteId', 'DU', 'du'], '');
    servico.origem               := GetStr(body, ['origem'], 'Manual');
    servico.usuario              := GetInt(body, ['Ultima_Pessoa_Atualizacao', 'idusuario'], 0);
    servico.avulso               := GetInt(body, ['avulso'], 0);
    servico.deletado             := 0;

    if IsEmpty(servico.sitecode) then
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'Site_Code obrigatório')).Status(THTTPStatus.BadRequest);
      Exit;
    end;

    { validação amigável para Fechamento informado em formato inesperado }
    if (rawFech <> '') and (servico.fechamento = '') then
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro',
        'Fechamento inválido. Use dd/mm/yyyy (ex.: 01/03/2026) ou yyyy-mm-dd.')).Status(THTTPStatus.BadRequest);
      Exit;
    end;

    if servico.adicionarsitemanual(erro) then
    begin
      jsonResponse := TJSONObject.Create;
      try
        jsonResponse.AddPair('mensagem', 'Site adicionado com sucesso');
        jsonResponse.AddPair('id', servico.id);
        jsonResponse.AddPair('Site_Code', servico.sitecode);
        Res.Send<TJSONObject>(jsonResponse).Status(THTTPStatus.OK);
      except
        jsonResponse.Free;
        raise;
      end;
    end
    else
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);

  except
    on E: Exception do
      Res.Send<TJSONObject>(CreateJsonObj('erro', E.Message)).Status(THTTPStatus.InternalServerError);
  end;

  if Assigned(body) then body.Free;
  servico.Free;
end;

procedure VerificarDuplicidadeRolloutHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
begin
  try
    servico := THuawei.Create;
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

procedure ExcluirSiteManualHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico   : THuawei;
  bodyObj   : TJSONObject;
  idStr     : string;
  usrStr    : string;
  usuarioId : Integer;
  ok        : Boolean;
  erro      : string;
  tmpI      : Integer;
  tmpS      : string;
begin
  servico := nil;
  bodyObj := nil;
  try
    servico := THuawei.Create;
    bodyObj := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
    idStr := '';
    if Assigned(bodyObj) then
    begin
      if bodyObj.TryGetValue<Integer>('idgeral', tmpI) then
        idStr := IntToStr(tmpI)
      else if bodyObj.TryGetValue<string>('idgeral', tmpS) then
        idStr := tmpS
      else if bodyObj.TryGetValue<Integer>('id', tmpI) then
        idStr := IntToStr(tmpI)
      else if bodyObj.TryGetValue<string>('id', tmpS) then
        idStr := tmpS;
    end;
    if idStr = '' then
    begin
      if Req.Query.Field('idgeral') <> nil then
        idStr := Req.Query.Field('idgeral').AsString;
      if (idStr = '') and (Req.Query.Field('id') <> nil) then
        idStr := Req.Query.Field('id').AsString;
    end;
    usrStr := '';
    if Assigned(bodyObj) then
    begin
      if bodyObj.TryGetValue<Integer>('idusuario', tmpI) then
        usrStr := IntToStr(tmpI)
      else if bodyObj.TryGetValue<string>('idusuario', tmpS) then
        usrStr := tmpS;
    end;
    if usrStr = '' then
      if Req.Query.Field('idusuario') <> nil then
        usrStr := Req.Query.Field('idusuario').AsString;
    usuarioId := StrToIntDef(usrStr, 0);
    if idStr = '' then
    begin
      Res.Status(THTTPStatus.BadRequest)
         .Send<TJSONObject>(CreateJsonObj('erro', 'Informe idgeral ou id'));
      Exit;
    end;
    if usuarioId <= 0 then
    begin
      Res.Status(THTTPStatus.BadRequest)
         .Send<TJSONObject>(CreateJsonObj('erro', 'Informe idusuario'));
      Exit;
    end;
    servico.usuario := usuarioId;
    ok := servico.excluirsitemanual(idStr, erro);
    if ok then
    begin
      Res.Status(THTTPStatus.OK)
         .Send<TJSONObject>(
           TJSONObject.Create
             .AddPair('ok', TJSONBool.Create(True))
             .AddPair('mensagem', 'Registro marcado como deletado')
         );
    end
    else
    begin
      if erro = '' then
        erro := 'Nenhum registro encontrado para exclusão ou origem <> "Manual".';
      Res.Status(THTTPStatus.NotFound)
         .Send<TJSONObject>(
           TJSONObject.Create
             .AddPair('ok', TJSONBool.Create(False))
             .AddPair('erro', erro)
         );
    end;
  except
    on E: Exception do
    begin
      Res.Status(THTTPStatus.InternalServerError)
         .Send<TJSONObject>(
           TJSONObject.Create
             .AddPair('ok', TJSONBool.Create(False))
             .AddPair('erro', E.Message)
         );
    end;
  end;
  if Assigned(bodyObj) then
    bodyObj.Free;
  if Assigned(servico) then
    servico.Free;
end;

procedure MarcarAvulsoHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  bodyObj: TJSONObject;
  idsStr: string;
  usrStr: string;
  usuarioId: Integer;
  ok: Boolean;
  erro: string;
begin
  servico := nil;
  bodyObj := nil;
  try
    servico := THuawei.Create;
    bodyObj := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
    if not Assigned(bodyObj) then
    begin
      Res.Status(THTTPStatus.BadRequest)
         .Send<TJSONObject>(CreateJsonObj('erro', 'JSON inválido ou vazio'));
      Exit;
    end;
    idsStr := bodyObj.GetValue<string>('ids', '');
    usrStr := bodyObj.GetValue<string>('idusuario', '');
    usuarioId := StrToIntDef(usrStr, 0);
    if (idsStr = '') then
    begin
      Res.Status(THTTPStatus.BadRequest)
         .Send<TJSONObject>(CreateJsonObj('erro', 'Informe o campo "ids" (ex: "1,2,3")'));
      Exit;
    end;
    if (usuarioId <= 0) then
    begin
      Res.Status(THTTPStatus.BadRequest)
         .Send<TJSONObject>(CreateJsonObj('erro', 'Informe um idusuario válido'));
      Exit;
    end;
    servico.usuario := usuarioId;
    ok := servico.marcarComoAvulso(idsStr, erro);
    if ok then
      Res.Status(THTTPStatus.OK)
         .Send<TJSONObject>(CreateJsonObj('sucesso', 'Registros marcados como avulso'))
    else
      Res.Status(THTTPStatus.BadRequest)
         .Send<TJSONObject>(CreateJsonObj('erro', erro));
  except
    on E: Exception do
      Res.Status(THTTPStatus.InternalServerError)
         .Send<TJSONObject>(CreateJsonObj('erro', E.Message));
  end;
  if Assigned(bodyObj) then
    bodyObj.Free;
  if Assigned(servico) then
    servico.Free;
end;

procedure DesmarcarAvulsoHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  bodyObj: TJSONObject;
  idsStr: string;
  usrStr: string;
  usuarioId: Integer;
  ok: Boolean;
  erro: string;
begin
  servico := nil;
  bodyObj := nil;
  try
    servico := THuawei.Create;
    bodyObj := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
    if not Assigned(bodyObj) then
    begin
      Res.Status(THTTPStatus.BadRequest)
         .Send<TJSONObject>(CreateJsonObj('erro', 'JSON inválido ou vazio'));
      Exit;
    end;
    idsStr := bodyObj.GetValue<string>('ids', '');
    usrStr := bodyObj.GetValue<string>('idusuario', '');
    usuarioId := StrToIntDef(usrStr, 0);
    if (idsStr = '') then
    begin
      Res.Status(THTTPStatus.BadRequest)
         .Send<TJSONObject>(CreateJsonObj('erro', 'Informe o campo "ids" (ex: "1,2,3")'));
      Exit;
    end;
    if (usuarioId <= 0) then
    begin
      Res.Status(THTTPStatus.BadRequest)
         .Send<TJSONObject>(CreateJsonObj('erro', 'Informe um idusuario válido'));
      Exit;
    end;
    servico.usuario := usuarioId;
    ok := servico.desmarcarComoAvulso(idsStr, erro);
    if ok then
      Res.Status(THTTPStatus.OK)
         .Send<TJSONObject>(CreateJsonObj('sucesso', 'Registros desmarcados como avulso'))
    else
      Res.Status(THTTPStatus.BadRequest)
         .Send<TJSONObject>(CreateJsonObj('erro', erro));
  except
    on E: Exception do
      Res.Status(THTTPStatus.InternalServerError)
         .Send<TJSONObject>(CreateJsonObj('erro', E.Message));
  end;
  if Assigned(bodyObj) then
    bodyObj.Free;
  if Assigned(servico) then
    servico.Free;
end;

end.


unit Controller.Projetohuawei;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  Model.Huawei, UtFuncao, Controller.Auth, DataSet.Serialize;

procedure Registry;

procedure ListarHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listapo(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure baixardados(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure AtualizarHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Deleta(Req: THorseRequest; Res: THorseResponse; Next: TProc);

function InserirSeNaoExistir(id: string; obj: TJSONObject): Boolean;

procedure Listaacionamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salvaatividadepj(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure criartarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure rollouthuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.Get('v1/projetohuawei', Lista);
  THorse.Get('v1/projetohuaweiid', Listaid);
  THorse.Get('v1/projetohuaweipo', Listapo);
  THorse.Post('v1/projetohuawei', Salva);
  THorse.Put('v1/projetohuawei/:id', AtualizarHuawei);
  THorse.Delete('v1/projetohuawei/:id', Deleta);
  THorse.Post('v1/projetohuawei/novocadastro', novocadastro);
  THorse.get('v1/projetohuawei/listaacionamento', listaacionamento);
  THorse.post('v1/projetohuawei/listaatividadepj/salva', Salvaatividadepj);
  THorse.Post('v1/projetohuawei/criartarefa', criartarefa);
  THorse.Get('v1/rollouthuawei', rollouthuawei);
end;


procedure criartarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  body: TJSONValue;
  JSON: TJSONObject;
  erro, xData: string;
begin
  servico := THuawei.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.os := body.getvalue<string>('os', '');
      servico.projectno := body.getvalue<string>('projectno', '');
      servico.sitecode := body.getvalue<string>('sitecode', '');
      servico.os := body.getvalue<string>('os', '');
      servico.biddingArea := body.getvalue<string>('region', '');
      servico.sitename := body.getvalue<string>('sitename', '');
      servico.siteid := body.getvalue<string>('siteid', '');
      servico.ponumber := body.getvalue<string>('ponumber', '');
      servico.itemcode := body.getvalue<string>('itemcode', '');
      servico.vo := body.getvalue<string>('vo', '');
      servico.itemdescription := body.getvalue<string>('itemdescription', '');
      try
        servico.usuario := StrToInt(body.getvalue<string>('usuario', ''))
      except
        servico.usuario := 0;
      end;

      try
        servico.qty := StrToFloat(body.getvalue<string>('qty', ''))
      except
        servico.qty := 0;
      end;


      if Length(erro) = 0 then
      begin
        if servico.criartarefa(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.id)).Status(THTTPStatus.Created)
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
  servico: THuawei;
  body: TJSONValue;
  JSON: TJSONObject;
  erro, xData: string;
begin
  servico := THuawei.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.os := body.getvalue<string>('os', '');
      servico.observacaopj := body.getvalue<string>('observacao', '');
      servico.id := body.getvalue<string>('id', '');
{      servico.projeto := body.getvalue<string>('projeto', '');
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
      servico.docresp := body.getvalue<string>('docresp', '');  }
      if Length(erro) = 0 then
      begin
        if servico.editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.id)).Status(THTTPStatus.Created)
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
  servico: THuawei;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := THuawei.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.os := body.getvalue<string>('os', '');

      if strisint(body.getvalue<string>('idcolaboradorpj', '')) then
        servico.idcolaboradorpj := body.getvalue<integer>('idcolaboradorpj', 0)
      else
        servico.idcolaboradorpj := 0;
      servico.po := body.getvalue<string>('selecao', '');
      servico.observacaopj := body.getvalue<string>('observacaopj', '');

      if body.getvalue<boolean>('opnegociado', false) then
        servico.negociadoSN := 1
      else
        servico.negociadoSN := 0;

      try
        servico.porcentagempj := StrToFloat(body.getvalue<string>('porcentagempj', ''))
      except
        servico.porcentagempj := 0;
      end;

      try
        servico.valornegociado := StrToFloat(body.getvalue<string>('valornegociadonum', ''))
      except
        servico.valornegociado := 0;
      end;

      if Length(erro) = 0 then
      begin
        if servico.Editaratividadepj(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.id)).Status(THTTPStatus.Created)
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

procedure Listaacionamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THuawei;
  body: TJSONValue;
  JSON: TJSONObject;
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
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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

procedure ListarHuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  huaweiModel: THuawei;
  qry: TFDQuery;
  erro: string;
  jsonArray: TJSONArray;
  jsonObj: TJSONObject;
  i: Integer;
  Info: string;
  SiteCode, SiteNamePart, SiteId, SiteName: string;
  Parts: TArray<string>;
begin
  huaweiModel := THuawei.Create;
  try
    qry := huaweiModel.ListarHuawei(Req.Query.Dictionary, erro);

    if qry = nil then
    begin
      Res.Send(erro).Status(THTTPStatus.InternalServerError);
      Exit;
    end;

    jsonArray := TJSONArray.Create;
    try
      qry.First;
      while not qry.Eof do
      begin
        jsonObj := TJSONObject.Create;
        try

          for i := 0 to qry.FieldCount - 1 do
          begin
            jsonObj.AddPair(qry.Fields[i].FieldName, qry.FieldByName(qry.Fields[i].FieldName).AsString);
          end;
          Info := qry.FieldByName('manufactureSiteInfo').AsString;
          if Info <> '' then
          begin
            Parts := Info.Split(['<!>']);
            if Length(Parts) = 3 then
            begin
              SiteId := Parts[0];
              SiteCode := Parts[1];
              SiteNamePart := Parts[2];

              SiteName := SiteNamePart.Substring(SiteNamePart.IndexOf('@') + 1);
              // Adicione os novos campos ao jsonObj
              jsonObj.AddPair('siteCode', SiteCode);
              jsonObj.AddPair('siteId', SiteId);
              jsonObj.AddPair('siteName', SiteName);
            end
            else
            begin
              // Adicione uma mensagem de erro se o formato estiver incorreto
              jsonObj.AddPair('SeparationError', 'Número inesperado de partes na string.');
            end;
          end;

          jsonArray.AddElement(jsonObj);
        except
          jsonObj.Free;
          raise; // Re-raise exception for further handling if needed
        end;
        qry.Next;
      end;

      Res.Send(jsonArray.ToString).ContentType('application/json').Status(THTTPStatus.OK);
    finally
      jsonArray.Free;
    end;
  finally
    qry.Free; // Não se esqueça de liberar o qry
    huaweiModel.Free;
  end;
end;

function InserirSeNaoExistir(id: string; obj: TJSONObject): Boolean;
var
  huaweiModel: THuawei;
  qry: TFDQuery;
  erro: string;
begin
  Result := False; // Inicializa o resultado como False, indicando que a inserção não foi necessária
  huaweiModel := THuawei.Create;

  try
    qry := TFDQuery.Create(nil);
    // Pesquisa por um registro com o ID fornecido
    qry := huaweiModel.PesquisarHuaweiPorPrimaryKey(id, erro);

    // Verifica se houve erro na pesquisa
    if (qry = nil) or (erro <> '') then
    begin
      erro := 'Erro ao pesquisar registro: ' + erro;
      Exit;
    end;

    try
      qry.Open;

      // Se o registro não existir, o campo será vazio ou o dataset estará vazio
      if qry.IsEmpty then
      begin
        // Insere o dado ou altera
        huaweiModel.InserirHuawei(obj, erro);

        if erro = '' then
          Result := True; // Indica que a inserção foi realizada com sucesso
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
  servico: THuawei;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := THuawei.Create;
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

procedure baixardados(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  huaweiModel: THuawei;
  body: TJSONObject;
  erro: string;
begin
  body := Req.Body<TJSONObject>;
  huaweiModel := THuawei.Create;
  try
    // Popule os campos do model com base nos dados do body
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
    // Popule os campos do model com base nos dados do body
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
  servico: Thuawei;
  qry: TFDQuery;
  erro: string;
begin
  servico := Thuawei.Create;
  try
    qry := servico.rollouthuawei(Req.Query.Dictionary, erro);
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

end.


unit Controller.HistoricoVeiculo;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.HistoricoVeiculo, UtFuncao;

procedure Registry;

implementation

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THistoricoVeiculo;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
begin
  try
    servico := THistoricoVeiculo.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Lista(Req.Query.Dictionary, erro);
  try
    try
      if erro = '' then
      begin
        arraydados := qry.ToJSONArray;
        Res.Send<TJSONArray>(arraydados).Status(THTTPStatus.OK)
      end
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

procedure GetById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THistoricoVeiculo;
  qry: TFDQuery;
  erro: string;
  obj: TJSONObject;
  idParam: string;
begin
  idParam := Req.Params.Items['id'];
  if not strisint(idParam) then
  begin
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'ID inválido')).Status(THTTPStatus.BadRequest);
    Exit;
  end;

  servico := THistoricoVeiculo.Create;
  try
    qry := servico.GetById(StrToInt(idParam), erro);
    if qry = nil then
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.NotFound);
      Exit;
    end;
    try
      obj := qry.ToJSONObject;
      Res.Send<TJSONObject>(obj).Status(THTTPStatus.OK);
    finally
      qry.Free;
    end;
  finally
    servico.Free;
  end;
end;

procedure CreateHistorico(Req: THorseRequest; Res: THorseResponse; Next: TProc); //n estamos usando por enquanto, o insert esta sendo feito diretamente no lançamento de despesas
var
  servico: THistoricoVeiculo;
  body: TJSONValue;
  erro: string;
  inicioStr, fimStr: string;
begin
  servico := THistoricoVeiculo.Create;
  try
    body := Req.Body<TJSONObject>;

    // Tenta converter datas, se forem vazias ou nulas, usar 0 (que indica Data nula)
    inicioStr := body.GetValue<string>('iniciolocacaohistorico', '');
    fimStr := body.GetValue<string>('fimlocacaohistorico', '');

    if inicioStr <> '' then
      servico.iniciolocacao := StrToDateDef(inicioStr, 0)
    else
      servico.iniciolocacao := 0;

    if fimStr <> '' then
      servico.fimlocacao := StrToDateDef(fimStr, 0)
    else
      servico.fimlocacao := 0;

    servico.valordespesa := body.GetValue<string>('valordespesa', '');
    servico.placa := body.GetValue<string>('placa', '');
    servico.empresa := body.GetValue<string>('empresa', '');
    servico.funcionario := body.GetValue<string>('funcionario', '');
    servico.categoria := body.GetValue<string>('categoria', '');
    servico.periodicidade := body.GetValue<string>('periodicidade', '');

    if servico.Insert(erro) then
      Res.Send<TJSONObject>(CreateJsonObj('id', servico.id)).Status(THTTPStatus.Created)
    else
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);

  finally
    servico.Free;
  end;
end;

procedure UpdateHistorico(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THistoricoVeiculo;
  body: TJSONValue;
  erro: string;
  idParam: string;
  inicioStr, fimStr: string;
begin
  idParam := Req.Params.Items['id'];
  if not strisint(idParam) then
  begin
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'ID inválido')).Status(THTTPStatus.BadRequest);
    Exit;
  end;

  servico := THistoricoVeiculo.Create;
  try
    servico.id := StrToInt(idParam);

    body := Req.Body<TJSONObject>;

    inicioStr := body.GetValue<string>('iniciolocacaohistorico', '');
    fimStr := body.GetValue<string>('fimlocacaohistorico', '');

    if inicioStr <> '' then
      servico.iniciolocacao := StrToDateDef(inicioStr, 0)
    else
      servico.iniciolocacao := 0;

    if fimStr <> '' then
      servico.fimlocacao := StrToDateDef(fimStr, 0)
    else
      servico.fimlocacao := 0;

    servico.valordespesa := body.GetValue<string>('valordespesa', '');
    servico.placa := body.GetValue<string>('placa', '');
    servico.empresa := body.GetValue<string>('empresa', '');
    servico.funcionario := body.GetValue<string>('funcionario', '');
    servico.categoria := body.GetValue<string>('categoria', '');
    servico.periodicidade := body.GetValue<string>('periodicidade', '');

    if servico.Update(erro) then
      Res.Send<TJSONObject>(CreateJsonObj('mensagem', 'Atualizado com sucesso')).Status(THTTPStatus.OK)
    else
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);

  finally
    servico.Free;
  end;
end;

procedure DeleteHistorico(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: THistoricoVeiculo;
  erro: string;
  idParam: string;
begin
  idParam := Req.Params.Items['id'];
  if not strisint(idParam) then
  begin
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'ID inválido')).Status(THTTPStatus.BadRequest);
    Exit;
  end;

  servico := THistoricoVeiculo.Create;
  try
    servico.id := StrToInt(idParam);

    if servico.Delete(erro) then
      Res.Send<TJSONObject>(CreateJsonObj('mensagem', 'Deletado com sucesso')).Status(THTTPStatus.OK)
    else
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);

  finally
    servico.Free;
  end;
end;

procedure Registry;
begin
  // Rotas do histórico
  THorse.Get('v1/historicoveiculo', Lista);
  THorse.Get('v1/historicoveiculo/:id', GetById);
  THorse.Post('v1/historicoveiculo', CreateHistorico);
  THorse.Put('v1/historicoveiculo/:id', UpdateHistorico);
  THorse.Delete('v1/historicoveiculo/:id', DeleteHistorico);
end;

end.


unit Controller.Projetoericssonadic;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Projetoericssonadic, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListaFaturamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure AtualizarFAT(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/projetoericssonadic', Lista);
  THorse.get('v1/projetoericsson/faturamento', ListaFaturamento);
  THorse.Post('v1/projetoericsson/atualizarfat', AtualizarFAT);

 // THorse.get('v1/projetoericssonadicid', Listaid);
  THorse.post('v1/projetoericssonadic', salva);
  THorse.Post('v1/projetoericssonadic/novocadastro', novocadastro);


end;

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericssonadic;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetoericssonadic.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idcategoria)).Status(THTTPStatus.Created)
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
  servico: TProjetoericssonadic;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico :=  TProjetoericssonadic.Create;
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

procedure AtualizarFAT(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericssonadic;
  body: TJSONValue;
  arraydados: TJSONArray;
  resultados: TJSONArray;
  inicio: TDateTime;
begin
  inicio := Now;

  try
    servico := TProjetoericssonadic.Create;
  except
    on E: Exception do
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao criar serviço: ' + E.Message)).Status(500);
      Exit;
    end;
  end;

  try
    // Obter o body da requisição
    body := Req.Body<TJSONValue>;
    if (body = nil) or not (body is TJSONArray) then
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'Body deve ser um JSON array')).Status(THTTPStatus.BadRequest);
      Exit;
    end;

    arraydados := TJSONArray(body);
    if servico.AtualizarFAT(arraydados, resultados) then
    begin
      // Adiciona métricas de performance
      resultados.AddElement(TJSONObject.Create
        .AddPair('performance', TJSONObject.Create
          .AddPair('tempo_processamento', FormatDateTime('hh:nn:ss.zzz', Now - inicio))
          .AddPair('total_registros', TJSONNumber.Create(arraydados.Count))
        ));

      Res.Send<TJSONArray>(resultados).Status(THTTPStatus.OK);
    end
    else
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'Falha no processamento em lote')).Status(THTTPStatus.InternalServerError);
    end;

  except
    on E: Exception do
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro interno: ' + E.Message)).Status(THTTPStatus.InternalServerError);
    end;
  end;

  servico.Free;
end;

procedure ListaFaturamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericssonadic;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico :=  TProjetoericssonadic.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaFaturamentoEricsson(Req.Query.Dictionary, erro);
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
  servico: TProjetoericssonadic;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetoericssonadic.Create;
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
  servico: TProjetoericssonadic;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetoericssonadic.Create;
  try

    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idcategoria', '')) then
        servico.idcategoria := body.getvalue<integer>('idcategoria', 0)
      else
        servico.idcategoria := 0;

      servico.descricao := body.getvalue<string>('descricao','');
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idcategoria)).Status(THTTPStatus.Created)
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


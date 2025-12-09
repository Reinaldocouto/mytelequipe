unit Controller.Chg;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Chg, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Exclui(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.Get('v1/chg', Lista);
  THorse.Get('v1/chgid', Listaid);
  THorse.Post('v1/chg', Salva);
  THorse.Delete('v1/chg', Exclui);
end;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TChg;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
begin
  try
    servico := TChg.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;
  qry := servico.Lista(Req.Query.Dictionary, erro);
  try
    if not Assigned(qry) then
    begin
      if erro <> '' then
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao consultar CHG')).Status(THTTPStatus.InternalServerError);
      Exit;
    end;
    try
      arraydados := qry.ToJSONArray;
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

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TChg;
  qry: TFDQuery;
  erro: string;
  objdados: TJSONObject;
begin
  try
    servico := TChg.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;
  qry := servico.Listaid(Req.Query.Dictionary, erro);
  try
    if not Assigned(qry) then
    begin
      if erro <> '' then
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao consultar CHG')).Status(THTTPStatus.InternalServerError);
      Exit;
    end;
    try
      objdados := qry.ToJSONObject;
      if erro = '' then
        Res.Send<TJSONObject>(objdados).Status(THTTPStatus.OK)
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

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TChg;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
  ok: Boolean;
begin
  try
    servico := TChg.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;
  try
    erro := '';
    try
      body := Req.Body<TJSONObject>;

      if strisint(body.GetValue<string>('idchg', '')) then
        servico.idchg := body.GetValue<Integer>('idchg', 0)
      else
        servico.idchg := 0;

      servico.tipo := body.GetValue<string>('tipo', '');
      servico.data_inicio := body.GetValue<string>('data_inicio', '');
      servico.hora_inicio := body.GetValue<string>('hora_inicio', '');
      servico.data_fim := body.GetValue<string>('data_fim', '');
      servico.hora_fim := body.GetValue<string>('hora_fim', '');
      servico.numero := body.GetValue<string>('numero', '');
      servico.status := body.GetValue<string>('status', '');
      servico.observacoes := body.GetValue<string>('observacoes', '');
      servico.empresa := body.GetValue<string>('empresa', '');

      if servico.idchg = 0 then
        ok := servico.Inserir(erro)
      else
        ok := servico.Editar(erro);

      if ok then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idchg)).Status(THTTPStatus.Created)
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

procedure Exclui(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TChg;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  try
    servico := TChg.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;
  try
    erro := '';
    try
      body := Req.Body<TJSONObject>;

      if strisint(body.GetValue<string>('idchg', '')) then
        servico.idchg := body.GetValue<Integer>('idchg', 0)
      else
        servico.idchg := 0;

      if servico.idchg = 0 then
      begin
        Res.Send<TJSONObject>(CreateJsonObj('erro', 'ID da CHG inválido')).Status(THTTPStatus.BadRequest);
        Exit;
      end;

      if servico.Excluir(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idchg)).Status(THTTPStatus.OK)
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

end.


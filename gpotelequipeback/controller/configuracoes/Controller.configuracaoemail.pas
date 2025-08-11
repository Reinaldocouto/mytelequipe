unit Controller.configuracaoemail;

interface uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, model.ConfiguracaoEmail, UtFuncao, Controller.Auth;

procedure Registry;
procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation
procedure Registry;
begin
  THorse.get('v1/emails/aviso', Lista);
  THorse.post('v1/emails/aviso', Editar);
end;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TConfiguracaoemail;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TConfiguracaoemail.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Lista(Req.Query.Dictionary, erro);
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



procedure Editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TConfiguracaoemail;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TConfiguracaoemail.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.tipo := body.GetValue<string>('tipo', '');
      servico.email := body.GetValue<string>('emailsSolicitacaoDiariaAviso', '');
      servico.emailmaterial := body.GetValue<string>('emailmaterial', '');
      servico.emailfaturamento := body.GetValue<string>('emailfaturamento', '');

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.email)).Status(THTTPStatus.Created)
        else
          Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
      end
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

end.

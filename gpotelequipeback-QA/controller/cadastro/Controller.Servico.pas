unit Controller.Servico;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Servico, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/servico', Lista);
  THorse.get('v1/servicoid', Listaid);
  THorse.post('v1/servico', salva);
  THorse.Post('v1/servico/novocadastro', novocadastro);
end;

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tservico;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tservico.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idservico)).Status(THTTPStatus.Created)
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
  servico: TServico;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico :=  TServico.Create;
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

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TServico;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TServico.Create;
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
  servico: TServico;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TServico.Create;
  try
    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idservico', '')) then
        servico.idservico := body.getvalue<integer>('idservico', 0)
      else
        servico.idservico := 0;

      servico.descricao := body.getvalue<string>('descricao','');

      if strisint(body.getvalue<string>('situacao', '')) then
        servico.situacao := body.getvalue<integer>('situacao', 0)
      else
        servico.situacao := 0;

      servico.valor := body.getvalue<string>('valor','');
      servico.codigo := body.getvalue<string>('codigo','');
      servico.unidade := body.getvalue<string>('unidade','');
      servico.codigoservico := body.getvalue<string>('codigoservico','');
      servico.nomenclatura := body.getvalue<string>('nomenclatura','');
      servico.descricaocomplementar := body.getvalue<string>('descricaocomplementar','');
      servico.observacoes := body.getvalue<string>('observacoes','');

      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idservico)).Status(THTTPStatus.Created)
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

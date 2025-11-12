unit Controller.Embalagem;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Embalagem, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/embalagem', Lista);
  THorse.get('v1/embalagemid', Listaid);
  THorse.post('v1/embalagem', salva);
  THorse.Post('v1/embalagem/novocadastro', novocadastro);

end;

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Tembalagem;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := Tembalagem.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idembalagem)).Status(THTTPStatus.Created)
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
  servico: TEmbalagem;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico :=  TEmbalagem.Create;
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
  servico: TEmbalagem;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TEmbalagem.Create;
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
  servico: TEmbalagem;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TEmbalagem.Create;
  try

    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idembalagem', '')) then
        servico.idembalagem := body.getvalue<integer>('idembalagem', 0)
      else
        servico.idembalagem := 0;

      servico.descricao := body.getvalue<string>('descricao','');
      servico.comprimento := body.getvalue<real>('comprimento', 0);
      servico.largura := body.getvalue<real>('largura',0);
      servico.peso := body.getvalue<real>('peso',0);
      servico.altura := body.getvalue<real>('altura',0);
      servico.diametro := body.getvalue<real>('diametro',0);
      servico.tipo := body.getvalue<string>('tipo','');

      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idembalagem)).Status(THTTPStatus.Created)
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


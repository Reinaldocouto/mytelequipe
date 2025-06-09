unit Controller.Configempresafilial;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Configempresafilial, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaloja(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/configempresafilial', Lista);
  THorse.get('v1/configempresafilialid', Listaid);
  THorse.post('v1/configempresafilial', salva);
  THorse.get('v1/configempresafilial/loja', Listaloja);
end;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TConfigempresafilial;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TConfigempresafilial.Create;
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

procedure Listaloja(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TConfigempresafilial;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TConfigempresafilial.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaloja(Req.Query.Dictionary, erro);
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
  servico: TConfigempresafilial;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TConfigempresafilial.Create;
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
  servico: TConfigempresafilial;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TConfigempresafilial.Create;
  erro := '';
  try
    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idcliente', '')) then
        servico.idcliente := body.getvalue<integer>('idcliente', 0)
      else
        servico.idcliente := 0;

      servico.nome := body.getvalue<string>('nome', '');
      servico.fantasia := body.getvalue<string>('fantasia', '');
      servico.codigo := body.getvalue<string>('codigo', '');
      servico.tipopessoa := body.getvalue<integer>('tipopessoa', 0);
      servico.documento := body.getvalue<string>('documento', '');
      servico.cpf := body.getvalue<string>('cpf', '');
      servico.rg := body.getvalue<string>('rg', '');
      servico.cnpj := body.getvalue<string>('cnpj', '');
      servico.pais := body.getvalue<string>('pais', '');
      servico.contribuinte := body.getvalue<string>('contribuinte', '');
      servico.inscricaoestadual := body.getvalue<string>('inscricaoestadual', '');
      servico.inscricaomunicipal := body.getvalue<string>('inscricaomunicipal', '');
      servico.cidade := body.getvalue<string>('cidade', '');
      servico.endereco := body.getvalue<string>('endereco', '');
      servico.bairro := body.getvalue<string>('bairro', '');
      servico.numero := body.getvalue<string>('numero', '');
      servico.uf := body.getvalue<string>('uf', '');
      servico.cep := body.getvalue<string>('cep', '');
      servico.complemento := body.getvalue<string>('complemento', '');
      servico.celular := body.getvalue<string>('celular', '');
      servico.telefone := body.getvalue<string>('telefone', '');
      servico.telefoneadicional := body.getvalue<string>('telefoneadicional', '');
      servico.website := body.getvalue<string>('website', '');
      servico.email := body.getvalue<string>('email', '');
      servico.emailnfe := body.getvalue<string>('emailnfe', '');
      servico.obscontato := body.getvalue<string>('obscontato', '');
      servico.codigoregimetributario := body.getvalue<string>('codigoregimetributario', '');
      servico.inscricaosuframa := body.getvalue<string>('inscricaosuframa', '');
      servico.observacao := body.getvalue<string>('observacao', '');

      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      //servico.idloja := body.getvalue<integer>('idloja', 0);
      {
      if Length(servico.nome) = 0 then
        erro := 'Campo Nome é Obrigatório';

      if Length(servico.celular) = 0 then
        erro := 'Campo Celular é Obrigatório';

      if not (servico.Pesquisarelacionamentovazio) then
        erro := 'Campo Tipo Relacionamento é Obrigatório';
      }

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idcliente)).Status(THTTPStatus.Created)
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


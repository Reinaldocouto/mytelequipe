unit Controller.Empresas;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB, REST.Types,
  DataSet.Serialize, Model.Empresas, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure cnpj(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure ListaSelecpj(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure ListaSelecpjforn(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listacolaborador(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Editarcolaborador(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaveiculo(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/empresas', Lista);
  THorse.Post('v1/empresas/novocadastro', novocadastro);
  THorse.get('v1/empresas/selectpj', ListaSelecpj);
  THorse.get('v1/empresas/selectpjforn', ListaSelecpjforn);
  THorse.post('v1/empresas', Salva);
  THorse.get('v1/empresasid', Listaid);
  THorse.get('v1/empresas/cnpj/:cnpjlocal', cnpj);
  THorse.get('v1/empresas/colaborador', Listacolaborador);
  THorse.post('v1/empresas/colaborador', Editarcolaborador);
  THorse.get('v1/empresas/veiculo', Listaveiculo);

end;

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmpresas;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TEmpresas.Create;
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

procedure ListaSelecpj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmpresas;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TEmpresas.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaSelectpj(Req.Query.Dictionary, erro);
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

procedure ListaSelecpjforn(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmpresas;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TEmpresas.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaSelectpjforn(Req.Query.Dictionary, erro);
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
  servico: TEmpresas;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TEmpresas.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idempresa)).Status(THTTPStatus.Created)
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

procedure Listacolaborador(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmpresas;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TEmpresas.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listacolaborador(Req.Query.Dictionary, erro);
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

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmpresas;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TEmpresas.Create;
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

procedure cnpj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmpresas;
  qry: TFDQuery;
  erro: string;
  JSON: TJSONObject;
begin
  try
    servico := TEmpresas.Create;
    servico.cnpj := Req.Params['cnpjlocal'];
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  JSON := servico.pesquisacnpj(Req.Query.Dictionary, erro);
  try

    try
      if erro = '' then
        Res.Send<TJSONObject>(JSON).Status(THTTPStatus.OK)
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

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmpresas;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TEmpresas.Create;
  erro := '';
  try
    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idempresa', '')) then
        servico.idempresa := body.getvalue<integer>('idempresa', 0)
      else
        servico.idempresa := 0;
      servico.cnpj := body.getvalue<string>('cnpj', '');
      servico.nome := body.getvalue<string>('nome', '');
      servico.fantasia := body.getvalue<string>('fantasia', '');
      servico.porte := body.getvalue<string>('porte', '');
      servico.cnaep := body.getvalue<string>('cnaep', '');
      servico.cnaes := body.getvalue<string>('cnaes', '');
      servico.codigodescricaoatividades := body.getvalue<string>('codigodescricaoatividades', '');
      servico.codigodescricaonatureza := body.getvalue<string>('codigodescricaonatureza', '');
      servico.logradouro := body.getvalue<string>('logradouro', '');
      servico.cidade := body.getvalue<string>('cidade', '');
      servico.numero := body.getvalue<string>('numero', '');
      servico.complemento := body.getvalue<string>('complemento', '');
      servico.cep := body.getvalue<string>('cep', '');
      servico.bairro := body.getvalue<string>('bairro', '');
      servico.uf := body.getvalue<string>('uf', '');
      servico.situacaocadastral := body.getvalue<string>('situacaocadastral', '');
      servico.pgr := body.getvalue<string>('pgr', '');
      servico.pcmso := body.getvalue<string>('pcmso', '');

      servico.outros := body.getvalue<string>('outros', '');
      servico.outrosdata := body.getvalue<string>('outrosdata', '');
      servico.outros2 := body.getvalue<string>('outros2', '');
      servico.outros2data := body.getvalue<string>('outros2data', '');

      servico.contratos := body.getvalue<string>('contratos', '');
      servico.nomeresponsavel := body.getvalue<string>('nomeresponsavel', '');
      servico.telefone := body.getvalue<string>('telefone', '');
      servico.email := body.getvalue<string>('email', '');
      servico.tipopj := body.getvalue<string>('tipopj', '');
      servico.statusTelequipe := body.getvalue<string>('statusTelequipe', '');

      servico.cnae1 := body.getvalue<string>('cnaes1', '');
      servico.cnae2 := body.getvalue<string>('cnaes2', '');
      servico.cnae3 := body.getvalue<string>('cnaes3', '');
      servico.cnae4 := body.getvalue<string>('cnaes4', '');
      servico.cnaedescricao1 := body.getvalue<string>('codigodescricaoatividades1', '');
      servico.cnaedescricao2 := body.getvalue<string>('codigodescricaoatividades2', '');
      servico.cnaedescricao3 := body.getvalue<string>('codigodescricaoatividades3', '');
      servico.cnaedescricao4 := body.getvalue<string>('codigodescricaoatividades4', '');

      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      if Length(servico.cnpj) = 0 then
        erro := 'Campo CNPJ é Obrigatório';

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idempresa)).Status(THTTPStatus.Created)
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

procedure Editarcolaborador(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmpresas;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TEmpresas.Create;
  erro := '';
  try
    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('ididentificador', '')) then
        servico.idpessoa := body.getvalue<integer>('ididentificador', 0)
      else
        servico.idpessoa := 0;
      servico.contrato := body.getvalue<string>('contrato', '');

      if Length(erro) = 0 then
      begin
        if servico.Editarcolaborador(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idempresa)).Status(THTTPStatus.Created)
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

procedure Listaveiculo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmpresas;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TEmpresas.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaveiculo(Req.Query.Dictionary, erro);
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
end.


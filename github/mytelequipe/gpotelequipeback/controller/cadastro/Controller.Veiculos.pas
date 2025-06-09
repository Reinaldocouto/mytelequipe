unit Controller.Veiculos;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Veiculos, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure GetDadosDaPlaca(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure ListaSelect(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/veiculos', Lista);
  THorse.get('v1/veiculos/select', ListaSelect);
  THorse.get('v1/veiculosid', Listaid);
  THorse.post('v1/veiculos', salva);
  THorse.get('v1/veiculoplaca', GetDadosDaPlaca);
  THorse.Post('v1/veiculos/novocadastro', novocadastro);
end;

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TVeiculos;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TVeiculos.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idveiculo)).Status(THTTPStatus.Created)
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

procedure ListaSelect(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TVeiculos;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TVeiculos.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaSelectVeiculos(Req.Query.Dictionary, erro);
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
  servico: TVeiculos;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TVeiculos.Create;
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

procedure GetDadosDaPlaca(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TVeiculos;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TVeiculos.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;

  // placa
     servico.placa := Req.Query['placa'];
  qry := servico.BuscarDadosPlaca(Req.Query.Dictionary, erro);
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


procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TVeiculos;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TVeiculos.Create;
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
  servico: TVeiculos;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TVeiculos.Create;
  erro := '';
  try
    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idveiculo', '')) then
        servico.idveiculo := body.getvalue<integer>('idveiculo', 0)
      else
        servico.idveiculo := 0;
      servico.inspecaoveicular := body.getvalue<string>('inspecaoVeicular', '');
      servico.modelo := body.getvalue<string>('modelo', '');
      servico.placa := body.getvalue<string>('placa', '');
      servico.cor := body.getvalue<string>('cor', '');
      servico.categoria := body.getvalue<string>('categoria', '');
      servico.iniciolocacao := body.getvalue<string>('iniciolocacao', '');
      servico.fimlocacao := body.getvalue<string>('fimlocacao', '');
      servico.periodicidade := body.getvalue<string>('periodicidade', '');
      servico.ultimarevper := body.getvalue<string>('ultimarevper', '');
      servico.kmsrestante := body.getvalue<string>('kmsrestante', '');
      servico.kmatual := body.getvalue<string>('kmatual', '');
      servico.km4 := body.getvalue<string>('km4', '');
      servico.proximarevper := body.getvalue<string>('proximarevper', '');
      servico.marca := body.getvalue<string>('marca', '');
      servico.fabricacao := body.getvalue<string>('fabricacao', '');
      servico.renavam := body.getvalue<string>('renavam', '');
      servico.chassi := body.getvalue<string>('chassi', '');
      servico.licenciamento := body.getvalue<string>('licenciamento', '');

      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      servico.classificacao := body.getvalue<string>('classificacao', '');
      //servico.idempresa := body.getvalue<string>('idempresa', '');
      //servico.idfuncionario := body.getvalue<string>('idfuncionario', '');
      servico.mesbase := body.getvalue<string>('mesbase', '');
      servico.ativo := body.getvalue<string>('ativo', '');

      if strisint(body.getvalue<string>('idempresa', '')) then
        servico.idempresa := body.getvalue<integer>('idempresa', 0)
      else
        servico.idempresa := 0;

      if strisint(body.getvalue<string>('idpessoa', '')) then
        servico.idpessoa := body.getvalue<integer>('idpessoa', 0)
      else
        servico.idpessoa := 0;


      {
      if Length(servico.nome) = 0 then
        erro := 'Campo Nome � Obrigat�rio';

      if Length(servico.contatocelular) = 0 then
        erro := 'Campo Celular � Obrigat�rio';

      if not(servico.Pesquisarelacionamentovazio) then
        erro := 'Campo Tipo Relacionamento � Obrigat�rio';
      }

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idveiculo)).Status(THTTPStatus.Created)
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


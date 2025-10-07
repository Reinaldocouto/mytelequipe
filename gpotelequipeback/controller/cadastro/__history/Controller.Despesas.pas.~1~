unit Controller.Despesas;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Despesas, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/despesas', Lista);
  THorse.get('v1/despesasid', Listaid);
  THorse.post('v1/despesas', Salva);
  THorse.post('v1/despesas/novocadastro', Novocadastro);
end;

procedure Novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TDespesas;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TDespesas.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.iddespesas)).Status(THTTPStatus.Created)
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
  servico: TDespesas;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TDespesas.Create;
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
  servico: TDespesas;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TDespesas.Create;
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
  servico: TDespesas;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
  idEmpresaStr, iddespesas: string;

begin
  servico := TDespesas.Create;
  erro := '';
  try
    try
      body := Req.body<TJSONObject>;
      iddespesas := body.getvalue<string>('idempresa', '');

      if (iddespesas <> '') and strisint(iddespesas) then
        servico.iddespesas := body.getvalue<integer>('iddespesas', 0)
      else
        servico.iddespesas := 0;


      servico.datalancamento := body.GetValue<string>('datalancamento', '');
      servico.valordespesa := body.GetValue<string>('valordespesa', '');
      servico.descricao := body.GetValue<string>('descricao', '');
      servico.comprovante := body.GetValue<string>('comprovante', '');
      servico.observacao := body.GetValue<string>('observacao', '');
      servico.periodicidade := body.GetValue<string>('periodicidade', '');
      servico.categoria := body.GetValue<string>('categoria', '');
      servico.periodo := body.GetValue<string>('periodo', '');
      servico.valordaparcela := body.GetValue<string>('valordaparcela', '');
      servico.dataInicio := body.GetValue<string>('dataInicio', '');
      servico.parceladoEm := body.GetValue<string>('parceladoEm', '');
      servico.despesacadastradapor := body.GetValue<string>('despesacadastradapor', '');

      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      idEmpresaStr := body.getvalue<string>('idempresa', '');

      if (idEmpresaStr <> '') and strisint(idEmpresaStr) then
        servico.idempresa := body.getvalue<integer>('idempresa', 0)
      else
        servico.idempresa := 0;


      if strisint(body.getvalue<string>('idpessoa', '')) then
        servico.idpessoa := body.getvalue<integer>('idpessoa', 0)
      else
        servico.idpessoa := 0;

      if strisint(body.getvalue<string>('idveiculo', '')) then
        servico.idveiculo := body.getvalue<integer>('idveiculo', 0)
      else
        servico.idveiculo := 0;

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.iddespesas)).Status(THTTPStatus.Created)
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


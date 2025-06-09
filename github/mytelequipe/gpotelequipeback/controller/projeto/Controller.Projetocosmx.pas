unit Controller.Projetocosmx;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Projetocosmx, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listapo(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure listalpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listafechamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listafechamentoporempresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Editarpagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Extratopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Extratopagamentototal(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Extratopagamentodesconto(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure historicopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure apagarpagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure demonstrativocosmx(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure relatorioconsolidadocosmx(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure relatoriohistoricopagamentocosmx(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure relatoriocontrolecosmx(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/projetocosmx', Lista);
  THorse.get('v1/projetocosmxpo', Listapo);
  THorse.get('v1/projetocosmxid', Listaid);
  THorse.Post('v1/projetocosmxid', Salva);
  THorse.get('v1/projetocosmxid/listalpu/:idc', listalpu);
  THorse.get('v1/projetocosmx/fechamento', Listafechamento);
  THorse.get('v1/projetocosmxid/fechamentoporempresa', Listafechamentoporempresa);
  THorse.get('v1/projetocosmxid/historicopagamento', historicopagamento);
  THorse.post('v1/projetocosmxid/fechamento/salvapagamento', Editarpagamento);
  THorse.get('v1/projetocosmxid/extrato', Extratopagamento);
  THorse.get('v1/projetocosmxid/extratototal', extratopagamentototal);
  THorse.get('v1/projetocosmxid/extratodesconto', Extratopagamentodesconto);
  THorse.post('v1/projetocosmxid/fechamento/apagapagamento', apagarpagamento);
  THorse.get('v1/projetocosmx/demonstrativo', demonstrativocosmx);
  THorse.get('v1/projetocosmx/relatorioconsolidadocosmx', relatorioconsolidadocosmx);
  THorse.get('v1/projetocosmx/relatoriohistoricopagamentocosmx', relatoriohistoricopagamentocosmx);
  THorse.get('v1/projetocosmx/relatoriocontrolecosmx', relatoriocontrolecosmx);
end;

procedure relatoriocontrolecosmx(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetocosmx.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.relatoriocontrolecosmx(Req.Query.Dictionary, erro);
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

procedure relatoriohistoricopagamentocosmx(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetocosmx.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.relatoriohistoricopagamentocosmx(Req.Query.Dictionary, erro);
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

procedure relatorioconsolidadocosmx(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetocosmx.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.relatorioconsolidadocosmx(Req.Query.Dictionary, erro);
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

procedure Demonstrativocosmx(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetocosmx.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.demonstrativocosmx(Req.Query.Dictionary, erro);
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

procedure apagarpagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetocosmx.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.id := body.getvalue<string>('id', '');

      if servico.excluirpagamento(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.id)).Status(THTTPStatus.Created)
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

procedure Historicopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetocosmx.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Historicopagamento(Req.Query.Dictionary, erro);
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

procedure Extratopagamentodesconto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetocosmx.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.extratopagamentodesconto(Req.Query.Dictionary, erro);
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

procedure Extratopagamentototal(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetocosmx.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Extratopagamentototal(Req.Query.Dictionary, erro);
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

procedure Extratopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetocosmx.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Extratopagamento(Req.Query.Dictionary, erro);
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

procedure Editarpagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetocosmx.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.mesfechamento := body.getvalue<string>('fechamento', '');
      servico.dataenviofechamento := body.getvalue<string>('dataenviofechamento', '');
      servico.idgeralfechamento := body.getvalue<integer>('idfechamento', 0);
      servico.porcentagem := body.getvalue<integer>('porcentagem', 0);
      servico.valor := body.getvalue<double>('valor', 0);
      if Length(servico.mesfechamento) = 0 then
        erro := 'Falta selecionar o mes de pagamento!';

      if Length(erro) = 0 then
      begin

        if (servico.consultapagamento) then
        begin
          if servico.Editarpagamento(erro) then
            Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.numero)).Status(THTTPStatus.Created)
          else
            Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
        end
        else
        begin

          if (servico.repostaalteracao = 1) then
          begin
            if servico.editarpagamento(erro) then
              Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.numero)).Status(THTTPStatus.Created)
            else
              Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
          end
          else
            Res.Send<TJSONObject>(CreateJsonObj('erro', 'Já existe pagamento nesse periodo')).Status(THTTPStatus.BadRequest);

        end;
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

procedure Listafechamentoporempresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetocosmx.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaFechamentoporempresa(Req.Query.Dictionary, erro);
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

procedure Listafechamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetocosmx.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaFechamento(Req.Query.Dictionary, erro);
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

procedure Listalpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetocosmx.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  servico.idempresa := Req.Params['idc'].ToInteger;
  qry := servico.Listalpu(Req.Query.Dictionary, erro);
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

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetocosmx.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      if strisint(body.getvalue<string>('numero', '')) then
        servico.numero := body.getvalue<integer>('numero', 0)
      else
        servico.numero := 0;

      servico.idempresa := body.getvalue<integer>('idempresa', 0);
      servico.lpu := body.getvalue<string>('lpu', '');
      servico.inicioatividadeplanejado := body.getvalue<string>('inicioatividadeplanejado', '');
      servico.inicioatividadereal := body.getvalue<string>('inicioatividadereal', '');
      servico.nomerelatorioenviado1 := body.getvalue<string>('nomerelatorioenviado1', '');
      servico.dataenvio1 := body.getvalue<string>('dataenvio1', '');
      servico.enviadopor1 := body.getvalue<string>('enviadopor1', '');
      servico.status1 := body.getvalue<string>('status1', '');
      servico.nomerelatorioenviado2 := body.getvalue<string>('nomerelatorioenviado2', '');
      servico.dataenvio2 := body.getvalue<string>('dataenvio2', '');
      servico.enviadopor2 := body.getvalue<string>('enviadopor2', '');
      servico.status2 := body.getvalue<string>('status2', '');
      servico.aprovacaocosmx := body.getvalue<string>('aprovacaocosmx', '');
      servico.valorlpu := body.getvalue<double>('valorlpu', 0);
      servico.observacao := body.getvalue<string>('observacao', '');

      servico.siteid := body.getvalue<string>('siteid', '');
      servico.sitefromto := body.getvalue<string>('sitefromto', '');
      servico.uf := body.getvalue<string>('uf', '');
      servico.region := body.getvalue<string>('regiona', '');
      servico.Infrasyte := body.getvalue<string>('infrasyte', '');
      servico.typesite := body.getvalue<string>('typesite', '');
      servico.batsw := body.getvalue<string>('batsw', '');
      servico.Qty := body.getvalue<string>('qty', '');
      servico.Owner1 := body.getvalue<string>('owner', '');
      servico.InstalledBy := body.getvalue<string>('installedby', '');
      servico.City := body.getvalue<string>('cidade', '');
      servico.Address := body.getvalue<string>('endereco', '');

      servico.notafiscal := body.getvalue<string>('notafiscal', '');

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.numero)).Status(THTTPStatus.Created)
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

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetocosmx.Create;
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

procedure Listapo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetocosmx;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetocosmx.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listapo(Req.Query.Dictionary, erro);
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
  servico: TProjetocosmx;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetocosmx.Create;
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

end.


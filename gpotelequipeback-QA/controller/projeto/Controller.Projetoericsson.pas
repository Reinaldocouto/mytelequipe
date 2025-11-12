unit Controller.Projetoericsson;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Projetoericsson, UtFuncao,
  Horse.Commons, System.IOUtils, System.Classes, Variants, System.DateUtils,
  FireDAC.Stan.Param, System.Generics.Collections, model.connection;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure ListaSelectprojeto(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure ListaSelectcolaboradorclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure ListaSelectcolaboradorpj(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaadicid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listapo(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listamigo(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listadocumentacaofinal(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listadocumentacaofinalcivilwork(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salvaengenharia(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaatividadeclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salvaatividadeclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaatividadepj(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaatividadepjengenharia(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salvaatividadepj(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salvaatividadepjengenharia(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listafechamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listafechamentoporempresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure listapagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Atualizalpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Editarpagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Extratopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure historicopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure apagarpagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Extratopagamentototal(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Extratopagamentodesconto(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure listalpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure listagemlpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure listagemgrupolpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Novocadastrotarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salvatarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Editardesconto(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure criarsite(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure ericssonRelatorioDespesas(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure regionalericsson(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure EditarEmMassaFaturamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure EditarEmMassaRollout(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListaCRQ(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure EditarCRQ(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/projetoericsson', Lista);
  THorse.get('v1/projetoericsson/fechamento', Listafechamento);
  THorse.get('v1/projetoericsson/fechamentoporempresa', Listafechamentoporempresa);
  THorse.get('v1/projetoericsson/extrato', Extratopagamento);
  THorse.get('v1/projetoericsson/extratototal', extratopagamentototal);
  THorse.get('v1/projetoericsson/extratodesconto', Extratopagamentodesconto);
  THorse.get('v1/projetoericsson/historicopagamento', historicopagamento);
  THorse.get('v1/projetoericsson/listapagamento', listapagamento);
  THorse.get('v1/projetoericsson/selectprojeto', ListaSelectprojeto);
  THorse.get('v1/projetoericsson/selectcolaboradorclt', ListaSelectcolaboradorclt);
  THorse.get('v1/projetoericsson/selectcolaboradorpj', ListaSelectcolaboradorpj);
  THorse.get('v1/projetoericssonid', Listaid);
  THorse.get('v1/projetoericssonadicid', Listaadicid);
  THorse.get('v1/projetoericsson/listapo', Listapo);
  THorse.get('v1/projetoericsson/listamigo', Listamigo);
  THorse.get('v1/projetoericsson/documentacaofinal', Listadocumentacaofinal);
  THorse.get('v1/projetoericsson/documentacaofinalcivilwork', Listadocumentacaofinalcivilwork);
  THorse.Post('v1/projetoericsson', Salva);
  THorse.Post('v1/projetoericsson/salvaengenharia', Salvaengenharia);
  THorse.get('v1/projetoericsson/listaatividadeclt', Listaatividadeclt);
  THorse.get('v1/projetoericsson/listaatividadepj', Listaatividadepj);
  THorse.get('v1/projetoericsson/listaatividadepjengenharia', Listaatividadepjengenharia);
  THorse.post('v1/projetoericsson/listaatividadeclt/salva', Salvaatividadeclt);
  THorse.post('v1/projetoericsson/listaatividadepj/salva', Salvaatividadepj);
  THorse.post('v1/projetoericsson/listaatividadepj/salvaengenharia', Salvaatividadepjengenharia);

  THorse.post('v1/projetoericsson/fechamento/salvapagamento', Editarpagamento);
  THorse.post('v1/projetoericsson/fechamento/apagapagamento', apagarpagamento);

  THorse.get('v1/projetoericsson/atualizalpu', Atualizalpu);
  THorse.get('v1/projetoericsson/listalpu/:idc/:cr', listalpu);

  THorse.get('v1/projetoericsson/listagemlpu', listagemlpu);
  THorse.get('v1/projetoericsson/selectlpu', listagemgrupolpu);

  THorse.post('v1/projetoericsson/novocadastrotarefa', Novocadastrotarefa);
  THorse.post('v1/projetoericsson/salvatarefa', salvatarefa);

  THorse.post('v1/projetoericsson/salvadesconto', Editardesconto);
  THorse.post('v1/projetoericsson/criarsite', criarsite);
  THorse.get('v1/projetoericsson/relatoriodespesas', ericssonRelatorioDespesas);
  THorse.get('v1/projetoericsson/regionalericsson', regionalericsson);
  THorse.post('v1/projetoericsson/editaremmassa', EditarEmMassaFaturamento);
  THorse.post('v1/projetoericsson/editaremmassarollout', EditarEmMassaRollout);
  THorse.post('v1/projetoericsson/crq', EditarCRQ);
  THorse.get('v1/projetoericsson/crq', ListaCRQ);
end;



procedure regionalericsson(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.regionalericsson(Req.Query.Dictionary, erro);
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

procedure Novocadastrotarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetoericsson.Create;
  try
    try
      body := Req.body<TJSONObject>;
      if servico.Novocadastrotarefa(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idtarefamigo)).Status(THTTPStatus.Created)
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

procedure Listalpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  servico.idcolaboradorpj := Req.Params['idc'].ToInteger;
  if Req.Params['cr'] = 'undefined' then
    servico.cr := '0'
  else
    servico.cr := Req.Params['cr'];
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

procedure Extratopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
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

procedure listagemgrupolpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.listagemgrupolpu(Req.Query.Dictionary, erro);
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

procedure listagemlpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.listagemlpu(Req.Query.Dictionary, erro);
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

procedure Historicopagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
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
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
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
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
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

procedure Editarpagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetoericsson.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.mespagamento := body.getvalue<string>('mespagamento', '');
      servico.porcentagem := body.getvalue<double>('porcentagem', 0);
      servico.observacaopagamento := body.getvalue<string>('observacao', '');
      servico.observacaopagamentointerna := body.getvalue<string>('observacaointerna', '');
      servico.descricaopagamento := body.getvalue<string>('servicosel', '');
      servico.popagamento := body.getvalue<string>('codigoservicosel', '');
      servico.empresapagamento := body.getvalue<string>('empresa', '');
      servico.status := body.getvalue<string>('status', '');
      servico.datadopagamento := body.GetValue<TDateTime>('datapagamento', 0);
      servico.idgeralfechamento := body.getvalue<integer>('geralfechamento', 0);
      servico.repostaalteracao := body.getvalue<integer>('repostaalteracao', 0);
      servico.numero := '0';


      if Length(servico.mespagamento) = 0 then
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
            if servico.alterarpagamento(erro) then
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

procedure apagarpagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetoericsson.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.mespagamento := body.getvalue<string>('mespagamentol', '');
      servico.descricaopagamento := body.getvalue<string>('deascricao', '');
      servico.popagamento := body.getvalue<string>('po', '');
      servico.empresapagamento := body.getvalue<string>('empresa', '');

      if Length(servico.mespagamento) = 0 then
        erro := 'Falta selecionar o mes de pagamento!';

      if Length(erro) = 0 then
      begin
        if servico.apagarpagamento(erro) then
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

procedure Atualizalpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  erro: string;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  if servico.atualizarlpu(erro) then
    Res.Send<TJSONObject>(CreateJsonObj('Retorno', 'OK')).Status(THTTPStatus.OK)
  else
    Res.Send<TJSONObject>(CreateJsonObj('Retorno', erro)).Status(THTTPStatus.InternalServerError);
end;

procedure Salvaatividadeclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  body: TJSONValue;
  JSON: TJSONObject;
  erro, xdata: string;
begin
  servico := TProjetoericsson.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      if strisint(body.getvalue<string>('idgeral', '')) then
        servico.idgeral := body.getvalue<integer>('idgeral', 0)
      else
        servico.idgeral := 0;

      servico.numero := body.getvalue<string>('numero', '');

      if strisint(body.getvalue<string>('idcolaboradorclt', '')) then
        servico.idcolaboradorclt := body.getvalue<integer>('idcolaboradorclt', 0)
      else
        servico.idcolaboradorclt := 0;

      servico.idposervico := body.getvalue<string>('idposervico', '');
      servico.descricaoservico := body.getvalue<string>('descricaoservico', '');

      try
        servico.datainicio := body.GetValue<string>('datainicioclt', '');
      except
        erro := 'Erro na Data do Inicio do Periodo;'
      end;

      try
        servico.datafim := body.GetValue<string>('datafinalclt', '');
      except
        erro := 'Erro na Data do Fim do Periodo;'
      end;

      servico.horanormalclt := body.getvalue<double>('horanormalclt', 0);
      servico.hora50clt := body.getvalue<double>('hora50clt', 0);
      servico.hora100clt := body.getvalue<double>('hora100clt', 0);

      servico.valorhora := body.getvalue<double>('valorhora', 0);

      servico.escopo := body.getvalue<string>('escopo', '');
      servico.po := body.getvalue<string>('po', '');
      servico.observacaoclt := body.getvalue<string>('observacaoclt', '');
      servico.totalhorasclt := body.getvalue<string>('totalhorasclt', '');

      if Length(erro) = 0 then
      begin
        if servico.Editaratividadeclt(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idgeral)).Status(THTTPStatus.Created)
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

procedure Salvaatividadepj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetoericsson.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      if strisint(body.getvalue<string>('idgeral', '')) then
        servico.idgeral := body.getvalue<integer>('idgeral', 0)
      else
        servico.idgeral := 0;

      servico.numero := body.getvalue<string>('numero', '');

      if strisint(body.getvalue<string>('idcolaboradorpj', '')) then
        servico.idcolaboradorpj := body.getvalue<integer>('idcolaboradorpj', 0)
      else
        servico.idcolaboradorpj := 0;

      servico.poitem := body.getvalue<string>('selecao', '');
      servico.po := body.getvalue<string>('selecao', '');
      servico.observacaopj := body.getvalue<string>('observacaopj', '');

      servico.lpuhistorico := body.getvalue<string>('lpuhistorico', '');

      try
        servico.valornegociado := StrToFloat(body.getvalue<string>('valornegociadonum', ''))
      except
        servico.valornegociado := 0;
      end;

      if Length(erro) = 0 then
      begin
        if servico.Editaratividadepj(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idgeral)).Status(THTTPStatus.Created)
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

procedure Salvaatividadepjengenharia(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetoericsson.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      if strisint(body.getvalue<string>('idgeral', '')) then
        servico.idgeral := body.getvalue<integer>('idgeral', 0)
      else
        servico.idgeral := 0;

      servico.numero := body.getvalue<string>('numero', '');

      if strisint(body.getvalue<string>('idcolaboradorpj', '')) then
        servico.idcolaboradorpj := body.getvalue<integer>('idcolaboradorpj', 0)
      else
        servico.idcolaboradorpj := 0;

      servico.po := body.getvalue<string>('numpo', '');
      servico.poitem := body.getvalue<string>('numpoitem', '');
      servico.codigo := body.getvalue<string>('codigo', '');
      servico.descricaoservico := body.getvalue<string>('descricao', '');

      servico.observacaopj := body.getvalue<string>('observacaopj', '');

      servico.lpuhistorico := body.getvalue<string>('lpuhistorico', '');

      try
        servico.valornegociado := StrToFloat(body.getvalue<string>('valornegociadonum', ''))
      except
        servico.valornegociado := 0;
      end;

      if Length(erro) = 0 then
      begin
        if servico.Editaratividadepjengenharia(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idgeral)).Status(THTTPStatus.Created)
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

procedure editardesconto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetoericsson.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.desconto := body.getvalue<double>('desconto', 0);

      servico.mespagamento := body.getvalue<string>('mespg', '');
      servico.empresapagamento := body.getvalue<string>('empresa', '');
      servico.numero := body.getvalue<string>('numerol', '');

      if Length(erro) = 0 then
      begin
        if servico.alterardesconto(erro) then
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

procedure Salvatarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetoericsson.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      if strisint(body.getvalue<string>('idtarefa', '')) then
        servico.idtarefamigo := body.getvalue<integer>('idtarefa', 0)
      else
        servico.idtarefamigo := 0;

      servico.numero := body.getvalue<string>('nobra', '');

      servico.datatarefa := body.getvalue<string>('data', '');

      servico.descricaoservico := body.getvalue<string>('descricao', '');

      servico.codigoservico := body.getvalue<string>('codigoservico', '');
      servico.site   := body.getvalue<string>('site', '');

      if Length(erro) = 0 then
      begin
        if servico.Editartarefa(erro) then
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


procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Body: TJSONObject;
  Conn: TFDConnection;
  Q: TFDQuery;
  IdGeral, IdLookup: Integer;
  Numero: string;

  function JStr(const K: string; const Default: string = ''): string;
  begin
    if Assigned(Body.Values[K]) then Result := Body.GetValue<string>(K, Default)
    else Result := Default;
  end;

  function JInt(const K: string; const Default: Integer = 0): Integer;
  begin
    if Assigned(Body.Values[K]) then Result := Body.GetValue<Integer>(K, Default)
    else Result := Default;
  end;

  // Lê Int64 mesmo se vier como string no JSON
  function JInt64Loose(const K: string; const Default: Int64 = 0): Int64;
  var
    V: TJSONValue;
    S: string;
  begin
    Result := Default;
    V := Body.Values[K];
    if not Assigned(V) then Exit;
    if V is TJSONNumber then
      Exit(TJSONNumber(V).AsInt64);
    S := Trim(V.Value);
    if S = '' then Exit(Default);
    try
      Result := StrToInt64(S);
    except
      Result := Default;
    end;
  end;

  // Normaliza o valor "booleano" em texto para a coluna VARCHAR
  // Regras:
  // - true/1/sim/ok  -> 'Ok'
  // - false/0/nao/não -> 'Não'
  // - se vier outro texto, grava como veio
  function JObraPreenchida(const K: string): string;
  var
    V: TJSONValue;
    S: string;
    B: Boolean;
  begin
    V := Body.Values[K];
    if not Assigned(V) then Exit('');

    // Se for boolean nativo
    if (V is TJSONTrue) or (V is TJSONFalse) then
    begin
      B := Body.GetValue<Boolean>(K);
      if B then
        Exit('Ok')
      else
        Exit('Não');
    end;

    // Se vier texto/numérico, normaliza
    S := LowerCase(Trim(V.Value));
    if (S = '1') or (S = 'true') or (S = 'sim') or (S = 'ok') then Exit('Ok');
    if (S = '0') or (S = 'false') or (S = 'nao') or (S = 'não') then Exit('Não');

    // qualquer outro texto: grava como veio
    Result := V.Value;
  end;

  procedure SetDateParam(const PName, V: string);
  var
    D: TDateTime;
    P: TFDParam;
    ok: Boolean;
    Y,M,DD: Word;
  begin
    P := Q.ParamByName(PName);
    P.DataType := ftDate;

    if Trim(V) = '' then
    begin
      P.Clear;
      Exit;
    end;

    ok := TryStrToDate(V, D); // dd/mm/yyyy
    if not ok then
    begin
      ok := (Length(V) >= 10) and (V[5]='-') and (V[8]='-'); // yyyy-mm-dd
      if ok then
      try
        Y := StrToInt(Copy(V,1,4));
        M := StrToInt(Copy(V,6,2));
        DD:= StrToInt(Copy(V,9,2));
        D := EncodeDate(Y,M,DD);
      except
        ok := False;
      end;
    end;

    if ok then P.AsDate := D else P.Clear;
  end;

  procedure BindParamsObra;
  var
    P: TFDParam;
    IdDet: Int64;
  begin
    // básicos
    Q.ParamByName('numero').AsString := Numero;
    Q.ParamByName('cliente').AsString := JStr('cliente');
    Q.ParamByName('regiona').AsString := JStr('regiona');
    Q.ParamByName('site').AsString := JStr('site');
    Q.ParamByName('situacaoimplantacao').AsString := JStr('situacaoimplantacao');
    Q.ParamByName('situacaodaintegracao').AsString := JStr('situacaodaintegracao');

    // datas existentes
    SetDateParam('datadacriacaodademandadia',        JStr('datadacriacaodademandadia'));
    SetDateParam('dataaceitedemandadia',             JStr('dataaceitedemandadia'));
    SetDateParam('datainicioentregamosplanejadodia', JStr('datainicioentregamosplanejadodia'));
    SetDateParam('datarecebimentodositemosreportadodia', JStr('datarecebimentodositemosreportadodia'));
    SetDateParam('datafiminstalacaoplanejadodia',    JStr('datafiminstalacaoplanejadodia'));
    SetDateParam('dataconclusaoreportadodia',        JStr('dataconclusaoreportadodia'));
    SetDateParam('datavalidacaoinstalacaodia',       JStr('datavalidacaoinstalacaodia'));
    SetDateParam('dataintegracaoplanejadodia',       JStr('dataintegracaoplanejadodia'));
    SetDateParam('datavalidacaoeriboxedia',          JStr('datavalidacaoeriboxedia'));

    // novos
    Q.ParamByName('statussydle').AsString := JStr('statussydle');
    Q.ParamByName('atividade').AsString   := JStr('atividade');
    Q.ParamByName('tipoinstalacao').AsString := JStr('tipoinstalacao');
    Q.ParamByName('impacto').AsString     := JStr('impacto');
    Q.ParamByName('ncrq').AsString        := JStr('ncrq');
    SetDateParam('iniciocrq',             JStr('iniciocrq'));
    SetDateParam('fimcrq',                JStr('fimcrq'));
    Q.ParamByName('statuscrq').AsString   := JStr('statuscrq');
    Q.ParamByName('crqdeinstalacao').AsString := JStr('crqdeinstalacao');
    Q.ParamByName('observacoes').AsString := JStr('observacoes');
    Q.ParamByName('central').AsString     := JStr('central');
    Q.ParamByName('detentora').AsString   := JStr('detentora');

    // iddentedora (pode vir string ou número)
    IdDet := JInt64Loose('iddentedora', 0);
    P := Q.ParamByName('iddentedora');
    P.DataType := ftLargeint;
    if IdDet = 0 then P.Clear else P.AsLargeInt := IdDet;

    Q.ParamByName('numeroativo').AsString := JStr('numeroativo');

    // >>> AQUI O AJUSTE PRINCIPAL <<<
    // coluna é VARCHAR, então gravamos string normal (normalizando quando boolean-like)
    Q.ParamByName('obraPreenchidaNaSydle').AsString := JObraPreenchida('obraPreenchidaNaSydle');

    Q.ParamByName('enderecoSite').AsString := JStr('enderecoSite');

    SetDateParam('dataativacaoplanejadodia', JStr('dataativacaoplanejadodia'));
    SetDateParam('dataativacaoreportadodia', JStr('dataativacaoreportadodia'));
    SetDateParam('datavalidacaoativacaodia', JStr('datavalidacaoativacaodia'));
    SetDateParam('dataaceiteeriboxedia',     JStr('dataaceiteeriboxedia'));
    SetDateParam('dataativacaoeriboxedia',   JStr('dataativacaoeriboxedia'));

    // acesso/geo
    Q.ParamByName('outros').AsString        := JStr('outros');
    Q.ParamByName('formadeacesso').AsString := JStr('formaAcesso');
    Q.ParamByName('ddd').AsString           := JStr('ddd');
    Q.ParamByName('municipio').AsString     := JStr('municipio');
    Q.ParamByName('nomeericsson').AsString  := JStr('nomeEricsson');
    Q.ParamByName('latitude').AsString      := JStr('latitude');
    Q.ParamByName('longitude').AsString     := JStr('longitude');
    Q.ParamByName('obs').AsString           := JStr('obs');
    Q.ParamByName('solicitacao').AsString   := JStr('solicitacao');
    Q.ParamByName('statusacesso').AsString  := JStr('statusAcesso');

    // camelCase -> snake (datas adicionais)
    SetDateParam('datasolicitacao', JStr('dataSolicitacao'));
    SetDateParam('datainicial',     JStr('dataInicial'));
    SetDateParam('datafinal',       JStr('dataFinal'));
  end;

  procedure SaveEquipeFixa(const ObraId: Integer);
  var
    ArrIds, ArrNomes: TJSONArray;
    I: Integer;
    PessoaId: Integer;
    PessoaNome: string;
  begin
    ArrIds := nil; ArrNomes := nil;
    Body.TryGetValue<TJSONArray>('equipefixaIds', ArrIds);
    Body.TryGetValue<TJSONArray>('equipefixaNomes', ArrNomes);

    // limpa atuais
    Q.SQL.Text := 'DELETE FROM obraericsson_equipe_fixa WHERE obraericsson_id = :id';
    Q.ParamByName('id').AsInteger := ObraId;
    Q.ExecSQL;

    if (ArrIds = nil) or (ArrIds.Count = 0) then Exit;

    // insere os novos
    Q.SQL.Text :=
      'INSERT INTO obraericsson_equipe_fixa (obraericsson_id, pessoa_id, pessoa_nome) '+
      'VALUES (:obra, :pessoa, :nome) '+
      'ON DUPLICATE KEY UPDATE pessoa_nome = VALUES(pessoa_nome)';

    for I := 0 to ArrIds.Count - 1 do
    begin
      if ArrIds.Items[I] is TJSONNumber then
        PessoaId := TJSONNumber(ArrIds.Items[I]).AsInt
      else
        PessoaId := StrToIntDef(ArrIds.Items[I].Value, 0);

      if (ArrNomes <> nil) and (I < ArrNomes.Count) then
        PessoaNome := ArrNomes.Items[I].Value
      else
        PessoaNome := '';

      Q.ParamByName('obra').AsInteger := ObraId;
      Q.ParamByName('pessoa').AsInteger := PessoaId;
      Q.ParamByName('nome').AsString := PessoaNome;
      Q.ExecSQL;
    end;
  end;

begin
  Body := Req.Body<TJSONObject>;
  Numero := JStr('numero');
  IdGeral := JInt('id', 0);

  Conn := TConnection.CreateConnection;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Conn;

    // lookup por NUMERO quando id não veio
    if (IdGeral = 0) and (Trim(Numero) <> '') then
    begin
      Q.SQL.Text := 'SELECT id FROM obraericsson WHERE numero = :numero LIMIT 1';
      Q.ParamByName('numero').AsString := Numero;
      Q.Open;
      if not Q.IsEmpty then
        IdGeral := Q.FieldByName('id').AsInteger;
      Q.Close;
    end;

    Conn.StartTransaction;
    try
      if IdGeral > 0 then
      begin
        // UPDATE
        Q.SQL.Text :=
          'UPDATE obraericsson SET '+
          'numero=:numero, cliente=:cliente, regiona=:regiona, site=:site, '+
          'situacaoimplantacao=:situacaoimplantacao, situacaodaintegracao=:situacaodaintegracao, '+
          'datadacriacaodademandadia=:datadacriacaodademandadia, dataaceitedemandadia=:dataaceitedemandadia, '+
          'datainicioentregamosplanejadodia=:datainicioentregamosplanejadodia, '+
          'datarecebimentodositemosreportadodia=:datarecebimentodositemosreportadodia, '+
          'datafiminstalacaoplanejadodia=:datafiminstalacaoplanejadodia, dataconclusaoreportadodia=:dataconclusaoreportadodia, '+
          'datavalidacaoinstalacaodia=:datavalidacaoinstalacaodia, dataintegracaoplanejadodia=:dataintegracaoplanejadodia, '+
          'datavalidacaoeriboxedia=:datavalidacaoeriboxedia, '+
          'statussydle=:statussydle, atividade=:atividade, tipoinstalacao=:tipoinstalacao, impacto=:impacto, '+
          'ncrq=:ncrq, iniciocrq=:iniciocrq, fimcrq=:fimcrq, statuscrq=:statuscrq, crqdeinstalacao=:crqdeinstalacao, '+
          'observacoes=:observacoes, central=:central, detentora=:detentora, iddentedora=:iddentedora, numeroativo=:numeroativo, '+
          'obraPreenchidaNaSydle=:obraPreenchidaNaSydle, enderecoSite=:enderecoSite, '+
          'dataativacaoplanejadodia=:dataativacaoplanejadodia, dataativacaoreportadodia=:dataativacaoreportadodia, '+
          'datavalidacaoativacaodia=:datavalidacaoativacaodia, dataaceiteeriboxedia=:dataaceiteeriboxedia, '+
          'dataativacaoeriboxedia=:dataativacaoeriboxedia, '+
          'outros=:outros, formadeacesso=:formadeacesso, ddd=:ddd, municipio=:municipio, nomeericsson=:nomeericsson, '+
          'latitude=:latitude, longitude=:longitude, obs=:obs, solicitacao=:solicitacao, statusacesso=:statusacesso, '+
          'datasolicitacao=:datasolicitacao, datainicial=:datainicial, datafinal=:datafinal '+
          'WHERE id=:id';
        BindParamsObra;
        Q.ParamByName('id').AsInteger := IdGeral;
        Q.ExecSQL;
      end
      else
      begin
        // INSERT
        Q.SQL.Text :=
          'INSERT INTO obraericsson ('+
          'numero, cliente, regiona, site, situacaoimplantacao, situacaodaintegracao, '+
          'datadacriacaodademandadia, dataaceitedemandadia, datainicioentregamosplanejadodia, '+
          'datarecebimentodositemosreportadodia, datafiminstalacaoplanejadodia, dataconclusaoreportadodia, '+
          'datavalidacaoinstalacaodia, dataintegracaoplanejadodia, datavalidacaoeriboxedia, '+
          'statussydle, atividade, tipoinstalacao, impacto, ncrq, iniciocrq, fimcrq, statuscrq, crqdeinstalacao, '+
          'observacoes, central, detentora, iddentedora, numeroativo, obraPreenchidaNaSydle, enderecoSite, '+
          'dataativacaoplanejadodia, dataativacaoreportadodia, datavalidacaoativacaodia, dataaceiteeriboxedia, dataativacaoeriboxedia, '+
          'outros, formadeacesso, ddd, municipio, nomeericsson, latitude, longitude, obs, solicitacao, statusacesso, '+
          'datasolicitacao, datainicial, datafinal) '+
          'VALUES ('+
          ':numero, :cliente, :regiona, :site, :situacaoimplantacao, :situacaodaintegracao, '+
          ':datadacriacaodademandadia, :dataaceitedemandadia, :datainicioentregamosplanejadodia, '+
          ':datarecebimentodositemosreportadodia, :datafiminstalacaoplanejadodia, :dataconclusaoreportadodia, '+
          ':datavalidacaoinstalacaodia, :dataintegracaoplanejadodia, :datavalidacaoeriboxedia, '+
          ':statussydle, :atividade, :tipoinstalacao, :impacto, :ncrq, :iniciocrq, :fimcrq, :statuscrq, :crqdeinstalacao, '+
          ':observacoes, :central, :detentora, :iddentedora, :numeroativo, :obraPreenchidaNaSydle, :enderecoSite, '+
          ':dataativacaoplanejadodia, :dataativacaoreportadodia, :datavalidacaoativacaodia, :dataaceiteeriboxedia, :dataativacaoeriboxedia, '+
          ':outros, :formadeacesso, :ddd, :municipio, :nomeericsson, :latitude, :longitude, :obs, :solicitacao, :statusacesso, '+
          ':datasolicitacao, :datainicial, :datafinal)';
        BindParamsObra;
        Q.ExecSQL;

        Q.SQL.Text := 'SELECT LAST_INSERT_ID() AS id';
        Q.Open;
        IdGeral := Q.FieldByName('id').AsInteger;
        Q.Close;
      end;

      // equipe fixa
      SaveEquipeFixa(IdGeral);

      Conn.Commit;

      Res.Send<TJSONObject>(
        TJSONObject.Create
          .AddPair('retorno', Numero)
          .AddPair('id', TJSONNumber.Create(IdGeral))
      ).Status(THTTPStatus.Created);

    except
      on E: Exception do
      begin
        Conn.Rollback;
        Res.Send<TJSONObject>(CreateJsonObj('erro', E.Message)).Status(THTTPStatus.InternalServerError);
      end;
    end;

  finally
    Q.Free;
  end;
end;


procedure Salvaengenharia(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetoericsson.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.numero := body.getvalue<string>('obraid', '');

      servico.poitem := body.getvalue<string>('numpoitem', '');
      servico.po := body.getvalue<string>('numpo', '');

      if Length(erro) = 0 then
      begin
        if servico.Editarengenharia(erro) then
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

procedure criarsite(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TProjetoericsson.Create;
  try
    erro := '';
    try
      body := Req.body<TJSONObject>;

      servico.numero := body.getvalue<string>('obraid', '');
      servico.cliente := body.getvalue<string>('nome', '');
      servico.site := body.getvalue<string>('site', '');
      servico.regiona := body.getvalue<string>('regional', '');

      if Length(erro) = 0 then
      begin
        if servico.criarsite(erro) then
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
  servico: TProjetoericsson;
  qry, qEquipes: TFDQuery;
  erro, msg: string;
  arraydados: TJSONArray;
  i, vObraId: Integer;
  obj: TJSONObject;
  obraIds: TList<Integer>;
  idsSet: TDictionary<Integer, Byte>;
  mapIds: TObjectDictionary<Integer, TJSONArray>;
  mapNomes: TObjectDictionary<Integer, TJSONArray>;
  arrIds, arrNomes: TJSONArray;
  Conn: TFDConnection;

  function GetJsonInt(const O: TJSONObject; const Keys: array of string): Integer;
  var
    k: string;
    V: TJSONValue;
    S: string;
  begin
    Result := 0;
    for k in Keys do
    begin
      V := O.Values[k];
      if (V = nil) or V.Null then Continue;
      if V is TJSONNumber then Exit(TJSONNumber(V).AsInt);
      S := Trim(V.Value);
      if S <> '' then Exit(StrToIntDef(S, 0));
    end;
  end;

  function BuildInList(const L: TList<Integer>): string;
  var
    j: Integer;
    sb: TStringBuilder;
  begin
    sb := TStringBuilder.Create;
    try
      sb.Append('(');
      for j := 0 to L.Count - 1 do
      begin
        if j > 0 then sb.Append(',');
        sb.Append(IntToStr(L[j]));
      end;
      sb.Append(')');
      Result := sb.ToString;
    finally
      sb.Free;
    end;
  end;

begin
  // cria o serviço (conexão do model)
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro','Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  // busca a lista base
  qry := servico.Lista(Req.Query.Dictionary, erro);
  try
    if (erro <> '') or (qry = nil) then
    begin
      if erro <> '' then msg := erro else msg := 'Falha ao executar consulta';
      Res.Send<TJSONObject>(CreateJsonObj('erro', msg)).Status(THTTPStatus.InternalServerError);
      Exit;
    end;

    arraydados := qry.ToJSONArray;

    // 1) Coleta obraIds únicos
    obraIds := TList<Integer>.Create;
    idsSet  := TDictionary<Integer, Byte>.Create;
    try
      for i := 0 to arraydados.Count - 1 do
        if arraydados.Items[i] is TJSONObject then
        begin
          obj := TJSONObject(arraydados.Items[i]);
          vObraId := GetJsonInt(obj, ['obraId','obraid','obra_id','id']);
          if (vObraId > 0) and (not idsSet.ContainsKey(vObraId)) then
          begin
            idsSet.Add(vObraId, 0);
            obraIds.Add(vObraId);
          end;
        end;

      // 2) Mapeia todas as equipes em uma única query
      mapIds   := TObjectDictionary<Integer, TJSONArray>.Create([doOwnsValues]);
      mapNomes := TObjectDictionary<Integer, TJSONArray>.Create([doOwnsValues]);
      try
        if obraIds.Count > 0 then
        begin
          Conn := TConnection.CreateConnection;  // conexão local, rápida e independente
          try
            qEquipes := TFDQuery.Create(nil);
            try
              qEquipes.Connection := Conn;
              qEquipes.SQL.Text :=
                'SELECT obraericsson_id, pessoa_id, pessoa_nome '+
                'FROM obraericsson_equipe_fixa '+
                'WHERE obraericsson_id IN ' + BuildInList(obraIds) + ' '+
                'ORDER BY obraericsson_id, id';
              qEquipes.Open;

              while not qEquipes.Eof do
              begin
                vObraId := qEquipes.FieldByName('obraericsson_id').AsInteger;

                if not mapIds.TryGetValue(vObraId, arrIds) then
                begin
                  arrIds := TJSONArray.Create;
                  mapIds.Add(vObraId, arrIds);
                end;
                if not mapNomes.TryGetValue(vObraId, arrNomes) then
                begin
                  arrNomes := TJSONArray.Create;
                  mapNomes.Add(vObraId, arrNomes);
                end;

                arrIds.AddElement(TJSONNumber.Create(qEquipes.FieldByName('pessoa_id').AsInteger));
                arrNomes.AddElement(TJSONString.Create(qEquipes.FieldByName('pessoa_nome').AsString));

                qEquipes.Next;
              end;
            finally
              qEquipes.Free;
            end;
          finally
            Conn.Free;
          end;
        end;

        // 3) Anexa os arrays (ou vazios) em cada item do JSON
        for i := 0 to arraydados.Count - 1 do
          if arraydados.Items[i] is TJSONObject then
          begin
            obj := TJSONObject(arraydados.Items[i]);
            vObraId := GetJsonInt(obj, ['obraId','obraid','obra_id','id']);

            // normaliza chaves do id da obra
            if (vObraId > 0) and (obj.Values['obraId'] = nil) then
              obj.AddPair('obraId', TJSONNumber.Create(vObraId));
            if (vObraId > 0) and (obj.Values['id'] = nil) then
              obj.AddPair('id', TJSONNumber.Create(vObraId));

            // remove pares antigos se existirem (evita duplicar)
            if obj.Values['equipefixaIds'] <> nil then
              obj.RemovePair('equipefixaIds').Free;
            if obj.Values['equipefixaNomes'] <> nil then
              obj.RemovePair('equipefixaNomes').Free;

            // pega arrays mapeadas ou cria vazias
            if not mapIds.TryGetValue(vObraId, arrIds) then
              arrIds := TJSONArray.Create;
            if not mapNomes.TryGetValue(vObraId, arrNomes) then
              arrNomes := TJSONArray.Create;

            // adiciona cópias (Clone) para não compartilhar instância entre itens
            obj.AddPair('equipefixaIds',  arrIds.Clone as TJSONArray);
            obj.AddPair('equipefixaNomes', arrNomes.Clone as TJSONArray);
          end;

      finally
        mapIds.Free;
        mapNomes.Free;
      end;

    finally
      obraIds.Free;
      idsSet.Free;
    end;

    Res.Send<TJSONArray>(arraydados).Status(THTTPStatus.OK);

  except
    on ex: Exception do
      Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
  end;

  qry.Free;
  servico.Free;
end;

procedure ListaCRQ(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaCRQ(Req.Query.Dictionary, erro);
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
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
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

procedure Listafechamentoporempresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
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

procedure listapagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.listapagamento(Req.Query.Dictionary, erro);
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
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
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

procedure ListaSelectprojeto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaSelect1(Req.Query.Dictionary, erro);
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

procedure ListaSelectcolaboradorclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaSelectcolaboradorclt(Req.Query.Dictionary, erro);
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

procedure ListaSelectcolaboradorpj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaSelectcolaboradorpj(Req.Query.Dictionary, erro);
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

procedure Listamigo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;

  qry := servico.Listamigo(Req.Query.Dictionary, erro);
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

procedure Listadocumentacaofinal(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;

  qry := servico.Listadocumentacaofinal(Req.Query.Dictionary, erro);
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

procedure Listadocumentacaofinalcivilwork(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;

  qry := servico.Listadocumentacaofinalcivilwork(Req.Query.Dictionary, erro);
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
  servico: TProjetoericsson;
  qry, qEquipe: TFDQuery;
  erro: string;
  dados: TJSONObject;
  arrIds, arrNomes: TJSONArray;
  Conn: TFDConnection;
  ObraId: Integer;
  SId: string;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  qry := servico.Listaid(Req.Query.Dictionary, erro);
  try
    if erro <> '' then
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
      Exit;
    end;

    dados := qry.ToJSONObject;

    // tenta obraId (camelCase), depois obra_id (snake), depois id
    if Assigned(dados.Values['obraId']) then
      ObraId := dados.GetValue<Integer>('obraId', 0)
    else if Assigned(dados.Values['obra_id']) then
      ObraId := dados.GetValue<Integer>('obra_id', 0)
    else if Assigned(dados.Values['id']) then
      ObraId := dados.GetValue<Integer>('id', 0)
    else if Req.Query.TryGetValue('id', SId) then
      ObraId := StrToIntDef(SId, 0)
    else
      ObraId := 0;

    arrIds := TJSONArray.Create;
    arrNomes := TJSONArray.Create;

    if ObraId > 0 then
    begin
      Conn := TConnection.CreateConnection;
      try
        qEquipe := TFDQuery.Create(nil);
        try
          qEquipe.Connection := Conn;
          qEquipe.SQL.Text :=
            'SELECT pessoa_id, pessoa_nome ' +
            'FROM obraericsson_equipe_fixa ' +
            'WHERE obraericsson_id = :id ' +
            'ORDER BY id';
          qEquipe.ParamByName('id').AsInteger := ObraId;
          qEquipe.Open;

          while not qEquipe.Eof do
          begin
            arrIds.AddElement(TJSONNumber.Create(qEquipe.FieldByName('pessoa_id').AsInteger));
            arrNomes.AddElement(TJSONString.Create(qEquipe.FieldByName('pessoa_nome').AsString));
            qEquipe.Next;
          end;
        finally
          qEquipe.Free;
        end;
      finally
        Conn.Free;
      end;
    end;

    dados.AddPair('equipefixaIds', arrIds);
    dados.AddPair('equipefixaNomes', arrNomes);

    Res.Send<TJSONObject>(dados).Status(THTTPStatus.OK);
  except
    on ex: Exception do
      Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
  end;

  qry.Free;
  servico.Free;
end;



procedure Listaadicid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaadicid(Req.Query.Dictionary, erro);
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

procedure Listaatividadeclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaatividadeclt(Req.Query.Dictionary, erro);
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

procedure Listaatividadepj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaatividadepj(Req.Query.Dictionary, erro);
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

procedure Listaatividadepjengenharia(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaatividadepjengenharia(Req.Query.Dictionary, erro);
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

procedure ericssonRelatorioDespesas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TProjetoericsson.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ObterRelatorioDespesas(Req.Query.Dictionary, erro);
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


procedure EditarEmMassaFaturamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  body: TJSONObject;
  jsonBody: string;
  erro: string;
  sucesso: Boolean;
begin
  servico := TProjetoericsson.Create;
  try
    erro := '';
    try
      body := Req.Body<TJSONObject>;

      // Converter o JSONObject para string para passar para EditarEmMassa
      jsonBody := body.ToString;
      sucesso := servico.EditarEmMassa(jsonBody, erro);

      if sucesso then
        Res.Send<TJSONObject>(TJSONObject.Create.AddPair('sucesso', 'true')
          .AddPair('mensagem', 'Registros atualizados com sucesso'))
          .Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(TJSONObject.Create.AddPair('erro', erro))
          .Status(THTTPStatus.InternalServerError);

    except
      on ex: exception do
        Res.Send<TJSONObject>(TJSONObject.Create.AddPair('erro', ex.Message))
          .Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;


procedure EditarEmMassaRollout(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  body: TJSONObject;
  erro: string;
  sucesso: Boolean;
  numeros: TArray<string>;
begin
  servico := TProjetoericsson.Create;
  try
    erro := '';
    try
      // Obter o corpo da requisição como JSONObject
      body := Req.Body<TJSONObject>;

      servico.datadacriacaodademandadia        := body.GetValue<string>('datadacriacaodademandadia', '');
      servico.dataaceitedemandadia             := body.GetValue<string>('dataaceitedemandadia', '');
      servico.datainicioentregamosplanejadodia := body.GetValue<string>('datainicioentregamosplanejadodia', '');
      servico.datarecebimentodositemosreportadodia := body.GetValue<string>('datarecebimentodositemosreportadodia', '');
      servico.datafiminstalacaoplanejadodia    := body.GetValue<string>('datafiminstalacaoplanejadodia', '');
      servico.dataconclusaoreportadodia        := body.GetValue<string>('dataconclusaoreportadodia', '');
      servico.datavalidacaoinstalacaodia       := body.GetValue<string>('datavalidacaoinstalacaodia', '');
      servico.dataintegracaoplanejadodia       := body.GetValue<string>('dataintegracaoplanejadodia', '');
      servico.datavalidacaoeriboxedia          := body.GetValue<string>('datavalidacaoeriboxedia', '');
      servico.dataintegracaoreportadodia       := body.GetValue<string>('dataintegracaoreportadodia', '');
      servico.dataaceitereportadodia           := body.GetValue<string>('dataaceitereportadodia', '');
      servico.dataativacaoplanejadodia         := body.GetValue<string>('dataativacaoplanejadodia', '');
      servico.dataativacaoreportadodia         := body.GetValue<string>('dataativacaoreportadodia', '');
      servico.datavalidacaoativacaodia         := body.GetValue<string>('datavalidacaoativacaodia', '');
      servico.dataaceiteeriboxedia             := body.GetValue<string>('dataaceiteeriboxedia', '');
      servico.dataativacaoeriboxedia           := body.GetValue<string>('dataativacaoeriboxedia', '');
      servico.datainicial                      := body.GetValue<string>('datainicial', '');
      servico.datafinal                        := body.GetValue<string>('datafinal', '');
      servico.datasolicitacao                  := body.GetValue<string>('datasolicitacao', '');
      servico.enderecoSite                     := body.GetValue<string>('enderecoSite', '');
      servico.obs                              := body.GetValue<string>('obs', '');
      servico.situacaoimplantacao              := body.GetValue<string>('situacaoimplantacao', '');
      servico.situacaodaintegracao             := body.GetValue<string>('situacaodaintegracao', '');
      servico.outros                           := body.GetValue<string>('outros', '');
      servico.formadeacesso                    := body.GetValue<string>('formaAcesso', '');
      servico.ddd                              := body.GetValue<string>('ddd', '');
      servico.municipio                        := body.GetValue<string>('municipio', '');
      servico.nomeericsson                     := body.GetValue<string>('nomeericsson', '');
      servico.latitude                         := body.GetValue<string>('latitude', '');
      servico.longitude                        := body.GetValue<string>('longitude', '');
      servico.solicitacao                      := body.GetValue<string>('solicitacao', '');
      servico.statusacesso                     := body.GetValue<string>('statusacesso', '');

      // Aqui estava o erro -> faltava fechar corretamente e indicar a chave do JSON
      numeros := body.GetValue<TArray<string>>('numeros', []);

      // Chamar o método EditarEmMassa passando os dados
      sucesso := servico.EditarEmMassaRollout(numeros, erro);

      if sucesso then
        Res.Send<TJSONObject>(
          TJSONObject.Create
            .AddPair('sucesso', 'true')
            .AddPair('mensagem', 'Registros atualizados com sucesso')
        ).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(
          TJSONObject.Create
            .AddPair('erro', erro)
        ).Status(THTTPStatus.InternalServerError);

    except
      on ex: Exception do
        Res.Send<TJSONObject>(
          TJSONObject.Create
            .AddPair('erro', ex.Message)
        ).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

procedure EditarCRQ(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TProjetoericsson;
  erro: string;
  sucesso: Boolean;
  resultado: TJSONObject;
  jsonBody: TJSONObject;
begin
  servico := TProjetoericsson.Create;
  try
    try
      // Pega o body e converte para JSON
      jsonBody := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
      try
        if not Assigned(jsonBody) then
        begin
          resultado := TJSONObject.Create
            .AddPair('sucesso', TJSONBool.Create(False))
            .AddPair('erro', 'Body da requisição não é um JSON válido');
          Res.Send<TJSONObject>(resultado).Status(THTTPStatus.BadRequest);
          Exit;
        end;

        // Chama seu serviço passando o body JSON
        sucesso := servico.EditarCRQ(jsonBody, erro);

        if sucesso then
        begin
          resultado := TJSONObject.Create
            .AddPair('sucesso', TJSONBool.Create(True))
            .AddPair('mensagem', 'CRQ salva com sucesso');
          Res.Send<TJSONObject>(resultado).Status(THTTPStatus.OK);
        end
        else
        begin
          resultado := TJSONObject.Create
            .AddPair('sucesso', TJSONBool.Create(False))
            .AddPair('erro', erro);
          Res.Send<TJSONObject>(resultado).Status(THTTPStatus.BadRequest);
        end;
      finally
        jsonBody.Free; // libera o JSON do body
      end;
    except
      on E: Exception do
      begin
        resultado := TJSONObject.Create
          .AddPair('sucesso', TJSONBool.Create(False))
          .AddPair('erro', 'Erro ao processar requisição: ' + E.Message);
        Res.Send<TJSONObject>(resultado).Status(THTTPStatus.InternalServerError);
      end;
    end;
  finally
    servico.Free;
  end;
end;


end.


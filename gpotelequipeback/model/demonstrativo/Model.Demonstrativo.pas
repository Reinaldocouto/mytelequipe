unit Model.Demonstrativo;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TDemonstrativo = class
  private
    FConn: TFDConnection;
    Fidunidade: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
    Fdescricao: string;
    Fsigla: string;

  public
    constructor Create;
    destructor Destroy; override;

    property idunidade: Integer read Fidunidade write Fidunidade;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property descricao: string read Fdescricao write Fdescricao;
    property sigla: string read Fsigla write Fsigla;

    function valorrecebimento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function recebidoxgasto(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function demonstra(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ofensores(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function totalacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function recebidoxgastosumary(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function relatoriopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function despesaspjacionados(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function despesascltacionados(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function despesassiteinstall(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function despesasvalorexecutado(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function despesasvalorpj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function despesasdiaria(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function despesasvaloriss(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function despesasvalorpiscofins(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function despesasvalorcsll(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function despesasvalorir(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function despesasinss(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function relatorioprevisao(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function painelcontrole(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;

  end;

implementation

{ TDemonstrativo }

constructor TDemonstrativo.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TDemonstrativo.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TDemonstrativo.ofensores(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('obraericssonmigo.statuspo, ');
      SQL.Add('Concat(''R$ '', Replace(Replace(Replace(Format(COALESCE(Sum(obraericssonmigo.medidafiltro),0), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As valor ');
      SQL.Add('From ');
      SQL.Add('obraericssonmigo Inner Join ');
      SQL.Add('obraericsson On obraericsson.numeroint = obraericssonmigo.id ');
      SQL.Add('where obraericssonmigo.statuspo <> ''Com MIGO'' and obraericssonmigo.sigla=''N'' and obraericsson.datavalidacaoinstalacaodia is not null ');
      if AQuery.ContainsKey('cliente') then
      begin
        if Length(AQuery.Items['cliente']) > 0 then
        begin
          SQL.Add('AND (obraericsson.cliente like ''%' + AQuery.Items['cliente'] + '%'') ');
        end;
      end;
      if AQuery.ContainsKey('regiona') then
      begin
        if Length(AQuery.Items['regiona']) > 0 then
        begin
          SQL.Add('AND (obraericsson.regiona like ''%' + AQuery.Items['regiona'] + '%'') ');
        end;
      end;
      if AQuery.ContainsKey('site') then
      begin
        if Length(AQuery.Items['site']) > 0 then
        begin
          SQL.Add('AND (obraericsson.site like ''%' + AQuery.Items['site'] + '%'') ');
        end;
      end;
      if AQuery.ContainsKey('rfp') then
      begin
        if Length(AQuery.Items['rfp']) > 0 then
        begin
          if AQuery.Items['rfp'] <> 'todos' then
            SQL.Add('AND (obraericsson.rfp like ''%' + AQuery.Items['rfp'] + '%'') ');
        end;
      end;
      SQL.Add('Group By ');
      SQL.Add('obraericssonmigo.statuspo');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.painelcontrole(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  anoStr, site, regional: string;
  anoInt: Integer;
begin
  qry := nil;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    // Configuração da query SQL
    with qry do
    begin
      SQL.Clear;
     SQL.Add('SELECT');
    SQL.Add('  -- Etapa MOS');
    SQL.Add('  COUNT(CASE WHEN `Baseline MOS` IS NOT NULL THEN seed END) AS total_mos,');
    SQL.Add('  COUNT(CASE WHEN mosreal IS NOT NULL AND mosreal <= `Baseline MOS` THEN seed END) AS mos_concluido,');
    SQL.Add('  COUNT(CASE WHEN mosreal IS NULL AND `Baseline MOS` IS NOT NULL THEN seed END) AS mos_andamento,');
    SQL.Add('  COUNT(CASE WHEN mosreal > `Baseline MOS` THEN seed END) AS mos_atrasado,');

    SQL.Add('  -- Etapa Instalação');
    SQL.Add('  COUNT(CASE WHEN `Baseline Fim Instalação` IS NOT NULL THEN seed END) AS total_instalacao,');
    SQL.Add('  COUNT(CASE WHEN fiminstalacaoreal IS NOT NULL AND fiminstalacaoreal <= `Baseline Fim Instalação` THEN seed END) AS instalacao_concluida,');
    SQL.Add('  COUNT(CASE WHEN fiminstalacaoreal IS NULL AND `Baseline Fim Instalação` IS NOT NULL THEN seed END) AS instalacao_andamento,');
    SQL.Add('  COUNT(CASE WHEN fiminstalacaoreal > `Baseline Fim Instalação` THEN seed END) AS instalacao_atrasado,');

    SQL.Add('  -- Etapa Validação');
    SQL.Add('  COUNT(CASE WHEN fiminstalacaoreal IS NOT NULL THEN seed END) AS total_validacao,');
    SQL.Add('  COUNT(CASE WHEN validacaoinstalacao IS NOT NULL THEN seed END) AS validacao_concluida,');
    SQL.Add('  COUNT(CASE WHEN validacaoinstalacao IS NULL AND fiminstalacaoreal IS NOT NULL THEN seed END) AS validacao_andamento,');
    SQL.Add('  0 AS validacao_atrasado,');  // Sem base de atraso

    SQL.Add('  -- Etapa Integração');
    SQL.Add('  COUNT(CASE WHEN `Baseline Integração` IS NOT NULL THEN seed END) AS total_integracao,');
    SQL.Add('  COUNT(CASE WHEN integracaoconfirmada IS NOT NULL AND integracaoconfirmada <= `Baseline Integração` THEN seed END) AS integracao_concluida,');
    SQL.Add('  COUNT(CASE WHEN integracaoconfirmada IS NULL AND `Baseline Integração` IS NOT NULL THEN seed END) AS integracao_andamento,');
    SQL.Add('  COUNT(CASE WHEN integracaoconfirmada > `Baseline Integração` THEN seed END) AS integracao_atrasado,');

    SQL.Add('  -- Etapa Documentação');
    SQL.Add('  COUNT(CASE WHEN integracaoconfirmada IS NOT NULL THEN seed END) AS total_documentacao,');
    SQL.Add('  COUNT(CASE WHEN doc.documentacaosituacaovalidacao = ''Validação Completa'' THEN seed END) AS documentacao_concluida,');
    SQL.Add('  COUNT(CASE WHEN doc.documentacaosituacaovalidacao IS NULL OR doc.documentacaosituacaovalidacao <> ''Validação Completa'' THEN seed END) AS documentacao_andamento,');
    SQL.Add('  0 AS documentacao_atrasado,');  // Sem data para atraso

    SQL.Add('  -- Etapa Aceitação');
    SQL.Add('  COUNT(CASE WHEN `Site Apto para Aceitação Plan` IS NOT NULL THEN seed END) AS total_aceitacao,');
    SQL.Add('  COUNT(CASE WHEN aceitacaofinal IS NOT NULL AND aceitacaofinal <= `Site Apto para Aceitação Plan` THEN seed END) AS aceitacao_concluida,');
    SQL.Add('  COUNT(CASE WHEN aceitacaofinal IS NULL AND `Site Apto para Aceitação Plan` IS NOT NULL THEN seed END) AS aceitacao_andamento,');
    SQL.Add('  COUNT(CASE WHEN aceitacaofinal > `Site Apto para Aceitação Plan` THEN seed END) AS aceitacao_atrasado');

    SQL.Add('FROM obrasericssonlistasites');
    SQL.Add('LEFT JOIN (');
    SQL.Add('  SELECT numero, MAX(documentacaosituacaovalidacao) AS documentacaosituacaovalidacao');
    SQL.Add('  FROM obradocumentacaofinal');
    SQL.Add('  GROUP BY numero');
    SQL.Add(') AS doc ON doc.numero = obrasericssonlistasites.seed');
    SQL.Add('WHERE 1=1');

    if AQuery.TryGetValue('ano', anoStr) and TryStrToInt(anoStr, anoInt) then
    begin
      SQL.Add('  AND YEAR(COALESCE(mosreal, `Baseline MOS`, `Baseline Fim Instalação`, fiminstalacaoreal, integracaoconfirmada, aceitacaofinal)) = :ano');
      Params.CreateParam(ftInteger, 'ano', ptInput);
      ParamByName('ano').AsInteger := anoInt;
    end;

    if AQuery.TryGetValue('site', site) and (site.Trim <> '') then
    begin
      SQL.Add('  AND obrasericssonlistasites.site = :site');
      Params.CreateParam(ftString, 'site', ptInput);
      ParamByName('site').AsString := site;
    end;

            {
    if AQuery.TryGetValue('regional', regional) and (regional.Trim <> '') then
    begin
      // Supondo que os valores venham separados por vírgula
      regionalList := regional.Split([',']);
      SQL.Add('  AND (');
      for i := 0 to High(regionalList) do
      begin
        if i > 0 then
          SQL.Add(' OR ');
        SQL.Add(Format('obrasericssonlistasites.regional LIKE :regional%d', [i]));
        Params.CreateParam(ftString, Format('regional%d', [i]), ptInput);
        ParamByName(Format('regional%d', [i])).AsString := '%' + Trim(regionalList[i]) + '%';
      end;
      SQL.Add(')');
    end;
           }

    Open;
    end;

    erro := '';
    Result := qry;
  except
    on E: Exception do
    begin
      erro := 'Erro ao consultar painel de controle: ' + E.Message;
      FreeAndNil(qry);
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.recebidoxgasto(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('obrasericssonlistasites.FiltroRFP as rfp, ');
      SQL.Add('obraericsson.numero As id, ');
      SQL.Add('obraericsson.cliente, ');
      SQL.Add('obraericsson.regiona, ');
      SQL.Add('obraericsson.site, ');
      SQL.Add('obraericsson.situacaoimplantacao, ');
      SQL.Add('obraericsson.situacaodaintegracao, ');
      SQL.Add('Date_Format(obraericsson.datarecebimentodositemosreportadodia, ''%d/%m/%Y'') As mosreal, ');
      SQL.Add('Date_Format(obraericsson.dataconclusaoreportadodia, ''%d/%m/%Y'') As instalreal, ');
      SQL.Add('Date_Format(obraericsson.datavalidacaoeriboxedia, ''%d/%m/%Y'') As integreal, ');
      SQL.Add('Concat(''R$ '', Replace(Replace(Replace(Format(COALESCE(Sum(obraericssonmigo.medidafiltro),0), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As valorpo, ');
      SQL.Add('Concat(''R$ '', Replace(Replace(Replace(Format(COALESCE(Sum(obraericssonmigo.medidafiltrounitario * obraericssonmigo.qtdmigo),0), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As valorfaturado, ');
      SQL.Add('If(obrasericssontiposervico.tipo=''Infra'' ,'''', obrasericssonlistasites.statusdoc) As docinstalacao, ');
      SQL.Add('obradocumentacaoobracivilworks.documentacaosituacao As docinfra, ');
      SQL.Add('If(obrasericssontiposervico.tipo=''Infra'' ,'''', obrasericssonfam.Statusfamentrega) As Statusfamentrega, ');
      SQL.Add('If(obrasericssontiposervico.tipo=''Infra'' ,'''', obrasericssonfam.StatusfamInstalacao) As StatusfamInstalacao, ');
      SQL.Add('obrasericssontiposervico.tipo, ');
      SQL.Add('Date_Format(obrasericssonlistasites.aceitacaofical, ''%d/%m/%Y'') as aceitacaofical, ');
      SQL.Add('obrasericssonlistasites.PendenciasObra ');
      SQL.Add('From ');
      SQL.Add('obraericsson Left Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.id = obraericsson.numero Left Join ');
      SQL.Add('obrasericssontiposervico On obrasericssontiposervico.CÓDIGO = obraericssonmigo.codigoservico Left Join ');
      SQL.Add('obrasericssonlistasites On obrasericssonlistasites.SEED = obraericsson.numero Left Join ');
      SQL.Add('obradocumentacaoobracivilworks On obradocumentacaoobracivilworks.numero = obraericsson.numero Left Join ');
      SQL.Add('obrasericssonfam On obrasericssonfam.Obra = obraericsson.numero where obraericssonmigo.qtdmigo <> obraericssonmigo.qtyordered  ');
      SQL.Add('Group By ');
      SQL.Add('obraericsson.numero ');
      SQL.Add('Order By ');
      SQL.Add('id Desc');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.recebidoxgastosumary(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('Concat(''R$ '', Replace(Replace(Replace(Format(COALESCE(Sum(obraericssonmigo.medidafiltro),0), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As valorpo, ');
      SQL.Add('Concat(''R$ '', Replace(Replace(Replace(Format(COALESCE(Sum(obraericssonmigo.medidafiltrounitario * obraericssonmigo.qtdmigo),0), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As valorfaturado, ');
      SQL.Add('Concat(''R$ '', Replace(Replace(Replace(Format(COALESCE(Sum(obraericssonmigo.medidafiltro)-Sum(obraericssonmigo.medidafiltrounitario * obraericssonmigo.qtdmigo),0), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As faltafaturado ');
      SQL.Add('From ');
      SQL.Add('obraericsson Left Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.id = obraericsson.numero Left Join ');
      SQL.Add('obrasericssontiposervico On obrasericssontiposervico.CÓDIGO = obraericssonmigo.codigoservico Left Join ');
      SQL.Add('obrasericssonlistasites On obrasericssonlistasites.SEED = obraericsson.numero Left Join ');
      SQL.Add('obradocumentacaoobracivilworks On obradocumentacaoobracivilworks.numero = obraericsson.numero Left Join ');
      SQL.Add('obrasericssonfam On obrasericssonfam.Obra = obraericsson.numero where obraericssonmigo.qtdmigo <> obraericssonmigo.qtyordered  ');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.relatoriopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      sql.add('SET @contador := 0; ');
      sql.add('SELECT ');
      sql.add('@contador := @contador + 1 AS id, ');
      SQL.Add('obraericssonfechamento.geral, ');
      SQL.Add('obraericssonfechamento.PO, ');
      SQL.Add('obraericssonfechamento.POITEM, ');
      SQL.Add('obraericssonfechamento.Sigla, ');
      SQL.Add('obraericssonfechamento.IDSydle, ');
      SQL.Add('obraericssonfechamento.Cliente, ');
      SQL.Add('obraericssonfechamento.Estado, ');
      SQL.Add('obraericssonfechamento.Codigo, ');
      SQL.Add('obraericssonfechamento.Descricao, ');
      SQL.Add('obraericssonpagamento.mespagamento, ');
      SQL.Add('obraericssonpagamento.numero, ');
      SQL.Add('Format((obraericssonpagamento.porcentagem * 100), 2) As porcentagem, ');
      SQL.Add('Concat(''R$ '', Replace(Replace(Replace(Format(obraericssonpagamento.valorpagamento, 2), ''.'', ''|''), '','', ''.''), ''|'', ');
      SQL.Add(' '','')) As valorpagamento, ');
      SQL.Add('Concat(''R$ '', Replace(Replace(Replace(Format(obraericssonfechamento.VALORPJ, 2), ''.'', ''|''), '','', ''.''), ''|'', ');
      SQL.Add(' '','')) As VALORPJ, ');
      SQL.Add('obraericssonpagamento.observacao, ');
      SQL.Add('obraericssonfechamento.EMPRESA, ');
      SQL.Add('Date_Format(obraericsson.datarecebimentodositemosreportadodia, ''%d/%m/%Y'') As mosreal, ');
      SQL.Add('Date_Format(obraericsson.dataconclusaoreportadodia, ''%d/%m/%Y'') As instalreal, ');
      SQL.Add('Date_Format(obraericsson.datavalidacaoeriboxedia, ''%d/%m/%Y'') As integreal, ');
      SQL.Add('obrasericssonlistasites.statusdoc As docinstalacao, ');
      SQL.Add('situacaocivilwork.documentacaosituacao as docinfra ');
      SQL.Add('From ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericssonpagamento On obraericssonpagamento.idgeralfechamento = obraericssonfechamento.geral Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle  Left Join ');
      SQL.Add('obrasericssonlistasites On obrasericssonlistasites.SEED = obraericssonfechamento.IDSydle left Join ');
      SQL.Add('situacaocivilwork On situacaocivilwork.numero = obraericssonfechamento.IDSydle ');
      SQL.Add('Where ');
      SQL.Add('    obraericssonfechamento.geral Is Not Null ');
      SQL.Add('Order By ');
      SQL.Add('    obraericssonfechamento.IDSydle, ');
      SQL.Add('    obraericssonfechamento.POITEM, ');
      SQL.Add('    obraericssonpagamento.mespagamento, ');
      SQL.Add('    obraericssonfechamento.Descricao ');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.relatorioprevisao(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      sql.Clear;
      sql.add('Select ');
      sql.add('obraericssonfechamento.geral, ');
      sql.add('obraericssonfechamento.PO, ');
      sql.add('obraericssonfechamento.POITEM, ');
      sql.add('obraericssonfechamento.Sigla, ');
      sql.add('obraericssonfechamento.IDSydle, ');
      sql.add('obraericssonfechamento.Cliente, ');
      sql.add('obraericssonfechamento.Estado, ');
      sql.add('obraericssonfechamento.Codigo, ');
      sql.add('obraericssonfechamento.Descricao, ');
      sql.add('Max(obraericssonpagamento.mespagamento) As max_mespagamento, ');
      sql.add('Coalesce(Sum(obraericssonpagamento.porcentagem + obraericssonfechamento.porc1 + obraericssonfechamento.porc2 + ');
      sql.add('obraericssonfechamento.porc3), 0) As porcentagem, ');
      sql.add('Count(obraericssonfechamento.geral) As npg, ');
      sql.add('obraericssonfechamento.VALORPJ, ');
      sql.add('obraericsson.dataconclusaoreportadodia, ');
      sql.add('obraericsson.datavalidacaoeriboxedia, ');
      sql.add('Max(obraericssonpagamento.observacao) As observacao, ');
      sql.add('relatoriolinha.MOSReportadoDia, ');
      sql.add('relatoriolinha.FimInstalacaoReportadodia, ');
      sql.add('relatoriolinha.DataValidacaoERIBOXDia, ');
      sql.add('relatoriolinha.analise_de_risco_Status, ');
      sql.add('relatoriolinha.ART_Status, ');
      sql.add('relatoriolinha.ART_de_Infraestrutura_Civil_Status, ');
      sql.add('relatoriolinha.ART_de_Instalacao_Status, ');
      sql.add('relatoriolinha.BP_Status, ');
      sql.add('relatoriolinha.Check_list_de_instalacao_Status, ');
      sql.add('relatoriolinha.Checklist_de_RF_Status, ');
      sql.add('relatoriolinha.Configuração_Bateria_de_Litio_Status, ');
      sql.add('relatoriolinha.FAM_de_Instalacao_Status, ');
      sql.add('relatoriolinha.FAM_Desinstalacao_Status, ');
      sql.add('relatoriolinha.FAM_MOS_Status, ');
      sql.add('relatoriolinha.FAM_Panoramicas_Status, ');
      sql.add('relatoriolinha.FCI_Status, ');
      sql.add('relatoriolinha.Inventario_Desinstalacao_Status, ');
      sql.add('relatoriolinha.Inventario_de_instalação_Status, ');
      sql.add('relatoriolinha.Inventário_Logico_Status, ');
      sql.add('relatoriolinha.Log_de_Antes_do_Site_Status, ');
      sql.add('relatoriolinha.Log_de_Depois_do_site_Status, ');
      sql.add('relatoriolinha.PDI_Status, ');
      sql.add('relatoriolinha.PPI_Status, ');
      sql.add('relatoriolinha.Relatorio_Descarte_Status, ');
      sql.add('relatoriolinha.Relatorio_Desmontagem_Status, ');
      sql.add('relatoriolinha.Relatorio_fotografico_Status, ');
      sql.add('relatoriolinha.Relatorio_fotografico_Base_de_Concreto_padrão_ATC_Status, ');
      sql.add('relatoriolinha.Relatorio_fotografico_Outras_Infras_Status, ');
      sql.add('relatoriolinha.Relatorio_Fotografico_Suportes_Status, ');
      sql.add('relatoriolinha.Relatorio_Fotografico_Instalacao_Status, ');
      sql.add('relatoriolinha.Relatorio_Fotografico_RF_Final_Status, ');
      sql.add('relatoriolinha.Relatorio_Fotografico_RF_Inicial_Status, ');
      sql.add('relatoriolinha.Site_Status_Conclusao_da_Obra_Status, ');
      sql.add('relatoriolinha.Site_Status_MOS_Status, ');
      sql.add('relatoriolinha.SSV_Status, ');
      sql.add('relatoriolinha.Termo_Roof_Top_Inspecao_Final_Status, ');
      sql.add('relatoriolinha.Termo_Roof_Top_Inspecao_Inicial_Status, ');
      sql.add('relatoriolinha.TSSR_Status, ');
      sql.add('relatoriolinha.TSSR_as_built_Status, ');
      sql.add('relatoriolinha.Verde_e_vermelho_Status ');
      sql.add('From ');
      sql.add('    obraericssonfechamento Left Join ');
      sql.add('    obraericssonpagamento On obraericssonpagamento.idgeralfechamento = obraericssonfechamento.geral Inner Join ');
      sql.add('    obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join ');
      sql.add('    relatoriolinha On relatoriolinha.numero = obraericssonfechamento.IDSydle ');
      sql.add('Where ');
      sql.add('    (obraericssonfechamento.Descricao Like ''%COMISS%'' And ');
      sql.add('        obraericsson.datavalidacaoeriboxedia Is Not Null) Or ');
      sql.add('    (Not obraericssonfechamento.Descricao Like ''%COMISS%'' And ');
      sql.add('        obraericsson.dataconclusaoreportadodia Is Not Null) ');
      sql.add('Group By ');
      sql.add('    obraericssonfechamento.geral, ');
      sql.add('    obraericssonpagamento.idgeralfechamento ');
      sql.add('Having ');
      sql.add('    (Sum(obraericssonpagamento.porcentagem + obraericssonfechamento.porc1 + obraericssonfechamento.porc2 + ');
      sql.add('        obraericssonfechamento.porc3) < 1) Or ');
      sql.add('    (obraericssonpagamento.idgeralfechamento Is Null)');

      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;

end;

function TDemonstrativo.totalacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      sql.Clear;
      sql.add('SET @contador := 0; ');
      sql.add('SELECT ');
      sql.add('@contador := @contador + 1 AS id, ');
      sql.add('obraericssonatividadepj.numero,  ');
      sql.add('obraericssonatividadepj.po, obraericsson.site , ');
      sql.add('obraericssonatividadepj.poitem,  ');
      sql.add('gesempresas.nome,  ');
      sql.add('obraericssonatividadepj.codigoservico,  ');
      sql.add('obraericssonatividadepj.descricaoservico,  ');
      SQL.Add('Concat(''R$ '', Replace(Replace(Replace(Format(obraericssonatividadepj.valorservico, 2), ''.'', ''|''), '','', ''.''), ''|'', ');
      SQL.Add(' '','')) As valorservico, ');
      sql.add('obraericssonatividadepj.lpuhistorico,  ');
      sql.add('obraericssonatividadepj.datadeenviodoemail  ');
      sql.add('From  ');
      sql.add('obraericssonatividadepj Inner Join  ');
      sql.add('gesempresas On gesempresas.idempresa = obraericssonatividadepj.idcolaboradorpj left Join ');
      sql.add('obraericsson On obraericsson.numero = obraericssonatividadepj.numero where obraericssonatividadepj.deletado = 0 order by obraericssonatividadepj.numero,descricaoservico,codigoservico   ');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;

end;

function FormatarNumero(Numero: Double): string;
begin
  if Numero >= 1e9 then
    Result := FormatFloat('#.##0,00 bi', Numero / 1e9)
  else if Numero >= 1e6 then
    Result := FormatFloat('#.##0,00 mi', Numero / 1e6)
  else if Numero >= 1e3 then
    Result := FormatFloat('#.##0,00 mil', Numero / 1e3)
  else
    Result := FormatFloat('#.##0,00', Numero);
end;

function TDemonstrativo.valorrecebimento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('CASE ');
      SQL.Add('WHEN sum(d.total) >= 1e9 THEN CONCAT(FORMAT(sum(d.total) / 1e9, 2), '' bi'' ) ');
      SQL.Add('WHEN sum(d.total) >= 1e6 THEN CONCAT(FORMAT(sum(d.total) / 1e6, 2), '' mi'') ');
      SQL.Add('WHEN sum(d.total) >= 1e3 THEN CONCAT(FORMAT(sum(d.total) / 1e3, 2), '' mil'')');
      SQL.Add('ELSE FORMAT(sum(d.total), 2)');
      SQL.Add('END as total, ');
      SQL.Add('sum(d.sem_migo) as semmigo, ');
      SQL.Add('sum(d.com_migo) as commigo, ');
      SQL.Add('sum(d.sem_migo)+sum(d.com_migo) as soma ');
      SQL.Add('From ');
      SQL.Add('(Select ');
      SQL.Add('Sum(obraericssonmigo.medidafiltro) As total, ');
      SQL.Add('0 As sem_migo, ');
      SQL.Add('0 As com_migo ');
      SQL.Add('From ');
      SQL.Add('obraericssonmigo ');
      SQL.Add('Where ');
      SQL.Add('obraericssonmigo.sigla = ''N'' ');
      SQL.Add('Union ');
      SQL.Add('Select ');
      SQL.Add('0 As total, ');
      SQL.Add('Sum(obraericssonmigo.medidafiltro) As sem_migo, ');
      SQL.Add('0 As com_migo ');
      SQL.Add('From ');
      SQL.Add('obraericssonmigo ');
      SQL.Add('Where ');
      SQL.Add('obraericssonmigo.sigla = ''N'' And ');
      SQL.Add('obraericssonmigo.nmigo Is Null ');
      SQL.Add('Union ');
      SQL.Add('Select ');
      SQL.Add('0 As total, ');
      SQL.Add('0 As sem_migo, ');
      SQL.Add('Sum(obraericssonmigo.medidafiltro) com_migo ');
      SQL.Add('From ');
      SQL.Add('obraericssonmigo ');
      SQL.Add('Where ');
      SQL.Add('obraericssonmigo.sigla = ''N'' And ');
      SQL.Add('obraericssonmigo.nmigo Is Not Null) As d ');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.despesaspjacionados(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('SELECT ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''01'' THEN f.idcolaboradorpj END) AS JAN, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''02'' THEN f.idcolaboradorpj END) AS FEV, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''03'' THEN f.idcolaboradorpj END) AS MAR, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''04'' THEN f.idcolaboradorpj END) AS ABR, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''05'' THEN f.idcolaboradorpj END) AS MAI, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''06'' THEN f.idcolaboradorpj END) AS JUN, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''07'' THEN f.idcolaboradorpj END) AS JUL, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''08'' THEN f.idcolaboradorpj END) AS AGO, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''09'' THEN f.idcolaboradorpj END) AS `SET`, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''10'' THEN f.idcolaboradorpj END) AS `OUT`, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''11'' THEN f.idcolaboradorpj END) AS NOV, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''12'' THEN f.idcolaboradorpj END) AS DEZ ');
      SQL.Add('FROM ');
      SQL.Add('obraericssonfechamento f ');
      SQL.Add('INNER JOIN ');
      SQL.Add('obraericsson o ON o.numero = f.IDSydle ');
      SQL.Add('WHERE ');
      SQL.Add('o.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add('AND YEAR(o.dataconclusaoreportadodia) = YEAR(CURDATE())');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.despesassiteinstall(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('SELECT ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''01'' THEN o.numero END) AS JAN, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''02'' THEN o.numero END) AS FEV, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''03'' THEN o.numero END) AS MAR, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''04'' THEN o.numero END) AS ABR, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''05'' THEN o.numero END) AS MAI, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''06'' THEN o.numero END) AS JUN, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''07'' THEN o.numero END) AS JUL, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''08'' THEN o.numero END) AS AGO, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''09'' THEN o.numero END) AS `SET`, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''10'' THEN o.numero END) AS `OUT`, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''11'' THEN o.numero END) AS NOV, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''12'' THEN o.numero END) AS DEZ ');
      SQL.Add('FROM ');
      SQL.Add('obraericssonfechamento f ');
      SQL.Add('INNER JOIN ');
      SQL.Add('obraericsson o ON o.numero = f.IDSydle ');
      SQL.Add('WHERE ');
      SQL.Add('o.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add('AND YEAR(o.dataconclusaoreportadodia) = YEAR(CURDATE()) ');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.despesasvalorcsll(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('Sum(d.JAN) As sumjan, ');
      SQL.Add('Sum(d.FEV) As sumfev, ');
      SQL.Add('Sum(d.MAR) As summar, ');
      SQL.Add('Sum(d.ABR) As sumabr, ');
      SQL.Add('Sum(d.MAI) As summai, ');
      SQL.Add('Sum(d.JUN) As sumjun, ');
      SQL.Add('Sum(d.JUL) As sumjul, ');
      SQL.Add('Sum(d.AGO) As sumago, ');
      SQL.Add('Sum(d.`SET`) As sumset, ');
      SQL.Add('Sum(d.`OUT`) As sumout, ');
      SQL.Add('Sum(d.NOV) As sumnov, ');
      SQL.Add('Sum(d.DEZ) As sumdez ');
      SQL.Add('From ');
      SQL.Add('(Select ');
      SQL.Add('    Sum(Case ');
      SQL.Add('        When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-01'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorcsllretido, 0.0)) ');
      SQL.Add('    End) As ''JAN'', ');
      SQL.Add('    0 As ''FEV'', ');
      SQL.Add('    0 As ''MAR'', ');
      SQL.Add('    0 As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add(' From ');
      SQL.Add('    impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-02'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorcsllretido, 0.0)) ');
      SQL.Add('End) As ''FEV'', ');
      SQL.Add('    0 As ''MAR'', ');
      SQL.Add('    0 As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-03'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorcsllretido, 0.0)) ');
      SQL.Add('End) As ''MAR'', ');
      SQL.Add('    0 As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-04'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorcsllretido, 0.0)) ');
      SQL.Add('End) As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-05'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorcsllretido, 0.0)) ');
      SQL.Add('End) As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-06'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorcsllretido, 0.0)) ');
      SQL.Add('End) As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('0 As ''JUN'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-07'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorcsllretido, 0.0)) ');
      SQL.Add('End) As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-08'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorcsllretido, 0.0)) ');
      SQL.Add('End) As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-09'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorcsllretido, 0.0)) ');
      SQL.Add('End) As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-10'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorcsllretido, 0.0)) ');
      SQL.Add('End) As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-11'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorcsllretido, 0.0)) ');
      SQL.Add('End) As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('0 As ''JUN'', ');
      SQL.Add('0 As ''JUL'', ');
      SQL.Add('0 As ''AGO'', ');
      SQL.Add('0 As ''SET'', ');
      SQL.Add('0 As ''OUT'', ');
      SQL.Add('0 As ''NOV'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-12'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorcsllretido, 0.0)) ');
      SQL.Add('End) As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add(') as d ');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.despesasvalorexecutado(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('SELECT  ');
      SQL.Add('COALESCE(SUM(CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''01'' THEN oe.medidafiltrounitario ELSE 0 END), 0) AS JAN,  ');
      SQL.Add('COALESCE(SUM(CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''02'' THEN oe.medidafiltrounitario ELSE 0 END), 0) AS FEV,  ');
      SQL.Add('COALESCE(SUM(CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''03'' THEN oe.medidafiltrounitario ELSE 0 END), 0) AS MAR,  ');
      SQL.Add('COALESCE(SUM(CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''04'' THEN oe.medidafiltrounitario ELSE 0 END), 0) AS ABR,  ');
      SQL.Add('COALESCE(SUM(CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''05'' THEN oe.medidafiltrounitario ELSE 0 END), 0) AS MAI,  ');
      SQL.Add('COALESCE(SUM(CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''06'' THEN oe.medidafiltrounitario ELSE 0 END), 0) AS JUN,  ');
      SQL.Add('COALESCE(SUM(CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''07'' THEN oe.medidafiltrounitario ELSE 0 END), 0) AS JUL,  ');
      SQL.Add('COALESCE(SUM(CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''08'' THEN oe.medidafiltrounitario ELSE 0 END), 0) AS AGO,  ');
      SQL.Add('COALESCE(SUM(CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''09'' THEN oe.medidafiltrounitario ELSE 0 END), 0) AS `SET`,  ');
      SQL.Add('COALESCE(SUM(CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''10'' THEN oe.medidafiltrounitario ELSE 0 END), 0) AS `OUT`,  ');
      SQL.Add('COALESCE(SUM(CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''11'' THEN oe.medidafiltrounitario ELSE 0 END), 0) AS NOV,  ');
      SQL.Add('COALESCE(SUM(CASE WHEN DATE_FORMAT(o.dataconclusaoreportadodia, ''%m'') = ''12'' THEN oe.medidafiltrounitario ELSE 0 END), 0) AS DEZ  ');
      SQL.Add('FROM  ');
      SQL.Add('obraericssonfechamento f  ');
      SQL.Add('INNER JOIN  ');
      SQL.Add('obraericsson o ON o.numero = f.IDSydle  ');
      SQL.Add('LEFT JOIN  ');
      SQL.Add('obraericssonmigo oe ON oe.poritem = f.POITEM  ');
      SQL.Add('WHERE  ');
      SQL.Add('o.situacaoimplantacao <> ''Cancelado''  ');
      SQL.Add('AND YEAR(o.dataconclusaoreportadodia) = YEAR(CURDATE())');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.despesasvalorir(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('Sum(d.JAN) As sumjan, ');
      SQL.Add('Sum(d.FEV) As sumfev, ');
      SQL.Add('Sum(d.MAR) As summar, ');
      SQL.Add('Sum(d.ABR) As sumabr, ');
      SQL.Add('Sum(d.MAI) As summai, ');
      SQL.Add('Sum(d.JUN) As sumjun, ');
      SQL.Add('Sum(d.JUL) As sumjul, ');
      SQL.Add('Sum(d.AGO) As sumago, ');
      SQL.Add('Sum(d.`SET`) As sumset, ');
      SQL.Add('Sum(d.`OUT`) As sumout, ');
      SQL.Add('Sum(d.NOV) As sumnov, ');
      SQL.Add('Sum(d.DEZ) As sumdez ');
      SQL.Add('From ');
      SQL.Add('(Select ');
      SQL.Add('    Sum(Case ');
      SQL.Add('        When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-01'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorirretido, 0.0)) ');
      SQL.Add('    End) As ''JAN'', ');
      SQL.Add('    0 As ''FEV'', ');
      SQL.Add('    0 As ''MAR'', ');
      SQL.Add('    0 As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('    impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-02'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorirretido, 0.0)) ');
      SQL.Add('End) As ''FEV'', ');
      SQL.Add('    0 As ''MAR'', ');
      SQL.Add('    0 As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-03'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorirretido, 0.0)) ');
      SQL.Add('End) As ''MAR'', ');
      SQL.Add('    0 As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-04'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorirretido, 0.0)) ');
      SQL.Add('End) As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-05'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorirretido, 0.0)) ');
      SQL.Add('End) As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-06'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorirretido, 0.0)) ');
      SQL.Add('End) As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('0 As ''JUN'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-07'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorirretido, 0.0)) ');
      SQL.Add('End) As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-08'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorirretido, 0.0)) ');
      SQL.Add('End) As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-09'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorirretido, 0.0)) ');
      SQL.Add('End) As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-10'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorirretido, 0.0)) ');
      SQL.Add('End) As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-11'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorirretido, 0.0)) ');
      SQL.Add('End) As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-12'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorirretido, 0.0)) ');
      SQL.Add('End) As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add(') as d ');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.despesasvalorpiscofins(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('Sum(d.JAN) As sumjan, ');
      SQL.Add('Sum(d.FEV) As sumfev, ');
      SQL.Add('Sum(d.MAR) As summar, ');
      SQL.Add('Sum(d.ABR) As sumabr, ');
      SQL.Add('Sum(d.MAI) As summai, ');
      SQL.Add('Sum(d.JUN) As sumjun, ');
      SQL.Add('Sum(d.JUL) As sumjul, ');
      SQL.Add('Sum(d.AGO) As sumago, ');
      SQL.Add('Sum(d.`SET`) As sumset, ');
      SQL.Add('Sum(d.`OUT`) As sumout, ');
      SQL.Add('Sum(d.NOV) As sumnov, ');
      SQL.Add('Sum(d.DEZ) As sumdez ');
      SQL.Add('From ');
      SQL.Add('(Select ');
      SQL.Add('    Sum(Case ');
      SQL.Add('        When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-01'' ');
      SQL.Add('        Then (Coalesce((impostosfaturamento.valorpisretido + impostosfaturamento.valorcofinsretido), 0.0)) ');
      SQL.Add('    End) As ''JAN'', ');
      SQL.Add('    0 As ''FEV'', ');
      SQL.Add('    0 As ''MAR'', ');
      SQL.Add('    0 As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('    impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-02'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valorpisretido + impostosfaturamento.valorcofinsretido), 0.0)) ');
      SQL.Add('End) As ''FEV'', ');
      SQL.Add('    0 As ''MAR'', ');
      SQL.Add('    0 As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-03'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valorpisretido + impostosfaturamento.valorcofinsretido), 0.0)) ');
      SQL.Add('End) As ''MAR'', ');
      SQL.Add('    0 As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-04'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valorpisretido + impostosfaturamento.valorcofinsretido), 0.0)) ');
      SQL.Add('End) As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-05'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valorpisretido + impostosfaturamento.valorcofinsretido), 0.0)) ');
      SQL.Add('End) As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-06'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valorpisretido + impostosfaturamento.valorcofinsretido), 0.0)) ');
      SQL.Add('End) As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('0 As ''JUN'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-07'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valorpisretido + impostosfaturamento.valorcofinsretido), 0.0)) ');
      SQL.Add('End) As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-08'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valorpisretido + impostosfaturamento.valorcofinsretido), 0.0)) ');
      SQL.Add('End) As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-09'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valorpisretido + impostosfaturamento.valorcofinsretido), 0.0)) ');
      SQL.Add('End) As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-10'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valorpisretido + impostosfaturamento.valorcofinsretido), 0.0)) ');
      SQL.Add('End) As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-11'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valorpisretido + impostosfaturamento.valorcofinsretido), 0.0)) ');
      SQL.Add('End) As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-12'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valorpisretido + impostosfaturamento.valorcofinsretido), 0.0)) ');
      SQL.Add('End) As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add(') as d ');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.despesasvaloriss(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('Sum(d.JAN) As sumjan, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(sum(d.emitido), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as emitidos, ');
      SQL.Add('Sum(d.FEV) As sumfev, ');
      SQL.Add('Sum(d.MAR) As summar, ');
      SQL.Add('Sum(d.ABR) As sumabr, ');
      SQL.Add('Sum(d.MAI) As summai, ');
      SQL.Add('Sum(d.JUN) As sumjun, ');
      SQL.Add('Sum(d.JUL) As sumjul, ');
      SQL.Add('Sum(d.AGO) As sumago, ');
      SQL.Add('Sum(d.`SET`) As sumset, ');
      SQL.Add('Sum(d.`OUT`) As sumout, ');
      SQL.Add('Sum(d.NOV) As sumnov, ');
      SQL.Add('Sum(d.DEZ) As sumdez ');
      SQL.Add('From ');
      SQL.Add('(Select ');
      SQL.Add('    Sum(Case ');
      SQL.Add('        When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-01'' ');
      SQL.Add('        Then (Coalesce((impostosfaturamento.valoriss + impostosfaturamento.valorissretido), 0.0)) ');
      SQL.Add('    End) As ''JAN'', ');
      SQL.Add('    0 As ''FEV'', ');
      SQL.Add('    0 As ''MAR'', ');
      SQL.Add('    0 As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('    impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-02'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valoriss + impostosfaturamento.valorissretido), 0.0)) ');
      SQL.Add('End) As ''FEV'', ');
      SQL.Add('    0 As ''MAR'', ');
      SQL.Add('    0 As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-03'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valoriss + impostosfaturamento.valorissretido), 0.0)) ');
      SQL.Add('End) As ''MAR'', ');
      SQL.Add('    0 As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-04'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valoriss + impostosfaturamento.valorissretido), 0.0)) ');
      SQL.Add('End) As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-05'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valoriss + impostosfaturamento.valorissretido), 0.0)) ');
      SQL.Add('End) As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-06'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valoriss + impostosfaturamento.valorissretido), 0.0)) ');
      SQL.Add('End) As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-06'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valoriss + impostosfaturamento.valorissretido), 0.0)) ');
      SQL.Add('End) As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-06'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valoriss + impostosfaturamento.valorissretido), 0.0)) ');
      SQL.Add('End) As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-06'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valoriss + impostosfaturamento.valorissretido), 0.0)) ');
      SQL.Add('End) As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-06'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valoriss + impostosfaturamento.valorissretido), 0.0)) ');
      SQL.Add('End) As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-06'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valoriss + impostosfaturamento.valorissretido), 0.0)) ');
      SQL.Add('End) As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-12'' ');
      SQL.Add('Then (Coalesce((impostosfaturamento.valoriss + impostosfaturamento.valorissretido), 0.0)) ');
      SQL.Add('End) As ''DEZ'', ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add(') as d ');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.despesasvalorpj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select  ');
      SQL.Add('Sum(d.JAN) as sumjan,  ');
      SQL.Add('Sum(d.FEV) As sumfev,  ');
      SQL.Add('Sum(d.MAR) As summar,  ');
      SQL.Add('Sum(d.ABR) As sumabr,  ');
      SQL.Add('Sum(d.MAI) As summai,  ');
      SQL.Add('Sum(d.JUN) As sumjun,  ');
      SQL.Add('Sum(d.JUL) As sumjul,  ');
      SQL.Add('Sum(d.AGO) As sumago,  ');
      SQL.Add('Sum(d.`SET`) As sumset,  ');
      SQL.Add('Sum(d.`OUT`) As sumout,  ');
      SQL.Add('Sum(d.NOV) As sumnov,  ');
      SQL.Add('Sum(d.DEZ) As sumdez  ');
      SQL.Add('From  ');
      SQL.Add('(Select  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-01''  ');
      SQL.Add('Then (Coalesce(obraericssonfechamento.VALORPJ*obraericssonfechamento.Quant, 0.0))  ');
      SQL.Add('End) As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',  ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado''  ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-02''  ');
      SQL.Add('Then (Coalesce(obraericssonfechamento.VALORPJ*obraericssonfechamento.Quant, 0.0))  ');
      SQL.Add('End) As ''FEV'',  ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado''   ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-03''  ');
      SQL.Add('Then (Coalesce(obraericssonfechamento.VALORPJ*obraericssonfechamento.Quant, 0.0))  ');
      SQL.Add('End) As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado''   ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',  ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-04''  ');
      SQL.Add('Then (Coalesce(obraericssonfechamento.VALORPJ*obraericssonfechamento.Quant, 0.0))  ');
      SQL.Add('End) As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado''   ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',  ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-05''  ');
      SQL.Add('Then (Coalesce(obraericssonfechamento.VALORPJ*obraericssonfechamento.Quant, 0.0))  ');
      SQL.Add('End) As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado''   ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',   ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-06''  ');
      SQL.Add('Then (Coalesce(obraericssonfechamento.VALORPJ*obraericssonfechamento.Quant, 0.0))  ');
      SQL.Add('End) As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',   ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-07''  ');
      SQL.Add('Then (Coalesce(obraericssonfechamento.VALORPJ*obraericssonfechamento.Quant, 0.0))  ');
      SQL.Add('End) As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',   ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-08''  ');
      SQL.Add('Then (Coalesce(obraericssonfechamento.VALORPJ*obraericssonfechamento.Quant, 0.0))  ');
      SQL.Add('End) As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',   ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-09''  ');
      SQL.Add('Then (Coalesce(obraericssonfechamento.VALORPJ*obraericssonfechamento.Quant, 0.0))  ');
      SQL.Add('End) As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',   ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-10''  ');
      SQL.Add('Then (Coalesce(obraericssonfechamento.VALORPJ*obraericssonfechamento.Quant, 0.0))  ');
      SQL.Add('End) As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',   ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-11''  ');
      SQL.Add('Then (Coalesce(obraericssonfechamento.VALORPJ*obraericssonfechamento.Quant, 0.0))  ');
      SQL.Add('End) As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',   ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-12''  ');
      SQL.Add('Then (Coalesce(obraericssonfechamento.VALORPJ*obraericssonfechamento.Quant, 0.0))  ');
      SQL.Add('End) As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add(' ) As d ');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.despesasdiaria(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select  ');
      SQL.Add('Sum(d.JAN) As sumjan,  ');
      SQL.Add('Sum(d.FEV) As sumfev,  ');
      SQL.Add('Sum(d.MAR) As summar,  ');
      SQL.Add('Sum(d.ABR) As sumabr,  ');
      SQL.Add('Sum(d.MAI) As summai,  ');
      SQL.Add('Sum(d.JUN) As sumjun,  ');
      SQL.Add('Sum(d.JUL) As sumjul,  ');
      SQL.Add('Sum(d.AGO) As sumago,  ');
      SQL.Add('Sum(d.`SET`) As sumset,  ');
      SQL.Add('Sum(d.`OUT`) As sumout,  ');
      SQL.Add('Sum(d.NOV) As sumnov,  ');
      SQL.Add('Sum(d.DEZ) As sumdez  ');
      SQL.Add('From  ');
      SQL.Add('(Select  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-01''  ');
      SQL.Add('Then (Coalesce(obradiaria.valortotal, 0.0))  ');
      SQL.Add('End) As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',  ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Inner Join ');
      SQL.Add('obradiaria On obradiaria.numero = obraericssonfechamento.IDSydle ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado''  ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-02''  ');
      SQL.Add('Then (Coalesce(obradiaria.valortotal, 0.0))  ');
      SQL.Add('End) As ''FEV'',  ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Inner Join ');
      SQL.Add('obradiaria On obradiaria.numero = obraericssonfechamento.IDSydle ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado''   ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-03''  ');
      SQL.Add('Then (Coalesce(obradiaria.valortotal, 0.0))  ');
      SQL.Add('End) As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Inner Join ');
      SQL.Add('obradiaria On obradiaria.numero = obraericssonfechamento.IDSydle ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado''   ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',  ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-04''  ');
      SQL.Add('Then (Coalesce(obradiaria.valortotal, 0.0))  ');
      SQL.Add('End) As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Inner Join ');
      SQL.Add('obradiaria On obradiaria.numero = obraericssonfechamento.IDSydle ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado''   ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',  ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-05''  ');
      SQL.Add('Then (Coalesce(obradiaria.valortotal, 0.0))  ');
      SQL.Add('End) As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Inner Join ');
      SQL.Add('obradiaria On obradiaria.numero = obraericssonfechamento.IDSydle ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado''   ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',   ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-06''  ');
      SQL.Add('Then (Coalesce(obradiaria.valortotal, 0.0))  ');
      SQL.Add('End) As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Inner Join ');
      SQL.Add('obradiaria On obradiaria.numero = obraericssonfechamento.IDSydle ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',   ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-07''  ');
      SQL.Add('Then (Coalesce(obradiaria.valortotal, 0.0))  ');
      SQL.Add('End) As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Inner Join ');
      SQL.Add('obradiaria On obradiaria.numero = obraericssonfechamento.IDSydle ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',   ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-08''  ');
      SQL.Add('Then (Coalesce(obradiaria.valortotal, 0.0))  ');
      SQL.Add('End) As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Inner Join ');
      SQL.Add('obradiaria On obradiaria.numero = obraericssonfechamento.IDSydle ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',   ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-09''  ');
      SQL.Add('Then (Coalesce(obradiaria.valortotal, 0.0))  ');
      SQL.Add('End) As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Inner Join ');
      SQL.Add('obradiaria On obradiaria.numero = obraericssonfechamento.IDSydle ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',   ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-10''  ');
      SQL.Add('Then (Coalesce(obradiaria.valortotal, 0.0))  ');
      SQL.Add('End) As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Inner Join ');
      SQL.Add('obradiaria On obradiaria.numero = obraericssonfechamento.IDSydle ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',   ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-11''  ');
      SQL.Add('Then (Coalesce(obradiaria.valortotal, 0.0))  ');
      SQL.Add('End) As ''NOV'',  ');
      SQL.Add('0 As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Inner Join ');
      SQL.Add('obradiaria On obradiaria.numero = obraericssonfechamento.IDSydle ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add('UNION All  ');
      SQL.Add('Select  ');
      SQL.Add('0 As ''JAN'',  ');
      SQL.Add('0 As ''FEV'',   ');
      SQL.Add('0 As ''MAR'',  ');
      SQL.Add('0 As ''ABR'',  ');
      SQL.Add('0 As ''MAI'',  ');
      SQL.Add('0 As ''JUN'',  ');
      SQL.Add('0 As ''JUL'',  ');
      SQL.Add('0 As ''AGO'',  ');
      SQL.Add('0 As ''SET'',  ');
      SQL.Add('0 As ''OUT'',  ');
      SQL.Add('0 As ''NOV'',  ');
      SQL.Add('sum(Case  ');
      SQL.Add('When Date_Format(obraericsson.dataconclusaoreportadodia, ''%Y-%m'') = ''2024-12''  ');
      SQL.Add('Then (Coalesce(obradiaria.valortotal, 0.0))  ');
      SQL.Add('End) As ''DEZ''  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Inner Join ');
      SQL.Add('obradiaria On obradiaria.numero = obraericssonfechamento.IDSydle ');
      SQL.Add('Where  ');
      SQL.Add('obraericsson.situacaoimplantacao <> ''Cancelado'' ');
      SQL.Add(' ) As d ');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.despesasinss(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('Sum(d.JAN) As sumjan, ');
      SQL.Add('Sum(d.FEV) As sumfev, ');
      SQL.Add('Sum(d.MAR) As summar, ');
      SQL.Add('Sum(d.ABR) As sumabr, ');
      SQL.Add('Sum(d.MAI) As summai, ');
      SQL.Add('Sum(d.JUN) As sumjun, ');
      SQL.Add('Sum(d.JUL) As sumjul, ');
      SQL.Add('Sum(d.AGO) As sumago, ');
      SQL.Add('Sum(d.`SET`) As sumset, ');
      SQL.Add('Sum(d.`OUT`) As sumout, ');
      SQL.Add('Sum(d.NOV) As sumnov, ');
      SQL.Add('Sum(d.DEZ) As sumdez ');
      SQL.Add('From ');
      SQL.Add('(Select ');
      SQL.Add('    Sum(Case ');
      SQL.Add('        When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-01'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorinssretido, 0.0)) ');
      SQL.Add('    End) As ''JAN'', ');
      SQL.Add('    0 As ''FEV'', ');
      SQL.Add('    0 As ''MAR'', ');
      SQL.Add('    0 As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('    impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-02'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorinssretido, 0.0)) ');
      SQL.Add('End) As ''FEV'', ');
      SQL.Add('    0 As ''MAR'', ');
      SQL.Add('    0 As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-03'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorinssretido, 0.0)) ');
      SQL.Add('End) As ''MAR'', ');
      SQL.Add('    0 As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-04'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorinssretido, 0.0)) ');
      SQL.Add('End) As ''ABR'', ');
      SQL.Add('    0 As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-05'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorinssretido, 0.0)) ');
      SQL.Add('End) As ''MAI'', ');
      SQL.Add('    0 As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add('Union all ');
      SQL.Add('Select ');
      SQL.Add('0 As ''JAN'', ');
      SQL.Add('0 As ''FEV'', ');
      SQL.Add('0 As ''MAR'', ');
      SQL.Add('0 As ''ABR'', ');
      SQL.Add('0 As ''MAI'', ');
      SQL.Add('sum(Case ');
      SQL.Add('When Date_Format(impostosfaturamento.emissao, ''%Y-%m'') = ''2024-06'' ');
      SQL.Add('        Then (Coalesce(impostosfaturamento.valorinssretido, 0.0)) ');
      SQL.Add('End) As ''JUN'', ');
      SQL.Add('    0 As ''JUL'', ');
      SQL.Add('    0 As ''AGO'', ');
      SQL.Add('    0 As ''SET'', ');
      SQL.Add('    0 As ''OUT'', ');
      SQL.Add('    0 As ''NOV'', ');
      SQL.Add('    0 As ''DEZ'' ');
      SQL.Add('From ');
      SQL.Add('impostosfaturamento ');
      SQL.Add(') as d ');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.demonstra(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select  ');
      SQL.Add('d.cliente,  ');
      SQL.Add('d.rfp,  ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(sum(d.emitido), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as emitidos, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(sum(d.semmigo), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as semmigo, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(sum(d.commigo), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as commigo, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(sum(d.faturar), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as faturar, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(sum(d.migo), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as migo,  ');
      SQL.Add('coalesce(sum(d.faturar),0) as faturarn ');
      SQL.Add('From  ');
      SQL.Add(' (Select  ');
      SQL.Add(' obraericsson.cliente,  ');
      SQL.Add(' obraericsson.rfp,  ');
      SQL.Add(' Sum(0) As emitido,  ');
      SQL.Add(' Sum(0) As semmigo,  ');
      SQL.Add(' Sum(obraericssonmigo.medidafiltro) As commigo,  ');
      SQL.Add(' Sum(0) As faturar,  ');
      SQL.Add('  Sum(0) As migo  ');
      SQL.Add(' From  ');
      SQL.Add(' obraericssonmigo left Join  ');
      SQL.Add(' obraericsson On obraericsson.numeroint = obraericssonmigo.id  ');
      SQL.Add(' Where  ');
      SQL.Add(' obraericssonmigo.statuspo = ''Com MIGO'' and obraericsson.rfp <> 0   ');
      if AQuery.ContainsKey('regiona') then
      begin
        if Length(AQuery.Items['regiona']) > 0 then
        begin
          SQL.Add('AND (obraericsson.regiona like ''%' + AQuery.Items['regiona'] + '%'') ');
        end;
      end;
      if AQuery.ContainsKey('site') then
      begin
        if Length(AQuery.Items['site']) > 0 then
        begin
          SQL.Add('AND (obraericsson.site like ''%' + AQuery.Items['site'] + '%'') ');
        end;
      end;
      SQL.Add(' Group By  ');
      SQL.Add(' obraericsson.cliente,  ');
      SQL.Add('  obraericsson.rfp  ');
      SQL.Add(' Union All  ');
      SQL.Add(' Select  ');
      SQL.Add(' obraericsson.cliente,  ');
      SQL.Add('obraericsson.rfp,  ');
      SQL.Add(' Sum(obraericssonmigo.medidafiltro) As emitido,  ');
      SQL.Add(' Sum(0) As semmigo,  ');
      SQL.Add(' Sum(0) As commigo,  ');
      SQL.Add(' Sum(0) As faturar,  ');
      SQL.Add(' Sum(0) As migo  ');
      SQL.Add(' From  ');
      SQL.Add(' obraericssonmigo left Join  ');
      SQL.Add(' obraericsson On obraericsson.numeroint = obraericssonmigo.id where 1=1 and obraericsson.rfp <> 0    ');
      if AQuery.ContainsKey('regiona') then
      begin
        if Length(AQuery.Items['regiona']) > 0 then
        begin
          SQL.Add('AND (obraericsson.regiona like ''%' + AQuery.Items['regiona'] + '%'') ');
        end;
      end;
      if AQuery.ContainsKey('site') then
      begin
        if Length(AQuery.Items['site']) > 0 then
        begin
          SQL.Add('AND (obraericsson.site like ''%' + AQuery.Items['site'] + '%'') ');
        end;
      end;
      SQL.Add('Group By  ');
      SQL.Add(' obraericsson.cliente,  ');
      SQL.Add(' obraericsson.rfp  ');
      SQL.Add(' Union All  ');
      SQL.Add('  Select  ');
      SQL.Add(' obraericsson.cliente,  ');
      SQL.Add('  obraericsson.rfp,  ');
      SQL.Add('  Sum(0) As emitido,  ');
      SQL.Add(' Sum(obraericssonmigo.medidafiltro) As semmigo,  ');
      SQL.Add(' Sum(0) As commigo,  ');
      SQL.Add(' Sum(0) As faturar,  ');
      SQL.Add(' Sum(0) As migo  ');
      SQL.Add(' From  ');
      SQL.Add('obraericssonmigo left Join  ');
      SQL.Add(' obraericsson On obraericsson.numeroint = obraericssonmigo.id  ');
      SQL.Add(' Where  ');
      SQL.Add(' obraericssonmigo.statuspo <> ''Com MIGO'' and obraericsson.rfp <> 0  ');
      if AQuery.ContainsKey('regiona') then
      begin
        if Length(AQuery.Items['regiona']) > 0 then
        begin
          SQL.Add('AND (obraericsson.regiona like ''%' + AQuery.Items['regiona'] + '%'') ');
        end;
      end;
      if AQuery.ContainsKey('site') then
      begin
        if Length(AQuery.Items['site']) > 0 then
        begin
          SQL.Add('AND (obraericsson.site like ''%' + AQuery.Items['site'] + '%'') ');
        end;
      end;
      SQL.Add(' Group By  ');
      SQL.Add(' obraericsson.cliente,  ');
      SQL.Add(' obraericsson.rfp  ');
      SQL.Add(' Union All  ');
      SQL.Add(' Select  ');
      SQL.Add(' obraericsson.cliente,  ');
      SQL.Add(' obraericsson.rfp,  ');
      SQL.Add(' Sum(0) As emitido,  ');
      SQL.Add(' Sum(0) As semmigo,  ');
      SQL.Add(' Sum(0) As commigo,  ');
      SQL.Add(' Sum(obraericssonmigo.medidafiltro) As faturar,  ');
      SQL.Add(' Sum(0) As migo  ');
      SQL.Add(' From  ');
      SQL.Add(' obraericssonmigo left Join  ');
      SQL.Add(' obraericsson On obraericsson.numeroint = obraericssonmigo.id  ');
      SQL.Add(' where statuspo <> ''Com MIGO'' and sigla=''N'' and datavalidacaoinstalacaodia is not null and obraericsson.rfp <> 0  ');
      if AQuery.ContainsKey('regiona') then
      begin
        if Length(AQuery.Items['regiona']) > 0 then
        begin
          SQL.Add('AND (obraericsson.regiona like ''%' + AQuery.Items['regiona'] + '%'') ');
        end;
      end;
      if AQuery.ContainsKey('site') then
      begin
        if Length(AQuery.Items['site']) > 0 then
        begin
          SQL.Add('AND (obraericsson.site like ''%' + AQuery.Items['site'] + '%'') ');
        end;
      end;
      SQL.Add(' Group By  ');
      SQL.Add(' obraericsson.cliente,  ');
      SQL.Add(' obraericsson.rfp ) As d where 1=1 ');
      if AQuery.ContainsKey('cliente') then
      begin
        if Length(AQuery.Items['cliente']) > 0 then
        begin
          SQL.Add('AND (d.cliente like ''%' + AQuery.Items['cliente'] + '%'') ');
        end;
      end;
      if AQuery.ContainsKey('rfp') then
      begin
        if Length(AQuery.Items['rfp']) > 0 then
        begin
          if AQuery.Items['rfp'] <> 'todos' then
            SQL.Add('AND (d.rfp like ''%' + AQuery.Items['rfp'] + '%'') ');
          a := AQuery.Items['rfp'];
        end;
      end;

      SQL.Add('Group By  ');
      SQL.Add(' d.cliente,  ');
      SQL.Add(' d.rfp     ');
      open;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TDemonstrativo.despesascltacionados(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('SELECT  ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.datafin, ''%m'') = ''01'' THEN o.datafin END) AS JAN, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.datafin, ''%m'') = ''02'' THEN o.datafin END) AS FEV, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.datafin, ''%m'') = ''03'' THEN o.datafin END) AS MAR, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.datafin, ''%m'') = ''04'' THEN o.datafin END) AS ABR, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.datafin, ''%m'') = ''05'' THEN o.datafin END) AS MAI, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.datafin, ''%m'') = ''06'' THEN o.datafin END) AS JUN, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.datafin, ''%m'') = ''07'' THEN o.datafin END) AS JUL, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.datafin, ''%m'') = ''08'' THEN o.datafin END) AS AGO, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.datafin, ''%m'') = ''09'' THEN o.datafin END) AS `SET`, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.datafin, ''%m'') = ''10'' THEN o.datafin END) AS `OUT`, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.datafin, ''%m'') = ''11'' THEN o.datafin END) AS NOV, ');
      SQL.Add('COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.datafin, ''%m'') = ''12'' THEN o.datafin END) AS DEZ ');
      SQL.Add('FROM ');
      SQL.Add('obraericssonatividadeclt o ');
      SQL.Add('WHERE ');
      SQL.Add('o.deletado = 0 ');
      SQL.Add('AND YEAR(o.datafin) = YEAR(CURDATE())');
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

end.


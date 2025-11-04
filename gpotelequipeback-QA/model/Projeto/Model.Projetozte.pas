unit Model.Projetozte;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection, ComObj,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections, UtFuncao;

type
  TProjetozte = class
  private
    FConn: TFDConnection;
    Fos: string;
    Fid: string;
    Fidgeral: Integer;
    Fobservacaopj: string;
    Fregiao: string;
    Fzona: string;
    Fregion: string;
    Fztecode: string;
    Fqtd: Double;
    Fnumero: string;
    Fidcolaboradorpj: Integer;
    Fpo: string;
    Flpuhistorico: string;
    fvalornegociado: Double;
    Fdescricaoservico: string;
    Fsitename: string;
    Fsitenamefrom: string;
    Festado: string;
    Fsiteid: string;
    Farea: string;

    Fprojeto: string;
    Fsupervisor: string;
    Fconcentrador: string;
    Ftiposite: string;
    Finstallplan: TDateTime;
    Finstallreal: TDateTime;
    Fstatusprojeto: string;
    Fgerenciaplan: TDateTime;
    Fgerenciareal: TDateTime;
    Fmos: string;
    Fmosresp: string;
    Fcompliance: string;
    Fcomplianceresp: string;
    Fehs: string;
    Fehsresp: string;
    Fqualidade: string;
    Fqualidaderesp: string;
    Fpdi: string;
    Fpdiresp: string;
    Fdocresp: string;
    Fstatusdoc: string;
    Fobservacaodoc: string;
    Fobservacao: string;
    Fmesfechamento: string;
    Fdataenviofechamento: string;
    Fidgeralfechamento: Integer;
    Fporcentagem: Integer;
    Fvalor: Double;
    Frepostaalteracao: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    property os: string read Fos write Fos;
    property id: string read Fid write Fid;
    property idgeral: Integer read Fidgeral write Fidgeral;
    property numero: string read Fnumero write Fnumero;
    property idcolaboradorpj: Integer read Fidcolaboradorpj write Fidcolaboradorpj;
    property po: string read Fpo write Fpo;
    property observacaopj: string read Fobservacaopj write Fobservacaopj;
    property regiao: string read Fregiao write Fregiao;
    property zona: string read Fzona write Fzona;
    property region: string read Fregion write Fregion;
    property ztecode: string read Fztecode write Fztecode;
    property qtd: Double read Fqtd write Fqtd;
    property lpuhistorico: string read Flpuhistorico write Flpuhistorico;
    property valornegociado: Double read Fvalornegociado write Fvalornegociado;
    property descricaoservico: string read Fdescricaoservico write Fdescricaoservico;
    property sitename: string read Fsitename write Fsitename;
    property sitenamefrom: string read Fsitenamefrom write Fsitenamefrom;
    property estado: string read Festado write Festado;
    property siteid: string read Fsiteid write Fsiteid;
    property area: string read Farea write Farea;

    property projeto: string read Fprojeto write Fprojeto;
    property supervisor: string read Fsupervisor write Fsupervisor;
    property concentrador: string read Fconcentrador write Fconcentrador;
    property tiposite: string read Ftiposite write Ftiposite;
    property installplan: tdatetime read Finstallplan write Finstallplan;
    property installreal: tdatetime read Finstallreal write Finstallreal;
    property statusprojeto: string read Fstatusprojeto write Fstatusprojeto;
    property gerenciaplan: tdatetime read Fgerenciaplan write Fgerenciaplan;
    property gerenciareal: tdatetime read Fgerenciareal write Fgerenciareal;
    property mos: string read Fmos write Fmos;
    property mosresp: string read Fmosresp write Fmosresp;
    property compliance: string read Fcompliance write Fcompliance;
    property complianceresp: string read Fcomplianceresp write Fcomplianceresp;
    property ehs: string read Fehs write Fehs;
    property ehsresp: string read Fehsresp write Fehsresp;
    property qualidade: string read Fqualidade write Fqualidade;
    property qualidaderesp: string read Fqualidaderesp write Fqualidaderesp;
    property pdi: string read Fpdi write Fpdi;
    property pdiresp: string read Fpdiresp write Fpdiresp;
    property docresp: string read Fdocresp write Fdocresp;
    property statusdoc: string read Fstatusdoc write Fstatusdoc;
    property observacaodoc: string read Fobservacaodoc write Fobservacaodoc;
    property observacao: string read Fobservacao write Fobservacao;
    property mesfechamento: string read Fmesfechamento write Fmesfechamento;
    property dataenviofechamento: string read Fdataenviofechamento write Fdataenviofechamento;
    property idgeralfechamento: Integer read Fidgeralfechamento write Fidgeralfechamento;
    property porcentagem: Integer read Fporcentagem write Fporcentagem;
    property valor: double read Fvalor write Fvalor;
    property repostaalteracao: Integer read Frepostaalteracao write Frepostaalteracao;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listapo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listatarefas(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editaros(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): string;
    function Listaatividadepj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listalpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editaratividadepj(out erro: string): Boolean;
    function salvartarefa(out erro: string): Boolean;
    function ListaFechamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaFechamentoporempresa(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function consultapagamento: Boolean;
    function Editarpagamento(out erro: string): Boolean;
    function Listaparadocumentacao(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaiddocumentacao(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function historicopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function extratopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function extratopagamentototal(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function rolloutzte(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function totalacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function listagemgrupolpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListalpuGeral(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
  end;

implementation

{ TProjetoericsson }

constructor TProjetozte.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TProjetozte.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TProjetozte.Editarpagamento(out erro: string): Boolean;
var
  qry: TFDQuery;
  id: Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      FConn.StartTransaction;

      with qry do
      begin
        Active := false;
        sql.Clear;
        sql.Add('update obrazte set fechamento=:fechamento, porcentagem =:porcentagem, dataenviofechamento=:dataenviofechamento, valor=:valor where id=:idfechamento');
        parambyname('fechamento').asstring := mesfechamento;
        parambyname('porcentagem').AsInteger := porcentagem;
        ParamByName('dataenviofechamento').asdate := date;
        ParamByName('idfechamento').asinteger := idgeralfechamento;
        parambyname('valor').Asfloat := valor;
        ExecSQL;
      end;

      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao efetuar pagamento: ' + ex.Message;
        Result := false;
      end;
    end;

  finally
    qry.Free;

  end;
end;

function TProjetozte.Listaparadocumentacao(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obrazte.id, ');
      SQL.Add('obrazte.State, ');
      SQL.Add('obrazte.PO, ');
      SQL.Add('obrazte.SiteID, ');
      SQL.Add('obrazte.SiteName, ');
      SQL.Add('obrazte.sitenamefrom, ');
      SQL.Add('obrazte.ZTECode, ');
      SQL.Add('obrazte.ServiceDescription, ');
      SQL.Add('gesempresas.nome, ');
      SQL.Add('gesempresas.idempresa, ');
      SQL.Add('obrazte.os, ');
      SQL.Add('obrazte.mos, ');
      SQL.Add('obrazte.compliance, ');
      SQL.Add('obrazte.ehs, ');
      SQL.Add('obrazte.qualidade, ');
      SQL.Add('obrazte.pdi, ');
      SQL.Add('obrazte.statusdoc, ');
      SQL.Add('obrazte.docresp ');
      SQL.Add('From ');
      SQL.Add('obrazte left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obrazte.idcolaborador where obrazte.id is not null and gesempresas.statusTelequipe = ''ATIVO'' and obrazte.statusprojeto = ''INSTALLED - FINISHED'' and valorlpu > 0 ');
      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND(gesempresas.nome like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obrazte.PO like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obrazte.siteid like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obrazte.sitename like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obrazte.sitenamefrom like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obrazte.state like ''%' + AQuery.Items['busca'] + '%'' )');
        end;
      end;
      SQL.Add('order by obrazte.sitename limit 500');
      Open();
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

function TProjetozte.ListaFechamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obrazte.id, ');
      SQL.Add('obrazte.State, ');
      SQL.Add('obrazte.PO, ');
      SQL.Add('obrazte.SiteID, ');
      SQL.Add('obrazte.SiteName, ');
      SQL.Add('obrazte.sitenamefrom, ');
      SQL.Add('obrazte.ZTECode, ');
      SQL.Add('obrazte.ServiceDescription, ');
      SQL.Add('gesempresas.nome, ');
      SQL.Add('gesempresas.idempresa, ');
      SQL.Add('obrazte.os ');
      SQL.Add('From ');
      SQL.Add('obrazte left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obrazte.idcolaborador ');
      SQL.Add('where obrazte.id is not null and gesempresas.statusTelequipe = ''ATIVO'' and obrazte.valorlpu > 0 and obrazte.porcentagem < 100 and   ');
      SQL.Add('obrazte.statusprojeto = ''INSTALLED - FINISHED'' and ((obrazte.statusdoc = ''OK'') or ((obrazte.statusdoc = ''AGUARDANDO'') and (obrazte.docresp = ''TELEQUIPE'')))  ');
      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND(gesempresas.nome like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obrazte.PO like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obrazte.siteid like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obrazte.sitename like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obrazte.sitenamefrom like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obrazte.state like ''%' + AQuery.Items['busca'] + '%'' )');
        end;
      end;
      SQL.Add('order by obrazte.sitename limit 500');
      Open();
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

function TProjetozte.historicopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obrazte.id, ');
      SQL.Add('obrazte.State, ');
      SQL.Add('obrazte.PO, ');
      SQL.Add('obrazte.SiteID, ');
      SQL.Add('obrazte.SiteName, ');
      SQL.Add('obrazte.sitenamefrom, ');
      SQL.Add('obrazte.ZTECode, ');
      SQL.Add('obrazte.ServiceDescription, ');
      SQL.Add('gesempresas.nome, ');
      SQL.Add('obrazte.os, ');
      SQL.Add('gesempresas.idempresa, ');
      SQL.Add('Concat(''R$'', Replace(Replace(Replace(Format(obrazte.valorlpu, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As valorlpu, ');
      SQL.Add('obrazte.Qty, ');
      SQL.Add('obrazte.mos, ');
      SQL.Add('obrazte.compliance, ');
      SQL.Add('obrazte.ehs, ');
      SQL.Add('obrazte.qualidade, ');
      SQL.Add('Concat(''R$'', Replace(Replace(Replace(Format(obrazte.Qty * obrazte.valor, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As valorpago, ');
      SQL.Add('obrazte.valor As valorpagosimples, ');
      SQL.Add('obrazte.pdi, ');
      SQL.Add('obrazte.statusdoc, ');
      SQL.Add('obrazte.porcentagem, ');
      SQL.Add('obrazte.fechamento, ');
      SQL.Add('obrazte.docresp ');
      SQL.Add('From ');
      SQL.Add('obrazte Left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obrazte.idcolaborador where obrazte.idcolaborador=:idcolaborador and obrazte.valorlpu > 0 and obrazte.porcentagem > 0 and ');
      SQL.Add('obrazte.statusprojeto = ''INSTALLED - FINISHED'' and ((obrazte.statusdoc = ''OK'') or ((obrazte.statusdoc = ''AGUARDANDO'') and (obrazte.docresp = ''TELEQUIPE'')))  ');
      ParamByName('idcolaborador').asinteger := AQuery.Items['idempresalocal'].ToInteger;
      Open();
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

function TProjetozte.extratopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select ');
      SQL.Add('obrazte.id, ');
      SQL.Add('obrazte.State, ');
      SQL.Add('obrazte.PO, ');
      SQL.Add('obrazte.SiteID, ');
      SQL.Add('obrazte.SiteName, ');
      SQL.Add('obrazte.sitenamefrom, ');
      SQL.Add('obrazte.ZTECode, ');
      SQL.Add('obrazte.ServiceDescription, ');
      SQL.Add('gesempresas.nome, ');
      SQL.Add('obrazte.os, ');
      SQL.Add('gesempresas.idempresa, ');
      SQL.Add('Concat(''R$'', Replace(Replace(Replace(Format(obrazte.valorlpu, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As valorlpu, ');
      SQL.Add('obrazte.Qty, ');
      SQL.Add('obrazte.mos, ');
      SQL.Add('obrazte.compliance, ');
      SQL.Add('obrazte.ehs, ');
      SQL.Add('obrazte.qualidade, ');
      SQL.Add('Concat(''R$'', Replace(Replace(Replace(Format(obrazte.Qty * obrazte.valor, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As valorpago, ');
      SQL.Add('obrazte.valor As valorpagosimples, ');
      SQL.Add('obrazte.pdi, ');
      SQL.Add('obrazte.statusdoc, ');
      SQL.Add('obrazte.porcentagem, ');
      SQL.Add('obrazte.fechamento, ');
      SQL.Add('obrazte.docresp ');
      SQL.Add('From ');
      SQL.Add('obrazte Left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obrazte.idcolaborador where obrazte.idcolaborador=:idcolaborador and obrazte.valorlpu > 0 and obrazte.porcentagem > 0 and ');
      SQL.Add('obrazte.statusprojeto = ''INSTALLED - FINISHED'' and ((obrazte.statusdoc = ''OK'') or ((obrazte.statusdoc = ''AGUARDANDO'') and (obrazte.docresp = ''TELEQUIPE'')))  ');
      ParamByName('idcolaborador').asinteger := AQuery.Items['idempresa'].ToInteger;
      a := AQuery.Items['mespagamento'];
      if AQuery.ContainsKey('mespagamento') then
      begin
        if Length(AQuery.Items['mespagamento']) > 0 then
        begin
          SQL.Add('AND obrazte.fechamento =:fechamento ');
          parambyname('fechamento').asstring := AQuery.Items['mespagamento'];
        end;
      end;
      SQL.Add('order by obrazte.SiteName asc, obrazte.sitenamefrom asc   ');
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

function TProjetozte.extratopagamentototal(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select ');
      SQL.Add(' sum(obrazte.valor) as total ');
      SQL.Add('From ');
      SQL.Add('obrazte Left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obrazte.idcolaborador where obrazte.idcolaborador=:idcolaborador and obrazte.valorlpu > 0 and obrazte.porcentagem > 0 and ');
      SQL.Add('obrazte.statusprojeto = ''INSTALLED - FINISHED'' and ((obrazte.statusdoc = ''OK'') or ((obrazte.statusdoc = ''AGUARDANDO'') and (obrazte.docresp = ''TELEQUIPE'')))  ');
      ParamByName('idcolaborador').asinteger := AQuery.Items['idempresa'].ToInteger;
      a := AQuery.Items['idempresa'];
      a := AQuery.Items['mespagamento'];
      if AQuery.ContainsKey('mespagamento') then
      begin
        if Length(AQuery.Items['mespagamento']) > 0 then
        begin
          SQL.Add('AND obrazte.fechamento =:fechamento ');
          parambyname('fechamento').asstring := AQuery.Items['mespagamento'];
        end;
      end;
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

function TProjetozte.consultapagamento: Boolean;
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
      sql.add('Select * From obrazte where fechamento=:fechamento and id=:idgeralfechamento ');
      ParamByName('fechamento').asstring := mesfechamento;
      ParamByName('idgeralfechamento').AsInteger := idgeralfechamento;
      Open();
      if RecordCount = 0 then
        result := true
      else
        result := False;
    end;

  finally
    qry.Free;
  end;

end;

function TProjetozte.ListaFechamentoporempresa(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select ');
      SQL.Add('obrazte.id, ');
      SQL.Add('obrazte.State, ');
      SQL.Add('obrazte.PO, ');
      SQL.Add('obrazte.SiteID, ');
      SQL.Add('obrazte.SiteName, ');
      SQL.Add('obrazte.sitenamefrom, ');
      SQL.Add('obrazte.ZTECode, ');
      SQL.Add('obrazte.ServiceDescription, ');
      SQL.Add('gesempresas.nome, ');
      SQL.Add('obrazte.os, ');
      SQL.Add('gesempresas.idempresa, ');
      SQL.Add('Concat(''R$'', Replace(Replace(Replace(Format(obrazte.valorlpu, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As valorlpu, ');
      SQL.Add('obrazte.Qty, ');
      SQL.Add('obrazte.mos, ');
      SQL.Add('obrazte.compliance, ');
      SQL.Add('obrazte.ehs, ');
      SQL.Add('obrazte.qualidade, ');
      SQL.Add('Concat(''R$'', Replace(Replace(Replace(Format(obrazte.Qty * obrazte.valorlpu, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As valorpj, ');
      SQL.Add('obrazte.Qty * obrazte.valorlpu As valorpjsimples, ');
      SQL.Add('obrazte.pdi, ');
      SQL.Add('obrazte.statusdoc, ');
      SQL.Add('obrazte.docresp ');
      SQL.Add('From ');
      SQL.Add('obrazte Left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obrazte.idcolaborador where obrazte.idcolaborador=:idcolaborador and obrazte.valorlpu > 0 and obrazte.porcentagem < 100 and ');
      SQL.Add('obrazte.statusprojeto = ''INSTALLED - FINISHED'' and ((obrazte.statusdoc = ''OK'') or ((obrazte.statusdoc = ''AGUARDANDO'') and (obrazte.docresp = ''TELEQUIPE'')))  ');
      ParamByName('idcolaborador').asinteger := AQuery.Items['idempresalocal'].ToInteger;
      a := AQuery.Items['idempresalocal'];
      Open();
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

function TProjetozte.Listalpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obraztelpu.geral as value, ');
      SQL.Add('obraztelpu.historico as label ');
      SQL.Add('From ');
      SQL.Add('obraztelpu ');
      SQL.Add('where obraztelpu.idcolaborador =:idcolaborador ');
      if (idcolaboradorpj = 164) then
        ParamByName('idcolaborador').AsInteger := idcolaboradorpj
      else
        ParamByName('idcolaborador').AsInteger := 0;
      SQL.Add('Group By ');
      SQL.Add('obraztelpu.historico');
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


function TProjetozte.ListalpuGeral(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  busca, descricao: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    // Usa TryGetValue para evitar access violation
    if not AQuery.TryGetValue('busca', busca) then
      busca := '';

    if not AQuery.TryGetValue('lpudescricao', descricao) then
      descricao := '';

    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('SELECT geral AS id, PROJETO, DESCRICAOATIVIDADE, CODIGO, ESTADO, NOMEESTADO, REGIAO, LOCALIDADE, AREA, VALOR, historico, idcolaborador, deletado, datadeletado');
      SQL.Add('FROM obraztelpu WHERE 1 = 1');


      // Filtro por busca geral em múltiplos campos
      if Trim(busca) <> '' then
      begin
        SQL.Add('AND (');
        SQL.Add('  PROJETO LIKE :busca OR');
        SQL.Add('  DESCRICAOATIVIDADE LIKE :busca OR');
        SQL.Add('  CODIGO LIKE :busca OR');
        SQL.Add('  ESTADO LIKE :busca OR');
        SQL.Add('  NOMEESTADO LIKE :busca OR');
        SQL.Add('  REGIAO LIKE :busca OR');
        SQL.Add('  LOCALIDADE LIKE :busca OR');
        SQL.Add('  AREA LIKE :busca OR');
        SQL.Add('  historico LIKE :busca');
        SQL.Add(')');
        ParamByName('busca').AsString := '%' + busca + '%';
      end;

      // Filtro por lpudescricao (campo historico)
      if Trim(descricao) <> '' then
      begin
        SQL.Add('AND historico LIKE :descricao');
        ParamByName('descricao').AsString := '%' + descricao + '%';
      end;

      Active := True;
    end;

    erro := '';
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar: ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TProjetozte.Listaatividadepj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      close;
      sql.Clear;
      SQL.Add('Select ');
      SQL.Add('obraericssonatividadepj.idgeral As id, ');
      SQL.Add('gesempresas.nome As fantasia, ');
      SQL.Add('obraericssonatividadepj.po, ');
      SQL.Add('obraericssonatividadepj.poitem, ');
      SQL.Add('obraericssonatividadepj.escopo, ');
      SQL.Add('obraericssonatividadepj.descricaoservico, ');
      SQL.Add('obraericssonatividadepj.codigoservico, ');
      SQL.Add('Date_Format(obraericssonatividadepj.dataacionamento, "%d/%m/%Y") As dataacionamento, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(obraericssonatividadepj.valorservico, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valorservico, ');
      SQL.Add('Sum(obraericssonpagamento.porcentagem) As porcentagem ');
      SQL.Add('From ');
      SQL.Add('obraericssonatividadepj Left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obraericssonatividadepj.idcolaboradorpj left Join ');
      SQL.Add('obraericssonfechamento On obraericssonfechamento.idcolaboradorpj = obraericssonatividadepj.idcolaboradorpj ');
      SQL.Add('and obraericssonfechamento.PO = obraericssonatividadepj.po ');
      SQL.Add('and obraericssonfechamento.POITEM = obraericssonatividadepj.poitem ');
      SQL.Add('and obraericssonfechamento.IDSydle = obraericssonatividadepj.numero ');
      SQL.Add('and obraericssonfechamento.Descricao = obraericssonatividadepj.descricaoservico left Join ');
      SQL.Add('obraericssonpagamento On obraericssonpagamento.idgeralfechamento = obraericssonfechamento.geral ');
      SQL.Add('where ');
      SQL.Add('obraericssonatividadepj.idgeral Is Not Null And ');
      SQL.Add('obraericssonatividadepj.deletado = 0 And ');
      SQL.Add('obraericssonatividadepj.numero = :numero ');
      SQL.Add('group By ');
      SQL.Add('obraericssonatividadepj.idgeral order by obraericssonatividadepj.poitem ');
      parambyname('numero').asstring := AQuery.Items['idlocal'];
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

function TProjetozte.salvartarefa(out erro: string): Boolean;
var
  qry: TFDQuery;
  id: Integer;
begin
 { try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      FConn.StartTransaction;
      with qry do
      begin
        Active := false;
        sql.Clear;
        SQL.Add('INSERT INTO gesempresas(idempresa,cnpj,nome,fantasia,porte,cnaep,cnaes,');
        SQL.Add('codigodescricaonatureza,logradouro,outros,outrosdata,outros2,outros2data,');
        SQL.Add('cidade,numero,complemento,cep,bairro,uf,situacaocadastral,tipopj,statusTelequipe,');
        SQL.Add('pgr,pcmso,contratos,nomeresponsavel,telefone,email,');
        SQL.Add('DELETADO,cnae1,cnae2,cnae3,cnae4,cnaedescricao1,cnaedescricao2,cnaedescricao3,cnaedescricao4)');
        SQL.Add('               VALUES(:idempresa,:cnpj,:nome,:fantasia,:porte,:cnaep,:cnaes,');
        SQL.Add(':codigodescricaonatureza,:logradouro,:outros,:outrosdata,:outros2,:outros2data,');
        SQL.Add(':cidade,:numero,:complemento,:cep,:bairro,:uf,:situacaocadastral,:tipopj,:statusTelequipe,');
        SQL.Add(':pgr,:pcmso,:contratos,:nomeresponsavel,:telefone,:email,');
        SQL.Add(':DELETADO,:cnae1,:cnae2,:cnae3,:cnae4,:cnaedescricao1,:cnaedescricao2,:cnaedescricao3,:cnaedescricao4)');

        ParamByName('idempresa').AsInteger := idempresa;
        ParamByName('cnpj').Value := cnpj;
        ParamByName('nome').Value := nome;

        if Length(fantasia) = 0 then
          ParamByName('fantasia').Value := nome
        else
          ParamByName('fantasia').Value := fantasia;

        ParamByName('porte').Value := porte;
        ParamByName('tipopj').Value := tipopj;
        ParamByName('statusTelequipe').Value := statusTelequipe;
        ParamByName('cnaep').Value := cnaep;
        ParamByName('cnaes').Value := cnaes;
        ParamByName('codigodescricaonatureza').Value := codigodescricaonatureza;
        ParamByName('logradouro').Value := logradouro;
        ParamByName('cidade').Value := cidade;
        ParamByName('numero').Value := numero;
        ParamByName('complemento').Value := complemento;
        ParamByName('cep').Value := cep;
        ParamByName('bairro').Value := bairro;
        ParamByName('uf').Value := uf;
        ParamByName('situacaocadastral').Value := situacaocadastral;
        ParamByName('pgr').Value := pgr;
        ParamByName('pcmso').Value := pcmso;
        ParamByName('contratos').Value := contratos;
        ParamByName('nomeresponsavel').Value := nomeresponsavel;
        ParamByName('telefone').Value := telefone;

        ParamByName('outros').Value := outros;

        if outrosdata = '' then
          ParamByName('outrosdata').value := '1899-12-30'
        else
          ParamByName('outrosdata').Value := outrosdata;

        ParamByName('outros2').Value := outros2;

        if outros2data = '' then
          ParamByName('outros2data').value := '1899-12-30'
        else
          ParamByName('outros2data').Value := outros2data;

        ParamByName('email').Value := email;
        ParamByName('cnae1').Value := cnae1;
        ParamByName('cnae2').Value := cnae2;
        ParamByName('cnae3').Value := cnae3;
        ParamByName('cnae4').Value := cnae4;
        ParamByName('cnaedescricao1').Value := cnaedescricao1;
        ParamByName('cnaedescricao2').Value := cnaedescricao2;
        ParamByName('cnaedescricao3').Value := cnaedescricao3;
        ParamByName('cnaedescricao4').Value := cnaedescricao4;
        ParamByName('DELETADO').Value := 0;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar cliente: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;  }
end;

function TProjetozte.totalacionamento(const AQuery: TDictionary<string, string>;
  out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      close;
      sql.Clear;
      SQL.Add('Select  ');
      SQL.Add('obrazte.os,  ');
      SQL.Add('obrazte.id,  ');
      SQL.Add('obrazte.PO,  ');
      SQL.Add('obrazte.Region,  ');
      SQL.Add('obrazte.regiaobr,  ');
      SQL.Add('obrazte.State,  ');
      SQL.Add('obrazte.SiteID,  ');
      SQL.Add('obrazte.SiteName,  ');
      SQL.Add('obrazte.ZTECode,  ');
      SQL.Add('obrazte.ServiceDescription,  ');
      SQL.Add('obrazte.Qty,  ');
      SQL.Add('obrazte.sitenamefrom,  ');
      SQL.Add('obrazte.valorlpu,  ');
      SQL.Add('obrazte.historicolpu,  ');
      SQL.Add('obrazte.dataacionamento,  ');
      SQL.Add('obrazte.idcolaborador,  ');
      SQL.Add('gesempresas.nome,  ');
      SQL.Add('obrazte.regiao,    obrazte.statusdoc  ');
      SQL.Add('From  ');
      SQL.Add('obrazte Inner Join  ');
      SQL.Add('gesempresas On gesempresas.idempresa = obrazte.idcolaborador  ');
      SQL.Add('Where  ');
      SQL.Add('obrazte.os Like ''%OS%'' order by dataacionamento  ');
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

function TProjetozte.Editar(out erro: string): Boolean;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      with qry do
      begin
        Active := false;
        sql.Clear;
        SQL.Add('update obrazte set  ');
        SQL.Add('projeto=:projeto,  ');
        SQL.Add('supervisor=:supervisor,  ');
        SQL.Add('concentrador=:concentrador,  ');
        SQL.Add('tiposite=:tiposite,  ');
        SQL.Add('installplan=:installplan,  ');
        SQL.Add('installreal=:installreal,  ');
        SQL.Add('statusprojeto=:statusprojeto,  ');
        SQL.Add('gerenciaplan=:gerenciaplan,  ');
        SQL.Add('gerenciareal=:gerenciareal,  ');
        SQL.Add('mos=:mos,  ');
        SQL.Add('mosresp=:mosresp,  ');
        SQL.Add('compliance=:compliance,  ');
        SQL.Add('complianceresp=:complianceresp,  ');
        SQL.Add('ehs=:ehs,  ');
        SQL.Add('ehsresp=:ehsresp,  ');
        SQL.Add('qualidade=:qualidade,  ');
        SQL.Add('qualidaderesp=:qualidaderesp,  ');
        SQL.Add('pdi=:pdi,  ');
        SQL.Add('pdiresp=:pdiresp,  ');
        SQL.Add('statusdoc=:statusdoc,  ');
        SQL.Add('observacaodoc=:observacaodoc,  ');
        SQL.Add('observacao=:observacao,  ');
        SQL.Add('sitenamefrom=:sitenamefrom,  ');
        SQL.Add('po=:po, docresp=:docresp  ');
        SQL.Add('where os=:os ');
        ParamByName('os').asstring := os;
        ParamByName('projeto').asstring := projeto;
        ParamByName('supervisor').asstring := supervisor;
        ParamByName('concentrador').asstring := concentrador;
        ParamByName('tiposite').asstring := tiposite;
        ParamByName('installplan').AsDateTime := installplan;
        ParamByName('installreal').AsDateTime := installreal;
        ParamByName('statusprojeto').asstring := statusprojeto;
        ParamByName('gerenciaplan').AsDateTime := gerenciaplan;
        ParamByName('gerenciareal').AsDateTime := gerenciareal;
        ParamByName('mos').asstring := mos;
        ParamByName('mosresp').asstring := mosresp;
        ParamByName('compliance').asstring := compliance;
        ParamByName('complianceresp').asstring := complianceresp;
        ParamByName('ehs').asstring := ehs;
        ParamByName('ehsresp').asstring := ehsresp;
        ParamByName('qualidade').asstring := qualidade;
        ParamByName('qualidaderesp').asstring := qualidaderesp;
        ParamByName('pdi').asstring := pdi;
        ParamByName('pdiresp').asstring := pdiresp;
        ParamByName('docresp').asstring := docresp;
        ParamByName('statusdoc').asstring := statusdoc;
        ParamByName('observacaodoc').asstring := observacaodoc;
        ParamByName('observacao').asstring := observacao;
        ParamByName('sitenamefrom').asstring := sitenamefrom;
        ParamByName('po').asstring := po;
        ExecSQL;
      end;

      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao salvar projeto ZTE: ' + ex.Message;
        Result := false;
      end;
    end;

  finally
    qry.Free;
  end;
end;

function TProjetozte.Editaratividadepj(out erro: string): Boolean;
var
  qry, qry1, qry2: TFDQuery;
  id, demanda: Integer;
  valorlpu: Real;
  polocal, cliente, empresa, site: string;
begin
  try
    erro := '';
    valorlpu := 0;
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    qry1 := TFDQuery.Create(nil);
    qry1.connection := FConn;
    try
      with qry1 do
      begin
        active := false;
        SQL.Clear;
        SQL.Add('Select ');
        SQL.Add('obraztelpu.VALOR, ');
        SQL.Add('obraztelpu.DESCRICAOATIVIDADE, ');
        SQL.Add('obraztelpu.REGIAO, ');
        SQL.Add('obraztelpu.LOCALIDADE ');
        SQL.Add('from ');
        SQL.Add('obrazte Inner Join ');
        SQL.Add('obraztelpu On obraztelpu.CODIGO = obrazte.ZTECode  ');
        SQL.Add('Where ');
        SQL.Add('obraztelpu.regiao=:regiao and obraztelpu.area=:area and obrazte.id=:id and obraztelpu.estado=:estado and obraztelpu.historico =:historicolpu ');
        ParamByName('area').asstring := area;
        ParamByName('regiao').asstring := region;
        ParamByName('id').asstring := po;
        ParamByName('estado').asstring := estado;
        ParamByName('historicolpu').asstring := lpuhistorico;
        Open();
        valorlpu := fieldbyname('valor').AsFloat;
      end;

      FConn.StartTransaction;
      with qry do
      begin
        active := false;
        SQL.Clear;
        SQL.Add('update obrazte set os=:os,valorlpu=:valorlpu,historicolpu=:historicolpu,regiao=:regiao,');
        SQL.Add('observacao=:observacao, idcolaborador=:idcolaborador, dataacionamento=:dataacionamento where id=:id ');
        ParamByName('idcolaborador').AsInteger := idcolaboradorpj;
        ParamByName('os').Asstring := numero;
        if lpuhistorico = 'NEGOCIADO' then
          ParamByName('valorlpu').AsFloat := valornegociado
        else
          ParamByName('valorlpu').AsFloat := valorlpu;
        ParamByName('historicolpu').AsString := lpuhistorico;
        ParamByName('observacao').AsString := observacaopj;
        ParamByName('dataacionamento').AsDateTime := now;
        ParamByName('regiao').AsString := area;
        ParamByName('id').asstring := po;
        ExecSQL;

      end;

      FConn.Commit;

      if Length(erro) = 0 then
        result := true
      else
        Result := false;

    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro fazer lan?amento: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TProjetozte.Editaros(out erro: string): Boolean;
var
  qry: TFDQuery;
  idzteos: Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      with qry do
      begin
        Active := false;
        sql.Clear;
        SQL.Add('Select * From obrazte where os=:os ');
        ParamByName('os').asstring := os;
        Open();

        FConn.StartTransaction;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          sql.add('update admponteiro set idzteos = idzteos+1 ');
          execsql;
          close;
          sql.Clear;
          sql.add('select idzteos from admponteiro ');
          Open;
          idzteos := fieldbyname('idzteos').AsInteger;

        end;

      end;

      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao efetuar pagamento: ' + ex.Message;
        Result := false;
      end;
    end;

  finally
    qry.Free;
  end;
end;

function TProjetozte.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obrazte.id, ');
      SQL.Add('obrazte.PO, ');
      SQL.Add('obrazte.regiaobr, ');
      SQL.Add('obrazte.Region, ');
      SQL.Add('obrazte.State, ');
      SQL.Add('obrazte.SiteID, ');
      SQL.Add('obrazte.sitename, ');
      SQL.Add('Count(obrazte.id) As itens, ');
      SQL.Add('obrazte.ServiceDescription, ');
      SQL.Add('obrazte.Qty, ');
      SQL.Add('obrazte.StartTime, ');
      SQL.Add('obrazte.EndTime, ');
      SQL.Add('obrazte.UnitPrice, ');
      SQL.Add('obrazte.TotalValue, ');
      SQL.Add('obrazte.Subcontract, ');
      SQL.Add('obrazte.projectcode, ');
      SQL.Add('obrazte.projectname, ');
      SQL.Add('obrazte.podate, ');
      SQL.Add('obrazte.observacao, ');
      SQL.Add('obrazte.sitenamefrom, ');
      SQL.Add('obrazte.os ');
      SQL.Add('From ');
      SQL.Add('obrazte ');
      SQL.Add(' WHERE obrazte.id is not null ');
      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND ((obrazte.siteid like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (obrazte.sitename like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (obrazte.po like ''%' + AQuery.Items['busca'] + '%'') ) ');
        end;
      end;
      SQL.Add('Group By  ');
      SQL.Add('obrazte.PO, ');
      SQL.Add('obrazte.SiteName, ');
      SQL.Add('obrazte.sitenamefrom, ');
      SQL.Add('obrazte.os ');
      SQL.Add('order by obrazte.po asc  ');
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

function TProjetozte.Listapo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a, b: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('obrazte.id, ');
      SQL.Add('obrazte.ZTECode, ');
      SQL.Add('obrazte.ServiceDescription, ');
      SQL.Add('obrazte.Qty, ');
      SQL.Add('obrazte.UnitPrice, ');
      SQL.Add('obrazte.TotalValue ');
      SQL.Add('From ');
      SQL.Add('obrazte ');
      SQL.Add('Where ');
      SQL.Add('obrazte.SiteName = :sn And ');
      SQL.Add('obrazte.PO = :po and os = ''--'' order by ZTECode ');
      a := AQuery.Items['sn1'];
      b := AQuery.Items['po1'];
      ParamByName('sn').asstring := AQuery.Items['sn1'];
      ParamByName('po').asstring := AQuery.Items['po1'];

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

function TProjetozte.Listatarefas(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: string;
  i: integer;
begin
  qry := TFDQuery.Create(nil);
  qry.connection := FConn;
  try
    FConn.StartTransaction;
    with qry do
    begin
      Active := false;
      sql.Clear;
      sql.add('Select ');
      sql.add('obrazte.id,obrazte.ZTECode, ');
      sql.add('obrazte.ServiceDescription, ');
      sql.add('1 as qtd, ');
      sql.add('obrazte.Region ');
      sql.add('From ');
      sql.add('obrazte where obrazte.Region=:region ');
      sql.add('Group By ');
      sql.add('obrazte.ServiceDescription ');
      ParamByName('region').asstring := AQuery.Items['regiao'];
      Active := true;
      a := AQuery.Items['regiao'];
      i := RecordCount;
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

function TProjetozte.Listaacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a, b: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('obrazte.id, ');
      SQL.Add('obrazte.idcolaborador, ');
      SQL.Add('gesempresas.nome, ');
      SQL.Add('obrazte.PO, ');
      SQL.Add('obrazte.ServiceDescription, ');
      SQL.Add('obrazte.dataacionamento, ');
      SQL.Add('obrazte.dataacionamentoemail ');
      SQL.Add('From ');
      SQL.Add('obrazte left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obrazte.idcolaborador where     obrazte.os=:os  ');
      ParamByName('os').asstring := AQuery.Items['pros'];
      a := AQuery.Items['pros'];
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

function TProjetozte.NovoCadastro(out erro: string): string;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      FConn.StartTransaction;
      with qry do
      begin
        Active := false;
        sql.Clear;
        sql.add('update admponteiro set idzteos = idzteos+1 ');
        execsql;
        close;
        sql.Clear;
        sql.add('select idzteos from admponteiro ');
        Open;
        id := 'OS' + RetZero(fieldbyname('idzteos').Asstring, 6);
      end;
      FConn.Commit;
      erro := '';
      Result := id;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao consultar : ' + ex.Message;
        Result := '0';
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TProjetozte.rolloutzte(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select * ');
      SQL.Add('From ');
      SQL.Add('rolloutzte ');
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

function TProjetozte.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select * ');
      SQL.Add('From ');
      SQL.Add('obrazte ');
      SQL.Add(' WHERE obrazte.id is not null and id=:id ');
      ParamByName('id').asinteger := AQuery.Items['idprojetoericsson'].ToInteger;
      a := AQuery.Items['idprojetoericsson'].ToInteger;
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

function TProjetozte.Listaiddocumentacao(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select * ');
      SQL.Add('From ');
      SQL.Add('obrazte ');
      SQL.Add(' WHERE obrazte.os =:id ');
      ParamByName('id').asstring := AQuery.Items['osouobra'];
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


function TProjetozte.listagemgrupolpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      sql.add('@contador := @contador + 1  As value, ');
      SQL.Add('obraztelpu.historico As label ');
      SQL.Add('From ');
      SQL.Add('obraztelpu where historico <> ''NEGOCIADO'' ');
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND obraztelpu.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      SQL.Add('Group By ');
      SQL.Add('obraztelpu.historico ');
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


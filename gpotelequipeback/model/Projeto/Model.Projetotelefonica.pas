unit Model.Projetotelefonica;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection, ComObj,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections, UtFuncao,
  DateUtils, System.JSON, System.Classes, Model.Email;

type
  TProjetotelefonica = class
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
    Fstatus: string;
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
    Fhistorico: string;
    Fidrollout: Integer;
    Fidatividade: Integer;
    Fidpacote: Integer;
    Fidcolaborador: Integer;
    Fidpmts: string;
    Fidfuncionario: Integer;
    Fdatainicioclt: string;
    Fdatafinalclt: string;
    Ftotalhorasclt: integer;
    Fobservacaoclt: string;
    Fhoranormalclt: Double;
    Fhora50clt: Double;
    Fhora100clt: Double;
    Fatividade: string;
    Ftipopagamento: string;
    Fdiapagamento: string;

    Finfra: string;
    Finfravivo: string;
    Facessoatividade: string;
    Facessocomentario: string;
    Facessooutros: string;
    Facessoformaacesso: string;
    Fddd: string;
    FCidade: string;
    Fnomedosite: string;
    Fendereco: string;
    FLATITUDE: string;
    FLONGITUDE: string;
    Facessoobs: string;
    Facessodatainicial: string;
    Facessodatafinal: string;
    Facessodatasolicitacao: string;
    Facessosolicitacao: string;
    Facessostatus: string;
    FEntregaPlan: string;
    FEntregaReal: string;
    FFimInstalacaoPlan: string;
    FFimInstalacaoReal: string;
    FIntegracaoPlan: string;
    FIntegracaoReal: string;
    FAtivacao: string;
    FDocumentacao: string;
    FInventarioDesinstalacao: string;
    FDTPlan: string;
    FDTReal: string;
    FAprovacaoSSV: string;
    FStatusObra: string;
    Fdocaplan: string;
    FOV: string;
    FUIDIDCPOMRF: string;
    Fresumodafase: string;
    Frollout: string;
    Fvistoriaplan: string;
    Fvistoriareal: string;
    Fdocplan: string;
    Fdocvitoriareal: string;
    Freq: string;
    Fquantidade: double;
    Fiddescricaocod: string;
    Fobra: string;
    Fsite: string;
    Fidusuario: string;
    Facompanhamentofisicoobservacao: string;
    Fequipe: string;
    Fdatadopagamento: TDatetime;
    Fregionalocal: string;
    Frevedescricao: string;
    Finitialtunningreal: string;
    Finitialtunningstatus: string;
    Finitialtunningrealfinal: string;
    Fstatusaprovacaossv: string;

    FdataExecucaoDoc: string;
    FdataPostagemDoc: string;
    FselectedOptionStatusDocumentacao: string;
    FdataExecucaoDocVDVM: string;
    FdataPostagemDocVDVM: string;
    FobservacaoDocumentacao: string;
    Fdataimprodutiva: string;


    procedure AddMultipleFiltersFromJSON(AQuery: TDictionary<string, string>; const KeysAndFields: array of string; SQL: TStrings);

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
    property historico: string read Fhistorico write Fhistorico;
    property idrollout: Integer read Fidrollout write Fidrollout;
    property idatividade: Integer read Fidatividade write Fidatividade;
    property idpacote : Integer read Fidpacote write Fidpacote;
    property idcolaborador: Integer read Fidcolaborador write Fidcolaborador;
    property idpmts: string read Fidpmts write Fidpmts;
    property idfuncionario: Integer read Fidfuncionario write Fidfuncionario;
    property datainicioclt: string read Fdatainicioclt write Fdatainicioclt;
    property datafinalclt: string read Fdatafinalclt write Fdatafinalclt;
    property totalhorasclt: integer read Ftotalhorasclt write Ftotalhorasclt;
    property observacaoclt: string read Fobservacaoclt write Fobservacaoclt;
    property horanormalclt: double read Fhoranormalclt write Fhoranormalclt;
    property hora50clt: double read Fhora50clt write Fhora50clt;
    property hora100clt: double read Fhora100clt write Fhora100clt;
    property atividade: string read Fatividade write Fatividade;

    property infra: string read Finfra write Finfra;
    property infravivo: string read Finfravivo write Finfravivo;
    property acessoatividade: string read Facessoatividade write Facessoatividade;
    property acessocomentario: string read Facessocomentario write Facessocomentario;
    property acessooutros: string read Facessooutros write Facessooutros;
    property acessostatus: string read Facessostatus write Facessostatus;
    property acessoformaacesso: string read Facessoformaacesso write Facessoformaacesso;
    property ddd: string read Fddd write Fddd;
    property Cidade: string read FCidade write FCidade;
    property nomedosite: string read Fnomedosite write Fnomedosite;
    property endereco: string read Fendereco write Fendereco;
    property LATITUDE: string read FLATITUDE write FLATITUDE;
    property LONGITUDE: string read FLONGITUDE write FLONGITUDE;
    property acessoobs: string read Facessoobs write Facessoobs;
    property acessodatainicial: string read Facessodatainicial write Facessodatainicial;
    property acessodatafinal: string read Facessodatafinal write Facessodatafinal;
    property acessodatasolicitacao: string read Facessodatasolicitacao write Facessodatasolicitacao;
    property acessosolicitacao: string read Facessosolicitacao write Facessosolicitacao;
    property EntregaPlan: string read FEntregaPlan write FEntregaPlan;
    property EntregaReal: string read FEntregaReal write FEntregaReal;
    property FimInstalacaoPlan: string read FFimInstalacaoPlan write FFimInstalacaoPlan;
    property FimInstalacaoReal: string read FFimInstalacaoReal write FFimInstalacaoReal;
    property IntegracaoPlan: string read FIntegracaoPlan write FIntegracaoPlan;
    property IntegracaoReal: string read FIntegracaoReal write FIntegracaoReal;
    property Ativacao: string read FAtivacao write FAtivacao;
    property Documentacao: string read FDocumentacao write FDocumentacao;
    property InventarioDesinstalacao: string read FInventarioDesinstalacao write FInventarioDesinstalacao;
    property DTPlan: string read FDTPlan write FDTPlan;
    property DTReal: string read FDTReal write FDTReal;
    property AprovacaoSSV: string read FAprovacaoSSV write FAprovacaoSSV;
    property StatusObra: string read FStatusObra write FStatusObra;
    property docaplan: string read Fdocaplan write Fdocaplan;
    property OV: string read FOV write FOV;
    property UIDIDCPOMRF: string read FUIDIDCPOMRF write FUIDIDCPOMRF;
    property resumodafase: string read Fresumodafase write Fresumodafase;
    property rollout: string read Frollout write Frollout;
    property vistoriaplan: string read Fvistoriaplan write Fvistoriaplan;
    property vistoriareal: string read Fvistoriareal write Fvistoriareal;
    property docplan: string read Fdocplan write Fdocplan;
    property docvitoriareal: string read Fdocvitoriareal write Fdocvitoriareal;
    property req: string read Freq write Freq;
    property quantidade: double read Fquantidade write Fquantidade;
    property iddescricaocod: string read Fiddescricaocod write Fiddescricaocod;
    property obra: string read Fobra write Fobra;
    property site: string read Fsite write Fsite;
    property tipopagamento: string read Ftipopagamento write Ftipopagamento;
    property diapagamento: string read Fdiapagamento write Fdiapagamento;
    property equipe: string read Fequipe write Fequipe;
    property initialtunningstatus: string read Finitialtunningstatus write Finitialtunningstatus;
    property initialtunningreal: string read Finitialtunningreal write Finitialtunningreal;
    property initialtunningrealfinal: string read Finitialtunningrealfinal write Finitialtunningrealfinal;
    property statusaprovacaossv: string read Fstatusaprovacaossv write Fstatusaprovacaossv;

    property dataExecucaoDoc: string read FdataExecucaoDoc write FdataExecucaoDoc;
    property dataPostagemDoc: string read FdataPostagemDoc write FdataPostagemDoc;
    property selectedOptionStatusDocumentacao: string read FselectedOptionStatusDocumentacao write FselectedOptionStatusDocumentacao;
    property dataExecucaoDocVDVM: string read FdataExecucaoDocVDVM write FdataExecucaoDocVDVM;
    property dataPostagemDocVDVM: string read FdataPostagemDocVDVM write FdataPostagemDocVDVM;
    property observacaoDocumentacao: string read FobservacaoDocumentacao write FobservacaoDocumentacao;

    property idusuario: string read Fidusuario write Fidusuario;

    property regionalocal: string read Fregionalocal write Fregionalocal;
    property brevedescricao: string read Frevedescricao write Frevedescricao;
    property dataimprodutiva: string read Fdataimprodutiva write Fdataimprodutiva;

    property acompanhamentofisicoobservacao: string read Facompanhamentofisicoobservacao write Facompanhamentofisicoobservacao;
    function apagarpagamento(const ABody: TJSONObject; out erro: string): Boolean;
    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listapmts(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaacompanhamentofinanceiro(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaatividades(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaconsolidado(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listapacotes(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listapo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listatarefas(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editaros(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): string;
    function Listaatividadepj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listalpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaacionamentopj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaacionamentoclt(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function salvaacionamentopj(out erro: string): Boolean;
    function salvaacionamentoclt(out erro: string): Boolean;
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
    function rollouttelefonica(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function totalacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function listacodt2(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editart2(out erro: string): Boolean;
    function listat2(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaatividade(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function emailadicional(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaacionamentos(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaSelectpjtelefonica(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaacionamentosf(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaacionamentosfhistorico(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function marcadorestelefonica(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function marcadorestelefonicaatrasado(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function graficosituacoes(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function diaria(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function extratodesconto(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function salvapagamento(out erro: string): Boolean;
    function Listastatuspmts(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function regionaltelefonica(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function listaidpmts(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function editartarefa(out erro: string): Boolean;
    function regionaltelefonicast(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function salvarpagamento(out erro: string): Boolean;
    function salvadesconto(out erro: string): Boolean;

    function ListPrevisaoFechamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;

    function dashboardtelefonicaposicionamentofinanceiro(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaacionamentoshistoricopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaDespesas(const AQuery: TDictionary<string, string>; var erro: string; var totalGeral: Double): TFDQuery;
    function listat4(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ExtrairRegional(const T2DescricaoCod: string): string;
    function GerarNumeroSequencial(const Regional: string; Ano: Integer; out erro: string): Integer;
    function AtualizarParaEmFaturamento(const ABody: TJSONObject; out erro: string): Boolean;
    function SalvarNotaFiscalT4(const ABody: TJSONObject; out erro: string): Boolean;
    function RegistrarCartaTAF(const DadosT2: TDictionary<string, string>; out Erro: string; out NomeArquivo: String): Boolean;
    function UpdateStatusFaturamento(const id: String; const statusFaturamento: String; out Erro: string): Boolean;
    function EditarEmMassa(const AJsonBody: string; out erro: string): Boolean;
  end;

implementation

{ TProjetoericsson }

constructor TProjetotelefonica.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TProjetotelefonica.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TProjetotelefonica.extratodesconto(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select * From telefonicapagamentodesconto  ');
      sql.add('where telefonicapagamentodesconto.idcolaborador =:idcolaborador and telefonicapagamentodesconto.mespagamento=:mespagamento and   ');
      sql.add('telefonicapagamentodesconto.datapagamento=:datapagamento and telefonicapagamentodesconto.tipopagamento =:tipopagamento ');
      parambyname('idcolaborador').asinteger := AQuery.items['idempresa'].tointeger;
      parambyname('mespagamento').asstring := AQuery.items['mespagamento'];
      ParamByName('datapagamento').Asstring := AQuery.items['datapagamento'];
      ParamByName('tipopagamento').AsString := AQuery.items['tipopagamento'];

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

function TProjetotelefonica.diaria(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('    gesdiaria.numero as id,  ');
      SQL.Add('    gesdiaria.datasolicitacao,  ');
      SQL.Add('    gespessoa.nome,  ');
      SQL.Add('    gesdiaria.projeto,  ');
      SQL.Add('    gesdiaria.siteid,  ');
      SQL.Add('    gesdiaria.siglasite,  ');
      SQL.Add('    gesdiaria.po,  ');
      SQL.Add('    gesdiaria.local,  ');
      SQL.Add('    gesdiaria.descricao,  ');
      SQL.Add('    gesdiaria.valoroutrassolicitacoes,  ');
      SQL.Add('    gesdiaria.diarias,  ');
      SQL.Add('    gesdiaria.valortotal,  ');
      SQL.Add('    gesdiaria.solicitante  ');
      SQL.Add('From  ');
      SQL.Add('    gesdiaria Inner Join  ');
      SQL.Add('    gespessoa On gespessoa.idpessoa = gesdiaria.colaborador where gesdiaria.siteid =:siteid ');
      ParamByName('siteid').asstring := AQuery.Items['osouobra'];
      a := AQuery.Items['osouobra'];
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

function TProjetotelefonica.ListaSelectpjtelefonica(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('fechamentotelefonica.idcolaborador as value, ');
      SQL.Add('gesempresas.nome as label ');
      SQL.Add('From ');
      SQL.Add('fechamentotelefonica Inner Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = fechamentotelefonica.idcolaborador ');
      SQL.Add('Group By ');
      SQL.Add('fechamentotelefonica.idcolaborador order by gesempresas.nome  ');
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

function TProjetotelefonica.ListaDespesas(const AQuery: TDictionary<string, string>; var erro: string; var totalGeral: Double): TFDQuery;
var
  qry, qryTotal: TFDQuery;
  DataConvertida: TDateTime;
  FormatSettings: TFormatSettings;
begin
  Result := nil;
  erro := '';
  totalGeral := 0;

  if not Assigned(FConn) then
  begin
    erro := 'Conexão com o banco de dados não está inicializada';
    Exit;
  end;

  FormatSettings := TFormatSettings.Create;
  FormatSettings.ShortDateFormat := 'yyyy-mm-dd';
  FormatSettings.DateSeparator := '-';

  // Executar SET @rownum := 0 separadamente
  try
    FConn.ExecSQL('SET @rownum := 0;');
  except
    on E: Exception do
    begin
      erro := 'Erro ao inicializar contador de linha: ' + E.Message;
      Exit;
    end;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    qry.CachedUpdates := False;

    qry.SQL.Clear;
    qry.SQL.Add('SELECT @rownum := @rownum + 1 AS id, d.* FROM (');
    qry.SQL.Add('  SELECT DISTINCT ac.idpmts, gp.nome AS descricao, ROUND((g.salario / 30 / 8) * ac.totaldehoras, 2) AS valor, ac.dataacionamento, gu.nome, ''ACIONAMENTO CLT'' AS tipo,    rolloutvivo.ufsigla, ');
    qry.SQL.Add('rolloutvivo.pmosigla ');
    qry.SQL.Add('  FROM acionamentovivoclt ac');
    qry.SQL.Add('  INNER JOIN gespessoa gp ON gp.idpessoa = ac.idcolaborador');
    qry.SQL.Add('  INNER JOIN gesusuario gu ON gu.idusuario = ac.idfuncionario');
    qry.SQL.Add('  INNER JOIN gesfolhapagamento g ON REPLACE(REPLACE(REPLACE(gp.cpf, ''.'', ''''), ''-'', ''''), ''/'', '''') = REPLACE(REPLACE(REPLACE(g.cpf, ''.'', ''''), ''-'', ''''), ''/'', '''')  left Join rolloutvivo On rolloutvivo.UIDIDPMTS = ac.idpmts ');
    qry.SQL.Add('  WHERE ac.deletado = 0');

    qry.SQL.Add('  UNION ALL');

    qry.SQL.Add('  SELECT av.idpmts, CONCAT(ge.nome, '' '', lp.CODIGOLPUVIVO) AS descricao, lp.VALORPJ, av.dataacionamento, gu.nome, ''ACIONAMENTO PJ'' AS tipo, rolloutvivo.ufsigla , rolloutvivo.pmosigla ');
    qry.SQL.Add('  FROM acionamentovivo av');
    qry.SQL.Add('  INNER JOIN lpuvivo lp ON lp.ID = av.idpacote AND lp.HISTORICO = av.lpu');
    qry.SQL.Add('  INNER JOIN gesempresas ge ON ge.idempresa = av.idcolaborador');
    qry.SQL.Add('  INNER JOIN gesusuario gu ON gu.idusuario = av.idfuncionario left Join rolloutvivo On rolloutvivo.UIDIDPMTS = av.idpmts ');
    qry.SQL.Add('  WHERE av.deletado = 0');

    qry.SQL.Add('  UNION ALL');

    qry.SQL.Add('  SELECT rv.UIDIDPMTS AS idpmts, gp.descricao,');
    qry.SQL.Add('    (SELECT gce.valor FROM gescontroleestoque gce');
    qry.SQL.Add('     WHERE gce.idtipomovimentacao = 1 AND gce.idproduto = gsi.idproduto LIMIT 1) AS valor,');
    qry.SQL.Add('    gs.data AS dataacionamento, gu.nome, ''MATERIAL E SERVIÇO'' AS tipo , rv.UFSIGLA , rv.PMOSIGLA  ');
    qry.SQL.Add('  FROM rolloutvivo rv');
    qry.SQL.Add('  INNER JOIN gessolicitacao gs ON gs.obra = rv.UIDIDPMTS');
    qry.SQL.Add('  INNER JOIN gessolicitacaoitens gsi ON gsi.idsolicitacao = gs.idsolicitacao');
    qry.SQL.Add('  INNER JOIN gesproduto gp ON gp.idproduto = gsi.idproduto');
    qry.SQL.Add('  INNER JOIN gesusuario gu ON gu.idusuario = gs.idcolaborador');
    qry.SQL.Add('  WHERE gs.projeto = ''TELEFONICA''');

    qry.SQL.Add('  UNION ALL');

    qry.SQL.Add('  SELECT ');
    qry.SQL.Add('    acionamentovivo.idpmts AS idpmts,');
    qry.SQL.Add('    despesas.descricao AS descricao,');
    qry.SQL.Add('    (despesas.valorparcela / 30) * ');
    qry.SQL.Add('    CASE ');
    qry.SQL.Add('      WHEN telefonicacontrolet2.atividade = ''Test'' AND rolloutvivo.DTPLan <> ''1899-12-30'' AND rolloutvivo.DTReal <> ''1899-12-30'' THEN DATEDIFF(rolloutvivo.DTPLan, rolloutvivo.DTReal) + 1');
    qry.SQL.Add('      WHEN telefonicacontrolet2.atividade = ''Instalação'' AND rolloutvivo.FimInstalacaoPlan <> ''1899-12-30'' AND rolloutvivo.FimInstalacaoReal <> ''1899-12-30'' THEN DATEDIFF(rolloutvivo.FimInstalacaoPlan, rolloutvivo.FimInstalacaoReal) + 1');
    qry.SQL.Add('      WHEN telefonicacontrolet2.atividade = ''Vistoria'' AND rolloutvivo.vistoriareal <> ''1899-12-30'' AND rolloutvivo.vistoriaplan <> ''1899-12-30'' THEN DATEDIFF(rolloutvivo.vistoriareal, rolloutvivo.vistoriaplan) + 1');
    qry.SQL.Add('      ELSE 0');
    qry.SQL.Add('    END AS valor,');
    qry.SQL.Add('    despesas.datalancamento AS dataacionamento,');
    qry.SQL.Add('    gesempresas.nome,');
    qry.SQL.Add('    ''CUSTO DE FROTAS'' AS tipo,');
    qry.SQL.Add('    rolloutvivo.ufsigla,');
    qry.SQL.Add('    rolloutvivo.pmosigla');
    qry.SQL.Add('  FROM acionamentovivo');
    qry.SQL.Add('    LEFT JOIN telefonicacontrolet2 ON telefonicacontrolet2.ID = acionamentovivo.idatividade');
    qry.SQL.Add('    LEFT JOIN lpuvivo ON lpuvivo.ID = acionamentovivo.idpacote');
    qry.SQL.Add('    LEFT JOIN gesempresas ON gesempresas.idempresa = acionamentovivo.idcolaborador');
    qry.SQL.Add('    LEFT JOIN rolloutvivo ON rolloutvivo.UIDIDPMTS = acionamentovivo.idpmts');
    qry.SQL.Add('    LEFT JOIN gesdespesas despesas ON despesas.idempresa = acionamentovivo.idcolaborador');
    qry.SQL.Add('  WHERE despesas.categoria = ''Locação''');
    qry.SQL.Add('  UNION ALL');

    qry.SQL.Add('  SELECT gd.siteid AS idpmts, gd.descricao, gd.valortotal AS valor, gd.datasolicitacao AS dataacionamento, gd.nomecolaborador AS nome, ''DIARIA'' AS tipo, rolloutvivo.ufsigla , rolloutvivo.pmosigla  ');
    qry.SQL.Add('  FROM gesdiaria gd left Join rolloutvivo On rolloutvivo.UIDIDPMTS = gd.siteid  ');
    qry.SQL.Add('  WHERE gd.projeto = ''TELEFONICA''');
    qry.SQL.Add(') AS d');
    qry.SQL.Add('WHERE 1=1');

    if AQuery.ContainsKey('idpmts') and (Trim(AQuery.Items['idpmts']) <> '') then
    begin
      qry.SQL.Add(' AND d.idpmts LIKE :idpmts');
      qry.ParamByName('idpmts').AsString := '%' + Trim(AQuery.Items['idpmts']) + '%';
    end;
    if AQuery.ContainsKey('ufsigla') and (Trim(AQuery.Items['ufsigla']) <> '') then
    begin
      qry.SQL.Add(' AND d.ufsigla LIKE :ufsigla');
      qry.ParamByName('ufsigla').AsString := '%' + Trim(AQuery.Items['ufsigla']) + '%';
    end;
    if AQuery.ContainsKey('sigla') and (Trim(AQuery.Items['sigla']) <> '') then
    begin
      qry.SQL.Add(' AND d.pmosigla LIKE :sigla');
      qry.ParamByName('sigla').AsString := '%' + Trim(AQuery.Items['sigla']) + '%';
    end;

    if AQuery.ContainsKey('datainicio') and (Trim(AQuery.Items['datainicio']) <> '') then
    begin
      if TryStrToDate(AQuery.Items['datainicio'], DataConvertida, FormatSettings) then
      begin
        qry.SQL.Add(' AND d.dataacionamento >= :datainicio');
        qry.ParamByName('datainicio').AsDate := DataConvertida;
      end
      else
        raise Exception.Create('Formato de data inicial inválido. Use DD/MM/AAAA');
    end;

    if AQuery.ContainsKey('datafinal') and (Trim(AQuery.Items['datafinal']) <> '') then
    begin
      if TryStrToDate(AQuery.Items['datafinal'], DataConvertida, FormatSettings) then
      begin
        qry.SQL.Add(' AND d.dataacionamento < :datafinal');
        qry.ParamByName('datafinal').AsDate := DataConvertida + 1;
      end
      else
        raise Exception.Create('Formato de data final inválido. Use DD/MM/AAAA');
    end;

    qry.SQL.Add(' ORDER BY d.dataacionamento DESC');
    qry.Open;

    // Cálculo do total
    qryTotal := TFDQuery.Create(nil);
    try
      qryTotal.Connection := FConn;
      qryTotal.SQL.Text := 'SELECT SUM(valor) AS total FROM (' + qry.SQL.Text + ') AS subquery';
      qryTotal.Params.Clear;

      if qry.Params.FindParam('idpmts') <> nil then
      begin
        qryTotal.Params.CreateParam(ftString, 'idpmts', ptInput);
        qryTotal.ParamByName('idpmts').AsString := qry.ParamByName('idpmts').AsString;
      end;

      if qry.Params.FindParam('ufsigla') <> nil then
      begin
        qryTotal.Params.CreateParam(ftString, 'ufsigla', ptInput);
        qryTotal.ParamByName('ufsigla').AsString := qry.ParamByName('ufsigla').AsString;
      end;

      if qry.Params.FindParam('sigla') <> nil then
      begin
        qryTotal.Params.CreateParam(ftString, 'sigla', ptInput);
        qryTotal.ParamByName('sigla').AsString := qry.ParamByName('sigla').AsString;
      end;

      if qry.Params.FindParam('datainicio') <> nil then
      begin
        qryTotal.Params.CreateParam(ftDate, 'datainicio', ptInput);
        qryTotal.ParamByName('datainicio').AsDate := qry.ParamByName('datainicio').AsDate;
      end;

      if qry.Params.FindParam('datafinal') <> nil then
      begin
        qryTotal.Params.CreateParam(ftDate, 'datafinal', ptInput);
        qryTotal.ParamByName('datafinal').AsDate := qry.ParamByName('datafinal').AsDate;
      end;

      qryTotal.Open;
      totalGeral := qryTotal.FieldByName('total').AsFloat;
    finally
      qryTotal.Free;
    end;

    Result := qry;

  except
    on E: Exception do
    begin
      erro := 'Erro ao executar a consulta: ' + E.Message;
      qry.Free;
    end;
  end;
end;

function TProjetotelefonica.Editarpagamento(out erro: string): Boolean;
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

function TProjetotelefonica.salvapagamento(out erro: string): Boolean;
var
  qry: TFDQuery;
  id: Integer;
  FS: TFormatSettings;
  valorp, porcent, valorpg, valorpgexistente, valorpagamentoexistente, valorpagamentonovo: Real;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    FS := TFormatSettings.Create;
    FS.DateSeparator := '-';
    FS.ShortDateFormat := 'yyyy-mm-dd';

    try
      FConn.StartTransaction;

      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('Select  ');
        SQL.Add('acionamentovivo.id, ');
        SQL.Add('acionamentovivo.valor,  ');
        SQL.Add('coalesce(Sum(telefonicapagamento.valorpagamento),0) As Sum_valorpagamento  ');
        SQL.Add('From  ');
        SQL.Add('acionamentovivo left Join   ');
        SQL.Add('telefonicapagamento On telefonicapagamento.idacionamentovivo = acionamentovivo.id WHERE acionamentovivo.id = :id  ');
        SQL.Add('Group By  ');
        SQL.Add('acionamentovivo.id ');
        ParamByName('id').AsInteger := idgeralfechamento;
        Open;
        valorp := fieldbyname('valor').asfloat;
        valorpgexistente := FieldByName('Sum_valorpagamento').asfloat;
        if valorp < 0 then
          valorp := 0;

        Close;
        SQL.Clear;
        SQL.Add('select * from telefonicapagamento where mespagamento=:mespagamento and datapagamento=:datapagamento and ');
        SQL.Add('tipopagamento=:tipopagamento and idacionamentovivo=:idacionamentovivo  ');
        ParamByName('idacionamentovivo').AsInteger := idgeralfechamento;
        ParamByName('mespagamento').AsString := mesfechamento;
        ParamByName('datapagamento').AsDate := StrToDate(diapagamento, FS);
        ParamByName('tipopagamento').AsString := tipopagamento;
        Open();
        valorpagamentoexistente := 0;
        if RecordCount > 0 then
          valorpagamentoexistente := FieldByName('valorpagamento').asfloat;

        valorpagamentonovo := valorp * (porcentagem / 100);
        if (valorpgexistente - valorpagamentoexistente + valorpagamentonovo) > valorp then
        begin
          FConn.Rollback;
          erro := 'Pagamento inválido: o valor informado ultrapassa 100% do valor do site.';
          Result := false;
          Exit;
        end;
        if RecordCount = 0 then
        begin
          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO telefonicapagamento ');
          SQL.Add('        (idacionamentovivo,  mespagamento,  porcentagem,  valorpagamento, observacao,  datapagamento,    idfuncionario,  tipopagamento, datafechamento) ');
          SQL.Add('VALUES (:idacionamentovivo, :mespagamento, :porcentagem, :valorpago,     :observacao, :datadopagamento, :idfuncionario, :status,       :datafechamento)');
        end
        else
        begin
          Close;
          SQL.Clear;
          sql.add('update telefonicapagamento set valorpagamento=:valorpago, porcentagem=:porcentagem, observacao=:observacao, idfuncionario=:idfuncionario, datafechamento=:datafechamento where mespagamento=:mespagamento and datapagamento=:datadopagamento and  ');
          SQL.Add('tipopagamento=:status and idacionamentovivo=:idacionamentovivo  ');
        end;
        ParamByName('mespagamento').AsString := mesfechamento;
        ParamByName('porcentagem').Asfloat := porcentagem / 100;
        ParamByName('valorpago').AsFloat := valorpagamentonovo;
        ParamByName('observacao').AsString := observacao;
        ParamByName('datadopagamento').AsDate := StrToDate(diapagamento, FS);
        ParamByName('status').AsString := tipopagamento;
        ParamByName('idfuncionario').AsInteger := idfuncionario;
        ParamByName('datafechamento').AsDatetime := now;
        ParamByName('idacionamentovivo').AsInteger := idgeralfechamento;
        ExecSQL;

        Close;
        SQL.Clear;
        sql.Add('Select ');
        sql.Add('Sum(telefonicapagamento.porcentagem) As Sum_porcentagem, ');
        sql.Add('Sum(telefonicapagamento.valorpagamento) As Sum_valorpagamento ');
        sql.Add('From ');
        sql.Add('telefonicapagamento where idacionamentovivo =:idacionamentovivo  ');
        ParamByName('idacionamentovivo').AsInteger := idgeralfechamento;
        Open();
        porcent := FieldByName('Sum_porcentagem').asfloat;
        valorpg := FieldByName('Sum_valorpagamento').asfloat;

        Close;
        SQL.Clear;
        SQL.Add('update acionamentovivo set porcentagem = :porce, valorpago = :vp where id=:id  ');
        ParamByName('id').asinteger := idgeralfechamento;
        ParamByName('porce').asfloat := porcent;
        ParamByName('vp').asfloat := valorpg;
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

function TProjetotelefonica.Listaparadocumentacao(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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

function TProjetotelefonica.Listapmts(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select * ');
      SQL.Add('From ');
      SQL.Add('pmtsvivo ');
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

function TProjetotelefonica.Listastatuspmts(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select pmtsvivo.DATA_MODIFICACAO as dmod From pmtsvivo Limit 1 ');
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

function TProjetotelefonica.Listaconsolidado(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select * ');
      SQL.Add('From ');
      SQL.Add('consolidadotelefonica ');
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

function TProjetotelefonica.apagarpagamento(const ABody: TJSONObject; out erro: string): Boolean;
var
  qry: TFDQuery;
  id: Integer;
  idaciovivo: Integer;
  porcent, valorpg: Real;
begin
  Result := False;
  erro := '';

  // Verifica se o corpo contém o campo "id"
  if not ABody.TryGetValue<Integer>('id', id) then
  begin
    erro := 'Parâmetro "id" obrigatório.';
    Exit;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    FConn.StartTransaction;

    try
      with qry do
      begin
        Close;
        SQL.Clear;
        sql.add('select idacionamentovivo from telefonicapagamento where idgeral =:id ');
        ParamByName('id').AsInteger := id;
        Open();
        idaciovivo := FieldByName('idacionamentovivo').asinteger;

        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM telefonicapagamento');
        SQL.Add('WHERE idgeral = :id');
        ParamByName('id').AsInteger := id;
        ExecSQL;

        Close;
        SQL.Clear;
        sql.Add('Select ');
        sql.Add('Sum(telefonicapagamento.porcentagem) As Sum_porcentagem, ');
        sql.Add('Sum(telefonicapagamento.valorpagamento) As Sum_valorpagamento ');
        sql.Add('From ');
        sql.Add('telefonicapagamento where idacionamentovivo =:idacionamentovivo  ');
        ParamByName('idacionamentovivo').AsInteger := idaciovivo;
        Open();
        porcent := FieldByName('Sum_porcentagem').asfloat;
        valorpg := FieldByName('Sum_valorpagamento').asfloat;

        Close;
        SQL.Clear;
        SQL.Add('update acionamentovivo set porcentagem = :porce, valorpago = :vp where id=:id');
        ParamByName('id').asinteger := idaciovivo;
        ParamByName('porce').asfloat := porcent;
        ParamByName('vp').asfloat := valorpg;
        ExecSQL;

      end;

      FConn.Commit;
      Result := True;
    except
      on ex: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao excluir pagamento: ' + ex.Message;
        Result := False;
      end;
    end;

  finally
    qry.Free;
  end;
end;

function TProjetotelefonica.ListaFechamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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

function TProjetotelefonica.historicopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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

function TProjetotelefonica.editartarefa(out erro: string): Boolean;
var
  qry: TFDQuery;
  cont: Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      FConn.StartTransaction;
      with qry do
      begin
        active := false;
        SQL.Clear;
        SQL.Add('insert into lpuvivo(UF,DIVISAO,BREVEDESCRICAO,HISTORICO,idfuncionario,CODIGOLPUVIVO) ');
        SQL.Add('            values(:UF,:DIVISAO,:BREVEDESCRICAO,:HISTORICO,:idfuncionario,:CODIGOLPUVIVO) ');
        ParamByName('UF').AsString := regionalocal;
        ParamByName('DIVISAO').AsString := regiao;
        ParamByName('BREVEDESCRICAO').AsString := brevedescricao;
        ParamByName('HISTORICO').AsString := 'NEGOCIADO';
        ParamByName('idfuncionario').AsString := idusuario;
        Parambyname('CODIGOLPUVIVO').Asstring := 'NEGOCIADO';
        execsql
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
        erro := 'Erro fazer lançamento: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TProjetotelefonica.emailadicional(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select * From telefonicaadicional where regional=:regional ');
      ParamByName('regional').asstring := AQuery.Items['uf'];
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

function TProjetotelefonica.listaidpmts(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select rolloutvivo.UIDIDPMTS From rolloutvivo where deletado = 0 order by UIDIDPMTS ');
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

function TProjetotelefonica.regionaltelefonica(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select * From telefonicaadicional where regional=:regional ');
      ParamByName('regional').AsString := AQuery['uf'];
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

function TProjetotelefonica.regionaltelefonicast(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select  regional  From telefonicaadicional order by regional ');
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

function TProjetotelefonica.extratopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  Result := nil;
  erro := '';

  if not Assigned(AQuery) then
  begin
    erro := 'Erro: Parâmetros não foram fornecidos.';
    Exit;
  end;

  if not AQuery.ContainsKey('idempresa') then
  begin
    erro := 'Erro: Parâmetro obrigatório "idempresa" ausente.';
    Exit;
  end;

  if not Assigned(FConn) then
  begin
    erro := 'Erro: Conexão com banco de dados não inicializada.';
    Exit;
  end;

  qry := TFDQuery.Create(nil);

  try
    qry.Connection := FConn;

    with qry.SQL do
    begin
      Clear;
      Add('SELECT');
      Add('  acionamentovivo.id AS id,');
      Add('  acionamentovivo.idpmts,');
      Add('  acionamentovivo.po,');
      Add('  rolloutvivo.ufsigla,');
      Add('  rolloutvivo.pmosigla,');
      Add('  rolloutvivo.pmoregional,');
      Add('  lpuvivo.brevedescricao,');
      Add('  acionamentovivo.quantidade,');
      Add('  lpuvivo.codigolpuvivo, ');
      Add('  t.mespagamento,');
      Add('  t.tipopagamento as status,');
      Add('  Date_Format( t.datapagamento , "%d/%m/%Y") As datadopagamento, ');
      Add('  t.idgeral as idpagamento, ');
      Add('  t.valorpagamento as valor,');
      Add('  t.observacao,');
      Add('  acionamentovivo.porcentagem,');
      Add('  rolloutvivo.entregareal,');
      Add('  rolloutvivo.fiminstalacaoreal,');
      Add('  rolloutvivo.integracaoreal,');
      Add('  rolloutvivo.dtreal,');
      Add('  rolloutvivo.vistoriareal,');
      Add('  rolloutvivo.ativacao,');
      Add('  rolloutvivo.documentacao,');
      Add('  rolloutvivo.inventariodesinstalacao,');
      Add('  gesempresas.email');
      Add(' FROM acionamentovivo');
      Add(' LEFT JOIN telefonicapagamento t ON t.idacionamentovivo = acionamentovivo.id ');
      Add(' INNER JOIN rolloutvivo ON rolloutvivo.uididpmts = acionamentovivo.idpmts');
      Add(' LEFT JOIN lpuvivo ON lpuvivo.id = acionamentovivo.idpacote');
      Add(' INNER JOIN gesempresas ON gesempresas.idempresa = acionamentovivo.idcolaborador');
      Add(' WHERE  acionamentovivo.deletado = 0 AND acionamentovivo.idcolaborador = :idcolaborador ');

      // here
    end;

    qry.ParamByName('idcolaborador').AsInteger := StrToIntDef(AQuery['idempresa'], 0);

    if AQuery.ContainsKey('mespagamento') and (Trim(AQuery['mespagamento']) <> '') then
    begin
      qry.SQL.Add(' AND t.mespagamento LIKE :mespagamento ');
      qry.ParamByName('mespagamento').AsString := '%' + AQuery['mespagamento'] + '%';
    end;

    if AQuery.ContainsKey('datapagamento') and (Trim(AQuery['datapagamento']) <> '') then
    begin
      qry.SQL.Add(' AND t.datapagamento LIKE :datapagamento ');
      qry.ParamByName('datapagamento').AsString := '%' + AQuery['datapagamento'] + '%';
    end;

    if AQuery.ContainsKey('tipopagamento') and (Trim(AQuery['tipopagamento']) <> '') then
    begin
      qry.SQL.Add(' AND t.tipopagamento LIKE :tipopagamento ');
      qry.ParamByName('tipopagamento').AsString := '%' + AQuery['tipopagamento'] + '%';
    end;

    qry.Open;
    Result := qry;

  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar extrato de pagamento: ' + ex.Message;
      qry.Free;
      Result := nil;
    end;
  end;
end;

function TProjetotelefonica.extratopagamentototal(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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

function TProjetotelefonica.consultapagamento: Boolean;
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

function TProjetotelefonica.ListaFechamentoporempresa(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin

end;

function TProjetotelefonica.Listalpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  qt: integer;
  qt1: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;

    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('lpuvivo.id as value, ');
      SQL.Add('lpuvivo.historico as label ');
      SQL.Add('From ');
      SQL.Add('lpuvivo ');
      SQL.Add('where lpuvivo.idempresa =:idcolaborador and uf=:uf ');
      if ((AQuery.Items['idcolaborador'].ToInteger = 140) or (AQuery.Items['idcolaborador'].ToInteger = 144) or (AQuery.Items['idcolaborador'].ToInteger = 87) or (AQuery.Items['idcolaborador'].ToInteger = 322)) then
        ParamByName('idcolaborador').AsInteger := AQuery.Items['idcolaborador'].ToInteger
      else
        ParamByName('idcolaborador').AsInteger := 0;
      ParamByName('uf').Asstring := AQuery.Items['uf'];
      SQL.Add('Group By ');
      SQL.Add('lpuvivo.historico');
      qt := AQuery.Items['idcolaborador'].ToInteger;
      qt1 := AQuery.Items['idcolaborador'];
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

function TProjetotelefonica.Listaatividadepj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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

function TProjetotelefonica.salvarpagamento(out erro: string): Boolean;
begin

end;

function TProjetotelefonica.salvartarefa(out erro: string): Boolean;
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

function TProjetotelefonica.totalacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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

function TProjetotelefonica.Editar(out erro: string): Boolean;
function FormatarDataBR(const Data: string): string;
var
  dt: TDateTime;
begin
  Result := '';
  try
    if Pos('-', Data) > 0 then  // formato ISO
    begin
      dt := EncodeDate(
              StrToInt(Copy(Data, 1, 4)),   // ano
              StrToInt(Copy(Data, 6, 2)),   // mês
              StrToInt(Copy(Data, 9, 2))    // dia
            );
      Result := FormatDateTime('dd/mm/yyyy', dt);
    end
    else if TryStrToDate(Data, dt) then
      Result := FormatDateTime('dd/mm/yyyy', dt);
  except
    Result := '';
  end;
end;

function DataValida(const Data: string): Boolean;
var
  DataConvertida: TDateTime;
begin
  Result := False;

  // Verifica se está vazia ou é data padrão
  if (Data = '') or (Data = '1899-12-30') or (Data = '30/12/1899') then
    Exit;

  // Tenta converter tanto formato ISO quanto formato brasileiro
  try
    if Pos('-', Data) > 0 then  // Formato ISO (2026-08-10)
      DataConvertida := ISO8601ToDate(Data)
    else if Pos('/', Data) > 0 then  // Formato brasileiro (10/08/2025)
      DataConvertida := StrToDate(Data)
    else
      Exit; // Formato desconhecido

    // Verifica se não é data padrão (30/12/1899)
    if DataConvertida <> EncodeDate(1899, 12, 30) then
      Result := True;

  except
    // Se falhar na conversão, data inválida
    Result := False;
  end;
end;

function DatasSaoDiferentes(const Data1, Data2: string): Boolean;
var
  Data1Convertida, Data2Convertida: TDateTime;
begin
  Result := True;

  // Se ambas forem inválidas, são iguais
  if not DataValida(Data1) and not DataValida(Data2) then
    Exit(False);

  // Se uma é válida e outra não, são diferentes
  if DataValida(Data1) <> DataValida(Data2) then
    Exit(True);

  // Se ambas são válidas, converte e compara
  try
    if Pos('-', Data1) > 0 then
      Data1Convertida := ISO8601ToDate(Data1)
    else
      Data1Convertida := StrToDate(Data1);

    if Pos('-', Data2) > 0 then
      Data2Convertida := ISO8601ToDate(Data2)
    else
      Data2Convertida := StrToDate(Data2);

    Result := Data1Convertida <> Data2Convertida;
  except
    Result := True; // Se falhar na conversão, assume que são diferentes
  end;
end;
var
  qry, qryOld: TFDQuery;
  ufsigla, OldStatusDocumentacao, OLDUIDIDPMTS, OldDTReal, PEDIDO, OldVistoriaReal, OldIntegracaoReal, OldDocVitoriaReal: string;
  EmailEnviado: Boolean;
  servicoEmail: TEmail;
begin
  Result := False;
  EmailEnviado := False;

  try
    qry := TFDQuery.Create(nil);
    qryOld := TFDQuery.Create(nil);
    try
      qry.connection := FConn;
      qryOld.connection := FConn;

      // Primeiro, buscar os valores antigos para comparação
      with qryOld do
      begin
        Active := false;
        sql.Clear;
        SQL.Add('SELECT statusdocumentacao, DTReal, vistoriareal, IntegracaoReal, docvitoriareal, pedido, ');
        SQL.Add('ufsigla, UIDIDPMTS ');
        SQL.Add('FROM rolloutvivo WHERE UIDIDCPOMRF = :UIDIDCPOMRF');
        ParamByName('UIDIDCPOMRF').AsString := UIDIDCPOMRF;
        Open;

        if not IsEmpty then
        begin
          OldStatusDocumentacao := FieldByName('statusdocumentacao').AsString;
          OldDTReal := FieldByName('DTReal').AsString;
          OldVistoriaReal := FieldByName('vistoriareal').AsString;
          OldIntegracaoReal := FieldByName('IntegracaoReal').AsString;
          OldDocVitoriaReal := FieldByName('docvitoriareal').AsString;
          OLDUIDIDPMTS := FieldByName('UIDIDPMTS').AsString;
          PEDIDO := FieldByName('pedido').AsString;
          ufsigla := FieldByName('ufsigla').AsString;
        end;
        Close;
      end;

      // Agora fazer o update
      with qry do
      begin
        Active := false;
        sql.Clear;
        SQL.Add('update rolloutvivo set  ');
        SQL.Add('infravivo=:infravivo,  ');
        SQL.Add('infra=:infra,  ');
        SQL.Add('acessoatividade=:acessoatividade,  ');
        SQL.Add('acessocomentario=:acessocomentario,  ');
        SQL.Add('acessooutros=:acessooutros,  ');
        SQL.Add('acessoformaacesso=:acessoformaacesso,  ');
        SQL.Add('ddd=:ddd,  ');
        SQL.Add('Cidade=:Cidade,  ');
        SQL.Add('nomedosite=:nomedosite,  ');
        SQL.Add('endereco=:endereco,  ');
        SQL.Add('LATITUDE=:LATITUDE,  ');
        SQL.Add('LONGITUDE=:LONGITUDE,  ');
        SQL.Add('acessoobs=:acessoobs,  ');
        SQL.Add('acessodatainicial=:acessodatainicial,  ');
        SQL.Add('acessodatafinal=:acessodatafinal,  ');
        SQL.Add('acessodatasolicitacao=:acessodatasolicitacao,  ');
        SQL.Add('acessosolicitacao=:acessosolicitacao,  ');
        SQL.Add('acessostatus=:acessostatus,  ');
        SQL.Add('dataimprodutiva=:dataimprodutiva,  ');
        SQL.Add('EntregaPlan=:EntregaPlan,  ');
        SQL.Add('EntregaReal=:EntregaReal,  ');
        SQL.Add('FimInstalacaoPlan=:FimInstalacaoPlan,  ');
        SQL.Add('FimInstalacaoReal=:FimInstalacaoReal,  ');
        SQL.Add('IntegracaoPlan=:IntegracaoPlan,  ');
        SQL.Add('IntegracaoReal=:IntegracaoReal,  ');
        SQL.Add('Ativacao=:Ativacao,  ');
        SQL.Add('Documentacao=:Documentacao,  ');
        SQL.Add('InventarioDesinstalacao=:InventarioDesinstalacao,  ');
        SQL.Add('DTPlan=:DTPlan,  ');
        SQL.Add('DTReal=:DTReal,  ');
        SQL.Add('AprovacaoSSV=:AprovacaoSSV,  ');
        SQL.Add('StatusAprovacaoSSV=:StatusAprovacaoSSV,  ');
        SQL.Add('StatusObra=:StatusObra,  ');
        SQL.Add('docaplan=:docaplan,  ');
        SQL.Add('OV=:OV, ');
        SQL.Add('vistoriaplan=:vistoriaplan, ');
        SQL.Add('vistoriareal=:vistoriareal, ');
        SQL.Add('docplan=:docplan, ');
        SQL.Add('docvitoriareal=:docvitoriareal, ');
        SQL.Add('req=:req, ');
        SQL.Add('resumodafase=:resumodafase, ');
        SQL.Add('acompanhamentofisicoobservacao=:acompanhamentofisicoobservacao, ');
        SQL.Add('initialtunnigstatus=:initialtunnigstatus, ');
        SQL.Add('initialtunningreal=:initialtunningreal, ');
        SQL.Add('InitialTunningRealFinal=:InitialTunningRealFinal, ');
        SQL.Add('Rollout=:Rollout, equipe=:equipe, ');
        SQL.Add('statusdocumentacao=:statusdocumentacao, observacaodocumentacao=:observacaodocumentacao, ');
        SQL.Add('datapostagemdoc=:datapostagemdoc , dataexecucaodocvdvm=:dataexecucaodocvdvm, ');
        SQL.Add('datapostagemdocvdvm=:datapostagemdocvdvm, dataexecucaodoc=:dataexecucaodoc');
        SQL.Add('where UIDIDCPOMRF=:UIDIDCPOMRF ');
        ParamByName('infra').asstring := infra;
        ParamByName('acessoatividade').asstring := acessoatividade;
        ParamByName('acessocomentario').asstring := acessocomentario;
        ParamByName('acessooutros').asstring := acessooutros;
        ParamByName('acessoformaacesso').asstring := acessoformaacesso;
        ParamByName('ddd').asstring := ddd;
        ParamByName('Cidade').asstring := Cidade;
        ParamByName('nomedosite').asstring := nomedosite;
        ParamByName('endereco').asstring := endereco;
        ParamByName('LATITUDE').asstring := LATITUDE;
        ParamByName('LONGITUDE').asstring := LONGITUDE;
        ParamByName('acessoobs').asstring := acessoobs;
        ParamByName('equipe').asstring := equipe;
        ParamByName('acompanhamentofisicoobservacao').asstring := acompanhamentofisicoobservacao;

        try
          ParamByName('initialtunningreal').AsDateTime := ISO8601ToDate(initialtunningreal);
        except
          ParamByName('initialtunningreal').asstring := '1899-12-30';
        end;

        ParamByName('initialtunnigstatus').asstring := initialtunningstatus;
        try
          ParamByName('InitialTunningRealFinal').AsDateTime := ISO8601ToDate(initialtunningrealfinal);
        except
          ParamByName('InitialTunningRealFinal').asstring := '1899-12-30';
        end;
        ParamByName('StatusAprovacaoSSV').asstring := statusaprovacaossv;

        try
          ParamByName('acessodatainicial').AsDateTime := ISO8601ToDate(acessodatainicial);
        except
          ParamByName('acessodatainicial').asstring := '1899-12-30';
        end;
        try
          ParamByName('acessodatafinal').AsDateTime := ISO8601ToDate(acessodatafinal);
        except
          ParamByName('acessodatafinal').asstring := '1899-12-30';

        end;
        try
          ParamByName('acessodatasolicitacao').AsDateTime := ISO8601ToDate(acessodatasolicitacao);
        except
          ParamByName('acessodatasolicitacao').asstring := '1899-12-30';
        end;

        ParamByName('acessosolicitacao').AsString := acessosolicitacao;

        try
          ParamByName('dataimprodutiva').AsDateTime := ISO8601ToDate(dataimprodutiva);
        except
          ParamByName('dataimprodutiva').AsString := '1899-12-30';
        end;

        try
          ParamByName('EntregaPlan').AsDateTime := ISO8601ToDate(EntregaPlan);
        except
          ParamByName('EntregaPlan').asstring := '1899-12-30';

        end;
        try
          ParamByName('EntregaReal').AsDateTime := ISO8601ToDate(EntregaReal);
        except
          ParamByName('EntregaReal').asstring := '1899-12-30';

        end;
        try
          ParamByName('FimInstalacaoPlan').AsDateTime := ISO8601ToDate(FimInstalacaoPlan);
        except
          ParamByName('FimInstalacaoPlan').asstring := '1899-12-30';

        end;
        try
          ParamByName('FimInstalacaoReal').AsDateTime := ISO8601ToDate(FimInstalacaoReal);
        except
          ParamByName('FimInstalacaoReal').asstring := '1899-12-30';

        end;
        try
          ParamByName('IntegracaoPlan').AsDateTime := ISO8601ToDate(IntegracaoPlan);
        except
          ParamByName('IntegracaoPlan').asstring := '1899-12-30';

        end;
        try
          ParamByName('IntegracaoReal').AsDateTime := ISO8601ToDate(IntegracaoReal);
        except
          ParamByName('IntegracaoReal').asstring := '1899-12-30';

        end;
        try
          ParamByName('Ativacao').AsDateTime := ISO8601ToDate(Ativacao);
        except
          ParamByName('Ativacao').asstring := '1899-12-30';

        end;
        try
          ParamByName('Documentacao').AsDateTime := ISO8601ToDate(Documentacao);
        except
          ParamByName('Documentacao').asstring := '1899-12-30';

        end;
        try
          ParamByName('InventarioDesinstalacao').AsDateTime := ISO8601ToDate(InventarioDesinstalacao);
        except
          ParamByName('InventarioDesinstalacao').asstring := '1899-12-30';
        end;
        try
          ParamByName('DTPlan').AsDateTime := ISO8601ToDate(DTPlan);
        except
          ParamByName('DTPlan').asstring := '1899-12-30';

        end;
        try
          ParamByName('DTReal').AsDateTime := ISO8601ToDate(DTReal);
        except
          ParamByName('DTReal').asstring := '1899-12-30';

          end;
        try
          ParamByName('AprovacaoSSV').AsDateTime := ISO8601ToDate(AprovacaoSSV);
        except
          ParamByName('AprovacaoSSV').asstring := '1899-12-30';

        end;
        ParamByName('StatusObra').asstring := StatusObra;
        try
          ParamByName('docaplan').AsDateTime := ISO8601ToDate(docaplan);
        except
          ParamByName('docaplan').asstring := '1899-12-30';

        end;
        ParamByName('OV').asstring := OV;
        ParamByName('UIDIDCPOMRF').asstring := UIDIDCPOMRF;
        ParamByName('resumodafase').asstring := resumodafase;
        ParamByName('rollout').asstring := rollout;
        try
          ParamByName('vistoriaplan').AsDateTime := ISO8601ToDate(vistoriaplan);
        except
          ParamByName('vistoriaplan').asstring := '1899-12-30';
        end;
        try
          ParamByName('vistoriareal').AsDateTime := ISO8601ToDate(vistoriareal);
        except
          ParamByName('vistoriareal').asstring := '1899-12-30';

        end;
        try
          ParamByName('docplan').AsDateTime := ISO8601ToDate(docplan);
        except
          ParamByName('docplan').asstring := '1899-12-30';

        end;
        try
          ParamByName('docvitoriareal').AsDateTime := ISO8601ToDate(docvitoriareal);
        except
          ParamByName('docvitoriareal').asstring := '1899-12-30';

        end;
        try
          ParamByName('req').AsDateTime := ISO8601ToDate(req);
        except
          ParamByName('req').asstring := '1899-12-30';

        end;

        try
          ParamByName('dataexecucaodoc').AsDateTime := ISO8601ToDate(dataexecucaodoc);
        except
          ParamByName('dataexecucaodoc').AsString := '1899-12-30';
        end;

        try
          ParamByName('datapostagemdoc').AsDateTime := ISO8601ToDate(datapostagemdoc);
        except
          ParamByName('datapostagemdoc').AsString := '1899-12-30';
        end;

        try
          ParamByName('dataexecucaodocvdvm').AsDateTime := ISO8601ToDate(dataexecucaodocvdvm);
        except
          ParamByName('dataexecucaodocvdvm').AsString := '1899-12-30';
        end;

        try
          ParamByName('datapostagemdocvdvm').AsDateTime := ISO8601ToDate(datapostagemdocvdvm);
        except
          ParamByName('datapostagemdocvdvm').AsString := '1899-12-30';
        end;

        try
          ParamByName('statusdocumentacao').AsString := selectedOptionStatusDocumentacao;
        except
          ParamByName('statusdocumentacao').AsString := '';
        end;

        try
          ParamByName('observacaoDocumentacao').AsString :=observacaoDocumentacao;
        except
          ParamByName('observacaoDocumentacao').AsString := '';
        end;

        ParamByName('infravivo').asstring := infravivo;

        try
          ParamByName('acessostatus').AsString := acessostatus;
        except
          ParamByName('acessostatus').AsString := '';
        end;

        ExecSQL;
      end;
      servicoEmail := TEmail.Create();

      // Na função Editar, modifique as verificações:

      if (selectedOptionStatusDocumentacao = 'Aprovado') and
         (OldStatusDocumentacao <> 'Aprovado') then
      begin
        servicoEmail.EnviarEmailInstalacao(ufsigla, PEDIDO, OLDUIDIDPMTS);
        EmailEnviado := True;
      end;

      // DRIVE TEST - Quando DTReal for preenchido e for diferente do anterior
      if DataValida(DTReal) and DatasSaoDiferentes(DTReal, OldDTReal) then
      begin
        servicoEmail.EnviarEmailDriveTest(ufsigla, PEDIDO, OLDUIDIDPMTS, FormatarDataBR(DTReal));
        EmailEnviado := True;
      end;

      // VISTORIA (SURVEY) - Quando vistoriareal for preenchido e for diferente do anterior
      if DataValida(DocVitoriaReal) and DatasSaoDiferentes(DocVitoriaReal, OldDocVitoriaReal) then
      begin
        servicoEmail.EnviarEmailSurvey(ufsigla, PEDIDO, OLDUIDIDPMTS, FormatarDataBR(DocVitoriaReal));
        EmailEnviado := True;
      end;

      // LEGADO - Quando IntegracaoReal for preenchido e for diferente do anterior
      if DataValida(IntegracaoReal)  and DatasSaoDiferentes(IntegracaoReal, OldIntegracaoReal)  then
      begin
        servicoEmail.EnviarEmailLegado(ufsigla, PEDIDO, OLDUIDIDPMTS, FormatarDataBR(IntegracaoReal));
        EmailEnviado := True;
      end;

    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao salvar projeto TELEFONICA: ' + ex.Message;
        Writeln(ex.Message);
        Result := false;
      end;
    end;

  finally
    qry.Free;
    qryOld.Free;
  end;
end;

function TProjetotelefonica.EditarEmMassa(const AJsonBody: string; out erro: string): Boolean;
var
  qry: TFDQuery;
  jsonParams: TJSONObject;
  updates, where, uuidValue, sUpdate: string;
  updateParts: TStringList;
  ids: TArray<string>;
  i: Integer;
  rowsAffected: Integer;
begin
  Result := False;
  erro := '';
  qry := nil;
  jsonParams := nil;
  updateParts := TStringList.Create;
  try
    // valida body
    if AJsonBody.Trim = '' then
    begin
      erro := 'body vazio';
      Exit;
    end;

    // parse JSON
    jsonParams := TJSONObject.ParseJSONValue(AJsonBody) as TJSONObject;
    if jsonParams = nil then
    begin
      erro := 'JSON inválido';
      Exit;
    end;

    // monta lista de campos para UPDATE (usar nomes reais da tabela)
    updateParts.Clear;
    if Assigned(jsonParams.GetValue('statusobra')) then
      updateParts.Add('StatusObra = :statusobra');
    if Assigned(jsonParams.GetValue('vistoriaplan')) then
      updateParts.Add('vistoriaplan = :vistoriaplan');
    if Assigned(jsonParams.GetValue('vistoriareal')) then
      updateParts.Add('vistoriareal = :vistoriareal');
    if Assigned(jsonParams.GetValue('docplan')) then
      updateParts.Add('docplan = :docplan');
    if Assigned(jsonParams.GetValue('docvitoriareal')) then
      updateParts.Add('docvitoriareal = :docvitoriareal');
    if Assigned(jsonParams.GetValue('req')) then
      updateParts.Add('req = :req');
    if Assigned(jsonParams.GetValue('entregaplan')) then
      updateParts.Add('EntregaPlan = :entregaplan');
    if Assigned(jsonParams.GetValue('entregareal')) then
      updateParts.Add('EntregaReal = :entregareal');
    if Assigned(jsonParams.GetValue('fiminstalacaoplan')) then
      updateParts.Add('FimInstalacaoPlan = :fiminstalacaoplan');
    if Assigned(jsonParams.GetValue('fiminstalacaoreal')) then
      updateParts.Add('FimInstalacaoReal = :fiminstalacaoreal');
    if Assigned(jsonParams.GetValue('integracaoplan')) then
      updateParts.Add('IntegracaoPlan = :integracaoplan');
    if Assigned(jsonParams.GetValue('integracaoreal')) then
      updateParts.Add('IntegracaoReal = :integracaoreal');
    if Assigned(jsonParams.GetValue('ativacao')) then
      updateParts.Add('Ativacao = :ativacao');
    if Assigned(jsonParams.GetValue('documentacao')) then
      updateParts.Add('Documentacao = :documentacao');
    if Assigned(jsonParams.GetValue('initialtunningreal')) then
      updateParts.Add('initialtunningreal = :initialtunningreal');
    if Assigned(jsonParams.GetValue('initialtunningrealfinal')) then
      updateParts.Add('InitialTunningRealFinal = :initialtunningrealfinal');
    if Assigned(jsonParams.GetValue('initialtunnigstatus')) then
      updateParts.Add('initialtunnigstatus = :initialtunnigstatus');
    if Assigned(jsonParams.GetValue('aprovacaossv')) then
      updateParts.Add('AprovacaoSSV = :aprovacaossv');
    if Assigned(jsonParams.GetValue('statusaprovacaossv')) then
      updateParts.Add('StatusAprovacaoSSV = :statusaprovacaossv');
    if Assigned(jsonParams.GetValue('dtplan')) then
      updateParts.Add('DTPlan = :dtplan');
    if Assigned(jsonParams.GetValue('dtreal')) then
      updateParts.Add('DTReal = :dtreal');
    if Assigned(jsonParams.GetValue('acompanhamentofisicoobservacao')) then
      updateParts.Add('acompanhamentofisicoobservacao = :acompanhamentofisicoobservacao');
    if Assigned(jsonParams.GetValue('rollout')) then
      updateParts.Add('Rollout = :rollout');
    if Assigned(jsonParams.GetValue('acionamento')) then
      updateParts.Add('Acionamento = :acionamento');
    if Assigned(jsonParams.GetValue('datapostagemdoc')) then
      updateParts.Add('datapostagemdoc = :datapostagemdoc');
    if Assigned(jsonParams.GetValue('dataexecucaodoc')) then
      updateParts.Add('dataexecucaodoc = :dataexecucaodoc');
    if Assigned(jsonParams.GetValue('datapostagemdocvdvm')) then
      updateParts.Add('datapostagemdocvdvm = :datapostagemdocvdvm');
    if Assigned(jsonParams.GetValue('dataexecucaodocvdvm')) then
      updateParts.Add('dataexecucaodocvdvm = :dataexecucaodocvdvm');
    if Assigned(jsonParams.GetValue('statusdocumentacao')) then
      updateParts.Add('statusdocumentacao = :statusdocumentacao');
    if Assigned(jsonParams.GetValue('infra')) then
      updateParts.Add('infra = :infra');

    if Assigned(jsonParams.GetValue('acessoatividade')) then
      updateParts.Add('acessoatividade = :acessoatividade');

    if Assigned(jsonParams.GetValue('acessocomentario')) then
      updateParts.Add('acessocomentario = :acessocomentario');

    if Assigned(jsonParams.GetValue('acessooutros')) then
      updateParts.Add('acessooutros = :acessooutros');

    if Assigned(jsonParams.GetValue('acessoformaacesso')) then
      updateParts.Add('acessoformaacesso = :acessoformaacesso');

    if Assigned(jsonParams.GetValue('ddd')) then
      updateParts.Add('ddd = :ddd');

    if Assigned(jsonParams.GetValue('latitude')) then
      updateParts.Add('latitude = :latitude');

    if Assigned(jsonParams.GetValue('longitude')) then
      updateParts.Add('longitude = :longitude');

    if Assigned(jsonParams.GetValue('acessoobs')) then
      updateParts.Add('acessoobs = :acessoobs');

    if Assigned(jsonParams.GetValue('acessosolicitacao')) then
      updateParts.Add('acessosolicitacao = :acessosolicitacao');

    if Assigned(jsonParams.GetValue('acessodatasolicitacao')) then
      updateParts.Add('acessodatasolicitacao = :acessodatasolicitacao');

    if Assigned(jsonParams.GetValue('acessodatainicial')) then
      updateParts.Add('acessodatainicial = :acessodatainicial');

    if Assigned(jsonParams.GetValue('acessodatafinal')) then
      updateParts.Add('acessodatafinal = :acessodatafinal');

    if Assigned(jsonParams.GetValue('acessostatus')) then
      updateParts.Add('acessostatus = :acessostatus');

    if Assigned(jsonParams.GetValue('dataimprodutiva')) then
      updateParts.Add('dataimprodutiva = :dataimprodutiva');

    if Assigned(jsonParams.GetValue('endereco')) then
      updateParts.Add('endereco = :endereco');

    // nenhum campo para atualizar?
    if updateParts.Count = 0 then
    begin
      erro := 'nenhum campo para atualizar';
      Exit;
    end;

    // uuidps obrigatório
    if jsonParams.GetValue('uuidps') = nil then
    begin
      erro := 'uuidps não informado';
      Exit;
    end;
    uuidValue := jsonParams.GetValue('uuidps').Value.Trim;
    if uuidValue = '' then
    begin
      erro := 'uuidps vazio';
      Exit;
    end;

    // monta WHERE (tratando múltiplos uuid's colocando aspas)
    if uuidValue.Contains(',') then
    begin
      ids := uuidValue.Split([',']);
      where := 'UIDIDPMTS IN (';
      for i := 0 to High(ids) do
      begin
        ids[i] := QuotedStr(Trim(ids[i])); // adiciona aspas e escapa apóstrofos
        if i > 0 then
          where := where + ',';
        where := where + ids[i];
      end;
      where := where + ')';
    end
    else
      where := 'UIDIDPMTS = :uuidps';

    // monta string de updates (separa por ", ")
    sUpdate := '';
    for i := 0 to updateParts.Count - 1 do
    begin
      if i > 0 then
        sUpdate := sUpdate + ', ';
      sUpdate := sUpdate + updateParts[i];
    end;

    // prepara e executa query em transação
    qry := TFDQuery.Create(nil);
    try
      qry.Connection := FConn;
      qry.SQL.Text := 'UPDATE rolloutvivo SET ' + sUpdate + ' WHERE ' + where;

      // parâmetros de update
      if Assigned(jsonParams.GetValue('statusobra')) then
        qry.ParamByName('statusobra').AsString := jsonParams.GetValue('statusobra').Value.Trim;

      if Assigned(jsonParams.GetValue('nomesite')) then
        qry.ParamByName('nomesite').AsString := jsonParams.GetValue('nomesite').Value.Trim;

      if Assigned(jsonParams.GetValue('vistoriaplan')) then
        qry.ParamByName('vistoriaplan').AsDate := ISO8601ToDate(jsonParams.GetValue('vistoriaplan').Value);

      if Assigned(jsonParams.GetValue('vistoriareal')) then
        qry.ParamByName('vistoriareal').AsDate := ISO8601ToDate(jsonParams.GetValue('vistoriareal').Value);

      if Assigned(jsonParams.GetValue('docplan')) then
        qry.ParamByName('docplan').AsDate := ISO8601ToDate(jsonParams.GetValue('docplan').Value);

      if Assigned(jsonParams.GetValue('docvitoriareal')) then
        qry.ParamByName('docvitoriareal').AsDate := ISO8601ToDate(jsonParams.GetValue('docvitoriareal').Value);

      if Assigned(jsonParams.GetValue('req')) then
        qry.ParamByName('req').AsDate := ISO8601ToDate(jsonParams.GetValue('req').Value);

      if Assigned(jsonParams.GetValue('entregaplan')) then
        qry.ParamByName('entregaplan').AsDate := ISO8601ToDate(jsonParams.GetValue('entregaplan').Value);

      if Assigned(jsonParams.GetValue('entregareal')) then
        qry.ParamByName('entregareal').AsDate := ISO8601ToDate(jsonParams.GetValue('entregareal').Value);

      if Assigned(jsonParams.GetValue('fiminstalacaoplan')) then
        qry.ParamByName('fiminstalacaoplan').AsDate := ISO8601ToDate(jsonParams.GetValue('fiminstalacaoplan').Value);

      if Assigned(jsonParams.GetValue('fiminstalacaoreal')) then
        qry.ParamByName('fiminstalacaoreal').AsDate := ISO8601ToDate(jsonParams.GetValue('fiminstalacaoreal').Value);

      if Assigned(jsonParams.GetValue('integracaoplan')) then
        qry.ParamByName('integracaoplan').AsDate := ISO8601ToDate(jsonParams.GetValue('integracaoplan').Value);

      if Assigned(jsonParams.GetValue('integracaoreal')) then
        qry.ParamByName('integracaoreal').AsDate := ISO8601ToDate(jsonParams.GetValue('integracaoreal').Value);

      if Assigned(jsonParams.GetValue('ativacao')) then
        qry.ParamByName('ativacao').AsDate := ISO8601ToDate(jsonParams.GetValue('ativacao').Value);

      if Assigned(jsonParams.GetValue('documentacao')) then
        qry.ParamByName('documentacao').AsDate := ISO8601ToDate(jsonParams.GetValue('documentacao').Value);

      if Assigned(jsonParams.GetValue('initialtunningreal')) then
        try
          qry.ParamByName('initialtunningreal').AsDateTime := ISO8601ToDate(jsonParams.GetValue('initialtunningreal').Value);
        except
          qry.ParamByName('initialtunningreal').Clear;
        end;

      if Assigned(jsonParams.GetValue('initialtunningrealfinal')) then
        try
          qry.ParamByName('initialtunningrealfinal').AsDateTime := ISO8601ToDate(jsonParams.GetValue('initialtunningrealfinal').Value);
        except
          qry.ParamByName('initialtunningrealfinal').Clear;
        end;

      if Assigned(jsonParams.GetValue('initialtunnigstatus')) then
        qry.ParamByName('initialtunnigstatus').AsString := jsonParams.GetValue('initialtunnigstatus').Value.Trim;

      if Assigned(jsonParams.GetValue('aprovacaossv')) then
        try
          qry.ParamByName('aprovacaossv').AsDateTime := ISO8601ToDate(jsonParams.GetValue('aprovacaossv').Value);
        except
          qry.ParamByName('aprovacaossv').Clear;
        end;

      if Assigned(jsonParams.GetValue('statusaprovacaossv')) then
        qry.ParamByName('statusaprovacaossv').AsString := jsonParams.GetValue('statusaprovacaossv').Value.Trim;

      if Assigned(jsonParams.GetValue('dtplan')) then
        qry.ParamByName('dtplan').AsDate := ISO8601ToDate(jsonParams.GetValue('dtplan').Value);

      if Assigned(jsonParams.GetValue('dtreal')) then
        qry.ParamByName('dtreal').AsDate := ISO8601ToDate(jsonParams.GetValue('dtreal').Value);

      if Assigned(jsonParams.GetValue('acompanhamentofisicoobservacao')) then
        qry.ParamByName('acompanhamentofisicoobservacao').AsString := jsonParams.GetValue('acompanhamentofisicoobservacao').Value.Trim;

      if Assigned(jsonParams.GetValue('rollout')) then
        qry.ParamByName('rollout').AsString := jsonParams.GetValue('rollout').Value.Trim;

      if Assigned(jsonParams.GetValue('acionamento')) then
        qry.ParamByName('acionamento').AsString := jsonParams.GetValue('acionamento').Value.Trim;

      if Assigned(jsonParams.GetValue('datapostagemdoc')) then
        try
          qry.ParamByName('datapostagemdoc').AsDateTime := ISO8601ToDate(jsonParams.GetValue('datapostagemdoc').Value);
        except
          qry.ParamByName('datapostagemdoc').Clear;
        end;

      if Assigned(jsonParams.GetValue('dataexecucaodoc')) then
        try
          qry.ParamByName('dataexecucaodoc').AsDateTime := ISO8601ToDate(jsonParams.GetValue('dataexecucaodoc').Value);
        except
          qry.ParamByName('dataexecucaodoc').Clear;
        end;

      if Assigned(jsonParams.GetValue('datapostagemdocvdvm')) then
        try
          qry.ParamByName('datapostagemdocvdvm').AsDateTime := ISO8601ToDate(jsonParams.GetValue('datapostagemdocvdvm').Value);
        except
          qry.ParamByName('datapostagemdocvdvm').Clear;
        end;

      if Assigned(jsonParams.GetValue('dataexecucaodocvdvm')) then
        try
          qry.ParamByName('dataexecucaodocvdvm').AsDateTime := ISO8601ToDate(jsonParams.GetValue('dataexecucaodocvdvm').Value);
        except
          qry.ParamByName('dataexecucaodocvdvm').Clear;
        end;

      if Assigned(jsonParams.GetValue('statusdocumentacao')) then
        qry.ParamByName('statusdocumentacao').AsString := jsonParams.GetValue('statusdocumentacao').Value;

      if Assigned(jsonParams.GetValue('infra')) then
        qry.ParamByName('infra').AsString := jsonParams.GetValue('infra').Value;

      if Assigned(jsonParams.GetValue('acessoatividade')) then
        qry.ParamByName('acessoatividade').AsString := jsonParams.GetValue('acessoatividade').Value;

      if Assigned(jsonParams.GetValue('acessocomentario')) then
        qry.ParamByName('acessocomentario').AsString := jsonParams.GetValue('acessocomentario').Value;

      if Assigned(jsonParams.GetValue('acessooutros')) then
        qry.ParamByName('acessooutros').AsString := jsonParams.GetValue('acessooutros').Value;

      if Assigned(jsonParams.GetValue('acessoformaacesso')) then
        qry.ParamByName('acessoformaacesso').AsString := jsonParams.GetValue('acessoformaacesso').Value;

      if Assigned(jsonParams.GetValue('ddd')) then
        qry.ParamByName('ddd').AsString := jsonParams.GetValue('ddd').Value;

      if Assigned(jsonParams.GetValue('endereco')) then
        qry.ParamByName('endereco').AsString := jsonParams.GetValue('endereco').Value;

      if Assigned(jsonParams.GetValue('nomesite')) then
        qry.ParamByName('nomesite').AsString := jsonParams.GetValue('nomesite').Value;

      if Assigned(jsonParams.GetValue('latitude')) then
        qry.ParamByName('latitude').AsString := jsonParams.GetValue('latitude').Value;

      if Assigned(jsonParams.GetValue('longitude')) then
        qry.ParamByName('longitude').AsString := jsonParams.GetValue('longitude').Value;

      if Assigned(jsonParams.GetValue('acessoobs')) then
        qry.ParamByName('acessoobs').AsString := jsonParams.GetValue('acessoobs').Value;

      if Assigned(jsonParams.GetValue('acessosolicitacao')) then
        qry.ParamByName('acessosolicitacao').AsString := jsonParams.GetValue('acessosolicitacao').Value;

      if Assigned(jsonParams.GetValue('acessostatus')) then
        qry.ParamByName('acessostatus').AsString := jsonParams.GetValue('acessostatus').Value;

      // Campos do tipo data
      if Assigned(jsonParams.GetValue('dataimprodutiva')) then
        try
          qry.ParamByName('dataimprodutiva').AsDateTime := ISO8601ToDate(jsonParams.GetValue('dataimprodutiva').Value);
        except
          qry.ParamByName('dataimprodutiva').Clear;
        end;
      if Assigned(jsonParams.GetValue('acessodatasolicitacao')) then
        try
          qry.ParamByName('acessodatasolicitacao').AsDateTime := ISO8601ToDate(jsonParams.GetValue('acessodatasolicitacao').Value);
        except
          qry.ParamByName('acessodatasolicitacao').Clear;
        end;

      if Assigned(jsonParams.GetValue('acessodatainicial')) then
        try
          qry.ParamByName('acessodatainicial').AsDateTime := ISO8601ToDate(jsonParams.GetValue('acessodatainicial').Value);
        except
          qry.ParamByName('acessodatainicial').Clear;
        end;

      if Assigned(jsonParams.GetValue('acessodatafinal')) then
        try
          qry.ParamByName('acessodatafinal').AsDateTime := ISO8601ToDate(jsonParams.GetValue('acessodatafinal').Value);
        except
          qry.ParamByName('acessodatafinal').Clear;
        end;


      // parâmetro uuid, se for único
      if not uuidValue.Contains(',') then
        qry.ParamByName('uuidps').AsString := uuidValue;

      // transação segura
      if not FConn.InTransaction then
        FConn.StartTransaction;
      try
        qry.ExecSQL;
        rowsAffected := qry.RowsAffected; // número de linhas atualizadas
        FConn.Commit;
      except
        on E: Exception do
        begin
          // rollback e repassa erro
          if FConn.InTransaction then
            FConn.Rollback;
          raise; // será capturado no except abaixo
        end;
      end;

      // resultado conforme linhas afetadas
      if rowsAffected > 0 then
      begin
        Result := True;
        erro := ''; // sem erro
      end
      else
      begin
        // nenhum registro alterado (podemos considerar isso como falso ou verdadeiro conforme sua lógica)
        Result := False;
        erro := 'nenhum registro foi alterado (rowsAffected = 0)';
      end;

    finally
      qry.Free;
    end;

  except
    on e: Exception do
    begin
      // captura qualquer exceção e retorna mensagem
      Result := False;
      erro := 'erro na execução: ' + e.Message;
      // garante que transação não fique aberta
      try
        if Assigned(FConn) and FConn.InTransaction then
          FConn.Rollback;
      except
        // ignore
      end;
    end;
  end;

  // limpeza
  if Assigned(jsonParams) then
    jsonParams.Free;
  updateParts.Free;
end;

function TProjetotelefonica.Editart2(out erro: string): Boolean;
var
  qry, qry1, qry2: TFDQuery;
  cont: Integer;
  descricao, regional: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    qry1 := TFDQuery.Create(nil);
    qry1.connection := FConn;
    qry2 := TFDQuery.Create(nil);
    qry2.connection := FConn;
    try
      FConn.StartTransaction;
      with qry do
      begin
        active := false;
        SQL.Clear;
        SQL.Add('Select  ');
        SQL.Add('telefonicacodigoservicos.EMPRESA, ');
        SQL.Add('telefonicacodigoservicos.CODFORNECEDOR, ');
        SQL.Add('telefonicacodigoservicos.FABRICANTE, ');
        SQL.Add('telefonicacodigoservicos.NUMERODOCONTRATO, ');
        SQL.Add('telefonicacodigoservicos.T2CODMATSERVSW, ');
        SQL.Add('telefonicacodigoservicos.T2DESCRICAOCOD, ');
        SQL.Add('telefonicacodigoservicos.VLRUNITARIOLIQLIQ, ');
        SQL.Add('telefonicacodigoservicos.VLRUNITARIOLIQ, ');
        SQL.Add('telefonicacodigoservicos.UNID, ');
        SQL.Add('telefonicacodigoservicos.VLRUNITARIOCIMPOSTO ');
        SQL.Add('from ');
        SQL.Add('telefonicacodigoservicos ');
        SQL.Add('Where ');
        SQL.Add('telefonicacodigoservicos.ID =:idtarefa ');
        ParamByName('idtarefa').asstring := iddescricaocod;
        Open();
      end;
      with qry1 do
      begin
        active := false;
        SQL.Clear;
        SQL.Add('Select ');
        SQL.Add('pmtsvivo.UID_IDPMTS, ');
        SQL.Add('pmtsvivo.UID_IDCPOMRF, ');
        SQL.Add('pmtsvivo.PMO_sigla, ');
        SQL.Add('pmtsvivo.PMO_TECN_EQUIP, ');
        SQL.Add('pmtsvivo.PMO_GESTAO ');
        SQL.Add('From ');
        SQL.Add('pmtsvivo ');
        SQL.Add('Where ');
        SQL.Add('pmtsvivo.UID_IDPMTS =:idpmts ');
        ParamByName('idpmts').asstring := idpmts;
        Open();
      end;
      with qry2 do
      begin
        active := false;
        SQL.Clear;
        SQL.Add('insert into telefonicacontrolet2(empresa, regional, site,itemt2,codfornecedor,fabricante,numerodocontrato,t2codmatservsw,t2descricaocod,vlrunitarioliqliq, ');
        SQL.Add('vlrunitarioliq,quant,unid,vlrunitariocimposto,vlrcimpsicms,vlrtotalcimpostos,itemt4,t4codeqmatswserv,t4descricaocod, ');
        SQL.Add('pepnivel2,idlocalidade,pepnivel3,descricaoobra,idobra,enlace,gestor,tipo,responsavel,categoria,tecnologia,datainclusao) ');
        SQL.Add('                         values(:empresa,:regional, :site,:itemt2,:codfornecedor,:fabricante,:numerodocontrato,:t2codmatservsw,:t2descricaocod,:vlrunitarioliqliq, ');
        SQL.Add(':vlrunitarioliq,:quant,:unid,:vlrunitariocimposto,:vlrcimpsicms,:vlrtotalcimpostos,:itemt4,:t4codeqmatswserv,:t4descricaocod, ');
        SQL.Add(':pepnivel2,:idlocalidade,:pepnivel3,:descricaoobra,:idobra,:enlace,:gestor,:tipo,:responsavel,:categoria,:tecnologia,:datainclusao) ');
        ParamByName('empresa').AsString := qry.fieldbyname('empresa').asstring;
        ParamByName('site').AsString := qry1.fieldbyname('PMO_sigla').asstring;
        ParamByName('itemt2').AsString := '0';
        ParamByName('codfornecedor').AsString := qry.fieldbyname('CODFORNECEDOR').asstring;
        ParamByName('fabricante').AsString := 'TELEQUIPE';
        ParamByName('numerodocontrato').AsString := qry.fieldbyname('NUMERODOCONTRATO').asstring;
        ParamByName('t2codmatservsw').AsString := qry.fieldbyname('T2CODMATSERVSW').asstring;
        descricao := qry.FieldByName('T2DESCRICAOCOD').AsString;
        regional := SplitString(descricao, '-')[0];
        ParamByName('regional').AsString := regional;
        ParamByName('t2descricaocod').AsString := descricao;
        ParamByName('vlrunitarioliqliq').asfloat := qry.fieldbyname('VLRUNITARIOLIQLIQ').AsFloat;
        ParamByName('vlrunitarioliq').asfloat := qry.fieldbyname('VLRUNITARIOLIQ').AsFloat;
        ParamByName('quant').asfloat := quantidade;
        ParamByName('unid').AsString := qry.fieldbyname('UNID').asstring;
        ParamByName('vlrunitariocimposto').asfloat := qry.fieldbyname('VLRUNITARIOCIMPOSTO').AsFloat;
        ParamByName('vlrcimpsicms').asfloat := qry.fieldbyname('VLRUNITARIOCIMPOSTO').AsFloat * quantidade;
        ParamByName('vlrtotalcimpostos').asfloat := qry.fieldbyname('VLRUNITARIOCIMPOSTO').AsFloat * quantidade;
        ParamByName('itemt4').AsString := '1';
        ParamByName('t4codeqmatswserv').AsString := '';
        ParamByName('t4descricaocod').AsString := '';
        ParamByName('pepnivel2').AsString := '';
        ParamByName('idlocalidade').AsString := '';
        ParamByName('pepnivel3').AsString := '';
        ParamByName('descricaoobra').AsString := '';
        ParamByName('idobra').AsString := qry1.fieldbyname('UID_IDCPOMRF').asstring;
        ParamByName('enlace').AsString := '';
        ParamByName('gestor').AsString := qry1.fieldbyname('PMO_GESTAO').asstring;
        ParamByName('tipo').AsString := '';
        ParamByName('responsavel').AsString := '';
        ParamByName('categoria').AsString := '';
        ParamByName('tecnologia').AsString := qry1.fieldbyname('PMO_TECN_EQUIP').asstring;
        ParamByName('datainclusao').AsDateTime := Now;
        ExecSQL;

        cont := 0;
        active := false;
        SQL.Clear;
        sql.Add('Select ');
        sql.Add('Count(telefonicacontrolet2.IDOBRA) As Count_IDOBRA, ');
        sql.Add('telefonicacontrolet2.ID, ');
        sql.Add('telefonicacontrolet2.ITEMT2 ');
        sql.Add('From ');
        sql.Add('telefonicacontrolet2 ');
        sql.Add('Where ');
        sql.Add('telefonicacontrolet2.IDOBRA =:ido ');
        sql.Add('Group By ');
        sql.Add('telefonicacontrolet2.ID, ');
        sql.Add('telefonicacontrolet2.ITEMT2 ');
        sql.Add('order by ');
        sql.Add('telefonicacontrolet2.ID ');
        ParamByName('ido').asstring := qry1.fieldbyname('UID_IDCPOMRF').asstring;
        Open();

        while not eof do
        begin
          cont := cont + 1;
          with qry do
          begin
            active := false;
            SQL.Clear;
            SQL.add('update telefonicacontrolet2 set itemt2=:t2, tipo=:tipo  where id=:id ');
            ParamByName('id').asinteger := qry2.fieldbyname('id').asinteger;
            ParamByName('t2').asinteger := cont;
            ParamByName('tipo').asstring := 'serviço' + inttostr(cont);
            execsql;
          end;
          Next;
        end;

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
        erro := 'Erro fazer lançamento: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;


function TProjetotelefonica.salvaacionamentopj(out erro: string): Boolean;
var
  qry, qry1, qry2: TFDQuery;
  id, demanda: Integer;
  valorlpu: Real;
  cliente, empresa, site, polocal: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      FConn.StartTransaction;
      with qry do
      begin

        active := false;
        SQL.Clear;
        SQL.Add('Select lpuvivo.VALORPJ From lpuvivo where id=:id');
        ParamByName('id').AsInteger := idpacote;
        Open();
        valorlpu := fieldbyname('VALORPJ').asfloat;

        active := false;
        SQL.Clear;
        SQL.Add('Select consolidadotelefonica.PO From consolidadotelefonica where id=:id');
        ParamByName('id').AsInteger := idatividade;
        Open();
        polocal := fieldbyname('PO').asstring;

        active := false;
        SQL.Clear;
        SQL.Add('Select * From acionamentovivo where idatividade=:idatividade and idcolaborador=:idcolaborador and  idpacote=:idpacote and idpmts=:idpmts and deletado = 0 ');
        ParamByName('idatividade').asinteger := idatividade;
        ParamByName('idcolaborador').asinteger := idcolaborador;
        ParamByName('idpacote').asinteger := idpacote;
        ParamByName('idpmts').asstring := idpmts;
        Open();
        if RecordCount = 0 then
        begin

          active := false;
          SQL.Clear;
          SQL.Add('insert into acionamentovivo(po,idatividade,idcolaborador,idpacote,lpu,valor,dataacionamento,');
          SQL.Add('idfuncionario,deletado,idrollout,idpmts,observacao,quantidade) ');
          SQL.Add('                     VALUES(:po,:idatividade,:idcolaborador,:idpacote,:lpu,:valor,:dataacionamento,');
          SQL.Add(':idfuncionario,:deletado,:idrollout,:idpmts, :observacao,:quantidade) ');
          ParamByName('po').asstring := polocal;
          ParamByName('idatividade').asinteger := idatividade;
          ParamByName('idcolaborador').asinteger := idcolaborador;
          ParamByName('idpacote').asinteger := idpacote;
          ParamByName('lpu').asstring := lpuhistorico;
          if lpuhistorico = 'NEGOCIADO' then
            ParamByName('valor').asfloat := valornegociado
          else
            ParamByName('valor').asfloat := valorlpu;
          ParamByName('dataacionamento').AsDateTime := now;
          ParamByName('idfuncionario').asinteger := idfuncionario;
          ParamByName('deletado').asinteger := 0;
          ParamByName('idrollout').asinteger := idrollout;
          ParamByName('quantidade').asfloat := quantidade;
          ParamByName('idpmts').asString := idpmts;
          ParamByName('observacao').asString := observacaopj;
          ExecSQL;
          FConn.Commit;

        end
        else
        begin
          erro := 'Lançamento Duplicado - Existe outro lançamento com as mesmas caracteristicas ';
          FConn.Rollback;
        end;

      end;

      if Length(erro) = 0 then
        result := true
      else
        Result := false;

    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro fazer lançamento: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TProjetotelefonica.salvadesconto(out erro: string): Boolean;
var
  qry: TFDQuery;
  cont: Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      FConn.StartTransaction;
      with qry do
      begin
        active := false;
        SQL.Clear;
        SQL.Add('select * from telefonicapagamentodesconto  ');
        sql.add('where telefonicapagamentodesconto.idcolaborador =:idcolaborador and telefonicapagamentodesconto.mespagamento=:mespagamento and   ');
        sql.add('telefonicapagamentodesconto.datapagamento=:datapagamento and telefonicapagamentodesconto.tipopagamento =:tipopagamento ');
        ParamByName('mespagamento').asstring := mesfechamento;
        ParamByName('idcolaborador').asinteger := idcolaboradorpj;
        ParamByName('datapagamento').Asstring := diapagamento;
        ParamByName('tipopagamento').AsString := tipopagamento;
        Open();

        if RecordCount = 0 then
        begin

          active := false;
          SQL.Clear;
          SQL.Add('insert into telefonicapagamentodesconto(desconto,mespagamento,idcolaborador,datapagamento,tipopagamento) ');
          SQL.Add('            values(:desconto,:mespagamento,:idcolaborador,:datapagamento,:tipopagamento) ');
          ParamByName('desconto').asfloat := valor;
          ParamByName('mespagamento').asstring := mesfechamento;
          ParamByName('idcolaborador').asinteger := idcolaboradorpj;
          ParamByName('datapagamento').Asstring := diapagamento;
          ParamByName('tipopagamento').AsString := tipopagamento;
          execsql
        end
        else
        begin
          active := false;
          SQL.Clear;
          SQL.Add('update telefonicapagamentodesconto set desconto=:desconto where mespagamento=:mespagamento and idcolaborador=:idcolaborador  and  datapagamento=:datapagamento  and tipopagamento=:tipopagamento ');
          ParamByName('desconto').asfloat := valor;
          ParamByName('mespagamento').asstring := mesfechamento;
          ParamByName('idcolaborador').asinteger := idcolaboradorpj;
          ParamByName('datapagamento').Asstring := diapagamento;
          ParamByName('tipopagamento').AsString := tipopagamento;
          execsql
        end;

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
        erro := 'Erro fazer desconto: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TProjetotelefonica.salvaacionamentoclt(out erro: string): Boolean;

  function StringToDateISO(const DateStr: string): TDateTime;
  var
    FS: TFormatSettings;
  begin
    if DateStr = '' then
      Result := StrToDate('30/12/1899') // Data padrão para valores vazios
    else
    begin
      FS := TFormatSettings.Create;
      FS.DateSeparator := '-';
      FS.ShortDateFormat := 'yyyy-mm-dd';

      if not TryStrToDate(DateStr, Result, FS) then
        raise Exception.Create('Formato de data inválido: ' + DateStr);
    end;
  end;

var
  qry: TFDQuery;
  polocal: string;
  poValue: Int64; // Para armazenar o PO convertido para BIGINT
begin
  Result := False;
  erro := '';
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    FConn.StartTransaction;
    try
      with qry do
      begin

        Active := False;
        SQL.Clear;
        SQL.Add('SELECT consolidadotelefonica.PO FROM consolidadotelefonica WHERE id=:id');
        ParamByName('id').AsInteger := idatividade;
        Open();

        Active := False;
        SQL.Clear;
        SQL.Add('INSERT INTO acionamentovivoclt(po, atividade, idatividade, idcolaborador, idpacote, valor, dataacionamento,');
        SQL.Add('idfuncionario, deletado, idrollout, idpmts, dataincio, datafinal, horanormal, horas50, horas100, totaldehoras) ');
        SQL.Add('VALUES(:po, :atividade, :idatividade, :idcolaborador, :idpacote, :valor, :dataacionamento,');
        SQL.Add(':idfuncionario, :deletado, :idrollout, :idpmts, :dataincio, :datafinal, :horanormal, :horas50, :horas100, :totaldehoras)');
        ParamByName('po').AsString := po;
        ParamByName('idcolaborador').AsInteger := idcolaborador;
        ParamByName('idatividade').AsInteger := idatividade;
        ParamByName('idpacote').AsInteger := 0;
        ParamByName('valor').AsFloat := 0;
        ParamByName('atividade').AsString := atividade;
        ParamByName('dataacionamento').AsDateTime := Now;
        ParamByName('idfuncionario').AsInteger := idfuncionario;
        ParamByName('deletado').AsInteger := 0;
        ParamByName('idrollout').AsInteger := idrollout;
        ParamByName('idpmts').AsString := idpmts;

        if datainicioclt <> '' then
          ParamByName('dataincio').AsDateTime := StringToDateISO(datainicioclt)
        else
          ParamByName('dataincio').AsDateTime := StrToDate('30/12/1899');

        if datafinalclt <> '' then
          ParamByName('datafinal').AsDateTime := StringToDateISO(datafinalclt)
        else
          ParamByName('datafinal').AsDateTime := StrToDate('30/12/1899');

        ParamByName('horanormal').AsFloat := horanormalclt;
        ParamByName('horas50').AsFloat := hora50clt;
        ParamByName('horas100').AsFloat := hora100clt;
        ParamByName('totaldehoras').AsFloat := totalhorasclt;

        ExecSQL;
        if qry.RowsAffected = 0 then
          raise Exception.Create('Nenhuma linha inserida');

      end;

      FConn.Commit;
      Result := True;
    except
      on ex: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao fazer lançamento: ' + ex.Message;
        Writeln(erro);
        Result := False;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TProjetotelefonica.Editaros(out erro: string): Boolean;
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

function TProjetotelefonica.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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

function TProjetotelefonica.Listapo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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

function TProjetotelefonica.ExtrairRegional(const T2DescricaoCod: string): string;
begin
  // Extrai os 2 primeiros caracteres do campo t2descricaocod
  if Length(T2DescricaoCod) >= 2 then
    Result := Copy(T2DescricaoCod, 1, 2).ToUpper()
  else
    Result := 'NE'; // Default caso não encontre
end;

function TProjetotelefonica.GerarNumeroSequencial(const Regional: string; Ano: Integer; out erro: string): Integer;
var
  Qry: TFDQuery;
begin
  erro := '';
  Result := 0;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;

    try
      FConn.StartTransaction;

      // Verifica se já existe registro para esta regional/ano
      Qry.SQL.Text := 'SELECT sequencial FROM controlecartataftelefonica ' +
                      'WHERE regional = :regional AND ano = :ano ' +
                      'ORDER BY sequencial DESC LIMIT 1';
      Qry.ParamByName('regional').AsString := Regional;
      Qry.ParamByName('ano').AsInteger := Ano;
      Qry.Open;

      if Qry.IsEmpty then
        Result := 1 // Primeiro número do ano para esta regional
      else
        Result := Qry.FieldByName('sequencial').AsInteger + 1;

      FConn.Commit;
    except
      on E: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao gerar número sequencial: ' + E.Message;
      end;
    end;
  finally
    Qry.Free;
  end;
end;

function TProjetotelefonica.AtualizarParaEmFaturamento(const ABody: TJSONObject; out erro: string): Boolean;
var
  Qry: TFDQuery;
  usuario, tid: string;
begin
  Result := False;
  erro := '';
  Qry := nil;

  try
    // Validação dos parâmetros obrigatórios no body
    if not ABody.TryGetValue<string>('tId', tid) then
    begin
      erro := 'É necessário informar "tid" no body da requisição';
      Exit;
    end;

    Qry := TFDQuery.Create(nil);
    try
      Qry.Connection := FConn;

      // Inicia transação
      FConn.StartTransaction;
      try
        // Monta a query de atualização
        Qry.SQL.Text :=
          'UPDATE telefonicacontrolet2 SET ' +
          'faturamento = ''1'', ' +
          'statusfaturamento = :statusfaturamento, ' +
          'dataemfaturamento = CURRENT_TIMESTAMP ' +
          'WHERE id = :id';

        // Atribui os parâmetros
        Qry.ParamByName('id').AsString := tid.Trim;
        Qry.ParamByName('statusfaturamento').AsString := 'Em Faturamento';

        Qry.ExecSQL;

        // Verifica se alguma linha foi afetada
        if Qry.RowsAffected = 0 then
        begin
          erro := 'Nenhum registro encontrado com o tid fornecido';
          FConn.Rollback;
          Exit;
        end;

        FConn.Commit;
        Result := True;

      except
        on E: Exception do
        begin
          FConn.Rollback;
          erro := 'Erro ao atualizar status para Em Faturamento: ' + E.Message;
        end;
      end;

    finally
      Qry.Free;
    end;

  except
    on E: Exception do
    begin
      erro := 'Erro geral: ' + E.Message;
    end;
  end;
end;

function TProjetotelefonica.SalvarNotaFiscalT4(const ABody: TJSONObject; out erro: string): Boolean;
var
  Qry: TFDQuery;
  nf: string;
  tId: Integer;
begin
  Result := False;
  erro := '';
  Qry := TFDQuery.Create(nil);

  try
    Qry.Connection := FConn;

    // Validação dos parâmetros obrigatórios
    if not ABody.TryGetValue<string>('notafiscal', nf) then
    begin
      erro := 'Campo "nf" (nota fiscal) não encontrado no body';
      Exit;
    end;

    if not ABody.TryGetValue<Integer>('tId', tId) then
    begin
      erro := 'Campo "tId" não encontrado no body';
      Exit;
    end;

    // Validação dos valores
    if nf.Trim.IsEmpty then
    begin
      erro := 'Número da nota fiscal não pode ser vazio';
      Exit;
    end;

    if tId <= 0 then
    begin
      erro := 'tId inválido';
      Exit;
    end;

    // Inicia transação
    FConn.StartTransaction;
    try
      // Atualiza a tabela telefonicacontrolet2
      Qry.SQL.Text :=
        'UPDATE telefonicacontrolet2 SET ' +
        'notafiscal = :notafiscal, ' +
        'statusfaturamento = :statusfaturamento, ' +
        'faturado = :faturado, ' +
        'datafaturamento = NOW() ' +
        'WHERE id = :tId';

      Qry.ParamByName('notafiscal').AsString := nf.Trim;
      Qry.ParamByName('statusfaturamento').AsString := 'Faturado';
      Qry.ParamByName('faturado').AsString := '1';
      Qry.ParamByName('tId').AsInteger := tId;

      Qry.ExecSQL;

      // Verifica se alguma linha foi afetada
      if Qry.RowsAffected = 0 then
      begin
        erro := 'Nenhum registro encontrado com o tId informado: ' + tId.ToString;
        FConn.Rollback;
        Exit;
      end;

      FConn.Commit;
      Result := True;

    except
      on E: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao salvar nota fiscal: ' + E.Message;
      end;
    end;

  finally
    Qry.Free;
  end;
end;


function TProjetotelefonica.listat2(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  idobraValor, uf: string;
begin
  Result := nil;
  erro := '';

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    qry.SQL.Clear;
    qry.SQL.Add('SELECT *');
    qry.SQL.Add('FROM telefonicacontrolet2');

    if AQuery.ContainsKey('idobraloca') and (Trim(AQuery.Items['idobraloca']) <> '') then
    begin
      idobraValor := AQuery.Items['idobraloca'];

      qry.SQL.Add('WHERE (');

      qry.SQL.Add('  IDOBRA = :idobra');

      qry.SQL.Add(' )');
      qry.ParamByName('idobra').AsString := idobraValor;

    end;

    qry.Active := True;
    Result := qry;

  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar: ' + ex.Message;
      qry.Free;
    end;
  end;
end;

function TProjetotelefonica.RegistrarCartaTAF(const DadosT2: TDictionary<string, string>; out Erro: string; out NomeArquivo: String): Boolean;
var
  Qry, QryUpdate: TFDQuery;
  NumeroTAF: string;
  Regional: string;
  Ano: Integer;
  ProximoSequencial: Integer;
  T2DescricaoCod, IDObra, cartataf, statusfaturamento: string;
  pepnivel3,descricao: string;
  servicoEmail: TEmail;
begin
  Result := False;
  Erro := '';
  Qry := TFDQuery.Create(nil);
  QryUpdate := TFDQuery.Create(nil);
  servicoEmail := TEmail.Create();
  try
    Qry.Connection := FConn;
    QryUpdate.Connection := FConn;

    // Verifica se o campo "regional" está presente e obtém seu valor
    if not DadosT2.TryGetValue('regional', T2DescricaoCod) then
    begin
      Erro := 'Campo "regional" não encontrado nos parâmetros.';
      Exit;
    end;

    // Verifica se o campo "idobra" está presente
    if not DadosT2.TryGetValue('idobra', IDObra) then
    begin
      Erro := 'Campo "idobra" não encontrado nos parâmetros.';
      Exit;
    end;
    if not DadosT2.TryGetValue('cartataf', cartataf) then
    begin
      Erro := 'Campo "Cartataf" não encontrado nos parâmetros.';
    end;

    if not DadosT2.TryGetValue('t2descricaocod', descricao) then
    begin
      Erro := 'Campo "descricao" não encontrado nos parâmetros.';
    end;
    if not DadosT2.TryGetValue('pepnivel3', pepnivel3) then
    begin
      Erro := 'Campo "pepnivel3" não encontrado nos parâmetros.';
      Exit;
    end;
    if not DadosT2.TryGetValue('statusfaturamento', statusfaturamento) then
    begin
      Erro := 'Campo "statusfaturamento" não encontrado nos parâmetros.';
      Exit;
    end;
    try
      if statusfaturamento = 'Retorno T4' then
      begin
        regional := SplitString(descricao, '-')[0];
        Regional := regional;
        Ano := YearOf(Now);
        // Consulta o próximo número sequencial
        Qry.SQL.Text :=
          'SELECT COALESCE(MAX(sequencial), 0) + 1 ' +
          'FROM controlecartataftelefonica ' +
          'WHERE regional = :regional AND ano = :ano';
        Qry.ParamByName('regional').AsString := Regional;
        Qry.ParamByName('ano').AsInteger := Ano;
        Qry.Open;
        ProximoSequencial := Qry.Fields[0].AsInteger;
        Qry.Close;

        // Monta o número TAF e nome do arquivo
        NumeroTAF := Format('%d_%.4d', [Ano, ProximoSequencial]);
        NomeArquivo := Format('TAF_RAN_%s_%s', [Regional, NumeroTAF]);
        // Inicia transação
        FConn.StartTransaction;

          // Insere o registro na tabela de controle

          Qry.SQL.Text :=
            'INSERT INTO controlecartataftelefonica ' +
            '(numerotaf, regional, ano, sequencial, datacriacao) ' +
            'VALUES (:numerotaf, :regional, :ano, :sequencial, NOW())';

          Qry.ParamByName('numerotaf').AsString := NumeroTAF;
          Qry.ParamByName('regional').AsString := Regional;
          Qry.ParamByName('ano').AsInteger := Ano;
          Qry.ParamByName('sequencial').AsInteger := ProximoSequencial;
          Qry.ExecSQL;

          // Atualiza a tabela telefonicacontrolet2
          QryUpdate.SQL.Text :=
            'UPDATE telefonicacontrolet2 SET ' +
            ' regional = :regional,  cartataf = :cartataf, statusfaturamento = :statusfaturamento ' +
            'WHERE pepnivel3 = :pepnivel3';
          QryUpdate.ParamByName('statusfaturamento').AsString := 'Gerada Carta TAF';
          QryUpdate.ParamByName('cartataf').AsString := NomeArquivo;
          QryUpdate.ParamByName('regional').AsString := Regional;
          QryUpdate.ParamByName('pepnivel3').AsString := pepnivel3;
          QryUpdate.ExecSQL;
          FConn.Commit;
          servicoEmail.EnviarEmailConfirmacaoCartaTAF(IdObra);
          Result := True;
        end
        else begin
          NomeArquivo := cartataf;
          Result := True;
        end
      except
        on E: Exception do
        begin
          FConn.Rollback;
          Erro := 'Erro ao registrar carta TAF: ' + E.Message;
        end;
      end;

  finally
    Qry.Free;
    QryUpdate.Free;
  end;
end;


function TProjetotelefonica.listat4(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  status, idobraValor: string;
begin
  Result := nil;
  erro := '';
  status := AQuery.Items['labelStatus'];
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;

    qry.SQL.Clear;
    qry.SQL.Text := 'SET @row_number = 0';
    qry.ExecSQL;
    qry.SQL.Clear;

    qry.SQL.Add('SELECT * FROM (');
    qry.SQL.Add('  SELECT');
    qry.SQL.Add('    @row_number := @row_number + 1 AS id,');
    qry.SQL.Add('    t.ID AS t_ID,');
    qry.SQL.Add('    t.EMPRESA, t.SITE, t.ITEMT2, t.CODFORNECEDOR, t.FABRICANTE, t.NUMERODOCONTRATO,');
    qry.SQL.Add('    t.T2CODMATSERVSW, t.T2DESCRICAOCOD, t.VLRUNITARIOLIQLIQ, t.VLRUNITARIOLIQ, t.QUANT,');
    qry.SQL.Add('    t.UNID, t.VLRUNITARIOCIMPOSTO, t.VLRCIMPSICMS, t.VLRTOTALCIMPOSTOS, t.ITEMT4,');
    qry.SQL.Add('    t.T4CODEQMATSWSERV, t.T4DESCRICAOCOD, t.PEPNIVEL2, t.IDLOCALIDADE, t.PEPNIVEL3,');
    qry.SQL.Add('    t.DESCRICAOOBRA, t.IDOBRA, t.ENLACE, t.GESTOR, t.TIPO, t.RESPONSAVEL, t.Categoria,');
    qry.SQL.Add('    t.TECNOLOGIA, t.REGIONAL, t.T2APROVADO, t.PO, t.atividade, t.cartataf, t.faturamento,');
    qry.SQL.Add('    t.faturado, t.notafiscal, t.statusfaturamento,');
    qry.SQL.Add('    (SELECT MAX(a.dataacionamento) FROM acionamentovivo a WHERE a.po = t.po) AS dataacionamento,');
    qry.SQL.Add('    (SELECT MAX(a.fechamento) FROM acionamentovivo a WHERE a.po = t.po) AS fechamento,');
    qry.SQL.Add('    (SELECT MAX(c.dataincio) FROM acionamentovivoclt c WHERE c.po = t.po) AS dataincio,');
    qry.SQL.Add('    (SELECT MAX(c.datafinal) FROM acionamentovivoclt c WHERE c.po = t.po) AS datafinal,');
    qry.SQL.Add('    CASE');
    qry.SQL.Add('      WHEN t.itemt4 IS NOT NULL THEN ''T4 criada''');
    qry.SQL.Add('      WHEN (EXISTS (SELECT 1 FROM acionamentovivo a WHERE a.po = t.po AND a.dataacionamento IS NOT NULL)');
    qry.SQL.Add('           OR EXISTS (SELECT 1 FROM acionamentovivoclt c WHERE c.po = t.po AND c.dataincio IS NOT NULL))');
    qry.SQL.Add('           AND t.itemt4 IS NULL THEN ''Serviço acionado, mas ainda sem T4''');
    qry.SQL.Add('      WHEN t.itemt2 IS NOT NULL AND NOT (EXISTS (SELECT 1 FROM acionamentovivo a WHERE a.po = t.po AND a.dataacionamento IS NOT NULL)');
    qry.SQL.Add('           OR EXISTS (SELECT 1 FROM acionamentovivoclt c WHERE c.po = t.po AND c.dataincio IS NOT NULL)) THEN ''T2 criada, mas ainda não acionada''');
    qry.SQL.Add('      WHEN (EXISTS (SELECT 1 FROM acionamentovivo a WHERE a.po = t.po AND a.fechamento IS NOT NULL)');
    qry.SQL.Add('           OR EXISTS (SELECT 1 FROM acionamentovivoclt c WHERE c.po = t.po AND c.datafinal IS NOT NULL))');
    qry.SQL.Add('           AND t.itemt4 IS NULL THEN ''Serviço executado sem T4''');
    qry.SQL.Add('      ELSE ''''');
    qry.SQL.Add('    END AS statussite');
    qry.SQL.Add('  FROM telefonicacontrolet2 t');
    qry.SQL.Add(') AS sub');
    qry.SQL.Add('WHERE 1=1');

    if status <> '' then
    begin
      qry.SQL.Add(' AND sub.statusfaturamento = :status');
      qry.ParamByName('status').AsString := status;
    end;

    if AQuery.ContainsKey('labelStatusSite') and (Trim(AQuery.Items['labelStatusSite']) <> '') then
    begin
      qry.SQL.Add(' AND sub.statussite = :statussite');
      qry.ParamByName('statussite').AsString := Trim(AQuery.Items['labelStatusSite']);
    end;

    if AQuery.ContainsKey('search') and (Trim(AQuery.Items['search']) <> '') then
    begin
      idobraValor := '%' + Trim(AQuery.Items['search']) + '%';
      qry.SQL.Add(' AND (sub.ATIVIDADE LIKE :idobra OR sub.CARTATAF LIKE :idobra OR sub.CATEGORIA LIKE :idobra OR');
      qry.SQL.Add('      sub.CODFORNECEDOR LIKE :idobra OR sub.DESCRICAOOBRA LIKE :idobra OR sub.EMPRESA LIKE :idobra OR');
      qry.SQL.Add('      sub.ENLACE LIKE :idobra OR sub.FABRICANTE LIKE :idobra OR sub.GESTOR LIKE :idobra OR');
      qry.SQL.Add('      sub.t_ID LIKE :idobra OR sub.IDLOCALIDADE LIKE :idobra OR sub.IDOBRA LIKE :idobra OR');
      qry.SQL.Add('      sub.ITEMT2 LIKE :idobra OR sub.ITEMT4 LIKE :idobra OR sub.NUMERODOCONTRATO LIKE :idobra OR');
      qry.SQL.Add('      sub.PEPNIVEL2 LIKE :idobra OR sub.PEPNIVEL3 LIKE :idobra OR sub.PO LIKE :idobra OR');
      qry.SQL.Add('      sub.QUANT LIKE :idobra OR sub.REGIONAL LIKE :idobra OR sub.RESPONSAVEL LIKE :idobra OR');
      qry.SQL.Add('      sub.SITE LIKE :idobra OR sub.T2APROVADO LIKE :idobra OR sub.T2CODMATSERVSW LIKE :idobra OR');
      qry.SQL.Add('      sub.T2DESCRICAOCOD LIKE :idobra OR sub.T4CODEQMATSWSERV LIKE :idobra OR sub.T4DESCRICAOCOD LIKE :idobra OR');
      qry.SQL.Add('      sub.TECNOLOGIA LIKE :idobra OR sub.TIPO LIKE :idobra OR sub.UNID LIKE :idobra OR');
      qry.SQL.Add('      sub.VLRCIMPSICMS LIKE :idobra OR sub.VLRTOTALCIMPOSTOS LIKE :idobra OR sub.VLRUNITARIOCIMPOSTO LIKE :idobra OR');
      qry.SQL.Add('      sub.VLRUNITARIOLIQ LIKE :idobra OR sub.VLRUNITARIOLIQLIQ LIKE :idobra)');
      qry.ParamByName('idobra').AsString := idobraValor;
    end;

    qry.Open;
    Result := qry;

  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar: ' + ex.Message;
      FreeAndNil(qry);
    end;
  end;
end;

function TProjetotelefonica.Listatarefas(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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

procedure TProjetotelefonica.AddMultipleFiltersFromJSON(AQuery: TDictionary<string, string>; const KeysAndFields: array of string; SQL: TStrings);
var
  Key, FieldName: string;
  JSONStr, Item: string;
  JSONArray: TJSONArray;
  Filter: string;
  I, J: Integer;
begin
  for I := Low(KeysAndFields) to High(KeysAndFields) do
  begin
    // Chave e campo SQL alternados: ['regional', 'rolloutvivo.regional', 'idpmts', 'tabela.idpmts'...]
    if (I mod 2 = 0) and (I + 1 <= High(KeysAndFields)) then
    begin
      Key := KeysAndFields[I];
      FieldName := KeysAndFields[I + 1];

      if not AQuery.ContainsKey(Key) then
        Continue;

      JSONStr := AQuery.Items[Key].Trim;

      if (JSONStr = '') or (JSONStr = '[]') or (JSONStr = '"Todos"') then
        Continue;

      // Verifica se é array JSON
      if JSONStr.StartsWith('[') then
      begin
        JSONArray := TJSONObject.ParseJSONValue(JSONStr) as TJSONArray;
        try
          if JSONArray.Count > 0 then
          begin
            Filter := '';
            for J := 0 to JSONArray.Count - 1 do
            begin
              Item := QuotedStr(JSONArray.Items[J].Value);
              if J > 0 then
                Filter := Filter + ', ' + Item
              else
                Filter := Item;
            end;
            SQL.Add(Format('AND %s IN (%s)', [FieldName, Filter]));
          end;
        finally
          JSONArray.Free;
        end;
      end
      else
      begin
        if (JSONStr <> '') and (JSONStr <> 'Todos') then
          SQL.Add(Format('AND %s = %s', [FieldName, QuotedStr(JSONStr)]));
      end;
    end;
  end;
end;

function QuotedCSV(const Valor: string): string;
var
  Lista, ListaQuoted: TStringList;
  i: Integer;
begin
  Lista := TStringList.Create;
  ListaQuoted := TStringList.Create;
  try
    Lista.CommaText := Valor;
    for i := 0 to Lista.Count - 1 do
      ListaQuoted.Add(QuotedStr(Trim(Lista[i]))); // coloca aspas simples
    Result := ListaQuoted.CommaText;
  finally
    Lista.Free;
    ListaQuoted.Free;
  end;
end;

function TProjetotelefonica.marcadorestelefonica(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  b, a, regional, idpmts: string;
  valor: string;
  pesquisa: TStringList;
begin
  regional := AQuery.Items['regional'];
  idpmts := AQuery.Items['idpmts'];
  a := idpmts;

  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('SELECT ');
      // Contagens básicas (planejado x realizado)
      SQL.Add('COUNT(CASE WHEN vistoriaplan       IS NOT NULL AND vistoriaplan       <> ''1899-12-30'' THEN 1 END) AS vistoriaplan, ');
      SQL.Add('COUNT(CASE WHEN vistoriareal       IS NOT NULL AND vistoriareal       <> ''1899-12-30'' THEN 1 END) AS vistoriareal, ');
      SQL.Add('COUNT(CASE WHEN EntregaPlan        IS NOT NULL AND EntregaPlan        <> ''1899-12-30'' THEN 1 END) AS EntregaPlan, ');
      SQL.Add('COUNT(CASE WHEN EntregaReal        IS NOT NULL AND EntregaReal        <> ''1899-12-30'' THEN 1 END) AS EntregaReal, ');
      SQL.Add('COUNT(CASE WHEN FimInstalacaoPlan  IS NOT NULL AND FimInstalacaoPlan  <> ''1899-12-30'' THEN 1 END) AS FimInstalacaoPlan, ');
      SQL.Add('COUNT(CASE WHEN FimInstalacaoReal  IS NOT NULL AND FimInstalacaoReal  <> ''1899-12-30'' THEN 1 END) AS FimInstalacaoReal, ');
      SQL.Add('COUNT(CASE WHEN IntegracaoPlan     IS NOT NULL AND IntegracaoPlan     <> ''1899-12-30'' THEN 1 END) AS IntegracaoPlan, ');
      SQL.Add('COUNT(CASE WHEN IntegracaoReal     IS NOT NULL AND IntegracaoReal     <> ''1899-12-30'' THEN 1 END) AS IntegracaoReal, ');
      // Correção para Initial Tunning Concluído
      SQL.Add('COUNT(CASE WHEN initialtunningplan IS NOT NULL AND initialtunningplan <> ''1899-12-30'' THEN 1 END) AS Initialtunningplan,');
      SQL.Add('COUNT(CASE WHEN COALESCE(initialtunningreal, ''1899-12-30'') <> ''1899-12-30'' AND ');
      SQL.Add('           initialtunningreal <= CURDATE() THEN 1 END) AS Initialtunningreal, ');

      SQL.Add('COUNT(CASE WHEN DTPlan             IS NOT NULL AND DTPlan             <> ''1899-12-30'' THEN 1 END) AS DTPlan, ');
      SQL.Add('COUNT(CASE WHEN DTReal             IS NOT NULL AND DTReal             <> ''1899-12-30'' THEN 1 END) AS DTReal, ');
      // Itens em andamento (no prazo)
      SQL.Add('COUNT(CASE WHEN vistoriaplan <> ''1899-12-30'' AND (vistoriareal = ''1899-12-30'' OR vistoriareal IS NULL) AND vistoriaplan >= CURDATE() THEN 1 END) AS vistoriaandamento, ');
      SQL.Add('COUNT(CASE WHEN EntregaPlan <> ''1899-12-30'' AND (EntregaReal = ''1899-12-30'' OR EntregaReal IS NULL) AND EntregaPlan >= CURDATE() THEN 1 END) AS entregaandamento, ');
      SQL.Add('COUNT(CASE WHEN FimInstalacaoPlan <> ''1899-12-30'' AND (FimInstalacaoReal = ''1899-12-30'' OR FimInstalacaoReal IS NULL) AND FimInstalacaoPlan >= CURDATE() THEN 1 END) AS instalacaoandamento, ');
      SQL.Add('COUNT(CASE WHEN IntegracaoPlan <> ''1899-12-30'' AND (IntegracaoReal = ''1899-12-30'' OR IntegracaoReal IS NULL) AND IntegracaoPlan >= CURDATE() THEN 1 END) AS integracaoandamento, ');
      SQL.Add('COUNT(CASE WHEN initialtunningplan <> ''1899-12-30'' AND (initialtunningreal = ''1899-12-30'' OR initialtunningreal IS NULL) AND initialtunningplan >= CURDATE() THEN 1 END) AS initialtunningandamento, ');
      SQL.Add('COUNT(CASE WHEN DTPlan <> ''1899-12-30'' AND (DTReal = ''1899-12-30'' OR DTReal IS NULL) AND DTPlan >= CURDATE() THEN 1 END) AS dtandamento, ');
      // Adicionado contagem total para verificação
      SQL.Add('COUNT(*) AS total_registros ');

      SQL.Add('FROM rolloutvivo WHERE deletado = 0 ');

      if ((regional <> 'Todos') and (regional <> '')) then
        SQL.Add(' AND pmoregional IN (' + QuotedCSV(regional) + ')');
      if ((idpmts <> 'Todos') and (idpmts <> '')) then
        SQL.Add(' AND UIDIDPMTS IN (' + QuotedCSV(idpmts) + ')');

      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar: ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TProjetotelefonica.marcadorestelefonicaatrasado(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a, b: string;
  regional, idpmts: string;
begin
  regional := AQuery.Items['regional'];
  idpmts := AQuery.Items['idpmts'];
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('SELECT  ');
      SQL.Add('  COUNT(CASE ');
      SQL.Add('    WHEN VistoriaPlan <> ''1899-12-30'' ');
      SQL.Add('      AND VistoriaPlan < CURDATE() ');
      SQL.Add('      AND (VistoriaReal = ''1899-12-30'' OR VistoriaReal IS NULL) ');
      SQL.Add('    THEN 1 ');
      SQL.Add('  END) AS vistoriaatrasado, ');
      SQL.Add('COUNT(CASE ');
      SQL.Add('    WHEN EntregaPlan <> ''1899-12-30'' ');
      SQL.Add('      AND EntregaPlan < CURDATE() ');
      SQL.Add('      AND (EntregaReal = ''1899-12-30'' OR EntregaReal IS NULL) ');
      SQL.Add('    THEN 1 ');
      SQL.Add('  END) AS entregaatrasado, ');
      SQL.Add('  COUNT(CASE ');
      SQL.Add('    WHEN FimInstalacaoPlan <> ''1899-12-30'' ');
      SQL.Add('      AND FimInstalacaoPlan < CURDATE() ');
      SQL.Add('      AND (FimInstalacaoReal = ''1899-12-30'' OR FimInstalacaoReal IS NULL) ');
      SQL.Add('    THEN 1 ');
      SQL.Add('  END) AS instalacaoatrasado, ');
      SQL.Add('  COUNT(CASE ');
      SQL.Add('    WHEN IntegracaoPlan <> ''1899-12-30'' ');
      SQL.Add('      AND IntegracaoPlan < CURDATE() ');
      SQL.Add('      AND (IntegracaoReal = ''1899-12-30'' OR IntegracaoReal IS NULL) ');
      SQL.Add('    THEN 1 ');
      SQL.Add('  END) AS integracaoatrasado, ');

      SQL.Add('  COUNT(CASE ');
      SQL.Add('    WHEN initialtunningplan <> ''1899-12-30'' ');
      SQL.Add('      AND initialtunningplan < CURDATE() ');
      SQL.Add('      AND (initialtunningreal = ''1899-12-30'' OR initialtunningreal IS NULL) ');
      SQL.Add('    THEN 1 ');
      SQL.Add('  END) AS initialtunningatrasado, ');

      SQL.Add('  COUNT(CASE ');
      SQL.Add('    WHEN DTPlan <> ''1899-12-30'' ');
      SQL.Add('      AND DTPlan < CURDATE() ');
      SQL.Add('      AND (DTReal = ''1899-12-30'' OR DTReal IS NULL) ');
      SQL.Add('    THEN 1 ');
      SQL.Add('  END) AS dtatrasado ');
      SQL.Add('FROM  rolloutvivo where deletado = 0 ');
      if ((regional <> 'Todos') and (regional <> '')) then
        SQL.Add(' and rolloutvivo.pmoregional in (' + QuotedCSV(regional) + ')');
      if ((idpmts <> 'Todos') and (idpmts <> '')) then
        SQL.Add(' and rolloutvivo.UIDIDPMTS in (' + QuotedCSV(idpmts) + ')');
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

function TProjetotelefonica.dashboardtelefonicaposicionamentofinanceiro(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  regional, idpmts: string;
begin
  Result := nil;
  erro := '';

  // Obter parâmetros com verificação de existência
  regional := '';
  idpmts := '';
  if AQuery.ContainsKey('regional') then
    regional := AQuery.Items['regional'];
  if AQuery.ContainsKey('idpmts') then
    idpmts := AQuery.Items['idpmts'];

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;

    with qry do
    begin
      SQL.BeginUpdate;
      try
        SQL.Clear;
        SQL.Add('SELECT');
        SQL.Add('  (SELECT COUNT(UIDIDPMTS) FROM rolloutvivo WHERE deletado = 0');
        if (idpmts <> '') and (idpmts <> 'Todos') then
        begin
          SQL.Add('AND rolloutvivo.UIDIDPMTS IN (' + QuotedCSV(idpmts) + ')');
        end;
        if (regional <> '') and (regional <> 'Todos') then
        begin
          var partes := regional.Split([',']);
          SQL.Add('AND (');
          for var i := 0 to High(partes) do
          begin
            if i > 0 then
              SQL.Add('OR ');
            SQL.Add('PMOREGIONAL LIKE ''%' + Trim(partes[i]) + '%''');
          end;
          SQL.Add(')');
        end;
        SQL.Add('  ) AS totalPMTS,');
        SQL.Add('');
        SQL.Add('  CASE');
        SQL.Add('    WHEN LOWER(T2DESCRICAOCOD) LIKE ''%installation%'' THEN ''Instalação''');
        SQL.Add('    WHEN LOWER(T2DESCRICAOCOD) LIKE ''%survey%'' THEN ''Vistoria''');
        SQL.Add('    WHEN LOWER(T2DESCRICAOCOD) LIKE ''%drive test%'' THEN ''DT''');
        SQL.Add('    WHEN LOWER(T2DESCRICAOCOD) LIKE ''%infra%'' THEN ''Infra''');
        SQL.Add('    ELSE ''Outros''');
        SQL.Add('  END AS TipoAtividade,');
        SQL.Add('  COUNT(DISTINCT CASE WHEN PO IS NOT NULL AND TRIM(PO) <> '''' THEN ID END) AS PO_Preenchido,');
        SQL.Add('  COUNT(DISTINCT CASE WHEN T4CODEQMATSWSERV IS NOT NULL AND TRIM(T4CODEQMATSWSERV) <> '''' THEN ID END) AS TIV_Emitidas,');
        SQL.Add('  COUNT(ID) AS TII_Emitidas,');
        SQL.Add('  COUNT(DISTINCT CASE WHEN cartataf IS NOT NULL AND TRIM(cartataf) <> '''' THEN ID END) AS Carta_TAF_Emitida,');
        SQL.Add('  COUNT(DISTINCT ID) AS TotalItens');
        SQL.Add('FROM telefonicacontrolet2');
        SQL.Add('WHERE 1 = 1');

        if (regional <> '') and (regional <> 'Todos') then
        begin
          var partes := regional.Split([',']);
          SQL.Add('AND (');
          for var i := 0 to High(partes) do
          begin
            if i > 0 then
              SQL.Add('OR ');
            SQL.Add('T2CODMATSERVSW LIKE ''%' + Trim(partes[i]) + '%''');
          end;
          SQL.Add(')');
        end;

        SQL.Add('GROUP BY');
        SQL.Add('  CASE');
        SQL.Add('    WHEN LOWER(T2DESCRICAOCOD) LIKE ''%installation%'' THEN ''Instalação''');
        SQL.Add('    WHEN LOWER(T2DESCRICAOCOD) LIKE ''%survey%'' THEN ''Vistoria''');
        SQL.Add('    WHEN LOWER(T2DESCRICAOCOD) LIKE ''%drive test%'' THEN ''DT''');
        SQL.Add('    WHEN LOWER(T2DESCRICAOCOD) LIKE ''%infra%'' THEN ''Infra''');
        SQL.Add('    ELSE ''Outros''');
        SQL.Add('  END');
        SQL.Add('ORDER BY TipoAtividade');
      finally
        SQL.EndUpdate;
      end;

      try
        Open; // Usar Open em vez de Active := True

        // Verifica se retornou dados
        if not (BOF and EOF) then
        begin
          First; // Garante que estamos no início do dataset
          Result := qry;
        end
        else
        begin
          erro := 'Nenhum dado encontrado';
          FreeAndNil(qry);
        end;
      except
        on E: Exception do
        begin
          erro := 'Erro ao executar consulta: ' + E.Message;
          FreeAndNil(qry);
        end;
      end;
    end;

  except
    on E: Exception do
    begin
      erro := 'Erro ao preparar consulta: ' + E.Message;
      FreeAndNil(qry);
    end;
  end;
end;

function TProjetotelefonica.graficosituacoes(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('SELECT  ');
      SQL.Add('CONCAT( ');
      SQL.Add('  CASE MONTH(data_real) ');
      SQL.Add('    WHEN 1 THEN ''Jan'' ');
      SQL.Add('    WHEN 2 THEN ''Fev'' ');
      SQL.Add('    WHEN 3 THEN ''Mar'' ');
      SQL.Add('    WHEN 4 THEN ''Abr'' ');
      SQL.Add('    WHEN 5 THEN ''Mai'' ');
      SQL.Add('    WHEN 6 THEN ''Jun'' ');
      SQL.Add('    WHEN 7 THEN ''Jul'' ');
      SQL.Add('    WHEN 8 THEN ''Ago'' ');
      SQL.Add('    WHEN 9 THEN ''Set'' ');
      SQL.Add('    WHEN 10 THEN ''Out'' ');
      SQL.Add('    WHEN 11 THEN ''Nov'' ');
      SQL.Add('    WHEN 12 THEN ''Dez'' ');
      SQL.Add('  END ');
      SQL.Add(') AS Mes,');
      SQL.Add('SUM(CASE WHEN tipo = ''Instalação'' THEN 1 ELSE 0 END) AS instalacao, ');
      SQL.Add('SUM(CASE WHEN tipo = ''Integração'' THEN 1 ELSE 0 END) AS integracao, ');
      SQL.Add('SUM(CASE WHEN tipo = ''Entrega'' THEN 1 ELSE 0 END) AS mos ');
      SQL.Add('FROM (  ');
      SQL.Add('  SELECT FimInstalacaoReal AS data_real, ''Instalação'' AS tipo  ');
      SQL.Add('  FROM rolloutvivo ');
      SQL.Add('  WHERE FimInstalacaoReal IS NOT NULL AND FimInstalacaoReal <> ''1899-12-30'' AND YEAR(FimInstalacaoReal) = 2025 ');
      SQL.Add('  UNION ALL ');
      SQL.Add('  SELECT IntegracaoReal AS data_real, ''Integração'' AS tipo ');
      SQL.Add('  FROM rolloutvivo  ');
      SQL.Add('  WHERE IntegracaoReal IS NOT NULL AND IntegracaoReal <> ''1899-12-30'' AND YEAR(IntegracaoReal) = 2025 ');
      SQL.Add('  UNION ALL  ');
      SQL.Add('  SELECT EntregaReal AS data_real, ''Entrega'' AS tipo ');
      SQL.Add('  FROM rolloutvivo ');
      SQL.Add('  WHERE EntregaReal IS NOT NULL AND EntregaReal <> ''1899-12-30'' AND YEAR(EntregaReal) = 2025 ');
      SQL.Add(') AS sub ');
      SQL.Add('GROUP BY YEAR(data_real), MONTH(data_real) ');
      SQL.Add('ORDER BY YEAR(data_real), MONTH(data_real); ');
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

{function TProjetotelefonica.Listaacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('pmtsvivo.UID_IDPMTS, ');
      SQL.Add('pmtsvivo.UID_UFSIGLA, ');
      SQL.Add('pmtsvivo.UID_IDCPOMRF, ');
      SQL.Add('pmtsvivo.PMO_UF, ');
      SQL.Add('pmtsvivo.PMO_REGIONAL, ');
      SQL.Add('pmtsvivo.VENDOR_VISTORIA, ');
      SQL.Add('pmtsvivo.VENDOR_INTEGRADOR, ');
      SQL.Add('consolidadotelefonica.id ');
      SQL.Add('From ');
      SQL.Add('consolidadotelefonica Inner Join ');
      SQL.Add('pmtsvivo On pmtsvivo.UID_IDCPOMRF = consolidadotelefonica.IDObra ');
      SQL.Add('where pmtsvivo.MASTEROBRA_STATUS_ROLLOUT = ''Disparado Implantação'' and ');
      SQL.Add('consolidadotelefonica.StatusFinan is null  ');
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
end;   }

function TProjetotelefonica.Listaacompanhamentofinanceiro(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('* ');
      SQL.Add('From ');
      SQL.Add('consolidadotelefonica where IDObra=:idpmts ');
      ParamByName('idpmts').asstring := AQuery.Items['idpmts'];
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

function TProjetotelefonica.Listaatividade(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select');
      SQL.Add('  telefonicacontrolet2.*');
      SQL.Add('From');
      SQL.Add('  telefonicacontrolet2 where IDObra=:idpmts');
      ParamByName('idpmts').asstring := AQuery.Items['idpmts'];
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

function TProjetotelefonica.Listaatividades(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('* ');
      SQL.Add('From ');
      SQL.Add('consolidadotelefonica whare status  = ''Aprovado''   ');
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

function TProjetotelefonica.listacodt2(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select  ');
      SQL.Add('telefonicacodigoservicos.T2DESCRICAOCOD as label, ');
      SQL.Add('telefonicacodigoservicos.ID as value ');
      SQL.Add('from ');
      SQL.Add('telefonicacodigoservicos where telefonicacodigoservicos.regional=:uf ');
      ParamByName('uf').asstring := AQuery.Items['uf'];
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

function TProjetotelefonica.Listapacotes(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('* ');
      SQL.Add('From ');
      SQL.Add('lpuvivo where lpuvivo.UF=:uf and historico=:historico and divisao =:divisao ');
      ParamByName('uf').asstring := AQuery.Items['uf'];
      ParamByName('divisao').asstring := AQuery.Items['regiaolocal'];
      ParamByName('historico').asstring := historico;
      a := historico;
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

function TProjetotelefonica.NovoCadastro(out erro: string): string;
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
        SQL.Clear;
        SQL.add('update admponteiro set idzteos = idzteos+1 ');
        execsql;
        close;
        SQL.Clear;
        SQL.add('select idzteos from admponteiro ');
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

function TProjetotelefonica.rollouttelefonica(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  hasWhere: Boolean;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    with qry do
    begin
      SQL.Clear;

      SQL.Add('SELECT PMTS, Sytex, PMOREF, PMOCATEGORIA, UIDIDPMTS, UFSIGLA, PMOSIGLA, PMOUF, PMOREGIONAL, Cidade,');
      SQL.Add('EAPAUTOMATICA, REGIONALEAPINFRA, STATUSMENSALTX, MASTEROBRASTATUSROLLOUT, REGIONALLIBSITEP, REGIONALLIBSITER,');
      SQL.Add('EQUIPAMENTOENTREGAP, REGIONALCARIMBO, RSORSASCI, RSORSASCISTATUS, REGIONALOFENSORDETALHE, VENDORVISTORIA,');
      SQL.Add('VENDORPROJETO, VENDORINSTALADOR, VENDORINTEGRADOR, PMOTECNEQUIP, PMOFREQEQUIP, UIDIDCPOMRF, StatusObra,');
      SQL.Add('PMOACEITACAO,');
      SQL.Add('EntregaRequest, EntregaPlan, EntregaReal, FimInstalacaoPlan, FimInstalacaoReal, IntegracaoPlan, IntegracaoReal,');
      SQL.Add('Ativacao, Documentacao, DTPlan, DTReal, Rollout, Acionamento, nomedosite, endereco, RSORSADETENTORA, RSORSAIDDETENTORA,');
      SQL.Add('resumodafase, infravivo, Equipe, docaplan, deliverypolan, OV, ACESSO, t2instalacao, NUMERODAREQ, NUMEROT2, PEDIDO,');
      SQL.Add('T2VISTORIA, NUMERODAREQVISTORIA, NUMEROT2VISTORIA, PEDIDOVISTORIA, id, infra, ddd, LATITUDE, LONGITUDE,');
      SQL.Add('acessoobs, acessosolicitacao, acessodatasolicitacao, acessodatainicial, acessodatafinal, acessostatus,  acompanhamentofisicoobservacao,');SQL.Add('acessoobs, acessosolicitacao, acessodatasolicitacao, acessodatainicial, acessodatafinal, acessostatus, dataimprodutiva,  acompanhamentofisicoobservacao,');
      SQL.Add('acessoatividade, acessocomentario, acessooutros, acessoformaacesso, vistoriaplan, vistoriareal, docplan, docvitoriareal, req, deletado, rtt, rttdata,');
      SQL.Add('initialtunningplan, initialtunningreal, initialtunnigstatus, InitialTunningRealFinal, AprovacaoSSV, StatusAprovacaoSSV, observacaodocumentacao,datapostagemdocvdvm,dataexecucaodocvdvm,statusdocumentacao,datapostagemdoc    ,dataexecucaodoc    ');
      SQL.Add('FROM rolloutvivo');

      hasWhere := False;

      // Add WHERE conditions for each parameter
      if AQuery.ContainsKey('pmoRef') and (AQuery['pmoRef'] <> '') then
      begin
        SQL.Add(' WHERE PMOREF = :pmoRef');
        hasWhere := True;
      end;

      if AQuery.ContainsKey('pmoCategoria') and (AQuery['pmoCategoria'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND PMOCATEGORIA = :pmoCategoria')
        else
        begin
          SQL.Add(' WHERE PMOCATEGORIA = :pmoCategoria');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('uidIdpmts') and (AQuery['uidIdpmts'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND UIDIDPMTS = :uidIdpmts')
        else
        begin
          SQL.Add(' WHERE UIDIDPMTS = :uidIdpmts');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('ufSigla') and (AQuery['ufSigla'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND UFSIGLA = :ufSigla')
        else
        begin
          SQL.Add(' WHERE UFSIGLA = :ufSigla');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('pmoSigla') and (AQuery['pmoSigla'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND PMOSIGLA = :pmoSigla')
        else
        begin
          SQL.Add(' WHERE PMOSIGLA = :pmoSigla');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('pmoUf') and (AQuery['pmoUf'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND PMOUF = :pmoUf')
        else
        begin
          SQL.Add(' WHERE PMOUF = :pmoUf');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('pmoRegional') and (AQuery['pmoRegional'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND PMOREGIONAL = :pmoRegional')
        else
        begin
          SQL.Add(' WHERE PMOREGIONAL = :pmoRegional');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('statusObra') and (AQuery['statusObra'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND StatusObra = :statusObra')
        else
        begin
          SQL.Add(' WHERE StatusObra = :statusObra');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('documentacao') and (AQuery['documentacao'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND Documentacao = :documentacao')
        else
        begin
          SQL.Add(' WHERE Documentacao = :documentacao');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('initialTunningReal') and (AQuery['initialTunningReal'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND initialtunningreal = :initialTunningReal')
        else
        begin
          SQL.Add(' WHERE initialtunningreal = :initialTunningReal');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('dtReal') and (AQuery['dtReal'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND DTReal = :dtReal')
        else
        begin
          SQL.Add(' WHERE DTReal = :dtReal');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('fimInstalacaoPlan') and (AQuery['fimInstalacaoPlan'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND FimInstalacaoPlan = :fimInstalacaoPlan')
        else
        begin
          SQL.Add(' WHERE FimInstalacaoPlan = :fimInstalacaoPlan');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('initialTunningStatus') and (AQuery['initialTunningStatus'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND initialtunnigstatus = :initialTunningStatus')
        else
        begin
          SQL.Add(' WHERE initialtunnigstatus = :initialTunningStatus');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('dtPlan') and (AQuery['dtPlan'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND DTPlan = :dtPlan')
        else
        begin
          SQL.Add(' WHERE DTPlan = :dtPlan');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('rollout') and (AQuery['rollout'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND Rollout = :rollout')
        else
        begin
          SQL.Add(' WHERE Rollout = :rollout');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('acionamento') and (AQuery['acionamento'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND Acionamento = :acionamento')
        else
        begin
          SQL.Add(' WHERE Acionamento = :acionamento');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('nomeSite') and (AQuery['nomeSite'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND nomedosite = :nomeSite')
        else
        begin
          SQL.Add(' WHERE nomedosite = :nomeSite');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('endereco') and (AQuery['endereco'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND endereco = :endereco')
        else
        begin
          SQL.Add(' WHERE endereco = :endereco');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('rsoRsaDetentora') and (AQuery['rsoRsaDetentora'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND RSORSADETENTORA = :rsoRsaDetentora')
        else
        begin
          SQL.Add(' WHERE RSORSADETENTORA = :rsoRsaDetentora');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('rsoRsaIdDetentora') and (AQuery['rsoRsaIdDetentora'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND RSORSAIDDETENTORA = :rsoRsaIdDetentora')
        else
        begin
          SQL.Add(' WHERE RSORSAIDDETENTORA = :rsoRsaIdDetentora');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('resumoFase') and (AQuery['resumoFase'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND resumodafase = :resumoFase')
        else
        begin
          SQL.Add(' WHERE resumodafase = :resumoFase');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('infraVivo') and (AQuery['infraVivo'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND infravivo = :infraVivo')
        else
        begin
          SQL.Add(' WHERE infravivo = :infraVivo');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('equipe') and (AQuery['equipe'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND Equipe = :equipe')
        else
        begin
          SQL.Add(' WHERE Equipe = :equipe');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('docaPlan') and (AQuery['docaPlan'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND docaplan = :docaPlan')
        else
        begin
          SQL.Add(' WHERE docaplan = :docaPlan');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('deliveryPlan') and (AQuery['deliveryPlan'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND deliverypolan = :deliveryPlan')
        else
        begin
          SQL.Add(' WHERE deliverypolan = :deliveryPlan');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('ov') and (AQuery['ov'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND OV = :ov')
        else
        begin
          SQL.Add(' WHERE OV = :ov');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('acesso') and (AQuery['acesso'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND ACESSO = :acesso')
        else
        begin
          SQL.Add(' WHERE ACESSO = :acesso');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('t2Instalacao') and (AQuery['t2Instalacao'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND t2instalacao = :t2Instalacao')
        else
        begin
          SQL.Add(' WHERE t2instalacao = :t2Instalacao');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('numeroReqInst') and (AQuery['numeroReqInst'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND NUMERODAREQ = :numeroReqInst')
        else
        begin
          SQL.Add(' WHERE NUMERODAREQ = :numeroReqInst');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('numeroT2Inst') and (AQuery['numeroT2Inst'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND NUMEROT2 = :numeroT2Inst')
        else
        begin
          SQL.Add(' WHERE NUMEROT2 = :numeroT2Inst');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('pedidoInst') and (AQuery['pedidoInst'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND PEDIDO = :pedidoInst')
        else
        begin
          SQL.Add(' WHERE PEDIDO = :pedidoInst');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('t2Vistoria') and (AQuery['t2Vistoria'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND T2VISTORIA = :t2Vistoria')
        else
        begin
          SQL.Add(' WHERE T2VISTORIA = :t2Vistoria');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('numeroReqVist') and (AQuery['numeroReqVist'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND NUMERODAREQVISTORIA = :numeroReqVist')
        else
        begin
          SQL.Add(' WHERE NUMERODAREQVISTORIA = :numeroReqVist');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('numeroT2Vist') and (AQuery['numeroT2Vist'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND NUMEROT2VISTORIA = :numeroT2Vist')
        else
        begin
          SQL.Add(' WHERE NUMEROT2VISTORIA = :numeroT2Vist');
          hasWhere := True;
        end;
      end;

      if AQuery.ContainsKey('pedidoVist') and (AQuery['pedidoVist'] <> '') then
      begin
        if hasWhere then
          SQL.Add(' AND PEDIDOVISTORIA = :pedidoVist')
        else
        begin
          SQL.Add(' WHERE PEDIDOVISTORIA = :pedidoVist');
          hasWhere := True;
        end;
      end;

      // Set parameter values
      if AQuery.ContainsKey('pmoRef') and (AQuery['pmoRef'] <> '') then
        ParamByName('pmoRef').Value := AQuery['pmoRef'];

      if AQuery.ContainsKey('pmoCategoria') and (AQuery['pmoCategoria'] <> '') then
        ParamByName('pmoCategoria').Value := AQuery['pmoCategoria'];

      if AQuery.ContainsKey('uidIdpmts') and (AQuery['uidIdpmts'] <> '') then
        ParamByName('uidIdpmts').Value := AQuery['uidIdpmts'];

      if AQuery.ContainsKey('ufSigla') and (AQuery['ufSigla'] <> '') then
        ParamByName('ufSigla').Value := AQuery['ufSigla'];

      if AQuery.ContainsKey('pmoSigla') and (AQuery['pmoSigla'] <> '') then
        ParamByName('pmoSigla').Value := AQuery['pmoSigla'];

      if AQuery.ContainsKey('pmoUf') and (AQuery['pmoUf'] <> '') then
        ParamByName('pmoUf').Value := AQuery['pmoUf'];

      if AQuery.ContainsKey('pmoRegional') and (AQuery['pmoRegional'] <> '') then
        ParamByName('pmoRegional').Value := AQuery['pmoRegional'];

      if AQuery.ContainsKey('statusObra') and (AQuery['statusObra'] <> '') then
        ParamByName('statusObra').Value := AQuery['statusObra'];

      if AQuery.ContainsKey('documentacao') and (AQuery['documentacao'] <> '') then
        ParamByName('documentacao').Value := AQuery['documentacao'];

      if AQuery.ContainsKey('initialTunningReal') and (AQuery['initialTunningReal'] <> '') then
        ParamByName('initialTunningReal').Value := AQuery['initialTunningReal'];

      if AQuery.ContainsKey('dtReal') and (AQuery['dtReal'] <> '') then
        ParamByName('dtReal').Value := AQuery['dtReal'];

      if AQuery.ContainsKey('fimInstalacaoPlan') and (AQuery['fimInstalacaoPlan'] <> '') then
        ParamByName('fimInstalacaoPlan').Value := AQuery['fimInstalacaoPlan'];

      if AQuery.ContainsKey('initialTunningStatus') and (AQuery['initialTunningStatus'] <> '') then
        ParamByName('initialTunningStatus').Value := AQuery['initialTunningStatus'];

      if AQuery.ContainsKey('dtPlan') and (AQuery['dtPlan'] <> '') then
        ParamByName('dtPlan').Value := AQuery['dtPlan'];

      if AQuery.ContainsKey('rollout') and (AQuery['rollout'] <> '') then
        ParamByName('rollout').Value := AQuery['rollout'];

      if AQuery.ContainsKey('acionamento') and (AQuery['acionamento'] <> '') then
        ParamByName('acionamento').Value := AQuery['acionamento'];

      if AQuery.ContainsKey('nomeSite') and (AQuery['nomeSite'] <> '') then
        ParamByName('nomeSite').Value := AQuery['nomeSite'];

      if AQuery.ContainsKey('endereco') and (AQuery['endereco'] <> '') then
        ParamByName('endereco').Value := AQuery['endereco'];

      if AQuery.ContainsKey('rsoRsaDetentora') and (AQuery['rsoRsaDetentora'] <> '') then
        ParamByName('rsoRsaDetentora').Value := AQuery['rsoRsaDetentora'];

      if AQuery.ContainsKey('rsoRsaIdDetentora') and (AQuery['rsoRsaIdDetentora'] <> '') then
        ParamByName('rsoRsaIdDetentora').Value := AQuery['rsoRsaIdDetentora'];

      if AQuery.ContainsKey('resumoFase') and (AQuery['resumoFase'] <> '') then
        ParamByName('resumoFase').Value := AQuery['resumoFase'];

      if AQuery.ContainsKey('infraVivo') and (AQuery['infraVivo'] <> '') then
        ParamByName('infraVivo').Value := AQuery['infraVivo'];

      if AQuery.ContainsKey('equipe') and (AQuery['equipe'] <> '') then
        ParamByName('equipe').Value := AQuery['equipe'];

      if AQuery.ContainsKey('docaPlan') and (AQuery['docaPlan'] <> '') then
        ParamByName('docaPlan').Value := AQuery['docaPlan'];

      if AQuery.ContainsKey('deliveryPlan') and (AQuery['deliveryPlan'] <> '') then
        ParamByName('deliveryPlan').Value := AQuery['deliveryPlan'];

      if AQuery.ContainsKey('ov') and (AQuery['ov'] <> '') then
        ParamByName('ov').Value := AQuery['ov'];

      if AQuery.ContainsKey('acesso') and (AQuery['acesso'] <> '') then
        ParamByName('acesso').Value := AQuery['acesso'];

      if AQuery.ContainsKey('t2Instalacao') and (AQuery['t2Instalacao'] <> '') then
        ParamByName('t2Instalacao').Value := AQuery['t2Instalacao'];

      if AQuery.ContainsKey('numeroReqInst') and (AQuery['numeroReqInst'] <> '') then
        ParamByName('numeroReqInst').Value := AQuery['numeroReqInst'];

      if AQuery.ContainsKey('numeroT2Inst') and (AQuery['numeroT2Inst'] <> '') then
        ParamByName('numeroT2Inst').Value := AQuery['numeroT2Inst'];

      if AQuery.ContainsKey('pedidoInst') and (AQuery['pedidoInst'] <> '') then
        ParamByName('pedidoInst').Value := AQuery['pedidoInst'];

      if AQuery.ContainsKey('t2Vistoria') and (AQuery['t2Vistoria'] <> '') then
        ParamByName('t2Vistoria').Value := AQuery['t2Vistoria'];

      if AQuery.ContainsKey('numeroReqVist') and (AQuery['numeroReqVist'] <> '') then
        ParamByName('numeroReqVist').Value := AQuery['numeroReqVist'];

      if AQuery.ContainsKey('numeroT2Vist') and (AQuery['numeroT2Vist'] <> '') then
        ParamByName('numeroT2Vist').Value := AQuery['numeroT2Vist'];

      if AQuery.ContainsKey('pedidoVist') and (AQuery['pedidoVist'] <> '') then
        ParamByName('pedidoVist').Value := AQuery['pedidoVist'];

      Active := True;
    end;

    erro := '';
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar: ' + ex.Message;
      if Assigned(qry) then
        qry.Free;
      Result := nil;
    end;
  end;
end;

function TProjetotelefonica.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('rolloutvivo.UIDIDPMTS,  ');
      SQL.Add('rolloutvivo.UFSIGLA,  ');
      SQL.Add('rolloutvivo.PMOSIGLA,  ');
      SQL.Add('rolloutvivo.PMOUF,  ');
      SQL.Add('rolloutvivo.PMOREGIONAL,  ');
      SQL.Add('rolloutvivo.uididcpomrf,  ');
      SQL.Add('rolloutvivo.infra,  ');
      SQL.Add('rolloutvivo.RSORSASCI,  ');
      SQL.Add('rolloutvivo.RSORSASCISTATUS,  ');
      SQL.Add('rolloutvivo.RSORSADETENTORA,  ');
      SQL.Add('rolloutvivo.RSORSAIDDETENTORA,  ');
      SQL.Add('rolloutvivo.ddd,  ');
      SQL.Add('rolloutvivo.Cidade,  ');
      SQL.Add('rolloutvivo.nomedosite As SCIENCENOME,  ');
      SQL.Add('rolloutvivo.endereco As SCIENCEENDERECO, ');
      SQL.Add('rolloutvivo.LATITUDE as SCIENCELATITUDE, ');
      SQL.Add('rolloutvivo.LONGITUDE as SCIENCELONGITUDE, ');
      SQL.Add('rolloutvivo.acessoobs, ');
      SQL.Add('rolloutvivo.acessostatus, ');
      SQL.Add('rolloutvivo.initialtunnigstatus, ');
      SQL.Add('rolloutvivo.acessosolicitacao, ');
      SQL.Add('rolloutvivo.acessodatasolicitacao, ');
      SQL.Add('rolloutvivo.acessodatainicial, ');
      SQL.Add('rolloutvivo.acessodatafinal, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.dataimprodutiva, ''%Y-%m-%d'') as dataimprodutiva, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.EntregaPlan, ''%Y-%m-%d'') as EntregaPlan, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.EntregaReal, ''%Y-%m-%d'') as EntregaReal, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.FimInstalacaoPlan, ''%Y-%m-%d'') as FimInstalacaoPlan, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.FimInstalacaoReal, ''%Y-%m-%d'') as FimInstalacaoReal, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.IntegracaoPlan, ''%Y-%m-%d'') as IntegracaoPlan, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.IntegracaoReal, ''%Y-%m-%d'') as IntegracaoReal, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.Ativacao, ''%Y-%m-%d'') as Ativacao, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.Documentacao, ''%Y-%m-%d'') as Documentacao, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.InventarioDesinstalacao, ''%Y-%m-%d'') as InventarioDesinstalacao, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.DTPlan, ''%Y-%m-%d'') as DTPlan, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.DTReal, ''%Y-%m-%d'') as DTReal, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.AprovacaoSSV, ''%Y-%m-%d'') as AprovacaoSSV, ');
      SQL.Add('rolloutvivo.StatusAprovacaoSSV, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.vistoriaplan, ''%Y-%m-%d'') as vistoriaplan, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.vistoriareal, ''%Y-%m-%d'') as vistoriareal, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.docplan, ''%Y-%m-%d'') as docplan, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.docvitoriareal, ''%Y-%m-%d'') as docvitoriareal, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.req, ''%Y-%m-%d'') as req, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.initialtunningreal, ''%Y-%m-%d'') as initialtunningreal, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.InitialTunningRealFinal, ''%Y-%m-%d'') as InitialTunningRealFinal, ');
      SQL.Add('rolloutvivo.resumodafase, ');
      SQL.Add('rolloutvivo.Rollout, ');
      SQL.Add('rolloutvivo.infravivo, ');
      SQL.Add('rolloutvivo.equipe, rolloutvivo.dataExecucaoDoc , rolloutvivo.datapostagemdoc , rolloutvivo.statusDocumentacao, rolloutvivo.dataexecucaodocvdvm, rolloutvivo.datapostagemdocvdvm, rolloutvivo.observacaoDocumentacao, ');
      SQL.Add('rolloutvivo.acompanhamentofisicoobservacao, ');
      SQL.Add('UPPER(rolloutvivo.StatusObra) as statusobra, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.docaplan, ''%Y-%m-%d'') as docaplan, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.PMOACEITACAO, ''%Y-%m-%d'') as PMO_ACEITACAO, ');
      SQL.Add('rolloutvivo.OV ');
      SQL.Add(' ');
      SQL.Add('From ');
      SQL.Add('rolloutvivo where rolloutvivo.uididcpomrf=:uididcpomrf ');
      ParamByName('uididcpomrf').asstring := AQuery.Items['idpmts'];
      a := AQuery.Items['idpmts'];
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Writeln(erro);
      Result := nil;
    end;
  end;
end;

function TProjetotelefonica.Listaiddocumentacao(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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

function TProjetotelefonica.Listaacionamentopj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
    
      SQL.Add('select  ');
      SQL.Add('acionamentovivo.id, ');
      SQL.Add('gesempresas.nome, ');
      SQL.Add('gesusuario.nome as usuario, ');
      SQL.Add('telefonicacontrolet2.po, ');
      SQL.Add('telefonicacontrolet2.t2codmatservsw, ');
      SQL.Add('telefonicacontrolet2.t2descricaocod, ');
      SQL.Add(' '' as atividade, ');
      SQL.Add(' '' as codservico, ');
      SQL.Add('acionamentovivo.quantidade as qtd, ');
      SQL.Add('lpuvivo.ts, ');
      SQL.Add('lpuvivo.brevedescricaoingles, ');
      SQL.Add('lpuvivo.brevedescricao, ');
      SQL.Add('lpuvivo.codigolpuvivo, ');
      SQL.Add('lpuvivo.valorpj, ');
      SQL.Add('acionamentovivo.dataacionamento, ');
      SQL.Add('acionamentovivo.observacao, ');
      SQL.Add('acionamentovivo.dataenvioemail ');
      SQL.Add('from ');
      SQL.Add('acionamentovivo inner join ');
      SQL.Add('gesempresas on gesempresas.idempresa = acionamentovivo.idcolaborador left join ');
      SQL.Add('gesusuario on gesusuario.idusuario = acionamentovivo.idfuncionario left join ');
      SQL.Add('telefonicacontrolet2 on telefonicacontrolet2.id = acionamentovivo.idatividade inner join ');
      SQL.Add('lpuvivo on acionamentovivo.idpacote = lpuvivo.id where acionamentovivo.idrollout =:idr and  acionamentovivo.deletado = 0 ');
      ParamByName('idr').asstring := AQuery.Items['idrollout'];
      a := AQuery.Items['idrollout'];
      Active := true;
    end;
    erro := '';
    Result := qry;
  except
    on ex: exception do
    begin

      erro := 'Erro ao consultar : ' + ex.Message;
      Writeln(erro);
      Result := nil;
    end;
  end;
end;

function TProjetotelefonica.Listaacionamentos(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('acionamentovivo.id, ');
      SQL.Add('acionamentovivo.idpmts, ');
      SQL.Add('lpuvivo.UF As regional, ');
      SQL.Add('acionamentovivo.po, ');
      SQL.Add('telefonicacontrolet2.T2DESCRICAOCOD As atividade, ');
      SQL.Add('acionamentovivo.quantidade, ');
      SQL.Add('lpuvivo.BREVEDESCRICAO As tarefas, ');
      SQL.Add('acionamentovivo.valor, ');
      SQL.Add('acionamentovivo.dataacionamento, ');
      SQL.Add('acionamentovivo.dataenvioemail, ');
      SQL.Add('gesempresas.nome, ');
      SQL.Add('rolloutvivo.pmosigla, ');
      SQL.Add('rolloutvivo.ufsigla, ');
      SQL.Add('rolloutvivo.EntregaRequest, ');
      SQL.Add('rolloutvivo.EntregaPlan, ');
      SQL.Add('rolloutvivo.EntregaReal, ');
      SQL.Add('rolloutvivo.FimInstalacaoPlan, ');
      SQL.Add('rolloutvivo.FimInstalacaoReal, ');
      SQL.Add('rolloutvivo.IntegracaoPlan, ');
      SQL.Add('rolloutvivo.IntegracaoReal, ');
      SQL.Add('rolloutvivo.Ativacao, ');
      SQL.Add('rolloutvivo.Documentacao, ');
      SQL.Add('rolloutvivo.InventarioDesinstalacao, ');
      SQL.Add('rolloutvivo.DTPlan, ');
      SQL.Add('rolloutvivo.DTReal, ');
      SQL.Add('rolloutvivo.AprovacaoSSV, ');
      SQL.Add('rolloutvivo.StatusAprovacaoSSV, ');
      SQL.Add('rolloutvivo.VistoriaPlan, ');
      SQL.Add('rolloutvivo.VistoriaReal, ');
      SQL.Add('rolloutvivo.InitialTunningPlan, ');
      SQL.Add('rolloutvivo.InitialTunningReal, ');
      SQL.Add('rolloutvivo.InitialTunningRealFinal, ');
      SQL.Add('rolloutvivo.initialtunnigstatus, ');
      SQL.Add('rolloutvivo.dataimprodutiva, ');
      SQL.Add('rolloutvivo.StatusObra, ');
      SQL.Add('lpuvivo.codigolpuvivo, ');
      SQL.Add('acionamentovivo.fechamento, ');
      SQL.Add('acionamentovivo.porcentagem,  ');
      SQL.Add('rolloutvivo.deletado, ');
      SQL.Add('acionamentovivo.deletado as acionamentovivodeletado ');
      SQL.Add('From ');
      SQL.Add('acionamentovivo left Join ');
      SQL.Add('telefonicacontrolet2 On telefonicacontrolet2.ID = acionamentovivo.idatividade left Join ');
      SQL.Add('lpuvivo On lpuvivo.ID = acionamentovivo.idpacote left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = acionamentovivo.idcolaborador left Join ');
      SQL.Add('rolloutvivo On rolloutvivo.UIDIDPMTS = acionamentovivo.idpmts ');
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

function TProjetotelefonica.Listaacionamentosf(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    if not AQuery.ContainsKey('idempresalocal') then
    begin
      erro := 'Parâmetro idempresalocal não informado.';
      Exit(nil);
    end;

    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    with qry.SQL do
    begin
      Clear;
      Add('SELECT acionamentovivo.id AS id, ');
      Add('acionamentovivo.idpmts,  ');
      Add('lpuvivo.UF AS regional, ');
      Add('acionamentovivo.po AS po, ');
      Add('telefonicacontrolet2.T2DESCRICAOCOD AS atividade, ');
      Add('acionamentovivo.quantidade AS quantidade, ');
      Add('lpuvivo.BREVEDESCRICAO AS tarefas, ');
      Add('acionamentovivo.valor AS valor, ');
      Add('acionamentovivo.dataacionamento AS dataacionamento, ');
      Add('acionamentovivo.dataenvioemail AS dataenvioemail, ');
      Add('gesempresas.nome AS nome, ');
      Add('rolloutvivo.PMOSIGLA AS PMOSIGLA, ');
      Add('rolloutvivo.UFSIGLA AS UFSIGLA, ');
      Add('rolloutvivo.EntregaRequest AS EntregaRequest, ');
      Add('rolloutvivo.EntregaPlan AS EntregaPlan, ');
      Add('rolloutvivo.EntregaReal AS EntregaReal, ');
      Add('rolloutvivo.FimInstalacaoPlan AS FimInstalacaoPlan, ');
      Add('rolloutvivo.FimInstalacaoReal AS FimInstalacaoReal, ');
      Add('rolloutvivo.IntegracaoPlan AS IntegracaoPlan, ');
      Add('rolloutvivo.IntegracaoReal AS IntegracaoReal, ');
      Add('rolloutvivo.Ativacao AS Ativacao, ');
      Add('rolloutvivo.Documentacao AS Documentacao, ');
      Add('rolloutvivo.InventarioDesinstalacao AS InventarioDesinstalacao, ');
      Add('rolloutvivo.DTPlan AS DTPlan, ');
      Add('rolloutvivo.DTReal AS DTReal, ');
      Add('rolloutvivo.AprovacaoSSV AS AprovacaoSSV, ');
      Add('rolloutvivo.StatusAprovacaoSSV AS StatusAprovacaoSSV, ');
      Add('rolloutvivo.initialtunningreal, ');
      Add('rolloutvivo.InitialTunningRealFinal, ');
      Add('rolloutvivo.vistoriareal, ');
      Add('rolloutvivo.StatusObra AS StatusObra, ');
      Add('lpuvivo.CODIGOLPUVIVO AS CODIGOLPUVIVO, ');
      Add('acionamentovivo.idcolaborador AS idcolaborador, ');
      Add('telefonicapagamento.tipopagamento  AS status, ');
      Add('coalesce(Sum(telefonicapagamento.valorpagamento),0) As valorpago, ');
      Add('max(telefonicapagamento.observacao) as observacao, ');
      Add('coalesce(Sum(telefonicapagamento.porcentagem),0) As porcentagem ');
      Add('FROM acionamentovivo ');
      Add('LEFT JOIN telefonicapagamento ON telefonicapagamento.idacionamentovivo = acionamentovivo.id ');
      Add('LEFT JOIN telefonicacontrolet2 ON telefonicacontrolet2.ID = acionamentovivo.idatividade ');
      Add('LEFT JOIN lpuvivo ON lpuvivo.ID = acionamentovivo.idpacote ');
      Add('LEFT JOIN gesempresas ON gesempresas.idempresa = acionamentovivo.idcolaborador ');
      Add('LEFT JOIN rolloutvivo ON rolloutvivo.UIDIDPMTS = acionamentovivo.idpmts ');
      Add('WHERE acionamentovivo.deletado = 0 and rolloutvivo.deletado = 0 ');
      Add('AND  acionamentovivo.idcolaborador = :idcolaborador AND acionamentovivo.porcentagem < 1 Group By acionamentovivo.id  ');
      if AQuery.ContainsKey('mespagamento') and (Trim(AQuery['mespagamento']) <> '') then
      begin
        qry.SQL.Add('  AND telefonicapagamento.mespagamento LIKE :mespagamento');
        qry.ParamByName('mespagamento').AsString := '%' + AQuery['mespagamento'] + '%';
      end;

      if AQuery.ContainsKey('pmo') and (AQuery['pmo'] <> '') then
      begin
        Add('AND rolloutvivo.PMOSIGLA = :PMOSIGLA ');
      end;
    end;

    qry.ParamByName('idcolaborador').AsString := AQuery['idempresalocal'];
    if AQuery.ContainsKey('pmo') and (AQuery['pmo'] <> '') then
      qry.ParamByName('PMOSIGLA').AsString := AQuery['pmo'];

    qry.Active := True;
    erro := '';
    Result := qry;

  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar: ' + ex.Message;
      Result := nil;
      qry.Free;
    end;
  end;
end;

function TProjetotelefonica.Listaacionamentosfhistorico(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    if not AQuery.ContainsKey('idempresalocal') then
    begin
      erro := 'Parâmetro idempresalocal não informado.';
      Exit(nil);
    end;

    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    with qry.SQL do
    begin
      Clear;
      Add('select   ');
      Add('telefonicapagamento.idgeral as id,  ');
      Add('acionamentovivo.idpmts,  ');
      Add('rolloutvivo.pmoregional,  ');
      Add('acionamentovivo.po,  ');
      Add('rolloutvivo.pmosigla,  ');
      Add('rolloutvivo.ufsigla,  ');
      Add('telefonicacontrolet2.t2descricaocod as atividade,  ');
      Add('acionamentovivo.quantidade,  ');
      Add('lpuvivo.codigolpuvivo,  ');
      Add('lpuvivo.brevedescricao,  ');
      Add('acionamentovivo.valor,  ');
      Add('acionamentovivo.dataacionamento,  ');
      Add('acionamentovivo.dataenvioemail,  ');
      Add('rolloutvivo.entregareal,  ');
      Add('rolloutvivo.fiminstalacaoreal,  ');
      Add('rolloutvivo.integracaoreal,  ');
      Add('rolloutvivo.ativacao,  ');
      Add('rolloutvivo.documentacao,  ');
      Add('rolloutvivo.inventariodesinstalacao,  ');
      Add('rolloutvivo.dtreal,  ');
      Add('rolloutvivo.aprovacaossv,  ');
      Add('rolloutvivo.statusaprovacaossv,  ');
      Add('rolloutvivo.initialtunningreal, ');
      Add('rolloutvivo.initialtunningrealfinal, ');
      Add('rolloutvivo.vistoriareal, ');
      Add('rolloutvivo.statusobra,  ');
      Add('telefonicapagamento.mespagamento,  ');
      Add('telefonicapagamento.porcentagem,  ');
      Add('telefonicapagamento.valorpagamento,  ');
      Add('telefonicapagamento.datapagamento,  ');
      Add('telefonicapagamento.observacao,  ');
      Add('telefonicapagamento.tipopagamento  ');
      Add('from  ');
      Add('telefonicapagamento left join  ');
      Add('acionamentovivo on acionamentovivo.id = telefonicapagamento.idacionamentovivo left join  ');
      Add('rolloutvivo on rolloutvivo.id = acionamentovivo.idrollout left join  ');
      Add('telefonicacontrolet2 on telefonicacontrolet2.id = acionamentovivo.idatividade left join  ');
      Add('lpuvivo on acionamentovivo.idpacote = lpuvivo.id ');
      Add('WHERE acionamentovivo.deletado = 0 ');
      Add('AND  acionamentovivo.idcolaborador = :idcolaborador  ');
      qry.ParamByName('idcolaborador').AsString := AQuery['idempresalocal'];
      if AQuery.ContainsKey('pmo') and (AQuery['pmo'] <> '') then
      begin
        Add('AND rolloutvivo.PMOSIGLA = :PMOSIGLA ');
        if AQuery.ContainsKey('pmo') and (AQuery['pmo'] <> '') then
          qry.ParamByName('PMOSIGLA').AsString := AQuery['pmo'];
      end;
      Add(' order by telefonicapagamento.mespagamento,rolloutvivo.pmosigla,telefonicapagamento.datapagamento  ');
    end;
    qry.Active := True;
    erro := '';
    Result := qry;

  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar: ' + ex.Message;
      Result := nil;
      qry.Free;
    end;
  end;
end;

function TProjetotelefonica.Listaacionamentoshistoricopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try

    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    with qry.SQL do
    begin
      Clear;
      Add('select   ');
      Add('telefonicapagamento.idgeral as id,  ');
      Add('gesempresas.nome, ');
      Add('acionamentovivo.idpmts,  ');
      Add('rolloutvivo.pmoregional,  ');
      Add('acionamentovivo.po,  ');
      Add('rolloutvivo.pmosigla,  ');
      Add('rolloutvivo.ufsigla,  ');
      Add('telefonicacontrolet2.t2descricaocod as atividade,  ');
      Add('acionamentovivo.quantidade,  ');
      Add('lpuvivo.codigolpuvivo,  ');
      Add('lpuvivo.brevedescricao,  ');
      Add('acionamentovivo.valor,  ');
      Add('acionamentovivo.dataacionamento,  ');
      Add('acionamentovivo.dataenvioemail,  ');
      Add('rolloutvivo.entregareal,  ');
      Add('rolloutvivo.fiminstalacaoreal,  ');
      Add('rolloutvivo.integracaoreal,  ');
      Add('rolloutvivo.ativacao,  ');
      Add('rolloutvivo.documentacao,  ');
      Add('rolloutvivo.dtreal,  ');
      Add('rolloutvivo.initialtunningreal, ');
      Add('rolloutvivo.vistoriareal, ');
      Add('rolloutvivo.statusobra,  ');
      Add('telefonicapagamento.mespagamento,  ');
      Add('telefonicapagamento.porcentagem,  ');
      Add('telefonicapagamento.valorpagamento,  ');
      Add('telefonicapagamento.datapagamento,  ');
      Add('telefonicapagamento.tipopagamento  ');
      Add('from  ');
      Add('telefonicapagamento left join  ');
      Add('acionamentovivo on acionamentovivo.id = telefonicapagamento.idacionamentovivo left join  ');
      Add('rolloutvivo on rolloutvivo.id = acionamentovivo.idrollout left join  ');
      Add('telefonicacontrolet2 on telefonicacontrolet2.id = acionamentovivo.idatividade left join  ');
      Add('lpuvivo on acionamentovivo.idpacote = lpuvivo.id left Join  ');
      Add('gesempresas On gesempresas.idempresa = acionamentovivo.idcolaborador ');
      Add('WHERE acionamentovivo.deletado = 0 ');
      Add(' order by telefonicapagamento.mespagamento,rolloutvivo.pmosigla,telefonicapagamento.datapagamento  ');
    end;
    qry.Active := True;
    erro := '';
    Result := qry;

  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar: ' + ex.Message;
      Result := nil;
      qry.Free;
    end;
  end;
end;

function TProjetotelefonica.Listaacionamentoclt(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  idpmts: string;
begin
  Result := nil;
  erro := '';
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;


    with qry do
    begin
      SQL.Clear;
      SQL.Add('SELECT ');
      SQL.Add('  acionamentovivoclt.po, ');
      SQL.Add('  acionamentovivoclt.id, ');
      SQL.Add('  telefonicacontrolet2.T2CODMATSERVSW, ');
      SQL.Add('  telefonicacontrolet2.T2DESCRICAOCOD, ');
      SQL.Add('  gespessoa.nome, ');
      SQL.Add('  gesusuario.nome AS usuario, ');
      SQL.Add('  acionamentovivoclt.valor, ');
      SQL.Add('  acionamentovivoclt.dataacionamento, ');
      SQL.Add('  acionamentovivoclt.atividade, ');
      SQL.Add('  acionamentovivoclt.dataincio, ');
      SQL.Add('  acionamentovivoclt.datafinal ');
      SQL.Add('FROM ');
      SQL.Add('  acionamentovivoclt ');
      SQL.Add('LEFT JOIN telefonicacontrolet2 ON telefonicacontrolet2.id = acionamentovivoclt.idatividade ');
      SQL.Add('LEFT JOIN gespessoa ON gespessoa.idpessoa = acionamentovivoclt.idcolaborador ');
      SQL.Add('LEFT JOIN gesusuario ON gesusuario.idusuario = acionamentovivoclt.idfuncionario ');
      SQL.Add('WHERE ');
      SQL.Add('  acionamentovivoclt.deletado = 0 ');

      // Verifica se o parâmetro idrollout existe e é válido
      if AQuery.ContainsKey('osouobra') then
      begin
        idpmts := AQuery.Items['osouobra'];
        SQL.Add('AND acionamentovivoclt.idpmts = :idpmts');
        ParamByName('idpmts').AsString := idpmts;
      end
      else
      begin
        erro := 'Parâmetro osouobra não informado';
        FreeAndNil(qry);
        Exit;
      end;

      FetchOptions.AutoClose := False;

      try
        Open;
        Result := qry;
      except
        on E: Exception do
        begin
          erro := 'Erro ao executar consulta: ' + E.Message;
          FreeAndNil(qry);
        end;
      end;
    end;
  except
    on Ex: Exception do
    begin
      erro := 'Erro ao preparar consulta: ' + Ex.Message;
      if Assigned(qry) then
        FreeAndNil(qry);
    end;
  end;
end;

function TProjetotelefonica.UpdateStatusFaturamento(const id: String; const statusFaturamento: String; out Erro: string): Boolean;
var
  qry: TFDQuery;
  iID: Integer;
begin
  Result := False;
  Erro := '';
  qry := nil;

  try
    try
      // Validação dos parâmetros de entrada
      if Trim(id) = '' then
        raise Exception.Create('ID não pode ser vazio');

      if Trim(statusFaturamento) = '' then
        raise Exception.Create('Status de faturamento não pode ser vazio');

      // Converter ID para inteiro antes de usar
      iID := StrToInt(id);

      // Criar e configurar a query
      qry := TFDQuery.Create(nil);
      try
        qry.Connection := FConn;
        qry.SQL.Text := 'UPDATE telefonicacontrolet2 ' +
                        'SET statusfaturamento = :statusfaturamento ' +
                        'WHERE id = :id';

        // Atribuir parâmetros
        qry.ParamByName('statusfaturamento').AsString := statusFaturamento;
        qry.ParamByName('id').AsInteger := iID;

        // Iniciar transação para garantir a atomicidade
        if FConn.InTransaction then
          FConn.Commit;

        FConn.StartTransaction;

        try
          qry.ExecSQL;

          // Commit explícito
          FConn.Commit;

          // Verificar se alguma linha foi afetada
          if qry.RowsAffected = 0 then
          begin
            Writeln('AVISO: Nenhum registro encontrado com ID: ' + id);
            // Não consideramos como erro, apenas informamos
            Result := True;
          end
          else
          begin
            Writeln('Sucesso: Registro atualizado. Linhas afetadas: ' + IntToStr(qry.RowsAffected));
            Result := True;
          end;
        except
          on E: Exception do
          begin
            FConn.Rollback;
            raise;
          end;
        end;
      finally
        qry.Free;
      end;
    except
      on E: EConvertError do
        Erro := 'Erro de conversão: ID deve ser um número válido';
      on E: Exception do
      begin
        Erro := 'Erro ao atualizar status de faturamento: ' + E.Message;
        Writeln('ERRO: ' + Erro);
        Result := False;
      end;
    end;
  except
    on E: Exception do
    begin
      Erro := 'Erro geral: ' + E.Message;
      Result := False;
    end;
  end;
end;



function TProjetotelefonica.ListPrevisaoFechamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('acionamentovivo.id, ');
      SQL.Add('acionamentovivo.idpmts, ');
      SQL.Add('lpuvivo.UF As regional, ');
      SQL.Add('acionamentovivo.po, ');
      SQL.Add('telefonicacontrolet2.T2DESCRICAOCOD As atividade, ');
      SQL.Add('acionamentovivo.quantidade, ');
      SQL.Add('lpuvivo.BREVEDESCRICAO As tarefas, ');
      SQL.Add('acionamentovivo.valor, ');
      SQL.Add('acionamentovivo.dataacionamento, ');
      SQL.Add('acionamentovivo.dataenvioemail, ');
      SQL.Add('gesempresas.nome, ');
      SQL.Add('rolloutvivo.pmosigla, ');
      SQL.Add('rolloutvivo.ufsigla, ');
      SQL.Add('rolloutvivo.EntregaRequest, ');
      SQL.Add('rolloutvivo.EntregaPlan, ');
      SQL.Add('rolloutvivo.EntregaReal, ');
      SQL.Add('rolloutvivo.FimInstalacaoPlan, ');
      SQL.Add('rolloutvivo.FimInstalacaoReal, ');
      SQL.Add('rolloutvivo.IntegracaoPlan, ');
      SQL.Add('rolloutvivo.IntegracaoReal, ');
      SQL.Add('rolloutvivo.Ativacao, ');
      SQL.Add('rolloutvivo.Documentacao, ');
      SQL.Add('rolloutvivo.DTPlan, ');
      SQL.Add('rolloutvivo.DTReal, ');
      SQL.Add('rolloutvivo.VistoriaPlan, ');
      SQL.Add('rolloutvivo.VistoriaReal, ');
      SQL.Add('rolloutvivo.InitialTunningPlan, ');
      SQL.Add('rolloutvivo.InitialTunningReal, ');
      SQL.Add('rolloutvivo.InitialTunningRealFinal, ');
      SQL.Add('rolloutvivo.initialtunnigstatus, ');
      SQL.Add('rolloutvivo.AprovacaoSSV, ');
      SQL.Add('rolloutvivo.StatusAprovacaoSSV, ');
      SQL.Add('rolloutvivo.DataImprodutiva, ');
      SQL.Add('rolloutvivo.StatusObra, ');
      SQL.Add('lpuvivo.codigolpuvivo, ');
      SQL.Add('acionamentovivo.fechamento, ');
      SQL.Add('acionamentovivo.porcentagem, rolloutvivo.deletado  ');
      SQL.Add('From ');
      SQL.Add('acionamentovivo left Join ');
      SQL.Add('telefonicacontrolet2 On telefonicacontrolet2.ID = acionamentovivo.idatividade left Join ');
      SQL.Add('lpuvivo On lpuvivo.ID = acionamentovivo.idpacote left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = acionamentovivo.idcolaborador left Join ');
      SQL.Add('rolloutvivo On rolloutvivo.UIDIDPMTS = acionamentovivo.idpmts ');
      SQL.Add('Where ');
      SQL.Add('acionamentovivo.deletado = 0 and (');
      SQL.Add('(rolloutvivo.FimInstalacaoReal is not null and rolloutvivo.FimInstalacaoReal <> "1899-12-30") or');
      SQL.Add('(rolloutvivo.EntregaReal is not null and rolloutvivo.EntregaReal <> "1899-12-30") or');
      SQL.Add('(rolloutvivo.DTReal is not null and rolloutvivo.DTReal <> "1899-12-30") or');
      SQL.Add('(rolloutvivo.VistoriaReal is not null and rolloutvivo.VistoriaReal <> "1899-12-30")');
      SQL.Add(') and acionamentovivo.porcentagem < 1');
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


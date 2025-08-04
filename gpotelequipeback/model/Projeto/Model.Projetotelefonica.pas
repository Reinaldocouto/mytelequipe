unit Model.Projetotelefonica;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection, ComObj,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections, UtFuncao,
  DateUtils, System.JSON, System.Classes;

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
    Ftotalhorasclt: Double;
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
    FEntregaPlan: string;
    FEntregaReal: string;
    FFimInstalacaoPlan: string;
    FFimInstalacaoReal: string;
    FIntegracaoPlan: string;
    FIntegracaoReal: string;
    FAtivacao: string;
    FDocumentacao: string;
    FDTPlan: string;
    FDTReal: string;
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
    property idpacote: Integer read Fidpacote write Fidpacote;
    property idcolaborador: Integer read Fidcolaborador write Fidcolaborador;
    property idpmts: string read Fidpmts write Fidpmts;
    property idfuncionario: Integer read Fidfuncionario write Fidfuncionario;
    property datainicioclt: string read Fdatainicioclt write Fdatainicioclt;
    property datafinalclt: string read Fdatafinalclt write Fdatafinalclt;
    property totalhorasclt: double read Ftotalhorasclt write Ftotalhorasclt;
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
    property DTPlan: string read FDTPlan write FDTPlan;
    property DTReal: string read FDTReal write FDTReal;
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

    property idusuario: string read Fidusuario write Fidusuario;

    property regionalocal: string read Fregionalocal write Fregionalocal;
    property brevedescricao: string read Frevedescricao write Frevedescricao;

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
  valorp, porcent, valorpg: Real;
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
        ParamByName('valorpago').AsFloat := valorp * (porcentagem / 100);
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
        SQL.Add('update acionamentovivo set porcentagem = porcentagem + :porce, valorpago = valorpago + :vp where id=:id  ');
        ParamByName('id').asinteger := idgeralfechamento;
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
      Add('  acionamentovivo.porcentagem,');
      Add('  rolloutvivo.entregareal,');
      Add('  rolloutvivo.fiminstalacaoreal,');
      Add('  rolloutvivo.integracaoreal,');
      Add('  rolloutvivo.dtreal,');
      Add('  rolloutvivo.vistoriareal,');
      Add('  rolloutvivo.ativacao,');
      Add('  rolloutvivo.documentacao,');
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
      if ((AQuery.Items['idcolaborador'].ToInteger = 140) or (AQuery.Items['idcolaborador'].ToInteger = 144) or (AQuery.Items['idcolaborador'].ToInteger = 87)or (AQuery.Items['idcolaborador'].ToInteger = 322)) then
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
        SQL.Add('EntregaPlan=:EntregaPlan,  ');
        SQL.Add('EntregaReal=:EntregaReal,  ');
        SQL.Add('FimInstalacaoPlan=:FimInstalacaoPlan,  ');
        SQL.Add('FimInstalacaoReal=:FimInstalacaoReal,  ');
        SQL.Add('IntegracaoPlan=:IntegracaoPlan,  ');
        SQL.Add('IntegracaoReal=:IntegracaoReal,  ');
        SQL.Add('Ativacao=:Ativacao,  ');
        SQL.Add('Documentacao=:Documentacao,  ');
        SQL.Add('DTPlan=:DTPlan,  ');
        SQL.Add('DTReal=:DTReal,  ');
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
        SQL.Add('Rollout=:Rollout, equipe=:equipe ');
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
        ParamByName('acessosolicitacao').asstring := acessosolicitacao;
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
          ParamByName('DTPlan').AsDateTime := ISO8601ToDate(DTPlan);
        except
          ParamByName('DTPlan').asstring := '1899-12-30';

        end;
        try
          ParamByName('DTReal').AsDateTime := ISO8601ToDate(DTReal);
        except
          ParamByName('DTReal').asstring := '1899-12-30';

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
        ParamByName('infravivo').asstring := infravivo;
        ExecSQL;
      end;

      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao salvar projeto TELEFONCIA: ' + ex.Message;
        Result := false;
      end;
    end;

  finally
    qry.Free;
  end;
end;

function TProjetotelefonica.Editart2(out erro: string): Boolean;
var
  qry, qry1, qry2: TFDQuery;
  cont: Integer;
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
        SQL.Add('insert into telefonicacontrolet2(empresa,site,itemt2,codfornecedor,fabricante,numerodocontrato,t2codmatservsw,t2descricaocod,vlrunitarioliqliq, ');
        SQL.Add('vlrunitarioliq,quant,unid,vlrunitariocimposto,vlrcimpsicms,vlrtotalcimpostos,itemt4,t4codeqmatswserv,t4descricaocod, ');
        SQL.Add('pepnivel2,idlocalidade,pepnivel3,descricaoobra,idobra,enlace,gestor,tipo,responsavel,categoria,tecnologia) ');
        SQL.Add('                         values(:empresa,:site,:itemt2,:codfornecedor,:fabricante,:numerodocontrato,:t2codmatservsw,:t2descricaocod,:vlrunitarioliqliq, ');
        SQL.Add(':vlrunitarioliq,:quant,:unid,:vlrunitariocimposto,:vlrcimpsicms,:vlrtotalcimpostos,:itemt4,:t4codeqmatswserv,:t4descricaocod, ');
        SQL.Add(':pepnivel2,:idlocalidade,:pepnivel3,:descricaoobra,:idobra,:enlace,:gestor,:tipo,:responsavel,:categoria,:tecnologia) ');
        ParamByName('empresa').AsString := qry.fieldbyname('empresa').asstring;
        ParamByName('site').AsString := qry1.fieldbyname('PMO_sigla').asstring;
        ParamByName('itemt2').AsString := '0';
        ParamByName('codfornecedor').AsString := qry.fieldbyname('CODFORNECEDOR').asstring;
        ParamByName('fabricante').AsString := 'TELEQUIPE';
        ParamByName('numerodocontrato').AsString := qry.fieldbyname('NUMERODOCONTRATO').asstring;
        ParamByName('t2codmatservsw').AsString := qry.fieldbyname('T2CODMATSERVSW').asstring;
        ParamByName('t2descricaocod').AsString := qry.fieldbyname('T2DESCRICAOCOD').asstring;
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
        SQL.Add('Select consolidadotelefonica.PO From consolidadotelefonica where id=:id');
        ParamByName('id').AsInteger := idatividade;
        Open();
        polocal := fieldbyname('PO').asstring;

        active := false;
        SQL.Clear;
        SQL.Add('insert into acionamentovivoclt(po,atividade,idatividade,idcolaborador,idpacote,valor,dataacionamento,');
        SQL.Add('idfuncionario,deletado,idrollout,idpmts,dataincio,datafinal,horanormal,horas50,horas100,totaldehoras) ');
        SQL.Add('                     VALUES(:po,:atividade,:idatividade,:idcolaborador,:idpacote,:valor,:dataacionamento,');
        SQL.Add(':idfuncionario,:deletado,:idrollout,:idpmts,:dataincio,:datafinal,:horanormal,:horas50,:horas100,:totaldehoras) ');
        ParamByName('po').asstring := polocal;
        ParamByName('idcolaborador').asinteger := idcolaborador;
        ParamByName('idatividade').asinteger := idatividade;
        ParamByName('idpacote').asinteger := idpacote;
        ParamByName('valor').asfloat := 0;
        ParamByName('atividade').asstring := atividade;
        ParamByName('dataacionamento').AsDateTime := now;
        ParamByName('idfuncionario').asinteger := idfuncionario;
        ParamByName('deletado').asinteger := 0;
        ParamByName('idrollout').asinteger := idrollout;
        ParamByName('idpmts').asString := idpmts;
        try
          ParamByName('dataincio').Asstring := datainicioclt;
        except
          ParamByName('dataincio').AsDateTime := StrToDate('30/12/1899');
        end;
        try
          ParamByName('datafinal').Asstring := datafinalclt;
        except
          ParamByName('datafinal').AsDateTime := StrToDate('30/12/1899');
        end;

        ParamByName('horanormal').asfloat := horanormalclt;
        ParamByName('horas50').asfloat := hora50clt;
        ParamByName('horas100').asfloat := hora100clt;
        ParamByName('totaldehoras').asfloat := totalhorasclt;
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
        erro := 'Erro fazer lançamento: ' + ex.Message;
        Result := false;
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

function TProjetotelefonica.listat2(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a, b, pesquisa: string;
begin

  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select  ');
      SQL.Add('* ');
      SQL.Add('from ');
      SQL.Add('telefonicacontrolet2 where idobra=:idobra');
      ;
      ParamByName('idobra').asstring := AQuery.Items['idobraloca'];
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
      SQL.Add('COUNT(CASE WHEN vistoriaplan       IS NOT NULL AND vistoriaplan       <> ''1899-12-30'' THEN 1 END) AS vistoriaplan, ');
      SQL.Add('COUNT(CASE WHEN vistoriareal       IS NOT NULL AND vistoriareal       <> ''1899-12-30'' THEN 1 END) AS vistoriareal, ');
      SQL.Add('COUNT(CASE WHEN EntregaPlan        IS NOT NULL AND EntregaPlan        <> ''1899-12-30'' THEN 1 END) AS EntregaPlan, ');
      SQL.Add('COUNT(CASE WHEN EntregaReal        IS NOT NULL AND EntregaReal        <> ''1899-12-30'' THEN 1 END) AS EntregaReal, ');
      SQL.Add('COUNT(CASE WHEN FimInstalacaoPlan  IS NOT NULL AND FimInstalacaoPlan  <> ''1899-12-30'' THEN 1 END) AS FimInstalacaoPlan, ');
      SQL.Add('COUNT(CASE WHEN FimInstalacaoReal  IS NOT NULL AND FimInstalacaoReal  <> ''1899-12-30'' THEN 1 END) AS FimInstalacaoReal, ');
      SQL.Add('COUNT(CASE WHEN IntegracaoPlan     IS NOT NULL AND IntegracaoPlan     <> ''1899-12-30'' THEN 1 END) AS IntegracaoPlan, ');
      SQL.Add('COUNT(CASE WHEN IntegracaoReal     IS NOT NULL AND IntegracaoReal     <> ''1899-12-30'' THEN 1 END) AS IntegracaoReal, ');
      SQL.Add('COUNT(CASE WHEN initialtunningplan     IS NOT NULL AND initialtunningplan     <> ''1899-12-30'' THEN 1 END) AS Initialtunningplan, ');
      SQL.Add('COUNT(CASE WHEN initialtunningreal     IS NOT NULL AND initialtunningreal     <> ''1899-12-30'' THEN 1 END) AS initialtunningreal, ');
      SQL.Add('COUNT(CASE WHEN DTPlan             IS NOT NULL AND DTPlan             <> ''1899-12-30'' THEN 1 END) AS DTPlan, ');
      SQL.Add('COUNT(CASE WHEN DTReal             IS NOT NULL AND DTReal             <> ''1899-12-30'' THEN 1 END) AS DTReal ');
      SQL.Add('FROM ');
      SQL.Add('  rolloutvivo where deletado = 0 ');
      if ((regional <> 'Todos') and (regional <> '')) then
        SQL.Add(' and pmoregional in (' + QuotedCSV(regional) + ')');
      if ((idpmts <> 'Todos') and (idpmts <> '')) then
        SQL.Add(' and UIDIDPMTS in (' + QuotedCSV(idpmts) + ')');
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
      SQL.Add('Select ');
      SQL.Add('* ');
      SQL.Add('From ');
      SQL.Add('telefonicacontrolet2 where IDObra=:idpmts ');
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
      SQL.Add('rolloutvivo where deletado = 0 ');
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
      SQL.Add('rolloutvivo.acessosolicitacao, ');
      SQL.Add('rolloutvivo.acessodatasolicitacao, ');
      SQL.Add('rolloutvivo.acessodatainicial, ');
      SQL.Add('rolloutvivo.acessodatafinal, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.EntregaPlan, ''%Y-%m-%d'') as EntregaPlan, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.EntregaReal, ''%Y-%m-%d'') as EntregaReal, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.FimInstalacaoPlan, ''%Y-%m-%d'') as FimInstalacaoPlan, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.FimInstalacaoReal, ''%Y-%m-%d'') as FimInstalacaoReal, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.IntegracaoPlan, ''%Y-%m-%d'') as IntegracaoPlan, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.IntegracaoReal, ''%Y-%m-%d'') as IntegracaoReal, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.Ativacao, ''%Y-%m-%d'') as Ativacao, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.Documentacao, ''%Y-%m-%d'') as Documentacao, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.DTPlan, ''%Y-%m-%d'') as DTPlan, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.DTReal, ''%Y-%m-%d'') as DTReal, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.vistoriaplan, ''%Y-%m-%d'') as vistoriaplan, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.vistoriareal, ''%Y-%m-%d'') as vistoriareal, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.docplan, ''%Y-%m-%d'') as docplan, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.docvitoriareal, ''%Y-%m-%d'') as docvitoriareal, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.req, ''%Y-%m-%d'') as req, ');
      SQL.Add('rolloutvivo.resumodafase, ');
      SQL.Add('rolloutvivo.Rollout, ');
      SQL.Add('rolloutvivo.infravivo, ');
      SQL.Add('rolloutvivo.equipe, ');
      SQL.Add('rolloutvivo.acompanhamentofisicoobservacao, ');
      SQL.Add('UPPER(rolloutvivo.StatusObra) as statusobra, ');
      SQL.Add('DATE_FORMAT(rolloutvivo.docaplan, ''%Y-%m-%d'') as docaplan, ');
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
    {  SQL.Add('select  ');
      SQL.Add('acionamentovivo.id, ');
      SQL.Add('gesempresas.nome, ');
      SQL.Add('consolidadotelefonica.po, ');
      SQL.Add('consolidadotelefonica.t2codmatservsw, ');
      SQL.Add('consolidadotelefonica.t2descricaocod, ');
      SQL.Add('consolidadotelefonica.atividade, ');
      SQL.Add('consolidadotelefonica.codservico, ');
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
      SQL.Add('gesempresas on gesempresas.idempresa = acionamentovivo.idcolaborador inner join ');
      SQL.Add('consolidadotelefonica on consolidadotelefonica.id = acionamentovivo.idatividade inner join ');
      SQL.Add('lpuvivo on acionamentovivo.idpacote = lpuvivo.id where acionamentovivo.idrollout =:idr and  acionamentovivo.deletado = 0  ');

      }


      SQL.Add('select  ');
      SQL.Add('acionamentovivo.id, ');
      SQL.Add('gesempresas.nome, ');
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
      SQL.Add('gesempresas on gesempresas.idempresa = acionamentovivo.idcolaborador inner join ');
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
      SQL.Add('rolloutvivo.DTPlan, ');
      SQL.Add('rolloutvivo.DTReal, ');
      SQL.Add('rolloutvivo.VistoriaPlan, ');
      SQL.Add('rolloutvivo.VistoriaReal, ');
      SQL.Add('rolloutvivo.InitialTunningPlan, ');
      SQL.Add('rolloutvivo.InitialTunningReal, ');
      SQL.Add('rolloutvivo.StatusObra, ');
      SQL.Add('lpuvivo.codigolpuvivo, ');
      SQL.Add('acionamentovivo.fechamento, ');
      SQL.Add('acionamentovivo.porcentagem  ');
      SQL.Add('From ');
      SQL.Add('acionamentovivo left Join ');
      SQL.Add('telefonicacontrolet2 On telefonicacontrolet2.ID = acionamentovivo.idatividade left Join ');
      SQL.Add('lpuvivo On lpuvivo.ID = acionamentovivo.idpacote left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = acionamentovivo.idcolaborador left Join ');
      SQL.Add('rolloutvivo On rolloutvivo.UIDIDPMTS = acionamentovivo.idpmts ');
      SQL.Add('Where ');
      SQL.Add('acionamentovivo.deletado = 0 ');
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
      Add('rolloutvivo.DTPlan AS DTPlan, ');
      Add('rolloutvivo.DTReal AS DTReal, ');
      Add('rolloutvivo.initialtunningreal, ');
      Add('rolloutvivo.vistoriareal, ');
      Add('rolloutvivo.StatusObra AS StatusObra, ');
      Add('lpuvivo.CODIGOLPUVIVO AS CODIGOLPUVIVO, ');
      Add('acionamentovivo.idcolaborador AS idcolaborador, ');
      Add('telefonicapagamento.tipopagamento  AS status, ');
      Add('coalesce(Sum(telefonicapagamento.valorpagamento),0) As valorpago, ');
      Add('coalesce(Sum(telefonicapagamento.porcentagem),0) As porcentagem ');
      Add('FROM acionamentovivo ');
      Add('LEFT JOIN telefonicapagamento ON telefonicapagamento.idacionamentovivo = acionamentovivo.id ');
      Add('LEFT JOIN telefonicacontrolet2 ON telefonicacontrolet2.ID = acionamentovivo.idatividade ');
      Add('LEFT JOIN lpuvivo ON lpuvivo.ID = acionamentovivo.idpacote ');
      Add('LEFT JOIN gesempresas ON gesempresas.idempresa = acionamentovivo.idcolaborador ');
      Add('LEFT JOIN rolloutvivo ON rolloutvivo.UIDIDPMTS = acionamentovivo.idpmts ');
      Add('WHERE acionamentovivo.deletado = 0 ');
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

function TProjetotelefonica.Listaacionamentoclt(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('acionamentovivoclt.po,     acionamentovivoclt.id, ');
      SQL.Add('consolidadotelefonica.T2CODMATSERVSW, ');
      SQL.Add('gespessoa.nome, ');
      SQL.Add('acionamentovivoclt.dataacionamento, ');
      SQL.Add('acionamentovivoclt.atividade, ');
      SQL.Add('acionamentovivoclt.dataincio, ');
      SQL.Add('acionamentovivoclt.datafinal ');
      SQL.Add('From ');
      SQL.Add('acionamentovivoclt left Join ');
      SQL.Add('consolidadotelefonica On consolidadotelefonica.id = acionamentovivoclt.idatividade left Join ');
      SQL.Add('gespessoa On gespessoa.idpessoa = acionamentovivoclt.idcolaborador where acionamentovivoclt.deletado = 0 and acionamentovivoclt.idrollout =:idr  ');
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
      Result := nil;
    end;
  end;
end;

end.


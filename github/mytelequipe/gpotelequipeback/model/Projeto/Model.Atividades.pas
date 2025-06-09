unit Model.Atividades;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections, UtFuncao;

type
  TAtividades = class
  private
    FConn: TFDConnection;
    Fnumero: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    property numero: Integer read Fnumero write Fnumero;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaSelect(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaAtividadesPO(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaAtividadesMIGO(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
  end;

implementation

{ TAtividades }

constructor TAtividades.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TAtividades.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;


function TAtividades.ListaSelect(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  A : string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('obraericssonmigo.poritem as value, ');
      SQL.Add('obraericssonmigo.po, ');
      SQL.Add('obraericssonmigo.poritem as label, ');
      SQL.Add('obraericssonmigo.datacriacaopo, ');
      SQL.Add('obraericssonmigo.escopo, ');
      SQL.Add('obraericssonmigo.codigoservico, ');
      SQL.Add('obraericssonmigo.descricaoservico, ');
      SQL.Add('obraericssonmigo.qtyordered, ');
      SQL.Add('obraericsson.coordenadoaspnome, ');
      SQL.Add('obraericsson.gestordeimplantacaonome, ');
      SQL.Add('obraericssonmigo.medidafiltro, ');
      SQL.Add('obraericssonmigo.medidafiltrounitario ');
      SQL.Add('From ');
      SQL.Add('obraericssonmigo,obraericsson ');
      SQL.Add('where obraericsson.numero =:numero and obraericssonmigo.id like ''%' + AQuery.Items['idlocal'] + '%'' order by poritem ');
      parambyname('numero').asstring := AQuery.Items['idlocal'];
      a :=AQuery.Items['idlocal'];
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


function TAtividades.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obraericsson.numero as id, ');
      SQL.Add('obraericsson.rfp, ');
      SQL.Add('obraericsson.cliente, ');
      SQL.Add('obraericsson.regiona, ');
      SQL.Add('obraericsson.site, ');
      SQL.Add('obraericsson.fornecedor, ');
      SQL.Add('obraericsson.situacaoimplantacao, ');
      SQL.Add('obraericsson.situacaodaintegracao, ');
      SQL.Add('obraericsson.datadacriacaodademandadia, ');
      SQL.Add('obraericsson.datalimiteaceitedia, ');
      SQL.Add('obraericsson.dataaceitedemandadia, ');
      SQL.Add('obraericsson.datainicioprevistasolicitantebaselinemosdia, ');
      SQL.Add('obraericsson.datainicioentregamosplanejadodia, ');
      SQL.Add('obraericsson.datarecebimentodositemosreportadodia, ');
      SQL.Add('obraericsson.datafimprevistabaselinefiminstalacaodia, ');
      SQL.Add('obraericsson.datafiminstalacaoplanejadodia, ');
      SQL.Add('obraericsson.dataconclusaoreportadodia, ');
      SQL.Add('obraericsson.datavalidacaoinstalacaodia, ');
      SQL.Add('obraericsson.dataintegracaobaselinedia, ');
      SQL.Add('obraericsson.dataintegracaoplanejadodia, ');
      SQL.Add('obraericsson.datavalidacaoeriboxedia, ');
      SQL.Add('obraericsson.listadepos, ');
      SQL.Add('obraericsson.gestordeimplantacaonome, ');
      SQL.Add('obraericsson.statusrsa, ');
      SQL.Add('obraericsson.rsarsa, ');
      SQL.Add('obraericsson.statusaceitacao, ');
      SQL.Add('obraericsson.datadefimdaaceitacaosydledia, ');
      SQL.Add('obraericsson.ordemdevenda, ');
      SQL.Add('obraericsson.coordenadoaspnome, ');
      SQL.Add('obraericsson.rsavalidacaorsanrotrackerdatafimdia, ');
      SQL.Add('obraericsson.fimdeobraplandia, ');
      SQL.Add('obraericsson.fimdeobrarealdia, ');
      SQL.Add('obraericsson.tipoatualizacaofam, ');
      SQL.Add('obraericsson.sinergia, ');
      SQL.Add('obraericsson.sinergia5g, ');
      SQL.Add('obraericsson.escoponome, ');
      SQL.Add('obraericsson.slapadraoescopodias, ');
      SQL.Add('obraericsson.tempoparalisacaoinstalacaodias, ');
      SQL.Add('obraericsson.localizacaositeendereco, ');
      SQL.Add('obraericsson.localizacaositecidade, ');
      SQL.Add('obraericsson.documentacaosituacao, ');
      SQL.Add('obraericsson.sitepossuirisco ');
      SQL.Add('From ');
      SQL.Add('obraericsson ');
      SQL.Add(' WHERE obraericsson.Numero is not null ');
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


function TAtividades.Listaid(const AQuery: TDictionary<string, string>;
  out erro: string): TFDQuery;
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
      SQL.Add(' * ');
      SQL.Add('From ');
      SQL.Add('obraericsson ');
      SQL.Add(' WHERE obraericsson.Numero is not null and numero=:numero ');
      ParamByName('numero').asinteger := AQuery.Items['idprojetoericsson'].ToInteger;
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

function TAtividades.ListaAtividadesMIGO(const AQuery: TDictionary<string, string>;
  out erro: string): TFDQuery;
var
  qry: TFDQuery;
  A : string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('obraericssonmigo.poritem as id, ');
      SQL.Add('obraericsson.numero, ');
      SQL.Add('obraericsson.cliente, ');
      SQL.Add('obraericsson.regiona, ');
      SQL.Add('obraericsson.site,obraericssonmigo.siteid, ');
      SQL.Add('obraericssonmigo.po, ');
      SQL.Add('obraericssonmigo.poritem, ');
      SQL.Add('obraericssonmigo.datacriacaopo, ');
      SQL.Add('obraericssonmigo.escopo, ');
      SQL.Add('obraericssonmigo.codigoservico, ');
      SQL.Add('obraericssonmigo.descricaoservico, ');
      SQL.Add('obraericssonmigo.qtyordered, ');
      SQL.Add('obraericsson.coordenadoaspnome, ');
      SQL.Add('obraericsson.gestordeimplantacaonome, ');
      SQL.Add('obraericssonmigo.medidafiltro, ');
      SQL.Add('obraericssonmigo.medidafiltrounitario ');
      SQL.Add('From ');
      SQL.Add('obraericssonmigo,obraericsson ');
      SQL.Add('where obraericsson.numero =:numero and obraericssonmigo.id like ''%' + AQuery.Items['idlocal'] + '%'' order by poritem ');
      parambyname('numero').asstring := AQuery.Items['idlocal'];
      a :=AQuery.Items['idlocal'];
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

function TAtividades.ListaAtividadesPO(const AQuery: TDictionary<string, string>;
  out erro: string): TFDQuery;
var
  qry: TFDQuery;
  A : string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('obraericssonlistapo.id, ');
      SQL.Add('obraericssonlistapo.seed, ');
      SQL.Add('obraericssonlistapo.site, ');
      SQL.Add('obraericssonlistapo.cliente, ');
      SQL.Add('obraericssonlistapo.regional, ');
      SQL.Add('obraericssonlistapo.filtrorfp, ');
      SQL.Add('obraericssonlistapo.fornecedor, ');
      SQL.Add('obraericssonlistapo.statusobra, ');
      SQL.Add('obraericssonlistapo.statusdoc, ');
      SQL.Add('obraericssonlistapo.po, ');
      SQL.Add('obraericssonlistapo.item, ');
      SQL.Add('obraericssonlistapo.criacaopo, ');
      SQL.Add('obraericssonlistapo.descricao, ');
      SQL.Add('obraericssonlistapo.qtd, ');
      SQL.Add('obraericssonlistapo.grqtd, ');
      SQL.Add('obraericssonlistapo.datamigo, ');
      SQL.Add('obraericssonlistapo.poativa, ');
      SQL.Add('obraericssonlistapo.aprovacaocpm, ');
      SQL.Add('obraericssonlistapo.grdocno, ');
      SQL.Add('obraericssonlistapo.pendenciaobra ');
      SQL.Add('From ');
      SQL.Add('obraericssonlistapo ');
      SQL.Add(' WHERE obraericssonlistapo.site =:site order by po,item ');
      a := AQuery.Items['sitelocal'];
      ParamByName('site').AsString := AQuery.Items['sitelocal'];
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


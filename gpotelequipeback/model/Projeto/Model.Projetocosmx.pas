unit Model.Projetocosmx;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection, ComObj,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections, UtFuncao;

type
  TProjetocosmx = class
  private
    FConn: TFDConnection;
    Fnumero: Integer;
    Fidempresa: Integer;
    Flpu: string;
    Finicioatividadeplanejado: string;
    Finicioatividadereal: string;
    Fnomerelatorioenviado1: string;
    Fdataenvio1: string;
    Fenviadopor1: string;
    Fstatus1: string;
    Fnomerelatorioenviado2: string;
    Fdataenvio2: string;
    Fenviadopor2: string;
    Fstatus2: string;
    Faprovacaocosmx: string;
    Fvalorlpu: double;
    Fmesfechamento: string;
    Fidgeralfechamento: Integer;
    Fdataenviofechamento: string;
    Fobservacao: string;
    Fporcentagem: Integer;
    Fvalor: Double;
    Frepostaalteracao: Integer;
    Fsiteid: string;
    Fsitefromto: string;
    Fuf: string;
    Fregion: string;
    FInfrasyte: string;
    Ftypesite: string;
    Fbatsw: string;
    FQty: string;
    FOwner1: string;
    FInstalledBy: string;
    FCity: string;
    FAddress: string;
    Fnotafiscal: string;
    Fid: string;

  public
    constructor Create;
    destructor Destroy; override;

    property numero: Integer read Fnumero write Fnumero;
    property idempresa: Integer read Fidempresa write Fidempresa;
    property lpu: string read Flpu write Flpu;
    property inicioatividadeplanejado: string read Finicioatividadeplanejado write Finicioatividadeplanejado;
    property inicioatividadereal: string read Finicioatividadereal write Finicioatividadereal;
    property nomerelatorioenviado1: string read Fnomerelatorioenviado1 write Fnomerelatorioenviado1;
    property dataenvio1: string read Fdataenvio1 write Fdataenvio1;
    property enviadopor1: string read Fenviadopor1 write Fenviadopor1;
    property status1: string read Fstatus1 write Fstatus1;
    property nomerelatorioenviado2: string read Fnomerelatorioenviado2 write Fnomerelatorioenviado2;
    property dataenvio2: string read Fdataenvio2 write Fdataenvio2;
    property enviadopor2: string read Fenviadopor2 write Fenviadopor2;
    property status2: string read Fstatus2 write Fstatus2;
    property aprovacaocosmx: string read Faprovacaocosmx write Faprovacaocosmx;
    property valorlpu: double read Fvalorlpu write Fvalorlpu;
    property mesfechamento: string read Fmesfechamento write Fmesfechamento;
    property observacao: string read Fobservacao write Fobservacao;
    property dataenviofechamento: string read Fdataenviofechamento write Fdataenviofechamento;
    property idgeralfechamento: Integer read Fidgeralfechamento write Fidgeralfechamento;
    property porcentagem: Integer read Fporcentagem write Fporcentagem;
    property valor: double read Fvalor write Fvalor;
    property repostaalteracao: Integer read Frepostaalteracao write Frepostaalteracao;

    property siteid: string read Fsiteid write Fsiteid;
    property sitefromto: string read Fsitefromto write Fsitefromto;
    property uf: string read Fuf write Fuf;
    property region: string read Fregion write Fregion;
    property Infrasyte: string read FInfrasyte write FInfrasyte;
    property typesite: string read Ftypesite write Ftypesite;
    property batsw: string read Fbatsw write Fbatsw;
    property Qty: string read FQty write FQty;
    property Owner1: string read FOwner1 write FOwner1;
    property InstalledBy: string read FInstalledBy write FInstalledBy;
    property City: string read FCity write FCity;
    property Address: string read FAddress write FAddress;
    property notafiscal: string read Fnotafiscal write Fnotafiscal;
    property id: string read Fid write Fid;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listapo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function listagemlpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listalpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaFechamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaFechamentoporempresa(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function consultapagamento: Boolean;
    function Editarpagamento(out erro: string): Boolean;
    function excluirpagamento(out erro: string): Boolean;
    function historicopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function extratopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function extratopagamentototal(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function extratopagamentodesconto(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function demonstrativocosmx(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function relatorioconsolidadocosmx(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function relatoriohistoricopagamentocosmx(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function relatoriocontrolecosmx(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;

  end;

implementation

{ TProjetoericsson }

constructor TProjetocosmx.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TProjetocosmx.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TProjetocosmx.demonstrativocosmx(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := False;
      SQL.Clear;
    {  sql.add('SET @contador := 0; ');
      sql.add('SELECT ');
      sql.add('@contador := @contador + 1 AS id, ');
      SQL.Add('CASE WHEN (obracosmx.region = '''') OR (obracosmx.region IS NULL) THEN ''VAZIO'' ELSE obracosmx.region END AS regiao, ');
      SQL.Add('COUNT(obracosmx.id) AS planejado, ');
      SQL.Add('COUNT(obracosmx.PO) AS compo, ');
      SQL.Add('COUNT(obracosmx.id) - COUNT(obracosmx.PO) AS sempo ');
      SQL.Add('FROM obracosmx ');
      SQL.Add('GROUP BY obracosmx.region ');
      SQL.Add('ORDER BY regiao;');
      Active := True;     }


      sql.add('SET @contador := 0; ');
      sql.add('SELECT ');
      sql.add('@contador := @contador + 1 AS id, ');
      SQL.Add('CASE WHEN (obracosmx.region = '''') OR (obracosmx.region IS NULL) THEN ''VAZIO'' ELSE obracosmx.region END AS regiao, ');
      SQL.Add('COUNT(obracosmx.id) AS planejado, ');
      SQL.Add('COUNT(CASE WHEN obracosmx.dataenvio1 IS not NULL OR obracosmx.dataenvio1 <> '''' THEN obracosmx.PO END) AS compo, ');
      SQL.Add('COUNT(CASE WHEN obracosmx.dataenvio1 IS not NULL OR obracosmx.dataenvio1 <> '''' THEN obracosmx.id END) - ');
      SQL.Add('COUNT(CASE WHEN obracosmx.dataenvio1 IS not NULL OR obracosmx.dataenvio1 <> '''' THEN obracosmx.PO END) AS sempo ');
      SQL.Add('FROM obracosmx ');
      SQL.Add('GROUP BY obracosmx.region ');
      SQL.Add('ORDER BY regiao');
      Active := True;

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

function TProjetocosmx.Editarpagamento(out erro: string): Boolean;
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
        sql.Add('update obracosmx set fechamento=:fechamento, porcentagem =:porcentagem, dataenviofechamento=:dataenviofechamento, valor=:valor where id=:idfechamento');
        parambyname('fechamento').asstring := mesfechamento;
        parambyname('porcentagem').AsInteger := porcentagem;
        ParamByName('dataenviofechamento').asstring := dataenviofechamento;
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

function TProjetocosmx.excluirpagamento(out erro: string): Boolean;
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
        sql.Add('update obracosmx set fechamento=:fechamento where id=:idfechamento');
        ParamByName('fechamento').asstring := '0';
        parambyname('idfechamento').asstring := id;
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

function TProjetocosmx.extratopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obracosmx.id, ');
      SQL.Add('obracosmx.*, ');
      SQL.Add('obracosmxlpu.geral as value, ');
      SQL.Add('CONCAT(obracosmxlpu.historico,'' - '',obracosmxlpu.localidade) as label, gesempresas.nome  ');
      SQL.Add('From ');
      SQL.Add('obracosmx left Join ');
      SQL.Add('obracosmxlpu On obracosmxlpu.CODIGO = obracosmx.lpu left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obracosmx.idempresa  where obracosmx.aprovacaocosmx Is Not Null and ((obracosmx.Fechamento is not null) or (obracosmx.Fechamento <> 0))  ');
      //pesquisar
      a := AQuery.Items['idempresa'];
      if AQuery.ContainsKey('idempresa') then
      begin
        if Length(AQuery.Items['idempresa']) > 0 then
        begin
          SQL.Add('AND obracosmx.idempresa =:idempresa ');
          parambyname('idempresa').asstring := AQuery.Items['idempresa'];
        end;
      end;
      a := AQuery.Items['mespagamento'];
      if AQuery.ContainsKey('mespagamento') then
      begin
        if Length(AQuery.Items['mespagamento']) > 0 then
        begin
          SQL.Add('AND obracosmx.fechamento =:fechamento ');
          parambyname('fechamento').asstring := AQuery.Items['mespagamento'];
        end;
      end;
      SQL.Add('order by obracosmx.POHwItem ,obracosmx.sitefromto asc ');
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

function TProjetocosmx.extratopagamentodesconto(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add(' sum(obracosmx.Valor) as total ');
      SQL.Add('From ');
      SQL.Add('obracosmx left Join ');
      SQL.Add('obracosmxlpu On obracosmxlpu.CODIGO = obracosmx.lpu left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obracosmx.idempresa  where obracosmx.aprovacaocosmx Is Not Null and obracosmx.Fechamento is not null  ');
      //pesquisar
      a := AQuery.Items['idempresa'];
      if AQuery.ContainsKey('idempresa') then
      begin
        if Length(AQuery.Items['idempresa']) > 0 then
        begin
          SQL.Add('AND obracosmx.idempresa =:idempresa ');
          parambyname('idempresa').asstring := AQuery.Items['idempresa'];
        end;
      end;
      if AQuery.ContainsKey('fechamento') then
      begin
        if Length(AQuery.Items['fechamento']) > 0 then
        begin
          SQL.Add('AND obracosmx.fechamento =:fechamento ');
          parambyname('fechamento').asstring := AQuery.Items['fechamento'];
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

function TProjetocosmx.extratopagamentototal(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add(' sum(obracosmx.Valorlpu) as total ');
      SQL.Add('From ');
      SQL.Add('obracosmx  where obracosmx.aprovacaocosmx Is Not Null and obracosmx.Fechamento is not null  ');
      //pesquisar
      a := AQuery.Items['idempresa'];
      if AQuery.ContainsKey('idempresa') then
      begin
        if Length(AQuery.Items['idempresa']) > 0 then
        begin
          SQL.Add('AND obracosmx.idempresa =:idempresa ');
          parambyname('idempresa').asstring := AQuery.Items['idempresa'];
        end;
      end;
      a := AQuery.Items['mespagamento'];
      if AQuery.ContainsKey('mespagamento') then
      begin
        if Length(AQuery.Items['mespagamento']) > 0 then
        begin
          SQL.Add('AND obracosmx.fechamento =:fechamento ');
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

function TProjetocosmx.historicopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obracosmx.id, ');
      SQL.Add('obracosmx.*, ');
      SQL.Add('obracosmxlpu.geral as value, ');
      SQL.Add('CONCAT(obracosmxlpu.historico,'' - '',obracosmxlpu.localidade) as label, gesempresas.nome  ');
      SQL.Add('From ');
      SQL.Add('obracosmx left Join ');
      SQL.Add('obracosmxlpu On obracosmxlpu.CODIGO = obracosmx.lpu left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obracosmx.idempresa  where obracosmx.aprovacaocosmx Is Not Null and obracosmx.Fechamento is not null  ');
      //pesquisar
      a := AQuery.Items['idempresalocal'];
      if AQuery.ContainsKey('idempresalocal') then
      begin
        if Length(AQuery.Items['idempresalocal']) > 0 then
        begin
          SQL.Add('AND obracosmx.idempresa =:idempresa ');
          parambyname('idempresa').asstring := AQuery.Items['idempresalocal'];
        end;
      end;
      if AQuery.ContainsKey('fechamento') then
      begin
        if Length(AQuery.Items['fechamento']) > 0 then
        begin
          SQL.Add('AND obracosmx.fechamento =:fechamento ');
          parambyname('fechamento').asstring := AQuery.Items['fechamento'];
        end;
      end;

      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND ((gesempresas.nome = ' + AQuery.Items['busca'] + ') ');
          SQL.Add('or  (obracosmx.InstalledBy like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (obracosmx.PO_1 like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (obracosmx.POHwItem like ''%' + AQuery.Items['busca'] + '%'') ) ');
        end;
      end;
      SQL.Add('order by obracosmx.fechamento desc, obracosmx.POHwItem ,obracosmx.sitefromto asc ');
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

function TProjetocosmx.consultapagamento: Boolean;
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
      sql.add('Select * From obracosmx where fechamento=:fechamento and id=:idgeralfechamento ');
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

function TProjetocosmx.ListaFechamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obracosmx.*, ');
      SQL.Add('obracosmxlpu.geral as value, ');
      SQL.Add('CONCAT(obracosmxlpu.historico,'' - '',obracosmxlpu.localidade) as label, gesempresas.nome  ');
      SQL.Add('From ');
      SQL.Add('obracosmx left Join ');
      SQL.Add('obracosmxlpu On obracosmxlpu.CODIGO = obracosmx.lpu left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obracosmx.idempresa  ');
      //where ((obracosmx.status1 Is Not Null) and (obracosmx.aprovacaocosmx <> ''1899-12-30'' )) and ((obracosmx.Fechamento is null) or (obracosmx.Fechamento = 0))  ');
      SQL.Add('where ((obracosmx.status1 = ''Enviado'') or (obracosmx.status1 = ''Aprovado'')) and ((obracosmx.idempresa is not null) and (obracosmx.idempresa <> 0))and ((obracosmx.Fechamento is null) or (obracosmx.Fechamento = 0)) ');
      SQL.Add('and ((valorlpu is not null) or (valorlpu <> 0))  ');
      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND ((obracosmx.sitefromto like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (obracosmx.InstalledBy like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (obracosmx.PO_1 like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (obracosmx.POHwItem like ''%' + AQuery.Items['busca'] + '%'') ) ');
        end;
      end;
      SQL.Add('order by obracosmx.POHwItem ,obracosmx.sitefromto asc ');
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

function TProjetocosmx.ListaFechamentoporempresa(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obracosmx.id, ');
      SQL.Add('obracosmx.*, ');
      SQL.Add('obracosmxlpu.geral as value, ');
      SQL.Add('CONCAT(obracosmxlpu.historico,'' - '',obracosmxlpu.localidade) as label, gesempresas.nome  ');
      SQL.Add('From ');
      SQL.Add('obracosmx left Join ');
      SQL.Add('obracosmxlpu On obracosmxlpu.CODIGO = obracosmx.lpu left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obracosmx.idempresa  ');
      //where ((obracosmx.aprovacaocosmx Is Not Null) and (obracosmx.aprovacaocosmx <> ''1899-12-30'' )) and ((obracosmx.Fechamento is null) or (obracosmx.Fechamento = 0))   ');
      SQL.Add('where ((obracosmx.status1 = ''Enviado'') or (obracosmx.status1 = ''Aprovado'')) and ((obracosmx.idempresa is not null) and (obracosmx.idempresa <> 0))and ((obracosmx.Fechamento is null) or (obracosmx.Fechamento = 0))  ');
      SQL.Add('and ((valorlpu is not null) or (valorlpu <> 0))  ');
      //pesquisar
      a := AQuery.Items['idempresalocal'];
      if AQuery.ContainsKey('idempresalocal') then
      begin
        if Length(AQuery.Items['idempresalocal']) > 0 then
        begin
          SQL.Add('AND obracosmx.idempresa =:idempresa ');
          parambyname('idempresa').asstring := AQuery.Items['idempresalocal'];
        end;
      end;
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND ((gesempresas.nome = ' + AQuery.Items['busca'] + ') ');
          SQL.Add('or  (obracosmx.InstalledBy like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (obracosmx.PO_1 like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (obracosmx.POHwItem like ''%' + AQuery.Items['busca'] + '%'') ) ');
        end;
      end;
      SQL.Add('order by obracosmx.POHwItem ,obracosmx.sitefromto asc ');
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

function TProjetocosmx.Editar(out erro: string): Boolean;
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
        sql.add('select id from obracosmx where id=:id ');
        ParamByName('id').Value := numero;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('insert into obracosmx (idempresa,lpu,inicioatividadeplanejado,inicioatividadereal,');
          SQL.Add('nomerelatorioenviado1,dataenvio1,enviadopor1,status1,nomerelatorioenviado2,dataenvio2,enviadopor2,');
          SQL.Add('status2,aprovacaocosmx,valorlpu,obs2,');
          SQL.Add('siteid,sitefromto,uf,region,Infrasyte,typesite,batsw,Qty,Owner,InstalledBy,City,Address,notafiscal)');
          SQL.Add('                values(:idempresa,:lpu,:inicioatividadeplanejado,:inicioatividadereal,');
          SQL.Add(':nomerelatorioenviado1,:dataenvio1,:enviadopor1,:status1,:nomerelatorioenviado2,:dataenvio2,:enviadopor2,');
          SQL.Add(':status2,:aprovacaocosmx,:valorlpu,:obs2,');
          SQL.Add(':siteid,:sitefromto,:uf,:region,:Infrasyte,:typesite,:batsw,:Qty,:Owner,:InstalledBy,:City,:Address,:notafiscal)');
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update obracosmx set ');
          SQL.Add('idempresa=:idempresa, ');
          SQL.Add('lpu=:lpu, ');
          SQL.Add('inicioatividadeplanejado=:inicioatividadeplanejado, ');
          SQL.Add('inicioatividadereal=:inicioatividadereal, ');
          SQL.Add('nomerelatorioenviado1=:nomerelatorioenviado1, ');
          SQL.Add('dataenvio1=:dataenvio1, ');
          SQL.Add('enviadopor1=:enviadopor1, ');
          SQL.Add('status1=:status1, ');
          SQL.Add('nomerelatorioenviado2=:nomerelatorioenviado2, ');
          SQL.Add('dataenvio2=:dataenvio2, ');
          SQL.Add('enviadopor2=:enviadopor2, ');
          SQL.Add('status2=:status2, ');
          SQL.Add('aprovacaocosmx=:aprovacaocosmx, valorlpu=:valorlpu, obs2=:obs2, ');
          SQL.Add('siteid=:siteid, ');
          SQL.Add('sitefromto=:sitefromto, ');
          SQL.Add('uf=:uf, ');
          SQL.Add('region=:region, ');
          SQL.Add('Infrasyte=:Infrasyte, ');
          SQL.Add('typesite=:typesite, ');
          SQL.Add('batsw=:batsw, ');
          SQL.Add('Qty=:Qty, ');
          SQL.Add('Owner=:Owner, ');
          SQL.Add('InstalledBy=:InstalledBy, ');
          SQL.Add('City=:City, ');
          SQL.Add('Address=:Address, notafiscal=:notafiscal ');
          SQL.Add('where id=:id ');
          ParamByName('id').Asinteger := numero;
        end;
        ParamByName('idempresa').asinteger := idempresa;
        ParamByName('lpu').AsString := lpu;
        if inicioatividadeplanejado = '' then
          ParamByName('inicioatividadeplanejado').value := '1899-12-30'
        else
          ParamByName('inicioatividadeplanejado').Value := inicioatividadeplanejado;
        if inicioatividadereal = '' then
          ParamByName('inicioatividadereal').value := '1899-12-30'
        else
          ParamByName('inicioatividadereal').Value := inicioatividadereal;

        ParamByName('nomerelatorioenviado1').AsString := nomerelatorioenviado1;

        if dataenvio1 = '' then
          ParamByName('dataenvio1').value := '1899-12-30'
        else
          ParamByName('dataenvio1').Value := dataenvio1;

        ParamByName('enviadopor1').AsString := enviadopor1;
        ParamByName('status1').AsString := status1;
        ParamByName('nomerelatorioenviado2').AsString := nomerelatorioenviado2;

        if dataenvio2 = '' then
          ParamByName('dataenvio2').value := '1899-12-30'
        else
          ParamByName('dataenvio2').Value := dataenvio2;

        ParamByName('enviadopor2').AsString := enviadopor2;
        ParamByName('status2').AsString := status2;

        if aprovacaocosmx = '' then
          ParamByName('aprovacaocosmx').value := '1899-12-30'
        else
          ParamByName('aprovacaocosmx').Value := aprovacaocosmx;

        ParamByName('valorlpu').AsFloat := valorlpu;
        ParamByName('obs2').AsString := observacao;

        ParamByName('siteid').AsString := siteid;
        ParamByName('sitefromto').AsString := sitefromto;
        ParamByName('uf').AsString := uf;
        ParamByName('region').AsString := region;
        ParamByName('Infrasyte').AsString := Infrasyte;
        ParamByName('typesite').AsString := typesite;
        ParamByName('batsw').AsString := batsw;
        try
          ParamByName('Qty').Asinteger := strtoint(Qty)
        except
          ParamByName('Qty').AsInteger := 1;
        end;
        ParamByName('Owner').AsString := Owner1;
        ParamByName('InstalledBy').AsString := InstalledBy;
        ParamByName('City').AsString := City;
        ParamByName('Address').AsString := Address;
        ParamByName('notafiscal').AsString := notafiscal;

        execsql;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao cadastrar cliente: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
  result := true;
end;

function TProjetocosmx.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obracosmx.*, ');
      SQL.Add('obracosmxlpu.geral as value, ');
      SQL.Add('CONCAT(obracosmxlpu.historico,'' - '',obracosmxlpu.localidade) as label, gesempresas.nome  ');
      SQL.Add('From ');
      SQL.Add('obracosmx left Join ');
      SQL.Add('obracosmxlpu On obracosmxlpu.CODIGO = obracosmx.lpu left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obracosmx.idempresa  where obracosmx.id is not null  ');
      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND ((obracosmx.sitefromto like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (obracosmx.InstalledBy like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (obracosmx.PO_1 like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (obracosmx.POHwItem like ''%' + AQuery.Items['busca'] + '%'') ) ');
        end;
      end;
      SQL.Add('order by obracosmx.POHwItem ,obracosmx.sitefromto asc ');
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

function TProjetocosmx.Listapo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select obracosmx.id, ');
      SQL.Add('obracosmx.PO_1, ');
      SQL.Add('obracosmx.POHwItem, ');
      SQL.Add('obracosmx.Qty, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(obracosmx.VALORpo, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as VALORpo, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(obracosmx.VALORpo, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as VALORpototal ');
      SQL.Add('From ');
      SQL.Add('obracosmx ');
      SQL.Add(' WHERE obracosmx.fechamento is not null and id=:id ');
      ParamByName('id').asinteger := AQuery.Items['idprojetocosmx'].ToInteger;
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

function TProjetocosmx.relatorioconsolidadocosmx(
  const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      sql.add('obracosmx.idempresa, ');
      sql.add('gesempresas.nome, ');
      sql.add('obracosmx.Fechamento, ');
      sql.add('Sum(obracosmx.valorlpu) As totalperiodo, ');
      sql.add('obracosmx.NF ');
      sql.add('From ');
      sql.add('obracosmx Inner Join ');
      sql.add('gesempresas On gesempresas.idempresa = obracosmx.idempresa ');
      sql.add('Where ');
      sql.add('((obracosmx.Fechamento Is Not Null) Or ');
      sql.add('(obracosmx.Fechamento <> '''')) ');
      sql.add('Group By ');
      sql.add('obracosmx.idempresa, ');
      sql.add('obracosmx.Fechamento ');
      sql.add('order by obracosmx.Fechamento,gesempresas.nome ');
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

function TProjetocosmx.relatoriocontrolecosmx(
  const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obracosmx.id, ');
      SQL.Add('obracosmx.PO, ');
      SQL.Add('obracosmx.siteid, ');
      SQL.Add('obracosmx.sitefromto, ');
      SQL.Add('obracosmx.uf, ');
      SQL.Add('obracosmx.region, ');
      SQL.Add('gesempresas.nome, ');
      SQL.Add('obracosmx.Fechamento, ');
      SQL.Add('obracosmx.NF ');
      SQL.Add('From  ');
      SQL.Add('obracosmx Inner Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obracosmx.idempresa order by obracosmx.Fechamento desc, gesempresas.nome  ');
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

function TProjetocosmx.relatoriohistoricopagamentocosmx(
  const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select obracosmx.id, ');
      SQL.Add('obracosmx.siteid, ');
      SQL.Add('obracosmx.sitefromto, ');
      SQL.Add('obracosmx.uf, ');
      SQL.Add('gesempresas.nome, ');
      SQL.Add('obracosmx.Fechamento, ');
      SQL.Add('obracosmx.porcentagem, ');
      SQL.Add('obracosmx.Valor, ');
      SQL.Add('obracosmx.Dataenviofechamento, ');
      SQL.Add('obracosmx.NF ');
      SQL.Add('From ');
      SQL.Add('obracosmx Inner Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obracosmx.idempresa ');
      SQL.Add('Where ');
      SQL.Add('((obracosmx.Fechamento Is Not Null) Or ');
      SQL.Add('(obracosmx.Fechamento <> '''')) ');
      SQL.Add('Order By ');
      SQL.Add('obracosmx.Dataenviofechamento desc,  obracosmx.Fechamento, ');
      SQL.Add('gesempresas.nome  ');
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

function TProjetocosmx.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obracosmx.*, ');
      SQL.Add('obracosmxlpu.geral as value, ');
      SQL.Add('CONCAT(obracosmxlpu.historico,'' - '',obracosmxlpu.localidade) as label,  gesempresas.nome ');
      SQL.Add('From ');
      SQL.Add('obracosmx left Join ');
      SQL.Add('obracosmxlpu On obracosmxlpu.CODIGO = obracosmx.lpu left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obracosmx.idempresa ');
      SQL.Add('where obracosmx.id Is Not Null  and id=:id  ');
      ParamByName('id').asinteger := AQuery.Items['idprojetocosmx'].ToInteger;
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

function TProjetocosmx.listagemlpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obracosmxlpu.geral As id, ');
      SQL.Add('obracosmxlpu.PROJETO, ');
      SQL.Add('obracosmxlpu.DESCRICAOATIVIDADE, ');
      SQL.Add('obracosmxlpu.CODIGO, ');
      SQL.Add('obracosmxlpu.ESTADO, ');
      SQL.Add('obracosmxlpu.NOMEESTADO, ');
      SQL.Add('obracosmxlpu.REGIAO, ');
      SQL.Add('obracosmxlpu.LOCALIDADE, ');
      SQL.Add('obracosmxlpu.AREA, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(obracosmxlpu.valor, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valor, ');
      SQL.Add('obracosmxlpu.historico, ');
      SQL.Add('obracosmxlpu.idcolaborador ');
      SQL.Add('From obracosmxlpu where  obracosmxlpu.geral is not null ');
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND obraericssonlpu.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
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

function TProjetocosmx.Listalpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obracosmxlpu.geral as value, ');
      SQL.Add('obracosmxlpu.valor, ');
      SQL.Add('CONCAT(obracosmxlpu.historico,''-'',obracosmxlpu.localidade,''-'',obracosmxlpu.regiao) as label ');
      SQL.Add('From ');
      SQL.Add('obracosmxlpu ');
      SQL.Add('where obracosmxlpu.idcolaborador =:idcolaborador ');
      ParamByName('idcolaborador').AsInteger := idempresa;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND obracosmxlpu.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
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

end.


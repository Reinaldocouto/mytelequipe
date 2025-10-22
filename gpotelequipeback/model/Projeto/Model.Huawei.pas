unit Model.Huawei;

interface

uses
  System.Generics.Defaults, Horse, FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection, ComObj,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections, UtFuncao, FireDAC.Stan.Option,
  System.Variants,
  FireDAC.Stan.Param, DateUtils, System.JSON, System.Classes, Model.Email;

type
  THuaweiAcessoSaveResult = record
    AcessoID: Integer;
  end;

  THuawei = class
  private
    FConn: TFDConnection;
    Fid: string;
    Fos: string;
    Fidcolaboradorpj: Integer;
    Fobservacaopj: string;
    Fpo: string;
    fvalornegociado: Double;
    Fporcentagempj: Double;
    Fdescricao: string;
    Fitemcode: string;
    Fsitename: string;
    Fsiteid: string;
    FbiddingArea: string;
    Fusuario: Integer;
    Fprojectno: string;
    Fregion: string;
    Fponumber: string;
    Fitemdescription: string;
    Fqty: Double;
    Fsitecode: string;
    FnegociadoSN: Integer;
    Fvo: string;

  public
    constructor Create;
    destructor Destroy; override;

    property id: string read Fid write Fid;
    property os: string read Fos write Fos;
    property idcolaboradorpj: Integer read Fidcolaboradorpj write Fidcolaboradorpj;
    property observacaopj: string read Fobservacaopj write Fobservacaopj;
    property po: string read Fpo write Fpo;
    property valornegociado: Double read Fvalornegociado write Fvalornegociado;
    property porcentagempj: Double read Fporcentagempj write Fporcentagempj;
    property descricao: string read Fdescricao write Fdescricao;
    property itemcode: string read Fitemcode write Fitemcode;
    property sitename: string read Fsitename write Fsitename;
    property siteid: string read Fsiteid write Fsiteid;
    property biddingArea: string read FbiddingArea write FbiddingArea;
    property usuario: Integer read Fusuario write Fusuario;
    property projectno: string read Fprojectno write Fprojectno;
    property region: string read Fregion write Fregion;
    property ponumber: string read Fponumber write Fponumber;
    property itemdescription: string read Fitemdescription write Fitemdescription;
    property qty: Double read Fqty write Fqty;
    property sitecode: string read Fsitecode write Fsitecode;
    property negociadoSN: Integer read FnegociadoSN write FnegociadoSN;
    property vo: string read Fvo write Fvo;

    function InserirHuawei(obj: TJSONObject; out erro: string): boolean;
    function Editar(out erro: string): Boolean;
    function ListarHuawei(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listapo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function PesquisarHuaweiPorObra(numeroObra: string; out erro: string): TFDQuery;
    function PesquisarHuaweiPorPrimaryKey(primaryKey: string; out erro: string): TFDQuery;
    function AtualizarHuawei(obj: TJSONObject; out erro: string): boolean;
    function Deletar(ID: Integer): boolean;
    function NovoCadastro(out erro: string): string;
    function Editaratividadepj(out erro: string): Boolean;
    function Listaacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function salvaacionamentopj(out erro: string): Boolean;
    function salvaacionamentoclt(out erro: string): Boolean;
    function Listaacionamentopj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaacionamentoclt(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function CriarTarefa(out erro: string): Boolean;
    function EditarEmMassa(const AJsonBody: string; out erro: string): Boolean;
    function InserirHuaweiRollout(obj: TJSONObject; out erro: string): boolean;
    function PesquisarHuaweiPorPrimaryKeyRollout(primaryKey: string; out erro: string): TFDQuery;
    function Listafechamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaconsolidado(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaDespesas(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function extratopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function totalacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function RolloutHuawei(const AQuery: TDictionary<string,string>;  out erro: string): TFDQuery;
    function ListaEquipeAcesso(const idAcesso: Integer; out erro: string): TFDQuery;
    function SalvarAcesso(const Body: TJSONObject; out erro: string; out R: THuaweiAcessoSaveResult): Boolean;
  end;

implementation

constructor THuawei.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor THuawei.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function THuawei.InserirHuawei(obj: TJSONObject; out erro: string): boolean;
var
  Q: TFDQuery;
  Flds, Params, Key: string;
  Cols, Pms: TStringList;
  i: Integer;

  procedure AddKV(const JsonKey, ColName: string);
  var
    V: TJSONValue;
  begin
    V := obj.GetValue(JsonKey);
    if Assigned(V) and (Trim(V.Value) <> '') then
    begin
      if Flds <> '' then
      begin
        Flds   := Flds   + ', ';
        Params := Params + ', ';
      end;
      Flds   := Flds   + ColName;
      Params := Params + ':' + JsonKey;
      Cols.Add(ColName);
      Pms.Add(JsonKey);
    end;
  end;

begin
  Result := False;
  erro := '';
  Q := TFDQuery.Create(nil);
  Cols := TStringList.Create;
  Pms  := TStringList.Create;
  try
    Q.Connection := FConn;
    Flds := '';
    Params := '';
    AddKV('primaryKey',      'primaryKey');
    AddKV('sitecode',        'sitecode');
    AddKV('sitename',        'sitename');
    AddKV('siteid',          'siteid');
    AddKV('poNumber',        'poNumber');
    AddKV('projectNo',       'projectNo');
    AddKV('biddingArea',     'biddingArea');
    AddKV('os',              'os');
    AddKV('observacaopj',    'observacaopj');
    AddKV('idcolaboradorpj', 'idcolaboradorpj');
    AddKV('valorpj',         'valorpj');
    AddKV('porcentagempj',   'porcentagempj');
    AddKV('negociadoSN',     'negociadoSN');
    AddKV('vo',              'vo');
    AddKV('observacaogeral', 'observacaogeral');
    if Flds = '' then
    begin
      erro := 'Sem campos válidos para inserir.';
      Exit;
    end;
    Q.SQL.Text := 'INSERT INTO ProjetoHuawei (' + Flds + ') VALUES (' + Params + ')';
    for i := 0 to Pms.Count - 1 do
    begin
      Key := Pms[i];
      if SameText(Cols[i], 'idcolaboradorpj') or SameText(Cols[i], 'negociadoSN') then
        Q.ParamByName(Key).AsInteger := StrToIntDef(obj.GetValue(Key).Value, 0)
      else if SameText(Cols[i], 'valorpj') or SameText(Cols[i], 'porcentagempj') then
        Q.ParamByName(Key).AsFloat := StrToFloatDef(StringReplace(obj.GetValue(Key).Value, ',', '.', [rfReplaceAll]), 0)
      else
        Q.ParamByName(Key).AsString := obj.GetValue(Key).Value;
    end;
    try
      Q.ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        erro := 'Erro ao inserir ProjetoHuawei: ' + E.Message;
        Result := False;
      end;
    end;
  except
    on E: Exception do
    begin
      erro := 'Erro interno ao inserir ProjetoHuawei: ' + E.Message;
      Result := False;
    end;
  end;
  Cols.Free;
  Pms.Free;
  Q.Free;
end;

function THuawei.Editar(out erro: string): Boolean;
var
  Q: TFDQuery;
begin
  Result := False;
  erro := '';
  if Trim(Self.id) = '' then
  begin
    erro := 'ID não informado para edição.';
    Exit;
  end;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Clear;
    Q.SQL.Add('UPDATE ProjetoHuawei SET ');
    Q.SQL.Add('  os = :os, ');
    Q.SQL.Add('  observacaopj = :observacaopj, ');
    Q.SQL.Add('  idcolaboradorpj = :idcolaboradorpj, ');
    Q.SQL.Add('  valorpj = :valorpj, ');
    Q.SQL.Add('  porcentagempj = :porcentagempj, ');
    Q.SQL.Add('  negociadoSN = :negociadoSN, ');
    Q.SQL.Add('  vo = :vo ');
    Q.SQL.Add('WHERE id = :id');
    Q.ParamByName('os').AsString               := Self.os;
    Q.ParamByName('observacaopj').AsString     := Self.observacaopj;
    Q.ParamByName('idcolaboradorpj').AsInteger := Self.idcolaboradorpj;
    Q.ParamByName('valorpj').AsFloat           := Self.valornegociado;
    Q.ParamByName('porcentagempj').AsFloat     := Self.porcentagempj;
    Q.ParamByName('negociadoSN').AsInteger     := Self.negociadoSN;
    Q.ParamByName('vo').AsString               := Self.vo;
    Q.ParamByName('id').AsInteger              := StrToIntDef(Self.id, 0);
    try
      Q.ExecSQL;
      Result := True;
      erro := '';
    except
      on E: Exception do
      begin
        erro := 'Erro ao editar: ' + E.Message;
        Result := False;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function THuawei.ListarHuawei(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry, qcfg: TFDQuery;
  Busca: string;
begin
  erro := '';
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    qcfg := TFDQuery.Create(nil);
    try
      qcfg.Connection := FConn;
      qcfg.SQL.Text := 'SET SESSION group_concat_max_len = 1048576';
      try qcfg.ExecSQL; except end;
    finally
      qcfg.Free;
    end;
    if AQuery.ContainsKey('agrupado') then
    begin
      qry.SQL.Text := 'SELECT manufactureSiteInfo, COUNT(*) AS occurrences FROM ProjetoHuawei';
      if AQuery.ContainsKey('busca') and (Trim(AQuery.Items['busca']) <> '') then
      begin
        qry.SQL.Add(' WHERE (manufactureSiteInfo LIKE :busca OR poNumber LIKE :busca OR subProjectCode LIKE :busca)');
        Busca := '%' + Trim(AQuery.Items['busca']) + '%';
        qry.ParamByName('busca').AsString := Busca;
      end;
      qry.SQL.Add(' GROUP BY manufactureSiteInfo');
    end
    else
    begin
      qry.SQL.Clear;
      qry.SQL.Add('SELECT');
      qry.SQL.Add('  ph.*,');
      qry.SQL.Add('  pha.id                   AS acesso_id,');
      qry.SQL.Add('  pha.id_projeto           AS acesso_id_projeto,');
      qry.SQL.Add('  pha.tipo_infra           AS acesso_tipo_infra,');
      qry.SQL.Add('  pha.quadrante            AS acesso_quadrante,');
      qry.SQL.Add('  pha.ddd                  AS acesso_ddd,');
      qry.SQL.Add('  pha.municipio            AS acesso_municipio,');
      qry.SQL.Add('  pha.endereco             AS acesso_endereco,');
      qry.SQL.Add('  pha.latitude             AS acesso_latitude,');
      qry.SQL.Add('  pha.longitude            AS acesso_longitude,');
      qry.SQL.Add('  pha.detentor_area        AS acesso_detentor_area,');
      qry.SQL.Add('  pha.id_detentora         AS acesso_id_detentora,');
      qry.SQL.Add('  pha.id_outros            AS acesso_id_outros,');
      qry.SQL.Add('  pha.forma_acesso         AS acesso_forma_acesso,');
      qry.SQL.Add('  pha.observacao_acesso    AS acesso_observacao_acesso,');
      qry.SQL.Add('  pha.data_solicitado      AS acesso_data_solicitado,');
      qry.SQL.Add('  pha.data_inicio          AS acesso_data_inicio,');
      qry.SQL.Add('  pha.data_fim             AS acesso_data_fim,');
      qry.SQL.Add('  pha.status_acesso        AS acesso_status_acesso,');
      qry.SQL.Add('  pha.numero_solicitacao   AS acesso_numero_solicitacao,');
      qry.SQL.Add('  pha.tratativa_acessos    AS acesso_tratativa_acessos,');
      qry.SQL.Add('  pha.du_id                AS acesso_du_id,');
      qry.SQL.Add('  pha.du_name              AS acesso_du_name,');
      qry.SQL.Add('  pha.status_att           AS acesso_status_att,');
      qry.SQL.Add('  pha.meta_plan            AS acesso_meta_plan,');
      qry.SQL.Add('  pha.atividade_escopo     AS acesso_atividade_escopo,');
      qry.SQL.Add('  pha.acionamentos_recentes AS acesso_acionamentos_recentes,');
      qry.SQL.Add('  pha.updated_by           AS acesso_updated_by,');
      qry.SQL.Add('  pha.updated_at           AS acesso_updated_at,');
      qry.SQL.Add('  (SELECT GROUP_CONCAT(gp.nome SEPARATOR '', '')');
      qry.SQL.Add('     FROM ProjetoHuaweiAcessoEquipe pae');
      qry.SQL.Add('     LEFT JOIN gespessoa gp ON gp.idpessoa = pae.id_pessoa');
      qry.SQL.Add('    WHERE pae.id_acesso = pha.id) AS acesso_equipe_nomes,');
      qry.SQL.Add('  (SELECT COUNT(*) FROM ProjetoHuaweiAcessoEquipe pae WHERE pae.id_acesso = pha.id) AS acesso_equipe_count');
      qry.SQL.Add('FROM ProjetoHuawei ph');
      qry.SQL.Add('LEFT JOIN ProjetoHuaweiAcesso pha ON pha.id_projeto = ph.id');
      qry.SQL.Add('WHERE 1=1');
      if AQuery.ContainsKey('busca') and (Trim(AQuery.Items['busca']) <> '') then
      begin
        qry.SQL.Add(
          ' AND (ph.manufactureSiteInfo LIKE :busca '+
          '  OR ph.poNumber           LIKE :busca '+
          '  OR ph.subProjectCode     LIKE :busca '+
          '  OR ph.sitecode           LIKE :busca '+
          '  OR ph.sitename           LIKE :busca '+
          '  OR ph.siteid             LIKE :busca '+
          '  OR ph.os                 LIKE :busca '+
          '  OR ph.vo                 LIKE :busca '+
          '  OR ph.primaryKey         LIKE :busca '+
          '  OR pha.municipio         LIKE :busca '+
          '  OR pha.tipo_infra        LIKE :busca '+
          '  OR pha.forma_acesso      LIKE :busca '+
          '  OR (SELECT GROUP_CONCAT(gp.nome SEPARATOR '', '') '+
          '        FROM ProjetoHuaweiAcessoEquipe pae '+
          '        LEFT JOIN gespessoa gp ON gp.idpessoa = pae.id_pessoa '+
          '       WHERE pae.id_acesso = pha.id) LIKE :busca)');
        Busca := '%' + Trim(AQuery.Items['busca']) + '%';
        qry.ParamByName('busca').AsString := Busca;
      end;
      qry.SQL.Add(' ORDER BY ph.poNumber DESC, ph.id DESC');
    end;
    qry.Open;
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao listar registros: ' + ex.Message;
      qry.Free;
      Result := nil;
    end;
  end;
end;

function THuawei.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  Q: TFDQuery;
  Busca, SLim, SOffs: string;
  Lim, Offs: Integer;
  IdFiltro: string;
begin
  erro := '';
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Clear;
    Q.SQL.Add('SELECT');
    Q.SQL.Add('  ph.*,');
    Q.SQL.Add('  pha.id                     AS acesso_id,');
    Q.SQL.Add('  pha.id_projeto             AS acesso_id_projeto,');
    Q.SQL.Add('  pha.tipo_infra             AS acesso_tipo_infra,');
    Q.SQL.Add('  pha.quadrante              AS acesso_quadrante,');
    Q.SQL.Add('  pha.ddd                    AS acesso_ddd,');
    Q.SQL.Add('  pha.municipio              AS acesso_municipio,');
    Q.SQL.Add('  pha.regiao                 AS acesso_regiao,');
    Q.SQL.Add('  pha.endereco               AS acesso_endereco,');
    Q.SQL.Add('  pha.latitude               AS acesso_latitude,');
    Q.SQL.Add('  pha.longitude              AS acesso_longitude,');
    Q.SQL.Add('  pha.detentor_area          AS acesso_detentor_area,');
    Q.SQL.Add('  pha.id_detentora           AS acesso_id_detentora,');
    Q.SQL.Add('  pha.id_outros              AS acesso_id_outros,');
    Q.SQL.Add('  pha.forma_acesso           AS acesso_forma_acesso,');
    Q.SQL.Add('  pha.observacao_acesso      AS acesso_observacao_acesso,');
    Q.SQL.Add('  DATE_FORMAT(pha.data_solicitado, ''%Y-%m-%d'') AS acesso_data_solicitado,');
    Q.SQL.Add('  DATE_FORMAT(pha.data_inicio,     ''%Y-%m-%d'') AS acesso_data_inicio,');
    Q.SQL.Add('  DATE_FORMAT(pha.data_fim,        ''%Y-%m-%d'') AS acesso_data_fim,');
    Q.SQL.Add('  pha.status_acesso          AS acesso_status_acesso,');
    Q.SQL.Add('  pha.numero_solicitacao     AS acesso_numero_solicitacao,');
    Q.SQL.Add('  pha.tratativa_acessos      AS acesso_tratativa_acessos,');
    Q.SQL.Add('  pha.du_id                  AS acesso_du_id,');
    Q.SQL.Add('  pha.du_name                AS acesso_du_name,');
    Q.SQL.Add('  pha.status_att             AS acesso_status_att,');
    Q.SQL.Add('  pha.meta_plan              AS acesso_meta_plan,');
    Q.SQL.Add('  pha.atividade_escopo       AS acesso_atividade_escopo,');
    Q.SQL.Add('  pha.acionamentos_recentes  AS acesso_acionamentos_recentes,');
    Q.SQL.Add('  pha.updated_by             AS acesso_updated_by,');
    Q.SQL.Add('  DATE_FORMAT(pha.updated_at, ''%Y-%m-%d %H:%i:%s'') AS acesso_updated_at,');
    Q.SQL.Add('  (SELECT GROUP_CONCAT(gp.nome ORDER BY gp.nome SEPARATOR '', '')');
    Q.SQL.Add('     FROM ProjetoHuaweiAcessoEquipe pae');
    Q.SQL.Add('     LEFT JOIN gespessoa gp ON gp.idpessoa = pae.id_pessoa');
    Q.SQL.Add('    WHERE pae.id_acesso = pha.id) AS acesso_equipe_nomes,');
    Q.SQL.Add('  (SELECT COUNT(*) FROM ProjetoHuaweiAcessoEquipe pae WHERE pae.id_acesso = pha.id) AS acesso_equipe_count');
    Q.SQL.Add('FROM ProjetoHuawei ph');
    Q.SQL.Add('LEFT JOIN ProjetoHuaweiAcesso pha ON pha.id_projeto = ph.id');
    Q.SQL.Add('LEFT JOIN rollouthuawei r ON ph.primaryKey LIKE CONCAT(r.id, ''|%'')');
    Q.SQL.Add('WHERE 1=1');

    if AQuery.ContainsKey('busca') and (Trim(AQuery.Items['busca']) <> '') then
    begin
      Q.SQL.Add(' AND (ph.manufactureSiteInfo LIKE :busca');
      Q.SQL.Add('  OR ph.poNumber           LIKE :busca');
      Q.SQL.Add('  OR ph.subProjectCode     LIKE :busca');
      Q.SQL.Add('  OR ph.sitecode           LIKE :busca');
      Q.SQL.Add('  OR ph.sitename           LIKE :busca');
      Q.SQL.Add('  OR ph.siteid             LIKE :busca');
      Q.SQL.Add('  OR ph.os                 LIKE :busca');
      Q.SQL.Add('  OR ph.vo                 LIKE :busca');
      Q.SQL.Add('  OR ph.primaryKey         LIKE :busca');
      Q.SQL.Add('  OR pha.municipio         LIKE :busca');
      Q.SQL.Add('  OR pha.tipo_infra        LIKE :busca');
      Q.SQL.Add('  OR pha.forma_acesso      LIKE :busca');
      Q.SQL.Add('  OR pha.regiao            LIKE :busca');
      Q.SQL.Add('  OR (SELECT GROUP_CONCAT(gp.nome SEPARATOR '', '')');
      Q.SQL.Add('        FROM ProjetoHuaweiAcessoEquipe pae');
      Q.SQL.Add('        LEFT JOIN gespessoa gp ON gp.idpessoa = pae.id_pessoa');
      Q.SQL.Add('       WHERE pae.id_acesso = pha.id) LIKE :busca)');
      Busca := '%' + Trim(AQuery.Items['busca']) + '%';
      Q.ParamByName('busca').AsString := Busca;
    end;

    if AQuery.ContainsKey('id') and (Trim(AQuery.Items['id']) <> '') then
    begin
      IdFiltro := Trim(AQuery.Items['id']);
      Q.SQL.Add(' AND ph.primaryKey LIKE :p_id_pk_like');
      Q.ParamByName('p_id_pk_like').AsString := IdFiltro + '|%';
    end;

    Q.SQL.Add('ORDER BY ph.id DESC');

    Lim := 0; Offs := 0;
    if AQuery.ContainsKey('limit') then
    begin
      SLim := Trim(AQuery.Items['limit']);
      Lim := StrToIntDef(SLim, 0);
    end;
    if AQuery.ContainsKey('offset') then
    begin
      SOffs := Trim(AQuery.Items['offset']);
      Offs := StrToIntDef(SOffs, 0);
    end;
    if Lim > 0 then
    begin
      Q.SQL.Add(Format('LIMIT %d', [Lim]));
      if Offs > 0 then
        Q.SQL.Add(Format('OFFSET %d', [Offs]));
    end;

    Q.Open;
    Result := Q;
  except
    on E: Exception do
    begin
      erro := 'Erro ao listar ProjetoHuawei: ' + E.Message;
      Q.Free;
      Result := nil;
    end;
  end;
end;


function THuawei.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry, qcfg: TFDQuery;
  HasId, HasPk, HasSiteCode, HasPoLineId: Boolean;
  IdStr, PkStr, SiteCodeStr, PoLineIdStr: string;
  IdNum: Int64;
  IdTemPipe: Boolean;
  IdEhInt64: Boolean;
begin
  erro := '';
  Result := nil;

  if not Assigned(FConn) then
  begin
    erro := 'Conexão não inicializada';
    Exit;
  end;

  HasId       := AQuery.ContainsKey('id');
  HasPk       := AQuery.ContainsKey('primaryKey');
  HasSiteCode := AQuery.ContainsKey('sitecode');
  HasPoLineId := AQuery.ContainsKey('poLineId');

  if HasId then       IdStr       := Trim(AQuery.Items['id']);
  if HasPk then       PkStr       := Trim(AQuery.Items['primaryKey']);
  if HasSiteCode then SiteCodeStr := Trim(AQuery.Items['sitecode']);
  if HasPoLineId then PoLineIdStr := Trim(AQuery.Items['poLineId']);

  IdTemPipe := HasId and (Pos('|', IdStr) > 0);
  IdEhInt64 := HasId and TryStrToInt64(IdStr, IdNum);

  if not (HasPk or HasId or HasSiteCode or HasPoLineId) then
  begin
    erro := 'Informe ao menos um identificador (id, primaryKey, sitecode ou poLineId).';
    Exit;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;

    qcfg := TFDQuery.Create(nil);
    try
      qcfg.Connection := FConn;
      qcfg.SQL.Text := 'SET SESSION group_concat_max_len = 1048576';
      try
        qcfg.ExecSQL;
      except
      end;
    finally
      qcfg.Free;
    end;

    qry.SQL.Clear;
    qry.SQL.Add('SELECT');
    qry.SQL.Add('  ph.*,');
    qry.SQL.Add('  DATE_FORMAT(ph.publishDate,   ''%Y-%m-%d %H:%i:%s'') AS publishDate_iso,');
    qry.SQL.Add('  DATE_FORMAT(ph.needByDate,    ''%Y-%m-%d %H:%i:%s'') AS needByDate_iso,');
    qry.SQL.Add('  DATE_FORMAT(ph.approvedDate,  ''%Y-%m-%d %H:%i:%s'') AS approvedDate_iso,');
    qry.SQL.Add('  DATE_FORMAT(ph.startDate,     ''%Y-%m-%d'')          AS startDate_iso,');
    qry.SQL.Add('  DATE_FORMAT(ph.promiseDate,   ''%Y-%m-%d %H:%i:%s'') AS promiseDate_iso,');
    qry.SQL.Add('  DATE_FORMAT(ph.creationDate,  ''%Y-%m-%d %H:%i:%s'') AS creationDate_iso,');
    qry.SQL.Add('  DATE_FORMAT(ph.lastUpdateDate,''%Y-%m-%d %H:%i:%s'') AS lastUpdateDate_iso,');
    qry.SQL.Add('  DATE_FORMAT(ph.dataacionamento,''%Y-%m-%d %H:%i:%s'') AS dataacionamento_iso,');
    qry.SQL.Add('  DATE_FORMAT(ph.dataenvioemail,''%Y-%m-%d %H:%i:%s'')  AS dataenvioemail_iso,');

    qry.SQL.Add('  pha.id                    AS acesso_id,');
    qry.SQL.Add('  pha.id_projeto            AS acesso_id_projeto,');
    qry.SQL.Add('  pha.tipo_infra            AS acesso_tipo_infra,');
    qry.SQL.Add('  pha.quadrante             AS acesso_quadrante,');
    qry.SQL.Add('  pha.ddd                   AS acesso_ddd,');
    qry.SQL.Add('  pha.municipio             AS acesso_municipio,');
    qry.SQL.Add('  pha.regiao                AS acesso_regiao,');               // <-- NOVO
    qry.SQL.Add('  pha.endereco              AS acesso_endereco,');
    qry.SQL.Add('  pha.latitude              AS acesso_latitude,');
    qry.SQL.Add('  pha.longitude             AS acesso_longitude,');
    qry.SQL.Add('  pha.detentor_area         AS acesso_detentor_area,');
    qry.SQL.Add('  pha.id_detentora          AS acesso_id_detentora,');
    qry.SQL.Add('  pha.id_outros             AS acesso_id_outros,');
    qry.SQL.Add('  pha.forma_acesso          AS acesso_forma_acesso,');
    qry.SQL.Add('  pha.observacao_acesso     AS acesso_observacao_acesso,');
    qry.SQL.Add('  DATE_FORMAT(pha.data_solicitado, ''%Y-%m-%d'') AS acesso_data_solicitado,');
    qry.SQL.Add('  DATE_FORMAT(pha.data_inicio,     ''%Y-%m-%d'') AS acesso_data_inicio,');
    qry.SQL.Add('  DATE_FORMAT(pha.data_fim,        ''%Y-%m-%d'') AS acesso_data_fim,');
    qry.SQL.Add('  pha.status_acesso         AS acesso_status_acesso,');
    qry.SQL.Add('  pha.numero_solicitacao    AS acesso_numero_solicitacao,');
    qry.SQL.Add('  pha.tratativa_acessos     AS acesso_tratativa_acessos,');
    qry.SQL.Add('  pha.du_id                 AS acesso_du_id,');
    qry.SQL.Add('  pha.du_name               AS acesso_du_name,');
    qry.SQL.Add('  pha.status_att            AS acesso_status_att,');
    qry.SQL.Add('  pha.meta_plan             AS acesso_meta_plan,');
    qry.SQL.Add('  pha.atividade_escopo      AS acesso_atividade_escopo,');
    qry.SQL.Add('  pha.acionamentos_recentes AS acesso_acionamentos_recentes,');
    qry.SQL.Add('  pha.updated_by            AS acesso_updated_by,');
    qry.SQL.Add('  DATE_FORMAT(pha.updated_at, ''%Y-%m-%d %H:%i:%s'') AS acesso_updated_at,');

    qry.SQL.Add('  eq.acesso_equipe_nomes,');
    qry.SQL.Add('  eq.acesso_equipe_count');

    qry.SQL.Add('FROM ProjetoHuawei ph');
    qry.SQL.Add('LEFT JOIN ProjetoHuaweiAcesso pha ON pha.id_projeto = ph.id');

    qry.SQL.Add('LEFT JOIN (');
    qry.SQL.Add('  SELECT pae.id_acesso,');
    qry.SQL.Add('         GROUP_CONCAT(gp.nome ORDER BY gp.nome SEPARATOR '', '') AS acesso_equipe_nomes,');
    qry.SQL.Add('         COUNT(*) AS acesso_equipe_count');
    qry.SQL.Add('  FROM ProjetoHuaweiAcessoEquipe pae');
    qry.SQL.Add('  LEFT JOIN gespessoa gp ON gp.idpessoa = pae.id_pessoa');
    qry.SQL.Add('  GROUP BY pae.id_acesso');
    qry.SQL.Add(') eq ON eq.id_acesso = pha.id');

    qry.SQL.Add('WHERE 1=1');

    if HasPk and (PkStr <> '') then
    begin
      qry.SQL.Add('  AND ph.primaryKey = :p_pk');
      qry.ParamByName('p_pk').AsString := PkStr;
    end
    else if HasId and (IdStr <> '') then
    begin
      if IdTemPipe then
      begin
        qry.SQL.Add('  AND ph.primaryKey = :p_id_pk');
        qry.ParamByName('p_id_pk').AsString := IdStr;
      end
      else
      begin
        qry.SQL.Add('  AND (ph.primaryKey LIKE :p_id_pk_like');
        if IdEhInt64 then
        begin
          qry.SQL.Add('       OR ph.id = :p_id_num)');
          qry.ParamByName('p_id_num').AsLargeInt := IdNum;
        end
        else
        begin
          qry.SQL.Add('       )');
        end;
        qry.ParamByName('p_id_pk_like').AsString := IdStr + '|%';
      end;
    end
    else if HasSiteCode and (SiteCodeStr <> '') then
    begin
      qry.SQL.Add('  AND ph.sitecode = :p_sitecode');
      qry.ParamByName('p_sitecode').AsString := SiteCodeStr;
    end
    else if HasPoLineId and (PoLineIdStr <> '') then
    begin
      qry.SQL.Add('  AND ph.poLineId = :p_poline');
      qry.ParamByName('p_poline').AsString := PoLineIdStr;
    end;

    qry.SQL.Add('LIMIT 1');
    qry.Open;

    if qry.IsEmpty then
    begin
      erro := 'Registro não encontrado';
      qry.Free;
      Exit(nil);
    end;

    Result := qry;
  except
    on E: Exception do
    begin
      erro := 'Erro ao buscar ProjetoHuawei (detalhe): ' + E.Message;
      if Assigned(qry) then
        qry.Free;
      Result := nil;
    end;
  end;
end;


function THuawei.Listapo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.PesquisarHuaweiPorObra(numeroObra: string; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.connection := FConn;
  try
    qry.SQL.Text := 'SELECT * FROM ProjetoHuawei WHERE projectNo = :projectNo';
    qry.ParamByName('projectNo').AsString := numeroObra;
    qry.Open;
    erro := '';
    Result := qry;
  except
    on E: Exception do
    begin
      erro := 'Erro ao pesquisar pelo número da obra: ' + E.Message;
      qry.Free;
      Result := nil;
    end;
  end;
end;

function THuawei.PesquisarHuaweiPorPrimaryKey(primaryKey: string; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  Result := nil;
  erro := '';
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    qry.SQL.Text :=
      'SELECT * FROM ProjetoHuawei ' +
      'WHERE primaryKey = :pk OR primaryKey LIKE CONCAT(:pk, ''|%'') ' +
      'ORDER BY id DESC';
    qry.ParamByName('pk').AsString := primaryKey;
    qry.Open;
    Result := qry;
  except
    on E: Exception do
    begin
      erro := 'Erro ao pesquisar pela primaryKey: ' + E.Message;
      qry.Free;
      Result := nil;
    end;
  end;
end;

function THuawei.AtualizarHuawei(obj: TJSONObject; out erro: string): boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.Deletar(ID: Integer): boolean;
begin
  Result := False;
end;

function THuawei.NovoCadastro(out erro: string): string;
begin
  Result := '';
  erro := 'Implementação pendente';
end;

function THuawei.Editaratividadepj(out erro: string): Boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.Listaacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.salvaacionamentopj(out erro: string): Boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.salvaacionamentoclt(out erro: string): Boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.Listaacionamentopj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.Listaacionamentoclt(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.CriarTarefa(out erro: string): Boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.RolloutHuawei(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry, qcfg: TFDQuery;
  vBusca, vId, vLimit, vOffset: string;
  hasBusca, hasId: Boolean;
  limite, desloc: Integer;
begin
  erro := '';
  Result := nil;

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;

    // aumenta limite de concatenação pra não truncar nomes/equipes
    qcfg := TFDQuery.Create(nil);
    try
      qcfg.Connection := FConn;
      qcfg.SQL.Text := 'SET SESSION group_concat_max_len = 1048576';
      try qcfg.ExecSQL; except end;
    finally
      qcfg.Free;
    end;

    hasBusca := AQuery.TryGetValue('busca', vBusca) and (Trim(vBusca) <> '');
    hasId    := AQuery.TryGetValue('id', vId) and (Trim(vId) <> '');

    if not AQuery.TryGetValue('limit',  vLimit)  then vLimit  := '100';
    if not AQuery.TryGetValue('offset', vOffset) then vOffset := '0';
    limite := StrToIntDef(Trim(vLimit), 100);
    desloc := StrToIntDef(Trim(vOffset), 0);

    qry.SQL.Clear;

    { =======================
      Estratégia:
      - Sem busca: primeiro pega só os IDs de rollouthuawei (ordenados) + paginação;
        depois faz os LEFT JOINs em cima desse conjunto pequeno.
      - Com busca: aplica filtro com joins (precisa olhar campos de ph/pha/eq).
      ======================= }

    if not hasBusca then
    begin
      qry.SQL.Add('SELECT');
      qry.SQL.Add('  r.*,');

      // ProjetoHuawei
      qry.SQL.Add('  ph.id                              AS projetoId,');
      qry.SQL.Add('  ph.primaryKey                      AS primaryKey,');

      // Acesso (ProjetoHuaweiAcesso) com aliases camelCase
      qry.SQL.Add('  pha.id                             AS idProjeto,');
      qry.SQL.Add('  pha.tipo_infra                     AS tipoInfra,');
      qry.SQL.Add('  pha.quadrante                      AS quadrante,');
      qry.SQL.Add('  pha.ddd                            AS ddd1,');
      qry.SQL.Add('  pha.municipio                      AS municipio,');
      qry.SQL.Add('  pha.regiao                         AS regiao,');
      qry.SQL.Add('  pha.endereco                       AS endereco,');
      qry.SQL.Add('  pha.latitude                       AS latitude1,');
      qry.SQL.Add('  pha.longitude                      AS longitude1,');
      qry.SQL.Add('  pha.detentor_area                  AS detentorArea,');
      qry.SQL.Add('  pha.id_detentora                   AS idDetentora,');
      qry.SQL.Add('  pha.id_outros                      AS idOutros,');
      qry.SQL.Add('  pha.forma_acesso                   AS formaAcesso,');
      qry.SQL.Add('  pha.observacao_acesso              AS observacaoAcesso,');
      qry.SQL.Add('  pha.data_solicitado                AS dataSolicitado,');
      qry.SQL.Add('  pha.data_inicio                    AS dataInicio,');
      qry.SQL.Add('  pha.data_fim                       AS dataFim,');
      qry.SQL.Add('  pha.status_acesso                  AS statusAcesso,');
      qry.SQL.Add('  pha.numero_solicitacao             AS numeroSolicitacao,');
      qry.SQL.Add('  pha.tratativa_acessos              AS tratativaAcessos,');
      qry.SQL.Add('  pha.du_id                          AS duId,');
      qry.SQL.Add('  pha.du_name                        AS duName,');
      qry.SQL.Add('  pha.status_att                     AS statusAtt,');
      qry.SQL.Add('  pha.meta_plan                      AS metaPlan,');
      qry.SQL.Add('  pha.atividade_escopo               AS atividadeEscopo,');
      qry.SQL.Add('  pha.acionamentos_recentes          AS acionamentosRecentes,');
      qry.SQL.Add('  pha.updated_by                     AS updatedBy,');
      qry.SQL.Add('  pha.updated_at                     AS updatedAt,');

      // Equipe agregada
      qry.SQL.Add('  eq.acesso_equipe_nomes             AS acessoEquipeNomes,');
      qry.SQL.Add('  eq.acesso_equipe_count             AS acessoEquipeCount,');
      qry.SQL.Add('  eq.acesso_equipe_ids_csv           AS acessoEquipeIdsCsv,');
      qry.SQL.Add('  CONCAT(''['', eq.acesso_equipe_ids_csv, '']'') AS acessoEquipeJson');

      qry.SQL.Add('FROM (');
      qry.SQL.Add('  SELECT r.*');
      qry.SQL.Add('  FROM rollouthuawei r');
      qry.SQL.Add('  WHERE 1=1');
      if hasId then
        qry.SQL.Add('    AND r.id = :p_id');
      qry.SQL.Add('  ORDER BY r.idgeral DESC');
      qry.SQL.Add('  LIMIT :p_limit OFFSET :p_offset');
      qry.SQL.Add(') r');

      qry.SQL.Add('LEFT JOIN ProjetoHuawei ph');
      qry.SQL.Add('  ON (ph.primaryKey = r.id OR ph.primaryKey LIKE CONCAT(r.id, ''|%''))');

      qry.SQL.Add('LEFT JOIN ProjetoHuaweiAcesso pha');
      qry.SQL.Add('  ON pha.id_projeto = ph.id');

      qry.SQL.Add('LEFT JOIN (');
      qry.SQL.Add('  SELECT');
      qry.SQL.Add('    pae.id_acesso,');
      qry.SQL.Add('    GROUP_CONCAT(gp.nome ORDER BY gp.nome SEPARATOR '', '') AS acesso_equipe_nomes,');
      qry.SQL.Add('    COUNT(*) AS acesso_equipe_count,');
      qry.SQL.Add('    GROUP_CONCAT(pae.id_pessoa ORDER BY gp.nome) AS acesso_equipe_ids_csv');
      qry.SQL.Add('  FROM ProjetoHuaweiAcessoEquipe pae');
      qry.SQL.Add('  LEFT JOIN gespessoa gp ON gp.idpessoa = pae.id_pessoa');
      qry.SQL.Add('  GROUP BY pae.id_acesso');
      qry.SQL.Add(') eq ON eq.id_acesso = pha.id');

      if hasId then
        qry.ParamByName('p_id').AsString := Trim(vId);
      qry.ParamByName('p_limit').AsInteger  := limite;
      qry.ParamByName('p_offset').AsInteger := desloc;
    end
    else
    begin
      // Busca em r/ph/pha/eq
      qry.SQL.Add('SELECT');
      qry.SQL.Add('  r.*,');
      qry.SQL.Add('  ph.id                              AS projetoId,');
      qry.SQL.Add('  ph.primaryKey                      AS primaryKey,');
      qry.SQL.Add('  pha.id                             AS idProjeto,');
      qry.SQL.Add('  pha.tipo_infra                     AS tipoInfra,');
      qry.SQL.Add('  pha.quadrante                      AS quadrante,');
      qry.SQL.Add('  pha.ddd                            AS ddd1,');
      qry.SQL.Add('  pha.municipio                      AS municipio,');
      qry.SQL.Add('  pha.regiao                         AS regiao,');
      qry.SQL.Add('  pha.endereco                       AS endereco,');
      qry.SQL.Add('  pha.latitude                       AS latitude1,');
      qry.SQL.Add('  pha.longitude                      AS longitude1,');
      qry.SQL.Add('  pha.detentor_area                  AS detentorArea,');
      qry.SQL.Add('  pha.id_detentora                   AS idDetentora,');
      qry.SQL.Add('  pha.id_outros                      AS idOutros,');
      qry.SQL.Add('  pha.forma_acesso                   AS formaAcesso,');
      qry.SQL.Add('  pha.observacao_acesso              AS observacaoAcesso,');
      qry.SQL.Add('  pha.data_solicitado                AS dataSolicitado,');
      qry.SQL.Add('  pha.data_inicio                    AS dataInicio,');
      qry.SQL.Add('  pha.data_fim                       AS dataFim,');
      qry.SQL.Add('  pha.status_acesso                  AS statusAcesso,');
      qry.SQL.Add('  pha.numero_solicitacao             AS numeroSolicitacao,');
      qry.SQL.Add('  pha.tratativa_acessos              AS tratativaAcessos,');
      qry.SQL.Add('  pha.du_id                          AS duId,');
      qry.SQL.Add('  pha.du_name                        AS duName,');
      qry.SQL.Add('  pha.status_att                     AS statusAtt,');
      qry.SQL.Add('  pha.meta_plan                      AS metaPlan,');
      qry.SQL.Add('  pha.atividade_escopo               AS atividadeEscopo,');
      qry.SQL.Add('  pha.acionamentos_recentes          AS acionamentosRecentes,');
      qry.SQL.Add('  pha.updated_by                     AS updatedBy,');
      qry.SQL.Add('  pha.updated_at                     AS updatedAt,');
      qry.SQL.Add('  eq.acesso_equipe_nomes             AS acessoEquipeNomes,');
      qry.SQL.Add('  eq.acesso_equipe_count             AS acessoEquipeCount,');
      qry.SQL.Add('  eq.acesso_equipe_ids_csv           AS acessoEquipeIdsCsv,');
      qry.SQL.Add('  CONCAT(''['', eq.acesso_equipe_ids_csv, '']'') AS acessoEquipeJson');

      qry.SQL.Add('FROM rollouthuawei r');
      qry.SQL.Add('LEFT JOIN ProjetoHuawei ph');
      qry.SQL.Add('  ON (ph.primaryKey = r.id OR ph.primaryKey LIKE CONCAT(r.id, ''|%''))');
      qry.SQL.Add('LEFT JOIN ProjetoHuaweiAcesso pha');
      qry.SQL.Add('  ON pha.id_projeto = ph.id');
      qry.SQL.Add('LEFT JOIN (');
      qry.SQL.Add('  SELECT');
      qry.SQL.Add('    pae.id_acesso,');
      qry.SQL.Add('    GROUP_CONCAT(gp.nome ORDER BY gp.nome SEPARATOR '', '') AS acesso_equipe_nomes,');
      qry.SQL.Add('    COUNT(*) AS acesso_equipe_count,');
      qry.SQL.Add('    GROUP_CONCAT(pae.id_pessoa ORDER BY gp.nome) AS acesso_equipe_ids_csv');
      qry.SQL.Add('  FROM ProjetoHuaweiAcessoEquipe pae');
      qry.SQL.Add('  LEFT JOIN gespessoa gp ON gp.idpessoa = pae.id_pessoa');
      qry.SQL.Add('  GROUP BY pae.id_acesso');
      qry.SQL.Add(') eq ON eq.id_acesso = pha.id');

      qry.SQL.Add('WHERE 1=1');
      if hasId then
      begin
        qry.SQL.Add('  AND r.id = :p_id');
        qry.ParamByName('p_id').AsString := Trim(vId);
      end;

      vBusca := '%' + Trim(vBusca) + '%';
      qry.SQL.Add('  AND (');
      qry.SQL.Add('       r.name LIKE :busca');
      qry.SQL.Add('    OR ph.sitename LIKE :busca');
      qry.SQL.Add('    OR ph.sitecode LIKE :busca');
      qry.SQL.Add('    OR pha.municipio LIKE :busca');
      qry.SQL.Add('    OR pha.regiao LIKE :busca');
      qry.SQL.Add('    OR eq.acesso_equipe_nomes LIKE :busca');
      qry.SQL.Add('  )');
      qry.ParamByName('busca').AsString := vBusca;

      qry.SQL.Add('ORDER BY r.idgeral DESC');
      qry.SQL.Add('LIMIT :p_limit OFFSET :p_offset');
      qry.ParamByName('p_limit').AsInteger  := limite;
      qry.ParamByName('p_offset').AsInteger := desloc;
    end;

    qry.Open;
    Result := qry;

  except
    on E: Exception do
    begin
      erro := 'Erro ao listar rollouthuawei: ' + E.Message;
      qry.Free;
      Result := nil;
    end;
  end;
end;


function THuawei.EditarEmMassa(const AJsonBody: string; out erro: string): Boolean;
type
  TStrStr = TDictionary<string, string>;
var
  Root: TJSONValue;
  Obj, Item: TJSONObject;
  Arr: TJSONArray;
  QBuscaProjeto, QCheckAcesso, QUpd, QIns, QDelEq, QInsEq, QAcessoId: TFDQuery;
  MapCols: TStrStr;

  function GetStr(JO: TJSONObject; const K: string): string;
  var V: TJSONValue;
  begin
    V := JO.GetValue(K);
    if Assigned(V) then Result := Trim(V.Value) else Result := '';
  end;

  function JKeys(JO: TJSONObject): TArray<string>;
  var P: TJSONPair; L: TList<string>;
  begin
    L := TList<string>.Create;
    try
      for P in JO do L.Add(P.JsonString.Value);
      Result := L.ToArray;
    finally
      L.Free;
    end;
  end;

  function EnsureParam(Q: TFDQuery; const AName: string): TFDParam;
  begin
    Result := Q.Params.FindParam(AName);
    if Result = nil then
    begin
      Result := Q.Params.Add as TFDParam;
      Result.Name := AName;
      Result.DataType := ftString;
      Result.ParamType := ptInput;
    end;
    Result.Clear;
  end;

  procedure BuildMap;
  begin
    MapCols := TStrStr.Create;
    MapCols.Add('tipo_infra','tipo_infra');      MapCols.Add('tipodeinfra','tipo_infra');
    MapCols.Add('quadrante','quadrante');
    MapCols.Add('ddd','ddd');
    MapCols.Add('municipio','municipio');
    MapCols.Add('regiao','regiao');
    MapCols.Add('endereco','endereco');
    MapCols.Add('latitude','latitude');
    MapCols.Add('longitude','longitude');
    MapCols.Add('detentor_area','detentor_area'); MapCols.Add('detentordaarea','detentor_area');
    MapCols.Add('id_detentora','id_detentora');   MapCols.Add('iddetentora','id_detentora');
    MapCols.Add('id_outros','id_outros');         MapCols.Add('idoutros','id_outros');
    MapCols.Add('forma_acesso','forma_acesso');   MapCols.Add('formaacesso','forma_acesso');
    MapCols.Add('observacao_acesso','observacao_acesso'); MapCols.Add('observacaoacesso','observacao_acesso');
    MapCols.Add('data_solicitado','data_solicitado');     MapCols.Add('datasolicitado','data_solicitado');
    MapCols.Add('data_inicio','data_inicio');             MapCols.Add('datainicio','data_inicio');
    MapCols.Add('data_fim','data_fim');                   MapCols.Add('datafim','data_fim');
    MapCols.Add('status_acesso','status_acesso');         MapCols.Add('statusacesso','status_acesso');
    MapCols.Add('numero_solicitacao','numero_solicitacao'); MapCols.Add('numerosolicitacao','numero_solicitacao');
    MapCols.Add('tratativa_acessos','tratativa_acessos');   MapCols.Add('tratativaacessos','tratativa_acessos');
    MapCols.Add('du_id','du_id');                         MapCols.Add('duid','du_id');
    MapCols.Add('du_name','du_name');                     MapCols.Add('duname','du_name');
    MapCols.Add('status_att','status_att');               MapCols.Add('statusatt','status_att');
    MapCols.Add('meta_plan','meta_plan');                 MapCols.Add('metaplan','meta_plan');
    MapCols.Add('atividade_escopo','atividade_escopo');   MapCols.Add('atividadeescopo','atividade_escopo');
    MapCols.Add('acionamentos_recentes','acionamentos_recentes'); MapCols.Add('acionamentosrecentes','acionamentos_recentes');
    MapCols.Add('updated_by','updated_by');               MapCols.Add('updatedby','updated_by');
  end;

  procedure UpsertAcesso(const IdProjeto: string; Row: TJSONObject);
  var
    Keys: TArray<string>;
    K, Col, ParamName, Sets, Cols, Pms, V: string;
    HasAcesso: Boolean;
  begin
    QCheckAcesso.Close;
    QCheckAcesso.ParamByName('id_projeto').AsString := IdProjeto;
    QCheckAcesso.Open;
    HasAcesso := not QCheckAcesso.IsEmpty;

    if HasAcesso then
    begin
      Sets := '';
      Keys := JKeys(Row);
      for K in Keys do
      begin
        if SameText(K, 'id') or SameText(K, 'equipe') then Continue;
        if MapCols.TryGetValue(LowerCase(K), Col) then
        begin
          V := GetStr(Row, K);
          if V = '' then Continue;
          if Sets <> '' then Sets := Sets + ', ';
          ParamName := 'p_' + Col;
          Sets := Sets + Col + ' = :' + ParamName;
        end;
      end;
      if Sets <> '' then
      begin
        Sets := Sets + ', updated_at = NOW()';
        QUpd.SQL.Text := 'UPDATE ProjetoHuaweiAcesso SET ' + Sets + ' WHERE id_projeto = :id_projeto';
        QUpd.Params.Clear;
        for K in Keys do
        begin
          if SameText(K, 'id') or SameText(K, 'equipe') then Continue;
          if MapCols.TryGetValue(LowerCase(K), Col) then
          begin
            V := GetStr(Row, K);
            if V = '' then Continue;
            ParamName := 'p_' + Col;
            EnsureParam(QUpd, ParamName).AsString := V;
          end;
        end;
        EnsureParam(QUpd, 'id_projeto').AsString := IdProjeto;
        QUpd.ExecSQL;
      end;
    end
    else
    begin
      Cols := 'id_projeto';
      Pms  := ':id_projeto';
      Keys := JKeys(Row);
      for K in Keys do
      begin
        if SameText(K, 'id') or SameText(K, 'equipe') then Continue;
        if MapCols.TryGetValue(LowerCase(K), Col) then
        begin
          V := GetStr(Row, K);
          if V = '' then Continue;
          Cols := Cols + ', ' + Col;
          Pms  := Pms  + ', :p_' + Col;
        end;
      end;
      QIns.SQL.Text := 'INSERT INTO ProjetoHuaweiAcesso (' + Cols + ') VALUES (' + Pms + ')';
      QIns.Params.Clear;
      EnsureParam(QIns, 'id_projeto').AsString := IdProjeto;
      for K in Keys do
      begin
        if SameText(K, 'id') or SameText(K, 'equipe') then Continue;
        if MapCols.TryGetValue(LowerCase(K), Col) then
        begin
          V := GetStr(Row, K);
          if V = '' then Continue;
          EnsureParam(QIns, 'p_' + Col).AsString := V;
        end;
      end;
      QIns.ExecSQL;
    end;
  end;

  procedure UpsertEquipe(const IdProjeto: string; Row: TJSONObject);
  var
    EquipeStr: string;
    Pessoas: TArray<string>;
    Pessoa: string;
    AcessoId: Int64;
  begin
    EquipeStr := GetStr(Row, 'equipe');
    if EquipeStr = '' then Exit;

    QAcessoId.Close;
    QAcessoId.ParamByName('p').AsString := IdProjeto;
    QAcessoId.Open;
    while not QAcessoId.Eof do
    begin
      AcessoId := QAcessoId.FieldByName('id').AsLargeInt;
      QDelEq.Params.Clear;
      EnsureParam(QDelEq, 'id_acesso').AsLargeInt := AcessoId;
      QDelEq.ExecSQL;

      Pessoas := EquipeStr.Split([',']);
      for Pessoa in Pessoas do
      begin
        if Trim(Pessoa) = '' then Continue;
        QInsEq.Params.Clear;
        EnsureParam(QInsEq, 'id_acesso').AsLargeInt := AcessoId;
        EnsureParam(QInsEq, 'id_pessoa').AsString := Trim(Pessoa);
        QInsEq.ExecSQL;
      end;

      QAcessoId.Next;
    end;
  end;

  procedure ProcessOneId(const IdLike: string; Row: TJSONObject);
  var
    IdProjeto: string;
  begin
    QBuscaProjeto.Close;
    QBuscaProjeto.ParamByName('pk').AsString := '%' + Trim(IdLike) + '%';
    QBuscaProjeto.Open;
    if QBuscaProjeto.IsEmpty then Exit;
    IdProjeto := QBuscaProjeto.FieldByName('id').AsString;
    UpsertAcesso(IdProjeto, Row);
    UpsertEquipe(IdProjeto, Row);
  end;

  procedure ProcessIds(const IdsStr: string; Row: TJSONObject);
  var
    Ids: TArray<string>;
    S: string;
  begin
    if Trim(IdsStr) = '' then Exit;
    Ids := IdsStr.Split([',']);
    for S in Ids do
      ProcessOneId(S, Row);
  end;

  procedure ProcessRow(Row: TJSONObject);
  begin
    ProcessIds(GetStr(Row, 'id'), Row);
  end;

  procedure ProcessRoot;
  var I: Integer;
  begin
    if Root is TJSONObject then
    begin
      Obj := TJSONObject(Root);
      if Obj.TryGetValue<TJSONArray>('data', Arr) then
      begin
        for I := 0 to Arr.Count - 1 do
          if Arr.Items[I] is TJSONObject then
            ProcessRow(TJSONObject(Arr.Items[I]));
      end
      else
        ProcessRow(Obj);
    end
    else if Root is TJSONArray then
    begin
      Arr := TJSONArray(Root);
      for I := 0 to Arr.Count - 1 do
        if Arr.Items[I] is TJSONObject then
          ProcessRow(TJSONObject(Arr.Items[I]));
    end;
  end;

begin
  Result := False;
  erro := '';
  if not Assigned(FConn) then
  begin
    erro := 'Conexão não inicializada';
    Exit;
  end;

  Root := TJSONObject.ParseJSONValue(AJsonBody);
  if not Assigned(Root) then
  begin
    erro := 'JSON inválido';
    Exit;
  end;

  QBuscaProjeto := TFDQuery.Create(nil);
  QCheckAcesso  := TFDQuery.Create(nil);
  QUpd          := TFDQuery.Create(nil);
  QIns          := TFDQuery.Create(nil);
  QDelEq        := TFDQuery.Create(nil);
  QInsEq        := TFDQuery.Create(nil);
  QAcessoId     := TFDQuery.Create(nil);
  BuildMap;
  try
    QBuscaProjeto.Connection := FConn;
    QCheckAcesso.Connection  := FConn;
    QUpd.Connection          := FConn;
    QIns.Connection          := FConn;
    QDelEq.Connection        := FConn;
    QInsEq.Connection        := FConn;
    QAcessoId.Connection     := FConn;

    QBuscaProjeto.SQL.Text := 'SELECT id FROM ProjetoHuawei WHERE primaryKey LIKE :pk LIMIT 1';
    QCheckAcesso.SQL.Text  := 'SELECT id FROM ProjetoHuaweiAcesso WHERE id_projeto = :id_projeto LIMIT 1';
    QAcessoId.SQL.Text     := 'SELECT id FROM ProjetoHuaweiAcesso WHERE id_projeto = :p';
    QDelEq.SQL.Text        := 'DELETE FROM ProjetoHuaweiAcessoEquipe WHERE id_acesso = :id_acesso';
    QInsEq.SQL.Text        := 'INSERT INTO ProjetoHuaweiAcessoEquipe (id_acesso, id_pessoa) VALUES (:id_acesso, :id_pessoa)';

    FConn.StartTransaction;
    try
      ProcessRoot;
      FConn.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao editar em massa: ' + E.Message;
      end;
    end;
  finally
    MapCols.Free;
    QAcessoId.Free;
    QInsEq.Free;
    QDelEq.Free;
    QIns.Free;
    QUpd.Free;
    QCheckAcesso.Free;
    QBuscaProjeto.Free;
    Root.Free;
  end;
end;


function THuawei.ListaEquipeAcesso(const idAcesso: Integer; out erro: string): TFDQuery;
var
  Q: TFDQuery;
begin
  erro := '';
  Result := nil;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT pae.id_acesso, pae.id_pessoa ' +
      'FROM ProjetoHuaweiAcessoEquipe pae ' +
      'WHERE pae.id_acesso = :p_id';
    Q.ParamByName('p_id').AsInteger := idAcesso;
    Q.Open;

    Result := Q; // retorna aberto (id_acesso, id_pessoa)
  except
    on E: Exception do
    begin
      erro := 'Erro ao listar equipe do acesso: ' + E.Message;
      Q.Free;
    end;
  end;
end;

function THuawei.SalvarAcesso(const Body: TJSONObject; out erro: string; out R: THuaweiAcessoSaveResult): Boolean;
var
  q: TFDQuery;
  projLookup: TFDQuery;
  projId, acessoId: Integer;
  pk: string;

  function JStr(const Key: string): string;
  var V: TJSONValue;
  begin
    V := Body.GetValue(Key);
    Result := IfThen(Assigned(V), Trim(V.Value), '');
  end;

  procedure SetDateParam(AParam: TFDParam; const ISO: string);
  var
    DT: TDateTime;
  begin
    AParam.DataType := ftDate;
    if ISO.Trim = '' then
      AParam.Clear
    else
    begin
      try
        DT := ISO8601ToDate(ISO);
      except
        DT := EncodeDate(StrToInt(Copy(ISO, 1, 4)), StrToInt(Copy(ISO, 6, 2)), StrToInt(Copy(ISO, 9, 2)));
      end;
      AParam.AsDate := DT;
    end;
  end;

  procedure UpsertEquipe(AcessoID: Integer);
  var
    arr: TJSONArray;
    i, idpessoa: Integer;
    qi: TFDQuery;
    V: TJSONValue;
  begin
    V := Body.GetValue('equipeAtt');
    if not Assigned(V) then Exit;
    if not (V is TJSONArray) then Exit;

    arr := TJSONArray(V);

    qi := TFDQuery.Create(nil);
    try
      qi.Connection := FConn;
      qi.SQL.Text := 'DELETE FROM ProjetoHuaweiAcessoEquipe WHERE id_acesso = :a';
      qi.ParamByName('a').AsInteger := AcessoID;
      qi.ExecSQL;

      if arr.Count > 0 then
      begin
        qi.SQL.Text := 'INSERT INTO ProjetoHuaweiAcessoEquipe (id_acesso, id_pessoa) VALUES (:a, :p)';
        for i := 0 to arr.Count - 1 do
        begin
          idpessoa := StrToIntDef(arr.Items[i].Value, 0);
          if idpessoa > 0 then
          begin
            qi.ParamByName('a').AsInteger := AcessoID;
            qi.ParamByName('p').AsInteger := idpessoa;
            qi.ExecSQL;
          end;
        end;
      end;
    finally
      qi.Free;
    end;
  end;

begin
  Result := False;
  erro := '';
  R.AcessoID := 0;

  if not Assigned(FConn) then
  begin
    erro := 'Conexão não inicializada';
    Exit;
  end;

  pk := JStr('idrollout');
  if pk = '' then
  begin
    erro := 'idrollout (primaryKey) não informado.';
    Exit;
  end;

  projLookup := TFDQuery.Create(nil);
  try
    projLookup.Connection := FConn;
    projLookup.SQL.Text :=
      'SELECT id FROM ProjetoHuawei '+
      'WHERE (primaryKey = :pk OR primaryKey LIKE CONCAT(:pk, ''|%'')) '+
      'LIMIT 1';
    projLookup.ParamByName('pk').AsString := pk;
    projLookup.Open;

    if projLookup.IsEmpty then
    begin
      projLookup.Close;
      projLookup.SQL.Text :=
        'SELECT ph.id '+
        'FROM rollouthuawei r '+
        'JOIN ProjetoHuawei ph '+
        '  ON (ph.primaryKey = r.id OR ph.primaryKey LIKE CONCAT(r.id, ''|%'')) '+
        'WHERE (r.id = :pk OR r.idgeral = :pk) '+
        'LIMIT 1';
      projLookup.ParamByName('pk').AsString := pk;
      projLookup.Open;
    end;

    if projLookup.IsEmpty then
    begin
      erro := 'ProjetoHuawei não encontrado para a primaryKey informada.';
      Exit;
    end;

    projId := projLookup.FieldByName('id').AsInteger;
  finally
    projLookup.Free;
  end;

  q := TFDQuery.Create(nil);
  try
    q.Connection := FConn;
    q.SQL.Text :=
      'INSERT INTO ProjetoHuaweiAcesso (' +
      '  id_projeto, tipo_infra, quadrante, ddd, municipio, endereco, latitude, longitude,' +
      '  detentor_area, id_detentora, id_outros, forma_acesso, observacao_acesso,' +
      '  data_solicitado, data_inicio, data_fim, status_acesso, numero_solicitacao,' +
      '  tratativa_acessos, du_id, du_name, status_att, meta_plan, atividade_escopo,' +
      '  acionamentos_recentes, regiao, updated_by, updated_at' +
      ') VALUES (' +
      '  :id_projeto, :tipo_infra, :quadrante, :ddd, :municipio, :endereco, :latitude, :longitude,' +
      '  :detentor_area, :id_detentora, :id_outros, :forma_acesso, :observacao_acesso,' +
      '  :data_solicitado, :data_inicio, :data_fim, :status_acesso, :numero_solicitacao,' +
      '  :tratativa_acessos, :du_id, :du_name, :status_att, :meta_plan, :atividade_escopo,' +
      '  :acionamentos_recentes, :regiao, :updated_by, NOW()' +
      ') ON DUPLICATE KEY UPDATE ' +
      '  id = LAST_INSERT_ID(id),' +
      '  tipo_infra=VALUES(tipo_infra),' +
      '  quadrante=VALUES(quadrante),' +
      '  ddd=VALUES(ddd),' +
      '  municipio=VALUES(municipio),' +
      '  endereco=VALUES(endereco),' +
      '  latitude=VALUES(latitude),' +
      '  longitude=VALUES(longitude),' +
      '  detentor_area=VALUES(detentor_area),' +
      '  id_detentora=VALUES(id_detentora),' +
      '  id_outros=VALUES(id_outros),' +
      '  forma_acesso=VALUES(forma_acesso),' +
      '  observacao_acesso=VALUES(observacao_acesso),' +
      '  data_solicitado=VALUES(data_solicitado),' +
      '  data_inicio=VALUES(data_inicio),' +
      '  data_fim=VALUES(data_fim),' +
      '  status_acesso=VALUES(status_acesso),' +
      '  numero_solicitacao=VALUES(numero_solicitacao),' +
      '  tratativa_acessos=VALUES(tratativa_acessos),' +
      '  du_id=VALUES(du_id),' +
      '  du_name=VALUES(du_name),' +
      '  status_att=VALUES(status_att),' +
      '  meta_plan=VALUES(meta_plan),' +
      '  atividade_escopo=VALUES(atividade_escopo),' +
      '  acionamentos_recentes=VALUES(acionamentos_recentes),' +
      '  regiao=VALUES(regiao),' +
      '  updated_by=VALUES(updated_by),' +
      '  updated_at=NOW()';

    q.ParamByName('id_projeto').DataType := ftInteger;
    q.ParamByName('id_projeto').AsInteger := projId;

    q.ParamByName('tipo_infra').AsString := JStr('tipoDeInfra');
    q.ParamByName('quadrante').AsString := JStr('quadrante');
    q.ParamByName('ddd').AsString := JStr('ddd');
    q.ParamByName('municipio').AsString := JStr('municipio');
    q.ParamByName('endereco').AsString := JStr('endereco');

    // latitude/longitude como string (colunas VARCHAR)
    q.ParamByName('latitude').DataType  := ftString;
    q.ParamByName('longitude').DataType := ftString;
    q.ParamByName('latitude').AsString  := JStr('latitude');
    q.ParamByName('longitude').AsString := JStr('longitude');

    q.ParamByName('detentor_area').AsString := JStr('detentorDaArea');
    q.ParamByName('id_detentora').AsString := JStr('idDetentora');
    q.ParamByName('id_outros').AsString := JStr('idOutros');
    q.ParamByName('forma_acesso').AsString := JStr('formaAcesso');
    q.ParamByName('observacao_acesso').AsString := JStr('observacaoDeAcesso');

    SetDateParam(q.ParamByName('data_solicitado'), JStr('dataSolicitado'));
    SetDateParam(q.ParamByName('data_inicio'),     JStr('dataInicio'));
    SetDateParam(q.ParamByName('data_fim'),        JStr('dataFim'));

    q.ParamByName('status_acesso').AsString := JStr('statusAcesso');
    q.ParamByName('numero_solicitacao').AsString := JStr('numeroDeSolicitacao');
    q.ParamByName('tratativa_acessos').AsString := JStr('tratativaDeAcessos');
    q.ParamByName('du_id').AsString := JStr('duId');
    q.ParamByName('du_name').AsString := JStr('duName');
    q.ParamByName('status_att').AsString := JStr('statusAtt');
    q.ParamByName('meta_plan').AsString := JStr('metaPlan');
    q.ParamByName('atividade_escopo').AsString := JStr('atividadeEscopo');
    q.ParamByName('acionamentos_recentes').AsString := JStr('acionamentosRecentes');
    q.ParamByName('regiao').AsString := JStr('regiao');
    q.ParamByName('updated_by').AsString := JStr('idusuario');

    FConn.StartTransaction;
    try
      q.ExecSQL;

      acessoId := StrToIntDef(VarToStr(FConn.ExecSQLScalar('SELECT LAST_INSERT_ID()')), 0);
      if acessoId = 0 then
        acessoId := StrToIntDef(VarToStr(FConn.ExecSQLScalar('SELECT id FROM ProjetoHuaweiAcesso WHERE id_projeto = :p', [projId])), 0);

      if acessoId = 0 then
        raise Exception.Create('Falha ao determinar ID do acesso.');

      UpsertEquipe(acessoId);
      FConn.Commit;
    except
      on E: Exception do
      begin
        FConn.Rollback;
        raise;
      end;
    end;

    R.AcessoID := acessoId;
    Result := True;
  except
    on E: Exception do
    begin
      erro := 'Erro ao salvar acesso: ' + E.Message;
      Result := False;
    end;
  end;
end;


function THuawei.InserirHuaweiRollout(obj: TJSONObject; out erro: string): boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.PesquisarHuaweiPorPrimaryKeyRollout(primaryKey: string; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.Listafechamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.Listaconsolidado(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.ListaDespesas(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.extratopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.totalacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

end.



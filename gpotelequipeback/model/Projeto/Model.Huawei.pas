unit Model.Huawei;

interface

uses
  // 🔹 System e utilitários básicos
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Windows,
  System.StrUtils,
  System.JSON,
  System.Variants,
  System.Generics.Collections,
  System.Generics.Defaults,
  DateUtils,
  ActiveX,
  ComObj,
  // 🔹 FireDAC (banco de dados)
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  FireDAC.Stan.Option,
  FireDAC.DApt,
  Data.DB,

  // 🔹 Framework e projeto
  Horse,
  model.connection,
  Model.Email,
  UtFuncao;


type
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
    function ExportRolloutHuawei(const AQuery: TDictionary<string, string>; out erro: string): string;
    function RolloutHuawei(const AQuery: TDictionary<string,string>;  out erro: string): TFDQuery;
    function GetJSONValueAsVariant(AJsonValue: TJSONValue; AFieldType: TFieldType): Variant;

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
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.Editar(out erro: string): Boolean;
begin
  Result := False;
  erro := 'Implementação pendente';
end;

function THuawei.ListarHuawei(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  erro := '';
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    
    if AQuery.ContainsKey('agrupado') then
    begin
      qry.SQL.Text := 'SELECT manufactureSiteInfo, COUNT(*) AS occurrences FROM ProjetoHuawei';
      
      if AQuery.ContainsKey('busca') and (Length(AQuery.Items['busca']) > 0) then
      begin
        qry.SQL.Add(' WHERE (manufactureSiteInfo LIKE :busca OR poNumber LIKE :busca OR subProjectCode LIKE :busca)');
        qry.ParamByName('busca').AsString := '%' + AQuery.Items['busca'] + '%';
      end;
      
      qry.SQL.Add(' GROUP BY manufactureSiteInfo');
    end
    else
    begin
      qry.SQL.Text := 'SELECT * FROM ProjetoHuawei WHERE 1 = 1';
      
      if AQuery.ContainsKey('busca') and (Length(AQuery.Items['busca']) > 0) then
      begin
        qry.SQL.Add(' AND (manufactureSiteInfo LIKE :busca OR poNumber LIKE :busca OR subProjectCode LIKE :busca)');
        qry.ParamByName('busca').AsString := '%' + AQuery.Items['busca'] + '%';
      end;
    end;
    
    qry.SQL.Add(' ORDER BY poNumber DESC');
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
begin
  Result := nil;
  erro := 'Implementação pendente';
end;

function THuawei.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := nil;
  erro := 'Implementação pendente';
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
begin
  Result := nil;
  erro := 'Implementação pendente';
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
  qry: TFDQuery;
  keys: TArray<string>;
  key, value, dbField, whereSQL, sqlFinal: string;
  i, j: Integer;
  fieldMap: TDictionary<string, string>;
  dateFields, datetimeFields, intFields, floatFields: TDictionary<string, Boolean>;
  isDate, isDateTime, isInt, isFloat: Boolean;
  dt: TDateTime;
  IncludedKeys: TStringList;
  validCols: TDictionary<string, Boolean>;
  metaQry: TFDQuery;
  colUpper: string;
  hasTime: Boolean;
begin
  Result := nil;
  erro := '';
  whereSQL := '';
  sqlFinal := '';

  if not Assigned(FConn) then
    FConn.LoginPrompt := False;

  if not FConn.Connected then
  begin
    try
      FConn.Open;
    except
      on E: Exception do
      begin
        erro := 'Falha ao conectar ao banco: ' + E.Message;
        Exit;
      end;
    end;
  end;

  if not Assigned(AQuery) then
  begin
    erro := 'Parâmetros de consulta não fornecidos';
    Exit;
  end;

  fieldMap := TDictionary<string, string>.Create;
  dateFields := TDictionary<string, Boolean>.Create;
  datetimeFields := TDictionary<string, Boolean>.Create;
  intFields := TDictionary<string, Boolean>.Create;
  floatFields := TDictionary<string, Boolean>.Create;
  IncludedKeys := TStringList.Create;
  try
    // --- Mapeamento de campos ---
    fieldMap.Add('name', 'Name');
    fieldMap.Add('projeto', 'Projeto');
    fieldMap.Add('endSite', 'End_Site');
    fieldMap.Add('du', 'DU');
    fieldMap.Add('statusGeral', 'Status_geral');
    fieldMap.Add('liderResponsavel', 'Lider_responsavel');
    fieldMap.Add('empresa', 'Empresa');
    fieldMap.Add('ativoNoPeriodo', 'Ativo_no_periodo');
    fieldMap.Add('fechamento', 'Fechamento');
    fieldMap.Add('anoSemanaFechamento', 'Ano_Semana_Fechamento');
    fieldMap.Add('descricaoAdd', 'Descricao_add');
    fieldMap.Add('numeroVo', 'Numero_VO');
    fieldMap.Add('infra', 'Infra');
    fieldMap.Add('town', 'Town');
    fieldMap.Add('reg', 'Reg');
    fieldMap.Add('ddd', 'DDD');
    fieldMap.Add('envioDaDemanda', 'Envio_da_demanda');
    fieldMap.Add('mosPlanned', 'MOS_Planned');
    fieldMap.Add('mosReal', 'MOS_Real');
    fieldMap.Add('mosStatus', 'MOS_Status');
    fieldMap.Add('integrationPlanned', 'Integration_Planned');
    fieldMap.Add('integrationReal', 'Integration_Real');
    fieldMap.Add('statusIntegracao', 'Status_integracao');
    fieldMap.Add('testeTx', 'Teste_TX');
    fieldMap.Add('iti', 'ITI');
    fieldMap.Add('qcPlanned', 'QC_Planned');
    fieldMap.Add('qcReal', 'QC_Real');
    fieldMap.Add('semanaQc', 'Semana_QC');
    fieldMap.Add('qcStatus', 'QC_Status');
    fieldMap.Add('observacao', 'Observacao');
    fieldMap.Add('logisticaReversaStatus', 'Logistica_reversa_Status');
    fieldMap.Add('detentora', 'Detentora');
    fieldMap.Add('idDententora', 'ID_Dententora');
    fieldMap.Add('idDetentora', 'ID_Dententora');
    fieldMap.Add('formaDeAcesso', 'Forma_de_acesso');
    fieldMap.Add('faturamento', 'Faturamento');
    fieldMap.Add('faturamentoStatus', 'Faturamento_Status');
    fieldMap.Add('idOriginal', 'ID_Original');
    fieldMap.Add('changeHistory', 'Change_History');
    fieldMap.Add('repOffice', 'Rep_Office');
    fieldMap.Add('projectCode', 'Project_Code');
    fieldMap.Add('siteCode', 'Site_Code');
    fieldMap.Add('siteName', 'Site_Name');
    fieldMap.Add('siteId', 'Site_ID');
    fieldMap.Add('subContractNo', 'Sub_Contract_NO');
    fieldMap.Add('prNo', 'PR_NO');
    fieldMap.Add('poNo', 'PO_NO');
    fieldMap.Add('poLineNo', 'PO_Line_NO');
    fieldMap.Add('shipmentNo', 'Shipment_NO');
    fieldMap.Add('itemCode', 'Item_Code');
    fieldMap.Add('itemDescription', 'Item_Description');
    fieldMap.Add('itemDescriptionLocal', 'Item_Description_Local');
    fieldMap.Add('unitPrice', 'Unit_Price');
    fieldMap.Add('requestedQty', 'Requested_Qty');
    fieldMap.Add('valorTelequipe', 'Valor_Telequipe');
    fieldMap.Add('valorEquipe', 'Valor_Equipe');
    fieldMap.Add('billedQuantity', 'Billed_Quantity');
    fieldMap.Add('quantityCancel', 'Quantity_Cancel');
    fieldMap.Add('dueQty', 'Due_Qty');
    fieldMap.Add('noteToReceiver', 'Note_to_Receiver');
    fieldMap.Add('fobLookupCode', 'Fob_Lookup_Code');
    fieldMap.Add('acceptanceDate', 'Acceptance_Date');
    fieldMap.Add('prPoAutomationSolutionOnlyChina', 'PR_PO_Automation_Solution_Only_China');
    fieldMap.Add('pessoa', 'Pessoa');
    fieldMap.Add('ultimaAtualizacao', 'Ultima_atualizacao');

    // Tipos
    dateFields.Add('fechamento', True);
    dateFields.Add('envioDaDemanda', True);
    dateFields.Add('mosPlanned', True);
    dateFields.Add('mosReal', True);
    dateFields.Add('integrationPlanned', True);
    dateFields.Add('integrationReal', True);
    dateFields.Add('qcPlanned', True);
    dateFields.Add('qcReal', True);

    datetimeFields.Add('acceptanceDate', True);
    datetimeFields.Add('ultimaAtualizacao', True);

    intFields.Add('requestedQty', True);
    intFields.Add('billedQuantity', True);
    intFields.Add('quantityCancel', True);
    intFields.Add('dueQty', True);

    floatFields.Add('unitPrice', True);
    floatFields.Add('valorTelequipe', True);
    floatFields.Add('valorEquipe', True);
    floatFields.Add('faturamento', True);

    // --- Verifica colunas da tabela ---
    validCols := TDictionary<string, Boolean>.Create;
    metaQry := TFDQuery.Create(nil);
    try
      metaQry.Connection := FConn;
      metaQry.SQL.Text := 'SELECT * FROM rollouthuawei LIMIT 1';
      metaQry.Open;
      for j := 0 to metaQry.FieldCount - 1 do
        validCols.AddOrSetValue(UpperCase(metaQry.Fields[j].FieldName), True);
      metaQry.Close;
    finally
      metaQry.Free;
    end;

    // --- Monta o WHERE ---
    keys := AQuery.Keys.ToArray;
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    for i := 0 to High(keys) do
    begin
      key := keys[i];
      value := Trim(AQuery.Items[key]);

      if (value = '') or not fieldMap.ContainsKey(key) then
        Continue;

      dbField := fieldMap[key];
      if not validCols.ContainsKey(UpperCase(dbField)) then
        Continue;

      isDate := dateFields.ContainsKey(key);
      isDateTime := datetimeFields.ContainsKey(key);
      isInt := intFields.ContainsKey(key);
      isFloat := floatFields.ContainsKey(key);

      if isDate or isDateTime then
        if not TryISO8601ToDate(value, dt) then
          Continue;

      if whereSQL <> '' then
        whereSQL := whereSQL + ' AND '
      else
        whereSQL := ' WHERE ';

      hasTime := (Pos('T', value) > 0) or (Pos(':', value) > 0) or (Length(value) > 10);

      // --- Correção principal ---
      if SameText(key, 'ultimaAtualizacao') then
      begin
        if not hasTime then
          whereSQL := whereSQL + 'DATE(`Ultima_atualizacao`) = :' + key
        else
          whereSQL := whereSQL + '`Ultima_atualizacao` = :' + key;
      end
      else if isInt or isFloat or isDate or isDateTime then
        whereSQL := whereSQL + '`' + dbField + '` = :' + key
      else
        whereSQL := whereSQL + '`' + dbField + '` LIKE :' + key;

      IncludedKeys.Add(key);
    end;

    sqlFinal := 'SELECT idgeral, Name, Projeto, End_Site, DU, Status_geral, Lider_responsavel, Empresa, Ativo_no_periodo, Fechamento, Ano_Semana_Fechamento, Confirmacao_pagamento, Descricao_add, Numero_VO, Infra, Town, Latitude, Longitude, Reg, DDD, Envio_da_demanda, MOS_Planned, MOS_Real, Semana_MOS, MOS_Status, Integration_Planned, Teste_TX, Integration_Real, Semana_Integration, Status_integracao, ITI, QC_Planned, QC_Real, Semana_QC, QC_Status, Observacao, Logistica_reversa_Status, Detentora, ID_Dententora, Forma_de_acesso, Faturamento, Faturamento_Status, ID_Original, Change_History, Rep_Office, Project_Code, Site_Code, Site_Name, Site_ID, Sub_Contract_NO, PR_NO, PO_NO, PO_Line_NO, Shipment_NO, Item_Code, Item_Description, Item_Description_Local, Unit_Price, Requested_Qty, Valor_Telequipe, Valor_Equipe, Billed_Quantity, Quantity_Cancel, Due_Qty, Note_to_Receiver, Fob_Lookup_Code, Acceptance_Date, PR_PO_Automation_Solution_Only_China, Pessoa, Ultima_atualizacao, primarykey, id, Ultima_Pessoa_Atualizacao FROM rollouthuawei' + whereSQL;
    qry.SQL.Text := sqlFinal;

    // --- Define parâmetros ---
    for i := 0 to IncludedKeys.Count - 1 do
    begin
      key := IncludedKeys[i];
      value := Trim(AQuery.Items[key]);
      isDate := dateFields.ContainsKey(key);
      isDateTime := datetimeFields.ContainsKey(key);
      isInt := intFields.ContainsKey(key);
      isFloat := floatFields.ContainsKey(key);
      hasTime := (Pos('T', value) > 0) or (Pos(':', value) > 0) or (Length(value) > 10);

      if SameText(key, 'ultimaAtualizacao') then
      begin
        TryISO8601ToDate(value, dt);
        qry.Params.CreateParam(ftDate, key, ptInput);
        qry.ParamByName(key).AsDate := dt;
      end
      else if isInt then
        qry.ParamByName(key).AsInteger := StrToIntDef(value, 0)
      else if isFloat then
        qry.ParamByName(key).AsFloat := StrToFloatDef(StringReplace(value, ',', '.', [rfReplaceAll]), 0)
      else if isDate then
      begin
        TryISO8601ToDate(value, dt);
        qry.ParamByName(key).AsDate := dt;
      end
      else if isDateTime then
      begin
        TryISO8601ToDate(value, dt);
        qry.ParamByName(key).AsDateTime := dt;
      end
      else
        qry.ParamByName(key).AsString := '%' + value + '%';
    end;

    qry.Open;

    if qry.RecordCount = 0 then
    begin
      erro := 'Nenhum registro ativo encontrado';
      Result := qry;
      Exit;
    end;

    Result := qry;

  except
    on E: Exception do
    begin
      erro := 'Erro interno ao preparar query: ' + E.Message;
      if Assigned(qry) then qry.Free;
      Exit;
    end;
  end;
end;

procedure ExportQueryToExcel(Qry: TFDQuery; const FileName: string);
const
  BLOCK_SIZE = 5000; // grava em blocos de 5 mil linhas (evita travamento COM)
var
  ExcelApp, Workbook, Worksheet, HeaderRange: OleVariant;
  i, j, RowCount, ColCount, StartRow, EndRow, BlockSize: Integer;
  DataArr: Variant;
  StartTick, EndTick: Cardinal;
begin
  if not Assigned(Qry) then
    raise Exception.Create('Query não informada.');

  if Qry.IsEmpty then
    raise Exception.Create('Nenhum dado encontrado para exportar.');

  StartTick := GetTickCount; // medir tempo

  CoInitialize(nil);
  try
    // === Inicializa Excel de forma leve ===
    ExcelApp := CreateOleObject('Excel.Application');
    ExcelApp.Visible := False;
    ExcelApp.ScreenUpdating := False;
    ExcelApp.DisplayAlerts := False;
    ExcelApp.EnableEvents := False;
    ExcelApp.AskToUpdateLinks := False;
    ExcelApp.ErrorCheckingOptions.BackgroundChecking := False;
    ExcelApp.AutoRecover.Enabled := False;

    try
      ExcelApp.Calculation := -4135; // xlCalculationManual
    except
      // alguns ambientes não permitem alterar via COM
    end;

    Workbook := ExcelApp.Workbooks.Add;
    Worksheet := Workbook.WorkSheets[1];
    Worksheet.Name := 'Rollout Huawei';

    ColCount := Qry.FieldCount;

    // === Cabeçalhos ===
    for i := 0 to ColCount - 1 do
      Worksheet.Cells[1, i + 1].Value := Qry.Fields[i].FieldName;

    HeaderRange := Worksheet.Range[Worksheet.Cells[1, 1], Worksheet.Cells[1, ColCount]];
    HeaderRange.Font.Bold := True;
    HeaderRange.Interior.Color := $00CCCCCC; // cinza claro

    // === Dados em blocos ===
    Qry.FetchAll;
    RowCount := Qry.RecordCount;

    if RowCount > 0 then
    begin
      BlockSize := BLOCK_SIZE;
      Qry.First;
      StartRow := 1;

      while not Qry.Eof do
      begin
        // calcula o bloco atual
        EndRow := StartRow + BlockSize - 1;
        if EndRow > RowCount then
          EndRow := RowCount;

        // cria o array para o bloco
        DataArr := VarArrayCreate([1, EndRow - StartRow + 1, 1, ColCount], varVariant);

        for i := 1 to (EndRow - StartRow + 1) do
        begin
          for j := 1 to ColCount do
            DataArr[i, j] := VarToStrDef(Qry.Fields[j - 1].AsVariant, '');
          Qry.Next;
          if Qry.Eof then Break;
        end;

        // grava o bloco inteiro no Excel de uma vez
        Worksheet.Range[
          Worksheet.Cells[StartRow + 1, 1],
          Worksheet.Cells[EndRow + 1, ColCount]
        ].Value := DataArr;

        StartRow := EndRow + 1;
      end;
    end;

    // === Ajuste apenas do cabeçalho (muito mais rápido que AutoFit global) ===
    HeaderRange.EntireColumn.AutoFit;

    try
      ExcelApp.Calculation := -4105; // xlCalculationAutomatic
    except
    end;

    ExcelApp.ScreenUpdating := True;

    Workbook.SaveAs(FileName, 51); // 51 = formato XLSX
    Workbook.Close(False);
    ExcelApp.Quit;

    EndTick := GetTickCount;
    Writeln(Format('✅ Excel gerado em %.2f segundos.', [(EndTick - StartTick) / 1000]));

  finally
    ExcelApp := Unassigned;
    Workbook := Unassigned;
    Worksheet := Unassigned;
    HeaderRange := Unassigned;
    CoUninitialize;
  end;
end;


function THuawei.ExportRolloutHuawei(const AQuery: TDictionary<string, string>; out erro: string): string;
var
  qry: TFDQuery;
  FileName: string;
begin
  Result := '';
  qry := RolloutHuawei(AQuery, erro);
  try
    if not Assigned(qry) or qry.IsEmpty then
    begin
      erro := 'Nenhum registro encontrado';
      Exit('');
    end;

    FileName := TPath.Combine(TPath.GetTempPath,
      'RolloutHuawei_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.xlsx');

    ExportQueryToExcel(qry, FileName);
    Result := FileName;
  finally
    qry.Free;
  end;
end;



function THuawei.GetJSONValueAsVariant(AJsonValue: TJSONValue; AFieldType: TFieldType): Variant;
var
  dt: TDateTime;
  strValue: string;
begin
  case AFieldType of
    ftInteger, ftSmallint, ftWord:
      begin
        if AJsonValue is TJSONNumber then
          Result := Trunc(TJSONNumber(AJsonValue).AsDouble)
        else
        begin
          strValue := StringReplace(AJsonValue.ToString, '"', '', [rfReplaceAll]);
          Result := StrToIntDef(strValue, 0);
        end;
      end;
    ftLargeint:
      begin
        if AJsonValue is TJSONNumber then
          Result := Round(TJSONNumber(AJsonValue).AsDouble)
        else
        begin
          strValue := StringReplace(AJsonValue.ToString, '"', '', [rfReplaceAll]);
          Result := StrToInt64Def(strValue, 0);
        end;
      end;
    ftFloat, ftCurrency, ftBCD, ftFMTBcd:
      begin
        if AJsonValue is TJSONNumber then
          Result := TJSONNumber(AJsonValue).AsDouble
        else
        begin
          strValue := StringReplace(AJsonValue.ToString, '"', '', [rfReplaceAll]);
          strValue := StringReplace(strValue, ',', '.', [rfReplaceAll]);
          Result := StrToFloatDef(strValue, 0);
        end;
      end;
    ftDate, ftDateTime, ftTimeStamp:
      begin
        if AJsonValue is TJSONString then
        begin
          strValue := TJSONString(AJsonValue).Value;
          if TryISO8601ToDate(strValue, dt) then
            Result := dt
          else
            Result := strValue;
        end
        else
        begin
          strValue := StringReplace(AJsonValue.ToString, '"', '', [rfReplaceAll]);
          Result := strValue;
        end;
      end;
  else
    begin
      if AJsonValue is TJSONString then
        Result := TJSONString(AJsonValue).Value
      else
      begin
        strValue := StringReplace(AJsonValue.ToString, '"', '', [rfReplaceAll]);
        Result := strValue;
      end;
    end;
  end;
end;

function THuawei.EditarEmMassa(const AJsonBody: string; out erro: string): Boolean;
var
  metaQry, Qry: TFDQuery;
  validCols: TDictionary<string, Boolean>;
  colMap: TDictionary<string, string>;
  colTypes: TDictionary<string, TFieldType>;
  fieldMap: TDictionary<string, string>;
  colUpper, actualName: string;
  j, i: Integer;
  jsonObj: TJSONObject;
  pair: TJSONPair;
  setList: TStringList;
  setSQL, idsValue, keyName, keyUpper, fieldActual, fieldUpper: string;
  ft: TFieldType;
  updatedAny, transStarted: Boolean;
begin
  Result := False;
  erro := '';
  updatedAny := False;
  transStarted := False;

  validCols := TDictionary<string, Boolean>.Create;
  colMap := TDictionary<string, string>.Create;
  colTypes := TDictionary<string, TFieldType>.Create;
  fieldMap := TDictionary<string, string>.Create;
  metaQry := TFDQuery.Create(nil);
  Qry := TFDQuery.Create(nil);
  setList := TStringList.Create;

  try
    // mapeamento frontend -> coluna real
     fieldMap.Add(UpperCase('endSite'), 'End_Site');
    fieldMap.Add(UpperCase('du'), 'DU');
    fieldMap.Add(UpperCase('statusGeral'), 'Status_geral');
    fieldMap.Add(UpperCase('liderResponsavel'), 'Lider_responsavel');
    fieldMap.Add(UpperCase('empresa'), 'Empresa');
    fieldMap.Add(UpperCase('ativoNoPeriodo'), 'Ativo_no_periodo');
    fieldMap.Add(UpperCase('fechamento'), 'Fechamento');
    fieldMap.Add(UpperCase('anoSemanaFechamento'), 'Ano_Semana_Fechamento');
    fieldMap.Add(UpperCase('confirmacaoPagamento'), 'Confirmacao_Pagamento'); // 🔹 ADICIONADO
    fieldMap.Add(UpperCase('descricaoAdd'), 'Descricao_add');
    fieldMap.Add(UpperCase('numeroVo'), 'Numero_VO');
    fieldMap.Add(UpperCase('infra'), 'Infra');
    fieldMap.Add(UpperCase('town'), 'Town');
    fieldMap.Add(UpperCase('latitude'), 'Latitude'); // 🔹 ADICIONADO
    fieldMap.Add(UpperCase('longitude'), 'Longitude'); // 🔹 ADICIONADO
    fieldMap.Add(UpperCase('reg'), 'Reg');
    fieldMap.Add(UpperCase('ddd'), 'DDD');
    fieldMap.Add(UpperCase('envioDaDemanda'), 'Envio_da_demanda');
    fieldMap.Add(UpperCase('semanaMos'), 'Semana_MOS');
    fieldMap.Add(UpperCase('mosPlanned'), 'MOS_Planned');
    fieldMap.Add(UpperCase('mosReal'), 'MOS_Real');
    fieldMap.Add(UpperCase('mosStatus'), 'MOS_Status');
    fieldMap.Add(UpperCase('integrationPlanned'), 'Integration_Planned');
    fieldMap.Add(UpperCase('integrationReal'), 'Integration_Real');
    fieldMap.Add(UpperCase('semanaIntegration'), 'Semana_Integration'); // 🔹 ADICIONADO
    fieldMap.Add(UpperCase('statusIntegracao'), 'Status_integracao');
    fieldMap.Add(UpperCase('testeTx'), 'Teste_TX');
    fieldMap.Add(UpperCase('iti'), 'ITI');
    fieldMap.Add(UpperCase('qcPlanned'), 'QC_Planned');
    fieldMap.Add(UpperCase('qcReal'), 'QC_Real');
    fieldMap.Add(UpperCase('semanaQc'), 'Semana_QC');
    fieldMap.Add(UpperCase('qcStatus'), 'QC_Status');
    fieldMap.Add(UpperCase('observacao'), 'Observacao');
    fieldMap.Add(UpperCase('logisticaReversaStatus'), 'Logistica_reversa_Status');
    fieldMap.Add(UpperCase('detentora'), 'Detentora');
    fieldMap.Add(UpperCase('idDetentora'), 'ID_Detentora');
    fieldMap.Add(UpperCase('formaDeAcesso'), 'Forma_de_acesso');
    fieldMap.Add(UpperCase('faturamento'), 'Faturamento');
    fieldMap.Add(UpperCase('faturamentoStatus'), 'Faturamento_Status');
    fieldMap.Add(UpperCase('changeHistory'), 'Change_History');
    fieldMap.Add(UpperCase('repOffice'), 'Rep_Office');
    fieldMap.Add(UpperCase('projectCode'), 'Project_Code');
    fieldMap.Add(UpperCase('siteCode'), 'Site_Code');
    fieldMap.Add(UpperCase('siteName'), 'Site_Name');
    fieldMap.Add(UpperCase('siteId'), 'Site_ID');
    fieldMap.Add(UpperCase('subContractNo'), 'Sub_Contract_NO');
    fieldMap.Add(UpperCase('prNo'), 'PR_NO');
    fieldMap.Add(UpperCase('poNo'), 'PO_NO');
    fieldMap.Add(UpperCase('poLineNo'), 'PO_Line_NO');
    fieldMap.Add(UpperCase('shipmentNo'), 'Shipment_NO');
    fieldMap.Add(UpperCase('itemCode'), 'Item_Code');
    fieldMap.Add(UpperCase('itemDescription'), 'Item_Description');
    fieldMap.Add(UpperCase('itemDescriptionLocal'), 'Item_Description_Local');
    fieldMap.Add(UpperCase('unitPrice'), 'Unit_Price');
    fieldMap.Add(UpperCase('requestedQty'), 'Requested_Qty');
    fieldMap.Add(UpperCase('valorTelequipe'), 'Valor_Telequipe');
    fieldMap.Add(UpperCase('valorEquipe'), 'Valor_Equipe');
    fieldMap.Add(UpperCase('billedQuantity'), 'Billed_Quantity');
    fieldMap.Add(UpperCase('quantityCancel'), 'Quantity_Cancel');
    fieldMap.Add(UpperCase('dueQty'), 'Due_Qty');
    fieldMap.Add(UpperCase('noteToReceiver'), 'Note_to_Receiver');
    fieldMap.Add(UpperCase('fobLookupCode'), 'Fob_Lookup_Code');
    fieldMap.Add(UpperCase('acceptanceDate'), 'Acceptance_Date');
    fieldMap.Add(UpperCase('prPoAutomationSolutionOnlyChina'), 'PR_PO_Automation_Solution_Only_China');
    fieldMap.Add(UpperCase('pessoa'), 'Pessoa');
    fieldMap.Add(UpperCase('ultimaPessoaAtualizacao'), 'Ultima_Pessoa_Atualizacao'); // 🔹 ADICIONADO
    fieldMap.Add(UpperCase('ultimaAtualizacao'), 'Ultima_Atualizacao'); // 🔹 ADICIONADO
    fieldMap.Add(UpperCase('projeto'), 'Projeto'); // 🔹 ADICIONADO
    fieldMap.Add(UpperCase('name'), 'Name'); // 🔹 ADICIONADO
    fieldMap.Add(UpperCase('idOriginal'), 'ID_Original'); // já existia no original, reincluído


    metaQry.Connection := FConn;
    metaQry.SQL.Text := 'SELECT * FROM rollouthuawei LIMIT 1';
    metaQry.Open;
    for j := 0 to metaQry.FieldCount - 1 do
    begin
      actualName := metaQry.Fields[j].FieldName;
      colUpper := UpperCase(actualName);
      if not validCols.ContainsKey(colUpper) then
      begin
        validCols.Add(colUpper, True);
        colMap.Add(colUpper, actualName);
        colTypes.Add(colUpper, metaQry.Fields[j].DataType);
      end;
    end;
    metaQry.Close;

    // parse do JSON
    jsonObj := TJSONObject.ParseJSONValue(AJsonBody) as TJSONObject;
    if jsonObj = nil then
    begin
      erro := 'JSON inválido';
      Exit;
    end;
    Qry.Connection := FConn;

    try
      if not FConn.InTransaction then
      begin
        FConn.StartTransaction;
        transStarted := True;
      end;

      setList.Clear;
      idsValue := '';

      // Processa cada campo do JSON
      for i := 0 to jsonObj.Count - 1 do
      begin
        pair := jsonObj.Pairs[i];
        keyName := pair.JsonString.Value;
        keyUpper := UpperCase(keyName);

        if SameText(keyUpper, 'id') or SameText(keyUpper, 'Id') then
        begin
          if pair.JsonValue is TJSONString then
            idsValue := TJSONString(pair.JsonValue).Value
          else if pair.JsonValue is TJSONArray then
          begin
            // Se for array, converte para string separada por vírgulas
            idsValue := '';
            for j := 0 to TJSONArray(pair.JsonValue).Count - 1 do
            begin
              if idsValue <> '' then
                idsValue := idsValue + ',';
              idsValue := idsValue + TJSONArray(pair.JsonValue).Items[j].Value;
            end;
          end
          else
            idsValue := StringReplace(pair.JsonValue.ToString, '"', '', [rfReplaceAll]);

          WriteLn('IDs encontrados: ' + idsValue);
          Continue;
        end;

        // Encontra o nome real do campo
        if fieldMap.ContainsKey(keyUpper) then
          fieldActual := fieldMap[keyUpper]
        else if validCols.ContainsKey(keyUpper) then
          fieldActual := colMap[keyUpper]
        else
          fieldActual := keyName;

        if not validCols.ContainsKey(UpperCase(fieldActual)) then
        begin
          LogError('Campo não válido: ' + fieldActual);
          Continue;
        end;
        // Adiciona ao SET
        setList.Add('`' + fieldActual + '` = :' + fieldActual);
      end;

      // Verifica se temos campos para atualizar e IDs
      if (idsValue = '') then
      begin
        erro := 'IDs não especificados';
        WriteLn('ERRO: IDs não especificados');
        Exit;
      end;

      if (setList.Count = 0) then
      begin
        erro := 'Nenhum campo válido para atualizar';
        WriteLn('ERRO: Nenhum campo válido para atualizar');
        Exit;
      end;
      // Constrói o SQL
      setSQL := '';
      for i := 0 to setList.Count - 1 do
      begin
        if setSQL = '' then
          setSQL := setList[i]
        else
          setSQL := setSQL + ', ' + setList[i];
      end;

      // Prepara o UPDATE com WHERE IN usando idgeral
      Qry.SQL.Text := 'UPDATE rollouthuawei SET ' + setSQL + ' WHERE idgeral IN (' + idsValue + ')';
      WriteLn('SQL: ' + Qry.SQL.Text);

      Qry.Params.Clear;

      // Atribui parâmetros (excluindo o campo IDs)
      for i := 0 to jsonObj.Count - 1 do
      begin
        pair := jsonObj.Pairs[i];
        keyName := pair.JsonString.Value;
        keyUpper := UpperCase(keyName);

        if SameText(keyUpper, 'IDGERAL') or SameText(keyUpper, 'IDS') then
          Continue;

        // Encontra o nome real do campo
        if fieldMap.ContainsKey(keyUpper) then
          fieldActual := fieldMap[keyUpper]
        else if validCols.ContainsKey(keyUpper) then
          fieldActual := colMap[keyUpper]
        else
          fieldActual := keyName;

        if not validCols.ContainsKey(UpperCase(fieldActual)) then
          Continue;

        fieldUpper := UpperCase(fieldActual);
        if colTypes.ContainsKey(fieldUpper) then
          ft := colTypes[fieldUpper]
        else
          ft := ftString;

        // Adiciona parâmetro
        with Qry.Params.Add do
        begin
          Name := fieldActual;
          DataType := ft;
          Value := GetJSONValueAsVariant(pair.JsonValue, ft);
        end;
      end;
      try
        Qry.ExecSQL;
        updatedAny := Qry.RowsAffected > 0;
      except
        on E: Exception do
        begin
          erro := 'Erro ao atualizar IDs ' + idsValue + ': ' + E.Message;
          LogError('ERRO no UPDATE: ' + E.Message);
        end;
      end;

      if transStarted then
      begin
        FConn.Commit;
      end;

      Result := updatedAny;

      if not Result and (erro = '') then
        erro := 'Nenhum registro foi atualizado';

    except
      on E: Exception do
      begin
        if transStarted then
        begin
          FConn.Rollback;
          WriteLn('Transação revertida');
        end;
        erro := 'Erro ao atualizar em massa: ' + E.Message;
        LogError('ERRO GERAL: ' + E.Message);
        Result := False;
      end;
    end;
  finally
    validCols.Free;
    colMap.Free;
    colTypes.Free;
    fieldMap.Free;
    metaQry.Free;
    Qry.Free;
    setList.Free;
    if Assigned(jsonObj) then
      jsonObj.Free;
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

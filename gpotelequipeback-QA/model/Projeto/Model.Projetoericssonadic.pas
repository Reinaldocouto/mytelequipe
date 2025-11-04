unit Model.Projetoericssonadic;

interface

uses
  System.JSON, FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections,FireDAC.Stan.Option;

type
  TProjetoericssonadic = class
  private
    FConn: TFDConnection;
    Fidcategoria: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
    Fdescricao: string;

  public
    constructor Create;
    destructor Destroy; override;

    property idcategoria: Integer read Fidcategoria write Fidcategoria;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property descricao: string read Fdescricao write Fdescricao;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Inserir(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;
    function ListaFaturamentoEricsson(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function AtualizarFAT(const dados: TJSONArray; out resultados: TJSONArray): Boolean;
  end;

implementation

{ TProjetoericssonadic }

constructor TProjetoericssonadic.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TProjetoericssonadic.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TProjetoericssonadic.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idcategoria = idcategoria+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idcategoria from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idcategoria := fieldbyname('idcategoria').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idcategoria
    except
      on ex: exception do
      begin
        erro := 'Erro ao consultar : ' + ex.Message;
        Result := 0;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TProjetoericssonadic.Editar(out erro: string): Boolean;
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
        sql.add('select idcategoria from gescategoria where idcliente=:idcliente and idloja=:idloja and idcategoria=:idcategoria ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ParamByName('IDcategoria').AsInteger := IDcategoria;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('INSERT INTO gescategoria(IDcategoria,descricao,idcliente,idloja,deletado)');
          SQL.Add('             VALUES(:IDcategoria,:descricao,:idcliente,:idloja,:deletado)');
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gescategoria set DELETADO=:DELETADO,descricao=:descricao');
          SQL.Add('where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDcategoria =:IDcategoria');
        end;
        ParamByName('idcategoria').Value := idcategoria;
        ParamByName('DESCRICAO').Value := DESCRICAO;
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 0;
        ExecSQL;
      end;
      FConn.Commit;
      erro := '';
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar Categoria: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TProjetoericssonadic.Inserir(out erro: string): Boolean;
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
        SQL.Add('INSERT INTO gescategoria(IDcategoria,DESCRICAO,');
        SQL.Add('IDCLIENTE,IDLOJA,DELETADO)');
        SQL.Add('       VALUES(:IDcategoria,:DESCRICAO,');
        SQL.Add(':IDCLIENTE,:IDLOJA,:DELETADO)');

        ParamByName('IDcategoria').AsInteger := id;
        ParamByName('DESCRICAO').Value := DESCRICAO;
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 0;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar Categoria: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TProjetoericssonadic.AtualizarFAT(const dados: TJSONArray; out resultados: TJSONArray): Boolean;
var
  qry: TFDQuery;
  i: Integer;
  idObraEricsson, po, poritem, novoFAT: string;
  resultadoObj: TJSONObject;
begin
  Result := True;
  resultados := TJSONArray.Create;
  qry := nil;

  try
    if (dados = nil) or (dados.Count = 0) then
      Exit;

    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    FConn.StartTransaction;

    try
      qry.SQL.Text :=
        'UPDATE obraericssonmigo ' +
        'SET fat = :novoFAT ' +
        'WHERE id = :idObraEricsson AND po = :po AND poritem = :poritem';

      for i := 0 to dados.Count - 1 do
      begin
        if dados.Items[i] is TJSONObject then
        begin
          resultadoObj := TJSONObject.Create;
          try
            idObraEricsson := TJSONObject(dados.Items[i]).GetValue('idObraEricsson', '');
            po := TJSONObject(dados.Items[i]).GetValue('po', '');
            poritem := TJSONObject(dados.Items[i]).GetValue('poritem', '');
            novoFAT := TJSONObject(dados.Items[i]).GetValue('novoFAT', '');

            if (idObraEricsson = '') or (po = '') or (poritem = '') or (novoFAT = '') then
            begin
              resultadoObj.AddPair('sucesso', TJSONBool.Create(False));
              resultadoObj.AddPair('erro', 'Dados incompletos');
              resultadoObj.AddPair('idObraEricsson', idObraEricsson);
            end
            else
            begin
              qry.ParamByName('novoFAT').AsString := novoFAT;
              qry.ParamByName('idObraEricsson').AsString := idObraEricsson;
              qry.ParamByName('po').AsString := po;
              qry.ParamByName('poritem').AsString := poritem;

              try
                qry.ExecSQL;
                resultadoObj.AddPair('sucesso', TJSONBool.Create(True));
                resultadoObj.AddPair('linhas_afetadas', TJSONNumber.Create(qry.RowsAffected));
              except
                on E: Exception do
                begin
                  resultadoObj.AddPair('sucesso', TJSONBool.Create(False));
                  resultadoObj.AddPair('erro', 'Erro no update: ' + E.Message);
                end;
              end;
            end;

            resultadoObj.AddPair('idObraEricsson', idObraEricsson);
            resultadoObj.AddPair('po', po);
            resultadoObj.AddPair('poritem', poritem);
            resultadoObj.AddPair('novoFAT', novoFAT);

          finally
            resultados.AddElement(resultadoObj);
          end;
        end;
      end;

      FConn.Commit;

    except
      on E: Exception do
      begin
        if FConn.InTransaction then
          FConn.Rollback;
        raise; // Re-lança a exceção
      end;
    end;

  finally
    if Assigned(qry) then
      qry.Free;
  end;
end;

function TProjetoericssonadic.ListaFaturamentoEricsson(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  sSQL, sWhere: string;
  bHasFilter: Boolean;
  sbusca: string;
  TemFiltro: Boolean;
begin
  qry := nil;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    qry.FetchOptions.Mode := fmAll;
    qry.FetchOptions.RowsetSize := 1000;
    qry.ResourceOptions.SilentMode := True;
    qry.UpdateOptions.ReadOnly := True;
    qry.ResourceOptions.DirectExecute := True;

    with qry.SQL do
    begin
      Clear;

    Add('SELECT');
    Add('  (@rownum := @rownum + 1) AS id,');
    Add('  m.po,');
    Add('  m.poritem,');
    Add('  m.datacriacaopo,');
    Add('  m.siteid,');
    Add('  m.id,');
    Add('  m.descricaoservico,');
    Add('  m.datamigo,');
    Add('  m.nmigo,');
    Add('  m.qtdmigo,');
    Add('  m.datamiro,');
    Add('  m.nmiro,');
    Add('  m.qtdmiro,');
    Add('  m.codigocliente,');
    Add('  m.estado,');
    Add('  m.qtyordered,');
    Add('  m.medidafiltro,');
    Add('  m.medidafiltrounitario,');
    Add('  m.id AS idobraericsson,');
    Add('  m.classificacaopo,');
    Add('  f.MOSREAL AS MOS,');
    Add('  f.INSTALREAL AS INSTALACAO,');
    Add('  f.INTEGREAL AS INTEGRACAO,');
    Add('  s.aceitacaofinal AS ACEITACAO,');
    Add('  f.DOCINSTAL AS DOC,');
    Add('  s.`Aprovação todos Docs.` AS APROVACAO_DOCS,');
    Add('  m.analise,');
    Add('  m.valorafaturar,');
    Add('  CASE');
    Add('    WHEN (m.fat IS NOT NULL AND m.fat <> '''') THEN m.fat');
    Add('    WHEN (m.nmiro IS NOT NULL AND m.nmiro <> '''') THEN ''100% Faturado''');
    Add('    WHEN (m.nmigo IS NOT NULL AND m.nmigo <> '''')');
    Add('         AND (m.nmiro IS NULL OR m.nmiro = '''') THEN ''OK''');
    Add('    ELSE ''NOK''');
    Add('  END AS fat');
    Add('FROM obraericssonmigo m');
    Add('LEFT JOIN obraericssonfechamento f ON m.po = f.PO AND m.poritem = f.POITEM');
    Add('LEFT JOIN obrasericssonlistasites s ON m.siteid = s.Site');
    Add('WHERE 1 = 1');




      // Filtro por busca geral
      if AQuery.ContainsKey('busca') then
      begin
        sBusca := AQuery.Items['busca'];
        if sBusca.Trim > '' then
        begin
          Add('AND (m.descricaoservico LIKE :busca ');
          Add('OR m.po LIKE :busca ');
          Add('OR m.siteid LIKE :busca ');
          Add('OR m.poritem LIKE :busca ');
          Add('OR m.id LIKE :busca ');
          Add('OR m.nmigo LIKE :busca ');
          Add('OR m.nmiro LIKE :busca)');
        end;
      end;

      if AQuery.ContainsKey('siteid') and (AQuery.Items['siteid'].Trim > '') then
      begin
        Add('AND m.siteid = :siteid');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('po') and (AQuery.Items['po'].Trim > '') then
      begin
        Add('AND m.po = :po');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('poritem') and (AQuery.Items['poritem'].Trim > '') then
      begin
        Add('AND m.poritem = :poritem');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('datacriacaopo') and (AQuery.Items['datacriacaopo'].Trim > '') then
      begin
        Add('AND DATE(m.datacriacaopo) = :datacriacaopo');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('id') and (AQuery.Items['id'].Trim > '') then
      begin
        Add('AND m.id = :id');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('descricaoservico') and (AQuery.Items['descricaoservico'].Trim > '') then
      begin
        Add('AND m.descricaoservico LIKE :descricaoservico');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('datamigo') and (AQuery.Items['datamigo'].Trim > '') then
      begin
        Add('AND DATE(m.datamigo) = :datamigo');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('nmigo') and (AQuery.Items['nmigo'].Trim > '') then
      begin
        Add('AND m.nmigo = :nmigo');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('qtdmigo') and (AQuery.Items['qtdmigo'].Trim > '') then
      begin
        Add('AND m.qtdmigo = :qtdmigo');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('datamiro') and (AQuery.Items['datamiro'].Trim > '') then
      begin
        Add('AND DATE(m.datamiro) = :datamiro');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('nmiro') and (AQuery.Items['nmiro'].Trim > '') then
      begin
        Add('AND m.nmiro = :nmiro');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('qtdmiro') and (AQuery.Items['qtdmiro'].Trim > '') then
      begin
        Add('AND m.qtdmiro = :qtdmiro');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('codigocliente') and (AQuery.Items['codigocliente'].Trim > '') then
      begin
        Add('AND m.codigocliente = :codigocliente');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('estado') and (AQuery.Items['estado'].Trim > '') then
      begin
        Add('AND m.estado LIKE :estado');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('cidade') and (AQuery.Items['cidade'].Trim > '') then
      begin
        Add('AND m.cidade = :cidade');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('qtyordered') and (AQuery.Items['qtyordered'].Trim > '') then
      begin
        Add('AND m.qtyordered = :qtyordered');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('medidafiltro') and (AQuery.Items['medidafiltro'].Trim > '') then
      begin
        Add('AND m.medidafiltro = :medidafiltro');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('medidafiltrounitario') and (AQuery.Items['medidafiltrounitario'].Trim > '') then
      begin
        Add('AND m.medidafiltrounitario = :medidafiltrounitario');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('classificacaopo') and (AQuery.Items['classificacaopo'].Trim > '') then
      begin
        Add('AND m.classificacaopo = :classificacaopo');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('mos') and (AQuery.Items['mos'].Trim > '') then
      begin
        Add('AND f.MOSREAL = :mos');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('instalacao') and (AQuery.Items['instalacao'].Trim > '') then
      begin
        Add('AND f.INSTALREAL = :instalacao');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('integracao') and (AQuery.Items['integracao'].Trim > '') then
      begin
        Add('AND f.INTEGREAL = :integracao');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('aceitacao') and (AQuery.Items['aceitacao'].Trim > '') then
      begin
        Add('AND s.aceitacaofinal = :aceitacao');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('doc') and (AQuery.Items['doc'].Trim > '') then
      begin
        Add('AND f.DOCINSTAL = :doc');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('aprovacaoDocs') and (AQuery.Items['aprovacaoDocs'].Trim > '') then
      begin
        Add('AND s.`Aprovação todos Docs.` = :aprovacaoDocs');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('analise') and (AQuery.Items['analise'].Trim > '') then
      begin
        Add('AND m.analise = :analise');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('fat') and (AQuery.Items['fat'].Trim > '') then
      begin
        Add('AND (');
        Add('      (m.fat = :fat) OR (');
        Add('          (m.fat IS NULL OR m.fat = '''') AND (');
        Add('              ( :fat = ''100% Faturado'' AND (m.nmiro IS NOT NULL AND m.nmiro <> '''')) OR');
        Add('              ( :fat = ''OK'' AND (m.nmigo IS NOT NULL AND m.nmigo <> '''') AND (m.nmiro IS NULL OR m.nmiro = '''')) OR');
        Add('              ( :fat = ''NOK'' AND (m.nmigo IS NULL OR m.nmigo = '''') AND (m.nmiro IS NULL OR m.nmiro = ''''))');
        Add('          )');
        Add('      )');
        Add('  )');
        TemFiltro := True;
      end;

      if AQuery.ContainsKey('valorafaturar') and (AQuery.Items['valorafaturar'].Trim > '') then
      begin
        Add('AND m.valorafaturar = :valorafaturar');
        TemFiltro := True;
      end;
      if AQuery.ContainsKey('apartirododiadatacriacaopo')
       and (Trim(AQuery.Items['apartirododiadatacriacaopo']) <> '') then
      begin
        Add(' AND m.datacriacaopo BETWEEN '
          + QuotedStr(AQuery.Items['apartirododiadatacriacaopo'])
          + ' AND CURRENT_DATE() ');
        TemFiltro := True;
      end;
      // Filtros específicos
     if not TemFiltro then
    begin
      Add(' AND m.datacriacaopo   BETWEEN DATE_ADD(CURRENT_DATE(), INTERVAL -30 DAY) AND CURRENT_DATE() ');
    end;

      Add('ORDER BY m.po, m.poritem');
    end;
    // Configurar parâmetros APÓS construir o SQL
    if AQuery.ContainsKey('busca') and (AQuery.Items['busca'].Trim > '') then
      qry.ParamByName('busca').AsString := '%' + AQuery.Items['busca'] + '%';

    if AQuery.ContainsKey('siteid') and (AQuery.Items['siteid'].Trim > '') then
      qry.ParamByName('siteid').AsString := AQuery.Items['siteid'];

    if AQuery.ContainsKey('po') and (AQuery.Items['po'].Trim > '') then
      qry.ParamByName('po').AsString := AQuery.Items['po'];

    if AQuery.ContainsKey('poritem') and (AQuery.Items['poritem'].Trim > '') then
      qry.ParamByName('poritem').AsString := AQuery.Items['poritem'];

    if AQuery.ContainsKey('datacriacaopo') and (AQuery.Items['datacriacaopo'].Trim > '') then
      qry.ParamByName('datacriacaopo').AsString := AQuery.Items['datacriacaopo'];

    if AQuery.ContainsKey('id') and (AQuery.Items['id'].Trim > '') then
      qry.ParamByName('id').AsString := AQuery.Items['id'];

    if AQuery.ContainsKey('descricaoservico') and (AQuery.Items['descricaoservico'].Trim > '') then
      qry.ParamByName('descricaoservico').AsString := '%' + AQuery.Items['descricaoservico'] + '%';

    if AQuery.ContainsKey('datamigo') and (AQuery.Items['datamigo'].Trim > '') then
      qry.ParamByName('datamigo').AsString := AQuery.Items['datamigo'];

    if AQuery.ContainsKey('nmigo') and (AQuery.Items['nmigo'].Trim > '') then
      qry.ParamByName('nmigo').AsString := AQuery.Items['nmigo'];

    if AQuery.ContainsKey('qtdmigo') and (AQuery.Items['qtdmigo'].Trim > '') then
      qry.ParamByName('qtdmigo').AsString := AQuery.Items['qtdmigo'];

    if AQuery.ContainsKey('datamiro') and (AQuery.Items['datamiro'].Trim > '') then
      qry.ParamByName('datamiro').AsString := AQuery.Items['datamiro'];

    if AQuery.ContainsKey('nmiro') and (AQuery.Items['nmiro'].Trim > '') then
      qry.ParamByName('nmiro').AsString := AQuery.Items['nmiro'];

    if AQuery.ContainsKey('qtdmiro') and (AQuery.Items['qtdmiro'].Trim > '') then
      qry.ParamByName('qtdmiro').AsString := AQuery.Items['qtdmiro'];

    if AQuery.ContainsKey('codigocliente') and (AQuery.Items['codigocliente'].Trim > '') then
      qry.ParamByName('codigocliente').AsString := AQuery.Items['codigocliente'];

    if AQuery.ContainsKey('estado') and (AQuery.Items['estado'].Trim > '') then
      qry.ParamByName('estado').AsString := AQuery.Items['estado'];

    if AQuery.ContainsKey('cidade') and (AQuery.Items['cidade'].Trim > '') then
      qry.ParamByName('cidade').AsString := AQuery.Items['cidade'];

    if AQuery.ContainsKey('qtyordered') and (AQuery.Items['qtyordered'].Trim > '') then
      qry.ParamByName('qtyordered').AsString := AQuery.Items['qtyordered'];

    if AQuery.ContainsKey('medidafiltro') and (AQuery.Items['medidafiltro'].Trim > '') then
      qry.ParamByName('medidafiltro').AsString := AQuery.Items['medidafiltro'];

    if AQuery.ContainsKey('medidafiltrounitario') and (AQuery.Items['medidafiltrounitario'].Trim > '') then
      qry.ParamByName('medidafiltrounitario').AsString := AQuery.Items['medidafiltrounitario'];

    if AQuery.ContainsKey('classificacaopo') and (AQuery.Items['classificacaopo'].Trim > '') then
      qry.ParamByName('classificacaopo').AsString := AQuery.Items['classificacaopo'];

    if AQuery.ContainsKey('mos') and (AQuery.Items['mos'].Trim > '') then
      qry.ParamByName('mos').AsString := AQuery.Items['mos'];

    if AQuery.ContainsKey('instalacao') and (AQuery.Items['instalacao'].Trim > '') then
      qry.ParamByName('instalacao').AsString := AQuery.Items['instalacao'];

    if AQuery.ContainsKey('integracao') and (AQuery.Items['integracao'].Trim > '') then
      qry.ParamByName('integracao').AsString := AQuery.Items['integracao'];

    if AQuery.ContainsKey('aceitacao') and (AQuery.Items['aceitacao'].Trim > '') then
      qry.ParamByName('aceitacao').AsString := AQuery.Items['aceitacao'];

    if AQuery.ContainsKey('doc') and (AQuery.Items['doc'].Trim > '') then
      qry.ParamByName('doc').AsString := AQuery.Items['doc'];

    if AQuery.ContainsKey('aprovacaoDocs') and (AQuery.Items['aprovacaoDocs'].Trim > '') then
      qry.ParamByName('aprovacaoDocs').AsString := AQuery.Items['aprovacaoDocs'];

    if AQuery.ContainsKey('analise') and (AQuery.Items['analise'].Trim > '') then
      qry.ParamByName('analise').AsString := AQuery.Items['analise'];

    if AQuery.ContainsKey('fat') and (AQuery.Items['fat'].Trim > '') then
      qry.ParamByName('fat').AsString := AQuery.Items['fat'];

    if AQuery.ContainsKey('valorafaturar') and (AQuery.Items['valorafaturar'].Trim > '') then
      qry.ParamByName('valorafaturar').AsString := AQuery.Items['valorafaturar'];
    qry.Open;
    erro := '';
    Result := qry;

  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar faturamento Ericsson: ' + ex.Message;
      if Assigned(qry) then
        FreeAndNil(qry);
      Result := nil;
    end;
  end;
end;
function TProjetoericssonadic.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obraericssonmigo.po, ');
      SQL.Add('obraericssonmigo.poritem as id, ');
      SQL.Add('obraericssonmigo.poritem, ');
      SQL.Add('obraericssonmigo.siteid,  ');
      SQL.Add('DATE_FORMAT(obraericssonmigo.datacriacaopo,''%d/%m/%Y'') as datacriacaopo,    ');
      SQL.Add('obraericssonmigo.codigoservico, ');
      SQL.Add('obraericssonmigo.descricaoservico ');
      SQL.Add('From ');
      SQL.Add('obraericssonmigo ');
      SQL.Add('Where ');
      SQL.Add('(obraericssonmigo.id Is Null or obraericssonmigo.id = '''') ');
     //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND(obraericssonmigo.descricaoservico like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obraericssonmigo.po like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obraericssonmigo.siteid like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obraericssonmigo.poritem like ''%' + AQuery.Items['busca'] + '%'' )');
        end;
      end;
      SQL.Add('order by obraericssonmigo.po');
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

function TProjetoericssonadic.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gescategoria WHERE gescategoria.idcategoria is not null and gescategoria.idcategoria =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idcategoriabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gescategoria.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gescategoria.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gescategoria.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
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


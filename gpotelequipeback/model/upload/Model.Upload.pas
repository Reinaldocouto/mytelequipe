unit Model.Upload;

interface

uses
  FireDAC.Comp.Client, Data.DB, FireDAC.Stan.Param, System.SysUtils, model.connection,Math,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections, System.JSON,  FireDAC.Stan.Error;

type
  TUpload = class
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
    function Descompatar: Boolean;
    function GetCredenciaisS3(out erro: string): TFDQuery;
    function InserirAtualizarMigo(const jsonData: TJSONArray; out erro: string): integer;
    function InserirAtualizaObraDocumentacaoObraFinal(const jsonData: TJSONArray; out erro: string): Integer;
    function InserirAtualizaObrasAspRFP2024(const jsonData: TJSONArray; out erro: string): Integer;
    function InserirAtualizaObras2022(const jsonData: TJSONArray; out erro: string): Integer;
    function InserirAtualizaObrasSites(const jsonData: TJSONArray; out erro: string): Integer;
    function migoparareal: Boolean;
    function obraericsson2022parareal: Boolean;
    function obraericsson2024parareal: Boolean;
    function pmtspararollout: Boolean;
    function InserirGeFolhaDePagamento(const jsonData: TJSONArray; const periodo: String; out erro: string): Integer;
    function InserirAtualizaPMTSRegistro(const jsonArray: TJSONArray; out erro: string): Integer;
    function RemoverPMTSRegistro(out erro: string): Integer;
    function InserirDespesas(const jsonData: TJSONArray; const periodo: String; out erro: string): Integer;
    function InserirTicket(const jsonData: TJSONArray; const periodo: String; out erro: string): Integer;
    function InserirTicketValeTransporte(const jsonData: TJSONArray; const periodo: String; out erro: string): Integer;
    function InserirConvenio(const jsonData: TJSONArray; const periodo: String; out erro: string): Integer;
    function InserirLpuZte(const jsonData: TJSONArray; out erro: string): Integer;
    function InserirMonitoramento(const jsonData: TJSONArray; out erro: string): Integer;
    function EditarT4(const Dados: TJSONObject; const periodo: String; out erro: string): Integer;
    function EditarT2(const Dados: TJSONObject; const periodo: String; out erro: string): Integer;


  end;

implementation

{ TUpload }

constructor TUpload.Create;
begin
  FConn := TConnection.CreateConnection;
end;

function TUpload.Descompatar: Boolean;
begin

end;

destructor TUpload.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TUpload.GetCredenciaisS3(out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('SELECT acesskeyid, secretkey, region, bucketname FROM credenciaiss3');
      Active := True;
    end;
    erro := '';
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar credenciais S3: ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TUpload.NovoCadastro(out erro: string): integer;
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
   if FConn <> nil then FConn.Free;
    qry.Free;
  end;
end;

function TUpload.obraericsson2022parareal: Boolean;
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
        sql.add('CALL AtualizaObraEricsson2022();');
        ExecSQL;

      end;
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TUpload.obraericsson2024parareal: Boolean;
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
        sql.add('CALL AtualizaObraEricsson2024();');
        ExecSQL;

      end;
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TUpload.pmtspararollout: Boolean;
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
        sql.add('CALL AtualizaRolloutVivo();');
        ExecSQL;
        Active := false;
        sql.Clear;
        sql.add('update rolloutvivo set pmoregional = ''NE'' where pMoregional = ''BA/SE''  ');
        ExecSQL;
      end;
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TUpload.Editar(out erro: string): Boolean;
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
  begin
     if FConn <> nil then FConn.Free;
    qry.Free;
  end;
  end;
end;

function TUpload.Inserir(out erro: string): Boolean;
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
     if FConn <> nil then FConn.Free;
    qry.Free;
  end;
end;

function TUpload.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gescategoria.idcategoria as id, ');
      SQL.Add('gescategoria.descricao ');
      SQL.Add('From  ');
      SQL.Add('gescategoria WHERE gescategoria.idcategoria is not null ');

     //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND(gescategoria.descricao like ''%' + AQuery.Items['busca'] + '%'' )');
          //SQL.Add('or gesproduto.descricao like ''%' + AQuery.Items['busca'] + '%'' ');
        end;
      end;

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
      SQL.Add('order by descricao');
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

function TUpload.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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

function TUpload.migoparareal: Boolean;
var
  qry: TFDQuery;
begin
  Result := False;
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    FConn.StartTransaction;
    try
      qry.SQL.Text := 'CALL AtualizaMigo()';
      qry.ExecSQL;
      FConn.Commit;
      Result := True;
    except
      on ex: Exception do
      begin
        FConn.Rollback;
        Writeln('Erro em migoparareal: ' + ex.Message);
      end;
    end;
  finally
    qry.Free;
  end;
end;
function TUpload.InserirAtualizarMigo(const jsonData: TJSONArray; out erro: string): Integer;
var
  qry: TFDQuery;
  i, poInt: Int64;
  jsonObject: TJSONObject;
  poStr: string;
  tempDate: TDateTime;
  tempFloat: Double;
  jsonValue: TJSONValue;
  requiredKeys: array of string;
  key: string;
  analiseStr: string;
begin
  Result := 0;
  erro := '';

  // 🔹 Validação do JSON
  if (jsonData = nil) or (jsonData.Count = 0) then
  begin
    erro := 'JSON vazio ou inválido.';
    Exit;
  end;

  // 🔹 Verifica se a conexão está atribuída
  if not Assigned(FConn) then
  begin
    erro := 'Conexão com o banco de dados não foi inicializada.';
    Exit;
  end;

  qry := TFDQuery.Create(nil);
  try

    FConn := TConnection.CreateConnection;

    qry.Connection := FConn;
    FConn.StartTransaction;
    try

      // 🔹 Limpa tabela antes de inserir novos registros
      qry.SQL.Text := 'DELETE FROM atualizacaomigo';
      qry.ExecSQL;
      FConn.Commit;
      qry.SQL.Clear;
      for i := 0 to jsonData.Count - 1 do
      begin
        jsonObject := jsonData.Items[i] as TJSONObject;
        if jsonObject = nil then
          Continue; // Ignora se for inválido

        // 🔹 Validação do PO
        if not jsonObject.TryGetValue<string>('PO', poStr) or not TryStrToInt64(poStr, poInt) then
        begin
          erro := Format('PO inválido na linha %d: %s. Registro ignorado.', [i + 1, poStr]);
          Continue; // Apenas pula para o próximo item, sem sair da função
        end;
        qry.SQL.Clear;
        qry.SQL.Add('INSERT INTO atualizacaomigo (po, poritem, datacriacaopo, siteid, codigoservico, id, ');
        qry.SQL.Add('descricaoservico, vendorno, vendorname, datamigo, nmigo, qtdmigo, ');
        qry.SQL.Add('datamiro, nmiro, qtdmiro, poativa, poaprovada, classificacaopo, statuspo, ');
        qry.SQL.Add('codigocliente, estado, cidade, qtyordered, medidafiltro, medidafiltrounitario, ');
        qry.SQL.Add('statusobranew, escopo, sigla, valorafaturar, analise, FAT) ');
        qry.SQL.Add('VALUES (:po, :poritem, :datacriacaopo, :siteid, :codigoservico, :id,');
        qry.SQL.Add(':descricaoservico, :vendorno, :vendorname, :datamigo, :nmigo, :qtdmigo, ');
        qry.SQL.Add(':datamiro, :nmiro, :qtdmiro, :poativa, :poaprovada, :classificacaopo, :statuspo, ');
        qry.SQL.Add(':codigocliente, :estado, :cidade, :qtyordered, :medidafiltro, :medidafiltrounitario, ');
        qry.SQL.Add(':statusobranew, :escopo, :sigla, :valorafaturar, :analise, :fat)');

        // 🔹 Mapeamento de parâmetros
        qry.ParamByName('po').AsInteger := poInt;
        qry.ParamByName('poritem').AsString := jsonObject.GetValue<string>('PO+Item', '');
        qry.ParamByName('datacriacaopo').DataType := ftDateTime;
        // Validação de Data
        if jsonObject.TryGetValue<string>('Data Criação PO', poStr) and TryStrToDate(poStr, tempDate) then
        begin
          qry.ParamByName('datacriacaopo').AsDateTime := tempDate
        end
        else
          qry.ParamByName('datacriacaopo').Clear;

        qry.ParamByName('siteid').AsString := jsonObject.GetValue<string>('Site ID', '');
        qry.ParamByName('codigoservico').AsString := jsonObject.GetValue<string>('Código Serviço', '');
        qry.ParamByName('id').AsString := jsonObject.GetValue<string>('id', '');
        qry.ParamByName('descricaoservico').AsString := jsonObject.GetValue<string>('Descrição Serviço', '');
        qry.ParamByName('vendorno').AsString := jsonObject.GetValue<string>('Vendor No', '');
        qry.ParamByName('vendorname').AsString := jsonObject.GetValue<string>('Vendor Name', '');
        qry.ParamByName('qtdmigo').DataType := ftFloat;
        qry.ParamByName('datamiro').DataType := ftDateTime;
        qry.ParamByName('nmiro').DataType := ftString;
        qry.ParamByName('qtdmiro').DataType := ftFloat;
        qry.ParamByName('qtyordered').DataType := ftFloat;
        jsonValue := jsonObject.GetValue('Data MIGO');
        qry.ParamByName('datamigo').DataType := ftDateTime;
        qry.ParamByName('fat').AsString := 'SELECIONE';


        if Assigned(jsonValue) and (jsonValue is TJSONString) then
        begin
          poStr := TJSONString(jsonValue).Value;
          if TryStrToDate(poStr, tempDate) then
            qry.ParamByName('datamigo').AsDateTime := tempDate
          else
            qry.ParamByName('datamigo').Clear;
        end
        else
          qry.ParamByName('datamigo').Clear;

        qry.ParamByName('nmigo').AsString := jsonObject.GetValue<string>('Nº MIGO', '');

        // Validação de Float
        if jsonObject.TryGetValue<string>('Qtd MIGO', poStr) then
        begin
          if TryStrToFloat(poStr, tempFloat) then
          begin
            qry.ParamByName('qtdmigo').AsFloat := tempFloat
          end
          else
            qry.ParamByName('qtdmigo').Clear;
        end
        else
          qry.ParamByName('qtdmigo').Clear;

        // Validação de Data para MIRO
        if jsonObject.TryGetValue<string>('Data MIRO', poStr) then
        begin
          if TryStrToDate(poStr, tempDate) then
            qry.ParamByName('datamiro').AsDateTime := tempDate
          else
            qry.ParamByName('datamiro').Clear;
        end
        else
          qry.ParamByName('datamiro').Clear;

        qry.ParamByName('nmiro').AsString := jsonObject.GetValue<string>('Nº MIRO', '');


        // Validação de Float
        if jsonObject.TryGetValue<string>('Qtd MIRO', poStr) then
        begin
          if TryStrToFloat(poStr, tempFloat) then
            qry.ParamByName('qtdmiro').AsFloat := tempFloat
          else
            qry.ParamByName('qtdmiro').Clear;
        end
        else
          qry.ParamByName('qtdmiro').Clear;

          // Validação de 'Qty ordered' - verifica se a chave existe e se pode ser convertida para Float
        if jsonObject.TryGetValue<string>('Qty ordered', poStr) then
        begin
          if TryStrToFloat(poStr, tempFloat) then
            qry.ParamByName('qtyordered').AsFloat := tempFloat
          else
            qry.ParamByName('qtyordered').Clear;
        end
        else
          qry.ParamByName('qtyordered').Clear;

      if (qry.ParamByName('nmigo').AsString <> '') and
         (not qry.ParamByName('qtdmigo').IsNull) and
         (qry.ParamByName('nmiro').AsString <> '') and
         (not qry.ParamByName('qtdmiro').IsNull) then
      begin
        if SameValue(qry.ParamByName('qtdmigo').AsFloat,
                     qry.ParamByName('qtdmiro').AsFloat, 0.0001) then
          analiseStr := 'OK'
        else
          analiseStr := 'NOK';
      end
      else
        analiseStr := 'NOK';
        qry.ParamByName('analise').AsString := analiseStr;
        qry.ParamByName('poativa').AsString := jsonObject.GetValue<string>('PO Ativa', '');
        qry.ParamByName('poaprovada').AsString := jsonObject.GetValue<string>('PO Aprovada', '');
        qry.ParamByName('classificacaopo').AsString := jsonObject.GetValue<string>('ClassificaçãoPO', '');
        qry.ParamByName('statuspo').AsString := jsonObject.GetValue<string>('StatusPO', '');
        qry.ParamByName('codigocliente').AsString := jsonObject.GetValue<string>('CodigoCliente', '');
        qry.ParamByName('estado').AsString := jsonObject.GetValue<string>('Estado', '');
        qry.ParamByName('cidade').AsString := jsonObject.GetValue<string>('Cidade', '');
        qry.ParamByName('medidafiltro').AsString := jsonObject.GetValue<string>('Medida_filtro', '');
        qry.ParamByName('valorafaturar').AsString := jsonObject.GetValue<string>('Medida_filtro', '');
        qry.ParamByName('medidafiltrounitario').AsString := jsonObject.GetValue<string>('Medida_filtro_Unitario', '');
        qry.ParamByName('statusobranew').AsString := jsonObject.GetValue<string>('Status Obra New', '');
        qry.ParamByName('escopo').AsString := jsonObject.GetValue<string>('Escopo', '');
        qry.ParamByName('sigla').AsString := jsonObject.GetValue<string>('Sigla', '');

        qry.ExecSQL;
      end;

      // 🔹 Finaliza a transação

      if not migoparareal then
        raise Exception.Create('Falha ao executar procedure AtualizaMigo');

      FConn.Commit;
      Result := jsonData.Count;


    except
      on E: Exception do
      begin
        erro := 'Erro ao inserir dados na linha ' + IntToStr(i + 1) + ': ' + E.Message;
        Writeln(erro);
        FConn.Rollback;
        Result := 0;
      end;
    end;
  finally
    if FConn <> nil then FConn.Free;
    qry.Free;
  end;
end;

function TUpload.InserirMonitoramento(const jsonData: TJSONArray; out erro: string): Integer;
var
  qry: TFDQuery;
  i: Integer;
  jsonObject: TJSONObject;
  tempDate: TDateTime;
  tempFloat: Double;
  poStr: string;
begin
  Result := 0;
  erro := '';

  if (jsonData = nil) or (jsonData.Count = 0) then
  begin
    erro := 'JSON vazio ou inválido.';
    Exit;
  end;

  if not Assigned(FConn) then
  begin
    erro := 'Conexão com o banco de dados não foi inicializada.';
    Exit;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;

    FConn.StartTransaction;
    try
      // Limpa a tabela antes de inserir
      qry.SQL.Text := 'DELETE FROM monitoramento';
      qry.ExecSQL;

      // Prepara a query de inserção
      qry.SQL.Text :=
        'INSERT INTO monitoramento ' +
        '(horario, data_inicio, data_fim, placa, endereco, latitude, longitude, velocidade, ignicao, bateria, sinal, gps, evento, hodometro) ' +
        'VALUES ' +
        '(:horario, :data_inicio, :data_fim, :placa, :endereco, :latitude, :longitude, :velocidade, :ignicao, :bateria, :sinal, :gps, :evento, :hodometro)';

      // Define os tipos dos parâmetros antecipadamente
      qry.Params.ParamByName('horario').DataType := ftDateTime;
      qry.Params.ParamByName('data_inicio').DataType := ftDateTime;
      qry.Params.ParamByName('data_fim').DataType := ftDateTime;
      qry.Params.ParamByName('placa').DataType := ftString;
      qry.Params.ParamByName('endereco').DataType := ftString;
      qry.Params.ParamByName('latitude').DataType := ftString;
      qry.Params.ParamByName('longitude').DataType := ftString;
      qry.Params.ParamByName('velocidade').DataType := ftString;
      qry.Params.ParamByName('ignicao').DataType := ftString;
      qry.Params.ParamByName('bateria').DataType := ftString;
      qry.Params.ParamByName('sinal').DataType := ftString;
      qry.Params.ParamByName('gps').DataType := ftString;
      qry.Params.ParamByName('evento').DataType := ftString;
      qry.Params.ParamByName('hodometro').DataType := ftString;

      qry.Prepare;

      for i := 0 to jsonData.Count - 1 do
      begin
        jsonObject := jsonData.Items[i] as TJSONObject;
        if jsonObject = nil then
          Continue;

        Writeln(jsonObject.ToString);

        try
          // Horário
          if jsonObject.TryGetValue<string>('Horário', poStr) and TryStrToDateTime(poStr, tempDate) then
            qry.ParamByName('horario').AsDateTime := tempDate
          else
            qry.ParamByName('horario').Clear;

          // Data Início
          if jsonObject.TryGetValue<string>('DataInicio', poStr) and TryStrToDateTime(poStr, tempDate) then
            qry.ParamByName('data_inicio').AsDateTime := tempDate
          else
            qry.ParamByName('data_inicio').Clear;

          // Data Fim
          if jsonObject.TryGetValue<string>('DataFim', poStr) and TryStrToDateTime(poStr, tempDate) then
            qry.ParamByName('data_fim').AsDateTime := tempDate
          else
            qry.ParamByName('data_fim').Clear;

          // Placa
          qry.ParamByName('placa').AsString := jsonObject.GetValue<string>('Placa', '');

          // Endereço
          qry.ParamByName('endereco').AsString := jsonObject.GetValue<string>('Endereço', '');

          if jsonObject.TryGetValue<string>('Latitude', poStr) then
          begin
            poStr := StringReplace(poStr, ',', '.', [rfReplaceAll]);
            if TryStrToFloat(poStr, tempFloat) then
              qry.ParamByName('latitude').AsString := poStr
            else
              qry.ParamByName('latitude').Clear;
          end
          else
            qry.ParamByName('latitude').Clear;

          // Longitude
          if jsonObject.TryGetValue<string>('Longitude', poStr) then
          begin
            poStr := StringReplace(poStr, ',', '.', [rfReplaceAll]);
            if TryStrToFloat(poStr, tempFloat) then
              qry.ParamByName('longitude').AsString := poStr
            else
              qry.ParamByName('longitude').Clear;
          end
          else
            qry.ParamByName('longitude').Clear;

          // Demais parâmetros simples
          qry.ParamByName('velocidade').AsString := jsonObject.GetValue<string>('Velocidade', '');
          qry.ParamByName('ignicao').AsString := jsonObject.GetValue<string>('Ignição', '');
          qry.ParamByName('bateria').AsString := jsonObject.GetValue<string>('Bateria', '');
          qry.ParamByName('sinal').AsString := jsonObject.GetValue<string>('Sinal', '');
          qry.ParamByName('gps').AsString := jsonObject.GetValue<string>('GPS', '');
          qry.ParamByName('evento').AsString := jsonObject.GetValue<string>('Evento', '');
          qry.ParamByName('hodometro').AsString := jsonObject.GetValue<string>('Hodômetro', '');

          qry.ExecSQL;
        except
          on E: Exception do
          begin
            erro := 'Erro ao inserir dados na linha ' + IntToStr(i + 1) + ': ' + E.Message;
            FConn.Rollback;
            Exit(0);
          end;
        end;
      end;

      FConn.Commit;
      Result := jsonData.Count;
    except
      on E: Exception do
      begin
        erro := 'Erro durante a transação: ' + E.Message;
        FConn.Rollback;
        Result := 0;
      end;
    end;
  finally
    if FConn <> nil then FConn.Free;
    qry.Free;
  end;
end;

procedure ProcessarCampoData(jsonObject: TJSONObject; campoJSON, campoBD: string; qry: TFDQuery; formatSettings: TFormatSettings);
var
  poStr: string;
  tempDateTime: TDateTime;
  trimmedStr: string;
  jsonValue: TJSONValue;
begin
  try
    jsonValue := jsonObject.GetValue(campoJSON);

    // Verifica se o JSONObject é nulo
    if not Assigned(jsonObject) then
    begin
      qry.ParamByName(campoBD).Clear;
      qry.ParamByName(campoBD).DataType := ftDateTime; // Define o tipo como DateTime
      Exit;
    end;

    if Assigned(jsonValue) then
    begin
      poStr := jsonValue.Value;
      trimmedStr := poStr.Trim;


      // Trata valores vazios ou "null"
      if (trimmedStr.IsEmpty) or SameText(trimmedStr, 'null') then
      begin
        qry.ParamByName(campoBD).Clear;
        qry.ParamByName(campoBD).DataType := ftDateTime; // Define o tipo como DateTime
        Exit;
      end;

      // Tenta converter para data/hora
      if TryStrToDateTime(trimmedStr, tempDateTime, formatSettings) then
      begin
        qry.ParamByName(campoBD).DataType := ftDateTime; // Define o tipo como DateTime
        qry.ParamByName(campoBD).AsDateTime := tempDateTime; // Atribui o valor convertido
      end
      else
      begin
        qry.ParamByName(campoBD).Clear;
        qry.ParamByName(campoBD).DataType := ftDateTime; // Define o tipo como DateTime
      end;
    end
    else
    begin
      // Chave não encontrada
      qry.ParamByName(campoBD).Clear;
      qry.ParamByName(campoBD).DataType := ftDateTime; // Define o tipo como DateTime
    end;
  except
    on E: Exception do
    begin
      qry.ParamByName(campoBD).Clear;
      qry.ParamByName(campoBD).DataType := ftDateTime; // Define o tipo como DateTime
    end;
  end;
end;

function TUpload.InserirAtualizaObras2022(const jsonData: TJSONArray; out erro: string): Integer;
var
  qry: TFDQuery;
  i: Integer;
  jsonObject: TJSONObject;
  poStr: string;
  intValue: Int64;
  formatSettings: TFormatSettings;
begin
  Result := 0;
  erro := '';

  // 🔹 Validação do JSON
  if (jsonData = nil) or (jsonData.Count = 0) then
  begin
    erro := 'JSON vazio ou inválido.';
    Exit;
  end;

  // 🔹 Verifica se a conexão está atribuída
  if not Assigned(FConn) then
  begin
    erro := 'Conexão com o banco de dados não foi inicializada.';
    Exit;
  end;

  qry := TFDQuery.Create(nil);
  try
    FConn := TConnection.CreateConnection;
    qry.Connection := FConn;
    FConn.StartTransaction;
    try
      // 🔹 Limpa tabela antes de inserir novos registros
      qry.SQL.Text := 'DELETE FROM atualizaobraericsson2022';
      qry.ExecSQL;
      FConn.Commit;
      qry.SQL.Clear;

      // Configuração do formato de data/hora
      formatSettings := TFormatSettings.Create;
      formatSettings.ShortDateFormat := 'dd/mm/yyyy'; // Formato esperado no JSON
      formatSettings.DateSeparator := '/';
      formatSettings.ShortTimeFormat := 'hh:nn:ss';
      formatSettings.TimeSeparator := ':';

      for i := 0 to jsonData.Count - 1 do
      begin
        jsonObject := jsonData.Items[i] as TJSONObject;
        if jsonObject = nil then
          Continue; // Ignora se for inválido

        if not jsonObject.TryGetValue<string>('RFP > Nome', poStr) or not TryStrToInt64(poStr, intValue) then
        begin
          erro := Format('RFP > Nome inválido na linha %d: %s. Registro ignorado.', [i + 1, poStr]);
          Continue; // Apenas pula para o próximo item, sem sair da função
        end;

        qry.SQL.Clear;
        qry.SQL.Add('INSERT INTO atualizaobraericsson2022 (rfp, numero, cliente, regiona, site, fornecedor, ');
        qry.SQL.Add('situacaoimplantacao, situacaodaintegracao, datadacriacaodademandadia, datalimiteaceitedia, ');
        qry.SQL.Add('dataaceitedemandadia, datainicioprevistasolicitantebaselinemosdia, datainicioentregamosplanejadodia, ');
        qry.SQL.Add('datarecebimentodositemosreportadodia, datafimprevistabaselinefiminstalacaodia, datafiminstalacaoplanejadodia, ');
        qry.SQL.Add('dataconclusaoreportadodia, datavalidacaoinstalacaodia, dataintegracaobaselinedia, dataintegracaoplanejadodia, ');
        qry.SQL.Add('datavalidacaoeriboxedia, listadepos, gestordeimplantacaonome, statusrsa, rsarsa, ARQsvalidadapeloCliente, ');
        qry.SQL.Add('statusaceitacao, datadefimdaaceitacaosydledia, ordemdevenda, coordenadoaspnome, rsavalidacaorsanrotrackerdatafimdia, ');
        qry.SQL.Add('fimdeobraplandia, fimdeobrarealdia, tipoatualizacaofam, sinergia, sinergia5g, escoponome, slapadraoescopodias, ');
        qry.SQL.Add('tempoparalisacaoinstalacaodias, localizacaositeendereco, localizacaositeCidade, documentacaosituacao, sitepossuirisco) ');
        qry.SQL.Add('VALUES (:rfp, :numero, :cliente, :regiona, :site, :fornecedor, ');
        qry.SQL.Add(':situacaoimplantacao, :situacaodaintegracao, :datadacriacaodademandadia, :datalimiteaceitedia, ');
        qry.SQL.Add(':dataaceitedemandadia, :datainicioprevistasolicitantebaselinemosdia, :datainicioentregamosplanejadodia, ');
        qry.SQL.Add(':datarecebimentodositemosreportadodia, :datafimprevistabaselinefiminstalacaodia, :datafiminstalacaoplanejadodia, ');
        qry.SQL.Add(':dataconclusaoreportadodia, :datavalidacaoinstalacaodia, :dataintegracaobaselinedia, :dataintegracaoplanejadodia, ');
        qry.SQL.Add(':datavalidacaoeriboxedia, :listadepos, :gestordeimplantacaonome, :statusrsa, :rsarsa, :ARQsvalidadapeloCliente, ');
        qry.SQL.Add(':statusaceitacao, :datadefimdaaceitacaosydledia, :ordemdevenda, :coordenadoaspnome, :rsavalidacaorsanrotrackerdatafimdia, ');
        qry.SQL.Add(':fimdeobraplandia, :fimdeobrarealdia, :tipoatualizacaofam, :sinergia, :sinergia5g, :escoponome, :slapadraoescopodias, ');
        qry.SQL.Add(':tempoparalisacaoinstalacaodias, :localizacaositeendereco, :localizacaositeCidade, :documentacaosituacao, :sitepossuirisco)');

        // 🔹 Mapeamento de parâmetros com validação de tamanho
        qry.ParamByName('rfp').AsString := Copy(jsonObject.GetValue<string>('RFP > Nome', ''), 1, 100);
        qry.ParamByName('numero').AsString := Copy(jsonObject.GetValue<string>('Número', ''), 1, 20);
        qry.ParamByName('cliente').AsString := Copy(jsonObject.GetValue<string>('Cliente > Nome', ''), 1, 50);
        qry.ParamByName('regiona').AsString := Copy(jsonObject.GetValue<string>('Regional > Nome', ''), 1, 50);
        qry.ParamByName('site').AsString := Copy(jsonObject.GetValue<string>('Site > Nome', ''), 1, 255);
        qry.ParamByName('fornecedor').AsString := Copy(jsonObject.GetValue<string>('Fornecedor > Nome', ''), 1, 255);
        qry.ParamByName('situacaoimplantacao').AsString := Copy(jsonObject.GetValue<string>('Situação Implantação', ''), 1, 60);
        qry.ParamByName('situacaodaintegracao').AsString := Copy(jsonObject.GetValue<string>('Situação da Integração', ''), 1, 50);
        qry.ParamByName('listadepos').AsString := Copy(jsonObject.GetValue<string>('Lista de POs', ''), 1, 255);
        qry.ParamByName('gestordeimplantacaonome').AsString := Copy(jsonObject.GetValue<string>('Gestor de Implantação > Nome', ''), 1, 255);
        qry.ParamByName('statusrsa').AsString := Copy(jsonObject.GetValue<string>('Status RSA', ''), 1, 50);
        qry.ParamByName('rsarsa').AsString := Copy(jsonObject.GetValue<string>('RSA > RSA', ''), 1, 50);
        qry.ParamByName('ARQsvalidadapeloCliente').AsString := Copy(jsonObject.GetValue<string>('ARQs validada pelo Cliente', ''), 1, 20);
        qry.ParamByName('statusaceitacao').AsString := Copy(jsonObject.GetValue<string>('Status Aceitação', ''), 1, 50);
        qry.ParamByName('ordemdevenda').AsString := Copy(jsonObject.GetValue<string>('Ordem de Venda', ''), 1, 200);
        qry.ParamByName('coordenadoaspnome').AsString := Copy(jsonObject.GetValue<string>('Coordenador ASP > Nome', ''), 1, 255);
        qry.ParamByName('tipoatualizacaofam').AsString := Copy(jsonObject.GetValue<string>('Tipo de atualização FAM', ''), 1, 59);
        qry.ParamByName('sinergia').AsString := Copy(jsonObject.GetValue<string>('Sinergia', ''), 1, 50);
        qry.ParamByName('sinergia5g').AsString := Copy(jsonObject.GetValue<string>('Sinergia 5G', ''), 1, 50);
        qry.ParamByName('escoponome').AsString := Copy(jsonObject.GetValue<string>('Escopo > Nome', ''), 1, 255);
        qry.ParamByName('slapadraoescopodias').AsString := Copy(jsonObject.GetValue<string>('SLA padrão do escopo (dias)', ''), 1, 100);
        qry.ParamByName('localizacaositeendereco').AsString := Copy(jsonObject.GetValue<string>('Localização do Site > Endereço (A)', ''), 1, 255);
        qry.ParamByName('localizacaositeCidade').AsString := Copy(jsonObject.GetValue<string>('Localização do Site > Cidade (A)', ''), 1, 255);
        qry.ParamByName('documentacaosituacao').AsString := Copy(jsonObject.GetValue<string>('Documentação > Situação', ''), 1, 50);
        qry.ParamByName('sitepossuirisco').AsString := Copy(jsonObject.GetValue<string>('Site Possui Risco?', ''), 1, 50);
        qry.ParamByName('tempoparalisacaoinstalacaodias').AsString := Copy(jsonObject.GetValue<string>('Tempo de paralisação de Instalação (dias)', ''), 1, 255);

        // Processar campos de data
        ProcessarCampoData(jsonObject, 'Data da criação da Demanda (Dia)', 'datadacriacaodademandadia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data limite de Aceite (Dia)', 'datalimiteaceitedia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de aceite da demanda (Dia)', 'dataaceitedemandadia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Início prevista pelo solicitante (Baseline MOS) (Dia)', 'datainicioprevistasolicitantebaselinemosdia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Início / Entrega (MOS - Planejado) (Dia)', 'datainicioentregamosplanejadodia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de recebimento do site (MOS - Reportado) (Dia)', 'datarecebimentodositemosreportadodia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Fim prevista pelo solicitante (Baseline Fim Instalação) (Dia)', 'datafimprevistabaselinefiminstalacaodia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Fim de Instalação (Planejado) (Dia)', 'datafiminstalacaoplanejadodia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Conclusão (Reportado) (Dia)', 'dataconclusaoreportadodia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Validação da Instalação (Dia)', 'datavalidacaoinstalacaodia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Integração (Baseline) (Dia)', 'dataintegracaobaselinedia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Integração (Planejado) (Dia)', 'dataintegracaoplanejadodia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Validação ERIBOX (Dia)', 'datavalidacaoeriboxedia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de fim da Aceitação (SYDLE) (Dia)', 'datadefimdaaceitacaosydledia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'RSA > Validação de Qualidade RSA (NRO Tracker) > Data fim do RSA (Dia)', 'rsavalidacaorsanrotrackerdatafimdia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'FIM_DE_OBRA PLAN', 'fimdeobraplandia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'FIM_DE_OBRA REAL', 'fimdeobrarealdia', qry, formatSettings);

        // 🔹 Executa a inserção
        qry.ExecSQL;
      end;

      // 🔹 Finaliza a transação
      FConn.Commit;
      Result := jsonData.Count;
      obraericsson2022parareal;

    except
      on E: Exception do
      begin
        erro := 'Erro ao inserir dados na linha ' + IntToStr(i + 1) + ': ' + E.Message;
        FConn.Rollback;
        Writeln(erro);
        Result := 0;
      end;
    end;
  finally
    qry.Connection := nil;
    if FConn <> nil then FConn.Free;
    qry.Free;
  end;
end;

function TUpload.RemoverPMTSRegistro(out erro: string): Integer;
var
  qry: TFDQuery;
begin
  Result := 0; // Retorna 0 em caso de falha
  erro := '';

  qry := TFDQuery.Create(nil);
  try
    FConn := TConnection.CreateConnection;
    try
      qry.Connection := FConn;

      // Inicia transação
      FConn.StartTransaction;
      try
        qry.SQL.Text := 'DELETE FROM pmtsvivo';
        qry.Prepare;
        qry.ExecSQL;

        // Confirma a transação se tudo ocorrer bem
        FConn.Commit;
        Result := 1; // Retorna 1 em caso de sucesso
      except
        on E: Exception do
        begin
          // Desfaz a transação em caso de erro
          if FConn.InTransaction then
            FConn.Rollback;

          erro := 'Erro ao executar DELETE: ' + E.Message;
          Result := 0;
        end;
      end;
    except
      on E: Exception do
      begin
        erro := 'Erro na conexão com o banco: ' + E.Message;
        Result := 0;
      end;
    end;
  finally
    // Libera recursos na ordem inversa de criação
    if Assigned(qry) then
    begin
      qry.Close;
      if Assigned(qry.Connection) then
        qry.Connection := nil;
      qry.Free;
    end;

    if Assigned(FConn) then
      FConn.Free;
  end;
end;

procedure SetDateParam(qry: TFDQuery; const ParamName, Value: string; const AFormatSettings: TFormatSettings);
var
  tempDate: TDateTime;
begin
  if Value <> '' then
  begin
    // Tenta converter a string para data usando o formato especificado
    if TryStrToDate(Value, tempDate, AFormatSettings) then
      qry.ParamByName(ParamName).AsDate := tempDate
    else
      qry.ParamByName(ParamName).Clear; // Limpa se a conversão falhar
  end
  else
    qry.ParamByName(ParamName).Clear; // Limpa se o valor estiver vazio
end;

function TUpload.InserirAtualizaPMTSRegistro(const jsonArray: TJSONArray; out erro: string): Integer;
var
  formatSettings: TFormatSettings;
  qry: TFDQuery;
  jsonObj: TJSONObject;
  i: Integer;
  processados: Integer;
  dt: TDateTime;

function GetJSONValueAsDate(json: TJSONObject; const key: string): TDate;
begin
  if Assigned(json.GetValue(key)) then
    Result := StrToDateDef(json.GetValue(key).Value, 0) // depende do formato local
  else
    Result := 0;
end;

  function GetJSONValue(jsonObj: TJSONObject; const AName: string): string;
  var
    jsonValue: TJSONValue;
  begin
    Result := '';
    if not Assigned(jsonObj) then
      Exit;

    jsonValue := jsonObj.GetValue(AName);
    if Assigned(jsonValue) and not (jsonValue is TJSONNull) then
      Result := jsonValue.Value;
  end;

procedure SetDateTimeParam(const AParamName, AValue: string; qry: TFDQuery; var AError: string);
var
  dt: TDateTime;
  formatSettings: TFormatSettings;
begin
  if AError <> '' then
    Exit;

  try
    if qry.Params.FindParam(AParamName) = nil then
    begin
      AError := 'Parâmetro ' + AParamName + ' não existe na query';
      Exit;
    end;

    formatSettings := TFormatSettings.Create;
    formatSettings.DateSeparator := '/';
    formatSettings.ShortDateFormat := 'dd/mm/yyyy';
    formatSettings.LongDateFormat := 'dd/mm/yyyy';
    formatSettings.ShortTimeFormat := 'hh:nn:ss';
    formatSettings.LongTimeFormat := 'hh:nn:ss';

    with qry.ParamByName(AParamName) do
    begin
      DataType := ftDateTime;

      if Trim(AValue) = '' then
        Clear
      else if TryStrToDateTime(AValue, dt, formatSettings) then
        AsDateTime := dt
      else
        AError := 'Data inválida no campo ' + AParamName + ': "' + AValue + '"';
    end;
  except
    on E: Exception do
      AError := 'Erro no campo DateTime ' + AParamName + ': ' + E.Message;
  end;
end;



  function GetJSONValueAsFloat(json: TJSONObject; const key: string): Double;
  var
    valorStr: string;
  begin
    Result := 0;
    if Assigned(json.GetValue(key)) then
    begin
      valorStr := json.GetValue(key).Value;
      valorStr := StringReplace(valorStr, ',', '.', [rfReplaceAll]); // troca vírgula por ponto
      Result := StrToFloatDef(valorStr, 0);
    end;
  end;

  procedure SetIntParam(const AParamName, AValue: string; qry: TFDQuery; var AError: string);
  begin
    if AError <> '' then
      Exit;

    try
      if qry.Params.FindParam(AParamName) = nil then
      begin
        AError := 'Parâmetro ' + AParamName + ' não encontrado';
        Exit;
      end;

      if AValue = '' then
        qry.ParamByName(AParamName).Clear
      else
      begin
        qry.ParamByName(AParamName).DataType := ftInteger;
        qry.ParamByName(AParamName).AsInteger := StrToInt(AValue);
      end;
    except
      on E: Exception do
        AError := 'Erro no campo Integer ' + AParamName + ': ' + E.Message;
    end;
  end;

  procedure SetFloatParam(const AParamName, AValue: string; qry: TFDQuery; var AError: string);
  begin
    if AError <> '' then
      Exit;

    try
      if qry.Params.FindParam(AParamName) = nil then
      begin
        AError := 'Parâmetro ' + AParamName + ' não encontrado';
        Exit;
      end;
       qry.ParamByName(AParamName).DataType := ftFloat;

      if AValue = '' then
        qry.ParamByName(AParamName).Clear
      else
      begin
        qry.ParamByName(AParamName).AsFloat := GetJSONValueAsFloat(jsonObj, AParamName);
      end;
    except
      on E: Exception do
        AError := 'Erro no campo Float ' + AParamName + ': ' + E.Message;
    end;
  end;

  procedure SetStrParam(const AParamName, AValue: string; qry: TFDQuery; var AError: string);
  begin
    if AError <> '' then
      Exit;

    try
      if qry.Params.FindParam(AParamName) = nil then
      begin
        AError := 'Parâmetro ' + AParamName + ' não encontrado';
        Exit;
      end;
      if qry.ParamByName(AParamName).DataType = ftUnknown then
        qry.ParamByName(AParamName).DataType := ftString;

    // Atribui o valor
      if Trim(AValue) = '' then
        qry.ParamByName(AParamName).Clear
      else
        qry.ParamByName(AParamName).AsString := AValue;

    except
      on E: Exception do
        AError := 'Erro no campo String ' + AParamName + ': ' + E.Message;
    end;
  end;

  procedure SetTextParam(const AParamName, AValue: string; qry: TFDQuery; var AError: string);
  begin
    if AError <> '' then
      Exit;

    try
      if qry.Params.FindParam(AParamName) = nil then
      begin
        AError := 'Parâmetro ' + AParamName + ' não encontrado';
        Exit;
      end;

      qry.ParamByName(AParamName).DataType := ftMemo;
      if AValue = '' then
        qry.ParamByName(AParamName).Clear
      else
        qry.ParamByName(AParamName).AsString := AValue;
    except
      on E: Exception do
        AError := 'Erro no campo Text ' + AParamName + ': ' + E.Message;
    end;
  end;

begin
  Result := 0;
  processados := 0;
  erro := '';

  if not Assigned(jsonArray) then
  begin
    erro := 'Array JSON não inicializado';
    Exit;
  end;

  if jsonArray.Count = 0 then
  begin
    erro := 'Array JSON vazio';
    Exit;
  end;

  // Configuração de formato
  formatSettings := TFormatSettings.Create;
  formatSettings.DateSeparator := '/';
  formatSettings.ShortDateFormat := 'dd/mm/yyyy';
  formatSettings.LongDateFormat := 'dd/mm/yyyy';
  formatSettings.ShortTimeFormat := 'hh:nn:ss';
  formatSettings.LongTimeFormat := 'hh:nn:ss';

  qry := TFDQuery.Create(nil);
  try

    FConn := TConnection.CreateConnection;

    qry.Connection := FConn;

    // Processa cada objeto do array
    for i := 0 to jsonArray.Count - 1 do
    begin
      if not (jsonArray.Items[i] is TJSONObject) then
      begin
        erro := 'Item ' + IntToStr(i) + ' não é um objeto JSON válido';
        Continue;
      end;

      if TJSONObject(jsonArray.Items[i]).Count = 0 then
      begin
        erro := 'Item ' + IntToStr(i) + ' está vazio';
        Continue;
      end;

      jsonObj := jsonArray.Items[i] as TJSONObject;
      erro := '';

      try
        // Prepara a query para cada registro
        qry.SQL.Text := 'INSERT INTO pmtsvivo (' + 'PROCESS_TIME, DATA_MODIFICACAO, UID_IDPMTS, UID_IDENG, UID_IDMASTER, ' + 'UID_UFSIGLA, UID_IDCPOMRF, UID_IDCPOMIE, PMO_SIGLA, PMO_UF, ' + 'PMO_REGIONAL, PMO_DIVISAO, PMO_GESTAO, UID_IBGE, IBGE_MUNICIPIO, ' + 'IBGE_CAPITAL, SIGLA_HOTEL_DE_BTS, FLG_RRU_REMOTA, MASTERSITE_COBERTURA, ' + 'PMO_CARIMBO_CENTRALIZADO, MASTER_CARIMBO, REGIONAL_CARIMBO, PMO_CARIMBO_BASELINE, ' + 'PMO_BASELINE, ANALISE_CARIMBO, EAP_AUTOMATICA, REGIONAL_RISCO, REGIONAL_EAP_CRITICA, '
          + 'UPDATE_EAP_CRITICA, REGIONAL_EAP_RESPONSAVEL, REGIONAL_EAP_OFENSOR, REGIONAL_EAP_ACAO, ' + 'PMO_REF, PMO_DATA_INCLUSAO, PMO_DATA_EXCLUSAO, MASTEROBRA_FREEZING, MASTEROBRA_STATUS_ROLLOUT, ' + 'PMO_CARIMBO_CENTRAL_QUARTER, PMO_ROLLOUT_OVBK, MASTEROBRA_PRIO_ENG, ENG_PARAM_OK, ' + 'ENG_PARAM_NOK, VENDOR_EQUIPAMENTO, VENDOR_VISTORIA, VENDOR_PROJETO, VENDOR_INSTALADOR, ' + 'VENDOR_INTEGRADOR, PMO_TECN_EQUIP, PMO_FREQ_EQUIP, PMO_TIPO_INTERV, PMO_TIPO_INTERV_2, ' +
          'PMO_TIPO_OBRA, PMO_TIPO_PMTS, PMO_CATEGORIA, COMPROMISSADO_SRF, FATURADO_SRF, ' + 'EMITIDO_SRF, ENG_FORNECEDOR_INFRA, ENG_STATUS_DISPARO_INFRA, ENG_GABINETE_NOVO, ' + 'ENG_GRADIL_GABINETE, ENG_DETENTORA_GABINETE, ENG_TIPO_GABINETE, ENG_STEP_GABINETE, ' + 'ENG_FABRICANTE_GABINETE, EQUIPAMENTO_STATUS_PO, VISTORIA_STATUS_PO, PROJETO_STATUS_PO, ' + 'INSTALADOR_STATUS_PO, INTEGRADOR_STATUS_PO, MASTEROBRA_SRF, MASTEROBRA_AVALIACAO_DE_TX, ' +
          'MASTEROBRA_OBSERVACAO_TX, MASTEROBRA_ANO_ACAO_INVERSORA, MASTEROBRA_MEGA_PROJETO, ' + 'MASTEROBRA_OBJ_ENG, ENG_OBJ_MACRO, MASTEROBRA_OBS, MASTERSITE_OBS, PMO_ANO, ' + 'PMO_CLASSIFICACAO, PMO_MEGA, PMO_MIMO_MASSIVE, PMO_NOVO_REF_REPORT, PMO_PEP_RF, ' + 'PMO_PROJETO, PMO_REFERENCIA_REPORT, PMO_RISCO_AUT, PMO_SUB_PROJETO, TX_FLAG_ATIVACAO, ' + 'REGIONAL_OFENSOR_DETALHE, REGIONAL_OFENSOR_MACRO, REGIONAL_OFENSOR_MICRO, REGIONAL_PRIO_REG, ' +
          'REGIONAL_TA_PRAZO, REGIONAL_ACEITE_EAP, REGIONAL_ACEITE_DETALHE, REGIONAL_ACEITE_RESPONSAVEL, ' + 'RSO_DEF_MODALIDADE, PMO_POLIGONO_P, DEADLINE_POLIGONO, RSO_POLIGONO, RSO_RSA_FCU_GABINETE, ' + 'PMO_MODALIDADE_P, DEADLINE_MODALIDADE, RSO_RSA_MODALIDADE, RSO_RSA_RESP_AQS, RSO_RSA_SCI, ' + 'INSTALADOR_ITENS_A_RETIRAR, INSTALADOR_OFENSOR_DETALHE, INSTALADOR_OFENSOR_MACRO, ' + 'INSTALADOR_OFENSOR_MICRO, SIGLA_LOGICA_REFERENCIA, PROJETO_SINERGIA, TA_ACEITACAO, ' +
          'TA_ACEITE_PENDENCIAS, TA_ACEITE_RESPONSAVEL, TA_AGING, TA_STATUS, POSSUI_TA, ' + 'TIPO_GABINETE_SHARING, ENG_ESTRUTURA_TIPO, ESPACO_AERO, IBGE_BW_FREQUENCIA, IBGE_TOP, ' + 'MASTERSITE_CN, MASTERSITE_RANSHARING, MASTERSITE_REMANEJAMENTO_LO, MASTERSITE_REMANEJAMENTO_CIT, ' + 'MASTERSITE_SAZONALIDADE, RSO_RSA_COORDENADOR, RSO_RSA_DETENTORA, RSO_RSA_ID_DETENTORA, ' + 'SCIENCE_BAIRRO, SCIENCE_CEP, SCIENCE_COMPLEMENTO, SCIENCE_DETENTORA, SCIENCE_ENDERECO, ' +
          'SCIENCE_ID_DETENTORA, SCIENCE_ID_FINANCEIRO, SCIENCE_LATITUDE, SCIENCE_LONGITUDE, ' + 'SCIENCE_NOME, TECNOLOGIAS_FINAIS, TIPO_ALARME, EAP_SIGLA_PORTADORA, PROJETO_STATUS_ENG, ' + 'PROJETO_ENGENHARIA_DEF, RSO_EAP_STATUS, RSO_EAP_MACRO, RSO_RSA_SCI_STATUS, ' + 'RSO_RSA_OFENSOR_AQS, EAP_GABINETE, REGIONAL_EAP_INFRA, REGIONAL_EAP_INFRA_RESP, ' + 'STATUS_MENSAL_TX, REGIONAL_PRE_ACEITE_EAP, REGIONAL_PRE_ACEITE_RESPONSAVEL, ' +
          'STATUS_ESTEIRA_PO, INTEGRADOR_ALARME_PRE_EXIST, INTEGRADOR_LOCAL_GABINETE_TECN, ' + 'RSO_DISPARO_P, DEADLINE_DISPARO, RSO_DISPARO_R, RSO_SAR_P, DEADLINE_SAR, RSO_SAR_R, ' + 'RSO_QUALIFICACAO_P, DEADLINE_QUALIFICACAO, RSO_QUALIFICACAO_R, RSO_CONTRATACAO_P, ' + 'DEADLINE_CONTRATACAO, RSO_CONTRATACAO_R, PMO_ABERT_SCI_P, DEADLINE_ABERT_SCI, ' + 'RSO_RSA_ABERT_SCI_R, RSO_RSA_LIB_SCI_P, DEADLINE_LIB_SCI, RSO_RSA_LIB_SCI_R, ' +
          'RSO_RSA_AQUISICAO_P, RSO_RSA_AQUISICAO_R, VISTORIA_VIST_PE_P, DEADLINE_VISTORIA, ' + 'VISTORIA_VIST_PE_R, PROJETO_WR_ENV_P, DEADLINE_WR_ENV, PROJETO_WR_ENV_R, ' + 'RSO_RSA_PROJ_EXEC_P, DEADLINE_PROJ_EXEC, RSO_RSA_PROJ_EXEC_R, PMO_WR_APROV_P, ' + 'DEADLINE_WR_APROV, PROJETO_WR_APROV_R, PROJETO_PPI_P, PROJETO_PPI_R, PMO_T2_DT_P, ' + 'DEADLINE_T2, MAX_T2_DT_R, EQUIPAMENTO_T2_DT_R, EQUIPAMENTO_T4_DT_R, VISTORIA_T2_DT_R, ' + 'VISTORIA_T4_DT_R, PROJETO_T2_DT_R, PROJETO_T4_DT_R, INSTALADOR_T2_DT_R, ' +
          'INSTALADOR_T4_DT_R, INTEGRADOR_T2_DT_R, INTEGRADOR_T4_DT_R, DATA_CRIACAO_PEDIDO, ' + 'OBRA_INICIO_P, DEADLINE_OBRA_INICIO, OBRA_INICIO_R, GABINETE_P, GABINETE_R, ' + 'RSO_RFI_P, RSO_RFI_R, REGIONAL_OBRA_FIM_P, REGIONAL_OBRA_FIM_R, OBRA_FIM_P, ' + 'DEADLINE_OBRA_FIM, OBRA_FIM_R, REGIONAL_LIB_SITE_P, DEADLINE_LIB_SITE, ' + 'REGIONAL_LIB_SITE_R, EQUIPAMENTO_ENTREGA_P, DEADLINE_ENTREGA, EQUIPAMENTO_ENTREGA_R, ' + 'INSTALADOR_RECEBIMENTO_P, INSTALADOR_RECEBIMENTO_R, EQUIPAMENTO_DISP_LIC_R, ' +
          'INTEGRADOR_CHECK_LIC_R, INSTALADOR_INSTALACAO_P, DEADLINE_INSTALACAO, ' + 'INSTALADOR_INSTALACAO_R, TX_OBRA_P, TX_OBRA_R, TX_CIRCUITO_P, DEADLINE_TX_CIRCUITO, ' + 'TX_CIRCUITO_R, INTEGRADOR_INTEGRACAO_P, DEADLINE_INTEGRACAO, INTEGRADOR_INTEGRACAO_R, ' + 'INTEGRADOR_ATIVACAO_P, DEADLINE_ATIVACAO, INTEGRADOR_ATIVACAO_R, INTEGRADOR_ACEITACAO_R, ' + 'INTEGRADOR_ENV_LOG_ATIV_R, REGIONAL_PRE_ACEITE_R, VALID_RSO_POLIGONO, VALID_RSO_DISPARO, ' +'INTEGRADOR_CHECK_LIC_R, INSTALADOR_INSTALACAO_P, DEADLINE_INSTALACAO, ' + 'INSTALADOR_INSTALACAO_R, TX_OBRA_P, TX_OBRA_R, TX_CIRCUITO_P, DEADLINE_TX_CIRCUITO, ' + 'TX_CIRCUITO_R, INTEGRADOR_INTEGRACAO_P, DEADLINE_INTEGRACAO, INTEGRADOR_INTEGRACAO_R, ' + 'INTEGRADOR_ATIVACAO_P, DEADLINE_ATIVACAO, INTEGRADOR_ATIVACAO_R, INTEGRADOR_ACEITACAO_R, ' + 'INTEGRADOR_ENV_LOG_ATIV_R, REGIONAL_PRE_ACEITE_R, PMO_ACEITACAO, VALID_RSO_POLIGONO, VALID_RSO_DISPARO, ' +
          'VALID_RSO_DEF_MODALIDADE, VALID_RSO_SAR, VALID_RSO_QUALIFICACAO, VALID_RSO_CONTRATACAO, ' + 'VALID_SITE_NOVO, VALID_AQUISICAO, VALID_ABERT_SCI, VALID_LIB_SCI, VALID_VIST_PE, ' + 'VALID_RSO_RSA_PROJ_EXEC, VALID_RSO_VALID_RELATORIO_CRITICO, VALID_RSO_VALID_ON_HOLD, ' + 'VALID_WR_ENV, VALID_WR_APROV, PROJETO_WR_STEP_APROV, VALID_PRECISA_PARAM, ' + 'VALID_ENG_PARAM, VALID_SIGLA_PORTADORA, VALID_PPI, VALID_LICENCIAMENTO, ' +
          'VALID_T2_EQUIPAMENTO, VALID_T4_EQUIPAMENTO, VALID_PO_EQUIPAMENTO, VALID_T2_VISTORIA, ' + 'VALID_T4_VISTORIA, VALID_PO_VISTORIA, VALID_T2_PROJETO, VALID_T4_PROJETO, ' + 'VALID_PO_PROJETO, VALID_T2_INSTALADOR, VALID_T4_INSTALADOR, VALID_PO_INSTALADOR, ' + 'VALID_T2_INTEGRADOR, VALID_T4_INTEGRADOR, VALID_PO_INTEGRADOR, VALID_T2, VALID_T4, ' + 'VALID_PO, VALID_OBRA_INICIO, VALID_RSO_OBRA_FIM, VALID_OBRA_FIM, VALID_GABINETE_SHARING, ' +
          'VALID_ENTREGA_GABINETE, VALID_CADASTRO_GABINETES_SHARING, VALID_LIB_SITE, ' + 'VALID_ENTREGA, VALID_RECEBIMENTO, VALID_INSTALACAO, VALID_TX, VALID_INTEGRACAO, ' + 'VALID_FLAG_ATIVACAO, VALID_ATIVACAO, VALID_PRE_ACEITE, VALID_CADASTRO, ' + 'VALID_FLAG_SCIENCE, VALID_ACEITE, VALID_CONCLUSAO_PMTS, VALID_STATUS_ROLLOUT, ' + 'VALID_TA_ACEITACAO, VALID_OBRA_BW, PMO_DIVULGAR, SOLUCAO_TX_FINAL, TX_STATUS_ACIONAMENTO, ' + 'ID_RD_CONSOLIDADO, RD_CARIMBO_MAX, RD_LIB_TRAFEGO_P_MAX, RD_LIB_TRAFEGO_R_MAX, ' +
          'ID_METRO_CONSOLIDADO, METRO_CARIMBO_MAX, METRO_P_MAX, METRO_R_MAX, METRO_STATUS_MAX, ' + 'TX_CARIMBO_MAX, TX_P_MAX, TX_R_MAX, VALID_TX_MAX, FAROL_ESTEIRA, ETAPAS_PEND_PLAN, ' + 'ETAPAS_PLAN, ETAPAS_CONCL, DEADLINE_ALERTA, FAROL_ESTEIRA_HOJE, ETAPAS_HOJE, ' + 'DEADLINE_ALERTA_HOJE, ETAPAS_INCONSIST, FAROL_ETAPA, SLA_ETAPA, DIAS_ETAPA_ATUAL, ' + 'VERSAOVENDOREQUIPAMENTO, VERSAOVENDORINSTALADOR, VERSAOVENDORINTEGRADOR, ' +
          'VERSAOVENDORPROJETO, VERSAOVENDORVISTORIA, VERSAOREGIONALTX, VERSAOREGIONALRF' + ') VALUES (' + ':PROCESS_TIME, :DATA_MODIFICACAO, :UID_IDPMTS, :UID_IDENG, :UID_IDMASTER, ' + ':UID_UFSIGLA, :UID_IDCPOMRF, :UID_IDCPOMIE, :PMO_SIGLA, :PMO_UF, ' + ':PMO_REGIONAL, :PMO_DIVISAO, :PMO_GESTAO, :UID_IBGE, :IBGE_MUNICIPIO, ' + ':IBGE_CAPITAL, :SIGLA_HOTEL_DE_BTS, :FLG_RRU_REMOTA, :MASTERSITE_COBERTURA, ' + ':PMO_CARIMBO_CENTRALIZADO, :MASTER_CARIMBO, :REGIONAL_CARIMBO, :PMO_CARIMBO_BASELINE, ' +
          ':PMO_BASELINE, :ANALISE_CARIMBO, :EAP_AUTOMATICA, :REGIONAL_RISCO, :REGIONAL_EAP_CRITICA, ' + ':UPDATE_EAP_CRITICA, :REGIONAL_EAP_RESPONSAVEL, :REGIONAL_EAP_OFENSOR, :REGIONAL_EAP_ACAO, ' + ':PMO_REF, :PMO_DATA_INCLUSAO, :PMO_DATA_EXCLUSAO, :MASTEROBRA_FREEZING, :MASTEROBRA_STATUS_ROLLOUT, ' + ':PMO_CARIMBO_CENTRAL_QUARTER, :PMO_ROLLOUT_OVBK, :MASTEROBRA_PRIO_ENG, :ENG_PARAM_OK, ' + ':ENG_PARAM_NOK, :VENDOR_EQUIPAMENTO, :VENDOR_VISTORIA, :VENDOR_PROJETO, :VENDOR_INSTALADOR, ' +
          ':VENDOR_INTEGRADOR, :PMO_TECN_EQUIP, :PMO_FREQ_EQUIP, :PMO_TIPO_INTERV, :PMO_TIPO_INTERV_2, ' + ':PMO_TIPO_OBRA, :PMO_TIPO_PMTS, :PMO_CATEGORIA, :COMPROMISSADO_SRF, :FATURADO_SRF, ' + ':EMITIDO_SRF, :ENG_FORNECEDOR_INFRA, :ENG_STATUS_DISPARO_INFRA, :ENG_GABINETE_NOVO, ' + ':ENG_GRADIL_GABINETE, :ENG_DETENTORA_GABINETE, :ENG_TIPO_GABINETE, :ENG_STEP_GABINETE, ' + ':ENG_FABRICANTE_GABINETE, :EQUIPAMENTO_STATUS_PO, :VISTORIA_STATUS_PO, :PROJETO_STATUS_PO, ' +
          ':INSTALADOR_STATUS_PO, :INTEGRADOR_STATUS_PO, :MASTEROBRA_SRF, :MASTEROBRA_AVALIACAO_DE_TX, ' + ':MASTEROBRA_OBSERVACAO_TX, :MASTEROBRA_ANO_ACAO_INVERSORA, :MASTEROBRA_MEGA_PROJETO, ' + ':MASTEROBRA_OBJ_ENG, :ENG_OBJ_MACRO, :MASTEROBRA_OBS, :MASTERSITE_OBS, :PMO_ANO, ' + ':PMO_CLASSIFICACAO, :PMO_MEGA, :PMO_MIMO_MASSIVE, :PMO_NOVO_REF_REPORT, :PMO_PEP_RF, ' + ':PMO_PROJETO, :PMO_REFERENCIA_REPORT, :PMO_RISCO_AUT, :PMO_SUB_PROJETO, :TX_FLAG_ATIVACAO, ' +
          ':REGIONAL_OFENSOR_DETALHE, :REGIONAL_OFENSOR_MACRO, :REGIONAL_OFENSOR_MICRO, :REGIONAL_PRIO_REG, ' + ':REGIONAL_TA_PRAZO, :REGIONAL_ACEITE_EAP, :REGIONAL_ACEITE_DETALHE, :REGIONAL_ACEITE_RESPONSAVEL, ' + ':RSO_DEF_MODALIDADE, :PMO_POLIGONO_P, :DEADLINE_POLIGONO, :RSO_POLIGONO, :RSO_RSA_FCU_GABINETE, ' + ':PMO_MODALIDADE_P, :DEADLINE_MODALIDADE, :RSO_RSA_MODALIDADE, :RSO_RSA_RESP_AQS, :RSO_RSA_SCI, ' + ':INSTALADOR_ITENS_A_RETIRAR, :INSTALADOR_OFENSOR_DETALHE, :INSTALADOR_OFENSOR_MACRO, ' +
          ':INSTALADOR_OFENSOR_MICRO, :SIGLA_LOGICA_REFERENCIA, :PROJETO_SINERGIA, :TA_ACEITACAO, ' + ':TA_ACEITE_PENDENCIAS, :TA_ACEITE_RESPONSAVEL, :TA_AGING, :TA_STATUS, :POSSUI_TA, ' + ':TIPO_GABINETE_SHARING, :ENG_ESTRUTURA_TIPO, :ESPACO_AERO, :IBGE_BW_FREQUENCIA, :IBGE_TOP, ' + ':MASTERSITE_CN, :MASTERSITE_RANSHARING, :MASTERSITE_REMANEJAMENTO_LO, :MASTERSITE_REMANEJAMENTO_CIT, ' + ':MASTERSITE_SAZONALIDADE, :RSO_RSA_COORDENADOR, :RSO_RSA_DETENTORA, :RSO_RSA_ID_DETENTORA, ' +
          ':SCIENCE_BAIRRO, :SCIENCE_CEP, :SCIENCE_COMPLEMENTO, :SCIENCE_DETENTORA, :SCIENCE_ENDERECO, ' + ':SCIENCE_ID_DETENTORA, :SCIENCE_ID_FINANCEIRO, :SCIENCE_LATITUDE, :SCIENCE_LONGITUDE, ' + ':SCIENCE_NOME, :TECNOLOGIAS_FINAIS, :TIPO_ALARME, :EAP_SIGLA_PORTADORA, :PROJETO_STATUS_ENG, ' + ':PROJETO_ENGENHARIA_DEF, :RSO_EAP_STATUS, :RSO_EAP_MACRO, :RSO_RSA_SCI_STATUS, ' + ':RSO_RSA_OFENSOR_AQS, :EAP_GABINETE, :REGIONAL_EAP_INFRA, :REGIONAL_EAP_INFRA_RESP, ' +
          ':STATUS_MENSAL_TX, :REGIONAL_PRE_ACEITE_EAP, :REGIONAL_PRE_ACEITE_RESPONSAVEL, ' + ':STATUS_ESTEIRA_PO, :INTEGRADOR_ALARME_PRE_EXIST, :INTEGRADOR_LOCAL_GABINETE_TECN, ' + ':RSO_DISPARO_P, :DEADLINE_DISPARO, :RSO_DISPARO_R, :RSO_SAR_P, :DEADLINE_SAR, :RSO_SAR_R, ' + ':RSO_QUALIFICACAO_P, :DEADLINE_QUALIFICACAO, :RSO_QUALIFICACAO_R, :RSO_CONTRATACAO_P, ' + ':DEADLINE_CONTRATACAO, :RSO_CONTRATACAO_R, :PMO_ABERT_SCI_P, :DEADLINE_ABERT_SCI, ' +
          ':RSO_RSA_ABERT_SCI_R, :RSO_RSA_LIB_SCI_P, :DEADLINE_LIB_SCI, :RSO_RSA_LIB_SCI_R, ' + ':RSO_RSA_AQUISICAO_P, :RSO_RSA_AQUISICAO_R, :VISTORIA_VIST_PE_P, :DEADLINE_VISTORIA, ' + ':VISTORIA_VIST_PE_R, :PROJETO_WR_ENV_P, :DEADLINE_WR_ENV, :PROJETO_WR_ENV_R, ' + ':RSO_RSA_PROJ_EXEC_P, :DEADLINE_PROJ_EXEC, :RSO_RSA_PROJ_EXEC_R, :PMO_WR_APROV_P, ' + ':DEADLINE_WR_APROV, :PROJETO_WR_APROV_R, :PROJETO_PPI_P, :PROJETO_PPI_R, :PMO_T2_DT_P, ' +
          ':DEADLINE_T2, :MAX_T2_DT_R, :EQUIPAMENTO_T2_DT_R, :EQUIPAMENTO_T4_DT_R, :VISTORIA_T2_DT_R, ' + ':VISTORIA_T4_DT_R, :PROJETO_T2_DT_R, :PROJETO_T4_DT_R, :INSTALADOR_T2_DT_R, ' + ':INSTALADOR_T4_DT_R, :INTEGRADOR_T2_DT_R, :INTEGRADOR_T4_DT_R, :DATA_CRIACAO_PEDIDO, ' + ':OBRA_INICIO_P, :DEADLINE_OBRA_INICIO, :OBRA_INICIO_R, :GABINETE_P, :GABINETE_R, ' + ':RSO_RFI_P, :RSO_RFI_R, :REGIONAL_OBRA_FIM_P, :REGIONAL_OBRA_FIM_R, :OBRA_FIM_P, ' +
          ':DEADLINE_OBRA_FIM, :OBRA_FIM_R, :REGIONAL_LIB_SITE_P, :DEADLINE_LIB_SITE, ' + ':REGIONAL_LIB_SITE_R, :EQUIPAMENTO_ENTREGA_P, :DEADLINE_ENTREGA, :EQUIPAMENTO_ENTREGA_R, ' + ':INSTALADOR_RECEBIMENTO_P, :INSTALADOR_RECEBIMENTO_R, :EQUIPAMENTO_DISP_LIC_R, ' + ':INTEGRADOR_CHECK_LIC_R, :INSTALADOR_INSTALACAO_P, :DEADLINE_INSTALACAO, ' + ':INSTALADOR_INSTALACAO_R, :TX_OBRA_P, :TX_OBRA_R, :TX_CIRCUITO_P, :DEADLINE_TX_CIRCUITO, ' +
          ':TX_CIRCUITO_R, :INTEGRADOR_INTEGRACAO_P, :DEADLINE_INTEGRACAO, :INTEGRADOR_INTEGRACAO_R, ' + ':INTEGRADOR_ATIVACAO_P, :DEADLINE_ATIVACAO, :INTEGRADOR_ATIVACAO_R, :INTEGRADOR_ACEITACAO_R, ' + ':INTEGRADOR_ENV_LOG_ATIV_R, :REGIONAL_PRE_ACEITE_R, :PMO_ACEITACAO, :VALID_RSO_POLIGONO, :VALID_RSO_DISPARO, ' + ':VALID_RSO_DEF_MODALIDADE, :VALID_RSO_SAR, :VALID_RSO_QUALIFICACAO, :VALID_RSO_CONTRATACAO, ' + ':VALID_SITE_NOVO, :VALID_AQUISICAO, :VALID_ABERT_SCI, :VALID_LIB_SCI, :VALID_VIST_PE, ' +':TX_CIRCUITO_R, :INTEGRADOR_INTEGRACAO_P, :DEADLINE_INTEGRACAO, :INTEGRADOR_INTEGRACAO_R, ' + ':INTEGRADOR_ATIVACAO_P, :DEADLINE_ATIVACAO, :INTEGRADOR_ATIVACAO_R, :INTEGRADOR_ACEITACAO_R, ' + ':INTEGRADOR_ENV_LOG_ATIV_R, :REGIONAL_PRE_ACEITE_R, :VALID_RSO_POLIGONO, :VALID_RSO_DISPARO, ' + ':VALID_RSO_DEF_MODALIDADE, :VALID_RSO_SAR, :VALID_RSO_QUALIFICACAO, :VALID_RSO_CONTRATACAO, ' + ':VALID_SITE_NOVO, :VALID_AQUISICAO, :VALID_ABERT_SCI, :VALID_LIB_SCI, :VALID_VIST_PE, ' +
          ':VALID_RSO_RSA_PROJ_EXEC, :VALID_RSO_VALID_RELATORIO_CRITICO, :VALID_RSO_VALID_ON_HOLD, ' + ':VALID_WR_ENV, :VALID_WR_APROV, :PROJETO_WR_STEP_APROV, :VALID_PRECISA_PARAM, ' + ':VALID_ENG_PARAM, :VALID_SIGLA_PORTADORA, :VALID_PPI, :VALID_LICENCIAMENTO, ' + ':VALID_T2_EQUIPAMENTO, :VALID_T4_EQUIPAMENTO, :VALID_PO_EQUIPAMENTO, :VALID_T2_VISTORIA, ' + ':VALID_T4_VISTORIA, :VALID_PO_VISTORIA, :VALID_T2_PROJETO, :VALID_T4_PROJETO, ' +
          ':VALID_PO_PROJETO, :VALID_T2_INSTALADOR, :VALID_T4_INSTALADOR, :VALID_PO_INSTALADOR, ' + ':VALID_T2_INTEGRADOR, :VALID_T4_INTEGRADOR, :VALID_PO_INTEGRADOR, :VALID_T2, :VALID_T4, ' + ':VALID_PO, :VALID_OBRA_INICIO, :VALID_RSO_OBRA_FIM, :VALID_OBRA_FIM, :VALID_GABINETE_SHARING, ' + ':VALID_ENTREGA_GABINETE, :VALID_CADASTRO_GABINETES_SHARING, :VALID_LIB_SITE, ' + ':VALID_ENTREGA, :VALID_RECEBIMENTO, :VALID_INSTALACAO, :VALID_TX, :VALID_INTEGRACAO, ' +
          ':VALID_FLAG_ATIVACAO, :VALID_ATIVACAO, :VALID_PRE_ACEITE, :VALID_CADASTRO, ' + ':VALID_FLAG_SCIENCE, :VALID_ACEITE, :VALID_CONCLUSAO_PMTS, :VALID_STATUS_ROLLOUT, ' + ':VALID_TA_ACEITACAO, :VALID_OBRA_BW, :PMO_DIVULGAR, :SOLUCAO_TX_FINAL, :TX_STATUS_ACIONAMENTO, ' + ':ID_RD_CONSOLIDADO, :RD_CARIMBO_MAX, :RD_LIB_TRAFEGO_P_MAX, :RD_LIB_TRAFEGO_R_MAX, ' + ':ID_METRO_CONSOLIDADO, :METRO_CARIMBO_MAX, :METRO_P_MAX, :METRO_R_MAX, :METRO_STATUS_MAX, ' +
          ':TX_CARIMBO_MAX, :TX_P_MAX, :TX_R_MAX, :VALID_TX_MAX, :FAROL_ESTEIRA, :ETAPAS_PEND_PLAN, ' + ':ETAPAS_PLAN, :ETAPAS_CONCL, :DEADLINE_ALERTA, :FAROL_ESTEIRA_HOJE, :ETAPAS_HOJE, ' + ':DEADLINE_ALERTA_HOJE, :ETAPAS_INCONSIST, :FAROL_ETAPA, :SLA_ETAPA, :DIAS_ETAPA_ATUAL, ' + ':VERSAOVENDOREQUIPAMENTO, :VERSAOVENDORINSTALADOR, :VERSAOVENDORINTEGRADOR, ' + ':VERSAOVENDORPROJETO, :VERSAOVENDORVISTORIA, :VERSAOREGIONALTX, :VERSAOREGIONALRF)';
        if qry.Params[i].DataType = ftUnknown then
          qry.Params[i].DataType := ftString;
          // Processa todos os campos DateTime

        SetDateTimeParam('DEADLINE_SAR', GetJSONValue(jsonObj, 'DEADLINE_SAR'), qry, erro);
        SetDateTimeParam('PROCESS_TIME', GetJSONValue(jsonObj, 'PROCESS_TIME'), qry, erro);
        SetDateTimeParam('DATA_MODIFICACAO', GetJSONValue(jsonObj, 'DATA_MODIFICACAO'), qry, erro);
        SetDateTimeParam('PMO_CARIMBO_CENTRALIZADO', GetJSONValue(jsonObj, 'PMO_CARIMBO_CENTRALIZADO'), qry, erro);
        SetDateTimeParam('MASTER_CARIMBO', GetJSONValue(jsonObj, 'MASTER_CARIMBO'), qry, erro);
        SetDateTimeParam('REGIONAL_CARIMBO', GetJSONValue(jsonObj, 'REGIONAL_CARIMBO'), qry, erro);
        SetDateTimeParam('PMO_CARIMBO_BASELINE', GetJSONValue(jsonObj, 'PMO_CARIMBO_BASELINE'), qry, erro);
        SetDateTimeParam('RSO_DEF_MODALIDADE', GetJSONValue(jsonObj, 'RSO_DEF_MODALIDADE'), qry, erro);
        SetDateTimeParam('RSO_POLIGONO', GetJSONValue(jsonObj, 'RSO_POLIGONO'), qry, erro);
        SetDateTimeParam('RSO_DISPARO_P', GetJSONValue(jsonObj, 'RSO_DISPARO_P'), qry, erro);
        SetDateTimeParam('DEADLINE_DISPARO', GetJSONValue(jsonObj, 'DEADLINE_DISPARO'), qry, erro);
        SetDateTimeParam('RSO_DISPARO_R', GetJSONValue(jsonObj, 'RSO_DISPARO_R'), qry, erro);
        SetDateTimeParam('RSO_SAR_P', GetJSONValue(jsonObj, 'RSO_SAR_P'), qry, erro);
        SetDateTimeParam('RSO_SAR_R', GetJSONValue(jsonObj, 'RSO_SAR_R'), qry, erro);
        SetDateTimeParam('RSO_QUALIFICACAO_P', GetJSONValue(jsonObj, 'RSO_QUALIFICACAO_P'), qry, erro);
        SetDateTimeParam('RSO_QUALIFICACAO_R', GetJSONValue(jsonObj, 'RSO_QUALIFICACAO_R'), qry, erro);
        SetDateTimeParam('RSO_CONTRATACAO_P', GetJSONValue(jsonObj, 'RSO_CONTRATACAO_P'), qry, erro);
        SetDateTimeParam('RSO_CONTRATACAO_R', GetJSONValue(jsonObj, 'RSO_CONTRATACAO_R'), qry, erro);
        SetDateTimeParam('PMO_ABERT_SCI_P', GetJSONValue(jsonObj, 'PMO_ABERT_SCI_P'), qry, erro);
        SetDateTimeParam('DEADLINE_ABERT_SCI', GetJSONValue(jsonObj, 'DEADLINE_ABERT_SCI'), qry, erro);
        SetDateTimeParam('RSO_RSA_ABERT_SCI_R', GetJSONValue(jsonObj, 'RSO_RSA_ABERT_SCI_R'), qry, erro);
        SetDateTimeParam('DEADLINE_LIB_SCI', GetJSONValue(jsonObj, 'DEADLINE_LIB_SCI'), qry, erro);
        SetDateTimeParam('RSO_RSA_LIB_SCI_R', GetJSONValue(jsonObj, 'RSO_RSA_LIB_SCI_R'), qry, erro);
        SetDateTimeParam('VISTORIA_VIST_PE_P', GetJSONValue(jsonObj, 'VISTORIA_VIST_PE_P'), qry, erro);
        SetDateTimeParam('DEADLINE_VISTORIA', GetJSONValue(jsonObj, 'DEADLINE_VISTORIA'), qry, erro);
        SetDateTimeParam('VISTORIA_VIST_PE_R', GetJSONValue(jsonObj, 'VISTORIA_VIST_PE_R'), qry, erro);
        SetDateTimeParam('PROJETO_WR_ENV_P', GetJSONValue(jsonObj, 'PROJETO_WR_ENV_P'), qry, erro);
        SetDateTimeParam('DEADLINE_WR_ENV', GetJSONValue(jsonObj, 'DEADLINE_WR_ENV'), qry, erro);
        SetDateTimeParam('PROJETO_WR_ENV_R', GetJSONValue(jsonObj, 'PROJETO_WR_ENV_R'), qry, erro);
        SetDateTimeParam('PMO_WR_APROV_P', GetJSONValue(jsonObj, 'PMO_WR_APROV_P'), qry, erro);
        SetDateTimeParam('DEADLINE_WR_APROV', GetJSONValue(jsonObj, 'DEADLINE_WR_APROV'), qry, erro);
        SetDateTimeParam('PROJETO_WR_APROV_R', GetJSONValue(jsonObj, 'PROJETO_WR_APROV_R'), qry, erro);
        SetDateTimeParam('PROJETO_PPI_P', GetJSONValue(jsonObj, 'PROJETO_PPI_P'), qry, erro);
        SetDateTimeParam('PROJETO_PPI_R', GetJSONValue(jsonObj, 'PROJETO_PPI_R'), qry, erro);
        SetDateTimeParam('PMO_T2_DT_P', GetJSONValue(jsonObj, 'PMO_T2_DT_P'), qry, erro);
        SetDateTimeParam('DEADLINE_T2', GetJSONValue(jsonObj, 'DEADLINE_T2'), qry, erro);
        SetDateTimeParam('EQUIPAMENTO_T2_DT_R', GetJSONValue(jsonObj, 'EQUIPAMENTO_T2_DT_R'), qry, erro);
        SetDateTimeParam('EQUIPAMENTO_T4_DT_R', GetJSONValue(jsonObj, 'EQUIPAMENTO_T4_DT_R'), qry, erro);
        SetDateTimeParam('VISTORIA_T2_DT_R', GetJSONValue(jsonObj, 'VISTORIA_T2_DT_R'), qry, erro);
        SetDateTimeParam('VISTORIA_T4_DT_R', GetJSONValue(jsonObj, 'VISTORIA_T4_DT_R'), qry, erro);
        SetDateTimeParam('PROJETO_T2_DT_R', GetJSONValue(jsonObj, 'PROJETO_T2_DT_R'), qry, erro);
        SetDateTimeParam('PROJETO_T4_DT_R', GetJSONValue(jsonObj, 'PROJETO_T4_DT_R'), qry, erro);
        SetDateTimeParam('INSTALADOR_T2_DT_R', GetJSONValue(jsonObj, 'INSTALADOR_T2_DT_R'), qry, erro);
        SetDateTimeParam('DATA_CRIACAO_PEDIDO', GetJSONValue(jsonObj, 'DATA_CRIACAO_PEDIDO'), qry, erro);
        SetDateTimeParam('OBRA_INICIO_P', GetJSONValue(jsonObj, 'OBRA_INICIO_P'), qry, erro);
        SetDateTimeParam('DEADLINE_OBRA_INICIO', GetJSONValue(jsonObj, 'DEADLINE_OBRA_INICIO'), qry, erro);
        SetDateTimeParam('GABINETE_P', GetJSONValue(jsonObj, 'GABINETE_P'), qry, erro);
        SetDateTimeParam('GABINETE_R', GetJSONValue(jsonObj, 'GABINETE_R'), qry, erro);
        SetDateTimeParam('RSO_RFI_P', GetJSONValue(jsonObj, 'RSO_RFI_P'), qry, erro);
        SetDateTimeParam('RSO_RFI_R', GetJSONValue(jsonObj, 'RSO_RFI_R'), qry, erro);
        SetDateTimeParam('REGIONAL_OBRA_FIM_P', GetJSONValue(jsonObj, 'REGIONAL_OBRA_FIM_P'), qry, erro);
        SetDateTimeParam('OBRA_FIM_P', GetJSONValue(jsonObj, 'OBRA_FIM_P'), qry, erro);
        SetDateTimeParam('DEADLINE_OBRA_FIM', GetJSONValue(jsonObj, 'DEADLINE_OBRA_FIM'), qry, erro);
        SetDateTimeParam('REGIONAL_LIB_SITE_P', GetJSONValue(jsonObj, 'REGIONAL_LIB_SITE_P'), qry, erro);
        SetDateTimeParam('DEADLINE_LIB_SITE', GetJSONValue(jsonObj, 'DEADLINE_LIB_SITE'), qry, erro);
        SetDateTimeParam('REGIONAL_LIB_SITE_R', GetJSONValue(jsonObj, 'REGIONAL_LIB_SITE_R'), qry, erro);
        SetDateTimeParam('EQUIPAMENTO_ENTREGA_P', GetJSONValue(jsonObj, 'EQUIPAMENTO_ENTREGA_P'), qry, erro);
        SetDateTimeParam('DEADLINE_ENTREGA', GetJSONValue(jsonObj, 'DEADLINE_ENTREGA'), qry, erro);
        SetDateTimeParam('INSTALADOR_RECEBIMENTO_P', GetJSONValue(jsonObj, 'INSTALADOR_RECEBIMENTO_P'), qry, erro);
        SetDateTimeParam('INSTALADOR_INSTALACAO_P', GetJSONValue(jsonObj, 'INSTALADOR_INSTALACAO_P'), qry, erro);
        SetDateTimeParam('DEADLINE_INSTALACAO', GetJSONValue(jsonObj, 'DEADLINE_INSTALACAO'), qry, erro);
        SetDateTimeParam('TX_CIRCUITO_P', GetJSONValue(jsonObj, 'TX_CIRCUITO_P'), qry, erro);
        SetDateTimeParam('DEADLINE_TX_CIRCUITO', GetJSONValue(jsonObj, 'DEADLINE_TX_CIRCUITO'), qry, erro);
        SetDateTimeParam('TX_CIRCUITO_R', GetJSONValue(jsonObj, 'TX_CIRCUITO_R'), qry, erro);
        SetDateTimeParam('INTEGRADOR_INTEGRACAO_P', GetJSONValue(jsonObj, 'INTEGRADOR_INTEGRACAO_P'), qry, erro);
        SetDateTimeParam('DEADLINE_INTEGRACAO', GetJSONValue(jsonObj, 'DEADLINE_INTEGRACAO'), qry, erro);
        SetDateTimeParam('INTEGRADOR_ATIVACAO_P', GetJSONValue(jsonObj, 'INTEGRADOR_ATIVACAO_P'), qry, erro);
        SetDateTimeParam('DEADLINE_ATIVACAO', GetJSONValue(jsonObj, 'DEADLINE_ATIVACAO'), qry, erro);
        SetDateTimeParam('VERSAOVENDOREQUIPAMENTO', GetJSONValue(jsonObj, 'VERSAOVENDOREQUIPAMENTO'), qry, erro);
        SetDateTimeParam('VERSAOVENDORINSTALADOR', GetJSONValue(jsonObj, 'VERSAOVENDORINSTALADOR'), qry, erro);
        SetDateTimeParam('VERSAOVENDORINTEGRADOR', GetJSONValue(jsonObj, 'VERSAOVENDORINTEGRADOR'), qry, erro);
        SetDateTimeParam('VERSAOVENDORPROJETO', GetJSONValue(jsonObj, 'VERSAOVENDORPROJETO'), qry, erro);
        SetDateTimeParam('VERSAOVENDORVISTORIA', GetJSONValue(jsonObj, 'VERSAOVENDORVISTORIA'), qry, erro);
        SetDateTimeParam('VERSAOREGIONALTX', GetJSONValue(jsonObj, 'VERSAOREGIONALTX'), qry, erro);
        SetDateTimeParam('VERSAOREGIONALRF', GetJSONValue(jsonObj, 'VERSAOREGIONALRF'), qry, erro);
        SetDateTimeParam('PMO_DATA_INCLUSAO', GetJSONValue(jsonObj, 'PMO_DATA_INCLUSAO'), qry, erro);
        SetDateTimeParam('PMO_DATA_EXCLUSAO', GetJSONValue(jsonObj, 'PMO_DATA_EXCLUSAO'), qry, erro);
        SetDateTimeParam('INTEGRADOR_T2_DT_R', GetJSONValue(jsonObj, 'INTEGRADOR_T2_DT_R'), qry, erro);
  

    // Processa todos os campos Integer
        SetIntParam('UID_IBGE', GetJSONValue(jsonObj, 'UID_IBGE'), qry, erro);
        SetIntParam('MASTEROBRA_ANO_ACAO_INVERSORA', GetJSONValue(jsonObj, 'MASTEROBRA_ANO_ACAO_INVERSORA'), qry, erro);
        SetIntParam('PMO_ANO', GetJSONValue(jsonObj, 'PMO_ANO'), qry, erro);
        SetIntParam('PMO_CLASSIFICACAO', GetJSONValue(jsonObj, 'PMO_CLASSIFICACAO'), qry, erro);
        SetIntParam('MASTERSITE_CN', GetJSONValue(jsonObj, 'MASTERSITE_CN'), qry, erro);
        qry.ParamByName('SLA_ETAPA').DataType := ftinteger;
        SetIntParam('SLA_ETAPA', GetJSONValue(jsonObj, 'SLA_ETAPA'), qry, erro);             // ESSE
        SetIntParam('DIAS_ETAPA_ATUAL', GetJSONValue(jsonObj, 'DIAS_ETAPA_ATUAL'), qry, erro);

    // Processa todos os campos Float

        SetFloatParam('SCIENCE_LATITUDE', GetJSONValue(jsonObj, 'SCIENCE_LATITUDE'), qry, erro);          // esse
        SetFloatParam('SCIENCE_LONGITUDE', GetJSONValue(jsonObj, 'SCIENCE_LONGITUDE'), qry, erro);
        SetFloatParam('COMPROMISSADO_SRF', GetJSONValue(jsonObj, 'COMPROMISSADO_$RF'), qry, erro); // esse
        SetFloatParam('FATURADO_SRF', GetJSONValue(jsonObj, 'FATURADO_$RF'), qry, erro);
        SetFloatParam('EMITIDO_SRF', GetJSONValue(jsonObj, 'EMITIDO_$RF'), qry, erro);
        SetFloatParam('MASTEROBRA_SRF', GetJSONValue(jsonObj, 'MASTEROBRA_$RF'), qry, erro);
                                      // DateTime
        SetDateTimeParam('MAX_T2_DT_R', GetJSONValue(jsonObj, 'MAX_T2_DT_R'), qry, erro);
        SetDateTimeParam('INSTALADOR_T4_DT_R', GetJSONValue(jsonObj, 'INSTALADOR_T4_DT_R'), qry, erro);
        SetDateTimeParam('INTEGRADOR_T4_DT_R', GetJSONValue(jsonObj, 'INTEGRADOR_T4_DT_R'), qry, erro);
        SetDateTimeParam('OBRA_INICIO_R', GetJSONValue(jsonObj, 'OBRA_INICIO_R'), qry, erro);
        SetDateTimeParam('RSO_RFI_P', GetJSONValue(jsonObj, 'RSO_RFI_P'), qry, erro);
        SetDateTimeParam('RSO_RFI_R', GetJSONValue(jsonObj, 'RSO_RFI_R'), qry, erro);
        SetDateTimeParam('REGIONAL_OBRA_FIM_R', GetJSONValue(jsonObj, 'REGIONAL_OBRA_FIM_R'), qry, erro);
        SetDateTimeParam('OBRA_FIM_R', GetJSONValue(jsonObj, 'OBRA_FIM_R'), qry, erro);
        SetDateTimeParam('EQUIPAMENTO_ENTREGA_R', GetJSONValue(jsonObj, 'EQUIPAMENTO_ENTREGA_R'), qry, erro);
        SetDateTimeParam('INSTALADOR_RECEBIMENTO_R', GetJSONValue(jsonObj, 'INSTALADOR_RECEBIMENTO_R'), qry, erro);
        SetDateTimeParam('EQUIPAMENTO_DISP_LIC_R', GetJSONValue(jsonObj, 'EQUIPAMENTO_DISP_LIC_R'), qry, erro);
        SetDateTimeParam('INTEGRADOR_CHECK_LIC_R', GetJSONValue(jsonObj, 'INTEGRADOR_CHECK_LIC_R'), qry, erro);
        SetDateTimeParam('INSTALADOR_INSTALACAO_R', GetJSONValue(jsonObj, 'INSTALADOR_INSTALACAO_R'), qry, erro);
        SetDateTimeParam('TX_OBRA_P', GetJSONValue(jsonObj, 'TX_OBRA_P'), qry, erro);
        SetDateTimeParam('TX_OBRA_R', GetJSONValue(jsonObj, 'TX_OBRA_R'), qry, erro);
        SetDateTimeParam('INTEGRADOR_INTEGRACAO_R', GetJSONValue(jsonObj, 'INTEGRADOR_INTEGRACAO_R'), qry, erro);
        SetDateTimeParam('INTEGRADOR_ATIVACAO_R', GetJSONValue(jsonObj, 'INTEGRADOR_ATIVACAO_R'), qry, erro);
        SetDateTimeParam('INTEGRADOR_ACEITACAO_R', GetJSONValue(jsonObj, 'INTEGRADOR_ACEITACAO_R'), qry, erro);
        SetDateTimeParam('INTEGRADOR_ENV_LOG_ATIV_R', GetJSONValue(jsonObj, 'INTEGRADOR_ENV_LOG_ATIV_R'), qry, erro);
        SetDateTimeParam('REGIONAL_PRE_ACEITE_R', GetJSONValue(jsonObj, 'REGIONAL_PRE_ACEITE_R'), qry, erro);SetDateTimeParam('REGIONAL_PRE_ACEITE_R', GetJSONValue(jsonObj, 'REGIONAL_PRE_ACEITE_R'), qry, erro);
        SetDateTimeParam('PMO_ACEITACAO', GetJSONValue(jsonObj, 'PMO_ACEITACAO'), qry, erro);
        SetDateTimeParam('RSO_RSA_AQUISICAO_P', GetJSONValue(jsonObj, 'RSO_RSA_AQUISICAO_P'), qry, erro);
        SetDateTimeParam('RSO_RSA_AQUISICAO_R', GetJSONValue(jsonObj, 'RSO_RSA_AQUISICAO_R'), qry, erro);
        SetDateTimeParam('RSO_RSA_PROJ_EXEC_P', GetJSONValue(jsonObj, 'RSO_RSA_PROJ_EXEC_P'), qry, erro);
        SetDateTimeParam('DEADLINE_PROJ_EXEC', GetJSONValue(jsonObj, 'DEADLINE_PROJ_EXEC'), qry, erro);
        SetDateTimeParam('RSO_RSA_PROJ_EXEC_R', GetJSONValue(jsonObj, 'RSO_RSA_PROJ_EXEC_R'), qry, erro);
        SetDateTimeParam('RD_CARIMBO_MAX', GetJSONValue(jsonObj, 'RD_CARIMBO_MAX'), qry, erro);
        SetDateTimeParam('RD_LIB_TRAFEGO_P_MAX', GetJSONValue(jsonObj, 'RD_LIB_TRAFEGO_P_MAX'), qry, erro);
        SetDateTimeParam('RD_LIB_TRAFEGO_R_MAX', GetJSONValue(jsonObj, 'RD_LIB_TRAFEGO_R_MAX'), qry, erro);
        SetDateTimeParam('METRO_CARIMBO_MAX', GetJSONValue(jsonObj, 'METRO_CARIMBO_MAX'), qry, erro);
        SetDateTimeParam('METRO_P_MAX', GetJSONValue(jsonObj, 'METRO_P_MAX'), qry, erro);
        SetDateTimeParam('METRO_R_MAX', GetJSONValue(jsonObj, 'METRO_R_MAX'), qry, erro);
        SetDateTimeParam('TX_CARIMBO_MAX', GetJSONValue(jsonObj, 'TX_CARIMBO_MAX'), qry, erro);
        SetDateTimeParam('TX_P_MAX', GetJSONValue(jsonObj, 'TX_P_MAX'), qry, erro);
        SetDateTimeParam('TX_R_MAX', GetJSONValue(jsonObj, 'TX_R_MAX'), qry, erro);
        SetDateTimeParam('MAX_T2_DT_R', GetJSONValue(jsonObj, 'MAX_T2_DT_R'), qry, erro);
        SetDateTimeParam('INSTALADOR_T4_DT_R', GetJSONValue(jsonObj, 'INSTALADOR_T4_DT_R'), qry, erro);
        SetDateTimeParam('INTEGRADOR_T4_DT_R', GetJSONValue(jsonObj, 'INTEGRADOR_T4_DT_R'), qry, erro);
        SetDateTimeParam('OBRA_INICIO_R', GetJSONValue(jsonObj, 'OBRA_INICIO_R'), qry, erro);
        SetDateTimeParam('OBRA_FIM_R', GetJSONValue(jsonObj, 'OBRA_FIM_R'), qry, erro);
        SetDateTimeParam('INSTALADOR_INSTALACAO_R', GetJSONValue(jsonObj, 'INSTALADOR_INSTALACAO_R'), qry, erro);
        SetDateTimeParam('TX_OBRA_R', GetJSONValue(jsonObj, 'TX_OBRA_R'), qry, erro);
        SetDateTimeParam('REGIONAL_OBRA_FIM_R', GetJSONValue(jsonObj, 'REGIONAL_OBRA_FIM_R'), qry, erro);
        SetDateTimeParam('INTEGRADOR_ACEITACAO_R', GetJSONValue(jsonObj, 'INTEGRADOR_ACEITACAO_R'), qry, erro);
        SetDateTimeParam('INTEGRADOR_ENV_LOG_ATIV_R', GetJSONValue(jsonObj, 'INTEGRADOR_ENV_LOG_ATIV_R'), qry, erro);
        SetDateTimeParam('REGIONAL_PRE_ACEITE_R', GetJSONValue(jsonObj, 'REGIONAL_PRE_ACEITE_R'), qry, erro);
        SetDateTimeParam('PMO_ACEITACAO', GetJSONValue(jsonObj, 'PMO_ACEITACAO'), qry, erro);
        SetDateTimeParam('DEADLINE_MODALIDADE', GetJSONValue(jsonObj, 'DEADLINE_MODALIDADE'), qry, erro);
        SetDateTimeParam('DEADLINE_POLIGONO', GetJSONValue(jsonObj, 'DEADLINE_POLIGONO'), qry, erro);
        SetDateTimeParam('RSO_RSA_AQUISICAO_P', GetJSONValue(jsonObj, 'RSO_RSA_AQUISICAO_P'), qry, erro);
        SetDateTimeParam('RSO_RSA_AQUISICAO_R', GetJSONValue(jsonObj, 'RSO_RSA_AQUISICAO_R'), qry, erro);
        SetDateTimeParam('RSO_RSA_LIB_SCI_P', GetJSONValue(jsonObj, 'RSO_RSA_LIB_SCI_P'), qry, erro);
        SetDateTimeParam('RSO_RSA_PROJ_EXEC_P', GetJSONValue(jsonObj, 'RSO_RSA_PROJ_EXEC_P'), qry, erro);
        SetDateTimeParam('RSO_RSA_PROJ_EXEC_R', GetJSONValue(jsonObj, 'RSO_RSA_PROJ_EXEC_R'), qry, erro);
        SetDateTimeParam('RD_CARIMBO_MAX', GetJSONValue(jsonObj, 'RD_CARIMBO_MAX'), qry, erro);
        SetDateTimeParam('RD_LIB_TRAFEGO_P_MAX', GetJSONValue(jsonObj, 'RD_LIB_TRAFEGO_P_MAX'), qry, erro);
        SetDateTimeParam('RD_LIB_TRAFEGO_R_MAX', GetJSONValue(jsonObj, 'RD_LIB_TRAFEGO_R_MAX'), qry, erro);
        SetDateTimeParam('METRO_CARIMBO_MAX', GetJSONValue(jsonObj, 'METRO_CARIMBO_MAX'), qry, erro);
        SetDateTimeParam('METRO_P_MAX', GetJSONValue(jsonObj, 'METRO_P_MAX'), qry, erro);
        SetDateTimeParam('METRO_R_MAX', GetJSONValue(jsonObj, 'METRO_R_MAX'), qry, erro);
        SetDateTimeParam('TX_CARIMBO_MAX', GetJSONValue(jsonObj, 'TX_CARIMBO_MAX'), qry, erro);
        SetDateTimeParam('TX_P_MAX', GetJSONValue(jsonObj, 'TX_P_MAX'), qry, erro);
        SetDateTimeParam('TX_R_MAX', GetJSONValue(jsonObj, 'TX_R_MAX'), qry, erro);
        SetDateTimeParam('PMO_MODALIDADE_P', GetJSONValue(jsonObj, 'PMO_MODALIDADE_P'), qry, erro);
        SetStrParam('PMO_MIMO_MASSIVE', GetJSONValue(jsonObj, 'PMO_MIMO_MASSIVE'), qry, erro);
        SetStrParam('PMO_MEGA', GetJSONValue(jsonObj, 'PMO_MEGA'), qry, erro);
        SetStrParam('PMO_MIMO_MASSIVE', GetJSONValue(jsonObj, 'PMO_MIMO_MASSIVE'), qry, erro);
        SetStrParam('PMO_PEP_RF', GetJSONValue(jsonObj, 'PMO_PEP_RF'), qry, erro);
        SetDateTimeParam('PMO_BASELINE', GetJSONValue(jsonObj, 'PMO_BASELINE'), qry, erro);
        SetDateTimeParam('DEADLINE_QUALIFICACAO', GetJSONValue(jsonObj, 'DEADLINE_QUALIFICACAO'), qry, erro);
        SetDateTimeParam('DEADLINE_CONTRATACAO', GetJSONValue(jsonObj, 'DEADLINE_CONTRATACAO'), qry, erro);

        // String
        SetStrParam('RSO_RSA_MODALIDADE', GetJSONValue(jsonObj, 'RSO_RSA_MODALIDADE'), qry, erro);
        SetStrParam('PMO_POLIGONO_P', GetJSONValue(jsonObj, 'PMO_POLIGONO_P'), qry, erro);
        SetStrParam('RSO_RSA_FCU_GABINETE', GetJSONValue(jsonObj, 'RSO_RSA_FCU_GABINETE'), qry, erro);
        SetStrParam('SCIENCE_COMPLEMENTO', GetJSONValue(jsonObj, 'SCIENCE_COMPLEMENTO'), qry, erro);
        SetStrParam('INTEGRADOR_ALARME_PRE_EXIST', GetJSONValue(jsonObj, 'INTEGRADOR_ALARME_PRE_EXIST'), qry, erro);
        SetStrParam('INTEGRADOR_LOCAL_GABINETE_TECN', GetJSONValue(jsonObj, 'INTEGRADOR_LOCAL_GABINETE_TECN'), qry, erro);
        SetStrParam('ETAPAS_PEND_PLAN', GetJSONValue(jsonObj, 'ETAPAS_PEND_PLAN'), qry, erro);
        SetStrParam('ID_RD_CONSOLIDADO', GetJSONValue(jsonObj, 'ID_RD_CONSOLIDADO'), qry, erro);
        SetStrParam('ID_METRO_CONSOLIDADO', GetJSONValue(jsonObj, 'ID_METRO_CONSOLIDADO'), qry, erro);
        SetStrParam('METRO_STATUS_MAX', GetJSONValue(jsonObj, 'METRO_STATUS_MAX'), qry, erro);
    // Processa todos os campos String
        SetStrParam('UID_IDPMTS', GetJSONValue(jsonObj, 'UID_IDPMTS'), qry, erro);
        SetStrParam('UID_IDENG', GetJSONValue(jsonObj, 'UID_IDENG'), qry, erro);
        SetStrParam('UID_IDMASTER', GetJSONValue(jsonObj, 'UID_IDMASTER'), qry, erro);
        SetStrParam('UID_UFSIGLA', GetJSONValue(jsonObj, 'UID_UFSIGLA'), qry, erro);
        SetStrParam('UID_IDCPOMRF', GetJSONValue(jsonObj, 'UID_IDCPOMRF'), qry, erro);
        SetStrParam('UID_IDCPOMIE', GetJSONValue(jsonObj, 'UID_IDCPOMIE'), qry, erro);
        SetStrParam('PMO_SIGLA', GetJSONValue(jsonObj, 'PMO_SIGLA'), qry, erro);
        SetStrParam('PMO_UF', GetJSONValue(jsonObj, 'PMO_UF'), qry, erro);
        SetStrParam('PMO_REGIONAL', GetJSONValue(jsonObj, 'PMO_REGIONAL'), qry, erro);
        SetStrParam('PMO_DIVISAO', GetJSONValue(jsonObj, 'PMO_DIVISAO'), qry, erro);
        SetStrParam('PMO_GESTAO', GetJSONValue(jsonObj, 'PMO_GESTAO'), qry, erro);
        SetStrParam('IBGE_MUNICIPIO', GetJSONValue(jsonObj, 'IBGE_MUNICIPIO'), qry, erro);
        SetStrParam('IBGE_CAPITAL', GetJSONValue(jsonObj, 'IBGE_CAPITAL'), qry, erro);
        SetStrParam('FLG_RRU_REMOTA', GetJSONValue(jsonObj, 'FLG_RRU_REMOTA'), qry, erro);
        SetStrParam('MASTERSITE_COBERTURA', GetJSONValue(jsonObj, 'MASTERSITE_COBERTURA'), qry, erro);

        SetStrParam('ANALISE_CARIMBO', GetJSONValue(jsonObj, 'ANALISE_CARIMBO'), qry, erro);
        SetStrParam('EAP_AUTOMATICA', GetJSONValue(jsonObj, 'EAP_AUTOMATICA'), qry, erro);
        SetStrParam('REGIONAL_EAP_RESPONSAVEL', GetJSONValue(jsonObj, 'REGIONAL_EAP_RESPONSAVEL'), qry, erro);
        SetStrParam('REGIONAL_EAP_OFENSOR', GetJSONValue(jsonObj, 'REGIONAL_EAP_OFENSOR'), qry, erro);
        SetStrParam('REGIONAL_EAP_ACAO', GetJSONValue(jsonObj, 'REGIONAL_EAP_ACAO'), qry, erro);
        SetStrParam('PMO_REF', GetJSONValue(jsonObj, 'PMO_REF'), qry, erro);
        SetStrParam('PMO_DATA_INCLUSAO', GetJSONValue(jsonObj, 'PMO_DATA_INCLUSAO'), qry, erro);
        SetStrParam('MASTEROBRA_FREEZING', GetJSONValue(jsonObj, 'MASTEROBRA_FREEZING'), qry, erro);
        SetStrParam('MASTEROBRA_STATUS_ROLLOUT', GetJSONValue(jsonObj, 'MASTEROBRA_STATUS_ROLLOUT'), qry, erro);
        SetStrParam('PMO_CARIMBO_CENTRAL_QUARTER', GetJSONValue(jsonObj, 'PMO_CARIMBO_CENTRAL_QUARTER'), qry, erro);
        SetStrParam('PMO_ROLLOUT_OVBK', GetJSONValue(jsonObj, 'PMO_ROLLOUT_OVBK'), qry, erro);
        SetStrParam('ENG_PARAM_NOK', GetJSONValue(jsonObj, 'ENG_PARAM_NOK'), qry, erro);
        SetStrParam('VENDOR_EQUIPAMENTO', GetJSONValue(jsonObj, 'VENDOR_EQUIPAMENTO'), qry, erro);
        SetStrParam('VENDOR_VISTORIA', GetJSONValue(jsonObj, 'VENDOR_VISTORIA'), qry, erro);
        SetStrParam('VENDOR_PROJETO', GetJSONValue(jsonObj, 'VENDOR_PROJETO'), qry, erro);
        SetStrParam('VENDOR_INSTALADOR', GetJSONValue(jsonObj, 'VENDOR_INSTALADOR'), qry, erro);
        SetStrParam('VENDOR_INTEGRADOR', GetJSONValue(jsonObj, 'VENDOR_INTEGRADOR'), qry, erro);
        SetStrParam('PMO_TECN_EQUIP', GetJSONValue(jsonObj, 'PMO_TECN_EQUIP'), qry, erro);
        SetStrParam('PMO_FREQ_EQUIP', GetJSONValue(jsonObj, 'PMO_FREQ_EQUIP'), qry, erro);


    // Adicione estas linhas na seção de String
        SetStrParam('REGIONAL_TA_PRAZO', GetJSONValue(jsonObj, 'REGIONAL_TA_PRAZO'), qry, erro);
        SetStrParam('REGIONAL_ACEITE_EAP', GetJSONValue(jsonObj, 'REGIONAL_ACEITE_EAP'), qry, erro);
        SetStrParam('REGIONAL_ACEITE_DETALHE', GetJSONValue(jsonObj, 'REGIONAL_ACEITE_DETALHE'), qry, erro);
        SetStrParam('REGIONAL_ACEITE_RESPONSAVEL', GetJSONValue(jsonObj, 'REGIONAL_ACEITE_RESPONSAVEL'), qry, erro);
        SetStrParam('PMO_POLIGONO_P', GetJSONValue(jsonObj, 'PMO_POLIGONO_P'), qry, erro);
        SetStrParam('RSO_RSA_FCU_GABINETE', GetJSONValue(jsonObj, 'RSO_RSA_FCU_GABINETE'), qry, erro);
        SetStrParam('RSO_RSA_MODALIDADE', GetJSONValue(jsonObj, 'RSO_RSA_MODALIDADE'), qry, erro);
        SetStrParam('RSO_RSA_RESP_AQS', GetJSONValue(jsonObj, 'RSO_RSA_RESP_AQS'), qry, erro);
        SetStrParam('RSO_RSA_SCI', GetJSONValue(jsonObj, 'RSO_RSA_SCI'), qry, erro);
        SetStrParam('INSTALADOR_ITENS_A_RETIRAR', GetJSONValue(jsonObj, 'INSTALADOR_ITENS_A_RETIRAR'), qry, erro);
        SetStrParam('INSTALADOR_OFENSOR_DETALHE', GetJSONValue(jsonObj, 'INSTALADOR_OFENSOR_DETALHE'), qry, erro);
        SetStrParam('INSTALADOR_OFENSOR_MACRO', GetJSONValue(jsonObj, 'INSTALADOR_OFENSOR_MACRO'), qry, erro);
        SetStrParam('INSTALADOR_OFENSOR_MICRO', GetJSONValue(jsonObj, 'INSTALADOR_OFENSOR_MICRO'), qry, erro);
        SetStrParam('SIGLA_LOGICA_REFERENCIA', GetJSONValue(jsonObj, 'SIGLA_LOGICA_REFERENCIA'), qry, erro);
        SetStrParam('PROJETO_SINERGIA', GetJSONValue(jsonObj, 'PROJETO_SINERGIA'), qry, erro);
        SetStrParam('TA_ACEITACAO', GetJSONValue(jsonObj, 'TA_ACEITACAO'), qry, erro);
        SetStrParam('TA_ACEITE_PENDENCIAS', GetJSONValue(jsonObj, 'TA_ACEITE_PENDENCIAS'), qry, erro);
        SetStrParam('TA_ACEITE_RESPONSAVEL', GetJSONValue(jsonObj, 'TA_ACEITE_RESPONSAVEL'), qry, erro);
        SetStrParam('TA_AGING', GetJSONValue(jsonObj, 'TA_AGING'), qry, erro);
        SetStrParam('TA_STATUS', GetJSONValue(jsonObj, 'TA_STATUS'), qry, erro);
        SetStrParam('POSSUI_TA', GetJSONValue(jsonObj, 'POSSUI_TA'), qry, erro);
        SetStrParam('ENG_ESTRUTURA_TIPO', GetJSONValue(jsonObj, 'ENG_ESTRUTURA_TIPO'), qry, erro);
        SetStrParam('ESPACO_AERO', GetJSONValue(jsonObj, 'ESPACO_AERO'), qry, erro);
        SetStrParam('IBGE_BW_FREQUENCIA', GetJSONValue(jsonObj, 'IBGE_BW_FREQUENCIA'), qry, erro);
        SetStrParam('IBGE_TOP', GetJSONValue(jsonObj, 'IBGE_TOP'), qry, erro);
        SetStrParam('MASTERSITE_RANSHARING', GetJSONValue(jsonObj, 'MASTERSITE_RANSHARING'), qry, erro);
        SetStrParam('MASTERSITE_REMANEJAMENTO_LO', GetJSONValue(jsonObj, 'MASTERSITE_REMANEJAMENTO_LO'), qry, erro);
        SetStrParam('MASTERSITE_REMANEJAMENTO_CIT', GetJSONValue(jsonObj, 'MASTERSITE_REMANEJAMENTO_CIT'), qry, erro);
        SetStrParam('MASTERSITE_SAZONALIDADE', GetJSONValue(jsonObj, 'MASTERSITE_SAZONALIDADE'), qry, erro);
        SetStrParam('RSO_RSA_COORDENADOR', GetJSONValue(jsonObj, 'RSO_RSA_COORDENADOR'), qry, erro);
        SetStrParam('RSO_RSA_DETENTORA', GetJSONValue(jsonObj, 'RSO_RSA_DETENTORA'), qry, erro);
        SetStrParam('RSO_RSA_ID_DETENTORA', GetJSONValue(jsonObj, 'RSO_RSA_ID_DETENTORA'), qry, erro);
        SetStrParam('SCIENCE_COMPLEMENTO', GetJSONValue(jsonObj, 'SCIENCE_COMPLEMENTO'), qry, erro);
        SetStrParam('SCIENCE_DETENTORA', GetJSONValue(jsonObj, 'SCIENCE_DETENTORA'), qry, erro);
        SetStrParam('TECNOLOGIAS_FINAIS', GetJSONValue(jsonObj, 'TECNOLOGIAS_FINAIS'), qry, erro);
        SetStrParam('TIPO_ALARME', GetJSONValue(jsonObj, 'TIPO_ALARME'), qry, erro);
        SetStrParam('EAP_SIGLA_PORTADORA', GetJSONValue(jsonObj, 'EAP_SIGLA_PORTADORA'), qry, erro);
        SetStrParam('PROJETO_STATUS_ENG', GetJSONValue(jsonObj, 'PROJETO_STATUS_ENG'), qry, erro);
        SetStrParam('RSO_EAP_STATUS', GetJSONValue(jsonObj, 'RSO_EAP_STATUS'), qry, erro);
        SetStrParam('RSO_EAP_MACRO', GetJSONValue(jsonObj, 'RSO_EAP_MACRO'), qry, erro);
        SetStrParam('RSO_RSA_SCI_STATUS', GetJSONValue(jsonObj, 'RSO_RSA_SCI_STATUS'), qry, erro);
        SetStrParam('RSO_RSA_OFENSOR_AQS', GetJSONValue(jsonObj, 'RSO_RSA_OFENSOR_AQS'), qry, erro);
        SetStrParam('EAP_GABINETE', GetJSONValue(jsonObj, 'EAP_GABINETE'), qry, erro);
        SetStrParam('REGIONAL_EAP_INFRA', GetJSONValue(jsonObj, 'REGIONAL_EAP_INFRA'), qry, erro);
        SetStrParam('REGIONAL_EAP_INFRA_RESP', GetJSONValue(jsonObj, 'REGIONAL_EAP_INFRA_RESP'), qry, erro);
        SetStrParam('STATUS_MENSAL_TX', GetJSONValue(jsonObj, 'STATUS_MENSAL_TX'), qry, erro);
        // DateTime
        SetDateTimeParam('EQUIPAMENTO_ENTREGA_R', GetJSONValue(jsonObj, 'EQUIPAMENTO_ENTREGA_R'), qry, erro);
        SetDateTimeParam('INSTALADOR_RECEBIMENTO_R', GetJSONValue(jsonObj, 'INSTALADOR_RECEBIMENTO_R'), qry, erro);
        SetDateTimeParam('TX_OBRA_P', GetJSONValue(jsonObj, 'TX_OBRA_P'), qry, erro);
        SetDateTimeParam('INTEGRADOR_INTEGRACAO_R', GetJSONValue(jsonObj, 'INTEGRADOR_INTEGRACAO_R'), qry, erro);
        SetDateTimeParam('INTEGRADOR_ATIVACAO_R', GetJSONValue(jsonObj, 'INTEGRADOR_ATIVACAO_R'), qry, erro);
        SetDateTimeParam('DEADLINE_MODALIDADE', GetJSONValue(jsonObj, 'DEADLINE_MODALIDADE'), qry, erro);
        SetDateTimeParam('DEADLINE_POLIGONO', GetJSONValue(jsonObj, 'DEADLINE_POLIGONO'), qry, erro);
        SetDateTimeParam('RSO_RSA_AQUISICAO_P', GetJSONValue(jsonObj, 'RSO_RSA_AQUISICAO_P'), qry, erro);
        SetDateTimeParam('RSO_RSA_AQUISICAO_R', GetJSONValue(jsonObj, 'RSO_RSA_AQUISICAO_R'), qry, erro);
        SetDateTimeParam('RSO_RSA_LIB_SCI_P', GetJSONValue(jsonObj, 'RSO_RSA_LIB_SCI_P'), qry, erro);
        SetDateTimeParam('RSO_RSA_PROJ_EXEC_P', GetJSONValue(jsonObj, 'RSO_RSA_PROJ_EXEC_P'), qry, erro);
        SetDateTimeParam('RSO_RSA_PROJ_EXEC_R', GetJSONValue(jsonObj, 'RSO_RSA_PROJ_EXEC_R'), qry, erro);
        SetDateTimeParam('RD_CARIMBO_MAX', GetJSONValue(jsonObj, 'RD_CARIMBO_MAX'), qry, erro);
        SetDateTimeParam('RD_LIB_TRAFEGO_P_MAX', GetJSONValue(jsonObj, 'RD_LIB_TRAFEGO_P_MAX'), qry, erro);
        SetDateTimeParam('RD_LIB_TRAFEGO_R_MAX', GetJSONValue(jsonObj, 'RD_LIB_TRAFEGO_R_MAX'), qry, erro);
        SetDateTimeParam('METRO_CARIMBO_MAX', GetJSONValue(jsonObj, 'METRO_CARIMBO_MAX'), qry, erro);
        SetDateTimeParam('METRO_P_MAX', GetJSONValue(jsonObj, 'METRO_P_MAX'), qry, erro);
        SetDateTimeParam('METRO_R_MAX', GetJSONValue(jsonObj, 'METRO_R_MAX'), qry, erro);
        SetDateTimeParam('TX_CARIMBO_MAX', GetJSONValue(jsonObj, 'TX_CARIMBO_MAX'), qry, erro);
        SetDateTimeParam('TX_P_MAX', GetJSONValue(jsonObj, 'TX_P_MAX'), qry, erro);
        SetDateTimeParam('TX_R_MAX', GetJSONValue(jsonObj, 'TX_R_MAX'), qry, erro);
        SetDateTimeParam('UPDATE_EAP_CRITICA', GetJSONValue(jsonObj, 'UPDATE_EAP_CRITICA'), qry, erro);
        SetDateTimeParam('PMO_POLIGONO_P', GetJSONValue(jsonObj, 'PMO_POLIGONO_P'), qry, erro);
        SetDateTimeParam('REGIONAL_PRIO_REG', GetJSONValue(jsonObj, 'REGIONAL_PRIO_REG'), qry, erro);

    // String
        SetStrParam('REGIONAL_TA_PRAZO', GetJSONValue(jsonObj, 'REGIONAL_TA_PRAZO'), qry, erro);
        SetStrParam('REGIONAL_ACEITE_EAP', GetJSONValue(jsonObj, 'REGIONAL_ACEITE_EAP'), qry, erro);
        SetStrParam('REGIONAL_ACEITE_DETALHE', GetJSONValue(jsonObj, 'REGIONAL_ACEITE_DETALHE'), qry, erro);
        SetStrParam('REGIONAL_ACEITE_RESPONSAVEL', GetJSONValue(jsonObj, 'REGIONAL_ACEITE_RESPONSAVEL'), qry, erro);

        SetStrParam('RSO_RSA_FCU_GABINETE', GetJSONValue(jsonObj, 'RSO_RSA_FCU_GABINETE'), qry, erro);
        SetStrParam('RSO_RSA_MODALIDADE', GetJSONValue(jsonObj, 'RSO_RSA_MODALIDADE'), qry, erro);
        SetStrParam('RSO_RSA_RESP_AQS', GetJSONValue(jsonObj, 'RSO_RSA_RESP_AQS'), qry, erro);
        SetStrParam('RSO_RSA_SCI', GetJSONValue(jsonObj, 'RSO_RSA_SCI'), qry, erro);
        SetStrParam('INSTALADOR_ITENS_A_RETIRAR', GetJSONValue(jsonObj, 'INSTALADOR_ITENS_A_RETIRAR'), qry, erro);
        SetStrParam('INSTALADOR_OFENSOR_DETALHE', GetJSONValue(jsonObj, 'INSTALADOR_OFENSOR_DETALHE'), qry, erro);
        SetStrParam('INSTALADOR_OFENSOR_MACRO', GetJSONValue(jsonObj, 'INSTALADOR_OFENSOR_MACRO'), qry, erro);
        SetStrParam('INSTALADOR_OFENSOR_MICRO', GetJSONValue(jsonObj, 'INSTALADOR_OFENSOR_MICRO'), qry, erro);
        SetStrParam('SIGLA_LOGICA_REFERENCIA', GetJSONValue(jsonObj, 'SIGLA_LOGICA_REFERENCIA'), qry, erro);
        SetStrParam('PROJETO_SINERGIA', GetJSONValue(jsonObj, 'PROJETO_SINERGIA'), qry, erro);
        SetStrParam('TA_ACEITACAO', GetJSONValue(jsonObj, 'TA_ACEITACAO'), qry, erro);
        SetStrParam('TA_ACEITE_PENDENCIAS', GetJSONValue(jsonObj, 'TA_ACEITE_PENDENCIAS'), qry, erro);
        SetStrParam('TA_ACEITE_RESPONSAVEL', GetJSONValue(jsonObj, 'TA_ACEITE_RESPONSAVEL'), qry, erro);
        SetStrParam('TA_AGING', GetJSONValue(jsonObj, 'TA_AGING'), qry, erro);
        SetStrParam('TA_STATUS', GetJSONValue(jsonObj, 'TA_STATUS'), qry, erro);
        SetStrParam('POSSUI_TA', GetJSONValue(jsonObj, 'POSSUI_TA'), qry, erro);
        SetStrParam('ENG_ESTRUTURA_TIPO', GetJSONValue(jsonObj, 'ENG_ESTRUTURA_TIPO'), qry, erro);
        SetStrParam('ESPACO_AERO', GetJSONValue(jsonObj, 'ESPACO_AERO'), qry, erro);
        SetStrParam('IBGE_BW_FREQUENCIA', GetJSONValue(jsonObj, 'IBGE_BW_FREQUENCIA'), qry, erro);
        SetStrParam('IBGE_TOP', GetJSONValue(jsonObj, 'IBGE_TOP'), qry, erro);
        SetStrParam('MASTERSITE_RANSHARING', GetJSONValue(jsonObj, 'MASTERSITE_RANSHARING'), qry, erro);
        SetStrParam('MASTERSITE_REMANEJAMENTO_LO', GetJSONValue(jsonObj, 'MASTERSITE_REMANEJAMENTO_LO'), qry, erro);
        SetStrParam('MASTERSITE_REMANEJAMENTO_CIT', GetJSONValue(jsonObj, 'MASTERSITE_REMANEJAMENTO_CIT'), qry, erro);
        SetStrParam('MASTERSITE_SAZONALIDADE', GetJSONValue(jsonObj, 'MASTERSITE_SAZONALIDADE'), qry, erro);
        SetStrParam('RSO_RSA_COORDENADOR', GetJSONValue(jsonObj, 'RSO_RSA_COORDENADOR'), qry, erro);
        SetStrParam('RSO_RSA_DETENTORA', GetJSONValue(jsonObj, 'RSO_RSA_DETENTORA'), qry, erro);
        SetStrParam('RSO_RSA_ID_DETENTORA', GetJSONValue(jsonObj, 'RSO_RSA_ID_DETENTORA'), qry, erro);
        SetStrParam('SCIENCE_COMPLEMENTO', GetJSONValue(jsonObj, 'SCIENCE_COMPLEMENTO'), qry, erro);
        SetStrParam('SCIENCE_DETENTORA', GetJSONValue(jsonObj, 'SCIENCE_DETENTORA'), qry, erro);
        SetStrParam('TECNOLOGIAS_FINAIS', GetJSONValue(jsonObj, 'TECNOLOGIAS_FINAIS'), qry, erro);
        SetStrParam('TIPO_ALARME', GetJSONValue(jsonObj, 'TIPO_ALARME'), qry, erro);
        SetStrParam('EAP_SIGLA_PORTADORA', GetJSONValue(jsonObj, 'EAP_SIGLA_PORTADORA'), qry, erro);
        SetStrParam('PROJETO_STATUS_ENG', GetJSONValue(jsonObj, 'PROJETO_STATUS_ENG'), qry, erro);
        SetStrParam('RSO_EAP_STATUS', GetJSONValue(jsonObj, 'RSO_EAP_STATUS'), qry, erro);
        SetStrParam('RSO_EAP_MACRO', GetJSONValue(jsonObj, 'RSO_EAP_MACRO'), qry, erro);
        SetStrParam('RSO_RSA_SCI_STATUS', GetJSONValue(jsonObj, 'RSO_RSA_SCI_STATUS'), qry, erro);
        SetStrParam('RSO_RSA_OFENSOR_AQS', GetJSONValue(jsonObj, 'RSO_RSA_OFENSOR_AQS'), qry, erro);
        SetStrParam('EAP_GABINETE', GetJSONValue(jsonObj, 'EAP_GABINETE'), qry, erro);
        SetStrParam('REGIONAL_EAP_INFRA', GetJSONValue(jsonObj, 'REGIONAL_EAP_INFRA'), qry, erro);
        SetStrParam('REGIONAL_EAP_INFRA_RESP', GetJSONValue(jsonObj, 'REGIONAL_EAP_INFRA_RESP'), qry, erro);
        SetStrParam('STATUS_MENSAL_TX', GetJSONValue(jsonObj, 'STATUS_MENSAL_TX'), qry, erro);
        SetStrParam('REGIONAL_PRE_ACEITE_EAP', GetJSONValue(jsonObj, 'REGIONAL_PRE_ACEITE_EAP'), qry, erro);
        SetStrParam('REGIONAL_PRE_ACEITE_RESPONSAVEL', GetJSONValue(jsonObj, 'REGIONAL_PRE_ACEITE_RESPONSAVEL'), qry, erro);
        SetStrParam('STATUS_ESTEIRA_PO', GetJSONValue(jsonObj, 'STATUS_ESTEIRA_PO'), qry, erro);
        SetStrParam('INTEGRADOR_ALARME_PRE_EXIST', GetJSONValue(jsonObj, 'INTEGRADOR_ALARME_PRE_EXIST'), qry, erro);
        SetStrParam('INTEGRADOR_LOCAL_GABINETE_TECN', GetJSONValue(jsonObj, 'INTEGRADOR_LOCAL_GABINETE_TECN'), qry, erro);
        SetStrParam('VALID_RSO_RSA_PROJ_EXEC', GetJSONValue(jsonObj, 'VALID_RSO_RSA_PROJ_EXEC'), qry, erro);
        SetStrParam('VALID_RSO_OBRA_FIM', GetJSONValue(jsonObj, 'VALID_RSO_OBRA_FIM'), qry, erro);
        SetStrParam('ID_RD_CONSOLIDADO', GetJSONValue(jsonObj, 'ID_RD_CONSOLIDADO'), qry, erro);
        SetStrParam('ID_METRO_CONSOLIDADO', GetJSONValue(jsonObj, 'ID_METRO_CONSOLIDADO'), qry, erro);
        SetStrParam('METRO_STATUS_MAX', GetJSONValue(jsonObj, 'METRO_STATUS_MAX'), qry, erro);
        SetStrParam('ETAPAS_PEND_PLAN', GetJSONValue(jsonObj, 'ETAPAS_PEND_PLAN'), qry, erro);
        SetStrParam('REGIONAL_OFENSOR_MACRO', GetJSONValue(jsonObj, 'REGIONAL_OFENSOR_MACRO'), qry, erro);
        SetStrParam('REGIONAL_OFENSOR_MICRO', GetJSONValue(jsonObj, 'REGIONAL_OFENSOR_MICRO'), qry, erro);
        SetStrParam('PMO_MIMO_MASSIVE', GetJSONValue(jsonObj, 'PMO_MIMO_MASSIVE'), qry, erro);
        SetStrParam('PMO_NOVO_REF_REPORT', GetJSONValue(jsonObj, 'PMO_NOVO_REF_REPORT'), qry, erro);
        SetStrParam('REGIONAL_PRE_ACEITE_EAP', GetJSONValue(jsonObj, 'REGIONAL_PRE_ACEITE_EAP'), qry, erro);
        SetStrParam('REGIONAL_PRE_ACEITE_RESPONSAVEL', GetJSONValue(jsonObj, 'REGIONAL_PRE_ACEITE_RESPONSAVEL'), qry, erro);
        SetStrParam('RSO_RSA_MODALIDADE', GetJSONValue(jsonObj, 'RSO_RSA_MODALIDADE'), qry, erro);

        SetStrParam('RSO_RSA_FCU_GABINETE', GetJSONValue(jsonObj, 'RSO_RSA_FCU_GABINETE'), qry, erro);
        SetStrParam('SCIENCE_COMPLEMENTO', GetJSONValue(jsonObj, 'SCIENCE_COMPLEMENTO'), qry, erro);
        SetStrParam('INTEGRADOR_ALARME_PRE_EXIST', GetJSONValue(jsonObj, 'INTEGRADOR_ALARME_PRE_EXIST'), qry, erro);
        SetStrParam('INTEGRADOR_LOCAL_GABINETE_TECN', GetJSONValue(jsonObj, 'INTEGRADOR_LOCAL_GABINETE_TECN'), qry, erro);
        SetStrParam('ETAPAS_PEND_PLAN', GetJSONValue(jsonObj, 'ETAPAS_PEND_PLAN'), qry, erro);
        SetStrParam('ID_RD_CONSOLIDADO', GetJSONValue(jsonObj, 'ID_RD_CONSOLIDADO'), qry, erro);
        SetStrParam('ID_METRO_CONSOLIDADO', GetJSONValue(jsonObj, 'ID_METRO_CONSOLIDADO'), qry, erro);
        SetStrParam('METRO_STATUS_MAX', GetJSONValue(jsonObj, 'METRO_STATUS_MAX'), qry, erro);
        SetStrParam('PMO_TIPO_INTERV', GetJSONValue(jsonObj, 'PMO_TIPO_INTERV'), qry, erro);
        SetStrParam('PMO_TIPO_INTERV_2', GetJSONValue(jsonObj, 'PMO_TIPO_INTERV_2'), qry, erro);
        SetStrParam('PMO_TIPO_OBRA', GetJSONValue(jsonObj, 'PMO_TIPO_OBRA'), qry, erro);
        SetStrParam('PMO_TIPO_PMTS', GetJSONValue(jsonObj, 'PMO_TIPO_PMTS'), qry, erro);
        SetStrParam('PMO_CATEGORIA', GetJSONValue(jsonObj, 'PMO_CATEGORIA'), qry, erro);
        SetStrParam('ENG_FORNECEDOR_INFRA', GetJSONValue(jsonObj, 'ENG_FORNECEDOR_INFRA'), qry, erro);
        SetStrParam('ENG_GABINETE_NOVO', GetJSONValue(jsonObj, 'ENG_GABINETE_NOVO'), qry, erro);
        SetStrParam('ENG_GRADIL_GABINETE', GetJSONValue(jsonObj, 'ENG_GRADIL_GABINETE'), qry, erro);
        SetStrParam('ENG_DETENTORA_GABINETE', GetJSONValue(jsonObj, 'ENG_DETENTORA_GABINETE'), qry, erro);
        SetStrParam('ENG_TIPO_GABINETE', GetJSONValue(jsonObj, 'ENG_TIPO_GABINETE'), qry, erro);
        SetStrParam('ENG_FABRICANTE_GABINETE', GetJSONValue(jsonObj, 'ENG_FABRICANTE_GABINETE'), qry, erro);
        SetStrParam('TIPO_GABINETE_SHARING', GetJSONValue(jsonObj, 'TIPO_GABINETE_SHARING'), qry, erro);
        SetStrParam('EQUIPAMENTO_STATUS_PO', GetJSONValue(jsonObj, 'EQUIPAMENTO_STATUS_PO'), qry, erro);
        SetStrParam('VISTORIA_STATUS_PO', GetJSONValue(jsonObj, 'VISTORIA_STATUS_PO'), qry, erro);
        SetStrParam('PROJETO_STATUS_PO', GetJSONValue(jsonObj, 'PROJETO_STATUS_PO'), qry, erro);
        SetStrParam('INSTALADOR_STATUS_PO', GetJSONValue(jsonObj, 'INSTALADOR_STATUS_PO'), qry, erro);
        SetStrParam('INTEGRADOR_STATUS_PO', GetJSONValue(jsonObj, 'INTEGRADOR_STATUS_PO'), qry, erro);
        SetStrParam('MASTEROBRA_MEGA_PROJETO', GetJSONValue(jsonObj, 'MASTEROBRA_MEGA_PROJETO'), qry, erro);
        SetStrParam('MASTEROBRA_OBJ_ENG', GetJSONValue(jsonObj, 'MASTEROBRA_OBJ_ENG'), qry, erro);
        SetStrParam('ENG_OBJ_MACRO', GetJSONValue(jsonObj, 'ENG_OBJ_MACRO'), qry, erro);
        SetStrParam('PMO_MEGA', GetJSONValue(jsonObj, 'PMO_MEGA'), qry, erro);
        SetStrParam('PMO_PEP_RF', GetJSONValue(jsonObj, 'PMO_PEP_RF'), qry, erro);
        SetStrParam('PMO_PROJETO', GetJSONValue(jsonObj, 'PMO_PROJETO'), qry, erro);
        SetStrParam('PMO_REFERENCIA_REPORT', GetJSONValue(jsonObj, 'PMO_REFERENCIA_REPORT'), qry, erro);
        SetStrParam('PMO_NOVO_REF_REPORT', GetJSONValue(jsonObj, 'PMO_NOVO_REF_REPORT'), qry, erro);
        SetStrParam('PMO_RISCO_AUT', GetJSONValue(jsonObj, 'PMO_RISCO_AUT'), qry, erro);
        SetStrParam('PMO_SUB_PROJETO', GetJSONValue(jsonObj, 'PMO_SUB_PROJETO'), qry, erro);
        SetStrParam('TX_FLAG_ATIVACAO', GetJSONValue(jsonObj, 'TX_FLAG_ATIVACAO'), qry, erro);
        SetStrParam('RSO_RSA_MODALIDADE', GetJSONValue(jsonObj, 'RSO_RSA_MODALIDADE'), qry, erro);
        SetStrParam('RSO_RSA_RESP_AQS', GetJSONValue(jsonObj, 'RSO_RSA_RESP_AQS'), qry, erro);
        SetStrParam('RSO_RSA_SCI', GetJSONValue(jsonObj, 'RSO_RSA_SCI'), qry, erro);
        SetStrParam('SIGLA_LOGICA_REFERENCIA', GetJSONValue(jsonObj, 'SIGLA_LOGICA_REFERENCIA'), qry, erro);
        SetStrParam('PROJETO_SINERGIA', GetJSONValue(jsonObj, 'PROJETO_SINERGIA'), qry, erro);
        SetStrParam('POSSUI_TA', GetJSONValue(jsonObj, 'POSSUI_TA'), qry, erro);
        SetStrParam('ENG_ESTRUTURA_TIPO', GetJSONValue(jsonObj, 'ENG_ESTRUTURA_TIPO'), qry, erro);
        SetStrParam('ESPACO_AERO', GetJSONValue(jsonObj, 'ESPACO_AERO'), qry, erro);
        SetStrParam('IBGE_BW_FREQUENCIA', GetJSONValue(jsonObj, 'IBGE_BW_FREQUENCIA'), qry, erro);
        SetStrParam('IBGE_TOP', GetJSONValue(jsonObj, 'IBGE_TOP'), qry, erro);
        SetStrParam('MASTERSITE_REMANEJAMENTO_LO', GetJSONValue(jsonObj, 'MASTERSITE_REMANEJAMENTO_LO'), qry, erro);
        SetStrParam('MASTERSITE_REMANEJAMENTO_CIT', GetJSONValue(jsonObj, 'MASTERSITE_REMANEJAMENTO_CIT'), qry, erro);
        SetStrParam('MASTERSITE_SAZONALIDADE', GetJSONValue(jsonObj, 'MASTERSITE_SAZONALIDADE'), qry, erro);
        SetStrParam('RSO_RSA_COORDENADOR', GetJSONValue(jsonObj, 'RSO_RSA_COORDENADOR'), qry, erro);
        SetStrParam('RSO_RSA_DETENTORA', GetJSONValue(jsonObj, 'RSO_RSA_DETENTORA'), qry, erro);
        SetStrParam('RSO_RSA_ID_DETENTORA', GetJSONValue(jsonObj, 'RSO_RSA_ID_DETENTORA'), qry, erro);
        SetStrParam('SCIENCE_BAIRRO', GetJSONValue(jsonObj, 'SCIENCE_BAIRRO'), qry, erro);
        SetStrParam('SCIENCE_CEP', GetJSONValue(jsonObj, 'SCIENCE_CEP'), qry, erro);
        SetStrParam('SCIENCE_ENDERECO', GetJSONValue(jsonObj, 'SCIENCE_ENDERECO'), qry, erro);
        SetStrParam('SCIENCE_ID_DETENTORA', GetJSONValue(jsonObj, 'SCIENCE_ID_DETENTORA'), qry, erro);
        SetStrParam('SCIENCE_ID_FINANCEIRO', GetJSONValue(jsonObj, 'SCIENCE_ID_FINANCEIRO'), qry, erro);
        SetStrParam('SCIENCE_NOME', GetJSONValue(jsonObj, 'SCIENCE_NOME'), qry, erro);
        SetStrParam('TECNOLOGIAS_FINAIS', GetJSONValue(jsonObj, 'TECNOLOGIAS_FINAIS'), qry, erro);
        SetStrParam('TIPO_ALARME', GetJSONValue(jsonObj, 'TIPO_ALARME'), qry, erro);
        SetStrParam('EAP_SIGLA_PORTADORA', GetJSONValue(jsonObj, 'EAP_SIGLA_PORTADORA'), qry, erro);
        SetStrParam('PROJETO_STATUS_ENG', GetJSONValue(jsonObj, 'PROJETO_STATUS_ENG'), qry, erro);
        SetStrParam('RSO_EAP_STATUS', GetJSONValue(jsonObj, 'RSO_EAP_STATUS'), qry, erro);
        SetStrParam('RSO_EAP_MACRO', GetJSONValue(jsonObj, 'RSO_EAP_MACRO'), qry, erro);
        SetStrParam('RSO_RSA_SCI_STATUS', GetJSONValue(jsonObj, 'RSO_RSA_SCI_STATUS'), qry, erro);
        SetStrParam('RSO_RSA_OFENSOR_AQS', GetJSONValue(jsonObj, 'RSO_RSA_OFENSOR_AQS'), qry, erro);
        SetStrParam('EAP_GABINETE', GetJSONValue(jsonObj, 'EAP_GABINETE'), qry, erro);
        SetStrParam('REGIONAL_EAP_INFRA', GetJSONValue(jsonObj, 'REGIONAL_EAP_INFRA'), qry, erro);
        SetStrParam('REGIONAL_EAP_INFRA_RESP', GetJSONValue(jsonObj, 'REGIONAL_EAP_INFRA_RESP'), qry, erro);
        SetStrParam('STATUS_MENSAL_TX', GetJSONValue(jsonObj, 'STATUS_MENSAL_TX'), qry, erro);
        SetStrParam('STATUS_ESTEIRA_PO', GetJSONValue(jsonObj, 'STATUS_ESTEIRA_PO'), qry, erro);
        SetStrParam('VALID_RSO_POLIGONO', GetJSONValue(jsonObj, 'VALID_RSO_POLIGONO'), qry, erro);
        SetStrParam('VALID_RSO_DISPARO', GetJSONValue(jsonObj, 'VALID_RSO_DISPARO'), qry, erro);
        SetStrParam('VALID_RSO_DEF_MODALIDADE', GetJSONValue(jsonObj, 'VALID_RSO_DEF_MODALIDADE'), qry, erro);
        SetStrParam('VALID_RSO_SAR', GetJSONValue(jsonObj, 'VALID_RSO_SAR'), qry, erro);
        SetStrParam('VALID_RSO_QUALIFICACAO', GetJSONValue(jsonObj, 'VALID_RSO_QUALIFICACAO'), qry, erro);
        SetStrParam('VALID_RSO_CONTRATACAO', GetJSONValue(jsonObj, 'VALID_RSO_CONTRATACAO'), qry, erro);
        SetStrParam('VALID_SITE_NOVO', GetJSONValue(jsonObj, 'VALID_SITE_NOVO'), qry, erro);
        SetStrParam('VALID_AQUISICAO', GetJSONValue(jsonObj, 'VALID_AQUISICAO'), qry, erro);
        SetStrParam('VALID_ABERT_SCI', GetJSONValue(jsonObj, 'VALID_ABERT_SCI'), qry, erro);
        SetStrParam('VALID_LIB_SCI', GetJSONValue(jsonObj, 'VALID_LIB_SCI'), qry, erro);
        SetStrParam('VALID_VIST_PE', GetJSONValue(jsonObj, 'VALID_VIST_PE'), qry, erro);
        SetStrParam('VALID_RSO_RSA_PROJ_EXEC', GetJSONValue(jsonObj, 'VALID_RSO_RSA_PROJ_EXEC'), qry, erro);
        SetStrParam('VALID_RSO_VALID_RELATORIO_CRITICO', GetJSONValue(jsonObj, 'VALID_RSO_VALID_RELATORIO_CRITICO'), qry, erro);
        SetStrParam('VALID_RSO_VALID_ON_HOLD', GetJSONValue(jsonObj, 'VALID_RSO_VALID_ON_HOLD'), qry, erro);
        SetStrParam('VALID_WR_ENV', GetJSONValue(jsonObj, 'VALID_WR_ENV'), qry, erro);
        SetStrParam('VALID_WR_APROV', GetJSONValue(jsonObj, 'VALID_WR_APROV'), qry, erro);
        SetStrParam('PROJETO_WR_STEP_APROV', GetJSONValue(jsonObj, 'PROJETO_WR_STEP_APROV'), qry, erro);
        SetStrParam('VALID_PRECISA_PARAM', GetJSONValue(jsonObj, 'VALID_PRECISA_PARAM'), qry, erro);
        SetStrParam('VALID_ENG_PARAM', GetJSONValue(jsonObj, 'VALID_ENG_PARAM'), qry, erro);
        SetStrParam('VALID_SIGLA_PORTADORA', GetJSONValue(jsonObj, 'VALID_SIGLA_PORTADORA'), qry, erro);
        SetStrParam('VALID_PPI', GetJSONValue(jsonObj, 'VALID_PPI'), qry, erro);
        SetStrParam('VALID_LICENCIAMENTO', GetJSONValue(jsonObj, 'VALID_LICENCIAMENTO'), qry, erro);
        SetStrParam('VALID_T2_EQUIPAMENTO', GetJSONValue(jsonObj, 'VALID_T2_EQUIPAMENTO'), qry, erro);
        SetStrParam('VALID_T4_EQUIPAMENTO', GetJSONValue(jsonObj, 'VALID_T4_EQUIPAMENTO'), qry, erro);
        SetStrParam('VALID_PO_EQUIPAMENTO', GetJSONValue(jsonObj, 'VALID_PO_EQUIPAMENTO'), qry, erro);
        SetStrParam('VALID_T2_VISTORIA', GetJSONValue(jsonObj, 'VALID_T2_VISTORIA'), qry, erro);
        SetStrParam('VALID_T4_VISTORIA', GetJSONValue(jsonObj, 'VALID_T4_VISTORIA'), qry, erro);
        SetStrParam('VALID_PO_VISTORIA', GetJSONValue(jsonObj, 'VALID_PO_VISTORIA'), qry, erro);
        SetStrParam('VALID_T2_PROJETO', GetJSONValue(jsonObj, 'VALID_T2_PROJETO'), qry, erro);
        SetStrParam('VALID_T4_PROJETO', GetJSONValue(jsonObj, 'VALID_T4_PROJETO'), qry, erro);
        SetStrParam('VALID_PO_PROJETO', GetJSONValue(jsonObj, 'VALID_PO_PROJETO'), qry, erro);
        SetStrParam('VALID_T2_INSTALADOR', GetJSONValue(jsonObj, 'VALID_T2_INSTALADOR'), qry, erro);
        SetStrParam('VALID_T4_INSTALADOR', GetJSONValue(jsonObj, 'VALID_T4_INSTALADOR'), qry, erro);
        SetStrParam('VALID_PO_INSTALADOR', GetJSONValue(jsonObj, 'VALID_PO_INSTALADOR'), qry, erro);
        SetStrParam('VALID_T2_INTEGRADOR', GetJSONValue(jsonObj, 'VALID_T2_INTEGRADOR'), qry, erro);
        SetStrParam('VALID_T4_INTEGRADOR', GetJSONValue(jsonObj, 'VALID_T4_INTEGRADOR'), qry, erro);
        SetStrParam('VALID_PO_INTEGRADOR', GetJSONValue(jsonObj, 'VALID_PO_INTEGRADOR'), qry, erro);
        SetStrParam('VALID_T2', GetJSONValue(jsonObj, 'VALID_T2'), qry, erro);
        SetStrParam('VALID_T4', GetJSONValue(jsonObj, 'VALID_T4'), qry, erro);
        SetStrParam('VALID_PO', GetJSONValue(jsonObj, 'VALID_PO'), qry, erro);
        SetStrParam('VALID_OBRA_INICIO', GetJSONValue(jsonObj, 'VALID_OBRA_INICIO'), qry, erro);
        SetStrParam('VALID_RSO_OBRA_FIM', GetJSONValue(jsonObj, 'VALID_RSO_OBRA_FIM'), qry, erro);
        SetStrParam('VALID_OBRA_FIM', GetJSONValue(jsonObj, 'VALID_OBRA_FIM'), qry, erro);
        SetStrParam('VALID_GABINETE_SHARING', GetJSONValue(jsonObj, 'VALID_GABINETE_SHARING'), qry, erro);
        SetStrParam('VALID_ENTREGA_GABINETE', GetJSONValue(jsonObj, 'VALID_ENTREGA_GABINETE'), qry, erro);
        SetStrParam('VALID_CADASTRO_GABINETES_SHARING', GetJSONValue(jsonObj, 'VALID_CADASTRO_GABINETES_SHARING'), qry, erro);
        SetStrParam('VALID_LIB_SITE', GetJSONValue(jsonObj, 'VALID_LIB_SITE'), qry, erro);
        SetStrParam('VALID_ENTREGA', GetJSONValue(jsonObj, 'VALID_ENTREGA'), qry, erro);
        SetStrParam('VALID_RECEBIMENTO', GetJSONValue(jsonObj, 'VALID_RECEBIMENTO'), qry, erro);
        SetStrParam('VALID_INSTALACAO', GetJSONValue(jsonObj, 'VALID_INSTALACAO'), qry, erro);
        SetStrParam('VALID_TX', GetJSONValue(jsonObj, 'VALID_TX'), qry, erro);
        SetStrParam('VALID_INTEGRACAO', GetJSONValue(jsonObj, 'VALID_INTEGRACAO'), qry, erro);
        SetStrParam('VALID_FLAG_ATIVACAO', GetJSONValue(jsonObj, 'VALID_FLAG_ATIVACAO'), qry, erro);
        SetStrParam('VALID_ATIVACAO', GetJSONValue(jsonObj, 'VALID_ATIVACAO'), qry, erro);
        SetStrParam('VALID_PRE_ACEITE', GetJSONValue(jsonObj, 'VALID_PRE_ACEITE'), qry, erro);
        SetStrParam('VALID_CADASTRO', GetJSONValue(jsonObj, 'VALID_CADASTRO'), qry, erro);
        SetStrParam('VALID_FLAG_SCIENCE', GetJSONValue(jsonObj, 'VALID_FLAG_SCIENCE'), qry, erro);
        SetStrParam('VALID_ACEITE', GetJSONValue(jsonObj, 'VALID_ACEITE'), qry, erro);
        SetStrParam('VALID_CONCLUSAO_PMTS', GetJSONValue(jsonObj, 'VALID_CONCLUSAO_PMTS'), qry, erro);
        SetStrParam('VALID_STATUS_ROLLOUT', GetJSONValue(jsonObj, 'VALID_STATUS_ROLLOUT'), qry, erro);
        SetStrParam('VALID_TA_ACEITACAO', GetJSONValue(jsonObj, 'VALID_TA_ACEITACAO'), qry, erro);
        SetStrParam('VALID_OBRA_BW', GetJSONValue(jsonObj, 'VALID_OBRA_BW'), qry, erro);
        SetStrParam('PMO_DIVULGAR', GetJSONValue(jsonObj, 'PMO_DIVULGAR'), qry, erro);
        SetStrParam('SOLUCAO_TX_FINAL', GetJSONValue(jsonObj, 'SOLUCAO_TX_FINAL'), qry, erro);
        SetStrParam('TX_STATUS_ACIONAMENTO', GetJSONValue(jsonObj, 'TX_STATUS_ACIONAMENTO'), qry, erro);
        SetStrParam('VALID_TX_MAX', GetJSONValue(jsonObj, 'VALID_TX_MAX'), qry, erro);
        SetStrParam('FAROL_ESTEIRA', GetJSONValue(jsonObj, 'FAROL_ESTEIRA'), qry, erro);
        SetStrParam('ETAPAS_PLAN', GetJSONValue(jsonObj, 'ETAPAS_PLAN'), qry, erro);
        SetStrParam('ETAPAS_CONCL', GetJSONValue(jsonObj, 'ETAPAS_CONCL'), qry, erro);
        SetStrParam('FAROL_ESTEIRA_HOJE', GetJSONValue(jsonObj, 'FAROL_ESTEIRA_HOJE'), qry, erro);
        SetStrParam('ETAPAS_HOJE', GetJSONValue(jsonObj, 'ETAPAS_HOJE'), qry, erro);
        SetStrParam('ETAPAS_INCONSIST', GetJSONValue(jsonObj, 'ETAPAS_INCONSIST'), qry, erro);
        SetStrParam('FAROL_ETAPA', GetJSONValue(jsonObj, 'FAROL_ETAPA'), qry, erro);
        SetStrParam('SIGLA_HOTEL_DE_BTS', GetJSONValue(jsonObj, 'SIGLA_HOTEL_DE_BTS'), qry, erro);
        SetStrParam('REGIONAL_RISCO', GetJSONValue(jsonObj, 'REGIONAL_RISCO'), qry, erro);
        SetStrParam('REGIONAL_EAP_CRITICA', GetJSONValue(jsonObj, 'REGIONAL_EAP_CRITICA'), qry, erro);

        SetStrParam('ENG_PARAM_OK', GetJSONValue(jsonObj, 'ENG_PARAM_OK'), qry, erro);
        SetStrParam('MASTEROBRA_PRIO_ENG', GetJSONValue(jsonObj, 'MASTEROBRA_PRIO_ENG'), qry, erro);
        SetStrParam('MASTEROBRA_AVALIACAO_DE_TX', GetJSONValue(jsonObj, 'MASTEROBRA_AVALIACAO_DE_TX'), qry, erro);
        SetStrParam('ENG_STATUS_DISPARO_INFRA', GetJSONValue(jsonObj, 'ENG_STATUS_DISPARO_INFRA'), qry, erro);
        SetStrParam('ENG_STEP_GABINETE', GetJSONValue(jsonObj, 'ENG_STEP_GABINETE'), qry, erro);
    // Processa campos Text/Blob

        SetTextParam('MASTEROBRA_OBS', GetJSONValue(jsonObj, 'MASTEROBRA_OBS'), qry, erro);
        SetTextParam('MASTERSITE_OBS', GetJSONValue(jsonObj, 'MASTERSITE_OBS'), qry, erro);
        SetTextParam('MASTEROBRA_OBSERVACAO_TX', GetJSONValue(jsonObj, 'MASTEROBRA_OBSERVACAO_TX'), qry, erro);
        SetTextParam('REGIONAL_OFENSOR_DETALHE', GetJSONValue(jsonObj, 'REGIONAL_OFENSOR_DETALHE'), qry, erro);
        SetTextParam('PROJETO_ENGENHARIA_DEF', GetJSONValue(jsonObj, 'PROJETO_ENGENHARIA_DEF'), qry, erro);
        SetTextParam('DEADLINE_ALERTA', GetJSONValue(jsonObj, 'DEADLINE_ALERTA'), qry, erro);
        SetTextParam('DEADLINE_ALERTA_HOJE', GetJSONValue(jsonObj, 'DEADLINE_ALERTA_HOJE'), qry, erro);
        SetStrParam('REGIONAL_ACEITE_EAP', GetJSONValue(jsonObj, 'REGIONAL_ACEITE_EAP'), qry, erro);
        SetStrParam('REGIONAL_ACEITE_DETALHE', GetJSONValue(jsonObj, 'REGIONAL_ACEITE_DETALHE'), qry, erro);

        SetStrParam('REGIONAL_ACEITE_RESPONSAVEL', GetJSONValue(jsonObj, 'REGIONAL_ACEITE_RESPONSAVEL'), qry, erro);
        SetStrParam('REGIONAL_PRE_ACEITE_EAP', GetJSONValue(jsonObj, 'REGIONAL_PRE_ACEITE_EAP'), qry, erro);
        SetStrParam('REGIONAL_PRE_ACEITE_RESPONSAVEL', GetJSONValue(jsonObj, 'REGIONAL_PRE_ACEITE_RESPONSAVEL'), qry, erro);

        if erro <> '' then
          Continue;
        qry.Prepare;
        qry.ExecSQL;
        Inc(processados);

       except
        on E: EJSONException do
        begin
          erro := Format('Erro de JSON no item %d: %s', [i, E.Message]);

          // Exibir ou registrar os dados que falharam
          Writeln(Format('Dados com erro no item %d', [i]));
          Writeln(erro);

          Continue;
        end;
        on E: Exception do
        begin
          erro := Format('Erro inesperado no item %d: %s', [i, E.Message]);

          // Exibir ou registrar os dados que falharam
          Writeln(Format('Dados com erro no item %d', [i]));
          Writeln(erro);

          Continue;
        end;
      end;
    end;
    FConn.Commit;
    Result := processados;
    pmtspararollout;

  finally
  begin
    FConn.Free;
    qry.Connection := nil;
    qry.Free;
  end;
  end;
end;


function TUpload.InserirGeFolhaDePagamento(const jsonData: TJSONArray; const periodo: String; out erro: string): Integer;
var
  qry: TFDQuery;
  i: Integer;
  jsonObject: TJSONObject;
  poStr: string;
  FConn: TFDConnection;
  intValue: Int64;
  formatSettings: TFormatSettings;
  dataStr: string;
  dataDateTime: TDateTime;
  transacaoAtiva: Boolean;


function GetJSONValueStr(obj: TJSONObject; const key: string): string;
var
  val: TJSONValue;
begin
  val := obj.GetValue(key);
  if (val <> nil) and (val is TJSONString) then
    Result := TJSONString(val).Value
  else
    Result := '';
end;

function GetJSONValueInt(obj: TJSONObject; const key: string): Integer;
var
  val: TJSONValue;
begin
  val := obj.GetValue(key);
  if (val <> nil) then
    Result := TJSONNumber(val).AsInt
  else
    Result := 0;
end;


function GetJSONValueFloat(obj: TJSONObject; const key: string): Double;
var
  val: TJSONValue;
  strValue: string;
begin
  val := obj.GetValue(key);
  if val = nil then
    Exit(0.0);

  strValue := val.Value.Trim.Replace(',', '.'); // trata vírgula como ponto decimal

  try
    Result := StrToFloat(strValue, TFormatSettings.Invariant);
  except
    Result := 0.0; // fallback em caso de erro de conversão
  end;
end;
begin
  Result := 0;
  erro := '';
  transacaoAtiva := False;

  // 🔹 Validação do JSON
  if (jsonData = nil) or (jsonData.Count = 0) then
  begin
    erro := 'JSON vazio ou inválido.';
    Exit;
  end;

  qry := TFDQuery.Create(nil);
  try
    FConn := TConnection.CreateConnection;
    try
      qry.Connection := FConn;

      // Inicia transação
      FConn.StartTransaction;
      transacaoAtiva := True;

      try
        // 🔹 Limpa registros existentes para a competência
        qry.SQL.Text := 'DELETE FROM gesfolhapagamento WHERE competencia = :periodo';
        qry.ParamByName('periodo').AsString := periodo;
        qry.ExecSQL;

        // Configura formato de data
        formatSettings := TFormatSettings.Create;
        formatSettings.DateSeparator := '/';
        formatSettings.ShortDateFormat := 'dd/MM/yyyy';

        // 🔹 Prepara SQL para inserção
        qry.SQL.Clear;
        qry.SQL.Add('INSERT INTO gesfolhapagamento');
        qry.SQL.Add('(codigo, Nome, CPF, funcao, depir, admissao, situacao, ocorrencia,');
        qry.SQL.Add('salario, codlancamento, lancamento, referencia, Provento, Desconto,');
        qry.SQL.Add('Bases, liquido, idgeral, competencia)');
        qry.SQL.Add('VALUES (:codigo, :Nome, :CPF, :funcao, :depir, :admissao, :situacao, :ocorrencia,');
        qry.SQL.Add(':salario, :codlancamento, :lancamento, :referencia, :Provento, :Desconto,');
        qry.SQL.Add(':Bases, :liquido, :idgeral, :competencia)');

        // 🔹 Processa cada item do JSON
        for i := 0 to jsonData.Count - 1 do
        begin
          if not (jsonData.Items[i] is TJSONObject) then
            Continue;

          jsonObject := jsonData.Items[i] as TJSONObject;

          try
            // 🔹 Preenche parâmetros
            qry.ParamByName('codigo').AsString       := Copy(GetJSONValueStr(jsonObject, 'Código'), 1, 255);
            qry.ParamByName('nome').AsString         := Copy(GetJSONValueStr(jsonObject, 'Nome'), 1, 255);
            qry.ParamByName('cpf').AsString          := Copy(GetJSONValueStr(jsonObject, 'CPF'), 1, 20);
            qry.ParamByName('funcao').AsString       := Copy(GetJSONValueStr(jsonObject, 'Função'), 1, 100);
            qry.ParamByName('depir').AsInteger       := GetJSONValueInt(jsonObject, 'Dep. IR');

            // 🔹 Conversão segura de data
            dataStr := Copy(GetJSONValueStr(jsonObject, 'Admissão'), 1, 10);
            if not TryStrToDate(dataStr, dataDateTime, formatSettings) then
              raise Exception.Create('Data de admissão inválida: ' + dataStr);
            qry.ParamByName('admissao').AsDateTime := dataDateTime;

            qry.ParamByName('situacao').AsString     := Copy(GetJSONValueStr(jsonObject, 'Situação'), 1, 50);
            qry.ParamByName('ocorrencia').AsInteger  := GetJSONValueInt(jsonObject, 'Ocorrência');
            qry.ParamByName('salario').AsFloat       := GetJSONValueFloat(jsonObject, 'Salário');
            qry.ParamByName('codlancamento').AsString := Copy(GetJSONValueStr(jsonObject, 'Código2'), 1, 100);
            qry.ParamByName('lancamento').AsString   := Copy(GetJSONValueStr(jsonObject, 'Lançamento'), 1, 100);
            qry.ParamByName('referencia').AsFloat    := GetJSONValueFloat(jsonObject, 'Referência');
            qry.ParamByName('provento').AsFloat      := GetJSONValueFloat(jsonObject, 'Provento');
            qry.ParamByName('desconto').AsFloat      := GetJSONValueFloat(jsonObject, 'Desconto');
            qry.ParamByName('bases').AsFloat         := GetJSONValueFloat(jsonObject, 'Bases');
            qry.ParamByName('liquido').AsFloat       := GetJSONValueFloat(jsonObject, 'Líquido');
            qry.ParamByName('idgeral').AsInteger     := 0;
            qry.ParamByName('competencia').AsString  := periodo; // Usa o período passado como parâmetro

            qry.ExecSQL;
            Inc(Result);
          except
            on E: Exception do
            begin
              erro := erro + 'Erro na linha ' + IntToStr(i + 1) + ': ' + E.Message + sLineBreak;
              // Continua processando os próximos registros
            end;
          end;
        end;

        // 🔹 Confirma transação se tudo ocorreu bem
        if erro = '' then
          FConn.Commit
        else
          FConn.Rollback;

      except
        on E: Exception do
        begin
          if transacaoAtiva then
            FConn.Rollback;

          erro := 'Erro durante o processamento: ' + E.Message;
          Result := 0;
        end;
      end;
    finally
      FConn.Free;
    end;
  finally
    qry.Free;
  end;
end;


function TUpload.InserirDespesas(const jsonData: TJSONArray; const periodo: String; out erro: string): Integer;
var
  qry: TFDQuery;
  i, idEmpresa, idPessoa, idVeiculo, iddespesas, idGeral: Integer;
  jsonObject: TJSONObject;
  FConn: TFDConnection;
  dataStr: string;
  dataDateTime: TDateTime;
  formatSettings: TFormatSettings;

function GetJSONValueInt(obj: TJSONObject; const key: string): Integer;
var
  val: TJSONValue;
begin
  val := obj.GetValue(key);
  if (val <> nil) then
    Result := TJSONNumber(val).AsInt
  else
    Result := 0;
end;

function GetJSONValueStr(obj: TJSONObject; const key: string): string;
var
  val: TJSONValue;
begin
  val := obj.GetValue(key);
  if (val <> nil) and (val is TJSONString) then
    Result := TJSONString(val).Value
  else
    Result := '';
end;

function ParseDateToISO(const dataStr: string): string;
var
  day, month, year: string;
begin
  if (Length(dataStr) = 10) and (dataStr[3] = '/') and (dataStr[6] = '/') then
  begin
    day := Copy(dataStr, 1, 2);
    month := Copy(dataStr, 4, 2);
    year := Copy(dataStr, 7, 4);
    Result := year + '-' + month + '-' + day;
  end
  else
    Result := ''; // Retorna vazio se não for no formato esperado
end;

begin
  Result := 0;
  erro := '';

  if (jsonData = nil) or (jsonData.Count = 0) then
  begin
    erro := 'JSON vazio ou inválido.';
    Exit;
  end;

  qry := TFDQuery.Create(nil);
  try
    FConn := TConnection.CreateConnection;
    qry.Connection := FConn;
    FConn.StartTransaction;

    formatSettings := TFormatSettings.Create;
    formatSettings.DateSeparator := '/';
    formatSettings.ShortDateFormat := 'dd/MM/yyyy';


    try
      for i := 0 to jsonData.Count - 1 do
      begin
        jsonObject := jsonData.Items[i] as TJSONObject;
        if jsonObject = nil then
          Continue;

        qry.Close;
        qry.SQL.Text := 'SELECT idveiculo FROM gesveiculos WHERE placa = :placa';
        qry.ParamByName('placa').AsString := GetJSONValueStr(jsonObject, 'Placa');
        qry.Open;
        if not qry.IsEmpty then
          idVeiculo := qry.FieldByName('idVeiculo').AsInteger
        else
          idVeiculo := 0;

        qry.Close;
        qry.SQL.Text := 'SELECT idempresa FROM gesempresas WHERE nome = :nome';
        qry.ParamByName('nome').AsString := GetJSONValueStr(jsonObject, 'Empresa');
        qry.Open;
        if not qry.IsEmpty then
          idEmpresa := qry.FieldByName('idEmpresa').AsInteger
        else
          idEmpresa := 0;

        qry.Close;
        qry.SQL.Text := 'SELECT idpessoa FROM gespessoa WHERE nome = :nome';
        qry.ParamByName('nome').AsString := GetJSONValueStr(jsonObject, 'Funcionário');
        qry.Open;
        if not qry.IsEmpty then
          idPessoa := qry.FieldByName('idpessoa').AsInteger
        else
          idPessoa := 0;

        qry.Close;
        qry.SQL.Text :=
          'SELECT idgeral FROM gesdespesas WHERE datalancamento = :datalancamento ' +
          'AND valordespesa = :valordespesa AND idveiculo = :idveiculo AND idpessoa = :idpessoa AND idempresa = :idempresa';
        qry.ParamByName('datalancamento').AsString := ParseDateToISO(GetJSONValueStr(jsonObject, 'Data Lançamento'));
        qry.ParamByName('valordespesa').AsString   := GetJSONValueStr(jsonObject, 'Valor Despesa');
        qry.ParamByName('idpessoa').AsInteger      := idPessoa;
        qry.ParamByName('idempresa').AsInteger      := idEmpresa;
        qry.ParamByName('idveiculo').AsInteger     := idVeiculo;
        qry.Open;

        if qry.IsEmpty then
        begin
          // 🔥 INSERT

          // Gerar iddespesas
          qry.Close;
          qry.SQL.Text := 'UPDATE admponteiro SET iddespesas = iddespesas + 1 WHERE idcliente = :idcliente AND idloja = :idloja';
          qry.ParamByName('idcliente').AsInteger := 1;
          qry.ParamByName('idloja').AsInteger := 1;
          qry.ExecSQL;

          qry.Close;
          qry.SQL.Text := 'SELECT iddespesas FROM admponteiro WHERE idcliente = :idcliente AND idloja = :idloja';
          qry.ParamByName('idcliente').AsInteger := 1;
          qry.ParamByName('idloja').AsInteger := 1;
          qry.Open;
          iddespesas := qry.FieldByName('iddespesas').AsInteger;

          qry.Close;
          qry.SQL.Text :=
            'INSERT INTO gesdespesas ' +
            '(datalancamento, valordespesa, descricao, idveiculo, observacao, deletado, idloja, idcliente, comprovante, ' +
            'idempresa, idpessoa, periodicidade, categoria, despesacadastradapor, parceladoem, datainicio, valorparcela, ' +
            'datadocadastro, iddespesas) ' +
            'VALUES ' +
            '(:datalancamento, :valordespesa, :descricao, :idveiculo, :observacao, :deletado, :idloja, :idcliente, ' +
            ':comprovante, :idempresa, :idpessoa, :periodicidade, :categoria, :despesacadastradapor, :parceladoem, ' +
            ':datainicio, :valorparcela, :datadocadastro, :iddespesas)';

          qry.ParamByName('datalancamento').AsString := ParseDateToISO(GetJSONValueStr(jsonObject, 'Data Lançamento'));
          qry.ParamByName('datainicio').AsString     := ParseDateToISO(GetJSONValueStr(jsonObject, 'Data Início'));
          qry.ParamByName('valordespesa').AsFloat    := StrToFloatDef(GetJSONValueStr(jsonObject, 'Valor Despesa').Replace(',', '.'), 0);
          qry.ParamByName('descricao').AsString      := GetJSONValueStr(jsonObject, 'Descrição');
          qry.ParamByName('idveiculo').AsInteger     := idVeiculo;
          qry.ParamByName('iddespesas').AsInteger    := iddespesas;
          qry.ParamByName('observacao').AsString     := GetJSONValueStr(jsonObject, 'Observação');
          qry.ParamByName('deletado').AsInteger      := 0;
          qry.ParamByName('idloja').AsInteger        := 1;
          qry.ParamByName('idcliente').AsInteger     := 1;
          qry.ParamByName('comprovante').AsString    := GetJSONValueStr(jsonObject, 'Comprovante');
          qry.ParamByName('idempresa').AsInteger     := idEmpresa;
          qry.ParamByName('idpessoa').AsInteger      := idPessoa;
          qry.ParamByName('periodicidade').AsString  := GetJSONValueStr(jsonObject, 'Periodicidade');
          qry.ParamByName('categoria').AsString      := GetJSONValueStr(jsonObject, 'Categoria');
          qry.ParamByName('despesacadastradapor').AsString := GetJSONValueStr(jsonObject, 'Despesa Cadastrada Por');
          qry.ParamByName('parceladoem').AsString    := GetJSONValueStr(jsonObject, 'Parcelado em');
          qry.ParamByName('valorparcela').AsFloat    := StrToFloatDef(GetJSONValueStr(jsonObject, 'Valor da Parcela').Replace(',', '.'), 0);
          qry.ParamByName('datadocadastro').AsDateTime := Now;
          qry.ExecSQL;
          Inc(Result);
        end
        else
        begin
          // 🔥 UPDATE
          idGeral := qry.FieldByName('idgeral').AsInteger;

          qry.Close;
          qry.SQL.Text :=
            'UPDATE gesdespesas SET ' +
            'observacao = :observacao, comprovante = :comprovante, idempresa = :idempresa, ' +
            'idpessoa = :idpessoa, periodicidade = :periodicidade, categoria = :categoria, ' +
            'despesacadastradapor = :despesacadastradapor, parceladoem = :parceladoem, ' +
            'datainicio = :datainicio, valorparcela = :valorparcela ' +
            'WHERE idgeral = :idgeral';

          qry.ParamByName('observacao').AsString     := GetJSONValueStr(jsonObject, 'Observação');
          qry.ParamByName('comprovante').AsString    := GetJSONValueStr(jsonObject, 'Comprovante');
          qry.ParamByName('idempresa').AsInteger     := idEmpresa;
          qry.ParamByName('idpessoa').AsInteger      := idPessoa;
          qry.ParamByName('periodicidade').AsString  := GetJSONValueStr(jsonObject, 'Periodicidade');
          qry.ParamByName('categoria').AsString      := GetJSONValueStr(jsonObject, 'Categoria');
          qry.ParamByName('despesacadastradapor').AsString := GetJSONValueStr(jsonObject, 'Despesa Cadastrada Por');
          qry.ParamByName('parceladoem').AsString    := GetJSONValueStr(jsonObject, 'Parcelado em');
          qry.ParamByName('datainicio').AsString     := ParseDateToISO(GetJSONValueStr(jsonObject, 'Data Início'));
          qry.ParamByName('valorparcela').AsFloat    := StrToFloatDef(GetJSONValueStr(jsonObject, 'Valor da Parcela').Replace(',', '.'), 0);
          qry.ParamByName('idgeral').AsInteger       := idGeral;
          qry.ExecSQL;
          Inc(Result);
        end;
      end;

      FConn.Commit;
    except
      on E: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro na linha ' + IntToStr(i + 1) + ': ' + E.Message;
        Result := 0;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TUpload.InserirLpuZte(const jsonData: TJSONArray; out erro: string): Integer;
var
  qry: TFDQuery;
  i: Integer;
  jsonObject: TJSONObject;
  descricaoAtividade, valorStr, itemValue: string;
  valorFloat: Double;
  regiao, estado: string;

function GetJSONValueStr(obj: TJSONObject; const key: string): string;
  var
    val: TJSONValue;
  begin
    if obj = nil then Exit('');
    val := obj.GetValue(key);
    if (val <> nil) and not val.Null and (val is TJSONString) then
      Result := TJSONString(val).Value
    else
      Result := '';
  end;
function EstadoParaRegiao(const estado: string): string;
begin
  case AnsiIndexStr(estado, ['SP', 'RJ', 'MG', 'ES',                      // Sudeste
                             'NE', 'BA', 'SE', 'AL', 'PE', 'PB', 'RN', 'CE', 'PI', 'MA', // Nordeste
                             'MT', 'MS', 'GO', 'DF',                        // Centro-Oeste
                             'PR', 'SC', 'RS',                              // Sul
                             'AM', 'RR', 'AP', 'PA', 'TO', 'RO', 'AC']) of  // Norte
    0..3: Result := 'SUDESTE';
    4..13: Result := 'NORDESTE';
    14..16: Result := 'CENTRO-OESTE';
    17..19: Result := 'SUL';
    20..26: Result := 'NORTE';
  else
    Result := 'DESCONHECIDO';
  end;
end;
begin
  Result := 0;
  erro := '';

  if (jsonData = nil) or (jsonData.Count = 0) then
  begin
    erro := 'JSON vazio ou inválido.';
    Exit;
  end;

  qry := TFDQuery.Create(nil);
  try
    FConn := TConnection.CreateConnection;
    if FConn = nil then
    begin
      erro := 'Falha ao criar conexão com o banco.';
      Exit;
    end;

    qry.Connection := FConn;

    try
      qry.Connection.StartTransaction;

      for i := 0 to jsonData.Count - 1 do
      begin
        if not (jsonData.Items[i] is TJSONObject) then Continue;

        jsonObject := TJSONObject(jsonData.Items[i]);
        itemValue := GetJSONValueStr(jsonObject, 'ITEM - Inglês');

        valorStr := GetJSONValueStr(jsonObject, 'Preço Unit');
        if valorStr = '' then
          valorStr := GetJSONValueStr(jsonObject, 'Preçp Unit');
        valorFloat := StrToFloatDef(valorStr, 0);

        valorStr := '';
        valorStr := GetJSONValueStr(jsonObject, 'ITEM - Portugues');
        if valorStr = '' then
          valorStr := GetJSONValueStr(jsonObject, 'ITEM - Português');

        descricaoAtividade := itemValue + ' / ' + valorStr;
        estado := GetJSONValueStr(jsonObject, 'REGIONAL');

        // Determina a região automaticamente
        regiao := EstadoParaRegiao(estado);

        qry.Params.Clear;
        qry.SQL.Text :=
          'INSERT INTO obraztelpu ' +
          '(PROJETO, DESCRICAOATIVIDADE, CODIGO, estado,localidade, REGIAO, VALOR, historico,  idcolaborador, deletado, datadeletado) ' +
          'VALUES (:projeto, :descricao, :codigo, :estado, :localidade, :regiao, :valor, :historico, 0, 0, 0)';


        qry.ParamByName('projeto').AsString := 'ZTE';
        qry.ParamByName('descricao').AsString := descricaoAtividade;
        qry.ParamByName('codigo').AsString := GetJSONValueStr(jsonObject, 'NO. ZTE');
        qry.ParamByName('estado').AsString := estado;;
        qry.ParamByName('localidade').AsString := estado;
        qry.ParamByName('regiao').AsString := regiao;
        qry.ParamByName('historico').AsString := 'LPU atualizada em ' + FormatDateTime('dd/mm/yyyy', Now);
        qry.ParamByName('valor').AsFloat := valorFloat;

        qry.ExecSQL;
        Inc(Result);
      end;

      qry.Connection.Commit;
    except
      on E: Exception do
      begin
        if (qry <> nil) and (qry.Connection <> nil) then
          qry.Connection.Rollback;

        erro := 'Erro ao inserir linha ' + IntToStr(i + 1) + ': ' + E.Message;
        Result := 0;
      end;
    end;
  finally
    if Assigned(qry) then
      qry.Free;
    if Assigned(FConn) then
      FConn.Free;
  end;
end;



function TUpload.InserirConvenio(const jsonData: TJSONArray; const periodo: String; out erro: string): Integer;
var
  qry: TFDQuery;
  i: Integer;
  jsonObject: TJSONObject;
  poStr: string;
  FConn: TFDConnection;
  intValue: Int64;
  formatSettings: TFormatSettings;
  dataStr: string;
  dataDateTime: TDateTime;


function GetJSONValueStr(obj: TJSONObject; const key: string): string;
var
  val: TJSONValue;
begin
  val := obj.GetValue(key);
  if (val <> nil) and (val is TJSONString) then
    Result := TJSONString(val).Value
  else
    Result := '';
end;

function GetJSONValueInt(obj: TJSONObject; const key: string): Integer;
var
  val: TJSONValue;
begin
  val := obj.GetValue(key);
  if (val <> nil) then
    Result := TJSONNumber(val).AsInt
  else
    Result := 0;
end;


function GetJSONValueFloat(obj: TJSONObject; const key: string): Double;
var
  val: TJSONValue;
  strValue: string;
begin
  val := obj.GetValue(key);
  if val = nil then
    Exit(0.0);

  strValue := val.Value.Trim.Replace(',', '.'); // trata vírgula como ponto decimal

  try
    Result := StrToFloat(strValue, TFormatSettings.Invariant);
  except
    Result := 0.0; // fallback em caso de erro de conversão
  end;
end;
begin
  Result := 0;
  erro := '';

  // 🔹 Validação do JSON
  if (jsonData = nil) or (jsonData.Count = 0) then
  begin
    erro := 'JSON vazio ou inválido.';
    Exit;
  end;

  qry := TFDQuery.Create(nil);
  try
    FConn := TConnection.CreateConnection;
    qry.Connection := FConn;
    FConn.StartTransaction;
    try
      // qry.SQL.Text := 'DELETE FROM convenio WHERE competencia = :periodo';
      // qry.ParamByName('periodo').AsString := periodo;
     //  qry.ExecSQL;
     //  FConn.Commit;
     // qry.SQL.Clear;
      formatSettings := TFormatSettings.Create;
      formatSettings.DateSeparator := '/';
      formatSettings.ShortDateFormat := 'dd/MM/yyyy';

      for i := 0 to jsonData.Count - 1 do
      begin
        jsonObject := jsonData.Items[i] as TJSONObject;
        if jsonObject = nil then
        begin
          Continue; // Ignora se for inválido
        end;
        qry.SQL.Clear;
        qry.SQL.Add('INSERT INTO convenio');
        qry.SQL.Add('(valorconvenio, descontocolaborador, valorempresa, periodo, idade, nome, nomeconvenio)');
        qry.SQL.Add('VALUES (:valorconvenio, :descontocolaborador, :valorempresa, :periodo, :idade, :nome, :nomeconvenio)');

        qry.ParamByName('valorconvenio').AsFloat           := GetJSONValueFloat(jsonObject, 'BRADESCO_2');
        qry.ParamByName('descontocolaborador').AsFloat    := GetJSONValueFloat(jsonObject, 'COLABORADOR');
        qry.ParamByName('valorempresa').AsFloat           := GetJSONValueFloat(jsonObject, 'EMPRESA');
        qry.ParamByName('periodo').AsString                := GetJSONValueStr(jsonObject, 'PERIODO'); // Faltava
        qry.ParamByName('idade').AsInteger                  := GetJSONValueInt(jsonObject, 'Idades');
        qry.ParamByName('nome').AsString                    := Copy(GetJSONValueStr(jsonObject, 'Nomes'), 1, 255);
        qry.ParamByName('nomeconvenio').AsString            := Copy(GetJSONValueStr(jsonObject, 'BRADESCO'), 1, 255);

        qry.ExecSQL;
      end;
      FConn.Commit;
      Result := jsonData.Count;
    except
      on E: EFDDBEngineException do
        begin
          Writeln('Erro ao inserir: ' + E.Message);
          // Exibe os valores importantes para debug
          Writeln('RFP: ' + qry.ParamByName('rfp').AsString);
          Writeln('SQL: ' + qry.SQL.Text);
        end;
      on E: Exception do
      begin
        erro := 'Erro ao inserir dados na linha ' + IntToStr(i + 1) + ': ' + E.Message;
        Writeln(erro);
        FConn.Rollback;
        Result := 0;
      end;
    end;
  finally
    qry.Free;
  end;
end;


function TUpload.InserirTicketValeTransporte(const jsonData: TJSONArray; const periodo: String; out erro: string): Integer;
var
  qry: TFDQuery;
  i: Integer;
  jsonObject: TJSONObject;
  FConn: TFDConnection;
  formatSettings: TFormatSettings;

  function GetJSONValueStr(obj: TJSONObject; const key: string): string;
  var
    val: TJSONValue;
  begin
    val := obj.GetValue(key);
    if (val <> nil) then
      Result := val.Value
    else
      Result := '';
  end;
function GetJSONValueFloatString(obj: TJSONObject; const key: string): Double;
var
  strValue: string;
  floatValue: Double;
begin
  strValue := GetJSONValueStr(obj, key).Trim.Replace(',', '.');

  // Tenta converter para número, se falhar, retorna 0.0
  if TryStrToFloat(strValue, floatValue, TFormatSettings.Invariant) then
    Result := floatValue
  else
    Result := 0.0;
end;

  function GetJSONValueFloat(obj: TJSONObject; const key: string): Double;
  var
    strValue: string;
  begin
    strValue := GetJSONValueStr(obj, key).Trim.Replace(',', '.');
    try
      Result := StrToFloat(strValue, TFormatSettings.Invariant);
    except
      Result := 0.0;
    end;
  end;

begin
  Result := 0;
  erro := '';

  if (jsonData = nil) or (jsonData.Count = 0) then
  begin
    erro := 'JSON vazio ou inválido.';
    Exit;
  end;

  qry := TFDQuery.Create(nil);
  try
    FConn := TConnection.CreateConnection;
    qry.Connection := FConn;
    FConn.StartTransaction;
    try
      qry.SQL.Text := 'DELETE FROM valetransporte WHERE periodo = :periodo';
      qry.ParamByName('periodo').AsString := periodo;
      qry.ExecSQL;

      //Insert Vale transporte
      for i := 0 to jsonData.Count - 1 do
      begin
        jsonObject := jsonData.Items[i] as TJSONObject;
        if jsonObject = nil then
          Continue;

        qry.SQL.Text :=
          'INSERT INTO valetransporte (' +
          'codigo, admissao, cargo, cbo, projeto, valordia, dias, ' +
          'beneficio, salario, porc6, empresa, observacao, periodo, created_at) ' +
          'VALUES (:codigo, :admissao, :cargo, :cbo, :projeto, :valordia, :dias, ' +
          ':beneficio, :salario, :desconto, :empresa, :observacao, :periodo, NOW())';
         Writeln(jsonObject.toString());
        qry.ParamByName('codigo').AsString        := GetJSONValueStr(jsonObject, 'Codigo');
        qry.ParamByName('admissao').AsDate        := StrToDateDef(GetJSONValueStr(jsonObject, 'Admissao'), 0);
        qry.ParamByName('cargo').AsString         := GetJSONValueStr(jsonObject, 'Cargo');
        qry.ParamByName('cbo').AsString           := GetJSONValueStr(jsonObject, 'CBO');
        qry.ParamByName('projeto').AsString       := GetJSONValueStr(jsonObject, 'Projeto');
        qry.ParamByName('valordia').AsFloat      := GetJSONValueFloat(jsonObject, 'Valor dia');
        qry.ParamByName('dias').AsInteger         := StrToIntDef(GetJSONValueStr(jsonObject, 'Dias'), 0);
        qry.ParamByName('beneficio').AsFloat      := GetJSONValueFloat(jsonObject, 'Beneficio');
        qry.ParamByName('salario').AsFloat        := GetJSONValueFloat(jsonObject, 'Salario');
        qry.ParamByName('desconto').AsFloat       := GetJSONValueFloat(jsonObject, 'Desconto');
        qry.ParamByName('empresa').AsFloat        := GetJSONValueFloat(jsonObject, 'Empresa');
        qry.ParamByName('observacao').AsString    := GetJSONValueStr(jsonObject, 'Observacao');
        qry.ParamByName('periodo').AsString   := GetJSONValueStr(jsonObject, 'Competência');

        qry.ExecSQL;
      end;

      FConn.Commit;
      Result := jsonData.Count;

    except
      on E: Exception do
      begin
        erro := 'Erro ao inserir dados na linha ' + IntToStr(i + 1) + ': ' + E.Message;
        Writeln(erro);
        FConn.Rollback;
        Result := 0;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TUpload.InserirTicket(const jsonData: TJSONArray; const periodo: String; out erro: string): Integer;
var
  qry: TFDQuery;
  i: Integer;
  jsonObject: TJSONObject;
  poStr: string;
  FConn: TFDConnection;
  intValue: Int64;
  formatSettings: TFormatSettings;
  perid, dataStr: string;

  dataDateTime: TDateTime;
  codValue, coluna1Value: string;
  beneficio, desconto, resultado: Double;



  function GetJSONValueStr(obj: TJSONObject; const key: string): string;
var
  val: TJSONValue;
begin
  val := obj.GetValue(key);
  if (val <> nil) and (val is TJSONString) then
    Result := TJSONString(val).Value
  else
    Result := '';
end;

function GetJSONValueFloatString(obj: TJSONObject; const key: string): Double;
var
  strValue: string;
  floatValue: Double;
begin
  strValue := GetJSONValueStr(obj, key).Trim.Replace(',', '.');

  // Tenta converter para número, se falhar, retorna 0.0
  if TryStrToFloat(strValue, floatValue, TFormatSettings.Invariant) then
    Result := floatValue
  else
    Result := 0.0;
end;

function GetJSONValueInt(obj: TJSONObject; const key: string): Integer;
var
  val: TJSONValue;
begin
  val := obj.GetValue(key);
  if (val <> nil) then
    Result := TJSONNumber(val).AsInt
  else
    Result := 0;
end;


function GetJSONValueFloat(obj: TJSONObject; const key: string): Double;
var
  val: TJSONValue;
  strValue: string;
begin
  val := obj.GetValue(key);
  if val = nil then
    Exit(0.0);

  strValue := val.Value.Trim.Replace(',', '.'); // trata vírgula como ponto decimal

  try
    Result := StrToFloat(strValue, TFormatSettings.Invariant);
  except
    Result := 0.0; // fallback em caso de erro de conversão
  end;
end;
begin
  Result := 0;
  erro := '';

  // 🔹 Validação do JSON
  if (jsonData = nil) or (jsonData.Count = 0) then
  begin
    erro := 'JSON vazio ou inválido.';
    Exit;
  end;

  qry := TFDQuery.Create(nil);
try
  FConn := TConnection.CreateConnection;
  qry.Connection := FConn;
  FConn.StartTransaction;
  try
    // Exclui registros do mesmo período antes de inserir
    perid := Copy(GetJSONValueStr(jsonData.Items[0] as TJSONObject, 'Competência'), 1, 7);

    qry.SQL.Text := 'DELETE FROM ticket WHERE periodo = :periodo';
    qry.ParamByName('periodo').AsString := perid;
    qry.ExecSQL;

    FConn.Commit;
    //Insert Ticket


    for i := 0 to jsonData.Count - 1 do
    begin
      jsonObject := jsonData.Items[i] as TJSONObject;
      if jsonObject = nil then
        Continue;


      codValue := Trim(GetJSONValueStr(jsonObject, 'COD'));
      coluna1Value := Trim(GetJSONValueStr(jsonObject, 'Coluna_1'));
      if (codValue = '') or (coluna1Value = '') then
         Continue;

      qry.SQL.Clear;
       qry.SQL.Add('INSERT INTO ticket');
      qry.SQL.Add('(opcao, codigo, beneficio, desconto, valorempresa, dias, observacao, periodo)');
      qry.SQL.Add('VALUES');
      qry.SQL.Add('(:opcao, :cod, :beneficio, :desconto, :valorempresa, :dias, :observacao, :periodo)');

      qry.ParamByName('opcao').AsString := Copy(GetJSONValueStr(jsonObject, 'Coluna_1'), 1, 10);
      qry.ParamByName('cod').AsInteger := GetJSONValueInt(jsonObject, 'COD');

      beneficio := GetJSONValueFloat(jsonObject, '28,6');
      desconto  := GetJSONValueFloat(jsonObject, 'Coluna_5');
      resultado := beneficio - desconto;

      qry.ParamByName('beneficio').AsFloat     := beneficio;
      qry.ParamByName('desconto').AsFloat      := desconto;
      qry.ParamByName('valorempresa').AsFloat  := resultado;

      qry.ParamByName('dias').AsInteger := GetJSONValueInt(jsonObject, 'DIAS');
      qry.ParamByName('observacao').AsString := Copy(GetJSONValueStr(jsonObject, 'Coluna_8'), 1, 255);
      qry.ParamByName('periodo').AsString := Copy(GetJSONValueStr(jsonObject, 'Competência'), 1, 7);

            qry.ExecSQL;
    end;


    FConn.Commit;
    Result := jsonData.Count;

  except
    on E: Exception do
    begin
      erro := 'Erro ao inserir dados na linha ' + IntToStr(i + 1) + ': ' + E.Message;
      Writeln(erro);
      FConn.Rollback;
      Result := 0;
    end;
  end;
finally
  qry.Free;
end;

end;


function TUpload.InserirAtualizaObrasAspRFP2024(const jsonData: TJSONArray; out erro: string): Integer;
var
  qry: TFDQuery;
  i: Integer;
  jsonObject: TJSONObject;
  poStr: string;
  intValue: Int64;
  formatSettings: TFormatSettings;
begin
  Result := 0;
  erro := '';

  // 🔹 Validação do JSON
  if (jsonData = nil) or (jsonData.Count = 0) then
  begin
    erro := 'JSON vazio ou inválido.';
    Exit;
  end;

  // 🔹 Verifica se a conexão está atribuída
  if not Assigned(FConn) then
  begin
    erro := 'Conexão com o banco de dados não foi inicializada.';
    Exit;
  end;

  qry := TFDQuery.Create(nil);
  try
    FConn := TConnection.CreateConnection;
    qry.Connection := FConn;
    FConn.StartTransaction;
    try
      // 🔹 Limpa tabela antes de inserir novos registros
      qry.SQL.Text := 'DELETE FROM atualizaobraericsson2024';
      qry.ExecSQL;
      FConn.Commit;
      qry.SQL.Clear;

      // Configuração do formato de data/hora
      formatSettings := TFormatSettings.Create;
      formatSettings.ShortDateFormat := 'dd/mm/yyyy'; // Formato esperado no JSON
      formatSettings.DateSeparator := '/';
      formatSettings.ShortTimeFormat := 'hh:nn:ss';
      formatSettings.TimeSeparator := ':';

      for i := 0 to jsonData.Count - 1 do
      begin
        jsonObject := jsonData.Items[i] as TJSONObject;
        if jsonObject = nil then
        begin

          Continue; // Ignora se for inválido
        end;

        if not jsonObject.TryGetValue<string>('RFP > Nome', poStr) or not TryStrToInt64(poStr, intValue) then
        begin
          erro := Format('RFP > Nome inválido na linha %d: %s. Registro ignorado.', [i + 1, poStr]);
          Continue; // Apenas pula para o próximo item, sem sair da função
        end;

        qry.SQL.Clear;
        qry.SQL.Add('INSERT INTO atualizaobraericsson2024 (rfp, numero, cliente, regiona, site, fornecedor, ');
        qry.SQL.Add('situacaoimplantacao, situacaodaintegracao, datadacriacaodademandadia, datalimiteaceitedia, ');
        qry.SQL.Add('dataaceitedemandadia, datainicioprevistasolicitantebaselinemosdia, datainicioentregamosplanejadodia, ');
        qry.SQL.Add('datarecebimentodositemosreportadodia, datafimprevistabaselinefiminstalacaodia, datafiminstalacaoplanejadodia, ');
        qry.SQL.Add('dataconclusaoreportadodia, datavalidacaoinstalacaodia, dataintegracaobaselinedia, dataintegracaoplanejadodia, ');
        qry.SQL.Add('datavalidacaoeriboxedia, listadepos, gestordeimplantacaonome, statusrsa, rsarsa, ARQsvalidadapeloCliente, ');
        qry.SQL.Add('statusaceitacao, datadefimdaaceitacaosydledia, ordemdevenda, coordenadoaspnome, rsavalidacaorsanrotrackerdatafimdia, ');
        qry.SQL.Add('fimdeobraplandia, fimdeobrarealdia, tipoatualizacaofam, sinergia, sinergia5g, escoponome, slapadraoescopodias, ');
        qry.SQL.Add('tempoparalisacaoinstalacaodias, localizacaositeendereco, localizacaositeCidade, documentacaosituacao, sitepossuirisco) ');
        qry.SQL.Add('VALUES (:rfp, :numero, :cliente, :regiona, :site, :fornecedor, ');
        qry.SQL.Add(':situacaoimplantacao, :situacaodaintegracao, :datadacriacaodademandadia, :datalimiteaceitedia, ');
        qry.SQL.Add(':dataaceitedemandadia, :datainicioprevistasolicitantebaselinemosdia, :datainicioentregamosplanejadodia, ');
        qry.SQL.Add(':datarecebimentodositemosreportadodia, :datafimprevistabaselinefiminstalacaodia, :datafiminstalacaoplanejadodia, ');
        qry.SQL.Add(':dataconclusaoreportadodia, :datavalidacaoinstalacaodia, :dataintegracaobaselinedia, :dataintegracaoplanejadodia, ');
        qry.SQL.Add(':datavalidacaoeriboxedia, :listadepos, :gestordeimplantacaonome, :statusrsa, :rsarsa, :ARQsvalidadapeloCliente, ');
        qry.SQL.Add(':statusaceitacao, :datadefimdaaceitacaosydledia, :ordemdevenda, :coordenadoaspnome, :rsavalidacaorsanrotrackerdatafimdia, ');
        qry.SQL.Add(':fimdeobraplandia, :fimdeobrarealdia, :tipoatualizacaofam, :sinergia, :sinergia5g, :escoponome, :slapadraoescopodias, ');
        qry.SQL.Add(':tempoparalisacaoinstalacaodias, :localizacaositeendereco, :localizacaositeCidade, :documentacaosituacao, :sitepossuirisco)');

        // 🔹 Mapeamento de parâmetros com validação de tamanho
        qry.ParamByName('rfp').AsString := Copy(jsonObject.GetValue<string>('RFP > Nome', ''), 1, 100);
        qry.ParamByName('numero').AsString := Copy(jsonObject.GetValue<string>('Número', ''), 1, 20);
        qry.ParamByName('cliente').AsString := Copy(jsonObject.GetValue<string>('Cliente > Nome', ''), 1, 50);
        qry.ParamByName('regiona').AsString := Copy(jsonObject.GetValue<string>('Regional > Nome', ''), 1, 50);
        qry.ParamByName('site').AsString := Copy(jsonObject.GetValue<string>('Site > Nome', ''), 1, 255);
        qry.ParamByName('fornecedor').AsString := Copy(jsonObject.GetValue<string>('Fornecedor > Nome', ''), 1, 255);
        qry.ParamByName('situacaoimplantacao').AsString := Copy(jsonObject.GetValue<string>('Situação Implantação', ''), 1, 60);
        qry.ParamByName('situacaodaintegracao').AsString := Copy(jsonObject.GetValue<string>('Situação da Integração', ''), 1, 50);
        qry.ParamByName('listadepos').AsString := Copy(jsonObject.GetValue<string>('Lista de POs', ''), 1, 255);
        qry.ParamByName('gestordeimplantacaonome').AsString := Copy(jsonObject.GetValue<string>('Gestor de Implantação > Nome', ''), 1, 255);
        qry.ParamByName('statusrsa').AsString := Copy(jsonObject.GetValue<string>('Status RSA', ''), 1, 50);
        qry.ParamByName('rsarsa').AsString := Copy(jsonObject.GetValue<string>('RSA > RSA', ''), 1, 50);
        qry.ParamByName('ARQsvalidadapeloCliente').AsString := Copy(jsonObject.GetValue<string>('ARQs validada pelo Cliente', ''), 1, 20);
        qry.ParamByName('statusaceitacao').AsString := Copy(jsonObject.GetValue<string>('Status Aceitação', ''), 1, 50);
        qry.ParamByName('ordemdevenda').AsString := Copy(jsonObject.GetValue<string>('Ordem de Venda', ''), 1, 200);
        qry.ParamByName('coordenadoaspnome').AsString := Copy(jsonObject.GetValue<string>('Coordenador ASP > Nome', ''), 1, 255);
        qry.ParamByName('tipoatualizacaofam').AsString := Copy(jsonObject.GetValue<string>('Tipo de atualização FAM', ''), 1, 59);
        qry.ParamByName('sinergia').AsString := Copy(jsonObject.GetValue<string>('Sinergia', ''), 1, 50);
        qry.ParamByName('sinergia5g').AsString := Copy(jsonObject.GetValue<string>('Sinergia 5G', ''), 1, 50);
        qry.ParamByName('escoponome').AsString := Copy(jsonObject.GetValue<string>('Escopo > Nome', ''), 1, 255);
        qry.ParamByName('slapadraoescopodias').AsString := Copy(jsonObject.GetValue<string>('SLA padrão do escopo (dias)', ''), 1, 100);
        qry.ParamByName('localizacaositeendereco').AsString := Copy(jsonObject.GetValue<string>('Localização do Site > Endereço (A)', ''), 1, 255);
        qry.ParamByName('localizacaositeCidade').AsString := Copy(jsonObject.GetValue<string>('Localização do Site > Cidade (A)', ''), 1, 255);
        qry.ParamByName('documentacaosituacao').AsString := Copy(jsonObject.GetValue<string>('Documentação > Situação', ''), 1, 50);
        qry.ParamByName('sitepossuirisco').AsString := Copy(jsonObject.GetValue<string>('Site Possui Risco?', ''), 1, 50);
        qry.ParamByName('tempoparalisacaoinstalacaodias').AsString := Copy(jsonObject.GetValue<string>('Tempo de paralisação de Instalação (dias)', ''), 1, 255);

        // Processar campos de data
        ProcessarCampoData(jsonObject, 'Data da criação da Demanda (Dia)', 'datadacriacaodademandadia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data limite de Aceite (Dia)', 'datalimiteaceitedia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de aceite da demanda (Dia)', 'dataaceitedemandadia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Início prevista pelo solicitante (Baseline MOS) (Dia)', 'datainicioprevistasolicitantebaselinemosdia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Início / Entrega (MOS - Planejado) (Dia)', 'datainicioentregamosplanejadodia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de recebimento do site (MOS - Reportado) (Dia)', 'datarecebimentodositemosreportadodia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Fim prevista pelo solicitante (Baseline Fim Instalação) (Dia)', 'datafimprevistabaselinefiminstalacaodia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Fim de Instalação (Planejado) (Dia)', 'datafiminstalacaoplanejadodia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Conclusão (Reportado) (Dia)', 'dataconclusaoreportadodia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Validação da Instalação (Dia)', 'datavalidacaoinstalacaodia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Integração (Baseline) (Dia)', 'dataintegracaobaselinedia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Integração (Planejado) (Dia)', 'dataintegracaoplanejadodia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Validação ERIBOX (Dia)', 'datavalidacaoeriboxedia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de fim da Aceitação (SYDLE) (Dia)', 'datadefimdaaceitacaosydledia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'RSA > Validação de Qualidade RSA (NRO Tracker) > Data fim do RSA (Dia)', 'rsavalidacaorsanrotrackerdatafimdia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'FIM_DE_OBRA PLAN', 'fimdeobraplandia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'FIM_DE_OBRA REAL', 'fimdeobrarealdia', qry, formatSettings);

        // 🔹 Executa a inserção
        qry.ExecSQL;
      end;

      // 🔹 Finaliza a transação
      FConn.Commit;
      Result := jsonData.Count;
      obraericsson2024parareal;
    except
      on E: EFDDBEngineException do
        begin
          Writeln('Erro ao inserir: ' + E.Message);
          // Exibe os valores importantes para debug
          Writeln('RFP: ' + qry.ParamByName('rfp').AsString);
          Writeln('SQL: ' + qry.SQL.Text);
        end;
      on E: Exception do
      begin
        erro := 'Erro ao inserir dados na linha ' + IntToStr(i + 1) + ': ' + E.Message;
        Writeln(erro);
        FConn.Rollback;
        Result := 0;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TUpload.InserirAtualizaObrasSites(const jsonData: TJSONArray; out erro: string): Integer;
var
  qry: TFDQuery;
  i: Int64;
  jsonObject: TJSONObject;
  poStr: string;
  tempDateTime: TDateTime;
  formatSettings: TFormatSettings;
  intValue: Int64;
  floatValue: Double;
begin
  Result := 0;
  erro := '';

  // 🔹 Validação do JSON
  if (jsonData = nil) or (jsonData.Count = 0) then
  begin
    erro := 'JSON vazio ou inválido.';
    Exit;
  end;

  // 🔹 Verifica se a conexão está atribuída
  if not Assigned(FConn) then
  begin
    erro := 'Conexão com o banco de dados não foi inicializada.';
    Exit;
  end;

  qry := TFDQuery.Create(nil);
  try
    FConn := TConnection.CreateConnection;
    qry.Connection := FConn;
    FConn.StartTransaction;
    try
      // 🔹 Limpa tabela antes de inserir novos registros
      qry.SQL.Text := 'DELETE FROM atualizaobrasericssonlistasites';
      qry.ExecSQL;
      FConn.Commit;
      qry.SQL.Clear;

      // Configuração do formato de data/hora
      formatSettings := TFormatSettings.Create;
      formatSettings.ShortDateFormat := 'dd/mm/yyyy'; // Formato esperado no JSON
      formatSettings.DateSeparator := '/';
      formatSettings.ShortTimeFormat := 'hh:nn:ss';
      formatSettings.TimeSeparator := ':';

      for i := 0 to jsonData.Count - 1 do
      begin
        jsonObject := jsonData.Items[i] as TJSONObject;
        if jsonObject = nil then
          Continue; // Ignora se for inválido

        // 🔹 Verifica se o campo "SEED" é numérico
        if not jsonObject.TryGetValue<string>('SEED', poStr) or not TryStrToInt64(poStr, intValue) then
        begin
          erro := Format('SEED inválido na linha %d: %s. Registro ignorado.', [i + 1, poStr]);
          Continue; // Apenas pula para o próximo item, sem sair da função
        end;

        qry.SQL.Clear;
        qry.SQL.Add('INSERT INTO atualizaobrasericssonlistasites (SEED, `Responsável da obra`, Solicitante, Cliente, Regional, Site, ');
        qry.SQL.Add('filtrorfp, Registros, Fornecedor, TypeSite, SLA_Escopo, Atrasado, `Ageing Instalação`, ');
        qry.SQL.Add('`Ageing Instalação Liquido`, `Tempo Paralisação Instalação`, `Justificativa SLA de Instalação`, `Já foi paralisada por HSE`, ');
        qry.SQL.Add('InstalacaoParalisadas, `Status Obra`, `Existe Pendencia`, `Detalhe do Status`, `Criação da Demanda`, `Baseline MOS`, ');
        qry.SQL.Add('`MOS Plan`, `MOS Real`, `Baseline Fim Instalação`, `Fim Instalação Plan`, `Fim Instalação Real`, `Integração Real`, ');
        qry.SQL.Add('`Validação da Instalação`, `Baseline Integração`, `Integração Plan`, `Integração Confirmada`, `FIMDEOBRAPLAN`, ');
        qry.SQL.Add('`FIMDEOBRAREAL`, `Site Apto para Aceitação Baseline`, `Site Apto para Aceitação Plan`, `Site Apto para Aceitação`, ');
        qry.SQL.Add('`Ofensor Atual`, TX, `ACK HW`, `FAM HABILITADA`, INFRA, `Progresso (Obra)`, `Data último progresso (RSA)`, ');
        qry.SQL.Add('`RSA Atrasado`, `Status RSA`, statusdoc, `Ageing MOS - Doc Aprovada`, `Ageing MOS - Doc Entregue`, `Postagem 100% Doc.`, ');
        qry.SQL.Add('`Aprovação todos Docs.`, `Progresso RSA`, `QtdRejeitado`, aceitacaofical, PendenciasObra, `Texto Sydle`) ');
        qry.SQL.Add('VALUES (:SEED, :ResponsavelObra, :Solicitante, :Cliente, :Regional, :Site, ');
        qry.SQL.Add(':filtrorfp, :Registros, :Fornecedor, :TypeSite, :SLA_Escopo, :Atrasado, :AgeingInstalacao, ');
        qry.SQL.Add(':AgeingInstalacaoLiquido, :TempoParalisacaoInstalacao, :JustificativaSLAInstalacao, :JaFoiParalisadaPorHSE, ');
        qry.SQL.Add(':InstalacaoParalisadas, :StatusObra, :ExistePendencia, :DetalheStatus, :CriacaoDemanda, :BaselineMOS, ');
        qry.SQL.Add(':MOSPlan, :MOSReal, :BaselineFimInstalacao, :FimInstalacaoPlan, :FimInstalacaoReal, :IntegracaoReal, ');
        qry.SQL.Add(':ValidacaoInstalacao, :BaselineIntegracao, :IntegracaoPlan, :IntegracaoConfirmada, :FIMDEOBRAPLAN, ');
        qry.SQL.Add(':FIMDEOBRA_REAL, :SiteAptoAceitacaoBaseline, :SiteAptoAceitacaoPlan, :SiteAptoAceitacao, ');
        qry.SQL.Add(':OfensorAtual, :TX, :ACK_HW, :FAM_HABILITADA, :INFRA, :ProgressoObra, :DataUltimoProgressoRSA, ');
        qry.SQL.Add(':RSAAtrasado, :StatusRSA, :statusdoc, :AgeingMOSDocAprovada, :AgeingMOSDocEntregue, :Postagem100Doc, ');
        qry.SQL.Add(':AprovacaoTodosDocs, :ProgressoRSA, :QtdRejeitado, :aceitacaofical, :PendenciasObra, :TextoSydle)');

        // 🔹 Mapeamento de parâmetros

        if jsonObject.TryGetValue<Int64>('SEED', intValue) then
        begin
          // Se o valor for encontrado e convertido com sucesso, atribui ao parâmetro
          qry.ParamByName('SEED').AsInteger := intValue;
        end
        else
        begin
          // Se o valor não for encontrado ou não for válido, limpa o parâmetro
          qry.ParamByName('SEED').Clear;
        end;
        qry.ParamByName('ResponsavelObra').AsString := jsonObject.GetValue<string>('Responsável da obra', '');
        qry.ParamByName('Solicitante').AsString := jsonObject.GetValue<string>('Solicitante', '');
        qry.ParamByName('Cliente').AsString := jsonObject.GetValue<string>('Cliente', '');
        qry.ParamByName('Regional').AsString := jsonObject.GetValue<string>('Regional', '');
        qry.ParamByName('Site').AsString := jsonObject.GetValue<string>('Site', '');
        qry.ParamByName('FAM_HABILITADA').AsString := jsonObject.GetValue<string>('FAM_HABILITADA', '');
        qry.ParamByName('filtrorfp').AsString := jsonObject.GetValue<string>('Filtro RFP', '');
        qry.ParamByName('Registros').AsString := jsonObject.GetValue<string>('Registros', '');
        qry.ParamByName('Fornecedor').AsString := jsonObject.GetValue<string>('Fornecedor', '');
        qry.ParamByName('TypeSite').AsString := jsonObject.GetValue<string>('TypeSite', '');
        qry.ParamByName('OfensorAtual').AsString := jsonObject.GetValue<string>('Ofensor Atual', '');
        qry.ParamByName('Atrasado').AsString := jsonObject.GetValue<string>('Atrasado', '');
        qry.ParamByName('JustificativaSLAInstalacao').AsString := jsonObject.GetValue<string>('Justificativa SLA de Instalação', '');
        qry.ParamByName('JaFoiParalisadaPorHSE').AsString := jsonObject.GetValue<string>('Já foi paralisada por HSE', '');
        qry.ParamByName('InstalacaoParalisadas').AsString := jsonObject.GetValue<string>('InstalacaoParalisadas', '');
        qry.ParamByName('StatusObra').AsString := jsonObject.GetValue<string>('Status Obra', '');
        qry.ParamByName('ExistePendencia').AsString := jsonObject.GetValue<string>('Existe Pendencia', '');
        qry.ParamByName('DetalheStatus').AsString := jsonObject.GetValue<string>('Detalhe do Status', '');
        qry.ParamByName('RSAAtrasado').AsString := jsonObject.GetValue<string>('RSA Atrasado', '');
        qry.ParamByName('StatusRSA').AsString := jsonObject.GetValue<string>('Status RSA', '');
        qry.ParamByName('statusdoc').AsString := jsonObject.GetValue<string>('Status DOC', '');
        qry.ParamByName('PendenciasObra').AsString := jsonObject.GetValue<string>('PendenciasObra', '');
        qry.ParamByName('TextoSydle').AsString := jsonObject.GetValue<string>('Texto Sydle', '');
        qry.ParamByName('ProgressoObra').AsString := jsonObject.GetValue<string>('Progresso (Obra)', '');
        qry.ParamByName('ProgressoRSA').AsString := jsonObject.GetValue<string>('Progresso RSA', '');

        if jsonObject.TryGetValue<Int64>('Qtd. Rejeitado', intValue) then
        begin
          qry.ParamByName('QtdRejeitado').DataType := ftInteger;  // Especificando o tipo
          qry.ParamByName('QtdRejeitado').AsInteger := intValue
        end
        else
        begin
          qry.ParamByName('QtdRejeitado').DataType := ftInteger;  // Especificando o tipo
          qry.ParamByName('QtdRejeitado').Clear;
        end;

        if jsonObject.TryGetValue<Int64>('Ageing MOS - Doc Entregue', intValue) then
        begin
          qry.ParamByName('AgeingMOSDocEntregue').DataType := ftInteger;  // Especificando o tipo
          qry.ParamByName('AgeingMOSDocEntregue').AsInteger := intValue
        end
        else
        begin
          qry.ParamByName('AgeingMOSDocEntregue').DataType := ftInteger;  // Especificando o tipo
          qry.ParamByName('AgeingMOSDocEntregue').Clear;
        end;

        if jsonObject.TryGetValue<Int64>('Ageing MOS - Doc Aprovada', intValue) then
          qry.ParamByName('AgeingMOSDocAprovada').AsInteger := intValue
        else
        begin
          qry.ParamByName('AgeingMOSDocAprovada').DataType := ftInteger;  // Especificando o tipo
          qry.ParamByName('AgeingMOSDocAprovada').Clear;
        end;

        if jsonObject.TryGetValue<Int64>('SLA_Escopo', intValue) then
          qry.ParamByName('SLA_Escopo').AsInteger := intValue
        else
        begin
          qry.ParamByName('SLA_Escopo').DataType := ftInteger;  // Especificando o tipo
          qry.ParamByName('SLA_Escopo').Clear;
        end;

      // Para "Ageing Instalação"
        if jsonObject.TryGetValue<Int64>('Ageing Instalação', intValue) then
        begin
          qry.ParamByName('AgeingInstalacao').AsInteger := intValue;
        end
        else
        begin
          qry.ParamByName('AgeingInstalacao').DataType := ftInteger; // Especificando tipo de dado
          qry.ParamByName('AgeingInstalacao').Clear;
        end;

      // Para "Ageing Instalação Liquido"
        if jsonObject.TryGetValue<Int64>('Ageing Instalação Liquido', intValue) then
        begin
          qry.ParamByName('AgeingInstalacaoLiquido').AsInteger := intValue;
        end
        else
        begin
          qry.ParamByName('AgeingInstalacaoLiquido').DataType := ftInteger; // Especificando tipo de dado
          qry.ParamByName('AgeingInstalacaoLiquido').Clear;
        end;

      // Para "Tempo Paralisação Instalação"
        if jsonObject.TryGetValue<Int64>('Tempo Paralisação Instalação', intValue) then
        begin
          qry.ParamByName('TempoParalisacaoInstalacao').DataType := ftInteger;
          qry.ParamByName('TempoParalisacaoInstalacao').AsInteger := intValue;
        end
        else
        begin
          qry.ParamByName('TempoParalisacaoInstalacao').DataType := ftInteger;
          qry.ParamByName('TempoParalisacaoInstalacao').Clear;
        end;


        // 🔹 Processamento de campos de data
        ProcessarCampoData(jsonObject, 'Criação da Demanda', 'CriacaoDemanda', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Baseline MOS', 'BaselineMOS', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'MOS Plan', 'MOSPlan', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'MOS Real', 'MOSReal', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Baseline Fim Instalação', 'BaselineFimInstalacao', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Fim Instalação Plan', 'FimInstalacaoPlan', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Fim Instalação Real', 'FimInstalacaoReal', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Integração Real', 'IntegracaoReal', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Validação da Instalação', 'ValidacaoInstalacao', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Baseline Integração', 'BaselineIntegracao', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Integração Plan', 'IntegracaoPlan', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Integração Confirmada', 'IntegracaoConfirmada', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'FIM_DE_OBRA PLAN', 'FIMDEOBRAPLAN', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'FIM_DE_OBRA REAL', 'FIMDEOBRA_REAL', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Site Apto para Aceitação Baseline', 'SiteAptoAceitacaoBaseline', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Site Apto para Aceitação Plan', 'SiteAptoAceitacaoPlan', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Site Apto para Aceitação', 'SiteAptoAceitacao', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'TX', 'TX', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'ACK HW', 'ACK_HW', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'INFRA', 'INFRA', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data último progresso (RSA)', 'DataUltimoProgressoRSA', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Postagem 100% Doc.', 'Postagem100Doc', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Aprovação todos Docs.', 'AprovacaoTodosDocs', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Aceitação Final', 'aceitacaofical', qry, formatSettings);

        // 🔹 Executa a inserção
        qry.ExecSQL;
      end;

      // 🔹 Finaliza a transação
      FConn.Commit;
      Result := jsonData.Count;

    except
      on E: Exception do
      begin
        erro := 'Erro ao inserir dados na linha ' + IntToStr(i + 1) + ': ' + E.Message;
        FConn.Rollback;
        Result := 0;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TUpload.InserirAtualizaObraDocumentacaoObraFinal(const jsonData: TJSONArray; out erro: string): Integer;
var
  qry: TFDQuery;
  i: Int64;
  jsonObject: TJSONObject;
  poStr: string;
  tempDateTime: TDateTime;
  formatSettings: TFormatSettings;
  intValue: Integer;
procedure SafeGetJSONValue(jsonObj: TJSONObject; const fieldName: string; param: TFDParam; fieldType: TFieldType);
begin
  try
    if jsonObj.TryGetValue(fieldName, poStr) then
    begin
      if (poStr = '') or (poStr = 'null') then
      begin
        param.Clear;
        param.DataType := fieldType;
      end
      else
      begin
        param.DataType := fieldType;
        param.Value := poStr;
      end;
    end
    else
    begin
      param.Clear;
      param.DataType := fieldType;
    end;
  except
    param.Clear;
    param.DataType := fieldType;
  end;
end;

procedure ProcessarCampoData(jsonObj: TJSONObject; const jsonField, dbField: string; qry: TFDQuery; formatSettings: TFormatSettings);
var
  tempStr: string;
  tempDate: TDateTime;
begin
  if jsonObj.TryGetValue<string>(jsonField, tempStr) and (tempStr <> '') then
  begin
    if TryStrToDateTime(tempStr, tempDate, formatSettings) then
      qry.ParamByName(dbField).AsDateTime := tempDate
    else
      qry.ParamByName(dbField).Clear;
  end
  else
    qry.ParamByName(dbField).Clear;
  qry.ParamByName(dbField).DataType := ftDateTime;
end;
begin
  Result := 0;
  erro := '';

  if (jsonData = nil) or (jsonData.Count = 0) then
  begin
    erro := 'JSON vazio ou inválido.';
    Exit;
  end;

  if not Assigned(FConn) then
  begin
    erro := 'Conexão com o banco de dados não foi inicializada.';
    Exit;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    FConn.StartTransaction;
    try
      qry.SQL.Text := 'DELETE FROM atualizaobradocumentacaoobrafinal';
      qry.ExecSQL;
      FConn.Commit;
      qry.SQL.Clear;

      formatSettings := TFormatSettings.Create;
      formatSettings.ShortDateFormat := 'dd/mm/yyyy'; // Alterado para o formato do JSON
      formatSettings.DateSeparator := '/';
      formatSettings.ShortTimeFormat := 'hh:nn:ss';
      formatSettings.TimeSeparator := ':';

      for i := 0 to jsonData.Count - 1 do
      begin
        jsonObject := jsonData.Items[i] as TJSONObject;
        if jsonObject = nil then
          Continue;

        qry.SQL.Clear;
        qry.SQL.Add('INSERT INTO atualizaobradocumentacaoobrafinal (numero, TipoDocumento, RegionalNome, Site, Cliente, FornecedorNome, ');
        qry.SQL.Add('DocumentacaoDocumentosSituacao, DocumentacaoSituacaoValidacao, DatadaPostagem, DocumentacaoDataultimaValidacao, ');
        qry.SQL.Add('DocumentacaoSituacao, RFPNome, DocumentacaoDocumentoMotivorejeicao, MOSReportadoDia, FimInstalacaoReportadodia, ');
        qry.SQL.Add('DataValidacaoERIBOXDia, DatalimitepostagemMOSdia, DatalimitepostagemInstalacaodia, DatalimitepostagemIntegracaodia, ');
        qry.SQL.Add('StatusRSA, SituacaoImplantacao) ');
        qry.SQL.Add('VALUES (:numero, :TipoDocumento, :RegionalNome, :Site, :Cliente, :FornecedorNome, ');
        qry.SQL.Add(':DocumentacaoDocumentosSituacao, :DocumentacaoSituacaoValidacao, :DatadaPostagem, :DocumentacaoDataultimaValidacao, ');
        qry.SQL.Add(':DocumentacaoSituacao, :RFPNome, :DocumentacaoDocumentoMotivorejeicao, :MOSReportadoDia, :FimInstalacaoReportadodia, ');
        qry.SQL.Add(':DataValidacaoERIBOXDia, :DatalimitepostagemMOSdia, :DatalimitepostagemInstalacaodia, :DatalimitepostagemIntegracaodia, ');
        qry.SQL.Add(':StatusRSA, :SituacaoImplantacao)');

        // Mapeamento de parâmetros com tratamento de erros
        SafeGetJSONValue(jsonObject, 'Número', qry.ParamByName('numero'), ftInteger);
        SafeGetJSONValue(jsonObject, 'Tipo do Documento', qry.ParamByName('TipoDocumento'), ftString);
        SafeGetJSONValue(jsonObject, 'Regional > Nome', qry.ParamByName('RegionalNome'), ftString);
        SafeGetJSONValue(jsonObject, 'Site', qry.ParamByName('Site'), ftString);
        SafeGetJSONValue(jsonObject, 'Cliente', qry.ParamByName('Cliente'), ftString);
        SafeGetJSONValue(jsonObject, 'Fornecedor > Nome', qry.ParamByName('FornecedorNome'), ftString);
        SafeGetJSONValue(jsonObject, 'Documentação > Documentos > Situação', qry.ParamByName('DocumentacaoDocumentosSituacao'), ftString);
        SafeGetJSONValue(jsonObject, 'Documentação > Situação da Validação', qry.ParamByName('DocumentacaoSituacaoValidacao'), ftString);

        // Tratamento especial para datas
        ProcessarCampoData(jsonObject, 'Data da Postagem', 'DatadaPostagem', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Documentação > Data da Última Validação (Data e hora)', 'DocumentacaoDataultimaValidacao', qry, formatSettings);

        SafeGetJSONValue(jsonObject, 'Documentação > Situação', qry.ParamByName('DocumentacaoSituacao'), ftString);
        SafeGetJSONValue(jsonObject, 'RFP > Nome', qry.ParamByName('RFPNome'), ftString);
        SafeGetJSONValue(jsonObject, 'Documentação > Documentos > Motivo da rejeição', qry.ParamByName('DocumentacaoDocumentoMotivorejeicao'), ftString);

        ProcessarCampoData(jsonObject, 'MOS - Reportado (Dia)', 'MOSReportadoDia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Fim Instalação - Reportado (Dia)', 'FimInstalacaoReportadodia', qry, formatSettings);
        ProcessarCampoData(jsonObject, 'Data de Validação ERIBOX (Dia)', 'DataValidacaoERIBOXDia', qry, formatSettings);

        SafeGetJSONValue(jsonObject, 'Data limite postagem - MOS (Dia)', qry.ParamByName('DatalimitepostagemMOSdia'), ftString);
        SafeGetJSONValue(jsonObject, 'Data limite postagem - Instalação (Dia)', qry.ParamByName('DatalimitepostagemInstalacaodia'), ftString);
        SafeGetJSONValue(jsonObject, 'Data limite postagem - Integração (Dia)', qry.ParamByName('DatalimitepostagemIntegracaodia'), ftString);
        SafeGetJSONValue(jsonObject, 'Status RSA', qry.ParamByName('StatusRSA'), ftString);
        SafeGetJSONValue(jsonObject, 'Situação Implantação', qry.ParamByName('SituacaoImplantacao'), ftString);

        qry.ExecSQL;
      end;

      FConn.Commit;
      Result := jsonData.Count;

    except
      on E: Exception do
      begin
        erro := 'Erro ao inserir dados na linha ' + IntToStr(i + 1) + ': ' + E.Message;
        Writeln(erro);
        FConn.Rollback;
        Result := 0;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TUpload.EditarT2(const Dados: TJSONObject; const periodo: String; out erro: string): Integer;
var
  qry: TFDQuery;
  FConn: TFDConnection;
  idObra, operacao: string;
  resultados: TJSONArray;

  function GetStr(const key: string): string;
  var
    v: TJSONValue;
  begin
    try
      v := Dados.GetValue(key);
      if (v <> nil) and not v.Null then
        Result := v.Value.Trim
      else
        Result := '';
    except
      Result := '';
    end;
  end;

  function GetFloat(const key: string): Double;
  var
    s: string;
    v: TJSONValue;
    fs: TFormatSettings;
  begin
    try
      fs := TFormatSettings.Create;
      fs.DecimalSeparator := ',';
      fs.ThousandSeparator := '.';

      v := Dados.GetValue(key);

      if (v = nil) or v.Null or (v.Value.Trim = '""') or (v.Value.Trim = '') then
        Exit(0.0);

      s := v.Value.Trim;

      // Remove aspas se existirem
      if (s.Length > 1) and (s.Chars[0] = '"') and (s.Chars[s.Length - 1] = '"') then
        s := s.Substring(1, s.Length - 2);

      s := s.Replace('.', '', [rfReplaceAll]);

      if not TryStrToFloat(s, Result, fs) then
        Result := 0.0;
    except
      Result := 0.0;
    end;
  end;

  function GetInt(const key: string): Integer;
  begin
    try
      Result := StrToIntDef(GetStr(key), 0);
    except
      Result := 0;
    end;
  end;

begin
  Result := 0;
  erro := '';
  resultados := TJSONArray.Create;
  qry := nil;
  FConn := nil;
  operacao := '';

  try
    try
      if Dados = nil then
      begin
        erro := 'Dados não informados.';
        Exit;
      end;

      idObra := GetStr('ID OBRA');
      if idObra = '' then
      begin
        erro := 'ID OBRA não informado';
        Exit;
      end;

      qry := TFDQuery.Create(nil);
      FConn := TConnection.CreateConnection;

      // Configurações adicionais para evitar problemas de rede
      FConn.ResourceOptions.SilentMode := True;
      FConn.ResourceOptions.AutoConnect := False;

      qry.Connection := FConn;

      // Testa a conexão antes de iniciar transação
      try
        FConn.Connected := True;
      except
        on E: Exception do
        begin
          erro := 'Erro ao conectar com o banco: ' + E.Message;
          Exit;
        end;
      end;

      FConn.StartTransaction;

      try
        qry.SQL.Text := 'SELECT COUNT(*) FROM telefonicacontrolet2 WHERE site = :site AND empresa = :empresa AND T2CODMATSERVSW = :codmat AND T2DESCRICAOCOD = :descmat';
        qry.ParamByName('empresa').AsString := GetStr('EMPRESA');
        qry.ParamByName('site').AsString := GetStr('SITE');
        qry.ParamByName('codmat').AsString := GetStr('T2 - COD MAT_SERV_SW');
        qry.ParamByName('descmat').AsString := GetStr('T2 - DESCRIÇÃO COD');

        qry.Open;

        if qry.Fields[0].AsInteger > 0 then
        begin
          operacao := 'UPDATE';
          qry.Close;
          qry.SQL.Text :=
            'UPDATE telefonicacontrolet2 SET ' +
            'ITEMT2 = :itemt2, CODFORNECEDOR = :codfornecedor, ' +
            'FABRICANTE = :fabricante, NUMERODOCONTRATO = :contrato, ' +
            'VLRUNITARIOLIQLIQ = :vlrliqliq, VLRUNITARIOLIQ = :vlrliq, ' +
            'QUANT = :quant, UNID = :unid, VLRUNITARIOCIMPOSTO = :vlrcimp, VLRCIMPSICMS = :vlrsicms, ' +
            'VLRTOTALCIMPOSTOS = :vlrtotal, ITEMT4 = :itemt4, T4CODEQMATSWSERV = :t4cod, ' +
            'T4DESCRICAOCOD = :t4desc, PEPNIVEL2 = :pep2, IDLOCALIDADE = :idlocal, ' +
            'PEPNIVEL3 = :pep3, DESCRICAOOBRA = :descobra, GESTOR = :gestor, TIPO = :tipo, ' +
            'RESPONSAVEL = :resp, idobra = :idobra, Categoria = :cat, TECNOLOGIA = :tec, T2APROVADO = :aprovado, ' +
            'statusfaturamento = :statusfaturamento ' +
            'WHERE site = :site AND empresa = :empresa AND T2CODMATSERVSW = :codmat AND T2DESCRICAOCOD = :descmat';
        end
        else
        begin
          operacao := 'INSERT';
          qry.Close;
          qry.SQL.Text :=
            'INSERT INTO telefonicacontrolet2 (' +
            'site, empresa, T2CODMATSERVSW, T2DESCRICAOCOD, ITEMT2, ' +
            'CODFORNECEDOR, FABRICANTE, NUMERODOCONTRATO, VLRUNITARIOLIQLIQ, ' +
            'VLRUNITARIOLIQ, QUANT, UNID, VLRUNITARIOCIMPOSTO, VLRCIMPSICMS, ' +
            'VLRTOTALCIMPOSTOS, ITEMT4, T4CODEQMATSWSERV, T4DESCRICAOCOD, ' +
            'PEPNIVEL2, IDLOCALIDADE, PEPNIVEL3, DESCRICAOOBRA, GESTOR, TIPO, ' +
            'RESPONSAVEL, idobra, Categoria, TECNOLOGIA, T2APROVADO, ' +
            'statusfaturamento) VALUES (' +
            ':site, :empresa, :codmat, :descmat, :itemt2, ' +
            ':codfornecedor, :fabricante, :contrato, :vlrliqliq, ' +
            ':vlrliq, :quant, :unid, :vlrcimp, :vlrsicms, ' +
            ':vlrtotal, :itemt4, :t4cod, :t4desc, ' +
            ':pep2, :idlocal, :pep3, :descobra, :gestor, :tipo, ' +
            ':resp, :idobra, :cat, :tec, :aprovado, ' +
            ':statusfaturamento)';
        end;

        qry.ParamByName('itemt2').AsInteger := GetInt('ITEM T2');
        qry.ParamByName('codfornecedor').AsString := GetStr('CÓD. FORNECEDOR');
        qry.ParamByName('fabricante').AsString := GetStr('FABRICANTE');
        qry.ParamByName('contrato').AsString := GetStr('NÚMERO DO CONTRATO');
        qry.ParamByName('empresa').AsString := GetStr('EMPRESA');
        qry.ParamByName('site').AsString := GetStr('SITE');
        qry.ParamByName('codmat').AsString := GetStr('T2 - COD MAT_SERV_SW');
        qry.ParamByName('descmat').AsString := GetStr('T2 - DESCRIÇÃO COD');
        qry.ParamByName('vlrliqliq').AsFloat := GetFloat('VLR_UNITARIO LIQLIQ');
        qry.ParamByName('vlrliq').AsFloat := GetFloat('VLR UNITÁRIO LIQ');
        qry.ParamByName('quant').AsFloat := GetFloat('QUANT');
        qry.ParamByName('unid').AsString := GetStr('UNID');
        qry.ParamByName('vlrcimp').AsFloat := GetFloat('VLR UNITÁRIO C/ IMPOSTO');
        qry.ParamByName('vlrsicms').AsFloat := GetFloat('VLR C_IMP S_ICMS');
        qry.ParamByName('vlrtotal').AsFloat := GetFloat('VLR TOTAL C_IMPOSTOS');
        qry.ParamByName('itemt4').AsString := GetStr('ITEM T4');
        qry.ParamByName('t4cod').AsString := GetStr('T4 - COD EQ_MAT_SW_SERV');
        qry.ParamByName('t4desc').AsString := GetStr('T4 - DESCRIÇÃO COD');
        qry.ParamByName('pep2').AsString := GetStr('PEP NÍVEL 2');
        qry.ParamByName('idlocal').AsString := GetStr('ID LOCALIDADE');
        qry.ParamByName('pep3').AsString := GetStr('PEP NÍVEL 3');
        qry.ParamByName('descobra').AsString := GetStr('DESCRIÇÃO DA OBRA');
        qry.ParamByName('idobra').AsString := idObra;
        qry.ParamByName('gestor').AsString := GetStr('GESTOR');
        qry.ParamByName('tipo').AsString := GetStr('TIPO (Hardware; Software; Serviço; Material)');
        qry.ParamByName('resp').AsString := GetStr('SCIENCE - NOME');
        qry.ParamByName('cat').AsString := GetStr('CATEGORIA');
        qry.ParamByName('tec').AsString := GetStr('TECNOLOGIA');
        qry.ParamByName('aprovado').AsString := GetStr('SCIENCE - SITUAÇÃO');
        qry.ParamByName('statusfaturamento').AsString := 'Retorno T2';

        qry.ExecSQL;
        Result := 1;

        resultados.Add(TJSONObject.Create
          .AddPair('status', 'sucesso')
          .AddPair('operacao', operacao)
          .AddPair('id_obra', idObra)
          .AddPair('periodo', periodo));

        FConn.Commit;
        erro := resultados.ToString;

      except
        on E: Exception do
        begin
          if FConn.InTransaction then
            FConn.Rollback;

          erro := 'Erro ao ' + operacao + ' T2: ' + E.Message;
          Result := 0;
          Writeln('ERRO: ' + erro);
        end;
      end;
    except
      on E: Exception do
      begin
        erro := 'Erro geral: ' + E.Message;
        Result := 0;
        Writeln('ERRO GERAL: ' + erro);
      end;
    end;
  finally
    if Assigned(qry) then
      qry.Free;

    if Assigned(FConn) then
    begin
      if FConn.Connected then
      begin
        if FConn.InTransaction then
          FConn.Rollback;
        FConn.Connected := False;
      end;
      FConn.Free;
    end;

    resultados.Free;
  end;
end;


function TUpload.EditarT4(const Dados: TJSONObject; const periodo: String; out erro: string): Integer;
var
  qry: TFDQuery;
  FConn: TFDConnection;
  idPedidoComprador, comentariosFornecedor, status, pepNivel3: string;
  resultados: TJSONArray;

  function GetStr(const key: string): string;
  var
    v: TJSONValue;
  begin
    v := Dados.GetValue(key);
    if (v <> nil) and not v.Null then
      Result := v.Value.Trim
    else
      Result := '';
  end;

function ExtrairPEPNivel3(const texto: string): string;
  var
    posInicio, posFim: Integer;
  begin
    // Procura por "Elemento Pep: " e pega o valor após
    posInicio := Pos('Elemento Pep:', texto);
    if posInicio > 0 then
    begin
      posInicio := posInicio + Length('Elemento Pep:');
      posFim := Length(texto);
      // Pega o texto restante e remove espaços extras
      Result := Trim(Copy(texto, posInicio, posFim - posInicio + 1));
    end
    else
      Result := '';
  end;

begin
  Result := 0;
  erro := '';
  resultados := TJSONArray.Create;
  qry := nil;
  FConn := nil;

  try
    // Validação inicial
    if Dados = nil then
    begin
      erro := 'Dados JSON não informados.';
      Exit;
    end;

    // Extrai valores do JSON
    status := GetStr('STATUS');
    idPedidoComprador := GetStr('ID. PEDIDO COMPRADOR');
    comentariosFornecedor := GetStr('COMENTÁRIOS SOBRE FORNECEDOR');

    // Extrai o PEP Nível 3 dos comentários
    pepNivel3 := ExtrairPEPNivel3(comentariosFornecedor);

    if pepNivel3 = '' then
    begin
      erro := 'Não foi possível identificar o PEP Nível 3 nos comentários';
      Exit;
    end;

    // Verifica se o status é ACEITADO
    if not SameText(status, 'ACEITADO') then
    begin
      erro := 'Status não é ACEITADO';
      Exit;
    end;

    // Criação dos objetos de banco de dados
    qry := TFDQuery.Create(nil);
    FConn := TConnection.CreateConnection;
    qry.Connection := FConn;

    FConn.StartTransaction;

    try
      // Atualiza o PO na tabela telefonicacontrolet2
      qry.SQL.Text :=
        'UPDATE telefonicacontrolet2 SET ' +
        'PO = :po, ' +
        'statusfaturamento = ''Retorno T4'', ' +
        'datafaturamento = CURRENT_TIMESTAMP ' +
        'WHERE PEPNIVEL3 = :pepNivel3';

      qry.ParamByName('po').AsString := idPedidoComprador;
      qry.ParamByName('pepNivel3').AsString := pepNivel3;

      qry.ExecSQL;

      // Verifica se alguma linha foi afetada
      if qry.RowsAffected = 0 then
      begin
        erro := 'Nenhum registro encontrado com o PEP Nível 3: ' + pepNivel3;
        FConn.Rollback;
        Exit;
      end;

      // Cria resultado em JSON
      resultados.Add(TJSONObject.Create
        .AddPair('status', 'sucesso')
        .AddPair('registros_afetados', TJSONNumber.Create(qry.RowsAffected))
        .AddPair('id_pedido_comprador', idPedidoComprador)
        .AddPair('pep_nivel3', pepNivel3));

      FConn.Commit;
      Result := qry.RowsAffected;
      erro := resultados.ToString;

    except
      on E: Exception do
      begin
        if FConn <> nil then
          FConn.Rollback;

        erro := 'Erro ao atualizar PO: ' + E.Message;
        Writeln(erro);
        Result := 0;
      end;
    end;

  finally
    // Liberação de recursos
    if qry <> nil then
      qry.Free;

    if FConn <> nil then
      FConn.Free;

    resultados.Free;
  end;
end;
end.


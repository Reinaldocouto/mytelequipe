unit UtFuncao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Horse,
  System.JSON, DataSet.Serialize,
  System.Generics.Collections, System.IOUtils,
  ComObj, ActiveX, StrUtils,  System.RegularExpressions;

function VersaoExe: string;

function CreateJsonObj(pairName: string; value: string): TJSONObject; overload;

function CreateJsonObj(pairName: string; value: integer): TJSONObject; overload;

function CreateJsonObj(pairName: string; value: double): TJSONObject; overload;

function StrIsint(const S: string): Boolean;

function StrIsdouble(const S: string): Boolean;

function limpaaspas(texto: string): string;

function ApenasNumerosStr(pStr: String): String;

function LerExcelParaJSON(const vXLSFile: string): TJSONArray;

function LerExcelParaJSONGEFolhaDePagamento(const vXLSFile: string): TJSONArray;

function RetZero(ZEROS: string; QUANT: Integer): String;

function LerCSVParaJSON(const vCSVFile: string; Delimitador: Char = ';'): TJSONArray;

function LerExcelParaJSONGETICKET(const vXLSFile: string): TJSONArray;

function LerExcelParaJSONValeTransporte(const vXLSFile: string): TJSONArray;
function LerExcelParaJSONSemTotal(const vXLSFile: string): TJSONArray;
function LerExcelParaJSONMonitoramento(const vXLSFile: string): TJSONArray;
function LerExcelParaJSONLpuValidar(const vXLSFile: string): TJSONArray;
function ISO8601ToDate(const ISO8601Str: string): TDateTime;
function ForcarLiberacaoArquivo(const nomeArquivo: string): Boolean;



procedure Registry;

procedure agora(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure LogError(const Msg: string);


implementation

procedure Registry;
begin
  THorse.get('v1/agora', agora);
end;

function RetZero(ZEROS: string; QUANT: Integer): String;
var
    I, Tamanho: Integer;
    aux: string;
begin
    aux := ZEROS;
    Tamanho := length(ZEROS);
    ZEROS := '';
    for I := 1 to QUANT - Tamanho do
        ZEROS := ZEROS + '0';
    aux := ZEROS + aux;
    RetZero := aux;
end;

function ApenasNumerosStr(pStr: String): String;
Var
    I: Integer;
begin
    Result := '';
    For I := 1 To length(pStr) do
        If pStr[I] In ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'] Then
            Result := Result + pStr[I];
end;



function limpaaspas(texto: string): string;
var
  textoOriginal, textoSemColchetes: string;
begin
  textoOriginal := texto;
  textoSemColchetes := StringReplace(textoOriginal, '''', '', [rfReplaceAll]);
  textoSemColchetes := StringReplace(textoSemColchetes, '''', '', [rfReplaceAll]);
  Result := textoSemColchetes; // Exibe: "Exemplo de texto com aspas"
end;

procedure agora(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  data: TDateTime;
  formatada: string;
begin
  try
  // vamos obter a data de hoje
    data := Now;

  // vamos formatar
    formatada := FormatDateTime('yyyy-mm-dd', data);

  // vamos exibir o resultado
    Res.Send<TJSONObject>(CreateJsonObj('agora', formatada)).Status(THTTPStatus.OK);
  except
    on ex: exception do
      Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
  end;

end;

function StrIsint(const S: string): Boolean;
begin
  try
    StrToint(S);
    Result := true;
  except
    Result := False;
  end;
end;

function StrIsdouble(const S: string): Boolean;
begin
  try
    StrTofloat(S);
    Result := true;
  except
    Result := False;
  end;
end;

function soNumero(const S: string): string;
var
  vText : PChar;
begin
  vText := PChar(S);
  Result := '';

  while (vText^ <> #0) do
  begin
    {$IFDEF UNICODE}
    if CharInSet(vText^, ['0'..'9']) then
    {$ELSE}
    if vText^ in ['0'..'9'] then
    {$ENDIF}
      Result := Result + vText^;

    Inc(vText);
  end;
end;

function VersaoExe: string;
type
  PFFI = ^vs_FixedFileInfo;
var
  F: PFFI;
  Handle: Dword;
  Len: Longint;
  Data: Pchar;
  Buffer: Pointer;
  Tamanho: Dword;
  Parquivo: Pchar;
  Arquivo: string;
begin
  Arquivo := Application.ExeName;
  Parquivo := StrAlloc(Length(Arquivo) + 1);
  StrPcopy(Parquivo, Arquivo);
  Len := GetFileVersionInfoSize(Parquivo, Handle);
  Result := '';
  if Len > 0 then
  begin
    Data := StrAlloc(Len + 1);
    if GetFileVersionInfo(Parquivo, Handle, Len, Data) then
    begin
      VerQueryValue(Data, '\', Buffer, Tamanho);
      F := PFFI(Buffer);
      Result := Format('%d.%d.%d.%d', [HiWord(F^.dwFileVersionMs), LoWord(F^.dwFileVersionMs), HiWord(F^.dwFileVersionLs), LoWord(F^.dwFileVersionLs)]);
    end;
    StrDispose(Data);
  end;
  StrDispose(Parquivo);
end;

function CreateJsonObj(pairName: string; value: string): TJSONObject;
begin
  Result := TJSONObject.Create(TJSONPair.Create(pairName, value));
end;

function CreateJsonObj(pairName: string; value: integer): TJSONObject;
begin
  Result := TJSONObject.Create(TJSONPair.Create(pairName, TJSONNumber.Create(value)));
end;

function CreateJsonObj(pairName: string; value: double): TJSONObject;
begin
  Result := TJSONObject.Create(TJSONPair.Create(pairName, TJSONNumber.Create(value)));
end;

procedure LogError(const Msg: string);
var
  logFile: TextFile;
  logPath: string;
begin
  logPath := ExtractFilePath(ParamStr(0)) + 'error.log';

  AssignFile(logFile, logPath);
  try
    if FileExists(logPath) then
      Append(logFile)
    else
      Rewrite(logFile);

    WriteLn(logFile, FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + ' - ' + Msg);
  finally
    CloseFile(logFile);
  end;
end;

function LerExcelParaJSONGETICKET(const vXLSFile: string): TJSONArray;
var
  vExcelApp, vWorkbook, vSheet: OleVariant;
  j, k, ColCount, RowCount, HeaderRow: Integer;
  jsonArray: TJSONArray;
  jsonRow: TJSONObject;
  ColHeaders: array of string;
  cellValue: Variant;
  competencia, observacao, tipo, valorTotal, desconto, dias: string;
  mesNome, anoStr, mesNum, headerValue: string;
  espacos: TArray<string>;
  isEmpty: Boolean;
begin
  jsonArray := TJSONArray.Create;
  CoInitialize(nil);

  try
    vExcelApp := CreateOleObject('Excel.Application');
    vExcelApp.Visible := False;
    vExcelApp.DisplayAlerts := False;

    try
      vWorkbook := vExcelApp.Workbooks.Open(vXLSFile);
      vSheet := vWorkbook.Sheets[1];

      RowCount := vSheet.UsedRange.Rows.Count;
      ColCount := vSheet.UsedRange.Columns.Count;

      // Tenta localizar automaticamente o cabeçalho
      HeaderRow := 0;
      for j := 1 to RowCount do
      begin
        if VarToStr(vSheet.Cells[j, 2].Value) = 'COD' then
        begin
          HeaderRow := j;
          Break;
        end;
      end;

      if HeaderRow = 0 then
        raise Exception.Create('Cabeçalho com "COD" não encontrado.');

      SetLength(ColHeaders, ColCount);

      headerValue := VarToStr(vSheet.Cells[7, 5].Value);
      headerValue := Trim(StringReplace(headerValue, 'DESCONTAR FOLHA', '', [rfIgnoreCase, rfReplaceAll]));
      espacos := headerValue.Split([' ']);
      if Length(espacos) = 2 then
      begin
        mesNome := LowerCase(espacos[0]);
        anoStr := espacos[1];
        mesNum :=
          IfThen(mesNome = 'janeiro', '01',
          IfThen(mesNome = 'fevereiro', '02',
          IfThen(mesNome = 'março', '03',
          IfThen(mesNome = 'abril', '04',
          IfThen(mesNome = 'maio', '05',
          IfThen(mesNome = 'junho', '06',
          IfThen(mesNome = 'julho', '07',
          IfThen(mesNome = 'agosto', '08',
          IfThen(mesNome = 'setembro', '09',
          IfThen(mesNome = 'outubro', '10',
          IfThen(mesNome = 'novembro', '11',
          IfThen(mesNome = 'dezembro', '12', '00'))))))))))));
        competencia := Format('%s-%s', [anoStr, mesNum]);
      end
      else
        competencia := '';

      // Lê cabeçalhos
      for k := 1 to ColCount do
      begin
        cellValue := vSheet.Cells[HeaderRow, k].Value;
        if not VarIsEmpty(cellValue) then
          ColHeaders[k - 1] := Trim(VarToStr(cellValue))
        else
          ColHeaders[k - 1] := Format('Coluna_%d', [k]);
      end;

      // Lê linhas de dados
      for j := HeaderRow + 1 to RowCount do
      begin
        jsonRow := TJSONObject.Create;
        try
          for k := 1 to ColCount do
          begin
            cellValue := vSheet.Cells[j, k].Value;
            if not VarIsEmpty(cellValue) then
              jsonRow.AddPair(ColHeaders[k - 1], Trim(VarToStr(cellValue)))
            else
              jsonRow.AddPair(ColHeaders[k - 1], TJSONNull.Create);
          end;

          // Regras específicas
          tipo := VarToStr(vSheet.Cells[j, 1].Value); // A
          valorTotal := VarToStr(vSheet.Cells[j, 4].Value); // D
          desconto := VarToStr(vSheet.Cells[j, 5].Value); // E
          dias := VarToStr(vSheet.Cells[j, 6].Value); // F

          observacao := '';
          if (Trim(dias) = '0') or (Trim(valorTotal) = '0,00') then
            observacao := 'Sem benefício no mês';
          if tipo = 'TR' then
          begin
            if observacao <> '' then
              observacao := observacao + ' | ';
            observacao := observacao + 'Tipo TR (ticket restaurante)';
          end;

          jsonRow.AddPair('Observação', observacao);
          jsonRow.AddPair('Competência', competencia);

          // Filtrar: exige COD e COLABORADOR
          if (jsonRow.GetValue('COD') = nil) or (Trim(jsonRow.GetValue('COD').Value) = '') or
             (jsonRow.GetValue('COLABORADOR') = nil) or (Trim(jsonRow.GetValue('COLABORADOR').Value) = '') then
          begin
            jsonRow.Free;
            Continue;
          end;

          jsonArray.AddElement(jsonRow);
        except
          on E: Exception do
          begin
            jsonRow.Free;
            Writeln('Erro na linha ', j, ': ', E.Message);
          end;
        end;
      end;

    finally
     // Liberação segura de recursos COM
      try
        if not VarIsEmpty(vWorkbook) and not VarIsNull(vWorkbook) then
        begin
          try
            vWorkbook.Close(False);
          except
            // Ignora erros ao fechar workbook
          end;
        end;
      except
        // Ignora erros de liberação
      end;

      try
        if not VarIsEmpty(vExcelApp) and not VarIsNull(vExcelApp) then
        begin
          try
            vExcelApp.Quit;
          except
            // Ignora erros ao fechar Excel
          end;
        end;
      except
        // Ignora erros de liberação
      end;
      vWorkbook := Unassigned;
      vSheet := Unassigned;
      vExcelApp := Unassigned;
    end;

  except
    on E: Exception do
    begin
      jsonArray.Free;
      raise Exception.Create('Erro ao abrir Excel: ' + E.Message);
    end;
  end;

  CoUninitialize;
  Result := jsonArray;
end;



function LerExcelParaJSONValeTransporte(const vXLSFile: string): TJSONArray;
var
  vExcelApp, vWorkbook, vSheet: OleVariant;
  j, k, ColCount, RowCount, HeaderRow: Integer;
  jsonArray: TJSONArray;
  jsonRow: TJSONObject;
  ColHeaders: array of string;
  cellValue: Variant;
  competencia, observacao, valorDia, dias, beneficio, desconto, empresa, tipo, descontoPercentual: string;
  headerValue,  day, month, year, formattedDate: string;
  espacos: TArray<string>;
begin
  jsonArray := TJSONArray.Create;
  CoInitialize(nil);

  try
    vExcelApp := CreateOleObject('Excel.Application');
    vExcelApp.Visible := False;
    vExcelApp.DisplayAlerts := False;

    try
      vWorkbook := vExcelApp.Workbooks.Open(vXLSFile);
      vSheet := vWorkbook.Sheets[1];

      RowCount := vSheet.UsedRange.Rows.Count;
      ColCount := vSheet.UsedRange.Columns.Count;

      // Localiza o cabeçalho pela célula "Código"
      HeaderRow := 0;
      for j := 1 to RowCount do
      begin
        if Trim(VarToStr(vSheet.Cells[j, 2].Value)) = 'Código' then
        begin
          HeaderRow := j;
          Break;
        end;
      end;

      if HeaderRow = 0 then
        raise Exception.Create('Cabeçalho não encontrado.');

      SetLength(ColHeaders, ColCount);

      // Lê cabeçalhos
      for k := 1 to ColCount do
      begin
        cellValue := vSheet.Cells[HeaderRow, k].Value;
        ColHeaders[k - 1] := Trim(VarToStr(cellValue));
      end;

      // Pega a competência
      headerValue := VarToStr(vSheet.Cells[5, 9].Value);
      headerValue := Trim(LowerCase(headerValue));
      day := Copy(headerValue, 1, 2);
      month := Copy(headerValue, 4, 2);
      year := Copy(headerValue, 7, 4);
      formattedDate := year + '-' + month;
      for j := HeaderRow + 1 to RowCount - 1 do
      begin
       if (Trim(VarToStr(vSheet.Cells[j, 2].Value)) = '') or (Trim(VarToStr(vSheet.Cells[j, 1].Value)) = '') then
        Continue;


        jsonRow := TJSONObject.Create;
        try
          jsonRow.AddPair('Codigo',       VarToStr(vSheet.Cells[j, 2].Value));
          jsonRow.AddPair('Colaborador',  VarToStr(vSheet.Cells[j, 3].Value));
          jsonRow.AddPair('Admissao',     VarToStr(vSheet.Cells[j, 4].Value));
          jsonRow.AddPair('Cargo',        VarToStr(vSheet.Cells[j, 5].Value));
          jsonRow.AddPair('CBO',          VarToStr(vSheet.Cells[j, 6].Value));
          jsonRow.AddPair('Projeto',      VarToStr(vSheet.Cells[j, 7].Value));
          jsonRow.AddPair('Valor dia',    VarToStr(vSheet.Cells[j, 8].Value));
          jsonRow.AddPair('Dias',         VarToStr(vSheet.Cells[j, 9].Value));
          jsonRow.AddPair('Beneficio',    VarToStr(vSheet.Cells[j, 10].Value));

          jsonRow.AddPair('Salario',VarToStr(vSheet.Cells[j, 12].Value));
          jsonRow.AddPair('Desconto',VarToStr(vSheet.Cells[j, 13].Value));
          jsonRow.AddPair('Empresa',      VarToStr(vSheet.Cells[j, 14].Value));
          jsonRow.AddPair('Obersavacao',      VarToStr(vSheet.Cells[j, 15].Value));
          jsonRow.AddPair('Competência',  formattedDate);

          // Regras para observação
          dias := VarToStr(vSheet.Cells[j, 9].Value);
          valorDia := VarToStr(vSheet.Cells[j, 8].Value);
          beneficio := VarToStr(vSheet.Cells[j, 10].Value);
          desconto := VarToStr(vSheet.Cells[j, 11].Value);
          empresa := VarToStr(vSheet.Cells[j, 12].Value);



          jsonArray.AddElement(jsonRow);
        except
          on E: Exception do
          begin
            jsonRow.Free;
            raise Exception.CreateFmt('Erro na linha %d: %s', [j, E.Message]);
          end;
        end;
      end;

    finally
      vWorkbook.Close(False);
      vExcelApp.Quit;
      vWorkbook := Unassigned;
      vSheet := Unassigned;
      vExcelApp := Unassigned;
    end;

  except
    on E: Exception do
    begin
      jsonArray.Free;
      raise Exception.Create('Erro ao processar planilha: ' + E.Message);
    end;
  end;

  CoUninitialize;
  Result := jsonArray;
end;



function LerExcelParaJSONGEFolhaDePagamento(const vXLSFile: string): TJSONArray;
var
  vExcelApp, vWorkbook, vSheet: OleVariant;
  j, k, ColCount, RowCount: Integer;
  jsonArray: TJSONArray;
  jsonRow: TJSONObject;
  ColHeaders: array of string;
  cellValue: Variant;
  competencia: string;
  HeaderMap: TDictionary<string, Integer>;
  baseName: string;
  count: Integer;
begin
  jsonArray := TJSONArray.Create;
  CoInitialize(nil);

  try
    vExcelApp := CreateOleObject('Excel.Application');
    vExcelApp.Visible := False;
    vExcelApp.DisplayAlerts := False;

    try
      vWorkbook := vExcelApp.Workbooks.Open(vXLSFile);
      vSheet := vWorkbook.Sheets[1];

      Writeln('📄 Arquivo Excel aberto com sucesso.');

      RowCount := vSheet.UsedRange.Rows.Count;
      ColCount := vSheet.UsedRange.Columns.Count;

      SetLength(ColHeaders, ColCount);
      HeaderMap := TDictionary<string, Integer>.Create;

      try
        // Lê os nomes das colunas na linha 3
        for k := 1 to ColCount do
        begin
          cellValue := vSheet.Cells[3, k].Value;

          if not VarIsNull(cellValue) and not VarIsEmpty(cellValue) and not VarIsError(cellValue) then
            baseName := Trim(VarToStr(cellValue))
          else
            baseName := Format('Coluna_%d', [k]);

          if HeaderMap.TryGetValue(baseName, count) then
          begin
            Inc(count);
            HeaderMap[baseName] := count; // ou HeaderMap.AddOrSetValue(baseName, count);
            ColHeaders[k - 1] := baseName + IntToStr(count);
          end
          else
          begin
            HeaderMap.Add(baseName, 1);
            ColHeaders[k - 1] := baseName;
          end;

        end;

        // Lê a competência da célula [1,2]
        competencia := Trim(VarToStr(vSheet.Cells[1, 2].Value));

        // Percorre cada linha a partir da linha 4
        for j := 4 to RowCount do
        begin
          jsonRow := TJSONObject.Create;
          try
            for k := 1 to ColCount do
            begin
              cellValue := vSheet.Cells[j, k].Value;

              if not VarIsNull(cellValue) and not VarIsEmpty(cellValue) and not VarIsError(cellValue) then
                jsonRow.AddPair(ColHeaders[k - 1], Trim(VarToStr(cellValue)))
              else
                jsonRow.AddPair(ColHeaders[k - 1], TJSONNull.Create);
            end;

            jsonRow.AddPair('Competência', competencia);

            // Verifica se a linha está totalmente vazia
            var isEmpty := True;
            for var pair in jsonRow do
            begin
              if not (pair.JsonValue is TJSONNull) then
              begin
                isEmpty := False;
                Break;
              end;
            end;

            if not isEmpty then
              jsonArray.AddElement(jsonRow)
            else
            begin
              LogError('⚠️ Linha ' + IntToStr(j) + ' vazia - descartada');
              jsonRow.Free;
            end;
          except
            on E: Exception do
            begin
              jsonRow.Free;
              LogError('❌ Erro processando linha ' + IntToStr(j) + ': ' + E.Message);
            end;
          end;
        end;

      finally
        HeaderMap.Free;
      end;

    finally
      vWorkbook.Close(False);
      vExcelApp.Quit;
      vWorkbook := Unassigned;
      vSheet := Unassigned;
      vExcelApp := Unassigned;
    end;

  except
    on E: Exception do
    begin
      Writeln('❌ Erro ao processar o Excel: ' + E.Message);
      jsonArray.Free;
      raise;
    end;
  end;

  CoUninitialize;
  Result := jsonArray;
end;

function LerExcelParaJSONLpuValidar(const vXLSFile: string): TJSONArray;
var
  vExcelApp, vWorkbook, vSheet: OleVariant;
  i, j, k, ColCount, RowCount, SheetCount: Integer;
  jsonArray: TJSONArray;
  jsonRow: TJSONObject;
  ColHeaders: array of string;
  cellValue, firstCellValue: Variant;
  CabecalhoPrimeiraCelula: string;

  function GetUniqueHeaderName(const BaseName: string; Index: Integer): string;
  var
    UniqueName: string;
    Counter: Integer;
    Exists: Boolean;
    idx: Integer;
  begin
    UniqueName := BaseName;
    Counter := 1;
    repeat
      Exists := False;
      for idx := 0 to Index - 1 do
      begin
        if SameText(ColHeaders[idx], UniqueName) then
        begin
          Exists := True;
          Inc(Counter);
          UniqueName := BaseName + '_' + IntToStr(Counter);
          Break;
        end;
      end;
    until not Exists;
    Result := UniqueName;
  end;

  function HeadersValid: Boolean;
  const
    RequiredHeaders: array[0..4] of string = (
      'REGIONAL',
      'NO. ZTE',
      'ITEM - Inglês',
      'ITEM - Portugues',
      'UNIT'
    );
  var
    h, i: Integer;
    found: Boolean;
  begin
    Result := True;
    for h := Low(RequiredHeaders) to High(RequiredHeaders) do
    begin
      found := False;
      for i := 0 to High(ColHeaders) do
      begin
        if SameText(RequiredHeaders[h], ColHeaders[i]) then
        begin
          found := True;
          Break;
        end;
      end;
      if not found then
      begin
        Writeln('❌ Cabeçalho obrigatório ausente: ' + RequiredHeaders[h]);
        Result := False;
        Exit;
      end;
    end;
  end;

begin
  jsonArray := TJSONArray.Create;
  CoInitialize(nil);

  try
    vExcelApp := CreateOleObject('Excel.Application');
    vExcelApp.Visible := False;
    vExcelApp.DisplayAlerts := False;

    try
      vWorkbook := vExcelApp.Workbooks.Open(vXLSFile);
      SheetCount := vWorkbook.Sheets.Count;

      for i := 1 to SheetCount do
      begin
        vSheet := vWorkbook.Sheets[i];
        CabecalhoPrimeiraCelula := VarToStr(vSheet.Cells[1, 1].Value).Trim;

        if SameText(CabecalhoPrimeiraCelula, 'REGIONAL') then
        begin
          RowCount := vSheet.UsedRange.Rows.Count;
          ColCount := vSheet.UsedRange.Columns.Count;
          SetLength(ColHeaders, ColCount);

          // Lê os cabeçalhos da primeira linha
          for k := 1 to ColCount do
          begin
            cellValue := vSheet.Cells[1, k].Value;
            if not VarIsNull(cellValue) and not VarIsEmpty(cellValue) and not VarIsError(cellValue) then
              ColHeaders[k - 1] := GetUniqueHeaderName(Trim(VarToStr(cellValue)), k - 1)
            else
              ColHeaders[k - 1] := GetUniqueHeaderName(Format('Coluna_%d', [k]), k - 1);
          end;

          // Valida os cabeçalhos
          if not HeadersValid then
          begin
            Writeln('⚠️ Aba "' + vSheet.Name + '" ignorada: cabeçalhos inválidos.');
            Continue;
          end;

          // Lê os dados da aba
          for j := 2 to RowCount do
          begin
            firstCellValue := vSheet.Cells[j, 1].Value;

            jsonRow := TJSONObject.Create;
            try
              for k := 1 to ColCount do
              begin
                cellValue := vSheet.Cells[j, k].Value;
                if not VarIsNull(cellValue) and not VarIsEmpty(cellValue) and not VarIsError(cellValue) then
                  jsonRow.AddPair(ColHeaders[k - 1], Trim(VarToStr(cellValue)));
              end;

              if jsonRow.Count > 0 then
                jsonArray.AddElement(jsonRow)
              else
                jsonRow.Free;

            except
              on E: Exception do
              begin
                jsonRow.Free;
                Writeln('❌ Erro na aba "' + vSheet.Name + '", linha ' + IntToStr(j) + ': ' + E.Message);
              end;
            end;
          end;

        end
        else
        begin
          Writeln('ℹ️ Aba "' + vSheet.Name + '" ignorada (formato não reconhecido).');
        end;
      end;

      vWorkbook.Close(False);
    finally
      vExcelApp.Quit;
      vWorkbook := Unassigned;
      vSheet := Unassigned;
      vExcelApp := Unassigned;
    end;

  except
    on E: Exception do
    begin
      Writeln('❌ Erro ao processar o Excel: ' + E.Message);
      jsonArray.Free;
      raise;
    end;
  end;

  CoUninitialize;
  Result := jsonArray;
end;




function LerExcelParaJSON(const vXLSFile: string): TJSONArray;
var
  vExcelApp, vWorkbook, vSheet: OleVariant;
  DataMatrix: Variant;
  RowCount, ColCount, j, k: Integer;
  jsonArray: TJSONArray;
  jsonRow: TJSONObject;
  ColHeaders: array of string;
  valor: string;
  tentativas: Integer;
  sucesso: Boolean;
  ultimoErro: string;

  function GetUniqueHeaderName(const BaseName: string; Index: Integer): string;
  var
    UniqueName: string;
    Counter: Integer;
    Exists: Boolean;
  begin
    UniqueName := BaseName;
    Counter := 1;
    repeat
      Exists := False;
      for var i := 0 to Index - 1 do
        if SameText(ColHeaders[i], UniqueName) then
        begin
          Exists := True;
          Inc(Counter);
          UniqueName := BaseName + '_' + IntToStr(Counter);
          Break;
        end;
    until not Exists;
    Result := UniqueName;
  end;

  procedure LimparProcessosExcelOrfaos;
  var
    ProcessList: TStringList;
    i: Integer;
    ProcessName: string;
  begin
    try
      ProcessList := TStringList.Create;
      try
        // Força fechamento de processos Excel órfãos
        if FileExists('C:\Windows\System32\taskkill.exe') then
        begin
          Writeln('[LIMPEZA] Finalizando processos Excel órfãos...');
          WinExec('taskkill /f /im excel.exe /t', SW_HIDE);
          Sleep(2000); // Aguarda 2 segundos para os processos serem finalizados
        end;
      finally
        ProcessList.Free;
      end;
    except
      // Ignora erros na limpeza de processos
    end;
  end;

  function TentarAbrirArquivo: Boolean;
  begin
    Result := False;
    try
      vExcelApp := CreateOleObject('Excel.Application');
      vExcelApp.Visible := False;
      vExcelApp.DisplayAlerts := False;
      vExcelApp.ScreenUpdating := False;
      vExcelApp.EnableEvents := False;

      // Tenta abrir o arquivo
      vWorkbook := vExcelApp.Workbooks.Open(vXLSFile, False, True); // ReadOnly = True
      vSheet := vWorkbook.Sheets[1];
      
      Result := True;
      Writeln('[SUCESSO] Arquivo Excel aberto com sucesso');
    except
      on E: Exception do
      begin
        ultimoErro := E.Message;
        Writeln(Format('[ERRO] Tentativa %d falhou: %s', [tentativas + 1, E.Message]));
        
        // Limpa objetos em caso de erro
        try
          if not VarIsEmpty(vWorkbook) then
            vWorkbook.Close(False);
          if not VarIsEmpty(vExcelApp) then
            vExcelApp.Quit;
        except
        end;
        
        vWorkbook := Unassigned;
        vSheet := Unassigned;
        vExcelApp := Unassigned;
        
        Result := False;
      end;
    end;
  end;

begin
  jsonArray := TJSONArray.Create;

  if not FileExists(vXLSFile) then
    raise Exception.Create('Arquivo não encontrado: ' + vXLSFile);

  // Implementa retry com limpeza de processos
  sucesso := False;
  tentativas := 0;
  ultimoErro := '';

  while (not sucesso) and (tentativas < 3) do
  begin
    if tentativas > 0 then
    begin
      Writeln(Format('[RETRY] Tentativa %d de 3 para abrir arquivo: %s', [tentativas + 1, ExtractFileName(vXLSFile)]));
      LimparProcessosExcelOrfaos;
      Sleep(3000); // Aguarda 3 segundos entre tentativas
    end;

    CoInitialize(nil);
    try
      sucesso := TentarAbrirArquivo;
      if not sucesso then
      begin
        CoUninitialize;
        Inc(tentativas);
      end;
    except
      on E: Exception do
      begin
        ultimoErro := E.Message;
        CoUninitialize;
        Inc(tentativas);
      end;
    end;
  end;

  if not sucesso then
  begin
    jsonArray.Free;
    raise Exception.Create(Format('Falha ao abrir arquivo após 3 tentativas. Último erro: %s', [ultimoErro]));
  end;

  try

    vWorkbook := vExcelApp.Workbooks.Open(vXLSFile);
    vSheet := vWorkbook.Sheets[1];

    // Lê tudo de uma vez em memória
    DataMatrix := vSheet.UsedRange.Value;

    if VarIsEmpty(DataMatrix) then
      raise Exception.Create('A planilha está vazia.');

    RowCount := VarArrayHighBound(DataMatrix, 1);
    ColCount := VarArrayHighBound(DataMatrix, 2);

    SetLength(ColHeaders, ColCount);

    // Cabeçalhos (linha 1)
    for k := 1 to ColCount do
    begin
      valor := Trim(VarToStr(DataMatrix[1, k]));
      if valor = '' then
        ColHeaders[k - 1] := Format('Coluna_%d', [k])
      else
        ColHeaders[k - 1] := GetUniqueHeaderName(valor, k - 1);
    end;

    // Linhas de dados (a partir da 2ª)
    for j := 2 to RowCount do
    begin
      jsonRow := TJSONObject.Create;
      try
        var linhaVazia := True;

        for k := 1 to ColCount do
        begin
          valor := Trim(VarToStr(DataMatrix[j, k]));
          if valor <> '' then
          begin
            linhaVazia := False;
            jsonRow.AddPair(ColHeaders[k - 1], valor);
          end;
        end;

        if not linhaVazia then
          jsonArray.AddElement(jsonRow)
        else
          jsonRow.Free;

        if (j mod 1000 = 0) then
          Writeln(Format('[Progresso] %d linhas processadas de %d', [j, RowCount]));
      except
        on E: Exception do
        begin
          jsonRow.Free;
          Writeln(Format('❌ Erro processando linha %d: %s', [j, E.Message]));
        end;
      end;
    end;

  finally
    try
      vWorkbook.Close(False);
      vExcelApp.Quit;
    except
    end;

    vWorkbook := Unassigned;
    vSheet := Unassigned;
    vExcelApp := Unassigned;
    CoUninitialize;
  end;

  Result := jsonArray;
end;

function LerExcelParaJSONMonitoramento(const vXLSFile: string): TJSONArray;
var
  vExcelApp, vWorkbook, vSheet: OleVariant;
  j, k, ColCount, RowCount: Integer;
  jsonArray: TJSONArray;
  jsonRow: TJSONObject;
  ColHeaders: array of string;
  cellValue, infoCell: Variant;
  placa, dataInicio, dataFim: string;
  regex: TRegEx;
  match: TMatch;
  headerRow: Integer;
begin
  jsonArray := TJSONArray.Create;
  CoInitialize(nil);

  try
    vExcelApp := CreateOleObject('Excel.Application');
    vExcelApp.Visible := False;
    vExcelApp.DisplayAlerts := False;

    try
      vWorkbook := vExcelApp.Workbooks.Open(vXLSFile);
      vSheet := vWorkbook.Sheets[1];
      infoCell := vSheet.Cells[1, 3].Value;
      if not VarIsNull(infoCell) then
      begin
        regex := TRegEx.Create('Posições do Veículo (\w+) de\s+(\d{2}/\d{2}/\d{4} \d{2}:\d{2}) a\s+(\d{2}/\d{2}/\d{4} \d{2}:\d{2})');
        match := regex.Match(VarToStr(infoCell));
        if match.Success then
        begin
          placa := match.Groups[1].Value;
          dataInicio := match.Groups[2].Value;
          dataFim := match.Groups[3].Value;
        end
        else
        begin
          placa := 'Desconhecida';
          dataInicio := '';
          dataFim := '';
        end;
      end;

      headerRow := 2;

      // Obter contagem de colunas e linhas
      RowCount := vSheet.UsedRange.Rows.Count;
      ColCount := vSheet.UsedRange.Columns.Count;
      SetLength(ColHeaders, ColCount);

      // Ler os cabeçalhos da linha 3
      for k := 1 to ColCount do
      begin
        cellValue := vSheet.Cells[headerRow, k].Value;
        if not VarIsNull(cellValue) and not VarIsEmpty(cellValue) then
          ColHeaders[k - 1] := Trim(VarToStr(cellValue))
        else
          ColHeaders[k - 1] := Format('Coluna_%d', [k]);
      end;

      // Ler os dados a partir da linha 4 (após o cabeçalho)
      for j := headerRow + 1 to RowCount do
      begin
        jsonRow := TJSONObject.Create;
        try
          // Adiciona informações fixas
          jsonRow.AddPair('Placa', placa);
          jsonRow.AddPair('DataInicio', dataInicio);
          jsonRow.AddPair('DataFim', dataFim);

          // Dados da linha
          for k := 1 to ColCount do
          begin
            cellValue := vSheet.Cells[j, k].Value;
            if not VarIsNull(cellValue) and not VarIsEmpty(cellValue) then
              jsonRow.AddPair(ColHeaders[k - 1], Trim(VarToStr(cellValue)))
            else
              jsonRow.AddPair(ColHeaders[k - 1], TJSONNull.Create);
          end;

          // Verifica se a linha está vazia
          var isEmpty := True;
          for var pair in jsonRow do
          begin
            if not (pair.JsonValue is TJSONNull) and
               not pair.JsonString.Value.StartsWith('Coluna_') then
            begin
              isEmpty := False;
              Break;
            end;
          end;

          if not isEmpty then
            jsonArray.AddElement(jsonRow)
          else
            jsonRow.Free;

        except
          on E: Exception do
          begin
            jsonRow.Free;
            Writeln('❌ Erro na linha ' + IntToStr(j) + ': ' + E.Message);
          end;
        end;
      end;

    finally
      vWorkbook.Close(False);
      vExcelApp.Quit;
      vWorkbook := Unassigned;
      vSheet := Unassigned;
      vExcelApp := Unassigned;
    end;
  except
    on E: Exception do
    begin
      Writeln('❌ Erro ao processar o Excel: ' + E.Message);
      jsonArray.Free;
      raise;
    end;
  end;

  CoUninitialize;
  Result := jsonArray;
end;


function LerExcelParaJSONSemTotal(const vXLSFile: string): TJSONArray;
var
  vExcelApp, vWorkbook, vSheet: OleVariant;
  j, k, ColCount, RowCount, ValidColCount: Integer;
  jsonArray: TJSONArray;
  jsonRow: TJSONObject;
  ColHeaders: array of string;
  cellValue, firstCellValue: Variant;
  ColunaValida: array of Boolean;

  function GetUniqueHeaderName(const BaseName: string; Index: Integer): string;
  var
    UniqueName: string;
    Counter: Integer;
    Exists: Boolean;
  begin
    UniqueName := BaseName;
    Counter := 1;
    repeat
      Exists := False;
      for var i := 0 to Index - 1 do
      begin
        if ColunaValida[i] and SameText(ColHeaders[i], UniqueName) then
        begin
          Exists := True;
          Inc(Counter);
          UniqueName := BaseName + '_' + IntToStr(Counter);
          Break;
        end;
      end;
    until not Exists;
    Result := UniqueName;
  end;

begin
  jsonArray := TJSONArray.Create;
  CoInitialize(nil);

  try
    try
      // Criar instância do Excel
      vExcelApp := CreateOleObject('Excel.Application');
      vExcelApp.Visible := False;
      vExcelApp.DisplayAlerts := False;

      try
        vWorkbook := vExcelApp.Workbooks.Open(vXLSFile);
        vSheet := vWorkbook.Sheets[1]; // Primeira planilha

        RowCount := vSheet.UsedRange.Rows.Count;
        ColCount := vSheet.UsedRange.Columns.Count;
        SetLength(ColHeaders, ColCount);
        SetLength(ColunaValida, ColCount);
        ValidColCount := 0;

        // Verifica quais colunas têm dados
        for k := 1 to ColCount do
        begin
          ColunaValida[k-1] := False;

          // Verifica se o cabeçalho não está vazio
          cellValue := vSheet.Cells[1, k].Value;
          if not VarIsNull(cellValue) and not VarIsEmpty(cellValue) and not VarIsError(cellValue) and (Trim(VarToStr(cellValue)) <> '') then
          begin
            ColunaValida[k-1] := True;
            Inc(ValidColCount);
          end
          else
          begin
            // Se o cabeçalho estiver vazio, verifica se há algum dado na coluna
            for j := 2 to RowCount do
            begin
              cellValue := vSheet.Cells[j, k].Value;
              if not VarIsNull(cellValue) and not VarIsEmpty(cellValue) and not VarIsError(cellValue) and (Trim(VarToStr(cellValue)) <> '') then
              begin
                ColunaValida[k-1] := True;
                Inc(ValidColCount);
                Break;
              end;
            end;
          end;
        end;

        // Se nenhuma coluna válida, retorna array vazio
        if ValidColCount = 0 then
          Exit(jsonArray);

        // Lê os cabeçalhos válidos
        for k := 1 to ColCount do
        begin
          if ColunaValida[k-1] then
          begin
            try
              cellValue := vSheet.Cells[1, k].Value;
              if not VarIsNull(cellValue) and not VarIsEmpty(cellValue) and not VarIsError(cellValue) and (Trim(VarToStr(cellValue)) <> '') then
                ColHeaders[k - 1] := GetUniqueHeaderName(Trim(VarToStr(cellValue)), k - 1)
              else
                ColHeaders[k - 1] := GetUniqueHeaderName(Format('Coluna_%d', [k]), k - 1);
            except
              on E: Exception do
              begin
                ColHeaders[k - 1] := GetUniqueHeaderName(Format('Coluna_%d', [k]), k - 1);
                Writeln('⚠️ Erro ao ler cabeçalho da coluna ' + IntToStr(k) + ': ' + E.Message);
              end;
            end;
          end;
        end;

        // Lê os dados das linhas (a partir da segunda)
        for j := 2 to RowCount do
        begin
          try
            firstCellValue := vSheet.Cells[j, 1].Value;
            // Ignora se a primeira célula tiver o valor 'Total'
            if VarToStr(firstCellValue).Trim.ToLower = 'total' then
              Continue;

            jsonRow := TJSONObject.Create;
            try
              for k := 1 to ColCount do
              begin
                if ColunaValida[k-1] then
                begin
                  try
                    cellValue := vSheet.Cells[j, k].Value;

                    // Se não for nulo/vazio, adiciona no JSON
                    if not VarIsNull(cellValue) and not VarIsEmpty(cellValue) and not VarIsError(cellValue) and (Trim(VarToStr(cellValue)) <> '') then
                      jsonRow.AddPair(ColHeaders[k - 1], Trim(VarToStr(cellValue)));
                  except
                    on E: Exception do
                      Writeln('⚠️ Erro ao ler célula [' + IntToStr(j) + ',' + IntToStr(k) + ']: ' + E.Message);
                  end;
                end;
              end;

              // Adiciona apenas se tiver pelo menos um valor
              if jsonRow.Count > 0 then
                jsonArray.AddElement(jsonRow)
              else
                jsonRow.Free;

            except
              on E: Exception do
              begin
                jsonRow.Free;
                Writeln('❌ Erro processando linha ' + IntToStr(j) + ': ' + E.Message);
              end;
            end;
          except
            on E: Exception do
              Writeln('❌ Erro ao acessar linha ' + IntToStr(j) + ': ' + E.Message);
          end;
        end;

      finally
        if not VarIsEmpty(vWorkbook) then
        begin
          vWorkbook.Close(False);
          vWorkbook := Unassigned;
        end;

        if not VarIsEmpty(vExcelApp) then
        begin
          vExcelApp.Quit;
          vExcelApp := Unassigned;
        end;

        vSheet := Unassigned;
      end;

    except
      on E: Exception do
      begin
        Writeln('❌ Erro ao processar o Excel: ' + E.Message);
        jsonArray.Free;
        jsonArray := nil;
        raise;
      end;
    end;

  finally
    CoUninitialize;
  end;

  Result := jsonArray;
end;

function ParseCSVLine(const Line: string; Delimiter: Char): TStringList;
var
  i: Integer;
  InQuotes: Boolean;
  CurrentField: string;
begin
  Result := TStringList.Create;
  InQuotes := False;
  CurrentField := '';
  i := 1;

  while i <= Length(Line) do
  begin
    if Line[i] = '"' then
    begin
      if InQuotes and (i < Length(Line)) and (Line[i+1] = '"') then
      begin
        CurrentField := CurrentField + '"';
        Inc(i);
      end;
      InQuotes := not InQuotes;
    end
    else if (Line[i] = Delimiter) and not InQuotes then
    begin
      Result.Add(CurrentField.Trim);
      CurrentField := '';
    end
    else
    begin
      CurrentField := CurrentField + Line[i];
    end;
    Inc(i);
  end;

  Result.Add(CurrentField.Trim);
end;

function LerCSVParaJSON(const vCSVFile: string; Delimitador: Char = ';'): TJSONArray;
var
  CSVFile: TextFile;
  Linha: string;
  jsonArray: TJSONArray;
  ColHeaders: TStringList;
  Valores: TStringList;
  i: Integer;
  jsonRow: TJSONObject;
begin
  jsonArray := TJSONArray.Create;
  ColHeaders := TStringList.Create;

  if not FileExists(vCSVFile) then
    raise Exception.Create('Arquivo CSV não encontrado: ' + vCSVFile);

  AssignFile(CSVFile, vCSVFile);
  Reset(CSVFile);

  try
    // Ler cabeçalhos
    if not Eof(CSVFile) then
    begin
      ReadLn(CSVFile, Linha);
      Valores := ParseCSVLine(Linha, Delimitador);
      try
        ColHeaders.Assign(Valores);
      finally
        Valores.Free;
      end;
    end;

    // Ler linhas de dados
    while not Eof(CSVFile) do
    begin
      ReadLn(CSVFile, Linha);
      if Trim(Linha) = '' then Continue;

      Valores := ParseCSVLine(Linha, Delimitador);
      try
        jsonRow := TJSONObject.Create;
        try
          for i := 0 to ColHeaders.Count - 1 do
          begin
            if i < Valores.Count then
              jsonRow.AddPair(ColHeaders[i], TJSONString.Create(Valores[i]))
            else
              jsonRow.AddPair(ColHeaders[i], TJSONString.Create(''));
          end;
          jsonArray.AddElement(jsonRow);
        except
          jsonRow.Free;
          raise;
        end;
      finally
        Valores.Free;
      end;
    end;
  finally
    CloseFile(CSVFile);
    ColHeaders.Free;
  end;

  Result := jsonArray;
end;


function ISO8601ToDate(const ISO8601Str: string): TDateTime;
var
  DateTimeStr: string;
  Year, Month, Day, Hour, Minute, Second: Word;
  DatePart, TimePart: string;
  TPos: Integer;
begin
  Result := 0;

  if Trim(ISO8601Str) = '' then
    Exit;

  try
    // Remove o 'Z' do final se existir
    DateTimeStr := StringReplace(ISO8601Str, 'Z', '', [rfReplaceAll]);

    // Encontra a posição do 'T' que separa data e hora
    TPos := Pos('T', DateTimeStr);

    if TPos > 0 then
    begin
      // Separa data e hora
      DatePart := Copy(DateTimeStr, 1, TPos - 1);
      TimePart := Copy(DateTimeStr, TPos + 1, Length(DateTimeStr));

      // Remove milissegundos se existirem
      if Pos('.', TimePart) > 0 then
        TimePart := Copy(TimePart, 1, Pos('.', TimePart) - 1);
    end
    else
    begin
      // Só tem data
      DatePart := DateTimeStr;
      TimePart := '00:00:00';
    end;

    // Parse da data (formato YYYY-MM-DD)
    if Length(DatePart) >= 10 then
    begin
      Year := StrToInt(Copy(DatePart, 1, 4));
      Month := StrToInt(Copy(DatePart, 6, 2));
      Day := StrToInt(Copy(DatePart, 9, 2));
    end
    else
      raise Exception.Create('Formato de data inválido');

    // Parse da hora (formato HH:MM:SS)
    if Length(TimePart) >= 8 then
    begin
      Hour := StrToInt(Copy(TimePart, 1, 2));
      Minute := StrToInt(Copy(TimePart, 4, 2));
      Second := StrToInt(Copy(TimePart, 7, 2));
    end
    else
    begin
      Hour := 0;
      Minute := 0;
      Second := 0;
    end;

    // Cria o TDateTime
    Result := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Minute, Second, 0);

  except
    on E: Exception do
    begin
      // Em caso de erro, retorna uma data padrão
      Result := EncodeDate(1899, 12, 30);
    end;
  end;
end;

function ForcarLiberacaoArquivo(const nomeArquivo: string): Boolean;
var
  tentativas: Integer;
  nomeArquivoSemCaminho: string;
begin
  Result := False;
  tentativas := 0;
  nomeArquivoSemCaminho := ExtractFileName(nomeArquivo);
  
  Writeln(Format('[LIBERAÇÃO] Tentando liberar arquivo: %s', [nomeArquivoSemCaminho]));
  
  while (tentativas < 3) do
  begin
    try
      // Tenta deletar o arquivo
      if FileExists(nomeArquivo) then
      begin
        if DeleteFile(nomeArquivo) then
        begin
          Writeln(Format('[SUCESSO] Arquivo liberado na tentativa %d', [tentativas + 1]));
          Result := True;
          Exit;
        end;
      end
      else
      begin
        Result := True; // Arquivo não existe, consideramos como sucesso
        Exit;
      end;
      
    except
      on E: Exception do
        Writeln(Format('[ERRO] Tentativa %d falhou: %s', [tentativas + 1, E.Message]));
    end;
    
    Inc(tentativas);
    
    if tentativas < 3 then
    begin
      // Força fechamento de processos Excel
      Writeln(Format('[LIMPEZA] Tentativa %d - Finalizando processos Excel...', [tentativas]));
      try
        WinExec('taskkill /f /im excel.exe /t', SW_HIDE);
        Sleep(2000);

        
      except
        on E: Exception do
          Writeln('[AVISO] Erro ao finalizar processos: ' + E.Message);
      end;
      
      Sleep(1000); // Aguarda antes da próxima tentativa
    end;
  end;
  
  if not Result then
    Writeln(Format('[FALHA] Não foi possível liberar o arquivo após %d tentativas', [tentativas]));
end;


end.


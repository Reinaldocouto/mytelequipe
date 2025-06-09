unit UtFuncao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Horse,
  System.JSON, DataSet.Serialize, ComObj, ActiveX;

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

function LerExcelParaJSONGEFolhaDePagamento(const vXLSFile: string): TJSONArray;
var
  vExcelApp, vWorkbook, vSheet: OleVariant;
  j, k, ColCount, RowCount: Integer;
  jsonArray: TJSONArray;
  jsonRow: TJSONObject;
  ColHeaders: array of string;
  cellValue: Variant;
  competencia: string;
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

      Writeln('Arquivo Excel aberto com sucesso.');

      RowCount := vSheet.UsedRange.Rows.Count;
      ColCount := vSheet.UsedRange.Columns.Count;
      SetLength(ColHeaders, ColCount);
      for k := 1 to ColCount do
      begin
        cellValue := vSheet.Cells[3, k].Value;
        if not VarIsNull(cellValue) and not VarIsEmpty(cellValue) and not VarIsError(cellValue) then
          ColHeaders[k - 1] := Trim(VarToStr(cellValue))
        else
          ColHeaders[k - 1] := Format('Coluna_%d', [k]);
      end;
      competencia := Trim(VarToStr(vSheet.Cells[1, 2].Value));
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
            LogError('Linha ' + IntToStr(j) + ' vazia - descartada');
            jsonRow.Free;
          end;
        except
          on E: Exception do
          begin
            jsonRow.Free;
            LogError('Erro processando linha ' + IntToStr(j) + ': ' + E.Message);
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



function LerExcelParaJSON(const vXLSFile: string): TJSONArray;
var
  vExcelApp, vWorkbook, vSheet: OleVariant;
  j, k, ColCount, RowCount: Integer;
  jsonArray: TJSONArray;
  jsonRow: TJSONObject;
  ColHeaders: array of string;
  cellValue: Variant;

begin
  jsonArray := TJSONArray.Create;
  CoInitialize(nil);

  try
    // Criar instância do Excel
    vExcelApp := CreateOleObject('Excel.Application');
    vExcelApp.Visible := False;
    vExcelApp.DisplayAlerts := False;

    try
      vWorkbook := vExcelApp.Workbooks.Open(vXLSFile);
      vSheet := vWorkbook.Sheets[1]; // Acessa a primeira planilha

      Writeln('Arquivo Excel aberto com sucesso.');

      RowCount := vSheet.UsedRange.Rows.Count;
      ColCount := vSheet.UsedRange.Columns.Count;
      SetLength(ColHeaders, ColCount);

      // 🔹 Lê os cabeçalhos da primeira linha
     for k := 1 to ColCount do
      begin
        cellValue := vSheet.Cells[1, k].Value;
        if not VarIsNull(cellValue) and not VarIsEmpty(cellValue) and not VarIsError(cellValue) then
          ColHeaders[k - 1] := Trim(VarToStr(cellValue))
        else
          ColHeaders[k - 1] := Format('Coluna_%d', [k]); // Nome genérico para colunas vazias
      end;
       // 🔹 Lê os dados das linhas (começa na segunda linha)
      for j := 2 to RowCount do
        begin
          jsonRow := TJSONObject.Create;
          try
            // Preenche todos os valores normalmente
            for k := 1 to ColCount do
            begin
              cellValue := vSheet.Cells[j, k].Value;

              if not VarIsNull(cellValue) and not VarIsEmpty(cellValue) and not VarIsError(cellValue) then
                jsonRow.AddPair(ColHeaders[k - 1], Trim(VarToStr(cellValue)))
              else
                jsonRow.AddPair(ColHeaders[k - 1], TJSONNull.Create);
            end;

            // Verifica se pelo menos um valor não é nulo/vazio
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
              LogError('Linha ' + IntToStr(j) + ' vazia - descartada');
              jsonRow.Free;
            end;

          except
            on E: Exception do
            begin
              jsonRow.Free;
              LogError('Erro processando linha ' + IntToStr(j) + ': ' + E.Message);
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

end.


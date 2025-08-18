unit Controller.Upload;

interface

uses
  Horse, Math, Horse.Upload, System.JSON, System.SysUtils, FireDAC.Comp.Client,
  model.connection, Data.DB, DataSet.Serialize, UtFuncao, Model.Upload,
  Controller.Auth, System.Zip, System.IOUtils, System.Classes;

procedure Registry;

procedure UploadObraEricson(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure UploadObraZTE(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Uploadlpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Uploaddespesa(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure uploadengenharia(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Uploadanexo(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure uploadpessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure GetCredenciaisS3(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure UploadPMTSTelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure UploadFolhaDePagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);


implementation

procedure Registry;
begin
  THorse.Post('v1/uploadobraericson', UploadObraEricson);
  THorse.Post('v1/uploadobrazte', UploadObraZTE);
  THorse.Post('v1/uploadlpu', Uploadlpu);
  THorse.Post('v1/uploaddespesa', Uploaddespesa);
  THorse.Post('v1/uploadengenharia', uploadengenharia);
  THorse.Post('v1/uploadanexo', Uploadanexo);
  THorse.Get('v1/credenciaiss3', GetCredenciaisS3);
  THorse.Post('v1/uploadpessoa', uploadpessoa);
  THorse.Post('v1/uploadPMTSTelefonica', uploadPMTSTelefonica);
  THorse.Post('v1/uploadfolhadepagamento', UploadFolhaDePagamento);
end;

procedure GetCredenciaisS3(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TUpload;
  qry: TFDQuery;
  erro: string;
begin
  servico := TUpload.Create;
  try
    qry := servico.GetCredenciaisS3(erro);
    if erro = '' then
      Res.Send<TJSONArray>(qry.ToJSONArray).Status(THTTPStatus.OK)
    else
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
  finally
    servico.Free;
  end;
end;

procedure uploadengenharia(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TUpload;
  LUploadConfig: TUploadConfig;
  vDiretorio: string;
begin
  LUploadConfig := TUploadConfig.Create('C:\servidorgpo\engenharia');
  LUploadConfig.ForceDir := True;
  LUploadConfig.OverrideFiles := True;

      //Optional: Callback for each file received
  LUploadConfig.UploadFileCallBack :=
    procedure(Sender: TObject; AFile: TUploadFileInfo)
    begin
      Writeln('');
      Writeln('Upload file: ' + AFile.filename + ' ' + AFile.size.ToString);
      vDiretorio := 'C:\servidorgpo\engenharia\' + AFile.filename;
    end;

      //Optional: Callback on end of all files
  LUploadConfig.UploadsFishCallBack :=
    procedure(Sender: TObject; AFiles: TUploadFiles)
    begin
      Writeln('');
      Writeln('Finish ' + AFiles.Count.ToString + ' files.');
    end;

  Res.Send<TUploadConfig>(LUploadConfig);

end;

procedure UploadObraEricson(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LUploadConfig: TUploadConfig;
  vDiretorio, vExtensao, vXLSFile: string;
  jsonData: TJSONArray;
  resultado: Integer;
  servico: TUpload;
  erro: string;
const
  DIRETORIO_BASE = 'C:\servidorgpo\obraericson\';
  PADRAO_MIGO = 'migo';
  PADRAO_DOCUMENTACAO_OBRA = 'documentação da obra  (final)';
  PADRAO_OBRAS_ASP_2022 = 'obras asp 2022';
  PADRAO_OBRAS_ASP_RFP_2024 = 'obras asp rfp 2024';
  PADRAO_LISTA_SITES = 'lista de sites';
begin
  try
    servico := TUpload.Create;
    jsonData := TJSONArray.Create;
    LUploadConfig := TUploadConfig.Create(DIRETORIO_BASE);
    LUploadConfig.ForceDir := True;
    LUploadConfig.OverrideFiles := True;
    resultado := 1;
    LUploadConfig.UploadFileCallBack :=
      procedure(Sender: TObject; AFile: TUploadFileInfo)
      var
        vZipFile: TZipFile;
        i: Integer;
      begin
        try
          Writeln('Upload file: ' + AFile.FileName + ' (' + IntToStr(AFile.Size) + ' bytes)');
          vDiretorio := DIRETORIO_BASE + AFile.FileName;
          vExtensao := LowerCase(ExtractFileExt(AFile.FileName));

          if vExtensao = '.zip' then
          begin
            Writeln('Arquivo ZIP detectado. Iniciando descompactação...');
            vZipFile := TZipFile.Create;
            try
              vZipFile.Open(vDiretorio, zmRead);
              for i := 0 to vZipFile.FileCount - 1 do
              begin
                jsonData := TJSONArray.Create;
                Writeln(TimeToStr(Now) + ' - Processando arquivo: ' + vZipFile.FileNames[i]);
                Writeln('Name file: ' + (LowerCase(Copy(ExtractFileName(vZipFile.FileNames[i]), 1, 38))));
               // if (LowerCase(Copy(ExtractFileName(vZipFile.FileNames[i]), 1, 4)) = PADRAO_MIGO) and (LowerCase(ExtractFileExt(vZipFile.FileNames[i])) = '.xlsx') then
                if (Pos(LowerCase(PADRAO_MIGO), LowerCase(ChangeFileExt(ExtractFileName(vZipFile.FileNames[i]), ''))) > 0) and (LowerCase(ExtractFileExt(vZipFile.FileNames[i])) = '.xlsx') then
                begin
                  vXLSFile := 'C:\servidorgpo\obraericson\' + ExtractFileName(vZipFile.FileNames[i]);
                  vZipFile.Extract(vZipFile.FileNames[i], ExtractFilePath(vXLSFile));
                  Writeln(TimeToStr(Now) + 'Lendo dados, arquivo: ' + vZipFile.FileNames[i]);
                  jsonData.Free;
                  jsonData := LerExcelParaJSON(vXLSFile);
                  Writeln(TimeToStr(Now) + 'Leitura de dados Finalizado, arquivo: ' + vZipFile.FileNames[i]);
                  try
                    Writeln(TimeToStr(Now) + ' Inserindo dados no banco, arquivo: ' + vZipFile.FileNames[i]);
                    resultado := servico.InserirAtualizarMigo(jsonData, erro);
                    Writeln(TimeToStr(Now) + 'Dados inseridos com sucesso!')
                  finally
                    jsonData.Free;
                  end;

                  if FileExists(vXLSFile) then
                    DeleteFile(vXLSFile);



                end;

                if (LowerCase(Copy(ExtractFileName(vZipFile.FileNames[i]), 1, 14)) = PADRAO_LISTA_SITES) and (LowerCase(ExtractFileExt(vZipFile.FileNames[i])) = '.xlsx') then
                begin
                  Writeln(TimeToStr(Now) + ' - Processando arquivo: ' + vZipFile.FileNames[i]);
                  vXLSFile := 'C:\servidorgpo\obraericson\' + ExtractFileName(vZipFile.FileNames[i]);
                  vZipFile.Extract(vZipFile.FileNames[i], ExtractFilePath(vXLSFile));
                  Writeln(TimeToStr(Now) + 'Lendo dados, arquivo: ' + vZipFile.FileNames[i]);
                  jsonData.Free;
                  jsonData := LerExcelParaJSON(vXLSFile); // Função para ler o CSV
                  Writeln(TimeToStr(Now) + 'Leitura de dados Finalizado, arquivo: ' + vZipFile.FileNames[i]);
                  try
                    Writeln(TimeToStr(Now) + 'Inserindo dados no banco, arquivo: ' + vZipFile.FileNames[i]);
                    resultado := servico.InserirAtualizaObrasSites(jsonData, erro);
                    Writeln(TimeToStr(Now) + 'Dados inseridos com sucesso!')

                  finally
                    jsonData.Free;
                  end;

                  if FileExists(vXLSFile) then
                    DeleteFile(vXLSFile);
                end;

                if (LowerCase(Copy(ExtractFileName(vZipFile.FileNames[i]), 1, 29)) = PADRAO_DOCUMENTACAO_OBRA) and (LowerCase(ExtractFileExt(vZipFile.FileNames[i])) = '.csv') then
                begin
                  Writeln(TimeToStr(Now) + ' - Processando arquivo: ' + vZipFile.FileNames[i]);
                  vXLSFile := 'C:\servidorgpo\obraericson\' + ExtractFileName(vZipFile.FileNames[i]);
                  vZipFile.Extract(vZipFile.FileNames[i], ExtractFilePath(vXLSFile));
                  Writeln(TimeToStr(Now) + 'Lendo dados, arquivo: ' + vZipFile.FileNames[i]);
                  jsonData.Free;
                  jsonData := LerCSVParaJSON(vXLSFile); // Função para ler o CSV
                  Writeln(TimeToStr(Now) + 'Leitura de dados Finalizado, arquivo: ' + vZipFile.FileNames[i]);
                  try
                    Writeln(TimeToStr(Now) + 'Inserindo dados no banco, arquivo: ' + vZipFile.FileNames[i]);
                    resultado := servico.InserirAtualizaObraDocumentacaoObraFinal(jsonData, erro);
                    Writeln(TimeToStr(Now) + 'Dados inseridos com sucesso!')
                  finally
                    jsonData.Free;
                  end;

                  if FileExists(vXLSFile) then
                    DeleteFile(vXLSFile);
                end;

                if (LowerCase(Copy(ExtractFileName(vZipFile.FileNames[i]), 1, 14)) = PADRAO_OBRAS_ASP_2022) and (LowerCase(ExtractFileExt(vZipFile.FileNames[i])) = '.csv') then
                begin
                  Writeln(TimeToStr(Now) + ' - Processando arquivo: ' + vZipFile.FileNames[i]);
                  vXLSFile := 'C:\servidorgpo\obraericson\' + ExtractFileName(vZipFile.FileNames[i]);
                  vZipFile.Extract(vZipFile.FileNames[i], ExtractFilePath(vXLSFile));
                  Writeln(TimeToStr(Now) + 'Lendo dados, arquivo: ' + vZipFile.FileNames[i]);
                  jsonData.Free;
                  jsonData := LerCSVParaJSON(vXLSFile); // Função para ler o CSV
                  Writeln(TimeToStr(Now) + 'Leitura de dados Finalizado, arquivo: ' + vZipFile.FileNames[i]);
                  try
                    Writeln(TimeToStr(Now) + 'Inserindo dados no banco, arquivo: ' + vZipFile.FileNames[i]);
                    resultado := servico.InserirAtualizaObras2022(jsonData, erro);
                    Writeln(TimeToStr(Now) + 'Dados inseridos com sucesso!' + vZipFile.FileNames[i])
                  finally
                    jsonData.Free;
                  end;

                  if FileExists(vXLSFile) then
                    DeleteFile(vXLSFile);
                end;

                if (LowerCase(Copy(ExtractFileName(vZipFile.FileNames[i]), 1, 18)) = PADRAO_OBRAS_ASP_RFP_2024) and (LowerCase(ExtractFileExt(vZipFile.FileNames[i])) = '.csv') then
                begin
                  Writeln(TimeToStr(Now) + ' - Processando arquivo: ' + vZipFile.FileNames[i]);
                  vXLSFile := 'C:\servidorgpo\obraericson\' + ExtractFileName(vZipFile.FileNames[i]);
                  vZipFile.Extract(vZipFile.FileNames[i], ExtractFilePath(vXLSFile));
                  Writeln(TimeToStr(Now) + 'Lendo dados, arquivo: ' + vZipFile.FileNames[i]);
                  jsonData.Free;
                  jsonData := LerCSVParaJSON(vXLSFile); // Função para ler o CSV
                  try
                    Writeln(TimeToStr(Now) + 'Inserindo dados no banco, arquivo: ' + vZipFile.FileNames[i]);
                    resultado := servico.InserirAtualizaObrasAspRFP2024(jsonData, erro);
                    Writeln(TimeToStr(Now) + 'Dados inseridos com sucesso!')
                  finally
                    jsonData.Free;
                  end;

                  if FileExists(vXLSFile) then
                    DeleteFile(vXLSFile);
                end;

              end;
            finally
              vZipFile.Free;
            end;
          end
          else
            Writeln('Arquivo não é um ZIP. Ignorando.');
        except
          on E: Exception do
            Res.Send<TJSONObject>(CreateJsonObj('erro', E.Message)).Status(THTTPStatus.InternalServerError);
        end;
      end;

    LUploadConfig.UploadsFishCallBack :=
      procedure(Sender: TObject; AFiles: TUploadFiles)
      begin
        Writeln('Processamento concluído. Total de arquivos: ' + IntToStr(AFiles.Count));
        Res.Send<TJSONObject>(CreateJsonObj('sucesso', 'Arquivo processado')).Status(THTTPStatus.OK);
      end;
    Writeln('Processo finalizado.');
    Res.Send<TUploadConfig>(LUploadConfig);
  except
    on E: Exception do
      Res.Send<TJSONObject>(CreateJsonObj('erro', E.Message)).Status(THTTPStatus.InternalServerError);
  end;
  servico.Free;
end;

procedure UploadObraZTE(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TUpload;
  LUploadConfig: TUploadConfig;
  vDiretorio: string;
begin
  LUploadConfig := TUploadConfig.Create('C:\servidorgpo\obrazte');
  LUploadConfig.ForceDir := True;
  LUploadConfig.OverrideFiles := True;

      //Optional: Callback for each file received
  LUploadConfig.UploadFileCallBack :=
    procedure(Sender: TObject; AFile: TUploadFileInfo)
    begin
      Writeln('');
      Writeln('Upload file: ' + AFile.filename + ' ' + AFile.size.ToString);
      vDiretorio := 'C:\servidorgpo\obrazte\' + AFile.filename;
    end;

      //Optional: Callback on end of all files
  LUploadConfig.UploadsFishCallBack :=
    procedure(Sender: TObject; AFiles: TUploadFiles)
    begin
      Writeln('');
      Writeln('Finish ' + AFiles.Count.ToString + ' files.');
    end;

  Res.Send<TUploadConfig>(LUploadConfig);

end;

procedure Uploadpessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TUpload;
  LUploadConfig: TUploadConfig;
  vDiretorio: string;
begin
  LUploadConfig := TUploadConfig.Create('C:\servidorgpo\pessoa');
  LUploadConfig.ForceDir := True;
  LUploadConfig.OverrideFiles := True;

      //Optional: Callback for each file received
  LUploadConfig.UploadFileCallBack :=
    procedure(Sender: TObject; AFile: TUploadFileInfo)
    begin
      Writeln('');
      Writeln('Upload file: ' + AFile.filename + ' ' + AFile.size.ToString);
      vDiretorio := 'C:\servidorgpo\pessoa\' + AFile.filename;
    end;

      //Optional: Callback on end of all files
  LUploadConfig.UploadsFishCallBack :=
    procedure(Sender: TObject; AFiles: TUploadFiles)
    begin
      Writeln('');
      Writeln('Finish ' + AFiles.Count.ToString + ' files.');

    end;

  Res.Send<TUploadConfig>(LUploadConfig);

end;

procedure Uploadlpu(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TUpload;
  LUploadConfig: TUploadConfig;
  vDiretorio: string;
begin
  LUploadConfig := TUploadConfig.Create('C:\servidorgpo\lpu');
  LUploadConfig.ForceDir := True;
  LUploadConfig.OverrideFiles := True;

      //Optional: Callback for each file received
  LUploadConfig.UploadFileCallBack :=
    procedure(Sender: TObject; AFile: TUploadFileInfo)
    begin
      Writeln('');
      Writeln('Upload file: ' + AFile.filename + ' ' + AFile.size.ToString);
      vDiretorio := 'C:\servidorgpo\lpu\' + AFile.filename;
    end;

      //Optional: Callback on end of all files
  LUploadConfig.UploadsFishCallBack :=
    procedure(Sender: TObject; AFiles: TUploadFiles)
    begin
      Writeln('');
      Writeln('Finish ' + AFiles.Count.ToString + ' files.');
    end;

  Res.Send<TUploadConfig>(LUploadConfig);

end;

procedure Uploaddespesa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TUpload;
  LUploadConfig: TUploadConfig;
  vDiretorio: string;
begin
  LUploadConfig := TUploadConfig.Create('C:\servidorgpo\despesafrota');
  LUploadConfig.ForceDir := True;
  LUploadConfig.OverrideFiles := True;

      //Optional: Callback for each file received
  LUploadConfig.UploadFileCallBack :=
    procedure(Sender: TObject; AFile: TUploadFileInfo)
    begin
      Writeln('');
      Writeln('Upload file: ' + AFile.filename + ' ' + AFile.size.ToString);
      vDiretorio := 'C:\servidorgpo\despesafrota\' + AFile.filename;
    end;

      //Optional: Callback on end of all files
  LUploadConfig.UploadsFishCallBack :=
    procedure(Sender: TObject; AFiles: TUploadFiles)
    begin
      Writeln('');
      Writeln('Finish ' + AFiles.Count.ToString + ' files.');
    end;

  Res.Send<TUploadConfig>(LUploadConfig);

end;

procedure Uploadanexo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TUpload;
  LUploadConfig: TUploadConfig;
  vDiretorio: string;
begin
  LUploadConfig := TUploadConfig.Create('C:\servidorgpo\anexo');
  LUploadConfig.ForceDir := True;
  LUploadConfig.OverrideFiles := True;
  servico := TUpload.Create;

      //Optional: Callback for each file received
  LUploadConfig.UploadFileCallBack :=
    procedure(Sender: TObject; AFile: TUploadFileInfo)
    begin
      Writeln('');
      Writeln('Upload file: ' + AFile.filename + ' ' + AFile.size.ToString);
      vDiretorio := 'C:\servidorgpo\anexo\' + AFile.filename;
    end;

      //Optional: Callback on end of all files
  LUploadConfig.UploadsFishCallBack :=
    procedure(Sender: TObject; AFiles: TUploadFiles)
    begin
      Writeln('');
      Writeln('Finish ' + AFiles.Count.ToString + ' files.');
      Res.Send<TJSONObject>(CreateJsonObj('retorno', vDiretorio)).Status(THTTPStatus.Created)
    end;

  Res.Send<TUploadConfig>(LUploadConfig);
end;


procedure UploadPMTSTelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TUpload;
  LUploadConfig: TUploadConfig;
const
  TAMANHO_LOTE = 330; // Tamanho fixo para os lotes
  MAX_TENTATIVAS = 3;  // Máximo de tentativas por lote
begin
  servico := TUpload.Create;
  try
    LUploadConfig := TUploadConfig.Create('C:\servidorgpo\pmtstelefonica');
    try
      LUploadConfig.ForceDir := True;
      LUploadConfig.OverrideFiles := True;

      // Callback de upload de cada arquivo
      LUploadConfig.UploadFileCallBack :=
        procedure(Sender: TObject; AFile: TUploadFileInfo)
        var
          vDiretorio, vXLSFile: string;
          jsonData: TJSONArray;
          resultado, totalProcessados, totalErros, lotesComErro: Integer;
          erro: string;
          inicioLote: TDateTime;
          taxaSucesso: Double;
        begin
          totalProcessados := 0;
          totalErros := 0;
          lotesComErro := 0;

          try
            Writeln('[' + TimeToStr(Now) + '] Iniciando processamento do arquivo: ' +
                    AFile.FileName + ' (' + AFile.Size.ToString + ' bytes)');

            // Define o diretório de destino
            vDiretorio := 'C:\servidorgpo\pmtstelefonica\';
            ForceDirectories(vDiretorio);
            vXLSFile := vDiretorio + AFile.FileName;

            // Processa o arquivo Excel
            Writeln('[' + TimeToStr(Now) + '] Lendo dados do arquivo Excel...');
            jsonData := LerExcelParaJSON(vXLSFile);
            try
              Writeln('[' + TimeToStr(Now) + '] Leitura concluída. Total de registros: ' +
                      jsonData.Count.ToString);

              // Remove registros existentes
              servico.RemoverPMTSRegistro(erro);
              if erro <> '' then
                raise Exception.Create('Erro ao limpar tabela: ' + erro);

              // Processa em lotes de tamanho fixo
              var indice := 0;
              while indice < jsonData.Count do
              begin
                inicioLote := Now;
                var lote := TJSONArray.Create;
                try
                  // Define o intervalo do lote atual
                  var fimLote := Math.Min(indice + TAMANHO_LOTE - 1, jsonData.Count - 1);
                  var tamanhoLoteAtual := fimLote - indice + 1;

                  // Preenche o lote com os itens
                  for var j := indice to fimLote do
                    lote.AddElement(jsonData.Items[j].Clone as TJSONValue);

                  // Tenta processar o lote (com retry)
                  var tentativa := 1;
                  var sucesso := False;

                  while (tentativa <= MAX_TENTATIVAS) and not sucesso do
                  begin
                    try
                      resultado := servico.InserirAtualizaPMTSRegistro(lote, erro);
                      if erro <> '' then
                        raise Exception.Create(erro);

                      totalProcessados := totalProcessados + resultado;
                      sucesso := True;

                      Writeln(Format('[%s] Lote %d (%d-%d) processado com sucesso. ' +
                             'Registros: %d/%d. Tempo: %s', [
                             TimeToStr(Now),
                             (indice div TAMANHO_LOTE) + 1,
                             indice + 1,
                             fimLote + 1,
                             resultado,
                             tamanhoLoteAtual,
                             FormatDateTime('nn:ss', Now - inicioLote)]));

                    except
                      on E: Exception do
                      begin
                        erro := Format('Tentativa %d/%d - Erro no lote %d: %s', [
                                      tentativa, MAX_TENTATIVAS,
                                      (indice div TAMANHO_LOTE) + 1,
                                      E.Message]);

                        LogError(erro);

                        if tentativa = MAX_TENTATIVAS then
                        begin
                          Inc(lotesComErro);
                          Inc(totalErros, tamanhoLoteAtual);
                          Writeln(Format('[%s] ERRO: Falha ao processar lote %d após %d tentativas', [
                                 TimeToStr(Now),
                                 (indice div TAMANHO_LOTE) + 1,
                                 MAX_TENTATIVAS]));
                        end;

                        Sleep(1000 * tentativa); // Backoff progressivo
                        Inc(tentativa);
                      end;
                    end;
                  end;

                  indice := fimLote + 1;
                finally
                  lote.Free;
                end;
              end;

              // Resumo final do processamento
              if jsonData.Count > 0 then
                taxaSucesso := (totalProcessados / jsonData.Count) * 100
              else
                taxaSucesso := 0;

              Writeln(Format('[%s] PROCESSAMENTO CONCLUÍDO! ' +
                     'Total: %d registros | Sucesso: %d (%.2f%%) | Erros: %d | Lotes com erro: %d', [
                     TimeToStr(Now),
                     jsonData.Count,
                     totalProcessados,
                     taxaSucesso,
                     totalErros,
                     lotesComErro]));

            finally
              jsonData.Free;
            end;
          except
            on E: Exception do
            begin
              Writeln('[' + TimeToStr(Now) + '] ERRO durante o processamento: ' + E.Message);
              if Assigned(jsonData) then
                jsonData.Free;
              raise; // Re-lança a exceção para tratamento superior
            end;
          end;

          Writeln('[' + TimeToStr(Now) + '] Processamento finalizado para o arquivo: ' + AFile.FileName);
          Writeln('--------------------------------------------------');
        end;

      LUploadConfig.UploadsFishCallBack :=
        procedure(Sender: TObject; AFiles: TUploadFiles)
        begin
          Writeln('');
          Writeln('[' + TimeToStr(Now) + '] Finalizado upload de ' + AFiles.Count.ToString + ' arquivo(s).');
        end;

      Res.Send<TUploadConfig>(LUploadConfig);
    except
      on E: Exception do
      begin
        LUploadConfig.Free;
        raise;
      end;
    end;
  except
    on E: Exception do
    begin
      servico.Free;
      Res.Status(500).Send('Erro no processamento: ' + E.Message);
    end;
  end;
end;

procedure UploadFolhaDePagamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  DIRETORIO_UPLOAD = 'C:\servidorgpo\folhadepagamento\';
var
  servico: TUpload;
  LUploadConfig: TUploadConfig;
  Inseridos: Integer;
  erro: string;


begin
  LUploadConfig := TUploadConfig.Create(DIRETORIO_UPLOAD);
  LUploadConfig.ForceDir := True;
  LUploadConfig.OverrideFiles := True;

      //Optional: Callback for each file received
  LUploadConfig.UploadFileCallBack :=
    procedure(Sender: TObject; AFile: TUploadFileInfo)
    var   jsonData: TJSONArray; vXLSFile: String; periodo: String;
      i: Integer;
      jsonObject: TJSONObject;
      jsonPair: TJSONPair;
    begin
      Writeln('');
      Writeln('Upload file: ' + AFile.filename + ' ' + AFile.size.ToString);
      vXLSFile := DIRETORIO_UPLOAD + AFile.FileName;
      jsonData := LerExcelParaJSONGEFolhaDePagamento(vXLSFile);
      if (jsonData.Count > 0) and (jsonData.Items[0] is TJSONObject) then
      begin
        jsonObject := jsonData.Items[0] as TJSONObject;
        periodo := (jsonObject.GetValue('Competência') as TJSONString).Value;
        Inseridos := Servico.InserirGeFolhaDePagamento(jsonData, periodo, Erro);
      end;


    end;

      //Optional: Callback on end of all files
  LUploadConfig.UploadsFishCallBack :=
    procedure(Sender: TObject; AFiles: TUploadFiles)
    begin
      Writeln('');
      Writeln('Finish ' + AFiles.Count.ToString + ' files.');
    end;

  Res.Send<TUploadConfig>(LUploadConfig);

end;

end.


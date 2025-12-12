unit Cron.Huawei;

interface

uses
  System.Classes, DateUtils, System.SysUtils, System.JSON, System.Generics.Collections, IdHTTP, DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, Controller.Projetohuawei, System.IOUtils;

type
  TCronJob = class(TThread)
  private
    FInterval: TTime; // Intervalo de execução
    FLastRun: TDateTime;
    procedure ExecuteHTTPRequest;
  protected
    procedure Execute; override;
  public
    constructor Create(AInterval: TTime);
    procedure ExecuteJob;
  end;

implementation

{ TCronJob }

constructor TCronJob.Create(AInterval: TTime);
begin
  inherited Create(True);
  FInterval := AInterval;
  FLastRun := Now;
  FreeOnTerminate := True;
end;

procedure TCronJob.Execute;
var
  i: Integer;
begin
  while not Terminated do
  begin
    if SecondsBetween(Now, FLastRun) >= SecondsBetween(0, FInterval) then
    begin
      ExecuteJob;
      FLastRun := Now;
    end;
    Sleep(1000); // Aguarda 1 segundo antes de verificar novamente
  end;
end;


procedure TCronJob.ExecuteHTTPRequest;
var
  HttpClient: TIdHTTP;
  URL, ResponseContent, FileName: string;
  RequestData: TStringStream;
  JSONObj, PageVOObj: TJSONObject;
  ResultArray: TJSONArray;
  i: Integer;
  Item: TJSONObject;
  primaryKey: string;
  curPage, totalPages: Integer;
begin
  HttpClient := TIdHTTP.Create(nil);
  try
    HttpClient.Request.ContentType := 'application/json';
    HttpClient.Request.CustomHeaders.Values['Cookie'] :=
      'ztsg_ruuid=dc4b1e80f0d0bbd0-506f-47df-9912-af2f13900d98';

    curPage := 1;
    totalPages := 1;

    while curPage <= totalPages do
    begin
      // URL da página atual
      URL :=
        'https://openapi.huawei.com/service/esupplier/findPoLineList/1.0.0' +
        '?X-HW-ID=APP_Z02XAC_gpo' +
        '&X-HW-APPKEY=1aka1TOHrCUJ%2FIev3aJnyg%3D%3D' +
        '&suffix_path=/200/' + IntToStr(curPage);

      // Corpo da requisição
      RequestData := TStringStream.Create(
        '{"poSubType": "E", "statusType": "COL_TASK_STATUS", "colTaskOrPoStatus": "all"}',
        TEncoding.UTF8
      );

      try
        ResponseContent := HttpClient.Post(URL, RequestData);
        // Parse JSON para continuar o processamento
        JSONObj := TJSONObject.ParseJSONValue(ResponseContent) as TJSONObject;
        try
          if not Assigned(JSONObj) then
          begin
            Writeln('Erro: resposta não é JSON válido.');
            Exit;
          end;

          // Paginação
          PageVOObj := JSONObj.GetValue('pageVO') as TJSONObject;
          if Assigned(PageVOObj) then
            totalPages := PageVOObj.GetValue<Integer>('totalPages');

          // Processar "result"
          if JSONObj.TryGetValue('result', ResultArray) then
          begin
            Writeln('Processando página ', curPage, ' de ', totalPages, '...');

            for i := 0 to ResultArray.Count - 1 do
            begin
              Item := ResultArray.Items[i] as TJSONObject;
              primaryKey := Item.GetValue<string>('primaryKey');

              Controller.Projetohuawei.InserirSeNaoExistir(primaryKey, Item);
              Controller.Projetohuawei.InserirSeNaoExistirRollout(primaryKey, Item);
            end;
          end
          else
            Writeln('A chave "result" não existe na página ', curPage, '.');

          Inc(curPage);
        finally
          JSONObj.Free;
        end;
      finally
        RequestData.Free;
      end;
    end;

  except
    on E: Exception do
      Writeln('Erro ao fazer a requisição: ', E.Message);
  end;

  HttpClient.Free;
end;


procedure TCronJob.ExecuteJob;
begin
  // Executa a requisição HTTP
  ExecuteHTTPRequest;

  // Outras tarefas do cron job
  Writeln('Executando o cron job: ', FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
end;

end.



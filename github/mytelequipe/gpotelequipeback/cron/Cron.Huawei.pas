unit Cron.Huawei;

interface

uses
  System.Classes, DateUtils, System.SysUtils, System.JSON, IdHTTP, DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, Controller.Projetohuawei;

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
  URL, ResponseContent: string;
  RequestData: TStringStream;
  JSONObj, PageVOObj: TJSONObject;
  ResultArray: TJSONArray;
  i: Integer;
  ResultItem: TJSONArray;
  //Item: TJSONValue;
  Obj, Item: TJSONObject;
  primaryKey: string;
  curPage, totalPages: Integer;
begin
  HttpClient := TIdHTTP.Create(nil);
  try
    HttpClient.Request.ContentType := 'application/json';
    HttpClient.Request.CustomHeaders.Values['Cookie'] := 'ztsg_ruuid=dc4b1e80f0d0bbd0-506f-47df-9912-af2f13900d98';

    // URL base da API
  //  URL := 'https://openapi.huawei.com/service/esupplier/findPoLineList/1.0.0?X-HW-ID=APP_Z02XAC_gpo&X-HW-APPKEY=1aka1TOHrCUJ%2FIev3aJnyg%3D%3D';

    curPage := 1; // Página inicial
    totalPages := 1; // Inicialização temporária

    while curPage <= totalPages do
    begin

      // URL base da API
      URL := 'https://openapi.huawei.com/service/esupplier/findPoLineList/1.0.0?X-HW-ID=APP_Z02XAC_gpo&X-HW-APPKEY=1aka1TOHrCUJ%2FIev3aJnyg%3D%3D&suffix_path=/200/' + IntToStr(curPage);



      // Define o corpo da requisição com a página atual
      RequestData := TStringStream.Create('{"poSubType": "E", "statusType": "COL_TASK_STATUS", "colTaskOrPoStatus": "all"}', TEncoding.UTF8);

      try
        ResponseContent := HttpClient.Post(URL, RequestData);
        JSONObj := TJSONObject.ParseJSONValue(ResponseContent) as TJSONObject;
        try
          // Pega os dados de paginação
          PageVOObj := JSONObj.GetValue('pageVO') as TJSONObject;
          if Assigned(PageVOObj) then
          begin
            // Atualiza o total de páginas (caso ainda não esteja definido)
            totalPages := PageVOObj.GetValue<Integer>('totalPages');
          end;

          // Verifica e processa o array 'result'
          if JSONObj.TryGetValue('result', ResultArray) then
          begin
            Writeln('Processando página ', curPage, ' de ', totalPages, '...');
            for i := 0 to ResultArray.Count - 1 do
            begin
              Item := ResultArray.Get(i) as TJSONObject;

              primaryKey := Item.GetValue<string>('primaryKey');
              Controller.Projetohuawei.InserirSeNaoExistir(primaryKey, Item);
            end;
          end
          else
          begin
            Writeln('Erro: A chave "result" não existe ou não é um array.');
          end;

          Inc(curPage); // Incrementa a página para a próxima requisição
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


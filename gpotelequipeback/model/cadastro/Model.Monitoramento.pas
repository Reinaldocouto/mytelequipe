unit Model.Monitoramento;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, Model.Connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections, System.DateUtils;

type
  TMonitoramento = class
  private
    FConn: TFDConnection;
  public
    constructor Create;
    destructor Destroy; override;

    function Lista(const AQuery: TDictionary<string, string>; out Erro: string): TFDQuery;
  end;

implementation

{ TMonitoramento }

constructor TMonitoramento.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TMonitoramento.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TMonitoramento.Lista(const AQuery: TDictionary<string, string>; out Erro: string): TFDQuery;
var
  qry: TFDQuery;
  vDataHora: TDateTime;
  FS: TFormatSettings;

begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('SELECT ');
      SQL.Add('  id, ');
      SQL.Add('  placa, ');
      SQL.Add('  DATE_FORMAT(horario, "%d/%m/%Y %H:%i:%s") AS horario, ');
      SQL.Add('  DATE_FORMAT(data_inicio, "%d/%m/%Y") AS data_inicio, ');
      SQL.Add('  DATE_FORMAT(data_fim, "%d/%m/%Y") AS data_fim, ');
      SQL.Add('  endereco, ');
      SQL.Add('  latitude, ');
      SQL.Add('  longitude, ');
      SQL.Add('  velocidade, ');
      SQL.Add('  ignicao, ');
      SQL.Add('  bateria, ');
      SQL.Add('  sinal, ');
      SQL.Add('  gps, ');
      SQL.Add('  evento, ');
      SQL.Add('  hodometro, ');
      SQL.Add('  DATE_FORMAT(criado_em, "%d/%m/%Y %H:%i:%s") AS criado_em ');
      SQL.Add('FROM monitoramento ');
      SQL.Add('WHERE id IS NOT NULL ');

      if AQuery.ContainsKey('placa') then
      begin
        if Trim(AQuery.Items['placa']) <> '' then
        begin
          SQL.Add('AND placa = :placa');
          ParamByName('placa').AsString := AQuery.Items['placa'];
        end;
      end;
      FS := TFormatSettings.Create;
      FS.DateSeparator := '-';
      FS.ShortDateFormat := 'yy-MM-dd';


     if AQuery.ContainsKey('horario') then
      begin
        var s := AQuery.Items['horario'].Trim;
        if s <> '' then
        begin
         if TryStrToDateTime(s, vDataHora, FS) then
         begin
            SQL.Add('AND DATE(horario) = :horario');
            ParamByName('horario').AsDate := vDataHora
         end
         else
           raise Exception.Create('Data inválida: ' + s);
         end;
      end;

      if AQuery.ContainsKey('endereco') then
      begin
        if Trim(AQuery.Items['endereco']) <> '' then
        begin
          SQL.Add('AND endereco LIKE :endereco');
          ParamByName('endereco').AsString := '%' + Trim(AQuery.Items['endereco']) + '%';
        end;
      end;

      SQL.Add('ORDER BY horario DESC');

      Open;
    end;

    Erro := '';
    Result := qry;
  except
    on E: Exception do
    begin
      Erro := 'Erro ao consultar: ' + E.Message;
      Result := nil;
    end;
  end;
end;

end.


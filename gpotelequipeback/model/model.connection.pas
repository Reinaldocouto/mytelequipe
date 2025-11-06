unit model.connection;

interface

uses
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.FMXUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.DApt,
  FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL,
  System.IniFiles,
  System.Classes,
  System.SysUtils;

type
  TConnection = class
  private

  public
    class procedure CarregarConfig(connection: TFDConnection);
    class function CreateConnection: TFDConnection;
  end;

implementation

{ TConnection }

class function TConnection.CreateConnection: TFDConnection;
var
  Conn: TFDConnection;
begin
  try
    Conn := TFDConnection.Create(nil);
    if not Assigned(Conn) then
    begin
      Result := nil;
      Exit;
    end;

    CarregarConfig(Conn);
    Conn.TxOptions.AutoCommit := False;
    Result := Conn;
  except
    on E: Exception do
    begin
      if Assigned(Conn) then
      begin
        Conn.Free;
        Conn := nil;
      end;
      Result := nil;
      raise Exception.Create('Erro ao criar conexão: ' + E.Message);
    end;
  end;
end;

class procedure TConnection.CarregarConfig(connection: TFDConnection);
var
  ini: TIniFile;
begin
  if not Assigned(connection) then
    Exit;

  // Instanciar arquivo INI...
  ini := TIniFile.Create(GetCurrentDir + '\configserver.ini');
  try
    try
      // Buscar dados do arquivo fisico...
      with connection.Params do
      begin
        Values['DriverID'] := ini.ReadString('Banco de Dados', 'DriverID', '');
        Values['Database'] := ini.ReadString('Banco de Dados', 'Database', '');
        Values['User_name'] := ini.ReadString('Banco de Dados',
          'User_name', '');
        Values['Password'] := ini.ReadString('Banco de Dados', 'Password', '');
        Add('Port=' + ini.ReadString('Banco de Dados', 'Port', '3306'));
        Add('Server=' + ini.ReadString('Banco de Dados', 'Server',
          '18.228.142.1'));
      end;
    except
      on ex: exception do
        // Log do erro se necessário, mas não propague a exceção
    end;

  finally
    if Assigned(ini) then
      ini.DisposeOf;
  end;
end;

end.


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
  Conn := TFDConnection.Create(nil);
  CarregarConfig(Conn);
  Conn.TxOptions.AutoCommit := False;
  Result := Conn;
end;

class procedure TConnection.CarregarConfig(connection: TFDConnection);
var
  ini: TIniFile;
begin
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
    end;

  finally
    if Assigned(ini) then
      ini.DisposeOf;
  end;
end;

end.

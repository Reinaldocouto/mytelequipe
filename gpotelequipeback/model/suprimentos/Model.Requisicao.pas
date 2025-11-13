unit Model.Requisicao;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections,
  Model.RegrasdeNegocio;

type
  Trequisicao = class
  private
    FConn: TFDConnection;
    Fidgeral: Integer;
    Fidcolaborador: Integer;
    Fdata: string;
    Fnumero: Integer;
    Fpo: Integer;
    Fstatus: string;
    Fdescricaoservico: string;
    Fobservacao: string;
    Fdeletado: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    property idgeral: Integer read Fidgeral write Fidgeral;
    property idcolaborador: Integer read Fidcolaborador write Fidcolaborador;
    property data: string read Fdata write Fdata;
    property numero: Integer read Fnumero write Fnumero;
    property po: Integer read Fpo write Fpo;
    property status: string read Fstatus write Fstatus;
    property descricaoservico: string read Fdescricaoservico write Fdescricaoservico;
    property observacao: string read Fobservacao write Fobservacao;
    property deletado: Integer read Fdeletado write Fdeletado;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;
  end;

implementation

{ Trequisicao }

constructor Trequisicao.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor Trequisicao.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function Trequisicao.Editar(out erro: string): Boolean;
var
  qry: TFDQuery;
begin
  try

  finally
    qry.Free;
  end;

end;

function Trequisicao.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesrequisicao.data, ');
      SQL.Add('gespessoa.nome, ');
      SQL.Add('gespessoa.fantasia, ');
      SQL.Add('gesrequisicao.numero, ');
      SQL.Add('gesrequisicao.po, ');
      SQL.Add('gesrequisicao.descricaoservico, ');
      SQL.Add('gesrequisicao.status ');
      SQL.Add('From ');
      SQL.Add('gesrequisicao left Join ');
      SQL.Add('gespessoa On gespessoa.idpessoa = gesrequisicao.idcolaborador ');
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

function Trequisicao.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idcontroleestoque = idcontroleestoque+1 ');
        execsql;
        close;
        sql.Clear;
        sql.add('select idcontroleestoque from admponteiro ');
        Open;
        //idcontroleestoque := fieldbyname('idcontroleestoque').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := 1;
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

function Trequisicao.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesmarca WHERE gesmarca.idmarca is not null and gesmarca.idmarca =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idmarcabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesmarca.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesmarca.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesmarca.idloja = :idloja');
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


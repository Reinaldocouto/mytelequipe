unit Model.Chg;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TChg = class
  private
    FConn: TFDConnection;
    Fidchg: Integer;
    Ftipo: string;
    Fcriado_em: string;
    Fdata_inicio: string;
    Fhora_inicio: string;
    Fdata_fim: string;
    Fhora_fim: string;
    Fnumero: string;
    Fstatus: string;
    Fobservacoes: string;
    Fempresa: string;
  public
    constructor Create;
    destructor Destroy; override;

    property idchg: Integer read Fidchg write Fidchg;
    property tipo: string read Ftipo write Ftipo;
    property criado_em: string read Fcriado_em write Fcriado_em;
    property data_inicio: string read Fdata_inicio write Fdata_inicio;
    property hora_inicio: string read Fhora_inicio write Fhora_inicio;
    property data_fim: string read Fdata_fim write Fdata_fim;
    property hora_fim: string read Fhora_fim write Fhora_fim;
    property numero: string read Fnumero write Fnumero;
    property status: string read Fstatus write Fstatus;
    property observacoes: string read Fobservacoes write Fobservacoes;
    property empresa: string read Fempresa write Fempresa;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Inserir(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
    function Excluir(out erro: string): Boolean;
  end;

implementation

constructor TChg.Create;
begin
  inherited Create;
  FConn := TConnection.CreateConnection;
end;

destructor TChg.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TChg.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  Result := nil;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('select');
      SQL.Add(' chg.idchg as id,');
      SQL.Add(' chg.tipo,');
      SQL.Add(' chg.criado_em,');
      SQL.Add(' chg.data_inicio,');
      SQL.Add(' chg.hora_inicio,');
      SQL.Add(' chg.data_fim,');
      SQL.Add(' chg.hora_fim,');
      SQL.Add(' chg.numero,');
      SQL.Add(' chg.status,');
      SQL.Add(' chg.observacoes,');
      SQL.Add(' chg.empresa');
      SQL.Add(' from chg');
      SQL.Add(' where chg.idchg is not null');

      if AQuery.ContainsKey('empresa') then
      begin
        if Length(AQuery.Items['empresa']) > 0 then
        begin
          SQL.Add(' and chg.empresa = :empresa');
          ParamByName('empresa').AsString := AQuery.Items['empresa'];
        end;
      end;

      if AQuery.ContainsKey('status') then
      begin
        if Length(AQuery.Items['status']) > 0 then
        begin
          SQL.Add(' and chg.status = :status');
          ParamByName('status').AsString := AQuery.Items['status'];
        end;
      end;

      if AQuery.ContainsKey('tipo') then
      begin
        if Length(AQuery.Items['tipo']) > 0 then
        begin
          SQL.Add(' and chg.tipo = :tipo');
          ParamByName('tipo').AsString := AQuery.Items['tipo'];
        end;
      end;

      if AQuery.ContainsKey('numero') then
      begin
        if Length(AQuery.Items['numero']) > 0 then
        begin
          SQL.Add(' and chg.numero like ''%' + AQuery.Items['numero'] + '%''');
        end;
      end;

      SQL.Add(' order by chg.criado_em desc');
      Active := True;
    end;
    erro := '';
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      if Assigned(qry) then
        qry.Free;
      Result := nil;
    end;
  end;
end;

function TChg.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  Result := nil;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('select');
      SQL.Add(' *');
      SQL.Add(' from chg');
      SQL.Add(' where chg.idchg is not null and chg.idchg = :idchg');
      ParamByName('idchg').AsInteger := AQuery.Items['idchg'].ToInteger;
      Active := True;
    end;
    erro := '';
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      if Assigned(qry) then
        qry.Free;
      Result := nil;
    end;
  end;
end;

function TChg.Inserir(out erro: string): Boolean;
var
  qry: TFDQuery;
begin
  Result := False;
  qry := nil;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    try
      FConn.StartTransaction;
      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('insert into chg(');
        SQL.Add(' tipo,');
        SQL.Add(' data_inicio,');
        SQL.Add(' hora_inicio,');
        SQL.Add(' data_fim,');
        SQL.Add(' hora_fim,');
        SQL.Add(' numero,');
        SQL.Add(' status,');
        SQL.Add(' observacoes,');
        SQL.Add(' empresa');
        SQL.Add(') values (');
        SQL.Add(' :tipo,');
        SQL.Add(' :data_inicio,');
        SQL.Add(' :hora_inicio,');
        SQL.Add(' :data_fim,');
        SQL.Add(' :hora_fim,');
        SQL.Add(' :numero,');
        SQL.Add(' :status,');
        SQL.Add(' :observacoes,');
        SQL.Add(' :empresa');
        SQL.Add(')');

        ParamByName('tipo').AsString := tipo;
        ParamByName('data_inicio').AsString := data_inicio;
        ParamByName('hora_inicio').AsString := hora_inicio;
        ParamByName('data_fim').AsString := data_fim;
        ParamByName('hora_fim').AsString := hora_fim;
        ParamByName('numero').AsString := numero;
        ParamByName('status').AsString := status;
        ParamByName('observacoes').AsString := observacoes;
        ParamByName('empresa').AsString := empresa;
        ExecSQL;

        SQL.Clear;
        SQL.Add('select LAST_INSERT_ID() as idchg');
        Open;
        Fidchg := FieldByName('idchg').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := True;
    except
      on ex: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao cadastrar CHG: ' + ex.Message;
        Result := False;
      end;
    end;
  finally
    if Assigned(qry) then
      qry.Free;
  end;
end;

function TChg.Editar(out erro: string): Boolean;
var
  qry: TFDQuery;
begin
  Result := False;
  qry := nil;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    try
      FConn.StartTransaction;
      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('update chg set');
        SQL.Add(' tipo = :tipo,');
        SQL.Add(' data_inicio = :data_inicio,');
        SQL.Add(' hora_inicio = :hora_inicio,');
        SQL.Add(' data_fim = :data_fim,');
        SQL.Add(' hora_fim = :hora_fim,');
        SQL.Add(' numero = :numero,');
        SQL.Add(' status = :status,');
        SQL.Add(' observacoes = :observacoes,');
        SQL.Add(' empresa = :empresa');
        SQL.Add(' where idchg = :idchg');

        ParamByName('tipo').AsString := tipo;
        ParamByName('data_inicio').AsString := data_inicio;
        ParamByName('hora_inicio').AsString := hora_inicio;
        ParamByName('data_fim').AsString := data_fim;
        ParamByName('hora_fim').AsString := hora_fim;
        ParamByName('numero').AsString := numero;
        ParamByName('status').AsString := status;
        ParamByName('observacoes').AsString := observacoes;
        ParamByName('empresa').AsString := empresa;
        ParamByName('idchg').AsInteger := idchg;
        ExecSQL;
      end;
      FConn.Commit;
      erro := '';
      Result := True;
    except
      on ex: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao atualizar CHG: ' + ex.Message;
        Result := False;
      end;
    end;
  finally
    if Assigned(qry) then
      qry.Free;
  end;
end;

function TChg.Excluir(out erro: string): Boolean;
var
  qry: TFDQuery;
begin
  Result := False;
  qry := nil;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    try
      FConn.StartTransaction;
      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('delete from chg where idchg = :idchg');
        ParamByName('idchg').AsInteger := idchg;
        ExecSQL;
      end;
      FConn.Commit;
      erro := '';
      Result := True;
    except
      on ex: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao excluir CHG: ' + ex.Message;
        Result := False;
      end;
    end;
  finally
    if Assigned(qry) then
      qry.Free;
  end;
end;

end.


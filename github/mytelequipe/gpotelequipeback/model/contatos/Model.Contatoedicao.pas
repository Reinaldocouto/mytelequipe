unit Model.Contatoedicao;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TContatoedicao = class
  private
    FConn: TFDConnection;
    Fidcontato: Integer;
    Fidpessoa: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;

    Fnome: string;
    Fsetor: string;
    Femail: string;
    Ftelefone: string;
    Framal: string;

  public
    constructor Create;
    destructor Destroy; override;

    property idcontato: Integer read Fidcontato write Fidcontato;
    property idpessoa: Integer read Fidpessoa write Fidpessoa;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;

    property nome: string read Fnome write Fnome;
    property setor: string read Fsetor write Fsetor;
    property email: string read Femail write Femail;
    property telefone: string read Ftelefone write Ftelefone;
    property ramal: string read Framal write Framal;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro:string): TFDQuery;
    function Inserir(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;
  end;

implementation

{ TContatoedicao}

constructor TContatoedicao.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TContatoedicao.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

 function TContatoedicao.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idcontato = idcontato+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idcontato from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idcontato := fieldbyname('idcontato').AsInteger;
      end;
      erro := '';
      Result := id
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

function TContatoedicao.Editar(out erro: string): Boolean;
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
        SQL.Add('update gescontato set DELETADO=:DELETADO,NOME=:NOME,SETOR=:SETOR,EMAIL=:EMAIL, ');
        SQL.Add('TELEFONE=:TELEFONE,RAMAL=:RAMAL ');
        SQL.Add('where IDCLIENTE=:IDCLIENTE and IDLOJA=:IDLOJA and IDPESSOA=:IDPESSOA and IDCONTATO=:IDCONTATO');

        ParamByName('IDCONTATO').AsInteger := IDCONTATO;
		    ParamByName('NOME').Value := NOME;
        ParamByName('SETOR').Value := SETOR;
        ParamByName('EMAIL').Value := EMAIL;
        ParamByName('TELEFONE').Value := TELEFONE;
        ParamByName('RAMAL').Value := RAMAL;
        ParamByName('IDPESSOA').Value := IDPESSOA;
        ParamByName('IDCLIENTE').Value := IDCLIENTE;
        ParamByName('IDLOJA').Value := IDLOJA;
        ParamByName('DELETADO').Value := 0;

        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar contato: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TContatoedicao.Inserir(out erro: string): Boolean;
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
        SQL.Add('INSERT INTO gescontato(IDCONTATO,NOME,SETOR,EMAIL,TELEFONE,RAMAL, ');
        SQL.Add('IDPESSOA,IDCLIENTE,IDLOJA,DELETADO)');
        SQL.Add('       VALUES(:IDCONTATO,:NOME,:SETOR,:EMAIL,:TELEFONE,:RAMAL,');
        SQL.Add(':IDPESSOA,:IDCLIENTE,:IDLOJA,:DELETADO)');

        ParamByName('IDCONTATO').AsInteger := idcontato;
        ParamByName('NOME').Value := NOME;
        ParamByName('SETOR').Value := SETOR;
        ParamByName('EMAIL').Value := EMAIL;
        ParamByName('TELEFONE').Value := TELEFONE;
        ParamByName('RAMAL').Value := RAMAL;
        ParamByName('IDPESSOA').Value := IDPESSOA;
        ParamByName('IDCLIENTE').Value := IDCLIENTE;
        ParamByName('IDLOJA').Value := IDLOJA;
        ParamByName('DELETADO').Value := 0;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar contato: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TContatoedicao.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select  ');
      SQL.Add('gescontato.idcontato as id, ');
      SQL.Add('gescontato.nome, ');
      SQL.Add('gescontato.setor, ');
      SQL.Add('gescontato.email, ');
      SQL.Add('gescontato.telefone, ');
      SQL.Add('gescontato.ramal ');
      SQL.Add('From ');
      SQL.Add('gescontato WHERE gescontato.idcontato is not null ');

      if AQuery.ContainsKey('nome') then
      begin
        if Length(AQuery.Items['nome']) > 0 then
          SQL.Add('AND gescontato.nome like ''%' + AQuery.Items['nome'] + '%'' ');
      end;

      if AQuery.ContainsKey('setor') then
      begin
        if Length(AQuery.Items['setor']) > 0 then
          SQL.Add('AND gescontato.setor like ''%' + AQuery.Items['setor'] + '%'' ');
      end;

      if AQuery.ContainsKey('email') then
      begin
        if Length(AQuery.Items['email']) > 0 then
          SQL.Add('AND gescontato.email like ''%' + AQuery.Items['email'] + '%'' ');
      end;

      if AQuery.ContainsKey('telefone') then
      begin
        if Length(AQuery.Items['telefone']) > 0 then
          SQL.Add('AND gescontato.telefone like ''%' + AQuery.Items['telefone'] + '%'' ');
      end;

      if AQuery.ContainsKey('ramal') then
      begin
        if Length(AQuery.Items['ramal']) > 0 then
          SQL.Add('AND gescontato.ramal like ''%' + AQuery.Items['ramal'] + '%'' ');
      end;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gescontato.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;

      if AQuery.ContainsKey('idpessoabusca') then
      begin
        if Length(AQuery.Items['idpessoabusca']) > 0 then
        begin
          SQL.Add('AND gescontato.idpessoa = :idpessoa');
          ParamByName('idpessoa').Value := AQuery.Items['idpessoabusca'].ToInteger;
        end;
      end;

      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gescontato.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;

      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gescontato.idloja = :idloja');
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

function TContatoedicao.Listaid(const AQuery: TDictionary<string, string>;
  out erro: string): TFDQuery;
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
      SQL.Add('gescontato WHERE gescontato.idcontato is not null and gescontato.idcontato =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idcontatobusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gescontato.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idpessoa') then
      begin
        if Length(AQuery.Items['idpessoa']) > 0 then
        begin
          SQL.Add('AND gescontato.idpessoa = :idpessoa');
          ParamByName('idpessoa').Value := AQuery.Items['idpessoa'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gescontato.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gescontato.idloja = :idloja');
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




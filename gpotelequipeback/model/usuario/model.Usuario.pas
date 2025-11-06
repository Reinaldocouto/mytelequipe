unit model.Usuario;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, Firedac.Stan.Param, System.JSON,
  Dataset.Serialize, System.Generics.Collections;

type
  TUsuario = class
  private
    FConn: TFDConnection;
    FBAIRRO: string;
    FEMAIL: string;
    FCOD_CIDADE: string;
    FUF: string;
    FCEP: string;
    FSENHA: string;
    FCOMPLEMENTO: string;
    FNOME: string;
    FCIDADE: string;
    FENDERECO: string;
    FID_USUARIO: integer;
    Fcargo: string;
    Ftelefone: string;
    Fcelular: string;
    Fsite: string;

    procedure Validate(operacao: string);

  public
    constructor Create;
    destructor Destroy; override;

    property ID_USUARIO: integer read FID_USUARIO write FID_USUARIO;
    property NOME: string read FNOME write FNOME;
    property EMAIL: string read FEMAIL write FEMAIL;
    property SENHA: string read FSENHA write FSENHA;
    property ENDERECO: string read FENDERECO write FENDERECO;
    property COMPLEMENTO: string read FCOMPLEMENTO write FCOMPLEMENTO;
    property BAIRRO: string read FBAIRRO write FBAIRRO;
    property CIDADE: string read FCIDADE write FCIDADE;
    property UF: string read FUF write FUF;
    property CEP: string read FCEP write FCEP;
    property COD_CIDADE: string read FCOD_CIDADE write FCOD_CIDADE;
    property cargo: string read Fcargo write Fcargo;
    property telefone: string read Ftelefone write Ftelefone;
    property celular: string read Fcelular write Fcelular;
    property site: string read Fsite write Fsite;

    function Login: TJSONObject;
    function AlterasenhaPorEmail(out erro: string): Boolean;
    function ValidarToken(token: string; email: string; out erro: string): Boolean;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function alterasenha(out erro: string): Boolean;
    function listausuario(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
  end;

implementation

{ TFuncao }

constructor TUsuario.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TUsuario.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
end;

function TUsuario.listausuario(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesusuario WHERE gesusuario.idusuario is not null and gesusuario.idusuario =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idusuario'].ToInteger;
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

function TUsuario.alterasenha(out erro: string): Boolean;
var
  qry: TFDQuery;
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
        SQL.Add('update gesusuario set senha=:senha ');
        SQL.Add('where idusuario=:idusuario');
        ParamByName('idusuario').Value := id_usuario;
        ParamByName('senha').Value := senha;
        ExecSQL;
      end;
      FConn.Commit;
      erro := '';
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao alterar Senha: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TUsuario.AlterasenhaPorEmail(out erro: string): Boolean;
var
  qry: TFDQuery;
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
        SQL.Add('update gesusuario set senha=:senha ');
        SQL.Add('where email=:email');
        ParamByName('email').Value := EMAIL;
        ParamByName('senha').Value := senha;
        ExecSQL;
      end;
      FConn.Commit;
      erro := '';
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao alterar Senha: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TUsuario.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: integer;
begin
  a := AQuery.Items['idusuario'].ToInteger;
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select * from gesassinatura where idusuario=:idusuario ');
      ParamByName('idusuario').AsInteger := AQuery.Items['idusuario'].ToInteger;
      Open();
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

function TUsuario.Editar(out erro: string): Boolean;
var
  qry: TFDQuery;
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
        sql.add('select idassinatura from gesassinatura where idusuario=:idusuario ');
        ParamByName('idusuario').asinteger := ID_USUARIO;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('INSERT INTO gesassinatura(idusuario,nome,cargo,telefone,celular,email,site,endereco)');
          SQL.Add('             VALUES(:idusuario,:nome,:cargo,:telefone,:celular,:email,:site,:endereco)');
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gesassinatura set nome=:nome, ');
          SQL.Add('cargo=:cargo, ');
          SQL.Add('telefone=:telefone, ');
          SQL.Add('celular=:celular, ');
          SQL.Add('email=:email, ');
          SQL.Add('site=:site, ');
          SQL.Add('endereco=:endereco where idusuario=:idusuario ');
        end;
        ParamByName('idusuario').Value := ID_USUARIO;
        ParamByName('nome').Value := NOME;
        ParamByName('cargo').Value := cargo;
        ParamByName('telefone').Value := telefone;
        ParamByName('celular').Value := celular;
        ParamByName('email').Value := EMAIL;
        ParamByName('site').Value := site;
        ParamByName('endereco').Value := ENDERECO;
        ExecSQL;
      end;
      FConn.Commit;
      erro := '';
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar assinatura: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TUsuario.ValidarToken(token: string; email: string; out erro: string): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConn;
    Query.SQL.Clear;
    Query.SQL.Add('SELECT email FROM recuperarsenhatoken');
    Query.SQL.Add('WHERE token = :token AND email = :email AND expira > NOW() AND usadoEm IS NULL');
    Query.ParamByName('token').AsString := token;
    Query.ParamByName('email').AsString := email;
    Query.Open;

    if not Query.IsEmpty then
    begin
        // Atualiza o campo 'usadoEm' com a data e hora atual
      Query.SQL.Clear;
      Query.SQL.Add('UPDATE recuperarsenhatoken SET usadoEm = NOW() WHERE token = :token AND email = :email');
      Query.ParamByName('token').AsString := token;
      Query.ParamByName('email').AsString := email;
      Query.ExecSQL;
      FConn.Commit;
      Result := True;
    end
    else
      erro := 'Token inválido ou expirado.';

  except
    on E: Exception do
    begin
      erro := 'Erro ao validar token: ' + E.Message;
      Result := False;
    end;
  end;
end;

function TUsuario.Login: TJSONObject;
var
  qry: TFDQuery;
begin
  Validate('Login');
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('gesusuario.idusuario, ');
      SQL.Add('gesusuario.idcliente, ');
      SQL.Add('gesusuario.idloja, ');
      SQL.Add('gesusuario.nome, ');
      SQL.Add('gesusuario.email, ');
      SQL.Add('gesusuario.senha, ');
      SQL.Add('gesusuario.ativo, admcliente.idplano ');
      SQL.Add('From ');
      SQL.Add('gesusuario inner Join admcliente On admcliente.idcliente = gesusuario.idcliente  ');
      SQL.Add('WHERE gesusuario.email = :EMAIL AND gesusuario.senha = :SENHA and gesusuario.ativo = 1 ');
      ParamByName('EMAIL').Value := email;
      ParamByName('SENHA').Value := SENHA;
      Active := true;
    end;
    Result := qry.ToJSONObject();
  finally
    qry.Free;
  end;
end;

procedure TUsuario.Validate(operacao: string);
begin
  if (ID_USUARIO <= 0) and MatchStr(operacao, ['Listar', 'Editar']) then
    raise Exception.Create('Usuário não informado');

  if (email.IsEmpty) and MatchStr(operacao, ['Login', 'Inserir', 'Editar']) then
    raise Exception.Create('E-mail não informado');

  if (SENHA.IsEmpty) and MatchStr(operacao, ['Login', 'Inserir']) then
    raise Exception.Create('Senha não informada');

  if (NOME.IsEmpty) and MatchStr(operacao, ['Inserir', 'Editar']) then
    raise Exception.Create('Nome não informado');

  if (ENDERECO.IsEmpty) and MatchStr(operacao, ['Inserir']) then
    raise Exception.Create('Endereço não informado');

  if (BAIRRO.IsEmpty) and MatchStr(operacao, ['Inserir']) then
    raise Exception.Create('Bairro não informado');

  if (CIDADE.IsEmpty) and MatchStr(operacao, ['Inserir']) then
    raise Exception.Create('Cidade não informada');

  if (UF.IsEmpty) and MatchStr(operacao, ['Inserir']) then
    raise Exception.Create('UF não informado');

  if (CEP.IsEmpty) and MatchStr(operacao, ['Inserir']) then
    raise Exception.Create('CEP não informado');

  if (COD_CIDADE.IsEmpty) and MatchStr(operacao, ['Inserir']) then
    raise Exception.Create('Cód. cidade não informado');
end;

end.


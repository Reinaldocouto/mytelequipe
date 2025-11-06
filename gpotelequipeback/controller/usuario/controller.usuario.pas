unit controller.usuario;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, model.Usuario, UtFuncao, Controller.Auth;

procedure Registry;

procedure AlterarSenhaEmail(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure alterasenha(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Listausuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ValidarToken(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.post('v1/usuarios/login', Login);
  THorse.post('v1/usuarios/validartoken', ValidarToken);
  THorse.get('v1/usuarios/assinatura', Listaid);
  THorse.post('v1/usuarios/assinatura', salva);
  THorse.post('v1/usuarios/alterasenhaemail', AlterarSenhaEmail);
  THorse.post('v1/usuarios/alterasenha', alterasenha);
  THorse.get('v1/usuarios/alterar', Listausuario);
end;

procedure Listausuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TUsuario;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TUsuario.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listausuario(Req.Query.Dictionary, erro);
  try
    try
      arraydados := qry.ToJSONObject;
      if erro = '' then
        Res.Send<TJSONObject>(arraydados).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    qry.Free;
    servico.Free;
  end;
end;

procedure ValidarToken(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TUsuario;
  qry: TFDQuery;
  erro, email, token: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  // Tenta criar o serviço
  try
    body := Req.Body<TJSONObject>;
    servico := TUsuario.Create;
  except
    on E: Exception do
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco: ' + E.Message))
        .Status(THTTPStatus.InternalServerError);
      exit;
    end;
  end;

  email := body.getvalue<string>('email', '');
  token := body.getvalue<string>('token', '');
  if (token = '') or (email = '') then
  begin
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Token ou E-mail não fornecido.')).Status(THTTPStatus.BadRequest);
    servico.Free;
    exit;
  end;

  // Chama a função ValidarToken
  if servico.ValidarToken(token, email, erro) then
  begin
    // Se o token for válido, retorne o e-mail
    Res.Send<TJSONObject>(CreateJsonObj('retorno', 'Dados salvos com sucesso')).Status(THTTPStatus.OK);
  end
  else
  begin
    // Caso contrário, retorna o erro
    Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
  end;

  // Libera recursos
  servico.Free;
end;



procedure alterasenha(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TUsuario;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TUsuario.Create;
  try
    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idusuario', '')) then
        servico.id_usuario := body.getvalue<integer>('idusuario', 0)
      else
        servico.id_usuario := 0;
      servico.senha := body.getvalue<string>('senha1', '');

      if Length(erro) = 0 then
      begin
        if servico.alterasenha(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.id_usuario)).Status(THTTPStatus.Created)
        else
          Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
      end
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.BadRequest);
    except
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

procedure AlterarSenhaEmail(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TUsuario;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TUsuario.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.EMAIL := body.getvalue<string>('email', '');
      servico.senha := body.getvalue<string>('senha', '');

      if servico.EMAIL = '' then
      begin
        Res.Send('E-mail não fornecido.').Status(400);
        exit;
      end;
      if servico.senha = '' then
      begin
        Res.Send('Senha não fornecido.').Status(400);
        exit;
      end;

      if Length(erro) = 0 then
      begin
        if servico.AlterasenhaPorEmail(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.id_usuario)).Status(THTTPStatus.Created)
        else
          Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
      end
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.BadRequest);
    except
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  usuario: TUsuario;
  body: TJSONValue;
  json: TJSONObject;
begin
  usuario := TUsuario.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      usuario.EMAIL := body.GetValue<string>('email', '');
      usuario.SENHA :=  body.GetValue<string>('senha', '');
      json := usuario.Login;
     { if json.size = 0 then
        Res.Send<TJSONObject>(CreateJsonObj('erro', 'E-mail ou senha inválida')).Status(THTTPStatus.Unauthorized)
      else
      begin
        usuario.ID_USUARIO := json.GetValue<integer>('idusuario', 0);
                // Gerar token JWT com o id_usuario dentro dele...
        json.AddPair('token', Criar_Token(usuario.ID_USUARIO));
        Res.Send<TJSONObject>(json).Status(THTTPStatus.OK);
      end; }

      if json.size = 0 then
        Res.Send('E-mail ou senha inválida.').Status(401)
      else
      begin
        usuario.ID_USUARIO := json.GetValue<integer>('idusuario', 0);
        Res.Send<TJSONObject>(json).Status(THTTPStatus.OK);
      end;

    except
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    usuario.Free;
  end;
end;

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TUsuario;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TUsuario.Create;
  try

    try
      body := Req.body<TJSONObject>;

      servico.id_usuario := body.getvalue<integer>('idusuario', 0);
      servico.nome := body.getvalue<string>('nome','');
      servico.cargo := body.getvalue<string>('cargo','');
      servico.telefone := body.getvalue<string>('telefone','');
      servico.celular := body.getvalue<string>('celular','');
      servico.email := body.getvalue<string>('email','');
      servico.site := body.getvalue<string>('site','');
      servico.endereco := body.getvalue<string>('endereco','');

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.ID_USUARIO)).Status(THTTPStatus.Created)
        else
          Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
      end
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.BadRequest);
    except
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TUsuario;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TUsuario.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listaid(Req.Query.Dictionary, erro);
  try
    try
      arraydados := qry.ToJSONObject;
      if erro = '' then
        Res.Send<TJSONObject>(arraydados).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    qry.Free;
    servico.Free;
  end;
end;

end.


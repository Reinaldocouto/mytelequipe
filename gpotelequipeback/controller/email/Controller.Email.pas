unit Controller.Email;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Email, UtFuncao, Controller.Auth, Horse.Upload;

procedure Registry;

procedure EnviarEmail(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure EnviarEmailEnviarTokenRecuperarSenha(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure EnviarEmailpj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure EnviarEmailpjtelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure EnviarEmailpjzte(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure EnviarEmailpjhuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure EnviarEmailpjextrato(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure EnviarEmailpjextratocosmx(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure EnviarEmailpjextratotelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.post('v1/email', EnviarEmail);
  THorse.post('v1/email/recuperarsenha', EnviarEmailEnviarTokenRecuperarSenha);
  THorse.post('v1/email/acionamentopj', EnviarEmailpj);
  THorse.post('v1/email/acionamentopjtelefonica', EnviarEmailpjtelefonica);
  THorse.post('v1/email/acionamentopjzte', EnviarEmailpjzte);
  THorse.post('v1/email/acionamentopjhuawei', EnviarEmailpjhuawei);
  THorse.post('v1/email/acionamentopj/extrato', EnviarEmailpjextrato);
  THorse.post('v1/email/acionamentopj/extratocosmx', EnviarEmailpjextratocosmx);
  THorse.post('v1/email/acionamentopj/extratotelefonica', EnviarEmailpjextratotelefonica);
end;

procedure EnviarEmail(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Temail;
  destinatario, assunto, texto: string;
  body: TJSONObject;
begin
  servico := Temail.Create;
  try
    try
      body := Req.Body<TJSONObject>;

      destinatario := body.GetValue<string>('destinatario', '');
      assunto := body.GetValue<string>('assunto', '');
      texto := body.GetValue<string>('texto', '');

      servico.SendEmail(destinatario, assunto, texto);

      Res.Send('E-mail enviado com sucesso').Status(200);

    except
      on ex: exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

procedure EnviarEmailEnviarTokenRecuperarSenha(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Temail;
  destinatario, erro: string;
  body: TJSONObject;
begin
  servico := Temail.Create;
  try
  try
  body := Req.Body<TJSONObject>;  // Obtendo o corpo da requisição
  destinatario := body.GetValue<string>('email');  // Recuperando o e-mail enviado no corpo da requisição

  // Verificando se o e-mail foi passado corretamente
  if destinatario = '' then
  begin
    Res.Send('E-mail não fornecido.').Status(400);  // Envia status 400 se o e-mail não for informado
    exit;
  end;

  // Chamando a função para gerar o token
  if servico.GerarTokenRecuperacaoSenha(destinatario, erro) then
  begin
    Res.Send('E-mail enviado com sucesso').Status(200);  // Envia status 200 se o token for gerado com sucesso
  end
  else
  begin
    // Se houve um erro na geração do token, envia status 500
    Res.Send('Erro ao gerar token: ' + erro).Status(500);
  end;
except
  on ex: exception do
  begin
    // Se houve qualquer exceção, retorna um erro genérico com status 500
    Res.Send('Erro inesperado: ' + ex.Message).Status(500);
  end;
end;

  finally
    servico.Free;
  end;
end;

procedure EnviarEmailpj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Temail;
  destinatario, assunto, texto, cliente, regiona, site, nomecolaboradorpj, retanexo: string;
  body: TJSONObject;
begin
  servico := Temail.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      destinatario := body.GetValue<string>('destinatario', '') + ';' + body.GetValue<string>('destinatario1', '');
      regiona := copy(body.GetValue<string>('regiona', ' '), 4, length(body.GetValue<string>('regiona', ' ')));
      cliente := body.GetValue<string>('cliente', '');
      site := body.GetValue<string>('site', '');
      servico.sitenome := body.GetValue<string>('site', '');
      nomecolaboradorpj := body.GetValue<string>('nomecolaboradorpj', '');
      assunto := body.GetValue<string>('assunto', '');
      assunto := assunto + ' ' + cliente + ' ' + regiona + ' ' + nomecolaboradorpj + ' ' + site;
      servico.idpessoa := body.GetValue<string>('idpessoa', '');
      servico.numero := body.GetValue<string>('numero', '');
      servico.idusuario := body.GetValue<string>('idusuario', '');
      retanexo := 'C:\servidorgpo\anexo\' + body.GetValue<string>('retanexo', '');

      servico.SendEmail(destinatario, assunto, servico.ExecuteSelect, retanexo);

      Res.Send('E-mail enviado com sucesso').Status(200);

      servico.marcacomoenviado;

    except
      on ex: exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;


procedure EnviarEmailpjtelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Temail;
  destinatario, assunto, texto, cliente, regiona, site, nomecolaboradorpj, retanexo: string;
  body: TJSONObject;
begin
  servico := Temail.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      destinatario := body.GetValue<string>('destinatario', '') + ';' + body.GetValue<string>('destinatario1', '');
      servico.os := body.GetValue<string>('uididpmts', '');
      servico.idusuario := body.GetValue<string>('idusuario', '');
      retanexo := 'C:\servidorgpo\anexo\' + body.GetValue<string>('retanexo', '');
      assunto := body.GetValue<string>('assunto', '');

      servico.SendEmail(destinatario, assunto, servico.Executeacionamentotelefonica, retanexo);

      Res.Send('E-mail enviado com sucesso').Status(200);

      servico.marcacomoenviado;

    except
      on ex: exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;



procedure EnviarEmailpjzte(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Temail;
  destinatario, assunto, texto, cliente, regiona, site, nomecolaboradorpj, retanexo: string;
  body: TJSONObject;
begin
  servico := Temail.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      destinatario := body.GetValue<string>('destinatario1', '');
      if Length(body.GetValue<string>('destinatario', '')) > 0 then
        destinatario := destinatario + ';' + body.GetValue<string>('destinatario', '');

      regiona := copy(body.GetValue<string>('regiona', ' '), 4, length(body.GetValue<string>('regiona', ' ')));
      cliente := body.GetValue<string>('cliente', '');
      site := body.GetValue<string>('site', '');
      servico.sitenome := body.GetValue<string>('site', '');
      nomecolaboradorpj := body.GetValue<string>('nomecolaboradorpj', '');
      assunto := body.GetValue<string>('assunto', '');
      assunto := assunto + ' ' + nomecolaboradorpj;
      servico.idpessoa := body.GetValue<string>('idpessoa', '');
      servico.os := body.GetValue<string>('os', '');
      servico.idusuario := body.GetValue<string>('idusuario', '');
      if length(body.GetValue<string>('retanexo', '')) > 0 then
        retanexo := 'C:\servidorgpo\anexo\' + body.GetValue<string>('retanexo', '')
      else
        retanexo := '';

      servico.SendEmail(destinatario, assunto, servico.ExecuteSelectzte, retanexo);

      Res.Send('E-mail enviado com sucesso').Status(200);

   //   servico.marcacomoenviado;

    except
      on ex: exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

procedure EnviarEmailpjhuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Temail;
  destinatario, assunto, texto, cliente, regiona, site, nomecolaboradorpj, retanexo: string;
  body: TJSONObject;
begin
  servico := Temail.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      destinatario := body.GetValue<string>('destinatario1', '');
      if Length(body.GetValue<string>('destinatario', '')) > 0 then
        destinatario := destinatario + ';' + body.GetValue<string>('destinatario', '');

      regiona := copy(body.GetValue<string>('regiona', ' '), 4, length(body.GetValue<string>('regiona', ' ')));
      cliente := body.GetValue<string>('cliente', '');
      site := body.GetValue<string>('site', '');
      servico.sitenome := body.GetValue<string>('site', '');
      nomecolaboradorpj := body.GetValue<string>('nomecolaboradorpj', '');
      assunto := body.GetValue<string>('assunto', '');
      assunto := assunto + ' ' + nomecolaboradorpj;
      servico.idpessoa := body.GetValue<string>('idpessoa', '');
      servico.os := body.GetValue<string>('os', '');
      servico.idusuario := body.GetValue<string>('idusuario', '');
      if length(body.GetValue<string>('retanexo', '')) > 0 then
        retanexo := 'C:\servidorgpo\anexo\' + body.GetValue<string>('retanexo', '')
      else
        retanexo := '';

      servico.SendEmail(destinatario, assunto, servico.ExecuteSelecthuawei, retanexo);

      Res.Send('E-mail enviado com sucesso').Status(200);

   //   servico.marcacomoenviado;

    except
      on ex: exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

procedure EnviarEmailpjextrato(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Temail;
  destinatario, assunto, texto, regiona: string;
  body: TJSONObject;
begin
  servico := Temail.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      destinatario := body.GetValue<string>('destinatario', '') + ';' + body.GetValue<string>('destinatario1', '');
      servico.empresa := body.GetValue<string>('empresa', '');
      assunto := body.GetValue<string>('assunto', '');
      regiona := body.GetValue<string>('regiona', ' ');
      servico.mespagamento := body.GetValue<string>('mespg', '');
      assunto := assunto + '  ' + regiona + '  ' + servico.empresa + ' ' + servico.mespagamento;
      servico.idpessoa := body.GetValue<string>('idpessoa', '');
      servico.observacao := body.GetValue<string>('observacao', '');
      servico.idusuario := body.GetValue<string>('idusuario', '');
      servico.numeroordem := body.GetValue<integer>('numero', 0);
      servico.status := body.GetValue<string>('status', '');
      servico.datapagamento := body.GetValue<string>('datapagamento', '');
      Writeln(servico.SendEmail(destinatario, assunto, servico.Executeextrato));

      Res.Send('E-mail enviado com sucesso').Status(200);

    except
      on ex: exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

procedure EnviarEmailpjextratocosmx(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Temail;
  destinatario, assunto, texto, regiona: string;
  body: TJSONObject;
begin
  servico := Temail.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      destinatario := body.GetValue<string>('destinatario', '') + ';' + body.GetValue<string>('destinatario1', '');
      servico.empresa := body.GetValue<string>('empresa', '');
      assunto := body.GetValue<string>('assunto', '');
      regiona := body.GetValue<string>('regiona', ' ');
      servico.mespagamento := body.GetValue<string>('mespg', '');
      assunto := assunto + '  ' + regiona + '  ' + servico.empresa + ' ' + servico.mespagamento;
      servico.idpessoa := body.GetValue<string>('idpessoa', '');
      servico.observacao := body.GetValue<string>('observacao', '');
      servico.idusuario := body.GetValue<string>('idusuario', '');
      servico.numeroordem := body.GetValue<integer>('numero', 0);
      Writeln(servico.SendEmail(destinatario, assunto, servico.Executeextratocosmx));

      Res.Send('E-mail enviado com sucesso').Status(200);

    except
      on ex: exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

procedure EnviarEmailpjextratotelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: Temail;
  destinatario, assunto, texto, regiona: string;
  body: TJSONObject;
begin
  servico := Temail.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      destinatario := body.GetValue<string>('destinatario', '') + ';' + body.GetValue<string>('destinatario1', '');
      servico.empresa := body.GetValue<string>('empresa', '');
      assunto := body.GetValue<string>('assunto', '');
      regiona := body.GetValue<string>('regiona', ' ');
      servico.mespagamento := body.GetValue<string>('mespg', '');
      assunto := assunto + '  ' + regiona + '  ' + servico.empresa + ' ' + servico.mespagamento;
      servico.idpessoa := body.GetValue<string>('idempresalocal', '');
      servico.observacao := body.GetValue<string>('observacao', '');
      servico.idusuario := body.GetValue<string>('idusuario', '');
//      servico.numeroordem := body.GetValue<integer>('numero', 0);
      servico.datapagamento := body.GetValue<string>('datapagamento', '');
      servico.status := body.GetValue<string>('tipopagamento', '');

      Writeln(servico.SendEmail(destinatario, assunto, servico.Executeextratotelefonica));

      Res.Send('E-mail enviado com sucesso').Status(200);

    except
      on ex: exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

end.


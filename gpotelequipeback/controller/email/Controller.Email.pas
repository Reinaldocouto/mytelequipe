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

// + Nova rota para envio de e-mail ao gerar Ordem de Servi�o
procedure EnviarEmailOrdemServico(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.post('v1/email',                               EnviarEmail);
  THorse.post('v1/email/recuperarsenha',                EnviarEmailEnviarTokenRecuperarSenha);
  THorse.post('v1/email/acionamentopj',                 EnviarEmailpj);
  THorse.post('v1/email/acionamentopjtelefonica',       EnviarEmailpjtelefonica);
  THorse.post('v1/email/acionamentopjzte',              EnviarEmailpjzte);
  THorse.post('v1/email/acionamentopjhuawei',           EnviarEmailpjhuawei);
  THorse.post('v1/email/acionamentopj/extrato',         EnviarEmailpjextrato);
  THorse.post('v1/email/acionamentopj/extratocosmx',    EnviarEmailpjextratocosmx);
  THorse.post('v1/email/acionamentopj/extratotelefonica', EnviarEmailpjextratotelefonica);

  // + Registro da nova rota para Ordem de Servi�o
  THorse.post('v1/email/ordemservico',                  EnviarEmailOrdemServico);
end;

procedure EnviarEmail(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmail;
  destinatario, assunto, texto: string;
  body: TJSONObject;
begin
  servico := TEmail.Create;
  try
    try
      body := Req.Body<TJSONObject>;

      destinatario := body.GetValue<string>('destinatario', '');
      assunto       := body.GetValue<string>('assunto', '');
      texto         := body.GetValue<string>('texto', '');

      servico.SendEmail(destinatario, assunto, texto);

      Res.Send('E-mail enviado com sucesso').Status(200);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

procedure EnviarEmailEnviarTokenRecuperarSenha(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmail;
  destinatario, erro: string;
  body: TJSONObject;
begin
  servico := TEmail.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      destinatario := body.GetValue<string>('email');

      if destinatario = '' then
      begin
        Res.Send('E-mail n�o fornecido.').Status(400);
        Exit;
      end;

      if servico.GerarTokenRecuperacaoSenha(destinatario, erro) then
        Res.Send('E-mail enviado com sucesso').Status(200)
      else
        Res.Send('Erro ao gerar token: ' + erro).Status(500);
    except
      on ex: Exception do
        Res.Send('Erro inesperado: ' + ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

procedure EnviarEmailpj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmail;
  destinatario, regiona, cliente, site, nomecolaboradorpj, assunto, retanexo: string;
  body: TJSONObject;
begin
  servico := TEmail.Create;
  try
    try
      body := Req.Body<TJSONObject>;

      destinatario      := body.GetValue<string>('destinatario', '') + ';' + body.GetValue<string>('destinatario1', '');
      regiona           := Copy(body.GetValue<string>('regiona',''), 4, MaxInt);
      cliente           := body.GetValue<string>('cliente','');
      site              := body.GetValue<string>('site','');
      servico.sitenome  := site;
      nomecolaboradorpj := body.GetValue<string>('nomecolaboradorpj','');
      assunto           := body.GetValue<string>('assunto','') + ' ' + cliente + ' ' + regiona + ' ' + nomecolaboradorpj + ' ' + site;
      servico.idpessoa  := body.GetValue<string>('idpessoa','');
      servico.numero    := body.GetValue<string>('numero','');
      servico.idusuario := body.GetValue<string>('idusuario','');
      servico.ids       := body.GetValue<string>('ids','');
      retanexo          := 'C:\servidorgpo\anexo\' + body.GetValue<string>('retanexo','');

      servico.SendEmail(destinatario, assunto, servico.ExecuteSelect, retanexo);

      Res.Send('E-mail enviado com sucesso').Status(200);
      servico.marcacomoenviado;
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

procedure EnviarEmailpjtelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmail;
  destinatario, assunto, retanexo, texto: string;
  body: TJSONObject;
begin
  servico := TEmail.Create;
  try
    try
      body := Req.Body<TJSONObject>;

      destinatario := body.GetValue<string>('destinatario', '') + ';' + body.GetValue<string>('destinatario1', '');
      servico.os   := body.GetValue<string>('uididpmts','');
      servico.idusuario := body.GetValue<string>('idusuario','');
      retanexo     := 'C:\servidorgpo\anexo\' + body.GetValue<string>('retanexo','');
      assunto      := body.GetValue<string>('assunto','');
      servico.ids  := body.GetValue<string>('ids','');
      texto := servico.Executeacionamentotelefonica;
      servico.SendEmail(destinatario, assunto, texto, retanexo);

      Res.Send('E-mail enviado com sucesso').Status(200);
      servico.marcacomoenviado;
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

procedure EnviarEmailpjzte(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmail;
  destinatario, regiona, cliente, site, nomecolaboradorpj, assunto, retanexo: string;
  body: TJSONObject;
begin
  servico := TEmail.Create;
  try
    try
      body := Req.Body<TJSONObject>;

      destinatario := body.GetValue<string>('destinatario1','');
      if Length(body.GetValue<string>('destinatario','')) > 0 then
        destinatario := destinatario + ';' + body.GetValue<string>('destinatario','');

      regiona           := Copy(body.GetValue<string>('regiona',''), 4, MaxInt);
      cliente           := body.GetValue<string>('cliente','');
      site              := body.GetValue<string>('site','');
      servico.sitenome  := site;
      nomecolaboradorpj := body.GetValue<string>('nomecolaboradorpj','');
      assunto           := body.GetValue<string>('assunto','') + ' ' + nomecolaboradorpj;
      servico.idpessoa  := body.GetValue<string>('idpessoa','');
      servico.os        := body.GetValue<string>('os','');
      servico.idusuario := body.GetValue<string>('idusuario','');

      if Length(body.GetValue<string>('retanexo','')) > 0 then
        retanexo := 'C:\servidorgpo\anexo\' + body.GetValue<string>('retanexo','')
      else
        retanexo := '';

      servico.SendEmail(destinatario, assunto, servico.ExecuteSelectzte, retanexo);

      Res.Send('E-mail enviado com sucesso').Status(200);
      // servico.marcacomoenviado;
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

procedure EnviarEmailpjhuawei(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmail;
  destinatario, regiona, cliente, site, nomecolaboradorpj, assunto, retanexo: string;
  body: TJSONObject;
begin
  servico := TEmail.Create;
  try
    try
      body := Req.Body<TJSONObject>;

      destinatario := body.GetValue<string>('destinatario1','');
      if Length(body.GetValue<string>('destinatario','')) > 0 then
        destinatario := destinatario + ';' + body.GetValue<string>('destinatario','');

      regiona           := Copy(body.GetValue<string>('regiona',''), 4, MaxInt);
      cliente           := body.GetValue<string>('cliente','');
      site              := body.GetValue<string>('site','');
      servico.sitenome  := site;
      nomecolaboradorpj := body.GetValue<string>('nomecolaboradorpj','');
      assunto           := body.GetValue<string>('assunto','') + ' ' + nomecolaboradorpj;
      servico.idpessoa  := body.GetValue<string>('idpessoa','');
      servico.os        := body.GetValue<string>('os','');
      servico.idusuario := body.GetValue<string>('idusuario','');

      if Length(body.GetValue<string>('retanexo','')) > 0 then
        retanexo := 'C:\servidorgpo\anexo\' + body.GetValue<string>('retanexo','')
      else
        retanexo := '';

      servico.SendEmail(destinatario, assunto, servico.ExecuteSelecthuawei, retanexo);

      Res.Send('E-mail enviado com sucesso').Status(200);
      // servico.marcacomoenviado;
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

procedure EnviarEmailpjextrato(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmail;
  destinatario, regiona, assunto: string;
  body: TJSONObject;
begin
  servico := TEmail.Create;
  try
    try
      body := Req.Body<TJSONObject>;

      destinatario := body.GetValue<string>('destinatario','') + ';' + body.GetValue<string>('destinatario1','');
      servico.empresa     := body.GetValue<string>('empresa','');
      assunto             := body.GetValue<string>('assunto','');
      regiona             := body.GetValue<string>('regiona','');
      servico.mespagamento := body.GetValue<string>('mespg','');
      assunto             := assunto + '  ' + regiona + '  ' + servico.empresa + ' ' + servico.mespagamento;
      servico.idpessoa    := body.GetValue<string>('idpessoa','');
      servico.observacao  := body.GetValue<string>('observacao','');
      servico.idusuario   := body.GetValue<string>('idusuario','');
      servico.numeroordem := body.GetValue<integer>('numero', 0);
      servico.status      := body.GetValue<string>('status','');
      servico.datapagamento := body.GetValue<string>('datapagamento','');

      Writeln(servico.SendEmail(destinatario, assunto, servico.Executeextrato));

      Res.Send('E-mail enviado com sucesso').Status(200);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

procedure EnviarEmailpjextratocosmx(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmail;
  destinatario, regiona, assunto: string;
  body: TJSONObject;
begin
  servico := TEmail.Create;
  try
    try
      body := Req.Body<TJSONObject>;

      destinatario := body.GetValue<string>('destinatario','') + ';' + body.GetValue<string>('destinatario1','');
      servico.empresa     := body.GetValue<string>('empresa','');
      assunto             := body.GetValue<string>('assunto','');
      regiona             := body.GetValue<string>('regiona','');
      servico.mespagamento := body.GetValue<string>('mespg','');
      assunto             := assunto + '  ' + regiona + '  ' + servico.empresa + ' ' + servico.mespagamento;
      servico.idpessoa    := body.GetValue<string>('idpessoa','');
      servico.observacao  := body.GetValue<string>('observacao','');
      servico.idusuario   := body.GetValue<string>('idusuario','');
      servico.numeroordem := body.GetValue<integer>('numero', 0);

      Writeln(servico.SendEmail(destinatario, assunto, servico.Executeextratocosmx));

      Res.Send('E-mail enviado com sucesso').Status(200);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

procedure EnviarEmailpjextratotelefonica(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmail;
  destinatario, regiona, assunto: string;
  body: TJSONObject;
begin
  servico := TEmail.Create;
  try
    try
      body := Req.Body<TJSONObject>;

      destinatario := body.GetValue<string>('destinatario','') + ';' + body.GetValue<string>('destinatario1','');
      servico.empresa     := body.GetValue<string>('empresa','');
      assunto             := body.GetValue<string>('assunto','');
      regiona             := body.GetValue<string>('regiona','');
      servico.mespagamento := body.GetValue<string>('mespg','');
      assunto             := assunto + '  ' + regiona + '  ' + servico.empresa + ' ' + servico.mespagamento;
      servico.idpessoa    := body.GetValue<string>('idempresalocal','');
      servico.observacao  := body.GetValue<string>('observacao','');
      servico.idusuario   := body.GetValue<string>('idusuario','');
      servico.datapagamento := body.GetValue<string>('datapagamento','');
      servico.status      := body.GetValue<string>('tipopagamento','');

      Writeln(servico.SendEmail(destinatario, assunto, servico.Executeextratotelefonica));

      Res.Send('E-mail enviado com sucesso').Status(200);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

// + Implementa��o da rotina de envio de e-mail para Ordem de Servi�o
procedure EnviarEmailOrdemServico(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TEmail;
  body: TJSONObject;
  dest,  assunto: string;
  osId: string;
  bodyHTML: string;
begin
  servico := TEmail.Create;
  try
    try
      body  := Req.Body<TJSONObject>;
      dest :=  body.GetValue<string>('dest','');
      assunto := body.GetValue<string>('assunto','');
      osId  := body.GetValue<string>('osId', '');

      // monta HTML simples da OS
      bodyHTML := Format(
        '<h3>Solicita��o de material criada da OBRA/OS '+osId+' </h3>' +
        '<p>Verifique os detalhes no sistema.</p>',
        [osId]
      );


      // dispara envio
      if servico.SendEmail(dest , assunto, bodyHTML) then
        Res.Send('E-mail de OS enviado com sucesso').Status(200)
      else
        Res.Send('Falha no envio do e-mail OS').Status(500);
    except
      on ex: Exception do
        Res.Send(ex.Message).Status(500);
    end;
  finally
    servico.Free;
  end;
end;

end.


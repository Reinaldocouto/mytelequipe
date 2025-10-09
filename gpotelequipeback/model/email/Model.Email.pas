unit Model.Email;

interface

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Types,
  System.DateUtils,
  System.RegularExpressions,
  System.Generics.Collections,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.DApt,
  IdSMTP,
  IdMessage,
  IdSSLOpenSSL,
  IdExplicitTLSClientServerBase,
  IdText,
  IdAttachmentFile,
  model.connection,
  System.IOUtils;


type
    TEmailModelo = (emInstalacao, emDriveTest, emSurvey, emLegado);
    TDiariaDTO = record
    Numero: string;
    DataSolicitacao: TDateTime;
    Colaborador: string;
    NomeColaborador: string;
    Projeto: string;
    SiteId: string;
    SiglaSite: string;
    Regional: string;
    PO: string;
    Local: string;
    Descricao: string;
    Cliente: string;
    ValorOutrasSolicitacoes: Double;
    Diarias: Double;
    ValorTotal: Double;
    Solicitante: string;

  end;

type
  Temail = class
  private
    FConn: TFDConnection;
    Fidpessoa: string;
    Fidusuario: string;
    Femailacionamento: string;
    Femailextrato: string;
    Fempresa: string;
    Fsitenome: string;
    Fnumero: string;
    Fmespagamento: string;
    fretanexo: string;
    Fobservacao: string;
    Fnumeroordem: Integer;
    Fos: string;
    Fdatapagamento: string;
    Fstatus: string;
    Fids: string;

  public
    assinaturamontada: string;
    constructor Create;
    destructor Destroy; override;

    property idpessoa: string read Fidpessoa write Fidpessoa;
    property idusuario: string read Fidusuario write Fidusuario;
    property emailacionamento: string read Femailacionamento write Femailacionamento;
    property emailextrato: string read Femailextrato write Femailextrato;
    property empresa: string read Fempresa write Fempresa;
    property sitenome: string read Fsitenome write Fsitenome;
    property mespagamento: string read Fmespagamento write Fmespagamento;
    property datapagamento: string read Fdatapagamento write Fdatapagamento;
    property status: string read Fstatus write Fstatus;
    property numero: string read Fnumero write Fnumero;
    property numeroordem: integer read Fnumeroordem write Fnumeroordem;
    property retanexo: string read Fretanexo write Fretanexo;
    property observacao: string read Fobservacao write Fobservacao;
    property os: string read Fos write Fos;
    property ids: string read Fids write Fids;
    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function GerarTokenRecuperacaoSenha(email: string; out erro: string): Boolean;

    procedure assinatura;

    procedure marcacomoenviado;

    function SendEmail(destinatario, assunto, texto: string; arquivo: string = ''): Boolean;
    function ExecuteSelect: string;
    function ExecuteSelectzte: string;
    function ExecuteSelecthuawei: string;
    function Executeextrato: string;
    function Executeextratocosmx: string;
    function Executeacionamentotelefonica: string;
    function Executeextratotelefonica: string;
    function ExecuteOrdemServico(AOrdemID: Integer;
      const ADest1, ADest2, AAssunto: string): Boolean;


    function EnviarEmailDiaria(dadosDiaria: TDiariaDTO; out erro: string): Boolean;
    function IsValidEmail(const Email: string): Boolean;
    function HtmlEncode(const Value: string): string;
    function EnviarEmailConfirmacaoCartaTAF(const AOrdemID: string): Boolean;
    procedure EnviarEmailDriveTest(const NomeSite, PO, IDPMTS, DataExecucao: string);
    procedure EnviarEmailLegado(const NomeSite, PO, IDPMTS, DataIntegracao: string);
    procedure EnviarEmailSurvey(const NomeSite, PO, IDPMTS, DataExecucao: string);
    procedure EnviarEmailInstalacao(const NomeSite, PO, IDPMTS: string);
    function ObterEmailsFaturamento: string;
  end;

const
  MINHA_SENHA = 'siti123@@@@';

implementation

{ Temail }
function Temail.IsValidEmail(const Email: string): Boolean;
var
  Regex: TRegEx;
begin
  Regex := TRegEx.Create('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  Result := Regex.IsMatch(Email);
end;

function Temail.HtmlEncode(const Value: string): string;
begin
  Result := Value;
  Result := StringReplace(Result, '&', '&amp;', [rfReplaceAll]);
  Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
  Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
  Result := StringReplace(Result, '''', '&#39;', [rfReplaceAll]);
end;

procedure Temail.assinatura;
var
  qry: TFDQuery;
begin
  assinaturamontada := '';
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select * from gesassinatura where idusuario=:idusuario ');
      ParamByName('idusuario').Asstring := idusuario;
      Open();

      assinaturamontada := assinaturamontada + '<table class="no-border-table" > ';
      assinaturamontada := assinaturamontada + '<colgroup> ';
      assinaturamontada := assinaturamontada + '<col style="width: 200px;"> ';
      assinaturamontada := assinaturamontada + '<col style="width: 1px;"> ';
      assinaturamontada := assinaturamontada + '<col style="width: 300px;"> ';
      assinaturamontada := assinaturamontada + '</colgroup> ';
      assinaturamontada := assinaturamontada + '  <tr > ';
      assinaturamontada := assinaturamontada + '<td rowspan="8"><img src="https://sitinfo.com.br/wp-content/uploads/2025/01/logotelequipe.png" alt="" width="180"></td> ';
      assinaturamontada := assinaturamontada + '<td rowspan="8"><hr width="1" size="150" /></td>';
      assinaturamontada := assinaturamontada + '<td style="font-size: 12px;font-Weight: Bold; line-height: 1; " >' + FieldByName('nome').asstring + '</td> ';
      assinaturamontada := assinaturamontada + '<td rowspan="8"></td> ';
      assinaturamontada := assinaturamontada + '<td rowspan="8"></td> ';
      assinaturamontada := assinaturamontada + '  </tr> ';
      assinaturamontada := assinaturamontada + '  <tr> ';
      assinaturamontada := assinaturamontada + '    <td style="font-size: 10px; line-height: 0; " >' + FieldByName('cargo').asstring + '</td> ';
      assinaturamontada := assinaturamontada + '  </tr> ';
      assinaturamontada := assinaturamontada + '  <tr> ';
      assinaturamontada := assinaturamontada + '    <td style="font-size: 10px; line-height: 0;" >' + FieldByName('telefone').asstring + '</td> ';
      assinaturamontada := assinaturamontada + '  </tr> ';
      assinaturamontada := assinaturamontada + '  <tr> ';
      assinaturamontada := assinaturamontada + '    <td style="font-size: 10px; line-height: 0;" >' + FieldByName('celular').asstring + '</td> ';
      assinaturamontada := assinaturamontada + '  </tr> ';
      assinaturamontada := assinaturamontada + '  <tr> ';
      assinaturamontada := assinaturamontada + '    <td style="font-size: 10px; line-height: 0;" ><a href = mailto:' + FieldByName('email').asstring + '>' + FieldByName('email').asstring + '</a></td> ';
      assinaturamontada := assinaturamontada + '  </tr> ';
      assinaturamontada := assinaturamontada + '  <tr> ';
      assinaturamontada := assinaturamontada + '    <td style="font-size: 10px; line-height: 0;" ><a href = ' + FieldByName('site').asstring + ' target="_blank" rel="noopener noreferrer">' + FieldByName('site').asstring + '</a> </td> ';
      assinaturamontada := assinaturamontada + '  </tr> ';
      assinaturamontada := assinaturamontada + '  <tr> ';
      assinaturamontada := assinaturamontada + '    <td style="font-size: 10px; line-height: 1.5; " >' + FieldByName('endereco').asstring + '</td> ';
      assinaturamontada := assinaturamontada + '  </tr> ';
      assinaturamontada := assinaturamontada + '</table> ';

    end;

  except

  end;
end;

constructor Temail.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor Temail.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function Temail.SendEmail(destinatario, assunto, texto: string; arquivo: string = ''): Boolean;
var
  SMTP: TIdSMTP;
  Msg: TIdMessage;
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
  IdText: TIdText;
  Attach: TIdAttachmentFile;
begin
  if destinatario.IsEmpty then
    raise Exception.Create('E-mail do destint�rio n�o informado');
  if assunto.IsEmpty then
    raise Exception.Create('Assunto do e-mail n�o informado');
  if texto.IsEmpty then
    raise Exception.Create('Texto do e-mail n�o informado');

  Msg := TIdMessage.Create(nil);
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create();

    // SSL...
  IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
  IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;

  try
    Msg.From.Address := 'no-reply@rbasolucoes.com.br';
    Msg.From.Name := 'TELEQUIPE';
    Msg.Recipients.EMailAddresses := destinatario;
    Msg.Subject := assunto;
    Msg.Encoding := meMIME;


    //Msg.ContentType := 'text/html;charset=utf-8';
    //Msg.Body.Text := texto;

        // Corpo email...
    IdText := TIdText.Create(Msg.MessageParts);
    IdText.Body.Add(texto);
    IdText.ContentType := 'text/html;charset=utf-8';

        // Anexo...
    if FileExists(arquivo) then
     begin
      Attach := TIdAttachmentFile.Create(Msg.MessageParts, arquivo);
      Attach.ContentType := 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      Attach.FileName := 'Solicitação Adiantamento.xlsx';
     end;
    //  TIdAttachmentFile.Create(Msg.MessageParts, arquivo);  //--> c:\arquivos\teste.txt

  {
    SMTP := TIdSMTP.Create(nil);
    SMTP.IOHandler := IdSSLIOHandlerSocket;
    SMTP.Host := 'email-smtp.us-east-1.amazonaws.com';
    SMTP.Port := 465;
    SMTP.AuthType := satDefault;
    SMTP.UseTLS := utUseImplicitTLS;
    SMTP.Username := 'AKIAWC2LMZ3UNOQUJ2EC';
    SMTP.Password := 'BAl3NIIU+akylNxEGjAOpZnB+GJsHC2NgmC/piViHIfS';
   }
    SMTP := TIdSMTP.Create(nil);
    SMTP.IOHandler := IdSSLIOHandlerSocket;
    SMTP.Host := 'smtpi.kinghost.net';
    SMTP.Port := 465;
    SMTP.AuthType := satDefault;
    SMTP.UseTLS := utUseImplicitTLS;
    SMTP.Username := 'no-reply@rbasolucoes.com.br';
    SMTP.Password := 'BAl3@NIIU';


    SMTP.Connect;
    SMTP.Send(Msg);
    Result := True;


    {'senha kinghost'
    'BAl3@NIIU' }

  finally
    SMTP.Free;
    Msg.Free;
  end;
end;

function Temail.Editar(out erro: string): Boolean;
begin

end;

function TEmail.ExecuteSelecthuawei: string; // acionamento
var
  Query: TFDQuery;
  html1, html2, html3, htmlcompleto: string;
  total: Real;
begin
  html1 := '';
  html2 := '';
  html3 := '';
  html1 := html1 + '<!DOCTYPE html> ';
  html1 := html1 + '<html lang="en"> ';
  html1 := html1 + '<head> ';
  html1 := html1 + '<meta charset="UTF-8"> ';
  html1 := html1 + '<meta name="viewport" content="width=device-width, initial-scale=1.0"> ';
  html1 := html1 + '<title>Tabela</title> ';
  html1 := html1 + '<style> ';
  html1 := html1 + 'table { ';
  html1 := html1 + 'border-collapse: collapse; ';
  html1 := html1 + 'width: 100%; ';
  html1 := html1 + '} ';
  html1 := html1 + 'th, ';
  html1 := html1 + 'td { ';
  html1 := html1 + 'border: 1px solid black; ';
  html1 := html1 + 'padding: 8px; ';
  html1 := html1 + 'text-align: left; ';
  html1 := html1 + '} ';
  html1 := html1 + 'th { ';
  html1 := html1 + 'background-color: #009efb; ';
  html1 := html1 + '} ';
  html1 := html1 + '.no-border-table td { ';
  html1 := html1 + 'border: none; ';
  html1 := html1 + '} ';

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConn;
    Query.Close;
    Query.ClearBlobs;
    Query.sql.Clear;
    Query.SQL.Add('Select * From projetohuawei ');
    Query.SQL.Add('Where  ');
    Query.SQL.Add('projetohuawei.os =:os and idcolaboradorpj=:idcolaboradorpj ');
    Query.parambyname('idcolaboradorpj').Asstring := idpessoa;
    Query.parambyname('os').asstring := os;
    Query.Open;
    total := 0;

    html1 := html1 + '</style> ';
    html1 := html1 + '</head> ';
    html1 := html1 + '<body> ';
    html1 := html1 + '<h3>' + Query.FieldByName('observacaopj').AsString + '</h3> ';
    html1 := html1 + '<h2> </h2> ';
    html1 := html1 + '<table> ';
    html1 := html1 + '    <thead> ';
    html1 := html1 + '        <tr> ';
    html1 := html1 + '<th>ID</th> ';
    html1 := html1 + '<th>PROJECT CODE</th> ';
    html1 := html1 + '<th>SITECODE</th> ';
    html1 := html1 + '<th>SITENAME</th> ';
    html1 := html1 + '<th>ITEMCODE</th> ';
    html1 := html1 + '<th>Data do Pagamento</th> ';
    html1 := html1 + '<th>Status</th> ';
    html1 := html1 + '<th>ITEM DESCRIPTION</th> ';
    html1 := html1 + '<th>VALOR UNIT</th> ';
    html1 := html1 + '<th>QTY</th> ';
    html1 := html1 + '<th>VALOR TOTAL</th> ';
    html1 := html1 + '<th>VO</th> ';
    html1 := html1 + '<th>DATA ACIONAMENTO</th> ';
    html1 := html1 + '</tr> ';
    html1 := html1 + '</thead> ';
    html1 := html1 + '<tbody> ';

    while not Query.eof do
    begin
      html2 := html2 + '<tr>';
      html2 := html2 + '<td>' + Query.FieldByName('idh').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('projectNo').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('sitecode').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('sitename').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('itemCode').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('datadopagamento').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('status').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('itemDescription').AsString + '</td>';
      html2 := html2 + '<td>' + floattostrf(Query.FieldByName('valorpjunit').AsFloat, ffCurrency, 18, 2) + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('quantity').AsString + '</td>';
      html2 := html2 + '<td>' + floattostrf(Query.FieldByName('valorpj').AsFloat, ffCurrency, 18, 2) + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('vo').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('dataacionamento').AsString + '</td>';
      html2 := html2 + '</tr>';
      total := Query.FieldByName('valorpj').AsFloat + total;
      Query.Next();
    end;
    html2 := html2 + '<tr> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td><b> Total: ' + floattostrf(total, ffCurrency, 18, 2) + '</b></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '</tr> ';
    html2 := html2 + '</tbody> ';
    html2 := html2 + '</table> ';

    html3 := html3 + '</body> ';
    html3 := html3 + '</html> ';

    assinatura;
    htmlcompleto := html1 + html2 + assinaturamontada + html3;
    Result := html1 + html2 + assinaturamontada + html3;

  except
    Query.Free;
    raise;
  end;

end;

function TEmail.GerarTokenRecuperacaoSenha(email: string; out erro: string): Boolean;
var
  Query: TFDQuery;
  token: string;
  htmlEmail: string;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConn;

    // Gera um token �nico (exemplo simples, use uma biblioteca segura para produ��o)
    token := IntToStr(Random(1000000));

    // Verifica se j� existe um token para o email fornecido
    Query.SQL.Clear;
    Query.SQL.Add('SELECT COUNT(*) FROM recuperarsenhatoken WHERE email = :email');
    Query.ParamByName('email').AsString := email;

    try
      Query.Open;
      if Query.Fields[0].AsInteger > 0 then
      begin
        // Se j� existe um token, faz o update
        Query.SQL.Clear;
        Query.SQL.Add('UPDATE recuperarsenhatoken');
        Query.SQL.Add('SET token = :token, criado = NOW(), expira = DATE_ADD(NOW(), INTERVAL 1 HOUR), usadoEm = NULL');
        Query.SQL.Add('WHERE email = :email');
        Query.ParamByName('token').AsString := token;
        Query.ParamByName('email').AsString := email;

        Query.ExecSQL;
        FConn.Commit;
      end
      else
      begin
        // Se n�o existe, insere um novo token
        Query.SQL.Clear;
        Query.SQL.Add('INSERT INTO recuperarsenhatoken (token, email, criado, expira) VALUES (:token, :email, NOW(), DATE_ADD(NOW(), INTERVAL 1 HOUR))');
        Query.ParamByName('token').AsString := token;
        Query.ParamByName('email').AsString := email;

        Query.ExecSQL;
        FConn.Commit;
      end;
    except
      on E: Exception do
      begin
        // Tratar erros de execu��o, como viola��o de chave prim�ria ou problemas de conex�o
        FConn.Rollback;
        raise Exception.Create('Erro ao inserir o token: ' + E.Message);
      end;
    end;

    htmlEmail := '<!DOCTYPE html>' + '<html lang="pt-BR">' + '<head>' + '  <meta charset="UTF-8">' + '  <meta name="viewport" content="width=device-width, initial-scale=1.0">' + '  <title>Recupera��o de Senha</title>' + '  <style>' + '    body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }' + '    .container { max-width: 600px; margin: 20px auto; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }' +
      '    h2 { color: #333333; text-align: center; }' + '    p { color: #555555; font-size: 16px; line-height: 1.6; }' + '    .token { background-color: #f9f9f9; padding: 15px; border: 1px solid #dddddd; border-radius: 4px; text-align: center; font-size: 20px; font-weight: bold; color: #007BFF; margin: 20px 0; }' + '    .footer { text-align: center; margin-top: 20px; font-size: 14px; color: #888888; }' + '    .footer a { color: #007BFF; text-decoration: none; }' + '  </style>' + '</head>' + '<body>' +
      '  <div class="container">' + '    <h2>Recupera��o de Senha</h2>' + '    <p>Ol�,</p>' + '    <p>Voc� solicitou a recupera��o de senha. Segue abaixo o seu token:</p>' + '    <div class="token">' + token + '</div>' + '    <p>Este token � v�lido por <strong>1 hora</strong>. Utilize-o para redefinir sua senha.</p>' + '    <p>Se voc� n�o solicitou esta recupera��o, ignore este e-mail.</p>' + '    <div class="footer">' + '      <p>Atenciosamente,<br>Equipe de Suporte</p>' + '    </div>' + '  </div>' + '</body>' + '</html>';
    if SendEmail(email, 'Recupera��o de Senha', htmlEmail, erro) then
      Result := True
    else
      erro := 'Erro ao enviar e-mail: ' + erro;

  except
    on E: Exception do
    begin
      erro := 'Erro ao gerar token: ' + E.Message;
      Result := False;
    end;
  end;
  Query.Free;
end;

function TEmail.EnviarEmailDiaria(dadosDiaria: TDiariaDTO; out erro: string): Boolean;
var
  Query: TFDQuery;
  htmlEmail: string;
  destinatarios: TStringList;
  i: Integer;
  projetoFormatado: string;
  regionalFormatado: string;

  function FormatProjectName(const Projeto, Regional: string): string;
  var
    trimmedProjeto, trimmedRegional: string;
  begin
    trimmedProjeto := Trim(Projeto);
    trimmedRegional := Trim(Regional);
    Result := trimmedProjeto;

    if trimmedRegional <> '' then
    begin
      if trimmedProjeto = '' then
        Result := trimmedRegional
      else if not ContainsText(trimmedProjeto, ' - ' + trimmedRegional) then
        Result := trimmedProjeto + ' - ' + trimmedRegional;
    end;
  end;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  destinatarios := TStringList.Create;
  try
    // 1. Valida��o dos campos obrigat�rios
    if Trim(dadosDiaria.Numero) = '' then
    begin
      erro := 'Numero da diaria não informado';
      Exit;
    end;

    if dadosDiaria.DataSolicitacao = 0 then
    begin
      erro := 'Data de solicitação não informada';
      Exit;
    end;

    if Trim(dadosDiaria.NomeColaborador) = '' then
    begin
      erro := 'Nome do colaborador não informado';
      Exit;
    end;


    if dadosDiaria.ValorTotal <= 0 then
    begin
      erro := 'Valor total deve ser maior que zero';
      Exit;
    end;

    Query.Connection := FConn;

    Query.SQL.Clear;
    Query.SQL.Add('SELECT emaildiaria FROM gesemailconfiguracao ');
    try
      Query.Open;
      if not Query.IsEmpty then
      begin
        destinatarios.Delimiter := ';';
        destinatarios.StrictDelimiter := True; // Considera apenas v�rgulas como delimitador
        destinatarios.DelimitedText := Query.FieldByName('emaildiaria').AsString;

        // Remove espa�os em branco e verifica e-mails v�lidos
        for i := destinatarios.Count - 1 downto 0 do
        begin
          destinatarios[i] := Trim(destinatarios[i]);
          if destinatarios[i] = '' then
            destinatarios.Delete(i)
          else if not IsValidEmail(destinatarios[i]) then
          begin
            erro := 'E-mail inv�lido encontrado na configura��o: ' + destinatarios[i];
            Exit;
          end;
        end;

        if destinatarios.Count = 0 then
        begin
          erro := 'Nenhum e-mail v�lido encontrado na configura��o';
          Exit;
        end;
      end
      else
      begin
        erro := 'Nenhum e-mail configurado para o tipo "diaria"';
        Exit;
      end;
    except
      on E: Exception do
      begin
        erro := 'Erro ao buscar e-mails configurados: ' + E.Message;
        Exit;
      end;
    end;

    // 3. Preparar o HTML do e-mail
    try
      regionalFormatado := Trim(dadosDiaria.Regional);
      if regionalFormatado = '' then
        regionalFormatado := Trim(dadosDiaria.SiglaSite);

      projetoFormatado := FormatProjectName(dadosDiaria.Projeto, regionalFormatado);
      htmlEmail := '<!DOCTYPE html>' +
                   '<html lang="pt-BR">' +
                   '<head>' +
                   '  <meta charset="UTF-8">' +
                   '  <meta name="viewport" content="width=device-width, initial-scale=1.0">' +
                   '  <title>Nova Diaria Registrada</title>' +
                   '  <style>' +
                   '    body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }' +
                   '    .container { max-width: 600px; margin: 20px auto; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }' +
                   '    h2 { color: #333333; text-align: center; }' +
                   '    table { width: 100%; border-collapse: collapse; margin: 20px 0; }' +
                   '    th, td { padding: 12px; text-align: left; border-bottom: 1px solid #dddddd; }' +
                   '    th { background-color: #f9f9f9; }' +
                   '    .footer { text-align: center; margin-top: 20px; font-size: 14px; color: #888888; }' +
                   '    .valor { text-align: right; }' +
                   '  </style>' +
                   '</head>' +
                   '<body>' +
                   '  <div class="container">' +
                   '    <h2>Nova Diaria Registrada</h2>' +
                   '    <p>Uma nova diaria foi registrada no sistema. Seguem os detalhes:</p>' +
                   '    <table>' +
                   '      <tr><th>Numero:</th><td>' + HtmlEncode(dadosDiaria.Numero) + '</td></tr>' +
                   '      <tr><th>Data:</th><td>' + FormatDateTime('dd/mm/yyyy', dadosDiaria.DataSolicitacao) + '</td></tr>' +
                   '      <tr><th>Colaborador:</th><td>' + HtmlEncode(dadosDiaria.NomeColaborador) + '</td></tr>' +
                   '      <tr><th>Cliente:</th><td>' + HtmlEncode(dadosDiaria.Cliente) + '</td></tr>' +
                   '      <tr><th>Site ID:</th><td>' + HtmlEncode(dadosDiaria.SiteId) + '</td></tr>' +
                   '      <tr><th>Sigla Site:</th><td>' + HtmlEncode(dadosDiaria.SiglaSite) + '</td></tr>' +
                   '      <tr><th>PO:</th><td>' + HtmlEncode(dadosDiaria.PO) + '</td></tr>' +
                   '      <tr><th>Local:</th><td>' + HtmlEncode(dadosDiaria.Local) + '</td></tr>' +
                   '      <tr><th>Descrição:</th><td>' + HtmlEncode(dadosDiaria.Descricao) + '</td></tr>' +
                   '      <tr><th>Projeto:</th><td>' + HtmlEncode(projetoFormatado) + '</td></tr>' +
                   '      <tr><th>Outras Solicitacoes:</th><td class="valor">' + FormatFloat('R$ #,##0.00', dadosDiaria.ValorOutrasSolicitacoes) + '</td></tr>' +
                   '      <tr><th>Diarias:</th><td class="valor">' + HtmlEncode(dadosDiaria.Diarias.ToString) + '</td></tr>' +
                   '      <tr><th>Valor Total:</th><td class="valor"><strong>' + FormatFloat('R$ #,##0.00', dadosDiaria.ValorTotal) + '</strong></td></tr>' +
                   '    </table>' +
                   '    <div class="footer">' +
                   '      <p>Este e-mail automatico, favor nao responder.</p>' +
                   '    </div>' +
                   '  </div>' +
                   '</body>' +
                   '</html>';
    except
      on E: Exception do
      begin
        erro := 'Erro ao gerar HTML do e-mail: ' + E.Message;
        Exit;
      end;
    end;

    // 4. Enviar para todos os destinat�rios
    for i := 0 to destinatarios.Count - 1 do
    begin
     // if not SendEmail(destinatarios[i], 'Nova Diária Registrada - ' + dadosDiaria.Numero, htmlEmail, erro) then
      if not SendEmail(destinatarios[i], 'Nova Diária Registrada - ' + dadosDiaria.Numero, htmlEmail,
        TPath.Combine(ExtractFilePath(ParamStr(0)), 'C:\servidorgpo\diaria\Solicitação Adiantamento.xlsx')) then
      begin
        erro := 'Erro ao enviar e-mail para ' + destinatarios[i] + ': ' + erro;
        Exit;
      end;
    end;

    Result := True;
  except
    on E: Exception do
    begin
      erro := 'Erro inesperado ao enviar e-mail de di�ria: ' + E.Message;
      Result := False;
    end;
  end;
  Query.Free;
  destinatarios.Free;
end;
function TEmail.ExecuteSelectzte: string; // acionamento
var
  Query: TFDQuery;
  html1, html2, html3, htmlcompleto: string;
  total: Real;
begin
  html1 := '';
  html2 := '';
  html3 := '';
  html1 := html1 + '<!DOCTYPE html> ';
  html1 := html1 + '<html lang="en"> ';
  html1 := html1 + '<head> ';
  html1 := html1 + '<meta charset="UTF-8"> ';
  html1 := html1 + '<meta name="viewport" content="width=device-width, initial-scale=1.0"> ';
  html1 := html1 + '<title>Tabela</title> ';
  html1 := html1 + '<style> ';
  html1 := html1 + 'table { ';
  html1 := html1 + 'border-collapse: collapse; ';
  html1 := html1 + 'width: 100%; ';
  html1 := html1 + '} ';
  html1 := html1 + 'th, ';
  html1 := html1 + 'td { ';
  html1 := html1 + 'border: 1px solid black; ';
  html1 := html1 + 'padding: 8px; ';
  html1 := html1 + 'text-align: left; ';
  html1 := html1 + '} ';
  html1 := html1 + 'th { ';
  html1 := html1 + 'background-color: #009efb; ';
  html1 := html1 + '} ';
  html1 := html1 + '.no-border-table td { ';
  html1 := html1 + 'border: none; ';
  html1 := html1 + '} ';

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConn;
    Query.Close;
    Query.ClearBlobs;
    Query.sql.Clear;
    Query.SQL.Add('Select  ');
    Query.SQL.Add('obrazte.State,  ');
    Query.SQL.Add('obrazte.SiteID,  ');
    Query.SQL.Add('obrazte.SiteName,  ');
    Query.SQL.Add('obrazte.sitenamefrom,  ');
    Query.SQL.Add('obrazte.ZTECode,  ');
    Query.SQL.Add('obrazte.ServiceDescription,  ');
    Query.SQL.Add('obrazte.Qty,  ');
    Query.SQL.Add('obrazte.dataacionamento,  ');
    Query.SQL.Add('obrazte.observacaopj,  ');
    Query.SQL.Add('obrazte.valorlpu  ');
    Query.SQL.Add('From  ');
    Query.SQL.Add('obrazte  ');
    Query.SQL.Add('Where  ');
    Query.SQL.Add('obrazte.os =:os and obrazte.valorlpu > 0 ');
    Query.parambyname('os').asstring := os;
    Query.Open;
    total := 0;

    html1 := html1 + '</style> ';
    html1 := html1 + '</head> ';
    html1 := html1 + '<body> ';
    html1 := html1 + '<h3>' + Query.FieldByName('observacaopj').AsString + '</h3> ';
    html1 := html1 + '<h2> </h2> ';
    html1 := html1 + '<table> ';
    html1 := html1 + '    <thead> ';
    html1 := html1 + '        <tr> ';
    html1 := html1 + '<th>STATE</th> ';
    html1 := html1 + '<th>ID SITE</th> ';
    html1 := html1 + '<th>SITE NAME(DE)</th> ';
    html1 := html1 + '<th>SITE NAME(PARA)</th> ';
    html1 := html1 + '<th>ZTE CODE</th> ';
    html1 := html1 + '<th>SERVICE DESCRIPTION</th> ';
    html1 := html1 + '<th>QTY</th> ';
    html1 := html1 + '<th>DATA ACIONAMENTO</th> ';
    html1 := html1 + '<th>VALOR</th> ';
    html1 := html1 + '</tr> ';
    html1 := html1 + '</thead> ';
    html1 := html1 + '<tbody> ';

    while not Query.eof do
    begin
      html2 := html2 + '<tr>';
      html2 := html2 + '<td>' + Query.FieldByName('State').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('SiteID').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('SiteName').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('sitenamefrom').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('ZTECode').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('ServiceDescription').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('Qty').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('dataacionamento').AsString + '</td>';
      html2 := html2 + '<td>' + floattostrf(Query.FieldByName('valorlpu').AsFloat, ffCurrency, 18, 2) + '</td>';
      html2 := html2 + '</tr>';
      total := Query.FieldByName('valorlpu').AsFloat + total;
      Query.Next();
    end;
    html2 := html2 + '<tr> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td><b> Total: ' + floattostrf(total, ffCurrency, 18, 2) + '</b></td> ';
    html2 := html2 + '</tr> ';
    html2 := html2 + '</tbody> ';
    html2 := html2 + '</table> ';

    html3 := html3 + '</body> ';
    html3 := html3 + '</html> ';

    assinatura;
    htmlcompleto := html1 + html2 + assinaturamontada + html3;
    Result := html1 + html2 + assinaturamontada + html3;

  except
    Query.Free;
    raise;
  end;

end;

function TEmail.ExecuteSelect: string; // acionamento
var
  Query: TFDQuery;
  html1, html2, html3, htmlcompleto: string;
  total: Real;
begin
  html1 := '';
  html2 := '';
  html3 := '';
  html1 := html1 + '<!DOCTYPE html> ';
  html1 := html1 + '<html lang="en"> ';
  html1 := html1 + '<head> ';
  html1 := html1 + '<meta charset="UTF-8"> ';
  html1 := html1 + '<meta name="viewport" content="width=device-width, initial-scale=1.0"> ';
  html1 := html1 + '<title>Tabela</title> ';
  html1 := html1 + '<style> ';
  html1 := html1 + 'table { ';
  html1 := html1 + 'border-collapse: collapse; ';
  html1 := html1 + 'width: 100%; ';
  html1 := html1 + '} ';
  html1 := html1 + 'th, ';
  html1 := html1 + 'td { ';
  html1 := html1 + 'border: 1px solid black; ';
  html1 := html1 + 'padding: 8px; ';
  html1 := html1 + 'text-align: left; ';
  html1 := html1 + '} ';
  html1 := html1 + 'th { ';
  html1 := html1 + 'background-color: #009efb; ';
  html1 := html1 + '} ';
  html1 := html1 + '.no-border-table td { ';
  html1 := html1 + 'border: none; ';
  html1 := html1 + '} ';

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConn;
    Query.Close;
    Query.ClearBlobs;
    Query.sql.Clear;
    Query.SQL.Add('SELECT ');
    Query.SQL.Add('obraericssonatividadepj.po, ');
    Query.SQL.Add('obraericssonatividadepj.poitem, ');
    Query.SQL.Add('obraericssonatividadepj.numero, ');
    Query.SQL.Add('obraericssonatividadepj.valorservico, ');
    Query.SQL.Add('obraericssonatividadepj.descricaoservico, ');
    Query.SQL.Add('obraericssonatividadepj.observacaopj, ');
    Query.SQL.Add('gesempresas.nome, obraericssonmigo.qtyordered,gesempresas.email as contatowebsite ');
    Query.SQL.Add('FROM ');
    Query.SQL.Add('obraericssonatividadepj Left Join ');
    Query.SQL.Add('gesempresas On gesempresas.idempresa = obraericssonatividadepj.idcolaboradorpj left Join ');
    Query.SQL.Add('obraericssonmigo On obraericssonmigo.po = obraericssonatividadepj.po ');
    Query.SQL.Add('And obraericssonmigo.poritem = obraericssonatividadepj.poitem ');
    Query.SQL.Add('And obraericssonmigo.codigoservico = obraericssonatividadepj.codigoservico where idcolaboradorpj=:idcpj and obraericssonatividadepj.numero=:numero ');
    Query.SQL.Add('and obraericssonatividadepj.deletado = 0  ');
    //  and obraericssonatividadepj.email = 0

    if Trim(ids) <> '' then
      Query.SQL.Add('  and obraericssonatividadepj.idgeral in (' + ids + ') ');

    Query.SQL.Add('order by descricaoservico ');
    Query.parambyname('idcpj').asstring := idpessoa;
    Query.parambyname('numero').asstring := numero;
    Query.Open;
    total := 0;

    html1 := html1 + '</style> ';
    html1 := html1 + '</head> ';
    html1 := html1 + '<body> ';
    html1 := html1 + '<h3>' + Query.FieldByName('observacaopj').AsString + '</h3> ';
    html1 := html1 + '<h2> </h2> ';
    html1 := html1 + '<table> ';
    html1 := html1 + '    <thead> ';
    html1 := html1 + '        <tr> ';
    html1 := html1 + '<th>PO</th> ';
    html1 := html1 + '<th>Item</th> ';
    html1 := html1 + '<th>Sigla</th> ';
    html1 := html1 + '<th>ID Sydle</th> ';
    html1 := html1 + '<th>Descri��o</th> ';
    html1 := html1 + '<th>Qtd</th> ';
    html1 := html1 + '<th>Empresa</th> ';
    html1 := html1 + '<th>Valor PJ</th> ';
    html1 := html1 + '</tr> ';
    html1 := html1 + '</thead> ';
    html1 := html1 + '<tbody> ';

    while not Query.eof do
    begin
      html2 := html2 + '<tr>';
      html2 := html2 + '<td>' + Query.FieldByName('po').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('poitem').AsString + '</td>';
      html2 := html2 + '<td>' + sitenome + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('numero').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('descricaoservico').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('qtyordered').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('nome').AsString + '</td>';
      html2 := html2 + '<td>' + floattostrf(Query.FieldByName('valorservico').AsFloat, ffCurrency, 18, 2) + '</td>';
      html2 := html2 + '</tr>';
      total := Query.FieldByName('valorservico').AsFloat + total;
      Query.Next();
    end;
    html2 := html2 + '<tr> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td><b> Total: ' + floattostrf(total, ffCurrency, 18, 2) + '</b></td> ';
    html2 := html2 + '</tr> ';
    html2 := html2 + '</tbody> ';
    html2 := html2 + '</table> ';

    html3 := html3 + '</body> ';
    html3 := html3 + '</html> ';

    assinatura;
    htmlcompleto := html1 + html2 + assinaturamontada + html3;
    Result := html1 + html2 + assinaturamontada + html3;

  except
    Query.Free;
    raise;
  end;

end;

function Temail.Executeacionamentotelefonica: string;
var
  Query, query2: TFDQuery;
  html1, html2, html3, htmlcompleto: string;
  total: Real;
begin
  html1 := '';
  html2 := '';
  html3 := '';
  html1 := html1 + '<!DOCTYPE html> ';
  html1 := html1 + '<html lang="pt-BR"> ';
  html1 := html1 + '<head> ';
  html1 := html1 + '<meta charset="UTF-8"> ';
  html1 := html1 + '<meta name="viewport" content="width=device-width, initial-scale=1.0"> ';
  html1 := html1 + '<title>Tabela</title> ';
  html1 := html1 + '<style> ';
  html1 := html1 + 'table { ';
  html1 := html1 + 'border-collapse: collapse; ';
  html1 := html1 + 'width: 100%; ';
  html1 := html1 + '} ';
  html1 := html1 + 'th, ';
  html1 := html1 + 'td { ';
  html1 := html1 + 'border: 1px solid black; ';
  html1 := html1 + 'padding: 8px; ';
  html1 := html1 + 'text-align: left; ';
  html1 := html1 + '} ';
  html1 := html1 + 'th { ';
  html1 := html1 + 'background-color: #009efb; ';
  html1 := html1 + '} ';
  html1 := html1 + '.no-border-table td { ';
  html1 := html1 + 'border: none; ';
  html1 := html1 + '} ';

  Query := TFDQuery.Create(nil);
  query2 := TFDQuery.Create(nil);
  try
    Query.Connection := FConn;
    query2.Connection := FConn;
    Query.Close;
    Query.ClearBlobs;
    Query.sql.Clear;
    Query.SQL.Add('Select ');
    Query.SQL.Add('rolloutvivo.UIDIDPMTS, ');
    Query.SQL.Add('rolloutvivo.UFSIGLA, ');
    Query.SQL.Add('rolloutvivo.PMOSIGLA, ');
    Query.SQL.Add('telefonicacontrolet2.Atividade, ');
    Query.SQL.Add('rolloutvivo.PMOREGIONAL, ');
    Query.SQL.Add('lpuvivo.BREVEDESCRICAO, ');
    Query.SQL.Add('telefonicacontrolet2.quant as QTD, ');
    Query.SQL.Add('lpuvivo.CODIGOLPUVIVO, ');
    Query.SQL.Add('telefonicacontrolet2.quant * acionamentovivo.valor As VALORPJ, ');
    Query.SQL.Add('gesempresas.nome, acionamentovivo.observacao, acionamentovivo.id ');
    Query.SQL.Add('From ');
    Query.SQL.Add('acionamentovivo Inner Join ');
    Query.SQL.Add('rolloutvivo On rolloutvivo.id = acionamentovivo.idrollout Inner Join ');
    Query.SQL.Add('telefonicacontrolet2 On telefonicacontrolet2.id = acionamentovivo.idatividade Inner Join ');
    Query.SQL.Add('lpuvivo On lpuvivo.ID = acionamentovivo.idpacote Inner Join ');
    Query.SQL.Add('gesempresas On gesempresas.idempresa = acionamentovivo.idcolaborador where rolloutvivo.UIDIDPMTS=:UIDIDPMTS and rolloutvivo.deletado = 0 and acionamentovivo.deletado = 0');
    if Trim(ids) <> '' then
      Query.SQL.Add('  and acionamentovivo.id in (' + ids + ') ');

    Query.parambyname('UIDIDPMTS').asstring := os;

    Query.Open;
    total := 0;

    if Query.RecordCount > 0 then
    begin

      html1 := html1 + '</style> ';
      html1 := html1 + '</head> ';
      html1 := html1 + '<body> ';
      html1 := html1 + '<h4> Senhores, </h4> ';
      html1 := html1 + '<h4>Segue acionamento para atividades no projeto SIRIUS - Telefônica:</h4>';
      html1 := html1 + '<h2> </h2> ';
      html1 := html1 + '<div style="font-size:14px; line-height:1.6; color:#333; margin:12px 0; white-space: pre-wrap;">' +
                Query.FieldByName('observacao').AsString +
                '</div>';
      html1 := html1 + '<h2> </h2> ';
      html1 := html1 + '<table> ';
      html1 := html1 + '    <thead> ';
      html1 := html1 + '        <tr> ';
      html1 := html1 + '<th>ID PMTS</th> ';
      html1 := html1 + '<th>SIGLA</th> ';
      html1 := html1 + '<th>SIGLA</th> ';
      html1 := html1 + '<th>Atividade</th> ';
      html1 := html1 + '<th>Reg</th> ';
      html1 := html1 + UTF8Encode('<th>Descrição Atividade</th>');

      html1 := html1 + '<th>Qtd.</th> ';
      html1 := html1 + '<th>C&oacute;digo LPU VIVO</th>';
      html1 := html1 + '<th>Valor Acionamento</th> ';
      html1 := html1 + '<th>Empresa</th> ';
      html1 := html1 + '</tr> ';
      html1 := html1 + '</thead> ';
      html1 := html1 + '<tbody> ';
      FConn.StartTransaction;
      while not Query.eof do
      begin
        html2 := html2 + '<tr>';
        html2 := html2 + '<td>' + Query.FieldByName('UIDIDPMTS').AsString + '</td>';
        html2 := html2 + '<td>' + Query.FieldByName('UFSIGLA').AsString + '</td>';
        html2 := html2 + '<td>' + Query.FieldByName('PMOSIGLA').AsString + '</td>';
        html2 := html2 + '<td>' + Query.FieldByName('Atividade').AsString + '</td>';
        html2 := html2 + '<td>' + Query.FieldByName('PMOREGIONAL').AsString + '</td>';
        html2 := html2 + '<td>' + Query.FieldByName('BREVEDESCRICAO').AsString + '</td>';
        html2 := html2 + '<td>' + Query.FieldByName('QTD').AsString + '</td>';
        html2 := html2 + '<td>' + Query.FieldByName('CODIGOLPUVIVO').AsString + '</td>';
        html2 := html2 + '<td>' + floattostrf(Query.FieldByName('VALORPJ').AsFloat, ffCurrency, 18, 2) + '</td>';
        html2 := html2 + '<td>' + Query.FieldByName('nome').AsString + '</td>';
        html2 := html2 + '</tr>';
        total := Query.FieldByName('VALORPJ').AsFloat + total;
        with query2 do
        begin
          active := false;
          SQL.Clear;
          SQL.add('update acionamentovivo set acionamentovivo.dataenvioemail=:dt  where acionamentovivo.id=:id ');
          ParamByName('id').asinteger := Query.fieldbyname('id').asinteger;
          ParamByName('dt').asdatetime := now;
          execsql;
        end;
        Query.Next();
      end;
      FConn.Commit;
      html2 := html2 + '<tr> ';
      html2 := html2 + '<td></td> ';
      html2 := html2 + '<td></td> ';
      html2 := html2 + '<td></td> ';
      html2 := html2 + '<td></td> ';
      html2 := html2 + '<td></td> ';
      html2 := html2 + '<td></td> ';
      html2 := html2 + '<td></td> ';
      html2 := html2 + '<td></td> ';
      html2 := html2 + '<td></td> ';
      html2 := html2 + '<td></td> ';
      html2 := html2 + '<td><b> Total: ' + floattostrf(total, ffCurrency, 18, 2) + '</b></td> ';
      html2 := html2 + '<td></td> ';
      html2 := html2 + '</tr> ';
      html2 := html2 + '</tbody> ';
      html2 := html2 + '</table> ';

      html3 := html3 + '</body> ';
      html3 := html3 + '</html> ';

      assinatura;
      htmlcompleto := html1 + html2 + assinaturamontada + html3;
      Result := html1 + html2 + assinaturamontada + html3;
    end;

  except
    Query.Free;
    raise;
  end;

end;

function TEmail.Executeextrato: string; // fechamento
var
  Query: TFDQuery;
  html1, html2, html3: string;
  total: Real;
begin
  assinatura;
  html1 := '';
  html2 := '';
  html3 := '';
  html1 := html1 + '<!DOCTYPE html> ';
  html1 := html1 + '<html lang="en"> ';
  html1 := html1 + '<head> ';
  html1 := html1 + '<meta charset="UTF-8"> ';
  html1 := html1 + '<meta name="viewport" content="width=device-width, initial-scale=1.0"> ';
  html1 := html1 + '<title>Tabela</title> ';
  html1 := html1 + '<style> ';
  html1 := html1 + '    table { ';
  html1 := html1 + '        border-collapse: collapse; ';
  html1 := html1 + '        width: 100%; ';
  html1 := html1 + '    } ';
  html1 := html1 + '    th, td { ';
  html1 := html1 + '        border: 1px solid black; ';
  html1 := html1 + '        padding: 8px; ';
  html1 := html1 + '        text-align: center; ';
  html1 := html1 + '    } ';
  html1 := html1 + 'th { ';
  html1 := html1 + 'background-color: #009efb; ';
  html1 := html1 + '} ';
  html1 := html1 + '.no-border-table td { ';
  html1 := html1 + 'border: none; ';
  html1 := html1 + '} ';
  html1 := html1 + '</style> ';
  html1 := html1 + '</head> ';
  html1 := html1 + '<body> ';
  html1 := html1 + '<h2> </h2> ';
  html1 := html1 + '<h3>' + observacao + '</h3> ';
  html1 := html1 + '<h2> </h2> ';
  html1 := html1 + '<table> ';
  html1 := html1 + '    <thead> ';

  html1 := html1 + '<tr> ';
  html1 := html1 + '<th>PO</td> ';
  html1 := html1 + '<th>PO Item</td> ';
  html1 := html1 + '<th>ID SYDLE</td> ';
  html1 := html1 + '<th>SIGLA</td> ';
  html1 := html1 + '<th>CLIENTE</td> ';
  html1 := html1 + '<th>ESTADO</td> ';
  html1 := html1 + '<th>MOS</td> ';
  html1 := html1 + '<th>INSTALL</td> ';
  html1 := html1 + '<th>INTEGR</td> ';
  html1 := html1 + '<th>DOC INSTAL</td> ';
  html1 := html1 + '<th>DOC CW</td> ';
  html1 := html1 + '<th>FAM</td> ';
  html1 := html1 + '<th>STATUS</td> ';
  html1 := html1 + '<th>DATA DO PAGTO</td> ';
  html1 := html1 + '<th>CODIGO</td> ';
  html1 := html1 + '<th>DESCRI��O</td> ';
  html1 := html1 + '<th>M�S DE PAGTO</td> ';
  html1 := html1 + '<th>PORCENTAGEM</td> ';
  html1 := html1 + '<th>VALOR (R$)</td> ';
  html1 := html1 + '<th>OBSERVA��O</td> ';
  html1 := html1 + '</tr> ';
  html1 := html1 + '</thead> ';
  html1 := html1 + '<tbody> ';

//corpo


  html3 := html3 + '</tbody> ';
  html3 := html3 + '</table> ';

  html3 := html3 + assinaturamontada;

  html3 := html3 + '</body> ';
  html3 := html3 + '</html> ';

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConn;
    Query.Close;
    Query.ClearBlobs;
    Query.SQL.Add('Select ');
    Query.SQL.Add('obraericssonfechamento.PO, ');
    Query.SQL.Add('obraericssonfechamento.POITEM, ');
    Query.SQL.Add('obraericssonfechamento.Sigla, ');
    Query.SQL.Add('obraericssonfechamento.IDSydle, ');
    Query.SQL.Add('Date_Format(obraericsson.datarecebimentodositemosreportadodia, ''%d/%m/%Y'') As mosreal, ');
    Query.SQL.Add('Date_Format(obraericsson.dataconclusaoreportadodia, ''%d/%m/%Y'') As instalreal, ');
    Query.SQL.Add('Date_Format(obraericsson.datavalidacaoeriboxedia, ''%d/%m/%Y'') As integreal, ');
    Query.SQL.Add('obrasericssonlistasites.statusdoc, ');
    Query.SQL.Add('(SELECT documentacaosituacao  ');
    Query.SQL.Add('FROM obradocumentacaoobracivilworks   ');
    Query.SQL.Add('WHERE obradocumentacaoobracivilworks.numero = obraericssonfechamento.IDSydle  ');
    Query.SQL.Add('LIMIT 1) as documentacaosituacao,  ');
    Query.SQL.Add('obraericssonfechamento.Cliente, ');
    Query.SQL.Add('obraericssonfechamento.Estado, ');
    Query.SQL.Add('obraericssonfechamento.Codigo, ');
    Query.SQL.Add('obraericssonfechamento.Descricao, ');
    Query.SQL.Add('coalesce(obrasericssonfam.respfaminstalacao,''N/A'') As fam, ');
    Query.SQL.Add('obraericssonpagamento.mespagamento, ');
    Query.SQL.Add('Date_Format(obraericssonpagamento.datadopagamento, ''%d/%m/%Y'') As datadopagamento, ');
    Query.SQL.Add('obraericssonpagamento.status, ');
    Query.SQL.Add('obraericssonpagamento.porcentagem, ');
    Query.SQL.Add('obraericssonpagamento.valorpagamento, ');
    Query.SQL.Add('obraericssonpagamento.observacao ');
    Query.SQL.Add('From ');
    Query.SQL.Add('obraericssonpagamento Inner Join ');
    Query.SQL.Add('obraericssonfechamento On obraericssonfechamento.geral = obraericssonpagamento.idgeralfechamento left Join ');
    Query.SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join ');
    Query.SQL.Add('obrasericssonlistasites On obrasericssonlistasites.SEED = obraericssonfechamento.IDSydle left Join ');
    Query.SQL.Add('obrasericssonfam On obrasericssonfam.Obra = obraericssonfechamento.IDSydle ');
    Query.SQL.Add('Where ');
    Query.SQL.Add('obraericssonfechamento.EMPRESA like ''%' + empresa + '%''  and');
    Query.SQL.Add('obraericssonpagamento.mespagamento = :MESPAGAMENTO ');
    if Trim(status) <> '' then
    begin
      Query.SQL.Add(' and obraericssonpagamento.status = :STATUS ');
      Query.ParamByName('STATUS').AsString := status;
    end;
    if Trim(datapagamento) <> '' then
    begin
      Query.SQL.Add(' AND obraericssonpagamento.datadopagamento LIKE :DATADOPAGAMENTO');
      Query.ParamByName('DATADOPAGAMENTO').AsString := '%' + datapagamento + '%';
    end;
    Query.parambyname('MESPAGAMENTO').asstring := mespagamento;
    Query.Open;
    total := 0;
    while not Query.eof do
    begin
      html2 := html2 + '<tr>';
      html2 := html2 + '<td>' + Query.FieldByName('po').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('poitem').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('IDSydle').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('Sigla').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('Cliente').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('Estado').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('mosreal').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('instalreal').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('integreal').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('statusdoc').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('documentacaosituacao').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('fam').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('status').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('datadopagamento').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('Codigo').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('Descricao').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('mespagamento').AsString + '</td>';
      html2 := html2 + '<td>' + FloatToStrF(Query.FieldByName('porcentagem').AsFloat * 100, ffNumber, 18, 2) + ' %' + '</td>';
      html2 := html2 + '<td>' + floattostrf(Query.FieldByName('valorpagamento').AsFloat, ffCurrency, 18, 2) + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('observacao').AsString + '</td>';
      html2 := html2 + '</tr>';
      total := Query.FieldByName('valorpagamento').AsFloat + total;
      Query.Next();
    end;
    html2 := html2 + '<tr> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td><b> Valor de Servi�os: ' + floattostrf(total, ffCurrency, 18, 2) + '</b></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';

    Query.Close;
    Query.sql.Clear;
    Query.SQL.Add('Select obraericssonpagamentodesconto.desconto From obraericssonpagamentodesconto ');
    Query.SQL.Add('Where ');
    Query.SQL.Add('obraericssonpagamentodesconto.EMPRESA like ''%' + empresa + '%''  and');
    Query.SQL.Add('obraericssonpagamentodesconto.mespagamento = :MESPAGAMENTO and obraericssonpagamentodesconto.numero=:numeroordem    ');
    Query.parambyname('MESPAGAMENTO').asstring := mespagamento;
    Query.parambyname('numeroordem').AsInteger := numeroordem;
    Query.Open;

    html2 := html2 + '</tr> ';
    html2 := html2 + '<tr> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td><b> Desconto: ' + floattostrf(Query.fieldbyname('desconto').asfloat, ffCurrency, 18, 2) + '</b></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '</tr> ';
    html2 := html2 + '<tr> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td><b> Valor Total: ' + floattostrf(total - Query.fieldbyname('desconto').asfloat, ffCurrency, 18, 2) + '</b></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '</tr> ';
    Result := html1 + html2 + html3;

  except
    Query.Free;
    raise;
  end;

end;

function TEmail.Executeextratocosmx: string; // fechamento
var
  Query: TFDQuery;
  html1, html2, html3: string;
  total: Real;
begin
  assinatura;
  html1 := '';
  html2 := '';
  html3 := '';
  html1 := html1 + '<!DOCTYPE html> ';
  html1 := html1 + '<html lang="en"> ';
  html1 := html1 + '<head> ';
  html1 := html1 + '<meta charset="UTF-8"> ';
  html1 := html1 + '<meta name="viewport" content="width=device-width, initial-scale=1.0"> ';
  html1 := html1 + '<title>Tabela</title> ';
  html1 := html1 + '<style> ';
  html1 := html1 + '    table { ';
  html1 := html1 + '        border-collapse: collapse; ';
  html1 := html1 + '        width: 100%; ';
  html1 := html1 + '    } ';
  html1 := html1 + '    th, td { ';
  html1 := html1 + '        border: 1px solid black; ';
  html1 := html1 + '        padding: 8px; ';
  html1 := html1 + '        text-align: center; ';
  html1 := html1 + '    } ';
  html1 := html1 + 'th { ';
  html1 := html1 + 'background-color: #009efb; ';
  html1 := html1 + '} ';
  html1 := html1 + '.no-border-table td { ';
  html1 := html1 + 'border: none; ';
  html1 := html1 + '} ';
  html1 := html1 + '</style> ';
  html1 := html1 + '</head> ';
  html1 := html1 + '<body> ';
  html1 := html1 + '<h2> </h2> ';
  html1 := html1 + '<h3>' + observacao + '</h3> ';
  html1 := html1 + '<h2> </h2> ';
  html1 := html1 + '<table> ';
  html1 := html1 + '    <thead> ';

  html1 := html1 + '<tr> ';
  html1 := html1 + '<th>SITE ID</td> ';
  html1 := html1 + '<th>SITE FROM TO</td> ';
  html1 := html1 + '<th>UF</td> ';
  html1 := html1 + '<th>EMPRESA</td> ';
  html1 := html1 + '<th>FECHAMENTO</td> ';
  html1 := html1 + '<th>%</td> ';
  html1 := html1 + '<th>VALOR (R$)</td> ';
  html1 := html1 + '<th>ENVIO FECHAMENTO</td> ';
  html1 := html1 + '<th>RELAT�RIO ACEITA��O</td> ';
  html1 := html1 + '</tr> ';
  html1 := html1 + '</thead> ';
  html1 := html1 + '<tbody> ';

//corpo
  html3 := html3 + '</tbody> ';
  html3 := html3 + '</table> ';

  html3 := html3 + assinaturamontada;

  html3 := html3 + '</body> ';
  html3 := html3 + '</html> ';

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConn;
    Query.Close;
    Query.ClearBlobs;
    Query.SQL.Add('Select ');
    Query.SQL.Add('obracosmx.*,gesempresas.nome ');
    Query.SQL.Add('From ');
    Query.SQL.Add('obracosmx left Join gesempresas On gesempresas.idempresa = obracosmx.idempresa ');
    Query.SQL.Add('Where ');
    Query.SQL.Add('obracosmx.aprovacaocosmx Is Not Null And ');
    Query.SQL.Add('obracosmx.Fechamento Is Not Null and obracosmx.Fechamento=:fechamento and obracosmx.idempresa=:idempresa   ');
    Query.parambyname('fechamento').asstring := mespagamento;
    Query.parambyname('idempresa').AsInteger := numeroordem;
    Query.Open;
    total := 0;
    while not Query.eof do
    begin
      html2 := html2 + '<tr>';
      html2 := html2 + '<td>' + Query.FieldByName('siteid').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('sitefromto').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('uf').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('nome').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('fechamento').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('porcentagem').AsString + '</td>';
      html2 := html2 + '<td>' + floattostrf(Query.FieldByName('valorlpu').AsFloat, ffCurrency, 18, 2) + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('aprovacaocosmx').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('nomerelatorioenviado1').AsString + '</td>';
      html2 := html2 + '</tr>';
      total := Query.FieldByName('valorlpu').AsFloat + total;
      Query.Next();
    end;
    html2 := html2 + '<tr> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td><b> Valor de Servi�os: ' + floattostrf(total, ffCurrency, 18, 2) + '</b></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '</tr> ';




  {  Query.Close;
    Query.sql.Clear;
    Query.SQL.Add('Select obraericssonpagamentodesconto.desconto From obraericssonpagamentodesconto ');
    Query.SQL.Add('Where ');
    Query.SQL.Add('obraericssonpagamentodesconto.EMPRESA like ''%' + empresa + '%''  and');
    Query.SQL.Add('obraericssonpagamentodesconto.mespagamento = :MESPAGAMENTO and obraericssonpagamentodesconto.numero=:numeroordem    ');
    Query.parambyname('MESPAGAMENTO').asstring := mespagamento;
    Query.parambyname('numeroordem').AsInteger := numeroordem;
    Query.Open;

    html2 := html2 + '</tr> ';
    html2 := html2 + '<tr> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td><b> Desconto: ' + floattostrf(Query.fieldbyname('desconto').asfloat, ffCurrency, 18, 2) + '</b></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '</tr> ';
    html2 := html2 + '<tr> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td><b> Valor Total: ' + floattostrf(total-Query.fieldbyname('desconto').asfloat, ffCurrency, 18, 2) + '</b></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '</tr> ';      }
    Result := html1 + html2 + html3;

  except
    Query.Free;
    raise;
  end;

end;

function Temail.Executeextratotelefonica: string;
var
  Query: TFDQuery;
  html1, html2, html3: string;
  total,desconto: Real;

begin
  assinatura;
  html1 := '';
  html2 := '';
  html3 := '';
  html1 := html1 + '<!DOCTYPE html> ';
  html1 := html1 + '<html lang="en"> ';
  html1 := html1 + '<head> ';
  html1 := html1 + '<meta charset="UTF-8"> ';
  html1 := html1 + '<meta name="viewport" content="width=device-width, initial-scale=1.0"> ';
  html1 := html1 + '<title>Tabela</title> ';
  html1 := html1 + '<style> ';
  html1 := html1 + '    table { ';
  html1 := html1 + '        border-collapse: collapse; ';
  html1 := html1 + '        width: 100%; ';
  html1 := html1 + '    } ';
  html1 := html1 + '    th, td { ';
  html1 := html1 + '        border: 1px solid black; ';
  html1 := html1 + '        padding: 8px; ';
  html1 := html1 + '        text-align: center; ';
  html1 := html1 + '    } ';
  html1 := html1 + 'th { ';
  html1 := html1 + 'background-color: #009efb; ';
  html1 := html1 + '} ';
  html1 := html1 + '.no-border-table td { ';
  html1 := html1 + 'border: none; ';
  html1 := html1 + '} ';
  html1 := html1 + '</style> ';
  html1 := html1 + '</head> ';
  html1 := html1 + '<body> ';
  html1 := html1 + '<h2> </h2> ';
  html1 := html1 + '<h3>' + observacao + '</h3> ';
  html1 := html1 + '<h2> </h2> ';
  html1 := html1 + '<table> ';
  html1 := html1 + '    <thead> ';

  html1 := html1 + '<tr> ';
  html1 := html1 + '<th>IDPMTS</th> ';
  html1 := html1 + '<th>PO</th> ';
  html1 := html1 + '<th>UFSIGLA</th> ';
  html1 := html1 + '<th>SIGLA</th> ';
  html1 := html1 + '<th>REGIONAL</th> ';
  html1 := html1 + '<th>ESCOPO</th> ';
  html1 := html1 + '<th>QUANTIDADE</th> ';
  html1 := html1 + '<th>CODIGO LPU</th> ';
  html1 := html1 + '<th>VALOR PJ</th> ';
  html1 := html1 + '<th>ENTREGA REAL</th> ';
  html1 := html1 + '<th>INSTALA��O REAL</th> ';
  html1 := html1 + '<th>INTEGRA��O REAL</th> ';
  html1 := html1 + '<th>ATIVA��O</th> ';
  html1 := html1 + '<th>Data do PGT</th> ';
  html1 := html1 + '<th>Status</th> ';
  html1 := html1 + '<th>DOCUMENTA��O</th> ';
  html1 := html1 + '<th>DT REAL</th> ';
  html1 := html1 + '<th>MES PAGAMENTO</th> ';
  html1 := html1 + '<th>%</th> ';
  html1 := html1 + '<th>VALOR PAGAMENTO</th> ';
  html1 := html1 + '<th>Observacao</th> ';
  html1 := html1 + '</tr> ';
  html1 := html1 + '</thead> ';
  html1 := html1 + '<tbody> ';



//corpo
  html3 := html3 + '</tbody> ';
  html3 := html3 + '</table> ';

  html3 := html3 + assinaturamontada;

  html3 := html3 + '</body> ';
  html3 := html3 + '</html> ';

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConn;
    Query.Close;
    Query.ClearBlobs;
    Query.SQL.Clear;
    Query.SQL.Add('select * from telefonicapagamentodesconto ');
    Query.SQL.Add(' WHERE telefonicapagamentodesconto.idcolaborador = :idcolaborador ');
    Query.ParamByName('idcolaborador').AsString := idpessoa;
    if mespagamento <> '' then
    begin
      Query.SQL.Add('  AND telefonicapagamentodesconto.mespagamento LIKE :mespagamento');
      Query.ParamByName('mespagamento').AsString := '%' + mespagamento + '%';
    end;
    if Trim(datapagamento) <> '' then
    begin
      Query.SQL.Add('  AND telefonicapagamentodesconto.datapagamento LIKE :datapagamento');
      Query.ParamByName('datapagamento').AsString := '%' + datapagamento + '%';
    end;
    if Trim(status) <> '' then
    begin
      Query.SQL.Add('  AND telefonicapagamentodesconto.tipopagamento LIKE :tipopagamento');
      Query.ParamByName('tipopagamento').AsString := '%' + status + '%';
    end;
    Query.Open;
    desconto := Query.fieldbyname('desconto').asfloat;


    Query.Close;
    Query.ClearBlobs;
    Query.SQL.Clear;
    Query.SQL.Add('SELECT');
    Query.SQL.Add('  acionamentovivo.id AS id,');
    Query.SQL.Add('  acionamentovivo.idpmts,');
    Query.SQL.Add('  acionamentovivo.po,');
    Query.SQL.Add('  rolloutvivo.ufsigla,');
    Query.SQL.Add('  rolloutvivo.pmosigla,');
    Query.SQL.Add('  rolloutvivo.pmoregional,');
    Query.SQL.Add('  lpuvivo.brevedescricao,');
    Query.SQL.Add('  acionamentovivo.quantidade,');
    Query.SQL.Add('  lpuvivo.codigolpuvivo, ');
    Query.SQL.Add('  t.mespagamento,');
    Query.SQL.Add('  t.tipopagamento as tipopagamento,');
    Query.SQL.Add('  Date_Format( t.datapagamento , "%d/%m/%Y") As datapagamento, ');
    Query.SQL.Add('  acionamentovivo.valor as valorpj,');
    Query.SQL.Add('  t.valorpagamento,');
    Query.SQL.Add('  t.observacao,');
    Query.SQL.Add('  CONCAT(ROUND(t.porcentagem * 100, 2), "%") AS porcentagem,');
    Query.SQL.Add('  rolloutvivo.entregareal,');
    Query.SQL.Add('  rolloutvivo.fiminstalacaoreal,');
    Query.SQL.Add('  rolloutvivo.integracaoreal,');
    Query.SQL.Add('  rolloutvivo.dtreal,');
    Query.SQL.Add('  rolloutvivo.vistoriareal,');
    Query.SQL.Add('  rolloutvivo.ativacao,');
    Query.SQL.Add('  rolloutvivo.documentacao,');
    Query.SQL.Add('  rolloutvivo.dataimprodutiva,');
    Query.SQL.Add('  rolloutvivo.aprovacaossv,');
    Query.SQL.Add('  rolloutvivo.statusaprovacaossv,');
    Query.SQL.Add('  gesempresas.email');
    Query.SQL.Add(' FROM acionamentovivo');
    Query.SQL.Add(' LEFT JOIN telefonicapagamento t ON t.idacionamentovivo = acionamentovivo.id ');
    Query.SQL.Add(' INNER JOIN rolloutvivo ON rolloutvivo.uididpmts = acionamentovivo.idpmts');
    Query.SQL.Add(' LEFT JOIN lpuvivo ON lpuvivo.id = acionamentovivo.idpacote');
    Query.SQL.Add(' INNER JOIN gesempresas ON gesempresas.idempresa = acionamentovivo.idcolaborador');
    Query.SQL.Add(' WHERE acionamentovivo.deletado = 0 AND acionamentovivo.idcolaborador = :idcolaborador ');
    Query.ParamByName('idcolaborador').AsString := idpessoa;

    if mespagamento <> '' then
    begin
      Query.SQL.Add('  AND t.mespagamento LIKE :mespagamento');
      Query.ParamByName('mespagamento').AsString := '%' + mespagamento + '%';
    end;

    if Trim(datapagamento) <> '' then
    begin
      Query.SQL.Add('  AND t.datapagamento LIKE :datapagamento');
      Query.ParamByName('datapagamento').AsString := '%' + datapagamento + '%';
    end;

    if Trim(status) <> '' then
    begin
      Query.SQL.Add('  AND t.tipopagamento LIKE :tipopagamento');
      Query.ParamByName('tipopagamento').AsString := '%' + status + '%';
    end;

    Query.Open;

    total := 0;
    while not Query.Eof do
    begin
      html2 := html2 + '<tr>';
      html2 := html2 + '<td>' + Query.FieldByName('idpmts').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('po').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('ufsigla').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('pmosigla').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('pmoregional').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('brevedescricao').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('quantidade').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('codigolpuvivo').AsString + '</td>';
      html2 := html2 + '<td>' + FloatToStrF(Query.FieldByName('valorpj').AsFloat, ffCurrency, 18, 2) + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('entregareal').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('fiminstalacaoreal').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('integracaoreal').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('ativacao').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('datapagamento').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('tipopagamento').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('documentacao').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('dtreal').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('mespagamento').AsString + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('porcentagem').AsString + '</td>';
      html2 := html2 + '<td>' + FloatToStrF(Query.FieldByName('valorpagamento').AsFloat, ffCurrency, 18, 2) + '</td>';
      html2 := html2 + '<td>' + Query.FieldByName('observacao').AsString + '</td>';
      html2 := html2 + '</tr>';

      total := total + Query.FieldByName('valorpagamento').AsFloat;
      Query.Next;
    end;

    html2 := html2 + '<tr> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td><b> Valor de Servi�os: ' + floattostrf(total, ffCurrency, 18, 2) + '</b></td> ';
    html2 := html2 + '</tr> ';
    html2 := html2 + '<tr> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td><b> Desconto: ' + floattostrf(desconto, ffCurrency, 18, 2) + '</b></td> ';
    html2 := html2 + '</tr> ';
    html2 := html2 + '<tr> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td></td> ';
    html2 := html2 + '<td><b> Total: ' + floattostrf(total-desconto, ffCurrency, 18, 2) + '</b></td> ';
    html2 := html2 + '</tr> ';


    Result := html1 + html2 + html3;
  finally

  end;
end;

function Temail.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select * From admemail ');
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

procedure Temail.marcacomoenviado;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    FConn.StartTransaction;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('update obraericssonatividadepj set email=1,datadeenviodoemail=:dte   where email = 0 and idcolaboradorpj=:idcpj and numero=:numero and obraericssonatividadepj.deletado = 0 ');
      parambyname('idcpj').asstring := idpessoa;
      parambyname('numero').Asstring := numero;
      parambyname('dte').AsDateTime := Now;
      ExecSQL;
    end;
    FConn.Commit;
  except
    FConn.Rollback;
  end;
end;

function TEmail.ExecuteOrdemServico(AOrdemID: Integer;
                                    const ADest1, ADest2, AAssunto: string): Boolean;
var
  bodyHTML: string;
begin
  // monta corpo HTML simples da OS
  bodyHTML := Format(
    '<h3>Ordem de Servi�o #%d criada</h3>' +
    '<p>Verifique os detalhes no sistema.</p>',
    [AOrdemID]
  );

  // envia usando o m�todo centralizado
  Result := SendEmail(
    ADest1 + ';' + ADest2,  // destinat�rios concatenados
    AAssunto,               // assunto
    bodyHTML                // corpo HTML
  );
end;


function TEmail.EnviarEmailConfirmacaoCartaTAF(const AOrdemID: string): Boolean;
var
  bodyHTML, assunto, DestinatarioStr: string;
  Destinatarios: TStringDynArray;
  FDQuery: TFDQuery;
  i: Integer;
  EnvioComSucesso: Boolean;
begin
  Result := False;
  EnvioComSucesso := False;

  // Validação do parâmetro
  if AOrdemID.Trim.IsEmpty then
    raise Exception.Create('ID da Ordem de Serviço não informado');

  // Monta o assunto e corpo do e-mail
  assunto := Format('Confirmação de Geração da Carta TAF - OS #%s', [AOrdemID]);

  bodyHTML :=
    '<html>' +
    '  <head>' +
    '    <style>' +
    '      body { font-family: Arial, sans-serif; line-height: 1.6; }' +
    '      .header { color: #0066cc; font-size: 18px; margin-bottom: 20px; }' +
    '      .footer { margin-top: 30px; font-size: 12px; color: #666; }' +
    '    </style>' +
    '  </head>' +
    '  <body>' +
    '    <div class="header">Confirmação de Geração da Carta TAF</div>' +
    '    <p>A Carta TAF vinculada à Ordem de Serviço <strong>#%s</strong> foi gerada com sucesso.</p>' +
    '    <p>Você pode verificar os detalhes acessando o sistema.</p>' +
    '    <p><strong>Data/Hora:</strong> %s</p>' +
    '    <div class="footer">' +
    '      Este é um e-mail automático, por favor não responda.' +
    '    </div>' +
    '  </body>' +
    '</html>';

  bodyHTML := Format(bodyHTML, [AOrdemID, FormatDateTime('dd/mm/yyyy hh:nn:ss', Now)]);

  // Consulta o(s) destinatário(s)
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FConn;
    FDQuery.SQL.Text := 'SELECT emailfaturamento FROM gesemailconfiguracao WHERE emailfaturamento IS NOT NULL';
    FDQuery.Open;

    if not FDQuery.IsEmpty then
    begin
      DestinatarioStr := FDQuery.FieldByName('emailfaturamento').AsString.Trim;

      // Remove espaços em branco e substitui delimitadores
      DestinatarioStr := StringReplace(DestinatarioStr, ' ', '', [rfReplaceAll]);
      DestinatarioStr := StringReplace(DestinatarioStr, ';', ',', [rfReplaceAll]);

      // Divide em array e remove entradas vazias
      Destinatarios := SplitString(DestinatarioStr, ',');

      // Envia para cada destinatário
      for i := 0 to High(Destinatarios) do
      begin
        if not Destinatarios[i].Trim.IsEmpty then
        begin
          try
            if SendEmail(Destinatarios[i].Trim, assunto, bodyHTML) then
              EnvioComSucesso := True;
          except
            on E: Exception do
              // Log do erro sem interromper o processo
              Writeln(Format('Erro ao enviar e-mail para %s: %s',
                [Destinatarios[i], E.Message]));
          end;
        end;
      end;

      Result := EnvioComSucesso;
    end
    else
    begin
      raise Exception.Create('Nenhum e-mail de faturamento configurado no sistema');
    end;

  finally
    FDQuery.Free;
  end;
end;

function TEmail.ObterEmailsFaturamento: string;
var
  qry: TFDQuery;
begin
  Result := '';
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    qry.SQL.Text := 'SELECT emailFaturamentoTelefonica FROM gesemailconfiguracao';
    qry.Open;

    if not qry.IsEmpty then
    begin
      Result := qry.FieldByName('emailFaturamentoTelefonica').AsString;
    end;
  finally
    qry.Free;
  end;
end;


// Função para enviar e-mail de Instalação
// Função para enviar e-mail de Instalação
procedure TEmail.EnviarEmailInstalacao(const NomeSite, PO, IDPMTS: string);
var
  Assunto, Corpo, Destinatarios: string;
begin
  Destinatarios := ObterEmailsFaturamento;
  if Destinatarios = '' then Exit;

  Assunto := 'Liberação para Faturamento – ' + NomeSite + ' | IDPMTS ' + IDPMTS;

  Corpo := '<!DOCTYPE html>' +
           '<html>' +
           '<head>' +
           '  <style>' +
           '    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }' +
           '    .container { max-width: 600px; margin: 0 auto; padding: 20px; }' +
           '    .header { background-color: #0066cc; color: white; padding: 15px; text-align: center; border-radius: 5px 5px 0 0; }' +
           '    .content { background-color: #f9f9f9; padding: 20px; border: 1px solid #ddd; border-top: none; }' +
           '    .info-item { margin-bottom: 10px; }' +
           '    .label { font-weight: bold; color: #0066cc; }' +
           '    .status { background-color: #4CAF50; color: white; padding: 5px 10px; border-radius: 3px; display: inline-block; }' +
           '    .footer { margin-top: 20px; padding-top: 15px; border-top: 1px solid #ddd; color: #666; font-size: 12px; }' +
           '  </style>' +
           '</head>' +
           '<body>' +
           '  <div class="container">' +
           '    <div class="header">' +
           '      <h2>Liberação para Faturamento</h2>' +
           '    </div>' +
           '    <div class="content">' +
           '      <div class="info-item"><span class="label">PO:</span> ' + PO + '</div>' +
           '      <div class="info-item"><span class="label">IDPMTS:</span> ' + IDPMTS + '</div>' +
           '      <div class="info-item"><span class="label">Site:</span> ' + NomeSite + '</div>' +
           '      <div class="info-item"><span class="label">Status:</span> <span class="status">Aprovado</span></div>' +
           '      <br>' +
           '      <p>Documentação aprovada. Liberado para faturamento.</p>' +
           '    </div>' +
           '    <div class="footer">' +
           '      E-mail automático - Sistema de Gestão de Projetos' +
           '    </div>' +
           '  </div>' +
           '</body>' +
           '</html>';

  SendEmail(Destinatarios, Assunto, Corpo);
end;

// Função para enviar e-mail de Drive Test
procedure TEmail.EnviarEmailDriveTest(const NomeSite, PO, IDPMTS, DataExecucao: string);
var
  Assunto, Corpo, Destinatarios: string;
begin
  Destinatarios := ObterEmailsFaturamento;
  if Destinatarios = '' then Exit;

  Assunto := 'Liberação para Faturamento – ' + NomeSite + ' | IDPMTS ' + IDPMTS;

  Corpo := '<!DOCTYPE html>' +
           '<html>' +
           '<head>' +
           '  <style>' +
           '    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }' +
           '    .container { max-width: 600px; margin: 0 auto; padding: 20px; }' +
           '    .header { background-color: #0066cc; color: white; padding: 15px; text-align: center; border-radius: 5px 5px 0 0; }' +
           '    .content { background-color: #f9f9f9; padding: 20px; border: 1px solid #ddd; border-top: none; }' +
           '    .info-item { margin-bottom: 10px; }' +
           '    .label { font-weight: bold; color: #0066cc; }' +
           '    .date { background-color: #FF9800; color: white; padding: 5px 10px; border-radius: 3px; display: inline-block; }' +
           '    .footer { margin-top: 20px; padding-top: 15px; border-top: 1px solid #ddd; color: #666; font-size: 12px; }' +
           '  </style>' +
           '</head>' +
           '<body>' +
           '  <div class="container">' +
           '    <div class="header">' +
           '      <h2>Liberação para Faturamento</h2>' +
           '    </div>' +
           '    <div class="content">' +
           '      <div class="info-item"><span class="label">PO:</span> ' + PO + '</div>' +
           '      <div class="info-item"><span class="label">IDPMTS:</span> ' + IDPMTS + '</div>' +
           '      <div class="info-item"><span class="label">Site:</span> ' + NomeSite + '</div>' +
           '      <div class="info-item"><span class="label">Data de Execução:</span> <span class="date">' + DataExecucao + '</span></div>' +
           '      <br>' +
           '      <p>Drive Test executado. Liberado para faturamento.</p>' +
           '    </div>' +
           '    <div class="footer">' +
           '      E-mail automático - Sistema de Gestão de Projetos' +
           '    </div>' +
           '  </div>' +
           '</body>' +
           '</html>';

  SendEmail(Destinatarios, Assunto, Corpo);
end;

// Função para enviar e-mail de Survey
procedure TEmail.EnviarEmailSurvey(const NomeSite, PO, IDPMTS, DataExecucao: string);
var
  Assunto, Corpo, Destinatarios: string;
begin
  Destinatarios := ObterEmailsFaturamento;
  if Destinatarios = '' then Exit;

  Assunto := 'Liberação para Faturamento – ' + NomeSite + ' | IDPMTS ' + IDPMTS;

  Corpo := '<!DOCTYPE html>' +
           '<html>' +
           '<head>' +
           '  <style>' +
           '    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }' +
           '    .container { max-width: 600px; margin: 0 auto; padding: 20px; }' +
           '    .header { background-color: #0066cc; color: white; padding: 15px; text-align: center; border-radius: 5px 5px 0 0; }' +
           '    .content { background-color: #f9f9f9; padding: 20px; border: 1px solid #ddd; border-top: none; }' +
           '    .info-item { margin-bottom: 10px; }' +
           '    .label { font-weight: bold; color: #0066cc; }' +
           '    .date { background-color: #9C27B0; color: white; padding: 5px 10px; border-radius: 3px; display: inline-block; }' +
           '    .footer { margin-top: 20px; padding-top: 15px; border-top: 1px solid #ddd; color: #666; font-size: 12px; }' +
           '  </style>' +
           '</head>' +
           '<body>' +
           '  <div class="container">' +
           '    <div class="header">' +
           '      <h2>Liberação para Faturamento</h2>' +
           '    </div>' +
           '    <div class="content">' +
           '      <div class="info-item"><span class="label">PO:</span> ' + PO + '</div>' +
           '      <div class="info-item"><span class="label">IDPMTS:</span> ' + IDPMTS + '</div>' +
           '      <div class="info-item"><span class="label">Site:</span> ' + NomeSite + '</div>' +
           '      <div class="info-item"><span class="label">Data de Execução:</span> <span class="date">' + DataExecucao + '</span></div>' +
           '      <br>' +
           '      <p>Vistoria executada. Liberado para faturamento.</p>' +
           '    </div>' +
           '    <div class="footer">' +
           '      E-mail automático - Sistema de Gestão de Projetos' +
           '    </div>' +
           '  </div>' +
           '</body>' +
           '</html>';

  SendEmail(Destinatarios, Assunto, Corpo);
end;

// Função para enviar e-mail de Legado
procedure TEmail.EnviarEmailLegado(const NomeSite, PO, IDPMTS, DataIntegracao: string);
var
  Assunto, Corpo, Destinatarios: string;
begin
  Destinatarios := ObterEmailsFaturamento;
  if Destinatarios = '' then Exit;

  Assunto := 'Liberação para Faturamento – ' + NomeSite + ' | IDPMTS ' + IDPMTS;

  Corpo := '<!DOCTYPE html>' +
           '<html>' +
           '<head>' +
           '  <style>' +
           '    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }' +
           '    .container { max-width: 600px; margin: 0 auto; padding: 20px; }' +
           '    .header { background-color: #0066cc; color: white; padding: 15px; text-align: center; border-radius: 5px 5px 0 0; }' +
           '    .content { background-color: #f9f9f9; padding: 20px; border: 1px solid #ddd; border-top: none; }' +
           '    .info-item { margin-bottom: 10px; }' +
           '    .label { font-weight: bold; color: #0066cc; }' +
           '    .date { background-color: #607D8B; color: white; padding: 5px 10px; border-radius: 3px; display: inline-block; }' +
           '    .footer { margin-top: 20px; padding-top: 15px; border-top: 1px solid #ddd; color: #666; font-size: 12px; }' +
           '  </style>' +
           '</head>' +
           '<body>' +
           '  <div class="container">' +
           '    <div class="header">' +
           '      <h2>Liberação para Faturamento</h2>' +
           '    </div>' +
           '    <div class="content">' +
           '      <div class="info-item"><span class="label">PO:</span> ' + PO + '</div>' +
           '      <div class="info-item"><span class="label">IDPMTS:</span> ' + IDPMTS + '</div>' +
           '      <div class="info-item"><span class="label">Site:</span> ' + NomeSite + '</div>' +
           '      <div class="info-item"><span class="label">Data de integração:</span> <span class="date">' + DataIntegracao + '</span></div>' +
           '      <br>' +
           '      <p>Legado executado. Liberado para faturamento.</p>' +
           '    </div>' +
           '    <div class="footer">' +
           '      E-mail automático - Sistema de Gestão de Projetos' +
           '    </div>' +
           '  </div>' +
           '</body>' +
           '</html>';

  SendEmail(Destinatarios, Assunto, Corpo);
end;

end.


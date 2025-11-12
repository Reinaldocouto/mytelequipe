unit Controller.Pessoa;

interface

uses
  System.Generics.Collections, Horse, System.JSON, System.SysUtils,
  FireDAC.Comp.Client, Data.DB, DataSet.Serialize, Model.Pessoa, UtFuncao,
  Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listatreinamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listatreinamentolista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listatreinamentogeral(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure UploadTreinamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure UploadPessoas(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listacurso(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure ListaSelect(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure ListaSelectclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure ListaSelectpj(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Salvatreinamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure ListaSelectfuncionario(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Cadastratreinamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure AtualizaTreinamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/pessoa', Lista);
  THorse.get('v1/pessoa/treinamento', Listatreinamento);
  THorse.get('v1/pessoa/treinamentolista', Listatreinamentolista);
  THorse.post('v1/pessoa/treinamento', salvatreinamento);
  THorse.get('v1/pessoaid', Listaid);
  THorse.post('v1/pessoa/uploadTreinamento', UploadTreinamento);
  THorse.post('v1/pessoa/uploadPessoas', UploadPessoas);
  THorse.post('v1/pessoa', salva);
  THorse.Post('v1/pessoa/novocadastro', novocadastro);
  THorse.get('v1/pessoa/select', ListaSelect);
  THorse.get('v1/pessoa/selectclt', ListaSelectclt);
  THorse.get('v1/pessoa/selectpj', ListaSelectpj);
  THorse.get('v1/curso', Listacurso);
  THorse.get('v1/pessoa/selectfuncionario/:id', ListaSelectfuncionario);
  THorse.post('v1/cadastratreinamento', Cadastratreinamento);
  THorse.post('v1/pessoa/atualizatreinamento', AtualizaTreinamento);
  THorse.get('v1/pessoa/treinamentogeral', Listatreinamentogeral);
end;

procedure AtualizaTreinamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  body: TJSONObject;
  erro: string;
begin
  servico := TPessoa.Create;
  try
    erro := '';
    try
      body := Req.Body<TJSONObject>;
      servico.idtreinamento := body.GetValue<integer>('idgestreinamento', 0);

      if body.GetValue<string>('dataemissao', '') <> '' then
        servico.dataemissaotreinamento := body.GetValue<string>('dataemissao', '');

      if body.GetValue<string>('statustreinamento', '') <> '' then
        servico.statustreinamento := body.GetValue<string>('statustreinamento', '');

      if body.GetValue<string>('datavencimentotreinamento', '') <> '' then
        servico.datavencimentotreinamento := body.GetValue<string>('datavencimentotreinamento', '');

      if Length(erro) = 0 then
      begin
        if servico.AtualizarTreinamento(Req.Query.Dictionary, erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idtreinamento)).Status(THTTPStatus.OK)
        else
          Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
      end
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.BadRequest);

    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TPessoa.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idpessoa)).Status(THTTPStatus.Created)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TPessoa.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Lista(Req.Query.Dictionary, erro);
  try
    try
      arraydados := qry.ToJSONArray();
      if erro = '' then
        Res.Send<TJSONArray>(arraydados).Status(THTTPStatus.OK)
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

procedure Listatreinamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TPessoa.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listatreinamento(Req.Query.Dictionary, erro);
  try
    try
      arraydados := qry.ToJSONArray();
      if erro = '' then
        Res.Send<TJSONArray>(arraydados).Status(THTTPStatus.OK)
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

procedure Listatreinamentolista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TPessoa.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listatreinamentolista(Req.Query.Dictionary, erro);
  try
    try
      arraydados := qry.ToJSONArray();
      if erro = '' then
        Res.Send<TJSONArray>(arraydados).Status(THTTPStatus.OK)
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

procedure Listatreinamentogeral(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TPessoa.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listatreinamentogeral(Req.Query.Dictionary, erro);
  try
    try
      arraydados := qry.ToJSONArray();
      if erro = '' then
        Res.Send<TJSONArray>(arraydados).Status(THTTPStatus.OK)
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

procedure Listacurso(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TPessoa.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.Listacurso(Req.Query.Dictionary, erro);
  try
    try
      arraydados := qry.ToJSONArray();
      if erro = '' then
        Res.Send<TJSONArray>(arraydados).Status(THTTPStatus.OK)
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

procedure ListaSelect(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
begin
  servico := nil;
  qry := nil;
  arraydados := nil;
  try
    try
      servico := TPessoa.Create;
    except
      Res.Status(THTTPStatus.InternalServerError);
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao inicializar serviço'));
      Exit;
    end;

    try
      qry := servico.ListaSelect(Req.Query.Dictionary, erro);
    except
      on E: Exception do
      begin
        Res.Status(THTTPStatus.InternalServerError);
        Res.Send<TJSONObject>(CreateJsonObj('erro', E.Message));
        Exit;
      end;
    end;

    if (erro <> '') then
    begin
      Res.Status(THTTPStatus.InternalServerError);
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro));
      Exit;
    end;

    if not Assigned(qry) then
    begin
      Res.Status(THTTPStatus.InternalServerError);
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'Consulta não retornou dados'));
      Exit;
    end;

    try
      arraydados := qry.ToJSONArray;
      Res.Status(THTTPStatus.OK);
      Res.Send<TJSONArray>(arraydados);
      arraydados := nil;
    except
      on E: Exception do
      begin
        Res.Status(THTTPStatus.InternalServerError);
        Res.Send<TJSONObject>(CreateJsonObj('erro', E.Message));
      end;
    end;
  finally
    if Assigned(arraydados) then
      arraydados.Free;
    if Assigned(qry) then
      qry.Free;
    if Assigned(servico) then
      servico.Free;
  end;
end;


procedure ListaSelectclt(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TPessoa.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaSelectcolaboradorclt(Req.Query.Dictionary, erro);
  try
    try
      arraydados := qry.ToJSONArray();
      if erro = '' then
        Res.Send<TJSONArray>(arraydados).Status(THTTPStatus.OK)
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

procedure ListaSelectpj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TPessoa.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;
  qry := servico.ListaSelectpj(Req.Query.Dictionary, erro);
  try
    try
      arraydados := qry.ToJSONArray();
      if erro = '' then
        Res.Send<TJSONArray>(arraydados).Status(THTTPStatus.OK)
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

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
  body: TJSONValue;
begin
  try
    servico := TPessoa.Create;
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

procedure UploadTreinamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  body: TJSONArray;
  JSONItem: TJSONValue;
  erro: string;
begin
  erro := '';
  try
    // Obtendo o corpo da requisi��o e verificando se est� nulo
    body := Req.Body<TJSONArray>;
    if not Assigned(body) then
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', 'O corpo da requisi��o est� vazio ou inv�lido')).Status(THTTPStatus.BadRequest);
      Exit;
    end;

    // Iterando sobre os itens do array
    for JSONItem in body do
    begin
      servico := TPessoa.Create;
      try
        // Extraindo os dados do JSONItem
        servico.idpessoa := JSONItem.GetValue<integer>('idpessoa', 0);
        servico.idtreinamento := JSONItem.GetValue<integer>('idtreinamento', 0);
        servico.dataemissaotreinamento := JSONItem.GetValue<string>('datadeemissao', '');
        servico.datavencimentotreinamento := JSONItem.GetValue<string>('datadevencimento', '');
        servico.statustreinamento := JSONItem.GetValue<string>('statustreinamento', '');
        servico.dataemissaotreinamento := Copy(servico.dataemissaotreinamento, 1, 10);
        servico.datavencimentotreinamento := Copy(servico.datavencimentotreinamento, 1, 10);
        // Validando e salvando o treinamento
        if Length(erro) = 0 then
        begin
          if not servico.Salvatreinamento(erro) then
          begin
            Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
            Exit;
          end;
        end
        else
        begin
          Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.BadRequest);
          Exit;
        end;
      except
        on ex: Exception do
        begin
          Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
          Exit;
        end;
      end;
      servico.Free;
    end;

    // Se tudo for salvo com sucesso
    Res.Send<TJSONObject>(CreateJsonObj('retorno', 'Dados salvos com sucesso')).Status(THTTPStatus.OK);
  except
    on ex: Exception do
      Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
  end;
end;

procedure UploadPessoas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servicos: TList<TPessoa>;
  body: TJSONArray;
  JSONItem: TJSONValue;
  erro: string;
  pessoa: TPessoa;
begin
  erro := '';
  pessoa := TPessoa.Create; // Criar a instância
  try
    try
      body := Req.Body<TJSONArray>;
      if Length(erro) = 0 then
      begin
        if pessoa.EditarUpload(body, erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', pessoa.idpessoa)).Status(THTTPStatus.Created)
        else
          Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
      end
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.BadRequest);

      // Se não houve erros, retorna sucesso
      if Length(erro) = 0 then
        Res.Send<TJSONObject>(CreateJsonObj('success', 'Lista de pessoas atualizada com sucesso')).Status(THTTPStatus.OK)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.BadRequest);

    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    pessoa.Free; // Liberar a instância
  end;
end;

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TPessoa.Create;
  erro := '';
  try
    try
      body := Req.body<TJSONObject>;

      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idpessoa', '')) then
        servico.idpessoa := body.getvalue<integer>('idpessoa', 0)
      else
        servico.idpessoa := 0;
      servico.nome := body.getvalue<string>('nome', '');
      //servico.nome := body.getvalue<string>('nome', '');
      servico.tipopessoa := body.getvalue<string>('tipopessoa', '');
      servico.regional := body.getvalue<string>('regional', '');
      servico.cadastro := body.getvalue<string>('cadastro', '');
      servico.nregistro := body.getvalue<string>('nregistro', '');
      servico.dataadmissao := body.getvalue<string>('dataadmissao', '');
      servico.datademissao := body.getvalue<string>('datademissao', '');
      servico.matriculaesocial := body.getvalue<string>('matriculaesocial', '');
      servico.cbo := body.getvalue<string>('cbo', '');
      servico.idempresa := body.getvalue<string>('idempresa', '');
      servico.cargo := body.getvalue<string>('cargo', '');
      servico.email := body.getvalue<string>('email', '');
      servico.telefone := body.getvalue<string>('telefone', '');
      servico.emailcorporativo := body.getvalue<string>('emailcorporativo', '');
      servico.telefonecorporativo := body.getvalue<string>('telefonecorporativo', '');
      servico.cor := body.getvalue<string>('cor', '');
      servico.sexo := body.getvalue<string>('sexo', '');
      servico.datanascimento := body.getvalue<string>('datanascimento', '');
      servico.estadocivil := body.getvalue<string>('estadocivil', '');
      servico.naturalidade := body.getvalue<string>('naturalidade', '');
      servico.nacionalidade := body.getvalue<string>('nacionalidade', '');
      servico.nomepai := body.getvalue<string>('nomepai', '');
      servico.nomemae := body.getvalue<string>('nomemae', '');
      servico.observacao := body.getvalue<string>('observacao', '');
      servico.mei := body.getvalue<string>('mei', '');
      servico.reset90 := body.getvalue<string>('reset90', '');

      if strisint(body.getvalue<string>('nfilho', '')) then
        servico.nfilho := body.getvalue<integer>('nfilho', 0)
      else
        servico.nfilho := 0;

      if body.getvalue<boolean>('checericsson', false) then
        servico.checericsson := 1
      else
        servico.checericsson := 0;

      if body.getvalue<boolean>('chechuawei', false) then
        servico.chechuawei := 1
      else
        servico.chechuawei := 0;

      if body.getvalue<boolean>('checzte', false) then
        servico.checzte := 1
      else
        servico.checzte := 0;

      if body.getvalue<boolean>('checknokia', false) then
        servico.checknokia := 1
      else
        servico.checknokia := 0;

      if body.getvalue<boolean>('checoutros', false) then
        servico.checoutros := 1
      else
        servico.checoutros := 0;

      servico.especificaroutros := body.getvalue<string>('especificar', '');


      //servico.nfilho := body.getvalue<string>('nfilho', '');

      //servico.nfilho := body.getvalue<string>('nfilho', '');
      servico.cep := body.getvalue<string>('cep', '');
      servico.endereco := body.getvalue<string>('endereco', '');
      servico.numero := body.getvalue<string>('numero', '');
      servico.complemento := body.getvalue<string>('complemento', '');
      servico.bairro := body.getvalue<string>('bairro', '');
      servico.municipio := body.getvalue<string>('municipio', '');
      servico.estado := body.getvalue<string>('estado', '');
      servico.rgrne := body.getvalue<string>('rgrne', '');
      servico.orgaoemissor := body.getvalue<string>('orgaoemissor', '');
      servico.dataemissao := body.getvalue<string>('dataemissao', '');
      servico.cpf := body.getvalue<string>('cpf', '');
      servico.tituloeleitor := body.getvalue<string>('tituloeleitor', '');
      servico.pis := body.getvalue<string>('pis', '');
      servico.ctps := body.getvalue<string>('ctps', '');
      servico.datactps := body.getvalue<string>('datactps', '');
      servico.reservista := body.getvalue<string>('reservista', '');
      servico.cnh := body.getvalue<string>('cnh', '');
      servico.datavalidadecnh := body.getvalue<string>('datavalidadecnh', '');
      servico.categoriacnh := body.getvalue<string>('categoriacnh', '');
      servico.primhabilitacao := body.getvalue<string>('primhabilitacao', '');
      servico.escolaridade := body.getvalue<string>('escolaridade', '');
      servico.tipocurso := body.getvalue<string>('tipocurso', '');
      servico.tipograduacao := body.getvalue<string>('tipograduacao', '');

      servico.datacadastro := body.getvalue<string>('datacadastro', '');
      servico.reativacao := body.getvalue<string>('reativacao', '');
      servico.idericsson := body.getvalue<string>('idericsson', '');
      servico.idisignum := body.getvalue<string>('idisignum', '');
      servico.idhuawei := body.getvalue<string>('idhuawei', '');
      servico.idzte := body.getvalue<string>('idzte', '');
      servico.senhahuawei := body.getvalue<string>('senhahuawei', '');
      servico.inativacao := body.getvalue<string>('inativacao', '');
      servico.senhazte := body.getvalue<string>('senhazte', '');
      servico.status := body.getvalue<string>('status', '');

      servico.valorhora := body.getvalue<real>('valorhora', 0);
      servico.salariobruto := body.getvalue<real>('salariobruto', 0);
      servico.fator := body.getvalue<real>('fator', 0);
      servico.horasmes := body.getvalue<real>('horasmes', 0);

     {
      if StrIsdouble(body.getvalue<string>('valorhora', '')) then
        servico.valorhora := body.getvalue<double>('valorhora', 0)
      else
        servico.valorhora := 0;

      if StrIsdouble(body.getvalue<string>('salariobruto', '')) then
        servico.salariobruto := body.getvalue<double>('salariobruto', 0)
      else
        servico.salariobruto := 0;

      if StrIsdouble(body.getvalue<string>('fator', '')) then
        servico.fator := body.getvalue<double>('fator', 0)
      else
        servico.fator := 0;

      if StrIsdouble(body.getvalue<string>('horasmes', '')) then
        servico.horasmes := body.getvalue<double>('horasmes', 0)
      else
        servico.horasmes := 0;
        }

      if Length(servico.nome) = 0 then
        erro := 'Campo Nome Obrigatorio';

      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idpessoa)).Status(THTTPStatus.Created)
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

procedure Salvatreinamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TPessoa.Create;
  erro := '';
  try
    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idpessoa', '')) then
        servico.idpessoa := body.getvalue<integer>('idpessoa', 0)
      else
        servico.idpessoa := 0;
      if strisint(body.getvalue<string>('idtreinamento', '')) then
        servico.idtreinamento := body.getvalue<integer>('idtreinamento', 0)
      else
        servico.idtreinamento := 0;
      servico.dataemissaotreinamento := body.getvalue<string>('dataemissaotreinamento', '');
      servico.datavencimentotreinamento := body.getvalue<string>('datavencimentotreinamento', '');
      servico.statustreinamento := body.getValue<string>('statustreinamento', '');

      if Length(erro) = 0 then
      begin
        if servico.Salvatreinamento(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idpessoa)).Status(THTTPStatus.Created)
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

procedure Cadastratreinamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  body: TJSONValue;
  JSON: TJSONObject;
  erro: string;
begin
  servico := TPessoa.Create;
  erro := '';
  try
    try
      body := Req.body<TJSONObject>;
      if strisint(body.getvalue<string>('idtreinamento', '')) then
        servico.idtreinamento := body.getvalue<integer>('idtreinamento', 0)
      else
        servico.idtreinamento := 0;

      servico.descricaotreinamento := body.getvalue<string>('treinamento', '');

      if strisint(body.getvalue<string>('validade', '')) then
        servico.duracaotreinamento := body.getvalue<integer>('validade', 0)
      else
        servico.duracaotreinamento := 0;

      if Length(erro) = 0 then
      begin
        if servico.Cadastratreinamento(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idtreinamento)).Status(THTTPStatus.Created)
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

procedure ListaSelectfuncionario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TPessoa;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
begin
  servico := TPessoa.Create;
  try
    try
      if Req.Params.ContainsKey('id') then
        servico.idpessoa := Req.Params['id'].ToInteger
      else
        raise Exception.Create('ID da pessoa não informado');

      Writeln(Req.ToString);


      if Req.Query.ContainsKey('isOnlyCnh') then
       servico.isOnlyCnh := Req.Query['isOnlyCnh'].ToInteger;

      qry := servico.ListaSelectfuncionario(Req.Query.Dictionary, erro);
      try
        arraydados := qry.ToJSONArray();
        if erro = '' then
          Res.Send<TJSONArray>(arraydados).Status(THTTPStatus.OK)
        else
          Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
      finally
        qry.Free;
      end;

    except
      on ex: Exception do
      begin
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
      end;
    end;
  finally
    servico.Free;
  end;
end;


end.


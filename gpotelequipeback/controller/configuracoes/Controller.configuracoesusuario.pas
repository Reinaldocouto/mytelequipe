unit Controller.configuracoesusuario;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, model.configuracoesusuario, UtFuncao, Controller.Auth;

procedure Registry;

procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/cadusuariosistema', Lista);
  THorse.get('v1/cadusuariosistemaid', Listaid);
  THorse.post('v1/cadusuariosistema', salva);
  THorse.Post('v1/cadusuariosistema/novocadastro', novocadastro);
end;

procedure novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idusuario)).Status(THTTPStatus.Created)
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
  servico: TUsuario;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
  body: TJSONValue;
begin
  try
    servico := TUsuario.Create;
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

      if strisint(body.getvalue<string>('idusuario', '')) then
        servico.idusuario := body.getvalue<integer>('idusuario', 0)
      else
        servico.idusuario := 0;

      servico.nome := body.GetValue<string>('nome', '');
      servico.email := body.GetValue<string>('email', '');
      servico.senha := body.GetValue<string>('senha', '');
      servico.datacriacao := body.GetValue<string>('datacriacao', '');
      servico.observacao := body.GetValue<string>('observacao', '');

      if body.getvalue<boolean>('ativo', false) then
        servico.ativo := 1
      else
        servico.ativo := 0;

      if body.getvalue<boolean>('selecionarTodos', false) then
        servico.selecionarTodos := 1
      else
        servico.selecionarTodos := 0;

      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);

      if servico.selecionarTodos = 1 then
      begin
        servico.pessoas := 1;
        servico.produtos := 1;
        servico.empresas := 1;
        servico.rh := 1;
        servico.veiculos := 1;
        servico.gestaoMultas := 1;
        servico.despesas := 1;
        servico.monitoramento := 1;
        servico.controleestoque := 1;
        servico.compras := 1;
        servico.solicitacao := 1;
        servico.solicitacaoavulsa := 1;
        servico.requisicao := 1;
        servico.ericAcionamento := 1;
        servico.ericAdicional := 1;
        servico.ericControleLpu := 1;
        servico.ericRelatorio := 1;
        servico.huaAcionamento := 1;
        servico.huaAdicional := 1;
        servico.huaControleLpu := 1;
        servico.huaRelatorio := 1;
        servico.zteAcionamento := 1;
        servico.zteAdicional := 1;
        servico.zteControleLpu := 1;
        servico.zteRelatorio := 1;
        servico.ericfechamento := 1;
        servico.huafechamento := 1;
        servico.ztefechamento := 1;
        servico.telefonicafechamento := 1;
        servico.telefonicaControle := 1;
        servico.telefonicaRelatorio := 1;
        servico.telefonicaControleLpu := 1;
        servico.telefonicaEdicaoDocumentacao := 1;
        servico.telefonicaT4 := 1;
        servico.cosfechamento := 1;
        servico.cosControle := 1;
        servico.cosRelatorio := 1;
        servico.cosControleLpu := 1;
        servico.demonstrativo := 1;
      end
      else
      begin
         if body.getvalue<boolean>('pessoas', false) then
          servico.pessoas := 1
        else
          servico.pessoas := 0;

        if body.getvalue<boolean>('produtos', false) then
          servico.produtos := 1
        else
          servico.produtos := 0;
        if body.getvalue<boolean>('modovisualizador', false) then
          servico.modovisualizador := 1
        else
          servico.modovisualizador := 0;


        if body.getvalue<boolean>('empresas', false) then
          servico.empresas := 1
        else
          servico.empresas := 0;

        if body.getvalue<boolean>('rh', false) then
          servico.rh := 1
        else
          servico.rh := 0;

        if body.getvalue<boolean>('veiculos', false) then
          servico.veiculos := 1
        else
          servico.veiculos := 0;

        if body.getvalue<boolean>('gestaoMultas', false) then
          servico.gestaoMultas := 1
        else
          servico.gestaoMultas := 0;

        if body.getvalue<boolean>('despesas', false) then
          servico.despesas := 1
        else
          servico.despesas := 0;

        if body.getvalue<boolean>('monitoramento', false) then
          servico.monitoramento := 1
        else
          servico.monitoramento := 0;

        if body.getvalue<boolean>('controleestoque', false) then
          servico.controleestoque := 1
        else
          servico.controleestoque := 0;

        if body.getvalue<boolean>('compras', false) then
          servico.compras := 1
        else
          servico.compras := 0;

        if body.getvalue<boolean>('solicitacao', false) then
          servico.solicitacao := 1
        else
          servico.solicitacao := 0;

        if body.getvalue<boolean>('solicitacaoavulsa', false) then
          servico.solicitacaoavulsa := 1
        else
          servico.solicitacaoavulsa := 0;

        if body.getvalue<boolean>('requisicao', false) then
          servico.requisicao := 1
        else
          servico.requisicao := 0;

        if body.getvalue<boolean>('ericAcionamento', false) then
          servico.ericAcionamento := 1
        else
          servico.ericAcionamento := 0;

        if body.getvalue<boolean>('ericFaturamento', false) then
          servico.ericFaturamento := 1
        else
          servico.ericFaturamento := 0;

        if body.getvalue<boolean>('ericAdicional', false) then
          servico.ericAdicional := 1
        else
          servico.ericAdicional := 0;

        if body.getvalue<boolean>('ericControleLpu', false) then
          servico.ericControleLpu := 1
        else
          servico.ericControleLpu := 0;

        if body.getvalue<boolean>('ericRelatorio', false) then
          servico.ericRelatorio := 1
        else
          servico.ericRelatorio := 0;

        if body.getvalue<boolean>('huaAcionamento', false) then
          servico.huaAcionamento := 1
        else
          servico.huaAcionamento := 0;

        if body.getvalue<boolean>('huaAdicional', false) then
          servico.huaAdicional := 1
        else
          servico.huaAdicional := 0;

        if body.getvalue<boolean>('huaControleLpu', false) then
          servico.huaControleLpu := 1
        else
          servico.huaControleLpu := 0;

        if body.getvalue<boolean>('huaRelatorio', false) then
          servico.huaRelatorio := 1
        else
          servico.huaRelatorio := 0;

        if body.getvalue<boolean>('zteAcionamento', false) then
          servico.zteAcionamento := 1
        else
          servico.zteAcionamento := 0;

        if body.getvalue<boolean>('zteAdicional', false) then
          servico.zteAdicional := 1
        else
          servico.zteAdicional := 0;

        if body.getvalue<boolean>('zteControleLpu', false) then
          servico.zteControleLpu := 1
        else
          servico.zteControleLpu := 0;

        if body.getvalue<boolean>('zteRelatorio', false) then
          servico.zteRelatorio := 1
        else
          servico.zteRelatorio := 0;



        if body.getvalue<boolean>('ericfechamento', false) then
          servico.ericfechamento := 1
        else
          servico.ericfechamento := 0;

        if body.getvalue<boolean>('huafechamento', false) then
          servico.huafechamento := 1
        else
          servico.huafechamento := 0;

        if body.getvalue<boolean>('ztefechamento', false) then
          servico.ztefechamento := 1
        else
          servico.ztefechamento := 0;

        if body.getvalue<boolean>('telefonicaControle', false) then
          servico.telefonicaControle := 1
        else
          servico.telefonicaControle := 0;

        if body.getvalue<boolean>('telefonicaRelatorio', false) then
          servico.telefonicaRelatorio := 1
        else
          servico.telefonicaRelatorio := 0;

        if body.getvalue<boolean>('telefonicaEdicaoDocumentacao', false) then
          servico.telefonicaEdicaoDocumentacao := 1
        else
          servico.telefonicaEdicaoDocumentacao := 0;

       if body.getvalue<boolean>('telefonicaT4', false) then
          servico.telefonicaT4 := 1
        else
          servico.telefonicaT4 := 0;

        if body.getvalue<boolean>('telefonicaControleLpu', false) then
          servico.telefonicaControleLpu := 1
        else
          servico.telefonicaControleLpu := 0;

        if body.getvalue<boolean>('cosfechamento', false) then
          servico.cosfechamento := 1
        else
          servico.cosfechamento := 0;

        if body.getvalue<boolean>('cosControle', false) then
          servico.cosControle := 1
        else
          servico.cosControle := 0;

        if body.getvalue<boolean>('cosRelatorio', false) then
          servico.cosRelatorio := 1
        else
          servico.cosRelatorio := 0;

        if body.getvalue<boolean>('cosControleLpu', false) then
          servico.cosControleLpu := 1
        else
          servico.cosControleLpu := 0;

        if body.getvalue<boolean>('demonstrativo', false) then
          servico.demonstrativo := 1
        else
          servico.demonstrativo := 0;

        if body.getvalue<boolean>('telefonicafechamento', false) then
          servico.telefonicafechamento := 1
        else
          servico.telefonicafechamento := 0;
      end;



      if Length(erro) = 0 then
      begin
        if servico.Editar(erro) then
          Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idusuario)).Status(THTTPStatus.Created)
        else
          Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
      end
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

end.


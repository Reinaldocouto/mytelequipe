unit Controller.Multas;

interface

uses
  Horse, System.JSON, System.SysUtils, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, Model.Multas, UtFuncao, Controller.Auth;

procedure Registry;
procedure Lista(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Listaid(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure BuscaMultaPorPlacaData(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DebitarMulta(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.get('v1/multas', Lista);
  THorse.get('v1/multasid', Listaid);
  THorse.get('v1/multas/placadata', BuscaMultaPorPlacaData);
  THorse.post('v1/multas', Salva);
  THorse.post('v1/multas/debitados', DebitarMulta);
  THorse.post('v1/multas/novocadastro', Novocadastro);
end;

// Fun��o para converter a data em m�ltiplos formatos
function TentarConverterData(const DataStr: string; out DataConvertida: TDateTime): Boolean;
const
  Formatos: array[0..3] of string = (
    'dd/mm/yyyy',         // Formato padr�o brasileiro
    'dd/mm/yyyy hh:nn:ss',// Com hor�rio
    'yyyy-mm-dd',         // ISO
    'yyyy-mm-dd hh:nn:ss' // ISO com hor�rio
  );
var
  I: Integer;
begin
  Result := False;
  for I := Low(Formatos) to High(Formatos) do
  begin
    try
      DataConvertida := StrToDateTime(DataStr);
      Exit(True); // Se converter, retorna sucesso
    except
      Continue; // Tenta pr�ximo formato se falhar
    end;
  end;
end;

// Busca multas por placa e data da infra��o
procedure BuscaMultaPorPlacaData(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TMultas;
  qry: TFDQuery;
  erro, placa, datainfracao: string;
  arraydados: TJSONObject;
  DataConvertida: TDateTime;
begin
  try
    servico := TMultas.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  placa := Req.Query.Field('placa').AsString;
  datainfracao := Req.Query.Field('datainfracao').AsString;

  // Valida par�metros obrigat�rios
  if (placa = '') or (datainfracao = '') then
  begin
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Placa e data da infra��o s�o obrigat�rios')).Status(THTTPStatus.BadRequest);
    Exit;
  end;

  // Tenta converter a data para garantir compatibilidade com o banco
  if not TentarConverterData(datainfracao, DataConvertida) then
  begin
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Formato de data inv�lido. Use DD/MM/AAAA')).Status(THTTPStatus.BadRequest);
    Exit;
  end;

  // Busca no banco
  qry := servico.BuscaPorPlacaData(placa, FormatDateTime('yyyy-mm-dd hh:nn:ss', DataConvertida), erro);
  try
    if erro = '' then
    begin
      arraydados := qry.ToJSONObject;
      Res.Send<TJSONObject>(arraydados).Status(THTTPStatus.OK);
    end
    else
    begin
      Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    qry.Free;
    servico.Free;
  end;
end;

procedure Novocadastro(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TMultas;
  body: TJSONValue;
  erro: string;
begin
  servico := TMultas.Create;
  try
    try
      body := Req.body<TJSONObject>;
      servico.idcliente := body.getvalue<integer>('idcliente', 0);
      servico.idloja := body.getvalue<integer>('idloja', 0);
      if servico.NovoCadastro(erro) > 0 then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', servico.idmultas)).Status(THTTPStatus.Created)
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
  servico: TMultas;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONArray;
begin
  try
    servico := TMultas.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
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
  servico: TMultas;
  qry: TFDQuery;
  erro: string;
  arraydados: TJSONObject;
begin
  try
    servico := TMultas.Create;
  except
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
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

procedure DebitarMulta(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TMultas;
  body: TJSONValue;
  erro: string;
begin
  servico := TMultas.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      servico.idsMultas := body.GetValue<string>('ids', '');


      if servico.TransformaDebitado(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', 'Salvo com sucesso')).Status(THTTPStatus.Created)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;

procedure Salva(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  servico: TMultas;
  body: TJSONValue;
  erro: string;
begin
  servico := TMultas.Create;
  try
    try
      body := Req.Body<TJSONObject>;
      servico.idcliente := body.GetValue<Integer>('idcliente', 0);
      servico.idloja := body.GetValue<Integer>('idloja', 0);
      servico.idmultas := body.GetValue<Integer>('idmultas', 0);
      servico.idempresa := body.GetValue<Integer>('idempresa', 0);
      servico.idpessoa := body.GetValue<Integer>('idpessoa', 0);
      servico.numeroait := body.getvalue<string>('numeroait', '');
      servico.pontuacao:= body.GetValue<Integer>('pontuacao', 0);
     //servico.nomeindicado:=
      servico.placa:= body.getvalue<string>('placa', '') ;
      servico.datainfracao:= body.getvalue<string>('datainfracao', '') ;
      servico.local:= body.getvalue<string>('local', '') ;
      servico.infracao:= body.getvalue<string>('infracao', '') ;
      servico.valor:= body.getvalue<string>('valor', '') ;
      servico.dataindicacao:= body.getvalue<string>('dataindicacao', '') ;
      servico.natureza:=  body.getvalue<string>('natureza', '') ;
      servico.datacolaborador:= body.getvalue<string>('datacolaborador', '') ;
      servico.statusmulta:=  body.getvalue<string>('statusmulta', '') ;



      if servico.Editar(erro) then
        Res.Send<TJSONObject>(CreateJsonObj('retorno', 'Salvo com sucesso')).Status(THTTPStatus.Created)
      else
        Res.Send<TJSONObject>(CreateJsonObj('erro', erro)).Status(THTTPStatus.InternalServerError);
    except
      on ex: Exception do
        Res.Send<TJSONObject>(CreateJsonObj('erro', ex.Message)).Status(THTTPStatus.InternalServerError);
    end;
  finally
    servico.Free;
  end;
end;


end.


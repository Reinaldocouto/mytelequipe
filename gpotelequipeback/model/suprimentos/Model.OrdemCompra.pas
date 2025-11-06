unit Model.OrdemCompra;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections, System.Classes,
  Model.RegrasdeNegocio, Model.Email;

type
  TOrdemCompra = class
  private
    FConn: TFDConnection;
    Fidordemcompra: Integer;
    Fsituacao: string;
    Fidordemcompraitens: Integer;
    Fidcliente: Integer;
    Fidusuario: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
    Fitem: Integer;
    Fidproduto: Integer;
    Fquantidade: Double;
    Fpreco: Double;
    Fipi: Double;
    Fvalorst: Double;
    Fvalortotal: Double;
    Fidsolicitacaoitens: Integer;
    Fdestinatarios: string;

    Fnitens: Integer;
    Fidfornecedor: Integer;
    Fidtransportadora: Integer;
    Fsomaqtdes: Double;
    Ftotalprodutos: Double;
    Fdesconto: Double;
    Ffrete: Double;
    Ftotalipi: Double;
    Ftotalicmsst: Double;
    Ftotalgeral: Double;
    Fidtipofrete: Integer;
    Fnumerofornecedor: string;
    Fdatacompra: string;
    Fdataprevista: string;
    Fobservacao: string;
    Fobservacaointerna: string;
    Faprovadopor: string;
  public
    constructor Create;
    destructor Destroy; override;

    property idordemcompra: Integer read Fidordemcompra write Fidordemcompra;
    property situacao: string read Fsituacao write Fsituacao;
    property idordemcompraitens: Integer read Fidordemcompraitens write Fidordemcompraitens;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idusuario: Integer read Fidusuario write Fidusuario;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property item: Integer read Fitem write Fitem;
    property idproduto: Integer read Fidproduto write Fidproduto;
    property quantidade: double read Fquantidade write Fquantidade;
    property preco: double read Fpreco write Fpreco;
    property ipi: double read Fipi write Fipi;
    property valorst: double read Fvalorst write Fvalorst;
    property valortotal: double read Fvalortotal write Fvalortotal;
    property idsolicitacaoitens: Integer read Fidsolicitacaoitens write Fidsolicitacaoitens;
    property destinatarios: string read Fdestinatarios write Fdestinatarios;

    property aprovadopor: string read Faprovadopor write Faprovadopor;

    property nitens: Integer read Fnitens write Fnitens;
    property idfornecedor: Integer read Fidfornecedor write Fidfornecedor;
    property idtransportadora: Integer read Fidtransportadora write Fidtransportadora;
    property somaqtdes: Double read Fsomaqtdes write Fsomaqtdes;
    property totalprodutos: Double read Ftotalprodutos write Ftotalprodutos;
    property desconto: Double read Fdesconto write Fdesconto;
    property frete: Double read Ffrete write Ffrete;
    property totalipi: Double read Ftotalipi write Ftotalipi;
    property totalicmsst: Double read Ftotalicmsst write Ftotalicmsst;
    property totalgeral: Double read Ftotalgeral write Ftotalgeral;
    property numerofornecedor: string read Fnumerofornecedor write Fnumerofornecedor;
    property datacompra: string read Fdatacompra write Fdatacompra;
    property dataprevista: string read Fdataprevista write Fdataprevista;
    property idtipofrete: Integer read Fidtipofrete write Fidtipofrete;
    property observacao: string read Fobservacao write Fobservacao;
    property observacaointerna: string read Fobservacaointerna write Fobservacaointerna;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaitens(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaitensid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaitenssoma(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function NovoCadastro(out erro: string): integer;
    function NovoCadastroItens(out erro: string): integer;
    function EditarItens(out erro: string): Boolean;
    function EditarItenssolicitacao(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
    function mudarstatus(out erro: string): boolean;
    function lancarestoque(out erro: string): boolean;
    function cancelarlancarestoque(out erro: string): boolean;
    function AprovacaoDaOrdemDeServico(out erro: string): Boolean;
    function GetEmailsAviso(const ATipo: string): string;
  end;

implementation

{ TProduto }

constructor TOrdemCompra.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TOrdemCompra.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TOrdemCompra.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  busca: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    with qry.SQL do
    begin
      Clear;
      Add('SELECT ');
      Add('  gesordemcompra.*, ');
      Add('  gesordemcompra.idordemcompra AS id, ');
      Add('  gesordemcompra.criadoem AS criadoem, ');
      Add('  DATE_FORMAT(gesordemcompra.data, ''%d/%m/%Y'') AS data, ');
      Add('  DATE_FORMAT(gesordemcompra.dataprevisto, ''%d/%m/%Y'') AS dataprevisto, ');
      Add('  gesempresas.nome AS fornecedor, ');
      Add('  MAX(gesusuario.nome) AS solicitante, ');
      Add('  DATE_FORMAT(MAX(gesordemcompraitens.datasolicitacao), ''%d/%m/%Y'') AS datasolicitacao, ');
      Add('  CONCAT(''R$ '', FORMAT(gesordemcompra.totalgeral, 2, ''de_DE'')) AS total ');
      Add('FROM gesordemcompra ');
      Add('LEFT JOIN gesordemcompraitens ON gesordemcompraitens.idordemcompra = gesordemcompra.idordemcompra ');
      Add('LEFT JOIN gesempresas ON gesempresas.idempresa = gesordemcompra.idfornecedor ');
      Add('LEFT JOIN gesusuario ON gesordemcompraitens.idUsuarioSolicitante = gesusuario.idusuario ');
      Add('WHERE gesordemcompra.idordemcompra IS NOT NULL ');
      Add('  AND gesordemcompra.deletado = 0 ');

      if AQuery.ContainsKey('idcliente') then
        if Trim(AQuery.Items['idcliente']) <> '' then
          Add('  AND gesordemcompra.idcliente = ' + AQuery.Items['idcliente']);

      if AQuery.ContainsKey('idloja') then
        if Trim(AQuery.Items['idloja']) <> '' then
          Add('  AND gesordemcompra.idloja = ' + AQuery.Items['idloja']);


      if AQuery.ContainsKey('busca') then
      begin
        busca := Trim(AQuery.Items['busca']);
        if busca <> '' then
        begin
          Add('  AND (gesempresas.nome LIKE ' + QuotedStr('%' + busca + '%') + ')');
          // Adicione mais campos aqui se quiser expandir a busca
        end;
      end;
      Add('GROUP BY gesordemcompra.idordemcompra ');
      Add('ORDER BY gesordemcompra.idordemcompra DESC');
    end;

    qry.Active := True;
    erro := '';
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar: ' + ex.Message;
      FreeAndNil(qry);
      Result := nil;
    end;
  end;
end;


function TOrdemCompra.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  a: string;
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
      SQL.Add('gesordemcompra.*, ');
      SQL.Add('gesempresas.nome as nomefornecedor, ');
      SQL.Add('gesempresas.fantasia as fantasiafornecedor, ');
      SQL.Add('gesusuario.nome as nomeusuario');
      SQL.Add('From ');
      SQL.Add('gesordemcompra left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = gesordemcompra.idfornecedor left Join  ');
      SQL.Add('gesusuario On gesusuario.idusuario = gesordemcompra.idusuario ');
      SQL.Add(' WHERE gesordemcompra.idordemcompra is not null ');
      if AQuery.ContainsKey('idordemcompra') then
      begin
        if Length(AQuery.Items['idordemcompra']) > 0 then
        begin
          SQL.Add('AND gesordemcompra.idordemcompra = :idordemcompra');
          ParamByName('idordemcompra').Value := AQuery.Items['idordemcompra'].ToInteger;
        end;
      end;
      a := AQuery.Items['idordemcompra'];

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesordemcompra.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
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

function TOrdemCompra.Listaitens(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('gesordemcompraitens.idordemcompraitens As id, ');
      SQL.Add('gesordemcompraitens.item, ');
      SQL.Add('gesproduto.descricao as produto, ');
      SQL.Add('gesproduto.codigosku, ');
      SQL.Add('gesordemcompraitens.quantidade, ');
      SQL.Add('gesproduto.unidade, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesordemcompraitens.preco, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as preco, ');
      SQL.Add('Concat(Replace(Replace(Replace(Format(gesordemcompraitens.ipi, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as ipi, ');
      SQL.Add('gesordemcompraitens.valorst, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesordemcompraitens.valortotal, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valortotal ');
      SQL.Add('From ');
      SQL.Add('gesordemcompraitens Inner Join ');
      SQL.Add('gesproduto On gesproduto.idproduto = gesordemcompraitens.idproduto ');
      SQL.Add('WHERE gesordemcompraitens.idordemcompraitens is not null and gesordemcompraitens.idordemcompra=:idordemcompra  and  gesordemcompraitens.deletado = 0 ');
      ParamByName('idordemcompra').Value := AQuery.Items['idordemcomprabusca'].ToInteger;
      a := AQuery.Items['idordemcomprabusca'].ToInteger;
      SQL.Add('order by gesordemcompraitens.item ');
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

function TOrdemCompra.Listaitensid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a,b : Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('gesordemcompraitens.idordemcompraitens, ');
      SQL.Add('gesordemcompraitens.item, ');
      SQL.Add('gesproduto.idproduto, ');
      SQL.Add('gesproduto.descricao as produto, ');
      SQL.Add('gesproduto.codigosku, ');
      SQL.Add('gesordemcompraitens.quantidade, ');
      SQL.Add('gesproduto.unidade, ');
      SQL.Add('gesordemcompraitens.preco, ');
      SQL.Add('gesordemcompraitens.ipi, ');
      SQL.Add('gesordemcompraitens.valorst, ');
      SQL.Add('gesordemcompraitens.valortotal ');
      SQL.Add('From ');
      SQL.Add('gesordemcompraitens left Join ');
      SQL.Add('gesproduto On gesproduto.idproduto = gesordemcompraitens.idproduto ');
      SQL.Add('WHERE gesordemcompraitens.idordemcompraitens is not null and gesordemcompraitens.idordemcompra=:idordemcompra and gesordemcompraitens.idordemcompraitens =:idordemcompraitens  ');
      ParamByName('idordemcompraitens').Value := AQuery.Items['idordemcompraitem'].ToInteger;
      ParamByName('idordemcompra').Value := AQuery.Items['idordemcompra'].ToInteger;
      a :=  AQuery.Items['idordemcompraitem'].ToInteger;
      b :=  AQuery.Items['idordemcompra'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesordemcompraitens.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesordemcompraitens .idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesordemcompraitens .idcliente = :idcliente');
          ParamByName('idcliente').Value := 0;
        end
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesordemcompraitens .idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesordemcompraitens .idloja = :idloja');
          ParamByName('idloja').Value := 0;
        end
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

function TOrdemCompra.Listaitenssoma(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Count(gesordemcompraitens.idordemcompraitens) As nitens, ');
      SQL.Add('Sum(gesordemcompraitens.quantidade) As totalquantidade, ');
      SQL.Add('Sum(gesordemcompraitens.valortotal) As totalvalorproduto, ');
      SQL.Add('Sum((gesordemcompraitens.ipi*0.01)*gesordemcompraitens.valortotal) As totalipi, ');
      SQL.Add('Sum(gesordemcompraitens.valorst) As totalicmsst ');
      SQL.Add('From ');
      SQL.Add('gesordemcompraitens ');
      SQL.Add('WHERE gesordemcompraitens.idordemcompraitens is not null and gesordemcompraitens.idordemcompra=:idordemcompra ');
      ParamByName('idordemcompra').Value := AQuery.Items['idordemcomprabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesordemcompraitens.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesordemcompraitens.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesordemcompraitens.idloja = :idloja');
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

function TOrdemCompra.mudarstatus(out erro: string): Boolean;
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
        sql.add('update gesordemcompra set situacao =:situacao where idcliente=:idcliente and idloja=:idloja and idordemcompra =:idordemcompra ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ParamByName('idordemcompra').AsInteger := idordemcompra;
        ParamByName('situacao').AsString := situacao;
        execsql;
      end;
      FConn.Commit;
      erro := '';
      Result := True;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao consultar : ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TOrdemCompra.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idordemcompra = idordemcompra+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').AsInteger := idcliente;
        ParamByName('idloja').AsInteger    := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idordemcompra from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').AsInteger := idcliente;
        ParamByName('idloja').AsInteger    := idloja;
        Open;
        idordemcompra := fieldbyname('idordemcompra').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idordemcompra;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao consultar : ' + ex.Message;
        Result := 0;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TOrdemCompra.NovoCadastroItens(out erro: string): integer;
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
        sql.add('update admponteiro set idordemcompraitens = idordemcompraitens+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idordemcompraitens from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idordemcompraitens := fieldbyname('idordemcompraitens').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idordemcompraitens;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao consultar : ' + ex.Message;
        Result := 0;
      end;
    end;
  finally
    qry.Free;
  end;
end;


 function TOrdemCompra.GetEmailsAviso(const ATipo: string): string;
 var
   Q: TFDQuery;
   LEmails: TStringList;
   EmailCampo: string;
   I: Integer;
   S: string;
 begin
   Result := '';
   Q := TFDQuery.Create(nil);
   LEmails := TStringList.Create;
   try
     Q.Connection := FConn;
     Q.SQL.Text :=
       'SELECT emailmaterial, emailfaturamento ' +
       'FROM gesemailconfiguracao ' +
       'WHERE tipo = :tipo';
     Q.ParamByName('tipo').AsString := ATipo;
     Q.Open;

     if SameText(ATipo, 'material') then
       EmailCampo := 'emailmaterial'
     else if SameText(ATipo, 'faturamento') then
       EmailCampo := 'emailfaturamento'
     else
       EmailCampo := '';

     if EmailCampo <> '' then
     begin
       while not Q.Eof do
       begin
         S := Trim(Q.FieldByName(EmailCampo).AsString);
         if S <> '' then
           LEmails.Add(S);
         Q.Next;
       end;
       // junta os e-mails com ';'
       for I := 0 to LEmails.Count - 1 do
       begin
         if I > 0 then
           Result := Result + ';';
         Result := Result + LEmails[I];
       end;
     end;
   finally
     Q.Free;
     LEmails.Free;
   end;
 end;


function TOrdemCompra.EditarItenssolicitacao(out erro: string): Boolean;
var
  qry: TFDQuery;
  id: Integer;
  dataSolicitacao: TDateTime;
  idUsuarioSolicitante: Integer;
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
        sql.add('update gessolicitacaoitens '+
                '   set status = :status, '+
                '       idordemcompra = :idoc '+
                ' where idsolicitacaoitens = :id ');
        ParamByName('status').AsString := 'EM PROCESSO';
        ParamByName('idoc').AsInteger  := idordemcompra;
        ParamByName('id').AsInteger    := idsolicitacaoitens;
        ExecSQL;

        Active := false;
        sql.Clear;
      with SQL do
        begin
          Clear;
          Add('SELECT ');
          Add('  i.idproduto, ');
          Add('  i.quantidade, ');
          Add('  s.idusuario, ');
          Add('  s.data ');
          Add('FROM gessolicitacaoitens i ');
          Add('LEFT JOIN gessolicitacao s ON s.idsolicitacao = i.idsolicitacao ');
          Add('WHERE i.idsolicitacaoitens = :id');
        end;
        ParamByName('id').AsInteger := idsolicitacaoitens;
        Open;
        if not IsEmpty then
        begin
          idproduto            := FieldByName('idproduto').AsInteger;
          quantidade           := FieldByName('quantidade').AsFloat;
          idUsuarioSolicitante := FieldByName('idusuario').AsInteger;
          dataSolicitacao      := FieldByName('data').AsDateTime;
        end;
        Active := false;
        sql.Clear;
        sql.add('select idordemcompraitens from gesordemcompraitens where idcliente=:idcliente and idloja=:idloja and idordemcompraitens=:idordemcompraitens ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ParamByName('idordemcompraitens').Value := idordemcompraitens;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO gesordemcompraitens(idordemcompraitens,idcliente,idloja,deletado,');
          SQL.Add('idordemcompra,item,idproduto,quantidade,preco,ipi,valorst,valortotal,idusuario,datasolicitacao,idUsuarioSolicitante)');
          SQL.Add('VALUES(:idordemcompraitens,:idcliente,:idloja,:deletado,');
          SQL.Add(':idordemcompra,:item,:idproduto,:quantidade,:preco,:ipi,:valorst,:valortotal,:idusuario,:datasolicitacao,:idUsuarioSolicitante)');
          ParamByName('deletado').AsInteger := 0;
          ParamByName('datasolicitacao').AsDateTime := dataSolicitacao;
          ParamByName('idUsuarioSolicitante').AsInteger := idUsuarioSolicitante;
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gesordemcompraitens set ');
          SQL.Add('item=:item, ');
          SQL.Add('idproduto=:idproduto, ');
          SQL.Add('idusuario=:idusuario, ');
          SQL.Add('quantidade=:quantidade, ');
          SQL.Add('preco=:preco, ');
          SQL.Add('ipi=:ipi, ');
          SQL.Add('valorst=:valorst, ');
          SQL.Add('valortotal=:valortotal ');
          SQL.Add('where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and ');
          SQL.Add('idordemcompraitens=:idordemcompraitens and idordemcompra=:idordemcompra ');
        end;
        ParamByName('idordemcompraitens').asinteger := idordemcompraitens;
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idusuario').asinteger := idusuario;
        ParamByName('idloja').AsInteger := idloja;
        ParamByName('idordemcompra').AsInteger := idordemcompra;
        ParamByName('item').AsInteger := item;
        ParamByName('idproduto').AsInteger := idproduto;
        ParamByName('quantidade').AsFloat := quantidade;
        ParamByName('preco').AsFloat := preco;
        ParamByName('ipi').AsFloat := ipi;
        ParamByName('valorst').AsFloat := valorst;
        ParamByName('valortotal').AsFloat := valortotal;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao cadastrar cliente: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TOrdemCompra.lancarestoque(out erro: string): boolean;
var
  regradenegocio: TRegraNegocios;
  qry: TFDQuery;
begin
  try
    regradenegocio := TRegraNegocios.Create;
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try

      with qry do
      begin

        Active := false;
        sql.Clear;
        SQL.Add('select lancarestoque from gesordemcompra where idordemcompra=:idordemcompra');
        ParamByName('idordemcompra').AsInteger := idordemcompra;
        Open();

        if FieldByName('lancarestoque').AsInteger = 0 then
        begin
          FConn.StartTransaction;
          Active := false;
          sql.Clear;
          SQL.Add('update gesordemcompra set lancarestoque = 1 where idordemcompra=:idordemcompra');
          ParamByName('idordemcompra').AsInteger := idordemcompra;
          ExecSQL;
          FConn.Commit;

          Active := false;
          sql.Clear;
          SQL.Add('Select * From gesordemcompraitens where idordemcompra=:idordemcompra');
          ParamByName('idordemcompra').AsInteger := idordemcompra;
          Open();
          while not Eof do
          begin
            regradenegocio.gerenciadorENTRADAeSAIDA(FieldByName('idproduto').AsInteger, 1, 1, idusuario, 1, (FieldByName('quantidade').asinteger + 0 + 0), 'Lancamento de produto de compra', FieldByName('preco').AsFloat);
            Next;
          end;
          erro := '';
          result := true;
        end
        else
        begin
          erro := 'Erro ao lançar estoque. Estoque já lançado';
          Result := false;
        end;
      end;

    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao lançar estoque: ' + ex.Message;
        Result := false;
      end;
    end;

  finally
    qry.Free;
  end;
end;

function TOrdemCompra.cancelarlancarestoque(out erro: string): boolean;
var
  regradenegocio: TRegraNegocios;
  qry: TFDQuery;
begin
  try
    regradenegocio := TRegraNegocios.Create;
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try

      with qry do
      begin

        Active := false;
        sql.Clear;
        SQL.Add('select lancarestoque from gesordemcompra where idordemcompra=:idordemcompra');
        ParamByName('idordemcompra').AsInteger := idordemcompra;
        Open();

        if FieldByName('lancarestoque').AsInteger = 1 then
        begin
          FConn.StartTransaction;
          Active := false;
          sql.Clear;
          SQL.Add('update gesordemcompra set lancarestoque = 0 where idordemcompra=:idordemcompra');
          ParamByName('idordemcompra').AsInteger := idordemcompra;
          ExecSQL;
          FConn.Commit;

          Active := false;
          sql.Clear;
          SQL.Add('Select * From gesordemcompraitens where idordemcompra=:idordemcompra');
          ParamByName('idordemcompra').AsInteger := idordemcompra;
          Open();
          while not Eof do
          begin
            regradenegocio.gerenciadorENTRADAeSAIDA(FieldByName('idproduto').AsInteger, 1, 1, idusuario, 2, FieldByName('quantidade').asfloat, 'Lancamento de produto de compra cancelado', FieldByName('preco').AsFloat);
            Next;
          end;
          erro := '';
          result := true;
        end
        else
        begin
          erro := 'Erro ao cancelar lançamento de estoque. Estoque ainda não foi lançado';
          Result := false;
        end;
      end;

    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao lançar estoque: ' + ex.Message;
        Result := false;
      end;
    end;

  finally
    qry.Free;
  end;
end;

function TOrdemCompra.EditarItens(out erro: string): Boolean;
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
        sql.add('select idordemcompraitens from gesordemcompraitens where idcliente=:idcliente and idloja=:idloja and idordemcompraitens=:idordemcompraitens ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ParamByName('idordemcompraitens').Value := idordemcompraitens;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO gesordemcompraitens(idordemcompraitens,idcliente,idloja,deletado, ');
          SQL.Add('idordemcompra,item,idproduto,quantidade,preco,ipi,valorst,valortotal,idusuario)');
          SQL.Add('               VALUES(:idordemcompraitens,:idcliente,:idloja,:deletado, ');
          SQL.Add(':idordemcompra,:item,:idproduto,:quantidade,:preco,:ipi,:valorst,:valortotal,:idusuario)');
          ParamByName('deletado').AsInteger := 0;
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gesordemcompraitens set ');
          SQL.Add('item=:item, ');
          SQL.Add('idproduto=:idproduto, ');
          SQL.Add('idusuario=:idusuario, ');
          SQL.Add('quantidade=:quantidade, ');
          SQL.Add('preco=:preco, ');
          SQL.Add('ipi=:ipi, ');
          SQL.Add('valorst=:valorst, ');
          SQL.Add('valortotal=:valortotal ');
          SQL.Add('where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and ');
          SQL.Add('idordemcompraitens=:idordemcompraitens and idordemcompra=:idordemcompra ');
        end;
        ParamByName('idordemcompraitens').asinteger := idordemcompraitens;
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idusuario').asinteger := idusuario;
        ParamByName('idloja').AsInteger := idloja;
        ParamByName('idordemcompra').AsInteger := idordemcompra;
        ParamByName('item').AsInteger := item;
        ParamByName('idproduto').AsInteger := idproduto;
        ParamByName('quantidade').AsFloat := quantidade;
        ParamByName('preco').AsFloat := preco;
        ParamByName('ipi').AsFloat := ipi;
        ParamByName('valorst').AsFloat := valorst;
        ParamByName('valortotal').AsFloat := valortotal;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao cadastrar cliente: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;


function TOrdemCompra.AprovacaoDaOrdemDeServico(out Erro: string): Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;
  Erro   := '';

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;

    FConn.StartTransaction;
    try
      with Qry do
      begin
        SQL.Clear;
        SQL.Add('UPDATE gesordemcompra SET');
        SQL.Add('  aprovadopor   = :aprovadopor,');
        SQL.Add('  iddoaprovador = :iddoaprovador,');
        SQL.Add('  statuscompraaprovada = :statuscompraaprovada,');
        SQL.Add('  dataaprovacao = :dataaprovacao');
        SQL.Add('WHERE idcliente      = :idcliente');
        SQL.Add('  AND idloja        = :idloja');
        SQL.Add('  AND idordemcompra = :idordemcompra');

        ParamByName('aprovadopor').AsString    := AprovadoPor;
        ParamByName('iddoaprovador').AsInteger := IdCliente;
        ParamByName('dataaprovacao').AsDateTime := Now;
        ParamByName('statuscompraaprovada').AsString := 'APROVADO';
        ParamByName('idcliente').AsInteger     := IdCliente;
        ParamByName('idloja').AsInteger        := IdLoja;
        ParamByName('idordemcompra').AsInteger := IdOrdemCompra;

        ExecSQL;
      end;

      FConn.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        FConn.Rollback;
        Erro := 'Erro ao aprovar ordem de serviço: ' + E.Message;
      end;
    end;
  finally
    Qry.Free;
  end;
end;

 function TOrdemCompra.Editar(out erro: string): Boolean;
 var
   Qry: TFDQuery;
   Destinatarios: string;
   Email: TEmail;
   SL: TStringList;
   I: Integer;
 begin
   Result := False;
   erro   := '';
   Qry    := TFDQuery.Create(nil);
   try
     Qry.Connection := FConn;
     FConn.StartTransaction;
     try
       // Verifica se a ordem já existe
       Qry.SQL.Text :=
         'select idordemcompra from gesordemcompra ' +
         'where idcliente = :idcliente and idloja = :idloja and idordemcompra = :idordemcompra';
       Qry.ParamByName('idcliente').AsInteger     := idcliente;
       Qry.ParamByName('idloja').AsInteger        := idloja;
       Qry.ParamByName('idordemcompra').AsInteger := idordemcompra;
       Qry.Open;
       Qry.Close;

       if Qry.IsEmpty then
       begin
         // Inserir novo registro
         Qry.SQL.Clear;
         Qry.SQL.Add('insert into gesordemcompra(' +
           'idordemcompra,idfornecedor,nitens,data,dataprevisto,idtransportadora,' +
           'observacoes,observacoesinterna,somaqtdes,totalprodutos,desconto,frete,totalipi,' +
           'totalicmsst,totalgeral,numerofornecedor,idtipofrete,idcliente,idloja,deletado) ' +
           'values(' +
           ':idordemcompra,:idfornecedor,:nitens,:data,:dataprevisto,:idtransportadora,' +
           ':observacoes,:observacoesinterna,:somaqtdes,:totalprodutos,:desconto,:frete,' +
           ':totalipi,:totalicmsst,:totalgeral,:numerofornecedor,:idtipofrete,:idcliente,' +
           ':idloja,0)');
       end
       else
       begin
         // Atualizar registro existente
         Qry.SQL.Clear;
         Qry.SQL.Add('update gesordemcompra set ' +
           'idfornecedor        = :idfornecedor,' +
           'nitens              = :nitens,' +
           'data                = :data,' +
           'dataprevisto        = :dataprevisto,' +
           'idtransportadora    = :idtransportadora,' +
           'observacoes         = :observacoes,' +
           'observacoesinterna  = :observacoesinterna,' +
           'somaqtdes           = :somaqtdes,' +
           'totalprodutos       = :totalprodutos,' +
           'desconto            = :desconto,' +
           'frete               = :frete,' +
           'totalipi            = :totalipi,' +
           'totalicmsst         = :totalicmsst,' +
           'totalgeral          = :totalgeral,' +
           'numerofornecedor    = :numerofornecedor,' +
           'idtipofrete         = :idtipofrete,' +
           'idusuario           = :idusuario ' +
           'where idcliente = :idcliente and idloja = :idloja and idordemcompra = :idordemcompra');
       end;

       // Define os parâmetros
       Qry.ParamByName('idordemcompra').AsInteger := idordemcompra;
       Qry.ParamByName('idfornecedor').AsInteger  := idfornecedor;
       Qry.ParamByName('nitens').AsInteger        := nitens;
       Qry.ParamByName('data').AsString           := datacompra;
       Qry.ParamByName('dataprevisto').AsString   := dataprevista;
       Qry.ParamByName('idtransportadora').AsInteger := idtransportadora;
       Qry.ParamByName('observacoes').AsString    := observacao;
       Qry.ParamByName('observacoesinterna').AsString := observacaointerna;
       Qry.ParamByName('somaqtdes').AsFloat       := somaqtdes;
       Qry.ParamByName('totalprodutos').AsFloat   := totalprodutos;
       Qry.ParamByName('desconto').AsFloat        := desconto;
       Qry.ParamByName('frete').AsFloat           := frete;
       Qry.ParamByName('totalipi').AsFloat        := totalipi;
       Qry.ParamByName('totalicmsst').AsFloat     := totalicmsst;
       Qry.ParamByName('totalgeral').AsFloat      := totalgeral;
       Qry.ParamByName('numerofornecedor').AsString := numerofornecedor;
       Qry.ParamByName('idtipofrete').AsInteger   := idtipofrete;
       Qry.ParamByName('idcliente').AsInteger     := idcliente;
       Qry.ParamByName('idloja').AsInteger        := idloja;
       Qry.ParamByName('idusuario').AsInteger     := idusuario;
       Qry.ExecSQL;

       // Commit da transação
       FConn.Commit;
       Result := True;

       // Enviar e‑mails
       Destinatarios := destinatarios;
       if Trim(Destinatarios) = '' then
         Destinatarios := GetEmailsAviso('material');  // padrão se não houver destinatários explícitos

       if Trim(Destinatarios) <> '' then
       begin
         SL := TStringList.Create;
         try
           SL.StrictDelimiter := True;
           SL.Delimiter       := ';';
           SL.DelimitedText   := Destinatarios;
           for I := 0 to SL.Count - 1 do
           begin
             Email := TEmail.Create;
             try
               Email.ExecuteOrdemServico(
                 idordemcompra,
                 Trim(SL[I]),
                 '',
                 'Nova ordem de serviço incluída'
               );
             finally
               Email.Free;
             end;
           end;
         finally
           SL.Free;
         end;
       end;
     except
       on E: Exception do
       begin
         FConn.Rollback;
         erro := 'Erro ao salvar ordem de compra: ' + E.Message;
         Result := False;
       end;
     end;
   finally
     Qry.Free;
   end;
 end;


end.

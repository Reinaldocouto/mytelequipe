unit Model.Recebimentocompra;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TRecebimentocompra = class
  private
    FConn: TFDConnection;
    Fidrecebimentocompra: Integer;
    Fidproduto: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
    Fsituacao: string;
    Fconfignome: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    property idrecebimentocompra: Integer read Fidrecebimentocompra write Fidrecebimentocompra;
    property idproduto: Integer read Fidproduto write Fidproduto;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property situacao: string read Fsituacao write Fsituacao;
    property confignome: integer read Fconfignome write Fconfignome;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listarecebimento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listarecebimentoitens(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Contagem(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Reiniciarcontagem(out erro: string): TFDQuery;
    function Reiniciarconferencia(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaconfiguracoescompra: Boolean;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaidqtd(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function salvar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;
    function ListaDivergencia(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;

  end;

implementation

{ TRecebimentocompra }

function TRecebimentocompra.Contagem(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: Integer;
  b: string;
  multiplicador: Integer;
begin

  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    FConn.StartTransaction;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('update gesrecebimentocompra set situacao=:situacao where idrecebimentocompra =:idrecebimentocompra ');
      ParamByName('situacao').asstring := 'EM CONFERENCIA';
      ParamByName('idrecebimentocompra').Asinteger := AQuery.Items['idrecebimentocomprabusca'].ToInteger;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompra.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesrecebimentocompra.idcliente = :idcliente');
          ParamByName('idcliente').Value := 0;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompra.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesrecebimentocompra.idloja = :idloja');
          ParamByName('idloja').Value := 0;
        end;
      end;
      ExecSQL;

      Active := false;
      SQL.Clear;
      SQL.Add('update gesrecebimentocompraitens set ');
      SQL.Add('quantidadechegada = quantidadechegada + :multiplicador ');
      SQL.Add('where codigobarras=:codigobarras and idrecebimentocompra =:idrecebimentocompra  ');
      ParamByName('codigobarras').AsString := trim(AQuery.Items['buscarcodigobarras']);
      ParamByName('idrecebimentocompra').Asinteger := AQuery.Items['idrecebimentocomprabusca'].ToInteger;
      b := AQuery.Items['buscarcodigobarras'];
      a := AQuery.Items['idrecebimentocomprabusca'].ToInteger;
      multiplicador := AQuery.Items['buscarmultiplicador'].ToInteger;
      ParamByName('multiplicador').Value := AQuery.Items['buscarmultiplicador'].ToInteger;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
          a := AQuery.Items['idcliente'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesrecebimentocompraitens.idcliente = :idcliente');
          ParamByName('idcliente').Value := 0;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
          a := AQuery.Items['idloja'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesrecebimentocompraitens.idloja = :idloja');
          ParamByName('idloja').Value := 0;
        end;
      end;
      ExecSQL;
      FConn.Commit;
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('gesrecebimentocompraitens.idrecebimentocompraitens as id, ');
      SQL.Add('gesproduto.descricao, ');
      SQL.Add('gesproduto.codigosku, ');
      SQL.Add('gesproduto.codigobarra, ');
      SQL.Add('gesrecebimentocompraitens.quantidade, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesrecebimentocompraitens.preco, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as preco, ');
      SQL.Add('gesrecebimentocompraitens.ipi, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesrecebimentocompraitens.valorst, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valorst, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesrecebimentocompraitens.valortotal, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valortotal, ');
      SQL.Add('gesrecebimentocompraitens.quantidadechegada, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesrecebimentocompraitens.valortotalchegada, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valortotalchegada, ');
      SQL.Add('gesrecebimentocompraitens.okqtd, ');
      SQL.Add('gesrecebimentocompraitens.okvt, ');
      SQL.Add('gesunidade.descricao As unidade  ');
      SQL.Add('From ');
      SQL.Add('gesrecebimentocompraitens Left Join ');
      SQL.Add('gesproduto On gesproduto.idproduto = gesrecebimentocompraitens.idproduto ');
      SQL.Add('And gesproduto.idcliente = gesrecebimentocompraitens.idcliente ');
      SQL.Add('And gesproduto.idloja = gesrecebimentocompraitens.idloja ');
      SQL.Add('And gesproduto.deletado = gesrecebimentocompraitens.deletado left Join ');
      SQL.Add('gesunidade On gesunidade.idunidade = gesproduto.idunidade ');
      SQL.Add('And gesunidade.deletado = gesproduto.deletado ');
      SQL.Add('And gesunidade.idcliente = gesproduto.idcliente ');
      SQL.Add('And gesunidade.idloja = gesproduto.idloja ');
      SQL.Add('WHERE gesrecebimentocompraitens.idrecebimentocompraitens is not null and gesrecebimentocompraitens.idrecebimentocompra =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idrecebimentocomprabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end;
      end;
      Active := true;
      erro := '';
      a := recordcount;
    end;
    Result := qry;
  except
    on ex: exception do
    begin
      FConn.Rollback;
      erro := 'Erro ao contar produto';
      Result := qry;
    end;
  end;

end;

constructor TRecebimentocompra.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TRecebimentocompra.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TRecebimentocompra.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idrecebimentocompra = idrecebimentocompra+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idrecebimentocompra from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idrecebimentocompra := fieldbyname('idrecebimentocompra').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idrecebimentocompra;
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

function TRecebimentocompra.Reiniciarconferencia(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('update gesrecebimentocompra set situacao=:situacao where idrecebimentocompra =:idrecebimentocompra ');
      ParamByName('situacao').asstring := 'AGUARDANDO ENTRADA';
      ParamByName('idrecebimentocompra').Asinteger := AQuery.Items['idrecebimentocomprabusca'].ToInteger;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompra.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesrecebimentocompra.idcliente = :idcliente');
          ParamByName('idcliente').Value := 0;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompra.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesrecebimentocompra.idloja = :idloja');
          ParamByName('idloja').Value := 0;
        end;
      end;
      ExecSQL;

      Active := false;
      SQL.Clear;
      SQL.Add('update gesrecebimentocompraitens set ');
      SQL.Add('quantidadechegada = 0 ');
      SQL.Add('where idrecebimentocompra =:idrecebimentocompra  ');
      ParamByName('idrecebimentocompra').Asinteger := AQuery.Items['idrecebimentocomprabusca'].ToInteger;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesrecebimentocompraitens.idcliente = :idcliente');
          ParamByName('idcliente').Value := 0;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesrecebimentocompraitens.idloja = :idloja');
          ParamByName('idloja').Value := 0;
        end;
      end;
      ExecSQL;
      FConn.Commit;
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('gesrecebimentocompraitens.idrecebimentocompraitens as id, ');
      SQL.Add('gesproduto.descricao, ');
      SQL.Add('gesproduto.codigosku, ');
      SQL.Add('gesproduto.codigobarra, ');
      SQL.Add('gesrecebimentocompraitens.quantidade, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesrecebimentocompraitens.preco, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as preco, ');
      SQL.Add('gesrecebimentocompraitens.ipi, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesrecebimentocompraitens.valorst, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valorst, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesrecebimentocompraitens.valortotal, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valortotal, ');
      SQL.Add('gesrecebimentocompraitens.quantidadechegada, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesrecebimentocompraitens.valortotalchegada, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valortotalchegada, ');
      SQL.Add('gesrecebimentocompraitens.okqtd, ');
      SQL.Add('gesrecebimentocompraitens.okvt, ');
      SQL.Add('gesunidade.descricao As unidade  ');
      SQL.Add('From ');
      SQL.Add('gesrecebimentocompraitens Left Join ');
      SQL.Add('gesproduto On gesproduto.idproduto = gesrecebimentocompraitens.idproduto ');
      SQL.Add('And gesproduto.idcliente = gesrecebimentocompraitens.idcliente ');
      SQL.Add('And gesproduto.idloja = gesrecebimentocompraitens.idloja ');
      SQL.Add('And gesproduto.deletado = gesrecebimentocompraitens.deletado left Join ');
      SQL.Add('gesunidade On gesunidade.idunidade = gesproduto.idunidade ');
      SQL.Add('And gesunidade.deletado = gesproduto.deletado ');
      SQL.Add('And gesunidade.idcliente = gesproduto.idcliente ');
      SQL.Add('And gesunidade.idloja = gesproduto.idloja ');
      SQL.Add('WHERE gesrecebimentocompraitens.idrecebimentocompraitens is not null and gesrecebimentocompraitens.idrecebimentocompra =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idrecebimentocomprabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end;
      end;
      Active := true;
      erro := '';
    end;
    Result := qry;
  except
    on ex: exception do
    begin
      FConn.Rollback;
      erro := 'Erro ao contar produto';
      Result := qry;
    end;
  end;

end;

function TRecebimentocompra.Reiniciarcontagem(out erro: string): TFDQuery;
var
  qry, qrystatus, qrypesquisa: TFDQuery;
  a: integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    FConn.StartTransaction;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('update gesrecebimentocompraitens set ');
      SQL.Add('quantidadechegada = 0 ');
      SQL.Add('where idrecebimentocompraitens=:idrecebimentocompraitens and idrecebimentocompra =:idrecebimentocompra and IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA  ');
      ParamByName('idrecebimentocompraitens').AsInteger := idproduto;
      ParamByName('idrecebimentocompra').Asinteger := idrecebimentocompra;
      ParamByName('idcliente').asinteger := idcliente;
      ParamByName('idloja').AsInteger := idloja;
      ExecSQL;
      FConn.Commit;
    end;

    qrypesquisa := TFDQuery.Create(nil);
    qrypesquisa.connection := FConn;
    qrystatus := TFDQuery.Create(nil);
    qrystatus.connection := FConn;
    with qrypesquisa do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('sum(gesrecebimentocompraitens.quantidade) as qtdtotal, ');
      SQL.Add('sum(gesrecebimentocompraitens.quantidadechegada) as qtdcontada ');
      SQL.Add('From ');
      SQL.Add('gesrecebimentocompraitens ');
      SQL.Add('WHERE gesrecebimentocompraitens.idrecebimentocompra is not null and gesrecebimentocompraitens.idrecebimentocompra=:id ');
      ParamByName('id').AsInteger := idrecebimentocompra;
      SQL.Add('AND gesrecebimentocompraitens.deletado = :deletado');
      ParamByName('deletado').Value := 0;
      SQL.Add('AND gesrecebimentocompraitens.idcliente = :idcliente');
      ParamByName('idcliente').Value := idcliente;
      SQL.Add('AND gesrecebimentocompraitens.idloja = :idloja');
      ParamByName('idloja').Value := idloja;
      Active := true;
      with qrystatus do
      begin
        FConn.StartTransaction;
        if qrypesquisa.FieldByName('qtdcontada').AsInteger = 0 then
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('update gesrecebimentocompra set situacao=:situacao where idrecebimentocompra =:idrecebimentocompra ');
          ParamByName('situacao').asstring := 'AGUARDANDO ENTRADA';
          ParamByName('idrecebimentocompra').Asinteger := idrecebimentocompra;
          SQL.Add('AND gesrecebimentocompra.idcliente = :idcliente');
          ParamByName('idcliente').Value := idcliente;
          SQL.Add('AND gesrecebimentocompra.idloja = :idloja');
          ParamByName('idloja').Value := idloja;
          ExecSQL;
        end;
        FConn.Commit;
      end;
    end;
    Result := qry;
  except
    on ex: exception do
    begin
      FConn.Rollback;
      erro := 'Erro ao contar produto';
      Result := qry;
    end;
  end;

end;

function TRecebimentocompra.salvar(out erro: string): Boolean;
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
        SQL.Clear;
        SQL.Add('update gesrecebimentocompraitens set okqtd = quantidade-quantidadechegada ');
        SQL.Add('where idrecebimentocompra=:idrecebimentocompra and idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idrecebimentocompra').Asinteger := idrecebimentocompra;
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ExecSQL;
        Active := false;
        SQL.Clear;
        SQL.Add('Select ');
        SQL.Add('sum(gesrecebimentocompraitens.okqtd) as okqtd ');
        SQL.Add('From ');
        SQL.Add('gesrecebimentocompraitens ');
        SQL.Add('where idrecebimentocompra=:idrecebimentocompra and idcliente=:idcliente and idloja=:idloja ');
        SQL.Add('Group By ');
        SQL.Add('gesrecebimentocompraitens.okqtd ');
        ParamByName('idrecebimentocompra').Asinteger := idrecebimentocompra;
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open();
        if ((RecordCount = 1) and (fieldbyname('okqtd').asinteger = 0)) then
          situacao := 'CONFERIDO'
        else
          situacao := 'DIVERGENTE';
        Active := false;
        SQL.Clear;
        SQL.Add('update gesrecebimentocompra set situacao=:situacao where idrecebimentocompra =:idrecebimentocompra and IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA  ');
        ParamByName('idrecebimentocompra').Asinteger := idrecebimentocompra;
        ParamByName('situacao').AsString := situacao;
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ExecSQL;
        FConn.Commit;
      end;
      FConn.Commit;
      erro := '';
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao Salvar Recebimento: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TRecebimentocompra.Editar(out erro: string): Boolean;
var
  qry: TFDQuery;
begin

end;

function TRecebimentocompra.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  if AQuery.ContainsKey('idcliente') then
  begin
    if Length(AQuery.Items['idcliente']) > 0 then
    begin
      idcliente := AQuery.Items['idcliente'].ToInteger;
    end;
  end
  else
  begin
    idcliente := 0;
  end;
  if AQuery.ContainsKey('idloja') then
  begin
    if Length(AQuery.Items['idloja']) > 0 then
    begin
      idloja := AQuery.Items['idloja'].ToInteger;
    end;
  end
  else
  begin
    idloja := 0;
  end;

  if Listaconfiguracoescompra then
  begin
    try
      qry := TFDQuery.Create(nil);
      qry.connection := FConn;
      with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('Select  ');
        SQL.Add('gesrecebimentocompra.idrecebimentocompra as id,  ');
        SQL.Add('gesrecebimentocompra.idordemcompra,  ');
        SQL.Add('gesrecebimentocompra.situacao,  ');
        SQL.Add('gesrecebimentocompra.ordemcompra,  ');
        SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesrecebimentocompra.valortotal, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valortotal, ');
        //SQL.Add('gesrecebimentocompra.datacompra, ');
        SQL.Add('DATE_FORMAT(gesrecebimentocompra.datacompra,''%m/%d/%Y'') as datacompra, ');
        SQL.Add('DATE_FORMAT(gesrecebimentocompra.previsaochegada,''%d/%m/%Y'') as previsaochegada, ');
        case confignome of
          1:
            SQL.Add('gespessoa.nome as fornecedor,  ');
          2:
            SQL.Add('gespessoa.fantasia as fornecedor,  ');
          0:
            SQL.Add('''Falta configuração das opções de compra'' as fornecedor,  ');
        end;
        SQL.Add('gesrecebimentocompra.itens  ');
        SQL.Add('From  ');
        SQL.Add('gesrecebimentocompra left Join  ');
        SQL.Add('gespessoa On gespessoa.idpessoa = gesrecebimentocompra.idfornecedor  ');
        SQL.Add('And gespessoa.idcliente = gesrecebimentocompra.idcliente  ');
        SQL.Add('And gespessoa.idloja = gesrecebimentocompra.idloja WHERE gesrecebimentocompra.idrecebimentocompra is not null ');
        //pesquisar
        if AQuery.ContainsKey('busca') then
        begin
          if Length(AQuery.Items['busca']) > 0 then
          begin
            SQL.Add('AND(gespessoa.nome like ''%' + AQuery.Items['busca'] + '%'') ');
          end;
        end;

        if AQuery.ContainsKey('deletado') then
        begin
          if Length(AQuery.Items['deletado']) > 0 then
          begin
            SQL.Add('AND gesrecebimentocompra.deletado = :deletado');
            ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
          end;
        end;
        if AQuery.ContainsKey('idcliente') then
        begin
          if Length(AQuery.Items['idcliente']) > 0 then
          begin
            SQL.Add('AND gesrecebimentocompra.idcliente = :idcliente');
            ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
          end;
        end
        else
        begin
          SQL.Add('AND gesrecebimentocompra.idcliente = :idcliente');
          ParamByName('idcliente').Value := 0;
        end;
        if AQuery.ContainsKey('idloja') then
        begin
          if Length(AQuery.Items['idloja']) > 0 then
          begin
            SQL.Add('AND gesrecebimentocompra.idloja = :idloja');
            ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
          end;
        end
        else
        begin
          SQL.Add('AND gesrecebimentocompra.idloja = :idloja');
          ParamByName('idloja').Value := 0;
        end;
          SQL.Add(' order by gesrecebimentocompra.datacompra desc ');
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
  end
  else
  begin
    erro := 'Erro ao recebimento de compra, Falta de configuração do suprimentos / compra : ';
    Result := nil;
  end;
end;

function TRecebimentocompra.Listaconfiguracoescompra: Boolean;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    confignome := 0;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select * From gesconfigordemcompra ');
      SQL.Add(' WHERE gesconfigordemcompra.idgeral is not null ');
      SQL.Add('AND gesconfigordemcompra.idcliente = :idcliente');
      ParamByName('idcliente').Value := idcliente;
      SQL.Add('AND gesconfigordemcompra.idloja = :idloja');
      ParamByName('idloja').Value := idloja;
      Active := true;
      confignome := fieldbyname('fornecedor').asinteger;
    end;
    Result := true;
  except
    on ex: exception do
    begin
      Result := false;
    end;
  end;
end;

function TRecebimentocompra.ListaDivergencia(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    confignome := 0;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('gesproduto.descricao As produto, ');
      SQL.Add('if (gesrecebimentocompraitens.okqtd > 0, CONCAT(''Divergencia na quantidade falta '', gesrecebimentocompraitens.okqtd, '' itens na contagem''),CONCAT(''Divergencia na quantidade '', gesrecebimentocompraitens.okqtd*-1, ''  excedido na contagem'')) as  erro, ');
      SQL.Add('gesrecebimentocompraitens.okqtd, ');
      SQL.Add('gesrecebimentocompraitens.okvt, ');
      SQL.Add('gesrecebimentocompraitens.codigobarras, ');
      SQL.Add('gesrecebimentocompraitens.idproduto as id ');
      SQL.Add('From ');
      SQL.Add('gesrecebimentocompraitens Inner Join ');
      SQL.Add('gesrecebimentocompra On gesrecebimentocompra.idrecebimentocompra = gesrecebimentocompraitens.idrecebimentocompra ');
      SQL.Add('Inner Join ');
      SQL.Add('gesproduto On gesproduto.idproduto = gesrecebimentocompraitens.idproduto ');
      SQL.Add('Where ');
      SQL.Add('okqtd <> 0 and gesrecebimentocompra.idrecebimentocompra=:id ');
      ParamByName('id').AsInteger := AQuery.Items['idrecebimentocomprabusca'].ToInteger;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompra.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end
      else
      begin
        SQL.Add('AND gesrecebimentocompra.idcliente = :idcliente');
        ParamByName('idcliente').Value := 0;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompra.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end;
      end
      else
      begin
        SQL.Add('AND gesrecebimentocompra.idloja = :idloja');
        ParamByName('idloja').Value := 0;
      end;
      Active := true;
    end;
    Result := qry;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TRecebimentocompra.Listaidqtd(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry, qrystatus: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    qrystatus := TFDQuery.Create(nil);
    qrystatus.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('sum(gesrecebimentocompraitens.quantidade) as qtdtotal, ');
      SQL.Add('sum(gesrecebimentocompraitens.quantidadechegada) as qtdcontada ');
      SQL.Add('From ');
      SQL.Add('gesrecebimentocompraitens ');
      SQL.Add('WHERE gesrecebimentocompraitens.idrecebimentocompra is not null and gesrecebimentocompraitens.idrecebimentocompra=:id ');
      ParamByName('id').AsInteger := AQuery.Items['idrecebimentocomprabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesrecebimentocompraitens.idcliente = :idcliente');
          ParamByName('idcliente').Value := 0;
        end
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesrecebimentocompraitens.idloja = :idloja');
          ParamByName('idloja').Value := 0;
        end;
      end;
      Active := true;
     { with qrystatus do
      begin
        FConn.StartTransaction;
        if qry.FieldByName('qtdcontada').AsInteger = 0 then
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('update gesrecebimentocompra set situacao=:situacao where idrecebimentocompra =:idrecebimentocompra ');
          ParamByName('situacao').asstring := 'AGUARDANDO ENTRADA';
          ParamByName('idrecebimentocompra').Asinteger := AQuery.Items['idrecebimentocomprabusca'].ToInteger;
          if AQuery.ContainsKey('idcliente') then
          begin
            if Length(AQuery.Items['idcliente']) > 0 then
            begin
              SQL.Add('AND gesrecebimentocompra.idcliente = :idcliente');
              ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
            end
            else
            begin
              SQL.Add('AND gesrecebimentocompra.idcliente = :idcliente');
              ParamByName('idcliente').Value := 0;
            end;
          end;
          if AQuery.ContainsKey('idloja') then
          begin
            if Length(AQuery.Items['idloja']) > 0 then
            begin
              SQL.Add('AND gesrecebimentocompra.idloja = :idloja');
              ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
            end
            else
            begin
              SQL.Add('AND gesrecebimentocompra.idloja = :idloja');
              ParamByName('idloja').Value := 0;
            end;
          end;
          ExecSQL;
        end;
        FConn.Commit;
      end;  }

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

function TRecebimentocompra.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('gesrecebimentocompra.ordemcompra, ');
      SQL.Add('gesrecebimentocompra.nf, ');
      SQL.Add('gespessoa.nome, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesrecebimentocompra.valortotal, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valortotal, ');
      SQL.Add('gesrecebimentocompra.itens, ');
      SQL.Add('DATE_FORMAT(gesrecebimentocompra.datacompra,''%d/%m/%Y'') as datacompra ');
      SQL.Add('From ');
      SQL.Add('gesrecebimentocompra left Join ');
      SQL.Add('gespessoa On gespessoa.idpessoa = gesrecebimentocompra.idfornecedor ');
      SQL.Add('And gespessoa.idcliente = gesrecebimentocompra.idcliente ');
      SQL.Add('And gespessoa.idloja = gesrecebimentocompra.idloja ');
      SQL.Add('WHERE gesrecebimentocompra.idrecebimentocompra is not null and gesrecebimentocompra.idrecebimentocompra=:id ');
      ParamByName('id').AsInteger := AQuery.Items['idrecebimentocomprabusca'].ToInteger;
      a := AQuery.Items['idrecebimentocomprabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompra.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompra.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesrecebimentocompra.idcliente = :idcliente');
          ParamByName('idcliente').Value := 0;
        end
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompra.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gesrecebimentocompra.idloja = :idloja');
          ParamByName('idloja').Value := 0;
        end;
      end;
      Active := true;
      a := RecordCount;
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

function TRecebimentocompra.Listarecebimento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gespessoa.nome, ');
      SQL.Add('gespessoa.fantasia, ');
      SQL.Add('gesrecebimentocompra.ordemcompra, ');
      SQL.Add('gesrecebimentocompra.nf, ');
      SQL.Add('gesrecebimentocompra.datacompra, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesrecebimentocompra.valortotal, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valortotal ');
      SQL.Add('From ');
      SQL.Add('gesrecebimentocompra left Join ');
      SQL.Add('gespessoa On gespessoa.idpessoa = gesrecebimentocompra.idfornecedor ');
      SQL.Add('And gespessoa.idcliente = gesrecebimentocompra.idcliente ');
      SQL.Add('And gespessoa.idloja = gesrecebimentocompra.idloja ');
      SQL.Add('And gespessoa.deletado = gesrecebimentocompra.deletado ');
      SQL.Add('WHERE gesrecebimentocompra.idrecebimentocompra is not null and gesrecebimentocompra.idrecebimentocompra =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idrecebimentocomprabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompra.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompra.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompra.idloja = :idloja');
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

function TRecebimentocompra.Listarecebimentoitens(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesrecebimentocompraitens.idrecebimentocompraitens as id, ');
      SQL.Add('gesproduto.descricao, ');
      SQL.Add('gesproduto.codigosku, ');
      SQL.Add('gesproduto.codigobarra, ');
      SQL.Add('gesrecebimentocompraitens.quantidade, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesrecebimentocompraitens.preco, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as preco, ');
      SQL.Add('gesrecebimentocompraitens.ipi, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesrecebimentocompraitens.valorst, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valorst, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesrecebimentocompraitens.valortotal, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valortotal, ');
      SQL.Add('gesrecebimentocompraitens.quantidadechegada, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gesrecebimentocompraitens.valortotalchegada, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valortotalchegada, ');
      SQL.Add('gesrecebimentocompraitens.okqtd, ');
      SQL.Add('gesrecebimentocompraitens.okvt, ');
      SQL.Add('gesunidade.descricao As unidade ');
      SQL.Add('From ');
      SQL.Add('gesrecebimentocompraitens Left Join ');
      SQL.Add('gesproduto On gesproduto.idproduto = gesrecebimentocompraitens.idproduto ');
      SQL.Add('And gesproduto.idcliente = gesrecebimentocompraitens.idcliente ');
      SQL.Add('And gesproduto.idloja = gesrecebimentocompraitens.idloja ');
      SQL.Add('And gesproduto.deletado = gesrecebimentocompraitens.deletado left Join ');
      SQL.Add('gesunidade On gesunidade.idunidade = gesproduto.idunidade ');
      SQL.Add('And gesunidade.deletado = gesproduto.deletado ');
      SQL.Add('And gesunidade.idcliente = gesproduto.idcliente ');
      SQL.Add('And gesunidade.idloja = gesproduto.idloja ');
      SQL.Add('WHERE gesrecebimentocompraitens.idrecebimentocompraitens is not null and gesrecebimentocompraitens.idrecebimentocompra =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idrecebimentocomprabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesrecebimentocompraitens.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end;
      end;
      Active := true;
      a := recordcount;
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


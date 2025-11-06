unit Model.PedidoVenda;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TPedidoVenda = class
  private
    FConn: TFDConnection;
    Fidpedidovenda: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
    Fidclienteped: Integer;
    Fdataenvio: string;
    Fdataprevista: string;
    Fdatavenda: string;
    Fdesconto: Real;
    Fdescricao: string;
    Fdespesas: Real;
    Fenviarexpedicao: string;
    Fformaenvio: string;
    Ffretecliente: Real;
    Ficms: Integer;
    Fintermediador: Integer;
    Fipi: Integer;
    Flistapreco: string;
    Fmarcadores: string;
    Fnaturezaoperacao: string;
    Fnumero: Integer;
    Fnumeroitem: Integer;
    Fnumeropedido: Integer;
    Fobservacoes: string;
    Fobservacoesinternas: string;
    Fpagamento: string;
    Fpesobruto: Real;
    Fpesoliquido: Real;
    Fprecounico: Real;
    Fqtd: Integer;
    Fsomaquantidade: Integer;
    Ftotalproduto: Real;
    Ftotalvenda: Real;
    Fidentificador: Integer;
    Fnumeropedidovenda: Integer;
    Frecebimento: string;
    Fcondicaopagamento: string;
    Fcategoria: string;
    Fformafrete: string;
    Fcodigorastreamento: Integer;
    Furlrastreamento: string;
    Fnome: string;
    Ffreteconta: Real;
    Fanexos: string;

  public
    constructor Create;
    destructor Destroy; override;

    property idpedidovenda: Integer read Fidpedidovenda write Fidpedidovenda;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property idclienteped: Integer read Fidclienteped write Fidclienteped;
    property dataenvio: string read Fdataenvio write Fdataenvio;
    property dataprevista: string read Fdataprevista write Fdataprevista;
    property datavenda: string read Fdatavenda write Fdatavenda;
    property desconto: Real read Fdesconto write Fdesconto;
    property descricao: string read Fdescricao write Fdescricao;
    property despesas: Real read Fdespesas write Fdespesas;
    property enviarexpedicao: string read Fenviarexpedicao write Fenviarexpedicao;
    property formaenvio: string read Fformaenvio write Fformaenvio;
    property fretecliente: Real read Ffretecliente write Ffretecliente;
    property icms: Integer read Ficms write Ficms;
    property intermediador: Integer read Fintermediador write Fintermediador;
    property ipi: Integer read Fipi write Fipi;
    property listapreco: string read Flistapreco write Flistapreco;
    property marcadores: string read Fmarcadores write Fmarcadores;
    property naturezaoperacao: string read Fnaturezaoperacao write Fnaturezaoperacao;
    property numero: Integer read Fnumero write Fnumero;
    property numeroitem: Integer read Fnumeroitem write Fnumeroitem;
    property numeropedido: Integer read Fnumeropedido write Fnumeropedido;
    property observacoes: string read Fobservacoes write Fobservacoes;
    property observacoesinternas: string read Fobservacoesinternas write Fobservacoesinternas;
    property pagamento: string read Fpagamento write Fpagamento;
    property pesobruto: Real read Fpesobruto write Fpesobruto;
    property pesoliquido: Real read Fpesoliquido write Fpesoliquido;
    property precounico: Real read Fprecounico write Fprecounico;
    property qtd: Integer read Fqtd write Fqtd;
    property somaquantidade: Integer read Fsomaquantidade write Fsomaquantidade;
    property totalproduto: Real read Ftotalproduto write Ftotalproduto;
    property totalvenda: Real read Ftotalvenda write Ftotalvenda;
    property identificador: Integer read Fidentificador write Fidentificador;
    property numeropedidovenda: Integer read Fnumeropedidovenda write Fnumeropedidovenda;
    property recebimento: string read Frecebimento write Frecebimento;
    property condicaopagamento: string read Fcondicaopagamento write Fcondicaopagamento;
    property categoria: string read Fcategoria write Fcategoria;
    property formafrete: string read Fformafrete write Fformafrete;
    property codigorastreamento: Integer read Fcodigorastreamento write Fcodigorastreamento;
    property urlrastreamento: string read Furlrastreamento write Furlrastreamento;
    property nome: string read Fnome write Fnome;
    property freteconta: Real read Ffreteconta write Ffreteconta;
    property anexos: string read Fanexos write Fanexos;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Inserir(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;

  end;

implementation

{ TPedidovenda }

constructor TPedidoVenda.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TPedidoVenda.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TPedidoVenda.Inserir(out erro: string): Boolean;
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
        SQL.Add('INSERT INTO gespedidovenda(idpedidovenda,idclienteped,dataenvio,dataprevista,datavenda,desconto,descricao,despesas,enviarexpedicao,');
        SQL.Add('formaenvio,fretecliente,icms,intermediador,ipi,listapreco,marcadores,naturezaoperacao,numero,numeroitem,numeropedido,');
        SQL.Add('observacoes,observacoesinternas,pagamento,pesobruto,pesoliquido,precounico,qtd,somaquantidade,totalproduto,totalvenda,');
        SQL.Add('identificador,numeropedidovenda,recebimento,condicaopagamento,categoria,formafrete,codigorastreamento,urlrastreamento,nome,');
        SQL.Add('freteconta,anexos,IDCLIENTE,IDLOJA,DELETADO)');
        SQL.Add('               VALUES(:idpedidovenda,:idclienteped,:dataenvio,:dataprevista,:datavenda,:desconto,:descricao,:despesas,:enviarexpedicao,');
        SQL.Add(':formaenvio,:fretecliente,:icms,:intermediador,:ipi,:listapreco,:marcadores,:naturezaoperacao,:numero,:numeroitem,:numeropedido,');
        SQL.Add(':observacoes,:observacoesinternas,:pagamento,:pesobruto,:pesoliquido,:precounico,:qtd,:somaquantidade,:totalproduto,:totalvenda,');
        SQL.Add(':identificador,:numeropedidovenda,:recebimento,:condicaopagamento,:categoria,:formafrete,:codigorastreamento,:urlrastreamento,:nome,');
        SQL.Add(':freteconta,:anexos,:IDCLIENTE,:IDLOJA,:DELETADO)');

        ParamByName('idpedidovenda').AsInteger := id;
        ParamByName('idclienteped').AsInteger := idclienteped;
        ParamByName('dataenvio').Value := dataenvio;
        ParamByName('dataprevista').Value := dataprevista;
        ParamByName('datavenda').Value := datavenda;
        ParamByName('desconto').Value := desconto;
        ParamByName('descricao').Value := descricao;
        ParamByName('despesas').Value := despesas;
        ParamByName('enviarexpedicao').Value := enviarexpedicao;
        ParamByName('formaenvio').Value := formaenvio;
        ParamByName('fretecliente').Value := fretecliente;
        ParamByName('icms').Value := icms;
        ParamByName('intermediador').Value := intermediador;
        ParamByName('ipi').Value := ipi;
        ParamByName('listapreco').Value := listapreco;
        ParamByName('marcadores').Value := marcadores;
        ParamByName('naturezaoperacao').Value := naturezaoperacao;
        ParamByName('numero').Value := numero;
        ParamByName('numeroitem').Value := numeroitem;
        ParamByName('numeropedido').Value := numeropedido;
        ParamByName('observacoes').Value := observacoes;
        ParamByName('observacoesinternas').Value := observacoesinternas;
        ParamByName('pagamento').Value := pagamento;
        ParamByName('pesobruto').Value := pesobruto;
        ParamByName('pesoliquido').Value := pesoliquido;
        ParamByName('precounico').Value := precounico;
        ParamByName('qtd').Value := qtd;
        ParamByName('somaquantidade').Value := somaquantidade;
        ParamByName('totalproduto').Value := totalproduto;
        ParamByName('totalvenda').Value := totalvenda;
        ParamByName('identificador').Value := identificador;
        ParamByName('numeropedidovenda').Value := numeropedidovenda;
        ParamByName('recebimento').Value := recebimento;
        ParamByName('condicaopagamento').Value := condicaopagamento;
        ParamByName('categoria').Value := categoria;
        ParamByName('formafrete').Value := formafrete;
        ParamByName('codigorastreamento').Value := codigorastreamento;
        ParamByName('urlrastreamento').Value := urlrastreamento;
        ParamByName('nome').Value := nome;
        ParamByName('freteconta').Value := freteconta;
        ParamByName('anexos').Value := anexos;

        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 0;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar pedido de venda: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TPedidoVenda.Editar(out erro: string): Boolean;
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

        sql.add('select idpedidovenda from gespedidovenda where idcliente=:idcliente and idloja=:idloja and idpedidovenda=:idpedidovenda ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ParamByName('idpedidovenda').Value := idpedidovenda;
        Open;

        //id := fieldbyname('idpedidovenda').AsInteger;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO gespedidovenda(idpedidovenda,idclienteped,dataenvio,dataprevista,datavenda,desconto,descricao,despesas,enviarexpedicao,');
          SQL.Add('formaenvio,fretecliente,icms,intermediador,ipi,listapreco,marcadores,naturezaoperacao,numero,numeroitem,numeropedido,');
          SQL.Add('observacoes,observacoesinternas,pagamento,pesobruto,pesoliquido,precounico,qtd,somaquantidade,totalproduto,totalvenda,');
          SQL.Add('identificador,numeropedidovenda,recebimento,condicaopagamento,categoria,formafrete,codigorastreamento,urlrastreamento,nome,');
          SQL.Add('freteconta,anexos,IDCLIENTE,IDLOJA,DELETADO)');
          SQL.Add('               VALUES(:idpedidovenda,:idclienteped,:dataenvio,:dataprevista,:datavenda,:desconto,:descricao,:despesas,:enviarexpedicao,');
          SQL.Add(':formaenvio,:fretecliente,:icms,:intermediador,:ipi,:listapreco,:marcadores,:naturezaoperacao,:numero,:numeroitem,:numeropedido,');
          SQL.Add(':observacoes,:observacoesinternas,:pagamento,:pesobruto,:pesoliquido,:precounico,:qtd,:somaquantidade,:totalproduto,:totalvenda,');
          SQL.Add(':identificador,:numeropedidovenda,:recebimento,:condicaopagamento,:categoria,:formafrete,:codigorastreamento,:urlrastreamento,:nome,');
          SQL.Add(':freteconta,:anexos,:IDCLIENTE,:IDLOJA,:DELETADO)');
          //ParamByName('deletado').AsInteger := 0;
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gespedidovenda set idpedidovenda=:idpedidovenda, ');
          SQL.Add('idclienteped=:idclienteped, ');
          SQL.Add('dataenvio=:dataenvio, ');
          SQL.Add('dataprevista=:dataprevista, ');
          SQL.Add('datavenda=:datavenda, ');
          SQL.Add('desconto=:desconto, ');
          SQL.Add('descricao=:descricao, ');
          SQL.Add('despesas=:despesas, ');
          SQL.Add('enviarexpedicao=:enviarexpedicao, ');
          SQL.Add('formaenvio=:formaenvio, ');
          SQL.Add('fretecliente=:fretecliente, ');
          SQL.Add('icms=:icms, ');
          SQL.Add('intermediador=:intermediador, ');
          SQL.Add('ipi=:ipi, ');
          SQL.Add('listapreco=:listapreco, ');
          SQL.Add('marcadores=:marcadores, ');
          SQL.Add('naturezaoperacao=:naturezaoperacao, ');
          SQL.Add('numero=:numero, ');
          SQL.Add('numeroitem=:numeroitem, ');
          SQL.Add('numeropedido=:numeropedido, ');
          SQL.Add('observacoes=:observacoes, ');
          SQL.Add('observacoesinternas=:observacoesinternas, ');
          SQL.Add('pagamento=:pagamento, ');
          SQL.Add('pesobruto=:pesobruto, ');
          SQL.Add('pesoliquido=:pesoliquido, ');
          SQL.Add('precounico=:precounico, ');
          SQL.Add('qtd=:qtd, ');
          SQL.Add('somaquantidade=:somaquantidade, ');
          SQL.Add('totalproduto=:totalproduto, ');
          SQL.Add('totalvenda=:totalvenda, ');
          SQL.Add('identificador=:identificador, ');
          SQL.Add('numeropedidovenda=:numeropedidovenda, ');
          SQL.Add('recebimento=:recebimento, ');
          SQL.Add('condicaopagamento=:condicaopagamento, ');
          SQL.Add('categoria=:categoria, ');
          SQL.Add('formafrete=:formafrete, ');
          SQL.Add('codigorastreamento=:codigorastreamento, ');
          SQL.Add('urlrastreamento=:urlrastreamento, ');
          SQL.Add('nome=:nome, ');
          SQL.Add('freteconta=:freteconta, ');
          SQL.Add('anexos=:anexos, ');
          SQL.Add('DELETADO=:DELETADO');
          SQL.Add('where IDCLIENTE=:IDCLIENTE and IDLOJA=:IDLOJA and IDPEDIDOVENDA=:IDPEDIDOVENDA');
        end;
        ParamByName('idpedidovenda').AsInteger := idpedidovenda;
        ParamByName('idclienteped').AsInteger := idclienteped;
        ParamByName('dataenvio').Value := dataenvio;
        ParamByName('dataprevista').Value := dataprevista;
        ParamByName('datavenda').Value := datavenda;
        ParamByName('desconto').Value := desconto;
        ParamByName('descricao').Value := descricao;
        ParamByName('despesas').Value := despesas;
        ParamByName('enviarexpedicao').Value := enviarexpedicao;
        ParamByName('formaenvio').Value := formaenvio;
        ParamByName('fretecliente').Value := fretecliente;
        ParamByName('icms').Value := icms;
        ParamByName('intermediador').Value := intermediador;
        ParamByName('ipi').Value := ipi;
        ParamByName('listapreco').Value := listapreco;
        ParamByName('marcadores').Value := marcadores;
        ParamByName('naturezaoperacao').Value := naturezaoperacao;
        ParamByName('numero').Value := numero;
        ParamByName('numeroitem').Value := numeroitem;
        ParamByName('numeropedido').Value := numeropedido;
        ParamByName('observacoes').Value := observacoes;
        ParamByName('observacoesinternas').Value := observacoesinternas;
        ParamByName('pagamento').Value := pagamento;
        ParamByName('pesobruto').Value := pesobruto;
        ParamByName('pesoliquido').Value := pesoliquido;
        ParamByName('precounico').Value := precounico;
        ParamByName('qtd').Value := qtd;
        ParamByName('somaquantidade').Value := somaquantidade;
        ParamByName('totalproduto').Value := totalproduto;
        ParamByName('totalvenda').Value := totalvenda;
        ParamByName('identificador').Value := identificador;
        ParamByName('numeropedidovenda').Value := numeropedidovenda;
        ParamByName('recebimento').Value := recebimento;
        ParamByName('condicaopagamento').Value := condicaopagamento;
        ParamByName('categoria').Value := categoria;
        ParamByName('formafrete').Value := formafrete;
        ParamByName('codigorastreamento').Value := codigorastreamento;
        ParamByName('urlrastreamento').Value := urlrastreamento;
        ParamByName('nome').Value := nome;
        ParamByName('freteconta').Value := freteconta;
        ParamByName('anexos').Value := anexos;
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 0;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao cadastrar pedido de venda: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TPedidoVenda.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gespedidovenda.idpedidovenda as id, ');
      SQL.Add('gespedidovenda.idclienteped as idclienteped, ');
      SQL.Add('DATE_FORMAT(gespedidovenda.dataenvio,''%d/%m/%Y'') as dataenvio, ');
      SQL.Add('DATE_FORMAT(gespedidovenda.dataprevista,''%d/%m/%Y'') as dataprevista, ');
      SQL.Add('gespessoa.nome, ');
      SQL.Add('gespessoa.fantasia, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gespedidovenda.totalvenda, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as totalvenda, ');
      SQL.Add('gespedidovenda.urlrastreamento, ');
      SQL.Add('gespedidovenda.marcadores ');
      SQL.Add('From ');
      SQL.Add('gespedidovenda Left Join ');
      SQL.Add('gespessoa On gespessoa.idpessoa = gespedidovenda.idclienteped ');
      SQL.Add('And gespessoa.idcliente = gespedidovenda.idcliente ');
      SQL.Add('And gespessoa.idloja = gespedidovenda.idloja ');
      SQL.Add('And gespessoa.deletado = gespedidovenda.deletado ');
      SQL.Add('WHERE gespedidovenda.idpedidovenda is not null ');
      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND(gespedidovenda.nome like ''%' + AQuery.Items['busca'] + '%'' )');
        end;
      end;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gespedidovenda.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gespedidovenda.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gespedidovenda.idcliente = :idcliente');
          ParamByName('idcliente').Value := 0;
        end
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gespedidovenda.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gespedidovenda.idloja = :idloja');
          ParamByName('idloja').Value := 0;
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

function TPedidoVenda.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gespedidovenda WHERE gespedidovenda.idpedidovenda is not null and gespedidovenda.idpedidovenda =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idpedidovendabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gespedidovenda.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gespedidovenda.deletado = :deletado');
          ParamByName('deletado').Value := 0;
        end;

      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gespedidovenda.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gespedidovenda.idcliente = :idcliente');
          ParamByName('idcliente').Value := 0;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gespedidovenda.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end
        else
        begin
          SQL.Add('AND gespedidovenda.idloja = :idloja');
          ParamByName('idloja').Value := 0;
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

function TPedidoVenda.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idpedidovenda = idpedidovenda+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idpedidovenda from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idpedidovenda := fieldbyname('idpedidovenda').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idpedidovenda;
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

end.


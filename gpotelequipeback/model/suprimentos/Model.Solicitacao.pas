unit Model.Solicitacao;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections,
  Model.RegrasdeNegocio;

type
  Tsolicitacao = class
  private
    FConn: TFDConnection;
    Fidgeral: Integer;
    Fidsolicitacao: Integer;
    Fidsolicitacaodiaria: Integer;
    Fidsolicitacaoitens: Integer;
    Fidcolaborador: Integer;
    Fidproduto: Integer;
    Fdatasolicitacao: string;
    Fnumero: Integer;
    Fpo: Integer;
    Fpodiaria: string;
    Fobra: string;
    Fos: string;
    Fstatus: string;
    Fdescricaoservico: string;
    Fobservacao: string;
    Fdeletado: Integer;
    Fquantidade: double;
    Fidusuario: Integer;
    Fprojeto: string;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fidtipomovimentacao: Integer;
    Fentrada: double;
    Fsaida: double;
    Fbalanco: double;
    Fevento: string;
    Fcolaborador: string;
    Fnomecolaborador: string;
    Fsiteid: string;
    Fsiglasite: string;
    Flocal: string;
    Fdescricao: string;
    Fcliente: string;
    Fvaloroutrassolicitacoes: Double;
    Fdiarias: Integer;
    Fvalortotal: Double;
    Fsolicitante: string;
    Fdataautorizacao: string;
    Fidusuarioaprovador: string;
    Fnomeaprovador: string;

  public
    constructor Create;
    destructor Destroy; override;

    property idgeral: Integer read Fidgeral write Fidgeral;
    property idsolicitacao: Integer read Fidsolicitacao write Fidsolicitacao;
    property idsolicitacaodiaria: Integer read Fidsolicitacaodiaria write Fidsolicitacaodiaria;
    property idsolicitacaoitens: Integer read Fidsolicitacaoitens write Fidsolicitacaoitens;
    property idcolaborador: Integer read Fidcolaborador write Fidcolaborador;
    property idproduto: Integer read Fidproduto write Fidproduto;
    property idusuario: Integer read Fidusuario write Fidusuario;
    property quantidade: double read Fquantidade write Fquantidade;
    property datasolicitacao: string read Fdatasolicitacao write Fdatasolicitacao;
    property numero: Integer read Fnumero write Fnumero;
    property po: Integer read Fpo write Fpo;
    property podiaria: string read Fpodiaria write Fpodiaria;
    property os: string read Fos write Fos;
    property obra: string read Fobra write Fobra;
    property evento: string read Fobra write Fobra;
    property status: string read Fevento write Fevento;
    property descricaoservico: string read Fdescricaoservico write Fdescricaoservico;
    property observacao: string read Fobservacao write Fobservacao;
    property deletado: Integer read Fdeletado write Fdeletado;
    property projeto: string read Fprojeto write Fprojeto;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property idtipomovimentacao: Integer read Fidtipomovimentacao write Fidtipomovimentacao;
    property entrada: double read Fentrada write Fentrada;
    property saida: double read Fsaida write Fsaida;
    property balanco: double read Fbalanco write Fbalanco;

    property colaborador: string read Fcolaborador write Fcolaborador;
    property nomecolaborador: string read Fnomecolaborador write Fnomecolaborador;
    property siteid: string read Fsiteid write Fsiteid;
    property siglasite: string read Fsiglasite write Fsiglasite;
    property local: string read Flocal write Flocal;
    property descricao: string read Fdescricao write Fdescricao;
    property cliente: string read Fcliente write Fcliente;
    property valoroutrassolicitacoes: Double read Fvaloroutrassolicitacoes write Fvaloroutrassolicitacoes;
    property diarias: Integer read Fdiarias write Fdiarias;
    property valortotal: Double read Fvalortotal write Fvalortotal;
    property solicitante: string read Fsolicitante write Fsolicitante;
    property dataautorizacao: string read Fdataautorizacao write Fdataautorizacao;
    property nomeaprovador: string read Fnomeaprovador write Fnomeaprovador;
    property idusuarioaprovador: string read Fidusuarioaprovador write Fidusuarioaprovador;

    function Listasolicitacao(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaitens(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaiditens(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function EditarItens(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;
    function NovoCadastroItens(out erro: string): integer;
    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaidlista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listarequisicao(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Atendesolicitacao(out erro: string): Boolean;
    function NovoCadastrodiaria(out erro: string): integer;
    function Editardiaria(out erro: string): Boolean;
    function Aprovarsolicitacao(out erro: string): Boolean;
    function Listasolicitacaoporempresa(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;

  end;

implementation

{ Tsolicitacao }

function Tsolicitacao.Aprovarsolicitacao(out erro: string): Boolean;
var
  qry: TFDQuery;
begin
  Result := False;
  erro := '';
  qry := nil;

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    FConn.StartTransaction;
    try
      qry.SQL.Clear;
      qry.SQL.Add('UPDATE gessolicitacaoitens ' + 'SET statusaprovacao = :statusaprovacao, ' + 'idusuarioaprovador = :idusuarioaprovador, ' + 'nomeaprovador = :nomeaprovador, ' + 'dataaprovada = :dataaprovada ' + 'WHERE idsolicitacao = :idsolicitacaoitens and idproduto = :idproduto');

      qry.ParamByName('statusaprovacao').AsString := 'APROVADO';
      qry.ParamByName('idusuarioaprovador').AsString := idusuarioaprovador;
      qry.ParamByName('idproduto').AsInteger := idproduto;
      qry.ParamByName('nomeaprovador').AsString := nomeaprovador;
      qry.ParamByName('dataaprovada').AsDateTime := Now;
      qry.ParamByName('idsolicitacaoitens').AsInteger := idsolicitacao;

      qry.ExecSQL;

      FConn.Commit;
      Result := True;

    except
      on E: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao aprovar solicita��o: ' + E.Message;
        Result := False;
      end;
    end;

  finally
    qry.Free;
  end;
end;

function Tsolicitacao.Atendesolicitacao(out erro: string): Boolean;
var
  regradenegocio: TRegraNegocios;
  qry: TFDQuery;
  idcontroleestoque: integer;
  desc: string;
begin
  try
    regradenegocio := TRegraNegocios.Create;
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      FConn.StartTransaction;
      with qry do
      begin

        Active := false;
        SQL.Clear;
        sql.Add('update gessolicitacaoitens set dataatendimento=:dataatendimento,atendidopor=:atendidopor,status=:status where idsolicitacaoitens=:idsolicitacaoitens  ');
        ParamByName('dataatendimento').AsDateTime := Now;
        ParamByName('atendidopor').AsInteger := idusuario;
        if evento = 'Atender' then
        begin
          ParamByName('status').AsString := 'ATENDIDO';
          desc := 'Solicita��o de produto';
        end
        else
        begin
          ParamByName('status').AsString := 'AGUARDANDO';
          desc := 'Cancelando Solicita��o de produto';
        end;
        ParamByName('idsolicitacaoitens').AsInteger := idsolicitacao;
        ExecSQL;

        FConn.Commit;
      end;

      if regradenegocio.gerenciadorENTRADAeSAIDA(idproduto, idcliente, idloja, idusuario, idtipomovimentacao, (entrada + saida + balanco), desc, 0) then
      begin
        erro := '';
        result := true;
      end
      else
      begin
        FConn.StartTransaction;
        with qry do
        begin
          Active := false;
          SQL.Clear;
          sql.Add('update gessolicitacaoitens set dataatendimento=:dataatendimento,atendidopor=:atendidopor,status=:status where idgeral=:idgeral  ');
          ParamByName('dataatendimento').AsDateTime := strtodate('30/12/1899');
          ParamByName('atendidopor').AsInteger := idusuario;
          ParamByName('status').AsString := 'AGUARDANDO';
          ParamByName('idgeral').AsInteger := idsolicitacao;
          ExecSQL;
          SQL.Clear;
          sql.Add('delete from gescontroleestoque where idcontroleestoque=:idcontroleestoque');
          ParamByName('idcontroleestoque').Value := idcontroleestoque;
          ExecSQL;
        end;
        FConn.Commit;
        erro := 'Erro ao salvar lan�amento: Problema ao atualizar estoque';
        Result := false;
      end;

    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao Atender solicita��o: ' + ex.Message;
        Result := false;
      end;
    end;

  finally
    qry.Free;
    regradenegocio.free;
  end;

end;

constructor Tsolicitacao.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor Tsolicitacao.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function Tsolicitacao.Listarequisicao(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('SELECT ');
      SQL.Add('  gessolicitacaoitens.idsolicitacaoitens AS id, ');
      SQL.Add('  gessolicitacao.idsolicitacao, ');
      SQL.Add('  gessolicitacao.data, ');
      SQL.Add('  gessolicitacaoitens.status, ');
      SQL.Add('  gesusuario.nome, ');
      SQL.Add('  gessolicitacao.obra, ');
      SQL.Add('  gessolicitacao.observacao,');
      SQL.Add('  gessolicitacaoitens.idproduto, ');
      SQL.Add('  gesproduto.descricao, ');
      SQL.Add('  gesproduto.unidade, ');
      SQL.Add('  gessolicitacaoitens.quantidade, ');
      SQL.Add('  gessolicitacaoitens.idusuarioaprovador, ');
      SQL.Add('  gessolicitacaoitens.observacao, ');
      SQL.Add('  gesproduto.estoque, ');
      SQL.Add('  gessolicitacao.projeto, ');
      SQL.Add('  DATE_FORMAT(gessolicitacaoitens.dataaprovada, "%d/%m/%Y") AS dataaprovada, ');
      SQL.Add('  gessolicitacaoitens.dataatendimento, ');
      SQL.Add('  gessolicitacaoitens.statusaprovacao, ');
      SQL.Add('  gessolicitacaoitens.nomeaprovador, ');
      SQL.Add('  gessolicitacaoitens.atendidopor, ');
      SQL.Add('  gesusuario1.nome AS nomeatendente ');
      SQL.Add('FROM gessolicitacao ');
      SQL.Add('LEFT JOIN gesusuario ON gesusuario.idusuario = gessolicitacao.idcolaborador ');
      SQL.Add('LEFT JOIN gessolicitacaoitens ON gessolicitacaoitens.idsolicitacao = gessolicitacao.idsolicitacao ');
      SQL.Add('LEFT JOIN gesproduto ON gesproduto.idproduto = gessolicitacaoitens.idproduto ');
      SQL.Add('LEFT JOIN gesusuario AS gesusuario1 ON gesusuario1.idgeral = gessolicitacaoitens.atendidopor ');
      SQL.Add('WHERE gessolicitacaoitens.deletado = 0 ');
      SQL.Add('  AND gessolicitacaoitens.status = "ATENDIDO" ');
      SQL.Add('ORDER BY gessolicitacao.idsolicitacao DESC;');

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

function Tsolicitacao.EditarItens(out erro: string): Boolean;
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
        sql.add('select idsolicitacaoitens from gessolicitacaoitens where  idsolicitacaoitens=:idsolicitacaoitens and idsolicitacao=:idsolicitacao ');
        ParamByName('idsolicitacao').AsInteger := idsolicitacao;
        ParamByName('idsolicitacaoitens').Value := idsolicitacaoitens;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO gessolicitacaoitens(idsolicitacaoitens,idsolicitacao,idproduto,quantidade, ');
          SQL.Add('idusuario,deletado)');
          SQL.Add('               VALUES(:idsolicitacaoitens,:idsolicitacao,:idproduto,:quantidade, ');
          SQL.Add(':idusuario,:deletado)');
          ParamByName('deletado').AsInteger := 0;
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gessolicitacaoitens set ');
          SQL.Add('idproduto=:idproduto, ');
          SQL.Add('idusuario=:idusuario, ');
          SQL.Add('quantidade=:quantidade ');
          SQL.Add('where idsolicitacaoitens=:idsolicitacaoitens and idsolicitacao=:idsolicitacao');
        end;
        ParamByName('idsolicitacaoitens').AsInteger := idsolicitacaoitens;
        ParamByName('idsolicitacao').AsInteger := idsolicitacao;
        ParamByName('idproduto').AsInteger := idproduto;
        ParamByName('quantidade').Asfloat := quantidade;
        ParamByName('idusuario').asinteger := idusuario;
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

function Tsolicitacao.Editar(out erro: string): Boolean;
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
        sql.add('Select  * From  gessolicitacao where  idsolicitacao=:idsolicitacao ');
        ParamByName('idsolicitacao').AsInteger := idsolicitacao;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO gessolicitacao(idcolaborador,obra,observacao,deletado,data,idsolicitacao,idusuario,projeto) ');
          SQL.Add('               VALUES(:idcolaborador,:obra,:observacao,:deletado,:data,:idsolicitacao,:idusuario,:projeto) ');
          ParamByName('deletado').AsInteger := 0;
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gessolicitacao set ');
          SQL.Add('obra=:obra, ');
          SQL.Add('observacao=:observacao, ');
          SQL.Add('data=:data, ');
          SQL.Add('idcolaborador=:idcolaborador, ');
          SQL.Add('idusuario=:idusuario, projeto=:projeto ');
          SQL.Add('where idsolicitacao=:idsolicitacao ');
        end;
        ParamByName('idcolaborador').asinteger := idusuario;
        ParamByName('obra').asstring := obra;
        ParamByName('observacao').AsString := observacao;
        ParamByName('data').AsString := datasolicitacao;
        ParamByName('idsolicitacao').AsInteger := idsolicitacao;
        ParamByName('idusuario').asinteger := idusuario;
        ParamByName('projeto').AsString := projeto;
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

function Tsolicitacao.Editardiaria(out erro: string): Boolean;
var
  formatSettings: TFormatSettings;
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
        // Configura��o de formato
        formatSettings := TFormatSettings.Create;
        formatSettings.DateSeparator := '/';
        formatSettings.ShortDateFormat := 'dd/mm/yyyy';
        formatSettings.LongDateFormat := 'dd/mm/yyyy';
        formatSettings.ShortTimeFormat := 'hh:nn:ss';
        formatSettings.LongTimeFormat := 'hh:nn:ss';
        sql.add('Select  * From  gesdiaria where  numero=:numero ');
        ParamByName('numero').AsInteger := numero;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO gesdiaria (numero, datasolicitacao, colaborador, nomecolaborador, projeto, siteid, siglasite, po, local, descricao, cliente,');
          SQL.Add('valoroutrassolicitacoes, diarias, valortotal, solicitante, deletado)');
          SQL.Add('VALUES (:numero, :datasolicitacao, :colaborador, :nomecolaborador, :projeto, :siteid, :siglasite, :po, :local, :descricao, :cliente,');
          SQL.Add(':valoroutrassolicitacoes, :diarias, :valortotal, :solicitante, :deletado);'); // <-- par�ntese e ponto e v�rgula adicionados

          ParamByName('deletado').AsBoolean := False;
          ParamByName('numero').AsInteger := numero;
          ParamByName('datasolicitacao').AsDateTime := StrToDateTime(datasolicitacao); // ou diretamente datasolicitacao, se for TDateTime
          ParamByName('colaborador').AsString := colaborador;
          ParamByName('nomecolaborador').AsString := nomecolaborador;
          ParamByName('projeto').AsString := projeto;
          ParamByName('siteid').AsString := siteid;
          ParamByName('siglasite').AsString := siglasite;
          ParamByName('po').AsString := podiaria;
          ParamByName('local').AsString := local;
          ParamByName('descricao').AsString := descricao;
          ParamByName('cliente').AsString := cliente;
          ParamByName('valoroutrassolicitacoes').AsFloat := valoroutrassolicitacoes;
          ParamByName('diarias').AsInteger := diarias;
          ParamByName('valortotal').AsFloat := valortotal;
          ParamByName('solicitante').AsString := solicitante;

          execsql;
        end
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

function Tsolicitacao.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gessolicitacao.idsolicitacao as id, ');
      SQL.Add('gessolicitacao.data, ');
      SQL.Add('gespessoa.nome, ');
      SQL.Add('gespessoa.fantasia, ');
      SQL.Add('gessolicitacao.numero, ');
      SQL.Add('gessolicitacao.po, ');
      SQL.Add('gessolicitacao.descricaoservico, ');
      SQL.Add('gessolicitacao.status ');
      SQL.Add('From ');
      SQL.Add('gessolicitacao left Join ');
      SQL.Add('gespessoa On gespessoa.idpessoa = gessolicitacao.idcolaborador ');
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

function Tsolicitacao.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idsolicitacao = idsolicitacao+1 ');
        execsql;
        close;
        sql.Clear;
        sql.add('select idsolicitacao from admponteiro ');
        Open;
        idsolicitacao := fieldbyname('idsolicitacao').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := 1;
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

function Tsolicitacao.NovoCadastrodiaria(out erro: string): integer;
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
        sql.add('update admponteiro set idsolicitacaodiaria = idsolicitacaodiaria+1 ');
        execsql;
        close;
        sql.Clear;
        sql.add('select idsolicitacaodiaria from admponteiro ');
        Open;
        idsolicitacaodiaria := fieldbyname('idsolicitacaodiaria').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := 1;
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

function Tsolicitacao.NovoCadastroItens(out erro: string): integer;
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
        sql.add('update admponteiro set idsolicitacaoitens = idsolicitacaoitens+1 ');
        execsql;
        close;
        sql.Clear;
        sql.add('select idsolicitacaoitens from admponteiro ');
        Open;
        idsolicitacaoitens := fieldbyname('idsolicitacaoitens').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idsolicitacaoitens;
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

function Tsolicitacao.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select gessolicitacao.idsolicitacao as id,  ');
      SQL.Add('gessolicitacao.data,  ');
      SQL.Add('gessolicitacao.status,  ');
      SQL.Add('gesusuario.nome  ');
      SQL.Add('From  ');
      SQL.Add('gessolicitacao left Join  ');
      SQL.Add('gesusuario On gesusuario.idusuario = gessolicitacao.idcolaborador where gessolicitacao.obra=:obra  and gessolicitacao.deletado = 0  ');
      ParamByName('obra').Asstring := AQuery.Items['osouobra'];
      a := AQuery.Items['osouobra'];
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

function Tsolicitacao.Listaidlista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      a := AQuery.Items['solicitacao'];
      Active := false;
      SQL.Clear;
      SQL.Add('Select gessolicitacao.idsolicitacao as id,  ');
      SQL.Add('gessolicitacao.data,  ');
      SQL.Add('gessolicitacao.status,  ');
      SQL.Add('gesusuario.nome  ');
      SQL.Add('From  ');
      SQL.Add('gessolicitacao left Join  ');
      SQL.Add('gesusuario On gesusuario.idusuario = gessolicitacao.idcolaborador where gessolicitacao.idsolicitacao=:idsolicitacao ');
      ParamByName('idsolicitacao').Asstring := AQuery.Items['solicitacao'];
      ;

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

function Tsolicitacao.Listaitens(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gessolicitacaoitens.idgeral as id, ');
      SQL.Add('gessolicitacaoitens.idproduto, ');
      SQL.Add('gesproduto.descricao, ');
      SQL.Add('gessolicitacaoitens.quantidade, ');
      SQL.Add('gesproduto.unidade, ');
      SQL.Add('gessolicitacaoitens.idsolicitacao, ');
      SQL.Add('gessolicitacaoitens.idsolicitacaoitens, ');
      SQL.Add('gessolicitacaoitens.deletado ');
      SQL.Add('From ');
      SQL.Add('gessolicitacaoitens Left Join ');
      SQL.Add('gesproduto On gesproduto.idproduto = gessolicitacaoitens.idproduto ');
      SQL.Add('WHERE gessolicitacaoitens.idsolicitacaoitens is not null and gessolicitacaoitens.idsolicitacao=:idsolicitacao ');
      ParamByName('idsolicitacao').Value := AQuery.Items['solicitacao'].ToInteger;
      a := AQuery.Items['solicitacao'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gessolicitacaoitens.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      SQL.Add('order by gessolicitacaoitens.idgeral ');
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

function Tsolicitacao.Listaiditens(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gessolicitacaoitens.idgeral as id, ');
      SQL.Add('gessolicitacaoitens.idproduto, ');
      SQL.Add('gesproduto.descricao, ');
      SQL.Add('gesproduto.codigosku, ');
      SQL.Add('gessolicitacaoitens.quantidade, ');
      SQL.Add('gesproduto.unidade, ');
      SQL.Add('gessolicitacaoitens.idsolicitacao, ');
      SQL.Add('gessolicitacaoitens.idsolicitacaoitens, ');
      SQL.Add('gessolicitacaoitens.deletado ');
      SQL.Add('From ');
      SQL.Add('gessolicitacaoitens Left Join ');
      SQL.Add('gesproduto On gesproduto.idproduto = gessolicitacaoitens.idproduto ');
      SQL.Add('WHERE gessolicitacaoitens.idsolicitacaoitens is not null and gessolicitacaoitens.idsolicitacaoitens=:idsolicitacaoitens ');
      ParamByName('idsolicitacaoitens').Value := AQuery.Items['idsolicitacaoitensbusca'].ToInteger;
      a := AQuery.Items['idsolicitacaoitensbusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gessolicitacaoitens.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      SQL.Add('order by gessolicitacaoitens.idgeral ');
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

function Tsolicitacao.Listasolicitacao(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: string;
  Projeto: string;
  Status: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select  ');
      SQL.Add('gessolicitacaoitens.idsolicitacaoitens As id, ');
      SQL.Add('gessolicitacao.idsolicitacao, ');
      SQL.Add('gessolicitacao.data, ');
      SQL.Add('gessolicitacaoitens.status, ');
      SQL.Add('gesusuario.nome, ');
      SQL.Add('gessolicitacao.obra, ');
      SQL.Add('  gessolicitacao.observacao,');
      SQL.Add('gessolicitacaoitens.idproduto, ');
      SQL.Add('gesproduto.descricao,  ');
      SQL.Add('gesproduto.unidade,  ');
      SQL.Add('gessolicitacaoitens.quantidade,  ');
      SQL.Add('gesproduto.estoque,  ');
      SQL.Add('gessolicitacao.projeto ');
      SQL.Add('From  ');
      SQL.Add('gessolicitacao Left Join   ');
      SQL.Add('gesusuario On gesusuario.idusuario = gessolicitacao.idcolaborador Left Join   ');
      SQL.Add('gessolicitacaoitens On gessolicitacaoitens.idsolicitacao = gessolicitacao.idsolicitacao Left Join   ');
      SQL.Add('gesproduto On gesproduto.idproduto = gessolicitacaoitens.idproduto  ');
      SQL.Add('Where  ');
      SQL.Add('gessolicitacaoitens.deletado = 0  ');      //and gessolicitacaoitens.status <> ''ATENDIDO''
      if AQuery.ContainsKey('status') then
      begin
        a := AQuery.Items['status'];

        if Length(AQuery.Items['status']) > 0 then
        begin
          if AQuery.Items['status'] <> 'TODOS' then
          begin
            SQL.Add('AND gessolicitacaoitens.status = :status');
            ParamByName('status').Value := AQuery.Items['status'];
          end;
        end
        else
        begin
          SQL.Add('AND gessolicitacaoitens.status = :status');
          ParamByName('status').Value := 'AGUARDANDO';
        end

      end;

      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND gesproduto.descricao like ''%' + AQuery.Items['busca'] + '%'' ');
        end;
      end;

      SQL.Add('order by idsolicitacao desc');

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

function Tsolicitacao.Listasolicitacaoporempresa(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a: string;
  Projeto: string;
  Status: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select  ');
      SQL.Add('gessolicitacaoitens.idsolicitacaoitens As id, ');
      SQL.Add('gessolicitacao.idsolicitacao, ');
      SQL.Add('gessolicitacao.data, ');
      SQL.Add('gessolicitacaoitens.status, ');
      SQL.Add('gesusuario.nome, ');
      SQL.Add('gessolicitacao.obra, ');
      SQL.Add('gessolicitacao.observacao,');
      SQL.Add('gessolicitacaoitens.idproduto, ');
      SQL.Add('gesproduto.descricao,  ');
      SQL.Add('gesproduto.unidade,  ');
      SQL.Add('gessolicitacaoitens.quantidade,  ');
      SQL.Add('gesproduto.estoque,  ');
      SQL.Add('gessolicitacao.projeto ');
      SQL.Add('From  ');
      SQL.Add('gessolicitacao Left Join   ');
      SQL.Add('gesusuario On gesusuario.idusuario = gessolicitacao.idcolaborador Left Join   ');
      SQL.Add('gessolicitacaoitens On gessolicitacaoitens.idsolicitacao = gessolicitacao.idsolicitacao Left Join   ');
      SQL.Add('gesproduto On gesproduto.idproduto = gessolicitacaoitens.idproduto  ');
      SQL.Add('Where  ');
      SQL.Add('gessolicitacaoitens.deletado = 0 and gessolicitacao.projeto =:projeto and gessolicitacao.obra=:obra  ');      //and gessolicitacaoitens.status <> ''ATENDIDO''
      ParamByName('projeto').Value := AQuery.Items['projeto'];
      ParamByName('obra').Value := AQuery.Items['osouobra'];
      SQL.Add('order by idsolicitacao desc');
      Active := true;

      a := IntToStr(RecordCount)
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


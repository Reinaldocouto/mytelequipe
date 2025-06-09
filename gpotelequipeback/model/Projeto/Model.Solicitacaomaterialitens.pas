unit Model.Solicitacaomaterialitens;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.Generics.Collections, System.StrUtils, FireDAC.DApt, Firedac.Stan.Param,
  System.JSON, Dataset.Serialize;

type
  TUsuario = class
  private
    FConn: TFDConnection;
    Fidusuario: Integer;
    Fidproduto: Integer;
    Fquantidade: Double;
    Femail: string;
    Fsenha: string;
    Fativo: Integer;
    Fdatacriacao: string;
    Fobservacao: string;
    FselecionarTodos: Integer;
    Fpessoas: Integer;
    Fprodutos: Integer;
    Fveiculos: Integer;
    Fgestaofrotas: Integer;
    Fdespesas: Integer;
    Fcontroleestoque: Integer;
    Fcompras: Integer;
    Fsolicitacao: Integer;
    Frequisicao: Integer;
    Fericsson: Integer;
    Fhuawei: Integer;
    Fmotorola: Integer;
    Fzte: Integer;
    Fdemonstrativo: Integer;

    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    property idusuario: Integer read Fidusuario write Fidusuario;
    property nome: string read Fnome write Fnome;
    property email: string read Femail write Femail;
    property senha: string read Fsenha write Fsenha;
    property ativo: Integer read Fativo write Fativo;
    property datacriacao: string read Fdatacriacao write Fdatacriacao;
    property observacao: string read Fobservacao write Fobservacao;
    property selecionarTodos: Integer read FselecionarTodos write FselecionarTodos;
    property pessoas: Integer read Fpessoas write Fpessoas;
    property produtos: Integer read Fprodutos write Fprodutos;
    property veiculos: Integer read Fveiculos write Fveiculos;
    property gestaofrotas: Integer read Fgestaofrotas write Fgestaofrotas;
    property despesas: Integer read Fdespesas write Fdespesas;
    property controleestoque: Integer read Fcontroleestoque write Fcontroleestoque;
    property compras: Integer read Fcompras write Fcompras;
    property solicitacao: Integer read Fsolicitacao write Fsolicitacao;
    property requisicao: Integer read Frequisicao write Frequisicao;
    property ericsson: Integer read Fericsson write Fericsson;
    property huawei: Integer read Fhuawei write Fhuawei;
    property motorola: Integer read Fmotorola write Fmotorola;
    property zte: Integer read Fzte write Fzte;
    property demonstrativo: Integer read Fdemonstrativo write Fdemonstrativo;

    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;
  end;

implementation

{ TFuncao }

constructor TUsuario.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TUsuario.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
end;

function TUsuario.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idusuario = idusuario+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idusuario from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idusuario := fieldbyname('idusuario').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idusuario;
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

function TUsuario.Editar(out erro: string): Boolean;
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
        sql.add('select idusuario from gesusuario where idcliente=:idcliente and idloja=:idloja and idusuario=:idusuario ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ParamByName('idusuario').Value := idusuario;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('INSERT INTO gesusuario(idusuario,nome,email,senha,ativo,datacriacao,');
          SQL.Add('observacao,selecionarTodos,pessoas,produtos,veiculos,gestaofrotas,despesas,controleestoque,');
          SQL.Add('compras,solicitacao,requisicao,ericsson,huawei,motorola,zte,demonstrativo,');
          SQL.Add('IDCLIENTE,IDLOJA,DELETADO)');
          SQL.Add('                        VALUES(:idusuario,:nome,:email,:senha,:ativo,:datacriacao,');
          SQL.Add(':observacao,:selecionarTodos,:pessoas,:produtos,:veiculos,:gestaofrotas,:despesas,:controleestoque,');
          SQL.Add(':compras,:solicitacao,:requisicao,:ericsson,:huawei,:motorola,:zte,:demonstrativo,');
          SQL.Add(':IDCLIENTE,:IDLOJA,:DELETADO)');
        end
        else
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('update gesusuario set idusuario=:idusuario,');
          SQL.Add('nome=:nome,');
          SQL.Add('email=:email,');
          SQL.Add('senha=:senha,');
          SQL.Add('ativo=:ativo,');
          SQL.Add('datacriacao=:datacriacao,');
          SQL.Add('observacao=:observacao,');
          SQL.Add('selecionarTodos=:selecionarTodos,');
          SQL.Add('pessoas=:pessoas,');
          SQL.Add('produtos=:produtos,');
          SQL.Add('veiculos=:veiculos,');
          SQL.Add('gestaofrotas=:gestaofrotas,');
          SQL.Add('despesas=:despesas,');
          SQL.Add('controleestoque=:controleestoque,');
          SQL.Add('compras=:compras,');
          SQL.Add('solicitacao=:solicitacao,');
          SQL.Add('requisicao=:requisicao,');
          SQL.Add('ericsson=:ericsson,');
          SQL.Add('huawei=:huawei,');
          SQL.Add('motorola=:motorola,');
          SQL.Add('zte=:zte,');
          SQL.Add('demonstrativo=:demonstrativo,');
          SQL.Add('DELETADO=:DELETADO');
          SQL.Add('where IDCLIENTE=:IDCLIENTE and IDLOJA=:IDLOJA and IDUSUARIO=:IDUSUARIO');
        end;
        ParamByName('idusuario').Value := idusuario;
        ParamByName('nome').Value := nome;
        ParamByName('email').Value := email;
        ParamByName('senha').Value := senha;
        ParamByName('ativo').Value := ativo;
        ParamByName('datacriacao').Value := datacriacao;
        ParamByName('observacao').Value := observacao;
        ParamByName('selecionarTodos').Value := selecionarTodos;
        ParamByName('pessoas').Value := pessoas;
        ParamByName('produtos').Value := produtos;
        ParamByName('veiculos').Value := veiculos;
        ParamByName('gestaofrotas').Value := gestaofrotas;
        ParamByName('despesas').Value := despesas;
        ParamByName('controleestoque').Value := controleestoque;
        ParamByName('compras').Value := compras;
        ParamByName('solicitacao').Value := solicitacao;
        ParamByName('requisicao').Value := requisicao;
        ParamByName('ericsson').Value := ericsson;
        ParamByName('huawei').Value := huawei;
        ParamByName('motorola').Value := motorola;
        ParamByName('zte').Value := zte;
        ParamByName('demonstrativo').Value := demonstrativo;
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
        erro := 'Erro ao cadastrar configuração do usuário: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TUsuario.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesusuario.idusuario as id, ');
      SQL.Add('gesusuario.nome, ');
      SQL.Add('gesusuario.email, ');
      SQL.Add('gesusuario.senha, ');
      SQL.Add('DATE_FORMAT(gesusuario.datacriacao,''%d/%m/%Y'') as datacriacao,    ');
      SQL.Add('gesusuario.ativo ');
      SQL.Add('From ');
      SQL.Add('gesusuario WHERE gesusuario.idusuario is not null ');
      if AQuery.ContainsKey('id') then
      begin
        if Length(AQuery.Items['id']) > 0 then
          SQL.Add('AND gesusuario.id like ''%' + AQuery.Items['id'] + '%'' ');
      end;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesusuario.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesusuario.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesusuario.idloja = :idloja');
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

function TUsuario.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesusuario WHERE gesusuario.idusuario is not null and gesusuario.idusuario =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idcontroleacessobusca'].ToInteger;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesusuario.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesusuario.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesusuario.idloja = :idloja');
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

end.


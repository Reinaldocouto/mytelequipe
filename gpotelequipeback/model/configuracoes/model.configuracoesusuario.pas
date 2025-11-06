unit model.configuracoesusuario;

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
    Fnome: string;
    Femail: string;
    Fsenha: string;
    Fativo: Integer;
    Fdatacriacao: string;
    Fobservacao: string;
    FselecionarTodos: Integer;
    Fpessoas: Integer;
    Fprodutos: Integer;
    Fempresas: Integer;
    Frh: Integer;
    Fveiculos: Integer;
    FgestaoMultas: Integer;
    Fdespesas: Integer;
    Fmonitoramento: Integer;
    Fcontroleestoque: Integer;
    Fcompras: Integer;
    Fsolicitacao: Integer;
    Frequisicao: Integer;
    FericAcionamento: Integer;
    FericAdicional: Integer;
    FericControleLpu: Integer;
    FericRelatorio: Integer;
    FhuaAcionamento: Integer;
    FhuaAdicional: Integer;
    FhuaControleLpu: Integer;
    FhuaRelatorio: Integer;
    FzteAcionamento: Integer;
    FzteAdicional: Integer;
    FzteControleLpu: Integer;
    FzteRelatorio: Integer;
    Fericfechamento:Integer;
    FericFaturamento:Integer;
    Fhuafechamento:Integer;
    Fztefechamento:Integer;
    Ftelefonicafechamento:Integer;
    FtelefonicaControle:Integer;
    FtelefonicaRelatorio:Integer;
    FtelefonicaControleLpu:Integer;
    Fcosfechamento:Integer;
    FcosControle:Integer;
    FcosRelatorio:Integer;
    FcosControleLpu:Integer;
    Fdemonstrativo: Integer;
    Fsolicitacaoavulsa: Integer;
    FtelefonicaEdicaoDocumentacao: Integer;
    FtelefonicaT4: Integer;
    FadicionarSiteManualmenteTelefonica: Integer;
    FmarcarDesmarcarSiteAvulso: Integer;

    Fmodovisualizador: Integer;

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
    property marcarDesmarcarSiteAvulso: Integer read FmarcarDesmarcarSiteAvulso write FmarcarDesmarcarSiteAvulso;
    property adicionarSiteManualmenteTelefonica: Integer read FadicionarSiteManualmenteTelefonica write FadicionarSiteManualmenteTelefonica;
    property pessoas: Integer read Fpessoas write Fpessoas;
    property produtos: Integer read Fprodutos write Fprodutos;
    property empresas: Integer read Fempresas write Fempresas;
    property rh: Integer read Frh write Frh;
    property veiculos: Integer read Fveiculos write Fveiculos;
    property gestaoMultas: Integer read FgestaoMultas write FgestaoMultas;
    property despesas: Integer read Fdespesas write Fdespesas;
    property monitoramento: Integer read Fmonitoramento write Fmonitoramento;
    property controleestoque: Integer read Fcontroleestoque write Fcontroleestoque;
    property compras: Integer read Fcompras write Fcompras;
    property solicitacao: Integer read Fsolicitacao write Fsolicitacao;
    property solicitacaoavulsa: Integer read Fsolicitacaoavulsa write Fsolicitacaoavulsa;
    property requisicao: Integer read Frequisicao write Frequisicao;
    property ericAcionamento: Integer read FericAcionamento write FericAcionamento;
    property ericAdicional: Integer read FericAdicional write FericAdicional;
    property ericControleLpu: Integer read FericControleLpu write FericControleLpu;
    property ericRelatorio: Integer read FericRelatorio write FericRelatorio;
    property huaAcionamento: Integer read FhuaAcionamento write FhuaAcionamento;
    property huaAdicional: Integer read FhuaAdicional write FhuaAdicional;
    property huaControleLpu: Integer read FhuaControleLpu write FhuaControleLpu;
    property huaRelatorio: Integer read FhuaRelatorio write FhuaRelatorio;
    property zteAcionamento: Integer read FzteAcionamento write FzteAcionamento;
    property zteAdicional: Integer read FzteAdicional write FzteAdicional;
    property zteControleLpu: Integer read FzteControleLpu write FzteControleLpu;
    property zteRelatorio: Integer read FzteRelatorio write FzteRelatorio;
    property ericfechamento: Integer read Fericfechamento write Fericfechamento;
    property ericFaturamento: Integer read FericFaturamento write FericFaturamento;
    property huafechamento: Integer read Fhuafechamento write Fhuafechamento;
    property ztefechamento: Integer read Fztefechamento write Fztefechamento;
    property telefonicafechamento: Integer read Ftelefonicafechamento write Ftelefonicafechamento;
    property telefonicaControle: Integer read FtelefonicaControle write FtelefonicaControle;
    property telefonicaRelatorio: Integer read FtelefonicaRelatorio write FtelefonicaRelatorio;
    property telefonicaControleLpu: Integer read FtelefonicaControleLpu write FtelefonicaControleLpu;
    property telefonicaEdicaoDocumentacao: Integer read FtelefonicaEdicaoDocumentacao write FtelefonicaEdicaoDocumentacao;
    property telefonicaT4: Integer read FtelefonicaT4 write FtelefonicaT4;
    property cosfechamento: Integer read Fcosfechamento write Fcosfechamento;
    property cosControle: Integer read FcosControle write FcosControle;
    property cosRelatorio: Integer read FcosRelatorio write FcosRelatorio;
    property cosControleLpu: Integer read FcosControleLpu write FcosControleLpu;
    property modovisualizador: Integer read Fmodovisualizador write Fmodovisualizador;
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
          SQL.Add('observacao,selecionarTodos,pessoas,produtos,empresas,rh,veiculos,gestaoMultas,despesas,monitoramento,controleestoque,');
          SQL.Add('compras,solicitacao,requisicao,ericAcionamento,ericAdicional,ericControleLpu,ericRelatorio, ericFaturamento,huaAcionamento,');
          SQL.Add('huaAdicional,huaControleLpu,huaRelatorio,zteAcionamento,zteAdicional,zteControleLpu,zteRelatorio,ericfechamento,huafechamento,ztefechamento,cosfechamento, telefonicafechamento, ');
          SQL.Add('cosControle,cosRelatorio,cosControleLpu,demonstrativo,solicitacaoavulsa, ');
          SQL.Add('telefonicaControle,  telefonicaRelatorio, telefonicaEdicaoDocumentacao, telefonicaControleLpu, modovisualizador, telefonicaT4,');
          SQL.Add('IDCLIENTE,IDLOJA,DELETADO)');
          SQL.Add('VALUES(:idusuario,:nome,:email,:senha,:ativo,:datacriacao,');
          SQL.Add(':observacao,:selecionarTodos,:pessoas,:produtos,:empresas,:rh,:veiculos,:gestaoMultas,:despesas,:monitoramento,:controleestoque,');
          SQL.Add(':compras,:solicitacao,:requisicao,:ericAcionamento,:ericAdicional,:ericControleLpu,:ericRelatorio, :ericFaturamento,');
          SQL.Add(':huaAcionamento,:huaAdicional,:huaControleLpu,:huaRelatorio,:zteAcionamento,:zteAdicional,:zteControleLpu,:zteRelatorio,:ericfechamento,:huafechamento,:ztefechamento,:cosfechamento, :telefonicafechamento, ');
          SQL.Add(':cosControle,:cosRelatorio, :cosControleLpu, :demonstrativo, :solicitacaoavulsa,');
          SQL.Add(':telefonicaControle,:telefonicaRelatorio, :telefonicaEdicaoDocumentacao, :telefonicaControleLpu, :modovisualizador,:telefonicaT4,');
          SQL.Add(':IDCLIENTE,:IDLOJA,:DELETADO)');
          ParamByName('senha').Value := senha;
        end
        else
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('update gesusuario set idusuario=:idusuario,');
          SQL.Add('nome=:nome,');
          SQL.Add('email=:email,');
          //SQL.Add('senha=:senha,');
          if senha <> '' then
          begin
          SQL.Add('senha=:senha,');
          ParamByName('senha').AsString := senha;
          end;
          SQL.Add('ativo=:ativo,');
          SQL.Add('datacriacao=:datacriacao,');
          SQL.Add('observacao=:observacao,');
          SQL.Add('selecionarTodos=:selecionarTodos,');
          SQL.Add('pessoas=:pessoas,');
          SQL.Add('produtos=:produtos,');
          SQL.Add('empresas=:empresas,');
          SQL.Add('rh=:rh,');
          SQL.Add('veiculos=:veiculos,');
          SQL.Add('gestaoMultas=:gestaoMultas,');
          SQL.Add('despesas=:despesas,');
          SQL.Add('monitoramento=:monitoramento,');
          SQL.Add('controleestoque=:controleestoque,');
          SQL.Add('compras=:compras,');
          SQL.Add('solicitacao=:solicitacao,');
          SQL.Add('requisicao=:requisicao,');
          SQL.Add('ericAcionamento=:ericAcionamento,');
          SQL.Add('ericAdicional=:ericAdicional,');
          SQL.Add('ericControleLpu=:ericControleLpu,');
          SQL.Add('ericRelatorio=:ericRelatorio,');
          SQL.Add('ericFaturamento=:ericFaturamento,');
          SQL.Add('huaAcionamento=:huaAcionamento,');
          SQL.Add('huaAdicional=:huaAdicional,');
          SQL.Add('huaControleLpu=:huaControleLpu,');
          SQL.Add('huaRelatorio=:huaRelatorio,');
          SQL.Add('zteAcionamento=:zteAcionamento,');
          SQL.Add('zteAdicional=:zteAdicional,');
          SQL.Add('zteControleLpu=:zteControleLpu,');
          SQL.Add('zteRelatorio=:zteRelatorio,');
          SQL.Add('ericfechamento=:ericfechamento,');
          SQL.Add('huafechamento=:huafechamento,');
          SQL.Add('ztefechamento=:ztefechamento,');
          SQL.Add('cosfechamento=:cosfechamento,');
          SQL.Add('cosControle=:cosControle,');
          SQL.Add('cosRelatorio=:cosRelatorio,');
          SQL.Add('cosControleLpu=:cosControleLpu,');
          SQL.Add('telefonicafechamento=:telefonicafechamento,');
          SQL.Add('telefonicaControle=:telefonicaControle,');
          SQL.Add('telefonicaRelatorio=:telefonicaRelatorio,');
          SQL.Add('telefonicaControleLpu=:telefonicaControleLpu, ');
          SQL.Add('marcarDesmarcarSiteAvulso=:marcarDesmarcarSiteAvulso, ');
          SQL.Add('adicionarSiteManualmenteTelefonica=:adicionarSiteManualmenteTelefonica, ');
          SQL.Add('telefonicaT4=:telefonicaT4, ');
          SQL.Add('demonstrativo=:demonstrativo,');
          SQL.Add('solicitacaoavulsa=:solicitacaoavulsa,');
          SQL.Add('telefonicaEdicaoDocumentacao=:telefonicaEdicaoDocumentacao,');
          SQL.Add('modovisualizador=:modovisualizador,');

          SQL.Add('DELETADO=:DELETADO');
          SQL.Add('where IDCLIENTE=:IDCLIENTE and IDLOJA=:IDLOJA and IDUSUARIO=:IDUSUARIO');
        end;
        ParamByName('idusuario').Value := idusuario;
        ParamByName('nome').Value := nome;
        ParamByName('email').Value := email;
        ParamByName('ativo').Value := ativo;
        ParamByName('datacriacao').Value := datacriacao;
        ParamByName('observacao').Value := observacao;
        ParamByName('selecionarTodos').Value := selecionarTodos;
        ParamByName('pessoas').Value := pessoas;
        ParamByName('produtos').Value := produtos;
        ParamByName('empresas').Value := empresas;
        ParamByName('rh').Value := rh;
        ParamByName('veiculos').Value := veiculos;
        ParamByName('gestaoMultas').Value := gestaoMultas;
        ParamByName('despesas').Value := despesas;
        ParamByName('monitoramento').Value := monitoramento;
        ParamByName('controleestoque').Value := controleestoque;
        ParamByName('compras').Value := compras;
        ParamByName('solicitacao').Value := solicitacao;
        ParamByName('solicitacaoavulsa').Value := solicitacaoavulsa;
        ParamByName('requisicao').Value := requisicao;
        ParamByName('ericAcionamento').Value := ericAcionamento;
        ParamByName('ericAdicional').Value := ericAdicional;
        ParamByName('ericControleLpu').Value := ericControleLpu;
        ParamByName('ericRelatorio').Value := ericRelatorio;
        ParamByName('ericFaturamento').Value := ericfaturamento;
        ParamByName('huaAcionamento').Value := huaAcionamento;
        ParamByName('huaAdicional').Value := huaAdicional;
        ParamByName('huaControleLpu').Value := huaControleLpu;
        ParamByName('huaRelatorio').Value := huaRelatorio;
        ParamByName('zteAcionamento').Value := zteAcionamento;
        ParamByName('zteAdicional').Value := zteAdicional;
        ParamByName('zteControleLpu').Value := FzteControleLpu;
        ParamByName('zteRelatorio').Value := zteRelatorio;
        ParamByName('ericfechamento').Value := ericfechamento;
        ParamByName('huafechamento').Value := huafechamento;
        ParamByName('ztefechamento').Value := ztefechamento;
        ParamByName('cosfechamento').Value := cosfechamento;
        ParamByName('cosControle').Value := cosControle;
        ParamByName('cosRelatorio').Value := cosRelatorio;
        ParamByName('cosControleLpu').Value := cosControleLpu;
        ParamByName('telefonicafechamento').Value := telefonicafechamento;
        ParamByName('telefonicaControle').Value := telefonicaControle;
        ParamByName('telefonicaRelatorio').Value := telefonicaRelatorio;
        ParamByName('telefonicaControleLpu').Value := telefonicaControleLpu;
        ParamByName('telefonicaEdicaoDocumentacao').Value := telefonicaEdicaoDocumentacao;
        ParamByName('marcarDesmarcarSiteAvulso').Value := marcarDesmarcarSiteAvulso;
        ParamByName('adicionarSiteManualmenteTelefonica').Value := adicionarSiteManualmenteTelefonica;
        ParamByName('telefonicaT4').Value := telefonicaT4;
        ParamByName('modovisualizador').Value := modovisualizador;
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
  a : string;
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
      SQL.Add('gesusuario WHERE gesusuario.idusuario is not null and gesusuario.idusuario =:id and deletado = 0 ');
      ParamByName('id').AsInteger := AQuery.Items['idcontroleacessobusca'].ToInteger;
      a :=  AQuery.Items['idcontroleacessobusca'];
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


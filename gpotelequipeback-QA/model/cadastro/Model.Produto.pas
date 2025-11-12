unit Model.Produto;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections, UtFuncao;

type
  TProduto = class
  private
    FConn: TFDConnection;
    Fidproduto: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;

    Fdescricao: string;
    Fcodigo: string;
    Forigem: Integer;
    Ftipoproduto: Integer;
    Fncm: string;
    Fcodigobarra: string;
    Fcest: string;
    Fcategoria: string;
    Fativo: integer;
    Funidade: string;
    Fcontrolarestoque: Integer;
    Festoque: real;
    Festoqueinicial: real;
    Festminimo: real;
    Festmaximo: real;
    Fsobencomenda: Integer;
    Fdiasparapreparacao: Integer;
    Flocalizacao: string;
  public
    constructor Create;
    destructor Destroy; override;

    property idproduto: Integer read Fidproduto write Fidproduto;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property descricao: string read fdescricao write fdescricao;
    property codigo: string read fcodigo write fcodigo;
    property origem: Integer read forigem write forigem;
    property ativo: Integer read fativo write fativo;
    property tipoproduto: Integer read ftipoproduto write ftipoproduto;
    property ncm: string read fncm write fncm;
    property categoria: string read fcategoria write fcategoria;
    property codigobarra: string read fcodigobarra write fcodigobarra;
    property cest: string read fcest write fcest;
    property unidade: string read funidade write funidade;
    property controlarestoque: Integer read fcontrolarestoque write fcontrolarestoque;
    property estoque: real read festoque write festoque;
    property estoqueinicial: real read festoqueinicial write festoqueinicial;
    property estminimo: real read festminimo write festminimo;
    property estmaximo: real read festmaximo write festmaximo;
    property sobencomenda: Integer read fsobencomenda write fsobencomenda;
    property diasparapreparacao: Integer read fdiasparapreparacao write fdiasparapreparacao;
    property localizacao: string read Flocalizacao write Flocalizacao;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaSelect(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
//    function Inserir(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;

  end;

implementation

{ TProduto }

constructor TProduto.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TProduto.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TProduto.Editar(out erro: string): Boolean;
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
        sql.add('select idproduto from gesproduto where idproduto=:idproduto ');
        ParamByName('idproduto').Value := idproduto;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO gesproduto(idproduto,descricao,unidade,codigosku,idorigem,deletado,');
          SQL.Add('categoria,ativo,controlarestoque,estoque,estoqueinicial,estminimo,estmaximo,sobencomenda,diasparapreparacao,localizacao)');
          SQL.Add('               values(:idproduto,:descricao,:unidade,:codigosku,:idorigem,:deletado,');
          SQL.Add(':categoria,:ativo,:controlarestoque,:estoque,:estoqueinicial,:estminimo,:estmaximo,:sobencomenda,:diasparapreparacao,:localizacao)');
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gesproduto set  descricao=:descricao,');
          SQL.Add('codigosku=:codigosku,');
          SQL.Add('unidade=:unidade,');
          SQL.Add('idorigem=:idorigem,');
          SQL.Add('categoria        =:categoria,');
          SQL.Add('ativo            =:ativo,');
          SQL.Add('controlarestoque =:controlarestoque,');
          SQL.Add('estoque          =:estoque,');
          SQL.Add('estoqueinicial   =:estoqueinicial,');
          SQL.Add('estminimo        =:estminimo,');
          SQL.Add('estmaximo        =:estmaximo,');
          SQL.Add('sobencomenda     =:sobencomenda,');
          SQL.Add('localizacao     =:localizacao,');
          SQL.Add('diasparapreparacao=:diasparapreparacao,DELETADO =:DELETADO ');
          SQL.Add('where IDproduto=:IDproduto');
        end;
        ParamByName('idproduto').Value := idproduto;
        ParamByName('descricao').Value := descricao;
        ParamByName('codigosku').Value := codigo;
        ParamByName('idorigem').Value := origem;
        ParamByName('categoria').Value := categoria;
        ParamByName('ativo').Value := ativo;
        ParamByName('unidade').Value := unidade;
        ParamByName('controlarestoque').Value := controlarestoque;
        ParamByName('estoque').Value := estoque;
        ParamByName('estoqueinicial').Value := estoqueinicial;
        ParamByName('estminimo').Value := estminimo;
        ParamByName('estmaximo').Value := estmaximo;
        ParamByName('sobencomenda').Value := sobencomenda;
        ParamByName('diasparapreparacao').Value := diasparapreparacao;
        ParamByName('localizacao').Value := localizacao;
        ParamByName('DELETADO').Value := 0;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar cliente: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

{function TProduto.Inserir(out erro: string): Boolean;
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
        sql.add('update admponteiro set idproduto = idproduto+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idproduto from admponteiro  where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        id := fieldbyname('idproduto').AsInteger;
        Active := false;
        sql.Clear;
        SQL.Add('INSERT INTO gesproduto(idproduto,descricao,codigo,origem,tipoproduto,ncm,codigobarra,cest,preco,unidade,');
        SQL.Add('pesoliquido,pesobruto,larguraembalagem,alturaembalagem,comprimentoembalagem,');
        SQL.Add('tipoembalagem,controlarestoque,estoque,estminimo,estmaximo,sobencomenda,localizacao,');

      {FALTA PRA SALVAR}
{        SQL.Add('tabelamedidas,descricaocomplementar,anexo,enderecoimagem,linkvideo,');
        SQL.Add('slug,keywords,tituloseo,descricaoseo,unidadecaixa,linhaproduto,custo,');
        SQL.Add('custocomposto,garantia,eantributavel,unidadetributavel,fatorconversao,');
        SQL.Add('codigoipi,cstipi,valoripi,nomefornecedor,codigofornecedor,observacaogeral,');

        SQL.Add('diasparapreparacao,IDCLIENTE,IDLOJA,DELETADO)');
        SQL.Add('               VALUES(:idproduto,:descricao,:codigo,:origem,:tipoproduto,:ncm,:codigobarra,:cest,:preco,:unidade,');
        SQL.Add(':pesoliquido,:pesobruto,:larguraembalagem,:alturaembalagem,:comprimentoembalagem,');
        SQL.Add(':tipoembalagem,:controlarestoque,:estoque,:estminimo,:estmaximo,:sobencomenda,:localizacao,');

      {FALTA PRA SALVAR}
{        SQL.Add(':tabelamedidas,:descricaocomplementar,:anexo,:enderecoimagem,:linkvideo,');
        SQL.Add(':slug,:keywords,:tituloseo,:descricaoseo,:unidadecaixa,:linhaproduto,:custo,');
        SQL.Add(':custocomposto,:garantia,:eantributavel,:unidadetributavel,:fatorconversao,');
        SQL.Add(':codigoipi,:cstipi,:valoripi,:nomefornecedor,:codigofornecedor,:observacaogeral,');

        SQL.Add(':diasparapreparacao,:IDCLIENTE,:IDLOJA,:DELETADO)');

        ParamByName('idproduto').Value := id;
        ParamByName('descricao').Value := descricao;
        ParamByName('codigo').Value := codigo;
        ParamByName('origem').Value := origem;
        ParamByName('tipoproduto').Value := tipoproduto;
        ParamByName('ncm').Value := ncm;
        ParamByName('codigobarra').Value := codigobarra;
        ParamByName('cest').Value := cest;
        ParamByName('preco').Value := preco;
        ParamByName('unidade').Value := unidade;
        ParamByName('pesoliquido').Value := pesoliquido;
        ParamByName('pesobruto').Value := pesobruto;
        ParamByName('larguraembalagem').Value := larguraembalagem;
        ParamByName('alturaembalagem').Value := alturaembalagem;
        ParamByName('comprimentoembalagem').Value := comprimentoembalagem;
        ParamByName('tipoembalagem').Value := tipoembalagem;
        ParamByName('controlarestoque').Value := controlarestoque;
        ParamByName('estoque').Value := estoque;
        ParamByName('estminimo').Value := estminimo;
        ParamByName('estmaximo').Value := estmaximo;
        ParamByName('sobencomenda').Value := sobencomenda;
        ParamByName('localizacao').Value := localizacao;
        ParamByName('diasparapreparacao').Value := diasparapreparacao;

                {FALTA PRA SALVAR}
{        ParamByName('tabelamedidas').Value := tabelamedidas;
        ParamByName('descricaocomplementar').Value := descricaocomplementar;
        ParamByName('anexo').Value := anexo;
        ParamByName('enderecoimagem').Value := enderecoimagem;
        ParamByName('linkvideo').Value := linkvideo;
        ParamByName('slug').Value := slug;
        ParamByName('keywords').Value := keywords;
        ParamByName('tituloseo').Value := tituloseo;
        ParamByName('descricaoseo').Value := descricaoseo;
        ParamByName('unidadecaixa').Value := unidadecaixa;
        ParamByName('linhaproduto').Value := linhaproduto;
        ParamByName('custo').Value := custo;
        ParamByName('custocomposto').Value := custocomposto;
        ParamByName('garantia').Value := garantia;
        ParamByName('eantributavel').Value := eantributavel;
        ParamByName('unidadetributavel').Value := unidadetributavel;
        ParamByName('fatorconversao').Value := fatorconversao;
        ParamByName('codigoipi').Value := codigoipi;
        ParamByName('cstipi').Value := cstipi;
        ParamByName('valoripi').Value := valoripi;
        ParamByName('nomefornecedor').Value := nomefornecedor;
        ParamByName('codigofornecedor').Value := codigofornecedor;
        ParamByName('observacaogeral').Value := observacaogeral;

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
        erro := 'Erro ao cadastrar cliente: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;  }

function TProduto.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  //numerofalso: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('gesproduto.idproduto as id, ');
      SQL.Add('gesproduto.descricao,');
      SQL.Add('gesproduto.unidade,');
      SQL.Add('gesproduto.categoria,');
      SQL.Add('if(gesproduto.ativo = 0,1,0) as habilitado,');
      SQL.Add('if(gesproduto.ativo = 2,1,0) as habilitadoparcial,');
      SQL.Add('if(gesproduto.ativo = 1,1,0) as desabilitado,');
      SQL.Add('if((gesproduto.estoque > gesproduto.estmaximo) and (gesproduto.estmaximo > 0) ,1,0) as estoquemaximo,');
      SQL.Add('if(gesproduto.estoque < gesproduto.estminimo,1,0) as estoqueminimo,');
      SQL.Add('gesproduto.ativo, ');
      SQL.Add('gesproduto.estoque ');
      SQL.Add('From');
      SQL.Add('gesproduto ');
      SQL.Add(' WHERE gesproduto.idproduto is not null ');
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesproduto.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND(gesproduto.codigosku like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or gesproduto.descricao like ''%' + AQuery.Items['busca'] + '%'' )');
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

function TProduto.ListaSelect(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesproduto.idproduto as value, ');
      SQL.Add('CONCAT_WS( ');
      SQL.Add(' '' - '',  ');
      SQL.Add('gesproduto.descricao, ');
      SQL.Add('gesproduto.codigosku, ');
      SQL.Add('gesproduto.codigobarra) AS label, ');
      SQL.Add('gesproduto.codigosku, ');
      SQL.Add('gesproduto.precodecusto as custo, ');
      SQL.Add('gesproduto.idproduto, ');
      SQL.Add('gesproduto.unidade, ');
      SQL.Add('gesproduto.custocomposto ');
      SQL.Add('From ');
      SQL.Add('gesproduto ');
      SQL.Add('WHERE gesproduto.idproduto is not null ');
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesproduto.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      SQL.Add('order by gesproduto.descricao');
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

function TProduto.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesproduto WHERE gesproduto.idproduto is not null and gesproduto.idproduto =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idprodutobusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesproduto.deletado = :deletado');
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

function TProduto.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idproduto = idproduto+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idproduto from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idproduto := fieldbyname('idproduto').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idproduto;
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

end.


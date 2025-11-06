unit Model.Empresa;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TEmpresa = class
  private
    FConn: TFDConnection;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Inserir(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;

  end;

implementation

{ TProduto }

constructor TEmpresa.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TEmpresa.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TEmpresa.Editar(out erro: string): Boolean;
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
        SQL.Add('update gesproduto set  descricao=:descricao,');
        SQL.Add('codigo=:codigo,');
        SQL.Add('origem=:origem,');
        SQL.Add('tipoproduto=:tipoproduto,');
        SQL.Add('ncm=:ncm,');
        SQL.Add('codigobarra=:codigobarra,');
        SQL.Add('cest=:cest,');
        SQL.Add('preco=:preco,');
        SQL.Add('unidade=:unidade,');
        SQL.Add('pesoliquido=:pesoliquido,');
        SQL.Add('pesobruto=:pesobruto,');
        SQL.Add('larguraembalagem=:larguraembalagem,');
        SQL.Add('alturaembalagem=:alturaembalagem,');
        SQL.Add('comprimentoembalagem=:comprimentoembalagem,');
        SQL.Add('tipoembalagem=:tipoembalagem,');
        SQL.Add('controlarestoque=:controlarestoque,');
        SQL.Add('estoque=:estoque,');
        SQL.Add('estminimo=:estminimo,');
        SQL.Add('estmaximo=:estmaximo,');
        SQL.Add('sobencomenda=:sobencomenda,');
        SQL.Add('localizacao=:localizacao,');
        SQL.Add('eantributavel=:eantributavel,');
        SQL.Add('fatorconversao=:fatorconversao,');
        SQL.Add('codigoenquadamentoipi=:codigoenquadamentoipi,');
        SQL.Add('valoripi=:valoripi,');
        SQL.Add('cstipi=:cstipi,');
        SQL.Add('fornecedor=:fornecedor,');
        SQL.Add('codfornecedor=:codfornecedor,');
        SQL.Add('observacao=:observacao,');
        SQL.Add('unidadetributavel=:unidadetributavel,');
        SQL.Add('linkdovideo =:linkdovideo,tituloseo =:tituloseo,descricaoseo =:descricaoseo,palavraschaveseo =:palavraschaveseo,');
        SQL.Add('slug =:slug,unidadeporcaixa =:unidadeporcaixa,custo =:custo,linhaproduto =:linhaproduto,garantia=:garantia,');
        SQL.Add('categoria1 =:categoria1,categoria2 =:categoria2,categoria3 =:categoria3,marca =:marca,cstipi=:cstipi,');
        SQL.Add('diasparapreparacao=:diasparapreparacao,DELETADO =:DELETADO ');
        SQL.Add('where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDproduto=:IDproduto');

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
end;

function TEmpresa.Inserir(out erro: string): Boolean;
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
        sql.add('update admponteiro set idnaturezaoperacao = idnaturezaoperacao+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idnaturezaoperacao from admponteiro  where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        id := fieldbyname('idnaturezaoperacao').AsInteger;
        Active := false;
        sql.Clear;
        SQL.Add('INSERT INTO gesproduto(idproduto,descricao,codigo,origem,tipoproduto,ncm,codigobarra,cest,preco,unidade,');
        SQL.Add('pesoliquido,pesobruto,larguraembalagem,alturaembalagem,comprimentoembalagem,');
        SQL.Add('tipoembalagem,controlarestoque,estoque,estminimo,estmaximo,sobencomenda,localizacao,');
        SQL.Add('Categoria1,Categoria2,Categoria3,Marca,Linkdovideo,');
        SQL.Add('TituloSEO,DescricaoSEO,PalavraschaveSEO,Slug,');
        SQL.Add('Unidadeporcaixa,custo,linhaproduto,Garantia,fornecedor,codfornecedor,observacao,');
        SQL.Add('eantributavel,fatorconversao,codigoenquadamentoipi,valoripi,cstipi,unidadetributavel,');
        SQL.Add('diasparapreparacao,IDCLIENTE,IDLOJA,DELETADO)');
        SQL.Add('               VALUES(:idproduto,:descricao,:codigo,:origem,:tipoproduto,:ncm,:codigobarra,:cest,:preco,:unidade,');
        SQL.Add(':pesoliquido,:pesobruto,:larguraembalagem,:alturaembalagem,:comprimentoembalagem,');
        SQL.Add(':tipoembalagem,:controlarestoque,:estoque,:estminimo,:estmaximo,:sobencomenda,:localizacao,');
        SQL.Add(':Categoria1,:Categoria2,:Categoria3,:Marca,:Linkdovideo,');
        SQL.Add(':TituloSEO,:DescricaoSEO,:PalavraschaveSEO,:Slug,');
        SQL.Add(':Unidadeporcaixa,:custo,:linhaproduto,:Garantia,:fornecedor,:codfornecedor,:observacao,');
        SQL.Add(':eantributavel,:fatorconversao,:codigoenquadamentoipi,:valoripi,:cstipi,:unidadetributavel,');
        SQL.Add(':diasparapreparacao,:IDCLIENTE,:IDLOJA,:DELETADO)');
        ParamByName('idproduto').Value := id;

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
        erro := 'Erro ao cadastrar cliente: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TEmpresa.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('admcliente.nome, ');
      SQL.Add('admcliente.email, ');
      SQL.Add('admcliente.ativo, ');
      SQL.Add('admcliente.idcliente as id ');
      SQL.Add('From ');
      SQL.Add('admcliente WHERE admcliente.idcliente is not null ');
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND admcliente.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end
        else
        begin
          SQL.Add('AND admcliente.idcliente = :idcliente');
          ParamByName('idcliente').Value := 0;
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

function TEmpresa.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select * ');
      SQL.Add('From ');
      SQL.Add('admcliente WHERE admcliente.idcliente is not null ');
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND admcliente.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end
        else
        begin
          SQL.Add('AND admcliente.idcliente = :idcliente');
          ParamByName('idcliente').Value := 0;
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

end.


unit Model.Fornecedor;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TFornecedor = class
  private
    FConn: TFDConnection;
    Fidfornecedor: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
    Fnome: string;
    Ffantasia: string;
    Fcep: string;
    Flogradouro: string;
    Fnumero: string;
    Fcomplemento: string;
    Fbairro: string;
    Fcidade: string;
    Fuf: string;
    Fcelular: string;
    Ftelefone: string;
    Femail: string;

  public
    constructor Create;
    destructor Destroy; override;

    property idfornecedor: Integer read Fidfornecedor write Fidfornecedor;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;

    property nome: string read Fnome write Fnome;
    property fantasia: string read Ffantasia write Ffantasia;
    property cep: string read Fcep write Fcep;
    property logradouro: string read Flogradouro write Flogradouro;
    property numero: string read Fnumero write Fnumero;
    property complemento: string read Fcomplemento write Fcomplemento;
    property bairro: string read Fbairro write Fbairro;
    property cidade: string read Fcidade write Fcidade;
    property uf: string read Fuf write Fuf;
    property celular: string read Fcelular write Fcelular;
    property telefone: string read Ftelefone write Ftelefone;
    property email: string read Femail write Femail;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaSelectfornecedor(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;
  end;

implementation

{ TFornecedor }

constructor TFornecedor.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TFornecedor.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TFornecedor.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idfornecedor = idfornecedor+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idfornecedor from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idfornecedor := fieldbyname('idfornecedor').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idfornecedor;
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

function TFornecedor.Editar(out erro: string): Boolean;
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
        sql.add('select idfornecedor from gesfornecedor where idcliente=:idcliente and idloja=:idloja and idfornecedor=:idfornecedor ');
        ParamByName('idcliente').Value := idcliente;
        ParamByName('idloja').Value := idloja;
        ParamByName('idfornecedor').Value := idfornecedor;
        open;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO gesfornecedor(idfornecedor,nome, ');
          SQL.Add('fantasia,cep,logradouro,numero,complemento, ');
          SQL.Add('bairro,cidade,uf,celular,telefone,email, ');
          SQL.Add('idloja,idcliente,DELETADO)');
          SQL.Add('               VALUES(:idfornecedor,:nome,:fantasia, ');
          SQL.Add(':cep,:logradouro,:numero,:complemento,:bairro, ');
          SQL.Add(':cidade,:uf,:celular,:telefone,:email, ');
          SQL.Add(':idloja,:idcliente,:DELETADO)');
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gesfornecedor set DELETADO=:DELETADO,nome=:nome,');
          SQL.Add('fantasia=:fantasia,cep=:cep,logradouro=:logradouro,');
          SQL.Add('numero=:numero,complemento=:complemento,bairro=:bairro,');
          SQL.Add('cidade=:cidade,uf=:uf,celular=:celular,telefone=:telefone,');
          SQL.Add('email=:email');
          SQL.Add('where idcliente=:idcliente and idloja=:idloja and idfornecedor=:idfornecedor');
        end;
        ParamByName('idfornecedor').AsInteger := idfornecedor;
        ParamByName('nome').Value := nome;
        ParamByName('fantasia').Value := fantasia;
        ParamByName('cep').Value := cep;
        ParamByName('logradouro').Value := logradouro;
        ParamByName('numero').Value := numero;
        ParamByName('complemento').Value := complemento;
        ParamByName('bairro').Value := bairro;
        ParamByName('cidade').Value := cidade;
        ParamByName('uf').Value := uf;
        ParamByName('celular').Value := celular;
        ParamByName('telefone').Value := telefone;
        ParamByName('email').Value := email;
        ParamByName('DELETADO').Value := 0;
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ExecSQL;
      end;
      FConn.Commit;
      erro := '';
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar Fornecedor: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TFornecedor.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesfornecedor.idfornecedor as id, ');
      SQL.Add('gesfornecedor.nome, ');
      SQL.Add('gesfornecedor.celular, ');
      SQL.Add('gesfornecedor.cidade, ');
      SQL.Add('gesfornecedor.uf ');
      SQL.Add('From ');
      SQL.Add('gesfornecedor WHERE gesfornecedor.idfornecedor is not null ');

      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND(gesfornecedor.nome like ''%' + AQuery.Items['busca'] + '%'' )');
        end;
      end;
         {
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesfornecedor.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;

      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesfornecedor.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesfornecedor.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end;
      end;
      }
      SQL.Add('order by id');
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

function TFornecedor.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesfornecedor WHERE gesfornecedor.idfornecedor is not null and gesfornecedor.idfornecedor =:id ');

      ParamByName('id').AsInteger := AQuery.Items['idpessoabusca'].ToInteger;
      {
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesfornecedor.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;

      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gesfornecedor.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gesfornecedor.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end;
      end;
      }
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

function TFornecedor.ListaSelectfornecedor(
  const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesfornecedor.idfornecedor As value, ');
      SQL.Add('gesfornecedor.nome As label ');
      SQL.Add('From ');
      SQL.Add('gesfornecedor where idgeral is not null ');
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesfornecedor.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      SQL.Add('order by nome');
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


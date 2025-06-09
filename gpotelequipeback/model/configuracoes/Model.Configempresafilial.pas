unit Model.Configempresafilial;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TConfigempresafilial = class
  private
    FConn: TFDConnection;
    Fidplano: Integer;
    Fidcliente: Integer;
    Fdeletado: Integer;
    Fnome: string;
    Ffantasia: string;
    Fcodigo: string;
    Ftipopessoa: Integer;
    Fdocumento: string;
    Fcpf: string;
    Frg: string;
    Fcnpj: string;
    Fpais: string;
    Fcontribuinte: string;
    Finscricaoestadual: string;
    Finscricaomunicipal: string;
    Fcidade: string;
    Fendereco: string;
    Fbairro: string;
    Fnumero: string;
    Fuf: string;
    Fcep: string;
    Fcomplemento: string;
    Fcelular: string;
    Ftelefone: string;
    Ftelefoneadicional: string;
    Fwebsite: string;
    Femail: string;
    Femailnfe: string;
    Fobscontato: string;
    Fcodigoregimetributario: string;
    Finscricaosuframa: string;
    Fobservacao: string;

    Fidpessoarelacionamento: Integer;
    Fidrelacionamento: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    property idcliente: Integer read Fidcliente write Fidcliente;
    property deletado: Integer read Fdeletado write Fdeletado;
    property nome: string read Fnome write Fnome;
    property fantasia: string read Ffantasia write Ffantasia;
    property codigo: string read Fcodigo write Fcodigo;
    property tipopessoa: Integer read Ftipopessoa write Ftipopessoa;
    property documento: string read Fdocumento write Fdocumento;

    property cpf: string read Fcpf write Fcpf;
    property rg: string read Frg write Frg;
    property cnpj: string read Fcnpj write Fcnpj;
    property pais: string read Fpais write Fpais;

    property contribuinte: string read Fcontribuinte write Fcontribuinte;
    property inscricaoestadual: string read Finscricaoestadual write Finscricaoestadual;
    property inscricaomunicipal: string read Finscricaomunicipal write Finscricaomunicipal;
    property cidade: string read Fcidade write Fcidade;
    property endereco: string read Fendereco write Fendereco;
    property bairro: string read Fbairro write Fbairro;
    property numero: string read Fnumero write Fnumero;
    property uf: string read Fuf write Fuf;
    property cep: string read Fcep write Fcep;
    property complemento: string read Fcomplemento write Fcomplemento;
    property celular: string read Fcelular write Fcelular;
    property telefone: string read Ftelefone write Ftelefone;
    property telefoneadicional: string read Ftelefoneadicional write Ftelefoneadicional;
    property website: string read Fwebsite write Fwebsite;
    property email: string read Femail write Femail;
    property emailnfe: string read Femailnfe write Femailnfe;
    property obscontato: string read Fobscontato write Fobscontato;

    property codigoregimetributario: string read Fcodigoregimetributario write Fcodigoregimetributario;
    property inscricaosuframa: string read Finscricaosuframa write Finscricaosuframa;
    property observacao: string read Fobservacao write Fobservacao;

    property idpessoarelacionamento: Integer read Fidpessoarelacionamento write Fidpessoarelacionamento;
    property idrelacionamento: Integer read Fidrelacionamento write Fidrelacionamento;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaloja(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;


  end;

implementation

{ TConfigempresafilial }

constructor TConfigempresafilial.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TConfigempresafilial.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;


function TConfigempresafilial.Editar(out erro: string): Boolean;
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
        SQL.Add('update admcliente set DELETADO =:DELETADO, NOME =:NOME,FANTASIA =:FANTASIA,CODIGO =:CODIGO,TIPOPESSOA =:TIPOPESSOA,DOCUMENTO =:DOCUMENTO, ');
        SQL.Add('CPF=:CPF,RG=:RG,CNPJ=:CNPJ,PAIS=:PAIS,INSCRICAOESTADUAL=:INSCRICAOESTADUAL,INSCRICAOMUNICIPAL =:INSCRICAOMUNICIPAL,ENDERECO =:ENDERECO,');
        SQL.Add('CONTRIBUINTE =:CONTRIBUINTE,BAIRRO =:BAIRRO,NUMERO=:NUMERO,');
        SQL.Add('CIDADE =:CIDADE,UF=:UF,CEP=:CEP,');
        SQL.Add('COMPLEMENTO =:COMPLEMENTO,CELULAR =:CELULAR,TELEFONE =:TELEFONE,TELEFONEADICIONAL=:TELEFONEADICIONAL,');
        SQL.Add('WEBSITE =:WEBSITE,CONTATOEMAIL =:EMAIL,EMAILNFE =:EMAILNFE,OBSERVACAO=:OBSERVACAO, ');
        SQL.Add('numero=:numero,codigoregimetributario=:codigoregimetributario,inscricaosuframa=:inscricaosuframa,');
        SQL.Add('observacao=:observacao ');
        SQL.Add('where IDCLIENTE =:IDCLIENTE');
        ParamByName('NOME').Value := NOME;

        if Length(fantasia) = 0 then
          ParamByName('fantasia').Value := nome
        else
          ParamByName('fantasia').Value := fantasia;

//      ParamByName('FANTASIA').Value := FANTASIA;
        ParamByName('CODIGO').Value := CODIGO;
        ParamByName('TIPOPESSOA').Value := TIPOPESSOA;
        ParamByName('DOCUMENTO').Value := DOCUMENTO;
        ParamByName('CPF').Value := CPF;
        ParamByName('RG').Value := RG;
        ParamByName('CNPJ').Value := CNPJ;
        ParamByName('PAIS').Value := PAIS;
        ParamByName('CONTRIBUINTE').Value := CONTRIBUINTE;
        ParamByName('INSCRICAOESTADUAL').Value := INSCRICAOESTADUAL;
        ParamByName('INSCRICAOMUNICIPAL').Value := INSCRICAOMUNICIPAL;
        ParamByName('CIDADE').Value := CIDADE;
        ParamByName('ENDERECO').Value := ENDERECO;
        ParamByName('BAIRRO').Value := BAIRRO;
        ParamByName('NUMERO').Value := NUMERO;
        ParamByName('UF').Value := UF;
        ParamByName('CEP').Value := CEP;
        ParamByName('COMPLEMENTO').Value := COMPLEMENTO;
        ParamByName('CELULAR').Value := CELULAR;
        ParamByName('TELEFONE').Value := TELEFONE;
        ParamByName('TELEFONEADICIONAL').Value := TELEFONEADICIONAL;
        ParamByName('WEBSITE').Value := WEBSITE;
        ParamByName('EMAIL').Value := EMAIL;
        ParamByName('EMAILNFE').Value := EMAILNFE;
        ParamByName('OBSCONTATO').Value := OBSCONTATO;
        ParamByName('codigoregimetributario').Value := codigoregimetributario;
        ParamByName('inscricaosuframa').Value := inscricaosuframa;
        ParamByName('observacao').Value := observacao;

        ParamByName('IDCLIENTE').Value := idcliente;
        //ParamByName('IDLOJA').Value := idloja;
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

function TConfigempresafilial.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('admcliente.idcliente as id, ');
      SQL.Add('admcliente.nome, ');
      SQL.Add('admcliente.rg, ');
      SQL.Add('admcliente.email, ');
      SQL.Add('admcliente.cidade, ');
      SQL.Add('admcliente.telefone, ');
      SQL.Add('admcliente.celular, ');
      SQL.Add('admcliente.uf ');
      SQL.Add('From ');
      SQL.Add('admcliente WHERE admcliente.idcliente is not null ');

      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          var rgBusca := StringReplace(AQuery.Items['busca'], '.', '', [rfReplaceAll]);
          rgBusca := StringReplace(rgBusca, '-', '', [rfReplaceAll]);

          SQL.Add('AND (admcliente.nome LIKE ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('OR REPLACE(REPLACE(admcliente.rg, ''.'', ''''), ''-'', '''') LIKE ''%' + rgBusca + '%'')');
        end;
      end;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND admcliente.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND admcliente.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
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

function TConfigempresafilial.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('admcliente WHERE admcliente.idcliente is not null and admcliente.idcliente =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idclientebusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND admcliente.deletado = :deletado');
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

function TConfigempresafilial.Listaloja(
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
      SQL.Add('admloja.idloja as id, ');
      SQL.Add('admloja.nome, ');
      SQL.Add('admloja.endereco, ');
      SQL.Add('admloja.numero, ');
      SQL.Add('admloja.complemento, ');
      SQL.Add('admloja.bairro, ');
      SQL.Add('admloja.cidade, ');
      SQL.Add('admloja.estado, ');
      SQL.Add('admloja.cep, ');
      SQL.Add('admloja.telefone, ');
      SQL.Add('admloja.celular, ');
      SQL.Add('admloja.email ');
      SQL.Add('From ');
      SQL.Add('admloja ');
      SQL.Add('WHERE admloja.idcliente is not null ');
      //pesquisar
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND admloja.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND admloja.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end
        else
        begin
          SQL.Add('AND admloja.idcliente = :idcliente');
          ParamByName('idcliente').Value := 0;
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


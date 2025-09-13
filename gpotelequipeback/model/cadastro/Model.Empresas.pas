unit Model.Empresas;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection, System.JSON,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections, REST.Types,
  RESTRequest4D, UtFuncao;

type
  TEmpresas = class
  private
    FConn: TFDConnection;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;

    Fidempresa: Integer;
    Fcnpj: string;
    Fnome: string;
    Ffantasia: string;
    Fporte: string;
    Fcnaep: string;
    Fcnaes: string;
    Fcodigodescricaoatividades: string;
    Fcodigodescricaonatureza: string;
    Flogradouro: string;
    Fcidade: string;
    Fnumero: string;
    Fcomplemento: string;
    Fcep: string;
    Ftipopj: string;
    FstatusTelequipe: string;
    Fbairro: string;
    Fuf: string;
    Fsituacaocadastral: string;
    Fpgr: string;
    Fpcmso: string;
    Fcontratos: string;
    Fnomeresponsavel: string;
    Ftelefone: string;
    Femail: string;
    Foutros: string;
    Foutrosdata: string;
    Foutros2: string;
    Foutros2data: string;
    Fidpessoa: Integer;
    Fcontrato: string;
    Fcnae1: string;
    Fcnae2: string;
    Fcnae3: string;
    Fcnae4: string;
    Fcnaedescricao1: string;
    Fcnaedescricao2: string;
    Fcnaedescricao3: string;
    Fcnaedescricao4: string;
  public
    constructor Create;
    destructor Destroy; override;

    property idempresa: Integer read Fidempresa write Fidempresa;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property cnpj: string read Fcnpj write Fcnpj;
    property nome: string read Fnome write Fnome;
    property fantasia: string read Ffantasia write Ffantasia;
    property porte: string read Fporte write Fporte;
    property cnaep: string read Fcnaep write Fcnaep;
    property cnaes: string read Fcnaes write Fcnaes;
    property codigodescricaoatividades: string read Fcodigodescricaoatividades write Fcodigodescricaoatividades;
    property codigodescricaonatureza: string read Fcodigodescricaonatureza write Fcodigodescricaonatureza;
    property logradouro: string read Flogradouro write Flogradouro;
    property cidade: string read Fcidade write Fcidade;
    property numero: string read Fnumero write Fnumero;
    property complemento: string read Fcomplemento write Fcomplemento;
    property cep: string read Fcep write Fcep;
    property bairro: string read Fbairro write Fbairro;
    property uf: string read Fuf write Fuf;
    property situacaocadastral: string read Fsituacaocadastral write Fsituacaocadastral;
    property pgr: string read Fpgr write Fpgr;
    property pcmso: string read Fpcmso write Fpcmso;
    property contratos: string read Fcontratos write Fcontratos;
    property nomeresponsavel: string read Fnomeresponsavel write Fnomeresponsavel;
    property telefone: string read Ftelefone write Ftelefone;
    property email: string read Femail write Femail;
    property outros: string read Foutros write Foutros;
    property outrosdata: string read Foutrosdata write Foutrosdata;
    property outros2: string read Foutros2 write Foutros2;
    property outros2data: string read Foutros2data write Foutros2data;
    property contrato: string read Fcontrato write Fcontrato;
    property idpessoa: Integer read Fidpessoa write Fidpessoa;
    property tipopj: string read Ftipopj write Ftipopj;
    property statusTelequipe: string read FstatusTelequipe write FstatusTelequipe;

    property cnae1: string read Fcnae1 write Fcnae1;
    property cnae2: string read Fcnae2 write Fcnae2;
    property cnae3: string read Fcnae3 write Fcnae3;
    property cnae4: string read Fcnae4 write Fcnae4;
    property cnaedescricao1: string read Fcnaedescricao1 write Fcnaedescricao1;
    property cnaedescricao2: string read Fcnaedescricao2 write Fcnaedescricao2;
    property cnaedescricao3: string read Fcnaedescricao3 write Fcnaedescricao3;
    property cnaedescricao4: string read Fcnaedescricao4 write Fcnaedescricao4;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function NovoCadastro(out erro: string): integer;
    function ListaSelectpj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaSelectpjforn(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function pesquisacnpj(const AQuery: TDictionary<string, string>; out erro: string): TJSONObject;
    function Listacolaborador(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editarcolaborador(out erro: string): Boolean;
    function Listaveiculo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
  end;

implementation

{ TEmpresas }

constructor TEmpresas.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TEmpresas.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TEmpresas.Editarcolaborador(out erro: string): Boolean;
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
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gespessoa set contrato=:contrato ');
          SQL.Add('where IDPESSOA=:IDPESSOA');
        end;
        ParamByName('contrato').AsString := contrato;
        ParamByName('idpessoa').AsInteger := IDPESSOA;
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

function TEmpresas.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesempresas WHERE gesempresas.idempresa is not null and gesempresas.idempresa =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idempresabusca'].ToInteger;
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

function TEmpresas.ListaSelectpj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
        if AQuery.ContainsKey('showinative') and (AQuery.Items['showinative'] = 'true') then
        begin
          SQL.Add('SELECT');
          SQL.Add('  gesempresas.idempresa AS value,');
          SQL.Add('  UPPER(CONCAT(');
          SQL.Add('    gesempresas.nome,');
          SQL.Add('    IF(gesempresas.statusTelequipe = ''INATIVO'' OR gesempresas.deletado <> ''0'',');
          SQL.Add('       '' - (Inativado)'', '''')');
          SQL.Add('  )) AS label,');
          SQL.Add('  gesempresas.email,');
          SQL.Add('  gesempresas.adicional');
          SQL.Add('FROM gesempresas');
          SQL.Add('WHERE gesempresas.deletado = ''0''');
          SQL.Add('ORDER BY gesempresas.nome;');
        end
        else
        begin
          SQL.Add('SELECT');
          SQL.Add('  gesempresas.idempresa AS value,');
          SQL.Add('  gesempresas.nome AS label,');
          SQL.Add('  gesempresas.email,');
          SQL.Add('  gesempresas.adicional');
          SQL.Add('FROM gesempresas');
          SQL.Add('WHERE gesempresas.status = ''ATIVO''');
          SQL.Add('  AND gesempresas.statusTelequipe = ''ATIVO''');
          SQL.Add('  AND gesempresas.deletado = ''0''');
          SQL.Add('ORDER BY gesempresas.nome;');
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


function TEmpresas.ListaSelectpjforn(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesempresas.idempresa as value, ');
      SQL.Add('gesempresas.nome as label, ');
      SQL.Add('gesempresas.email, ');
      SQL.Add('gesempresas.adicional ');
      SQL.Add('From ');
      SQL.Add('gesempresas where status = ''ATIVO'' and tipopj = ''FORNECEDOR'' order by  gesempresas.nome ');
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

function TEmpresas.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idempresas = idempresas+1 ');
        execsql;
        close;
        sql.Clear;
        sql.add('select idempresas from admponteiro  ');
        Open;
        idempresa := fieldbyname('idempresas').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idempresa;
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

function TEmpresas.pesquisacnpj(const AQuery: TDictionary<string, string>; out erro: string): TJSONObject;
var
  resp: IResponse;
begin
  resp := TRequest.New.BaseURL('https://www.receitaws.com.br/v1/cnpj').Resource(ApenasNumerosStr(cnpj)).Accept('application/json').Get;
  Result := TJSONObject.ParseJSONValue(resp.Content) as TJSONObject;
end;

function TEmpresas.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesempresas.idempresa as id, ');
      SQL.Add('gesempresas.* ');
      SQL.Add('From ');
      SQL.Add('gesempresas WHERE gesempresas.idempresa is not null ');
      //pesquisar
      if AQuery.ContainsKey('status1') then
      begin
        if Length(AQuery.Items['status1']) > 0 then
        begin
          if AQuery.Items['status1'] <> 'TODOS' then
          begin
            SQL.Add(' and gesempresas.statustelequipe =:status ');
            ParamByName('status').asstring := AQuery.Items['status1'];
          end;
        end
        else
        begin
            SQL.Add(' and gesempresas.statustelequipe =:status ');
            ParamByName('status').asstring := 'ATIVO';
        end;
      end;


     // SQL.Add('

      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          var rgBusca := StringReplace(AQuery.Items['busca'], '.', '', [rfReplaceAll]);
          rgBusca := StringReplace(rgBusca, '-', '', [rfReplaceAll]);

          SQL.Add('AND (gesempresas.nome LIKE ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('OR REPLACE(REPLACE(gesempresas.cnpj, ''.'', ''''), ''-'', '''') LIKE ''%' + rgBusca + '%'')');
        end;
      end;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesempresas.deletado = :deletado');
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

function TEmpresas.Listacolaborador(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select p.idpessoa as id, p.nome, p.contrato, p.status ');
      SQL.Add('From gespessoa p ');
      SQL.Add('Inner Join gesempresas e On e.idempresa = p.empresa ');
      SQL.Add('Where p.empresa = :empresa');
      if AQuery.ContainsKey('idempresabusca') then
      begin
        if Length(AQuery.Items['idempresabusca']) > 0 then
        begin
          ParamByName('empresa').asstring := AQuery.Items['idempresabusca'];
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

function TEmpresas.Editar(out erro: string): Boolean;
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
        sql.add('select idempresa from gesempresas where idempresa=:idempresa ');
        ParamByName('idempresa').Value := idempresa;
        Open;
        if RecordCount = 0 then
        begin
          Close;
          Active := False;
          SQL.Clear;
          SQL.Add('select 1 from gesempresas where cnpj = :cnpj');
          ParamByName('cnpj').Value := cnpj;
          Open;
          if not EOF then
          begin
            erro := 'Já existe uma empresa cadastrada com este Documento. Verifique antes de prosseguir.';
            FConn.Rollback;
            Result := False;
            Exit;
          end;
          Close;
          Active := false;
          sql.Clear;

          SQL.Add('INSERT INTO gesempresas(idempresa,cnpj,nome,fantasia,porte,cnaep,cnaes,');
          SQL.Add('codigodescricaonatureza,logradouro,outros,outrosdata,outros2,outros2data,');
          SQL.Add('cidade,numero,complemento,cep,bairro,uf,situacaocadastral,tipopj,statusTelequipe,');
          SQL.Add('pgr,pcmso,contratos,nomeresponsavel,telefone,email,');
          SQL.Add('DELETADO,cnae1,cnae2,cnae3,cnae4,cnaedescricao1,cnaedescricao2,cnaedescricao3,cnaedescricao4)');
          SQL.Add('               VALUES(:idempresa,:cnpj,:nome,:fantasia,:porte,:cnaep,:cnaes,');
          SQL.Add(':codigodescricaonatureza,:logradouro,:outros,:outrosdata,:outros2,:outros2data,');
          SQL.Add(':cidade,:numero,:complemento,:cep,:bairro,:uf,:situacaocadastral,:tipopj,:statusTelequipe,');
          SQL.Add(':pgr,:pcmso,:contratos,:nomeresponsavel,:telefone,:email,');
          SQL.Add(':DELETADO,:cnae1,:cnae2,:cnae3,:cnae4,:cnaedescricao1,:cnaedescricao2,:cnaedescricao3,:cnaedescricao4)');
        end
        else
        begin
          Close;
          Active := False;
          SQL.Clear;
          SQL.Add('select 1 from gesempresas where cnpj = :cnpj and idempresa <> :idempresa');
          ParamByName('cnpj').Value := cnpj;
          ParamByName('idempresa').Value := idempresa;
          Open;
          if not EOF then
          begin
            erro := 'Já existe uma empresa cadastrada com este Documento. Verifique antes de prosseguir.';
            FConn.Rollback;
            Result := False;
            Exit;
          end;
          Close;
          Active := false;
          sql.Clear;

          SQL.Add('update gesempresas set DELETADO =:DELETADO,idempresa=:idempresa,cnpj=:cnpj,nome=:nome,fantasia=:fantasia,porte=:porte,cnaep=:cnaep,cnaes=:cnaes ');
          SQL.Add(',codigodescricaonatureza=:codigodescricaonatureza,logradouro=:logradouro, ');
          SQL.Add('outros=:outros,outrosdata=:outrosdata,outros2=:outros2,outros2data=:outros2data, ');
          SQL.Add('cidade=:cidade,numero=:numero,complemento=:complemento,cep=:cep,bairro=:bairro,uf=:uf,situacaocadastral=:situacaocadastral, ');
          SQL.Add('pgr=:pgr,pcmso=:pcmso,contratos=:contratos,nomeresponsavel=:nomeresponsavel,telefone=:telefone,email=:email, ');
          SQL.Add('cnae1=:cnae1,cnae2=:cnae2,cnae3=:cnae3,cnae4=:cnae4,cnaedescricao1=:cnaedescricao1,cnaedescricao2=:cnaedescricao2,');
          SQL.Add('cnaedescricao3=:cnaedescricao3,cnaedescricao4=:cnaedescricao4,tipopj=:tipopj,statusTelequipe=:statusTelequipe');
          SQL.Add('where idempresa=:idempresa');
        end;
        ParamByName('idempresa').AsInteger := idempresa;
        ParamByName('cnpj').Value := cnpj;
        ParamByName('nome').Value := nome;

        if Length(fantasia) = 0 then
          ParamByName('fantasia').Value := nome
        else
          ParamByName('fantasia').Value := fantasia;

        ParamByName('porte').Value := porte;
        ParamByName('tipopj').Value := tipopj;
        ParamByName('statusTelequipe').Value := statusTelequipe;
        ParamByName('cnaep').Value := cnaep;
        ParamByName('cnaes').Value := cnaes;
        ParamByName('codigodescricaonatureza').Value := codigodescricaonatureza;
        ParamByName('logradouro').Value := logradouro;
        ParamByName('cidade').Value := cidade;
        ParamByName('numero').Value := numero;
        ParamByName('complemento').Value := complemento;
        ParamByName('cep').Value := cep;
        ParamByName('bairro').Value := bairro;
        ParamByName('uf').Value := uf;
        ParamByName('situacaocadastral').Value := situacaocadastral;
        ParamByName('pgr').Value := pgr;
        ParamByName('pcmso').Value := pcmso;
        ParamByName('contratos').Value := contratos;
        ParamByName('nomeresponsavel').Value := nomeresponsavel;
        ParamByName('telefone').Value := telefone;

        ParamByName('outros').Value := outros;

        if outrosdata = '' then
          ParamByName('outrosdata').value := '1899-12-30'
        else
          ParamByName('outrosdata').Value := outrosdata;

        ParamByName('outros2').Value := outros2;

        if outros2data = '' then
          ParamByName('outros2data').value := '1899-12-30'
        else
          ParamByName('outros2data').Value := outros2data;

        ParamByName('email').Value := email;
        ParamByName('cnae1').Value := cnae1;
        ParamByName('cnae2').Value := cnae2;
        ParamByName('cnae3').Value := cnae3;
        ParamByName('cnae4').Value := cnae4;
        ParamByName('cnaedescricao1').Value := cnaedescricao1;
        ParamByName('cnaedescricao2').Value := cnaedescricao2;
        ParamByName('cnaedescricao3').Value := cnaedescricao3;
        ParamByName('cnaedescricao4').Value := cnaedescricao4;
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

function TEmpresas.Listaveiculo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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

      SQL.Add('Select');
      SQL.Add('gesveiculos.idveiculo as id,');
      SQL.Add('gesveiculos.MODELO,');
      SQL.Add('gesveiculos.COR,');
      SQL.Add('gesveiculos.PLACA,');
      SQL.Add('gesveiculos.MARCA,');
      SQL.Add('gesveiculos.status as ativo,');
      SQL.Add('gespessoa.nome as funcionario');
      SQL.Add('From');
      SQL.Add('gesveiculos left join');
      SQL.Add('gespessoa On gespessoa.idpessoa = gesveiculos.idpessoa ');
      SQL.Add('Where idempresa=:idempresa and');
      SQL.Add('gesveiculos.idveiculo is not null');

      a := AQuery.Items['idempresabusca'];
      if AQuery.ContainsKey('idempresabusca') then
      begin
        if Length(AQuery.Items['idempresabusca']) > 0 then
        begin
          ParamByName('idempresa').asstring := AQuery.Items['idempresabusca'];
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


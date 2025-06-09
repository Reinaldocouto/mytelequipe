unit Model.Pessoa;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Param, Data.DB, System.SysUtils,
  model.connection, System.StrUtils, System.Classes, FireDAC.DApt,
  System.DateUtils,   System.Generics.Collections, Horse, System.JSON,
  DataSet.Serialize, UtFuncao, Controller.Auth;

type
  TPessoa = class
  private
    FConn: TFDConnection;
    Fidpessoa: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;

    Fnome: string;
    Ftipopessoa: string;
    Fregional: string;
    Fcadastro: string;
    Fnregistro: string;
    Fdataadmissao: string;
    Fdatademissao: string;
    Fmatriculaesocial: string;
    Fcbo: string;
    Fidempresa: string;
    Fcargo: string;
    Femail: string;
    Ftelefone: string;
    Femailcorporativo: string;
    Ftelefonecorporativo: string;
    Fcor: string;
    Fsexo: string;
    Fdatanascimento: string;
    Festadocivil: string;
    Fnaturalidade: string;
    Fnacionalidade: string;
    Fnomepai: string;
    Fnomemae: string;
    Fnfilho: Integer;
    Fcep: string;
    Fendereco: string;
    Fnumero: string;
    Fcomplemento: string;
    Fbairro: string;
    Fmunicipio: string;
    Festado: string;
    Frgrne: string;
    Forgaoemissor: string;
    Fdataemissao: string;
    Fcpf: string;
    Ftituloeleitor: string;
    Fpis: string;
    Fctps: string;
    Fdatactps: string;
    Freservista: string;
    Fcnh: string;
    Fdatavalidadecnh: string;
    Fcategoriacnh: string;
    Fprimhabilitacao: string;
    Fescolaridade: string;
    Ftipocurso: string;
    Ftipograduacao: string;
    Fdatacadastro: string;
    Freativacao: string;
    Fidericsson: string;
    Fidisignum: string;
    Fidhuawei: string;
    Fidzte: string;
    Fsenhahuawei: string;
    Finativacao: string;
    Fsenhazte: string;
    Fstatus: string;
    Fduracaotreinamento: Integer;
    Fdescricaotreinamento: string;
    Fchecericsson: integer;
    Fchechuawei: integer;
    Fcheczte: integer;
    Fchecknokia: integer;
    Fchecoutros: integer;
    Fespecificaroutros: string;
    Fidtreinamento: integer;
    Fdataemissaotreinamento: string;
    Fdatavencimentotreinamento: string;
    Fstatustreinamento: string;
    Fvalorhora: Real;
    Fsalariobruto: Real;
    Ffator: Real;
    Fhorasmes: Real;
    Fobservacao: string;
    Fmei: string;
    Freset90: string;
    FisOnlyCnh: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    property idpessoa: Integer read Fidpessoa write Fidpessoa;
    property isOnlyCnh: Integer read FisOnlyCnh write FisOnlyCnh;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;

    property nome: string read Fnome write Fnome;
    property tipopessoa: string read Ftipopessoa write Ftipopessoa;
    property regional: string read Fregional write Fregional;
    property cadastro: string read Fcadastro write Fcadastro;
    property nregistro: string read Fnregistro write Fnregistro;
    property dataadmissao: string read Fdataadmissao write Fdataadmissao;
    property datademissao: string read Fdatademissao write Fdatademissao;
    property matriculaesocial: string read Fmatriculaesocial write Fmatriculaesocial;
    property cbo: string read Fcbo write Fcbo;
    property idempresa: string read Fidempresa write Fidempresa;
    property cargo: string read Fcargo write Fcargo;
    property email: string read Femail write Femail;
    property telefone: string read Ftelefone write Ftelefone;
    property emailcorporativo: string read Femailcorporativo write Femailcorporativo;
    property telefonecorporativo: string read Ftelefonecorporativo write Ftelefonecorporativo;
    property cor: string read Fcor write Fcor;
    property sexo: string read Fsexo write Fsexo;
    property datanascimento: string read Fdatanascimento write Fdatanascimento;
    property estadocivil: string read Festadocivil write Festadocivil;
    property naturalidade: string read Fnaturalidade write Fnaturalidade;
    property nacionalidade: string read Fnacionalidade write Fnacionalidade;
    property nomepai: string read Fnomepai write Fnomepai;
    property nomemae: string read Fnomemae write Fnomemae;
    property nfilho: integer read Fnfilho write Fnfilho;
    property cep: string read Fcep write Fcep;
    property endereco: string read Fendereco write Fendereco;
    property numero: string read Fnumero write Fnumero;
    property complemento: string read Fcomplemento write Fcomplemento;
    property bairro: string read Fbairro write Fbairro;
    property municipio: string read Fmunicipio write Fmunicipio;
    property estado: string read Festado write Festado;
    property rgrne: string read Frgrne write Frgrne;
    property orgaoemissor: string read Forgaoemissor write Forgaoemissor;
    property dataemissao: string read Fdataemissao write Fdataemissao;
    property cpf: string read Fcpf write Fcpf;
    property tituloeleitor: string read Ftituloeleitor write Ftituloeleitor;
    property pis: string read Fpis write Fpis;
    property ctps: string read Fctps write Fctps;
    property datactps: string read Fdatactps write Fdatactps;
    property reservista: string read Freservista write Freservista;
    property cnh: string read Fcnh write Fcnh;
    property datavalidadecnh: string read Fdatavalidadecnh write Fdatavalidadecnh;
    property categoriacnh: string read Fcategoriacnh write Fcategoriacnh;
    property primhabilitacao: string read Fprimhabilitacao write Fprimhabilitacao;
    property escolaridade: string read Fescolaridade write Fescolaridade;
    property tipocurso: string read Ftipocurso write Ftipocurso;
    property tipograduacao: string read Ftipograduacao write Ftipograduacao;
    property datacadastro: string read fdatacadastro write fdatacadastro;
    property reativacao: string read freativacao write freativacao;
    property idericsson: string read fidericsson write fidericsson;
    property idisignum: string read fidisignum write fidisignum;
    property idhuawei: string read fidhuawei write fidhuawei;
    property idzte: string read fidzte write fidzte;
    property senhahuawei: string read fsenhahuawei write fsenhahuawei;
    property inativacao: string read finativacao write finativacao;
    property senhazte: string read fsenhazte write fsenhazte;
    property status: string read fstatus write fstatus;

    property checericsson: Integer read Fchecericsson write Fchecericsson;
    property chechuawei: Integer read Fchechuawei write Fchechuawei;
    property checzte: Integer read Fcheczte write Fcheczte;
    property checknokia: Integer read Fchecknokia write Fchecknokia;
    property checoutros: Integer read Fchecoutros write Fchecoutros;
    property especificaroutros: string read Fespecificaroutros write Fespecificaroutros;
    property descricaotreinamento: string read Fdescricaotreinamento write Fdescricaotreinamento;
    property valorhora: Real read Fvalorhora write Fvalorhora;
    property salariobruto: Real read Fsalariobruto write Fsalariobruto;
    property fator: Real read Ffator write Ffator;
    property horasmes: Real read Fhorasmes write Fhorasmes;

    property observacao: string read Fobservacao write Fobservacao;
    property mei: string read Fmei write Fmei;
    property reset90: string read Freset90 write Freset90;

    property idtreinamento: Integer read Fidtreinamento write Fidtreinamento;
    property duracaotreinamento: Integer read Fduracaotreinamento write Fduracaotreinamento;
    property dataemissaotreinamento: string read Fdataemissaotreinamento write Fdataemissaotreinamento;
    property datavencimentotreinamento: string read Fdatavencimentotreinamento write Fdatavencimentotreinamento;
    property statustreinamento: string read Fstatustreinamento write Fstatustreinamento;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaSelect(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaSelectpj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaSelectclt(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listatreinamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listatreinamentolista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function AtualizarTreinamento(const AQuery: TDictionary<string, string>; out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
    function EditarUpload(body: TJSONArray; out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;
    function ListaSelectfuncionario(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaSelectcolaboradorclt(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;

    //function Listatiporelacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    //function Listarelacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listacurso(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Salvatreinamento(out erro: string): Boolean;
    //function salvacurso(out erro: string): Boolean;
    //function Pesquisarelacionamentovazio: Boolean;
    function Cadastratreinamento(out erro: string): Boolean;
    function Listatreinamentogeral(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;

  end;

implementation

{ TPessoa }

function TPessoa.Cadastratreinamento(out erro: string): Boolean;
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
        sql.add('select id from treinamento where id=:id ');
        ParamByName('id').Value := idtreinamento;
        open;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO treinamento(descricao, duracao)');
          SQL.Add('                values(:descricao,:duracao)');
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update treinamento set descricao=:descricao, duracao=:duracao where id=:id');
          ParamByName('id').Value := idtreinamento;
        end;
        ParamByName('descricao').asstring := descricaotreinamento;
        ParamByName('duracao').asinteger := duracaotreinamento;
        execsql;

      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao cadastrar treinamento: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

constructor TPessoa.Create;
begin
  inherited;
  FConn := TConnection.CreateConnection;
   FConn.ResourceOptions.AutoConnect := True;
end;

destructor TPessoa.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;

  inherited;
  FConn := nil;
  inherited;
end;

function TPessoa.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idpessoa = idpessoa+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idpessoa from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idpessoa := fieldbyname('idpessoa').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idpessoa;
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

function TPessoa.Salvatreinamento(out erro: string): Boolean;
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
        sql.add('select idtreinamento from gestreinamento where idpessoa=:idpessoa and idtreinamento=:idtreinamento  ');
        ParamByName('idpessoa').Value := idpessoa;
        ParamByName('idtreinamento').Value := idtreinamento;
        open;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO gestreinamento(idtreinamento, idpessoa, dataemissao, datavencimento, statustreinamento)');
          SQL.Add('                   values(:idtreinamento,:idpessoa,:dataemissao,:datavencimento, :statustreinamento)');
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gestreinamento set dataemissao=:dataemissao, datavencimento=:datavencimento, statustreinamento=:statustreinamento where idtreinamento=:idtreinamento and idpessoa=:idpessoa');
        end;
        if dataemissaotreinamento = '' then
          ParamByName('dataemissao').value := StrToDate('30/12/1899')
        else
          ParamByName('dataemissao').value := dataemissaotreinamento;

        if datavencimentotreinamento = '' then
          ParamByName('datavencimento').value := StrToDate('30/12/1899')
        else
          ParamByName('datavencimento').value := datavencimentotreinamento;

        if statustreinamento = '' then
          ParamByName('statustreinamento').value := ''
        else
          ParamByName('statustreinamento').value := statustreinamento;

        ParamByName('idtreinamento').Value := idtreinamento;
        ParamByName('idpessoa').Value := idpessoa;
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


function TPessoa.Editar(out erro: string): Boolean;
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
        sql.add('select idpessoa from gespessoa where idpessoa=:idpessoa  ');
        ParamByName('idpessoa').Value := idpessoa;
        open;
        if RecordCount = 0 then
        begin

          Active := false;
          sql.Clear;
          sql.add('select * from gespessoa where cpf=:cpf and deletado = 0 ');
          ParamByName('cpf').Value := cpf;
          open;
          if RecordCount = 0 then
          begin

            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO gespessoa(IDPESSOA,nome,tipopessoa,regional,nregistro,dataadmissao,datademissao,matriculaesocial,cbo,');
            SQL.Add('cargo,email,telefone,emailcorporativo,telefonecorporativo,cor,sexo,datanascimento,estadocivil,naturalidade,');
            SQL.Add('nacionalidade,nomepai,nomemae,nfilho,cep,endereco,numero,complemento,bairro,municipio,estado,rgrne,orgaoemissor,');
            SQL.Add('dataemissao,cpf,tituloeleitor,pis,ctps,datactps,reservista,cnh,datavalidadecnh,categoriacnh,primhabilitacao,');
            SQL.Add('escolaridade,tipocurso,tipograduacao,cadastro,empresa,DELETADO,checericsson,chechuawei,checzte,checknokia,checoutros,especificaroutros,');
            SQL.Add('datacadastro,inativacao,reativacao,idericsson,idisignum,idhuawei,senhahuawei,idzte,valorhora,salariobruto,fator,horasmes,observacao,mei,reset90,status)');
            SQL.Add('               VALUES(:IDPESSOA,:nome,:tipopessoa,:regional,:nregistro,:dataadmissao,:datademissao,:matriculaesocial,:cbo,');
            SQL.Add(':cargo,:email,:telefone,:emailcorporativo,:telefonecorporativo,:cor,:sexo,:datanascimento,:estadocivil,:naturalidade,');
            SQL.Add(':nacionalidade,:nomepai,:nomemae,:nfilho,:cep,:endereco,:numero,:complemento,:bairro,:municipio,:estado,:rgrne,:orgaoemissor,');
            SQL.Add(':dataemissao,:cpf,:tituloeleitor,:pis,:ctps,:datactps,:reservista,:cnh,:datavalidadecnh,:categoriacnh,:primhabilitacao,');
            SQL.Add(':escolaridade,:tipocurso,:tipograduacao,:cadastro,:empresa,:DELETADO,:checericsson,:chechuawei,:checzte,:checknokia,:checoutros,:especificaroutros,');
            SQL.Add(':datacadastro,:inativacao,:reativacao,:idericsson,:idisignum,:idhuawei,:senhahuawei,:idzte,:valorhora,:salariobruto,:fator,:horasmes,:observacao,:mei,:reset90,:status)');
          end
          else
          begin
            FConn.Rollback;
            erro := 'Erro ao cadastrar cliente: CPF ja existe no cadastro ';
            Result := false;
            exit
          end;
        end
        else
        begin

          Active := false;
          sql.Clear;
          sql.add('select * from gespessoa where cpf=:cpf and deletado = 0 ');
          ParamByName('cpf').Value := cpf;
          open;
          if ((RecordCount = 1) or (RecordCount = 0)) then
          begin
            Active := false;
            sql.Clear;
            SQL.Add('update gespessoa set DELETADO=:DELETADO,nome=:nome,tipopessoa=:tipopessoa,regional=:regional,nregistro=:nregistro,dataadmissao=:dataadmissao, ');
            SQL.Add('datademissao=:datademissao,matriculaesocial=:matriculaesocial,cbo=:cbo,cargo=:cargo,email=:email,telefone=:telefone,emailcorporativo=:emailcorporativo,');
            SQL.Add('telefonecorporativo=:telefonecorporativo,cor=:cor,sexo=:sexo,datanascimento=:datanascimento,estadocivil=:estadocivil,naturalidade=:naturalidade,');
            SQL.Add('nacionalidade=:nacionalidade,nomepai=:nomepai,nomemae=:nomemae,nfilho=:nfilho,cep=:cep,endereco=:endereco,numero=:numero,complemento=:complemento,');
            SQL.Add('bairro=:bairro,municipio=:municipio,estado=:estado,rgrne=:rgrne,orgaoemissor=:orgaoemissor,dataemissao=:dataemissao,cpf=:cpf,tituloeleitor=:tituloeleitor,');
            SQL.Add('pis=:pis,ctps=:ctps,datactps=:datactps,reservista=:reservista,cnh=:cnh,datavalidadecnh=:datavalidadecnh,categoriacnh=:categoriacnh,status=:status, ');
            SQL.Add('primhabilitacao=:primhabilitacao,escolaridade=:escolaridade,tipocurso=:tipocurso,tipograduacao=:tipograduacao,cadastro=:cadastro,empresa=:empresa,');
            SQL.Add('checericsson=:checericsson,chechuawei=:chechuawei,checzte=:checzte,checknokia=:checknokia,checoutros=:checoutros,especificaroutros=:especificaroutros, ');
            SQL.Add('datacadastro=:datacadastro,inativacao=:inativacao,reativacao=:reativacao,idericsson=:idericsson,valorhora=:valorhora,salariobruto=:salariobruto,');
            SQL.Add('idisignum=:idisignum,idhuawei=:idhuawei,senhahuawei=:senhahuawei,idzte=:idzte,fator=:fator,horasmes=:horasmes,observacao=:observacao, mei=:mei,reset90=:reset90 ');
            SQL.Add('where IDPESSOA=:IDPESSOA');
          end
          else
          begin
            FConn.Rollback;
            erro := 'Erro ao cadastrar cliente: CPF ja existe em outro cadastro ';
            Result := false;
            exit
          end;
        end;
        try
          if ((datacadastro = '') or (datacadastro = '-') or (datacadastro = '1899-12-30T00:00:00.000Z')) then
            ParamByName('datacadastro').value := StrToDate('30/12/1899')
          else
            ParamByName('datacadastro').value := StrToDate(datacadastro);
        except
          ParamByName('datacadastro').AsDateTime := ISO8601ToDate(datacadastro);

        end;

        try
          if ((inativacao = '') or (inativacao = '-') or (inativacao = '1899-12-30T00:00:00.000Z')) then
            ParamByName('inativacao').value := StrToDate('30/12/1899')
          else
            ParamByName('inativacao').value := StrToDate(inativacao);
        except
          ParamByName('inativacao').AsDateTime := ISO8601ToDate(inativacao);
        end;

        try
          if ((reativacao = '') or (reativacao = '-') or (reativacao = '1899-12-30T00:00:00.000Z')) then
            ParamByName('reativacao').value := StrToDate('30/12/1899')
          else
            ParamByName('reativacao').value := StrToDate(reativacao);
        except
          ParamByName('reativacao').AsDateTime := ISO8601ToDate(reativacao);
        end;

        ParamByName('idericsson').AsString := idericsson;
        ParamByName('idisignum').AsString := idisignum;
        ParamByName('idhuawei').AsString := idhuawei;
        ParamByName('senhahuawei').AsString := senhahuawei;
        ParamByName('idzte').AsString := idzte;

        ParamByName('idpessoa').AsInteger := IDPESSOA;
        ParamByName('nome').Value := nome;
        ParamByName('tipopessoa').Value := tipopessoa;
        ParamByName('regional').Value := regional;
        ParamByName('nregistro').Value := nregistro;

        try
          if ((dataadmissao = '') or (dataadmissao = '-')) then
            ParamByName('dataadmissao').value := StrToDate('30/12/1899')
          else
            ParamByName('dataadmissao').Value := StrToDate(dataadmissao);
        except
          ParamByName('dataadmissao').AsDateTime := ISO8601ToDate(dataadmissao);
        end;
        try
          if ((datademissao = '') or (datademissao = '-') or (datademissao = '1899-12-30T00:00:00.000Z')) then
            ParamByName('datademissao').value := StrToDate('30/12/1899')
          else
            ParamByName('datademissao').Value := StrToDate(datademissao);
        except
          ParamByName('datademissao').AsDateTime := ISO8601ToDate(datademissao);
        end;

        try
          if ((reset90 = '') or (reset90 = '-') or (reset90 = '1899-12-30T00:00:00.000Z')) then
            ParamByName('reset90').value := StrToDate('30/12/1899')
          else
            ParamByName('reset90').value := StrToDate(reset90);
        except
          ParamByName('reset90').AsDateTime := ISO8601ToDate(reset90);
        end;

        ParamByName('matriculaesocial').Value := matriculaesocial;
        ParamByName('cbo').Value := cbo;
        ParamByName('cargo').Value := cargo;
        ParamByName('email').Value := email;
        ParamByName('telefone').Value := telefone;
        ParamByName('emailcorporativo').Value := emailcorporativo;
        ParamByName('telefonecorporativo').Value := telefonecorporativo;
        ParamByName('cor').Value := cor;
        ParamByName('sexo').Value := sexo;

        try
          if ((datanascimento = '') or (datanascimento = '-') or (datanascimento = '1899-12-30T00:00:00.000Z')) then
            ParamByName('datanascimento').value := StrToDate('30/12/1899')
          else
            ParamByName('datanascimento').Value := StrToDate(datanascimento);
        except
          ParamByName('datanascimento').AsDateTime := ISO8601ToDate(datanascimento);
        end;

        ParamByName('estadocivil').Value := estadocivil;
        ParamByName('naturalidade').Value := naturalidade;
        ParamByName('nacionalidade').Value := nacionalidade;
        ParamByName('nomepai').Value := nomepai;
        ParamByName('nomemae').Value := nomemae;
        ParamByName('nfilho').Value := nfilho;
        ParamByName('cep').Value := cep;
        ParamByName('endereco').Value := endereco;
        ParamByName('numero').Value := numero;
        ParamByName('complemento').Value := complemento;
        ParamByName('bairro').Value := bairro;
        ParamByName('municipio').Value := municipio;
        ParamByName('estado').Value := estado;
        ParamByName('rgrne').Value := rgrne;
        ParamByName('orgaoemissor').Value := orgaoemissor;

        try
          if ((dataemissao = '') or (dataemissao = '-') or (dataemissao = '1899-12-30T00:00:00.000Z')) then
            ParamByName('dataemissao').value := StrToDate('30/12/1899')
          else
            ParamByName('dataemissao').Value := StrToDate(dataemissao);
        except
          ParamByName('dataemissao').AsDateTime := ISO8601ToDate(dataemissao);
        end;

        ParamByName('cpf').Value := cpf;
        ParamByName('tituloeleitor').Value := tituloeleitor;
        ParamByName('pis').Value := pis;
        ParamByName('ctps').Value := ctps;
        try
          if ((datactps = '') or (datactps = '-') or (datactps = '1899-12-30T00:00:00.000Z')) then
            ParamByName('datactps').value := StrToDate('30/12/1899')
          else
            ParamByName('datactps').Value := StrToDate(datactps);
        except
          ParamByName('datactps').AsDateTime := ISO8601ToDate(datactps);
        end;
        ParamByName('reservista').Value := reservista;
        ParamByName('cnh').Value := cnh;

        try
          if ((datavalidadecnh = '') or (datavalidadecnh = '-') or (datavalidadecnh = '1899-12-30T00:00:00.000Z')) then
            ParamByName('datavalidadecnh').value := StrToDate('30/12/1899')
          else
            ParamByName('datavalidadecnh').Value := StrToDate(datavalidadecnh);
        except
          ParamByName('datavalidadecnh').AsDateTime := ISO8601ToDate(datavalidadecnh);
        end;

        ParamByName('categoriacnh').Value := categoriacnh;

        try
          if ((primhabilitacao = '') or (primhabilitacao = '-') or (primhabilitacao = '1899-12-30T00:00:00.000Z')) then
            ParamByName('primhabilitacao').value := StrToDate('30/12/1899')
          else
            ParamByName('primhabilitacao').Value := StrToDate(primhabilitacao);
        except
          ParamByName('primhabilitacao').AsDateTime := ISO8601ToDate(primhabilitacao);
        end;
        ParamByName('escolaridade').Value := escolaridade;
        ParamByName('tipocurso').Value := tipocurso;
        ParamByName('status').Value := status;
        ParamByName('tipograduacao').Value := tipograduacao;
        ParamByName('cadastro').Value := cadastro;
        ParamByName('empresa').Value := idempresa;
        ParamByName('DELETADO').Value := 0;

        ParamByName('checericsson').Value := checericsson;
        ParamByName('chechuawei').Value := chechuawei;
        ParamByName('checzte').Value := checzte;
        ParamByName('checknokia').Value := checknokia;
        ParamByName('checoutros').Value := checoutros;
        ParamByName('especificaroutros').Value := especificaroutros;

        ParamByName('valorhora').Value := valorhora;
        ParamByName('salariobruto').Value := salariobruto;
        ParamByName('fator').Value := fator;
        ParamByName('horasmes').Value := horasmes;
        ParamByName('observacao').Value := observacao;
        ParamByName('mei').Value := mei;
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

function TPessoa.EditarUpload(body: TJSONArray; out erro: string): Boolean;
var
  qry: TFDQuery;
  id: Integer;
  DataStr: string;
  DataConvertida: TDateTime;
  FS: TFormatSettings;
  JSONItem: TJSONValue;
   pessoa: TPessoa;
procedure AtribuirDataOuPadrao(const NomeParametro, ValorData: string; Query: TFDQuery; const FS: TFormatSettings);
var
  DataConvertida: TDateTime;
  DataStr: string;
begin
  // Define explicitamente o tipo do parâmetro como ftDate
  Query.ParamByName(NomeParametro).DataType := ftDate;

  // Trata valores vazios ou inválidos
  if (Trim(ValorData) = '') or (ValorData = '-') or
     (ValorData = '1899-12-30T00:00:00.000Z') or
     (ValorData = '30/12/1899') then
  begin
    Query.ParamByName(NomeParametro).AsDate := EncodeDate(1899, 12, 30);
    Exit;
  end;

  // Trata datas em formato ISO8601
  if Pos('T', ValorData) > 0 then
  begin
    try
      DataConvertida := ISO8601ToDate(ValorData);
      Query.ParamByName(NomeParametro).AsDate := DataConvertida;
      Exit;
    except
      on E: Exception do
        raise Exception.CreateFmt('Erro ao converter data ISO8601 "%s": %s', [ValorData, E.Message]);
    end;
  end;

  // Remove espaços e caracteres inválidos
  DataStr := Trim(StringReplace(StringReplace(ValorData, #13, '', [rfReplaceAll]), #10, '', [rfReplaceAll]));

  // Tenta converter a data usando o formato especificado
  if TryStrToDate(DataStr, DataConvertida, FS) then
  begin
    Query.ParamByName(NomeParametro).AsDate := DataConvertida;
    Exit;
  end;

  // Se chegou aqui, tenta outros formatos comuns
  if TryStrToDate(DataStr, DataConvertida) then
  begin
    Query.ParamByName(NomeParametro).AsDate := DataConvertida;
    Exit;
  end;

  // Se nenhuma conversão funcionou, usa a data padrão
  Query.ParamByName(NomeParametro).AsDate := EncodeDate(1899, 12, 30);
end;

begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    FS := TFormatSettings.Create;
    FS.DateSeparator := '-';
    FS.ShortDateFormat := 'dd-mm-yyyy';
    FS.LongDateFormat := 'dd-mm-yyyy';

    try
      FConn.StartTransaction;
        for JSONItem in body do
      begin
        pessoa := TPessoa.Create;
        try
          idpessoa := JSONItem.GetValue<integer>('idpessoa', 0);
          cpf := JSONItem.getvalue<string>('cpf', '');
          nome := JSONItem.GetValue<string>('nome', '');
          tipopessoa := JSONItem.GetValue<string>('tipopessoa', '');
          regional := JSONItem.GetValue<string>('regional', '');
          cadastro := JSONItem.GetValue<string>('cadastro', '');
          nregistro := JSONItem.GetValue<string>('nregistro', '');
          dataadmissao := JSONItem.GetValue<string>('dataadmissao', '');
          datademissao := JSONItem.GetValue<string>('datademissao', '');
          matriculaesocial := JSONItem.GetValue<string>('matriculaesocial', '');
          cbo := JSONItem.GetValue<string>('cbo', '');
          idempresa := JSONItem.GetValue<string>('idempresa', '');
          cargo := JSONItem.GetValue<string>('cargo', '');
          email := JSONItem.GetValue<string>('email', '');
          telefone := JSONItem.GetValue<string>('telefone', '');
          emailcorporativo := JSONItem.GetValue<string>('emailcorporativo', '');
          telefonecorporativo := JSONItem.GetValue<string>('telefonecorporativo', '');
          cor := JSONItem.GetValue<string>('cor', '');
          sexo := JSONItem.GetValue<string>('sexo', '');
          datanascimento := JSONItem.GetValue<string>('datanascimento', '');


          estadocivil := JSONItem.GetValue<string>('estadocivil', '');
          naturalidade := JSONItem.GetValue<string>('naturalidade', '');
          nacionalidade := JSONItem.GetValue<string>('nacionalidade', '');
          nomepai := JSONItem.GetValue<string>('nomepai', '');
          nomemae := JSONItem.GetValue<string>('nomemae', '');
          observacao := JSONItem.GetValue<string>('observacao', '');
          mei := JSONItem.GetValue<string>('mei', '');
          reset90 := JSONItem.GetValue<string>('reset90', '');

          cep := JSONItem.getvalue<string>('cep', '');
          endereco := JSONItem.getvalue<string>('endereco', '');
          numero := JSONItem.getvalue<string>('numero', '');
          complemento := JSONItem.getvalue<string>('complemento', '');
          bairro := JSONItem.getvalue<string>('bairro', '');
          municipio := JSONItem.getvalue<string>('municipio', '');
          estado := JSONItem.getvalue<string>('estado', '');
          rgrne := JSONItem.getvalue<string>('rgrne', '');
          orgaoemissor := JSONItem.getvalue<string>('orgaoemissor', '');
          dataemissao := JSONItem.getvalue<string>('dataemissao', '');
          tituloeleitor := JSONItem.getvalue<string>('tituloeleitor', '');
          pis := JSONItem.getvalue<string>('pis', '');
          ctps := JSONItem.getvalue<string>('ctps', '');
          datactps := JSONItem.getvalue<string>('datactps', '');
          reservista := JSONItem.getvalue<string>('reservista', '');
          cnh := JSONItem.getvalue<string>('cnh', '');
          datavalidadecnh := JSONItem.getvalue<string>('datavalidadecnh', '');
          categoriacnh := JSONItem.getvalue<string>('categoriacnh', '');
          primhabilitacao := JSONItem.getvalue<string>('primhabilitacao', '');
          escolaridade := JSONItem.getvalue<string>('escolaridade', '');
          tipocurso := JSONItem.getvalue<string>('tipocurso', '');
          tipograduacao := JSONItem.getvalue<string>('tipograduacao', '');

          datacadastro := JSONItem.getvalue<string>('datacadastro', '');
          reativacao := JSONItem.getvalue<string>('reativacao', '');
          idericsson := JSONItem.getvalue<string>('idericsson', '');
          idisignum := JSONItem.getvalue<string>('idisignum', '');
          idhuawei := JSONItem.getvalue<string>('idhuawei', '');
          idzte := JSONItem.getvalue<string>('idzte', '');
          senhahuawei := JSONItem.getvalue<string>('senhahuawei', '');
          inativacao := JSONItem.getvalue<string>('inativacao', '');
          senhazte := JSONItem.getvalue<string>('senhazte', '');
          status := JSONItem.getvalue<string>('status', '');

          valorhora := JSONItem.getvalue<real>('valorhora', 0);
          salariobruto := JSONItem.getvalue<real>('salariobruto', 0);
          fator := JSONItem.getvalue<real>('fator', 0);
          horasmes := JSONItem.getvalue<real>('horasmes', 0);
          if strisint(JSONItem.GetValue<string>('nfilho', '')) then
            nfilho := JSONItem.GetValue<integer>('nfilho', 0)
          else
            nfilho := 0;

          if JSONItem.GetValue<boolean>('checericsson', false) then
            checericsson := 1
          else
            checericsson := 0;

          if JSONItem.GetValue<boolean>('chechuawei', false) then
            chechuawei := 1
          else
            chechuawei := 0;

          if JSONItem.getvalue<boolean>('checzte', false) then
            checzte := 1
          else
            checzte := 0;

          if JSONItem.getvalue<boolean>('checknokia', false) then
            checknokia := 1
          else
            checknokia := 0;

          if JSONItem.getvalue<boolean>('checoutros', false) then
            checoutros := 1
          else
            checoutros := 0;

          especificaroutros := body.getvalue<string>('especificar', '');


          //servico.nfilho := body.getvalue<string>('nfilho', '');

          if Length(nome) = 0 then
            erro := 'Campo Nome � Obrigat�rio';
          with qry do
          begin
            Active := false;
            sql.Clear;
            sql.add('select idpessoa from gespessoa where idpessoa=:idpessoa  ');
            ParamByName('idpessoa').Value := idpessoa;
            open;
            if RecordCount = 0 then
            begin

              Active := false;
              sql.Clear;
              if RecordCount = 0 then
              begin

                Active := false;
                sql.Clear;
                SQL.Add('INSERT INTO gespessoa(IDPESSOA,nome,tipopessoa,regional,nregistro,dataadmissao,datademissao,matriculaesocial,cbo,');
                SQL.Add('cargo,email,telefone,emailcorporativo,telefonecorporativo,cor,sexo,datanascimento,estadocivil,naturalidade,');
                SQL.Add('nacionalidade,nomepai,nomemae,nfilho,cep,endereco,numero,complemento,bairro,municipio,estado,rgrne,orgaoemissor,');
                SQL.Add('dataemissao,cpf,tituloeleitor,pis,ctps,datactps,reservista,cnh,datavalidadecnh,categoriacnh,primhabilitacao,');
                SQL.Add('escolaridade,tipocurso,tipograduacao,cadastro,empresa,DELETADO,checericsson,chechuawei,checzte,checknokia,checoutros,especificaroutros,');
                SQL.Add('datacadastro,inativacao,reativacao,idericsson,idisignum,idhuawei,senhahuawei,idzte,valorhora,salariobruto,fator,horasmes,observacao,mei,reset90,status)');
                SQL.Add('               VALUES(:IDPESSOA,:nome,:tipopessoa,:regional,:nregistro,:dataadmissao,:datademissao,:matriculaesocial,:cbo,');
                SQL.Add(':cargo,:email,:telefone,:emailcorporativo,:telefonecorporativo,:cor,:sexo,:datanascimento,:estadocivil,:naturalidade,');
                SQL.Add(':nacionalidade,:nomepai,:nomemae,:nfilho,:cep,:endereco,:numero,:complemento,:bairro,:municipio,:estado,:rgrne,:orgaoemissor,');
                SQL.Add(':dataemissao,:cpf,:tituloeleitor,:pis,:ctps,:datactps,:reservista,:cnh,:datavalidadecnh,:categoriacnh,:primhabilitacao,');
                SQL.Add(':escolaridade,:tipocurso,:tipograduacao,:cadastro,:empresa,:DELETADO,:checericsson,:chechuawei,:checzte,:checknokia,:checoutros,:especificaroutros,');
                SQL.Add(':datacadastro,:inativacao,:reativacao,:idericsson,:idisignum,:idhuawei,:senhahuawei,:idzte,:valorhora,:salariobruto,:fator,:horasmes,:observacao,:mei,:reset90,:status)');
              end
              else
              begin
                FConn.Rollback;
                erro := 'Erro ao cadastrar cliente: CPF ' + cpf + ' já existe em outro cadastro.';
                Writeln(erro);
                Result := false;
                exit
              end;
            end
            else
            begin

              Active := false;
              sql.Clear;
              sql.add('select * from gespessoa where idpessoa=:idpessoa');
              ParamByName('idpessoa').Value := idpessoa;
              open;
              if (RecordCount = 1) then
              begin
                Active := false;
                sql.Clear;
                SQL.Add('update gespessoa set DELETADO=:DELETADO,nome=:nome,tipopessoa=:tipopessoa,regional=:regional,nregistro=:nregistro,dataadmissao=:dataadmissao, ');
                SQL.Add('datademissao=:datademissao,matriculaesocial=:matriculaesocial,cbo=:cbo,cargo=:cargo,email=:email,telefone=:telefone,emailcorporativo=:emailcorporativo,');
                SQL.Add('telefonecorporativo=:telefonecorporativo,cor=:cor,sexo=:sexo,datanascimento=:datanascimento,estadocivil=:estadocivil,naturalidade=:naturalidade,');
                SQL.Add('nacionalidade=:nacionalidade,nomepai=:nomepai,nomemae=:nomemae,nfilho=:nfilho,cep=:cep,endereco=:endereco,numero=:numero,complemento=:complemento,');
                SQL.Add('bairro=:bairro,municipio=:municipio,estado=:estado,rgrne=:rgrne,orgaoemissor=:orgaoemissor,dataemissao=:dataemissao,cpf=:cpf,tituloeleitor=:tituloeleitor,');
                SQL.Add('pis=:pis,ctps=:ctps,datactps=:datactps,reservista=:reservista,cnh=:cnh,datavalidadecnh=:datavalidadecnh,categoriacnh=:categoriacnh,status=:status, ');
                SQL.Add('primhabilitacao=:primhabilitacao,escolaridade=:escolaridade,tipocurso=:tipocurso,tipograduacao=:tipograduacao,cadastro=:cadastro,empresa=:empresa,');
                SQL.Add('checericsson=:checericsson,chechuawei=:chechuawei,checzte=:checzte,checknokia=:checknokia,checoutros=:checoutros,especificaroutros=:especificaroutros, ');
                SQL.Add('datacadastro=:datacadastro,inativacao=:inativacao,reativacao=:reativacao,idericsson=:idericsson,valorhora=:valorhora,salariobruto=:salariobruto,');
                SQL.Add('idisignum=:idisignum,idhuawei=:idhuawei,senhahuawei=:senhahuawei,idzte=:idzte,fator=:fator,horasmes=:horasmes,observacao=:observacao, mei=:mei,reset90=:reset90 ');
                SQL.Add('where IDPESSOA=:IDPESSOA');
              end
              else
              begin
                FConn.Rollback;
                Writeln(erro);
                erro := 'Erro ao atualizar cliente: CPF ' + cpf + ' já existe em outro cadastro. Id do Usuario '+ idPessoa.ToString() + ' já existe em outro cadastro.';
                Writeln(erro);
                Result := false;
                exit
              end;
            end;

            ParamByName('idericsson').AsString := idericsson;
            ParamByName('idisignum').AsString := idisignum;
            ParamByName('idhuawei').AsString := idhuawei;
            ParamByName('senhahuawei').AsString := senhahuawei;
            ParamByName('idzte').AsString := idzte;

            ParamByName('idpessoa').AsInteger := IDPESSOA;
            ParamByName('nome').Value := nome;
            ParamByName('tipopessoa').Value := tipopessoa;
            ParamByName('regional').Value := regional;
            ParamByName('nregistro').Value := nregistro;

            try
              if ((reset90 = '') or (reset90 = '-') or (reset90 = '1899-12-30T00:00:00.000Z')) then
                ParamByName('reset90').value := StrToDate('30/12/1899')
              else
                ParamByName('reset90').value := StrToDate(reset90);
            except
              ParamByName('reset90').AsDateTime := ISO8601ToDate(reset90);
            end;

            ParamByName('matriculaesocial').Value := matriculaesocial;
            ParamByName('cbo').Value := cbo;
            ParamByName('cargo').Value := cargo;
            ParamByName('email').Value := email;
            ParamByName('telefone').Value := telefone;
            ParamByName('emailcorporativo').Value := emailcorporativo;
            ParamByName('telefonecorporativo').Value := telefonecorporativo;
            ParamByName('cor').Value := cor;
            
            ParamByName('sexo').Value := sexo;

            DataStr := datanascimento;


            qry.Params.ParamByName('dataadmissao').DataType := ftDateTime;
            qry.Params.ParamByName('datademissao').DataType := ftDateTime;
            qry.Params.ParamByName('datacadastro').DataType := ftDateTime;
            qry.Params.ParamByName('inativacao').DataType := ftDateTime;
            qry.Params.ParamByName('dataemissao').DataType := ftDateTime;
            qry.Params.ParamByName('reativacao').DataType := ftDateTime;
            qry.Params.ParamByName('datanascimento').DataType := ftDateTime;
            qry.Params.ParamByName('datavalidadecnh').DataType := ftDateTime;
            qry.Params.ParamByName('datactps').DataType := ftDateTime;
            qry.Params.ParamByName('primhabilitacao').DataType := ftDateTime;
            qry.Prepare;

            AtribuirDataOuPadrao('dataadmissao', dataadmissao, qry, FS);
            AtribuirDataOuPadrao('datademissao', datademissao, qry, FS);
            AtribuirDataOuPadrao('datacadastro', datacadastro, qry, FS);
            AtribuirDataOuPadrao('inativacao', inativacao, qry, FS);
            AtribuirDataOuPadrao('dataemissao', dataemissao, qry, FS);
            AtribuirDataOuPadrao('reativacao', reativacao, qry, FS);
            AtribuirDataOuPadrao('datanascimento', datanascimento, qry, FS);
            AtribuirDataOuPadrao('datavalidadecnh', datavalidadecnh, qry, FS);
            AtribuirDataOuPadrao('datactps', datactps, qry, FS);
            AtribuirDataOuPadrao('primhabilitacao', primhabilitacao, qry, FS);

            ParamByName('estadocivil').Value := estadocivil;
            ParamByName('naturalidade').Value := naturalidade;
            ParamByName('nacionalidade').Value := nacionalidade;
            ParamByName('nomepai').Value := nomepai;
            ParamByName('nomemae').Value := nomemae;
            ParamByName('nfilho').Value := nfilho;
            ParamByName('cep').Value := cep;
            ParamByName('endereco').Value := endereco;
            ParamByName('numero').Value := numero;
            ParamByName('complemento').Value := complemento;
            ParamByName('bairro').Value := bairro;
            ParamByName('municipio').Value := municipio;
            ParamByName('estado').Value := estado;
            ParamByName('rgrne').Value := rgrne;
            ParamByName('orgaoemissor').Value := orgaoemissor;
            ParamByName('cpf').DataType := ftString;


            if Trim(cpf) = '' then
                ParamByName('cpf').Clear
            else
              ParamByName('cpf').Value := cpf;

            ParamByName('tituloeleitor').Value := tituloeleitor;
            ParamByName('pis').Value := pis;
            ParamByName('ctps').Value := ctps;
            ParamByName('reservista').Value := reservista;
            ParamByName('cnh').Value := cnh;

            ParamByName('categoriacnh').Value := categoriacnh;
            DataStr :='';
            ParamByName('escolaridade').Value := escolaridade;
            ParamByName('tipocurso').Value := tipocurso;
            ParamByName('status').Value := status;
            ParamByName('tipograduacao').Value := tipograduacao;
            ParamByName('cadastro').Value := cadastro;
            ParamByName('empresa').Value := idempresa;
            ParamByName('DELETADO').Value := 0;

            ParamByName('checericsson').Value := checericsson;
            ParamByName('chechuawei').Value := chechuawei;
            ParamByName('checzte').Value := checzte;
            ParamByName('checknokia').Value := checknokia;
            ParamByName('checoutros').Value := checoutros;
            ParamByName('especificaroutros').Value := especificaroutros;

            ParamByName('valorhora').Value := valorhora;
            ParamByName('salariobruto').Value := salariobruto;
            ParamByName('fator').Value := fator;
            ParamByName('horasmes').Value := horasmes;
            ParamByName('observacao').Value := observacao;
            ParamByName('mei').Value := mei;
            ExecSQL;
          end;
          erro := '';
          FConn.Commit;
          result := true;
        except
          on ex: exception do
          begin
            FConn.Rollback;
            writeln('Erro ao atualizar cliente: CPF ' + cpf + ' já existe em outro cadastro. Id do Usuario '+ idpessoa.ToString());
            erro := 'Erro ao cadastrar cliente: ' + ex.Message;
            Result := false;
          end;
        end;
      end;
      except
      on ex: exception do
        begin
        FConn.Rollback;
        writeln('Erro ao atualizar cliente: CPF ' + cpf + ' já existe em outro cadastro. Id do Usuario '+ idpessoa.ToString());
        erro := 'Erro ao cadastrar cliente: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TPessoa.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('  gespessoa.idpessoa AS id, ');
      SQL.Add('  gespessoa.*, ');
      SQL.Add('  gesempresas.nome AS nomeEmpresa ');
      SQL.Add('FROM ');
      SQL.Add('  gespessoa ');
      SQL.Add('LEFT JOIN ');
      SQL.Add('  gesempresas ON gespessoa.empresa = gesempresas.idempresa ');
      SQL.Add('WHERE ');
      SQL.Add('  gespessoa.idpessoa IS NOT NULL ');
      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND(gespessoa.nome like ''%' + AQuery.Items['busca'] + '%'' )');
        end;
      end;

      if AQuery.ContainsKey('status1') then
      begin
        if (Length(AQuery.Items['status1']) > 0) and (AQuery.Items['status1'] <> 'TODOS') then
        begin
          SQL.Add('AND gespessoa.status = :status');
          ParamByName('status').Value := AQuery.Items['status1'];

        end
      end;

      if AQuery.ContainsKey('tipopessoa1') then
      begin
        if ((Length(AQuery.Items['tipopessoa1']) > 0) and (AQuery.Items['tipopessoa1'] <> 'TODOS')) then
        begin

          SQL.Add('AND gespessoa.tipopessoa = :tipopessoa');
          ParamByName('tipopessoa').Value := AQuery.Items['tipopessoa1'];
        end
      end;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gespessoa.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      SQL.Add(' order by  nome ');
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

function TPessoa.Listacurso(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select  ');
      SQL.Add('gescurso.idcurso as id, ');
      SQL.Add('gescurso.treinamentos, ');
      SQL.Add('gescurso.datanr, ');
      SQL.Add('gescurso.datavencimento, ');
      SQL.Add('gescurso.idcliente, ');
      SQL.Add('gescurso.idloja ');
      SQL.Add('From ');
      SQL.Add('gescurso  where idpessoa=:idpessoa ');
      a := AQuery.Items['idpessoabusca'].ToInteger;
      ParamByName('idpessoa').Value := AQuery.Items['idpessoabusca'].ToInteger;
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

function TPessoa.ListaSelect(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gespessoa.idpessoa  as value, ');
      SQL.Add('gespessoa.nome as label ');
      SQL.Add('From ');
      SQL.Add('gespessoa WHERE gespessoa.idpessoa is not null ');

      if AQuery.ContainsKey('nome') then
      begin
        if Length(AQuery.Items['nome']) > 0 then
          SQL.Add('AND gespessoa.nome like ''%' + AQuery.Items['nome'] + '%'' ');
      end;

      if AQuery.ContainsKey('cidade') then
      begin
        if Length(AQuery.Items['cidade']) > 0 then
          SQL.Add('AND gespessoa.cidade like ''%' + AQuery.Items['cidade'] + '%'' ');
      end;

      if AQuery.ContainsKey('rg') then
      begin
        if Length(AQuery.Items['rg']) > 0 then
          SQL.Add('AND gespessoa.rg like ''%' + AQuery.Items['rg'] + '%'' ');
      end;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gespessoa.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gespessoa.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gespessoa.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
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

function TPessoa.ListaSelectcolaboradorclt(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gespessoa.idpessoa as value, ');
      SQL.Add('gespessoa.nome as label, ');
      SQL.Add('gespessoa.valorhora ');
      SQL.Add('From ');
      SQL.Add('gespessoa  ');
      SQL.Add('Where ');
      SQL.Add('gespessoa.tipopessoa = ''CLT'' order by nome ');
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

function TPessoa.ListaSelectclt(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gespessoa.idpessoa As value, ');
      SQL.Add('gespessoa.nome As label ');
      SQL.Add('From ');
      SQL.Add('gespessoa left Join ');
      SQL.Add('gespessoarelacionamento On gespessoarelacionamento.idcliente = gespessoa.idcliente ');
      SQL.Add('And gespessoarelacionamento.idloja = gespessoa.idloja ');
      SQL.Add('And gespessoarelacionamento.idpessoa = gespessoa.idpessoa ');
      SQL.Add('Where ');
      SQL.Add('gespessoa.idpessoa Is Not Null and gespessoarelacionamento.idrelacionamento = 3  ');
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gespessoa.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gespessoa.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gespessoa.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
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

function TPessoa.ListaSelectpj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gespessoa.idpessoa As value, ');
      SQL.Add('gespessoa.nome As label ');
      SQL.Add('From ');
      SQL.Add('gespessoa left Join ');
      SQL.Add('gespessoarelacionamento On gespessoarelacionamento.idcliente = gespessoa.idcliente ');
      SQL.Add('And gespessoarelacionamento.idloja = gespessoa.idloja ');
      SQL.Add('And gespessoarelacionamento.idpessoa = gespessoa.idpessoa ');
      SQL.Add('Where ');
      SQL.Add('gespessoa.idpessoa Is Not Null and gespessoarelacionamento.idrelacionamento = 4  ');
      if AQuery.ContainsKey('nome') then
      begin
        if Length(AQuery.Items['nome']) > 0 then
          SQL.Add('AND gespessoa.nome like ''%' + AQuery.Items['nome'] + '%'' ');
      end;

      if AQuery.ContainsKey('cidade') then
      begin
        if Length(AQuery.Items['cidade']) > 0 then
          SQL.Add('AND gespessoa.cidade like ''%' + AQuery.Items['cidade'] + '%'' ');
      end;

      if AQuery.ContainsKey('rg') then
      begin
        if Length(AQuery.Items['rg']) > 0 then
          SQL.Add('AND gespessoa.rg like ''%' + AQuery.Items['rg'] + '%'' ');
      end;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gespessoa.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gespessoa.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gespessoa.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
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

function TPessoa.Listatreinamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('treinamento.id as value, ');
      SQL.Add('treinamento.descricao as label, ');
      SQL.Add('treinamento.duracao ');
      SQL.Add('From ');
      SQL.Add('treinamento');
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

function TPessoa.Listatreinamentogeral(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gestreinamento.idgestreinamento As id, ');
      SQL.Add('gestreinamento.idpessoa, ');
      SQL.Add('gestreinamento.statustreinamento as statustreinamento, ');
      SQL.Add('gespessoa.nome, ');
      SQL.Add('gespessoa.status, ');
      SQL.Add('gespessoa.cargo as funcao, ');
      SQL.Add('gespessoa.cadastro as cliente, ');
      SQL.Add('gestreinamento.idtreinamento, ');
      SQL.Add('treinamento.descricao, ');
      SQL.Add('Date_Format(gestreinamento.dataemissao, ''%d/%m/%Y'') As dataemissao, ');
      SQL.Add('Date_Format(gestreinamento.datavencimento, ''%d/%m/%Y'') As datavencimento, ');
      SQL.Add('If(CurDate() > gestreinamento.datavencimento, ''VENCIDO'', (If(CurDate() + 30 >= gestreinamento.datavencimento, ');
      SQL.Add('''RENOVAR'', ''VALIDO''))) As situacao ');
      SQL.Add('From ');
      SQL.Add('gestreinamento Left Join ');
      SQL.Add('treinamento On treinamento.id = gestreinamento.idtreinamento Inner Join ');
      SQL.Add('gespessoa On gespessoa.idpessoa = gestreinamento.idpessoa where gespessoa.deletado = 0 and gespessoa.status = ''ATIVO''  ');
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

function TPessoa.Listatreinamentolista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select  ');
      SQL.Add('gestreinamento.idgestreinamento As id, ');
      SQL.Add('gestreinamento.idpessoa, ');
      SQL.Add('gestreinamento.statustreinamento, ');
      SQL.Add('gestreinamento.idtreinamento, ');
      SQL.Add('treinamento.descricao, ');
      SQL.Add('Date_Format(gestreinamento.dataemissao, ''%d/%m/%Y'') As dataemissao, ');
      SQL.Add('Date_Format(gestreinamento.datavencimento, ''%d/%m/%Y'') As datavencimento, ');
      SQL.Add('if( curdate() > gestreinamento.datavencimento, ''VENCIDO'', (If (curdate()+30 >= gestreinamento.datavencimento, ''RENOVAR'', ''VALIDO'' ) ) ) as situacao ');
      SQL.Add('From ');
      SQL.Add('gestreinamento left Join ');
      SQL.Add('treinamento On treinamento.id = gestreinamento.idtreinamento where gestreinamento.idpessoa=:idpessoa order by gestreinamento.idgestreinamento  ');
      ParamByName('idpessoa').AsInteger := AQuery.Items['idpessoabusca'].ToInteger;
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

function TPessoa.AtualizarTreinamento(const AQuery: TDictionary<string, string>; out erro: string): Boolean;
var
  qry: TFDQuery;
  sqlUpdate: TStringList;
begin
  Result := False;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    // Inicia a transa��o
    FConn.StartTransaction;
    try
      sqlUpdate := TStringList.Create;
      try
        sqlUpdate.Add('UPDATE gestreinamento SET ');

        if statustreinamento <> '' then
          sqlUpdate.Add('statustreinamento = :statustreinamento, ');

        if dataemissaotreinamento <> '' then
          sqlUpdate.Add('dataemissao = :dataemissao, ');

        if datavencimentotreinamento <> '' then
          sqlUpdate.Add('datavencimento = :datavencimentotreinamento, ');

        // Remove a �ltima v�rgula e espa�o
        if sqlUpdate.Count > 0 then
          sqlUpdate[sqlUpdate.Count - 1] := Copy(sqlUpdate[sqlUpdate.Count - 1], 1, Length(sqlUpdate[sqlUpdate.Count - 1]) - 2);

        sqlUpdate.Add('WHERE idgestreinamento = :idtreinamento ');

        with qry do
        begin
          Active := False;
          SQL.Text := sqlUpdate.Text;

          if statustreinamento <> '' then
            ParamByName('statustreinamento').Value := statustreinamento;

          if dataemissaotreinamento <> '' then
            ParamByName('dataemissao').Value := dataemissaotreinamento;

          if datavencimentotreinamento <> '' then
            ParamByName('datavencimentotreinamento').Value := datavencimentotreinamento;

          ParamByName('idtreinamento').Value := idtreinamento;

          ExecSQL;
        end;
      finally
        sqlUpdate.Free;
      end;

      // Commit da transa��o
      FConn.Commit;
      erro := '';
      Result := True;
    except
      on ex: Exception do
      begin
        // Rollback da transa��o em caso de erro
        FConn.Rollback;
        erro := 'Erro ao atualizar: ' + ex.Message;
        Result := False;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TPessoa.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gespessoa.*, ');
      SQL.Add('gesempresas.nome as label, ');
      SQL.Add('gesempresas.idempresa as value');
      SQL.Add('From ');
      SQL.Add('gespessoa left Join  ');
      SQL.Add('gesempresas On gesempresas.idempresa = gespessoa.empresa WHERE gespessoa.idpessoa is not null and gespessoa.idpessoa =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idpessoabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gespessoa.deletado = :deletado');
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

function TPessoa.ListaSelectfuncionario(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('SELECT');
     if AQuery.ContainsKey('showinative') and (AQuery.Items['showinative'] = 'true') then
      begin
        SQL.Add('  gespessoa.idpessoa AS value,');
        SQL.Add('  UPPER(CONCAT(');
        SQL.Add('    gespessoa.nome,');
        SQL.Add('    IF(COALESCE(gespessoa.deletado, 0) = 1, '' - (Inativado)'', '''')');
        SQL.Add('  )) AS label');
      end
      else
      begin
        SQL.Add('  gespessoa.idpessoa AS value,');
        SQL.Add('  gespessoa.nome AS label');
      end;
      SQL.Add('From');
      SQL.Add('gespessoa where empresa =:empresa');
      ParamByName('empresa').AsInteger := idpessoa;

      if isOnlyCnh = 1 then
      begin
        SQL.Add('and gespessoa.cnh is not null');
        SQL.Add('and gespessoa.cnh <> :cnh');
        ParamByName('cnh').AsString := '';
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


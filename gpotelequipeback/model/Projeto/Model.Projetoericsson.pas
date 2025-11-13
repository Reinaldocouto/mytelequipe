unit Model.Projetoericsson;

interface

uses
  FireDAC.Comp.Client,
  Data.DB,
  System.SysUtils,
  System.DateUtils,
  model.connection,
  System.StrUtils,
  FireDAC.DApt,
  System.Generics.Collections,
  System.Variants,
  FireDAC.Stan.Param,
  Classes,
  ComObj,
  UtFuncao,
  System.JSON,
  Model.Email,
  System.Math;

type
  TProjetoericsson = class
  private
    FConn: TFDConnection;
    Fnumero: string;
    Fcliente: string;
    Fregiona: string;
    Fsite: string;
    Fsituacaoimplantacao: string;
    Fsituacaodaintegracao: string;
    Fdatadacriacaodademandadia: string;
    Fdataaceitedemandadia: string;
    Fdatainicioentregamosplanejadodia: string;
    Fdatarecebimentodositemosreportadodia: string;
    Fdatafiminstalacaoplanejadodia: string;
    Fdataconclusaoreportadodia: string;
    Fdatavalidacaoinstalacaodia: string;
    Fdataintegracaoplanejadodia: string;
    Fdatavalidacaoeriboxedia: string;
    Fdescricaoservico: string;
    Fcodigoservico: string;
    Fidcolaboradorclt: Integer;
    Fidcolaboradorpj: Integer;
    Fidposervico: string;
    Fdataexecucaoclt: string;
    Fdatainicio: string;
    Fdatafim: string;
    Fvalorhora: Double;
    Fhoranormalclt: Double;
    Fhora50clt: Double;
    Fhora100clt: Double;
    Fvalornegociado: Double;
    Fescopo: string;
    Fpo: string;
    Fpoitem: string;
    Fcodigo: string;
    Fcr: string;
    Ftotalhorasclt: string;
    Fobservacaoclt: string;
    Fobservacaopj: string;
    Fidgeral: Integer;
    Fidgeralfechamento: Integer;
    Fmespagamento: string;
    Fporcentagem: Double;
    Fvalorpagamento: Double;
    Fdesconto: Double;
    Fobservacaopagamento: string;
    Fobservacaopagamentointerna: string;
    Fdatadopagamento: TDateTime;
    Fstatus: string;
    Fdescricaopagamento: string;
    Fpopagamento: string;
    Fempresapagamento: string;
    Flpuhistorico: string;
    Flpucr: string;
    Fdataintegracaoreportadodia: string;
    Fdataaceitereportadodia: string;
    Fdataativacaoplanejadodia: string;
    Fdataativacaoreportadodia: string;
    Fdatavalidacaoativacaodia: string;
    Fdataaceiteeriboxedia: string;
    Fdataativacaoeriboxedia: string;
    Fidtarefamigo: Integer;
    Fdatatarefa: string;
    Fgeralfechamento: Integer;
    Frepostaalteracao: Integer;
    Foutros: string;
    Fformadeacesso: string;
    Fddd: string;
    Fmunicipio: string;
    Fnomeericsson: string;
    Flatitude: string;
    Flongitude: string;
    Fobs: string;
    Fsolicitacao: string;
    Fdatasolicitacao: string;
    Fdatainicial: string;
    Fdatafinal: string;
    Fstatusacesso: string;
    FenderecoSite: string;
    Fstatussydle: string;
    Fatividade: string;
    Ftipoinstalacao: string;
    Fimpacto: string;
    Fncrq: string;
    Finiciocrq: string;
    Ffimcrq: string;
    Fstatuscrq: string;
    Fcrqdeinstalacao: string;
    Fobservacoes: string;
    Fcentral: string;
    Fdetentora: string;
    Fiddentedora: Int64;
    Fnumeroativo: string;
    FobraPreenchidaNaSydle: string;
  public
    constructor Create;
    destructor Destroy; override;

    property idcolaboradorclt: Integer read Fidcolaboradorclt write Fidcolaboradorclt;
    property idcolaboradorpj: Integer read Fidcolaboradorpj write Fidcolaboradorpj;
    property idposervico: string read Fidposervico write Fidposervico;
    property dataexecucaoclt: string read Fdataexecucaoclt write Fdataexecucaoclt;
    property escopo: string read Fescopo write Fescopo;
    property po: string read Fpo write Fpo;
    property poitem: string read Fpoitem write Fpoitem;
    property codigo: string read Fcodigo write Fcodigo;
    property cr: string read Fcr write Fcr;
    property totalhorasclt: string read Ftotalhorasclt write Ftotalhorasclt;
    property observacaoclt: string read Fobservacaoclt write Fobservacaoclt;
    property observacaopj: string read Fobservacaopj write Fobservacaopj;
    property idgeral: Integer read Fidgeral write Fidgeral;

    property numero: string read Fnumero write Fnumero;
    property cliente: string read Fcliente write Fcliente;
    property regiona: string read Fregiona write Fregiona;
    property site: string read Fsite write Fsite;
    property situacaoimplantacao: string read Fsituacaoimplantacao write Fsituacaoimplantacao;
    property situacaodaintegracao: string read Fsituacaodaintegracao write Fsituacaodaintegracao;
    property datadacriacaodademandadia: string read Fdatadacriacaodademandadia write Fdatadacriacaodademandadia;
    property dataaceitedemandadia: string read Fdataaceitedemandadia write Fdataaceitedemandadia;
    property datainicioentregamosplanejadodia: string read Fdatainicioentregamosplanejadodia write Fdatainicioentregamosplanejadodia;
    property datarecebimentodositemosreportadodia: string read Fdatarecebimentodositemosreportadodia write Fdatarecebimentodositemosreportadodia;
    property datafiminstalacaoplanejadodia: string read Fdatafiminstalacaoplanejadodia write Fdatafiminstalacaoplanejadodia;
    property dataconclusaoreportadodia: string read Fdataconclusaoreportadodia write Fdataconclusaoreportadodia;
    property datavalidacaoinstalacaodia: string read Fdatavalidacaoinstalacaodia write Fdatavalidacaoinstalacaodia;
    property dataintegracaoplanejadodia: string read Fdataintegracaoplanejadodia write Fdataintegracaoplanejadodia;
    property datavalidacaoeriboxedia: string read Fdatavalidacaoeriboxedia write Fdatavalidacaoeriboxedia;
    property datainicio: string read Fdatainicio write Fdatainicio;
    property datadopagamento: TDateTime read Fdatadopagamento write Fdatadopagamento;
    property status: string read Fstatus write Fstatus;
    property datafim: string read Fdatafim write Fdatafim;
    property descricaoservico: string read Fdescricaoservico write Fdescricaoservico;
    property codigoservico: string read Fcodigoservico write Fcodigoservico;

    property valorhora: Double read Fvalorhora write Fvalorhora;
    property valornegociado: Double read Fvalornegociado write Fvalornegociado;

    property horanormalclt: Double read Fhoranormalclt write Fhoranormalclt;
    property hora50clt: Double read Fhora50clt write Fhora50clt;
    property hora100clt: Double read Fhora100clt write Fhora100clt;

    property idgeralfechamento: Integer read Fidgeralfechamento write Fidgeralfechamento;
    property geralfechamento: Integer read Fgeralfechamento write Fgeralfechamento;
    property repostaalteracao: Integer read Frepostaalteracao write Frepostaalteracao;
    property mespagamento: string read Fmespagamento write Fmespagamento;
    property porcentagem: Double read Fporcentagem write Fporcentagem;
    property valorpagamento: Double read Fvalorpagamento write Fvalorpagamento;
    property desconto: Double read Fdesconto write Fdesconto;
    property observacaopagamento: string read Fobservacaopagamento write Fobservacaopagamento;
    property observacaopagamentointerna: string read Fobservacaopagamentointerna write Fobservacaopagamentointerna;
    property descricaopagamento: string read Fdescricaopagamento write Fdescricaopagamento;
    property popagamento: string read Fpopagamento write Fpopagamento;
    property empresapagamento: string read Fempresapagamento write Fempresapagamento;
    property lpuhistorico: string read Flpuhistorico write Flpuhistorico;
    property lpucr: string read Flpucr write Flpucr;
    property idtarefamigo: Integer read Fidtarefamigo write Fidtarefamigo;
    property datatarefa: string read Fdatatarefa write Fdatatarefa;
    property outros: string read Foutros write Foutros;
    property formadeacesso: string read Fformadeacesso write Fformadeacesso;
    property ddd: string read Fddd write Fddd;
    property municipio: string read Fmunicipio write Fmunicipio;
    property nomeericsson: string read Fnomeericsson write Fnomeericsson;
    property latitude: string read Flatitude write Flatitude;
    property longitude: string read Flongitude write Flongitude;
    property obs: string read Fobs write Fobs;
    property solicitacao: string read Fsolicitacao write Fsolicitacao;
    property datasolicitacao: string read Fdatasolicitacao write Fdatasolicitacao;
    property datainicial: string read Fdatainicial write Fdatainicial;
    property datafinal: string read Fdatafinal write Fdatafinal;
    property statusacesso: string read Fstatusacesso write Fstatusacesso;
    property enderecoSite: string read FenderecoSite write FenderecoSite;

    property dataintegracaoreportadodia: string read Fdataintegracaoreportadodia write Fdataintegracaoreportadodia;
    property dataaceitereportadodia: string read Fdataaceitereportadodia write Fdataaceitereportadodia;
    property dataativacaoplanejadodia: string read Fdataativacaoplanejadodia write Fdataativacaoplanejadodia;
    property dataativacaoreportadodia: string read Fdataativacaoreportadodia write Fdataativacaoreportadodia;
    property datavalidacaoativacaodia: string read Fdatavalidacaoativacaodia write Fdatavalidacaoativacaodia;
    property dataaceiteeriboxedia: string read Fdataaceiteeriboxedia write Fdataaceiteeriboxedia;
    property dataativacaoeriboxedia: string read Fdataativacaoeriboxedia write Fdataativacaoeriboxedia;

    property statussydle: string read Fstatussydle write Fstatussydle;
    property atividade: string read Fatividade write Fatividade;
    property tipoinstalacao: string read Ftipoinstalacao write Ftipoinstalacao;
    property impacto: string read Fimpacto write Fimpacto;
    property ncrq: string read Fncrq write Fncrq;
    property iniciocrq: string read Finiciocrq write Finiciocrq;
    property fimcrq: string read Ffimcrq write Ffimcrq;
    property statuscrq: string read Fstatuscrq write Fstatuscrq;
    property crqdeinstalacao: string read Fcrqdeinstalacao write Fcrqdeinstalacao;
    property observacoes: string read Fobservacoes write Fobservacoes;
    property central: string read Fcentral write Fcentral;
    property detentora: string read Fdetentora write Fdetentora;
    property iddentedora: Int64 read Fiddentedora write Fiddentedora;
    property numeroativo: string read Fnumeroativo write Fnumeroativo;
    property obraPreenchidaNaSydle: string read FobraPreenchidaNaSydle write FobraPreenchidaNaSydle;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaadicid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaPO(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaMIGO(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listadocumentacaofinal(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listadocumentacaofinalcivilwork(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function Editarengenharia(out erro: string): Boolean;
    function ListaSelect1(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaSelectcolaboradorclt(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaatividadeclt(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editaratividadeclt(out erro: string): Boolean;
    function ListaSelectcolaboradorpj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaatividadepj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaatividadepjengenharia(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editaratividadepj(out erro: string): Boolean;
    function Editaratividadepjengenharia(out erro: string): Boolean;
    function ListaFechamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function ListaFechamentoporempresa(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function listapagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function atualizarlpu(out erro: string): Boolean;
    function Listalpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editarpagamento(out erro: string): Boolean;
    function Alterarpagamento(out erro: string): Boolean;
    function consultapagamento: Boolean;
    function apagarpagamento(out erro: string): Boolean;
    function extratopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function extratopagamentototal(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function extratopagamentodesconto(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function alterardesconto(out erro: string): Boolean;
    function historicopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function listagemlpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function listagemgrupolpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function NovoCadastrotarefa(out erro: string): integer;
    function Editartarefa(out erro: string): Boolean;
    function criarsite(out erro: string): Boolean;
    function ObterRelatorioDespesas(const AFiltros: TDictionary<string, string>; out AErro: string): TFDQuery;
    function regionalericsson(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function diaria(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function EditarEmMassa(const AJsonBody: string; out erro: string): Boolean;
    function EditarEmMassaRollout(const Numeros: TArray<string>; out erro: string): Boolean;
    function ListaCRQ(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    procedure SetDateParamExplicit(qry: TFDQuery; const paramName: string; const dateValue: string);
    function EditarCRQ(const ABody: TJSONObject; out erro: string): Boolean;
    function ListarCRQ(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function SendEmailEquipeFixa(const AQuery: TDictionary<string, string>; out erro: string): Boolean;

  end;

implementation


{ TProjetoericsson }

function TProjetoericsson.diaria(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select  ');
      SQL.Add('    gesdiaria.numero as id,  ');
      SQL.Add('    gesdiaria.datasolicitacao,  ');
      SQL.Add('    gespessoa.nome,  ');
      SQL.Add('    gesdiaria.projeto,  ');
      SQL.Add('    gesdiaria.siteid,  ');
      SQL.Add('    gesdiaria.siglasite,  ');
      SQL.Add('    gesdiaria.po,  ');
      SQL.Add('    gesdiaria.local,  ');
      SQL.Add('    gesdiaria.descricao,  ');
      SQL.Add('    gesdiaria.valoroutrassolicitacoes,  ');
      SQL.Add('    gesdiaria.diarias,  ');
      SQL.Add('    gesdiaria.valortotal,  ');
      SQL.Add('    gesdiaria.solicitante  ');
      SQL.Add('From  ');
      SQL.Add('    gesdiaria Inner Join  ');
      SQL.Add('    gespessoa On gespessoa.idpessoa = gesdiaria.colaborador where gesdiaria.siteid =:siteid ');
      ParamByName('siteid').asstring := AQuery.Items['osouobra'];
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

function TProjetoericsson.regionalericsson(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select  regional  From emailregional order by regional ');
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

function TProjetoericsson.consultapagamento: Boolean;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      sql.Clear;
      sql.add('Select * From obraericssonpagamento where mespagamento=:mespagamento and idgeralfechamento=:idgeralfechamento and datadopagamento=:datadopagamento and status=:status');
      ParamByName('mespagamento').asstring := mespagamento;
      ParamByName('idgeralfechamento').AsInteger := idgeralfechamento;
      ParamByName('datadopagamento').AsDate := datadopagamento;
      ParamByName('status').AsString := status;
      Open();
      if RecordCount = 0 then
        result := true
      else
        result := False;
    end;

  finally
    qry.Free;
  end;

end;

function TProjetoericsson.apagarpagamento(out erro: string): Boolean;
var
  qry: TFDQuery;
begin
  try
    try
      qry := TFDQuery.Create(nil);
      qry.connection := FConn;
      FConn.StartTransaction;
      with qry do
      begin
        Active := false;
        sql.Clear;
        sql.add('DELETE FROM obraericssonpagamento');
        sql.add('WHERE idgeralfechamento IN (');
        sql.add('SELECT geral');
        sql.add('FROM obraericssonfechamento');
        sql.add('WHERE PO =:po');
        sql.add('AND Descricao =:descricao');
        sql.add('AND EMPRESA =:empresa');
        sql.add(')');
        sql.add('AND mespagamento =:mespagamento');
        ParamByName('mespagamento').asstring := mespagamento;
        ParamByName('po').asstring := popagamento;
        ParamByName('descricao').asstring := descricaopagamento;
        ParamByName('empresa').asstring := empresapagamento;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao excluir pagamento: ' + ex.Message;
        Result := false;
      end;
    end;

  finally
    qry.Free;
  end;

end;

constructor TProjetoericsson.Create;
begin
  FConn := TConnection.CreateConnection;
end;

function TProjetoericsson.criarsite(out erro: string): Boolean;
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
        SQL.Add('select * from obraericsson where numero =:numero');
        parambyname('numero').AsString := numero;
        open;
        if recordcount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO obraericsson(numero,cliente,regiona,site)');
          SQL.Add('               VALUES(:numero,:cliente,:regiona,:site)');
          ParamByName('numero').asstring := UpperCase(numero);
          ParamByName('cliente').asstring := UpperCase(cliente);
          ParamByName('regiona').asstring := UpperCase(regiona);
          ParamByName('site').asstring := UpperCase(site);
          execsql;
          erro := '';
          FConn.Commit;
          result := true;
        end
        else
        begin
          erro := 'Numero de obra ja existe';
          result := false;
        end;
      end;

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

destructor TProjetoericsson.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TProjetoericsson.Editaratividadeclt(out erro: string): Boolean;
var
  qry: TFDQuery;
  id: Integer;
  valortotalhoras: Real;
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
        sql.add('select idgeral from obraericssonatividadeclt where idgeral=:idgeral ');
        ParamByName('idgeral').Value := idgeral;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO obraericssonatividadeclt(idgeral,numero,idcolaboradorclt,idposervico,datainicio,datafin,');
          SQL.Add('escopo,observacaoclt,po,totalhorasclt,descricaoservico,valorhora,horaxvalor,horasnormal,horas50,horas100)');
          SQL.Add('               VALUES(:idgeral,:numero,:idcolaboradorclt,:idposervico,:datainicio,:datafin,');
          SQL.Add(':escopo,:observacaoclt,:po,:totalhorasclt,:descricaoservico,:valorhora,:horaxvalor,:horasnormal,:horas50,:horas100)');
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update obraericssonatividadeclt set ');
          SQL.Add('numero=:numero,');
          SQL.Add('idcolaboradorclt=:idcolaboradorclt,');
          SQL.Add('idposervico=:idposervico,');
          SQL.Add('datainicio=:datainicio,datafin=:datafin,');
          SQL.Add('escopo=:escopo,');
          SQL.Add('observacaoclt=:observacaoclt,');
          SQL.Add('po=:po,valorhora=:valorhora,horaxvalor=:horaxvalor,');
          SQL.Add('totalhorasclt=:totalhorasclt, descricaoservico=:descricaoservico, ');
          SQL.Add('horasnormal=:horasnormal,horas50=:horas50,horas100=:horas100 ');
          SQL.Add('where idgeral=:idgeral ');
        end;
        ParamByName('idgeral').asinteger := idgeral;
        ParamByName('numero').asstring := numero;
        ParamByName('idcolaboradorclt').asinteger := idcolaboradorclt;
        ParamByName('idposervico').asstring := idposervico;
        ParamByName('datainicio').AsString := datainicio;
        ParamByName('datafin').AsString := datafim;
        ParamByName('valorhora').AsFloat := valorhora;
        ParamByName('escopo').AsString := escopo;
        ParamByName('observacaoclt').AsString := observacaoclt;
        ParamByName('po').AsString := po;
        ParamByName('totalhorasclt').AsString := totalhorasclt;
        ParamByName('descricaoservico').asstring := descricaoservico;
        ParamByName('horasnormal').AsFloat := horanormalclt;
        ParamByName('horas50').AsFloat := hora50clt;
        ParamByName('horas100').AsFloat := hora100clt;
        valortotalhoras := StrToFloat(StringReplace(totalhorasclt, '.', ',', []));
        ParamByName('horaxvalor').asfloat := valorhora * valortotalhoras;
        execsql;
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

function TProjetoericsson.Editaratividadepj(out erro: string): Boolean;
var
  qry, qry1, qry2: TFDQuery;
  id, demanda: Integer;
  polocal, cliente, empresa, site: string;
begin
  try
    erro := '';
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    qry1 := TFDQuery.Create(nil);
    qry1.connection := FConn;
    qry2 := TFDQuery.Create(nil);
    qry2.connection := FConn;
    try
      FConn.StartTransaction;
      with qry2 do
      begin
        active := false;
        SQL.Clear;
        SQL.Add('Select ');
        SQL.Add('  datarecebimentodositemosreportadodia, ');
        SQL.Add('  datavalidacaoinstalacaodia, ');
        SQL.Add('  datavalidacaoeriboxedia ');
        SQL.Add('From ');
        SQL.Add('  obraericsson ');
        SQL.Add('Where ');
        SQL.Add('  obraericsson.numero =:numero ');
        parambyname('numero').asstring := numero;
        open;
      end;
      with qry do
      begin
        active := false;
        SQL.Clear;
        SQL.Add('Select obraericssonmigo.descricaoservico,obraericssonmigo.po From ');
        SQL.Add('  obraericssonmigo  ');
        SQL.Add('Where ');
        SQL.Add('  obraericssonmigo.poritem=:po ');         // quantos itens tem em cada item
        ParamByName('po').AsString := po;
        Open();

        // Debug: Verificar se encontrou o registro na primeira query
        if RecordCount = 0 then
        begin
          erro := erro + ' Não foi encontrado registro na tabela obraericssonmigo para poritem: ' + po + '. ';
          descricaoservico := '';
          polocal := '';
        end
        else
        begin
          descricaoservico := FieldByName('descricaoservico').AsString;
          polocal := FieldByName('po').AsString;
        end;
        Active := false;
        SQL.Clear;
        SQL.Add('Select ');
        SQL.Add('  obraericsson.rfp, ');
        SQL.Add('  obraericsson.cliente, ');
        SQL.Add('  obraericsson.site ');
        SQL.Add('From ');
        SQL.Add('  obraericsson ');
        SQL.Add('Where ');
        SQL.Add('  obraericsson.numero=:numero ');
        ParamByName('numero').asstring := numero;
        open;
        demanda := fieldbyname('rfp').AsInteger;
        cliente := fieldbyname('cliente').asstring;
        site := fieldbyname('site').asstring;

        Active := false;
        SQL.Clear;
        SQL.Add('Select gesempresas.nome From gesempresas where idempresa =:idempresa');
        parambyname('idempresa').asinteger := idcolaboradorpj;
        Open();
        empresa := FieldByName('nome').asstring;

        if (descricaoservico = '') or (polocal = '') then
        begin
          erro := erro + ' Parâmetros essenciais vazios. Não é possível continuar. ';
          FConn.Rollback;
          Result := false;
          Exit;
        end;

        if lpuhistorico = 'NEGOCIADO' then
        begin
          Active := false;
          SQL.Clear;
            SQL.Add('Select ');
            SQL.Add('  obraericssonmigo.po, ');
            SQL.Add('  obraericssonmigo.poritem, ');
            SQL.Add('  SUBSTRING(obraericssonmigo.poritem, 11, 12) AS item,');
            SQL.Add('  obraericssonmigo.codigoservico, ');
            SQL.Add('  obraericssonmigo.descricaoservico, ');
            SQL.Add('  obraericssonmigo.estado, ');
            SQL.Add('  obraericssonmigo.sigla, ');
            SQL.Add('  obraericssonmigo.qtyordered ');
            SQL.Add('From ');
            SQL.Add('  obraericssonmigo ');
            SQL.Add('Where ');
            SQL.Add('  descricaoservico LIKE :descricaoservico and poritem=:poritem ');
            ParamByName('descricaoservico').asstring := '%' + descricaoservico + '%';
            ParamByName('poritem').asstring := poitem;
          Open();
        end
        else
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('Select ');
          SQL.Add('  obraericssonlpu.codigo, ');
          SQL.Add('  obraericssonlpu.Valor, ');
          SQL.Add('  obraericssonmigo.po, ');
          SQL.Add('  obraericssonmigo.poritem, ');
          SQL.Add('  SUBSTRING(obraericssonmigo.poritem, 11, 12) AS item,');
          SQL.Add('  obraericssonmigo.codigoservico, ');
          SQL.Add('  obraericssonmigo.descricaoservico, ');
          SQL.Add('  obraericssonmigo.estado, ');
          SQL.Add('  obraericssonmigo.sigla, ');
          SQL.Add('  obraericssonmigo.qtyordered ');
          SQL.Add('From ');
          SQL.Add('  obraericssonmigo Inner Join ');
          SQL.Add('  obraericssonlpu On obraericssonlpu.codigo = obraericssonmigo.codigoservico ');
          SQL.Add('Where ');
          SQL.Add('  descricaoservico LIKE :descricaoservico and po=:po and ');
          SQL.Add('  obraericssonlpu.historico LIKE :historico ');
          ParamByName('descricaoservico').asstring := '%' + descricaoservico + '%';
          ParamByName('po').asString := polocal;
          ParamByName('historico').asstring := lpuhistorico;
          Open();
        end;

        if qry.RecordCount = 0 then
        begin
          erro := erro + ' LPU não localizada para o pacote ' + descricaoservico +
                  ' - PO+ITEM: ' + poitem + ' - Histórico: ' + lpuhistorico;
          if lpuhistorico <> 'NEGOCIADO' then
            erro := erro + ', historico="%' + lpuhistorico + '%"';
          erro := erro + '. ';
        end
        else
        begin
          while not eof do
          begin
            with qry1 do
            begin
              close;
              SQL.clear;
              sql.Add('insert into obraericssonatividadepj(idcolaboradorpj,idposervico,po,lpuhistorico,');
              sql.Add('  poitem,escopo,numero,deletado,valorservico,observacaopj,descricaoservico,codigoservico,dataacionamento)');
              sql.Add('values(:idcolaboradorpj,:idposervico,:po,:lpuhistorico,');
              sql.Add('  :poitem,:escopo,:numero,:deletado,:valorservico,:observacaopj,:descricaoservico,:codigoservico,:dataacionamento)');
              ParamByName('idcolaboradorpj').asinteger := idcolaboradorpj;
              ParamByName('idposervico').asstring := idposervico;
              ParamByName('po').asstring := polocal;
              ParamByName('poitem').asstring := qry.FieldByName('poritem').AsString;
              ParamByName('escopo').asstring := escopo;
              ParamByName('numero').asstring := numero;
              ParamByName('deletado').asinteger := 0;
              if lpuhistorico = 'NEGOCIADO' then
                ParamByName('valorservico').asfloat := valornegociado
              else
                ParamByName('valorservico').asfloat := qry.FieldByName('Valor').AsFloat * qry.FieldByName('qtyordered').asfloat;
              ParamByName('observacaopj').asstring := observacaopj;
              ParamByName('descricaoservico').asstring := descricaoservico;
              ParamByName('codigoservico').asstring := qry.FieldByName('codigoservico').AsString;
              ParamByName('lpuhistorico').asstring := lpuhistorico;
              ParamByName('dataacionamento').AsDate := Date;
              ExecSQL;

              close;
              SQL.clear;
              SQL.Add('insert into obraericssonfechamento (Demanda,PO,POITEM,Item,Sigla,IDSydle,Cliente,Estado,Codigo,');
              SQL.Add('  Descricao,VALORPJ,Quant,EMPRESA,DATADEENVIO,idcolaboradorpj,MOSREAL,INSTALREAL,INTEGREAL) ');
              sql.Add('values(:Demanda,:PO,:POITEM,:Item,:Sigla,:IDSydle,:Cliente,:Estado,:Codigo,');
              sql.Add('  :Descricao,:VALORPJ,:Quant,:EMPRESA,:DATADEENVIO,:idcolaboradorpj,:MOSREAL,:INSTALREAL,:INTEGREAL) ');
              ParamByName('Demanda').AsInteger := demanda;
              ParamByName('PO').Asstring := polocal;
              ParamByName('POITEM').AsString := qry.FieldByName('poritem').AsString;
              if qry.FieldByName('sigla').asstring = 'T' then
                ParamByName('Item').AsInteger := 0
              else
                ParamByName('Item').AsInteger := qry.FieldByName('item').asinteger;
              ParamByName('Sigla').asstring := site;
              ParamByName('IDSydle').asstring := numero;
              ParamByName('Cliente').asstring := cliente;
              ParamByName('Estado').asstring := qry.FieldByName('estado').AsString;
              ParamByName('Codigo').asstring := qry.FieldByName('codigoservico').AsString;
              ParamByName('Descricao').asstring := descricaoservico;
              if lpuhistorico = 'NEGOCIADO' then
                ParamByName('VALORPJ').asfloat := valornegociado
              else
                ParamByName('VALORPJ').asfloat := qry.FieldByName('Valor').AsFloat * qry.FieldByName('qtyordered').asfloat;
              ParamByName('Quant').asfloat := qry.FieldByName('qtyordered').asfloat;
              if qry2.FieldByName('datarecebimentodositemosreportadodia').asstring = '' then
               begin
                 ParamByName('MOSREAL').DataType := ftDate;
                 ParamByName('MOSREAL').Clear;
               end
               else
                 ParamByName('MOSREAL').AsDate := qry2.FieldByName('datarecebimentodositemosreportadodia').AsDateTime;

               if qry2.FieldByName('datavalidacaoinstalacaodia').asstring = '' then
               begin
                 ParamByName('INSTALREAL').DataType := ftDate;
                 ParamByName('INSTALREAL').Clear;
               end
               else
                 ParamByName('INSTALREAL').AsDate := qry2.FieldByName('datavalidacaoinstalacaodia').AsDateTime;

               if qry2.FieldByName('datavalidacaoeriboxedia').asstring = '' then
               begin
                 ParamByName('INTEGREAL').DataType := ftDate;
                 ParamByName('INTEGREAL').Clear;
               end
               else
                 ParamByName('INTEGREAL').AsDate := qry2.FieldByName('datavalidacaoeriboxedia').AsDateTime;
              ParamByName('EMPRESA').asstring := empresa;
              ParamByName('DATADEENVIO').asdate := date;
              ParamByName('idcolaboradorpj').asinteger := idcolaboradorpj;
              execsql;
            end;
            Next;
          end;
        end;

      end;

      FConn.Commit;

      if Length(erro) = 0 then
        result := true
      else
        Result := false;

    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao cadastrar cliente: ' + ex.Message;
        Writeln(erro);
        Result := false;
      end;
    end;
  finally
    qry.Free;
    qry1.Free;
    qry2.Free;
  end;
end;

function TProjetoericsson.Editaratividadepjengenharia(out erro: string): Boolean;
var
  qry, qry1, qry2: TFDQuery;
  id, demanda: Integer;
  polocal, cliente, empresa, site: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    qry1 := TFDQuery.Create(nil);
    qry1.connection := FConn;
    qry2 := TFDQuery.Create(nil);
    qry2.connection := FConn;
    try
      erro := '';
      FConn.StartTransaction;
      with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('Select gesempresas.nome From gesempresas where idempresa =:idempresa');
        parambyname('idempresa').asinteger := idcolaboradorpj;
        Open();
        empresa := FieldByName('nome').asstring;

        // Tratar caracteres especiais na descrição do serviço
        if Copy(descricaoservico, 1, 2) = '//' then
        begin
          descricaoservico := Trim(Copy(descricaoservico, 3, Length(descricaoservico)));
          erro := erro + ' Caracteres especiais removidos da descrição. ';
        end;

        // Debug: Verificar valores dos parâmetros antes da query principal
        erro := erro + ' Parâmetros: descricaoservico=' + descricaoservico + ', poitem=' + poitem + ', lpuhistorico=' + lpuhistorico + '. ';

        // Verificar se os parâmetros essenciais estão preenchidos
        if (descricaoservico = '') or (poitem = '') then
        begin
          erro := erro + ' Parâmetros essenciais vazios. Não é possível continuar. ';
          FConn.Rollback;
          Result := false;
          Exit;
        end;

        if lpuhistorico = 'NEGOCIADO' then
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('Select ');
          SQL.Add('obraericssonmigo.po, ');
          SQL.Add('obraericssonmigo.poritem, ');
          SQL.Add('SUBSTRING(obraericssonmigo.poritem, 11, 12) AS item,');
          SQL.Add('obraericssonmigo.codigoservico, ');
          SQL.Add('obraericssonmigo.descricaoservico, ');
          SQL.Add('obraericssonmigo.estado, ');
          SQL.Add('obraericssonmigo.sigla, ');
          SQL.Add('obraericssonmigo.qtyordered ');
          SQL.Add('From ');
          SQL.Add('obraericssonmigo where descricaoservico LIKE :descricaoservico and poritem=:poritem ');
          ParamByName('descricaoservico').asstring := '%' + descricaoservico + '%';
          ParamByName('poritem').asstring := poitem;
          Open();
        end
        else
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('Select ');
          SQL.Add('obraericssonlpu.codigo, ');
          SQL.Add('obraericssonlpu.Valor, ');
          SQL.Add('obraericssonmigo.po, ');
          SQL.Add('obraericssonmigo.poritem, ');
          SQL.Add('SUBSTRING(obraericssonmigo.poritem, 11, 12) AS item,');
          SQL.Add('obraericssonmigo.codigoservico, ');
          SQL.Add('obraericssonmigo.descricaoservico, ');
          SQL.Add('obraericssonmigo.estado, ');
          SQL.Add('obraericssonmigo.sigla, ');
          SQL.Add('obraericssonmigo.qtyordered ');
          SQL.Add('From ');
          SQL.Add('obraericssonmigo Inner Join ');
          SQL.Add('obraericssonlpu On obraericssonlpu.codigo = obraericssonmigo.codigoservico where descricaoservico LIKE :descricaoservico and poritem=:poritem and ');
          SQL.Add('obraericssonlpu.historico LIKE :historico ');
          ParamByName('descricaoservico').asstring := '%' + descricaoservico + '%';
          ParamByName('poritem').asstring := poitem;
          ParamByName('historico').asstring := '%' + lpuhistorico + '%';
          Open();
          erro := 'Codigo de servi�o n�o localizado na LPU';
        end;
        while not eof do
        begin
          erro := '';
          with qry1 do
          begin
            close;
            SQL.clear;
            sql.Add('insert into obraericssonatividadepj(idcolaboradorpj,idposervico,po,lpuhistorico,');
            sql.Add('poitem,escopo,numero,deletado,valorservico,observacaopj,descricaoservico,codigoservico,email)');
            sql.Add('                             values(:idcolaboradorpj,:idposervico,:po,:lpuhistorico,');
            sql.Add(':poitem,:escopo,:numero,:deletado,:valorservico,:observacaopj,:descricaoservico,:codigoservico,:email)');
            ParamByName('idcolaboradorpj').asinteger := idcolaboradorpj;
            ParamByName('idposervico').asstring := idposervico;
            ParamByName('po').asstring := po;
            ParamByName('poitem').asstring := qry.FieldByName('poritem').AsString;
            ParamByName('escopo').asstring := '';
            ParamByName('numero').asinteger := 0;
            ParamByName('deletado').asinteger := 0;
            ParamByName('email').asinteger := 2;
            if lpuhistorico = 'NEGOCIADO' then
              ParamByName('valorservico').asfloat := valornegociado
            else
              ParamByName('valorservico').asfloat := qry.FieldByName('Valor').AsFloat;
            ParamByName('observacaopj').asstring := observacaopj;
            ParamByName('descricaoservico').asstring := descricaoservico;
            ParamByName('codigoservico').asstring := qry.FieldByName('codigoservico').AsString;
            ParamByName('lpuhistorico').asstring := lpuhistorico;
            ExecSQL;

            close;
            SQL.clear;
            SQL.Add('insert into obraericssonfechamento (Demanda,PO,POITEM,Item,Sigla,IDSydle,Cliente,Estado,Codigo,');
            SQL.Add('Descricao,VALORPJ,Quant,EMPRESA,DATADEENVIO,idcolaboradorpj) ');
            sql.Add('                            values(:Demanda,:PO,:POITEM,:Item,:Sigla,:IDSydle,:Cliente,:Estado,:Codigo,');
            sql.Add(':Descricao,:VALORPJ,:Quant,:EMPRESA,:DATADEENVIO,:idcolaboradorpj) ');
            ParamByName('Demanda').AsInteger := 0;
            ParamByName('PO').Asstring := po;
            ParamByName('POITEM').AsString := qry.FieldByName('poritem').AsString;
            if qry.FieldByName('sigla').asstring = 'T' then
              ParamByName('Item').AsInteger := 0
            else
              ParamByName('Item').AsInteger := qry.FieldByName('item').asinteger;
            ParamByName('Sigla').asstring := '';
            ParamByName('IDSydle').asinteger := 0;
            ParamByName('Cliente').asstring := cliente;
            ParamByName('Estado').asstring := qry.FieldByName('estado').AsString;
            ParamByName('Codigo').asstring := codigo;
            ParamByName('Descricao').asstring := descricaoservico;
            if lpuhistorico = 'NEGOCIADO' then
              ParamByName('VALORPJ').asfloat := valornegociado
            else
              ParamByName('VALORPJ').asfloat := qry.FieldByName('Valor').AsFloat;
            ParamByName('Quant').asinteger := qry.FieldByName('qtyordered').asinteger;
            ParamByName('EMPRESA').asstring := empresa;
            ParamByName('DATADEENVIO').asdate := date;
            ParamByName('idcolaboradorpj').asinteger := idcolaboradorpj;
            execsql;
          end;
          Next;
        end;

      end;

      FConn.Commit;
      if length(erro) = 0 then
        result := true
      else
        Result := false;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao cadastrar acionamento: ' + ex.Message +
                ' SQL: ' + qry.SQL.Text +
                ' Parâmetros: descricaoservico=' + descricaoservico +
                ', poitem=' + poitem +
                ', lpuhistorico=' + lpuhistorico;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TProjetoericsson.Editarengenharia(out erro: string): Boolean;
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
        sql.add('select numero from obraericsson where numero=:numero ');
        ParamByName('numero').Value := numero;
        Open;
        if RecordCount = 0 then
        begin
          erro := 'Numero de obra n�o localizado';
          result := false;
          Exit;
        end
        else
        begin
          erro := '';
          result := true;
          Active := false;
          sql.Clear;
          SQL.Add('update obraericssonmigo set id=:id where  poritem=:poritem  ');
          ParamByName('id').asstring := numero;
          ParamByName('poritem').asstring := poitem;
          execsql;
         { Active := false;
          sql.Clear;
          SQL.Add('insert into cr (POItem,po,ID_1)');
          SQL.Add('        values (:POItem,:po,:ID_1)');
          parambyname('POItem').asstring := poitem;
          parambyname('PO').asstring := po;
          parambyname('id_1').asstring := numero;
          execsql;  }
          FConn.Commit;
        end;
      end;

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
  result := true;
end;

function TProjetoericsson.Editarpagamento(out erro: string): Boolean;
var
  qry: TFDQuery;
  qry1: TFDQuery;
  id: Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    qry1 := TFDQuery.Create(nil);
    qry1.connection := FConn;
    try
      with qry1 do
      begin
        Active := false;
        sql.Clear;
        SQL.Add('Select ');
        SQL.Add('obraericssonfechamento.PO, ');
        SQL.Add('obraericssonfechamento.geral, ');
        SQL.Add('obraericssonfechamento.VALORPJ ');
        SQL.Add('From ');
        SQL.Add('obraericssonfechamento ');
        SQL.Add('Where ');
        SQL.Add('obraericssonfechamento.EMPRESA =:empresa And ');
        SQL.Add('obraericssonfechamento.po =:po And ');
        SQL.Add('obraericssonfechamento.Descricao Like ''%' + descricaopagamento + '%'' ');
        ParamByName('empresa').asstring := empresapagamento;
        ParamByName('po').asstring := popagamento;
        Open();
      end;
      FConn.StartTransaction;
      while not qry1.eof do
      begin
        with qry do
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO obraericssonpagamento(idgeralfechamento,mespagamento,porcentagem,valorpagamento,observacao,observacaointerna,numero,desconto, datadopagamento, status)');
          sql.add('                          values(:idgeralfechamento,:mespagamento,:porcentagem,:valorpagamento,:observacao,:observacaointerna,:numero,:desconto, :datadopagamento, :status)');
          ParamByName('idgeralfechamento').asinteger := qry1.fieldbyname('geral').AsInteger;
          ParamByName('mespagamento').asstring := mespagamento;
          ParamByName('porcentagem').asfloat := porcentagem / 100;
          ParamByName('valorpagamento').asfloat := qry1.fieldbyname('VALORPJ').AsFloat * (porcentagem / 100);
          ParamByName('observacao').AsString := observacaopagamento;
          ParamByName('observacaointerna').AsString := observacaopagamentointerna;
          ParamByName('status').AsString := status;
          ParamByName('datadopagamento').AsDateTime := datadopagamento;
          ParamByName('desconto').asfloat := 0;
          ParamByName('numero').asstring := numero;
          ExecSQL;
        end;
        qry1.Next;
      end;

      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao efetuar pagamento: ' + ex.Message;
        Result := false;
      end;
    end;

  finally
    qry.Free;
    qry1.Free;
  end;
end;

function TProjetoericsson.alterardesconto(out erro: string): Boolean;
var
  qry: TFDQuery;
  id: Integer;
begin
  try

    try
      qry := TFDQuery.Create(nil);
      qry.connection := FConn;
      with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('Select  ');
        SQL.Add('COALESCE( obraericssonpagamentodesconto.desconto, 0) as desconto,  ');
        SQL.Add('obraericssonpagamentodesconto.motivo,  ');
        SQL.Add('obraericssonpagamentodesconto.subtotal,  ');
        SQL.Add('obraericssonpagamentodesconto.total  ');
        SQL.Add('From  ');
        SQL.Add('obraericssonpagamentodesconto where idgeral is not null ');
        SQL.Add('AND(obraericssonpagamentodesconto.EMPRESA=:empresa) ');
        SQL.Add('AND(obraericssonpagamentodesconto.mespagamento=:mespagamento) ');
        SQL.Add('AND(obraericssonpagamentodesconto.numero=:numero) ');
        parambyname('empresa').asstring := empresapagamento;
        parambyname('mespagamento').asstring := mespagamento;
        parambyname('numero').asstring := numero;
        Open();
        if RecordCount = 0 then
        begin
          Active := false;
          SQL.Clear;
          SQL.Add('insert into obraericssonpagamentodesconto(desconto,mespagamento,numero,empresa)');
          SQL.Add('                                   values(:desconto,:mespagamento,:numero,:empresa)');

        end
        else
        begin
          Active := false;
          SQL.Clear;
          sql.add('update obraericssonpagamentodesconto set desconto=:desconto where mespagamento=:mespagamento and numero=:numero and empresa=:empresa ');

        end;
        parambyname('desconto').AsFloat := desconto;
        parambyname('empresa').asstring := empresapagamento;
        parambyname('mespagamento').asstring := mespagamento;
        parambyname('numero').asstring := numero;
        execsql;
      end;

      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao salvar desconto: ' + ex.Message;
        Result := false;
      end;
    end;

  finally
    qry.Free;
  end;
end;

function TProjetoericsson.alterarpagamento(out erro: string): Boolean;
var
  qry: TFDQuery;
  qry1: TFDQuery;
  id: Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    qry1 := TFDQuery.Create(nil);
    qry1.connection := FConn;
    try
      with qry1 do
      begin
        Active := false;
        sql.Clear;
        SQL.Add('Select ');
        SQL.Add('obraericssonfechamento.PO, ');
        SQL.Add('obraericssonfechamento.geral, ');
        SQL.Add('obraericssonfechamento.VALORPJ ');
        SQL.Add('From ');
        SQL.Add('obraericssonfechamento ');
        SQL.Add('Where ');
        SQL.Add('obraericssonfechamento.EMPRESA =:empresa and ');
        SQL.Add('obraericssonfechamento.po =:po And ');
        SQL.Add('obraericssonfechamento.Descricao Like ''%' + descricaopagamento + '%'' ');
        ParamByName('empresa').asstring := empresapagamento;
        ParamByName('po').asstring := popagamento;
        Open();
      end;
      FConn.StartTransaction;
      while not qry1.eof do
      begin
        with qry do
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update obraericssonpagamento set  porcentagem=:porcentagem , valorpagamento=:valorpagamento, observacao=:observacao, observacaointerna=:observacaointerna, desconto=:desconto ');
          SQL.Add('where idgeralfechamento=:idgeralfechamento and  mespagamento=:mespagamento and datadopagamento=:datadopagamento and status=:status');
          ParamByName('idgeralfechamento').asinteger := qry1.fieldbyname('geral').AsInteger;
          ParamByName('mespagamento').asstring := mespagamento;
          ParamByName('porcentagem').asfloat := porcentagem / 100;
          ParamByName('valorpagamento').asfloat := qry1.fieldbyname('VALORPJ').AsFloat * (porcentagem / 100);
          ParamByName('observacao').AsString := observacaopagamento;
          ParamByName('observacaointerna').AsString := observacaopagamentointerna;
          ParamByName('datadopagamento').AsDate := datadopagamento;
          ParamByName('status').asString := status;
          ParamByName('desconto').asfloat := 0;
          ExecSQL;
        end;
        qry1.Next;
      end;

      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao efetuar pagamento: ' + ex.Message;
        Result := false;
      end;
    end;

  finally
    qry.Free;
    qry1.Free;
  end;
end;

function TProjetoericsson.Editartarefa(out erro: string): Boolean;
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
        sql.add('Select obraericssonmigo.sigla, obraericssonmigo.po From  obraericssonmigo where sigla = ''T'' and po=:po  ');
        ParamByName('po').Value := idtarefamigo;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO obraericssonmigo(po,poritem,datacriacaopo,id,descricaoservico,qtyordered,codigoservico,siteid, sigla)');
          SQL.Add('               VALUES(:po,:poritem,:datacriacaopo,:id,:descricaoservico,:qtyordered,:codigoservico,:siteid, :sigla)');
        end
        else
        begin

        end;
        ParamByName('po').asinteger := idtarefamigo;
        ParamByName('poritem').asinteger := idtarefamigo;
        ParamByName('datacriacaopo').asstring := datatarefa;
        ParamByName('id').asstring := numero;
        ParamByName('descricaoservico').asstring := descricaoservico;
        ParamByName('qtyordered').asinteger := 1;
        ParamByName('sigla').AsString := 'T';
        ParamByName('codigoservico').asstring := codigoservico;
        ParamByName('siteid').asstring := site;
        execsql;
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

function TProjetoericsson.extratopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a, b: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('obraericssonfechamento.geral as id, ');
      SQL.Add('obraericssonfechamento.PO, ');
      SQL.Add('obraericssonfechamento.POITEM, ');
      SQL.Add('obraericssonmigo.siteid as Sigla, ');
      SQL.Add('obraericssonfechamento.IDSydle, ');
      SQL.Add('obraericssonfechamento.Cliente, ');
      SQL.Add('obraericssonfechamento.estado, ');
      SQL.Add('obraericssonfechamento.Codigo, ');
      SQL.Add('obraericssonfechamento.Descricao, ');
      SQL.Add('obraericssonpagamento.mespagamento, ');
      SQL.Add('obraericssonpagamento.status, ');
      SQL.Add('obraericssonpagamento.datadopagamento, ');
      SQL.Add('emailregional.emailfechamento, ');
      SQL.Add('FORMAT((obraericssonpagamento.porcentagem * 100), 2) as porcentagem  , ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(obraericssonpagamento.valorpagamento, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valorpagamento, ');
      SQL.Add('obraericssonpagamento.observacao ');
      SQL.Add('From ');
      SQL.Add('obraericssonfechamento Inner Join  ');
      SQL.Add('obraericssonpagamento On obraericssonpagamento.idgeralfechamento = obraericssonfechamento.geral left Join  ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle left Join  ');
      SQL.Add('emailregional On emailregional.regional = obraericsson.regiona Left Join  ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM where obraericssonfechamento.geral is not null  ');

      if AQuery.ContainsKey('empresalocal') then
      begin
        if Length(AQuery.Items['empresalocal']) > 0 then
        begin
          SQL.Add('AND(obraericssonfechamento.EMPRESA like ''%' + AQuery.Items['empresalocal'] + '%'') ');
        end;
      end;

      if AQuery.ContainsKey('datapagamento') then
      begin
        if AQuery.Items['datapagamento'] <> '' then
        begin
          SQL.Add(' AND(obraericssonpagamento.datadopagamento like ''%' + AQuery.Items['datapagamento'] + '%'') ');
        end;
      end;

      if AQuery.ContainsKey('status') then
      begin
        if AQuery.Items['status'] <> '' then
        begin
          SQL.Add(' AND(obraericssonpagamento.status like ''%' + AQuery.Items['status'] + '%'') ');
        end;
      end;

      a := AQuery.Items['empresalocal'];
      if AQuery.ContainsKey('mespagamento') then
      begin
        if Length(AQuery.Items['mespagamento']) > 0 then
        begin
          SQL.Add('AND(obraericssonpagamento.mespagamento like ''%' + AQuery.Items['mespagamento'] + '%'') ');
        end;
      end;

{*      if AQuery.ContainsKey('numero') then
      begin
        if Length(AQuery.Items['numero']) > 0 then
        begin
          SQL.Add('AND(obraericssonpagamento.numero like ''%' + AQuery.Items['numero'] + '%'') ');
        end;
      end;                              }
      b := AQuery.Items['mespagamento'];
      SQL.Add('order by IDSydle, obraericssonfechamento.descricao,obraericssonfechamento.poitem');
      Open();
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

function TProjetoericsson.extratopagamentodesconto(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a, b: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select  ');
      SQL.Add('COALESCE( obraericssonpagamentodesconto.desconto, 0) as desconto,  ');
      SQL.Add('obraericssonpagamentodesconto.motivo,  ');
      SQL.Add('obraericssonpagamentodesconto.subtotal,  ');
      SQL.Add('obraericssonpagamentodesconto.total  ');
      SQL.Add('From  ');
      SQL.Add('obraericssonpagamentodesconto where idgeral is not null ');
      if AQuery.ContainsKey('empresalocal') then
      begin
        if Length(AQuery.Items['empresalocal']) > 0 then
        begin
          SQL.Add(' AND(obraericssonpagamentodesconto.EMPRESA like ''%' + AQuery.Items['empresalocal'] + '%'') ');
        end;
      end;

      if AQuery.ContainsKey('mespagamento') then
      begin
        if Length(AQuery.Items['mespagamento']) > 0 then
        begin
          SQL.Add(' AND(obraericssonpagamentodesconto.mespagamento like ''%' + AQuery.Items['mespagamento'] + '%'') ');
        end;
      end;
{*      if AQuery.ContainsKey('numero') then
      begin
        if Length(AQuery.Items['numero']) > 0 then
        begin
          SQL.Add('AND(obraericssonpagamentodesconto.numero like ''%' + AQuery.Items['numero'] + '%'') ');
        end;
      end;  *}

      Open();
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

function TProjetoericsson.extratopagamentototal(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a, b: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(sum(obraericssonpagamento.valorpagamento), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as total, ');
      SQL.Add('sum(obraericssonpagamento.valorpagamento) as totalsimples ');
      SQL.Add('From ');
      SQL.Add('obraericssonfechamento Inner Join ');
      SQL.Add('obraericssonpagamento On obraericssonpagamento.idgeralfechamento = obraericssonfechamento.geral where obraericssonfechamento.geral is not null ');
      if AQuery.ContainsKey('empresalocal') then
      begin
        if Length(AQuery.Items['empresalocal']) > 0 then
        begin
          SQL.Add(' AND(obraericssonfechamento.EMPRESA like ''%' + AQuery.Items['empresalocal'] + '%'') ');
        end;
      end;
      a := AQuery.Items['empresalocal'];
      if AQuery.ContainsKey('mespagamento') then
      begin
        if Length(AQuery.Items['mespagamento']) > 0 then
        begin
          SQL.Add(' AND(obraericssonpagamento.mespagamento like ''%' + AQuery.Items['mespagamento'] + '%'') ');
        end;
      end;
      if AQuery.ContainsKey('datapagamento') then
      begin
        if AQuery.Items['datapagamento'] <> '' then
        begin
          SQL.Add(' AND(obraericssonpagamento.datadopagamento like ''%' + AQuery.Items['datapagamento'] + '%'') ');
        end;
      end;

      if AQuery.ContainsKey('status') then
      begin
        if AQuery.Items['status'] <> '' then
        begin
          SQL.Add(' AND(obraericssonpagamento.status like ''%' + AQuery.Items['status'] + '%'') ');
        end;
      end;
 {*     if AQuery.ContainsKey('numero') then
      begin
        if Length(AQuery.Items['numero']) > 0 then
        begin
          SQL.Add('AND(obraericssonpagamento.numero like ''%' + AQuery.Items['numero'] + '%'') ');
        end;
      end;
      b := AQuery.Items['mespagamento'];*}
      SQL.Add('order by IDSydle, obraericssonfechamento.descricao,obraericssonfechamento.poitem');
      Open();
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

function TProjetoericsson.historicopagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  a, b: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      sql.add('SET @contador := 0; ');
      sql.add('SELECT ');
      sql.add('@contador := @contador + 1 AS id, ');
      SQL.Add('obraericssonfechamento.geral, ');
      SQL.Add('obraericssonfechamento.PO, ');
      SQL.Add('obraericssonfechamento.POITEM, ');
      SQL.Add('obraericssonmigo.siteid as Sigla, ');
      SQL.Add('obraericssonfechamento.IDSydle, ');
      SQL.Add('obraericssonfechamento.Cliente, ');
      SQL.Add('obraericssonfechamento.estado, ');
      SQL.Add('obraericssonfechamento.Codigo, ');
      SQL.Add('obraericssonfechamento.Descricao, ');
      SQL.Add('obraericssonpagamento.mespagamento, ');
      SQL.Add('obraericssonpagamento.numero, ');
      SQL.Add('FORMAT((obraericssonpagamento.porcentagem * 100), 2) as porcentagem  , ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(obraericssonpagamento.valorpagamento, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valorpagamento, ');
      SQL.Add('obraericssonpagamento.observacao ');
      SQL.Add('From ');
      SQL.Add('obraericssonfechamento Inner Join  ');
      SQL.Add('obraericssonpagamento On obraericssonpagamento.idgeralfechamento = obraericssonfechamento.geral Inner Join  ');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join  ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM  where obraericssonfechamento.geral is not null  ');
      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND(obraericssonfechamento.EMPRESA like ''%' + AQuery.Items['busca'] + '%'') ');
        end;
      end;
      if AQuery.ContainsKey('sig') then
      begin
        if Length(AQuery.Items['sig']) > 0 then
        begin
          SQL.Add('AND(obraericssonfechamento.sigla =:sig ');
          SQL.Add('or obraericssonfechamento.IdSydle =:sig ) ');
          ParamByName('sig').asstring := AQuery.Items['sig'];
        end;
        a := AQuery.Items['sig'];
      end;
      SQL.Add('order by IDSydle, obraericssonfechamento.POITEM, obraericssonpagamento.mespagamento, obraericssonfechamento.descricao');
      Open();
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

function TProjetoericsson.atualizarlpu(out erro: string): Boolean;
var
  qry1, qry2: TFDQuery;
begin

  try
    qry1 := TFDQuery.Create(nil);
    qry2 := TFDQuery.Create(nil);
    qry1.connection := FConn;
    qry2.connection := FConn;
    try
      FConn.StartTransaction;
      with qry1 do
      begin
        Active := false;
        sql.Clear;
        sql.add('select * from obraericssonlpunova ');
        Open;
        while not Eof do
        begin
          with qry2 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('select * from obraericssonlpu where codigo=:codigo ');
            ParamByName('codigo').AsString := qry1.FieldByName('codigo').asstring;
            Open();
            if recordcount = 0 then
            begin
              Close;
              SQL.Clear;
              sql.Add('insert into obraericssonlpu(descricaoatividade,codigo,Valor )');
              sql.add('                    values(:descricaoatividade,:codigo,:Valor)');
            end
            else
            begin
              Close;
              SQL.Clear;
              sql.Add('update obraericssonlpu set descricaoatividade=:descricaoatividade,Valor=:Valor  where codigo=:codigo ');
            end;
            ParamByName('descricaoatividade').asstring := qry1.FieldByName('DESCRICAOATIVIDADE').asstring;
            ParamByName('codigo').asstring := qry1.FieldByName('codigo').asstring;
            ParamByName('Valor').asfloat := qry1.FieldByName('VALOR').asfloat;
            ExecSQL;

          end;
          Next;

        end;
      end;
      erro := '';
      FConn.Commit;
      Result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao Atualizar LPU: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry1.Free;
    qry2.Free;
  end;

end;

function TProjetoericsson.Editar(out erro: string): Boolean;
var
  qry: TFDQuery;
begin
  Result := False;
  erro := '';
  qry := TFDQuery.Create(nil);

  try
    qry.Connection := FConn;
    FConn.StartTransaction;

    try
      // Verifica se já existe por NUMERO
      qry.Active := False;
      qry.SQL.Text := 'SELECT 1 FROM obraericsson WHERE numero = :numero';
      qry.ParamByName('numero').DataType := ftString;
      qry.ParamByName('numero').AsString := numero;
      qry.Open;

      qry.Close;
      qry.SQL.Clear;

      if qry.RecordCount = 0 then
      begin
        // =============== INSERT ===============
        qry.SQL.Add('INSERT INTO obraericsson('+
          'numero, cliente, regiona, site, situacaoimplantacao, situacaodaintegracao,'+
          'datadacriacaodademandadia, dataaceitedemandadia, datainicioentregamosplanejadodia,'+
          'datarecebimentodositemosreportadodia, datafiminstalacaoplanejadodia, dataconclusaoreportadodia,'+
          'datavalidacaoinstalacaodia, dataintegracaoplanejadodia, datavalidacaoeriboxedia,'+
          'statussydle, atividade, tipoinstalacao, impacto, ncrq, iniciocrq, fimcrq, statuscrq, crqdeinstalacao,'+
          'observacoes, central, detentora, iddentedora, numeroativo, obraPreenchidaNaSydle, enderecoSite,'+
          'dataativacaoplanejadodia, dataativacaoreportadodia, datavalidacaoativacaodia, dataaceiteeriboxedia, dataativacaoeriboxedia,'+
          'outros, formadeacesso, ddd, municipio, nomeericsson, latitude, longitude, obs, solicitacao, statusacesso,'+
          'datasolicitacao, datainicial, datafinal, localizacaositeendereco) '+
          'VALUES ('+
          ':numero, :cliente, :regiona, :site, :situacaoimplantacao, :situacaodaintegracao,'+
          ':datadacriacaodademandadia, :dataaceitedemandadia, :datainicioentregamosplanejadodia,'+
          ':datarecebimentodositemosreportadodia, :datafiminstalacaoplanejadodia, :dataconclusaoreportadodia,'+
          ':datavalidacaoinstalacaodia, :dataintegracaoplanejadodia, :datavalidacaoeriboxedia,'+
          ':statussydle, :atividade, :tipoinstalacao, :impacto, :ncrq, :iniciocrq, :fimcrq, :statuscrq, :crqdeinstalacao,'+
          ':observacoes, :central, :detentora, :iddentedora, :numeroativo, :obraPreenchidaNaSydle, :enderecoSite,'+
          ':dataativacaoplanejadodia, :dataativacaoreportadodia, :datavalidacaoativacaodia, :dataaceiteeriboxedia, :dataativacaoeriboxedia,'+
          ':outros, :formadeacesso, :ddd, :municipio, :nomeericsson, :latitude, :longitude, :obs, :solicitacao, :statusacesso,'+
          ':datasolicitacao, :datainicial, :datafinal, :localizacaositeendereco)');
      end
      else
      begin
        // =============== UPDATE ===============
        qry.SQL.Add('UPDATE obraericsson SET');
        qry.SQL.Add('  cliente=:cliente, regiona=:regiona, site=:site,');
        qry.SQL.Add('  situacaoimplantacao=:situacaoimplantacao, situacaodaintegracao=:situacaodaintegracao,');
        qry.SQL.Add('  datadacriacaodademandadia=:datadacriacaodademandadia, dataaceitedemandadia=:dataaceitedemandadia,');
        qry.SQL.Add('  datainicioentregamosplanejadodia=:datainicioentregamosplanejadodia,');
        qry.SQL.Add('  datarecebimentodositemosreportadodia=:datarecebimentodositemosreportadodia,');
        qry.SQL.Add('  datafiminstalacaoplanejadodia=:datafiminstalacaoplanejadodia, dataconclusaoreportadodia=:dataconclusaoreportadodia,');
        qry.SQL.Add('  datavalidacaoinstalacaodia=:datavalidacaoinstalacaodia, dataintegracaoplanejadodia=:dataintegracaoplanejadodia,');
        qry.SQL.Add('  datavalidacaoeriboxedia=:datavalidacaoeriboxedia,');
        qry.SQL.Add('  statussydle=:statussydle, atividade=:atividade, tipoinstalacao=:tipoinstalacao, impacto=:impacto, ncrq=:ncrq,');
        qry.SQL.Add('  iniciocrq=:iniciocrq, fimcrq=:fimcrq, statuscrq=:statuscrq, crqdeinstalacao=:crqdeinstalacao, observacoes=:observacoes,');
        qry.SQL.Add('  central=:central, detentora=:detentora, iddentedora=:iddentedora, numeroativo=:numeroativo,');
        qry.SQL.Add('  obraPreenchidaNaSydle=:obraPreenchidaNaSydle, enderecoSite=:enderecoSite,');
        qry.SQL.Add('  dataativacaoplanejadodia=:dataativacaoplanejadodia, dataativacaoreportadodia=:dataativacaoreportadodia,');
        qry.SQL.Add('  datavalidacaoativacaodia=:datavalidacaoativacaodia, dataaceiteeriboxedia=:dataaceiteeriboxedia, dataativacaoeriboxedia=:dataativacaoeriboxedia,');
        qry.SQL.Add('  outros=:outros, formadeacesso=:formadeacesso, ddd=:ddd, municipio=:municipio, nomeericsson=:nomeericsson,');
        qry.SQL.Add('  latitude=:latitude, longitude=:longitude, obs=:obs, solicitacao=:solicitacao, statusacesso=:statusacesso,');
        qry.SQL.Add('  datasolicitacao=:datasolicitacao, datainicial=:datainicial, datafinal=:datafinal, localizacaositeendereco=:localizacaositeendereco');
        qry.SQL.Add('WHERE numero = :numero');
      end;

      // --------- PARAMETRIZAÇÃO ---------
      qry.Prepare;

      // Strings simples
      qry.ParamByName('numero').AsString := numero;
      qry.ParamByName('cliente').AsString := cliente;
      qry.ParamByName('regiona').AsString := regiona;
      qry.ParamByName('site').AsString := site;
      qry.ParamByName('situacaoimplantacao').AsString := situacaoimplantacao;
      qry.ParamByName('situacaodaintegracao').AsString := situacaodaintegracao;

      // Datas (usa seu helper)
      SetDateParamExplicit(qry, 'datadacriacaodademandadia', datadacriacaodademandadia);
      SetDateParamExplicit(qry, 'dataaceitedemandadia', dataaceitedemandadia);
      SetDateParamExplicit(qry, 'datainicioentregamosplanejadodia', datainicioentregamosplanejadodia);
      SetDateParamExplicit(qry, 'datarecebimentodositemosreportadodia', datarecebimentodositemosreportadodia);
      SetDateParamExplicit(qry, 'datafiminstalacaoplanejadodia', datafiminstalacaoplanejadodia);
      SetDateParamExplicit(qry, 'dataconclusaoreportadodia', dataconclusaoreportadodia);
      SetDateParamExplicit(qry, 'datavalidacaoinstalacaodia', datavalidacaoinstalacaodia);
      SetDateParamExplicit(qry, 'dataintegracaoplanejadodia', dataintegracaoplanejadodia);
      SetDateParamExplicit(qry, 'datavalidacaoeriboxedia', datavalidacaoeriboxedia);

      // Novos campos
      qry.ParamByName('statussydle').AsString := statussydle;
      qry.ParamByName('atividade').AsString := atividade;
      qry.ParamByName('tipoinstalacao').AsString := tipoinstalacao;
      qry.ParamByName('impacto').AsString := impacto;
      qry.ParamByName('ncrq').AsString := ncrq;
      SetDateParamExplicit(qry, 'iniciocrq', iniciocrq);
      SetDateParamExplicit(qry, 'fimcrq', fimcrq);
      qry.ParamByName('statuscrq').AsString := statuscrq;
      qry.ParamByName('crqdeinstalacao').AsString := crqdeinstalacao;
      qry.ParamByName('observacoes').AsString := observacoes;
      qry.ParamByName('central').AsString := central;
      qry.ParamByName('detentora').AsString := detentora;

      // BIGINT iddentedora
      qry.ParamByName('iddentedora').DataType := ftLargeint;
      if iddentedora = 0 then qry.ParamByName('iddentedora').Clear
      else qry.ParamByName('iddentedora').AsLargeInt := iddentedora;

      qry.ParamByName('numeroativo').AsString := numeroativo;
      qry.ParamByName('obraPreenchidaNaSydle').AsString := obraPreenchidaNaSydle;
      qry.ParamByName('enderecoSite').AsString := enderecoSite;

      SetDateParamExplicit(qry, 'dataativacaoplanejadodia', dataativacaoplanejadodia);
      SetDateParamExplicit(qry, 'dataativacaoreportadodia', dataativacaoreportadodia);
      SetDateParamExplicit(qry, 'datavalidacaoativacaodia', datavalidacaoativacaodia);
      SetDateParamExplicit(qry, 'dataaceiteeriboxedia', dataaceiteeriboxedia);
      SetDateParamExplicit(qry, 'dataativacaoeriboxedia', dataativacaoeriboxedia);

      qry.ParamByName('outros').AsString := outros;
      qry.ParamByName('formadeacesso').AsString := formadeacesso;
      qry.ParamByName('ddd').AsString := ddd;
      qry.ParamByName('municipio').AsString := municipio;
      qry.ParamByName('nomeericsson').AsString := nomeericsson;
      qry.ParamByName('latitude').AsString := latitude;
      qry.ParamByName('longitude').AsString := longitude;
      qry.ParamByName('obs').AsString := obs;
      qry.ParamByName('solicitacao').AsString := solicitacao;
      qry.ParamByName('statusacesso').AsString := statusacesso;

      // Datas extras camelCase
      SetDateParamExplicit(qry, 'datasolicitacao', datasolicitacao);
      SetDateParamExplicit(qry, 'datainicial', datainicial);
      SetDateParamExplicit(qry, 'datafinal', datafinal);

      // Campo legado mapeado pro mesmo valor do endereço de site
      qry.ParamByName('localizacaositeendereco').AsString := enderecoSite;

      // Executa
      qry.ExecSQL;

      FConn.Commit;
      Result := True;

    except
      on ex: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao editar registro: ' + ex.Message;
        Result := False;
      end;
    end;

  finally
    qry.Free;
  end;
end;


function TProjetoericsson.EditarEmMassaRollout(const Numeros: TArray<string>; out erro: string): Boolean;

  function ValidStatusAcesso(const Value: string): Boolean;
  const
    StatusValidos: array[0..5] of string = ('AGUARDANDO','CANCELADO','CONCLUIDO','LIBERADO','PEDIR','REJEITADO');
  var
    S: string;
    i: Integer;
  begin
    Result := False;
    S := UpperCase(Trim(Value));
    for i := Low(StatusValidos) to High(StatusValidos) do
      if StatusValidos[i] = S then
        Exit(True);
  end;

  procedure AddSetIfFilled(SQLText: TStringList; const FieldName, ParamName, Value: string);
  begin
    if Trim(Value) <> '' then
      SQLText.Add('  ' + FieldName + ' = :' + ParamName + ',');
  end;

  procedure AddSetDateIfFilled(SQLText: TStringList; const FieldName, ParamName, Value: string);
  begin
    if Trim(Value) <> '' then
      SQLText.Add('  ' + FieldName + ' = :' + ParamName + ',');
  end;

var
  qry: TFDQuery;
  SQLText: TStringList;
  i: Integer;
begin
  Result := False;
  erro := '';

  if Length(Numeros) = 0 then
  begin
    erro := 'Nenhum número informado para atualização.';
    Exit;
  end;

  qry := TFDQuery.Create(nil);
  SQLText := TStringList.Create;
  try
    qry.Connection := FConn;
    FConn.StartTransaction;
    try
      SQLText.Add('UPDATE obraericsson SET');

      // ------------ TEXTOS (apenas se vierem preenchidos) ------------
      AddSetIfFilled(SQLText, 'cliente', 'cliente', cliente);
      AddSetIfFilled(SQLText, 'regiona', 'regiona', regiona);
      AddSetIfFilled(SQLText, 'site', 'site', site);
      AddSetIfFilled(SQLText, 'situacaoimplantacao', 'situacaoimplantacao', situacaoimplantacao);
      AddSetIfFilled(SQLText, 'situacaodaintegracao', 'situacaodaintegracao', situacaodaintegracao);

      if (statusacesso <> '') and ValidStatusAcesso(statusacesso) then
        SQLText.Add('  statusacesso = :statusacesso,');

      AddSetIfFilled(SQLText, 'formadeacesso', 'formadeacesso', formadeacesso);
      AddSetIfFilled(SQLText, 'outros', 'outros', outros);
      AddSetIfFilled(SQLText, 'ddd', 'ddd', ddd);
      AddSetIfFilled(SQLText, 'municipio', 'municipio', municipio);
      AddSetIfFilled(SQLText, 'nomeericsson', 'nomeericsson', nomeericsson);
      AddSetIfFilled(SQLText, 'localizacaositeendereco', 'localizacaositeendereco', enderecoSite);
      AddSetIfFilled(SQLText, 'solicitacao', 'solicitacao', solicitacao);
      AddSetIfFilled(SQLText, 'latitude', 'latitude', latitude);
      AddSetIfFilled(SQLText, 'longitude', 'longitude', longitude);
      AddSetIfFilled(SQLText, 'obs', 'obs', obs);

      // Novos campos (texto)
      AddSetIfFilled(SQLText, 'statussydle', 'statussydle', statussydle);
      AddSetIfFilled(SQLText, 'atividade', 'atividade', atividade);
      AddSetIfFilled(SQLText, 'tipoinstalacao', 'tipoinstalacao', tipoinstalacao);
      AddSetIfFilled(SQLText, 'impacto', 'impacto', impacto);
      AddSetIfFilled(SQLText, 'ncrq', 'ncrq', ncrq);
      AddSetIfFilled(SQLText, 'statuscrq', 'statuscrq', statuscrq);
      AddSetIfFilled(SQLText, 'crqdeinstalacao', 'crqdeinstalacao', crqdeinstalacao);
      AddSetIfFilled(SQLText, 'observacoes', 'observacoes', observacoes);
      AddSetIfFilled(SQLText, 'central', 'central', central);
      AddSetIfFilled(SQLText, 'detentora', 'detentora', detentora);
      AddSetIfFilled(SQLText, 'numeroativo', 'numeroativo', numeroativo);
      AddSetIfFilled(SQLText, 'obraPreenchidaNaSydle', 'obraPreenchidaNaSydle', obraPreenchidaNaSydle);
      AddSetIfFilled(SQLText, 'enderecoSite', 'enderecoSite', enderecoSite);

      // ------------ DATAS (apenas se vierem preenchidas) ------------
      AddSetDateIfFilled(SQLText, 'datadacriacaodademandadia', 'datadacriacaodademandadia', datadacriacaodademandadia);
      AddSetDateIfFilled(SQLText, 'dataaceitedemandadia', 'dataaceitedemandadia', dataaceitedemandadia);
      AddSetDateIfFilled(SQLText, 'datainicioentregamosplanejadodia', 'datainicioentregamosplanejadodia', datainicioentregamosplanejadodia);
      AddSetDateIfFilled(SQLText, 'datafiminstalacaoplanejadodia', 'datafiminstalacaoplanejadodia', datafiminstalacaoplanejadodia);
      AddSetDateIfFilled(SQLText, 'dataintegracaoplanejadodia', 'dataintegracaoplanejadodia', dataintegracaoplanejadodia);
      AddSetDateIfFilled(SQLText, 'datainicial', 'datainicial', datainicial);
      AddSetDateIfFilled(SQLText, 'datafinal', 'datafinal', datafinal);
      AddSetDateIfFilled(SQLText, 'dataconclusaoreportadodia', 'dataconclusaoreportadodia', dataconclusaoreportadodia);
      AddSetDateIfFilled(SQLText, 'datavalidacaoinstalacaodia', 'datavalidacaoinstalacaodia', datavalidacaoinstalacaodia);
      AddSetDateIfFilled(SQLText, 'datavalidacaoeriboxedia', 'datavalidacaoeriboxedia', datavalidacaoeriboxedia);
      AddSetDateIfFilled(SQLText, 'datasolicitacao', 'datasolicitacao', datasolicitacao);

      // Datas novas
      AddSetDateIfFilled(SQLText, 'iniciocrq', 'iniciocrq', iniciocrq);
      AddSetDateIfFilled(SQLText, 'fimcrq', 'fimcrq', fimcrq);
      AddSetDateIfFilled(SQLText, 'dataativacaoplanejadodia', 'dataativacaoplanejadodia', dataativacaoplanejadodia);
      AddSetDateIfFilled(SQLText, 'dataativacaoreportadodia', 'dataativacaoreportadodia', dataativacaoreportadodia);
      AddSetDateIfFilled(SQLText, 'datavalidacaoativacaodia', 'datavalidacaoativacaodia', datavalidacaoativacaodia);
      AddSetDateIfFilled(SQLText, 'dataaceiteeriboxedia', 'dataaceiteeriboxedia', dataaceiteeriboxedia);
      AddSetDateIfFilled(SQLText, 'dataativacaoeriboxedia', 'dataativacaoeriboxedia', dataativacaoeriboxedia);

      // Remove vírgula final
      if (SQLText.Count > 0) and (SQLText[SQLText.Count-1].EndsWith(',')) then
        SQLText[SQLText.Count-1] := SQLText[SQLText.Count-1].Substring(0, SQLText[SQLText.Count-1].Length-1);

      // WHERE IN pelos N números
      SQLText.Add('WHERE numero IN (' + QuotedStr(Numeros[0]));
      for i := 1 to High(Numeros) do
        SQLText[SQLText.Count-1] := SQLText[SQLText.Count-1] + ',' + QuotedStr(Numeros[i]);
      SQLText[SQLText.Count-1] := SQLText[SQLText.Count-1] + ')';

      // Monta a query final
      qry.SQL.Text := SQLText.Text;

      // Bind textos
      if cliente <> '' then qry.ParamByName('cliente').AsString := cliente;
      if regiona <> '' then qry.ParamByName('regiona').AsString := regiona;
      if site <> '' then qry.ParamByName('site').AsString := site;
      if situacaoimplantacao <> '' then qry.ParamByName('situacaoimplantacao').AsString := situacaoimplantacao;
      if situacaodaintegracao <> '' then qry.ParamByName('situacaodaintegracao').AsString := situacaodaintegracao;
      if (statusacesso <> '') and ValidStatusAcesso(statusacesso) then
        qry.ParamByName('statusacesso').AsString := statusacesso;

      if formadeacesso <> '' then qry.ParamByName('formadeacesso').AsString := formadeacesso;
      if outros <> '' then qry.ParamByName('outros').AsString := outros;
      if ddd <> '' then qry.ParamByName('ddd').AsString := ddd;
      if municipio <> '' then qry.ParamByName('municipio').AsString := municipio;
      if nomeericsson <> '' then qry.ParamByName('nomeericsson').AsString := nomeericsson;
      if enderecoSite <> '' then qry.ParamByName('localizacaositeendereco').AsString := enderecoSite;
      if solicitacao <> '' then qry.ParamByName('solicitacao').AsString := solicitacao;
      if latitude <> '' then qry.ParamByName('latitude').AsString := latitude;
      if longitude <> '' then qry.ParamByName('longitude').AsString := longitude;
      if obs <> '' then qry.ParamByName('obs').AsString := obs;

      // Novos textos
      if statussydle <> '' then qry.ParamByName('statussydle').AsString := statussydle;
      if atividade <> '' then qry.ParamByName('atividade').AsString := atividade;
      if tipoinstalacao <> '' then qry.ParamByName('tipoinstalacao').AsString := tipoinstalacao;
      if impacto <> '' then qry.ParamByName('impacto').AsString := impacto;
      if ncrq <> '' then qry.ParamByName('ncrq').AsString := ncrq;
      if statuscrq <> '' then qry.ParamByName('statuscrq').AsString := statuscrq;
      if crqdeinstalacao <> '' then qry.ParamByName('crqdeinstalacao').AsString := crqdeinstalacao;
      if observacoes <> '' then qry.ParamByName('observacoes').AsString := observacoes;
      if central <> '' then qry.ParamByName('central').AsString := central;
      if detentora <> '' then qry.ParamByName('detentora').AsString := detentora;
      if numeroativo <> '' then qry.ParamByName('numeroativo').AsString := numeroativo;
      if obraPreenchidaNaSydle <> '' then qry.ParamByName('obraPreenchidaNaSydle').AsString := obraPreenchidaNaSydle;
      if enderecoSite <> '' then qry.ParamByName('enderecoSite').AsString := enderecoSite;

      // Datas
      if datadacriacaodademandadia <> '' then SetDateParamExplicit(qry, 'datadacriacaodademandadia', datadacriacaodademandadia);
      if dataaceitedemandadia <> '' then SetDateParamExplicit(qry, 'dataaceitedemandadia', dataaceitedemandadia);
      if datainicioentregamosplanejadodia <> '' then SetDateParamExplicit(qry, 'datainicioentregamosplanejadodia', datainicioentregamosplanejadodia);
      if datafiminstalacaoplanejadodia <> '' then SetDateParamExplicit(qry, 'datafiminstalacaoplanejadodia', datafiminstalacaoplanejadodia);
      if dataintegracaoplanejadodia <> '' then SetDateParamExplicit(qry, 'dataintegracaoplanejadodia', dataintegracaoplanejadodia);
      if datainicial <> '' then SetDateParamExplicit(qry, 'datainicial', datainicial);
      if datafinal <> '' then SetDateParamExplicit(qry, 'datafinal', datafinal);
      if dataconclusaoreportadodia <> '' then SetDateParamExplicit(qry, 'dataconclusaoreportadodia', dataconclusaoreportadodia);
      if datavalidacaoinstalacaodia <> '' then SetDateParamExplicit(qry, 'datavalidacaoinstalacaodia', datavalidacaoinstalacaodia);
      if datavalidacaoeriboxedia <> '' then SetDateParamExplicit(qry, 'datavalidacaoeriboxedia', datavalidacaoeriboxedia);
      if datasolicitacao <> '' then SetDateParamExplicit(qry, 'datasolicitacao', datasolicitacao);

      // Datas novas
      if iniciocrq <> '' then SetDateParamExplicit(qry, 'iniciocrq', iniciocrq);
      if fimcrq <> '' then SetDateParamExplicit(qry, 'fimcrq', fimcrq);
      if dataativacaoplanejadodia <> '' then SetDateParamExplicit(qry, 'dataativacaoplanejadodia', dataativacaoplanejadodia);
      if dataativacaoreportadodia <> '' then SetDateParamExplicit(qry, 'dataativacaoreportadodia', dataativacaoreportadodia);
      if datavalidacaoativacaodia <> '' then SetDateParamExplicit(qry, 'datavalidacaoativacaodia', datavalidacaoativacaodia);
      if dataaceiteeriboxedia <> '' then SetDateParamExplicit(qry, 'dataaceiteeriboxedia', dataaceiteeriboxedia);
      if dataativacaoeriboxedia <> '' then SetDateParamExplicit(qry, 'dataativacaoeriboxedia', dataativacaoeriboxedia);

      // Executa
      qry.ExecSQL;

      FConn.Commit;
      Result := True;

    except
      on ex: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao editar em massa: ' + ex.Message;
        Result := False;
      end;
    end;

  finally
    qry.Free;
    SQLText.Free;
  end;
end;



// Nova procedure com definição explícita de tipo
procedure TProjetoericsson.SetDateParamExplicit(qry: TFDQuery; const paramName: string; const dateValue: string);
var
  dt: TDate;
  year, month, day: Integer;
  sDate: string;
begin
  qry.ParamByName(paramName).DataType := ftDate;

  if dateValue <> '' then
  begin
    // Pega somente os 10 primeiros caracteres (YYYY-MM-DD)
    sDate := Copy(dateValue, 1, 10);

    if (Length(sDate) = 10) and (sDate[5] = '-') and (sDate[8] = '-') then
    begin
      try
        year := StrToInt(Copy(sDate, 1, 4));
        month := StrToInt(Copy(sDate, 6, 2));
        day := StrToInt(Copy(sDate, 9, 2));

        dt := EncodeDate(year, month, day);
        qry.ParamByName(paramName).AsDate := dt;
      except
        qry.ParamByName(paramName).Clear;
      end;
    end
    else
      qry.ParamByName(paramName).Clear;
  end
  else
    qry.ParamByName(paramName).Clear;
end;

function TProjetoericsson.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  busca: string;
begin
  Result := nil;
  erro := '';
  qry := nil;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('SELECT');
      SQL.Add('  obraericsson.id AS obraId,');
      SQL.Add('  obraericsson.numero AS numero,');
      SQL.Add('  obraericsson.rfp,');
      SQL.Add('  obraericsson.cliente,');
      SQL.Add('  obraericsson.regiona,');
      SQL.Add('  obraericsson.site,');
      SQL.Add('  obraericsson.fornecedor,');
      SQL.Add('  obraericsson.situacaoimplantacao,');
      SQL.Add('  obraericsson.situacaodaintegracao,');
      SQL.Add('  obraericsson.datadacriacaodademandadia,');
      SQL.Add('  obraericsson.datalimiteaceitedia,');
      SQL.Add('  obraericsson.dataaceitedemandadia,');
      SQL.Add('  obraericsson.datainicioprevistasolicitantebaselinemosdia,');
      SQL.Add('  obraericsson.datainicioentregamosplanejadodia,');
      SQL.Add('  obraericsson.datarecebimentodositemosreportadodia,');
      SQL.Add('  obraericsson.datafimprevistabaselinefiminstalacaodia,');
      SQL.Add('  obraericsson.datafiminstalacaoplanejadodia,');
      SQL.Add('  obraericsson.dataconclusaoreportadodia,');
      SQL.Add('  obraericsson.datavalidacaoinstalacaodia,');
      SQL.Add('  obraericsson.dataintegracaobaselinedia,');
      SQL.Add('  obraericsson.dataintegracaoplanejadodia,');
      SQL.Add('  obraericsson.datavalidacaoeriboxedia,');
      SQL.Add('  obraericsson.listadepos,');
      SQL.Add('  obraericsson.gestordeimplantacaonome,');
      SQL.Add('  obraericsson.statusrsa,');
      SQL.Add('  obraericsson.rsarsa,');
      SQL.Add('  obraericsson.statusaceitacao,');
      SQL.Add('  obraericsson.datadefimdaaceitacaosydledia,');
      SQL.Add('  obraericsson.ordemdevenda,');
      SQL.Add('  obraericsson.coordenadoaspnome,');
      SQL.Add('  obraericsson.rsavalidacaorsanrotrackerdatafimdia,');
      SQL.Add('  obraericsson.fimdeobraplandia,');
      SQL.Add('  obraericsson.fimdeobrarealdia,');
      SQL.Add('  obraericsson.tipoatualizacaofam,');
      SQL.Add('  obraericsson.sinergia,');
      SQL.Add('  obraericsson.sinergia5g,');
      SQL.Add('  obraericsson.escoponome,');
      SQL.Add('  obraericsson.slapadraoescopodias,');
      SQL.Add('  obraericsson.tempoparalisacaoinstalacaodias,');
      SQL.Add('  obraericsson.localizacaositeendereco,');
      SQL.Add('  obraericsson.localizacaositecidade,');
      SQL.Add('  obraericsson.documentacaosituacao,');
      SQL.Add('  obraericsson.statusdoc,');
      SQL.Add('  obraericsson.aprovacaotodosdocs,');
      SQL.Add('  obraericsson.sitepossuirisco,');
      SQL.Add('  obraericsson.outros,');
      SQL.Add('  obraericsson.formadeacesso,');
      SQL.Add('  obraericsson.ddd,');
      SQL.Add('  obraericsson.municipio,');
      SQL.Add('  obraericsson.nomeericsson,');
      SQL.Add('  obraericsson.latitude,');
      SQL.Add('  obraericsson.longitude,');
      SQL.Add('  obraericsson.obs,');
      SQL.Add('  obraericsson.solicitacao,');
      SQL.Add('  obraericsson.datasolicitacao,');
      SQL.Add('  obraericsson.datainicial,');
      SQL.Add('  obraericsson.datafinal,');
      SQL.Add('  obraericsson.statusacesso,');
      SQL.Add('  obraericsson.statussydle,');
      SQL.Add('  obraericsson.atividade,');
      SQL.Add('  obraericsson.tipoinstalacao,');
      SQL.Add('  obraericsson.impacto,');
      SQL.Add('  obraericsson.ncrq,');
      SQL.Add('  obraericsson.iniciocrq,');
      SQL.Add('  obraericsson.fimcrq,');
      SQL.Add('  obraericsson.statuscrq,');
      SQL.Add('  obraericsson.crqdeinstalacao,');
      SQL.Add('  obraericsson.observacoes,');
      SQL.Add('  obraericsson.central,');
      SQL.Add('  obraericsson.detentora,');
      SQL.Add('  obraericsson.iddentedora,');
      SQL.Add('  obraericsson.numeroativo,');
      SQL.Add('  obraericsson.obraPreenchidaNaSydle,');
      SQL.Add('  obraericsson.enderecoSite,');
      SQL.Add('  obraericsson.dataativacaoplanejadodia,');
      SQL.Add('  obraericsson.dataativacaoreportadodia,');
      SQL.Add('  obraericsson.datavalidacaoativacaodia,');
      SQL.Add('  obraericsson.dataaceiteeriboxedia,');
      SQL.Add('  obraericsson.dataativacaoeriboxedia');
      SQL.Add('FROM obraericsson');
      SQL.Add('WHERE obraericsson.numero IS NOT NULL');
      if AQuery.ContainsKey('rfp') and (Trim(AQuery.Items['rfp']) <> '') then
        SQL.Add('  AND obraericsson.rfp = ' + QuotedStr(Trim(AQuery.Items['rfp'])));
      if AQuery.ContainsKey('numero') and (Trim(AQuery.Items['numero']) <> '') then
        SQL.Add('  AND obraericsson.numero = ' + QuotedStr(Trim(AQuery.Items['numero'])));
      if AQuery.ContainsKey('cliente') and (Trim(AQuery.Items['cliente']) <> '') then
        SQL.Add('  AND obraericsson.cliente = ' + QuotedStr(Trim(AQuery.Items['cliente'])));
      if AQuery.ContainsKey('regional') and (Trim(AQuery.Items['regional']) <> '') then
        SQL.Add('  AND obraericsson.regiona = ' + QuotedStr(Trim(AQuery.Items['regional'])));
      if AQuery.ContainsKey('site') and (Trim(AQuery.Items['site']) <> '') then
        SQL.Add('  AND obraericsson.site = ' + QuotedStr(Trim(AQuery.Items['site'])));
      if AQuery.ContainsKey('fornecedor') and (Trim(AQuery.Items['fornecedor']) <> '') then
        SQL.Add('  AND obraericsson.fornecedor = ' + QuotedStr(Trim(AQuery.Items['fornecedor'])));
      if AQuery.ContainsKey('situacaoimplantacao') and (Trim(AQuery.Items['situacaoimplantacao']) <> '') then
        SQL.Add('  AND obraericsson.situacaoimplantacao = ' + QuotedStr(Trim(AQuery.Items['situacaoimplantacao'])));
      if AQuery.ContainsKey('situacaodaintegracao') and (Trim(AQuery.Items['situacaodaintegracao']) <> '') then
        SQL.Add('  AND obraericsson.situacaodaintegracao = ' + QuotedStr(Trim(AQuery.Items['situacaodaintegracao'])));
      if AQuery.ContainsKey('datadacriacaodademandadia') and (Trim(AQuery.Items['datadacriacaodademandadia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.datadacriacaodademandadia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['datadacriacaodademandadia'])));
      if AQuery.ContainsKey('datalimiteaceitedia') and (Trim(AQuery.Items['datalimiteaceitedia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.datalimiteaceitedia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['datalimiteaceitedia'])));
      if AQuery.ContainsKey('dataaceitedemandadia') and (Trim(AQuery.Items['dataaceitedemandadia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.dataaceitedemandadia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['dataaceitedemandadia'])));
      if AQuery.ContainsKey('datainicioprevistasolicitantebaselinemosdia') and (Trim(AQuery.Items['datainicioprevistasolicitantebaselinemosdia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.datainicioprevistasolicitantebaselinemosdia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['datainicioprevistasolicitantebaselinemosdia'])));
      if AQuery.ContainsKey('datainicioentregamosplanejadodia') and (Trim(AQuery.Items['datainicioentregamosplanejadodia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.datainicioentregamosplanejadodia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['datainicioentregamosplanejadodia'])));
      if AQuery.ContainsKey('datarecebimentodositemosreportadodia') and (Trim(AQuery.Items['datarecebimentodositemosreportadodia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.datarecebimentodositemosreportadodia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['datarecebimentodositemosreportadodia'])));
      if AQuery.ContainsKey('datafimprevistabaselinefiminstalacaodia') and (Trim(AQuery.Items['datafimprevistabaselinefiminstalacaodia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.datafimprevistabaselinefiminstalacaodia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['datafimprevistabaselinefiminstalacaodia'])));
      if AQuery.ContainsKey('datafiminstalacaoplanejadodia') and (Trim(AQuery.Items['datafiminstalacaoplanejadodia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.datafiminstalacaoplanejadodia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['datafiminstalacaoplanejadodia'])));
      if AQuery.ContainsKey('dataconclusaoreportadodia') and (Trim(AQuery.Items['dataconclusaoreportadodia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.dataconclusaoreportadodia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['dataconclusaoreportadodia'])));
      if AQuery.ContainsKey('datavalidacaoinstalacaodia') and (Trim(AQuery.Items['datavalidacaoinstalacaodia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.datavalidacaoinstalacaodia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['datavalidacaoinstalacaodia'])));
      if AQuery.ContainsKey('dataintegracaobaselinedia') and (Trim(AQuery.Items['dataintegracaobaselinedia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.dataintegracaobaselinedia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['dataintegracaobaselinedia'])));
      if AQuery.ContainsKey('dataintegracaoplanejadodia') and (Trim(AQuery.Items['dataintegracaoplanejadodia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.dataintegracaoplanejadodia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['dataintegracaoplanejadodia'])));
      if AQuery.ContainsKey('datavalidacaoeriboxedia') and (Trim(AQuery.Items['datavalidacaoeriboxedia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.datavalidacaoeriboxedia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['datavalidacaoeriboxedia'])));
      if AQuery.ContainsKey('datadefimdaaceitacaosydledia') and (Trim(AQuery.Items['datadefimdaaceitacaosydledia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.datadefimdaaceitacaosydledia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['datadefimdaaceitacaosydledia'])));
      if AQuery.ContainsKey('rsavalidacaorsanrotrackerdatafimdia') and (Trim(AQuery.Items['rsavalidacaorsanrotrackerdatafimdia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.rsavalidacaorsanrotrackerdatafimdia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['rsavalidacaorsanrotrackerdatafimdia'])));
      if AQuery.ContainsKey('fimdeobraplandia') and (Trim(AQuery.Items['fimdeobraplandia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.fimdeobraplandia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['fimdeobraplandia'])));
      if AQuery.ContainsKey('fimdeobrarealdia') and (Trim(AQuery.Items['fimdeobrarealdia']) <> '') then
        SQL.Add('  AND CAST(obraericsson.fimdeobrarealdia AS DATE) = ' + QuotedStr(Trim(AQuery.Items['fimdeobrarealdia'])));
      if AQuery.ContainsKey('listadepos') and (Trim(AQuery.Items['listadepos']) <> '') then
        SQL.Add('  AND obraericsson.listadepos = ' + QuotedStr(Trim(AQuery.Items['listadepos'])));
      if AQuery.ContainsKey('gestordeimplantacaonome') and (Trim(AQuery.Items['gestordeimplantacaonome']) <> '') then
        SQL.Add('  AND obraericsson.gestordeimplantacaonome = ' + QuotedStr(Trim(AQuery.Items['gestordeimplantacaonome'])));
      if AQuery.ContainsKey('statusrsa') and (Trim(AQuery.Items['statusrsa']) <> '') then
        SQL.Add('  AND obraericsson.statusrsa = ' + QuotedStr(Trim(AQuery.Items['statusrsa'])));
      if AQuery.ContainsKey('rsarsa') and (Trim(AQuery.Items['rsarsa']) <> '') then
        SQL.Add('  AND obraericsson.rsarsa = ' + QuotedStr(Trim(AQuery.Items['rsarsa'])));
      if AQuery.ContainsKey('arqsvalidadapelocliente') and (Trim(AQuery.Items['arqsvalidadapelocliente']) <> '') then
        SQL.Add('  AND obraericsson.arqsvalidadapelocliente = ' + QuotedStr(Trim(AQuery.Items['arqsvalidadapelocliente'])));
      if AQuery.ContainsKey('statusaceitacao') and (Trim(AQuery.Items['statusaceitacao']) <> '') then
        SQL.Add('  AND obraericsson.statusaceitacao = ' + QuotedStr(Trim(AQuery.Items['statusaceitacao'])));
      if AQuery.ContainsKey('ordemdevenda') and (Trim(AQuery.Items['ordemdevenda']) <> '') then
        SQL.Add('  AND obraericsson.ordemdevenda = ' + QuotedStr(Trim(AQuery.Items['ordemdevenda'])));
      if AQuery.ContainsKey('coordenadoaspnome') and (Trim(AQuery.Items['coordenadoaspnome']) <> '') then
        SQL.Add('  AND obraericsson.coordenadoaspnome = ' + QuotedStr(Trim(AQuery.Items['coordenadoaspnome'])));
      if AQuery.ContainsKey('tipoatualizacaofam') and (Trim(AQuery.Items['tipoatualizacaofam']) <> '') then
        SQL.Add('  AND obraericsson.tipoatualizacaofam = ' + QuotedStr(Trim(AQuery.Items['tipoatualizacaofam'])));
      if AQuery.ContainsKey('sinergia') and (Trim(AQuery.Items['sinergia']) <> '') then
        SQL.Add('  AND obraericsson.sinergia = ' + QuotedStr(Trim(AQuery.Items['sinergia'])));
      if AQuery.ContainsKey('sinergia5g') and (Trim(AQuery.Items['sinergia5g']) <> '') then
        SQL.Add('  AND obraericsson.sinergia5g = ' + QuotedStr(Trim(AQuery.Items['sinergia5g'])));
      if AQuery.ContainsKey('escoponome') and (Trim(AQuery.Items['escoponome']) <> '') then
        SQL.Add('  AND obraericsson.escoponome = ' + QuotedStr(Trim(AQuery.Items['escoponome'])));
      if AQuery.ContainsKey('slapadraoescopodias') and (Trim(AQuery.Items['slapadraoescopodias']) <> '') then
        SQL.Add('  AND obraericsson.slapadraoescopodias = ' + Trim(AQuery.Items['slapadraoescopodias']));
      if AQuery.ContainsKey('tempoparalisacaoinstalacaodias') and (Trim(AQuery.Items['tempoparalisacaoinstalacaodias']) <> '') then
        SQL.Add('  AND obraericsson.tempoparalisacaoinstalacaodias = ' + Trim(AQuery.Items['tempoparalisacaoinstalacaodias']));
      if AQuery.ContainsKey('localizacaositeendereco') and (Trim(AQuery.Items['localizacaositeendereco']) <> '') then
        SQL.Add('  AND obraericsson.localizacaositeendereco = ' + QuotedStr(Trim(AQuery.Items['localizacaositeendereco'])));
      if AQuery.ContainsKey('localizacaositecidade') and (Trim(AQuery.Items['localizacaositecidade']) <> '') then
        SQL.Add('  AND obraericsson.localizacaositecidade = ' + QuotedStr(Trim(AQuery.Items['localizacaositecidade'])));
      if AQuery.ContainsKey('documentacaosituacao') and (Trim(AQuery.Items['documentacaosituacao']) <> '') then
        SQL.Add('  AND obraericsson.documentacaosituacao = ' + QuotedStr(Trim(AQuery.Items['documentacaosituacao'])));
      if AQuery.ContainsKey('statusdoc') and (Trim(AQuery.Items['statusdoc']) <> '') then
        SQL.Add('  AND obraericsson.statusdoc = ' + QuotedStr(Trim(AQuery.Items['statusdoc'])));
      if AQuery.ContainsKey('aprovacaotodosdocs') and (Trim(AQuery.Items['aprovacaotodosdocs']) <> '') then
        SQL.Add('  AND obraericsson.aprovacaotodosdocs = ' + QuotedStr(Trim(AQuery.Items['aprovacaotodosdocs'])));
      if AQuery.ContainsKey('sitepossuirisco') and (Trim(AQuery.Items['sitepossuirisco']) <> '') then
        SQL.Add('  AND obraericsson.sitepossuirisco = ' + QuotedStr(Trim(AQuery.Items['sitepossuirisco'])));
      if AQuery.ContainsKey('busca') and (Trim(AQuery.Items['busca']) <> '') then
      begin
        busca := Trim(AQuery.Items['busca']);
        SQL.Add('  AND (obraericsson.numero = ' + QuotedStr(busca));
        SQL.Add('       OR obraericsson.site = ' + QuotedStr(busca));
        SQL.Add('       OR obraericsson.cliente = ' + QuotedStr(busca));
        SQL.Add('       OR obraericsson.rfp = ' + QuotedStr(busca) + ')');
      end;
      SQL.Add('ORDER BY obraericsson.id DESC');
      Active := True;
    end;
    Result := qry;
    qry := nil;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar: ' + ex.Message;
      Result := nil;
    end;
  end;
  qry.Free;
end;



function TProjetoericsson.Listadocumentacaofinal(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  Result := nil;
  erro := '';
  qry := nil;

  try
    try
      qry := TFDQuery.Create(nil);
      qry.Connection := FConn;

      with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('Select ');
        SQL.Add(' * ');
        SQL.Add('From ');
        SQL.Add('obradocumentacaofinal ');
        SQL.Add(' WHERE obradocumentacaofinal.Numero is not null and numero=:numero ');
        ParamByName('numero').AsString := AQuery.Items['idprojetoericsson'];
        Active := true;
      end;

      Result := qry;
      qry := nil;

    except
      on ex: Exception do
      begin
        erro := 'Erro ao consultar: ' + ex.Message;
        Result := nil;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TProjetoericsson.Listadocumentacaofinalcivilwork(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  Result := nil;
  erro := '';
  qry := nil;

  try
    try
      qry := TFDQuery.Create(nil);
      qry.Connection := FConn;

      with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('Select ');
        SQL.Add('obradocumentacaoobracivilworks.geral as id, ');
        SQL.Add('obradocumentacaoobracivilworks.numero, ');
        SQL.Add('obradocumentacaoobracivilworks.site, ');
        SQL.Add('obradocumentacaoobracivilworks.cliente, ');
        SQL.Add('obradocumentacaoobracivilworks.Fornecedor, ');
        SQL.Add('obradocumentacaoobracivilworks.documentacaonome, ');
        SQL.Add('obradocumentacaoobracivilworks.documentacaosituacao, ');
        SQL.Add('obradocumentacaoobracivilworks.documentacaosituacaovalidacao, ');
        SQL.Add('obradocumentacaoobracivilworks.motivorejeicao, ');
        SQL.Add('obradocumentacaoobracivilworks.subtipoobra ');
        SQL.Add('from ');
        SQL.Add('obradocumentacaoobracivilworks ');
        SQL.Add(' WHERE obradocumentacaoobracivilworks.Numero is not null and numero=:numero ');
        ParamByName('numero').AsString := AQuery.Items['idprojetoericsson'];
        Active := true;
      end;

      Result := qry;
      qry := nil;

    except
      on ex: Exception do
      begin
        erro := 'Erro ao consultar: ' + ex.Message;
        Result := nil;
      end;
    end;
  finally
    qry.Free; // Só libera se ocorreu uma exceção antes de setar qry := nil
  end;
end;

function TProjetoericsson.ListaFechamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obraericssonfechamento.geral as id, ');
      SQL.Add('obraericssonfechamento.PO, ');
      SQL.Add('obraericssonfechamento.poitem, ');
      SQL.Add('obraericssonfechamento.Item, ');
      SQL.Add('obraericssonmigo.siteid as Sigla, ');
      SQL.Add('obraericssonfechamento.IDSydle, ');
      SQL.Add('obraericssonfechamento.Cliente, ');
      SQL.Add('obraericssonfechamento.Estado, ');
      SQL.Add('obraericssonfechamento.codigo, ');
      SQL.Add('obraericssonfechamento.descricao, ');
      SQL.Add('DATE_FORMAT(obraericssonfechamento.mosreal,''%d/%m/%Y'') as mosreal,    ');
      SQL.Add('DATE_FORMAT(obraericssonfechamento.instalreal,''%d/%m/%Y'') as instalreal,    ');
      SQL.Add('DATE_FORMAT(obraericssonfechamento.integreal,''%d/%m/%Y'') as integreal,    ');
      SQL.Add('obraericssonfechamento.docinstal, ');
      SQL.Add('obraericssonfechamento.docinfra, ');
      SQL.Add('obraericssonfechamento.FAMMOS, ');
      SQL.Add('obraericssonfechamento.FAMINSTAL, ');
      SQL.Add('obraericssonfechamento.quant, ');
      SQL.Add('obraericssonfechamento.VALORPJ, ');
      SQL.Add('obraericssonfechamento.EMPRESA, ');
      SQL.Add('obraericssonfechamento.DATADEENVIO, ');
      SQL.Add('obraericssonfechamento.mesPAGAMENTO1, ');
      SQL.Add('obraericssonfechamento.porc1, ');
      SQL.Add('obraericssonfechamento.valor1, ');
      SQL.Add('obraericssonfechamento.mesPAGAMENTO2, ');
      SQL.Add('obraericssonfechamento.porc2, ');
      SQL.Add('obraericssonfechamento.valor2,    ');
      SQL.Add('obraericssonfechamento.mesPAGAMENTO3, ');
      SQL.Add('obraericssonfechamento.porc3, ');
      SQL.Add('obraericssonfechamento.valor3,    ');
      SQL.Add('gesempresas.email, ');
      SQL.Add('porcanterior,    ');
      SQL.Add('valoranterior,    ');
      SQL.Add('mesatual,    ');
      SQL.Add('porcatual,    ');
      SQL.Add('valoratual,    ');
      SQL.Add('obraericssonfechamento.obs From obraericssonfechamento   Left Join ');
      SQL.Add('gesempresas On gesempresas.nome = obraericssonfechamento.EMPRESA inner Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM  where (porc1+porc2+porc3) < 1 and  empresa is not null and geral is not null and gesempresas.statusTelequipe = ''ATIVO'' ');
      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND(obraericssonfechamento.EMPRESA like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obraericssonfechamento.PO like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obraericssonfechamento.poitem like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obraericssonfechamento.Sigla like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obraericssonfechamento.IDSydle like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obraericssonfechamento.Estado like ''%' + AQuery.Items['busca'] + '%'' )');
        end;
      end;
      SQL.Add('order by IDSydle, obraericssonfechamento.descricao,obraericssonfechamento.poitem limit 500');
      Open();
    end;
    erro := '';
    Result := qry;
    qry := nil;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;

  end;

end;

function TProjetoericsson.ListaFechamentoporempresa(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
     { SQL.Add('Select ');
      SQL.Add('obraericssonfechamento.geral as id, ');
      SQL.Add('obraericssonfechamento.PO, ');
      SQL.Add('obraericssonfechamento.poitem, ');
      SQL.Add('obraericssonfechamento.Item, ');
      SQL.Add('obraericssonfechamento.Sigla, ');
      SQL.Add('obraericssonfechamento.IDSydle, ');
      SQL.Add('obraericssonfechamento.Cliente, ');
      SQL.Add('obraericssonfechamento.Estado, ');
      SQL.Add('obraericssonfechamento.codigo, ');
      SQL.Add('obraericssonfechamento.descricao, ');
      SQL.Add('Date_Format(obraericsson.datarecebimentodositemosreportadodia, ''%d/%m/%Y'') As mosreal, ');
      SQL.Add('Date_Format(obraericsson.dataconclusaoreportadodia, ''%d/%m/%Y'') As instalreal, ');
      SQL.Add('Date_Format(obraericsson.datavalidacaoeriboxedia, ''%d/%m/%Y'') As integreal, ');
      SQL.Add('obraericssonfechamento.docinstal, ');
      SQL.Add('obraericssonfechamento.docinfra, ');
      SQL.Add('obraericssonfechamento.FAMMOS, ');
      SQL.Add('obraericssonfechamento.FAMINSTAL, ');
      SQL.Add('obraericssonfechamento.quant, ');
      SQL.Add('obraericssonfechamento.VALORPJ, ');
      SQL.Add('obraericssonfechamento.EMPRESA, ');
      SQL.Add('obraericssonfechamento.DATADEENVIO, ');
      SQL.Add('obrasericssonfam.StatusFAMentrega, ');
      SQL.Add('obrasericssonfam.StatusFAMInstalacao, ');
      SQL.Add('obrasericssonlistasites.statusdoc, ');
      SQL.Add('obradocumentacaoobracivilworks.documentacaosituacao, ');
      SQL.Add('gesempresas.email, ');
      SQL.Add('IF( Sum(obraericssonpagamento.porcentagem) < 1 ,  ');
      SQL.Add('FORMAT(((obraericssonfechamento.porc1+obraericssonfechamento.porc2+obraericssonfechamento.porc3) * 100), 2), ');
      SQL.Add('FORMAT(((Sum(obraericssonpagamento.porcentagem)+obraericssonfechamento.porc1+obraericssonfechamento.porc2+obraericssonfechamento.porc3) * 100), 2)) as porcentagem  , ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(Sum(obraericssonpagamento.valorpagamento), 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valorpagamento, ');
      SQL.Add('IF( Sum(obraericssonpagamento.porcentagem) is null ,  ');
      SQL.Add('obraericssonfechamento.OBS, ');
      SQL.Add('obraericssonpagamento.observacao) as observacao   ');

      SQL.Add('From obraericssonfechamento Left Join ');
      SQL.Add('obraericssonpagamento On obraericssonpagamento.idgeralfechamento = obraericssonfechamento.geral  Left Join ');
      SQL.Add('gesempresas On gesempresas.nome = obraericssonfechamento.EMPRESA Left Join ');
      SQL.Add('obrasericssonfam On obrasericssonfam.Obra = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('obrasericssonlistasites On obrasericssonlistasites.SEED = obraericssonfechamento.IDSydle left Join ');
      SQL.Add('obradocumentacaoobracivilworks On obradocumentacaoobracivilworks.numero = obraericssonfechamento.IDSydle left Join');
      SQL.Add('obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle ');     }

      SQL.Add('Select ');
      SQL.Add('obraericssonfechamento.geral As id, ');
      SQL.Add('obraericssonfechamento.PO, ');
      SQL.Add('obraericssonfechamento.POITEM, ');
      SQL.Add('obraericssonfechamento.Item, ');
      SQL.Add('obraericssonmigo.siteid as Sigla, ');
      SQL.Add('obraericssonfechamento.IDSydle, ');
      SQL.Add('obraericssonfechamento.Cliente, ');
      SQL.Add('obraericssonfechamento.Estado, ');
      SQL.Add('obraericssonfechamento.Codigo, ');
      SQL.Add('obraericssonfechamento.Descricao, ');
      SQL.Add('Date_Format(obraericsson.datarecebimentodositemosreportadodia, ''%d/%m/%Y'') As mosreal, ');
      SQL.Add('Date_Format(obraericsson.dataconclusaoreportadodia, ''%d/%m/%Y'') As instalreal, ');
      SQL.Add('Date_Format(obraericsson.datavalidacaoeriboxedia, ''%d/%m/%Y'') As integreal, ');
      SQL.Add('obraericssonfechamento.DOCINSTAL, ');
      SQL.Add('obraericssonfechamento.DOCINFRA, ');
      SQL.Add('obraericssonfechamento.FAMMOS, ');
      SQL.Add('obraericssonfechamento.FAMINSTAL, ');
      SQL.Add('obraericssonfechamento.Quant, ');
      SQL.Add('obraericssonfechamento.VALORPJ, ');
      SQL.Add('obraericssonfechamento.EMPRESA, ');
      SQL.Add('obraericssonfechamento.DATADEENVIO, ');
      SQL.Add('obrasericssonfam.respfamentrega, ');
      SQL.Add('obrasericssonfam.respfaminstalacao, ');
      SQL.Add('obrasericssonlistasites.statusdoc, ');
      SQL.Add('obradocumentacaoobracivilworks.documentacaosituacao, ');
      SQL.Add('gesempresas.email, ');
      SQL.Add('If(pagamentoporc.porcentagem Is Null, Format(((obraericssonfechamento.porc1 + obraericssonfechamento.porc2 + ');
      SQL.Add('obraericssonfechamento.porc3) * 100), 2), Format(((pagamentoporc.porcentagem + obraericssonfechamento.porc1 + ');
      SQL.Add('obraericssonfechamento.porc2 + obraericssonfechamento.porc3) * 100), 2)) As porcentagem, ');
      SQL.Add('Concat(''R$'', Replace(Replace(Replace(Format(pagamentoporc.valorpagamento, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) As valorpagamento, ');
      SQL.Add('If(pagamentoporc.porcentagem Is Null, obraericssonfechamento.OBS, pagamento.observacao) As observacao, pagamento.observacaointerna  ');
      SQL.Add('From ');
      SQL.Add('    obraericssonfechamento Left Join ');
      SQL.Add('    (Select ');
      SQL.Add('         obraericssonpagamento.idgeralfechamento, ');
      SQL.Add('         obraericssonpagamento.mespagamento, ');
      SQL.Add('         obraericssonpagamento.porcentagem, ');
      SQL.Add('         obraericssonpagamento.valorpagamento, ');
      SQL.Add('         obraericssonpagamento.observacao, ');
      SQL.Add('         obraericssonpagamento.observacaointerna ');
      SQL.Add('     From ');
      SQL.Add('         obraericssonpagamento ');
      SQL.Add('     Order By ');
      SQL.Add('         obraericssonpagamento.idgeral Desc) As pagamento On pagamento.idgeralfechamento = obraericssonfechamento.geral ');
      SQL.Add('Left Join ');
      SQL.Add('    (Select ');
      SQL.Add('         Sum(obraericssonpagamento.porcentagem) As porcentagem, ');
      SQL.Add('         Sum(obraericssonpagamento.valorpagamento) As valorpagamento, ');
      SQL.Add('         obraericssonpagamento.idgeralfechamento ');
      SQL.Add('     From ');
      SQL.Add('         obraericssonpagamento ');
      SQL.Add('     Group By ');
      SQL.Add('         obraericssonpagamento.idgeralfechamento) As pagamentoporc On pagamentoporc.idgeralfechamento = ');
      SQL.Add('            obraericssonfechamento.geral Left Join ');
      SQL.Add('    obraericsson On obraericsson.numero = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('    obrasericssonfam On obrasericssonfam.Obra = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('    obradocumentacaoobracivilworks On obradocumentacaoobracivilworks.numero = obraericssonfechamento.IDSydle Left Join ');
      SQL.Add('    obrasericssonlistasites On obrasericssonlistasites.SEED = obraericssonfechamento.IDSydle left Join ');
      SQL.Add('    gesempresas On obraericssonfechamento.EMPRESA = gesempresas.nome  Left Join ');
      SQL.Add('    obraericssonmigo On obraericssonmigo.poritem = obraericssonfechamento.POITEM ');
      SQL.Add('where ((obraericssonfechamento.porc1 + obraericssonfechamento.porc2 + obraericssonfechamento.porc3 + coalesce(pagamentoporc.porcentagem,0)) < 1) And obraericssonfechamento.empresa is not null and obraericssonfechamento.geral is not null ');
      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND(obraericssonfechamento.EMPRESA like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obraericssonfechamento.PO like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obraericssonfechamento.poitem like ''%' + AQuery.Items['busca'] + '%'' ');
          SQL.Add('or obraericssonfechamento.Estado like ''%' + AQuery.Items['busca'] + '%'' )');
        end;
        a := AQuery.Items['busca'];
      end;
      if AQuery.ContainsKey('sig') then
      begin
        if Length(AQuery.Items['sig']) > 0 then
        begin
          SQL.Add('AND(obraericssonfechamento.sigla =:sig ');
          SQL.Add('or obraericssonfechamento.IdSydle =:sig ) ');
          ParamByName('sig').asstring := AQuery.Items['sig'];
        end;
        a := AQuery.Items['busca'];
      end;
      if AQuery.ContainsKey('datainicioop') then
      begin
        if Length(AQuery.Items['datainicioop']) > 0 then
        begin
          SQL.Add('and ((obraericsson.datarecebimentodositemosreportadodia between :dt1 and :dt2) or ');
          SQL.Add('(obraericsson.dataconclusaoreportadodia between :dt1 and :dt2) or ');
          SQL.Add('(obraericsson.datavalidacaoeriboxedia between :dt1 and :dt2)) ');
          ParamByName('dt1').asstring := '2000-04-01';
          ParamByName('dt2').asstring := (AQuery.Items['datafimop']);
          a := (AQuery.Items['datainicioop']);
        end;

      end;
      SQL.Add('Group By obraericssonfechamento.geral  order by CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(poitem, '' '', -1), '' '', 1) AS UNSIGNED) , IDSydle, obraericssonfechamento.descricao  limit 500');
      Open();
    end;
    erro := '';
    Result := qry;
    qry := nil;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;

  end;

end;

function TProjetoericsson.listagemgrupolpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      sql.add('SET @contador := 0; ');
      sql.add('SELECT ');
      sql.add('@contador := @contador + 1  As value, ');
      SQL.Add('obraericssonlpu.historico As label ');
      SQL.Add('From ');
      SQL.Add('obraericssonlpu where historico <> ''NEGOCIADO'' ');
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND obraericssonlpu.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      SQL.Add('Group By ');
      SQL.Add('obraericssonlpu.historico ');
      Active := true;
    end;
    erro := '';
    Result := qry;
    qry := nil;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;

end;

function TProjetoericsson.listagemlpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obraericssonlpu.geral As id, ');
      SQL.Add('obraericssonlpu.PROJETO, ');
      SQL.Add('obraericssonlpu.DESCRICAOATIVIDADE, ');
      SQL.Add('obraericssonlpu.CODIGO, ');
      SQL.Add('obraericssonlpu.ESTADO, ');
      SQL.Add('obraericssonlpu.NOMEESTADO, ');
      SQL.Add('obraericssonlpu.REGIAO, ');
      SQL.Add('obraericssonlpu.LOCALIDADE, ');
      SQL.Add('obraericssonlpu.AREA, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(obraericssonlpu.valor, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valor, ');
      SQL.Add('obraericssonlpu.historico, ');
      SQL.Add('obraericssonlpu.idcolaborador ');
      SQL.Add('From obraericssonlpu where  obraericssonlpu.geral is not null ');
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND obraericssonlpu.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      Active := true;
    end;
    erro := '';
    Result := qry;
    qry := nil;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;



function TProjetoericsson.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('SELECT ');
      SQL.Add('  obraericsson.numero AS id,');
      SQL.Add('  obraericsson.rfp,');
      SQL.Add('  obraericsson.cliente,');
      SQL.Add('  obraericsson.regiona,');
      SQL.Add('  obraericsson.site,');
      SQL.Add('  obraericsson.fornecedor,');
      SQL.Add('  obraericsson.situacaoimplantacao,');
      SQL.Add('  obraericsson.situacaodaintegracao,');
      SQL.Add('  obraericsson.datadacriacaodademandadia,');
      SQL.Add('  obraericsson.datalimiteaceitedia,');
      SQL.Add('  obraericsson.dataaceitedemandadia,');
      SQL.Add('  obraericsson.datainicioprevistasolicitantebaselinemosdia,');
      SQL.Add('  obraericsson.datainicioentregamosplanejadodia,');
      SQL.Add('  obraericsson.datarecebimentodositemosreportadodia,');
      SQL.Add('  obraericsson.datafimprevistabaselinefiminstalacaodia,');
      SQL.Add('  obraericsson.datafiminstalacaoplanejadodia,');
      SQL.Add('  obraericsson.dataconclusaoreportadodia,');
      SQL.Add('  obraericsson.datavalidacaoinstalacaodia,');
      SQL.Add('  obraericsson.dataintegracaobaselinedia,');
      SQL.Add('  obraericsson.dataintegracaoplanejadodia,');
      SQL.Add('  obraericsson.datavalidacaoeriboxedia,');
      SQL.Add('  obraericsson.listadepos,');
      SQL.Add('  obraericsson.gestordeimplantacaonome,');
      SQL.Add('  obraericsson.statusrsa,');
      SQL.Add('  obraericsson.rsarsa,');
      SQL.Add('  obraericsson.statusaceitacao,');
      SQL.Add('  obraericsson.datadefimdaaceitacaosydledia,');
      SQL.Add('  obraericsson.ordemdevenda,');
      SQL.Add('  obraericsson.coordenadoaspnome,');
      SQL.Add('  obraericsson.rsavalidacaorsanrotrackerdatafimdia,');
      SQL.Add('  obraericsson.fimdeobraplandia,');
      SQL.Add('  obraericsson.fimdeobrarealdia,');
      SQL.Add('  obraericsson.tipoatualizacaofam,');
      SQL.Add('  obraericsson.sinergia,');
      SQL.Add('  obraericsson.sinergia5g,');
      SQL.Add('  obraericsson.escoponome,');
      SQL.Add('  obraericsson.slapadraoescopodias,');
      SQL.Add('  obraericsson.tempoparalisacaoinstalacaodias,');
      SQL.Add('  obraericsson.localizacaositeendereco,');
      SQL.Add('  obraericsson.localizacaositeCidade,');
      SQL.Add('  obraericsson.documentacaosituacao,');
      SQL.Add('obraericsson.statusdoc,');
      SQL.Add('obraericsson.aprovacaotodosdocs,');
      SQL.Add('  obraericsson.sitepossuirisco,');
      SQL.Add('  obraericsson.formadeacesso,');
      SQL.Add('  obraericsson.outros,');
      SQL.Add('  obraericsson.ddd,');
      SQL.Add('  obraericsson.municipio,');
      SQL.Add('  obraericsson.nomeericsson,');
      SQL.Add('  obraericsson.latitude,');
      SQL.Add('  obraericsson.longitude,');
      SQL.Add('  obraericsson.obs,');
      SQL.Add('  obraericsson.solicitacao,');
      SQL.Add('  obraericsson.datasolicitacao,');
      SQL.Add('  obraericsson.datainicial,');
      SQL.Add('  obraericsson.datafinal,');
      SQL.Add('  obraericsson.statusacesso,');
      SQL.Add('  obrasericssonlistasites.aceitacaofinal AS aceitacaofical,');
      SQL.Add('  obrasericssonlistasites.PendenciasObra,');
      SQL.Add('  emailregional.emailacionamento,');
      SQL.Add('  CASE ');
      SQL.Add('    WHEN obraericsson.datafinal IS NULL THEN NULL');
      SQL.Add('    WHEN DATE(obraericsson.datafinal) = CURDATE() THEN "Vencido"');
      SQL.Add('    WHEN DATE(obraericsson.datafinal) BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY) THEN "A vencer"');
      SQL.Add('    ELSE ""');
      SQL.Add('  END AS status_vencimento');
      SQL.Add('FROM obraericsson');
      SQL.Add('LEFT JOIN obrasericssonlistasites ON obrasericssonlistasites.SEED = obraericsson.numero');
      SQL.Add('LEFT JOIN emailregional ON emailregional.regional = obraericsson.regiona');
      SQL.Add('WHERE obraericsson.numero IS NOT NULL AND obraericsson.numero = :numero');

      ParamByName('numero').AsString := AQuery.Items['idprojetoericsson'];
      Active := True;
    end;
    erro := '';
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar: ' + ex.Message;
      Result := nil;
    end;
  end;
end;


function TProjetoericsson.Listaadicid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  str: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('obraericssonmigo.po, ');
      SQL.Add('obraericssonmigo.poritem, ');
      SQL.Add('obraericssonmigo.codigoservico, ');
      SQL.Add('obraericssonmigo.descricaoservico ');
      SQL.Add('From ');
      SQL.Add('obraericssonmigo where poritem=:poritem ');
      ParamByName('poritem').asstring := AQuery.Items['idporitem'];
      Active := true;
    end;
    erro := '';
    Result := qry;
    qry := nil;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TProjetoericsson.Listalpu(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;

    if cr = '0' then
    begin
      with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('Select ');
        SQL.Add('obraericssonlpu.geral as value, ');
        SQL.Add('obraericssonlpu.historico as label ');
        SQL.Add('From ');
        SQL.Add('obraericssonlpu ');
        SQL.Add('where obraericssonlpu.idcolaborador =:idcolaborador ');
        if ((idcolaboradorpj = 140) or (idcolaboradorpj = 144)) then
          ParamByName('idcolaborador').AsInteger := idcolaboradorpj
        else
          ParamByName('idcolaborador').AsInteger := 0;
        if AQuery.ContainsKey('deletado') then
        begin
          if Length(AQuery.Items['deletado']) > 0 then
          begin
            SQL.Add('AND obraericssonlpu.deletado = :deletado');
            ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
          end;
        end;
        SQL.Add('Group By ');
        SQL.Add('obraericssonlpu.historico');
        Active := true;
      end;
    end
    else
    begin
      with qry do
      begin
        Active := false;
        SQL.Clear;
        SQL.Add('Select ');
        SQL.Add('lpucr.id,');
        SQL.Add('lpucr.titulo as value,');
        SQL.Add('Concat(lpucr.titulo,'' '',lpucr.Localidade) as label ');
        SQL.Add('From lpucr');
        Active := true;
      end;
    end;

    erro := '';
    Result := qry;
    qry := nil;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TProjetoericsson.ListaMIGO(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  A: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('obraericssonmigo.poritem as id, ');
      SQL.Add('obraericsson.numero, ');
      SQL.Add('obraericsson.cliente, ');
      SQL.Add('obraericsson.regiona, ');
      SQL.Add('obraericsson.site,obraericssonmigo.siteid, ');
      SQL.Add('obraericssonmigo.po, ');
      SQL.Add('obraericssonmigo.poritem, ');
      SQL.Add('DATE_FORMAT(obraericssonmigo.datacriacaopo,"%d/%m/%Y") as datacriacaopo ,');
      SQL.Add('obraericssonmigo.escopo, ');
      SQL.Add('obraericssonmigo.codigoservico, ');
      SQL.Add('obraericssonmigo.descricaoservico, ');
      SQL.Add('obraericssonmigo.qtyordered, ');
      SQL.Add('obraericsson.coordenadoaspnome, ');
      SQL.Add('obraericsson.gestordeimplantacaonome, ');
      SQL.Add('obraericssonmigo.medidafiltro, ');
      SQL.Add('obraericssonmigo.medidafiltrounitario ');
      SQL.Add('From ');
      SQL.Add('obraericssonmigo,obraericsson ');
      SQL.Add('where obraericsson.numero =:numero and obraericssonmigo.id like ''%' + AQuery.Items['idlocal'] + '%'' order by poritem ');
      parambyname('numero').asstring := AQuery.Items['idlocal'];
      A := AQuery.Items['idlocal'];
      Active := true;
    end;
    erro := '';
    Result := qry;
    qry := nil;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TProjetoericsson.listapagamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add(' obraericssonpagamento.idgeral as id, ');
      SQL.Add(' obraericssonpagamento.mespagamento, ');
      SQL.Add(' FORMAT((obraericssonpagamento.porcentagem * 100), 2) as porcentagem  , ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(obraericssonpagamento.valorpagamento, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valorpagamento, ');
      SQL.Add(' obraericssonpagamento.observacao, ');
      SQL.Add(' obraericssonpagamento.observacaointerna ');
      SQL.Add(' From ');
      SQL.Add(' obraericssonpagamento ');
      SQL.Add(' WHERE obraericssonpagamento.idgeralfechamento =:idgeralfechamento order by idgeral ');
      ParamByName('idgeralfechamento').AsString := AQuery.Items['idgeralfechamento'];
      Active := true;
    end;
    erro := '';
    Result := qry;
    qry := nil;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TProjetoericsson.ListaPO(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  A: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('obraericssonlistapo.id, ');
      SQL.Add('obraericssonlistapo.seed, ');
      SQL.Add('obraericssonlistapo.site, ');
      SQL.Add('obraericssonlistapo.cliente, ');
      SQL.Add('obraericssonlistapo.regional, ');
      SQL.Add('obraericssonlistapo.filtrorfp, ');
      SQL.Add('obraericssonlistapo.fornecedor, ');
      SQL.Add('obraericssonlistapo.statusobra, ');
      SQL.Add('obraericssonlistapo.statusdoc, ');
      SQL.Add('obraericssonlistapo.po, ');
      SQL.Add('obraericssonlistapo.item, ');
      SQL.Add('DATE_FORMAT(obraericssonlistapo.criacaopo,"%d/%m/%Y") as criacaopo ,');
      SQL.Add('obraericssonlistapo.descricao, ');
      SQL.Add('obraericssonlistapo.qtd, ');
      SQL.Add('obraericssonlistapo.grqtd, ');
      SQL.Add('obraericssonlistapo.datamigo, ');
      SQL.Add('obraericssonlistapo.poativa, ');
      SQL.Add('obraericssonlistapo.aprovacaocpm, ');
      SQL.Add('obraericssonlistapo.grdocno, ');
      SQL.Add('obraericssonlistapo.pendenciaobra ');
      SQL.Add('From ');
      SQL.Add('obraericssonlistapo ');
      SQL.Add(' WHERE obraericssonlistapo.site =:site order by po,item ');
      A := AQuery.Items['sitelocal'];
      ParamByName('site').AsString := AQuery.Items['sitelocal'];
      Active := true;
    end;
    erro := '';
    Result := qry;
    qry := nil;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TProjetoericsson.ListaSelect1(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
  A: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('SET @rownum := 0;');
      SQL.Add('SELECT');
      SQL.Add('  @rownum := @rownum + 1 AS id,');
      SQL.Add('obraericssonmigo.poritem as value, ');
      SQL.Add('obraericssonmigo.po, ');
      SQL.Add('obraericssonmigo.escopo, obraericssonmigo.siteid, ');
      SQL.Add('obraericssonmigo.descricaoservico as label ');
      SQL.Add('From ');
      SQL.Add('obraericssonmigo,  ');
      SQL.Add('obraericsson ');
      SQL.Add('where obraericsson.numero =:numero and obraericssonmigo.id like ''%' + AQuery.Items['idlocal'] + '%'' ');
      SQL.Add('Group By ');
      SQL.Add('obraericssonmigo.descricaoservico,obraericssonmigo.po ');
      SQL.Add('Order By ');
      SQL.Add('obraericssonmigo.poritem ');
      parambyname('numero').asstring := AQuery.Items['idlocal'];
      A := AQuery.Items['idlocal'];
      Active := true;
    end;
    erro := '';
    Result := qry;
    qry := nil;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TProjetoericsson.ListaSelectcolaboradorclt(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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

function TProjetoericsson.ListaSelectcolaboradorpj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesempresas.idempresa as value,');
      SQL.Add('gesempresas.nome as label ,');
      SQL.Add('0 as valorhora, ');
      SQL.Add('gesempresas.email,');
      SQL.Add('gesempresas.adicional ');
      SQL.Add('From ');
      SQL.Add('gesempresas ');
      Active := true;
    end;
    erro := '';
    Result := qry;
    qry := nil;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TProjetoericsson.NovoCadastrotarefa(out erro: string): integer;
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
        sql.add('update admponteiro set idtarefamigo = idtarefamigo+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := 1;
        ParamByName('idloja').AsInteger := 1;
        execsql;
        close;
        sql.Clear;
        sql.add('select idtarefamigo from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := 1;
        ParamByName('idloja').AsInteger := 1;
        Open;
        idtarefamigo := fieldbyname('idtarefamigo').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idtarefamigo;
      qry := nil;
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

function TProjetoericsson.Listaatividadeclt(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  try
    Result.Connection := FConn;
    Result.Close;

    with Result.SQL do
    begin
      Clear;
      Add('Select ');
      Add('obraericssonatividadeclt.idgeral as id, ');
      Add('obraericssonatividadeclt.numero, ');
      Add('obraericssonatividadeclt.idcolaboradorclt, ');
      Add('gespessoa.nome as colaboradorclt, ');
      Add('obraericssonatividadeclt.idposervico, ');
      Add('obraericssonatividadeclt.descricaoservico, ');
      Add('DATE_FORMAT(obraericssonatividadeclt.datainicio, "%d/%m/%Y") as datainicio, ');
      Add('DATE_FORMAT(obraericssonatividadeclt.datafin, "%d/%m/%Y") as datafin, ');
      Add('obraericssonatividadeclt.escopo, ');
      Add('obraericssonatividadeclt.po, ');
      Add('obraericssonatividadeclt.totalhorasclt, ');
      Add('obraericssonatividadeclt.valorhora, ');
      Add('obraericssonatividadeclt.horaxvalor, ');
      Add('obraericssonatividadeclt.observacaoclt ');
      Add('From ');
      Add('obraericssonatividadeclt ');
      Add('Left Join gespessoa On gespessoa.idpessoa = obraericssonatividadeclt.idcolaboradorclt ');
      Add('Left Join obraericssonmigo On obraericssonmigo.poritem = obraericssonatividadeclt.idposervico');
      Add('WHERE obraericssonatividadeclt.idgeral is not null ');
      Add('and obraericssonatividadeclt.deletado = 0 ');
      Add('and obraericssonatividadeclt.numero = :numero');
    end;

    Result.ParamByName('numero').AsString := AQuery.Items['idlocal'];
    Result.Open;

    erro := '';

  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar: ' + ex.Message;
      FreeAndNil(Result);
    end;
  end;
end;

function TProjetoericsson.Listaatividadepj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  qry := nil;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('obraericssonatividadepj.idgeral As id, ');
      SQL.Add('gesempresas.nome As fantasia, ');
      SQL.Add('obraericssonatividadepj.po, ');
      SQL.Add('obraericssonatividadepj.poitem, ');
      SQL.Add('obraericssonatividadepj.escopo, ');
      SQL.Add('obraericssonatividadepj.descricaoservico, ');
      SQL.Add('obraericssonatividadepj.codigoservico, ');
      SQL.Add('Date_Format(obraericssonatividadepj.dataacionamento, "%d/%m/%Y") As dataacionamento, ');
      SQL.Add('Date_Format(obraericssonatividadepj.datadeenviodoemail, "%d/%m/%Y %H:%i") As datadeenviodoemail, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(obraericssonatividadepj.valorservico, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valorservico, ');
      SQL.Add('Sum(obraericssonpagamento.porcentagem) As porcentagem ');
      SQL.Add('From ');
      SQL.Add('obraericssonatividadepj Left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obraericssonatividadepj.idcolaboradorpj ');
      SQL.Add('Left Join obraericssonfechamento On obraericssonfechamento.idcolaboradorpj = obraericssonatividadepj.idcolaboradorpj ');
      SQL.Add('and obraericssonfechamento.PO = obraericssonatividadepj.po ');
      SQL.Add('and obraericssonfechamento.POITEM = obraericssonatividadepj.poitem ');
      SQL.Add('and obraericssonfechamento.IDSydle = obraericssonatividadepj.numero ');
      SQL.Add('and obraericssonfechamento.Descricao = obraericssonatividadepj.descricaoservico ');
      SQL.Add('Left Join obraericssonpagamento On obraericssonpagamento.idgeralfechamento = obraericssonfechamento.geral ');
      SQL.Add('where ');
      SQL.Add('obraericssonatividadepj.idgeral Is Not Null And ');
      SQL.Add('obraericssonatividadepj.deletado = 0 And ');
      SQL.Add('obraericssonatividadepj.numero = :numero ');
      SQL.Add('group By ');
      SQL.Add('obraericssonatividadepj.idgeral, ');
      SQL.Add('gesempresas.nome, ');
      SQL.Add('obraericssonatividadepj.po, ');
      SQL.Add('obraericssonatividadepj.poitem, ');
      SQL.Add('obraericssonatividadepj.escopo, ');
      SQL.Add('obraericssonatividadepj.descricaoservico, ');
      SQL.Add('obraericssonatividadepj.codigoservico, ');
      SQL.Add('obraericssonatividadepj.dataacionamento, ');
      SQL.Add('obraericssonatividadepj.datadeenviodoemail, ');
      SQL.Add('obraericssonatividadepj.valorservico ');
      SQL.Add('order by obraericssonatividadepj.poitem ');

      ParamByName('numero').AsString := AQuery.Items['idlocal'];
      Open; // Use Open em vez de Active := True para queries
    end;

    erro := '';
    Result := qry;
    qry := nil;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar: ' + ex.Message;
      if Assigned(qry) then
        qry.Free;
      Result := nil;
    end;
  end;
end;

function TProjetoericsson.Listaatividadepjengenharia(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    with qry do
    begin
      close;
      sql.Clear;
      sql.Add('Select ');
      SQL.Add('obraericssonatividadepj.idgeral as id, ');
      sql.Add('gesempresas.nome as fantasia, ');
      sql.Add('obraericssonatividadepj.po, ');
      sql.Add('obraericssonatividadepj.poitem, ');
      sql.Add('obraericssonatividadepj.escopo, ');
      sql.Add('obraericssonatividadepj.descricaoservico, ');
      sql.Add('obraericssonatividadepj.codigoservico, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(obraericssonatividadepj.valorservico, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valorservico ');
      sql.Add('From ');
      sql.Add('obraericssonatividadepj Left Join ');
      sql.Add('gesempresas On gesempresas.idempresa = obraericssonatividadepj.idcolaboradorpj');
      sql.Add('WHERE obraericssonatividadepj.idgeral is not null and obraericssonatividadepj.deletado = 0 and obraericssonatividadepj.poitem=:poitem');
      parambyname('poitem').asstring := AQuery.Items['idporitem'];
      Active := true;
    end;
    erro := '';
    Result := qry;
    qry := nil;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;

end;

function TProjetoericsson.ObterRelatorioDespesas(const AFiltros: TDictionary<string, string>; out AErro: string): TFDQuery;
var
  Qry: TFDQuery;
  a:string;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;

    // Construção da query principal
    Qry.SQL.Text := 'SET @rownum := 0; ' + 'SELECT ' + '  @rownum := @rownum + 1 AS id, ' + '  d.idpmts, ' + '  d.descricao, ' + '  d.valor, ' + '  d.dataacionamento, ' + '  d.nome, ' + '  d.tipo ' + 'FROM ( ' + '  SELECT ' + '      e.site as idpmts, ' + '      gp.nome AS descricao, ' + '      (ac.totalhorasclt * ac.valorhora) AS valor, ' + '      ac.dataacionamento, ' + '      gu.nome, ' + '      ''ACIONAMENTO CLT'' AS tipo ' + '  FROM ' + '      obraericssonatividadeclt ac ' + '      LEFT JOIN obraericsson e ON ac.numero = e.numero ' + '      INNER JOIN gespessoa gp ON gp.idpessoa = ac.idcolaboradorclt ' + '      INNER JOIN gesusuario gu ON gu.idusuario = ac.idcolaboradorclt ' + '  WHERE ' + '      ac.deletado = 0 ';

    // Parte PJ
    Qry.SQL.Add('  UNION ALL ' + '  SELECT ' + '      oe.numero as idpmts, ' + '      oap.descricaoservico AS descricao, ' + '      oem.medidafiltro as valor, ' + '      oap.dataacionamento, ' + '      ge.nome AS nome, ' + '      ''ACIONAMENTO PJ'' AS tipo ' + '  FROM ' + '      obraericssonatividadepj oap ' + '      LEFT JOIN gesempresas ge ON ge.idempresa = oap.idcolaboradorpj ' + '      LEFT JOIN obraericsson oe ON oe.numero = oap.numero ' + '      LEFT JOIN obraericssonmigo oem ON oem.poritem = oap.poitem ' + '  WHERE ' + '      oap.deletado = 0 ');

    // Parte Material e Serviço
    Qry.SQL.Add('  UNION ALL ');
    Qry.SQL.Add(' Select ');
    Qry.SQL.Add(' gs.obra as idpmts, ');
    Qry.SQL.Add(' gp.descricao, ');
    Qry.SQL.Add(' Coalesce((Select ');
    Qry.SQL.Add(' gce.valor ');
    Qry.SQL.Add(' From ');
    Qry.SQL.Add(' gescontroleestoque gce ');
    Qry.SQL.Add(' Where ');
    Qry.SQL.Add(' gce.idtipomovimentacao = 1 And ');
    Qry.SQL.Add(' gce.idproduto = gsi.idproduto ');
    Qry.SQL.Add(' Limit 1), 0) As valor, ');
    Qry.SQL.Add(' gs.data As dataacionamento, ');
    Qry.SQL.Add(' gu.nome, ');
    Qry.SQL.Add(' ''MATERIAL E SERVIÇO'' As tipo ');
    Qry.SQL.Add(' From ');
    Qry.SQL.Add(' gessolicitacao gs left Join ');
    Qry.SQL.Add(' gessolicitacaoitens gsi On gsi.idsolicitacao = gs.idsolicitacao left Join ');
    Qry.SQL.Add(' gesproduto gp On gp.idproduto = gsi.idproduto left Join ');
    Qry.SQL.Add(' gesusuario gu On gu.idusuario = gs.idcolaborador ');
    Qry.SQL.Add(' Where gs.projeto = ''ERICSSON'' and gsi.deletado = 0 ');

    // Parte Diária
    Qry.SQL.Add('  UNION ALL ' + '  SELECT ' + '      gd.siteid AS idpmts, ' + '      gd.descricao, ' + '      gd.valortotal AS valor, ' + '      gd.datasolicitacao AS dataacionamento, ' + '      gd.nomecolaborador AS nome, ' + '      ''DIARIA'' AS tipo ' + '  FROM ' + '      gesdiaria gd ' + '  WHERE ' + '      gd.projeto = ''ERICSSON'' ');

    Qry.SQL.Add(') AS d ' + 'WHERE 1=1 ');

    if AFiltros.ContainsKey('site') and (AFiltros['site'] <> '') then
      Qry.SQL.Add('      AND d.idpmts LIKE ''%' + StringReplace(AFiltros['site'], '''', '''''', [rfReplaceAll]) + '%'' ');

    a := AFiltros['site'];
    // Filtro por nome
    if AFiltros.ContainsKey('nome') and (AFiltros['nome'] <> '') then
      Qry.SQL.Add('      AND d.nome LIKE ''%' + StringReplace(AFiltros['nome'], '''', '''''', [rfReplaceAll]) + '%'' ');

    if AFiltros.ContainsKey('datainicio') and (AFiltros['datainicio'] <> '') then
    begin
      if AFiltros.ContainsKey('datafim') and (AFiltros['datafim'] <> '') then
      begin
        // Ambas as datas informadas
        if AFiltros['datainicio'] = AFiltros['datafim'] then
          Qry.SQL.Add('      AND d.dataacionamento BETWEEN ''' + AFiltros['datainicio'] + ' 00:00:00'' ' + '      AND DATE_ADD(''' + AFiltros['datafim'] + ''', INTERVAL 1 DAY) ')
        else
          Qry.SQL.Add('      AND d.dataacionamento BETWEEN ''' + AFiltros['datainicio'] + ' 00:00:00'' ' + '      AND DATE_ADD(''' + AFiltros['datafim'] + ''', INTERVAL 1 DAY) ');
      end
      else
      begin
        // Apenas data inicial informada
        Qry.SQL.Add('      AND d.dataacionamento >= ''' + AFiltros['datainicio'] + ' 00:00:00'' ');
      end;
    end
    else if AFiltros.ContainsKey('datafim') and (AFiltros['datafim'] <> '') then
    begin
      Qry.SQL.Add('      AND d.dataacionamento < DATE_ADD(''' + AFiltros['datafim'] + ''', INTERVAL 1 DAY)');
    end;

    Qry.SQL.Add('ORDER BY d.dataacionamento, d.tipo');

    try
      Qry.Open;
      AErro := '';
      Result := Qry;
      qry := nil;
    except
      on E: Exception do
      begin
        AErro := 'Erro ao executar consulta: ' + E.Message;
        FreeAndNil(Qry);
        Result := nil;
      end;
    end;
  except
    on E: Exception do
    begin
      AErro := 'Erro ao criar consulta: ' + E.Message;
      FreeAndNil(Qry);
      Result := nil;
    end;
  end;
end;


function TProjetoericsson.EditarEmMassa(const AJsonBody: string; out erro: string): Boolean;
var
  qry: TFDQuery;
  jsonParams: TJSONObject;
  updates, where, uuidValue, sUpdate: string;
  updateParts: TStringList;
  ids: TArray<string>;
  i: Integer;
  rowsAffected: Integer;
begin
  Result := False;
  erro := '';
  qry := nil;
  jsonParams := nil;
  updateParts := TStringList.Create;
  try

    if AJsonBody.Trim = '' then
    begin
      erro := 'body vazio';
      Exit;
    end;

    jsonParams := TJSONObject.ParseJSONValue(AJsonBody) as TJSONObject;
    if jsonParams = nil then
    begin
      erro := 'JSON inválido';
      Exit;
    end;

    updateParts.Clear;
    if Assigned(jsonParams.GetValue('fat')) then
      updateParts.Add('fat = :fat');

    // nenhum campo para atualizar?
    if updateParts.Count = 0 then
    begin
      erro := 'nenhum campo para atualizar';
      Exit;
    end;

    if jsonParams.GetValue('atividadeSelecionada') = nil then
    begin
      erro := 'Ids não informado';
      Exit;
    end;
    uuidValue := jsonParams.GetValue('atividadeSelecionada').Value.Trim;
    if uuidValue = '' then
    begin
      erro := 'atividadeSelecionada vazio';
      Exit;
    end;

    if uuidValue.Contains(',') then
    begin
      ids := uuidValue.Split([',']);
      where := 'poritem IN (';
      for i := 0 to High(ids) do
      begin
        ids[i] := QuotedStr(Trim(ids[i])); // adiciona aspas e escapa apóstrofos
        if i > 0 then
          where := where + ',';
        where := where + ids[i];
      end;
      where := where + ')';
    end
    else
      where := 'poritem = :poritem';

    sUpdate := '';
    for i := 0 to updateParts.Count - 1 do
    begin
      if i > 0 then
        sUpdate := sUpdate + ', ';
      sUpdate := sUpdate + updateParts[i];
    end;

    qry := TFDQuery.Create(nil);
    try
      qry.Connection := FConn;
      qry.SQL.Text := 'UPDATE obraericssonmigo SET ' + sUpdate + ' WHERE ' + where;

      if Assigned(jsonParams.GetValue('fat')) then
        qry.ParamByName('fat').AsString := jsonParams.GetValue('fat').Value.Trim;

      if not uuidValue.Contains(',') then
        qry.ParamByName('poritem').AsString := uuidValue;

      if not FConn.InTransaction then
        FConn.StartTransaction;
      try
        qry.ExecSQL;
        rowsAffected := qry.RowsAffected; // número de linhas atualizadas
        FConn.Commit;
      except
        on E: Exception do
        begin
          if FConn.InTransaction then
            FConn.Rollback;
          raise; // será capturado no except abaixo
        end;
      end;
      if rowsAffected > 0 then
      begin
        Result := True;
        erro := ''; // sem erro
      end
      else
      begin
        // nenhum registro alterado
        Result := False;
        erro := 'nenhum registro foi alterado (rowsAffected = 0)';
      end;

    finally
      qry.Free;
    end;

  except
    on e: Exception do
    begin
      // captura qualquer exceção e retorna mensagem
      Result := False;
      erro := 'erro na execução: ' + e.Message;
      // garante que transação não fique aberta
      try
        if Assigned(FConn) and FConn.InTransaction then
          FConn.Rollback;
      except
        // ignore
      end;
    end;
  end;

  // Liberar objetos criados
  if Assigned(jsonParams) then
    jsonParams.Free;
  updateParts.Free;
end;


function TProjetoericsson.ListaCRQ(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  Result := nil;
  erro := '';
  qry := nil;

  try
    try
      qry := TFDQuery.Create(nil);
      qry.Connection := FConn;

      with qry do
      begin
        Active := false;
        SQL.Clear;
        with SQL do
        begin
          Clear;
          Add('SELECT ');
          Add('  id, ');
          Add('  numero, ');
          Add('  site, ');
          Add('  atividade, ');
          Add('  impacto, ');
          Add('  numero_crq, ');
          Add('  DATE_FORMAT(inicio_crq, "%Y-%m-%d") AS inicio_crq, ');
          Add('  DATE_FORMAT(final_crq, "%Y-%m-%d") AS final_crq, ');
          Add('  status, ');
          Add('  tipo_crq, ');
          Add('  origem, ');
          Add('  deletado, ');
          Add('  DATE_FORMAT(criado_em, "%Y-%m-%d %H:%i:%s") AS criado_em, ');
          Add('  DATE_FORMAT(atualizado_em, "%Y-%m-%d %H:%i:%s") AS atualizado_em ');
          Add('FROM obraericssoncrq ');
          Add('WHERE numero = :numero AND deletado = 0 ');
          Add('ORDER BY criado_em DESC');
        end;
        ParamByName('numero').AsString := AQuery.Items['numero'];
        Active := true;
      end;

      Result := qry;
      qry := nil;

    except
      on ex: Exception do
      begin
        erro := 'Erro ao consultar: ' + ex.Message;
        Result := nil;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TProjetoericsson.EditarCRQ(const ABody: TJSONObject; out erro: string): Boolean;
var
  Qry: TFDQuery;
  hasId: Boolean;
  id: Integer;
  strId: string;
  numero, site, atividade, impacto, numeroCrq, status, tipoCrq, origem: string;
  inicioCrq, finalCrq: string;
  dtTmp: TDateTime;
  deletado: Integer;

  function TryGetStr(const Key1, Key2: string; out Value: string): Boolean;
  begin
    Result := ABody.TryGetValue<string>(Key1, Value) or
              ((Key2 <> '') and ABody.TryGetValue<string>(Key2, Value));
  end;

  function ParseDateSafe(const S: string; out D: TDateTime): Boolean;
  begin
    Result := TryISO8601ToDate(S, D) or TryStrToDate(S, D);
  end;

begin
  Result := False;
  erro := '';
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.ResourceOptions.ParamCreate := True;
    Qry.ResourceOptions.SilentMode := True;
    Qry.ResourceOptions.DirectExecute := True;

    // === ID ===
    hasId := ABody.TryGetValue<Integer>('id', id);
    if not hasId then
    begin
      if ABody.TryGetValue<string>('id', strId) then
        id := StrToIntDef(Trim(strId), 0)
      else
        id := 0;
      hasId := id > 0;
    end;

    // === Campos principais ===
    if not TryGetStr('numero', 'pmts', numero) then numero := '';
    if not TryGetStr('site', 'site_id', site) then site := '';

    ABody.TryGetValue<string>('atividade', atividade);
    ABody.TryGetValue<string>('impacto', impacto);

    if not TryGetStr('numero_crq', 'numeroCrq', numeroCrq) then numeroCrq := '';
    if not TryGetStr('status', '', status) then status := '';
    if not TryGetStr('tipo_crq', 'tipoCrq', tipoCrq) then tipoCrq := '';
    if not TryGetStr('origem', '', origem) then origem := 'Manual';

    TryGetStr('inicio_crq', 'inicioCrq', inicioCrq);
    TryGetStr('final_crq', 'finalCrq', finalCrq);

    if not ABody.TryGetValue<Integer>('deletado', deletado) then
      deletado := 0;

    // === Validações mínimas ===
    numero := Trim(numero);
    site := Trim(site);

    if (numero = '') and (site = '') then
    begin
      erro := 'Informe o campo "numero" (PMTS) ou "site".';
      Exit;
    end;

    // === Transação ===
    if not FConn.InTransaction then
      FConn.StartTransaction;
    try
      if hasId then
      begin
        // UPDATE
        Qry.SQL.Text :=
          'UPDATE obraericssoncrq SET ' +
          'numero = :numero, site = :site, atividade = :atividade, impacto = :impacto, ' +
          'numero_crq = :numero_crq, inicio_crq = :inicio_crq, final_crq = :final_crq, ' +
          'status = :status, tipo_crq = :tipo_crq, origem = :origem, deletado = :deletado, ' +
          'atualizado_em = CURRENT_TIMESTAMP ' +
          'WHERE id = :id';
        Qry.ParamByName('id').AsInteger := id;
      end
      else
      begin
        // INSERT
        Qry.SQL.Text :=
          'INSERT INTO obraericssoncrq (' +
          'numero, site, atividade, impacto, numero_crq, inicio_crq, final_crq, status, tipo_crq, origem, deletado' +
          ') VALUES (' +
          ':numero, :site, :atividade, :impacto, :numero_crq, :inicio_crq, :final_crq, :status, :tipo_crq, :origem, :deletado' +
          ')';
      end;

      // === Tipos de parâmetros de data ===
      Qry.ParamByName('inicio_crq').DataType := ftDateTime;
      Qry.ParamByName('final_crq').DataType := ftDateTime;

      // === Bind de parâmetros ===
      Qry.ParamByName('numero').AsString := numero;
      Qry.ParamByName('site').AsString := site;
      Qry.ParamByName('atividade').AsString := atividade;
      Qry.ParamByName('impacto').AsString := impacto;
      Qry.ParamByName('numero_crq').AsString := numeroCrq;
      Qry.ParamByName('status').AsString := status;
      Qry.ParamByName('tipo_crq').AsString := tipoCrq;
      Qry.ParamByName('origem').AsString := origem;
      Qry.ParamByName('deletado').AsInteger := deletado;

      // === Datas ===
      if (inicioCrq <> '') and ParseDateSafe(inicioCrq, dtTmp) then
        Qry.ParamByName('inicio_crq').AsDateTime := dtTmp
      else
        Qry.ParamByName('inicio_crq').Clear;

      if (finalCrq <> '') and ParseDateSafe(finalCrq, dtTmp) then
        Qry.ParamByName('final_crq').AsDateTime := dtTmp
      else
        Qry.ParamByName('final_crq').Clear;

      // === Execução ===
      Qry.ExecSQL;

      if Qry.RowsAffected = 0 then
      begin
        erro := 'Nenhuma linha afetada ao salvar CRQ.';
        FConn.Rollback;
        Exit;
      end;

      FConn.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        if FConn.InTransaction then
          FConn.Rollback;
        erro := 'Erro ao salvar CRQ: ' + E.Message;
      end;
    end;
  finally
    Qry.Free;
  end;
end;

function TProjetoericsson.ListarCRQ(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  erro := '';
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('SELECT id, numero, site, atividade, impacto, numero_crq, inicio_crq, final_crq, status, tipo_crq, origem, deletado ');
      SQL.Add('FROM obraericssoncrq WHERE 1=1 ');
      if AQuery.ContainsKey('numero') then
      begin
        if Length(AQuery.Items['numero']) > 0 then
        begin
          SQL.Add('AND numero = :numero');
          ParamByName('numero').AsString := AQuery.Items['numero'];
        end;
      end;
      SQL.Add('AND deletado = 0');
      Active := True;
    end;
    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro ao consultar CRQ: ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TProjetoericsson.SendEmailEquipeFixa(const AQuery: TDictionary<string, string>; out erro: string): Boolean;
var
  servico: TEmail;
  qry: TFDQuery;
  destinatarios, empresaLista: TStringList;
  idsStr, idsIn, assunto, html1, html2, html3, htmlFinal: string;
  ids: TArray<string>;
  i: Integer;

  function IsNumeric(const S: string): Boolean;
  var
    V: Integer;
  begin
    Result := TryStrToInt(Trim(S), V);
  end;

  function GetValue(const Key: string): string;
  begin
    if AQuery.ContainsKey(Key) then
      Result := AQuery.Items[Key]
    else
      Result := '';
  end;

  function FormatarDataBR(const S: string): string;
  var
    dt: TDateTime;
  begin
    Result := '';
    if Trim(S) = '' then Exit;
    try
      if Pos('T', S) > 0 then
        dt := ISO8601ToDate(S)
      else
        dt := StrToDate(S);
      Result := FormatDateTime('dd/mm/yyyy', dt);
    except
      Result := S;
    end;
  end;

begin
  Result := False;
  erro := '';

  idsStr := GetValue('equipefixa');
  if Trim(idsStr) = '' then
  begin
    erro := 'Equipe fixa não informada.';
    Exit;
  end;

  servico := TEmail.Create;
  destinatarios := TStringList.Create;
  empresaLista := TStringList.Create;
  qry := TFDQuery.Create(nil);

  try
    qry.Connection := FConn;

    // === Normaliza IDs ===
    idsStr := StringReplace(idsStr, ';', ',', [rfReplaceAll]);
    idsStr := StringReplace(idsStr, ' ', '', [rfReplaceAll]);
    ids := idsStr.Split([',']);
    idsIn := '';
    for i := 0 to High(ids) do
      if IsNumeric(ids[i]) then
      begin
        if idsIn <> '' then idsIn := idsIn + ',';
        idsIn := idsIn + Trim(ids[i]);
      end;

    if idsIn = '' then
    begin
      erro := 'Nenhum ID válido em equipeResponsavel.';
      Exit;
    end;

    // === Consulta equipe ===
    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT');
      SQL.Add('  p.idpessoa,');
      SQL.Add('  p.nome,');
      SQL.Add('  p.email,');
      SQL.Add('  COALESCE(p.rgrne, p.rg) AS rg,');
      SQL.Add('  p.cpf,');
      SQL.Add('  e.nome AS empresa');
      SQL.Add('FROM gespessoa p');
      SQL.Add('LEFT JOIN gesempresas e ON e.idempresa = p.empresa');
      SQL.Add('WHERE p.deletado = 0');
      SQL.Add('  AND p.idpessoa IN (' + idsIn + ')');
      Open;
    end;

    // === Monta lista de destinatários ===
    while not qry.Eof do
    begin
      if servico.IsValidEmail(qry.FieldByName('email').AsString) then
        if destinatarios.IndexOf(qry.FieldByName('email').AsString) = -1 then
          destinatarios.Add(qry.FieldByName('email').AsString);

      if empresaLista.IndexOf(qry.FieldByName('empresa').AsString) = -1 then
        empresaLista.Add(qry.FieldByName('empresa').AsString);

      qry.Next;
    end;

    if destinatarios.Count = 0 then
    begin
      erro := 'Nenhum e-mail válido encontrado para os IDs informados.';
      Exit;
    end;

    // === Montagem do assunto ===
    assunto := 'Solicitação de Acesso – ' + GetValue('site') +
               ' | ' + GetValue('detentora') +
               ' - ' + GetValue('iddetentora') +
               ' / ' + GetValue('enderecoSite') +
               ' / ' + GetValue('tipoinstalacao');

    if Trim(GetValue('numero')) <> '' then
      assunto := assunto + ' | CRQ ' + GetValue('numero');

    // === Início do HTML ===
    html1 := '<!DOCTYPE html><html lang="pt-BR"><head>' +
             '<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">' +
             '<title>Solicitação de Acesso</title>' +
             '<style>' +
             'body{font-family:Arial,sans-serif;color:#333;}' +
             'table{border-collapse:collapse;width:100%;}' +
             'th,td{border:1px solid #000;padding:6px;font-size:12px;}' +
             'th{background-color:#eaeaea;text-transform:uppercase;}' +
             '.section-title{font-weight:bold;margin:8px 0 4px 0;}' +
             '</style></head><body>';

    html1 := html1 +
             '<p class="section-title">Prezados(as),</p>' +
             '<p>Uso deste para formalizar necessidade de liberação de acesso para início/realização de atividades conforme descrito.</p>' +
             '<p>As atividades serão realizadas pelos colaboradores incluídos no documento e e-mail.</p>';

    // === Cabeçalho do site ===
    html1 := html1 +
             '<table><thead><tr>' +
             '<th>TIPO</th><th>SITE</th><th>DETENTORA</th><th>ID DETENTORA</th><th>MUNICÍPIO</th<th>ENDEREÇO</th>' +
             '</tr></thead><tbody><tr>' +
             '<td>' + UTF8Encode(GetValue('tipoinstalacao')) + '</td>' +
             '<td>' + UTF8Encode(GetValue('site')) + '</td>' +
             '<td>' + UTF8Encode(GetValue('detentora')) + '</td>' +
             '<td>' + UTF8Encode(GetValue('iddetentora')) + '</td>' +
             '<td>' + UTF8Encode(GetValue('municipio')) + '</td>' +
             '<td>' + UTF8Encode(GetValue('enderecoSite')) + '</td>' +
             '</tr></tbody></table>';

    // === Empresas responsáveis ===
    html1 := html1 + '<p class="section-title">EMPRESAS RESPONSÁVEIS:</p>';
    if empresaLista.Count > 0 then
      html1 := html1 + '<p>' + UTF8Encode(StringReplace(empresaLista.Text, sLineBreak, ' / ', [rfReplaceAll])) +
                       ' / À SERVIÇO DA VIVO.</p>'
    else
      html1 := html1 + '<p>TELEQUIPE PROJETOS / À SERVIÇO DA VIVO.</p>';

    // === Datas e Atividade ===
    html1 := html1 +
             '<p class="section-title">DATA DE INÍCIO:</p><p>' + FormatarDataBR(GetValue('dataInicial')) + '</p>' +
             '<p class="section-title">DATA FINAL:</p><p>' + FormatarDataBR(GetValue('dataFinal')) + '</p>' +
             '<p class="section-title">DESCRIÇÃO DA ATIVIDADE:</p><p>' + UTF8Encode(GetValue('atividade')) + '</p>';

    // === Lista de técnicos ===
    html1 := html1 +
             '<p class="section-title">LISTA DE TÉCNICOS AUTORIZADOS:</p>' +
             '<table><thead><tr><th>EMPRESA</th><th>COLABORADOR</th><th>CPF</th><th>RG/RNE</th></tr></thead><tbody>';

    qry.First;
    while not qry.Eof do
    begin
      html2 := html2 + '<tr>' +
                       '<td>' + UTF8Encode(qry.FieldByName('empresa').AsString) + '</td>' +
                       '<td>' + UTF8Encode(qry.FieldByName('nome').AsString) + '</td>' +
                       '<td>' + UTF8Encode(qry.FieldByName('cpf').AsString) + '</td>' +
                       '<td>' + UTF8Encode(qry.FieldByName('rg').AsString) + '</td>' +
                       '</tr>';
      qry.Next;
    end;
    html2 := html2 + '</tbody></table>';

    // === Rodapé e assinatura ===
    html3 := '</body></html>';
    servico.assinatura;
    htmlFinal := html1 + html2 + servico.assinaturamontada + html3;

    // === Envio do e-mail ===
    if servico.SendEmail(StringReplace(destinatarios.Text, sLineBreak, ';', [rfReplaceAll]), assunto, htmlFinal) then
    begin
      Result := True;
      erro := '';
    end
    else
    begin
      Result := False;
      erro := 'Falha ao enviar e-mail.';
    end;

  except
    on E: Exception do
    begin
      Result := False;
      erro := 'Erro ao enviar e-mail: ' + E.Message;
    end;
  end;

  destinatarios.Free;
  empresaLista.Free;
  qry.Free;
  servico.Free;
end;

end.


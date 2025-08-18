unit Model.Projetoericsson;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection, ComObj,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections, UtFuncao;

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
    fhora50clt: Double;
    fhora100clt: Double;
    fvalornegociado: Double;

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
    Fidtarefamigo: Integer;
    Fdatatarefa: string;
    Fgeralfechamento: integer;
    Frepostaalteracao: Integer;

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
    property hora100clt: Double read Fvalorhora write Fhora100clt;

    property idgeralfechamento: Integer read Fidgeralfechamento write Fidgeralfechamento;
    property repostaalteracao: Integer read Frepostaalteracao write Frepostaalteracao;
    property mespagamento: string read Fmespagamento write Fmespagamento;
    property porcentagem: Double read Fporcentagem write Fporcentagem;
    property valorpagamento: Double read Fvalorpagamento write Fvalorpagamento;
    property observacaopagamento: string read Fobservacaopagamento write Fobservacaopagamento;
    property observacaopagamentointerna: string read Fobservacaopagamentointerna write Fobservacaopagamentointerna;
    property descricaopagamento: string read Fdescricaopagamento write Fdescricaopagamento;
    property popagamento: string read Fpopagamento write Fpopagamento;
    property empresapagamento: string read Fempresapagamento write Fempresapagamento;
    property lpuhistorico: string read Flpuhistorico write Flpuhistorico;
    property lpucr: string read Flpucr write Flpucr;
    property idtarefamigo: Integer read Fidtarefamigo write Fidtarefamigo;
    property datatarefa: string read Fdatatarefa write Fdatatarefa;

    property desconto: Double read Fdesconto write Fdesconto;

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

  end;

implementation

{ TProjetoericsson }

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
        SQL.Add('datarecebimentodositemosreportadodia, ');
        SQL.Add('datavalidacaoinstalacaodia, ');
        SQL.Add('datavalidacaoeriboxedia ');
        SQL.Add('From ');
        SQL.Add('obraericsson ');
        SQL.Add('Where ');
        SQL.Add('obraericsson.numero =:numero ');
        parambyname('numero').asstring := numero;
        open;

      end;
      with qry do
      begin
        active := false;
        SQL.Clear;
        SQL.Add('Select obraericssonmigo.descricaoservico,obraericssonmigo.po From ');
        SQL.Add('obraericssonmigo  ');
        SQL.Add('Where ');
        SQL.Add('obraericssonmigo.poritem =:poritem ');
        ParamByName('poritem').AsString := po;
        Open();
        descricaoservico := FieldByName('descricaoservico').AsString;
        polocal := FieldByName('po').AsString;
        Active := false;
        SQL.Clear;
        SQL.Add('Select ');
        SQL.Add('obraericsson.rfp, ');
        SQL.Add('obraericsson.cliente, ');
        SQL.Add('obraericsson.site ');
        SQL.Add('From ');
        SQL.Add('obraericsson ');
        SQL.Add('Where ');
        SQL.Add('obraericsson.numero=:numero ');
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
          SQL.Add('obraericssonmigo where descricaoservico =:descricaoservico and po=:po ');
          ParamByName('descricaoservico').asstring := descricaoservico;
          ParamByName('po').asstring := polocal;
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
          SQL.Add('obraericssonlpu On obraericssonlpu.codigo = obraericssonmigo.codigoservico where descricaoservico =:descricaoservico and po=:po and ');
          SQL.Add('obraericssonlpu.historico =:historico ');
          ParamByName('descricaoservico').asstring := descricaoservico;
          ParamByName('po').asstring := polocal;
          ParamByName('historico').asstring := lpuhistorico;
          Open();
        end;

      {  if qry.RecordCount = 0 then
        begin
          erro := erro + ' LPU n�o localizada para o pacote ' + descricaoservico;
        end ; }
       // else
       // begin
          while not eof do
          begin
            with qry1 do
            begin
              close;
              SQL.clear;
              sql.Add('insert into obraericssonatividadepj(idcolaboradorpj,idposervico,po,lpuhistorico,');
              sql.Add('poitem,escopo,numero,deletado,valorservico,observacaopj,descricaoservico,codigoservico,dataacionamento)');
              sql.Add('                             values(:idcolaboradorpj,:idposervico,:po,:lpuhistorico,');
              sql.Add(':poitem,:escopo,:numero,:deletado,:valorservico,:observacaopj,:descricaoservico,:codigoservico,:dataacionamento)');
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
              ;
              ParamByName('observacaopj').asstring := observacaopj;
              ParamByName('descricaoservico').asstring := descricaoservico;
              ParamByName('codigoservico').asstring := qry.FieldByName('codigoservico').AsString;
              ParamByName('lpuhistorico').asstring := lpuhistorico;
              ParamByName('dataacionamento').AsDate := Date;
              ExecSQL;

              close;
              SQL.clear;
              SQL.Add('insert into obraericssonfechamento (Demanda,PO,POITEM,Item,Sigla,IDSydle,Cliente,Estado,Codigo,');
              SQL.Add('Descricao,VALORPJ,Quant,EMPRESA,DATADEENVIO,idcolaboradorpj,MOSREAL,INSTALREAL,INTEGREAL) ');
              sql.Add('                            values(:Demanda,:PO,:POITEM,:Item,:Sigla,:IDSydle,:Cliente,:Estado,:Codigo,');
              sql.Add(':Descricao,:VALORPJ,:Quant,:EMPRESA,:DATADEENVIO,:idcolaboradorpj,:MOSREAL,:INSTALREAL,:INTEGREAL) ');
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
                ParamByName('MOSREAL').AsDate := StrToDate('30/12/1899')
              else
                ParamByName('MOSREAL').AsDate := qry2.FieldByName('datarecebimentodositemosreportadodia').AsDateTime;

              if qry2.FieldByName('datavalidacaoinstalacaodia').asstring = '' then
                ParamByName('INSTALREAL').AsDate := StrToDate('30/12/1899')
              else
                ParamByName('INSTALREAL').AsDate := qry2.FieldByName('datavalidacaoinstalacaodia').AsDateTime;

              if qry2.FieldByName('datavalidacaoeriboxedia').asstring = '' then
                ParamByName('INTEGREAL').AsDate := StrToDate('30/12/1899')
              else
                ParamByName('INTEGREAL').AsDate := qry2.FieldByName('datavalidacaoeriboxedia').AsDateTime;
              ParamByName('EMPRESA').asstring := empresa;
              ParamByName('DATADEENVIO').asdate := date;
              ParamByName('idcolaboradorpj').asinteger := idcolaboradorpj;
              execsql;
            end;
            Next;
          end;
        //end;

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
        Result := false;
      end;
    end;
  finally
    qry.Free;
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
          SQL.Add('obraericssonmigo where descricaoservico =:descricaoservico and poritem=:poritem ');
          ParamByName('descricaoservico').asstring := descricaoservico;
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
          SQL.Add('obraericssonlpu On obraericssonlpu.codigo = obraericssonmigo.codigoservico where descricaoservico =:descricaoservico and poritem=:poritem and ');
          SQL.Add('obraericssonlpu.historico =:historico ');
          ParamByName('descricaoservico').asstring := descricaoservico;
          ParamByName('poritem').asstring := poitem;
          ParamByName('historico').asstring := lpuhistorico;
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
        erro := 'Erro ao cadastrar acionamento: ' + ex.Message;
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
  id: Integer;
begin
 { try
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
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO obraericsson(numero,cliente,regiona,site,situacaoimplantacao,');
          SQL.Add('situacaodaintegracao,datadacriacaodademandadia,dataaceitedemandadia,');
          SQL.Add('datainicioentregamosplanejadodia,datarecebimentodositemosreportadodia,');
          SQL.Add('datafiminstalacaoplanejadodia,dataconclusaoreportadodia,datavalidacaoinstalacaodia');
          SQL.Add('dataintegracaoplanejadodia,datavalidacaoeriboxedia)');
          SQL.Add('               VALUES(:numero,:cliente,:regiona,:site,:situacaoimplantacao,');
          SQL.Add(':situacaodaintegracao,:datadacriacaodademandadia,:dataaceitedemandadia,');
          SQL.Add(':datainicioentregamosplanejadodia,:datarecebimentodositemosreportadodia,');
          SQL.Add(':datafiminstalacaoplanejadodia,:dataconclusaoreportadodia,:datavalidacaoinstalacaodia');
          SQL.Add(':dataintegracaoplanejadodia,:datavalidacaoeriboxedia)');
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update obraericsson set ');
          SQL.Add('numero                              =:numero,');
          SQL.Add('cliente                             =:cliente,');
          SQL.Add('regiona                             =:regiona,');
          SQL.Add('site                                =:site,');
          SQL.Add('situacaoimplantacao                 =:situacaoimplantacao,');
          SQL.Add('situacaodaintegracao                =:situacaodaintegracao,');
          SQL.Add('datadacriacaodademandadia           =:datadacriacaodademandadia,');
          SQL.Add('dataaceitedemandadia                =:dataaceitedemandadia,');
          SQL.Add('datainicioentregamosplanejadodia    =:datainicioentregamosplanejadodia,');
          SQL.Add('datarecebimentodositemosreportadodia=:datarecebimentodositemosreportadodia,');
          SQL.Add('datafiminstalacaoplanejadodia       =:datafiminstalacaoplanejadodia,');
          SQL.Add('dataconclusaoreportadodia           =:dataconclusaoreportadodia,');
          SQL.Add('datavalidacaoinstalacaodia          =:datavalidacaoinstalacaodia,');
          SQL.Add('dataintegracaoplanejadodia          =:dataintegracaoplanejadodia,');
          SQL.Add('datavalidacaoeriboxedia             =:datavalidacaoeriboxedia');
          SQL.Add('where numero=:numero ');
        end;
        ParamByName('numero').asinteger := numero;
        ParamByName('cliente').AsString := cliente;
        ParamByName('regiona').AsString := regiona;
        ParamByName('site').AsString := site;
        ParamByName('situacaoimplantacao').AsString := situacaoimplantacao;
        ParamByName('situacaodaintegracao').AsString := situacaodaintegracao;
        ParamByName('datadacriacaodademandadia').AsString := datadacriacaodademandadia;
        ParamByName('dataaceitedemandadia').AsString := dataaceitedemandadia;
        ParamByName('datainicioentregamosplanejadodia').AsString := datainicioentregamosplanejadodia;
        ParamByName('datarecebimentodositemosreportadodia').AsString := datarecebimentodositemosreportadodia;
        ParamByName('datafiminstalacaoplanejadodia').AsString := datafiminstalacaoplanejadodia;
        ParamByName('dataconclusaoreportadodia').AsString := dataconclusaoreportadodia;
        ParamByName('datavalidacaoinstalacaodia').AsString := datavalidacaoinstalacaodia;
        ParamByName('dataintegracaoplanejadodia').AsString := dataintegracaoplanejadodia;
        ParamByName('datavalidacaoeriboxedia').AsString := datavalidacaoeriboxedia;
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
  end; }
  result := true;
end;

function TProjetoericsson.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obraericsson.numero as id, ');
      SQL.Add('obraericsson.rfp, ');
      SQL.Add('obraericsson.cliente, ');
      SQL.Add('obraericsson.regiona, ');
      SQL.Add('obraericsson.site, ');
      SQL.Add('obraericsson.fornecedor, ');
      SQL.Add('obraericsson.situacaoimplantacao, ');
      SQL.Add('obraericsson.situacaodaintegracao, ');
      SQL.Add('obraericsson.datadacriacaodademandadia, ');
      SQL.Add('obraericsson.datalimiteaceitedia, ');
      SQL.Add('obraericsson.dataaceitedemandadia, ');
      SQL.Add('obraericsson.datainicioprevistasolicitantebaselinemosdia, ');
      SQL.Add('obraericsson.datainicioentregamosplanejadodia, ');
      SQL.Add('obraericsson.datarecebimentodositemosreportadodia, ');
      SQL.Add('obraericsson.datafimprevistabaselinefiminstalacaodia, ');
      SQL.Add('obraericsson.datafiminstalacaoplanejadodia, ');
      SQL.Add('obraericsson.dataconclusaoreportadodia, ');
      SQL.Add('obraericsson.datavalidacaoinstalacaodia, ');
      SQL.Add('obraericsson.dataintegracaobaselinedia, ');
      SQL.Add('obraericsson.dataintegracaoplanejadodia, ');
      SQL.Add('obraericsson.datavalidacaoeriboxedia, ');
      SQL.Add('obraericsson.listadepos, ');
      SQL.Add('obraericsson.gestordeimplantacaonome, ');
      SQL.Add('obraericsson.statusrsa, ');
      SQL.Add('obraericsson.rsarsa, ');
      SQL.Add('obraericsson.statusaceitacao, ');
      SQL.Add('obraericsson.datadefimdaaceitacaosydledia, ');
      SQL.Add('obraericsson.ordemdevenda, ');
      SQL.Add('obraericsson.coordenadoaspnome, ');
      SQL.Add('obraericsson.rsavalidacaorsanrotrackerdatafimdia, ');
      SQL.Add('obraericsson.fimdeobraplandia, ');
      SQL.Add('obraericsson.fimdeobrarealdia, ');
      SQL.Add('obraericsson.tipoatualizacaofam, ');
      SQL.Add('obraericsson.sinergia, ');
      SQL.Add('obraericsson.sinergia5g, ');
      SQL.Add('obraericsson.escoponome, ');
      SQL.Add('obraericsson.slapadraoescopodias, ');
      SQL.Add('obraericsson.tempoparalisacaoinstalacaodias, ');
      SQL.Add('obraericsson.localizacaositeendereco, ');
      SQL.Add('obraericsson.localizacaositecidade, ');
      SQL.Add('obraericsson.documentacaosituacao, ');
      SQL.Add('obraericsson.sitepossuirisco ');
      SQL.Add('From ');
      SQL.Add('obraericsson ');
      SQL.Add(' WHERE obraericsson.Numero is not null ');
      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND ((obraericsson.numero like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (obraericsson.site like ''%' + AQuery.Items['busca'] + '%'')) ');
        end;
      end;
      SQL.Add('order by  obraericsson.id desc ');
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

function TProjetoericsson.Listadocumentacaofinal(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('obradocumentacaofinal ');
      SQL.Add(' WHERE obradocumentacaofinal.Numero is not null and numero=:numero ');
      ParamByName('numero').asstring := AQuery.Items['idprojetoericsson'];
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

function TProjetoericsson.Listadocumentacaofinalcivilwork(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      ParamByName('numero').asstring := AQuery.Items['idprojetoericsson'];
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
    qry.connection := FConn;
    with qry do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('Select ');
      SQL.Add('obraericsson.numero,');
      SQL.Add('obraericsson.rfp,');
      SQL.Add('obraericsson.cliente,');
      SQL.Add('obraericsson.regiona,');
      SQL.Add('obraericsson.site,');
      SQL.Add('obraericsson.fornecedor,');
      SQL.Add('obraericsson.situacaoimplantacao,');
      SQL.Add('obraericsson.situacaodaintegracao,');
      SQL.Add('obraericsson.datadacriacaodademandadia,');
      SQL.Add('obraericsson.datalimiteaceitedia,');
      SQL.Add('obraericsson.dataaceitedemandadia,');
      SQL.Add('obraericsson.datainicioprevistasolicitantebaselinemosdia,');
      SQL.Add('obraericsson.datainicioentregamosplanejadodia,');
      SQL.Add('obraericsson.datarecebimentodositemosreportadodia,');
      SQL.Add('obraericsson.datafimprevistabaselinefiminstalacaodia,');
      SQL.Add('obraericsson.datafiminstalacaoplanejadodia,');
      SQL.Add('obraericsson.dataconclusaoreportadodia,');
      SQL.Add('obraericsson.datavalidacaoinstalacaodia,');
      SQL.Add('obraericsson.dataintegracaobaselinedia,');
      SQL.Add('obraericsson.dataintegracaoplanejadodia,');
      SQL.Add('obraericsson.datavalidacaoeriboxedia,');
      SQL.Add('obraericsson.listadepos,');
      SQL.Add('obraericsson.gestordeimplantacaonome,');
      SQL.Add('obraericsson.statusrsa,');
      SQL.Add('obraericsson.rsarsa,');
      SQL.Add('obraericsson.statusaceitacao,');
      SQL.Add('obraericsson.datadefimdaaceitacaosydledia,');
      SQL.Add('obraericsson.ordemdevenda,');
      SQL.Add('obraericsson.coordenadoaspnome,');
      SQL.Add('obraericsson.rsavalidacaorsanrotrackerdatafimdia,');
      SQL.Add('obraericsson.fimdeobraplandia,');
      SQL.Add('obraericsson.fimdeobrarealdia,');
      SQL.Add('obraericsson.tipoatualizacaofam,');
      SQL.Add('obraericsson.sinergia,');
      SQL.Add('obraericsson.sinergia5g,');
      SQL.Add('obraericsson.escoponome,');
      SQL.Add('obraericsson.slapadraoescopodias,');
      SQL.Add('obraericsson.tempoparalisacaoinstalacaodias,');
      SQL.Add('obraericsson.localizacaositeendereco,');
      SQL.Add('obraericsson.localizacaositeCidade,');
      SQL.Add('obraericsson.documentacaosituacao,');
      SQL.Add('obraericsson.sitepossuirisco, ');
      SQL.Add('obrasericssonlistasites.aceitacaofinal as aceitacaofical, ');
      SQL.Add('obrasericssonlistasites.PendenciasObra,emailregional.emailacionamento ');
      SQL.Add('From ');
      SQL.Add('obraericsson left Join  ');
      SQL.Add('obrasericssonlistasites On obrasericssonlistasites.SEED = obraericsson.numero left Join ');
      SQL.Add('emailregional On emailregional.regional = obraericsson.regiona ');
      SQL.Add(' WHERE obraericsson.Numero is not null and numero=:numero ');
      ParamByName('numero').asstring := AQuery.Items['idprojetoericsson'];
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
      SQL.Add('Select ');
      SQL.Add('obraericssonmigo.poritem as id, ');
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
      SQL.Add('obraericssonatividadeclt.idgeral as id, ');
      SQL.Add('obraericssonatividadeclt.numero, ');
      SQL.Add('obraericssonatividadeclt.idcolaboradorclt, ');
      SQL.Add('gespessoa.nome  as colaboradorclt, ');
      SQL.Add('obraericssonatividadeclt.idposervico,obraericssonmigo.descricaoservico,');
      SQL.Add('DATE_FORMAT(obraericssonatividadeclt.datainicio,"%d/%m/%Y") as datainicio, ');
      SQL.Add('DATE_FORMAT(obraericssonatividadeclt.datafin,"%d/%m/%Y") as datafin ,');
      SQL.Add('obraericssonatividadeclt.escopo,');
      SQL.Add('obraericssonatividadeclt.po,');
      SQL.Add('obraericssonatividadeclt.descricaoservico,');
      SQL.Add('obraericssonatividadeclt.totalhorasclt,');
      SQL.Add('obraericssonatividadeclt.valorhora,');
      SQL.Add('obraericssonatividadeclt.horaxvalor,obraericssonatividadeclt.observacaoclt ');
      SQL.Add('From ');
      SQL.Add('obraericssonatividadeclt left Join ');
      SQL.Add('gespessoa On gespessoa.idpessoa = obraericssonatividadeclt.idcolaboradorclt left Join ');
      SQL.Add('obraericssonmigo On obraericssonmigo.poritem = obraericssonatividadeclt.idposervico');
      SQL.Add(' WHERE obraericssonatividadeclt.idgeral is not null and obraericssonatividadeclt.deletado = 0 and obraericssonatividadeclt.numero=:numero ');
      parambyname('numero').asstring := AQuery.Items['idlocal'];
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

function TProjetoericsson.Listaatividadepj(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
{      sql.Add('Select ');
      SQL.Add('obraericssonatividadepj.idgeral as id, ');
      sql.Add('gesempresas.nome as fantasia, ');
      sql.Add('obraericssonatividadepj.po, ');
      sql.Add('obraericssonatividadepj.poitem, ');
      sql.Add('obraericssonatividadepj.escopo, ');
      sql.Add('obraericssonatividadepj.descricaoservico, ');
      sql.Add('obraericssonatividadepj.codigoservico, ');
      SQL.Add('DATE_FORMAT(obraericssonatividadepj.dataacionamento,"%d/%m/%Y") as dataacionamento, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(obraericssonatividadepj.valorservico, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valorservico ');
      sql.Add('From ');
      sql.Add('obraericssonatividadepj Left Join ');
      sql.Add('gesempresas On gesempresas.idempresa = obraericssonatividadepj.idcolaboradorpj');
      sql.Add('WHERE obraericssonatividadepj.idgeral is not null and obraericssonatividadepj.deletado = 0 and obraericssonatividadepj.numero=:numero');
      parambyname('numero').asstring := AQuery.Items['idlocal'];    }

      SQL.Add('Select ');
      SQL.Add('obraericssonatividadepj.idgeral As id, ');
      SQL.Add('gesempresas.nome As fantasia, ');
      SQL.Add('obraericssonatividadepj.po, ');
      SQL.Add('obraericssonatividadepj.poitem, ');
      SQL.Add('obraericssonatividadepj.escopo, ');
      SQL.Add('obraericssonatividadepj.descricaoservico, ');
      SQL.Add('obraericssonatividadepj.codigoservico, ');
      SQL.Add('Date_Format(obraericssonatividadepj.dataacionamento, "%d/%m/%Y") As dataacionamento, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(obraericssonatividadepj.valorservico, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valorservico, ');
      SQL.Add('Sum(obraericssonpagamento.porcentagem) As porcentagem ');
      SQL.Add('From ');
      SQL.Add('obraericssonatividadepj Left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = obraericssonatividadepj.idcolaboradorpj left Join ');
      SQL.Add('obraericssonfechamento On obraericssonfechamento.idcolaboradorpj = obraericssonatividadepj.idcolaboradorpj ');
      SQL.Add('and obraericssonfechamento.PO = obraericssonatividadepj.po ');
      SQL.Add('and obraericssonfechamento.POITEM = obraericssonatividadepj.poitem ');
      SQL.Add('and obraericssonfechamento.IDSydle = obraericssonatividadepj.numero ');
      SQL.Add('and obraericssonfechamento.Descricao = obraericssonatividadepj.descricaoservico left Join ');
      SQL.Add('obraericssonpagamento On obraericssonpagamento.idgeralfechamento = obraericssonfechamento.geral ');
      SQL.Add('where ');
      SQL.Add('obraericssonatividadepj.idgeral Is Not Null And ');
      SQL.Add('obraericssonatividadepj.deletado = 0 And ');
      SQL.Add('obraericssonatividadepj.numero = :numero ');
      SQL.Add('group By ');
      SQL.Add('obraericssonatividadepj.idgeral order by obraericssonatividadepj.poitem ');
      parambyname('numero').asstring := AQuery.Items['idlocal'];
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
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar : ' + ex.Message;
      Result := nil;
    end;
  end;

end;

end.


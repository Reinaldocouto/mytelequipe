unit Model.Veiculos;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TVeiculos = class
  private
    FConn: TFDConnection;
    Fidveiculo: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
    Finspecaoveicular: string;
    Fmodelo: string;
    Fplaca: string;
    Fcor: string;
    Fcategoria: string;
    Finiciolocacao: string;
    Ffimlocacao: string;
    Fperiodicidade: string;
    Fultimarevper: string;
    Fkmsrestante: string;
    Fkmatual: string;
    Fkm4: string;
    Fproximarevper: string;
    Fmarca: string;
    Ffabricacao: string;
    Frenavam: string;
    Fchassi: string;
    Flicenciamento: string;
    Fclassificacao: string;
    Fmesbase: string;
    Fativo: string;
    Fidempresa: integer;
    Fidpessoa: integer;

  public
    constructor Create;
    destructor Destroy; override;

    property idveiculo: Integer read Fidveiculo write Fidveiculo;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property inspecaoveicular: string read Finspecaoveicular write Finspecaoveicular;
    property modelo: string read Fmodelo write Fmodelo;
    property placa: string read Fplaca write Fplaca;
    property cor: string read Fcor write Fcor;
    property categoria: string read Fcategoria write Fcategoria;
    property iniciolocacao: string read Finiciolocacao write Finiciolocacao;
    property fimlocacao: string read Ffimlocacao write Ffimlocacao;
    property periodicidade: string read Fperiodicidade write Fperiodicidade;
    property ultimarevper: string read Fultimarevper write Fultimarevper;
    property kmsrestante: string read Fkmsrestante write Fkmsrestante;
    property kmatual: string read Fkmatual write Fkmatual;
    property km4: string read Fkm4 write Fkm4;
    property proximarevper: string read Fproximarevper write Fproximarevper;
    property marca: string read Fmarca write Fmarca;
    property fabricacao: string read Ffabricacao write Ffabricacao;
    property renavam: string read Frenavam write Frenavam;
    property chassi: string read Fchassi write Fchassi;
    property licenciamento: string read Flicenciamento write Flicenciamento;
    property classificacao: string read Fclassificacao write Fclassificacao;
    property idempresa: integer read Fidempresa write Fidempresa;
    property idpessoa: integer read Fidpessoa write Fidpessoa;
    property mesbase: string read Fmesbase write Fmesbase;
    property ativo: string read Fativo write Fativo;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;
    function ListaSelectVeiculos(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function BuscarDadosPlaca(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;

  end;

implementation

{ TVeiculos }

constructor TVeiculos.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TVeiculos.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TVeiculos.ListaSelectVeiculos(
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
      SQL.Add('SELECT ');
      SQL.Add('gesveiculos.idveiculo AS value, ');
      SQL.Add('gesveiculos.PLACA AS label ');
      SQL.Add('FROM ');
      SQL.Add('gesveiculos ');
      SQL.Add('WHERE idveiculo IS NOT NULL AND PLACA <> '''' ');

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesfornecedor.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      SQL.Add('order by PLACA');
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

function TVeiculos.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idveiculo = idveiculo+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idveiculo from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idveiculo := fieldbyname('idveiculo').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idveiculo;
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

function TVeiculos.Editar(out erro: string): Boolean;
var
  qry, qryHist: TFDQuery;
  id: Integer;
  isInsert: Boolean;
  dataHoje: TDate;
  totalDias, diasCorridos: Integer;
  valorTotal, valorProporcional: Double;
  dataInicio, dataFimOriginal: TDate;
begin
  Result := False;
  erro := '';
  dataHoje := Date; // Data atual do sistema

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    FConn.StartTransaction;
    try
      qry.Active := False;
      qry.SQL.Text := 'SELECT idveiculo FROM gesveiculos WHERE idveiculo=:idveiculo';
      qry.ParamByName('idveiculo').AsInteger := idveiculo;
      qry.Open;

      isInsert := (qry.RecordCount = 0);
      qry.Close;
      qry.SQL.Clear;

      if isInsert then
      begin
        qry.SQL.Add('INSERT INTO gesveiculos(idveiculo,inspecaoveicular,modelo,placa,cor,categoria,iniciolocacao,fimlocacao,periodicidade,ultimarevper,kmsrestante,kmatual,km4,proximarevper,marca,fabricacao,');
        qry.SQL.Add('renavam,chassi,licenciamento,DELETADO,classificacao,idempresa,idpessoa,mesbase,status)');
        qry.SQL.Add('VALUES(:idveiculo,:inspecaoveicular,:modelo,:placa,:cor,:categoria,:iniciolocacao,:fimlocacao,:periodicidade,:ultimarevper,:kmsrestante,:kmatual,:km4,:proximarevper,:marca,:fabricacao,');
        qry.SQL.Add(':renavam,:chassi,:licenciamento,:DELETADO,:classificacao,:idempresa,:idpessoa,:mesbase,:status)');
      end
      else
      begin
        qry.SQL.Add('UPDATE gesveiculos SET DELETADO=:DELETADO,inspecaoveicular=:inspecaoveicular,modelo=:modelo,placa=:placa,');
        qry.SQL.Add('cor=:cor,categoria=:categoria,iniciolocacao=:iniciolocacao,fimlocacao=:fimlocacao,periodicidade=:periodicidade,ultimarevper=:ultimarevper,kmsrestante=:kmsrestante,kmatual=:kmatual,km4=:km4,proximarevper=:proximarevper,');
        qry.SQL.Add('marca=:marca,fabricacao=:fabricacao,renavam=:renavam,chassi=:chassi,licenciamento=:licenciamento,classificacao=:classificacao,idempresa=:idempresa,idpessoa=:idpessoa,mesbase=:mesbase,status=:status ');
        qry.SQL.Add('WHERE idveiculo=:idveiculo');
      end;

      qry.ParamByName('idveiculo').AsInteger := idveiculo;

      // Datas
      with qry.ParamByName('inspecaoveicular') do
      begin
        DataType := ftDate;
        if inspecaoveicular = '' then Clear else AsString := inspecaoveicular;
      end;

      with qry.ParamByName('iniciolocacao') do
      begin
        DataType := ftDate;
        if iniciolocacao = '' then Clear else AsString := iniciolocacao;
      end;

      with qry.ParamByName('fimlocacao') do
      begin
        DataType := ftDate;
        if fimlocacao = '' then Clear else AsString := fimlocacao;
      end;

      qry.ParamByName('periodicidade').AsString := periodicidade;
      qry.ParamByName('modelo').AsString := modelo;
      qry.ParamByName('placa').AsString := placa;
      qry.ParamByName('cor').AsString := cor;
      qry.ParamByName('categoria').AsString := categoria;
      qry.ParamByName('ultimarevper').AsString := ultimarevper;
      qry.ParamByName('kmsrestante').AsString := kmsrestante;
      qry.ParamByName('kmatual').AsString := kmatual;
      qry.ParamByName('km4').AsString := km4;
      qry.ParamByName('proximarevper').AsString := proximarevper;
      qry.ParamByName('marca').AsString := marca;
      qry.ParamByName('fabricacao').AsString := fabricacao;
      qry.ParamByName('renavam').AsString := renavam;
      qry.ParamByName('chassi').AsString := chassi;
      qry.ParamByName('licenciamento').AsString := licenciamento;
      qry.ParamByName('DELETADO').AsInteger := 0;
      qry.ParamByName('classificacao').AsString := classificacao;
      qry.ParamByName('mesbase').AsString := mesbase;
      qry.ParamByName('status').AsString := ativo;
      qry.ParamByName('idempresa').AsInteger := idempresa;
      qry.ParamByName('idpessoa').AsInteger := idpessoa;

      qry.ExecSQL;

      // Após salvar o veículo, verifica se status != 'ATIVO'
      if not SameText(ativo, 'ATIVO') then
      begin
        qryHist := TFDQuery.Create(nil);
        try
          qryHist.Connection := FConn;
          qryHist.SQL.Text :=
            'SELECT id, iniciolocacaohistorico, fimlocacaohistorico, valordespesa ' +
            'FROM historicoveiculo ' +
            'WHERE placa = :placa ' +
            'AND iniciolocacaohistorico IS NOT NULL ' +
            'AND (fimlocacaohistorico IS NULL OR fimlocacaohistorico > CURRENT_DATE()) ' +
            'ORDER BY id DESC LIMIT 1';
          qryHist.ParamByName('placa').AsString := placa;
          qryHist.Open;

          if not qryHist.IsEmpty then
          begin
            dataInicio := qryHist.FieldByName('iniciolocacaohistorico').AsDateTime;

            if not qryHist.FieldByName('fimlocacaohistorico').IsNull then
              dataFimOriginal := qryHist.FieldByName('fimlocacaohistorico').AsDateTime
            else
              dataFimOriginal := dataHoje;

            try
              valorTotal := StrToFloatDef(qryHist.FieldByName('valordespesa').AsString,0);
            except
              valorTotal := 0;
            end;

            if (valorTotal > 0) and (dataFimOriginal > dataInicio) then
            begin
              totalDias := Trunc(dataFimOriginal - dataInicio);
              if totalDias < 1 then
                totalDias := 1;

              diasCorridos := Trunc(dataHoje - dataInicio);
              if diasCorridos < 1 then
                diasCorridos := 1;

              if diasCorridos > totalDias then
                diasCorridos := totalDias;

              valorProporcional := (valorTotal / totalDias) * diasCorridos;

              // Faz o UPDATE
              var idHist := qryHist.FieldByName('id').AsInteger;
              qryHist.Close;
              qryHist.SQL.Clear;
              qryHist.SQL.Add('UPDATE historicoveiculo SET fimlocacaohistorico = :fim, valordespesa = :valor WHERE id = :id');
              qryHist.ParamByName('fim').AsDate := dataHoje;
              qryHist.ParamByName('valor').AsString := FloatToStr(valorProporcional);
              qryHist.ParamByName('id').AsInteger := idHist;
              qryHist.ExecSQL;
            end;
          end;
        finally
          qryHist.Free;
        end;
      end;

      FConn.Commit;
      Result := True;
    except
      on ex: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao cadastrar veículo: ' + ex.Message;
        Result := False;
      end;
    end;
  finally
    qry.Free;
  end;
end;


function TVeiculos.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select ');
      SQL.Add('gesveiculos.idveiculo as id, ');
      SQL.Add('gesveiculos.PLACA, ');
      SQL.Add('gesveiculos.inspecaoveicular, ');
      SQL.Add('gesveiculos.RENAVAM, ');
      SQL.Add('gesveiculos.LICENCIAMENTO, ');
      SQL.Add('gesveiculos.MODELO, ');
      SQL.Add('gesveiculos.FABRICACAO, ');
      SQL.Add('gesveiculos.MARCA, ');
      SQL.Add('gesveiculos.CHASSI, ');
      SQL.Add('gesveiculos.COR, ');
      SQL.Add('gesveiculos.CATEGORIA, ');
      SQL.Add('gesveiculos.INICIOLOCACAO, ');
      SQL.Add('gesveiculos.FIMLOCACAO, ');
      SQL.Add('gesveiculos.periodicidade, ');
      SQL.Add('gesveiculos.MESBASE, ');
      SQL.Add('gesveiculos.Status, ');
      SQL.Add('gesveiculos.idempresa, ');
      SQL.Add('gesveiculos.idpessoa, ');
      SQL.Add('gesveiculos.proximarevper, ');
      SQL.Add('gesveiculos.km4, ');
      SQL.Add('gesveiculos.kmatual, ');
      SQL.Add('gesveiculos.ultimarevper, ');
      SQL.Add('gesveiculos.kmsrestante, ');
      SQL.Add('gespessoa.nome, ');
      SQL.Add('gespessoa.idpessoa, ');
      SQL.Add('gespessoa.datavalidadecnh, ');
      SQL.Add('gespessoa.status as statuspessoa ');
      SQL.Add('From ');
      SQL.Add('gesveiculos ');
      SQL.Add('LEFT JOIN gespessoa ON gesveiculos.idpessoa = gespessoa.idpessoa ');
      SQL.Add('WHERE gesveiculos.idveiculo is not null and gesveiculos.deletado = 0 ');

      if AQuery.ContainsKey('statusveic') then
      begin
        a := AQuery.Items['statusveic'];
        if a <> 'TODOS' then
        begin
          SQL.Add('AND gesveiculos.status = :sta ');
          if a = '' then
            parambyname('sta').asstring := 'ATIVO'
          else
            parambyname('sta').asstring := a;
        end;
      end;

      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND (gesveiculos.PLACA LIKE :busca OR ');
          SQL.Add('gespessoa.nome LIKE :busca OR ');
          SQL.Add('gesveiculos.inspecaoveicular LIKE :busca OR ');
          SQL.Add('gesveiculos.RENAVAM LIKE :busca OR ');
          SQL.Add('gesveiculos.MODELO LIKE :busca OR ');
          SQL.Add('gesveiculos.MARCA LIKE :busca OR ');
          SQL.Add('gesveiculos.CHASSI LIKE :busca OR ');
          SQL.Add('gesveiculos.COR LIKE :busca OR ');
          SQL.Add('gesveiculos.CATEGORIA LIKE :busca) ');
          parambyname('busca').AsString := '%' + AQuery.Items['busca'] + '%';
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

function TVeiculos.BuscarDadosPlaca(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gesveiculos.* ');
      SQL.Add('From ');
      SQL.Add('gesveiculos');
      SQL.Add('WHERE gesveiculos.idveiculo is not null and gesveiculos.placa = :placa ');
      ParamByName('placa').AsString := placa;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesveiculos.deletado = :deletado');
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
function TVeiculos.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select ');
      SQL.Add('gesveiculos.*, ');
      SQL.Add('gesempresas.nome as empresa, ');
      SQL.Add('gespessoa.nome As funcionario ');
      SQL.Add('From ');
      SQL.Add('gesveiculos left Join ');
      SQL.Add('gesempresas On gesempresas.idempresa = gesveiculos.idempresa left Join ');
      SQL.Add('gespessoa On gespessoa.idpessoa = gesveiculos.idpessoa ');
      SQL.Add('WHERE gesveiculos.idveiculo is not null and gesveiculos.idveiculo =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idpessoabusca'].ToInteger;
      a := AQuery.Items['idpessoabusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gesveiculos.deletado = :deletado');
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

end.


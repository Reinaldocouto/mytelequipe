unit Model.ContasPagar;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TContasPagar = class
  private
    FConn: TFDConnection;
    Fidcontaspagar: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
    Fidcontaspagarbaixa: Integer;
    Fidcategoria: Integer;
    Fidfornecedor: Integer;
    Fidpessoa: Integer;
    Fdocumento: string;
    Fhistorico: string;
    Fpago: Real;
    Fsaldo: Real;
    Fvalor: Real;
    Fvencimento: string;
    Focorrencia: string;
    Femissao: string;
    Fcategoria: string;
    Fdiavencimento: Integer;
    Fnumeroparcelas: Integer;
    Fmarcadores: string;
    Forigem: string;
    Fdatapagamento: string;
    Fvalorpago: real;
    Fformapagamento: real;

  public
    constructor Create;
    destructor Destroy; override;

    property idcontaspagar: Integer read Fidcontaspagar write Fidcontaspagar;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;
    property idfornecedor: Integer read Fidfornecedor write Fidfornecedor;
    property idpessoa: Integer read Fidpessoa write Fidpessoa;
    property documento: string read Fdocumento write Fdocumento;
    property historico: string read Fhistorico write Fhistorico;
    property pago: Real read Fpago write Fpago;
    property saldo: Real read Fsaldo write Fsaldo;
    property valor: Real read Fvalor write Fvalor;
    property vencimento: string read Fvencimento write Fvencimento;
    property ocorrencia: string read Focorrencia write Focorrencia;
    property emissao: string read Femissao write Femissao;
    property categoria: string read Fcategoria write Fcategoria;
    property diavencimento: Integer read Fdiavencimento write Fdiavencimento;
    property numeroparcelas: Integer read Fnumeroparcelas write Fnumeroparcelas;
    property marcadores: string read Fmarcadores write Fmarcadores;
    property idcontaspagarbaixa: Integer read Fidcontaspagarbaixa write Fidcontaspagarbaixa;
    property idcategoria: Integer read Fidcategoria write Fidcategoria;
    property origem: string read Forigem write Forigem;
    property datapagamento: string read Fdatapagamento write Fdatapagamento;
    property valorpago: real read Fvalorpago write Fvalorpago;
    property formapagamento: real read Fformapagamento write Fformapagamento;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    //function Inserir(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
    function Baixarconta(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;
  end;

implementation

{ TContaspagar }

constructor TContasPagar.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TContasPagar.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TContasPagar.Editar(out erro: string): Boolean;
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

        sql.add('select idcontaspagar from gescontaspagar where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        if RecordCount = 0 then
        begin
          id := fieldbyname('idcontaspagar').AsInteger;
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO gescontaspagar(idcontaspagar,idfornecedor,idpessoa,documento,historico,pago,saldo,');
          SQL.Add('valor,vencimento,ocorrencia,emissao,categoria,');
          SQL.Add('numeroparcelas,marcadores,IDCLIENTE,IDLOJA,DELETADO)');
          SQL.Add('               VALUES(:idcontaspagar,:idfornecedor,:idpessoa,:documento,:historico,:pago,:saldo,');
          SQL.Add(':valor,:vencimento,:ocorrencia,:emissao,:categoria, ');
          SQL.Add(':numeroparcelas,:marcadores,:IDCLIENTE,:IDLOJA,:DELETADO)');
          ParamByName('deletado').AsInteger := 0;
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gescontaspagar set idpessoa=:idpessoa,');
          SQL.Add('idfornecedor =:idfornecedor,');
          SQL.Add('documento=:documento,');
          SQL.Add('historico=:historico,');
          SQL.Add('pago=:pago,');
          SQL.Add('saldo=:saldo,');
          SQL.Add('valor=:valor,');
          SQL.Add('vencimento=:vencimento, ');
          SQL.Add('ocorrencia=:ocorrencia,');
          SQL.Add('emissao=:emissao,');
          SQL.Add('categoria=:categoria,');
          SQL.Add('numeroparcelas=:numeroparcelas,');
          SQL.Add('marcadores=:marcadores, DELETADO=:DELETADO');
          SQL.Add('where IDCLIENTE=:IDCLIENTE and IDLOJA=:IDLOJA and IDCONTASPAGAR=:IDCONTASPAGAR');
        end;
        ParamByName('idcontaspagar').Value := idcontaspagar;
        ParamByName('idpessoa').Value := idpessoa;
        ParamByName('idfornecedor').Value := idfornecedor;
        ParamByName('documento').Value := documento;
        ParamByName('historico').Value := historico;
        ParamByName('pago').Value := pago;
        ParamByName('saldo').Value := saldo;
        ParamByName('valor').Value := valor;
        ParamByName('vencimento').Value := vencimento;
        ParamByName('ocorrencia').Value := ocorrencia;
        ParamByName('emissao').Value := emissao;
        ParamByName('categoria').Value := categoria;
        ParamByName('numeroparcelas').Value := numeroparcelas;
        ParamByName('marcadores').Value := marcadores;

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
        erro := 'Erro ao cadastrar contas a pagar: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TContasPagar.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idcontaspagar = idcontaspagar+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idcontaspagar from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idcontaspagar := fieldbyname('idcontaspagar').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idcontaspagar;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao consultar : ' + ex.Message;
        Result := 0;
      end;
    end;
  finally
    qry.Free;
  end;
end;

{
function TContasPagar.Inserir(out erro: string): Boolean;
var
  qry: TFDQuery;
  id, i: Integer;
  dataano: string;
  datames: string;
  datadia: string;
  vencimentoh: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      dataano := vencimento[1] + vencimento[2] + vencimento[3] + vencimento[4];
      datames := vencimento[6] + vencimento[7];
      datadia := vencimento[9] + vencimento[10];
      vencimentoh := datadia + '/' + datames + '/' + dataano;

      FConn.StartTransaction;
      with qry do
      begin
        Active := false;
        sql.Clear;
        sql.add('update admponteiro set idcontaspagar = idcontaspagar+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idcontaspagar from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        id := fieldbyname('idcontaspagar').AsInteger;
        Active := false;
        sql.Clear;
        SQL.Add('INSERT INTO gescontaspagar(idcontaspagar,idpessoa,documento,historico,pago,saldo,');
        SQL.Add('valor,vencimento,ocorrencia,emissao,categoria,');
        SQL.Add('numeroparcelas,marcadores,IDCLIENTE,IDLOJA,DELETADO)');
        SQL.Add('               VALUES(:idcontaspagar,:idpessoa,:documento,:historico,:pago,:saldo,');
        SQL.Add(':valor,:vencimento,:ocorrencia,:emissao,:categoria, ');
        SQL.Add(':numeroparcelas,:marcadores,:IDCLIENTE,:IDLOJA,:DELETADO)');

        ParamByName('idcontaspagar').Value := id;
        ParamByName('idpessoa').Value := idpessoa;
        ParamByName('documento').Value := documento;
        ParamByName('historico').Value := historico;
        ParamByName('pago').Value := pago;
        ParamByName('saldo').Value := saldo;
        ParamByName('valor').Value := valor;

        case AnsiIndexStr(UpperCase(ocorrencia), ['ÚNICA', 'SEMANAL', 'MENSAL', 'TRIMESTRAL', 'SEMESTRAL', 'ANUAL']) of
          0:
            ParamByName('vencimento').Value := StrToDate(vencimentoh);
          1:
            ParamByName('vencimento').Value := (StrToDate(vencimentoh) + (i * 7));
          2:
            ParamByName('vencimento').Value := IncMonth(StrToDate(vencimentoh), i);
          3:
            ParamByName('vencimento').Value := IncMonth(StrToDate(vencimentoh), i * 3);
          4:
            ParamByName('vencimento').Value := IncMonth(StrToDate(vencimentoh), i * 6);
          5:
            ParamByName('vencimento').Value := IncMonth(StrToDate(vencimentoh), i * 12);
          {/*
            6:
              ParamByName('vencimento').Value := IncMonth(StrToDate(vencimento), i);
          */
        end;


       // ParamByName('vencimento').Value := vencimentoh;
        ParamByName('ocorrencia').Value := ocorrencia;
        ParamByName('emissao').Value := emissao;
        ParamByName('categoria').Value := categoria;
        ParamByName('numeroparcelas').Value := numeroparcelas;
        ParamByName('marcadores').Value := marcadores;

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
        erro := 'Erro ao cadastrar contas a pagar: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;
}

function TContasPagar.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select   ');
      SQL.Add('gescontaspagar.idcontaspagar as id,   ');
      SQL.Add('gescontaspagar.idfornecedor,  ');
      SQL.Add('gespessoa.nome as fornecedor,   ');
      SQL.Add('gescontaspagar.status,   ');
      SQL.Add('gescontaspagar.idpessoa,   ');
      SQL.Add('gescontaspagar.documento,   ');
      SQL.Add('gescontaspagar.historico,   ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gescontaspagar.pago, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as pago, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gescontaspagar.saldo, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as saldo, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gescontaspagar.valor, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valor, ');
      SQL.Add('DATE_FORMAT(gescontaspagar.vencimento,''%d/%m/%Y'') as vencimento,    ');
      SQL.Add('gescontaspagar.marcadores    ');
      SQL.Add('From   ');
      SQL.Add('gescontaspagar Left Join  ');
      SQL.Add('gespessoa On gespessoa.idpessoa = gescontaspagar.idfornecedor  ');
      SQL.Add('And gespessoa.idcliente = gescontaspagar.idcliente  ');
      SQL.Add('And gespessoa.idloja = gescontaspagar.idloja  ');
      SQL.Add('WHERE gescontaspagar.idcontaspagar is not null ');

      //pesquisar
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND(gespessoa.nome like ''%' + AQuery.Items['busca'] + '%'') ');
        end;
      end;

      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gescontaspagar.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gescontaspagar.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gescontaspagar.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end;
      end;
      SQL.Add(' order by idcontaspagar asc');
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

function TContaspagar.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add(' *, ');
      SQL.Add('gespessoa.nome as fornecedor   ');
      SQL.Add('From ');
      SQL.Add('gescontaspagar Left Join  ');
      SQL.Add('gespessoa On gespessoa.idpessoa = gescontaspagar.idfornecedor  ');
      SQL.Add('And gespessoa.idcliente = gescontaspagar.idcliente  ');
      SQL.Add('And gespessoa.idloja = gescontaspagar.idloja  ');
      SQL.Add('WHERE gescontaspagar.idcontaspagar is not null and gescontaspagar.idcontaspagar =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idcontaspagarbusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gescontaspagar.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gescontaspagar.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gescontaspagar.idloja = :idloja');
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

function TContasPagar.Baixarconta(out erro: string): Boolean;
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
        sql.add('update admponteiro set idcontaspagarbaixa = idcontaspagarbaixa+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idcontaspagarbaixa from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;

        id := fieldbyname('idcontaspagarbaixa').AsInteger;
        Active := false;
        sql.Clear;
        SQL.Add('INSERT INTO gescontaspagarbaixa(idcontaspagarbaixa,idcontaspagar,idcategoria,');
        SQL.Add('valorpago,origem,datapagamento,formapagamento,');
        SQL.Add('historico,documento,IDCLIENTE,IDLOJA,DELETADO)');
        SQL.Add('               VALUES(:idcontaspagarbaixa,:idcontaspagar,:idcategoria,:valorpago,');
        SQL.Add(':origem,:datapagamento,:formapagamento,:historico, ');
        SQL.Add(':documento,:IDCLIENTE,:IDLOJA,:DELETADO)');

        ParamByName('idcontaspagarbaixa').Value := id;
        ParamByName('idcontaspagar').Value := idcontaspagar;
        ParamByName('idcategoria').Value := idcategoria;
        ParamByName('origem').Value := origem;
        ParamByName('datapagamento').Value := datapagamento;
        ParamByName('valorpago').Value := valorpago;
        ParamByName('documento').Value := documento;
        ParamByName('historico').Value := historico;
        ParamByName('formapagamento').Value := formapagamento;

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
        erro := 'Erro ao cadastrar contas a pagar baixa: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

end.


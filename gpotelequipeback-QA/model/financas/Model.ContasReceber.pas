unit Model.ContasReceber;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TContasreceber = class
  private
    FConn: TFDConnection;
    Fidcontasreceber: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
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
    Fnumeroparcelas: Integer;
    Fmarcadores: string;

  public
    constructor Create;
    destructor Destroy; override;

    property idcontasreceber: Integer read Fidcontasreceber write Fidcontasreceber;
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
    property numeroparcelas: Integer read Fnumeroparcelas write Fnumeroparcelas;
    property marcadores: string read Fmarcadores write Fmarcadores;

    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    //function Inserir(out erro: string): Boolean;
    function Editar(out erro: string): Boolean;
    function NovoCadastro(out erro: string): integer;

  end;

implementation

{ TContasreceber }

constructor TContasreceber.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TContasreceber.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TContasreceber.NovoCadastro(out erro: string): integer;
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
        sql.add('update admponteiro set idcontasreceber = idcontasreceber+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idcontasreceber from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idcontasreceber := fieldbyname('idcontasreceber').AsInteger;
      end;
      FConn.Commit;
      erro := '';
      Result := idcontasreceber;
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

function TContasreceber.Editar(out erro: string): Boolean;
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
        sql.add('select idcontasreceber from gescontasreceber where idcliente=:idcliente and idloja=:idloja and idcontasreceber=:idcontasreceber ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        ParamByName('idcontasreceber').AsInteger := idcontasreceber;
        Open;
        if RecordCount = 0 then
        begin
          Active := false;
          sql.Clear;
          SQL.Add('INSERT INTO gescontasreceber(idcontasreceber,idclientelocal,documento,historico,pago,saldo,');
          SQL.Add('valor,vencimento,ocorrencia,emissao,categoria,');
          SQL.Add('numeroparcelas,marcadores,IDCLIENTE,IDLOJA,DELETADO)');
          SQL.Add('  VALUES(:idcontasreceber,:idclientelocal,:documento,:historico,:pago,:saldo,');
          SQL.Add(':valor,:vencimento,:ocorrencia,:emissao,:categoria, ');
          SQL.Add(':numeroparcelas,:marcadores,:IDCLIENTE,:IDLOJA,:DELETADO)');
          ParamByName('deletado').AsInteger := 0;
        end
        else
        begin
          Active := false;
          sql.Clear;
          SQL.Add('update gescontasreceber set ');
          SQL.Add('idclientelocal =:idclientelocal,');
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
          SQL.Add('where IDCLIENTE=:IDCLIENTE and IDLOJA=:IDLOJA and IDCONTASRECEBER=:IDCONTASRECEBER');
        end;
        ParamByName('idcontasreceber').Value := idcontasreceber;
        ParamByName('idclientelocal').Value := idpessoa;
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
        FConn.Rollback;
        erro := 'Erro ao cadastrar contas a receber: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TContasreceber.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gescontasreceber.idcontasreceber as id,   ');
      SQL.Add('gespessoa.nome as cliente,   ');
      SQL.Add('gescontasreceber.documento,   ');
      SQL.Add('gescontasreceber.historico,   ');
      SQL.Add('gescontaspagar.status,   ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gescontasreceber.pago, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as pago, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gescontasreceber.saldo, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as saldo, ');
      SQL.Add('Concat(''R$ '',Replace(Replace(Replace(Format(gescontasreceber.valor, 2), ''.'', ''|''), '','', ''.''), ''|'', '','')) as valor, ');
      SQL.Add('DATE_FORMAT(gescontasreceber.vencimento,''%d/%m/%Y'') as vencimento, ');
      SQL.Add('gescontasreceber.ocorrencia,    ');
      SQL.Add('DATE_FORMAT(gescontasreceber.emissao,''%d/%m/%Y'') as emissao, ');
      SQL.Add('gescontasreceber.categoria,    ');
      SQL.Add('gescontasreceber.numeroparcelas,    ');
      SQL.Add('gescontasreceber.marcadores    ');
      SQL.Add('From   ');
      SQL.Add('gescontasreceber Left Join  ');
      SQL.Add('gespessoa On gespessoa.idpessoa = gescontasreceber.idclientelocal  ');
      SQL.Add('And gespessoa.idcliente = gescontasreceber.idcliente  ');
      SQL.Add('And gespessoa.idloja = gescontasreceber.idloja  ');
      SQL.Add('WHERE gescontasreceber.idcontasreceber is not null ');

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
          SQL.Add('AND gescontasreceber.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gescontasreceber.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gescontasreceber.idloja = :idloja');
          ParamByName('idloja').Value := AQuery.Items['idloja'].ToInteger;
        end;
      end;
      SQL.Add(' order by idcontasreceber asc');
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

function TContasreceber.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('gespessoa.nome as cliente   ');
      SQL.Add('From ');
      SQL.Add('gescontasreceber Left Join  ');
      SQL.Add('gespessoa On gespessoa.idpessoa = gescontasreceber.idclientelocal  ');
      SQL.Add('And gespessoa.idcliente = gescontasreceber.idcliente  ');
      SQL.Add('And gespessoa.idloja = gescontasreceber.idloja  ');
      SQL.Add('WHERE gescontasreceber.idcontasreceber is not null and gescontasreceber.idcontasreceber =:id ');
      ParamByName('id').AsInteger := AQuery.Items['idcontasreceberbusca'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND gescontasreceber.deletado = :deletado');
          ParamByName('deletado').Value := AQuery.Items['deletado'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idcliente') then
      begin
        if Length(AQuery.Items['idcliente']) > 0 then
        begin
          SQL.Add('AND gescontasreceber.idcliente = :idcliente');
          ParamByName('idcliente').Value := AQuery.Items['idcliente'].ToInteger;
        end;
      end;
      if AQuery.ContainsKey('idloja') then
      begin
        if Length(AQuery.Items['idloja']) > 0 then
        begin
          SQL.Add('AND gescontasreceber.idloja = :idloja');
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

end.


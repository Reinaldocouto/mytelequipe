unit Model.Exclusao;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TExclusao = class
  private
    FConn: TFDConnection;
    Fid: string;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    property id: string read Fid write Fid;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;

    function excluirpessoas(out erro: string): Boolean;
    function excluirproduto(out erro: string): Boolean;
    function excluircompras(out erro: string): Boolean;
    function excluirembalagem(out erro: string): Boolean;
    function excluircontaspagar(out erro: string): Boolean;
    function excluircontasreceber(out erro: string): Boolean;
    function excluirpedidovenda(out erro: string): Boolean;
    function excluirmarca(out erro: string): Boolean;
    function excluircategoria(out erro: string): Boolean;
    function excluirplanoconta(out erro: string): Boolean;
    function excluircontatoedicao(out erro: string): Boolean;
    function excluirconfiguracoesusuario(out erro: string): Boolean;
    function excluirsubcategoria(out erro: string): Boolean;
    function excluirunidade(out erro: string): Boolean;
    function excluirrelacionamento(out erro: string): Boolean;
    function excluiratividadeclt(out erro: string): Boolean;
    function excluirveiculos(out erro: string): Boolean;
    function excluiratividadepj(out erro: string): Boolean;
    function excluirempresas(out erro: string): Boolean;
    function excluiratividadepjengenharia(out erro: string): Boolean;
    function excluirtreinamentopessoas(out erro: string): Boolean;
    function excluirmultas(out erro: string): Boolean;
    function excluirdespesas(out erro: string): Boolean;
    function excluirdespesasitens(out erro: string): Boolean;
    function excluirlpu(out erro: string): Boolean;
    function excluircomprasitens(out erro: string): Boolean;
    function excluirsolicitacao(out erro: string): Boolean;
    function excluirsolicitacaoitens(out erro: string): Boolean;
    function excluiracionamentopjzte(out erro: string): Boolean;
    function excluiracionamentopjtelefonica(out erro: string): Boolean;
    function excluit2(out erro: string): Boolean;
    function excluiracionamentoclttelefonica(out erro: string): Boolean;
  end;

implementation

{ TExclusao }

constructor TExclusao.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TExclusao.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TExclusao.excluirpessoas(out erro: string): Boolean;
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
        SQL.Add('update gespessoa set DELETADO =:DELETADO where IDPESSOA =:IDPESSOA');
        ParamByName('idpessoa').AsInteger := StrToInt(id);
        //ParamByName('IDCLIENTE').Value := idcliente;
        //ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirproduto(out erro: string): Boolean;
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
        SQL.Add('update gesproduto set DELETADO =:DELETADO where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDproduto =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluircompras(out erro: string): Boolean;
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
        SQL.Add('Select gesordemcompra.situacao From gesordemcompra where idordemcompra =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        open;
        if fieldbyname('situacao').asstring = 'EM ABERTO' then
        begin

          Active := false;
          sql.Clear;
          SQL.Add('update gesordemcompra set DELETADO =:DELETADO where idordemcompra =:ID');
          ParamByName('id').AsInteger := StrToInt(id);
          ParamByName('DELETADO').Value := 1;
          ExecSQL;
          erro := '';
          FConn.Commit;
          result := true;
        end
        else
        begin
          FConn.Rollback;
          erro := 'Esse pedido de compra ja esta em andamento ou finalizado. Voltar para o STATUS EM ABERTO para poder excluir!';
          Result := false;
        end;
      end;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirembalagem(out erro: string): Boolean;
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
        SQL.Add('update gesembalagem set DELETADO =:DELETADO where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDEMBALAGEM =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirempresas(out erro: string): Boolean;
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
        SQL.Add('update gesempresas set DELETADO =:DELETADO where IDEMPRESA =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluircomprasitens(out erro: string): Boolean;
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
        SQL.Add('update gesordemcompraitens set DELETADO =:DELETADO where idordemcompraitens =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirlpu(out erro: string): Boolean;
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
        SQL.Add('update obraericssonlpu set DELETADO =:DELETADO where historico =:historico');
        ParamByName('historico').Asstring := id;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluircontaspagar(out erro: string): Boolean;
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
        SQL.Add('update gescontaspagar set DELETADO =:DELETADO where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDCONTASPAGAR =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluircontasreceber(out erro: string): Boolean;
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
        SQL.Add('update gescontasreceber set DELETADO =:DELETADO where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDCONTASRECEBER =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirpedidovenda(out erro: string): Boolean;
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
        SQL.Add('update gespedidovenda set DELETADO =:DELETADO where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDPEDIDOVENDA =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirmarca(out erro: string): Boolean;
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
        SQL.Add('update gesmarca set DELETADO =:DELETADO where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDMARCA =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluircategoria(out erro: string): Boolean;
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
        SQL.Add('update gescategoria set DELETADO =:DELETADO where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDCATEGORIA =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirplanoconta(out erro: string): Boolean;
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
        SQL.Add('update gesplanoconta set DELETADO =:DELETADO where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDPLANOCONTA =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluircontatoedicao(out erro: string): Boolean;
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
        SQL.Add('update gescontato set DELETADO =:DELETADO where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDCONTATO =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirconfiguracoesusuario(out erro: string): Boolean;
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
        SQL.Add('update gesusuario set DELETADO =:DELETADO where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDUSUARIO =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirsolicitacao(out erro: string): Boolean;
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
        SQL.Add('update gessolicitacaoitens set DELETADO =:DELETADO where idsolicitacao =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
        Active := false;
        sql.Clear;
        SQL.Add('update gessolicitacao set DELETADO =:DELETADO where idsolicitacao =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirsolicitacaoitens(out erro: string): Boolean;
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
        SQL.Add('update gessolicitacaoitens set DELETADO =:DELETADO where idsolicitacaoitens =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirsubcategoria(out erro: string): Boolean;
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
        SQL.Add('update gessubcategoria set DELETADO =:DELETADO where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDSUBCATEGORIA =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirunidade(out erro: string): Boolean;
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
        SQL.Add('update gesunidade set DELETADO =:DELETADO where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDunidade =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirrelacionamento(out erro: string): Boolean;
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
        SQL.Add('update gespessoarelacionamento set DELETADO =:DELETADO where IDCLIENTE =:IDCLIENTE and IDLOJA =:IDLOJA and IDpessoarelacionamento =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluiracionamentopjtelefonica(out erro: string): Boolean;
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
        SQL.Add('update acionamentovivo set deletado = 1 where id=:id ');
        ParamByName('id').AsInteger := StrToInt(id);
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluiracionamentoclttelefonica(out erro: string): Boolean;
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
        SQL.Add('update acionamentovivoclt set deletado = 1 where id=:id ');
        ParamByName('id').AsInteger := StrToInt(id);
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluiracionamentopjzte(out erro: string): Boolean;
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
        SQL.Add('update obrazte set os=:os, ');
        SQL.Add('historicolpu=:historicolpu, ');
        SQL.Add('dataacionamento=:dataacionamento, ');
        SQL.Add('dataacionamentoemail=:dataacionamentoemail, ');
        SQL.Add('idcolaborador=:idcolaborador, ');
        SQL.Add('regiao=:regiao, ');
        SQL.Add('observacaopj=:observacaopj, ');
        SQL.Add('valorlpu=:valorlpu where id=:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('os').AsString := '--';
        ParamByName('historicolpu').AsString := '';
        ParamByName('dataacionamento').AsDate := StrToDate('31/12/1899');
        ParamByName('dataacionamentoemail').AsDate := StrToDate('31/12/1899');
        ParamByName('idcolaborador').AsInteger := 0;
        ParamByName('regiao').AsString := '';
        ParamByName('observacaopj').AsString := '';
        ParamByName('valorlpu').Asfloat := 0;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluiratividadeclt(out erro: string): Boolean;
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
        SQL.Add('update obraericssonatividadeclt set DELETADO =:DELETADO where idgeral =:ID');
        ParamByName('id').AsInteger := StrToInt(id);
        //ParamByName('IDCLIENTE').Value := idcliente;
        //ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluiratividadepj(out erro: string): Boolean;
var
  qry: TFDQuery;
  descricaoservico, po: string;
  idcolaborador: string;
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
        SQL.Add('select * from obraericssonatividadepj where idgeral =:ID ');
        ParamByName('id').AsInteger := StrToInt(id);
        Open();
        descricaoservico := FieldByName('descricaoservico').asstring;
        idcolaborador := FieldByName('idcolaboradorpj').asstring;
        po := FieldByName('po').asstring;

        Active := false;
        sql.Clear;
        SQL.Add('update obraericssonatividadepj set DELETADO =:DELETADO where descricaoservico=:descricaoservico and idcolaboradorpj=:idcolaboradorpj and po=:po ');
        ParamByName('idcolaboradorpj').AsString := idcolaborador;
        ParamByName('descricaoservico').AsString := descricaoservico;
        ParamByName('po').AsString := po;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
        Active := false;
        sql.Clear;
        SQL.Add('delete From obraericssonfechamento where obraericssonfechamento.Descricao =:descricaoservico and idcolaboradorpj=:idcolaboradorpj and po=:po ');
        ParamByName('idcolaboradorpj').AsString := idcolaborador;
        ParamByName('descricaoservico').AsString := descricaoservico;
        ParamByName('po').AsString := po;
        ExecSQL;

      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluiratividadepjengenharia(out erro: string): Boolean;
var
  qry: TFDQuery;
  descricaoservico: string;
  idcolaborador: string;
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
        SQL.Add('select * from obraericssonatividadepj where idgeral =:ID ');
        ParamByName('id').AsInteger := StrToInt(id);
        Open();
        descricaoservico := FieldByName('descricaoservico').asstring;
        idcolaborador := FieldByName('idcolaboradorpj').asstring;

        Active := false;
        sql.Clear;
        SQL.Add('update obraericssonatividadepj set DELETADO =:DELETADO where descricaoservico=:descricaoservico and idcolaboradorpj=:idcolaboradorpj ');
        ParamByName('idcolaboradorpj').AsString := idcolaborador;
        ParamByName('descricaoservico').AsString := descricaoservico;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
        Active := false;
        sql.Clear;
        SQL.Add('delete From obraericssonfechamento where obraericssonfechamento.Descricao =:descricaoservico and idcolaboradorpj=:idcolaboradorpj');
        ParamByName('idcolaboradorpj').AsString := idcolaborador;
        ParamByName('descricaoservico').AsString := descricaoservico;
        ExecSQL;

      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirveiculos(out erro: string): Boolean;
var
  qry: TFDQuery;
  vehicleStatus: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    try
      FConn.StartTransaction;

      // verifica o status
      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('SELECT status FROM gesveiculos WHERE idveiculo = :ID');
        ParamByName('ID').AsInteger := StrToInt(id);
        Open;
        if not EOF then
        begin
          vehicleStatus := FieldByName('status').AsString;
        end
        else
        begin
          erro := 'Veículo não encontrado.';
          Result := False;
          FConn.Rollback;
          Exit;
        end;
      end;

      // se status 'ATIVO', não deleta
      if vehicleStatus = 'ATIVO' then
      begin
        erro := 'Primeiro é necessário desativar esse veículo.';
        Result := False;
        FConn.Rollback;
      end
      else
      begin
        // continua para deleção
        qry.Active := False;
        qry.SQL.Clear;
        qry.SQL.Add('UPDATE gesveiculos SET deletado = :deletado WHERE idveiculo = :ID');
        qry.ParamByName('ID').AsInteger := StrToInt(id);
        qry.ParamByName('DELETADO').Value := 1;
        qry.ExecSQL;

        erro := '';
        FConn.Commit;
        Result := True;
      end;

    except
      on ex: Exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := False;
        FConn.Rollback;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluit2(out erro: string): Boolean;
var
  qry, qry2: TFDQuery;
  UID_IDCPOMRF: string;
  cont : Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    qry2 := TFDQuery.Create(nil);
    qry2.connection := FConn;
    try
      FConn.StartTransaction;
      with qry2 do
      begin
        Active := false;
        sql.Clear;
        SQL.Add('select * from telefonicacontrolet2 where id=:id ');
        ParamByName('id').AsInteger := StrToInt(id);
        open   ;
        UID_IDCPOMRF := fieldbyname('idobra').asstring;

        Active := false;
        sql.Clear;
        SQL.Add('delete from telefonicacontrolet2 where id=:id ');
        ParamByName('id').AsInteger := StrToInt(id);
        ExecSQL;


        cont := 0;
        active := false;
        SQL.Clear;
        sql.Add('Select ');
        sql.Add('Count(telefonicacontrolet2.IDOBRA) As Count_IDOBRA, ');
        sql.Add('telefonicacontrolet2.ID, ');
        sql.Add('telefonicacontrolet2.ITEMT2 ');
        sql.Add('From ');
        sql.Add('telefonicacontrolet2 ');
        sql.Add('Where ');
        sql.Add('telefonicacontrolet2.IDOBRA =:ido ');
        sql.Add('Group By ');
        sql.Add('telefonicacontrolet2.ID, ');
        sql.Add('telefonicacontrolet2.ITEMT2 ');
        sql.Add('order by ');
        sql.Add('telefonicacontrolet2.ID ');
        ParamByName('ido').asstring := UID_IDCPOMRF;
        Open();

        while not eof do
        begin
          cont := cont + 1;
          with qry do
          begin
            active := false;
            SQL.Clear;
            SQL.add('update telefonicacontrolet2 set itemt2=:t2, tipo=:tipo  where id=:id ');
            ParamByName('id').asinteger := qry2.fieldbyname('id').asinteger;
            ParamByName('t2').asinteger := cont;
            ParamByName('tipo').asstring := 'serviço'+inttostr(cont);
            execsql;
          end;
          Next;
        end;

      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirtreinamentopessoas(out erro: string): Boolean;
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
        SQL.Add('delete from gestreinamento where idgestreinamento=:idgestreinamento ');
        ParamByName('idgestreinamento').AsInteger := StrToInt(id);
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirmultas(out erro: string): Boolean;
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
        SQL.Add('update gesmultas set DELETADO =:DELETADO where idmultas =:id');
        //  idcliente =:IDCLIENTE AND idloja =:IDLOJA and
        ParamByName('id').AsInteger := StrToInt(id);
        //ParamByName('IDCLIENTE').Value := idcliente;
        //ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirdespesas(out erro: string): Boolean;
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
        SQL.Add('update gesdespesas set DELETADO =:DELETADO where iddespesas =:id');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TExclusao.excluirdespesasitens(out erro: string): Boolean;
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
        SQL.Add('update gesdespesas set DELETADO =:DELETADO where idcliente =:IDCLIENTE AND idloja =:IDLOJA and iddespesas =:id');
        ParamByName('id').AsInteger := StrToInt(id);
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 1;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        erro := 'Erro ao excluir registro: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

end.


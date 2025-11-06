unit Model.HistoricoVeiculo;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.Generics.Collections;

type
  THistoricoVeiculo = class
  private
    FConn: TFDConnection;
    Fid: Integer;
    Finiciolocacao: TDate;
    Ffimlocacao: TDate;
    Fvalordespesa: string;
    Fplaca: string;
    Fempresa: string;
    Ffuncionario: string;
    Fcategoria: string;
    Fperiodicidade: string;

  public
    constructor Create;
    destructor Destroy; override;

    property id: Integer read Fid write Fid;
    property iniciolocacao: TDate read Finiciolocacao write Finiciolocacao;
    property fimlocacao: TDate read Ffimlocacao write Ffimlocacao;
    property valordespesa: string read Fvalordespesa write Fvalordespesa;
    property placa: string read Fplaca write Fplaca;
    property empresa: string read Fempresa write Fempresa;
    property funcionario: string read Ffuncionario write Ffuncionario;
    property categoria: string read Fcategoria write Fcategoria;
    property periodicidade: string read Fperiodicidade write Fperiodicidade;

    function Insert(out erro: string): Boolean;
    function Update(out erro: string): Boolean;
    function Delete(out erro: string): Boolean;
    function GetById(const AId: Integer; out erro: string): TFDQuery;
    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
  end;

implementation

{ THistoricoVeiculo }

constructor THistoricoVeiculo.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor THistoricoVeiculo.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function THistoricoVeiculo.Insert(out erro: string): Boolean;  //n estamos usando por enquanto, o insert esta sendo feito diretamente no lançamento de despesas
var
  qry: TFDQuery;
begin
  Result := False;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    try
      FConn.StartTransaction;
      qry.SQL.Clear;
      qry.SQL.Add('INSERT INTO historicoveiculo (iniciolocacaohistorico, fimlocacaohistorico, valordespesa, placa, empresa, funcionario, categoria, periodicidade)');
      qry.SQL.Add('VALUES (:iniciolocacaohistorico, :fimlocacaohistorico, :valordespesa, :placa, :empresa, :funcionario, :categoria, :periodicidade)');
      qry.ParamByName('iniciolocacaohistorico').AsDate := iniciolocacao;
      qry.ParamByName('fimlocacaohistorico').AsDate := fimlocacao;
      qry.ParamByName('valordespesa').AsString := valordespesa;
      qry.ParamByName('placa').AsString := placa;
      qry.ParamByName('empresa').AsString := empresa;
      qry.ParamByName('funcionario').AsString := funcionario;
      qry.ParamByName('categoria').AsString := categoria;
      qry.ParamByName('periodicidade').AsString := periodicidade;

      qry.ExecSQL;

      // Recupera o ID gerado
      qry.SQL.Text := 'SELECT LAST_INSERT_ID() as id';
      qry.Open;
      if not qry.IsEmpty then
        id := qry.FieldByName('id').AsInteger;

      FConn.Commit;
      erro := '';
      Result := True;
    except
      on E: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao inserir histórico: ' + E.Message;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function THistoricoVeiculo.Update(out erro: string): Boolean;
var
  qry: TFDQuery;
begin
  Result := False;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    try
      FConn.StartTransaction;
      qry.SQL.Clear;
      qry.SQL.Add('UPDATE historicoveiculo SET ');
      qry.SQL.Add('iniciolocacaohistorico = :iniciolocacaohistorico,');
      qry.SQL.Add('fimlocacaohistorico = :fimlocacaohistorico,');
      qry.SQL.Add('valordespesa = :valordespesa,');
      qry.SQL.Add('placa = :placa,');
      qry.SQL.Add('empresa = :empresa,');
      qry.SQL.Add('funcionario = :funcionario,');
      qry.SQL.Add('categoria = :categoria,');
      qry.SQL.Add('periodicidade = :periodicidade');
      qry.SQL.Add('WHERE id = :id');

      qry.ParamByName('iniciolocacaohistorico').AsDate := iniciolocacao;
      qry.ParamByName('fimlocacaohistorico').AsDate := fimlocacao;
      qry.ParamByName('valordespesa').AsString := valordespesa;
      qry.ParamByName('placa').AsString := placa;
      qry.ParamByName('empresa').AsString := empresa;
      qry.ParamByName('funcionario').AsString := funcionario;
      qry.ParamByName('categoria').AsString := categoria;
      qry.ParamByName('periodicidade').AsString := periodicidade;
      qry.ParamByName('id').AsInteger := id;

      qry.ExecSQL;
      FConn.Commit;
      erro := '';
      Result := True;
    except
      on E: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao atualizar histórico: ' + E.Message;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function THistoricoVeiculo.Delete(out erro: string): Boolean;
var
  qry: TFDQuery;
begin
  Result := False;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    try
      FConn.StartTransaction;
      qry.SQL.Text := 'DELETE FROM historicoveiculo WHERE id = :id';
      qry.ParamByName('id').AsInteger := id;
      qry.ExecSQL;
      FConn.Commit;
      erro := '';
      Result := True;
    except
      on E: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao deletar histórico: ' + E.Message;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function THistoricoVeiculo.GetById(const AId: Integer; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  Result := nil;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    qry.SQL.Text := 'SELECT * FROM historicoveiculo WHERE id = :id';
    qry.ParamByName('id').AsInteger := AId;
    qry.Open;
    if qry.IsEmpty then
    begin
      qry.Free;
      erro := 'Nenhum registro encontrado';
      Exit(nil);
    end;
    erro := '';
    Result := qry;
  except
    on E: Exception do
    begin
      erro := 'Erro ao buscar por ID: ' + E.Message;
      if Assigned(qry) then qry.Free;
    end;
  end;
end;

function THistoricoVeiculo.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  Result := nil;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    qry.SQL.Text := 'SELECT * FROM historicoveiculo WHERE 1=1';
    if AQuery.ContainsKey('nome') then
    begin
      qry.SQL.Add('AND empresa LIKE :empresa');
      qry.ParamByName('empresa').AsString := '%' + AQuery.Items['nome'] + '%';
    end;
    qry.Open;
    erro := '';
    Result := qry;
  except
    on E: Exception do
    begin
      erro := 'Erro ao consultar: ' + E.Message;
      if Assigned(qry) then qry.Free;
      Result := nil;
    end;
  end;
end;


end.


unit Model.Geral;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  Tgeral = class
  private
    FConn: TFDConnection;

  public
    constructor Create;
    destructor Destroy; override;

    function listaestadosbrasil(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function listaestadosbrasilid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;

    //tabelas Fiscais
    function listatipofrete(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;

  end;

implementation

{ Tgeral }

constructor TGeral.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TGeral.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TGeral.listaestadosbrasil(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('geralestadosbrasil.id, ');
      SQL.Add('geralestadosbrasil.nome, ');
      SQL.Add('geralestadosbrasil.abreviacao, ');
      SQL.Add('geralestadosbrasil.regiao ');
      SQL.Add('From ');
      SQL.Add('geralestadosbrasil order by id ');
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

function Tgeral.listaestadosbrasilid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
begin

end;

function Tgeral.listatipofrete(const AQuery: TDictionary<string, string>;
  out erro: string): TFDQuery;
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
      SQL.Add('gertipofrete.idtipofrete, ');
      SQL.Add('gertipofrete.descricao ');
      SQL.Add('From ');
      SQL.Add('gertipofrete order by idtipofrete');
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


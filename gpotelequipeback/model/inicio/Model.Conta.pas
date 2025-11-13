unit Model.Conta;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TConta = class
  private
    FConn: TFDConnection;
    //Fidconta: Integer;
    Fidcliente: Integer;
    Fidloja: Integer;
    Fdeletado: Integer;
    Frazaosocial: string;
    Ffantasia: string;
    Fnome: string;
    Fcnpj: string;
    Ftipopessoa: string;
    Fcodigoregimetributario: string;
    Fierg: string;
    Femail: string;
    Ftelefone: string;
    Fendereco: string;
    Fnumero: Integer;
    Fbairro: string;
    Fcidade: string;
    Fcep: string;
    Fuf: string;
    Fcomplemento: string;

  public
    constructor Create;
    destructor Destroy; override;

   //property idconta: Integer read Fidconta write Fidconta;
    property idcliente: Integer read Fidcliente write Fidcliente;
    property idloja: Integer read Fidloja write Fidloja;
    property deletado: Integer read Fdeletado write Fdeletado;

    property razaosocial: string read Frazaosocial write Frazaosocial;
    property fantasia: string read Ffantasia write Ffantasia;
    property nome: string read Fnome write Fnome;
    property cnpj: string read Fcnpj write Fcnpj;
    property tipopessoa: string read Ftipopessoa write Ftipopessoa;
    property codigoregimetributario: string read Fcodigoregimetributario write Fcodigoregimetributario;
    property ierg: string read Fierg write Fierg;
    property email: string read Femail write Femail;
    property telefone: string read Ftelefone write Ftelefone;
    property endereco: string read Fendereco write Fendereco;
    property numero: Integer read Fnumero write Fnumero;
    property bairro: string read Fbairro write Fbairro;
    property cidade: string read Fcidade write Fcidade;
    property cep: string read Fcep write Fcep;
    property uf: string read Fuf write Fuf;
    property complemento: string read Fcomplemento write Fcomplemento;

    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
  end;

implementation

{ TConta }

constructor TConta.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TConta.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TConta.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('admcliente WHERE admcliente.idcliente is not null and admcliente.idcliente =:id ');
      ParamByName('id').Value := AQuery.Items['idcliente'].ToInteger;
      if AQuery.ContainsKey('deletado') then
      begin
        if Length(AQuery.Items['deletado']) > 0 then
        begin
          SQL.Add('AND admcliente.deletado = :deletado');
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


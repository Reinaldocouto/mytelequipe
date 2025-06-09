unit Model.RegrasdeNegocio;

interface

uses
  FireDAC.Comp.Client, Data.DB, System.SysUtils, model.connection,
  System.StrUtils, FireDAC.DApt, System.Generics.Collections;

type
  TRegraNegocios = class
  private
    FConn: TFDConnection;

  public
    constructor Create;
    destructor Destroy; override;

    function gerenciadorENTRADAeSAIDA(idproduto: Integer; idcliente: integer; idloja: Integer; idusuario: Integer; idtipomovimento: integer; quantidade: double; observacao: string; valor:double): Boolean;
    // 1 ENTRADA  |  SOMA      |
    // 2 SAIDA    |  SUBTRAIR  |
    // 3 BALANCO  |  IGUAL     |

  end;

implementation

{ Tmarca }

constructor TRegraNegocios.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TRegraNegocios.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TRegraNegocios.gerenciadorENTRADAeSAIDA(idproduto, idcliente, idloja, idusuario, idtipomovimento: integer; quantidade: double; observacao: string; valor:double): Boolean;
var
  qry: TFDQuery;
  id, idcontroleestoque: Integer;
  mensagem: string;
  entrada: double;
  saida: double;
  balanco: double;
begin
  try
    mensagem := '';
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      FConn.StartTransaction;
      with qry do
      begin
        case idtipomovimento of
          1: //ENTRADA DE PRODUTO
            begin
              Active := false;
              sql.Clear;
              sql.add('update gesproduto set estoque = estoque + :quantidade where idproduto=:idproduto and idcliente=:idcliente and idloja=:idloja ');
              ParamByName('idcliente').asinteger := idcliente;
              ParamByName('idloja').AsInteger := idloja;
              ParamByName('idproduto').AsInteger := idproduto;
              ParamByName('quantidade').AsFloat := quantidade;
              execsql;
              mensagem := 'Entrada no estoque de ' + FloatToStr(quantidade) + ' item(s) ao produto de ID = ' + IntToStr(idproduto);
              entrada := quantidade;
              saida := 0;
              balanco := 0;
            end;
          2: //SAIDA DE PRODUTO
            begin
              Active := false;
              sql.Clear;
              sql.add('update gesproduto set estoque = estoque - :quantidade where idproduto=:idproduto and idcliente=:idcliente and idloja=:idloja ');
              ParamByName('idcliente').asinteger := idcliente;
              ParamByName('idloja').AsInteger := idloja;
              ParamByName('idproduto').AsInteger := idproduto;
              ParamByName('quantidade').AsFloat := quantidade;
              execsql;
              mensagem := 'Saida do estoque de ' + FloatToStr(quantidade) + ' item(s) ao produto de ID = ' + IntToStr(idproduto);
              entrada := 0;
              saida := quantidade;
              balanco := 0;
            end;
          3: //BALANÇO DE PRODUTO
            begin
              Active := false;
              sql.Clear;
              sql.add('update gesproduto set estoque=:quantidade where idproduto=:idproduto and idcliente=:idcliente and idloja=:idloja ');
              ParamByName('idcliente').asinteger := idcliente;
              ParamByName('idloja').AsInteger := idloja;
              ParamByName('idproduto').AsInteger := idproduto;
              ParamByName('quantidade').AsFloat := quantidade;
              execsql;
              mensagem := 'BALANÇO - Estoque atualizado para ' + FloatToStr(quantidade) + ' item(s) no produto de ID = ' + IntToStr(idproduto);
              entrada := 0;
              saida := 0;
              balanco := quantidade;
            end;
        else
          //erro := 'Tipo de movimento de estoque não localizado!';
        end;

        Active := false;
        sql.Clear;
        sql.add('update admponteiro set idcontroleestoque = idcontroleestoque+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idcontroleestoque from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        idcontroleestoque := fieldbyname('idcontroleestoque').AsInteger;

        Active := false;
        SQL.Clear;
        SQL.Add('INSERT INTO gescontroleestoque(idcontroleestoque,idproduto,idtipomovimentacao,');
        SQL.Add('idcliente,idloja,deletado,dataehora,entrada,saida,balanco,valor,observacao)');
        SQL.Add('VALUES(:idcontroleestoque,:idproduto,:idtipomovimentacao,');
        SQL.Add(':idcliente,:idloja,:deletado,:dataehora,:entrada,:saida,:balanco,:valor,:observacao)');
        ParamByName('idcontroleestoque').Value := idcontroleestoque;
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ParamByName('DELETADO').Value := 0;
        ParamByName('idproduto').Value := idproduto;
        ParamByName('idtipomovimentacao').Value := idtipomovimento;
        ParamByName('dataehora').Value := now;
        ParamByName('entrada').Value := entrada;
        ParamByName('saida').Value := saida;
        ParamByName('balanco').Value := balanco;
        ParamByName('valor').Value := valor;
        ParamByName('observacao').Value := observacao;
        ExecSQL;












        // adicionando o movimento no arquivo de log
        Active := false;
        sql.Clear;
        sql.add('update admponteiro set idlog = idlog+1 where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        execsql;
        close;
        sql.Clear;
        sql.add('select idlog from admponteiro where idcliente=:idcliente and idloja=:idloja ');
        ParamByName('idcliente').asinteger := idcliente;
        ParamByName('idloja').AsInteger := idloja;
        Open;
        id := fieldbyname('idlog').AsInteger;

        Active := false;
        sql.Clear;
        SQL.Add('INSERT INTO geslog(idlog,idusuario, descricao, data, hora, ');
        SQL.Add('IDCLIENTE,IDLOJA)');
        SQL.Add('       VALUES(:idlog,:idusuario, :descricao, :data, :hora,');
        SQL.Add(':IDCLIENTE,:IDLOJA)');
        ParamByName('idlog').AsInteger := id;
        ParamByName('idusuario').AsInteger := idusuario;
        ParamByName('descricao').Value := mensagem;
        ParamByName('data').Value := Date;
        ParamByName('hora').Value := time;
        ParamByName('IDCLIENTE').Value := idcliente;
        ParamByName('IDLOJA').Value := idloja;
        ExecSQL;
      end;
      FConn.Commit;
      //erro := '';
      Result := True;
    except
      on ex: exception do
      begin
        //erro := 'Erro ao consultar : ' + ex.Message;
        Result := False;
      end;
    end;
  finally
    qry.Free;
  end;
end;

end.


unit UtXMLcompraSAURUSpTABELA;

interface

uses
  FireDAC.Comp.Client, Data.DB, SysUtils, Classes, Xml.XmlDoc, Xml.XmlIntf,
  FireDAC.DApt, model.connection, System.Generics.Collections,  Xml.xmldom, MSXML;

type
  TXMLcompraSAURUSpTABELA = class
  private
    FConn: TFDConnection;
  public
    constructor Create;
    destructor Destroy; override;

    function ExtractDataFromXML(const XMLString: string): boolean;
  end;

implementation

constructor TXMLcompraSAURUSpTABELA.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TXMLcompraSAURUSpTABELA.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;


function TXMLcompraSAURUSpTABELA.ExtractDataFromXML(const XMLString: string): Boolean;
var
  XMLDoc: iXMLDocument;
  Node, MovDadosNode, MovProdNode: IXMLNode;
  qry: TFDQuery;
  codpedido: string;
  erro: string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    XMLDoc := TXMLDocument.Create(nil);
    XmlDoc.LoadFromFile('C:\trabalho\application');
    Node := XMLDoc.DocumentElement;
    try
      FConn.StartTransaction;
      with qry do
      begin
        if Assigned(Node) then
        begin
          MovDadosNode := Node.ChildNodes.FindNode('MovDados');
          while Assigned(MovDadosNode) do
          begin
            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO sauruscompra(mov_idMov,mov_tpMov,mov_dhEmi,mov_tpAmb,mov_natOp,mov_tpOp,');
            SQL.Add('emit_idLoja,mov_idCaixa,mov_nNf,mov_idOperador,dest_idCadastro,dest_doc,');
            SQL.Add('dest_xNome,mov_indStatus,tot_qCom,tot_qtdItens,tot_vNF');
            SQL.Add('                 values(:mov_idMov,:mov_tpMov,:mov_dhEmi,:mov_tpAmb,:mov_natOp,:mov_tpOp,');
            SQL.Add(':emit_idLoja,:mov_idCaixa,:mov_nNf,:mov_idOperador,:dest_idCadastro,:dest_doc,');
            SQL.Add(':dest_xNome,:mov_indStatus,:tot_qCom,:tot_qtdItens,:tot_vNF');
            ParamByName('mov_idMov').AsString := MovDadosNode.Attributes['mov_idMov'];
            ParamByName('mov_tpMov').AsString := MovDadosNode.Attributes['mov_tpMov'];
            ParamByName('mov_dhEmi').AsString := MovDadosNode.Attributes['mov_dhEmi'];
            ParamByName('mov_tpAmb').AsString := MovDadosNode.Attributes['mov_tpAmb'];
            ParamByName('mov_natOp').AsString := MovDadosNode.Attributes['mov_natOp'];
            ParamByName('mov_tpOp').AsString := MovDadosNode.Attributes['mov_tpOp'];
            ParamByName('emit_idLoja').AsString := MovDadosNode.Attributes['emit_idLoja'];
            ParamByName('mov_idCaixa').AsString := MovDadosNode.Attributes['mov_idCaixa'];
            ParamByName('mov_nNf').AsString := MovDadosNode.Attributes['mov_nNf'];
            ParamByName('mov_idOperador').AsString := MovDadosNode.Attributes['mov_idOperador'];
            ParamByName('dest_idCadastro').AsString := MovDadosNode.Attributes['dest_idCadastro'];
            ParamByName('dest_doc').AsString := MovDadosNode.Attributes['dest_doc'];
            ParamByName('dest_xNome').AsString := MovDadosNode.Attributes['dest_xNome'];
            ParamByName('mov_indStatus').AsString := MovDadosNode.Attributes['mov_indStatus'];
            ParamByName('tot_qCom').AsString := MovDadosNode.Attributes['dest_doc'];
            ParamByName('tot_qtdItens').AsString := MovDadosNode.Attributes['tot_qtdItens'];
            ParamByName('tot_vNF').AsString := MovDadosNode.Attributes['tot_vNF'];
            ExecSQL;
            codpedido := MovDadosNode.Attributes['mov_idMov'];
            MovProdNode := MovDadosNode.ChildNodes.FindNode('Produtos/MovProd');
            while Assigned(MovProdNode) do
            begin
              Active := false;
              sql.Clear;
              SQL.Add('INSERT INTO sauruscompraitens(prod_nItem,prod_idProd,prod_idProduto,prod_cProd,prod_xProd,');
              SQL.Add('prod_vUnCom,prod_cfop,prod_qCom,prod_uCom,prod_vDesc,prod_vOutro,');
              SQL.Add('prod_vProd,prod_infAdProd,prod_idVendedor,prod_loginVendedor,mov_idMov)');
              SQL.Add('                       values(:prod_nItem,:prod_idProd,:prod_idProduto,:prod_cProd,:prod_xProd,');
              SQL.Add(':prod_vUnCom,:prod_cfop,:prod_qCom,:prod_uCom,:prod_vDesc,:prod_vOutro,');
              SQL.Add(':prod_vProd,:prod_infAdProd,:prod_idVendedor,:prod_loginVendedor,:mov_idMov)');

              ParamByName('mov_idMov').AsString := codpedido;
              ParamByName('prod_nItem').AsString := MovProdNode.Attributes['prod_nItem'];
              ParamByName('prod_idProd').AsString := MovProdNode.Attributes['prod_idProd'];
              ParamByName('prod_idProduto').AsString := MovProdNode.Attributes['prod_idProduto'];
              ParamByName('prod_cProd').AsString := MovProdNode.Attributes['prod_cProd'];
              ParamByName('prod_xProd').AsString := MovProdNode.Attributes['prod_xProd'];
              ParamByName('prod_vUnCom').AsString := MovProdNode.Attributes['prod_vUnCom'];
              ParamByName('prod_cfop').AsString := MovProdNode.Attributes['prod_cfop'];
              ParamByName('prod_qCom').AsString := MovProdNode.Attributes['prod_qCom'];
              ParamByName('prod_uCom').AsString := MovProdNode.Attributes['prod_uCom'];
              ParamByName('prod_vDesc').AsString := MovProdNode.Attributes['prod_vDesc'];
              ParamByName('prod_vOutro').AsString := MovProdNode.Attributes['prod_vOutro'];
              ParamByName('prod_vProd').AsString := MovProdNode.Attributes['prod_vProd'];
              ParamByName('prod_infAdProd').AsString := MovProdNode.Attributes['prod_infAdProd'];
              ParamByName('prod_idVendedor').AsString := MovProdNode.Attributes['prod_idVendedor'];
              ParamByName('prod_loginVendedor').AsString := MovProdNode.Attributes['prod_loginVendedor'];
              ExecSQL;
              MovProdNode := MovProdNode.NextSibling;
            end;
            MovDadosNode := MovDadosNode.NextSibling;
          end;
        end;
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
    XMLDoc := nil;
  end;

end;

end.


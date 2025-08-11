unit Model.Huawei;

interface

uses
  FireDAC.Comp.Client, System.JSON, Data.DB, System.SysUtils, Model.connection,
  ComObj, System.DateUtils, System.StrUtils, FireDAC.DApt,
  System.Generics.Collections, UtFuncao;

type
  THuawei = class
  private
    FConn: TFDConnection;
    Fid: string;
    Fos: string;
    Fidcolaboradorpj: Integer;
    Fobservacaopj: string;
    Fpo: string;
    fvalornegociado: Double;
    Fporcentagempj: Double;
    Fdescricao: string;
    Fitemcode: string;
    Fsitename: string;
    Fsiteid: string;
    FbiddingArea: string;
    Fusuario: Integer;
    Fprojectno: string;
    Fregion: string;
    Fponumber: string;
    Fitemdescription: string;
    Fqty: Double;
    Fsitecode: string;
    FnegociadoSN: Integer;
    Fvo: string;

  public
    constructor Create;
    destructor Destroy; override;

    property id: string read Fid write Fid;
    property os: string read Fos write Fos;
    property idcolaboradorpj: Integer read Fidcolaboradorpj write Fidcolaboradorpj;
    property observacaopj: string read Fobservacaopj write Fobservacaopj;
    property po: string read Fpo write Fpo;
    property valornegociado: Double read Fvalornegociado write Fvalornegociado;
    property porcentagempj: Double read Fporcentagempj write Fporcentagempj;
    property descricao: string read Fdescricao write Fdescricao;
    property itemcode: string read Fitemcode write Fitemcode;
    property sitename: string read Fsitename write Fsitename;
    property siteid: string read Fsiteid write Fsiteid;
    property biddingArea: string read FbiddingArea write FbiddingArea;
    property usuario: Integer read Fusuario write Fusuario;
    property projectno: string read Fprojectno write Fprojectno;
    property region: string read Fregion write Fregion;
    property ponumber: string read Fponumber write Fponumber;
    property itemdescription: string read Fitemdescription write Fitemdescription;
    property qty: Double read Fqty write Fqty;
    property sitecode: string read Fsitecode write Fsitecode;
    property negociadoSN: Integer read FnegociadoSN write FnegociadoSN;
    property vo: string read Fvo write Fvo;

    function InserirHuawei(obj: TJSONObject; out erro: string): boolean;
    function Editar(out erro: string): Boolean;
    function ListarHuawei(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function Listapo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function PesquisarHuaweiPorObra(numeroObra: string; out erro: string): TFDQuery;
    function PesquisarHuaweiPorPrimaryKey(primaryKey: string; out erro: string): TFDQuery;
    function AtualizarHuawei(obj: TJSONObject; out erro: string): boolean;
    function Deletar(ID: Integer): boolean;
    function NovoCadastro(out erro: string): string;
    function Editaratividadepj(out erro: string): Boolean;
    function Listaacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
    function CriarTarefa(out erro: string): Boolean;
    function Rollouthuawei(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;

  end;

implementation

constructor THuawei.Create;
begin
  FConn := TConnection.CreateConnection;
end;

function THuawei.CriarTarefa(out erro: string): Boolean;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      with qry do
      begin
        Active := false;
        sql.Clear;
        SQL.Add('insert into projetohuawei(projectNo,sitecode,itemDescription,poNumber,deleteFlag,itemCode,quantity,quantityCancelled,  ');
        SQL.Add('sitename,siteid,unitPrice,biddingArea,os,creationDate,criadopor,cancelFlag,vo) ');
        SQL.Add('                   values(:projectNo,:sitecode,:itemDescription,:poNumber,:deleteFlag,:itemCode,:quantity,:quantityCancelled,  ');
        SQL.Add(':sitename,:siteid,:unitPrice,:biddingArea,:os,:creationDate,:criadopor,:cancelFlag,:vo)');
        ParamByName('itemDescription').asstring := itemdescription;
        ParamByName('poNumber').asstring := ponumber;
        ParamByName('deleteFlag').asstring := 'N';
        ParamByName('cancelFlag').asstring := 'N';
        ParamByName('itemCode').asstring := itemCode;
        ParamByName('quantity').AsFloat := qty;
        ParamByName('quantityCancelled').AsFloat := 0;
        ParamByName('sitename').asstring := sitename;
        ParamByName('siteid').asstring := siteid;
        ParamByName('unitPrice').AsFloat := 0;
        ParamByName('biddingArea').asstring := biddingArea;
        ParamByName('os').asstring := '--';
        ParamByName('creationDate').AsDateTime := Now;
        ParamByName('criadopor').AsInteger := usuario;
        ParamByName('projectNo').asstring := projectNo;
        ParamByName('sitecode').asstring := sitecode;
        ParamByName('vo').asstring := vo;
        ExecSQL;
      end;
      erro := '';
      FConn.Commit;
      result := true;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao salvar projeto Huawei: ' + ex.Message;
        Result := false;
      end;
    end;

  finally
    qry.Free;
  end;

end;

destructor THuawei.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function THuawei.Editar(out erro: string): Boolean;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    try
      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('UPDATE projetohuawei SET observacaogeral = :observacao ');
        SQL.Add('WHERE id = :id');

        ParamByName('id').AsString := id;
        ParamByName('observacao').AsString := observacaopj;

        ExecSQL;
      end;

      erro := '';
      FConn.Commit;
      Result := True;
    except
      on ex: Exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao atualizar observação: ' + ex.Message;
        Result := False;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function THuawei.Editaratividadepj(out erro: string): Boolean;
var
  qry, qry1, qry2: TFDQuery;
  id, demanda: Integer;
  valorlpu: Real;
  polocal, cliente, empresa, site: string;
begin
  try
    erro := '';
    qry := TFDQuery.Create(nil);
    qry.connection := FConn;
    try
      FConn.StartTransaction;
      with qry do
      begin
        active := false;
        SQL.Clear;
        SQL.Add('update projetohuawei set ');
        SQL.Add('os=:os,');
        SQL.Add('observacaopj=:observacaopj,');
        SQL.Add('idcolaboradorpj=:idcolaboradorpj,');
        if negociadoSN = 1 then
        begin
          SQL.Add('valorpj= :valornegociado*quantity,');
          SQL.Add('valorpjunit = :valornegociado,');
        end
        else
        begin
          SQL.Add('valorpj= (unitprice*(:porcentagempj*0.01))*quantity,');
          SQL.Add('valorpjunit = (unitprice*(:porcentagempj*0.01)),');
        end;
        SQL.Add('negociadoSN=:negociadoSN,');
        SQL.Add('porcentagempj=:porcentagempj,dataacionamento=:dataacionamento  ');
        SQL.Add('where id=:id ');
        ParamByName('idcolaboradorpj').AsInteger := idcolaboradorpj;
        ParamByName('observacaopj').AsString := observacaopj;
        ParamByName('os').Asstring := os;
        ParamByName('id').asstring := po;
        ParamByName('negociadoSN').AsInteger := negociadoSN;
        if negociadoSN = 1 then
        begin
          ParamByName('valornegociado').AsFloat := valornegociado;
          ParamByName('porcentagempj').AsFloat := 0;
        end
        else
          ParamByName('porcentagempj').AsFloat := porcentagempj;
        ParamByName('dataacionamento').AsDateTime := now;
        ExecSQL;

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
        erro := 'Erro ao fazer lançamento: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function THuawei.NovoCadastro(out erro: string): string;
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
        sql.add('update admponteiro set idhuaweios = idhuaweios+1 ');
        execsql;
        close;
        sql.Clear;
        sql.add('select idhuaweios from admponteiro ');
        Open;
        id := 'OS' + RetZero(fieldbyname('idhuaweios').Asstring, 6);
      end;
      FConn.Commit;
      erro := '';
      Result := id;
    except
      on ex: exception do
      begin
        FConn.Rollback;
        erro := 'Erro ao consultar : ' + ex.Message;
        Result := '0';
      end;
    end;
  finally
    qry.Free;
  end;
end;

function ParseISO8601DateTime(const ISO8601Str: string): TDateTime;
var
  DateTimeStr: string;
  Year, Month, Day, Hour, Minute, Second, Millisecond: Word;
begin
  // Extrair a parte da data e hora da string
  DateTimeStr := Copy(ISO8601Str, 1, Pos('T', ISO8601Str) - 1) + ' ' + Copy(ISO8601Str, Pos('T', ISO8601Str) + 1, 8);

  // Parse a string para TDateTime
  try
    Year := StrToInt(Copy(DateTimeStr, 1, 4));
    Month := StrToInt(Copy(DateTimeStr, 6, 2));
    Day := StrToInt(Copy(DateTimeStr, 9, 2));
    Hour := StrToInt(Copy(DateTimeStr, 12, 2));
    Minute := StrToInt(Copy(DateTimeStr, 15, 2));
    Second := StrToInt(Copy(DateTimeStr, 18, 2));
    Millisecond := 0;  // A parte dos milissegundos não está incluída aqui

    Result := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Minute, Second, Millisecond);
  except
    on E: Exception do
      raise Exception.Create('Erro ao converter a data/hora: ' + E.Message);
  end;
end;

function THuawei.InserirHuawei(obj: TJSONObject; out erro: string): boolean;
var
  qry: TFDQuery;
  value: Variant;
  parts: TArray<string>;
  responseDate: Variant;
  atualiza: integer;
  id:string;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;
    try
      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('SELECT * FROM ProjetoHuawei WHERE primaryKey = :primaryKey');
        ParamByName('primaryKey').AsString := obj.GetValue<string>('primaryKey');
        Open();
        id :=  obj.GetValue<string>('primaryKey');
        if RecordCount > 0 then
          atualiza := 1
        else
          atualiza := 0;
      end;
     // Verifica se já existe uma transação ativa
      if not FConn.InTransaction then
        FConn.StartTransaction;

      with qry do
      begin
        if atualiza = 0 then
        begin
          Active := False;
          SQL.Clear;
          SQL.Add('INSERT INTO ProjetoHuawei (poDistributionId,receivingRoutingId, itemDescription, itemId, vendorCode, itemDesc, ');
          SQL.Add('lastUpdateDate, poNumber, deleteFlag, shipmentNum, termsDescription, termsName, ');
          SQL.Add('billToLocationId, projectNo, invoiceFinishFlag, subcontractNo, priceOverride, deptCode, ');
          SQL.Add('vendorName, repOfficeName, sendConnecter, quantityCancelled, recvConnecter, ');
          SQL.Add('vendorId, publishDate, interfaceSourceCode, needByDate, agentEmployeeNumber, projectInfo, ');
          SQL.Add('receivedFinishFlag, recvVendorAddr, currencyCode, quantity, engInfoOffice, unitOfMeasure, ');
          SQL.Add('cancelFlag, itemCode, engInfoSalesContract,  quantityReceived, approvedDate, ');
          SQL.Add('startDate, closedCode, quantityBilled, engineeringNo, lineLocationId, issuOffice, authorizationStatus, ');
          SQL.Add('unitPrice, quantityAccepted, orgName, poSubType, manufactureSiteInfo, quantityRejected, ');
          SQL.Add('revisionNum, repOfficeCode, sendVendorTelNum, termsMode, engInfoEngineeringName, billToLocation, ');
          SQL.Add('shipToOrganizationId, sendVendorFax, biddingArea, prhaInterfaceSourceCode, promiseDate, sendPaymentTerms, ');
          SQL.Add('attachmentQty, shipmentStatus, poLineNum, poLineId, unitMeasLookupCode, poHeaderId, shipmentType, ');
          SQL.Add('pllaNoteToReceiver, orgCode, paymentTerms, termsId, agentName, taxRate, categoryId, sendVendorAddr, ');
          SQL.Add('businessMode, category, vendorSiteId, subProjectCode, orgId, shipToLocationId, creationDate, ');
          SQL.Add('instanceId, createdBy, poReleaseId, carrierName, fobLookupCode, primaryKey, acQty, ');
          SQL.Add('openTaskQuantity, taskQuantity, objectChangeContext, shipToLocation, shipToLocationCode, ');
          SQL.Add('taxRateText, isDeduct, bsOrgId, isJxSoftWare, isChinaArea, unitCode, shipToOrganizationCode, ');
          SQL.Add('isSwitchedHpo, supplierState, mpoPoHeaderId, localBpaReleaseFlag, purchaseType, prPoAutomated, ');
          SQL.Add('switchedHpo, canSplit, buySellPo,dueQty,sitecode,sitename,siteid,prnumber) ');
          SQL.Add('VALUES (:poDistributionId, :receivingRoutingId, :itemDescription, :itemId, :vendorCode, :itemDesc, :lastUpdateDate, :poNumber, :deleteFlag, ');
          SQL.Add(':shipmentNum, :termsDescription, :termsName,  :billToLocationId, :projectNo, ');
          SQL.Add(':invoiceFinishFlag, :subcontractNo, :priceOverride, :deptCode, :vendorName, ');
          SQL.Add(':repOfficeName, :sendConnecter, :quantityCancelled, :recvConnecter, :vendorId, :publishDate, ');
          SQL.Add(':interfaceSourceCode, :needByDate, :agentEmployeeNumber, :projectInfo, :receivedFinishFlag, ');
          SQL.Add(':recvVendorAddr, :currencyCode, :quantity, :engInfoOffice, :unitOfMeasure, :cancelFlag, :itemCode, ');
          SQL.Add(':engInfoSalesContract,  :quantityReceived, :approvedDate, :startDate, :closedCode, ');
          SQL.Add(':quantityBilled, :engineeringNo, :lineLocationId, :issuOffice, :authorizationStatus, :unitPrice, ');
          SQL.Add(':quantityAccepted, :orgName, :poSubType, :manufactureSiteInfo, :quantityRejected, ');
          SQL.Add(':revisionNum, :repOfficeCode, :sendVendorTelNum, :termsMode, :engInfoEngineeringName, :billToLocation, ');
          SQL.Add(':shipToOrganizationId, :sendVendorFax, :biddingArea, :prhaInterfaceSourceCode, :promiseDate, ');
          SQL.Add(':sendPaymentTerms, :attachmentQty, :shipmentStatus, :poLineNum, :poLineId, :unitMeasLookupCode, ');
          SQL.Add(':poHeaderId, :shipmentType, :pllaNoteToReceiver, :orgCode, :paymentTerms, :termsId, :agentName, ');
          SQL.Add(':taxRate, :categoryId, :sendVendorAddr, :businessMode, :category, :vendorSiteId, :subProjectCode, ');
          SQL.Add(':orgId, :shipToLocationId, :creationDate, :instanceId, :createdBy, :poReleaseId, :carrierName, ');
          SQL.Add(':fobLookupCode, :primaryKey, :acQty,  :openTaskQuantity, :taskQuantity, ');
          SQL.Add(':objectChangeContext, :shipToLocation, :shipToLocationCode, :taxRateText, :isDeduct, :bsOrgId, ');
          SQL.Add(':isJxSoftWare, :isChinaArea, :unitCode, :shipToOrganizationCode, :isSwitchedHpo, :supplierState, ');
          SQL.Add(':mpoPoHeaderId, :localBpaReleaseFlag, :purchaseType, :prPoAutomated, :switchedHpo, :canSplit, ');
          SQL.Add(':buySellPo, :dueQty,:sitecode,:sitename,:siteid,:prnumber)');
        end
        else
        begin
          Active := False;
          SQL.Clear;
          SQL.Add('update ProjetoHuawei set ');
          SQL.Add('poDistributionId=:poDistributionId, ');
          SQL.Add('receivingRoutingId=:receivingRoutingId, ');
          SQL.Add('itemDescription=:itemDescription, ');
          SQL.Add('itemId=:itemId, ');
          SQL.Add('vendorCode=:vendorCode, ');
          SQL.Add('itemDesc=:itemDesc, ');
          SQL.Add('lastUpdateDate=:lastUpdateDate, ');
          SQL.Add('poNumber=:poNumber, ');
          SQL.Add('deleteFlag=:deleteFlag, ');
          SQL.Add('shipmentNum=:shipmentNum, ');
          SQL.Add('termsDescription=:termsDescription, ');
          SQL.Add('termsName=:termsName, ');
          SQL.Add('billToLocationId=:billToLocationId, ');
          SQL.Add('projectNo=:projectNo, ');
          SQL.Add('invoiceFinishFlag=:invoiceFinishFlag, ');
          SQL.Add('subcontractNo=:subcontractNo, ');
          SQL.Add('priceOverride=:priceOverride, ');
          SQL.Add('deptCode=:deptCode,      ');
          SQL.Add('vendorName=:vendorName,    ');
          SQL.Add('repOfficeName=:repOfficeName,        ');
          SQL.Add('sendConnecter=:sendConnecter,        ');
          SQL.Add('quantityCancelled=:quantityCancelled,    ');
          SQL.Add('recvConnecter=:recvConnecter,        ');
          SQL.Add('vendorId=:vendorId,             ');
          SQL.Add('publishDate=:publishDate,          ');
          SQL.Add('interfaceSourceCode=:interfaceSourceCode,  ');
          SQL.Add('needByDate=:needByDate,           ');
          SQL.Add('agentEmployeeNumber=:agentEmployeeNumber,  ');
          SQL.Add('projectInfo=:projectInfo,          ');
          SQL.Add('receivedFinishFlag=:receivedFinishFlag,   ');
          SQL.Add('recvVendorAddr=:recvVendorAddr,       ');
          SQL.Add('currencyCode=:currencyCode,         ');
          SQL.Add('quantity=:quantity,             ');
          SQL.Add('engInfoOffice=:engInfoOffice,        ');
          SQL.Add('unitOfMeasure=:unitOfMeasure,        ');
          SQL.Add('cancelFlag=:cancelFlag,           ');
          SQL.Add('itemCode=:itemCode,             ');
          SQL.Add('engInfoSalesContract=:engInfoSalesContract, ');
          SQL.Add('quantityReceived=:quantityReceived,     ');
          SQL.Add('approvedDate=:approvedDate,         ');
          SQL.Add('startDate=:startDate,            ');
          SQL.Add('closedCode=:closedCode,           ');
          SQL.Add('quantityBilled=:quantityBilled,       ');
          SQL.Add('engineeringNo=:engineeringNo,        ');
          SQL.Add('lineLocationId=:lineLocationId,       ');
          SQL.Add('issuOffice=:issuOffice,           ');
          SQL.Add('authorizationStatus=:authorizationStatus,  ');
          SQL.Add('unitPrice=:unitPrice,            ');
          SQL.Add('quantityAccepted=:quantityAccepted,     ');
          SQL.Add('orgName=:orgName,              ');
          SQL.Add('poSubType=:poSubType,            ');
          SQL.Add('manufactureSiteInfo=:manufactureSiteInfo,  ');
          SQL.Add('quantityRejected=:quantityRejected,     ');
          SQL.Add('revisionNum=:revisionNum,           ');
          SQL.Add('repOfficeCode=:repOfficeCode,         ');
          SQL.Add('sendVendorTelNum=:sendVendorTelNum,      ');
          SQL.Add('termsMode=:termsMode,             ');
          SQL.Add('engInfoEngineeringName=:engInfoEngineeringName,');
          SQL.Add('billToLocation=:billToLocation,        ');
          SQL.Add('shipToOrganizationId=:shipToOrganizationId,  ');
          SQL.Add('sendVendorFax=:sendVendorFax,         ');
          SQL.Add('biddingArea=:biddingArea,           ');
          SQL.Add('prhaInterfaceSourceCode=:prhaInterfaceSourceCode,');
          SQL.Add('promiseDate=:promiseDate,            ');
          SQL.Add('sendPaymentTerms=:sendPaymentTerms,       ');
          SQL.Add('attachmentQty=:attachmentQty,          ');
          SQL.Add('shipmentStatus=:shipmentStatus,         ');
          SQL.Add('poLineNum=:poLineNum,              ');
          SQL.Add('poLineId=:poLineId,               ');
          SQL.Add('unitMeasLookupCode=:unitMeasLookupCode,     ');
          SQL.Add('poHeaderId=:poHeaderId,             ');
          SQL.Add('shipmentType=:shipmentType,           ');
          SQL.Add('pllaNoteToReceiver=:pllaNoteToReceiver,     ');
          SQL.Add('orgCode=:orgCode,                ');
          SQL.Add('paymentTerms=:paymentTerms,           ');
          SQL.Add('termsId=:termsId,                ');
          SQL.Add('agentName=:agentName,              ');
          SQL.Add('taxRate=:taxRate,                ');
          SQL.Add('categoryId=:categoryId,             ');
          SQL.Add('sendVendorAddr=:sendVendorAddr,         ');
          SQL.Add('businessMode=:businessMode,           ');
          SQL.Add('category=:category,               ');
          SQL.Add('vendorSiteId=:vendorSiteId,           ');
          SQL.Add('subProjectCode=:subProjectCode,         ');
          SQL.Add('orgId=:orgId,                  ');
          SQL.Add('shipToLocationId=:shipToLocationId,       ');
          SQL.Add('creationDate=:creationDate,           ');
          SQL.Add('instanceId=:instanceId,             ');
          SQL.Add('createdBy=:createdBy,              ');
          SQL.Add('poReleaseId=:poReleaseId,            ');
          SQL.Add('carrierName=:carrierName,            ');
          SQL.Add('fobLookupCode=:fobLookupCode,          ');
          SQL.Add('acQty=:acQty,                  ');
          SQL.Add('openTaskQuantity=:openTaskQuantity,       ');
          SQL.Add('taskQuantity=:taskQuantity,           ');
          SQL.Add('objectChangeContext=:objectChangeContext,    ');
          SQL.Add('shipToLocation=:shipToLocation,         ');
          SQL.Add('shipToLocationCode=:shipToLocationCode,     ');
          SQL.Add('taxRateText=:taxRateText,            ');
          SQL.Add('isDeduct=:isDeduct,               ');
          SQL.Add('bsOrgId=:bsOrgId,                ');
          SQL.Add('isJxSoftWare=:isJxSoftWare,           ');
          SQL.Add('isChinaArea=:isChinaArea,            ');
          SQL.Add('unitCode=:unitCode,               ');
          SQL.Add('shipToOrganizationCode=:shipToOrganizationCode, ');
          SQL.Add('isSwitchedHpo=:isSwitchedHpo,          ');
          SQL.Add('supplierState=:supplierState,          ');
          SQL.Add('mpoPoHeaderId=:mpoPoHeaderId,          ');
          SQL.Add('localBpaReleaseFlag=:localBpaReleaseFlag,    ');
          SQL.Add('purchaseType=:purchaseType,           ');
          SQL.Add('prPoAutomated=:prPoAutomated,          ');
          SQL.Add('switchedHpo=:switchedHpo,            ');
          SQL.Add('canSplit=:canSplit,               ');
          SQL.Add('buySellPo=:buySellPo,              ');
          SQL.Add('dueQty=:dueQty,                 ');
          SQL.Add('sitecode=:sitecode,               ');
          SQL.Add('sitename=:sitename,               ');
          SQL.Add('siteid=:siteid,                 ');
          SQL.Add('prnumber=:prnumber                ');
          SQL.Add('where primaryKey=:primaryKey    ');
         end;
        try
          ParamByName('receivingRoutingId').AsInteger := obj.GetValue<Integer>('receivingRoutingId');
        except
          ParamByName('receivingRoutingId').AsInteger := 0;
        end;
        try
          ParamByName('itemDescription').AsString := obj.GetValue<string>('itemDescription');
        except
          ParamByName('itemDescription').AsString := '';
        end;
        try
          ParamByName('itemId').AsInteger := obj.GetValue<Integer>('itemId');
        except
          ParamByName('itemId').AsInteger := 0;
        end;
        try
          ParamByName('vendorCode').AsString := obj.GetValue<string>('vendorCode');
        except
          ParamByName('vendorCode').AsString := '';
        end;
        try
          ParamByName('itemDesc').AsString := obj.GetValue<string>('itemDesc');
        except
          ParamByName('itemDesc').AsString := '';
        end;
        try
          ParamByName('poNumber').AsString := obj.GetValue<string>('poNumber');
        except
          ParamByName('poNumber').AsString := obj.GetValue<integer>('poNumber').ToString;
        end;
        try
          ParamByName('deleteFlag').AsString := obj.GetValue<string>('deleteFlag');
        except
          ParamByName('deleteFlag').AsString := '';
        end;
        try
          ParamByName('shipmentNum').AsInteger := obj.GetValue<Integer>('shipmentNum');
        except
          ParamByName('shipmentNum').AsInteger := 0;
        end;
        try
          ParamByName('termsDescription').AsString := obj.GetValue<string>('termsDescription');
        except
          ParamByName('termsDescription').AsString := '';
        end;
        try
          ParamByName('termsName').AsString := obj.GetValue<string>('termsName');
        except
          ParamByName('termsName').AsString := '';
        end;
        try
          ParamByName('poDistributionId').AsString := obj.GetValue<string>('poDistributionId');
        except
          ParamByName('poDistributionId').AsString := '';
        end;
        try
          ParamByName('billToLocationId').AsInteger := obj.GetValue<Integer>('billToLocationId');
        except
          ParamByName('billToLocationId').AsInteger := 0;
        end;
        try
          ParamByName('projectNo').AsString := obj.GetValue<string>('projectNo');
        except
          ParamByName('projectNo').AsString := '';
        end;
        try
          ParamByName('invoiceFinishFlag').AsString := obj.GetValue<string>('invoiceFinishFlag');
        except
          ParamByName('invoiceFinishFlag').AsString := '';
        end;
        try
          ParamByName('subcontractNo').AsString := obj.GetValue<string>('subcontractNo');
        except
          ParamByName('subcontractNo').AsString := '';
        end;
        try
          ParamByName('priceOverride').AsFloat := obj.GetValue<Currency>('priceOverride');
        except
          ParamByName('priceOverride').AsFloat := 0;
        end;
        try
          ParamByName('deptCode').AsString := obj.GetValue<string>('deptCode');
        except
          ParamByName('deptCode').AsString := '';
        end;
        try
          ParamByName('prNumber').AsString := obj.GetValue<string>('prNumber');
        except
          ParamByName('prNumber').AsString := '';
        end;

        try
          ParamByName('vendorName').AsString := obj.GetValue<string>('vendorName');
        except
          ParamByName('vendorName').AsString := '';
        end;
        try
          ParamByName('repOfficeName').AsString := obj.GetValue<string>('repOfficeName');
        except
          ParamByName('repOfficeName').AsString := '';
        end;
        try
          ParamByName('sendConnecter').AsString := obj.GetValue<string>('sendConnecter');
        except
          ParamByName('sendConnecter').AsString := '';
        end;
        try
          ParamByName('quantityCancelled').AsFloat := obj.GetValue<double>('quantityCancelled');
        except
          ParamByName('quantityCancelled').AsFloat := 0;
        end;
        try
          ParamByName('recvConnecter').AsString := obj.GetValue<string>('recvConnecter');
        except
          ParamByName('recvConnecter').AsString := '';
        end;
        try
          ParamByName('vendorId').AsInteger := obj.GetValue<Integer>('vendorId');
        except
          ParamByName('vendorId').AsInteger := 0;
        end;
        try
          ParamByName('publishDate').AsDateTime := obj.GetValue<TDateTime>('publishDate');
        except
          ParamByName('publishDate').asdate := strtodate('30/12/1899');
        end;
        try
          ParamByName('interfaceSourceCode').AsString := obj.GetValue<string>('interfaceSourceCode');
        except
          ParamByName('interfaceSourceCode').AsString := '';
        end;
        try
          ParamByName('needByDate').AsDateTime := obj.GetValue<TDateTime>('needByDate');
        except
          ParamByName('needByDate').asdate := strtodate('30/12/1899');
        end;
        try
          ParamByName('agentEmployeeNumber').AsString := obj.GetValue<string>('agentEmployeeNumber');
        except
          ParamByName('agentEmployeeNumber').AsString := '';
        end;
        try
          ParamByName('projectInfo').AsString := obj.GetValue<string>('projectInfo');
        except
          ParamByName('projectInfo').AsString := '';
        end;
        try
          ParamByName('receivedFinishFlag').AsString := obj.GetValue<string>('receivedFinishFlag');
        except
          ParamByName('receivedFinishFlag').AsString := '';
        end;
        try
          ParamByName('recvVendorAddr').AsString := obj.GetValue<string>('recvVendorAddr');
        except
          ParamByName('recvVendorAddr').AsString := '';
        end;
        try
          ParamByName('currencyCode').AsString := obj.GetValue<string>('currencyCode');
        except
          ParamByName('currencyCode').AsString := '';
        end;
        try
          ParamByName('quantity').AsFloat := obj.GetValue<Currency>('quantity');
        except
          ParamByName('quantity').AsFloat := 0;
        end;
        try
          ParamByName('engInfoOffice').AsString := obj.GetValue<string>('engInfoOffice');
        except
          ParamByName('engInfoOffice').AsString := '';
        end;
        try
          ParamByName('unitOfMeasure').AsString := obj.GetValue<string>('unitOfMeasure');
        except
          ParamByName('unitOfMeasure').AsString := '';
        end;
        try
          ParamByName('cancelFlag').AsString := obj.GetValue<string>('cancelFlag');
        except
          ParamByName('cancelFlag').AsString := '';
        end;
        try
          ParamByName('itemCode').AsString := obj.GetValue<string>('itemCode');
        except
          ParamByName('itemCode').AsString := '';
        end;
        try
          ParamByName('engInfoSalesContract').AsString := obj.GetValue<string>('engInfoSalesContract');
        except
          ParamByName('engInfoSalesContract').AsString := '';
        end;
//      responseDate := obj.GetValue<TDateTime>('responseDate');
//      responseDate := Copy(responseDateStr, 1, Length(responseDateStr) - 6);
//      qry.ParamByName('responseDate').AsDateTime := responseDate;      responseDate := obj.GetValue<TDateTime>('responseDate');
//      responseDate := Copy(responseDateStr, 1, Length(responseDateStr) - 6);
//      qry.ParamByName('responseDate').AsDateTime := responseDate;
        try
          ParamByName('quantityReceived').AsFloat := obj.GetValue<Currency>('quantityReceived');
        except
          ParamByName('quantityReceived').AsFloat := 0;
        end;

        try
          var response := ParseISO8601DateTime(obj.GetValue<string>('approvedDate'));
          ParamByName('approvedDate').AsDateTime := response;
        except
          ParamByName('approvedDate').asdate := strtodate('30/12/1899');
        end;
        try
          ParamByName('startDate').AsDateTime := obj.GetValue<TDateTime>('startDate');
        except
          ParamByName('startDate').asdate := strtodate('30/12/1899');
        end;
        try
          ParamByName('closedCode').AsString := obj.GetValue<string>('closedCode');
        except
          ParamByName('closedCode').AsString := '';
        end;
        try
          ParamByName('quantityBilled').AsFloat := obj.GetValue<Currency>('quantityBilled');
        except
          ParamByName('quantityBilled').AsFloat := 0;
        end;
        try
          ParamByName('engineeringNo').AsString := obj.GetValue<string>('engineeringNo');
        except
          ParamByName('engineeringNo').AsString := '';
        end;
//      ParamByName('firstPromiseDate').AsDateTime := obj.GetValue<TDateTime>('firstPromiseDate');
        try
          ParamByName('lineLocationId').AsString := obj.GetValue<string>('lineLocationId');
        except
          ParamByName('lineLocationId').AsString := '';
        end;
        try
          ParamByName('issuOffice').AsString := obj.GetValue<string>('issuOffice');
        except
          ParamByName('issuOffice').AsString := '';
        end;
        try
          ParamByName('authorizationStatus').AsString := obj.GetValue<string>('authorizationStatus');
        except
          ParamByName('authorizationStatus').AsString := '';
        end;
        try
          ParamByName('unitPrice').AsFloat := obj.GetValue<Currency>('unitPrice');
        except
          ParamByName('unitPrice').AsFloat := 0;
        end;
//    response := ParseISO8601DateTime(obj.GetValue<string>('openDate'));
//    qry.ParamByName('openDate').AsDateTime := response;
        try
          ParamByName('quantityAccepted').AsFloat := obj.GetValue<Currency>('quantityAccepted');
        except
          ParamByName('quantityAccepted').AsFloat := 0;
        end;
        try
          ParamByName('orgName').AsString := obj.GetValue<string>('orgName');
        except
          ParamByName('orgName').AsString := '';
        end;
        try
          ParamByName('poSubType').AsString := obj.GetValue<string>('poSubType');
        except
          ParamByName('poSubType').AsString := '';
        end;
        try
          ParamByName('manufactureSiteInfo').AsString := obj.GetValue<string>('manufactureSiteInfo');
          parts := SplitString(obj.GetValue<string>('manufactureSiteInfo'), '<!>');
          ParamByName('siteid').AsString := parts[0];
          ParamByName('sitecode').AsString := parts[3];
          ParamByName('sitename').AsString := parts[6];
        except
          ParamByName('manufactureSiteInfo').AsString := '';
          ParamByName('siteid').AsString := '';
          ParamByName('sitecode').AsString := '';
          ParamByName('sitename').AsString := '';
        end;
        try
          ParamByName('quantityRejected').AsInteger := obj.GetValue<Integer>('quantityRejected');
        except
          ParamByName('quantityRejected').AsInteger := 0;
        end;
        try
          ParamByName('revisionNum').AsInteger := obj.GetValue<Integer>('revisionNum');
        except
          ParamByName('revisionNum').AsInteger := 0;
        end;
        try
          ParamByName('repOfficeCode').AsString := obj.GetValue<string>('repOfficeCode');
        except
          ParamByName('repOfficeCode').AsString := '';
        end;
        try
          ParamByName('sendVendorTelNum').AsString := obj.GetValue<string>('sendVendorTelNum');
        except
          ParamByName('sendVendorTelNum').AsString := '';
        end;
        try
          ParamByName('termsMode').AsString := obj.GetValue<string>('termsMode');
        except
          ParamByName('termsMode').AsString := '';
        end;
        try
          ParamByName('engInfoEngineeringName').AsString := obj.GetValue<string>('engInfoEngineeringName');
        except
          ParamByName('engInfoEngineeringName').AsString := '';
        end;
        try
          ParamByName('billToLocation').AsString := obj.GetValue<string>('billToLocation');
        except
          ParamByName('billToLocation').AsString := '';
        end;
        try
          ParamByName('shipToOrganizationId').AsInteger := obj.GetValue<Integer>('shipToOrganizationId');
        except
          ParamByName('shipToOrganizationId').AsInteger := 0;
        end;
        try
          ParamByName('sendVendorFax').AsString := obj.GetValue<string>('sendVendorFax');
        except
          ParamByName('sendVendorFax').AsString := '';
        end;
        try
          ParamByName('biddingArea').AsString := obj.GetValue<string>('biddingArea');
        except
          ParamByName('biddingArea').AsString := '';
        end;
        try
          ParamByName('prhaInterfaceSourceCode').AsString := obj.GetValue<string>('prhaInterfaceSourceCode');
        except
          ParamByName('prhaInterfaceSourceCode').AsString := '';
        end;
        try
          var response := ParseISO8601DateTime(obj.GetValue<string>('promiseDate'));
          ParamByName('promiseDate').AsDateTime := response;
        except
          ParamByName('promiseDate').asdate := strtodate('30/12/1899');
        end;
        try
          ParamByName('sendPaymentTerms').AsString := obj.GetValue<string>('sendPaymentTerms');
        except
          ParamByName('sendPaymentTerms').AsString := '';
        end;
        try
          ParamByName('attachmentQty').AsFloat := obj.GetValue<Currency>('attachmentQty');
        except
          ParamByName('attachmentQty').AsFloat := 0;
        end;
        try
          ParamByName('shipmentStatus').AsString := obj.GetValue<string>('shipmentStatus');
        except
          ParamByName('shipmentStatus').AsString := '';
        end;
        try
          ParamByName('poLineNum').AsInteger := obj.GetValue<Integer>('poLineNum');
        except
          ParamByName('poLineNum').AsInteger := 0;
        end;
        try
          ParamByName('poLineId').AsString := obj.GetValue<string>('poLineId');
        except
          ParamByName('poLineId').AsString := '';
        end;
        try
          ParamByName('unitMeasLookupCode').AsString := obj.GetValue<string>('unitMeasLookupCode');
        except
          ParamByName('unitMeasLookupCode').AsString := '';
        end;
        try
          ParamByName('poHeaderId').AsString := obj.GetValue<string>('poHeaderId');
        except
          ParamByName('poHeaderId').AsString := '';
        end;
        try
          ParamByName('shipmentType').AsString := obj.GetValue<string>('shipmentType');
        except
          ParamByName('shipmentType').AsString := '';
        end;
        try
          ParamByName('pllaNoteToReceiver').AsString := obj.GetValue<string>('pllaNoteToReceiver');
        except
          ParamByName('pllaNoteToReceiver').AsString := '';
        end;
        try
          ParamByName('orgCode').AsString := obj.GetValue<string>('orgCode');
        except
          ParamByName('orgCode').AsString := '';
        end;
        try
          ParamByName('paymentTerms').AsString := obj.GetValue<string>('paymentTerms');
        except
          ParamByName('paymentTerms').AsString := '';
        end;
        try
          ParamByName('termsId').AsInteger := obj.GetValue<Integer>('termsId');
        except
          ParamByName('termsId').AsInteger := 0;
        end;
        try
          ParamByName('agentName').AsString := obj.GetValue<string>('agentName');
        except
          ParamByName('agentName').AsString := '';
        end;

        try
          ParamByName('taxRate').AsFloat := obj.GetValue<Currency>('taxRate');
        except
          ParamByName('taxRate').AsFloat := 0;
        end;
        try
          ParamByName('categoryId').AsInteger := obj.GetValue<Integer>('categoryId');
        except
          ParamByName('categoryId').AsInteger := 0;
        end;
        try
          ParamByName('sendVendorAddr').AsString := obj.GetValue<string>('sendVendorAddr');
        except
          ParamByName('sendVendorAddr').AsString := '';
        end;
        try
          ParamByName('businessMode').AsString := obj.GetValue<string>('businessMode');
        except
          ParamByName('businessMode').AsString := '';
        end;
        try
          ParamByName('category').AsString := obj.GetValue<string>('category');
        except
          ParamByName('category').AsString := '';
        end;
        try
          ParamByName('vendorSiteId').AsInteger := obj.GetValue<Integer>('vendorSiteId');
        except
          ParamByName('vendorSiteId').AsInteger := 0;
        end;
        try
          ParamByName('subProjectCode').AsString := obj.GetValue<string>('subProjectCode');
        except
          ParamByName('subProjectCode').AsString := '';
        end;
        try
          ParamByName('orgId').AsInteger := obj.GetValue<Integer>('orgId');
        except
          ParamByName('orgId').AsInteger := 0;
        end;
        try
          ParamByName('shipToLocationId').AsString := obj.GetValue<string>('shipToLocationId');
        except
          ParamByName('shipToLocationId').AsString := '';
        end;
        try
          var response := ParseISO8601DateTime(obj.GetValue<string>('creationDate'));
          ParamByName('creationDate').AsDateTime := response;
        except
          ParamByName('creationDate').asdate := strtodate('30/12/1899');
        end;
        try
          ParamByName('instanceId').AsInteger := obj.GetValue<Integer>('instanceId');
        except
          ParamByName('instanceId').AsInteger := 0;
        end;
        try
          ParamByName('createdBy').AsInteger := obj.GetValue<Integer>('createdBy');
        except
          ParamByName('createdBy').AsInteger := 0;
        end;
        try
          ParamByName('poReleaseId').AsInteger := obj.GetValue<Integer>('poReleaseId');
        except
          ParamByName('poReleaseId').AsInteger := 0;
        end;
        ParamByName('carrierName').AsString := ''; //obj.GetValue<string>('carrierName');
        try
          var response := ParseISO8601DateTime(obj.GetValue<string>('lastUpdateDate'));
          ParamByName('lastUpdateDate').AsDateTime := response;
        except
          ParamByName('lastUpdateDate').asdate := strtodate('30/12/1899');
        end;
        try
          ParamByName('fobLookupCode').AsString := obj.GetValue<string>('fobLookupCode');
        except
          ParamByName('fobLookupCode').AsString := '';
        end;
        try
          ParamByName('primaryKey').AsString := obj.GetValue<string>('primaryKey');
        except
          ParamByName('primaryKey').AsString := '';
        end;
        try
          ParamByName('acQty').AsFloat := obj.GetValue<Double>('acQty');
        except
          ParamByName('acQty').AsInteger := 0;
        end;
        try
          ParamByName('dueQty').AsString := obj.GetValue<string>('dueQty');
        except
          ParamByName('dueQty').AsString := '';
        end;
        try
          ParamByName('openTaskQuantity').AsInteger := obj.GetValue<Integer>('openTaskQuantity');
        except
          ParamByName('openTaskQuantity').AsInteger := 0;
        end;
        try
          ParamByName('taskQuantity').AsInteger := obj.GetValue<Integer>('taskQuantity');
        except
          ParamByName('taskQuantity').AsInteger := 0;
        end;
        try
          ParamByName('objectChangeContext').AsString := obj.GetValue<string>('objectChangeContext');
        except
          ParamByName('objectChangeContext').AsString := '';
        end;
        try
          ParamByName('shipToLocation').AsString := obj.GetValue<string>('shipToLocation');
        except
          ParamByName('shipToLocation').AsString := '';
        end;
        try
          ParamByName('shipToLocationCode').AsString := obj.GetValue<string>('shipToLocationCode');
        except
          ParamByName('shipToLocationCode').AsString := '';
        end;

        try
          ParamByName('taxRateText').AsString := obj.GetValue<string>('taxRateText');
        except
          ParamByName('taxRateText').AsString := '';
        end;
        try
          ParamByName('isDeduct').AsString := obj.GetValue<string>('isDeduct');
        except
          ParamByName('isDeduct').AsString := '';
        end;
        try
          ParamByName('bsOrgId').AsString := obj.GetValue<string>('bsOrgId');
        except
          ParamByName('bsOrgId').AsString := '';
        end;

        try
          ParamByName('isJxSoftWare').AsString := obj.GetValue<string>('isJxSoftWare');
        except
          ParamByName('isJxSoftWare').AsString := '';
        end;
        try
          ParamByName('isChinaArea').AsString := obj.GetValue<string>('isChinaArea');
        except
          ParamByName('isChinaArea').AsString := '';
        end;
        try
          ParamByName('unitCode').AsString := obj.GetValue<string>('unitCode');
        except
          ParamByName('unitCode').AsString := '';
        end;
        try
          ParamByName('shipToOrganizationCode').AsString := obj.GetValue<string>('shipToOrganizationCode');
        except
          ParamByName('shipToOrganizationCode').AsString := '';
        end;
        try
          ParamByName('isSwitchedHpo').AsBoolean := obj.GetValue<Boolean>('isSwitchedHpo');
        except
          ParamByName('isSwitchedHpo').AsBoolean := false;
        end;
        try
          ParamByName('supplierState').AsString := obj.GetValue<string>('supplierState');
        except
          ParamByName('supplierState').AsString := '';
        end;
        try
          ParamByName('mpoPoHeaderId').AsString := obj.GetValue<string>('mpoPoHeaderId');
        except
          ParamByName('mpoPoHeaderId').AsString := '';
        end;
        ParamByName('localBpaReleaseFlag').AsString := 'N';
        try
          ParamByName('purchaseType').AsString := obj.GetValue<string>('purchaseType');
        except
          ParamByName('purchaseType').AsString := '';
        end;
        try
          ParamByName('prPoAutomated').AsBoolean := obj.GetValue<Boolean>('prPoAutomated');
        except
          ParamByName('prPoAutomated').AsBoolean := False;
        end;
        try
          ParamByName('switchedHpo').AsBoolean := obj.GetValue<Boolean>('switchedHpo');
        except
          ParamByName('switchedHpo').AsBoolean := False;
        end;
        try
          ParamByName('canSplit').AsBoolean := obj.GetValue<Boolean>('canSplit');
        except
          ParamByName('canSplit').AsBoolean := False;
        end;
        try
          ParamByName('buySellPo').AsBoolean := obj.GetValue<Boolean>('buySellPo');
        except
          ParamByName('buySellPo').AsBoolean := False;
        end;
        ExecSQL;
      end;

      // Confirma a transação
     // if FConn.InTransaction then
      FConn.Commit;

      erro := '';
      Result := True;
    except
      on ex: Exception do
      begin
        // Realiza rollback caso ocorra um erro
        if FConn.InTransaction then
          FConn.Rollback;

        erro := 'Erro ao migrar: ' + ex.Message;
        Writeln(erro);
        Result := False;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function THuawei.Lista(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('projetohuawei.siteid, ');
      SQL.Add('projetohuawei.id, ');
      SQL.Add('projetohuawei.projectNo, ');
      SQL.Add('projetohuawei.sitecode, ');
      SQL.Add('projetohuawei.sitename, ');
      SQL.Add('projetohuawei.subcontractNo, ');
      SQL.Add('projetohuawei.prNumber, ');
      SQL.Add('projetohuawei.os, ');
      SQL.Add('Count(projetohuawei.id) As itens ');
      SQL.Add('From ');
      SQL.Add('projetohuawei ');
      SQL.Add('Where ');
      SQL.Add('projetohuawei.id Is Not Null ');
      if AQuery.ContainsKey('busca') then
      begin
        if Length(AQuery.Items['busca']) > 0 then
        begin
          SQL.Add('AND ((projetohuawei.siteid like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (projetohuawei.projectNo like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (projetohuawei.sitecode like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (projetohuawei.sitename like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (projetohuawei.subcontractNo like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (projetohuawei.os like ''%' + AQuery.Items['busca'] + '%'') ');
          SQL.Add('or  (projetohuawei.prNumber like ''%' + AQuery.Items['busca'] + '%'') ) ');
        end;
      end;
      SQL.Add('Group By ');
      SQL.Add('projetohuawei.siteid, ');
      SQL.Add('projetohuawei.os ');
      SQL.Add('Order By ');
      SQL.Add('projetohuawei.id Desc ');
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

function THuawei.Listaacionamento(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('projetohuawei.id,  ');
      SQL.Add('projetohuawei.idh,  ');
      SQL.Add('projetohuawei.poNumber,  ');
      SQL.Add('projetohuawei.itemCode,  ');
      SQL.Add('projetohuawei.itemDescription,  ');
      SQL.Add('projetohuawei.dataacionamento,  ');
      SQL.Add('projetohuawei.dataenvioemail,  ');
      SQL.Add('projetohuawei.idcolaboradorpj,  ');
      SQL.Add('gesempresas.nome  ');
      SQL.Add('From  ');
      SQL.Add('projetohuawei Inner Join  ');
      SQL.Add('gesempresas On gesempresas.idempresa = projetohuawei.idcolaboradorpj  where projetohuawei.os=:os  ');
      ParamByName('os').asstring := AQuery.Items['pros'];
      a := AQuery.Items['pros'];
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

function THuawei.Listapo(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('projetohuawei.id, ');
      SQL.Add('projetohuawei.primaryKey, ');
      SQL.Add('projetohuawei.itemId, ');
      SQL.Add('projetohuawei.itemDescription, ');
      SQL.Add('projetohuawei.itemCode, ');
      SQL.Add('projetohuawei.poNumber, ');
      SQL.Add('projetohuawei.quantity, ');
      SQL.Add('projetohuawei.unitOfMeasure, ');
      SQL.Add('projetohuawei.dueQty, ');
      SQL.Add('projetohuawei.cancelFlag, ');
      SQL.Add('projetohuawei.quantityCancelled ');
      SQL.Add('From ');
      SQL.Add('projetohuawei ');
      SQL.Add('Where ');
      SQL.Add('projetohuawei.sitename = :sn And os = ''--'' order by projetohuawei.itemCode ');
      a := AQuery.Items['sn1'];
      ParamByName('sn').asstring := AQuery.Items['sn1'];
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

function THuawei.Listaid(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
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
      SQL.Add('Select * ');
      SQL.Add('From ');
      SQL.Add('projetohuawei ');
      SQL.Add(' WHERE projetohuawei.id is not null and siteid=:siteid limit 1 ');
      ParamByName('siteid').asstring := AQuery.Items['siteid'];
      a := AQuery.Items['siteid'];
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

function THuawei.ListarHuawei(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  erro := ''; // Inicialize o erro como uma string vazia

  qry := TFDQuery.Create(nil); // Crie o objeto TFDQuery
  try
    qry.Connection := FConn; // Defina a conexão do TFDQuery

        // Construa a consulta SQL base
    if AQuery.ContainsKey('agrupado') then
    begin
      // Consulta para agrupamento
      qry.SQL.Text := 'SELECT manufactureSiteInfo, COUNT(*) AS occurrences FROM ProjetoHuawei';

      // Adiciona condições de busca após a seleção e antes de agrupar
      if AQuery.ContainsKey('busca') and (Length(AQuery.Items['busca']) > 0) then
      begin
        qry.SQL.Add(' WHERE (manufactureSiteInfo LIKE :busca ' + 'OR poNumber LIKE :busca ' + 'OR subProjectCode LIKE :busca)');
        qry.ParamByName('busca').AsString := '%' + AQuery.Items['busca'] + '%';
      end;

      qry.SQL.Add(' GROUP BY manufactureSiteInfo');
    end
    else
    begin
      // Consulta sem agrupamento
      qry.SQL.Text := 'SELECT * FROM ProjetoHuawei WHERE 1 = 1';

      // Adiciona condições de busca
      if AQuery.ContainsKey('busca') and (Length(AQuery.Items['busca']) > 0) then
      begin
        qry.SQL.Add(' AND (manufactureSiteInfo LIKE :busca ' + 'OR poNumber LIKE :busca ' + 'OR subProjectCode LIKE :busca)');
        qry.ParamByName('busca').AsString := '%' + AQuery.Items['busca'] + '%';
      end;
    end;

    // Adiciona ordenação
    qry.SQL.Add(' ORDER BY poNumber DESC');

    qry.Open; // Execute a consulta

    Result := qry; // Retorne o objeto TFDQuery
  except
    on ex: Exception do
    begin
      erro := 'Erro ao listar registros: ' + ex.Message; // Atribua a mensagem de erro
      qry.Free; // Libere o objeto TFDQuery se ocorrer um erro
      Result := nil; // Defina o resultado como nil em caso de erro
    end;
  end;
end;

function THuawei.PesquisarHuaweiPorObra(numeroObra: string; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.connection := FConn;
  with qry do
  begin
    try
      qry.SQL.Text := 'SELECT * FROM ProjetoHuawei WHERE projectNo = :projectNo';
      qry.ParamByName('projectNo').AsString := numeroObra;
      qry.Open;
      erro := '';
      Result := qry;
    except
      on E: Exception do
      begin
        erro := 'Erro ao pesquisar pelo número da obra: ' + E.Message;
        qry.Free;
        Result := nil;
      end;
    end;
  end;
end;

function THuawei.PesquisarHuaweiPorPrimaryKey(primaryKey: string; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  Result := nil; // Inicializa o resultado como nil, caso ocorra algum erro.
  erro := '';
  try
  // Cria a query e atribui a conexão
    qry := TFDQuery.Create(nil);
    try
      qry.Connection := FConn; // Conexão definida para o componente de consulta

      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('SELECT * FROM ProjetoHuawei WHERE primaryKey = :primaryKey');
        ParamByName('primaryKey').AsString := '-1'; //primaryKey;

      // Executa a consulta
        Open();

      // Se a consulta foi bem-sucedida, atribui qry ao resultado.
        Result := qry;
      end;
    except
      on E: Exception do
      begin
      // Em caso de erro, define a mensagem de erro e garante a liberação da query.
        erro := 'Erro ao pesquisar pelo número da obra: ' + E.Message;
      end;
    end;
  finally
    //FreeAndNil(qry); // Libera a query em caso de exceção
  // Verifica se Result ainda é nil, o que significa que houve erro, então libera `qry`
    if Result = nil then
      qry.Free;
  end;

  // Nota: o chamador da função deve liberar o `TFDQuery` retornado, se bem-sucedido.

{  qry := TFDQuery.Create(nil);
  qry.connection := FConn;
  with qry do
  begin
    try
      Active := False;
      SQL.Clear;
      SQL.Add('SELECT * FROM ProjetoHuawei WHERE primaryKey = :primaryKey');
      ParamByName('primaryKey').AsString := primaryKey;
      Open();
      erro := '';
      Result := qry;
    except
      on E: Exception do
      begin
        erro := 'Erro ao pesquisar pelo número da obra: ' + E.Message;
        qry.Free;
        Result := nil;
      end;
    end;
  end;  }
end;

function THuawei.AtualizarHuawei(obj: TJSONObject; out erro: string): boolean;
var
  qry: TFDQuery;
begin
  Result := False;
  erro := '';
  qry := TFDQuery.Create(nil);
  try

    try
      with qry do
      begin
        SQL.Clear;
        SQL.Add('UPDATE ProjetoHuawei SET');
        SQL.Add('itemDescription = :itemDescription,');
        SQL.Add('itemDesc = :itemDesc,');
        SQL.Add('vendorCode = :vendorCode,');
        SQL.Add('poNumber = :poNumber,');
        SQL.Add('deleteFlag = :deleteFlag,');
        SQL.Add('shipmentNum = :shipmentNum,');
        SQL.Add('termsDescription = :termsDescription,');
        SQL.Add('termsName = :termsName,');
        SQL.Add('poDistributionId = :poDistributionId,');
        SQL.Add('billToLocationId = :billToLocationId,');
        SQL.Add('projectNo = :projectNo,');
        SQL.Add('invoiceFinishFlag = :invoiceFinishFlag,');
        SQL.Add('subcontractNo = :subcontractNo,');
        SQL.Add('priceOverride = :priceOverride,');
        SQL.Add('deptCode = :deptCode,');
        SQL.Add('vendorName = :vendorName,');
        SQL.Add('repOfficeName = :repOfficeName,');
        SQL.Add('sendConnecter = :sendConnecter,');
        SQL.Add('quantityCancelled = :quantityCancelled,');
        SQL.Add('recvConnecter = :recvConnecter,');
        SQL.Add('vendorId = :vendorId,');
        SQL.Add('publishDate = :publishDate,');
        SQL.Add('interfaceSourceCode = :interfaceSourceCode,');
        SQL.Add('needByDate = :needByDate,');
        SQL.Add('agentEmployeeNumber = :agentEmployeeNumber,');
        SQL.Add('projectInfo = :projectInfo,');
        SQL.Add('receivedFinishFlag = :receivedFinishFlag,');
        SQL.Add('recvVendorAddr = :recvVendorAddr,');
        SQL.Add('currencyCode = :currencyCode,');
        SQL.Add('quantity = :quantity,');
        SQL.Add('unitOfMeasure = :unitOfMeasure,');
        SQL.Add('cancelFlag = :cancelFlag,');
        SQL.Add('itemCode = :itemCode,');
        SQL.Add('engInfoSalesContract = :engInfoSalesContract,');
        SQL.Add('responseDate = :responseDate,');
        SQL.Add('quantityReceived = :quantityReceived,');
        SQL.Add('approvedDate = :approvedDate,');
        SQL.Add('startDate = :startDate,');
        SQL.Add('closedCode = :closedCode,');
        SQL.Add('quantityBilled = :quantityBilled,');
        SQL.Add('engineeringNo = :engineeringNo,');
        SQL.Add('lineLocationId = :lineLocationId,');
        SQL.Add('issuOffice = :issuOffice,');
        SQL.Add('authorizationStatus = :authorizationStatus,');
        SQL.Add('unitPrice = :unitPrice,');
        SQL.Add('quantityAccepted = :quantityAccepted,');
        SQL.Add('orgName = :orgName,');
        SQL.Add('poSubType = :poSubType,');
        SQL.Add('manufactureSiteInfo = :manufactureSiteInfo,');
        SQL.Add('quantityRejected = :quantityRejected,');
        SQL.Add('revisionNum = :revisionNum,');
        SQL.Add('repOfficeCode = :repOfficeCode,');
        SQL.Add('sendVendorTelNum = :sendVendorTelNum,');
        SQL.Add('termsMode = :termsMode,');
        SQL.Add('engInfoEngineeringName = :engInfoEngineeringName,');
        SQL.Add('billToLocation = :billToLocation,');
        SQL.Add('shipToOrganizationId = :shipToOrganizationId,');
        SQL.Add('sendVendorFax = :sendVendorFax,');
        SQL.Add('biddingArea = :biddingArea,');
        SQL.Add('prhaInterfaceSourceCode = :prhaInterfaceSourceCode,');
        SQL.Add('promiseDate = :promiseDate,');
        SQL.Add('sendPaymentTerms = :sendPaymentTerms,');
        SQL.Add('attachmentQty = :attachmentQty,');
        SQL.Add('shipmentStatus = :shipmentStatus,');
        SQL.Add('poLineNum = :poLineNum,');
        SQL.Add('poLineId = :poLineId,');
        SQL.Add('unitMeasLookupCode = :unitMeasLookupCode,');
        SQL.Add('poHeaderId = :poHeaderId,');
        SQL.Add('shipmentType = :shipmentType,');
        SQL.Add('pllaNoteToReceiver = :pllaNoteToReceiver,');
        SQL.Add('orgCode = :orgCode,');
        SQL.Add('paymentTerms = :paymentTerms,');
        SQL.Add('termsId = :termsId,');
        SQL.Add('agentName = :agentName,');
        SQL.Add('taxRate = :taxRate,');
        SQL.Add('categoryId = :categoryId,');
        SQL.Add('businessMode = :businessMode,');
        SQL.Add('category = :category,');
        SQL.Add('vendorSiteId = :vendorSiteId,');
        SQL.Add('subProjectCode = :subProjectCode,');
        SQL.Add('orgId = :orgId,');
        SQL.Add('shipToLocationId = :shipToLocationId,');
        SQL.Add('creationDate = :creationDate,');
        SQL.Add('instanceId = :instanceId,');
        SQL.Add('createdBy = :createdBy,');
        SQL.Add('poReleaseId = :poReleaseId,');
        SQL.Add('carrierName = :carrierName,');
        SQL.Add('lastUpdateDate = :lastUpdateDate,');
        SQL.Add('fobLookupCode = :fobLookupCode,');
        SQL.Add('primaryKey = :primaryKey,');
        SQL.Add('acQty = :acQty,');
        SQL.Add('dueQty = :dueQty,');
        SQL.Add('openTaskQuantity = :openTaskQuantity,');
        SQL.Add('taskQuantity = :taskQuantity,');
        SQL.Add('objectChangeContext = :objectChangeContext,');
        SQL.Add('shipToLocation = :shipToLocation,');
        SQL.Add('shipToLocationCode = :shipToLocationCode,');
        SQL.Add('taxRateText = :taxRateText,');
        SQL.Add('isDeduct = :isDeduct,');
        SQL.Add('bsOrgId = :bsOrgId,');
        SQL.Add('isJxSoftWare = :isJxSoftWare,');
        SQL.Add('isChinaArea = :isChinaArea,');
        SQL.Add('unitCode = :unitCode,');
        SQL.Add('shipToOrganizationCode = :shipToOrganizationCode,');
        SQL.Add('isSwitchedHpo = :isSwitchedHpo,');
        SQL.Add('closedCodeLine = :closedCodeLine,');
        SQL.Add('cancelFlagLine = :cancelFlagLine,');
        SQL.Add('quantityLine = :quantityLine,');
        SQL.Add('switchedHpo = :switchedHpo,');
        SQL.Add('canSplit = :canSplit,');
        SQL.Add('buySellPo = :buySellPo');
        SQL.Add('WHERE poLineId = :poLineId');

        // Definindo todos os parâmetros
        ParamByName('itemDescription').AsString := obj.GetValue('itemDescription', '');
        ParamByName('itemDesc').AsString := obj.GetValue('itemDesc', '');
        ParamByName('vendorCode').AsString := obj.GetValue('vendorCode', '');
        ParamByName('poNumber').AsString := obj.GetValue('poNumber', '');
        ParamByName('deleteFlag').AsString := obj.GetValue('deleteFlag', '');
        ParamByName('shipmentNum').AsString := obj.GetValue('shipmentNum', '');
        ParamByName('termsDescription').AsString := obj.GetValue('termsDescription', '');
        ParamByName('termsName').AsString := obj.GetValue('termsName', '');
        ParamByName('poDistributionId').AsString := obj.GetValue('poDistributionId', '');
        ParamByName('billToLocationId').AsInteger := obj.GetValue('billToLocationId', 0);
        ParamByName('projectNo').AsString := obj.GetValue('projectNo', '');
        ParamByName('invoiceFinishFlag').AsString := obj.GetValue('invoiceFinishFlag', '');
        ParamByName('subcontractNo').AsString := obj.GetValue('subcontractNo', '');
        ParamByName('priceOverride').AsCurrency := obj.GetValue('priceOverride', 0.0);
        ParamByName('deptCode').AsString := obj.GetValue('deptCode', '');
        ParamByName('vendorName').AsString := obj.GetValue('vendorName', '');
        ParamByName('repOfficeName').AsString := obj.GetValue('repOfficeName', '');
        ParamByName('sendConnecter').AsString := obj.GetValue('sendConnecter', '');
        ParamByName('quantityCancelled').AsInteger := obj.GetValue('quantityCancelled', 0);
        ParamByName('recvConnecter').AsString := obj.GetValue('recvConnecter', '');
        ParamByName('vendorId').AsInteger := obj.GetValue('vendorId', 0);
        ParamByName('publishDate').AsDateTime := obj.GetValue('publishDate', 0.0);
        ParamByName('interfaceSourceCode').AsString := obj.GetValue('interfaceSourceCode', '');
        ParamByName('needByDate').AsDateTime := obj.GetValue('needByDate', 0.0);
        ParamByName('agentEmployeeNumber').AsString := obj.GetValue('agentEmployeeNumber', '');
        ParamByName('projectInfo').AsString := obj.GetValue('projectInfo', '');
        ParamByName('receivedFinishFlag').AsString := obj.GetValue('receivedFinishFlag', '');
        ParamByName('recvVendorAddr').AsString := obj.GetValue('recvVendorAddr', '');
        ParamByName('currencyCode').AsString := obj.GetValue('currencyCode', '');
        ParamByName('quantity').AsInteger := obj.GetValue('quantity', 0);
        ParamByName('unitOfMeasure').AsString := obj.GetValue('unitOfMeasure', '');
        ParamByName('cancelFlag').AsString := obj.GetValue('cancelFlag', '');
        ParamByName('itemCode').AsString := obj.GetValue('itemCode', '');
        ParamByName('engInfoSalesContract').AsString := obj.GetValue('engInfoSalesContract', '');
        ParamByName('responseDate').AsDateTime := obj.GetValue('responseDate', 0.0);
        ParamByName('quantityReceived').AsInteger := obj.GetValue('quantityReceived', 0);
        ParamByName('approvedDate').AsDateTime := obj.GetValue('approvedDate', 0.0);
        ParamByName('startDate').AsDateTime := obj.GetValue('startDate', 0.0);
        ParamByName('closedCode').AsString := obj.GetValue('closedCode', '');
        ParamByName('quantityBilled').AsInteger := obj.GetValue('quantityBilled', 0);

        ParamByName('engineeringNo').AsString := obj.GetValue('engineeringNo', '');
        ParamByName('lineLocationId').AsInteger := obj.GetValue('lineLocationId', 0);
        ParamByName('issuOffice').AsString := obj.GetValue('issuOffice', '');
        ParamByName('authorizationStatus').AsString := obj.GetValue('authorizationStatus', '');
        ParamByName('unitPrice').AsCurrency := obj.GetValue('unitPrice', 0.0);
        ParamByName('quantityAccepted').AsInteger := obj.GetValue('quantityAccepted', 0);
        ParamByName('orgName').AsString := obj.GetValue('orgName', '');
        ParamByName('poSubType').AsString := obj.GetValue('poSubType', '');
        ParamByName('manufactureSiteInfo').AsString := obj.GetValue('manufactureSiteInfo', '');
        ParamByName('quantityRejected').AsInteger := obj.GetValue('quantityRejected', 0);
        ParamByName('revisionNum').AsInteger := obj.GetValue('revisionNum', 0);
        ParamByName('repOfficeCode').AsString := obj.GetValue('repOfficeCode', '');
        ParamByName('sendVendorTelNum').AsString := obj.GetValue('sendVendorTelNum', '');
        ParamByName('termsMode').AsString := obj.GetValue('termsMode', '');
        ParamByName('engInfoEngineeringName').AsString := obj.GetValue('engInfoEngineeringName', '');
        ParamByName('billToLocation').AsString := obj.GetValue('billToLocation', '');
        ParamByName('shipToOrganizationId').AsInteger := obj.GetValue('shipToOrganizationId', 0);
        ParamByName('sendVendorFax').AsString := obj.GetValue('sendVendorFax', '');
        ParamByName('biddingArea').AsString := obj.GetValue('biddingArea', '');
        ParamByName('prhaInterfaceSourceCode').AsString := obj.GetValue('prhaInterfaceSourceCode', '');
        ParamByName('promiseDate').AsDateTime := obj.GetValue('promiseDate', 0.0);
        ParamByName('sendPaymentTerms').AsString := obj.GetValue('sendPaymentTerms', '');
        ParamByName('attachmentQty').AsInteger := obj.GetValue('attachmentQty', 0);
        ParamByName('shipmentStatus').AsString := obj.GetValue('shipmentStatus', '');
        ParamByName('poLineNum').AsInteger := obj.GetValue('poLineNum', 0);
        ParamByName('poLineId').AsInteger := obj.GetValue('poLineId', 0);
        ParamByName('unitMeasLookupCode').AsString := obj.GetValue('unitMeasLookupCode', '');
        ParamByName('poHeaderId').AsString := obj.GetValue('poHeaderId', '');
        ParamByName('shipmentType').AsString := obj.GetValue('shipmentType', '');
        ParamByName('pllaNoteToReceiver').AsString := obj.GetValue('pllaNoteToReceiver', '');
        ParamByName('orgCode').AsString := obj.GetValue('orgCode', '');
        ParamByName('paymentTerms').AsString := obj.GetValue('paymentTerms', '');
        ParamByName('termsId').AsInteger := obj.GetValue('termsId', 0);
        ParamByName('agentName').AsString := obj.GetValue('agentName', '');
        ParamByName('taxRate').AsFloat := obj.GetValue('taxRate', 0.0);
        ParamByName('categoryId').AsInteger := obj.GetValue('categoryId', 0);
        ParamByName('businessMode').AsString := obj.GetValue('businessMode', '');
        ParamByName('category').AsString := obj.GetValue('category', '');
        ParamByName('vendorSiteId').AsInteger := obj.GetValue('vendorSiteId', 0);
        ParamByName('subProjectCode').AsString := obj.GetValue('subProjectCode', '');
        ParamByName('orgId').AsInteger := obj.GetValue('orgId', 0);
        ParamByName('shipToLocationId').AsString := obj.GetValue('shipToLocationId', '');
        ParamByName('creationDate').AsDateTime := obj.GetValue('creationDate', 0.0);
        ParamByName('instanceId').AsInteger := obj.GetValue('instanceId', 0);
        ParamByName('createdBy').AsString := obj.GetValue('createdBy', '');
        ParamByName('poReleaseId').AsInteger := obj.GetValue('poReleaseId', 0);
        ParamByName('carrierName').AsString := obj.GetValue('carrierName', '');
        ParamByName('lastUpdateDate').AsDateTime := obj.GetValue('lastUpdateDate', 0.0);
        ParamByName('fobLookupCode').AsString := obj.GetValue('fobLookupCode', '');
        ParamByName('primaryKey').AsString := obj.GetValue('primaryKey', '');
        ParamByName('acQty').AsInteger := obj.GetValue('acQty', 0);
        ParamByName('dueQty').AsInteger := obj.GetValue('dueQty', 0);
        ParamByName('openTaskQuantity').AsInteger := obj.GetValue('openTaskQuantity', 0);
        ParamByName('taskQuantity').AsInteger := obj.GetValue('taskQuantity', 0);
        ParamByName('objectChangeContext').AsString := obj.GetValue('objectChangeContext', '');
        ParamByName('shipToLocation').AsString := obj.GetValue('shipToLocation', '');
        ParamByName('shipToLocationCode').AsString := obj.GetValue('shipToLocationCode', '');
        ParamByName('taxRateText').AsString := obj.GetValue('taxRateText', '');
        ParamByName('isDeduct').AsBoolean := obj.GetValue('isDeduct', False);
        ParamByName('bsOrgId').AsInteger := obj.GetValue('bsOrgId', 0);
        ParamByName('isJxSoftWare').AsBoolean := obj.GetValue('isJxSoftWare', False);
        ParamByName('isChinaArea').AsBoolean := obj.GetValue('isChinaArea', False);
        ParamByName('unitCode').AsString := obj.GetValue('unitCode', '');
        ParamByName('shipToOrganizationCode').AsString := obj.GetValue('shipToOrganizationCode', '');
        ParamByName('isSwitchedHpo').AsBoolean := obj.GetValue('isSwitchedHpo', False);
        ParamByName('closedCodeLine').AsString := obj.GetValue('closedCodeLine', '');
        ParamByName('cancelFlagLine').AsString := obj.GetValue('cancelFlagLine', '');
        ParamByName('quantityLine').AsInteger := obj.GetValue('quantityLine', 0);
        ParamByName('switchedHpo').AsString := obj.GetValue('switchedHpo', '');
        ParamByName('canSplit').AsBoolean := obj.GetValue('canSplit', False);
        ParamByName('buySellPo').AsString := obj.GetValue('buySellPo', '');

        ExecSQL;
      end;
      Result := True; // Sucesso
    except
      on E: Exception do
      begin
        erro := 'Erro ao atualizar a tabela Huawei: ' + E.Message;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function THuawei.Deletar(ID: Integer): boolean;
var
  FDQuery: TFDQuery;
begin
  Result := False;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.connection := FConn;
    FDQuery.SQL.Text := 'DELETE FROM ProjetoHuawei WHERE id = :id';
    FDQuery.Params.ParamByName('id').AsInteger := ID;
    try
      FDQuery.ExecSQL;
      Result := FDQuery.RowsAffected > 0;
      // Verifica se algum registro foi afetado
    except
      on E: Exception do
        raise Exception.Create('Erro ao deletar o registro: ' + E.Message);
    end;
  finally
    FDQuery.Free;
  end;
end;

function Thuawei.Rollouthuawei(const AQuery: TDictionary<string, string>; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  qry := nil;
  try
    if not Assigned(FConn) then
      raise Exception.Create('Conexão não inicializada');

    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    with qry do
    begin
      SQL.Text := 'SELECT * FROM obraericsson';
      Open;

      if RecordCount = 0 then
        erro := 'Nenhum registro ativo encontrado';
    end;

    Result := qry;
  except
    on ex: Exception do
    begin
      erro := 'Erro na consulta: ' + ex.Message;
      FreeAndNil(qry);
      Result := nil;
    end;
  end;
end;

end.


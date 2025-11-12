import { useState, useEffect } from 'react';
import { Box } from '@mui/material';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  GridActionsCellItem,
  useGridSelector,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import { Card, CardBody, CardTitle, Button, Input, InputGroup } from 'reactstrap';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import EditIcon from '@mui/icons-material/Edit';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import api from '../../services/api';
import HuaweiEdicao from '../../components/formulario/projeto/HuaweiEdicao';
import exportExcel from '../../data/exportexcel/Excelexport';
import Notpermission from '../../layouts/notpermission/notpermission';

const Projehuawei = () => {
  const [projeto, setprojeto] = useState([]);
  const [pageSize, setPageSize] = useState(10);
  const [loading, setloading] = useState(false);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [site, setsite] = useState('');
  const [permission, setpermission] = useState(0);

  console.log(setprojeto);
  console.log(setloading);

  const params = {
    busca: pesqgeral,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
    agrupado: true
  };

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado.</div>
      </GridOverlay>
    );
  }

  function CustomPagination() {
    const apiRef = useGridApiContext();
    const page = useGridSelector(apiRef, gridPageSelector);
    const pageCount = useGridSelector(apiRef, gridPageCountSelector);

    return (
      <Pagination
        color="primary"
        count={pageCount}
        page={page + 1}
        onChange={(event, value1) => apiRef.current.setPage(value1 - 1)}
      />
    );
  }

  const lista = async () => {
    setmensagemsucesso('');
    try {
      setloading(true);
      api.get('v1/projetohuawei', { params }).then((response) => {
        setprojeto(response.data);
        setpesqgeral('');
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  function alterarUser(stat) {
    settelacadastroedicao(true);
    setididentificador(stat);
    setsite(stat);
    lista();
  }
  function userpermission() {
    // const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    // setpermission(permissionstorage.ericacionamento === 1);
    setpermission(true);
  }

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          onClick={() => alterarUser(parametros.id)}
        />,
      ],
    },
    // {
    //   field: 'numero',
    //   headerName: 'Número',
    //   width: 200,
    //   align: 'left',
    //   editable: false,
    // },
    // {
    //   field: 'subProjectCode',
    //   headerName: 'Project Code',
    //   width: 120,
    //   align: 'left',
    //   editable: false,
    // },
    {
      field: 'siteCode',
      headerName: 'Site Code',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'siteName',
      headerName: 'Site Name',
      width: 320,
      align: 'left',
      editable: false,
    },
    {
      field: 'siteId',
      headerName: 'Site ID',
      width: 150,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },    
    // {
    //   field: 'poNumber',
    //   headerName: 'PO NO',
    //   width: 160,
    //   align: 'left',
    //   editable: false,
    //   renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    // },
    // {
    //   field: 'itemCode',
    //   headerName: 'Item Code',
    //   width: 120,
    //   align: 'left',
    //   editable: false,
    //   renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    // },
    // {
    //   field: 'itemDescription',
    //   headerName: 'Item Description',
    //   width: 600,
    //   align: 'left',
    //   editable: false,
    //   renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    // },
  ];


  const iniciatabelas = () => {
   // lista();
  };

  const gerarexcel = () => {
    const excelData = projeto.map((item) => {
      return {
        "ID": item.number,  // Assuming "ID" corresponds to "itemId" from JSON
        "Change History": item.objectChangeContext,
        "Rep Office": item.repOfficeName,
        "Project Code": item.projectNo,
        "Site Code": item.siteCode,
        "Site Name": item.siteName,
        "Site ID": item.siteId,
        "Sub Contract NO.": item.subcontractNo,
        "PR NO.": item.engInfoSalesContract, 
        "PO NO.": item.poNumber,
        "PO Line NO.": item.poLineNum,
        "Shipment NO.": item.shipmentNum,
        "Item Code": item.itemCode,
        "Item Description": item.itemDescription,
        "Item Description(Local)": item.itemDesc,
        "Unit Price": item.unitPrice,
        "Requested Qty": item.quantity,
        "Valor Telequipe": item.priceOverride,
        "Valor Equipe": item.priceOverride, // Same field used as placeholder; adjust as needed
        "Billed Quantity": item.quantityBilled,
        "Quantity Cancel": item.quantityCancelled,
        "Due Qty": item.dueQty,
        "Note to Receiver": item.pllaNoteToReceiver,
        "Fob Lookup Code": item.fobLookupCode,
        "Acceptance Date": item.receivedFinishFlag, // Assuming "Acceptance Date" corresponds to "receivedFinishFlag" for example
        "PR/PO Automation Solution (Only China)": item.projectInfo // Assuming this as a placeholder
      };
    });
    exportExcel({ excelData, fileName: 'projeto_huawei' });
  };
  
  const getRowId = (row) => row.siteCode;

  useEffect(() => {
    iniciatabelas();
    userpermission();
  }, []);
  return (
    <div>
       {permission && ( 
        <Card>
          <CardBody className="bg-light">
            <CardTitle tag="h4" className="mb-0">
              Obras Huawei Acionamento
            </CardTitle>
          </CardBody>
          <CardBody style={{ backgroundColor: 'white' }}>
            {mensagem.length !== 0 ? (
              <div className="alert alert-danger mt-2" role="alert">
                {mensagem}
              </div>
            ) : null}
            {mensagemsucesso.length > 0 ? (
              <div className="alert alert-success" role="alert">
                {' '}
                {mensagemsucesso}
              </div>
            ) : null}
            {telacadastroedicao ? (
              <>
                {' '}
                <HuaweiEdicao
                  show={telacadastroedicao}
                  setshow={settelacadastroedicao}
                  ididentificador={ididentificador}
                  atualiza={lista}
                  idsite={site}
                />{' '}
              </>
            ) : null}

            <div className="row g-3">
              {/*  <div className="col-sm-1">
              RFP
              <Input type="select" placeholder="Pesquise por Numero da Obra" >
                <option>2022</option>
                <option>2020</option>
              </Input>
             </div>  */}

              <div className="col-sm-6">
                Pesquisa
                <InputGroup>
                  <Input
                    type="text"
                    onChange={(e) => setpesqgeral(e.target.value)}
                    value={pesqgeral}
                    placeholder="Pesquise"
                  ></Input>
                  <Button color="primary" onClick={lista}>
                    {' '}
                    <SearchIcon />
                  </Button>
                  <Button color="primary" onClick={lista}>
                    {' '}
                    <AutorenewIcon />
                  </Button>
                </InputGroup>
              </div>
            </div>
          </CardBody>
          <CardBody style={{ backgroundColor: 'white' }}>
            <Button color="link" onClick={() => gerarexcel()}>
              {' '}
              Exportar Excel
            </Button>
            <Box sx={{ height: projeto.length > 0 ? '100%' : 500, width: '100%' }}>
              <DataGrid
                rows={projeto}
                columns={columns}
                loading={loading}
                pageSize={pageSize}
                onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                disableSelectionOnClick
                experimentalFeatures={{ newEditingApi: true }}
                getRowId={getRowId}
                components={{
                  Pagination: CustomPagination,
                  LoadingOverlay: LinearProgress,
                  NoRowsOverlay: CustomNoRowsOverlay,
                }}
                //opções traduzidas da tabela
                localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
              />
            </Box>
          </CardBody>
        </Card>
      )}
      {!permission && <Notpermission />} 
    </div>
  );
};

export default Projehuawei;
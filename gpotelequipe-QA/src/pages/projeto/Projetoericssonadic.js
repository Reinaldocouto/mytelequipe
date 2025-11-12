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
import Ericssonedicaoadic from '../../components/formulario/projeto/Ericssonedicaoadic';
import exportExcel from '../../data/exportexcel/Excelexport';
import Notpermission from '../../layouts/notpermission/notpermission';

const Projetoericssonadic = () => {
  const [projeto, setprojeto] = useState([]);
  const [pageSize, setPageSize] = useState(10);
  const [loading, setloading] = useState(false);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [permission, setpermission] = useState(0);

  console.log(setprojeto);
  console.log(setloading);

  const params = {
    busca: pesqgeral,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
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
    try {
      setloading(true);
      await api.get('v1/projetoericssonadic', { params }).then((response) => {
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
  }
  function userpermission() {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(permissionstorage.ericadicional === 1);
  }

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 120,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          onClick={() => alterarUser(parametros.id)}
        />,
      ],
    },
    // { field: 'id', headerName: 'ID', width: 80, align: 'left', },
    {
      field: 'po',
      headerName: 'PO',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'poritem',
      headerName: 'PO ITEM',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'datacriacaopo',
      headerName: 'DATA CRIAÇÃO PO',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'siteid',
      headerName: 'SIGLA',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'codigoservico',
      headerName: 'CODIGO SERVIÇO',
      width: 220,
      align: 'left',
      editable: false,
    },
    {
      field: 'descricaoservico',
      headerName: 'DESCRIÇÃO',
      width: 500,
      align: 'left',
      editable: false,
    },
  ];
  const gerarexcel = () => {
    const excelData = projeto.map((item) => {
      console.log(item);
      return {
        PO: item.po,
        'PO ITEM': item.poritem,
        'DATA CRIAÇÃO PO': item.datacriacaopo,
        SIGLA: item.siteid,
        'CÓDIGO SERVIÇO': item.codigoservico,
        DESCRIÇÃO: item.descricaoservico,
      };
    });
    exportExcel({ excelData, fileName: 'projeto' });
  };
  const iniciatabelas = () => {
    //lista();
  };

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
              Obras Ericsson - Item sem ID
            </CardTitle>
          </CardBody>
          <CardBody style={{ backgroundColor: 'white' }}>
            {mensagem.length !== 0 ? (
              <div className="alert alert-danger mt-2" role="alert">
                {mensagem}
              </div>
            ) : null}
            {telacadastroedicao ? (
              <>
                {' '}
                <Ericssonedicaoadic
                  show={telacadastroedicao}
                  setshow={settelacadastroedicao}
                  ididentificador={ididentificador}
                  atualiza={lista}
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
                    placeholder="Pesquise por Numero da Obra"
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

export default Projetoericssonadic;

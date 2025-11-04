import { useState, useEffect } from 'react';
import { Box } from '@mui/material';
import {
  DataGrid,
  gridPageCountSelector,
  GridActionsCellItem,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import PropTypes from 'prop-types';
import {
  Modal,
  ModalHeader,
  ModalBody,
  Card,
  CardBody,
  Button,
  Input,
  InputGroup,
} from 'reactstrap';
import Pagination from '@mui/material/Pagination';
import Typography from '@mui/material/Typography';
import LinearProgress from '@mui/material/LinearProgress';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import modoVisualizador from '../../../services/modovisualizador';
import api from '../../../services/api';
import exportExcel from '../../../data/exportexcel/Excelexport';
//import Notpermission from '../../layouts/notpermission/notpermission';

const Telefonicaconsolidado = ({ setshow, show }) => {
  const [projeto, setprojeto] = useState([]);
  //const [pageSize, setPageSize] = useState(10);
  const [paginationModel, setPaginationModel] = useState({ pageSize: 10, page: 0 });
  const [loading, setloading] = useState(false);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [arquivoobra, setarquivoobra] = useState('');

  const togglecadastro = () => {
    setshow(!show);
  };

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
    const rowCount = apiRef.current.getRowsCount(); // Obtém total de itens
    return (
      <Box
        sx={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          width: '100%',
          padding: '10px',
        }}
      >
        {/* Texto com total de itens alinhado à esquerda */}
        <Typography variant="body2">Total de itens: {rowCount}</Typography>

        {/* Componente de paginação alinhado à direita */}
        <Pagination
          color="primary"
          count={pageCount}
          page={page + 1}
          onChange={(event, value1) => apiRef.current.setPage(value1 - 1)}
        />
      </Box>
    );
  }

  const uploadarquivo = async (e) => {
    e.preventDefault();

    if (!arquivoobra) {
      setmensagem('Nenhum arquivo selecionado para atualizar!');
      return;
    }

    const formData = new FormData();
    formData.append('files', arquivoobra);

    const header = {
      headers: {
        'Custom-Header': 'value',
      },
    };
    try {
      setloading(true);
      const response = await api.post('v1/upload/telefonica/consolidado', formData, header);
      if (response && response.data) {
        console.log(response);
        if (response.status === 200) {
          setmensagemsucesso(
            'Upload concluido, aguarde a atualização que dura em torno de 20 minutos',
          );
          setmensagem('');
        } else {
          setmensagemsucesso('');
          setmensagem('Erro ao fazer upload!');
        }
      } else {
        throw new Error('Resposta inválida do servidor');
      }
    } catch (err) {
      if (err.response) {
        setmensagem(err.message);
        setmensagemsucesso('');
      } else {
        setmensagem('Erro: Tente novamente mais tarde!');
        setmensagemsucesso('');
      }
    } finally {
      setloading(false);
    }
  };

  const lista = async () => {
    setmensagemsucesso('');
    try {
      setloading(true);
      await api.get('v1/projetotelefonica/consolidado', { params }).then((response) => {
        setprojeto(response.data);
        console.log(response.data);
        setpesqgeral('');
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  /* function userpermission() {
       const permissionstorage = JSON.parse(localStorage.getItem('permission'));
       setpermission(permissionstorage.ericsson === 1);
     } */

  function deleteconsolidado(stat) {
    // settelaexclusaosolicitacao(true);
    // setidentificadorsolicitacao(stat);
    console.log(stat);
  }
  function alterarconsolidado(stat) {
    //settelacadastroedicaosolicitacao(true);
    //setidentificadorsolicitacao(stat);
    console.log(stat);
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
          title="Alterar"
          onClick={() => alterarconsolidado(parametros.id)}
        />,
        <GridActionsCellItem
          icon={<DeleteIcon />}
          label="Delete"
          title="Delete"
          onClick={() => deleteconsolidado(parametros.id)}
        />,
      ],
    },

    // { field: 'id', headerName: 'ID', width: 80, align: 'left', },
    /*  {
            field: 'rfp',
            headerName: 'RFP > Nome',
            width: 180,
            align: 'left',
            editable: false,
          }, */
    {
      field: 'idtlqp',
      headerName: 'CÓD. ID TLQP',
      width: 250,
      align: 'left',
      editable: false,
    },
    {
      field: 'linha',
      headerName: 'LINHA',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'site',
      headerName: 'SITE',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'numerodocontrato',
      headerName: 'NUMERO DO CONTRATO',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 't2codmatservsw',
      headerName: 'T2 - COD MAT_SERV_SW',
      width: 250,
      align: 'left',
      editable: false,
    },
    {
      field: 't2descricaocod',
      headerName: 'T2 - DESCRIÇÃO COD',
      width: 500,
      align: 'left',
      editable: false,
    },
    {
      field: 'regiao',
      headerName: 'REGIÃO',
      width: 80,
      align: 'left',
      editable: false,
    },
    {
      field: 'atividade',
      headerName: 'ATIVIDADE',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'codservico',
      headerName: 'CÓD. SERV.',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'cidade',
      headerName: 'CIDADE',
      width: 300,
      align: 'left',
      editable: false,
    },
    {
      field: 'uf',
      headerName: 'UF',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'qtd',
      headerName: 'QTD',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'statust2',
      headerName: 'STATUS T2',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'data',
      headerName: 'DATA',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'reqaprovt2',
      headerName: 'REQ. APROV T2',
      width: 250,
      align: 'left',
      editable: false,
    },
    {
      field: 'idpmts',
      headerName: 'ID PMTS',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'idt2cpom',
      headerName: 'ID T2 (CPOM)',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'idobra',
      headerName: 'ID. OBRA',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'pepnivel3',
      headerName: 'PEP NÍVEL 3',
      width: 300,
      align: 'left',
      editable: false,
    },
    {
      field: 'statust4',
      headerName: 'STATUS T4',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'datat4',
      headerName: 'DATA T4',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'po',
      headerName: 'PO',
      width: 200,
      align: 'left',
      editable: false,
    },
    {
      field: 'cartataf',
      headerName: 'CARTA TAF',
      width: 200,
      align: 'left',
      editable: false,
    },
    {
      field: 'dataenvio',
      headerName: 'DATA ENVIO',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'autcpomgestor',
      headerName: 'AUT. CPOM GESTOR',
      width: 200,
      align: 'left',
      editable: false,
    },
    {
      field: 'statusfinan',
      headerName: 'STATUS FINAN.',
      width: 200,
      align: 'left',
      editable: false,
    },
    {
      field: 'nf',
      headerName: 'NF',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'pagto',
      headerName: 'PAGTO',
      width: 300,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'obs',
      headerName: 'OBS.',
      width: 600,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
  ];

  const iniciatabelas = () => {
    // setPageSize(10);
    // lista();
  };

  const gerarexcel = () => {
    const excelData = projeto.map((item) => {
      return {
        OS: item.os,
        PO: item.po,
        REGION: item.region,
        REGINONAL: item.regiaobr,
        STATE: item.state,
        SITEID: item.siteid,
        'SITENAME(DE)': item.sitename,
        'SITENAME(PARA)': item.sitenamefrom,
      };
    });
    exportExcel({ excelData, fileName: 'projeto ZTE' });
  };

  useEffect(() => {
    iniciatabelas();
  }, []);

  return (
    <Modal
      isOpen={show}
      toggle={togglecadastro.bind(null)}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-fullscreen modal-dialog-scrollable modal-fullscreen "
    >
      <ModalHeader toggle={togglecadastro.bind(null)} style={{ backgroundColor: 'white' }}>
        Consolidado - Telefônica
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white', padding: '0px' }}>
        <div>
          <Card>
            <CardBody style={{ backgroundColor: 'white', marginBottom: '-35px' }}>
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

              <div className="row g-3">
                <div className="col-sm-6">
                  Pesquisa
                  <InputGroup>
                    <Input
                      type="text"
                      onChange={(e) => setpesqgeral(e.target.value)}
                      value={pesqgeral}
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

                <div className="col-sm-6">
                  Selecione o arquivo de atualização
                  <div className="d-flex flex-row-reverse custom-file">
                    <InputGroup>
                      <Input
                        type="file"
                        onChange={(e) => setarquivoobra(e.target.files[0])}
                        className="custom-file-input"
                        id="customFile3"
                        disabled={modoVisualizador()}
                      />
                      <Button color="primary" onClick={uploadarquivo} disabled={modoVisualizador()}>
                        Atualizar{' '}
                      </Button>
                    </InputGroup>
                  </div>
                </div>
              </div>
            </CardBody>
            <CardBody style={{ backgroundColor: 'white' }}>
              <Button color="link" onClick={() => gerarexcel()}>
                Exportar Excel
              </Button>
              <Box sx={{ height: projeto.length > 0 ? '100%' : 500, width: '100%' }}>
                <DataGrid
                  rows={projeto}
                  columns={columns}
                  loading={loading}
                  disableSelectionOnClick
                  experimentalFeatures={{ newEditingApi: true }}
                  components={{
                    Pagination: CustomPagination,
                    LoadingOverlay: LinearProgress,
                    NoRowsOverlay: CustomNoRowsOverlay,
                  }}
                  localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                  // Usa estado para controlar a paginação dinamicamente
                  paginationModel={paginationModel}
                  onPaginationModelChange={setPaginationModel}
                />
              </Box>
            </CardBody>
          </Card>
        </div>
      </ModalBody>
    </Modal>
  );
};

Telefonicaconsolidado.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Telefonicaconsolidado;

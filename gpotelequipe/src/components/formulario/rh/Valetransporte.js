import { useState, useEffect } from 'react';
import {
  Button,
  Label,
  Input,
  InputGroup,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
} from 'reactstrap';
import { Box } from '@mui/material';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import PropTypes from 'prop-types';
import Pagination from '@mui/material/Pagination';
import { toast, ToastContainer } from 'react-toastify';
import LinearProgress from '@mui/material/LinearProgress';
import modoVisualizador from '../../../services/modovisualizador';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';

//import exportExcel from '../../../data/exportexcel/Excelexport';

const Ticket = ({ setshow, show }) => {
  const [pageSize, setPageSize] = useState(100);
  const [loading, setLoading] = useState(false);
  const [ticket, setticket] = useState([]);
  const [mensagem, setmensagem] = useState('');
  const [arquivoanexo, setarquivoanexo] = useState('');
  const [retanexo, setretanexo] = useState('');
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const listaticket = async () => {
    try {
      setLoading(true);
      await api.get('v1/rh/valetransporte', { params }).then((response) => {
        setticket(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  const columns = [
    {
      field: 'codigo',
      headerName: 'Código',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'nome',
      headerName: 'Colaborador',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'projeto',
      headerName: 'Projeto',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'valordia',
      headerName: 'Valor Dia',
      width: 120,
      align: 'right',
      type: 'number',
      editable: false,
      valueFormatter: (paramscolumn) =>
        paramscolumn.value ? `R$ ${paramscolumn?.value?.toFixed(2).replace('.', ',')}` : '',
    },
    {
      field: 'dias',
      headerName: 'Dias',
      width: 80,
      align: 'left',
      type: 'number',
      editable: false,
    },
    {
      field: 'beneficio',
      headerName: 'Benefício',
      width: 120,
      align: 'right',
      type: 'number',
      editable: false,
      valueFormatter: (paramscolumn) =>
        paramscolumn.value ? `R$ ${paramscolumn?.value?.toFixed(2).replace('.', ',')}` : '',
    },
    {
      field: 'porc6',
      headerName: '% 6%',
      width: 100,
      align: 'right',
      type: 'number',
      editable: false,
    },
    {
      field: 'empresa',
      headerName: 'Empresa',
      width: 120,
      align: 'right',
      type: 'number',
      editable: false,
      valueFormatter: (paramscolumn) =>
        paramscolumn.value ? `R$ ${paramscolumn?.value?.toFixed(2).replace('.', ',')}` : '',
    },
    {
      field: 'estado',
      headerName: 'Estado',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'periodo',
      headerName: 'Período',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'admissao',
      headerName: 'Admissão',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'cargo',
      headerName: 'Cargo',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'cbo',
      headerName: 'CBO',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'salario',
      headerName: 'Salário',
      width: 120,
      align: 'right',
      type: 'number',
      editable: false,
      valueFormatter: (paramscolumn) =>
        params?.value ? `R$ ${paramscolumn?.value?.toFixed(2).replace('.', ',')}` : '',
    },
    {
      field: 'observacao',
      headerName: 'Observação',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (paramscolumn) => (
        <div style={{ whiteSpace: 'pre-wrap' }}>{paramscolumn?.value}</div>
      ),
    },
  ];

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
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
        onChange={(event, value) => apiRef.current.setPage(value - 1)}
      />
    );
  }

  const toggle = () => {
    setshow(!show);
  };

  const uploadanexo = async (e) => {
    e.preventDefault();

    const formData = new FormData();
    formData.append('files', arquivoanexo);

    const header = {
      headers: {
        'Custom-Header': 'value',
      },
    };
    try {
      setLoading(true);
      const response = await api.post('v1/upload/ticketransporte', formData, header);
      if (response && response.data) {
        setretanexo(response.data.files[0].filename);
        listaticket();
        toast.success('Arquivo Anexado');
      } else {
        throw new Error('Resposta inválida do servidor');
      }
    } catch (err) {
      if (err.response) {
        toast.error(`Erro: ${err.message}`);
      } else {
        toast.error('Erro: Tente novamente mais tarde!');
      }
    } finally {
      setLoading(false);
    }
  };
  useEffect(() => {
    listaticket();
    if (1 === 0) {
      console.log(retanexo);
    }
  }, []);
  return (
    <>
      <Modal
        isOpen={show}
        toggle={toggle}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-fullscreen modal-dialog-scrollable"
      >
        <ModalHeader style={{ backgroundColor: 'white' }}>Vale Transporte</ModalHeader>
        <ModalBody style={{ backgroundColor: 'white' }}>
          <ToastContainer
            style={{ zIndex: 9999999 }}
            position="top-right"
            autoClose={2000}
            hideProgressBar={false}
            newestOnTop
            closeOnClick
            rtl={false}
            pauseOnFocusLoss
            draggable
            pauseOnHover
          />
          {mensagem.length > 0 ? (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          ) : null}
          {loading ? (
            <Loader />
          ) : (
            <>
              <div className="col-sm-6">
                <Label>Selecione o arquivo de atualização de tickets</Label>
                <div className="d-flex flex-row-reverse custom-file">
                  <InputGroup>
                    <Input
                      type="file"
                      onChange={async (e) => {
                        const file = e.target.files[0];
                        setarquivoanexo(file);
                      }}
                      className="custom-file-input"
                      id="customFile3"
                      disabled={modoVisualizador()}
                    />
                    <Button color="primary" onClick={uploadanexo} disabled={modoVisualizador()}>
                      Atualizar{' '}
                    </Button>
                  </InputGroup>
                </div>
              </div>

              {/*   <Button color="link" onClick={gerarexcel}>
                                Exportar Excel
                            </Button> */}

              <Box sx={{ height: '100%', width: '100%' }}>
                <DataGrid
                  rows={ticket.map((colab, index) => ({
                    id: index, // ou outro campo único
                    ...colab,
                  }))}
                  columns={columns}
                  loading={loading}
                  pageSize={pageSize}
                  getRowId={(row) => row.id}
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  disableSelectionOnClick
                  experimentalFeatures={{ newEditingApi: true }}
                  components={{
                    Pagination: CustomPagination,
                    LoadingOverlay: LinearProgress,
                    NoRowsOverlay: CustomNoRowsOverlay,
                  }}
                  localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                />
              </Box>
            </>
          )}
        </ModalBody>
        <ModalFooter style={{ backgroundColor: 'white' }}>
          <Button color="secondary" onClick={toggle}>
            Fechar
          </Button>
        </ModalFooter>
      </Modal>
    </>
  );
};

Ticket.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Ticket;

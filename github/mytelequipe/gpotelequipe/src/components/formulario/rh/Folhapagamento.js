import { useState } from 'react';
import {
  Button,
  Label,
  InputGroup,
  Input,
  FormGroup,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
} from 'reactstrap';
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
import GroupsIcon from '@mui/icons-material/Groups';
import PropTypes from 'prop-types';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import { toast, ToastContainer } from 'react-toastify';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import Folhapagamentovisualizar from './Folhapagamentovisualizar';
import modoVisualizador from '../../../services/modovisualizador';
//import exportExcel from '../../../data/exportexcel/Excelexport';

const Folhapagamento = ({ setshow, show }) => {
  const [pageSize, setPageSize] = useState(100);
  const [loading, setLoading] = useState(false);
  const [folhapagamento, setfolhapagamento] = useState([]);
  const [datapagamento, setdatapagamento] = useState('');
  const [visualizarfolha, setvisualizarfolha] = useState('');
  const [ididentificador, setididentificador] = useState('');
  const [titulo, settitulo] = useState('');
  const [arquivofolhadepagamento, setarquivofolhadepagamento] = useState('');

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
    datafolha: datapagamento,
  };
  const uploadarquivo = async (e) => {
    e.preventDefault();

    if (!arquivofolhadepagamento) {
      toast.info('Nenhum arquivo selecionado para atualizar!');
      return;
    }

    const header = {
      headers: {
        'Custom-Header': 'value',
      },
    };
    const formData = new FormData();
    formData.append('files', arquivofolhadepagamento);

    try {
      setLoading(true);
      const response = await api.post('v1/uploadfolhadepagamento', formData, header);
      if (response && response.data) {
        if (response.status === 200) {
          toast.success('Upload concluido, aguarde a atualização que dura em torno de 20 minutos');
          //setarquivofolhadepagamento('');
        } else {
          toast.info('Erro ao fazer upload!');
        }
      } else {
        throw new Error('Resposta inválida do servidor');
      }
    } catch (err) {
      if (err.response) {
        toast.warn(err.message);
      } else {
        toast.warn('Erro: Tente novamente mais tarde!');
      }
    } finally {
      setLoading(false);
    }
  };
  const handleChangeDataPagamento = (value) => {
    const [ano, mes] = value.split('-');
    return `${mes}/${ano}`;
  };

  const listafolhapagamento = async () => {
    if (datapagamento.length > 0) {
      try {
        setLoading(true);
        params.datafolha = handleChangeDataPagamento(datapagamento);
        await api.get('v1/rh/folhapagamento', { params }).then((response) => {
          setfolhapagamento(response.data);
        });
      } catch (err) {
        toast.warn(err.message);
      } finally {
        setLoading(false);
      }
    } else {
      toast.info('Falta selecionar o periodo de visualização');
    }
  };

  const visualizar = async (stat, codfunc, nomefunc, cargofunc) => {
    setvisualizarfolha(true);
    setididentificador(codfunc);
    settitulo(`${codfunc} - ${nomefunc} - ${cargofunc}`);
    console.log(stat);
  };

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<GroupsIcon />}
          label="Visualizar"
          onClick={() =>
            visualizar(
              parametros.id,
              parametros.row.codigo,
              parametros.row.nome,
              parametros.row.cargo,
            )
          }
        />,
      ],
    },
    // { field: 'id', headerName: 'ID', width: 80, align: 'center' },
    {
      field: 'codigo',
      headerName: 'Código',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'nome',
      headerName: 'Colaborador',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'tipopessoa',
      headerName: 'Contratação',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'dataadmissao',
      headerName: 'Admissão',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'cargo',
      headerName: 'Cargo',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'cbo',
      headerName: 'CBO',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'cpf',
      headerName: 'CPF',
      width: 180,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'salario',
      headerName: 'Salario',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'provento',
      headerName: 'Provento',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'desconto',
      headerName: 'Desconto',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'liquido',
      headerName: 'Liquido',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
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

  return (
    <>
      <Modal
        isOpen={show}
        toggle={toggle}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-fullscreen modal-dialog-scrollable"
      >
        <ModalHeader style={{ backgroundColor: 'white' }}>Folha de Pagamento</ModalHeader>
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
          {visualizarfolha ? (
            <Folhapagamentovisualizar
              show={visualizarfolha}
              setshow={setvisualizarfolha}
              ididentificador={ididentificador}
              titulo={`${titulo}  ${` ${handleChangeDataPagamento(datapagamento)}` || ''}`.trim()}
              periodo={handleChangeDataPagamento(datapagamento)}
            />
          ) : null}

          {loading ? (
            <Loader />
          ) : (
            <>
              <FormGroup>
                <div className="row g-3">
                  <div className="col-sm-6 pb-3">
                    <Label>Selecione o arquivo de atualização de folhas de pagamento</Label>
                    <div className="d-flex flex-row-reverse custom-file">
                      <InputGroup>
                        <Input
                          type="file"
                          onChange={async (e) => {
                            const file = e.target.files[0];
                            setarquivofolhadepagamento(file);
                          }}
                          className="custom-file-input"
                          id="customFile3"
                          disabled={modoVisualizador()}
                        />
                        <Button
                          color="primary"
                          onClick={uploadarquivo}
                          disabled={modoVisualizador()}
                        >
                          Atualizar{' '}
                        </Button>
                      </InputGroup>
                    </div>
                  </div>
                </div>
                <div className="row g-3">
                  <div className="col-sm-2">
                    <Input
                      type="month"
                      onChange={(e) => setdatapagamento(e.target.value)}
                      value={datapagamento}
                    />
                  </div>
                  <div className="col-sm-1">
                    <Button color="primary" onClick={listafolhapagamento}>
                      Executar
                    </Button>
                  </div>
                </div>
              </FormGroup>

              <Box sx={{ height: '100%', width: '100%' }}>
                <DataGrid
                  rows={folhapagamento}
                  columns={columns}
                  loading={loading}
                  pageSize={pageSize}
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  disableSelectionOnClick
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

Folhapagamento.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Folhapagamento;

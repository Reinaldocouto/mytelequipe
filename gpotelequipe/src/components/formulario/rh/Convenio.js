import { useEffect, useState } from 'react';
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
import { toast, ToastContainer } from 'react-toastify';
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
import LinearProgress from '@mui/material/LinearProgress';
import modoVisualizador from '../../../services/modovisualizador';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
//import exportExcel from '../../../data/exportexcel/Excelexport';

const Convenio = ({ setshow, show }) => {
  const [pageSize, setPageSize] = useState(100);
  const [loading, setLoading] = useState(false);
  const [convenio, setconvenio] = useState([]);
  const [mensagem, setmensagem] = useState('');
  const [arquivo, setarquivo] = useState('');

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
    //datafolha: datapagamento,
  };
  const listaconvenio = async () => {
    try {
      setLoading(true);
      console.log(params);
      await api.get('v1/rh/convenio', { params }).then((response) => {
        setLoading(false);

        setconvenio(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };
  const uploadarquivo = async (e) => {
    e.preventDefault();

    if (!arquivo) {
      toast.info('Nenhum arquivo selecionado para atualizar!');
      return;
    }

    const nomeSemAcento = 'convenio.xls';
    const arquivoModificado = new File([arquivo], nomeSemAcento, { type: arquivo.type });

    const header = {
      headers: {
        'Custom-Header': 'value',
      },
    };
    const formData = new FormData();
    formData.append('files', arquivoModificado);

    try {
      setLoading(true);
      const response = await api.post('v1/uploadconvenio', formData, header);
      if (response && response.data) {
        if (response.status === 200) {
          listaconvenio();
          toast.success('Upload concluído, aguarde a atualização que dura em torno de 20 minutos');
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

  useEffect(() => {
    listaconvenio();
  }, []);

  const columns = [
    {
      field: 'nome',
      headerName: 'Nome',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (result) => <div style={{ whiteSpace: 'pre-wrap' }}>{result.value}</div>,
    },
    {
      field: 'idade',
      headerName: 'Idade',
      width: 100,
      align: 'center',
      type: 'number',
      editable: false,
    },
    {
      field: 'nomeconvenio',
      headerName: 'Convênio',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },

    {
      field: 'valorconvenio',
      headerName: 'Valor Convênio',
      width: 160,
      align: 'right',
      type: 'number',
      editable: false,
      valueFormatter: (result) => (result.value ? `R$ ${Number(result.value).toFixed(2)}` : ''),
    },
    {
      field: 'valorempresa',
      headerName: 'Valor Empresa',
      width: 160,
      align: 'right',
      type: 'number',
      editable: false,
      valueFormatter: (result) => (result.value ? `R$ ${Number(result.value).toFixed(2)}` : ''),
    },
    {
      field: 'descontocolaborador',
      headerName: 'Colaborador',
      width: 180,
      align: 'right',
      type: 'number',
      editable: false,
      valueFormatter: (result) => (result.value ? `R$ ${Number(result.value).toFixed(2)}` : ''),
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

  /*    const gerarexcel = () => {
            const excelData = totalacionamento.map((item) => ({
                PO: item.po,
                "PO ITEM": item.poitem,
                Sigla: item.sigla,
                IDsydle: item.idsydle,
                NOME: item.nome,
                'cliente': item.cliente,
                'Estado': item.estado,
                'Codigo Serviço': item.codigo,
                'Descricao': item.descricao,
                'Mes Pagamento': item.mespagamento,
                'Numero': item.numero,
                'Porcentagem': item.porcentagem,
                'valor Pagamento': item.valorpagamento,
                'Observacao': item.observacao,
                'Empresa': item.empresa
            }));
            exportExcel({ excelData, fileName: 'Relatorio_Total_acionamento' });
        };*/

  return (
    <>
      <Modal
        isOpen={show}
        toggle={toggle}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-fullscreen modal-dialog-scrollable"
      >
        <ModalHeader style={{ backgroundColor: 'white' }}>Convênio</ModalHeader>
        <ModalBody style={{ backgroundColor: 'white' }}>
          {mensagem.length > 0 ? (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          ) : null}
          {loading ? (
            <Loader />
          ) : (
            <>
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
              <FormGroup>
                <div className="row g-3">
                  <div className="col-sm-6 pb-3">
                    <Label>Selecione o arquivo de atualização de convênio</Label>

                    <div className="d-flex flex-row-reverse custom-file">
                      <InputGroup>
                        <Input
                          type="file"
                          onChange={async (e) => {
                            const file = e.target.files[0];
                            setarquivo(file);
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
              </FormGroup>

              {/*   <Button color="link" onClick={gerarexcel}>
                                Exportar Excel
                            </Button> */}

              <Box sx={{ height: '100%', width: '100%' }}>
                <DataGrid
                  rows={convenio}
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

Convenio.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Convenio;

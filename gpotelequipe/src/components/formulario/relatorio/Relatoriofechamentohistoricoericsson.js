import { useState, useEffect } from 'react';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
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
import LinearProgress from '@mui/material/LinearProgress';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import exportExcel from '../../../data/exportexcel/Excelexport';

const RelatoriofechamentohistoricoEricsson = ({ setshow, show }) => {
  const [pageSize, setPageSize] = useState(10);
  const [loading, setLoading] = useState(false);
  const [totalacionamento, settotalacionamento] = useState([]);
  const [mensagem, setmensagem] = useState('');

  
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const listaacionamentos = async () => {
    try {
      setLoading(true);
      const response = await api.get('v1/totalpagamento', { params });
      //console.log(response.data);
      settotalacionamento(response.data);
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };
  const columns = [
    // { field: 'id', headerName: 'ID', width: 80, align: 'center' },
    {
      field: 'po',
      headerName: 'PO',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'poitem',
      headerName: 'POITEM',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'sigla',
      headerName: 'Sigla',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'idsydle',
      headerName: 'IDSydle',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'cliente',
      headerName: 'Cliente',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'estado',
      headerName: 'Estado',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'codigo',
      headerName: 'Codigo',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'descricao',
      headerName: 'Descricao',
      width: 350,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'mespagamento',
      headerName: 'mespagamento',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'numero',
      headerName: 'numero',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'porcentagem',
      headerName: 'porcentagem',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'valorpj',
      headerName: 'valorpj',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'valorpagamento',
      headerName: 'valorpagamento',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'observacao',
      headerName: 'observacao',
      width: 350,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'empresa',
      headerName: 'EMPRESA',
      width: 350,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'mosreal',
      headerName: 'data mos',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'instalreal',
      headerName: 'data instalação',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'integreal',
      headerName: 'data integração',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'docinstalacao',
      headerName: 'doc instalação',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'docinfra',
      headerName: 'doc infra',
      width: 350,
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

  const iniciatabelas = () => {
    listaacionamentos();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);

  const gerarexcel = () => {
    const excelData = totalacionamento.map((item) => ({
      PO: item.po,
      POITEM: item.poitem,
      SIGLA: item.sigla,
      IDSYDLE: item.idsydle,
      CLIENTE: item.cliente,
      ESTADO: item.estado,
      CÓDIGO: item.codigo,
      DESCRIÇÃO: item.descricao,
      'MÊS PAGAMENTO': item.mespagamento,
      NÚMERO: item.numero,
      '%': item.porcentagem,
      'VALOR PJ': item.valorpj,
      'VALOR PAGAMENTO': item.valorpagamento,
      OBSERVAÇÃO: item.observacao,
      EMPRESA: item.empresa,
      'DATA MOS': item.mosreal,
      'DATA INSTALAÇÃO': item.instalreal,
      'DATA INTEGRAÇÃO': item.integreal,
      'DOC INSTALAÇÃO': item.docinstalacao,
      'DOC INFRA': item.docinfra,
    }));

    exportExcel({ excelData, fileName: 'Relatório - Histórico Fechamentos' });
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
        <ModalHeader>Relatório - Histórico Fechamentos</ModalHeader>
        <ModalBody>
          {mensagem.length > 0 ? (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          ) : null}
          {loading ? (
            <Loader />
          ) : (
            <>
              <Button color="link" onClick={gerarexcel}>
                Exportar Excel
              </Button>

              <Box sx={{ height: '100%', width: '100%' }}>
                <DataGrid
                  rows={totalacionamento}
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
        <ModalFooter>
          <Button color="secondary" onClick={toggle}>
            Fechar
          </Button>
        </ModalFooter>
      </Modal>
    </>
  );
};

RelatoriofechamentohistoricoEricsson.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default RelatoriofechamentohistoricoEricsson;

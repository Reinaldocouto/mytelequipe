import React, { useState, useEffect } from 'react';
import {
  Button,
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
import LinearProgress from '@mui/material/LinearProgress';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import exportExcel from '../../../data/exportexcel/Excelexport';

const Relatoriototalacionamento = ({ setshow, show }) => {
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
      const response = await api.get('v1/totalacionamento', { params });
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
      field: 'numero',
      headerName: 'NUMERO',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'site',
      headerName: 'SIGLA',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },    
    {
      field: 'po',
      headerName: 'PO',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'poitem',
      headerName: 'PO ITEM',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'nome',
      headerName: 'NOME',
      width: 350,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'codigoservico',
      headerName: 'CODIGO SERVIÇO',
      width: 180,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'descricaoservico',
      headerName: 'DESCRIÇÃO SERVIÇO',
      width: 350,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'valorservico',
      headerName: 'VALOR SERVIÇO',
      width: 140,
      align: 'right',
      type: 'string',
      editable: false,
    },
    {
      field: 'lpuhistorico',
      headerName: 'LPU HISTÓRICO',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'datadeenviodoemail',
      headerName: 'DATA ENVIO EMAIL',
      width: 180,
      align: 'center',
      type: 'datetime',
      editable: false,
      valueFormatter: (param) => {
        if (!param.value) {
          return '';
        }
        const date = new Date(param.value);
        const formattedDate = date.toLocaleString('pt-BR', {
          year: 'numeric',
          month: '2-digit',
          day: '2-digit',
          hour: '2-digit',
          minute: '2-digit',
          second: '2-digit',
        });
    
        return formattedDate
        
      },
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
      Numero: item.numero,
      Sigla: item.site,
      PO: item.po,
      "PO ITEM": item.poitem,
      NOME: item.nome,
      'CODIGO SERVIÇO': item.codigoservico,
      'DESCRIÇÃO SERVIÇO': item.descricaoservico,
      "VALOR SERVIÇO": item.valorservico,
      "LPU HISTÓRICO": item.lpuhistorico,
      "DATA ENVIO EMAIL": item.datadeenviodoemail ? new Date(item.datadeenviodoemail).toLocaleString('pt-BR', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
      }) : '',
    }));
    exportExcel({ excelData, fileName: 'Relatorio_Total_acionamento' });
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
        <ModalHeader>Relatório - Total de Acionamentos</ModalHeader>
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

              <Box sx={{ height: '90%', width: '100%' }}>
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

Relatoriototalacionamento.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Relatoriototalacionamento;

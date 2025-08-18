import { useState, useEffect } from 'react';
import {
  Button,
  Col,
  Label,
  Modal,
  Row,
  Input,
  ModalBody,
  ModalHeader,
  ModalFooter,
} from 'reactstrap';
import PropTypes from 'prop-types';

import { Box } from '@mui/material';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import Typography from '@mui/material/Typography';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import exportExcel from '../../../data/exportexcel/Excelexport';

const Relatoriodespesastelefonica = ({ setshow, show }) => {
  const [pageSize, setPageSize] = useState(10);
  const [loading, setLoading] = useState(false);
  const [listadespesas, setlistadespesas] = useState([]);
  const [mensagem, setmensagem] = useState('');
  const [idmpst, setidmpst] = useState('');
  const [datainicio, setdatainicio] = useState('');
  const [datafinal, setdatafinal] = useState('');

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const getlistaDespesa = async () => {
    try {
      setLoading(true);
      const response = await api.get('v1/projetotelefonica/ListaDespesas', {
        params: {
          idmpst,
          datainicio,
          datafinal,
          ...params,
        },
      });
      setlistadespesas(response.data);
      console.log(response.data);
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
      field: 'idpmts',
      headerName: 'IDMPTS',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'nome',
      headerName: 'NOME',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'tipo',
      headerName: 'TIPO',
      width: 140,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'descricao',
      headerName: 'DESCRIÇÃO',
      width: 400,
      align: 'left',
      type: 'string',
      editable: false,
    },

    {
      field: 'dataacionamento',
      headerName: 'DATA ACIONAMENTO',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'valor',
      headerName: 'VALOR',
      width: 150,
      align: 'right',
      type: 'number', // Melhor usar 'number' para valores monetários
      editable: false,
      valueFormatter: (parametros) => {
        if (parametros.value == null) return ''; // Caso o valor seja nulo
        return parametros.value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
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
        <Typography variant="body2">Total de itens: {rowCount}</Typography>

        <Pagination
          color="primary"
          count={pageCount}
          page={page + 1}
          onChange={(event, value1) => apiRef.current.setPage(value1 - 1)}
        />
      </Box>
    );
  }

  const toggle = () => {
    setshow(!show);
  };

  const iniciatabelas = () => {
    getlistaDespesa();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);

  const gerarexcel = () => {
    console.log(listadespesas);
    const excelData = listadespesas.map((item) => {
      const formatarData = (data) => {
        if (!data) return '';
        const d = new Date(data);
        if (d.getFullYear() === 1899 && d.getMonth() === 11 && d.getDate() === 30) {
          return '';
        }
        return d.toLocaleDateString('pt-BR');
      };

      return {
        IDPMTS: item.idpmts,
        Descrição: item.descricao,
        'Data do Acionamento': formatarData(item.dataacionamento),
        Nome: item.nome,
        Tipo: item.tipo,
        Valor: item.valor,
      };
    });

    exportExcel({ excelData, fileName: 'Relatório - Despesa Telefônica' });
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
        <ModalHeader>Relatório - Despesas</ModalHeader>
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
              <Row className="align-items-end g-3 mb-3">
                <Col md="2">
                  <Label for="idpmts" className="fw-bold">
                    IDPMTS
                  </Label>
                  <Input
                    id="idpmts"
                    type="text"
                    value={idmpst}
                    onChange={(e) => setidmpst(e.target.value)}
                    placeholder="Digite o ID"
                  />
                </Col>

                <Col md="3">
                  <Label for="dataInicio" className="fw-bold">
                    Data Início
                  </Label>
                  <Input
                    id="dataInicio"
                    type="date"
                    value={datainicio}
                    onChange={(e) => setdatainicio(e.target.value)}
                  />
                </Col>

                <Col md="3">
                  <Label for="dataFinal" className="fw-bold">
                    Data Final
                  </Label>
                  <Input
                    id="dataFinal"
                    type="date"
                    value={datafinal}
                    onChange={(e) => setdatafinal(e.target.value)}
                  />
                </Col>

                <Col md="auto" className="d-flex gap-2">
                  <Button color="primary" onClick={getlistaDespesa} title="Buscar">
                    <SearchIcon />
                  </Button>
                  <Button color="secondary" onClick={getlistaDespesa} title="Atualizar">
                    <AutorenewIcon />
                  </Button>
                </Col>
              </Row>

              <Box sx={{ height: '95%', width: '100%' }}>
                <DataGrid
                  rows={listadespesas}
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
Relatoriodespesastelefonica.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};
export default Relatoriodespesastelefonica;

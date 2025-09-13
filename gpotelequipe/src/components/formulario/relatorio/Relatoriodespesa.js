import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import {
  Modal,
  ModalHeader,
  ModalBody,
  Input,
  Label,
  Button,
  ModalFooter,
  Col,
  Row,
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
import LinearProgress from '@mui/material/LinearProgress';
import 'react-toastify/dist/ReactToastify.css';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import Typography from '@mui/material/Typography';
import Pagination from '@mui/material/Pagination';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import exportExcel from '../../../data/exportexcel/Excelexport';

const Relatoriodespesa = ({ setshow, show }) => {
  const [loading, setloading] = useState(false);
  const [loadingFinanceiro, setloadingFinanceiro] = useState(true);
  const [mensagem, setmensagem] = useState('');
  const [totalRegistros, setTotalRegistros] = useState(0);
  const [site, setsite] = useState('');
  const [datainicio, setdatainicio] = useState('');
  const [datafinal, setdatafinal] = useState('');
  const [relatorioDespesas, setRelatorioDespesas] = useState([]);
  const [valorTotal, setValorTotal] = useState(0);
  const [selectionModel, setSelectionModel] = useState([]);
  const [paginationModel, setPaginationModel] = useState({ page: 0, pageSize: 10 });

  const toggle = () => {
    setshow(!show);
  };

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  // Componente de paginação personalizado
  function CustomPagination(item) {
    const apiRef = useGridApiContext();
    const pageItem = useGridSelector(apiRef, gridPageSelector);
    const pageCount = useGridSelector(apiRef, gridPageCountSelector);

    return (
      <Box
        sx={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          width: '100%',
          padding: '10px',
          flexWrap: 'wrap',
          gap: 2,
        }}
      >
        <Typography variant="body2">
          Total de registros: <strong>{item.totalRegistros}</strong>
        </Typography>
        <Pagination
          color="primary"
          count={pageCount}
          page={pageItem + 1}
          onChange={(event, value) => apiRef.current.setPage(value - 1)}
        />
      </Box>
    );
  }

  // Função para buscar os dados
  const despesasrelaotrioericsson = async () => {
    try {
      setloadingFinanceiro(true);
      const response = await api.get('v1/projetoericsson/relatoriodespesas', {
        params: {
          site,
          datainicio,
          datafim: datafinal,
          ...params,
        },
      });

      if (response.data.length === 0) {
        setRelatorioDespesas([]);
        setloading(false);
        return;
      }

      const dadosFormatados = response?.data.map((item, index) => ({
        ...item,
        id: item.id || `${index}-${Date.now()}`, // ID único mais robusto
        valor: item.valor ? parseFloat(String(item.valor).replace(',', '.')) : 0,
        dataacionamento: item.dataacionamento || null,
      }));
      const ids = dadosFormatados.map((item) => item.id);
      setSelectionModel(ids);
      const somaDosValores = ids.reduce((total, id) => {
        const row = dadosFormatados.find((item) => item.id === id);
        return total + (row?.valor || 0);
      }, 0);
      setValorTotal(somaDosValores);
      setRelatorioDespesas(dadosFormatados);
      setTotalRegistros(dadosFormatados.length);
      setmensagem('');
    } catch (err) {
      setmensagem(err.response?.data?.message || err.message);
      setRelatorioDespesas([]);
      setTotalRegistros(0);
    } finally {
      setloadingFinanceiro(false);
    }
  };

  useEffect(() => {
    if (show) {
      despesasrelaotrioericsson();
    }
  }, [show]);

  const handleSelectionChange = (newSelection) => {
    setSelectionModel(newSelection);
    const total = relatorioDespesas
      .filter((row) => newSelection.includes(row.id))
      .reduce((acc, row) => acc + (row.valor || 0), 0);
    setValorTotal(total);
  };

  const handleBuscar = () => {
    despesasrelaotrioericsson();
  };

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

  const gerarexcel = () => {
    const excelData = relatorioDespesas.map((item) => ({
      ID: item.id || '',
      Site: item.idpmts || '',
      Descrição: item.descricao || '',
      Valor: item.valor !== null ? `R$ ${item.valor.toFixed(2)}` : 'R$ 0,00',
      'Data Acionamento': item.dataacionamento
        ? new Date(item.dataacionamento).toLocaleDateString('pt-BR')
        : 'Data não informada',
      Nome: item.nome || '',
      Tipo: item.tipo || '',
    }));

    exportExcel({ excelData, fileName: 'Relatorio_Despesas_Ericsson' });
  };

  const columns = [
    {
      field: 'idpmts',
      headerName: 'Site',
      width: 100,
      align: 'left',
      type: 'string',
    },
    {
      field: 'nome',
      headerName: 'NOME',
      width: 200,
      align: 'left',
      type: 'string',
    },
    {
      field: 'tipo',
      headerName: 'TIPO',
      width: 140,
      align: 'left',
      type: 'string',
    },
    {
      field: 'descricao',
      headerName: 'DESCRIÇÃO',
      width: 400,
      align: 'left',
      type: 'string',
    },
    {
      field: 'dataacionamento',
      headerName: 'DATA ACIONAMENTO',
      width: 150,
      align: 'center',
      valueFormatter: ({ value }) => (value ? new Date(value).toLocaleDateString('pt-BR') : ''),
    },
    {
      field: 'valor',
      headerName: 'VALOR',
      width: 150,
      align: 'right',
      valueFormatter: ({ value }) =>
        value?.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }) || 'R$ 0,00',
    },
  ];

  return (
    <Modal
      isOpen={show}
      toggle={toggle}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-fullscreen modal-dialog-scrollable"
    >
      <ModalHeader toggle={toggle}>Relatório de despesas</ModalHeader>
      <ModalBody>
        {mensagem && (
          <div className="alert alert-danger mt-2" role="alert">
            {mensagem}
          </div>
        )}

        {loading ? (
          <Loader />
        ) : (
          <>
            <Button color="link" onClick={gerarexcel}>
              Exportar Excel
            </Button>

            <Row className="align-items-end g-3 mb-3">
              <Col md="2">
                <Label for="site" className="fw-bold">
                  Site
                </Label>
                <Input
                  id="site"
                  type="text"
                  value={site}
                  onChange={(e) => setsite(e.target.value)}
                  placeholder="Digite o site"
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
                <Button color="primary" onClick={handleBuscar} title="Buscar">
                  <SearchIcon />
                </Button>
                <Button color="secondary" onClick={handleBuscar} title="Atualizar">
                  <AutorenewIcon />
                </Button>
              </Col>
            </Row>

            <Box sx={{ height: '70%', width: '100%' }}>
              <div
                style={{
                  display: 'flex',
                  flexDirection: 'column',
                  gap: '8px',
                  marginBottom: '16px',
                  alignItems: 'flex-end', // Alinha à direita
                }}
              >
                <Typography variant="body1">
                  Valor Total:{' '}
                  <b>
                    {valorTotal?.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
                  </b>
                </Typography>
              </div>

              <DataGrid
                rows={relatorioDespesas}
                columns={columns}
                loading={loadingFinanceiro}
                paginationMode="client"
                checkboxSelection
                selectionModel={selectionModel}
                onSelectionModelChange={handleSelectionChange}
                paginationModel={paginationModel}
                onPaginationModelChange={setPaginationModel}
                pageSizeOptions={[5, 10, 20, 50]}
                disableSelectionOnClick
                components={{
                  Pagination: () => <CustomPagination totalRegistros={totalRegistros} />,
                  LoadingOverlay: LinearProgress,
                  NoRowsOverlay: CustomNoRowsOverlay,
                }}
                localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                getRowId={(row) => row.id}
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
  );
};

Relatoriodespesa.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Relatoriodespesa;

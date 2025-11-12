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
  const [idpmts, setidpmts] = useState('');
  const [ufsigla, setufsigla] = useState('');
  const [sigla, setsigla] = useState('');    
  const [datainicio, setdatainicio] = useState('');
  const [datafinal, setdatafinal] = useState('');
  const [valorTotal, setValorTotal] = useState('');
  const [sortModel, setSortModel] = useState([]); // ⬅️ novo estado de ordenação

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
          idpmts,
          datainicio,
          datafinal,
          ufsigla,
          sigla,
          ...params,
        },
      });
      setlistadespesas(response.data.dados);
      setValorTotal(response.data.total_geral);
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  const columns = [
    { field: 'idpmts', headerName: 'IDPMTS', width: 100, align: 'left' },
    { field: 'ufsigla', headerName: 'UF/SIGLA', width: 100, align: 'left' },
    { field: 'pmosigla', headerName: 'SIGLA', width: 100, align: 'left' },        
    { field: 'nome', headerName: 'NOME', width: 300, align: 'left' },
    { field: 'tipo', headerName: 'TIPO', width: 150, align: 'left' },
    { field: 'descricao', headerName: 'DESCRIÇÃO', width: 450
      , align: 'left',      renderCell: (parametros) => (
        <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>
      ), },


    {
      field: 'dataacionamento',
      headerName: 'DATA ACIONAMENTO',
      width: 150,
      align: 'center',
      type: 'date',
      valueFormatter: ({ value }) => {
        if (!value) return '';
        const date = new Date(value);
        if (date.getDate() === 30 && date.getMonth() === 11 && date.getFullYear() === 1899)
          return '';
        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'valor',
      headerName: 'VALOR',
      width: 150,
      align: 'right',
      type: 'number',
      valueFormatter: ({ value }) => {
        if (value == null) return '';
        return value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
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
    const rowCount = apiRef.current.getRowsCount();
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
          onChange={(e, val) => apiRef.current.setPage(val - 1)}
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
    const formatarData = (data) => {
      if (!data) return '';
      const d = new Date(data);
      if (d.getFullYear() === 1899 && d.getMonth() === 11 && d.getDate() === 30) {
        return '';
      }
      return d.toLocaleDateString('pt-BR');
    };

    const sortedData = [...listadespesas];
    if (sortModel.length > 0) {
      const { field, sort } = sortModel[0];
      sortedData.sort((a, b) => {
        const valA = a[field];
        const valB = b[field];

        if (field === 'dataacionamento') {
          const dateA = new Date(valA || '1900-01-01');
          const dateB = new Date(valB || '1900-01-01');
          return sort === 'asc' ? dateA - dateB : dateB - dateA;
        }

        if (typeof valA === 'string' && typeof valB === 'string') {
          return sort === 'asc' ? valA.localeCompare(valB) : valB.localeCompare(valA);
        }

        return sort === 'asc' ? valA - valB : valB - valA;
      });
    }

    const excelData = sortedData.map((item) => ({
      IDPMTS: item.idpmts,
      Nome: item.nome,
      UFSigla: item.ufsigla,
      Sigla: item.pmosigla,
      Tipo: item.tipo,
      Descrição: item.descricao,
      'Data do Acionamento': formatarData(item.dataacionamento),
      Valor: item.valor,
    }));

    exportExcel({ excelData, fileName: 'Relatório - Despesa Telefônica' });
  };

  return (
    <Modal
      isOpen={show}
      toggle={toggle}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-fullscreen modal-dialog-scrollable"
    >
      <ModalHeader>Relatório - Despesas</ModalHeader>
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
                <Label for="idpmts" className="fw-bold">
                  IDPMTS
                </Label>
                <Input
                  id="idpmts"
                  type="text"
                  value={idpmts}
                  onChange={(e) => setidpmts(e.target.value)}
                  placeholder="Digite o ID"
                />
              </Col>

              <Col md="2">
                <Label for="ufsigla" className="fw-bold">
                  UF/SIGLA
                </Label>
                <Input
                  id="ufsigla"
                  type="text"
                  value={ufsigla}
                  onChange={(e) => setufsigla(e.target.value)}
                  placeholder="Digite a UF/Sigla"
                />
              </Col>       
              <Col md="2">
                <Label for="sigla" className="fw-bold">
                  SIGLA
                </Label>
                <Input
                  id="sigla"
                  type="text"
                  value={sigla}
                  onChange={(e) => setsigla(e.target.value)}
                  placeholder="Digite a Sigla"
                />
              </Col>                        

              <Col md="2">
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

              <Col md="2">
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
              <h4 style={{ width: '100%', textAlign: 'right' }}>
                Valor total: <b>{valorTotal?.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })} </b>
              </h4>

              <DataGrid
                rows={listadespesas}
                columns={columns}
                loading={loading}
                pageSize={pageSize}
                onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                disableSelectionOnClick
                sortModel={sortModel}
                onSortModelChange={(model) => setSortModel(model)}
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
  );
};
Relatoriodespesastelefonica.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};
export default Relatoriodespesastelefonica;

import React, { useState, useEffect, useCallback } from 'react';
import PropTypes from 'prop-types';
import { Modal, ModalHeader, ModalBody, Button, ModalFooter } from 'reactstrap';
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
import { ToastContainer, toast } from 'react-toastify';
import LinearProgress from '@mui/material/LinearProgress';
import 'react-toastify/dist/ReactToastify.css';
import Typography from '@mui/material/Typography';
import Pagination from '@mui/material/Pagination';
import FaturamentoEricsson from '../../modals/filtros/FaturamentoEricsson';
import api from '../../../services/api';
import createLocalDate, { formatDatePtBR } from '../../../services/data';
import Loader from '../../../layouts/loader/Loader';
import exportExcel from '../../../data/exportexcel/Excelexport';
import ConfirmaModal from '../../modals/ConfirmacaoModal';
import PainelGraficosFAT from '../../dashboard/FaturamentoEricssonFat/PainelGraficosFAT';

function RelatorioEricssonFaturamento({ setshow, show }) {
  const [loading, setloading] = useState(false);
  const [loadingFinanceiro, setloadingFinanceiro] = useState(true);
  const [mensagem, setmensagem] = useState('');
  const [totalRegistros, setTotalRegistros] = useState(0);
  const [relatorioFaturamento, setRelatorioFaturamento] = useState([]);
  const [rowSelectionModel, setRowSelectionModel] = useState([]);
  const [changedField, setChangedField] = useState();
  const [rowToUpdate, setRowToUpdate] = useState(null);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [mostrarGrafico, setMostrarGrafico] = useState(true);
  const [showFiltro, setShowFiltro] = useState(false);
  const [filtro, setFiltro] = useState({});

  // Helpers de status (MIGO/MIRO) — definidas antes do uso no DataGrid
  const hasVal = (v) =>
    v !== undefined && v !== null && String(v).trim() !== '' && String(v).trim() !== '0';
  const hasMigo = (row) => hasVal(row.nmigo);
  const hasMiro = (row) => hasVal(row.nmiro);

  const getStatusFaturamento = (row) => {
    if (hasMigo(row) && hasMiro(row)) return '100% Faturado';
    if (hasMigo(row) && !hasMiro(row)) return 'OK';
    return 'NOK';
  };

  const isRowLocked = (row) => getStatusFaturamento(row) === '100% Faturado';

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };
  const toggleFiltro = useCallback(() => {
    setShowFiltro((prev) => !prev);
  }, []);

  const aplicarFiltros = useCallback(async (novoFiltro) => {
    setShowFiltro(false);
    setFiltro(novoFiltro);

    try {
      setloadingFinanceiro(true);

      const response = await api.get('v1/projetoericsson/faturamento', {
        params: {
          ...params, // parâmetros globais
          ...novoFiltro, // filtros aplicados pelo usuário
        },
      });

      if (!response.data || response.data.length === 0) {
        setRelatorioFaturamento([]);
        setTotalRegistros(0);
        setmensagem('Nenhum dado encontrado');
        return;
      }

      const dadosFormatados = response.data.map((item, index) => ({
        ...item,
        id: item.id || `${index}-${Date.now()}`, // ID único
        valor: item.valor ? parseFloat(item.valor) : 0,
        dataacionamento: item.dataacionamento || null,
      }));

      setRelatorioFaturamento(dadosFormatados);
      setTotalRegistros(response.data.length);
      setmensagem('');
    } catch (err) {
      setmensagem(err.response?.data?.message || err.message);
      setRelatorioFaturamento([]);
      setTotalRegistros(0);
    } finally {
      setloadingFinanceiro(false);
    }
  }, []);

  const toggle = () => {
    setshow(!show);
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
      const response = await api.get('v1/projetoericsson/faturamento', {
        params: {
          ...params,
        },
      });

      if (response.data.length === 0) {
        setRelatorioFaturamento([]);
        setloading(false);
        return;
      }

      const dadosFormatados = response?.data.map((item, index) => ({
        ...item,
        id: item.id || `${index}-${Date.now()}`, // ID único mais robusto
        valor: item.valor ? parseFloat(item.valor) : 0,
        dataacionamento: item.dataacionamento || null,
      }));
      setRelatorioFaturamento(dadosFormatados || []);
      setTotalRegistros(response.data.length || 0);
      setmensagem('');
    } catch (err) {
      setmensagem(err.response?.data?.message || err.message);
      setRelatorioFaturamento([]);
      setTotalRegistros(0);
    } finally {
      setloadingFinanceiro(false);
    }
  };
  const handleCancelSave = () => {
    console.log('Cancelado pelo usuário.');
    setConfirmOpen(false);
  };
  const handleConfirmSave = async () => {
    if (!rowSelectionModel.length) {
      toast.warning('Nenhuma atividade selecionada.');
      return;
    }

    setloadingFinanceiro(true);

    try {
      // Filtra os IDs das atividades selecionadas
      const atividadeSelecionada = relatorioFaturamento
        .filter((item) => rowSelectionModel.includes(item.id))
        .map((item) => item.poritem)
        .join(',');

      const requestData = {
        ...params,
        atividadeSelecionada, // Adiciona como propriedade, não espalhada
        [rowToUpdate.changedFields[0]]: rowToUpdate.newRow[rowToUpdate.changedFields[0]],
      };
      await api.post('v1/projetoericsson/editaremmassa', requestData);
      setloadingFinanceiro(false);
      setConfirmOpen(false);
      setloading(true);
      await aplicarFiltros(filtro);
    } catch (error) {
      console.error('Erro ao salvar alterações em massa:', error);
      // Opcional: mostrar feedback visual ao usuário
      setloadingFinanceiro(false);
      setConfirmOpen(false);
      toast.error('Falha ao salvar alterações.');
    } finally {
      setloadingFinanceiro(false);
      setloading(false);
      setConfirmOpen(false);
    }
  };
  useEffect(() => {
    if (show) {
      despesasrelaotrioericsson();
    }
  }, [show]);

  // const handleBuscar = () => {
  //   despesasrelaotrioericsson();
  // };

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }
  const handleProcessRowUpdate = async (newRow, oldRow) => {
    if (rowSelectionModel.length === 0) {
      setmensagem('Selecione pelo menos um item');
      return oldRow;
    }

    // Find all changed fields (more robust than just finding the first one)
    const changedFields = Object.keys(newRow).filter(
      (key) => newRow[key] !== oldRow[key] && key !== 'id', // Exclude ID field from changes if needed
    );

    if (changedFields.length === 0) {
      return oldRow; // No actual changes detected
    }

    React.startTransition(() => {
      setChangedField(changedFields[0]);
      setRowToUpdate({
        newRow,
        oldRow,
        changedFields,
      });
      setConfirmOpen(true);
    });

    return newRow;
  };

  const gerarexcel = () => {
    const excelData = relatorioFaturamento.map((item) => ({
      'Site ID': item.siteid || '',
      PO: item.po || '',
      'PO+Item': item.poritem || '',
      'Data Criação PO': formatDatePtBR(item.datacriacaopo) || '',
      ID: item.id || '',
      'Descrição Serviço': item.descricaoservico || '',
      'Data MIGO': formatDatePtBR(item.datamigo) || '',
      'Nº MIGO': item.nmigo || '',
      'Qtd MIGO': item.qtdmigo !== null ? item.qtdmigo : '',
      'Data MIRO': formatDatePtBR(item.datamiro) || '',
      'Nº MIRO': item.nmiro || '',
      'Qtd MIRO': item.qtdmiro !== null ? item.qtdmiro : '',
      CodigoCliente: item.codigocliente || '',
      Estado: item.estado || '',
      'Qty ordered': item.qtyordered !== null ? item.qtyordered : '',
      Medida_filtro: item.medidafiltro || '',
      Medida_filtro_Unitario: item.medidafiltrounitario || '',
      'TIPO DE PO': item.classificacaopo || '',
      MOS: item.mos ? formatDatePtBR(item.mos) : '',
      INSTALAÇÃO: item.instalacao ? formatDatePtBR(item.instalacao) : '',
      INTEGRAÇÃO: item.integracao ? formatDatePtBR(item.integracao) : '',
      ACEITAÇÃO: item.aceitacao ? formatDatePtBR(item.aceitacao) : '',
      DOC: item.doc ? formatDatePtBR(item.doc) : '',
      'Aprovação todos Docs.': item.aprovacaoDocs ? formatDatePtBR(item.aprovacaoDocs) : '',
      ANÁLISE: item.analise || '',
      'FAT.': item.fat || '',
      'VALOR A FATURAR (R$)':
        item.valorafaturar !== null ? `R$ ${Number(item.valorafaturar).toFixed(2)}` : 'R$ 0,00',
    }));

    exportExcel({
      excelData,
      fileName: 'Relatorio_Faturamento_Ericsson',
      sheetName: 'Faturamento Ericsson',
    });
  };

  const columns = [
    {
      field: 'siteid',
      headerName: 'Site ID',
      width: 120,
      align: 'left',
      type: 'string',
      headerClassName: 'default-header',
    },
    {
      field: 'po',
      headerName: 'PO',
      width: 80,
      align: 'left',
      type: 'string',
      headerClassName: 'default-header',
    },
    {
      field: 'poritem',
      headerName: 'PO+Item',
      width: 100,
      align: 'left',
      type: 'string',
      headerClassName: 'default-header',
    },
    {
      field: 'datacriacaopo',
      headerName: 'Data Criação PO',
      width: 150,
      align: 'center',
      type: 'date',
      headerClassName: 'default-header',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
    },
    {
      field: 'id',
      headerName: 'ID',
      width: 150,
      align: 'left',
      type: 'string',
      headerClassName: 'default-header',
    },
    {
      field: 'descricaoservico',
      headerName: 'Descrição Serviço',
      width: 300,
      align: 'left',
      type: 'string',
      headerClassName: 'default-header',
    },
    {
      field: 'datamigo',
      headerName: 'Data MIGO',
      width: 150,
      align: 'center',
      type: 'date',
      headerClassName: 'default-header',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
    },
    {
      field: 'nmigo',
      headerName: 'Nº MIGO',
      width: 120,
      align: 'left',
      type: 'string',
      headerClassName: 'yellow-header',
    },
    {
      field: 'qtdmigo',
      headerName: 'Qtd MIGO',
      width: 100,
      align: 'right',
      type: 'number',
      headerClassName: 'dark-green-header',
    },
    {
      field: 'datamiro',
      headerName: 'Data MIRO',
      width: 120,
      align: 'center',
      type: 'date',
      headerClassName: 'default-header',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
    },
    {
      field: 'nmiro',
      headerName: 'Nº MIRO',
      width: 120,
      align: 'left',
      type: 'string',
      headerClassName: 'yellow-header',
    },
    {
      field: 'qtdmiro',
      headerName: 'Qtd MIRO',
      width: 100,
      align: 'right',
      type: 'number',
      headerClassName: 'dark-green-header',
    },
    {
      field: 'codigocliente',
      headerName: 'CodigoCliente',
      width: 120,
      align: 'left',
      type: 'string',
      headerClassName: 'default-header',
    },
    {
      field: 'estado',
      headerName: 'Estado',
      width: 100,
      align: 'left',
      type: 'string',
      headerClassName: 'default-header',
    },
    {
      field: 'qtyordered',
      headerName: 'Qty ordered',
      width: 100,
      align: 'right',
      type: 'number',
      headerClassName: 'default-header',
    },
    {
      field: 'medidafiltro',
      headerName: 'Medida_filtro',
      width: 120,
      align: 'left',
      type: 'string',
      headerClassName: 'default-header',
    },
    {
      field: 'medidafiltrounitario',
      headerName: 'Medida_filtro_Unitario',
      width: 200,
      align: 'left',
      type: 'string',
      headerClassName: 'default-header',
    },
    {
      field: 'classificacaopo',
      headerName: 'TIPO DE PO',
      width: 120,
      align: 'left',
      type: 'string',
      headerClassName: 'default-header',
    },
    {
      field: 'mos',
      headerName: 'MOS',
      width: 120,
      align: 'center',
      type: 'date',
      headerClassName: 'light-green-header',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
    },
    {
      field: 'instalacao',
      headerName: 'INSTALAÇÃO',
      width: 120,
      align: 'center',
      type: 'date',
      headerClassName: 'light-green-header',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
    },
    {
      field: 'integracao',
      headerName: 'INTEGRAÇÃO',
      width: 120,
      align: 'center',
      type: 'date',
      headerClassName: 'light-green-header',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
    },
    {
      field: 'aceitacao',
      headerName: 'ACEITAÇÃO',
      width: 120,
      align: 'center',
      type: 'date',
      headerClassName: 'light-green-header',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
    },
    {
      field: 'doc',
      headerName: 'DOC',
      width: 150,
      align: 'center',
      type: 'string',
      headerClassName: 'light-green-header',
    },
    {
      field: 'aprovacaoDocs',
      headerName: 'Aprovação todos Docs.',
      width: 200,
      align: 'center',
      type: 'date',
      headerClassName: 'light-green-header',
      valueGetter: (parametros) => createLocalDate(parametros.value),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
    },
    {
      field: 'analise',
      headerName: 'ANÁLISE',
      width: 200,
      align: 'center',
      headerClassName: 'pink-header',
      type: 'string',
    },
    {
      field: 'fat',
      headerName: 'FAT.',
      width: 250,
      align: 'center',
      type: 'singleSelect',
      editable: true,
      headerClassName: 'pink-header',
      valueOptions: [
        'Aguarda Aceitação',
        'Em Andamento',
        'Emitir NF',
        'Solicitado Faturamento',
        'Doc. Aguarda Análise',
        'Aguarda TX',
        '100% Faturado',
        'OK',
        'NOK',
      ],
    },
    {
      field: 'valorafaturar',
      headerName: 'VALOR A FATURAR (R$)',
      width: 200,
      align: 'right',
      type: 'number',
      headerClassName: 'pink-header',
      valueFormatter: ({ value }) =>
        value?.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }) || 'R$ 0,00',
    },
  ];

  const handleProcessRowUpdateError = (error) => {
    console.error('Erro ao atualizar linha:', error);
  };
  return (
    <>
      {showFiltro && (
        <FaturamentoEricsson
          showFiltro={showFiltro}
          toggleFiltro={toggleFiltro}
          filtrar={aplicarFiltros}
          filtro={filtro}
        />
      )}

      <Modal
        isOpen={show}
        toggle={toggle}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-fullscreen modal-dialog-scrollable"
      >
        <ModalHeader toggle={toggle}>Relatório de Faturamento</ModalHeader>
        <ModalBody>
          {mensagem && (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          )}

          {loading ? (
            <Loader />
          ) : (
            <div>
              <div className="container-fluid p-3">
                <div className="d-flex justify-content-between gap-3">
                  <Button color="primary" onClick={() => setMostrarGrafico((prev) => !prev)}>
                    {mostrarGrafico ? 'Esconder Gráfico' : 'Mostrar Gráfico'}
                  </Button>
                  <div className="d-flex justify-content-between gap-3">
                    <Button className="mr-4" color="primary" onClick={() => toggleFiltro()}>
                      Aplicar Filtros
                    </Button>
                    <Button color="secondary" onClick={() => despesasrelaotrioericsson()}>
                      Cancelar Filtros
                    </Button>
                  </div>
                </div>
              </div>
              {mostrarGrafico && relatorioFaturamento.length > 0 && (
                <PainelGraficosFAT relatorioFaturamento={relatorioFaturamento} />
              )}
              <Button color="link" onClick={gerarexcel}>
                Exportar Excel
              </Button>
              <ToastContainer />
              <ConfirmaModal
                open={confirmOpen}
                quantity={rowSelectionModel.length}
                onConfirm={handleConfirmSave}
                onCancel={handleCancelSave}
                campo={changedField}
              />
              <Box sx={{ height: '800px', width: '100%' }}>
                <DataGrid
                  rows={relatorioFaturamento}
                  columns={columns}
                  loading={loadingFinanceiro}
                  paginationMode="client"
                  rowCount={totalRegistros}
                  disableSelectionOnClick
                  checkboxSelection
                  experimentalFeatures={{ newEditingApi: true }}
                  rowSelectionModel={rowSelectionModel}
                  onRowSelectionModelChange={setRowSelectionModel}
                  editMode="row"
                  processRowUpdate={handleProcessRowUpdate}
                  onProcessRowUpdateError={handleProcessRowUpdateError}
                  // Bloqueia edição quando "100% Faturado"
                  isCellEditable={(cellParams) => !isRowLocked(cellParams.row)}
                  // Classe por linha para aplicar cor verde clara
                  getRowClassName={(rowParams) =>
                    getStatusFaturamento(rowParams.row) === '100% Faturado' ? 'row-locked' : ''
                  }
                  components={{
                    Pagination: () => <CustomPagination totalRegistros={totalRegistros} />,
                    LoadingOverlay: LinearProgress,
                    NoRowsOverlay: CustomNoRowsOverlay,
                  }}
                  sx={{
                    '& .MuiDataGrid-row.Mui-selected': {
                      backgroundColor: '#32ccbc !important',
                      '& .MuiDataGrid-cell': { color: '#000 !important' },
                      transition: 'background-color 0.2s ease-in-out',
                      '&:hover': { backgroundColor: '#28a89b !important' },
                    },
                    '& .MuiDataGrid-cell:focus': { outline: 'none' },
                    '& .MuiDataGrid-row.linha-diferente .MuiDataGrid-cell': {
                      backgroundColor: '#ffe0b2 !important',
                    },
                    '& .MuiDataGrid-row.linha-diferente .MuiDataGrid-cell:hover': {
                      backgroundColor: '#ffcc80 !important',
                    },
                    // Verde claro na linha inteira para "100% Faturado"
                    '& .row-locked .MuiDataGrid-cell': {
                      backgroundColor: '#d4edda !important',
                      color: '#155724',
                    },
                    '& .MuiDataGrid-columnHeaders': { backgroundColor: '#848484FF' },
                    '& .yellow-header': {
                      backgroundColor: '#ffd700 !important',
                      fontWeight: 'bold !important',
                      color: '#000 !important',
                    },
                    '& .dark-green-header': {
                      backgroundColor: '#006400 !important',
                      fontWeight: 'bold !important',
                      color: '#fff !important',
                    },
                    '& .light-green-header': {
                      backgroundColor: '#90ee90 !important',
                      fontWeight: 'bold !important',
                      color: '#000 !important',
                    },
                    '& .pink-header': {
                      backgroundColor: '#9c27b0 !important',
                      fontWeight: 'bold !important',
                      color: '#000 !important',
                    },
                    '& .default-header': {
                      backgroundColor: '#f0f0f0 !important',
                      fontWeight: 'bold !important',
                    },
                  }}
                  localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                  getRowId={(row) => row.id}
                />
              </Box>
            </div>
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
}

RelatorioEricssonFaturamento.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default RelatorioEricssonFaturamento;

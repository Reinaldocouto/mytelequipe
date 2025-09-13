import React, { useState, useEffect } from 'react';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
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
import EditIcon from '@mui/icons-material/Edit';
import PropTypes from 'prop-types';
import Typography from '@mui/material/Typography';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import { ToastContainer, toast } from 'react-toastify';
import ConfirmaModal from '../../components/modals/ConfirmacaoModal';
import exportExcel from '../../data/exportexcel/Excelexport';
import Loader from '../../layouts/loader/Loader';
import api from '../../services/api';
import Rolloutericssonedicao from '../../components/formulario/rollout/Rolloutericssonedicao';
import Excluirregistro from '../../components/Excluirregistro';
import ConfiguracaoCamposVisiveis from '../../components/modals/ConfiguracaoCamposVisiveis';
import FiltroRolloutEricsson from '../../components/modals/filtros/FiltroRolloutEricsson';

const Rolloutericsson = ({ setshow, show }) => {
  const [pageSize, setPageSize] = useState(10);
  const [loading, setLoading] = useState(false);
  const [rollout, setrollout] = useState([]);
  const [mensagem, setmensagem] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [titulo, settitulo] = useState('');
  const [show1, setshow1] = useState(false);
  const [configModalOpen, setConfigModalOpen] = useState(false);
  const [formValues, setFormValues] = useState({});
  const [rowSelectionModel, setRowSelectionModel] = useState([]);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [changedField, setChangedField] = useState();

  const [rowToUpdate, setRowToUpdate] = useState(null);
  // Estado para controlar a visibilidade dos campos
  const [fieldVisibility, setFieldVisibility] = useState({
    rfp: true,
    numero: true,
    cliente: true,
    regional: true,
    site: true,
    fornecedor: true,
    situacaoimplantacao: true,
    situacaodaintegracao: true,
    datadacriacaodademandadia: true,
    datalimiteaceitedia: true,
    dataaceitedemandadia: true,
    datainicioprevistasolicitantebaselinemosdia: true,
    datainicioentregamosplanejadodia: true,
    datarecebimentodositemosreportadodia: true,
    datafimprevistabaselinefiminstalacaodia: true,
    datafiminstalacaoplanejadodia: true,
    dataconclusaoreportadodia: true,
    datavalidacaoinstalacaodia: true,
    dataintegracaobaselinedia: true,
    dataintegracaoplanejadodia: true,
    datavalidacaoeriboxedia: true,
    listadepos: true,
    gestordeimplantacaonome: true,
    statusrsa: true,
    rsarsa: true,
    arqsvalidadapelocliente: true,
    statusaceitacao: true,
    datadefimdaaceitacaosydledia: true,
    ordemdevenda: true,
    coordenadoaspnome: true,
    rsavalidacaorsanrotrackerdatafimdia: true,
    fimdeobraplandia: true,
    fimdeobrarealdia: true,
    tipoatualizacaofam: true,
    sinergia: true,
    sinergia5g: true,
    escoponome: true,
    slapadraoescopodias: true,
    tempoparalisacaoinstalacaodias: true,
    localizacaositeendereco: true,
    localizacaositecidade: true,
    documentacaosituacao: true,
    sitepossuirisco: true,
  });

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const listarolloutericsson = async () => {
    try {
      setLoading(true);
      const response = await api.get('v1/projetoericsson', { params });
      setrollout(response.data);
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };
  const limparFiltro = () => {
    setFormValues({});
    setLoading(true);
    listarolloutericsson().finally(() => {
      setLoading(false);
    });
    toast.success('Filtros limpos com sucesso!');
    setTimeout(() => setmensagem(''), 3000); // Remove a mensagem após 3 segundos
  };
  function alterarUser(stat) {
    settitulo('Editar Rollout Ericsson');
    settelacadastroedicao(true);
    setididentificador(stat);
  }

  const [ErirssonSelecionado, setericssonSelecionado] = useState(null);

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
          name="Alterar"
          hint="Alterar"
          onClick={() => {
            alterarUser(parametros.id);
            setericssonSelecionado(parametros.row);
          }}
        />,
      ],
    },
    { field: 'rfp', headerName: 'RFP', width: 120 },
    { field: 'id', headerName: 'Número', width: 100 },
    { field: 'cliente', headerName: 'Cliente', width: 150, editable: true },
    { field: 'regiona', headerName: 'Regional', width: 150, editable: true },
    { field: 'site', headerName: 'Site', width: 150, editable: true },
    { field: 'fornecedor', headerName: 'Fornecedor', width: 150, editable: true },
    {
      field: 'situacaoimplantacao',
      headerName: 'Situação Impl.',
      width: 300,
      editable: true,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
      type: 'singleSelect',
      valueOptions: [
        { value: 'Aguardando aceite do ASP', label: 'Aguardando aceite do ASP' },
        { value: 'Aguardando agendamento Bluebee', label: 'Aguardando agendamento Bluebee' },
        { value: 'Aguardando definição de Equipe', label: 'Aguardando definição de Equipe' },
        { value: 'Cancelado', label: 'Cancelado' },
        { value: 'Concluída', label: 'Concluída' },
        { value: 'Em Aceitação', label: 'Em Aceitação' },
        { value: 'Fim do Período de Garantia', label: 'Fim do Período de Garantia' },
        { value: 'Iniciando cancelamento da Obra', label: 'Iniciando cancelamento da Obra' },
        { value: 'Obra em Andamento', label: 'Obra em Andamento' },
        { value: 'Paralisada por HSE', label: 'Paralisada por HSE' },
        { value: 'Período de Garantia', label: 'Período de Garantia' },
        { value: 'Retomada planejada', label: 'Retomada planejada' },
        { value: 'Revisar Finalização da Obra', label: 'Revisar Finalização da Obra' },
      ],
    },
    {
      field: 'situacaodaintegracao',
      headerName: 'Situação Int.',
      width: 200,
      editable: true,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
      type: 'singleSelect',
      valueOptions: ['Completa', 'Em Andamento', 'Não Iniciou'],
    },
    { field: 'outros', headerName: 'Outros', width: 150, editable: true },
    { field: 'formadeacesso', headerName: 'Forma de Acesso', width: 180, editable: true },
    { field: 'ddd', headerName: 'DDD', width: 80, editable: true },
    { field: 'municipio', headerName: 'Município', width: 200, editable: true },
    { field: 'nomeericsson', headerName: 'Nome Ericsson', width: 200, editable: true },
    { field: 'localizacaositeendereco', headerName: 'Endereço Site', width: 300, editable: true },
    {
      field: 'localizacaositecidade',
      headerName: 'Cidade Site',
      width: 300,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'datasolicitacao',
      headerName: 'Data Solicitação',
      width: 150,
      type: 'date',
      editable: true,
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    { field: 'solicitacao', headerName: 'Solicitação', width: 150, editable: true },
    { field: 'latitude', headerName: 'Latitude', width: 100, editable: true },
    { field: 'longitude', headerName: 'Longitude', width: 100, editable: true },
    { field: 'obs', headerName: 'Observação', width: 300, editable: true },
    {
      field: 'statusacesso',
      headerName: 'Status Acesso',
      width: 150,
      editable: true,
      type: 'singleSelect',
      valueOptions: ['AGUARDANDO', 'CANCELADO', 'CONCLUIDO', 'LIBERADO', 'PEDIR', 'REJEITADO'],
    },
    {
      field: 'datainicial',
      headerName: 'Data Inicial',
      width: 150,
      type: 'date',
      editable: true,
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'datafinal',
      headerName: 'Data Final',
      width: 150,
      type: 'date',
      editable: true,
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'datainicioentregamosplanejadodia',
      headerName: 'Data Início (Entrega Planejada)',
      edit: true,
      width: 250,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'datarecebimentodositemosreportadodia',
      headerName: 'Recebimento Reportado',
      width: 180,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'datadacriacaodademandadia',
      headerName: 'Data Criação Demanda',
      width: 160,
      type: 'date',
      editable: true,
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'datalimiteaceitedia',
      headerName: 'Data Limite Aceite',
      width: 160,
      type: 'date',
      editable: true,
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'dataaceitedemandadia',
      headerName: 'Data Aceite Demanda',
      width: 160,
      type: 'date',
      editable: true,
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'datainicioprevistasolicitantebaselinemosdia',
      headerName: 'Início Prev. Solicitante',
      width: 180,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'datafimprevistabaselinefiminstalacaodia',
      headerName: 'Fim Prev. Baseline Inst.',
      width: 180,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'datafiminstalacaoplanejadodia',
      headerName: 'Fim Inst. Planejada',
      width: 160,
      type: 'date',
      edit: true,
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'dataconclusaoreportadodia',
      headerName: 'Conclusão Reportada',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'datavalidacaoinstalacaodia',
      headerName: 'Validação Instalação',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'dataintegracaobaselinedia',
      headerName: 'Integração Baseline',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'dataintegracaoplanejadodia',
      headerName: 'Integração Planejada',
      width: 160,
      type: 'date',
      edit: true,
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'datavalidacaoeriboxedia',
      headerName: 'Validação Eriboxe',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    { field: 'listadepos', headerName: 'Lista de POS', width: 150 },
    { field: 'gestordeimplantacaonome', headerName: 'Gestor Impl.', width: 300 },
    { field: 'statusrsa', headerName: 'Status RSA', width: 300 },
    { field: 'rsarsa', headerName: 'RSA', width: 100 },
    { field: 'arqsvalidadapelocliente', headerName: 'Docs Validados', width: 140 },
    { field: 'statusaceitacao', headerName: 'Status Aceite', width: 140 },
    {
      field: 'datadefimdaaceitacaosydledia',
      headerName: 'Fim Aceite Sydle',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    { field: 'ordemdevenda', headerName: 'Ordem de Venda', width: 200 },
    { field: 'coordenadoaspnome', headerName: 'Coordenador ASP', width: 300 },
    {
      field: 'rsavalidacaorsanrotrackerdatafimdia',
      headerName: 'Fim Validação RSA Tracker',
      width: 200,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'fimdeobraplandia',
      headerName: 'Fim Obra Plan.',
      width: 140,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    {
      field: 'fimdeobrarealdia',
      headerName: 'Fim Obra Real',
      width: 140,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
    },
    { field: 'tipoatualizacaofam', headerName: 'Tipo Atualização FAM', width: 200 },
    { field: 'sinergia', headerName: 'Sinergia', width: 100 },
    { field: 'sinergia5g', headerName: 'Sinergia 5G', width: 100 },
    {
      field: 'escoponome',
      headerName: 'Escopo',
      width: 300,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    { field: 'slapadraoescopodias', headerName: 'SLA Padrão (dias)', width: 140 },
    { field: 'tempoparalisacaoinstalacaodias', headerName: 'Tempo Paralisação (dias)', width: 180 },
    { field: 'documentacaosituacao', headerName: 'Situação Doc.', width: 300 },
    { field: 'statusdoc', headerName: 'Status Doc', width: 150 },
    { field: 'aprovacaotodosdocs', headerName: 'Aprovação Todos Docs', width: 200 },
    { field: 'sitepossuirisco', headerName: 'Site Possui Risco', width: 150 },
  ];

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }
  const dateFields = new Set([
    // já existentes
    'ENTRGA_REQUEST',
    'ENTREGA_PLAN',
    'ENTREGA_REAL',
    'FIM_INSTALACAO_PLAN',
    'FIM_INSTALACAO_REAL',
    'INTEGRACAO_PLAN',
    'INTEGRACAO_REAL',
    'DT_PLAN',
    'DT_REAL',
    'DELIVERY_PLAN',
    'REGIONAL_LIB_SITE_P',
    'REGIONAL_LIB_SITE_R',
    'EQUIPAMENTO_ENTREGA_P',
    'REGIONAL_CARIMBO',
    'ATIVACAO_REAL',
    'DOCUMENTACAO',
    'INITIAL_TUNNING_REAL',
    'INITIAL_TUNNING_STATUS',
    'VISTORIA_PLAN',
    'VISTORIA_REAL',
    'DOCUMENTACAO_VISTORIA_PLAN',
    'DOCUMENTACAO_VISTORIA_REAL',
    'REQ',
  ]);

  const toBRDate = (v) => {
    if (!v) return v;
    // “datas nulas” → vazio
    if (/^(1899-12-(30|31)|0000-00-00)/.test(v)) return '';

    // "YYYY-MM-DD HH:MM:SS" ⇒ "YYYY-MM-DDTHH:MM:SS"
    const spaced = typeof v === 'string' && v.includes(' ') ? v.replace(' ', 'T') : v;

    const d = spaced instanceof Date ? spaced : new Date(spaced);
    if (!Number.isNaN(d.getTime())) return d.toLocaleDateString('pt-BR'); // 28/04/2025

    // dd/mm/aaaa ou dd-mm-aaaa
    const br = typeof v === 'string' && v.match(/^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$/);
    if (br) {
      const [, dd, mm, yyyy] = br;
      const normal = `${dd.padStart(2, '0')}/${mm.padStart(2, '0')}/${yyyy}`;
      if (normal === '31/12/1899' || normal === '30/12/1899') return '';
      return normal;
    }
    return v; // valor não reconhecido
  };
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
          onChange={(event, value1) => apiRef.current.setPage(value1 - 1)}
        />
      </Box>
    );
  }

  const toggle = () => {
    setshow(!show);
  };

  const toggle1 = () => {
    setshow1(!show1);
  };

  const toggleConfigModal = () => {
    setConfigModalOpen(!configModalOpen);
  };

  const iniciatabelas = () => {
    listarolloutericsson();
  };

  const chamarfiltro = () => {
    setshow1(true);
  };

  const aplicarFiltro = async () => {
    try {
      setLoading(true);

      // Preparar os parâmetros de filtro
      const filtroParams = {
        ...params, // seus parâmetros existentes
        ...formValues, // valores dos campos do formulário
      };

      // Remover campos vazios ou nulos
      Object.keys(filtroParams).forEach((key) => {
        if (
          filtroParams[key] === '' ||
          filtroParams[key] === null ||
          filtroParams[key] === undefined
        ) {
          delete filtroParams[key];
        }
      });

      const response = await api.get('v1/projetoericsson', {
        params: filtroParams,
      });

      setrollout(response.data);
      toast.success('Filtro aplicado com sucesso!');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
      toggle1(); // Fecha o modal de filtro
    }
  };
  const handleProcessRowUpdateError = (error) => {
    console.error('Erro ao salvar:', error);
    setmensagem('Erro ao salvar a edição!');
  };
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

  useEffect(() => {
    iniciatabelas();
  }, []);

  const formatDatesBR = (row) =>
    Object.fromEntries(
      Object.entries(row).map(([k, v]) => [k, dateFields.has(k) ? toBRDate(v) : v]),
    );

  const upperStrings = (row) =>
    Object.fromEntries(
      Object.entries(row).map(([k, v]) => [k, typeof v === 'string' ? v.toUpperCase() : v]),
    );
  const handleConfirmSave = async () => {
    if (!rowSelectionModel.length) {
      console.warn('Nenhuma atividade selecionada.');
      return;
    }
    console.log(rowSelectionModel);
    setLoading(true);

    try {
      // Filtra os IDs das atividades selecionadas
      // const atividadeSelecionada = totalacionamento
      //   .filter((item) => rowSelectionModel.includes(item.id))
      //   .map((item) => item.uididpmts)
      //   .join(',');
      // Espera a resposta da API
      await api.post('v1/projetoericsson/editaremmassarollout', {
        ...params,
        numeros: rowSelectionModel,
        [rowToUpdate.changedFields[0]]: rowToUpdate.newRow[rowToUpdate.changedFields[0]],
      });
      await listarolloutericsson();
      toast.success('Atualizado com sucesso');
    } catch (error) {
      console.error('Erro ao salvar alterações em massa:', error);
      toast.error('Erro ao salvar as suas alterações');
      // Opcional: mostrar feedback visual ao usuário
    } finally {
      setLoading(false);
      setConfirmOpen(false);
    }
  };

  const handleCancelSave = () => {
    console.log('Cancelado pelo usuário.');
    setConfirmOpen(false);
  };

  const gerarexcel = () => {
    const excelData = rollout
      .map((item) => ({
        RFP: item.rfp,
        NÚMERO: item.id,
        CLIENTE: item.cliente,
        REGIONAL: item.regiona,
        SITE: item.site,
        FORNECEDOR: item.fornecedor,
        'SITUAÇÃO IMPL.': item.situacaoimplantacao,
        'SITUAÇÃO INT.': item.situacaodaintegracao,
        OUTROS: item.outros,
        'FORMA DE ACESSO': item.formadeacesso,
        DDD: item.ddd,
        MUNICÍPIO: item.municipio,
        'NOME ERICSSON': item.nomeericsson,
        'ENDEREÇO SITE': item.localizacaositeendereco,
        'CIDADE SITE': item.localizacaositecidade,
        'DATA SOLICITAÇÃO': item.datasolicitacao,
        SOLICITAÇÃO: item.solicitacao,
        LATITUDE: item.latitude,
        LONGITUDE: item.longitude,
        OBSERVAÇÃO: item.obs,
        'STATUS ACESSO': item.statusacesso,
        'DATA INICIAL': item.datainicial,
        'DATA FINAL': item.datafinal,
        'DATA CRIAÇÃO DEMANDA': item.datadacriacaodademandadia,
        'DATA LIMITE ACEITE': item.datalimiteaceitedia,
        'DATA ACEITE DEMANDA': item.dataaceitedemandadia,
        'INÍCIO PREV. SOLICITANTE': item.datainicioprevistasolicitantebaselinemosdia,
        'INÍCIO ENTREGA PLANEJADA': item.datainicioentregamosplanejadodia,
        'RECEBIMENTO REPORTADO': item.datarecebimentodositemosreportadodia,
        'FIM PREV. BASELINE INST.': item.datafimprevistabaselinefiminstalacaodia,
        'FIM INST. PLANEJADA': item.datafiminstalacaoplanejadodia,
        'CONCLUSÃO REPORTADA': item.dataconclusaoreportadodia,
        'VALIDAÇÃO INSTALAÇÃO': item.datavalidacaoinstalacaodia,
        'INTEGRAÇÃO BASELINE': item.dataintegracaobaselinedia,
        'INTEGRAÇÃO PLANEJADA': item.dataintegracaoplanejadodia,
        'VALIDAÇÃO ERIBOXE': item.datavalidacaoeriboxedia,
        'LISTA DE POS': item.listadepos,
        'GESTOR IMPL.': item.gestordeimplantacaonome,
        'STATUS RSA': item.statusrsa,
        RSA: item.rsarsa,
        'DOCS VALIDADOS': item.arqsvalidadapelocliente,
        'STATUS ACEITE': item.statusaceitacao,
        'FIM ACEITE SYDLE': item.datadefimdaaceitacaosydledia,
        'ORDEM DE VENDA': item.ordemdevenda,
        'COORDENADOR ASP': item.coordenadoaspnome,
        'FIM VAL. RSA TRACKER': item.rsavalidacaorsanrotrackerdatafimdia,
        'FIM OBRA PLAN.': item.fimdeobraplandia,
        'FIM OBRA REAL': item.fimdeobrarealdia,
        'TIPO ATUALIZAÇÃO FAM': item.tipoatualizacaofam,
        SINERGIA: item.sinergia,
        'SINERGIA 5G': item.sinergia5g,
        ESCOPO: item.escoponome,
        'SLA PADRÃO (DIAS)': item.slapadraoescopodias,
        'TEMPO PARALISAÇÃO (DIAS)': item.tempoparalisacaoinstalacaodias,
        'SIT. DOC.': item.documentacaosituacao,
        'STATUS DOC': item.statusdoc,
        'APROVAÇÃO TODOS DOCS': item.aprovacaotodosdocs,
        'SITE POSSUI RISCO': item.sitepossuirisco,
      }))
      .map(formatDatesBR) // converte datas e zera 1899-12-xx
      .map(upperStrings); // caixa-alta

    exportExcel({ excelData, fileName: 'ROLLOUT ERICSSON' });
  };

  useEffect(() => {
    if (rowToUpdate) {
      setConfirmOpen(true);
    }
  }, [rowToUpdate]);

  return (
    <>
      <ConfiguracaoCamposVisiveis
        isOpen={configModalOpen}
        toggle={toggleConfigModal}
        fieldVisibility={fieldVisibility}
        setFieldVisibility={setFieldVisibility}
        LOCAL_STORAGE_KEY="rolloutericsson"
      />
      <ToastContainer
        position="top-right"
        autoClose={5000}
        hideProgressBar={false}
        newestOnTop={false}
        closeOnClick
        rtl={false}
        pauseOnFocusLoss
        draggable
        pauseOnHover
      />{' '}
      <FiltroRolloutEricsson
        show1={show1}
        toggle1={toggle1}
        toggleConfigModal={toggleConfigModal}
        fieldVisibility={fieldVisibility}
        formValues={formValues}
        setFormValues={setFormValues}
        limparFiltro={limparFiltro}
        aplicarFiltro={aplicarFiltro}
      />
      <ConfirmaModal
        open={confirmOpen}
        quantity={rowSelectionModel.length}
        onConfirm={handleConfirmSave}
        onCancel={handleCancelSave}
        campo={changedField}
      />
      <Modal
        isOpen={show}
        toggle={toggle}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-fullscreen modal-dialog-scrollable"
      >
        <ModalHeader>Rollout - Ericsson</ModalHeader>
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
              {telacadastroedicao && (
                <Rolloutericssonedicao
                  show={telacadastroedicao}
                  setshow={settelacadastroedicao}
                  ididentificador={ididentificador}
                  atualiza={listarolloutericsson}
                  ericssonSelecionado={ErirssonSelecionado}
                  titulotopo={titulo}
                />
              )}

              {telaexclusao && (
                <Excluirregistro
                  show={telaexclusao}
                  setshow={settelaexclusao}
                  ididentificador={ididentificador}
                  quemchamou="ROLLOUTERICSSON"
                  atualiza={listarolloutericsson}
                />
              )}

              <div className="row g-3">
                <div className="col-sm-3">
                  <Button color="link" onClick={gerarexcel}>
                    Exportar Excel
                  </Button>
                </div>
                <div className="col-sm-9">
                  <div className="col-sm-12 d-flex flex-row-reverse">
                    <Button color="secondary" onClick={limparFiltro}>
                      Limpar Filtros
                    </Button>
                    <div style={{ width: '10px' }}></div>
                    <Button color="primary" onClick={chamarfiltro}>
                      Aplicar Filtros
                    </Button>
                  </div>
                </div>
              </div>
              <br />
              <Box sx={{ height: '85%', width: '100%' }}>
                <DataGrid
                  rows={rollout}
                  columns={columns}
                  loading={loading}
                  pageSize={pageSize}
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  processRowUpdate={handleProcessRowUpdate}
                  onProcessRowUpdateError={handleProcessRowUpdateError}
                  rowSelectionModel={rowSelectionModel}
                  onRowSelectionModelChange={setRowSelectionModel}
                  disableSelectionOnClick
                  isRowSelectable={(rowSelectable) => rowSelectable.row.deletado !== 1}
                  checkboxSelection
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

Rolloutericsson.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Rolloutericsson;

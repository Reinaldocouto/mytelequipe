import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import {
  Button,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
  Card,
  CardBody,
  Input,
  InputGroup,
} from 'reactstrap';
import { Box, Typography } from '@mui/material';
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
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import EditIcon from '@mui/icons-material/Edit';
import { ToastContainer, toast } from 'react-toastify';
import ConfirmaModal from '../../components/modals/ConfirmacaoModal';
import exportExcel from '../../data/exportexcel/Excelexport';
import Loader from '../../layouts/loader/Loader';
import api from '../../services/api';
import Rolloutericssonedicao from '../../components/formulario/rollout/Rolloutericssonedicao';
import Excluirregistro from '../../components/Excluirregistro';
import ConfiguracaoCamposVisiveis from '../../components/modals/ConfiguracaoCamposVisiveis';
import FiltroRolloutEricsson from '../../components/modals/filtros/FiltroRolloutEricsson';
import Ericssonedicao from '../../components/formulario/projeto/Ericssonedicao';
import Notpermission from '../../layouts/notpermission/notpermission';
import modoVisualizador from '../../services/modovisualizador';
import ImportLogModal from '../../components/modals/filtros/ImportLogModalProps';

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
  const [changedField, setChangedField] = useState('');
  const [rowToUpdate, setRowToUpdate] = useState(null);
  const [ErirssonSelecionado, setericssonSelecionado] = useState(null);

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
    statusdoc: true,
    aprovacaotodosdocs: true,
    sitepossuirisco: true,
  });

  const [, setprojeto] = useState([]);
  const [, setloadingAc] = useState(false);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [ididentificadorAc,] = useState(0);
  const [telacadastroedicaoAc, settelacadastroedicaoAc] = useState('');
  const [siteAc,] = useState('');
  const [arquivoobra, setarquivoobra] = useState('');
  const [permissionAc, setpermissionAc] = useState(false);
  const [showLogModal, setShowLogModal] = useState(false);

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const paramsAc = {
    ...params,
    busca: pesqgeral,
  };

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
      <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', width: '100%', p: 1.5 }}>
        <Typography variant="body2">Total de itens: {rowCount}</Typography>
        <Pagination color="primary" count={pageCount} page={page + 1} onChange={(e, v) => apiRef.current.setPage(v - 1)} />
      </Box>
    );
  }

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
    setTimeout(() => setmensagem(''), 3000);
  };

  function alterarUser(stat) {
    settitulo('Editar Rollout Ericsson');
    settelacadastroedicao(true);
    setididentificador(stat);
  }

  const columnsRollout = [
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
          onClick={() => {
            alterarUser(parametros.id);
            setericssonSelecionado(parametros.row);
          }}
        />,
      ],
    },
    { field: 'rfp', headerName: 'RFP', width: 120, hide: !fieldVisibility.rfp },
    { field: 'id', headerName: 'Número', width: 100, hide: !fieldVisibility.numero },
    { field: 'cliente', headerName: 'Cliente', width: 150, editable: true, hide: !fieldVisibility.cliente },
    { field: 'regiona', headerName: 'Regional', width: 150, editable: true, hide: !fieldVisibility.regional },
    { field: 'site', headerName: 'Site', width: 150, editable: true, hide: !fieldVisibility.site },
    { field: 'fornecedor', headerName: 'Fornecedor', width: 150, editable: true, hide: !fieldVisibility.fornecedor },
    {
      field: 'situacaoimplantacao',
      headerName: 'Situação Impl.',
      width: 300,
      editable: true,
      hide: !fieldVisibility.situacaoimplantacao,
      renderCell: (p) => <div style={{ whiteSpace: 'pre-wrap' }}>{p.value}</div>,
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
      hide: !fieldVisibility.situacaodaintegracao,
      renderCell: (p) => <div style={{ whiteSpace: 'pre-wrap' }}>{p.value}</div>,
      type: 'singleSelect',
      valueOptions: ['Completa', 'Em Andamento', 'Não Iniciou'],
    },
    { field: 'outros', headerName: 'Outros', width: 150, editable: true },
    { field: 'formadeacesso', headerName: 'Forma de Acesso', width: 180, editable: true },
    { field: 'ddd', headerName: 'DDD', width: 80, editable: true },
    { field: 'municipio', headerName: 'Município', width: 200, editable: true },
    { field: 'nomeericsson', headerName: 'Nome Ericsson', width: 200, editable: true },
    { field: 'localizacaositeendereco', headerName: 'Endereço Site', width: 300, editable: true, hide: !fieldVisibility.localizacaositeendereco },
    { field: 'localizacaositecidade', headerName: 'Cidade Site', width: 300, renderCell: (p) => <div style={{ whiteSpace: 'pre-wrap' }}>{p.value}</div>, hide: !fieldVisibility.localizacaositecidade },
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
      width: 250,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.datainicioentregamosplanejadodia,
    },
    {
      field: 'datarecebimentodositemosreportadodia',
      headerName: 'Recebimento Reportado',
      width: 180,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.datarecebimentodositemosreportadodia,
    },
    {
      field: 'datadacriacaodademandadia',
      headerName: 'Data Criação Demanda',
      width: 160,
      type: 'date',
      editable: true,
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.datadacriacaodademandadia,
    },
    {
      field: 'datalimiteaceitedia',
      headerName: 'Data Limite Aceite',
      width: 160,
      type: 'date',
      editable: true,
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.datalimiteaceitedia,
    },
    {
      field: 'dataaceitedemandadia',
      headerName: 'Data Aceite Demanda',
      width: 160,
      type: 'date',
      editable: true,
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.dataaceitedemandadia,
    },
    {
      field: 'datainicioprevistasolicitantebaselinemosdia',
      headerName: 'Início Prev. Solicitante',
      width: 180,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.datainicioprevistasolicitantebaselinemosdia,
    },
    {
      field: 'datafimprevistabaselinefiminstalacaodia',
      headerName: 'Fim Prev. Baseline Inst.',
      width: 180,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.datafimprevistabaselinefiminstalacaodia,
    },
    {
      field: 'datafiminstalacaoplanejadodia',
      headerName: 'Fim Inst. Planejada',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.datafiminstalacaoplanejadodia,
    },
    {
      field: 'dataconclusaoreportadodia',
      headerName: 'Conclusão Reportada',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.dataconclusaoreportadodia,
    },
    {
      field: 'datavalidacaoinstalacaodia',
      headerName: 'Validação Instalação',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.datavalidacaoinstalacaodia,
    },
    {
      field: 'dataintegracaobaselinedia',
      headerName: 'Integração Baseline',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.dataintegracaobaselinedia,
    },
    {
      field: 'dataintegracaoplanejadodia',
      headerName: 'Integração Planejada',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.dataintegracaoplanejadodia,
    },
    {
      field: 'datavalidacaoeriboxedia',
      headerName: 'Validação Eriboxe',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.datavalidacaoeriboxedia,
    },
    { field: 'listadepos', headerName: 'Lista de POS', width: 150, hide: !fieldVisibility.listadepos },
    { field: 'gestordeimplantacaonome', headerName: 'Gestor Impl.', width: 300, hide: !fieldVisibility.gestordeimplantacaonome },
    { field: 'statusrsa', headerName: 'Status RSA', width: 300, hide: !fieldVisibility.statusrsa },
    { field: 'rsarsa', headerName: 'RSA', width: 100, hide: !fieldVisibility.rsarsa },
    { field: 'arqsvalidadapelocliente', headerName: 'Docs Validados', width: 140, hide: !fieldVisibility.arqsvalidadapelocliente },
    { field: 'statusaceitacao', headerName: 'Status Aceite', width: 140, hide: !fieldVisibility.statusaceitacao },
    {
      field: 'datadefimdaaceitacaosydledia',
      headerName: 'Fim Aceite Sydle',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.datadefimdaaceitacaosydledia,
    },
    { field: 'ordemdevenda', headerName: 'Ordem de Venda', width: 200, hide: !fieldVisibility.ordemdevenda },
    { field: 'coordenadoaspnome', headerName: 'Coordenador ASP', width: 300, hide: !fieldVisibility.coordenadoaspnome },
    {
      field: 'rsavalidacaorsanrotrackerdatafimdia',
      headerName: 'Fim Validação RSA Tracker',
      width: 200,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.rsavalidacaorsanrotrackerdatafimdia,
    },
    {
      field: 'fimdeobraplandia',
      headerName: 'Fim Obra Plan.',
      width: 140,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.fimdeobraplandia,
    },
    {
      field: 'fimdeobrarealdia',
      headerName: 'Fim Obra Real',
      width: 140,
      type: 'date',
      valueGetter: ({ value }) => (value ? new Date(value) : null),
      valueFormatter: ({ value }) => (value ? new Intl.DateTimeFormat('pt-BR').format(value) : ''),
      hide: !fieldVisibility.fimdeobrarealdia,
    },
    { field: 'tipoatualizacaofam', headerName: 'Tipo Atualização FAM', width: 200, hide: !fieldVisibility.tipoatualizacaofam },
    { field: 'sinergia', headerName: 'Sinergia', width: 100, hide: !fieldVisibility.sinergia },
    { field: 'sinergia5g', headerName: 'Sinergia 5G', width: 100, hide: !fieldVisibility.sinergia5g },
    { field: 'escoponome', headerName: 'Escopo', width: 300, renderCell: (p) => <div style={{ whiteSpace: 'pre-wrap' }}>{p.value}</div>, hide: !fieldVisibility.escoponome },
    { field: 'slapadraoescopodias', headerName: 'SLA Padrão (dias)', width: 140, hide: !fieldVisibility.slapadraoescopodias },
    { field: 'tempoparalisacaoinstalacaodias', headerName: 'Tempo Paralisação (dias)', width: 180, hide: !fieldVisibility.tempoparalisacaoinstalacaodias },
    { field: 'documentacaosituacao', headerName: 'Situação Doc.', width: 300, hide: !fieldVisibility.documentacaosituacao },
    { field: 'statusdoc', headerName: 'Status Doc', width: 150, hide: !fieldVisibility.statusdoc },
    { field: 'aprovacaotodosdocs', headerName: 'Aprovação Todos Docs', width: 200, hide: !fieldVisibility.aprovacaotodosdocs },
    { field: 'sitepossuirisco', headerName: 'Site Possui Risco', width: 150, hide: !fieldVisibility.sitepossuirisco },
  ];

  const handleProcessRowUpdateError = () => {
    setmensagem('Erro ao salvar a edição!');
  };

  const handleProcessRowUpdate = async (newRow, oldRow) => {
    if (rowSelectionModel.length === 0) {
      setmensagem('Selecione pelo menos um item');
      return oldRow;
    }
    const changedFields = Object.keys(newRow).filter((k) => newRow[k] !== oldRow[k] && k !== 'id');
    if (!changedFields.length) return oldRow;
    React.startTransition(() => {
      setChangedField(changedFields[0]);
      setRowToUpdate({ newRow, oldRow, changedFields });
      setConfirmOpen(true);
    });
    return newRow;
  };

  const handleConfirmSave = async () => {
    if (!rowSelectionModel.length || !rowToUpdate) return;
    setLoading(true);
    try {
      await api.post('v1/projetoericsson/editaremmassarollout', {
        ...params,
        numeros: rowSelectionModel,
        [rowToUpdate.changedFields[0]]: rowToUpdate.newRow[rowToUpdate.changedFields[0]],
      });
      await listarolloutericsson();
      toast.success('Atualizado com sucesso');
    } catch (error) {
      toast.error('Erro ao salvar as suas alterações');
    } finally {
      setLoading(false);
      setConfirmOpen(false);
      setRowToUpdate(null);
      setChangedField('');
    }
  };

  const handleCancelSave = () => {
    setConfirmOpen(false);
    setRowToUpdate(null);
    setChangedField('');
  };

  const toggleLogModal = () => setShowLogModal(!showLogModal);

  const userpermissionAc = () => {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermissionAc(permissionstorage?.ericacionamento === 1);
  };

  const listaAcionamento = async () => {
    setmensagemsucesso('');
    try {
      setloadingAc(true);
      const response = await api.get('v1/projetoericsson', { params: paramsAc });
      setprojeto(response.data);
      setpesqgeral('');
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloadingAc(false);
    }
  };

  const uploadarquivo = async (e) => {
    e.preventDefault();
    if (!arquivoobra) {
      setmensagem('Nenhum arquivo selecionado para atualizar!');
      return;
    }
    const formData = new FormData();
    formData.append('files', arquivoobra);
    const header = { headers: { 'Custom-Header': 'value' } };
    try {
      setloadingAc(true);
      const response = await api.post('v1/uploadobraericson', formData, header);
      if (response && response.data) {
        if (response.status === 200) {
          setmensagemsucesso('Upload concluído. A atualização está sendo processada.');
          setmensagem('');
        } else {
          setmensagemsucesso('');
          setmensagem('Erro ao fazer upload!');
        }
      } else {
        throw new Error('Resposta inválida do servidor');
      }
    } catch (err) {
      if (err.response) {
        setmensagem(err.message);
        setmensagemsucesso('');
      } else {
        setmensagem('Erro: Tente novamente mais tarde!');
        setmensagemsucesso('');
      }
    } finally {
      setloadingAc(false);
    }
  };

  useEffect(() => {
    listarolloutericsson();
    userpermissionAc();
  }, []);

  useEffect(() => {
    if (rowToUpdate && changedField) setConfirmOpen(true);
  }, [rowToUpdate, changedField]);

  const toggle = () => setshow(!show);
  const toggle1 = () => setshow1(!show1);
  const toggleConfigModal = () => setConfigModalOpen(!configModalOpen);
  const chamarfiltro = () => setshow1(true);

  const aplicarFiltro = async () => {
    try {
      setLoading(true);
      const filtroParams = { ...params, ...formValues };
      Object.keys(filtroParams).forEach((k) => {
        if (filtroParams[k] === '' || filtroParams[k] === null || filtroParams[k] === undefined) {
          delete filtroParams[k];
        }
      });
      const response = await api.get('v1/projetoericsson', { params: filtroParams });
      setrollout(response.data);
      toast.success('Filtro aplicado com sucesso!');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
      toggle1();
    }
  };

  return (
    <>
      <ConfiguracaoCamposVisiveis
        isOpen={configModalOpen}
        toggle={toggleConfigModal}
        fieldVisibility={fieldVisibility}
        setFieldVisibility={setFieldVisibility}
        LOCAL_STORAGE_KEY="rolloutericsson"
      />
      <ToastContainer position="top-right" autoClose={5000} hideProgressBar={false} newestOnTop={false} closeOnClick rtl={false} pauseOnFocusLoss draggable pauseOnHover />
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
      {confirmOpen && changedField && (
        <ConfirmaModal
          open={confirmOpen}
          quantity={rowSelectionModel.length}
          onConfirm={handleConfirmSave}
          onCancel={handleCancelSave}
          campo={changedField}
        />
      )}
      <Modal isOpen={show} toggle={toggle} backdrop="static" keyboard={false} className="modal-dialog modal-fullscreen modal-dialog-scrollable">
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
              {permissionAc ? (
                <Card>
                  <CardBody style={{ backgroundColor: 'white' }}>
                    {mensagem.length !== 0 ? (
                      <div className="alert alert-danger mt-2" role="alert">
                        {mensagem}
                      </div>
                    ) : null}
                    {mensagemsucesso.length > 0 ? (
                      <div className="alert alert-success" role="alert">
                        {mensagemsucesso}
                      </div>
                    ) : null}
                    {telacadastroedicaoAc ? (
                      <Ericssonedicao
                        show={telacadastroedicaoAc}
                        setshow={settelacadastroedicaoAc}
                        ididentificador={ididentificadorAc}
                        atualiza={listaAcionamento}
                        idsite={siteAc}
                      />
                    ) : null}
                    <div className="row g-3">
                      <div className="col-sm-6 d-flex align-items-center gap-2">
                        <Button color="primary" onClick={toggleLogModal}>
                          Acompanhar Importação
                        </Button>
                      </div>
                      <div className="col-sm-6">
                        Selecione o arquivo de atualização
                        <div className="d-flex flex-row-reverse custom-file">
                          <InputGroup>
                            <Input
                              type="file"
                              onChange={(e) => setarquivoobra(e.target.files[0])}
                              className="custom-file-input"
                              id="customFile3"
                              disabled={modoVisualizador()}
                            />
                            <Button
                              color="primary"
                              onClick={uploadarquivo}
                              disabled={modoVisualizador()}
                            >
                              Atualizar
                            </Button>
                          </InputGroup>
                        </div>
                      </div>
                    </div>
                  </CardBody>
                </Card>
              ) : (
                <Notpermission />
              )}
              <div className="row g-3">
                <div className="col-sm-3">
                  <Button
                    color="link"
                    onClick={() => {
                      const excelData = rollout.map((item) => ({
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
                      }));
                      exportExcel({ excelData, fileName: 'ROLLOUT ERICSSON' });
                    }}
                  >
                    Exportar Excel
                  </Button>
                </div>
                <div className="col-sm-9">
                  <div className="col-sm-12 d-flex flex-row-reverse">
                    <Button color="secondary" onClick={limparFiltro}>Limpar Filtros</Button>
                    <div style={{ width: 10 }} />
                    <Button color="primary" onClick={chamarfiltro}>Aplicar Filtros</Button>
                  </div>
                </div>
              </div>
              <br />
              <Box sx={{ height: '85%', width: '100%' }}>
                <DataGrid
                  rows={rollout}
                  columns={columnsRollout}
                  loading={loading}
                  pageSize={pageSize}
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  processRowUpdate={handleProcessRowUpdate}
                  onProcessRowUpdateError={handleProcessRowUpdateError}
                  rowSelectionModel={rowSelectionModel}
                  onRowSelectionModelChange={setRowSelectionModel}
                  disableSelectionOnClick
                  isRowSelectable={(p) => p.row.deletado !== 1}
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
      <ImportLogModal show1={showLogModal} toggle1={toggleLogModal} />
    </>
  );
};

Rolloutericsson.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Rolloutericsson;

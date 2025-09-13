import React, { useState, useEffect } from 'react';
import { Box } from '@mui/material';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
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
import { ToastContainer, toast } from 'react-toastify';
import EditIcon from '@mui/icons-material/Edit';
import AssignmentIcon from '@mui/icons-material/Assignment';
//import DeleteIcon from '@mui/icons-material/Delete';
import PropTypes from 'prop-types';
import Typography from '@mui/material/Typography';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Loader from '../../layouts/loader/Loader';
import api from '../../services/api';
import exportExcel from '../../data/exportexcel/Excelexport';
import Rollouthuaweiedicao from '../../components/formulario/rollout/Rollouthuaweiedicao';
import Excluirregistro from '../../components/Excluirregistro';
import Telat2editar from '../../components/formulario/projeto/Telat2editar';
import FiltroRolloutHuawei from '../../components/modals/filtros/FiltroRolloutHuawei';
import ConfirmaModal from '../../components/modals/ConfirmacaoModal';

const Rollouthuawei = ({ setshow, show }) => {
  const [pageSize, setPageSize] = useState(10);
  const [loading, setLoading] = useState(false);
  const [totalacionamento, settotalacionamento] = useState([]);
  const [mensagem, setmensagem] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telacadastrot2edicao, settelacadastrot2edicao] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [titulo, settitulo] = useState('');
  const [titulot2, settitulot2] = useState('');
  const [pmuf, setpmuf] = useState('');
  const [idr, setidr] = useState('');
  const [idpmtslocal, setidpmtslocal] = useState('');
  const [show1, setshow1] = useState(false);
  const [idobra, setidobra] = useState('');
  const [formValues, setFormValues] = useState({});
  const [confirmDialogOpen, setConfirmDialogOpen] = useState(false);
  const [rowSelectionModel, setRowSelectionModel] = useState([]);
  const [rowToUpdate, setRowToUpdate] = useState(null);
  const [pessoas, setPessoas] = useState([]);
  const [empresas, setEmpresas] = useState([]);
  const [changedField, setChangedField] = useState();

  const [paginationModel, setPaginationModel] = useState({
    pageSize: 100,
    page: 0,
  });

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const listarollouthuawei = async () => {
    try {
      setLoading(true);
      const response = await api.get('v1/rollouthuawei', { params });
      settotalacionamento(response.data);
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleCellEditCommit = async (paramshandleCellEditCommit) => {
    const { id, field, value } = paramshandleCellEditCommit;
    setChangedField({ id, field, value });
    setConfirmDialogOpen(true);
  };

  const handleConfirmEdit = async () => {
    if (!rowSelectionModel.length) {
      toast.warning('Nenhuma atividade selecionada.');
      return;
    }

    try {
      setLoading(true);

      // IDs selecionados
      const idsSelecionados = totalacionamento
        .filter((item) => rowSelectionModel.includes(item.id))
        .map((item) => item.id)
        .join(',');

      if (!idsSelecionados) {
        toast.error('Registro não encontrado!');
        return;
      }

      // Monta payload (JSON esperado pelo backend Delphi)
      const updatedRow = {
        id: idsSelecionados,
        [rowToUpdate.changedFields[0]]: rowToUpdate.newRow[rowToUpdate.changedFields[0]],
      };

      // Atualiza no backend
      await api.post('v1/rollouthuawei/editaremmassa', updatedRow);

      // Atualiza localmente (só os selecionados)
      const updatedRows = totalacionamento.map((r) =>
        rowSelectionModel.includes(r.id)
          ? {
              ...r,
              [rowToUpdate.changedFields[0]]: rowToUpdate.newRow[rowToUpdate.changedFields[0]],
            }
          : r,
      );

      settotalacionamento(updatedRows);

      toast.success('Registro atualizado com sucesso!');
    } catch (err) {
      console.error('Erro ao atualizar:', err);
      setmensagem(err.message || 'Erro ao atualizar o registro');
      toast.error('Erro ao atualizar o registro!');
    } finally {
      setLoading(false);
      setConfirmDialogOpen(false);
    }
  };

  const handleCancelEdit = () => {
    // Fecha o diálogo e limpa as informações de edição
    setConfirmDialogOpen(false);
    // Notifica o usuário
    toast.info('Edição cancelada');
    // Recarrega os dados para reverter a edição
    listarollouthuawei();
  };
  const listaempresa = async () => {
    try {
      setLoading(true);
      await api.get('/v1/empresas', { params }).then((response) => {
        const empresasName = response.data.map((item) => item.nome);
        setEmpresas(empresasName);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };
  const listapessoas = async () => {
    try {
      await api.get('/v1/pessoa', { params }).then((response) => {
        console.log(setPessoas);
        const pessoasName = response.data.map((item) => item.nome);
        setPessoas(pessoasName);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      console.log('');
    }
  };

  function alterarUser(stat, pmuflocal, idrlocal, ipmts) {
    settitulo('Editar Rollout Huawei');
    setididentificador(stat);
    setpmuf(pmuflocal);
    setidr(idrlocal);
    settelacadastroedicao(true);
    setidpmtslocal(ipmts);
    console.log(ipmts);
    console.log(stat);
  }

  function t2editar(stat, pmuflocal, idrlocal, ipmts) {
    setididentificador(stat);
    setpmuf(pmuflocal);
    setidr(idrlocal);
    settelacadastrot2edicao(true);
    setidpmtslocal(ipmts);
    settitulot2(`T2 - ${ipmts}`);
    setidobra(stat);
  }

  const [HuaweiSelecionado, sethuaweiSelecionado] = useState(null);
  const [selectionModel, setSelectionModel] = useState([]);

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (rowData) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          onClick={() => {
            alterarUser(
              rowData.row.id,
              rowData.row.projeto,
              rowData.row.siteCode,
              rowData.row.siteId,
            );
            sethuaweiSelecionado(rowData.row);
          }}
        />,
        <GridActionsCellItem
          icon={<AssignmentIcon />}
          label="T2"
          onClick={() =>
            t2editar(rowData.row.id, rowData.row.projeto, rowData.row.siteCode, rowData.row.siteId)
          }
        />,
      ],
    },

    { field: 'name', headerName: 'Name', width: 200, editable: true },
    {
      field: 'projeto',
      headerName: 'Projeto',
      width: 200,
      editable: true,
      type: 'singleSelect',
      valueOptions: ['Tim WL SP', 'Tim WL Adicional'],
    },
    { field: 'endSite', headerName: 'End Site', width: 200, editable: true },
    { field: 'du', headerName: 'DU', width: 120, editable: true },
    {
      field: 'statusGeral',
      headerName: 'Status Geral',
      width: 150,
      editable: true,
      type: 'singleSelect',
      valueOptions: [
        'QC Andamento',
        'Instalação em andamento',
        'DU via exceptuon',
        'Finalizado',
        'Cancelado',
        'Instalação paralisada',
        'Zeladoria',
        'QC Paralizado',
        'Acesso bloqueado',
        'Instalação paralizada',
        'Material devolvido',
        'Programar MOS',
        'Aguardando MOS',
        'Planejado',
        'QC pendente Huawei',
        'QC Paralisado',
      ],
    },
    {
      field: 'liderResponsavel',
      headerName: 'Líder Responsável',
      width: 200,
      editable: true,
      type: 'singleSelect',
      valueOptions: pessoas,
    }, // Cadastro de Pessoas
    {
      field: 'empresa',
      headerName: 'Empresa',
      width: 150,
      editable: true,
      type: 'singleSelect',
      valueOptions: empresas,
    }, // Cadastro de Empresas
    {
      field: 'ativoNoPeriodo',
      headerName: 'Ativo no Período',
      width: 150,
      editable: true,
      type: 'singleSelect',
      valueOptions: ['Aguardando', 'Ativo', 'Inativo', 'Cancelado'],
    },
    {
      field: 'fechamento',
      headerName: 'Fechamento',
      width: 160,
      editable: true,
      type: 'singleSelect',
      valueOptions: ['TLQP', 'Sim', 'Não', 'Cancelado'],
    },
    {
      field: 'anoSemanaFechamento',
      headerName: 'Ano/Semana Fechamento',
      width: 180,
      editable: true,
    },
    {
      field: 'confirmacaoPagamento',
      headerName: 'Confirmação Pagamento',
      width: 180,
      editable: true,
      type: 'singleSelect',
      valueOptions: ['Pendente', 'Aguardando PO', 'Pago', 'TLQP', 'Cancelado'],
    },
    { field: 'descricaoAdd', headerName: 'Descrição Adicional', width: 250, editable: true },
    { field: 'numeroVo', headerName: 'N° VO', width: 120, editable: true },
    {
      field: 'infra',
      headerName: 'Infra',
      width: 120,
      editable: true,
      type: 'singleSelect',
      valueOptions: ['BioSite', "Caixa D'Água", 'Greenfield', 'Rooftop', 'Indoor', 'Totem'],
    },
    { field: 'town', headerName: 'Town', width: 150, editable: true },
    { field: 'latitude', headerName: 'Latitude', width: 120, editable: true },
    { field: 'longitude', headerName: 'Longitude', width: 120, editable: true },
    { field: 'reg', headerName: 'Reg', width: 100, editable: true },
    { field: 'ddd', headerName: 'DDD', width: 80, editable: true },

    // MOS
    {
      field: 'envioDaDemanda',
      headerName: 'Envio da Demanda',
      type: 'date',
      width: 160,
      valueGetter: (cell) => (cell.value ? new Date(cell.value) : null),
    },
    {
      field: 'mosPlanned',
      headerName: 'MOS Planned',
      type: 'date',
      width: 160,
      valueGetter: (cell) => (cell.value ? new Date(cell.value) : null),
    },
    {
      field: 'mosReal',
      headerName: 'MOS Real',
      type: 'date',
      width: 160,
      valueGetter: (cell) => (cell.value ? new Date(cell.value) : null),
    },
    { field: 'semanaMos', headerName: 'Semana MOS', width: 150, editable: true },
    {
      field: 'mosStatus',
      headerName: 'MOS Status',
      width: 150,
      editable: true,
      type: 'singleSelect',
      valueOptions: ['Finalizado', 'Cancelado', 'Pendente'],
    },

    // Integração
    {
      field: 'integrationPlanned',
      headerName: 'Integration Planned',
      type: 'date',
      width: 180,
      valueGetter: (cell) => (cell.value ? new Date(cell.value) : null),
    },
    {
      field: 'testeTx',
      headerName: 'Teste TX',
      width: 150,
      editable: true,
      type: 'singleSelect',
      valueOptions: ['NOK', 'OK', 'CA', 'S/TX'],
    },
    {
      field: 'integrationReal',
      headerName: 'Integration Real',
      type: 'date',
      width: 180,
      valueGetter: (cell) => (cell.value ? new Date(cell.value) : null),
    },
    { field: 'semanaIntegration', headerName: 'Semana Integration', width: 180, editable: true },
    {
      field: 'statusIntegracao',
      headerName: 'Status Integração',
      width: 180,
      editable: true,
      type: 'singleSelect',
      valueOptions: ['Finalizado', 'Pendente', 'Cancelado', 'Sem TX'],
    },
    {
      field: 'iti',
      headerName: 'ITI',
      width: 150,
      editable: true,
      type: 'singleSelect',
      valueOptions: ['NOK', 'OK', 'CA', 'S/TX', 'Licença'],
    },

    // QC
    {
      field: 'qcPlanned',
      headerName: 'QC Planned',
      type: 'date',
      width: 160,
      valueGetter: (cell) => (cell.value ? new Date(cell.value) : null),
    },
    {
      field: 'qcReal',
      headerName: 'QC Real',
      type: 'date',
      width: 160,
      valueGetter: (cell) => (cell.value ? new Date(cell.value) : null),
    },
    { field: 'semanaQc', headerName: 'Semana QC', width: 150, editable: true },
    {
      field: 'qcStatus',
      headerName: 'QC Status',
      width: 150,
      editable: true,
      type: 'singleSelect',
      valueOptions: ['Pendente', 'QC vinculado', 'Finalizado', 'Cancelado', 'Pendente Huawei'],
    },

    { field: 'observacao', headerName: 'Observação', width: 250, editable: true },
    {
      field: 'logisticaReversaStatus',
      headerName: 'Logística Reversa Status',
      width: 200,
      editable: true,
      type: 'singleSelect',
      valueOptions: [
        'Vandalizado',
        'Pendente',
        'Respon. Huawei',
        'Cancelado',
        'Finalizado',
        'Site novo',
        'S/ Coleta',
      ],
    },
    { field: 'detentora', headerName: 'Detentora', width: 150, editable: true },
    { field: 'idDetentora', headerName: 'ID Detentora', width: 150, editable: true },
    { field: 'formaDeAcesso', headerName: 'Forma de Acesso', width: 180, editable: true },
    {
      field: 'faturamento',
      headerName: 'Faturamento',
      width: 150,
      editable: true,
      type: 'singleSelect',
      valueOptions: ['Pendente PO', 'Retido', 'OK', 'Cancelado'],
    },
    {
      field: 'faturamentoStatus',
      headerName: 'Faturamento Status',
      width: 180,
      editable: true,
      type: 'singleSelect',
      valueOptions: ['Não faturar', 'Pendente', 'Cancelado', 'Finalizado', 'Parcial'],
    },

    // Identificadores e projeto
    { field: 'changeHistory', headerName: 'Change History', width: 200, editable: true },
    { field: 'repOffice', headerName: 'Rep Office', width: 180, editable: true },
    { field: 'projectCode', headerName: 'Project Code', width: 150, editable: true },
    { field: 'siteCode', headerName: 'Site Code', width: 150, editable: true },
    { field: 'siteName', headerName: 'Site Name', width: 200, editable: true },
    { field: 'siteId', headerName: 'Site ID', width: 150, editable: true },
    { field: 'subContractNo', headerName: 'Sub Contract NO.', width: 200, editable: true },
    { field: 'prNo', headerName: 'PR NO.', width: 120, editable: true },
    { field: 'poNo', headerName: 'PO NO.', width: 120, editable: true },
    { field: 'poLineNo', headerName: 'PO Line NO.', width: 150, editable: true },
    { field: 'shipmentNo', headerName: 'Shipment NO.', width: 150, editable: true },
    { field: 'itemCode', headerName: 'Item Code', width: 120, editable: true },
    { field: 'itemDescription', headerName: 'Item Description', width: 250, editable: true },
    {
      field: 'itemDescriptionLocal',
      headerName: 'Item Description (Local)',
      width: 250,
      editable: true,
    },
    { field: 'unitPrice', headerName: 'Unit Price', type: 'number', width: 150, editable: true },
    {
      field: 'requestedQty',
      headerName: 'Requested Qty',
      type: 'number',
      width: 150,
      editable: true,
    },
    {
      field: 'valorTelequipe',
      headerName: 'Valor Telequipe',
      type: 'number',
      width: 180,
      editable: true,
    },
    {
      field: 'valorEquipe',
      headerName: 'Valor Equipe',
      type: 'number',
      width: 180,
      editable: true,
    },
    {
      field: 'billedQuantity',
      headerName: 'Billed Quantity',
      type: 'number',
      width: 180,
      editable: true,
    },
    {
      field: 'quantityCancel',
      headerName: 'Quantity Cancel',
      type: 'number',
      width: 180,
      editable: true,
    },
    { field: 'dueQty', headerName: 'Due Qty', type: 'number', width: 150, editable: true },
    { field: 'noteToReceiver', headerName: 'Note to Receiver', width: 250, editable: true },
    { field: 'fobLookupCode', headerName: 'Fob Lookup Code', width: 180, editable: true },

    {
      field: 'acceptanceDate',
      headerName: 'Acceptance Date',
      type: 'date',
      width: 180,
      valueGetter: (cell) => (cell.value ? new Date(cell.value) : null),
    },
    {
      field: 'prPoAutomationSolutionOnlyChina',
      headerName: 'PR/PO Automation Solution (Only China)',
      width: 250,
      editable: true,
    },
    { field: 'pessoa', headerName: 'Pessoa', width: 180, editable: true },
    {
      field: 'ultimaAtualizacao',
      headerName: 'Última Atualização',
      type: 'dateTime',
      width: 200,
      valueGetter: (cell) => (cell.value ? new Date(cell.value) : null),
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

  const toggle1 = () => {
    setshow1(!show1);
  };

  const iniciatabelas = () => {
    listarollouthuawei();
    listaempresa();
    listapessoas();
  };

  const chamarfiltro = () => {
    setshow1(true);
  };

  useEffect(() => {
    iniciatabelas();
  }, []);

  /* ---------- helpers -------------------------------------------------- */
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

  const formatDatesBR = (row) =>
    Object.fromEntries(
      Object.entries(row).map(([k, v]) => [k, dateFields.has(k) ? toBRDate(v) : v]),
    );

  const upperStrings = (row) =>
    Object.fromEntries(
      Object.entries(row).map(([k, v]) => [k, typeof v === 'string' ? v.toUpperCase() : v]),
    );

  /* ---------- função principal ---------------------------------------- */
  const gerarexcel = () => {
    const excelData = totalacionamento
      .map((item) => ({
        ID: item.id,
        NAME: item.name,
        PROJETO: item.projeto,
        'END SITE': item.endSite,
        DU: item.du,
        'STATUS GERAL': item.statusGeral,
        'LÍDER RESPONSÁVEL': item.liderResponsavel,
        EMPRESA: item.empresa,
        'ATIVO NO PERÍODO': item.ativoNoPeriodo,

        FECHAMENTO: item.fechamento,
        'ANO/SEMANA FECHAMENTO': item.anoSemanaFechamento,
        'CONFIRMAÇÃO PAGAMENTO': item.confirmacaoPagamento,
        'DESCRIÇÃO ADD': item.descricaoAdd,
        'N° VO': item.numeroVo,
        INFRA: item.infra,
        TOWN: item.town,
        LATITUDE: item.latitude,
        LONGITUDE: item.longitude,
        REG: item.reg,
        DDD: item.ddd,

        'ENVIO DA DEMANDA': item.envioDaDemanda,
        'MOS PLANNED': item.mosPlanned,
        'MOS REAL': item.mosReal,
        'SEMANA MOS': item.semanaMos,
        'MOS STATUS': item.mosStatus,

        'INTEGRATION PLANNED': item.integrationPlanned,
        'TESTE TX': item.testeTx,
        'INTEGRATION REAL': item.integrationReal,
        'SEMANA INTEGRATION': item.semanaIntegration,
        'STATUS INTEGRAÇÃO': item.statusIntegracao,

        ITI: item.iti,
        'QC PLANNED': item.qcPlanned,
        'QC REAL': item.qcReal,
        'SEMANA QC': item.semanaQc,
        'QC STATUS': item.qcStatus,

        OBSERVAÇÃO: item.observacao,
        'LOGÍSTICA REVERSA STATUS': item.logisticaReversaStatus,
        DETENTORA: item.detentora,
        'ID DETENTORA': item.idDententora,
        'FORMA DE ACESSO': item.formaDeAcesso,

        FATURAMENTO: item.faturamento,
        'FATURAMENTO STATUS': item.faturamentoStatus,
        'ID ORIGINAL': item.idOriginal,
        'CHANGE HISTORY': item.changeHistory,
        'REP OFFICE': item.repOffice,
        'PROJECT CODE': item.projectCode,
        'SITE CODE': item.siteCode,
        'SITE NAME': item.siteName,
        'SITE ID': item.siteId,
        'SUB CONTRACT NO.': item.subContractNo,
        'PR NO.': item.prNo,
        'PO NO.': item.poNo,
        'PO LINE NO.': item.poLineNo,
        'SHIPMENT NO.': item.shipmentNo,
        'ITEM CODE': item.itemCode,
        'ITEM DESCRIPTION': item.itemDescription,
        'ITEM DESCRIPTION LOCAL': item.itemDescriptionLocal,
        'UNIT PRICE': item.unitPrice,
        'REQUESTED QTY': item.requestedQty,
        'VALOR TELEQUIPE': item.valorTelequipe,
        'VALOR EQUIPE': item.valorEquipe,
        'BILLED QUANTITY': item.billedQuantity,
        'QUANTITY CANCEL': item.quantityCancel,
        'DUE QTY': item.dueQty,
        'NOTE TO RECEIVER': item.noteToReceiver,
        'FOB LOOKUP CODE': item.fobLookupCode,
        'ACCEPTANCE DATE': item.acceptanceDate,
        'PR/PO AUTOMATION SOLUTION (ONLY CHINA)': item.prPoAutomationSolutionOnlyChina,

        PESSOA: item.pessoa,
        'ÚLTIMA ATUALIZAÇÃO': item.ultimaAtualizacao,
      }))
      .map(formatDatesBR) // converte datas para dd/MM/yyyy
      .map(upperStrings); // caixa-alta

    exportExcel({ excelData, fileName: 'ROLLOUT HUAWEI' });
  };
  const handleProcessRowUpdateError = (error) => {
    console.error('Erro ao salvar:', error);
    setmensagem('Erro ao salvar a edição!');
  };
  const limparFiltro = () => {
    setFormValues({});
    setLoading(true);
    // listarolloutericsson().finally(() => {
    //   setLoading(false);
    // });
    toast.success('Filtros limpos com sucesso!');
    setTimeout(() => setmensagem(''), 3000); // Remove a mensagem após 3 segundos
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
      setConfirmDialogOpen(true);
    });

    return newRow;
  };

  useEffect(() => {
    if (rowToUpdate) {
      setConfirmDialogOpen(true);
    }
  }, [rowToUpdate]);

  const aplicarFiltro = async () => {
    try {
      setLoading(true);
      const filtroParams = {
        ...params, // seus parâmetros existentes
        ...formValues, // valores dos campos do formulário
      };
      Object.keys(filtroParams).forEach((key) => {
        if (
          filtroParams[key] === '' ||
          filtroParams[key] === null ||
          filtroParams[key] === undefined
        ) {
          delete filtroParams[key];
        }
      });

      const response = await api.get('v1/rollouthuawei', {
        params: filtroParams,
      });

      settotalacionamento(response.data);
      toast.success('Filtro aplicado com sucesso!');
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
      toggle1();
    }
  };

  return (
    <>
      <ConfirmaModal
        open={confirmDialogOpen}
        quantity={rowSelectionModel.length}
        onConfirm={handleConfirmEdit}
        onCancel={handleCancelEdit}
        campo={changedField}
      />
      {show1 && (
        <FiltroRolloutHuawei
          show1={show1}
          toggle1={toggle1}
          formValues={formValues}
          setFormValues={setFormValues}
          limparFiltro={limparFiltro}
          aplicarFiltro={aplicarFiltro}
          pessoas={pessoas}
          empresas={empresas}
        />
      )}
      <Modal
        isOpen={show}
        toggle={toggle}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-fullscreen modal-dialog-scrollable"
      >
        <ModalHeader>Rollout - Huawei</ModalHeader>
        <ModalBody>
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
          />
          {mensagem.length > 0 ? (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          ) : null}
          {loading ? (
            <Loader />
          ) : (
            <>
              {telacadastroedicao ? (
                <>
                  {' '}
                  <Rollouthuaweiedicao
                    show={telacadastroedicao}
                    setshow={settelacadastroedicao}
                    ididentificador={ididentificador}
                    atualiza={listarollouthuawei}
                    huaweiSelecionado={HuaweiSelecionado}
                    //pmuf={pmuf}
                    titulotopo={titulo}
                    idr={idr}
                    //idpmtslocal={idpmtslocal}
                  />{' '}
                </>
              ) : null}

              {telacadastrot2edicao ? (
                <>
                  {' '}
                  <Telat2editar
                    show={telacadastrot2edicao}
                    setshow={settelacadastrot2edicao}
                    ididentificador={ididentificador}
                    atualiza={listarollouthuawei}
                    pmuf={pmuf}
                    titulo={titulot2}
                    idr={idr}
                    idobra={idobra}
                    idpmtslocal={idpmtslocal}
                  />{' '}
                </>
              ) : null}

              {telaexclusao ? (
                <>
                  <Excluirregistro
                    show={telaexclusao}
                    setshow={settelaexclusao}
                    ididentificador={ididentificador}
                    quemchamou="ROLLOUTHUAWEI"
                    atualiza={listarollouthuawei}
                  />{' '}
                </>
              ) : null}

              <div className="row g-3">
                <div className="col-sm-3">
                  <Button color="link" onClick={gerarexcel}>
                    Exportar Excel
                  </Button>
                </div>
                <div className="col-sm-9">
                  <div className=" col-sm-12 d-flex flex-row-reverse">
                    <Button color="primary" onClick={chamarfiltro}>
                      Aplicar Filtros
                    </Button>
                  </div>
                </div>
              </div>
              <br />
              <Box sx={{ height: '85%', width: '100%' }}>
                <DataGrid
                  rows={totalacionamento}
                  columns={columns}
                  loading={loading}
                  pageSize={pageSize}
                  checkboxSelection
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  disableSelectionOnClick
                  processRowUpdate={handleProcessRowUpdate}
                  onProcessRowUpdateError={handleProcessRowUpdateError}
                  rowSelectionModel={rowSelectionModel}
                  onRowSelectionModelChange={setRowSelectionModel}
                  onCellEditCommit={handleCellEditCommit}
                  editMode="cell"
                  onSelectionModelChange={(newSelectionModel) => {
                    if (newSelectionModel.length > 0) {
                      const selectedRow = totalacionamento.find(
                        (row) => row.id === newSelectionModel[0],
                      );
                      if (selectedRow) {
                        sethuaweiSelecionado(selectedRow);
                        setididentificador(selectedRow.id);
                        setpmuf(selectedRow.projeto);
                        setidr(selectedRow.siteCode);
                        setidpmtslocal(selectedRow.siteId);
                      }
                    }
                    setSelectionModel(newSelectionModel);
                  }}
                  selectionModel={selectionModel}
                  components={{
                    Pagination: CustomPagination,
                    LoadingOverlay: LinearProgress,
                    NoRowsOverlay: CustomNoRowsOverlay,
                  }}
                  localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                  paginationModel={paginationModel}
                  onPaginationModelChange={setPaginationModel}
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

Rollouthuawei.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Rollouthuawei;

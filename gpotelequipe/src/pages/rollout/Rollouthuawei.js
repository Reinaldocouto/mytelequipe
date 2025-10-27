import React, { useState, useEffect, useMemo, useCallback } from 'react';
import { Box, CircularProgress, Alert } from '@mui/material';
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
import PropTypes from 'prop-types';
import Typography from '@mui/material/Typography';
import Pagination from '@mui/material/Pagination';
import createLocalDate from '../../services/data';
import api from '../../services/api';
import exportExcel from '../../data/exportexcel/Excelexport';
import Rollouthuaweiedicao from '../../components/formulario/rollout/Rollouthuaweiedicao';
import Excluirregistro from '../../components/Excluirregistro';
import Telat2editar from '../../components/formulario/projeto/Telat2editar';
import FiltroRolloutHuawei from '../../components/modals/filtros/FiltroRolloutHuawei';
import ConfirmaModal from '../../components/modals/ConfirmacaoModal';
import Loader from '../../layouts/loader/Loader';

const Rollouthuawei = ({ setshow, show }) => {
  const [pageSize, setPageSize] = useState(100);
  const [loading, setLoading] = useState(true);
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
  const [idobra, setidobra] = useState('');
  const [HuaweiSelecionado, sethuaweiSelecionado] = useState(null);
  const [show1, setshow1] = useState(false);
  const [formValues, setFormValues] = useState({});
  const [confirmDialogOpen, setConfirmDialogOpen] = useState(false);
  const [rowSelectionModel, setRowSelectionModel] = useState([]);
  const [rowToUpdate, setRowToUpdate] = useState(null);
  const [pessoas, setPessoas] = useState([]);
  const [empresas, setEmpresas] = useState([]);
  const [changedField, setChangedField] = useState();
  const [paginationModel, setPaginationModel] = useState({ pageSize: 100, page: 0 });

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
      toast.error(`Erro ao carregar dados: ${err.message}`);
    } finally {
      setLoading(false);
    }
  };

  const handleCellEditCommit = async ({ id, field, value }) => {
    setChangedField({ id, field, value });
    setConfirmDialogOpen(true);
  };

  const rowsById = useMemo(
    () => new Map(totalacionamento.map((r) => [r.idgeral, r])),
    [totalacionamento]
  );

  const handleConfirmEdit = async () => {
    if (!rowSelectionModel.length) {
      toast.warning('Nenhuma atividade selecionada.');
      return;
    }
    if (!rowToUpdate || !rowToUpdate.changedFields?.length) {
      toast.warning('Nenhuma alteração detectada.');
      setConfirmDialogOpen(false);
      return;
    }

    try {
      setLoading(true);

      const idsSelecionados = rowSelectionModel
        .map((rid) => rowsById.get(rid)?.id)
        .filter((v) => v != null && v !== '')
        .join(',');

      if (!idsSelecionados) {
        toast.error('Registro não encontrado!');
        return;
      }

      const campo = rowToUpdate.changedFields[0];
      const row = rowToUpdate.newRow;

      let campoFinal = campo;
      let valorFinal = row[campo];

      if (campo === 'ddd' || campo === 'latitude' || campo === 'longitude') {
        valorFinal = row[`${campo}1`] ?? row[campo];
      }
      if (campo === 'ddd1') { campoFinal = 'ddd'; valorFinal = row.ddd1; }
      if (campo === 'latitude1') { campoFinal = 'latitude'; valorFinal = row.latitude1; }
      if (campo === 'longitude1') { campoFinal = 'longitude'; valorFinal = row.longitude1; }

      await api.post('v1/rollouthuawei/editaremmassa', {
        id: idsSelecionados,
        [campoFinal]: valorFinal,
      });

      const filtroParams = { ...params, ...formValues };
      Object.keys(filtroParams).forEach((k) => {
        if (filtroParams[k] == null || filtroParams[k] === '') delete filtroParams[k];
      });

      const response = await api.get('v1/rollouthuawei', { params: filtroParams });
      settotalacionamento(response.data);
      toast.success('Registro atualizado com sucesso!');
    } catch (err) {
      setmensagem(err.message || 'Erro ao atualizar o registro');
      toast.error('Erro ao atualizar o registro!');
    } finally {
      setLoading(false);
      setConfirmDialogOpen(false);
      setRowToUpdate(null);
    }
  };

  const handleCancelEdit = () => {
    setConfirmDialogOpen(false);
    toast.info('Edição cancelada');
    listarollouthuawei();
  };

  const listaempresa = async () => {
    try {
      const response = await api.get('/v1/empresas', { params });
      setEmpresas(response.data.map((i) => i.nome));
    } catch (err) {
      setmensagem(err.message);
      toast.error(`Erro ao carregar empresas: ${err.message}`);
    }
  };

  const listapessoas = async () => {
    try {
      const response = await api.get('/v1/pessoa', { params });
      setPessoas(response.data.map((i) => i.nome));
    } catch (err) {
      setmensagem(err.message);
      toast.error(`Erro ao carregar pessoas: ${err.message}`);
    }
  };

  function alterarUser(stat, pmuflocal, idrlocal, ipmts) {
    settitulo('Editar Rollout Huawei');
    setididentificador(stat);
    setpmuf(pmuflocal);
    setidr(idrlocal);
    settelacadastroedicao(true);
    setidpmtslocal(ipmts);
  }

  const t2editar = useCallback((stat, pmuflocal, idrlocal, ipmts) => {
    setididentificador(stat);
    setpmuf(pmuflocal);
    setidr(idrlocal);
    settelacadastrot2edicao(true);
    setidpmtslocal(ipmts);
    settitulot2(`T2 - ${ipmts}`);
    setidobra(stat);
  }, []);

  const handleRowSelectionChange = useCallback(
    (newSelectionModel) => {
      if (newSelectionModel.length > 0) {
        const selectedRow = rowsById.get(newSelectionModel[0]);
        if (selectedRow) {
          sethuaweiSelecionado(selectedRow);
          setididentificador(selectedRow.idgeral);
          setpmuf(selectedRow.projeto);
          setidr(selectedRow.siteCode);
          setidpmtslocal(selectedRow.siteId);
        }
      }
      setRowSelectionModel(newSelectionModel);
    },
    [rowsById]
  );

  const accessFields = useMemo(
    () => [
      'ddd',
      'municipio',
      'idoutros',
      'endereco',
      'latitude',
      'longitude',
      'datasolicitado',
      'datainicio',
      'datafim',
      'tipoinfra',
      'quadrante',
      'detentorarea',
      'iddetentora',
      'formaacesso',
      'observacaoacesso',
      'statusacesso',
      'numerosolicitacao',
      'tratativaacessos',
      'duid',
      'duname',
      'statusatt',
      'metaplan',
      'atividadeescopo',
      'acionamentosrecentes',
      'regiao',
      'acessoequipenomes',
    ],
    []
  );

  const columns = useMemo(
    () => [
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
                rowData.row.siteId
              );
              sethuaweiSelecionado(rowData.row);
            }}
          />,
          <GridActionsCellItem
            icon={<AssignmentIcon />}
            label="T2"
            onClick={() =>
              t2editar(
                rowData.row.id,
                rowData.row.projeto,
                rowData.row.siteCode,
                rowData.row.siteId
              )
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
      { field: 'du', headerName: 'DU', width: 250, editable: true },

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
      },

      {
        field: 'empresa',
        headerName: 'Empresa',
        width: 150,
        editable: true,
        type: 'singleSelect',
        valueOptions: empresas,
      },

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

      { field: 'anoSemanaFechamento', headerName: 'Ano/Semana Fechamento', width: 180, editable: true },

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
      { field: 'reg', headerName: 'Reg', width: 100, editable: true },

      {
        field: 'envioDaDemanda',
        headerName: 'Envio da Demanda',
        type: 'date',
        width: 160,
        valueGetter: (c) => (c.value ? createLocalDate(c.value) : null),
      },

      {
        field: 'mosPlanned',
        headerName: 'MOS Planned',
        type: 'date',
        width: 160,
        valueGetter: (c) => (c.value ? createLocalDate(c.value) : null),
      },

      {
        field: 'mosReal',
        headerName: 'MOS Real',
        type: 'date',
        width: 160,
        valueGetter: (c) => (c.value ? createLocalDate(c.value) : null),
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

      {
        field: 'integrationPlanned',
        headerName: 'Integration Planned',
        type: 'date',
        width: 180,
        valueGetter: (c) => (c.value ? createLocalDate(c.value) : null),
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
        valueGetter: (c) => (c.value ? createLocalDate(c.value) : null),
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

      {
        field: 'qcPlanned',
        headerName: 'QC Planned',
        type: 'date',
        width: 160,
        valueGetter: (c) => (c.value ? createLocalDate(c.value) : null),
      },

      {
        field: 'qcReal',
        headerName: 'QC Real',
        type: 'date',
        width: 160,
        valueGetter: (c) => (c.value ? createLocalDate(c.value) : null),
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
        valueOptions: ['Vandalizado', 'Pendente', 'Respon. Huawei', 'Cancelado', 'Finalizado', 'Site novo', 'S/ Coleta'],
      },

      { field: 'idoutros', headerName: 'ID Outros', width: 150, editable: true, headerClassName: 'col-acesso-header' },
      { field: 'municipio', headerName: 'Município', width: 150, editable: true, headerClassName: 'col-acesso-header' },
      { field: 'endereco', headerName: 'Endereço', width: 220, editable: true, headerClassName: 'col-acesso-header' },

      {
        field: 'ddd',
        headerName: 'DDD',
        width: 80,
        editable: true,
        valueGetter: (p) => p.row.ddd1,
        valueSetter: (v) => ({ ...v.row, ddd1: v.value }),
        headerClassName: 'col-acesso-header',
      },
      {
        field: 'latitude',
        headerName: 'Latitude',
        width: 120,
        editable: true,
        valueGetter: (p) => p.row.latitude1,
        valueSetter: (v) => ({ ...v.row, latitude1: v.value }),
        headerClassName: 'col-acesso-header',
      },
      {
        field: 'longitude',
        headerName: 'Longitude',
        width: 120,
        editable: true,
        valueGetter: (p) => p.row.longitude1,
        valueSetter: (v) => ({ ...v.row, longitude1: v.value }),
        headerClassName: 'col-acesso-header',
      },

      {
        field: 'datasolicitado',
        headerName: 'Data Solicitada',
        type: 'date',
        width: 160,
        valueGetter: (c) => (c.value ? createLocalDate(c.value) : null),
        headerClassName: 'col-acesso-header',
      },
      {
        field: 'datainicio',
        headerName: 'Data Início',
        type: 'date',
        width: 160,
        valueGetter: (c) => (c.value ? createLocalDate(c.value) : null),
        headerClassName: 'col-acesso-header',
      },
      {
        field: 'datafim',
        headerName: 'Data Fim',
        type: 'date',
        width: 160,
        valueGetter: (c) => (c.value ? createLocalDate(c.value) : null),
        headerClassName: 'col-acesso-header',
      },

      {
        field: 'tipoinfra',
        headerName: 'Tipo Infra',
        width: 150,
        editable: true,
        type: 'singleSelect',
        valueOptions: ['BioSite', "Caixa D'Água", 'Greenfield', 'Rooftop', 'Indoor', 'Totem'],
        headerClassName: 'col-acesso-header',
      },
      { field: 'quadrante', headerName: 'Quadrante', width: 120, editable: true, headerClassName: 'col-acesso-header' },

      { field: 'detentorarea', headerName: 'Detentor Área', width: 180, editable: true, headerClassName: 'col-acesso-header' },
      { field: 'iddetentora', headerName: 'ID Detentora', width: 150, editable: true, headerClassName: 'col-acesso-header' },
      { field: 'formaacesso', headerName: 'Forma Acesso', width: 150, editable: true, headerClassName: 'col-acesso-header' },
      { field: 'observacaoacesso', headerName: 'Obs. Acesso', width: 250, editable: true, headerClassName: 'col-acesso-header' },

      {
        field: 'statusacesso',
        headerName: 'Status Acesso',
        width: 150,
        editable: true,
        type: 'singleSelect',
        valueOptions: ['Aguardando', 'Aprovado', 'Negado', 'Cancelado'],
        headerClassName: 'col-acesso-header',
      },
      { field: 'numerosolicitacao', headerName: 'N° Solicitação', width: 150, editable: true, headerClassName: 'col-acesso-header' },
      { field: 'tratativaacessos', headerName: 'Tratativa Acessos', width: 200, editable: true, headerClassName: 'col-acesso-header' },

      { field: 'duid', headerName: 'DU ID', width: 120, editable: true, headerClassName: 'col-acesso-header' },
      { field: 'duname', headerName: 'DU Name', width: 200, editable: true, headerClassName: 'col-acesso-header' },

      {
        field: 'statusatt',
        headerName: 'Status ATT',
        width: 250,
        editable: true,
        type: 'singleSelect',
        valueOptions: ['Cancelado | Baterias Entregue a TIM', 'Outro Status'],
        headerClassName: 'col-acesso-header',
      },

      { field: 'metaplan', headerName: 'Meta Plan', width: 150, editable: true, headerClassName: 'col-acesso-header' },
      { field: 'atividadeescopo', headerName: 'Atividade Escopo', width: 200, editable: true, headerClassName: 'col-acesso-header' },
      { field: 'acionamentosrecentes', headerName: 'Acionamentos Recentes', width: 200, editable: true, headerClassName: 'col-acesso-header' },

      { field: 'regiao', headerName: 'Região', width: 150, editable: true, headerClassName: 'col-acesso-header' },
      { field: 'acessoequipenomes', headerName: 'Acesso Equipe Nomes', width: 300, editable: false, headerClassName: 'col-acesso-header' },

      { field: 'detentora', headerName: 'Detentora', width: 150, editable: true },
      { field: 'idDetentora', headerName: 'ID Detentora (Legacy)', width: 170, editable: true },
      { field: 'formaDeAcesso', headerName: 'Forma de Acesso (Legacy)', width: 210, editable: true },
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
      { field: 'itemDescriptionLocal', headerName: 'Item Description (Local)', width: 250, editable: true },
      { field: 'unitPrice', headerName: 'Unit Price', type: 'number', width: 150, editable: true },
      { field: 'requestedQty', headerName: 'Requested Qty', type: 'number', width: 150, editable: true },
      { field: 'valorTelequipe', headerName: 'Valor Telequipe', type: 'number', width: 180, editable: true },
      { field: 'valorEquipe', headerName: 'Valor Equipe', type: 'number', width: 180, editable: true },
      { field: 'billedQuantity', headerName: 'Billed Quantity', type: 'number', width: 180, editable: true },
      { field: 'quantityCancel', headerName: 'Quantity Cancel', type: 'number', width: 180, editable: true },
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
        valueGetter: (cell) => (cell.value ? createLocalDate(cell.value) : null),
      },
    ],
    [empresas, pessoas, t2editar]
  );

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
      <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', width: '100%', padding: '10px' }}>
        <Typography variant="body2">Total de itens: {rowCount}</Typography>
        <Pagination color="primary" count={pageCount} page={page + 1} onChange={(e, v) => apiRef.current.setPage(v - 1)} />
      </Box>
    );
  }

  const toggle = () => setshow(!show);
  const toggle1 = () => setshow1(!show1);

  const iniciatabelas = async () => {
    try {
      setLoading(true);
      await Promise.all([listarollouthuawei(), listaempresa(), listapessoas()]);
    } catch {
      toast.error('Erro ao carregar dados iniciais');
    } finally {
      setLoading(false);
    }
  };

  const chamarfiltro = () => setshow1(true);

  useEffect(() => {
    iniciatabelas();
  }, []);

  const dateFields = new Set([
    'ENTRGA_REQUEST', 'ENTREGA_PLAN', 'ENTREGA_REAL', 'FIM_INSTALACAO_PLAN', 'FIM_INSTALACAO_REAL',
    'INTEGRACAO_PLAN', 'INTEGRACAO_REAL', 'DT_PLAN', 'DT_REAL', 'DELIVERY_PLAN', 'REGIONAL_LIB_SITE_P',
    'REGIONAL_LIB_SITE_R', 'EQUIPAMENTO_ENTREGA_P', 'REGIONAL_CARIMBO', 'ATIVACAO_REAL', 'DOCUMENTACAO',
    'INITIAL_TUNNING_REAL', 'INITIAL_TUNNING_STATUS', 'VISTORIA_PLAN', 'VISTORIA_REAL',
    'DOCUMENTACAO_VISTORIA_PLAN', 'DOCUMENTACAO_VISTORIA_REAL', 'REQ', 'datasolicitado', 'datainicio', 'datafim',
  ]);

  const toBRDate = (v) => {
    if (!v) return v;
    if (/^(1899-12-(30|31)|0000-00-00)/.test(v)) return '';
    const spaced = typeof v === 'string' && v.includes(' ') ? v.replace(' ', 'T') : v;
    const d = spaced instanceof Date ? spaced : new Date(spaced);
    if (!Number.isNaN(d.getTime())) return d.toLocaleDateString('pt-BR');
    const br = typeof v === 'string' && v.match(/^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$/);
    if (br) {
      const [, dd, mm, yyyy] = br;
      const normal = `${dd.padStart(2, '0')}/${mm.padStart(2, '0')}/${yyyy}`;
      if (normal === '31/12/1899' || normal === '30/12/1899') return '';
      return normal;
    }
    return v;
  };

  const formatDatesBR = (row) =>
    Object.fromEntries(Object.entries(row).map(([k, v]) => [k, dateFields.has(k) ? toBRDate(v) : v]));

  const upperStrings = (row) =>
    Object.fromEntries(Object.entries(row).map(([k, v]) => [k, typeof v === 'string' ? v.toUpperCase() : v]));

  const gerarexcel = async () => {
    try {
      setLoading(true);
      await new Promise((r) => setTimeout(r, 500));
      const excelData = totalacionamento
        .map((item) => ({
          ID: item.idgeral ?? item.id,
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
          REG: item.reg,
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
          'ID DETENTORA': item.idDetentora,
          'FORMA DE ACESSO': item.formaDeAcesso,
          FATURAMENTO: item.faturamento,
          'FATURAMENTO STATUS': item.faturamentoStatus,
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
          'TIPO INFRA': item.tipoinfra,
          QUADRANTE: item.quadrante,
          MUNICÍPIO: item.municipio,
          REGIÃO: item.regiao,
          ENDEREÇO: item.endereco,
          DDD: item.ddd,
          LATITUDE: item.latitude,
          LONGITUDE: item.longitude,
          'DETENTOR ÁREA': item.detentorarea,
          'ID DETENTORA (NOVO)': item.iddetentora,
          'ID OUTROS': item.idoutros,
          'FORMA ACESSO': item.formaacesso,
          'OBS. ACESSO': item.observacaoacesso,
          'DATA SOLICITADA': item.datasolicitado,
          'DATA INÍCIO': item.datainicio,
          'DATA FIM': item.datafim,
          'STATUS ACESSO': item.statusacesso,
          'N° SOLICITAÇÃO': item.numerosolicitacao,
          'TRATATIVA ACESSOS': item.tratativaacessos,
          'DU ID': item.duid,
          'DU NAME': item.duname,
          'STATUS ATT': item.statusatt,
          'META PLAN': item.metaplan,
          'ATIVIDADE ESCOPO': item.atividadeescopo,
          'ACIONAMENTOS RECENTES': item.acionamentosrecentes,
          'ACESSO EQUIPE NOMES': item.acessoequipenomes,
        }))
        .map(formatDatesBR)
        .map(upperStrings);
      exportExcel({ excelData, fileName: 'ROLLOUT HUAWEI' });
      toast.success('Arquivo Excel gerado com sucesso!');
    } catch {
      toast.error('Erro ao gerar arquivo Excel');
    } finally {
      setLoading(false);
    }
  };

  const handleProcessRowUpdateError = () => {
    setmensagem('Erro ao salvar a edição!');
  };

  const limparFiltro = async () => {
    setFormValues({});
    setLoading(true);
    const filtroParams = { ...params };
    const response = await api.get('v1/rollouthuawei', { params: filtroParams });
    settotalacionamento(response.data);
    toast.success('Filtros limpos com sucesso!');
    setTimeout(() => setmensagem(''), 3000);
    setLoading(false);
  };

  const handleProcessRowUpdate = async (newRow, oldRow) => {
    if (rowSelectionModel.length === 0) {
      setmensagem('Selecione pelo menos um item');
      return oldRow;
    }
    const changedFields = Object.keys(newRow).filter((key) => newRow[key] !== oldRow[key] && key !== 'id');
    if (changedFields.length === 0) return oldRow;
    React.startTransition(() => {
      setChangedField(changedFields[0]);
      setRowToUpdate({ newRow, oldRow, changedFields });
      setConfirmDialogOpen(true);
    });
    return newRow;
  };

  useEffect(() => {
    if (rowToUpdate) setConfirmDialogOpen(true);
  }, [rowToUpdate]);

  const aplicarFiltro = async () => {
    try {
      setLoading(true);
      const filtroParams = { ...params, ...formValues };
      Object.keys(filtroParams).forEach((k) => {
        if (filtroParams[k] === '' || filtroParams[k] === null || filtroParams[k] === undefined)
          delete filtroParams[k];
      });
      const response = await api.get('v1/rollouthuawei', { params: filtroParams });
      settotalacionamento(response.data);
      toast.success('Filtro aplicado com sucesso!');
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
      toast.error(`Erro ao aplicar filtros: ${err.message}`);
    } finally {
      setLoading(false);
      toggle1();
    }
  };

  const getRowClassName = () => {
    if (rowSelectionModel.includes(params.id)) return 'selected-row-green';
    return '';
  };

  return (
    <>
      <style>
        {`
          .selected-row-green { background-color: #e8f5e9 !important; border-left: 5px solid #4caf50; }
          .MuiDataGrid-columnHeaders { background-color: #f0f0f0; color: #555; text-transform: uppercase; }
          .MuiDataGrid-columnHeaderTitle { font-weight: bold; }
          .MuiDataGrid-cell { color: rgba(0, 0, 0, 0.87); }
          .col-acesso-header { background-color: #2e7d32 !important; color: #fff !important; }
          .col-acesso-verde { background-color: #e8f5e9 !important; }
          .col-cinza { background-color: #fafafa !important; }
        `}
      </style>

      {telacadastroedicao ? (
        <Rollouthuaweiedicao
          show={telacadastroedicao}
          setshow={settelacadastroedicao}
          ididentificador={ididentificador}
          atualiza={listarollouthuawei}
          huaweiSelecionado={HuaweiSelecionado}
          titulotopo={titulo}
          idr={idr}
          idpmtslocal={idpmtslocal}
        />
      ) : null}

      {telacadastrot2edicao ? (
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
        />
      ) : null}

      {telaexclusao ? (
        <Excluirregistro
          show={telaexclusao}
          setshow={settelaexclusao}
          ididentificador={ididentificador}
          quemchamou="ROLLOUTHUAWEI"
          atualiza={listarollouthuawei}
        />
      ) : null}

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
          <ToastContainer position="top-right" autoClose={5000} hideProgressBar={false} newestOnTop={false} closeOnClick rtl={false} pauseOnFocusLoss draggable pauseOnHover />
          {mensagem.length > 0 && <Alert severity="error" sx={{ mb: 2 }}>{mensagem}</Alert>}
          {loading ? (
            <Loader />
          ) : (
            <>
              <div className="row g-3">
                <div className="col-sm-3">
                  <Button color="link" onClick={gerarexcel} disabled={loading}>
                    {loading ? (<><CircularProgress size={16} sx={{ mr: 1 }} /> Carregando...</>) : ('Exportar Excel')}
                  </Button>
                </div>
                <div className="col-sm-9">
                  <div className=" col-sm-12 d-flex flex-row-reverse">
                    <Button color="primary" onClick={chamarfiltro} disabled={loading}>
                      {loading ? (<><CircularProgress size={16} sx={{ mr: 1 }} /> Aplicando...</>) : ('Aplicar Filtros')}
                    </Button>
                  </div>
                </div>
              </div>
              <br />
              <Box sx={{ height: '85%', width: '100%' }}>
                <DataGrid
                  disableRowSelectionOnClick
                  rows={totalacionamento}
                  columns={columns}
                  loading={loading}
                  pageSize={pageSize}
                  checkboxSelection
                  getRowId={(row) => row.idgeral}
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  disableSelectionOnClick
                  processRowUpdate={handleProcessRowUpdate}
                  onProcessRowUpdateError={handleProcessRowUpdateError}
                  rowSelectionModel={rowSelectionModel}
                  onCellEditCommit={handleCellEditCommit}
                  editMode="cell"
                  onRowSelectionModelChange={handleRowSelectionChange}
                  components={{ Pagination: CustomPagination, NoRowsOverlay: CustomNoRowsOverlay }}
                  localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                  paginationModel={paginationModel}
                  onPaginationModelChange={setPaginationModel}
                  getRowClassName={getRowClassName}
                  getCellClassName={(x) =>
                    accessFields.includes(x.field) ? 'col-acesso-verde' : 'col-cinza'
                  }
                />
              </Box>
            </>
          )}
        </ModalBody>
        <ModalFooter>
          <Button color="secondary" onClick={toggle}>Fechar</Button>
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

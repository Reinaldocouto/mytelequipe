import React, { useState, useEffect, useMemo, useCallback } from 'react';
import {
  Box,
  CircularProgress,
  Alert,
  Autocomplete,
  TextField,
  Chip,
  Typography,
  Pagination,
} from '@mui/material';
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
import DeleteIcon from '@mui/icons-material/Delete';
import PropTypes from 'prop-types';
import createLocalDate from '../../services/data';
import api from '../../services/api';
import exportExcel from '../../data/exportexcel/ExcelexportHawei';
import Rollouthuaweiedicao from '../../components/formulario/rollout/Rollouthuaweiedicao';
import Excluirregistro from '../../components/Excluirregistro';
import Telat2editar from '../../components/formulario/projeto/Telat2editar';
import FiltroRolloutHuawei from '../../components/modals/filtros/FiltroRolloutHuawei';
import ConfirmaModal from '../../components/modals/ConfirmacaoModal';
import Loader from '../../layouts/loader/Loader';
import AdicionarSiteManual from '../../components/formulario/rollout/AdicionarSiteManual';
import Solicitacaoedicao from './components/SolicitarEdicao';

const getRowKey = (row) =>
  row?.idgeral ?? row?.id ?? row?.primarykey ?? row?.ID ?? row?.Id;

const normalizeIds = (val) => {
  if (val == null) return [];
  if (Array.isArray(val)) return val.filter((v) => v !== '' && v != null);
  if (typeof val === 'string') {
    return val
      .split(',')
      .map((s) => s.trim())
      .filter(Boolean)
      .map((s) => (Number.isNaN(Number(s)) ? s : Number(s)));
  }
  if (typeof val === 'number') return [val];
  return [];
};

const AcessoEquipeMultiEdit = (props) => {
  const { id, field, value, api: gridApi, row, colDef } = props;

  const options = colDef.valueOptions || [];
  const currentIds = normalizeIds(
    value ?? row?.acessoequipenomes ?? row?.acessoEquipeNomes,
  );
  const selectedOptions = options.filter((o) => currentIds.includes(o.value));

  const handleChange = (_e, newOptions) => {
    const ids = (newOptions || []).map((o) => o.value);
    gridApi.setEditCellValue({ id, field, value: ids }, undefined);
  };

  return (
    <Autocomplete
      multiple
      disableCloseOnSelect
      options={options}
      value={selectedOptions}
      onChange={handleChange}
      getOptionLabel={(o) => o.label ?? String(o)}
      renderInput={(params) => (
        <TextField {...params} size="small" placeholder="Selecionar..." />
      )}
      renderTags={(tagValue, getTagProps) =>
        tagValue.map((option, index) => (
          <Chip {...getTagProps({ index })} key={option.value} label={option.label} />
        ))
      }
      sx={{ width: '100%' }}
    />
  );
};

AcessoEquipeMultiEdit.propTypes = {
  id: PropTypes.any,
  field: PropTypes.string,
  value: PropTypes.any,
  api: PropTypes.object,
  row: PropTypes.object,
  colDef: PropTypes.object,
};

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
  const [paginationModel, setPaginationModel] = useState({
    pageSize: 100,
    page: 0,
  });
  const [showAdicionarSiteManual, setShowAdicionarSiteManual] = useState(false);
  const [showGerarSolicitacaoModal, setShowGerarSolicitacaoModal] =
    useState(false);
  const [sitesValidosSolicitacao, setSitesValidosSolicitacao] = useState([]);
  const [sitesBloqueadosSolicitacao, setSitesBloqueadosSolicitacao] = useState(
    [],
  );
  const [showIsNew,] = useState(true);

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const clearMensagem = useCallback(() => setmensagem(''), []);

  const toISODate = (v) => {
    if (!v) return null;
    if (typeof v === 'string') {
      const m = v.trim().match(/^(\d{4})-(\d{2})-(\d{2})$/);
      if (m) return `${m[1]}-${m[2]}-${m[3]}`;
    }
    const d = v instanceof Date ? v : new Date(v);
    if (Number.isNaN(d.getTime())) return null;
    const yyyy = d.getUTCFullYear();
    const mm = String(d.getUTCMonth() + 1).padStart(2, '0');
    const dd = String(d.getUTCDate()).padStart(2, '0');
    return `${yyyy}-${mm}-${dd}`;
  };

  const getFromPaths = (obj, paths) => {
    if (!Array.isArray(paths)) return undefined;
    const values = paths.map((p) =>
      p.split('.').reduce(
        (acc, k) => (acc && acc[k] !== undefined ? acc[k] : undefined),
        obj,
      ),
    );
    return values.find((val) => val !== undefined && val !== null);
  };

  const fisicoPaths = {
    fisicoSituacaoImplantacao: [
      'fisicoSituacaoImplantacao',
      'fisico_situacao_implantacao',
      'fisico.situacaoImplantacao',
      'fisico.situacao_implantacao',
      'acompanhamentoFisico.situacaoImplantacao',
      'acompanhamentoFisico.situacao_implantacao',
      'fisicosituacaoimplantacao',
    ],
    fisicoSituacaoIntegracao: [
      'fisicoSituacaoIntegracao',
      'fisico_situacao_integracao',
      'fisico.situacaoIntegracao',
      'fisico.situacao_integracao',
      'acompanhamentoFisico.situacaoIntegracao',
      'acompanhamentoFisico.situacao_integracao',
      'fisicosituacaointegracao',
    ],
    fisicoDataCriacaoDemanda: [
      'fisicoDataCriacaoDemanda',
      'fisico_data_criacao_demanda',
      'fisico.dataCriacaoDemanda',
      'fisico.data_criacao_demanda',
      'acompanhamentoFisico.dataCriacaoDemanda',
      'acompanhamentoFisico.data_criacao_demanda',
      'fisicodatacriacaodemanda',
    ],
    fisicoDataAceiteDemanda: [
      'fisicoDataAceiteDemanda',
      'fisico_data_aceite_demanda',
      'fisico.dataAceiteDemanda',
      'fisico.data_aceite_demanda',
      'acompanhamentoFisico.dataAceiteDemanda',
      'acompanhamentoFisico.data_aceite_demanda',
      'fisicodataaceitedemanda',
    ],
    fisicoDataInicioPlanejado: [
      'fisicoDataInicioPlanejado',
      'fisico_data_inicio_planejado',
      'fisico.dataInicioPlanejado',
      'fisico.data_inicio_planejado',
      'acompanhamentoFisico.dataInicioPlanejado',
      'acompanhamentoFisico.data_inicio_planejado',
      'fisicodatainicioplanejado',
    ],
    fisicoDataEntregaPlanejado: [
      'fisicoDataEntregaPlanejado',
      'fisico_data_entrega_planejado',
      'fisico.dataEntregaPlanejado',
      'fisico.data_entrega_planejado',
      'acompanhamentoFisico.dataEntregaPlanejado',
      'acompanhamentoFisico.data_entrega_planejado',
      'fisicodataentregaplanejado',
    ],
    fisicoDataRecebimentoReportado: [
      'fisicoDataRecebimentoReportado',
      'fisico_data_recebimento_reportado',
      'fisico.dataRecebimentoReportado',
      'fisico.data_recebimento_reportado',
      'acompanhamentoFisico.dataRecebimentoReportado',
      'acompanhamentoFisico.data_recebimento_reportado',
      'fisicodatarecebimentoreportado',
    ],
    fisicoDataFimInstalacaoPlanejado: [
      'fisicoDataFimInstalacaoPlanejado',
      'fisico_data_fim_instalacao_planejado',
      'fisico.dataFimInstalacaoPlanejado',
      'fisico.data_fim_instalacao_planejado',
      'acompanhamentoFisico.dataFimInstalacaoPlanejado',
      'acompanhamentoFisico.data_fim_instalacao_planejado',
      'fisicodatafiminstalacaoplanejado',
    ],
    fisicoDataConclusaoReportado: [
      'fisicoDataConclusaoReportado',
      'fisico_data_conclusao_reportado',
      'fisico.dataConclusaoReportado',
      'fisico.data_conclusao_reportado',
      'acompanhamentoFisico.dataConclusaoReportado',
      'acompanhamentoFisico.data_conclusao_reportado',
      'fisicodataconclusaoreportado',
    ],
    fisicoDataValidacaoInstalacao: [
      'fisicoDataValidacaoInstalacao',
      'fisico_data_validacao_instalacao',
      'fisico.dataValidacaoInstalacao',
      'fisico.data_validacao_instalacao',
      'acompanhamentoFisico.dataValidacaoInstalacao',
      'acompanhamentoFisico.data_validacao_instalacao',
      'fisicodatavalidacaoinstalacao',
    ],
    fisicoDataIntegracaoPlanejado: [
      'fisicoDataIntegracaoPlanejado',
      'fisico_data_integracao_planejado',
      'fisico.dataIntegracaoPlanejado',
      'fisico.data_integracao_planejado',
      'acompanhamentoFisico.dataIntegracaoPlanejado',
      'acompanhamentoFisico.data_integracao_planejado',
      'fisicodataintegracaoplanejado',
    ],
    fisicoDataValidacaoEribox: [
      'fisicoDataValidacaoEribox',
      'fisico_data_validacao_eribox',
      'fisico.dataValidacaoEribox',
      'fisico.data_validacao_eribox',
      'acompanhamentoFisico.dataValidacaoEribox',
      'acompanhamentoFisico.data_validacao_eribox',
      'fisicodatavalidacaoeribox',
    ],
    fisicoDataAceitacaoFinal: [
      'fisicoDataAceitacaoFinal',
      'fisico_data_aceitacao_final',
      'fisico.dataAceitacaoFinal',
      'fisico.data_aceitacao_final',
      'acompanhamentoFisico.dataAceitacaoFinal',
      'acompanhamentoFisico.data_aceitacao_final',
      'fisicodataaceitacaofinal',
    ],
    fisicoPendenciasObras: [
      'fisicoPendenciasObras',
      'fisico_pendencias_obras',
      'fisico.pendenciasObras',
      'fisico.pendencias_obras',
      'acompanhamentoFisico.pendenciasObras',
      'acompanhamentoFisico.pendencias_obras',
      'fisicopendenciasobras',
    ],
    fisicoObservacoes: [
      'fisicoObservacoes',
      'fisico_observacoes',
      'fisico.observacoes',
      'acompanhamentoFisico.observacoes',
      'fisicoobservacoes',
    ],
    fisicoCriadoEm: [
      'fisicoCriadoEm',
      'fisico_criado_em',
      'fisico.criadoEm',
      'fisico.criado_em',
      'acompanhamentoFisico.criadoEm',
      'acompanhamentoFisico.criado_em',
      'fisicocriadoem',
    ],
    fisicoAtualizadoEm: [
      'fisicoAtualizadoEm',
      'fisico_atualizado_em',
      'fisico.atualizadoEm',
      'fisico.atualizado_em',
      'acompanhamentoFisico.atualizadoEm',
      'acompanhamentoFisico.atualizado_em',
      'fisicoatualizadoem',
    ],
  };

  const [showSolicitacaoEdicao, setShowSolicitacaoEdicao] = useState(false);
  const [solicitacaoPayload, setSolicitacaoPayload] = useState(null);

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
    () => new Map(totalacionamento.map((r) => [getRowKey(r), r])),
    [totalacionamento],
  );

  const mapFieldToBackend = (f) => {
    const m = {
      infra: 'tipodeinfra',
      detentorarea: 'detentordaarea',
      idDetentora: 'iddetentora',
      formaDeAcesso: 'formaacesso',
      acessoequipenomes: 'equipe',
    };
    return m[f] ?? f;
  };

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
        .map((rid) => {
          const r = rowsById.get(rid);
          return r?.id ?? r?.idgeral ?? rid;
        })
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

      if (campo === 'ddd1') {
        campoFinal = 'ddd';
        valorFinal = row.ddd1;
      }

      if (campo === 'latitude1') {
        campoFinal = 'latitude';
        valorFinal = row.latitude1;
      }

      if (campo === 'longitude1') {
        campoFinal = 'longitude';
        valorFinal = row.longitude1;
      }

      if (campo === 'tipoinfra') {
        campoFinal = 'tipodeinfra';
      }

      if (
        campo === 'datasolicitado' ||
        campo === 'datainicio' ||
        campo === 'datafim'
      ) {
        valorFinal = toISODate(valorFinal);
      }

      if (campo === 'acessoequipenomes') {
        const ids = normalizeIds(valorFinal);
        valorFinal = ids.join(',');
      }

      campoFinal = mapFieldToBackend(campoFinal);

      await api.post('v1/rollouthuawei/editaremmassa', {
        id: idsSelecionados,
        [campoFinal]: valorFinal,
      });

      const filtroParams = { ...params, ...formValues };
      Object.keys(filtroParams).forEach((k) => {
        if (filtroParams[k] == null || filtroParams[k] === '') {
          delete filtroParams[k];
        }
      });

      const response = await api.get('v1/rollouthuawei', {
        params: filtroParams,
      });
      settotalacionamento(response.data);
      setmensagem('');
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
    clearMensagem();
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
      const { data } = await api.get('/v1/pessoa/select');
      const opts = (Array.isArray(data) ? data : [])
        .map((o) => {
          const value = o?.value ?? o?.id ?? o?.codigo ?? null;
          const label = String(o?.label ?? o?.nome ?? o?.name ?? '').trim();
          if (value == null || !label) return null;
          return { value, label };
        })
        .filter(Boolean);

      setPessoas(opts);
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

  const abrirExclusao = useCallback((idRegistro) => {
    setididentificador(idRegistro);
    settelaexclusao(true);
  }, []);

  const handleRowSelectionChange = useCallback(
    (newSelectionModel) => {
      if (newSelectionModel.length > 0) {
        const selectedRow = rowsById.get(newSelectionModel[0]);
        if (selectedRow) {
          sethuaweiSelecionado(selectedRow);
          setididentificador(selectedRow.idgeral ?? selectedRow.id);
          setpmuf(selectedRow.projeto);
          setidr(selectedRow.siteCode);
          setidpmtslocal(selectedRow.siteId);
        }
      }
      setRowSelectionModel(newSelectionModel);
    },
    [rowsById],
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
    [],
  );

  const getOsFromRow = (row) => {
    const raw =
      row?.os ?? row?.numeroOs ?? row?.numeroOS ?? row?.osNumero ?? row?.OS;
    if (raw == null) return '';
    const s = String(raw).trim();
    if (!s) return '';
    if (s === '--') return '';
    return s;
  };

  const columns = useMemo(
    () => [
      {
        field: 'actions',
        headerName: 'Ação',
        type: 'actions',
        width: 120,
        align: 'center',
        getActions: (rowData) => {
          const actions = [
            <GridActionsCellItem
              key="edit"
              icon={<EditIcon />}
              label="Alterar"
              onClick={() => {
                const rid = rowData.row.id ?? rowData.row.idgeral;
                alterarUser(
                  rid,
                  rowData.row.projeto,
                  rowData.row.siteCode,
                  rowData.row.siteId,
                );
                sethuaweiSelecionado(rowData.row);
              }}
            />,
            <GridActionsCellItem
              key="t2"
              icon={<AssignmentIcon />}
              label="T2"
              onClick={() =>
                t2editar(
                  rowData.row.id ?? rowData.row.idgeral,
                  rowData.row.projeto,
                  rowData.row.siteCode,
                  rowData.row.siteId,
                )
              }
            />,
          ];

          if (rowData.row?.origem === 'Manual' || rowData.row?.avulso === 1) {
            actions.push(
              <GridActionsCellItem
                key="delete"
                icon={<DeleteIcon />}
                label="Excluir"
                onClick={() =>
                  abrirExclusao(rowData.row.id ?? rowData.row.idgeral)
                }
                showInMenu={false}
              />,
            );
          }

          return actions;
        },
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
        valueOptions: pessoas.map((p) => p.label),
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
      {
        field: 'descricaoAdd',
        headerName: 'Descrição Adicional',
        width: 250,
        editable: true,
      },
      { field: 'numeroVo', headerName: 'N° VO', width: 120, editable: true },
      {
        field: 'infra',
        headerName: 'Infra',
        width: 120,
        editable: true,
        type: 'singleSelect',
        valueOptions: [
          'BioSite',
          "Caixa D'Água",
          'Greenfield',
          'Rooftop',
          'Indoor',
          'Totem',
        ],
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
      {
        field: 'semanaIntegration',
        headerName: 'Semana Integration',
        width: 180,
        editable: true,
      },
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
        valueOptions: [
          'Pendente',
          'QC vinculado',
          'Finalizado',
          'Cancelado',
          'Pendente Huawei',
        ],
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
      { field: 'avulso', headerName: 'Avulso', width: 100, editable: false },
      {
        field: 'criadoEm',
        headerName: 'Criado em',
        width: 160,
        editable: false,
        valueFormatter: (x) => {
          if (!x.value) return '';
          const data = new Date(x.value);
          return data.toLocaleString('pt-BR', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
          });
        },
      },
      { field: 'ultimaAtualizacao', headerName: 'Última Atualização', width: 160, editable: false },
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
        editable: true,
        valueGetter: (c) => (c.value ? createLocalDate(c.value) : null),
        valueSetter: (p) => ({
          ...p.row,
          datasolicitado: toISODate(p.value),
        }),
        headerClassName: 'col-acesso-header',
      },
      {
        field: 'datainicio',
        headerName: 'Data Início',
        type: 'date',
        width: 160,
        editable: true,
        valueGetter: (c) => (c.value ? createLocalDate(c.value) : null),
        valueSetter: (p) => ({
          ...p.row,
          datainicio: toISODate(p.value),
        }),
        headerClassName: 'col-acesso-header',
      },
      {
        field: 'datafim',
        headerName: 'Data Fim',
        type: 'date',
        width: 160,
        editable: true,
        valueGetter: (c) => (c.value ? createLocalDate(c.value) : null),
        valueSetter: (p) => ({
          ...p.row,
          datafim: toISODate(p.value),
        }),
        headerClassName: 'col-acesso-header',
      },
      {
        field: 'tipoinfra',
        headerName: 'Tipo Infra',
        width: 150,
        editable: true,
        type: 'singleSelect',
        valueOptions: [
          'BioSite',
          "Caixa D'Água",
          'Greenfield',
          'Rooftop',
          'Indoor',
          'Totem',
        ],
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
      {
        field: 'regiao',
        headerName: 'Região',
        width: 150,
        editable: true,
        type: 'singleSelect',
        valueOptions: ['Interior', 'Capital'],
        headerClassName: 'col-acesso-header',
      },
      {
        field: 'acessoequipenomes',
        headerName: 'Acesso Equipe Nomes',
        width: 300,
        editable: true,
        headerClassName: 'col-acesso-header',
        valueOptions: pessoas,
        renderEditCell: (value) => <AcessoEquipeMultiEdit {...value} />,
        valueSetter: (value) => {
          const ids = normalizeIds(value.value);
          return {
            ...value.row,
            acessoequipenomes: ids,
            acessoEquipeNomes: ids,
          };
        },
        valueFormatter: (value) => {
          const ids = normalizeIds(
            value.value ??
            value.row?.acessoequipenomes ??
            value.row?.acessoEquipeNomes,
          );
          if (!ids.length) return '';
          return ids
            .map((id) => {
              const opt = (pessoas || []).find((o) => o.value === id);
              return opt ? opt.label : String(id);
            })
            .join(', ');
        },
      },
      {
        field: 'avulso',
        headerName: 'Avulso',
        width: 110,
        type: 'boolean',
        editable: false,
        valueGetter: (p) => {
          const v = p.value ?? p.row?.avulso;
          return v === 1 || v === '1' || v === true || v === 'true';
        },
      },
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
      { field: 'os', headerName: 'OS', width: 140, editable: false },
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
      {
        field: 'fisicoSituacaoImplantacao',
        headerName: 'Físico • Situação Implantação',
        width: 240,
        editable: false,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) =>
          getFromPaths(p.row, fisicoPaths.fisicoSituacaoImplantacao),
      },
      {
        field: 'fisicoSituacaoIntegracao',
        headerName: 'Físico • Situação Integração',
        width: 230,
        editable: false,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) =>
          getFromPaths(p.row, fisicoPaths.fisicoSituacaoIntegracao),
      },
      {
        field: 'fisicoDataCriacaoDemanda',
        headerName: 'Físico • Criação Demanda',
        type: 'date',
        width: 190,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) => {
          const v = getFromPaths(p.row, fisicoPaths.fisicoDataCriacaoDemanda);
          return v ? createLocalDate(v) : null;
        },
      },
      {
        field: 'fisicoDataAceiteDemanda',
        headerName: 'Físico • Aceite Demanda',
        type: 'date',
        width: 185,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) => {
          const v = getFromPaths(p.row, fisicoPaths.fisicoDataAceiteDemanda);
          return v ? createLocalDate(v) : null;
        },
      },
      {
        field: 'fisicoDataInicioPlanejado',
        headerName: 'Físico • Início Planejado',
        type: 'date',
        width: 195,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) => {
          const v = getFromPaths(
            p.row,
            fisicoPaths.fisicoDataInicioPlanejado,
          );
          return v ? createLocalDate(v) : null;
        },
      },
      {
        field: 'fisicoDataEntregaPlanejado',
        headerName: 'Físico • Entrega Planejado',
        type: 'date',
        width: 200,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) => {
          const v = getFromPaths(
            p.row,
            fisicoPaths.fisicoDataEntregaPlanejado,
          );
          return v ? createLocalDate(v) : null;
        },
      },
      {
        field: 'fisicoDataRecebimentoReportado',
        headerName: 'Físico • Receb. Reportado',
        type: 'date',
        width: 205,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) => {
          const v = getFromPaths(
            p.row,
            fisicoPaths.fisicoDataRecebimentoReportado,
          );
          return v ? createLocalDate(v) : null;
        },
      },
      {
        field: 'fisicoDataFimInstalacaoPlanejado',
        headerName: 'Físico • Fim Instalação (Plan)',
        type: 'date',
        width: 230,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) => {
          const v = getFromPaths(
            p.row,
            fisicoPaths.fisicoDataFimInstalacaoPlanejado,
          );
          return v ? createLocalDate(v) : null;
        },
      },
      {
        field: 'fisicoDataConclusaoReportado',
        headerName: 'Físico • Conclusão Reportado',
        type: 'date',
        width: 220,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) => {
          const v = getFromPaths(
            p.row,
            fisicoPaths.fisicoDataConclusaoReportado,
          );
          return v ? createLocalDate(v) : null;
        },
      },
      {
        field: 'fisicoDataValidacaoInstalacao',
        headerName: 'Físico • Validação Instalação',
        type: 'date',
        width: 220,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) => {
          const v = getFromPaths(
            p.row,
            fisicoPaths.fisicoDataValidacaoInstalacao,
          );
          return v ? createLocalDate(v) : null;
        },
      },
      {
        field: 'fisicoDataIntegracaoPlanejado',
        headerName: 'Físico • Integração (Plan)',
        type: 'date',
        width: 210,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) => {
          const v = getFromPaths(
            p.row,
            fisicoPaths.fisicoDataIntegracaoPlanejado,
          );
          return v ? createLocalDate(v) : null;
        },
      },
      {
        field: 'fisicoDataValidacaoEribox',
        headerName: 'Físico • Validação Eribox',
        type: 'date',
        width: 200,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) => {
          const v = getFromPaths(
            p.row,
            fisicoPaths.fisicoDataValidacaoEribox,
          );
          return v ? createLocalDate(v) : null;
        },
      },
      {
        field: 'fisicoDataAceitacaoFinal',
        headerName: 'Físico • Aceitação Final',
        type: 'date',
        width: 200,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) => {
          const v = getFromPaths(
            p.row,
            fisicoPaths.fisicoDataAceitacaoFinal,
          );
          return v ? createLocalDate(v) : null;
        },
      },
      {
        field: 'fisicoPendenciasObras',
        headerName: 'Físico • Pendências de Obras',
        width: 260,
        editable: false,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) =>
          getFromPaths(p.row, fisicoPaths.fisicoPendenciasObras),
      },
      {
        field: 'fisicoObservacoes',
        headerName: 'Físico • Observações',
        width: 260,
        editable: false,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) =>
          getFromPaths(p.row, fisicoPaths.fisicoObservacoes),
      },
      {
        field: 'fisicoCriadoEm',
        headerName: 'Físico • Criado Em',
        type: 'dateTime',
        width: 190,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) => {
          const v = getFromPaths(p.row, fisicoPaths.fisicoCriadoEm);
          return v ? createLocalDate(v) : null;
        },
      },
      {
        field: 'fisicoAtualizadoEm',
        headerName: 'Físico • Atualizado Em',
        type: 'dateTime',
        width: 200,
        headerClassName: 'col-fisico-header',
        valueGetter: (p) => {
          const v = getFromPaths(p.row, fisicoPaths.fisicoAtualizadoEm);
          return v ? createLocalDate(v) : null;
        },
      },
    ],
    [empresas, pessoas, t2editar, abrirExclusao],
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
          onChange={(_e, v) => apiRef.current.setPage(v - 1)}
        />
      </Box>
    );
  }

  const toggle = () => setshow(!show);
  const toggle1 = () => setshow1(!show1);

  const iniciatabelas = async () => {
    try {
      setLoading(true);
      await listapessoas();
      await Promise.all([listarollouthuawei(), listaempresa()]);
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
    'datasolicitado',
    'datainicio',
    'datafim',
    'ACCEPTANCE DATE',
    'ENVIO DA DEMANDA',
    'FÍSICO • CRIAÇÃO DEMANDA',
    'FÍSICO • ACEITE DEMANDA',
    'FÍSICO • INÍCIO PLANEJADO',
    'FÍSICO • ENTREGA PLANEJADO',
    'FÍSICO • RECEBIMENTO REPORTADO',
    'FÍSICO • FIM INSTALAÇÃO (PLAN)',
    'FÍSICO • CONCLUSÃO REPORTADO',
    'FÍSICO • VALIDAÇÃO INSTALAÇÃO',
    'FÍSICO • INTEGRAÇÃO (PLAN)',
    'FÍSICO • VALIDAÇÃO ERIBOX',
    'FÍSICO • ACEITAÇÃO FINAL',
    'FÍSICO • CRIADO EM',
    'FÍSICO • ATUALIZADO EM',
  ]);

  const toBRDate = (v) => {
    if (!v) return v;
    if (/^(1899-12-(30|31)|0000-00-00)/.test(v)) return '';
    const spaced =
      typeof v === 'string' && v.includes(' ')
        ? v.replace(' ', 'T')
        : v;
    const d = spaced instanceof Date ? spaced : new Date(spaced);
    if (!Number.isNaN(d.getTime())) return d.toLocaleDateString('pt-BR');
    const br =
      typeof v === 'string' &&
      v.match(/^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$/);
    if (br) {
      const [, dd, mm, yyyy] = br;
      const normal = `${dd.padStart(2, '0')}/${mm.padStart(
        2,
        '0',
      )}/${yyyy}`;
      if (normal === '31/12/1899' || normal === '30/12/1899') return '';
      return normal;
    }
    return v;
  };

  const formatDatesBR = (row) =>
    Object.fromEntries(
      Object.entries(row).map(([k, v]) => [
        k,
        dateFields.has(k) ? toBRDate(v) : v,
      ]),
    );

  const upperStrings = (row) =>
    Object.fromEntries(
      Object.entries(row).map(([k, v]) => [
        k,
        typeof v === 'string' ? v.toUpperCase() : v,
      ]),
    );

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
          OS: item.os,
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
          'PR/PO AUTOMATION SOLUTION (ONLY CHINA)':
            item.prPoAutomationSolutionOnlyChina,
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
          criadoEm: item.criadoEm,
          'DETENTOR ÁREA': item.detentorarea,
          'ID DETENTORA (NOVO)': item.iddetentora,
          Avulso: item.avulso ? 'SIM' : 'NÃO',
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
          'ACESSO EQUIPE NOMES': Array.isArray(
            item.acessoequipenomes ?? item.acessoEquipeNomes,
          )
            ? (item.acessoequipenomes ?? item.acessoEquipeNomes).join(',')
            : item.acessoequipenomes ?? item.acessoEquipeNomes,
          AVULSO:
            item.avulso === 1 ||
              item.avulso === '1' ||
              item.avulso === true ||
              item.avulso === 'true'
              ? 'SIM'
              : 'NÃO',
          'FÍSICO • ID PROJETO HUAWEI': getFromPaths(item, [
            'fisicoIdProjetohuawei',
            'fisico.idProjetohuawei',
            'acompanhamentoFisico.idProjetohuawei',
          ]),
          'FÍSICO • SITUAÇÃO IMPLANTAÇÃO': getFromPaths(
            item,
            fisicoPaths.fisicoSituacaoImplantacao,
          ),
          'FÍSICO • SITUAÇÃO INTEGRAÇÃO': getFromPaths(
            item,
            fisicoPaths.fisicoSituacaoIntegracao,
          ),
          'FÍSICO • CRIAÇÃO DEMANDA': getFromPaths(
            item,
            fisicoPaths.fisicoDataCriacaoDemanda,
          ),
          'FÍSICO • ACEITE DEMANDA': getFromPaths(
            item,
            fisicoPaths.fisicoDataAceiteDemanda,
          ),
          'FÍSICO • INÍCIO PLANEJADO': getFromPaths(
            item,
            fisicoPaths.fisicoDataInicioPlanejado,
          ),
          'FÍSICO • ENTREGA PLANEJADO': getFromPaths(
            item,
            fisicoPaths.fisicoDataEntregaPlanejado,
          ),
          'FÍSICO • RECEBIMENTO REPORTADO': getFromPaths(
            item,
            fisicoPaths.fisicoDataRecebimentoReportado,
          ),
          'FÍSICO • FIM INSTALAÇÃO (PLAN)': getFromPaths(
            item,
            fisicoPaths.fisicoDataFimInstalacaoPlanejado,
          ),
          'FÍSICO • CONCLUSÃO REPORTADO': getFromPaths(
            item,
            fisicoPaths.fisicoDataConclusaoReportado,
          ),
          'FÍSICO • VALIDAÇÃO INSTALAÇÃO': getFromPaths(
            item,
            fisicoPaths.fisicoDataValidacaoInstalacao,
          ),
          'FÍSICO • INTEGRAÇÃO (PLAN)': getFromPaths(
            item,
            fisicoPaths.fisicoDataIntegracaoPlanejado,
          ),
          'FÍSICO • VALIDAÇÃO ERIBOX': getFromPaths(
            item,
            fisicoPaths.fisicoDataValidacaoEribox,
          ),
          'FÍSICO • ACEITAÇÃO FINAL': getFromPaths(
            item,
            fisicoPaths.fisicoDataAceitacaoFinal,
          ),
          'FÍSICO • PENDÊNCIAS OBRAS': getFromPaths(
            item,
            fisicoPaths.fisicoPendenciasObras,
          ),
          'FÍSICO • OBSERVAÇÕES': getFromPaths(
            item,
            fisicoPaths.fisicoObservacoes,
          ),
          'FÍSICO • CRIADO EM': getFromPaths(
            item,
            fisicoPaths.fisicoCriadoEm,
          ),
          'FÍSICO • ATUALIZADO EM': getFromPaths(
            item,
            fisicoPaths.fisicoAtualizadoEm,
          ),
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
    const response = await api.get('v1/rollouthuawei', {
      params: filtroParams,
    });

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

    const changedFields = Object.keys(newRow).filter(
      (key) => newRow[key] !== oldRow[key] && key !== 'id',
    );

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
        if (
          filtroParams[k] === '' ||
          filtroParams[k] === null ||
          filtroParams[k] === undefined
        ) {
          delete filtroParams[k];
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
      toast.error(`Erro ao aplicar filtros: ${err.message}`);
    } finally {
      setLoading(false);
      toggle1();
    }
  };

  const isTotalmenteCancelado = (row) => {
    const rq = Number(row?.requestedQty ?? 0);
    const qc = Number(row?.quantityCancel ?? 0);
    return rq > 0 && qc === rq;
  };

  const isSiteNovo = (row) => {
    const pick = (val) => {
      if (!val) return null;
      const s = typeof val === 'string' ? val.trim() : val;
      const iso =
        typeof s === 'string' && s.includes(' ') && !s.includes('T')
          ? s.replace(' ', 'T')
          : s;
      const d = new Date(iso);
      return Number.isNaN(d.getTime()) ? null : d;
    };

    const vCriado =
      getFromPaths(row, fisicoPaths.fisicoCriadoEm) ??
      row.criadoEm ??
      row.criado_em ??
      row.createdAt ??
      row.created_at;
    const criado = pick(vCriado);
    if (!criado) return false;

    const vAtualizado =
      getFromPaths(row, fisicoPaths.fisicoAtualizadoEm) ??
      row.ultimaAtualizacao ??
      row.ultima_atualizacao ??
      row.updatedAt ??
      row.updated_at;

    const atualizado = pick(vAtualizado);
    const diffDias = (Date.now() - criado.getTime()) / 86400000;
    const datasDiferentes =
      !atualizado || atualizado.getTime() === criado.getTime();

    return diffDias <= 7 && datasDiferentes;
  };

  const getRowClassName = (paramsRow) => {
    const classes = [];

    if (rowSelectionModel.includes(paramsRow.id))
      classes.push('selected-row-green');
    if (isTotalmenteCancelado(paramsRow.row)) classes.push('row-red');
    else if (isSiteNovo(paramsRow.row)) classes.push('row-green');

    return classes.join(' ');
  };

  const marcarAvulso = useCallback(
    async (flag) => {
      const selectedIds = rowSelectionModel
        .map((rid) => {
          const r = rowsById.get(rid);
          return r?.idgeral ?? r?.id ?? rid ?? null;
        })
        .filter((v) => v !== null && v !== '');

      if (!selectedIds.length) {
        toast.warning('Selecione ao menos um registro.');
        return;
      }

      try {
        setLoading(true);
        const idusuario =
          localStorage.getItem('sessionId') ||
          localStorage.getItem('sessionIdUsuario') ||
          params.idusuario;

        await api.post(
          `v1/rollouthuawei/${flag ? 'marcaravulso' : 'desmarcaravulso'}`,
          {
            ids: selectedIds.join(','),
            idusuario,
          },
        );

        await listarollouthuawei();
        toast.success(
          flag ? 'Marcado como avulso.' : 'Desmarcado como avulso.',
        );
      } catch (err) {
        toast.error(err?.message || 'Erro ao atualizar avulso');
      } finally {
        setLoading(false);
      }
    },
    [rowSelectionModel, rowsById],
  );

  const handleGerarSolicitacaoClick = () => {
    if (!rowSelectionModel.length) {
      toast.warning('Selecione ao menos um site.');
      return;
    }
    const selecionados = rowSelectionModel
      .map((rid) => rowsById.get(rid))
      .filter(Boolean);
    const validos = [];
    const bloqueados = [];
    selecionados.forEach((row) => {
      const os = getOsFromRow(row);
      if (!os) bloqueados.push(row);
      else validos.push({ ...row, os });
    });
    setSitesValidosSolicitacao(validos);
    setSitesBloqueadosSolicitacao(bloqueados);
    setShowGerarSolicitacaoModal(true);
    if (!validos.length) {
      toast.error(
        'Não é possível gerar solicitação de material para sites sem número de OS associado.',
      );
    }
  };

  useEffect(() => {
    if (!showGerarSolicitacaoModal) return;
    const selecionados = rowSelectionModel
      .map((rid) => rowsById.get(rid))
      .filter(Boolean);
    const validos = [];
    const bloqueados = [];
    selecionados.forEach((row) => {
      const os = getOsFromRow(row);
      if (!os) bloqueados.push(row);
      else validos.push({ ...row, os });
    });
    setSitesValidosSolicitacao(validos);
    setSitesBloqueadosSolicitacao(bloqueados);
  }, [rowSelectionModel, rowsById, showGerarSolicitacaoModal]);

  const handleRemoverBloqueadosDaSelecao = useCallback(() => {
    if (!sitesBloqueadosSolicitacao.length) return;
    const idsBloqueados = new Set(
      sitesBloqueadosSolicitacao.map((r) => getRowKey(r)),
    );
    setRowSelectionModel((prev) => prev.filter((id) => !idsBloqueados.has(id)));
    toast.info('Sites sem OS foram removidos da seleção.');
  }, [sitesBloqueadosSolicitacao]);

  const handleConfirmGerarSolicitacao = async () => {
    if (!sitesValidosSolicitacao.length || sitesBloqueadosSolicitacao.length) {
      toast.error('Remova os sites sem OS para continuar.');
      return;
    }

    // Em vez de chamar API, abrimos o componente externo com o payload
    setLoading(true);
    try {
      const payload = {
        idcliente: params.idcliente,
        idusuario: params.idusuario,
        sites: sitesValidosSolicitacao.map((site) => ({
          id: site.idgeral ?? site.id,
          name: site.name,
          siteCode: site.siteCode,
          siteId: site.siteId,
          os: site.os,
        })),
      };

      setSolicitacaoPayload(payload);        // passa dados para o componente
      setShowGerarSolicitacaoModal(false);   // fecha o modal atual
      setShowSolicitacaoEdicao(true);        // abre o componente externo
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <style>
        {`
          .MuiDataGrid-columnHeaders {
            background-color: #f0f0f0;
            color: #555;
            text-transform: uppercase;
          }
          .MuiDataGrid-columnHeaderTitle { font-weight: bold; }
          .MuiDataGrid-cell { color: rgba(0, 0, 0, 0.87); }
          .MuiDataGrid-row.selected-row-green .MuiDataGrid-cell { background-color: #e8f5e9 !important; }
          .MuiDataGrid-row.row-green .MuiDataGrid-cell { background-color: #e6ffe9 !important; }
          .MuiDataGrid-row.row-red .MuiDataGrid-cell { background-color: #ffebee !important; }
          .col-acesso-header { background-color: #2e7d32 !important; color: #fff !important; }
          .MuiDataGrid-row:not(.row-red):not(.row-green):not(.selected-row-green) .col-acesso-verde { background-color: #e8f5e9 !important; }
          .MuiDataGrid-row:not(.row-red):not(.row-green):not(.selected-row-green) .col-cinza { background-color: #fafafa !important; }
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
          rota="v1/rollouthuawei/excluirmanual"
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

          {mensagem.length > 0 && (
            <Alert severity="error" sx={{ mb: 2 }}>
              {mensagem}
            </Alert>
          )}

          {loading ? (
            <Loader />
          ) : (
            <>
              <div className="row g-3">
                <div className="col-sm-3">
                  <Button color="link" onClick={gerarexcel} disabled={loading}>
                    {loading ? (
                      <>
                        <CircularProgress size={16} sx={{ mr: 1 }} /> Carregando...
                      </>
                    ) : (
                      'Exportar Excel'
                    )}
                  </Button>
                </div>

                <div className="col-sm-9">
                  <div className="col-sm-12 d-flex flex-row-reverse gap-2">
                    <div>
                      <Button
                        color="primary"
                        onClick={chamarfiltro}
                        disabled={loading}
                      >
                        {loading ? (
                          <>
                            <CircularProgress size={16} sx={{ mr: 1 }} /> Aplicando...
                          </>
                        ) : (
                          'Aplicar Filtros'
                        )}
                      </Button>
                    </div>
                    <div>
                      <Button
                        color="primary"
                        onClick={() => marcarAvulso(false)}
                      >
                        Desmarcar como avulso
                      </Button>
                    </div>
                    <div>
                      <Button
                        color="primary"
                        onClick={() => marcarAvulso(true)}
                      >
                        Marcar como avulso
                      </Button>
                    </div>
                    <div>
                      <Button
                        color="success"
                        onClick={() => setShowAdicionarSiteManual(true)}
                      >
                        Adicionar site manualmente
                      </Button>
                    </div>
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
                  getRowId={(row) => getRowKey(row)}
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  disableSelectionOnClick
                  processRowUpdate={handleProcessRowUpdate}
                  onProcessRowUpdateError={handleProcessRowUpdateError}
                  rowSelectionModel={rowSelectionModel}
                  onCellEditCommit={handleCellEditCommit}
                  editMode="cell"
                  onRowSelectionModelChange={handleRowSelectionChange}
                  components={{
                    Pagination: CustomPagination,
                    NoRowsOverlay: CustomNoRowsOverlay,
                  }}
                  localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                  paginationModel={paginationModel}
                  onPaginationModelChange={setPaginationModel}
                  getRowClassName={getRowClassName}
                  getCellClassName={(x) =>
                    accessFields.includes(x.field)
                      ? 'col-acesso-verde'
                      : 'col-cinza'
                  }
                />
              </Box>
            </>
          )}
        </ModalBody>
        <ModalFooter>
          <Button
            color="primary"
            onClick={handleGerarSolicitacaoClick}
            disabled={loading}
          >
            Gerar material e/ou serviço
          </Button>
          <Button color="secondary" onClick={toggle}>
            Fechar
          </Button>
        </ModalFooter>
      </Modal>

      <AdicionarSiteManual
        show={showAdicionarSiteManual}
        setShow={setShowAdicionarSiteManual}
        onSiteAdded={listarollouthuawei}
        empresa="huawei"
      />

      <Modal
        isOpen={showGerarSolicitacaoModal}
        toggle={() => setShowGerarSolicitacaoModal(false)}
        backdrop="static"
      >
        <ModalHeader>Gerar solicitação de material/serviço</ModalHeader>
        <ModalBody>
          {!sitesValidosSolicitacao.length && (
            <Alert severity="error" sx={{ mb: 2 }}>
              Não é possível gerar solicitação de material para sites sem número de
              OS associado.
            </Alert>
          )}

          {sitesValidosSolicitacao.length > 0 && (
            <>
              <Typography variant="subtitle1" sx={{ mb: 1 }}>
                Sites incluídos na solicitação
              </Typography>
              <ul>
                {sitesValidosSolicitacao.map((s) => (
                  <li key={getRowKey(s)}>
                    {s.name} | {s.siteCode} | OS: {s.os}
                  </li>
                ))}
              </ul>
            </>
          )}

          {sitesBloqueadosSolicitacao.length > 0 && (
            <>
              <Alert severity="warning" sx={{ mt: 2, mb: 1 }}>
                Não é possível gerar solicitação de material para sites sem número de
                OS associado.
              </Alert>
              <Typography variant="subtitle1" sx={{ mb: 1 }}>
                Sites sem OS ou com OS inválido
              </Typography>
              <ul>
                {sitesBloqueadosSolicitacao.map((s) => (
                  <li key={getRowKey(s)}>
                    {s.name} | {s.siteCode} | OS:{' '}
                    {getOsFromRow(s) || '--'}
                  </li>
                ))}
              </ul>
            </>
          )}
        </ModalBody>
        <ModalFooter>
          {sitesBloqueadosSolicitacao.length > 0 && (
            <Button
              color="warning"
              onClick={handleRemoverBloqueadosDaSelecao}
            >
              Remover sites bloqueados da seleção
            </Button>
          )}
          <Button
            color="primary"
            onClick={handleConfirmGerarSolicitacao}
            disabled={
              loading ||
              !sitesValidosSolicitacao.length ||
              sitesBloqueadosSolicitacao.length > 0
            }
          >
            Confirmar
          </Button>
          <Button
            color="secondary"
            onClick={() => setShowGerarSolicitacaoModal(false)}
          >
            Fechar
          </Button>
        </ModalFooter>
      </Modal>

      {showSolicitacaoEdicao && (
        <Solicitacaoedicao
          isNew={showIsNew}
          show={showSolicitacaoEdicao}
          setshow={setShowSolicitacaoEdicao}
          atualiza={listarollouthuawei}
          payload={solicitacaoPayload}
          origem="rollout-huawei"
        />
      )}

    </>
  );
};

Rollouthuawei.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Rollouthuawei;

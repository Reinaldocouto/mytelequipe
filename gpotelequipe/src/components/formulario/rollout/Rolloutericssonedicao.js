import { useState, useEffect, useCallback } from 'react';
import PropTypes from 'prop-types';
import {
  Modal,
  ModalHeader,
  ModalBody,
  ModalFooter,
  Input,
  InputGroup,
  Button,
  CardBody,
} from 'reactstrap';
import PaidIcon from '@mui/icons-material/Paid';
import { grey, yellow, green } from '@mui/material/colors';
import Typography from '@mui/material/Typography';
import Select from 'react-select';
import Box from '@mui/material/Box';
import {
  DataGrid,
  GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import * as Icon from 'react-feather';
import { LinearProgress } from '@mui/material';
import { toast, ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { NumericFormat } from 'react-number-format';
import Pagination from '@mui/material/Pagination';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import CrqModal from '../../modals/CrqModal';
import Tarefaedicao from '../projeto/Tarefaedicao';
import Excluirregistro from '../../Excluirregistro';
import Solicitardiaria from '../projeto/Solicitardiaria';
import Solicitacaoedicao from '../suprimento/Solicitacaoedicao';
import api from '../../../services/api';
import { ChgModal } from '../../modals/ChgModal';
import { TpModal } from '../../modals/TpModal';

function TabPanel(props) {
  const { children, value, value1, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: 3 }}>
          <Typography>{children}</Typography>
        </Box>
      )}
    </div>
  );
}

TabPanel.propTypes = {
  children: PropTypes.node,
  index: PropTypes.number.isRequired,
  value: PropTypes.number.isRequired,
  value1: PropTypes.number.isRequired,
};

//import { CustomPagination, CustomNoRowsOverlay } from '../../../components/CustomDataGrid';

const Rolloutericssonedicao = ({ show, setshow, ididentificador, titulotopo, atualiza }) => {
  const [numero, setNumero] = useState('');
  const [cliente, setCliente] = useState('');
  const [regiona, setRegiona] = useState('');
  const [site, setSite] = useState('');

  const [situacaoimplantacao, setsituacaoimplantacao] = useState('');
  const [situacaodaintegracao, setsituacaodaintegracao] = useState('');
  const [datadacriacaodademandadia, setdatadacriacaodademandadia] = useState('');
  const [dataaceitedemandadia, setdataaceitedemandadia] = useState('');
  const [datainicioentregamosplanejadodia, setdatainicioentregamosplanejadodia] = useState('');
  const [datarecebimentodositemosreportadodia, setdatarecebimentodositemosreportadodia] =
    useState('');
  const [datafiminstalacaoplanejadodia, setdatafiminstalacaoplanejadodia] = useState('');
  const [dataconclusaoreportadodia, setdataconclusaoreportadodia] = useState('');
  const [datavalidacaoinstalacaodia, setdatavalidacaoinstalacaodia] = useState('');
  const [dataintegracaoplanejadodia, setdataintegracaoplanejadodia] = useState('');
  const [datavalidacaoeriboxedia, setdatavalidacaoeriboxedia] = useState('');
  const [aceitacao, setaceitacao] = useState('');
  const [pendencia, setpendencia] = useState('');
  const [telacadastrotarefa, settelacadastrotarefa] = useState(false);
  const [ididentificadortarefa, setididentificadortarefa] = useState('');
  const [loading, setloading] = useState(false);
  const [listamigo, setlistamigo] = useState([]);
  const [titulotarefa, settitulotarefa] = useState('');
  const [pageSize, setPageSize] = useState(10);
  const [valorhora, setvalorhora] = useState('');
  const [rowSelectionEquipeFixaModel, setRowSelectionEquipeFixaModel] = useState([]);
  const [idtp, setidtp] = useState(0);
  const [paginationModeldiarias, setPaginationModeldiarias] = useState({
    pageSize: 5,
    page: 0,
  });
  const [paginationModeldespesas, setPaginationModeldespesas] = useState({
    pageSize: 5,
    page: 0,
  });
  const [paginationModelacionamentopj, setPaginationModelacionamentopj] = useState({
    pageSize: 5,
    page: 0,
  });
  const [paginationModelvalorpo, setPaginationModelvalorpo] = useState({
    pageSize: 5,
    page: 0,
  });
  const [paginationModelmaterial, setPaginationModelmaterial] = useState({
    pageSize: 5,
    page: 0,
  });
  const [paginationModelatividadepj, setPaginationModelatividadepj] = useState({
    pageSize: 5,
    page: 0,
  });
  const [paginationModeltarefa, setPaginationModeltarefa] = useState({
    pageSize: 5,
    page: 0,
  });
  const [paginationModelacionamentoclt, setPaginationModelacionamentoclt] = useState({
    pageSize: 5,
    page: 0,
  });
  const [paginationModelobrafinal, setPaginationModelobrafinal] = useState({
    pageSize: 5,
    page: 0,
  });
  const [paginationModelcivilwork, setPaginationModelcivilwork] = useState({
    pageSize: 5,
    page: 0,
  });
  const [numeroacio, setnumeroacio] = useState('');
  const [telacadastrosolicitacaodiaria, settelacadastrosolicitacaodiaria] = useState(false);
  const [titulodiaria, settitulodiaria] = useState('');
  const [solicitacaodiaria, setsolicitacaodiaria] = useState([]);
  const [iddiaria, setiddiaria] = useState(0);
  const [telaexclusaodiaria, settelaexclusaodiaria] = useState(false);
  const [telaexclusaopj, settelaexclusaopj] = useState(false);
  const [telaexclusaoclt, settelaexclusaoclt] = useState(false);
  const [idacionamentopj, setidacionamentopj] = useState(0);
  const [idacionamentoclt, setidacionamentoclt] = useState(0);
  const [telaexclusaotp, settelaexclusaotp] = useState(false);
  const [pacotesacionadosclt, setpacotesacionadosclt] = useState([]);
  const [colaboradorlistapj, setcolaboradorlistapj] = useState([]);
  const [colaboradorlistaclt, setcolaboradorlistaclt] = useState([]);
  const [colaboradorlista, setcolaboradorlista] = useState([]);
  const [rowSelectionModel, setRowSelectionModel] = useState([]);
  const [rowSelectionModelPJ, setRowSelectionModelPJ] = useState([]);
  const [idcolaboradorpj, setidcolaboradorpj] = useState('');
  const [selectedoptioncolaboradorpj, setselectedoptioncolaboradorpj] = useState(null);
  const [lpulista, setlpulista] = useState([]);
  const [lpuhistorico, setlpuhistorico] = useState('');
  const [selectedoptionlpu, setselectedoptionlpu] = useState(null);
  const [valornegociado, setvalornegociado] = useState(0);
  const [observacaopj, setobservacaopj] = useState('');
  const [colaboradoremail, setcolaboradoremail] = useState('');
  const [emailadcional, setemailadcional] = useState('');
  const [arquivoanexo, setarquivoanexo] = useState('');
  const [idcolaboradorclt, setidcolaboradorclt] = useState('');
  const [selectedoptioncolaboradorclt, setselectedoptioncolaboradorclt] = useState(null);
  const [datainicioclt, setdatainicioclt] = useState('');
  const [datafinalclt, setdatafinalclt] = useState('');
  const [horanormalclt, sethoranormalclt] = useState('');
  const [hora50clt, sethora50clt] = useState('');
  const [hora100clt, sethora100clt] = useState('');
  const [totalhorasclt, settotalhorasclt] = useState('');
  const [observacaoclt, setobservacaoclt] = useState('');
  const [identificadorsolicitacao, setidentificadorsolicitacao] = useState('');
  const [titulo, settitulo] = useState('');
  const [telacadastrosolicitacao, settelacadastrosolicitacao] = useState('');
  const [poservicolista, setposervicolista] = useState([]);
  const [materialeservico, setmaterialeservico] = useState([]);
  const [telacadastroedicaosolicitacao, settelacadastroedicaosolicitacao] = useState('');
  const [telaexclusaosolicitacao, settelaexclusaosolicitacao] = useState('');
  const [nomecolaboradorpj, setnomecolaboradorpj] = useState('');
  const [tps, setTps] = useState([]);
  const [atividadepjlista, setatividadepjlista] = useState([]);
  const [retanexo, setretanexo] = useState('');
  const [loadingpj, setloadingpj] = useState(false);

  const [usuario, setusuario] = useState('');
  const [documentacaoobrafinal, setdocumentacaoobrafinal] = useState([]);
  const [documentacaocivilwork, setdocumentacaocivilwork] = useState([]);
  const [ericFechamento, setEricFechamento] = useState(0);

  const [longitude, setLongitude] = useState('');
  const [totalfinanceiro, setTotalFinanceiro] = useState();
  const [loadingFinanceiro, setloadingFinanceiro] = useState(false);
  const [relatorioDespesas, setRelatorioDespesas] = useState([]);
  const [identificadorsolicitacaodiaria, setidentificadorsolicitacaodiaria] = useState('');
  const [outros, setOutros] = useState('');
  const [formaAcesso, setFormaAcesso] = useState('');
  const [ddd, setDdd] = useState('');
  const [municipio, setMunicipio] = useState('');
  const [nomeEricsson, setNomeEricsson] = useState('');
  const [enderecoSite, setEnderecoSite] = useState('');
  const [latitude, setLatitude] = useState('');
  const [obs, setObs] = useState('');
  const [solicitacao, setSolicitacao] = useState('');
  const [dataSolicitacao, setDataSolicitacao] = useState('');
  const [dataInicial, setDataInicial] = useState('');
  const [dataFinal, setDataFinal] = useState('');
  const [statusAcesso, setStatusAcesso] = useState('');
  const [observacoes, setobservacoes] = useState('');
  const [statussydle, setstatussydle] = useState('');
  const [atividade, setatividade] = useState('');
  const [tipoinstalacao, settipoinstalacao] = useState('');
  const [impacto, setimpacto] = useState('');
  const [ncrq, setncrq] = useState('');
  const [iniciocrq, setiniciocrq] = useState('');
  const [fimcrq, setfimcrq] = useState('');
  const [crqdeinstalacao, setcrqdeinstalacao] = useState('');
  const [obraPreenchidaNaSydle, setobrapreenchidanasydle] = useState(false);
  const [statuscrq, setstatuscrq] = useState('');
  const [equipefixa, setequipefixa] = useState('');
  const [statatussydle, setstatatussydle] = useState('');
  const [tpModalOpen, setTpModalOpen] = useState(false);
  const [central, setcentral] = useState('');
  const [detentora, setdetentora] = useState('');
  const [iddentedora, setiddentedora] = useState(0);
  const [numeroativo, setnumeroativo] = useState('');
  const [statusvalidadeAcesso, setstatusvalidadeAcesso] = useState('');
  const [tpLoading, setTpLoading] = useState(false);
  const [chgModalOpen, setChgModalOpen] = useState(false);
  const tpTipos = ['S/IMPACTO', 'IMPACTO'];
  const tpStatus = ['Autorizada', 'Cancelada', 'Fechado', 'Pedir', 'Pré-Aprovada'];
  const [tpForm, setTpForm] = useState({
    siteId: '',
    tipo: 'S/IMPACTO',
    criadoEm: '',
    dataInicio: '',
    horaInicio: '',
    dataFim: '',
    horaFim: '',
    sequenciaTp: '',
    status: 'Pré-Aprovada',
    itpPercent: 0,
  });

  const [crqModalOpen, setCrqModalOpen] = useState(false);
  const [paginationModelEquipeFixa, setPaginationModellEquipeFixa] = useState({
    pageSize: 5,
    page: 0,
  });

  const clearCrqForm = () => {
    setTpForm({
      id: null,
      siteId: '',
      tipo: 'CRQ',
      criadoEm: '',
      dataInicio: '',
      horaInicio: '',
      dataFim: '',
      horaFim: '',
      sequenciaTp: '',
      itpPercent: 0,
      impacto: 'TOTAL',
      status: 'APROVADA',
    });
  };

  const clearTpForm = () => {
    setTpForm({
      siteId: '',
      tipo: 'S/IMPACTO',
      criadoEm: '',
      dataInicio: '',
      horaInicio: '',
      dataFim: '',
      horaFim: '',
      sequenciaTp: '',
      status: 'Pré-Aprovada',
      itpPercent: 0,
    });
  };

  const abrirCrqModal = () => {
    clearCrqForm();
    setCrqModalOpen(true);
  };

  const formatDatePtBR = (value) => {
    if (!value) return '';

    let d;

    if (typeof value === 'string') {
      const s = value.trim();
      if (s.length === 0) return '';

      // ISO: YYYY-MM-DD ou YYYY-MM-DDTHH:mm:ss
      const isoMatch = s.match(/^(\d{4})-(\d{2})-(\d{2})(?:[T\s](\d{2}):(\d{2})(?::(\d{2}))?)?$/);
      if (isoMatch) {
        const year = parseInt(isoMatch[1], 10);
        const month = parseInt(isoMatch[2], 10) - 1;
        const day = parseInt(isoMatch[3], 10);
        const hh = isoMatch[4] ? parseInt(isoMatch[4], 10) : 0;
        const mm = isoMatch[5] ? parseInt(isoMatch[5], 10) : 0;
        const ss = isoMatch[6] ? parseInt(isoMatch[6], 10) : 0;
        // Cria data em horário local para evitar deslocamento por fuso
        d = new Date(year, month, day, hh, mm, ss);
      } else {
        // dd/mm/yyyy
        const brMatch = s.match(/^(\d{2})\/(\d{2})\/(\d{4})$/);
        if (brMatch) {
          const day = parseInt(brMatch[1], 10);
          const month = parseInt(brMatch[2], 10) - 1;
          const year = parseInt(brMatch[3], 10);
          d = new Date(year, month, day);
        } else {
          // Fallback: tenta parse nativo
          d = new Date(s);
        }
      }
    } else {
      d = value instanceof Date ? value : new Date(value);
    }

    if (Number.isNaN(d.getTime())) return '';

    // Oculta sentinela 30/12/1899
    if (d.getDate() === 30 && d.getMonth() === 11 && d.getFullYear() === 1899) return '';

    return d.toLocaleDateString('pt-BR');
  };

  const editarTP = (row) => {
    const novoForm = {
      ...tpForm,
      id: row.id ?? tpForm.id,
      siteId: `ERICSON${row.siteId}`,
      tipo: row.tipo ?? '',
      criadoEm: row.criadoEm ?? row.criado_em ?? '',
      dataInicio: row.dataInicio ?? row.data_inicio ?? '',
      horaInicio: row.horaInicio ?? row.hora_inicio ?? '',
      dataFim: row.dataFim ?? row.data_fim ?? '',
      horaFim: row.horaFim ?? row.hora_fim ?? '',
      sequenciaTp: row.sequenciaTp ?? row.sequencia_tp ?? '',
      status: row.status ?? '',
      itpPercent: row.itpPercent ?? row.itp_percent ?? 0,
      deletado: Boolean(row.deletado ?? row.deleted ?? false),
      empresa: row.empresa ?? '',
      numero: row.numero ?? row.numeroCrq ?? '',
      tipoRegistro: row.tipoRegistro ?? row.tipo_registro ?? '',
      impacto: row.impacto ?? '',
      descricao: row.descricao ?? '',
      createdAt: row.createdAt ?? row.created_at ?? '',
      updatedAt: row.updatedAt ?? row.updated_at ?? '',
    };

    console.log('novoForm', novoForm);
    setTpForm(novoForm);
    console.log('form', tpForm);

    const tipoRegistro = row.tipoRegistro ?? row.tipo_registro;

    if (tipoRegistro === 'CHG') {
      setChgModalOpen(true);
    }
    if (tipoRegistro === 'CRQ') {
      setCrqModalOpen(true);
    }
  };

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idlocal: ididentificador,
    idprojetoericsson: ididentificador,
    idcontroleacessobusca: localStorage.getItem('sessionId'),
    regiona,
    deletado: 0,
    osouobra: ididentificador,
    obra: numero,
    projeto: 'ERICSSON',
  };

  const tpColumns = [
    {
      field: 'actions',
      type: 'actions',
      headerName: 'Ações',
      width: 120,
      align: 'center',
      sortable: false,
      getActions: (paramsTp) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Editar"
          onClick={() => editarTP(paramsTp.row)}
          showInMenu={false}
        />,
        <GridActionsCellItem
          icon={<DeleteIcon />}
          label="Excluir"
          onClick={() => {
            settelaexclusaotp(true);
            setidtp(paramsTp.row.id);
          }}
          showInMenu={false}
        />,
      ],
    },
    {
      field: 'tipo',
      headerName: 'Tipo',
      width: 130,
      type: 'singleSelect',
      editable: true,
      valueOptions: tpTipos,
    },
    {
      field: 'tipoRegistro',
      headerName: 'Registro',
      width: 100,
      type: 'string',
      editable: false,
      valueOptions: tpStatus,
    },
    {
      field: 'criadoEm',
      headerName: 'Criado em',
      width: 140,
      type: 'string',
      editable: true,
      valueFormatter: ({ value }) => formatDatePtBR(value),
    },
    {
      field: 'dataInicio',
      headerName: 'Data Início',
      width: 130,
      type: 'string',
      editable: true,
      valueFormatter: ({ value }) => formatDatePtBR(value),
    },
    { field: 'horaInicio', headerName: 'Hora Início', width: 120, type: 'string', editable: true },
    {
      field: 'dataFim',
      headerName: 'Data Fim',
      width: 130,
      type: 'string',
      editable: true,
      valueFormatter: ({ value }) => formatDatePtBR(value),
    },
    { field: 'horaFim', headerName: 'Hora Fim', width: 120, type: 'string', editable: true },
    {
      field: 'sequenciaTp',
      headerName: 'Sequência TP',
      width: 160,
      type: 'string',
      editable: true,
    },
    {
      field: 'status',
      headerName: 'Status',
      width: 160,
      type: 'singleSelect',
      editable: true,
      valueOptions: tpStatus,
    },
    {
      field: 'itpPercent',
      headerName: 'ITP %',
      width: 100,
      type: 'number',
      editable: true,
      valueFormatter: ({ value }) =>
        value !== null && value !== undefined ? `${Number(value)}%` : '',
    },
    {
      field: 'numero',
      headerName: 'Número',
      width: 130,
      type: 'string',
      editable: false,
    },
    {
      field: 'impacto',
      headerName: 'Impacto',
      width: 130,
      type: 'string',
      editable: false,
    },
    // descricao
    {
      field: 'descricao',
      headerName: 'Descrição',
      width: 200,
      type: 'string',
      editable: false,
    },
  ];

  const processRowUpdateTp = async (newRow, oldRow) => {
    try {
      toast.success('TP atualizada.');
      return newRow;
    } catch (err) {
      console.error('Erro ao atualizar TP:', err);
      toast.error(err.response?.data?.erro || 'Falha ao atualizar TP.');
      return oldRow;
    }
  };

  const carregarTPs = useCallback(async () => {
    try {
      setTpLoading(true);
      const response = await api.get('v1/acesso/tp', {
        params: { siteId: `ERICSSON${ididentificador}`, deletado: 0, empresa: 'ERICSSON' },
      });
      const dados = Array.isArray(response.data) ? response.data : [];
      const dadosFormatados = dados.map((item, idx) => ({
        id: item.id || `${idx}-${Date.now()}`,
        siteId: item.numero,
        tipo: item.tipo,
        criadoEm: item.criadoEm,
        dataInicio: item.dataInicio,
        horaInicio: item.horaInicio,
        dataFim: item.dataFim,
        horaFim: item.horaFim,
        sequenciaTp: item.sequenciaTp,
        numero: item.numero,
        tipoRegistro: item.tipoRegistro,
        status: item.status,
        itpPercent: item.itpPercent,
        impacto: item.impacto,
        descricao: item.descricao,
      }));
      setTps(dadosFormatados);
    } catch (err) {
      console.error('Erro ao carregar TPs:', err);
      setTps([]);
    } finally {
      setTpLoading(false);
    }
  }, [tpForm?.siteId]);

  const criarTP = async (id = ' ', pai, empresa) => {
    console.log(pai, empresa);
    // Validação mínima
    if (!tpForm?.siteId && pai === 'TP') {
      toast.warning('Informe o Site ID para vincular a TP.');
      return;
    }
    if (!tpForm?.criadoEm) {
      toast.warning('Informe a data "Criado em".');
      return;
    }

    const payload = {
      id,
      siteId: `ERICSSON${ididentificador}`,
      tipo: tpForm.tipo,
      criadoEm: tpForm.criadoEm,
      dataInicio: tpForm.dataInicio,
      horaInicio: tpForm.horaInicio,
      dataFim: tpForm.dataFim,
      horaFim: tpForm.horaFim,
      sequenciaTp: tpForm.sequenciaTp,
      status: tpForm.status,
      numero: tpForm.numero,
      empresa,
      tipoRegistro: pai,
      itpPercent: Number(tpForm.itpPercent) || 0,
    };

    try {
      setTpLoading(true);
      await api.post('v1/acesso/tp', payload);
      toast.success('TP criada com sucesso!');
      await carregarTPs();
      // limpa parcialmente o form, mantendo site
      setTpForm((prev) => ({
        ...prev,
        tipo: 'S/IMPACTO',
        criadoEm: '',
        dataInicio: '',
        horaInicio: '',
        dataFim: '',
        horaFim: '',
        sequenciaTp: '',
        status: 'Pré-Aprovada',
        itpPercent: 0,
      }));
    } catch (err) {
      console.error('Erro ao criar TP:', err);
      toast.error(err.response?.data?.erro || 'Falha ao criar TP.');
    } finally {
      setTpLoading(false);
      setTpModalOpen(false);
      setChgModalOpen(false);
    }
  };

  const abrirChgModal = () => setChgModalOpen(true);

  const handleTpFormChange = (e) => {
    const { name, value } = e.target;
    setTpForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleCloseModal = (type) => {
    if (type === 'tp') {
      setTpModalOpen(false);
    } else if (type === 'chg') {
      setChgModalOpen(false);
    }

    clearTpForm();
  };

  const salvarCrq = async (data) => {
    try {
      const payload = {
        id: data?.id,
        siteId: `ERICSSON${ididentificador}`,
        descricao: data.descricao?.trim(),
        tipoRegistro: 'CRQ',
        impacto: data.impacto,
        numero: data.numeroCrq?.trim(),
        dataInicio: data.dataInicio || null,
        dataFim: data.dataFim || null,
        status: data.status,
        tipo: data.tipo,
        empresa: 'ERICSSON',
      };
      await api.post('v1/acesso/tp', payload);
      setCrqModalOpen(false);
      carregarTPs();
    } catch (err) {
      console.error(err);
    }
  };

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

  const modoVisualizador = () => {
    return false;
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
          onChange={(event, value2) => apiRef.current.setPage(value2 - 1)}
        />
      </Box>
    );
  }

  function CustomPaginationclt() {
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
          onChange={(event, value2) => apiRef.current.setPage(value2 - 1)}
        />
      </Box>
    );
  }

  const despesasrelaotrioericsson = async () => {
    try {
      setloadingFinanceiro(true);
      const response = await api.get('v1/projetoericsson/relatoriodespesas', {
        params: {
          site: ididentificador,
          ...params,
        },
      });

      const dadosFormatados = response.data?.map((item) => ({
        ...item,
        id: item.id || Math.random().toString(36).substr(2, 9),
        valor: item.valor ? parseFloat(item.valor) : null,
        dataacionamento: item.dataacionamento ? new Date(item.dataacionamento) : null,
      }));
      const somaDosValores = dadosFormatados?.reduce((total, item) => total + (item.valor || 0), 0);
      setTotalFinanceiro(somaDosValores || 0);
      setRelatorioDespesas(dadosFormatados || []);
    } catch (err) {
      toast.error(err.response?.data?.message || err.message);
      setRelatorioDespesas([]);
    } finally {
      setloadingFinanceiro(false);
    }
  };

  const listaid = async () => {
    try {
      setloading(true);

      const response = await api.get('v1/projetoericsson/id', { params });

      const { data } = response;
      console.log(data);
      console.log(data.ddd);
      setNumero(ididentificador);
      setCliente(data.cliente);
      setRegiona(data.regiona);
      setSite(data.site);

      setsituacaoimplantacao(data.situacaoimplantacao);
      setsituacaodaintegracao(data.situacaodaintegracao);

      setdatadacriacaodademandadia(data.datadacriacaodademandadia || '');
      setdataaceitedemandadia(data.dataaceitedemandadia || '');
      setdatainicioentregamosplanejadodia(data.datainicioentregamosplanejadodia || '');
      setdatarecebimentodositemosreportadodia(data.datarecebimentodositemosreportadodia || '');
      setdatafiminstalacaoplanejadodia(data.datafiminstalacaoplanejadodia || '');
      setdataconclusaoreportadodia(data.dataconclusaoreportadodia || '');
      setdatavalidacaoinstalacaodia(data.datavalidacaoinstalacaodia || '');
      setdataintegracaoplanejadodia(data.dataintegracaoplanejadodia || '');
      setdatavalidacaoeriboxedia(data.datavalidacaoeriboxedia || '');

      setDataInicial(data.datainicial || '');
      setDataFinal(data.datafinal || '');
      setDataSolicitacao(data.datasolicitacao || '');
      setDdd(data.ddd);

      setEnderecoSite(data.localizacaositeendereco || '');
      setMunicipio(data.municipio || data.localizacaositecidade || '');
      setLatitude(data.latitude || '');
      setLongitude(data.longitude || '');

      setFormaAcesso(data.formadeacesso || '');
      setOutros(data.outros || '');
      setNomeEricsson(data.nomeericsson || '');
      setObs(data.obs || '');
      setSolicitacao(data.solicitacao || '');
      setStatusAcesso(data.statusacesso || '');
      // ----- NOVOS CAMPOS -----
      console.log(data.statussydle);
      setstatatussydle(data.statussydle || '');
      setatividade(data.atividade || '');
      settipoinstalacao(data.tipoinstalacao || '');
      setimpacto(data.impacto || '');
      setncrq(data.ncrq || '');
      setiniciocrq(data.iniciocrq || '');
      setfimcrq(data.fimcrq || '');
      setstatuscrq(data.statuscrq || '');
      setcrqdeinstalacao(data.crqdeinstalacao || '');
      setobservacoes(data.observacoes || '');
      setcentral(data.central || '');
      setdetentora(data.detentora || '');
      setiddentedora(data.iddentedora || 0);
      setnumeroativo(data.numeroativo || '');
      setobrapreenchidanasydle(data.obrapreenchidanasydle ?? '');
      /* se quiser exibir o novo "enderecosite" também: */
      setEnderecoSite(data.enderecosite || data.localizacaositeendereco || '');
      setstatusvalidadeAcesso(response.data.status_vencimento);

      // Equipe fixa (converte arrays do backend para o Select)
      (() => {
        const ids = Array.isArray(data.equipefixaIds) ? data.equipefixaIds : [];
        const nomes = Array.isArray(data.equipefixaNomes) ? data.equipefixaNomes : [];
        const selecionados = ids.map((id, i) => ({
          value: id,
          label: nomes[i] || String(id),
        }));
        setequipefixa(selecionados);
      })();

      setemailadcional(data.emailadcional || '');
      setaceitacao(data.aceitacaofical || '');
      setpendencia(data.pendenciasobra || '');
      setTimeout(() => {}, 3000);
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const listalpu = async (idc, icr) => {
    try {
      await api.get(`v1/projetoericsson/listalpu/${idc}/${icr}`, { params }).then((response) => {
        setlpulista(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      console.log('');
    }
  };

  const handleChangecolaboradorclt = (stat) => {
    if (stat !== null) {
      setidcolaboradorclt(stat.value);
      setvalorhora(stat.valorhora);
      setselectedoptioncolaboradorclt({ value: stat.value, label: stat.label });
    } else {
      setidcolaboradorclt(0);
      setselectedoptioncolaboradorclt({ value: null, label: null });
    }
  };

  const handleChangecolaboradorpj = (stat) => {
    if (stat !== null) {
      setidcolaboradorpj(stat.value);
      setselectedoptioncolaboradorpj({ value: stat.value, label: stat.label });
      setcolaboradoremail(stat.email);
      setnomecolaboradorpj(stat.label);
      setemailadcional(stat.adicional);
      listalpu(stat.value);
    } else {
      setidcolaboradorpj(0);
      setcolaboradoremail('');
      setnomecolaboradorpj('');
      setselectedoptioncolaboradorpj({ value: null, label: null });
    }
  };

  const novocadastrotarefa = async () => {
    console.log('Chaamda da tarefa');
    const idcliente = localStorage.getItem('sessionCodidcliente');
    const idusuario = localStorage.getItem('sessionId');
    const idloja = localStorage.getItem('sessionloja');

    try {
      const response = await api.post('v1/projetoericsson/novocadastrotarefa', {
        idcliente,
        idusuario,
        idloja,
      });
      console.log('Retorno da tarefa');
      console.log(response);

      if (response && response.data) {
        setididentificadortarefa(response.data.retorno);
        settitulotarefa('Cadastro nova tarefa');
        settelacadastrotarefa(true);
        console.log('Tarefa criada com sucesso:', response.data.retorno);
      } else {
        toast.error('Resposta inválida do servidor.');
      }
    } catch (err) {
      if (err.response && err.response.data && err.response.data.erro) {
        toast.error(err.response.data.erro);
      } else {
        toast.error('Ocorreu um erro na requisição.');
      }
    }
  };

  const handleChangelpu = (stat) => {
    if (stat !== null) {
      if (stat.label === 'NEGOCIADO') {
        if (usuario !== '33' && usuario !== '35' && usuario !== '78') {
          setlpuhistorico('');
          setselectedoptionlpu({ value: null, label: null });
          toast.warning('Você não tem permissão para acionar PJ com valor negociado.');
        } else {
          setlpuhistorico(stat.label);
          setselectedoptionlpu({ value: stat.value, label: stat.label });
        }
      } else {
        setlpuhistorico(stat.label);
        setselectedoptionlpu({ value: stat.value, label: stat.label });
      }
    } else {
      setlpuhistorico('');
      setselectedoptionlpu({ value: null, label: null });
    }
  };

  const listapormigo = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/listamigo', { params }).then((response) => {
        setlistamigo(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const columnsmigo = [
    {
      field: 'po',
      headerName: 'PO',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'poritem',
      headerName: 'PO+Item',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'datacriacaopo',
      headerName: 'Data Criação PO',
      width: 120,
      align: 'left',
      editable: false,
    },
    {
      field: 'escopo',
      headerName: 'Escopo',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'codigoservico',
      headerName: 'Código Serviço',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'descricaoservico',
      headerName: 'Descrição Serviço',
      width: 300,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'qtyordered',
      headerName: 'Quantidade',
      width: 100,
      align: 'center',
      editable: false,
    },
  ];

  const valorpo = [
    {
      field: 'po',
      headerName: 'PO',
      width: 160,
      align: 'left',
      editable: false,
    },
    {
      field: 'poritem',
      headerName: 'PO+Item',
      width: 160,
      align: 'left',
      editable: false,
    },
    {
      field: 'datacriacaopo',
      headerName: 'Data Criação PO',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'codigoservico',
      headerName: 'Código Serviço',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'descricaoservico',
      headerName: 'Descrição Serviço',
      width: 320,
      align: 'left',
      editable: false,
    },
    {
      field: 'qtyordered',
      headerName: 'Quantidade',
      width: 100,
      align: 'center',
      editable: false,
    },
    {
      field: 'medidafiltrounitario',
      headerName: 'Valor Unitário R$',
      width: 140,
      align: 'left',
      editable: false,
    },
    {
      field: 'medidafiltro',
      headerName: 'Total R$',
      width: 100,
      align: 'left',
      editable: false,
    },
  ];

  const columnsescopo = [
    {
      field: 'label',
      headerName: 'Descrição Serviço',
      width: 450,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'po',
      headerName: 'PO',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'siteid',
      headerName: 'SIGLA',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
  ];

  const columnsFinanceiro = [
    {
      field: 'idpmts',
      headerName: 'OBRA',
      width: 100,
      align: 'left',
      type: 'string',
    },
    {
      field: 'nome',
      headerName: 'NOME',
      width: 370,
      align: 'left',
      type: 'string',
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'tipo',
      headerName: 'TIPO',
      width: 160,
      align: 'left',
      type: 'string',
    },
    {
      field: 'descricao',
      headerName: 'DESCRIÇÃO',
      width: 400,
      align: 'left',
      type: 'string',
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'dataacionamento',
      headerName: 'DATA ACIONAMENTO',
      width: 150,
      align: 'center',
      valueFormatter: (item) =>
        item.value ? new Date(item.value).toLocaleDateString('pt-BR') : '',
    },
    {
      field: 'valor',
      headerName: 'VALOR',
      width: 150,
      align: 'right',
      valueFormatter: (item) =>
        item.value
          ? item.value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })
          : '',
    },
  ];

  function deletediaria(stat) {
    setiddiaria(stat);
    settelaexclusaodiaria(true);
  }

  const colunasdiarias = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<DeleteIcon />}
          label="Delete"
          title="Delete"
          onClick={() => deletediaria(parametros.id)}
        />,
      ],
    },
    {
      field: 'datasolicitacao',
      headerName: 'Data',
      width: 130,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) =>
        parametros.value ? new Date(`${parametros.value}T00:00:00`) : null,
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'nome',
      headerName: 'Nome Colaborador',
      type: 'string',
      width: 290,
      align: 'left',
      editable: false,
    },
    {
      field: 'descricao',
      headerName: 'Descrição',
      type: 'string',
      width: 290,
      align: 'left',
      editable: false,
    },
    {
      field: 'valoroutrassolicitacoes',
      headerName: 'Outras Solicitações',
      type: 'number',
      width: 150,
      align: 'right',
      valueFormatter: (parametros) => {
        if (parametros.value == null) return '';
        return parametros.value.toLocaleString('pt-BR', {
          style: 'currency',
          currency: 'BRL',
        });
      },
      editable: false,
    },
    {
      field: 'valortotal',
      headerName: 'Valor Total',
      type: 'number',
      width: 150,
      align: 'right',
      valueFormatter: (parametros) => {
        if (parametros.value == null) return '';
        return parametros.value.toLocaleString('pt-BR', {
          style: 'currency',
          currency: 'BRL',
        });
      },
      editable: false,
    },
    {
      field: 'solicitante',
      headerName: 'Solicitante',
      type: 'string',
      width: 250,
      align: 'left',
      editable: false,
    },
  ];

  function deleteUser(stat) {
    setidacionamentopj(stat);
    settelaexclusaopj(true);
  }

  const colunaspacotesacionados = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => {
        const { porcentagem } = parametros.row;
        if (porcentagem > 0) {
          return [
            <GridActionsCellItem
              icon={<DeleteIcon style={{ color: grey[500] }} />}
              label="Já houve pagamento"
              title="Já houve pagamento"
              onClick={(event) => {
                event.stopPropagation();
                toast.error('Já houve pagamento');
              }}
            />,
          ];
        }
        return [
          <GridActionsCellItem
            icon={<DeleteIcon />}
            label="Delete"
            title="Delete"
            onClick={() => deleteUser(parametros.id)}
          />,
        ];
      },
    },
    {
      field: 'fantasia',
      headerName: 'Empresa',
      width: 250,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'po',
      headerName: 'PO',
      width: 130,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'poitem',
      headerName: 'PO+ITEM',
      width: 130,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'descricaoservico',
      headerName: 'Descrição Serviço',
      width: 350,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'dataacionamento',
      headerName: 'Data Acionamento',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'datadeenviodoemail',
      headerName: 'Data de Envio do E-mail',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
  ];

  const novocadastrodiaria = async () => {
    try {
      const response = await api.post('v1/solicitacao/novocadastrodiaria', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      });

      if (response.status !== 201) {
        toast.error(`Erro: status ${response.status}`);
        return;
      }

      const novoId = response.data.retorno;
      setidentificadorsolicitacaodiaria(novoId);
      settitulodiaria('Cadastrar Solicitação de Diaria');
      settelacadastrosolicitacaodiaria(true);

      const formData = new FormData();
      formData.append('idsolicitacaodiaria', novoId);
    } catch (err) {
      if (err.response?.data?.erro) {
        toast.error(err.response.data.erro);
      } else {
        toast.error('Ocorreu um erro na requisição.');
      }
      console.error('Erro ao enviar e-mail de diária:', err);
    }
  };

  const obrafinal = [
    {
      field: 'numero',
      headerName: 'Numero',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'site',
      headerName: 'SIGLA',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'documentacaonome',
      headerName: 'Tipo Documento',
      width: 350,
      align: 'left',
      editable: false,
    },
    {
      field: 'documentacaosituacao',
      headerName: 'Situação',
      width: 250,
      align: 'left',
      editable: false,
    },
  ];

  const civilwork = [
    {
      field: 'numero',
      headerName: 'Número',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'site',
      headerName: 'SIGLA',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'documentacaonome',
      headerName: 'Tipo do documento',
      width: 350,
      align: 'left',
      editable: false,
    },
    {
      field: 'documentacaosituacao',
      headerName: 'Situação',
      width: 350,
      align: 'left',
      editable: false,
    },
  ];

  const listapos = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/selectprojeto', { params }).then((response) => {
        setposervicolista(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const listadocumentacaoobrafinalcivilwork = async () => {
    try {
      setloading(true);
      await api
        .get('v1/projetoericsson/documentacaofinalcivilwork', { params })
        .then((response) => {
          setdocumentacaocivilwork(response.data);
        });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const listadocumentacaoobrafinal = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/documentacaofinal', { params }).then((response) => {
        setdocumentacaoobrafinal(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const acessoFinanceiro = async () => {
    try {
      const response = await api.get('v1/cadusuariosistemaid', { params });
      setEricFechamento(response.data.ericfechamento);
      console.log('Eric Fechamento:', response.data.ericfechamento);
    } catch (err) {
      console.error(err.message);
    }
  };

  const listasolicitacaodiaria = async () => {
    try {
      setloading(true);
      await api.get('v1/projetotelefonica/diaria', { params }).then((response) => {
        setsolicitacaodiaria(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const listacolaboradorpj = async () => {
    try {
      setloading(true);
      await api.get('v1/empresas/selectpj', { params }).then((response) => {
        setemailadcional(response.data?.adicional);
        setcolaboradorlistapj(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const listacolaborador = async () => {
    try {
      setloading(true);
      const reg = regiona;
      let regional = null;
      switch (reg) {
        case 'RSU MG':
          regional = 'MG';
          break;
        case 'RSU SPC':
        case 'RSU SPI':
          regional = 'SP';
          break;
        case 'RSU NE':
          regional = 'NE';
          break;
        case 'RSU RJ':
          regional = 'RJ';
          break;
        default:
          regional = null;
      }
      await api.get('v1/pessoa', { params: { regional, mostrarInativos: 1 } }).then((response) => {
        const options = response.data.map((item) => ({
          label: item.nome,
          value: String(item.idpessoa),
          isDisabled: item.nome?.includes('(INATIVO)'),
        }));
        setcolaboradorlista(options);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };
  useEffect(() => {
    listacolaborador();
  }, [regiona]);

  const listacolaboradorclt = async () => {
    try {
      setloading(true);
      await api.get('v1/pessoa/selectclt', { params }).then((response) => {
        setcolaboradorlistaclt(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const listaatividadepj = async () => {
    try {
      setloadingpj(true);
      await api.get('v1/projetoericsson/listaatividadepj', { params }).then((response) => {
        setatividadepjlista(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloadingpj(false);
    }
  };

  const salvarpj = async (poit) => {
    api
      .post('v1/projetoericsson/listaatividadepj/salva', {
        numero: ididentificador,

        selecao: poit,

        idcolaboradorpj,
        observacaopj,

        lpuhistorico,
        valornegociadonum: valornegociado.toString().replace('.', ','),
      })
      .then((response) => {
        if (response.status === 201) {
          toast.success('Registro Salvo');
          listaatividadepj();
        } else {
          toast.error(response.status);
        }
      })
      .catch((err) => {
        if (err.response) {
          toast.error(err.response.data.erro);
        } else {
          toast.error('Ocorreu um erro na requisição.');
        }
      });
  };

  const svlista = async () => {
    rowSelectionModel.forEach((idSelecionado) => {
      const itemSelecionado = poservicolista.find((item) => item.id === idSelecionado);
      if (!itemSelecionado) return;

      const { value } = itemSelecionado;

      /*  const existe = atividadepjlista.some(
          (item) => item.poitem?.toString() === value?.toString()
        );*/

      salvarpj(value);
      /*  if (!existe) {
          salvarpj(value);
        } else {
          camposExistentes.push(value);
        } */
    });

    listaatividadepj();

    /*  if (camposExistentes.length > 0) {
        toast.error(
          `Existem campos já inseridos, remova para adicionar os novos. (${camposExistentes.join(', ')})`
        );
      } */
  };

  const listaatividadeclt = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/listaatividadeclt', { params }).then((response) => {
        setpacotesacionadosclt(response.data);
        setselectedoptioncolaboradorclt({
          value: response.data.idcolaboradorclt,
          label: response.data.colaboradorclt,
        });
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  function deleteuserclt(stat) {
    setidacionamentoclt(stat);
    settelaexclusaoclt(true);
    listaatividadeclt();
  }

  const colunaspacotesacionadosclt = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<DeleteIcon />}
          label="Delete"
          title="Delete"
          onClick={() => deleteuserclt(parametros.id)}
        />,
      ],
    },
    {
      field: 'datainicio',
      headerName: 'Data Início',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'datafin',
      headerName: 'Data Final',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'colaboradorclt',
      headerName: 'Colaborador',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (p) => <div style={{ whiteSpace: 'pre-wrap' }}>{p.value}</div>,
    },
    {
      field: 'po',
      headerName: 'PO',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'descricaoservico',
      headerName: 'Descrição Serviço',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (p) => <div style={{ whiteSpace: 'pre-wrap' }}>{p.value}</div>,
    },
    {
      field: 'totalhorasclt',
      headerName: 'Total de Horas',
      width: 120,
      align: 'center',
      type: 'number',
      editable: false,
    },
  ];

  const execacionamentoclt = async () => {
    if (!rowSelectionModel || rowSelectionModel.length === 0) {
      toast.error('Selecione ao menos uma atividade');
      return;
    }

    const results = await Promise.allSettled(
      rowSelectionModel.map(async (idSelecionado) => {
        const poservico = poservicolista.find((item) => item.id === idSelecionado);

        if (!poservico) {
          return { id: idSelecionado, status: 'rejected' };
        }

        try {
          const response = await api.post('v1/projetoericsson/listaatividadeclt/salva', {
            numero: ididentificador,
            po: poservico.value,
            descricaoservico: poservico.label,
            idcolaboradorclt,
            datainicioclt,
            datafinalclt,
            observacaoclt,
            totalhorasclt,
            valorhora,
            horanormalclt,
            hora50clt,
            hora100clt,
          });

          if (response.status === 201) {
            return { id: idSelecionado, status: 'fulfilled' };
          }
          return { id: idSelecionado, status: 'rejected' };
        } catch (err) {
          return { id: idSelecionado, status: 'rejected' };
        }
      }),
    );

    const camposSalvos = results.filter((r) => r.status === 'fulfilled').map((r) => r.id);
    const camposComErro = results.filter((r) => r.status === 'rejected').map((r) => r.id);

    listaatividadeclt();

    if (camposSalvos.length > 0 && camposComErro.length === 0) {
      toast.success('Todas as atividades foram salvas com sucesso.');
    } else if (camposSalvos.length > 0 && camposComErro.length > 0) {
      toast.success(`Algumas atividades foram salvas, mas ${camposComErro.length} falharam.`);
    } else {
      toast.error('Nenhuma atividade foi salva. Todas falharam.');
    }
  };

  const enviaremail = () => {
    if (colaboradoremail == null || colaboradoremail === '' || colaboradoremail === undefined) {
      toast.error('Falta preencher o E-mail!');
      return;
    }

    if (idcolaboradorpj.length === 0) {
      toast.error('Falta Selecionar o Colaborador!');
      return;
    }

    api
      .post('v1/email/acionamentopj', {
        destinatario: emailadcional,
        destinatario1: colaboradoremail,
        assunto: 'ACIONAMENTO ERICSSON',
        cliente,
        numero,
        regiona,
        site,
        ids: rowSelectionModelPJ.join(','),
        nomecolaboradorpj,
        retanexo,
        idpessoa: idcolaboradorpj,
        idusuario: localStorage.getItem('sessionId'),
      })
      .then((response) => {
        if (response.status === 200) {
          toast.success('Email Enviando com Sucesso!');
          listaatividadepj();
        } else {
          toast.error('Erro ao enviar a mensagem!');
        }
      })
      .catch((err) => {
        if (err.response) {
          toast.error(err.response.data || 'Erro na resposta do servidor');
        } else {
          toast.error('Ocorreu um erro na requisição.');
        }
      });
  };

  const novocadastro = () => {
    api
      .post('v1/solicitacao/novocadastro', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setidentificadorsolicitacao(response.data.retorno);
          console.log(response.data.retorno);
          settitulo('Cadastrar Solicitação de Produto');
          settelacadastrosolicitacao(true);
        } else {
          toast.error(response.status);
        }
      })
      .catch((err) => {
        if (err.response) {
          toast.error(err.response.data.erro);
        } else {
          toast.error('Ocorreu um erro na requisição.');
        }
      });
  };

  function deletepj(stat) {
    console.log('apagar o acionamento');
    console.log(stat);
    settelaexclusaopj(true);
    setnumeroacio(stat);
    listaatividadepj();
  }

  const valorpopj = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      getActions: (parametros) => {
        const { porcentagem } = parametros.row;
        if (porcentagem > 0) {
          return [
            <GridActionsCellItem
              icon={<DeleteIcon style={{ color: grey[500] }} />}
              label="Já houve pagamento"
              title="Já houve pagamento"
              onClick={(event) => {
                event.stopPropagation();
                toast.error('Já houve pagamento');
              }}
            />,
          ];
        }
        return [
          <GridActionsCellItem
            icon={<DeleteIcon />}
            label="Delete"
            title="Delete"
            onClick={() => deletepj(parametros.id)}
          />,
        ];
      },
    },
    {
      field: 'fantasia',
      headerName: 'Colaborador',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
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
      field: 'codigoservico',
      headerName: 'Código Serviço',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'descricaoservico',
      headerName: 'Descrição Serviço',
      width: 280,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'valorservico',
      headerName: 'Valor Serviço',
      width: 100,
      align: 'left',
      type: 'number',
      editable: false,
    },
    {
      field: 'dataacionamento',
      headerName: 'Data de Acionamento',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'datadeenviodoemail',
      headerName: 'Data de Envio do E-mail',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },

    {
      field: 'pagamentoStatus',
      headerName: 'Pagamento status',
      width: 200,
      align: 'center',
      headerAlign: 'center',
      type: 'string',
      editable: false,
      renderCell: ({ row: { porcentagem } }) => {
        const color =
          porcentagem === null || porcentagem === 0
            ? grey[350]
            : porcentagem > 0 && porcentagem < 1
            ? yellow[500]
            : porcentagem >= 1
            ? green[500]
            : undefined;

        return <PaidIcon style={{ color }} />;
      },
    },
  ];

  const handleSolicitarMaterial = () => {
    novocadastro();
  };
  const enviaremailEquipeFixa = () => {
    const idsEquipeFixa = rowSelectionEquipeFixaModel.map((item) => {
      const partes = item.trim().split(/\s+/); // divide por espaço(s)
      return partes[partes.length - 1]; // pega o último elemento
    });
    console.log(idsEquipeFixa);
    if (rowSelectionEquipeFixaModel.length === 0) {
      toast.info('Falta Selecionar um responsável da equipe!');
    } else {
      const payload = {
        equiperesponsavel: idsEquipeFixa.join(','),
        idusuario: localStorage.getItem('sessionId'),
        numero,
        cliente,
        regiona,
        site,
        situacaoimplantacao,
        situacaodaintegracao,
        datadacriacaodademandadia,
        dataaceitedemandadia,
        datainicioentregamosplanejadodia,
        datarecebimentodositemosreportadodia,
        datafiminstalacaoplanejadodia,
        dataconclusaoreportadodia,
        datavalidacaoinstalacaodia,
        dataintegracaoplanejadodia,
        datavalidacaoeriboxedia,
        dataInicial,
        dataFinal,
        dataSolicitacao,
        obs,
        aceitacao,
        pendencia,
        outros,
        formaAcesso,
        statussydle,
        atividade,
        tipoinstalacao,
        impacto,
        ncrq,
        iniciocrq,
        fimcrq,
        statuscrq,
        crqdeinstalacao,
        observacoes,
        statusAcesso,
        central,
        municipio,
        detentora,
        iddentedora,
        numeroativo,
        obraPreenchidaNaSydle,
        ddd,
        nomeEricsson,
        enderecoSite,
        latitude,
        longitude,
        solicitacao,
        equipefixaIds: Array.isArray(equipefixa) ? equipefixa.map((o) => o.value) : [],
        equipefixaNomes: Array.isArray(equipefixa) ? equipefixa.map((o) => o.label) : [],
      };
      api
        .post('v1/projetoericsson/enviaremailfixa', payload)
        .then((response) => {
          if (response.status === 201) {
            toast.success('Email enviado com sucesso!');
          } else {
            toast.error('Erro ao enviar a mensagem!');
          }
        })
        .catch((err) => {
          if (err.response) {
            toast.error(err.response.data.erro);
          } else {
            toast.error('Ocorreu um erro na requisição.');
          }
        });
    }
  };

  const uploadanexo = async (e) => {
    e.preventDefault();

    const formData = new FormData();
    formData.append('files', arquivoanexo);

    const header = {
      headers: {
        'Custom-Header': 'value',
      },
    };
    try {
      setloading(true);
      const response = await api.post('v1/uploadanexo', formData, header);
      if (response && response.data) {
        if (response.status === 201) {
          setretanexo(response.data.files[0].filename);

          toast.success('Arquivo Anexado');
        } else {
          setretanexo('');

          toast.error('Erro ao Anexar arquivo!');
        }
      } else {
        throw new Error('Resposta inválida do servidor');
      }
    } catch (err) {
      if (err.response) {
        toast.error(err.message);
      } else {
        toast.error('Erro: Tente novamente mais tarde!');
      }
    } finally {
      setloading(false);
    }
  };

  const listasolicitacao = async () => {
    try {
      setloading(true);
      await api.get('v1/solicitacao/listaporempresa', { params }).then((response) => {
        setmaterialeservico(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  function deletedespesa(stat) {
    settelaexclusaosolicitacao(true);
    setidentificadorsolicitacao(stat);
  }
  const handleSalvar = async () => {
    try {
      setloading(true);

      const payload = {
        numero,
        cliente,
        regiona,
        site,
        situacaoimplantacao,
        situacaodaintegracao,
        datadacriacaodademandadia,
        dataaceitedemandadia,
        datainicioentregamosplanejadodia,
        datarecebimentodositemosreportadodia,
        datafiminstalacaoplanejadodia,
        dataconclusaoreportadodia,
        datavalidacaoinstalacaodia,
        dataintegracaoplanejadodia,
        datavalidacaoeriboxedia,
        dataInicial,
        dataFinal,
        dataSolicitacao,
        obs,
        aceitacao,
        pendencia,
        outros,
        formaAcesso,
        statussydle,
        atividade,
        tipoinstalacao,
        impacto,
        ncrq,
        iniciocrq,
        fimcrq,
        statuscrq,
        crqdeinstalacao,
        observacoes,
        statusAcesso,
        central,
        municipio,
        detentora,
        iddentedora,
        numeroativo,
        obraPreenchidaNaSydle,
        ddd,
        nomeEricsson,
        enderecoSite,
        latitude,
        longitude,
        solicitacao,
        equipefixaIds: Array.isArray(equipefixa) ? equipefixa.map((o) => o.value) : [],
        equipefixaNomes: Array.isArray(equipefixa) ? equipefixa.map((o) => o.label) : [],
      };

      const response = await api.post('/v1/projetoericsson', payload);

      const result = await response.json();

      if (response.ok) {
        console.log('Salvo com sucesso:', result);
      } else {
        console.error('Erro ao salvar:', result);
      }
    } catch (error) {
      console.error('Erro na requisição:', error);
    } finally {
      setloading(false);
    }
  };

  const columnsdespesa = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<DeleteIcon />}
          label="Delete"
          title="Delete"
          onClick={() => deletedespesa(parametros.id)}
        />,
      ],
    },
    { field: 'idsolicitacao', headerName: 'Solicitação', width: 90, align: 'center' },
    {
      field: 'data',
      headerName: 'Data',
      type: 'string',
      width: 120,
      align: 'left',
      valueGetter: (parametros) =>
        parametros.value ? new Date(`${parametros.value}T00:00:00`) : null,
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    {
      field: 'status',
      headerName: 'Status',
      type: 'string',
      width: 130,
      align: 'left',
      editable: false,
    },
    {
      field: 'nome',
      headerName: 'Solicitante',
      type: 'string',
      width: 200,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'projeto',
      headerName: 'Projeto',
      type: 'string',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'obra',
      headerName: 'Obra/OS',
      type: 'string',
      width: 120,
      align: 'left',
      editable: false,
    },
    {
      field: 'descricao',
      headerName: 'Descrição',
      type: 'string',
      width: 300,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'unidade',
      headerName: 'Unidade',
      type: 'string',
      width: 120,
      align: 'left',
      editable: false,
    },
    {
      field: 'quantidade',
      headerName: 'Quant. Solicitada',
      type: 'string',
      width: 150,
      align: 'center',
      editable: false,
    },
    {
      field: 'estoque',
      headerName: 'Quant. Estoque',
      type: 'string',
      width: 150,
      align: 'center',
      editable: false,
    },
    {
      field: 'observacao',
      headerName: 'Observação',
      type: 'string',
      width: 400,
      align: 'left',
      editable: false,
      renderCell: (parametros) => (
        <div
          style={{
            whiteSpace: 'pre-wrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            display: '-webkit-box',
            WebkitLineClamp: 2,
            WebkitBoxOrient: 'vertical',
          }}
        >
          {parametros.value}
        </div>
      ),
    },
  ];
  const colunasequipefixo = [
    {
      field: 'label',
      headerName: 'Nome',
      width: 250,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
  ];

  const bootstrapData = useCallback(async () => {
    const sessionId = localStorage.getItem('sessionId');
    setusuario(sessionId);

    const fastTasks = [
      Promise.resolve(listaid()),
      Promise.resolve(acessoFinanceiro()),
      Promise.resolve(listapormigo()),
      Promise.resolve(listapos()),
    ];

    const backgroundTasks = [
      Promise.resolve(listacolaboradorpj()),
      Promise.resolve(listacolaboradorclt()),
      Promise.resolve(listacolaborador()),
      Promise.resolve(listadocumentacaoobrafinalcivilwork()),
      Promise.resolve(listadocumentacaoobrafinal()),
      Promise.resolve(listaatividadepj()),
      Promise.resolve(listaatividadeclt()),
      Promise.resolve(despesasrelaotrioericsson()),
      Promise.resolve(listasolicitacaodiaria()),
      Promise.resolve(listasolicitacao()),
      Promise.resolve(carregarTPs()),
    ];

    await Promise.allSettled(fastTasks);

    if (typeof window !== 'undefined' && 'requestIdleCallback' in window) {
      window.requestIdleCallback(async () => {
        await Promise.allSettled(backgroundTasks);
      });
    } else {
      setTimeout(async () => {
        await Promise.allSettled(backgroundTasks);
      }, 0);
    }
    setusuario(localStorage.getItem('sessionId'));
  }, [
    listaid,
    acessoFinanceiro,
    listapormigo,
    listapos,
    listacolaboradorpj,
    listacolaboradorclt,
    listacolaborador,
    listadocumentacaoobrafinalcivilwork,
    listadocumentacaoobrafinal,
    listaatividadepj,
    listaatividadeclt,
    despesasrelaotrioericsson,
    listasolicitacaodiaria,
    listasolicitacao,
    setusuario,
  ]);

  useEffect(() => {
    bootstrapData();
  }, []);

  return (
    <Modal
      isOpen={show}
      toggle={() => setshow(false)}
      className="modal-dialog modal-fullscreen modal-dialog-scrollable"
      backdrop="static"
      keyboard={false}
    >
      <ModalHeader className="bg-white border-bottom" toggle={() => setshow(false)}>
        {titulotopo}
      </ModalHeader>

      <ToastContainer
        style={{ zIndex: 9999999 }}
        position="top-right"
        autoClose={2000}
        hideProgressBar={false}
        newestOnTop
        closeOnClick
        rtl={false}
        pauseOnFocusLoss
        draggable
        pauseOnHover
      />
      <CrqModal
        isOpen={crqModalOpen}
        onClose={() => setCrqModalOpen(false)}
        onSubmit={salvarCrq}
        tpForm={tpForm}
      />

      {telaexclusaodiaria ? (
        <>
          {' '}
          <Excluirregistro
            show={telaexclusaodiaria}
            setshow={settelaexclusaodiaria}
            ididentificador={iddiaria}
            quemchamou="DIARIA"
            atualiza={listasolicitacaodiaria}
          />{' '}
        </>
      ) : null}
      {telacadastrosolicitacaodiaria ? (
        <Solicitardiaria
          show={telacadastrosolicitacaodiaria}
          setshow={settelacadastrosolicitacaodiaria}
          ididentificador={identificadorsolicitacaodiaria}
          atualiza={listasolicitacaodiaria}
          titulotopo={titulodiaria}
          numero={numero}
          idlocal={numero}
          sigla={site}
          regional={regiona}
          clientelocal="ERICSSON"
          projetousual="ERICSSON"
          novo="0"
        />
      ) : null}
      {telaexclusaoclt ? (
        <>
          <Excluirregistro
            show={telaexclusaoclt}
            setshow={settelaexclusaoclt}
            ididentificador={numeroacio}
            quemchamou="ATIVIDADECLT"
            atualiza={listaatividadeclt}
          />{' '}
        </>
      ) : null}
      {telaexclusaopj ? (
        <>
          <Excluirregistro
            show={telaexclusaopj}
            setshow={settelaexclusaopj}
            ididentificador={numeroacio}
            quemchamou="ATIVIDADEPJ"
            atualiza={listaatividadepj}
          />{' '}
        </>
      ) : null}
      {telacadastrosolicitacaodiaria ? (
        <Solicitardiaria
          show={telacadastrosolicitacaodiaria}
          setshow={settelacadastrosolicitacaodiaria}
          ididentificador={identificadorsolicitacaodiaria}
          atualiza={listasolicitacaodiaria}
          titulotopo={titulodiaria}
          novo="0"
          projetousual="ERICSSON"
          numero={numero}
          idlocal={numero}
          sigla={site}
          regional={regiona}
          clientelocal={cliente}
        />
      ) : null}
      {telacadastrosolicitacao ? (
        <Solicitacaoedicao
          show={telacadastrosolicitacao}
          setshow={settelacadastrosolicitacao}
          ididentificador={identificadorsolicitacao}
          atualiza={listasolicitacao}
          titulotopo={titulo}
          novo="1"
          projetousual="ERICSSON"
          numero={numero}
        />
      ) : null}
      {telacadastroedicaosolicitacao ? (
        <>
          {' '}
          <Rolloutericssonedicao
            show={telacadastroedicaosolicitacao}
            setshow={settelacadastroedicaosolicitacao}
            ididentificador={identificadorsolicitacao}
            atualiza={listasolicitacao}
            titulotopo={titulo}
            novo="0"
            numero={numero}
          />{' '}
        </>
      ) : null}
      {telaexclusaosolicitacao ? (
        <>
          <Excluirregistro
            show={telaexclusaosolicitacao}
            setshow={settelaexclusaosolicitacao}
            ididentificador={identificadorsolicitacao}
            quemchamou="SOLICITACAO"
            atualiza={listasolicitacao}
            idlojaatual={localStorage.getItem('sessionloja')}
          />{' '}
        </>
      ) : null}
      {telaexclusaopj && (
        <Excluirregistro
          show={telaexclusaopj}
          setshow={settelaexclusaopj}
          ididentificador={idacionamentopj}
          quemchamou="ATIVIDADEPJ"
          atualiza={listaatividadepj}
        />
      )}
      {telaexclusaoclt && (
        <Excluirregistro
          show={telaexclusaoclt}
          setshow={settelaexclusaoclt}
          ididentificador={idacionamentoclt}
          quemchamou="ATIVIDADECLT"
          atualiza={listaatividadeclt}
        />
      )}

      <ModalBody className="bg-white">
        {/* === IDENTIFICAÇÃO === */}
        <b>Identificação</b>
        <hr style={{ marginTop: '0px', width: '100%' }} />
        <CardBody className="px-4 , pb-2">
          <div className="row g-3">
            <div className="col-sm-3">
              Número
              <Input id="campoNumero" type="text" value={numero} disabled />
            </div>

            <div className="col-sm-3">
              Cliente
              <Input id="campoCliente" type="text" value={cliente} disabled />
            </div>

            <div className="col-sm-3">
              Regional
              <Input id="campoRegiona" type="text" value={regiona} disabled />
            </div>

            <div className="col-sm-3">
              Site
              <Input id="campoSite" type="text" value={site} disabled />
            </div>
          </div>
        </CardBody>
        {/*ACESSO*/}
        <b>Acesso</b>
        <hr style={{ marginTop: '0px', width: '100%' }} />
        <CardBody className="px-4 pb-2">
          <div className="row g-3">
            <div className="col-sm-2">
              OUTROS
              <Input type="text" value={outros} onChange={(e) => setOutros(e.target.value)} />
            </div>

            <div className="col-sm-4">
              FORMA DE ACESSO
              <Input
                type="text"
                value={formaAcesso}
                onChange={(e) => setFormaAcesso(e.target.value)}
              />
            </div>

            <div className="col-sm-1">
              DDD
              <Input type="text" value={ddd} onChange={(e) => setDdd(e.target.value)} />
            </div>

            <div className="col-sm-2">
              MUNICÍPIO
              <Input type="text" value={municipio} onChange={(e) => setMunicipio(e.target.value)} />
            </div>

            <div className="col-sm-3">
              NOME ERICSSON
              <Input
                type="text"
                value={nomeEricsson}
                onChange={(e) => setNomeEricsson(e.target.value)}
              />
            </div>

            <div className="col-sm-6">
              ENDEREÇO
              <Input
                type="text"
                value={enderecoSite}
                onChange={(e) => setEnderecoSite(e.target.value)}
              />
            </div>

            <div className="col-sm-2">
              LATITUDE
              <Input type="text" value={latitude} onChange={(e) => setLatitude(e.target.value)} />
            </div>

            <div className="col-sm-2">
              LONGITUDE
              <Input type="text" value={longitude} onChange={(e) => setLongitude(e.target.value)} />
            </div>

            <div className="col-sm-2">
              OBS
              <Input type="text" value={obs} onChange={(e) => setObs(e.target.value)} />
            </div>

            <div className="col-sm-4">
              SOLICITAÇÃO
              <Input
                type="text"
                value={solicitacao}
                onChange={(e) => setSolicitacao(e.target.value)}
              />
            </div>

            <div className="col-sm-2">
              DATA-SOLICITAÇÃO
              <Input
                type="date"
                value={dataSolicitacao}
                onChange={(e) => setDataSolicitacao(e.target.value)}
              />
            </div>

            <div className="col-sm-2">
              DATA-INICIAL
              <Input
                type="date"
                value={dataInicial}
                onChange={(e) => setDataInicial(e.target.value)}
              />
            </div>

            <div className="col-sm-2">
              DATA-FINAL
              <Input type="date" value={dataFinal} onChange={(e) => setDataFinal(e.target.value)} />
            </div>

            <div className="col-sm-2">
              STATUS
              <Input
                type="select"
                name="statusacesso"
                value={statusAcesso}
                onChange={(e) => setStatusAcesso(e.target.value)}
              >
                <option value="">Selecione</option>
                <option value="AGUARDANDO">AGUARDANDO</option>
                <option value="CANCELADO">CANCELADO</option>
                <option value="CONCLUIDO">CONCLUIDO</option>
                <option value="LIBERADO">LIBERADO</option>
                <option value="PEDIR">PEDIR</option>
                <option value="REJEITADO">REJEITADO</option>
                <option value="SEM ACESSO">SEM ACESSO</option>
              </Input>
            </div>

            {/* text status_sydle */}
            <div className="col-4">
              Status SYDLE
              <Input
                type="text"
                value={statussydle}
                onChange={(e) => setstatussydle(e.target.value)}
              />
            </div>

            {/* text atividade */}

            <div className="col-4">
              Atividade
              <Input type="text" value={atividade} onChange={(e) => setatividade(e.target.value)} />
            </div>

            {/* Lista suspensa com opções: Rooftop, Greenfield, Indoor, Camuflado, Mastro, Poste Metálico, Torre Metálica, SLS. */}

            <div className="col-4">
              Tipo de Instalação
              <Input
                type="select"
                value={tipoinstalacao}
                onChange={(e) => settipoinstalacao(e.target.value)}
              >
                <option value="">Selecione</option>
                <option value="Rooftop">Rooftop</option>
                <option value="Greenfield">Greenfield</option>
                <option value="Indoor">Indoor</option>
                <option value="Camuflado">Camuflado</option>
                <option value="Mastro">Mastro</option>
                <option value="Poste Metálico">Poste Metálico</option>
                <option value="Torre Metálica">Torre Metálica</option>
                <option value="SLS">SLS</option>
              </Input>
            </div>

            {/* IMPACTO → Lista suspensa (padrão vazio) com opção: “S/Impacto”. */}

            <div className="col-4">
              Impacto
              <Input type="select" value={impacto} onChange={(e) => setimpacto(e.target.value)}>
                <option value="">Selecione</option>
                <option value="S/Impacto">S/Impacto</option>
              </Input>
            </div>

            {/* - [ ]  **N° CRQ** → Preenchimento manual. */}
            <div className="col-4">
              N° CRQ
              <Input type="text" value={ncrq} onChange={(e) => setncrq(e.target.value)} />
            </div>

            {/* - [ ]  **INICIO_CRQ** → Preenchimento manual (data). */}

            <div className="col-4">
              INICIO_CRQ
              <Input type="date" value={iniciocrq} onChange={(e) => setiniciocrq(e.target.value)} />
            </div>

            {/* - [ ]  **FIM_CRQ** → Preenchimento manual (data). */}

            <div className="col-4">
              FIM_CRQ
              <Input type="date" value={fimcrq} onChange={(e) => setfimcrq(e.target.value)} />
            </div>
            {/* - [ ]  **STATUS CRQ** → Preenchimento manual. */}
            <div className="col-4">
              STATUS CRQ
              <Input type="text" value={statuscrq} onChange={(e) => setstatuscrq(e.target.value)} />
            </div>

            {/* - [ ]  **FORMA DE ACESSO** → Preenchimento manual. */}

            <div className="col-4">
              FORMA DE ACESSO
              <Input
                type="text"
                value={formaAcesso}
                onChange={(e) => setFormaAcesso(e.target.value)}
              />
            </div>

            {/* CRQ DE INSTALAÇÃO → Preenchimento manual. */}
            <div className="col-4">
              CRQ DE INSTALAÇÃO
              <Input
                type="text"
                value={crqdeinstalacao}
                onChange={(e) => setcrqdeinstalacao(e.target.value)}
              />
            </div>

            {/* OBRA PREENCHIDA NA SYDLE → Seleção com opções: Ok, Não.K */}

            <div className="col-4">
              OBRA PREENCHIDA NA SYDLE
              <Input
                type="select"
                value={obraPreenchidaNaSydle}
                onChange={(e) => setobrapreenchidanasydle(e.target.value)}
              >
                <option value="">Selecione</option>
                <option value="Ok">Ok</option>
                <option value="Não">Não</option>
              </Input>
            </div>

            {/* statatussydle */}
            <div className="col-4">
              Status Sydle
              <Input
                type="text"
                value={statatussydle}
                onChange={(e) => setstatatussydle(e.target.value)}
              />
            </div>

            {/* central */}

            <div className="col-4">
              Central
              <Input type="text" value={central} onChange={(e) => setcentral(e.target.value)} />
            </div>

            {/* detentora */}
            <div className="col-4">
              Detentora
              <Input type="text" value={detentora} onChange={(e) => setdetentora(e.target.value)} />
            </div>

            {/* iddentedora */}
            <div className="col-4">
              Id Detentora
              <Input
                type="text"
                value={iddentedora}
                onChange={(e) => setiddentedora(e.target.value)}
              />
            </div>

            <div className="col-4">
              Númerdo do ativo
              <Input
                type="text"
                value={numeroativo}
                onChange={(e) => setnumeroativo(e.target.value)}
              />
            </div>

            <div className="col-4">
              Equipe Fixa
              {/* multiplo select vem do colaboradorlista */}
              <Select
                isMulti
                options={colaboradorlista}
                value={equipefixa}
                onChange={setequipefixa}
                placeholder="Selecione"
              />
            </div>
            <div className="col-sm-4">
              Status Validade Acesso
              <Input type="text" value={statusvalidadeAcesso} disabled />
            </div>
            <div className="col-sm-12">
              Observações
              <Input
                type="text"
                value={observacoes}
                onChange={(e) => setobservacoes(e.target.value)}
              />
            </div>
          </div>

          <div className="row g-3">
            <Box sx={{ height: equipefixa.length > 0 ? '100%' : 400, width: '100%' }}>
              <DataGrid
                rows={equipefixa}
                columns={colunasequipefixo}
                loading={loading}
                getRowId={(data) => data.label.concat(` ${data.value}`)}
                disableSelectionOnClick
                checkboxSelection
                experimentalFeatures={{ newEditingApi: true }}
                components={{
                  Pagination: CustomPagination,
                  LoadingOverlay: LinearProgress,
                  NoRowsOverlay: CustomNoRowsOverlay,
                }}
                localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                paginationModel={paginationModelEquipeFixa}
                onPaginationModelChange={setPaginationModellEquipeFixa}
                onRowSelectionModelChange={(newRowSelectionModel) => {
                  setRowSelectionEquipeFixaModel(newRowSelectionModel);
                }}
              />
            </Box>
            <br></br>
            <div className=" col-sm-12 d-flex flex-row-reverse">
              <Button
                color="secondary"
                onClick={enviaremailEquipeFixa}
                disabled={modoVisualizador()}
              >
                Enviar E-mail para equipe fixa <Icon.Mail />
              </Button>
            </div>
          </div>
          <div className="row my-3 align-items-end">
            <div className="col-12 col-md-6 mb-2 mb-md-0">
              <Button color="primary" className="btn btn-primary w-100" onClick={abrirCrqModal}>
                Criar CRQ
              </Button>
            </div>

            <div className="col-12 col-md-6">
              <Button
                color="primary"
                className="w-100"
                onClick={abrirChgModal}
                disabled={tpLoading}
              >
                Criar CHG
              </Button>
            </div>
            <Box sx={{ height: 500, width: '100%' }}>
              <DataGrid
                rows={tps}
                columns={tpColumns}
                loading={tpLoading}
                pagination
                pageSizeOptions={[10, 25, 50]}
                initialState={{
                  pagination: { paginationModel: { pageSize: 10, page: 0 } },
                  sorting: { sortModel: [{ field: 'criadoEm', sort: 'desc' }] },
                }}
                disableRowSelectionOnClick
                editMode="row"
                processRowUpdate={processRowUpdateTp}
                onProcessRowUpdateError={(error) => console.error(error)}
                getRowId={(row) => row.id}
              />
            </Box>
          </div>
        </CardBody>

        <CrqModal
          isOpen={crqModalOpen}
          onClose={() => setCrqModalOpen(false)}
          onSubmit={salvarCrq}
          initialData={tpForm}
        />

        <TpModal
          open={tpModalOpen}
          onClose={() => handleCloseModal('tp')}
          onCreate={criarTP}
          tpForm={tpForm}
          onChange={handleTpFormChange}
          tpTipos={tpTipos}
          tpStatus={tpStatus}
          loading={tpLoading}
          empresa="ERICSSON"
          pai="TP"
        />

        <ChgModal
          open={chgModalOpen}
          onClose={() => handleCloseModal('chg')}
          onCreate={criarTP}
          tpForm={tpForm}
          onChange={handleTpFormChange}
          tpTipos={tpTipos}
          tpStatus={tpStatus}
          loading={tpLoading}
          empresa="ERICSSON"
          pai="CHG"
        />

        {telaexclusaotp ? (
          <>
            <Excluirregistro
              show={telaexclusaotp}
              setshow={settelaexclusaotp}
              ididentificador={idtp}
              quemchamou="TPTELEFONICA"
              atualiza={carregarTPs}
            />{' '}
          </>
        ) : null}

        {/* === Acompanhamento Físico === */}
        <br />
        <b>Acompanhamento Físico</b>
        <hr style={{ marginTop: '0px', width: '100%' }} />
        <CardBody className="px-4 , pb-2">
          <div className="row g-3">
            <div className="col-sm-4">
              Situação Implantação
              <Input
                type="select"
                onChange={(e) => setsituacaoimplantacao(e.target.value)}
                value={situacaoimplantacao}
                name="Tipo Pessoa"
              >
                <option value="">Selecione</option>
                <option value="Aguardando aceite do ASP">Aguardando aceite do ASP</option>
                <option value="Aguardando agendamento Bluebee">
                  Aguardando agendamento Bluebee
                </option>
                <option value="Aguardando definição de Equipe">
                  Aguardando definição de Equipe
                </option>
                <option value="Cancelado">Cancelado</option>
                <option value="Concluída">Concluída</option>
                <option value="Em Aceitação">Em Aceitação</option>
                <option value="Fim do Período de Garantia">Fim do Período de Garantia</option>
                <option value="Iniciando cancelamento da Obra">
                  Iniciando cancelamento da Obra
                </option>
                <option value="Obra em Andamento">Obra em Andamento</option>
                <option value="Paralisada por HSE">Paralisada por HSE</option>
                <option value="Período de Garantia">Período de Garantia</option>
                <option value="Retomada planejada">Retomada planejada</option>
                <option value="Revisar Finalização da Obra">Revisar Finalização da Obra</option>
              </Input>
            </div>
            <div className="col-sm-4">
              Situação Integração
              <Input
                type="select"
                onChange={(e) => setsituacaodaintegracao(e.target.value)}
                value={situacaodaintegracao}
                name="Tipo Pessoa"
              >
                <option value="">Selecione</option>
                <option value="Completa">Completa</option>
                <option value="Em Andamento">Em Andamento</option>
                <option value="Não Iniciou">Não Iniciou</option>
              </Input>
            </div>
          </div>

          <div className="row g-3">
            <div className="row g-3">
              <div className="col-sm-4">
                Data da Criação Demanda (Dia)
                <Input
                  type="date"
                  onChange={(e) => setdatadacriacaodademandadia(e.target.value)}
                  value={datadacriacaodademandadia}
                  placeholder=""
                  disabled
                />
              </div>

              <div className="col-sm-4">
                Data de Aceite da Demanda (Dia)
                <Input
                  type="date"
                  onChange={(e) => setdataaceitedemandadia(e.target.value)}
                  value={dataaceitedemandadia}
                  placeholder="Descrição completa"
                  disabled
                />
              </div>
            </div>

            <div className="row g-3">
              <div className="col-sm-4">
                Data de Início / Entrega (MOS - Planejado) (Dia)
                <Input
                  type="date"
                  onChange={(e) => setdatainicioentregamosplanejadodia(e.target.value)}
                  value={datainicioentregamosplanejadodia}
                  placeholder=""
                />
              </div>

              <div className="col-sm-4">
                Data de Recebimento do Site (MOS - Reportado) (Dia)
                <Input
                  type="date"
                  onChange={(e) => setdatarecebimentodositemosreportadodia(e.target.value)}
                  value={datarecebimentodositemosreportadodia}
                  placeholder=""
                  disabled
                />
              </div>
            </div>

            <div className="row g-3">
              <div className="col-sm-4">
                Data de Fim de Instalação (Planejado) (Dia)
                <Input
                  type="date"
                  onChange={(e) => setdatafiminstalacaoplanejadodia(e.target.value)}
                  value={datafiminstalacaoplanejadodia}
                  placeholder="Descrição completa"
                />
              </div>

              <div className="col-sm-4">
                Data de Conclusão (Reportado) (Dia)
                <Input
                  type="date"
                  onChange={(e) => setdataconclusaoreportadodia(e.target.value)}
                  value={dataconclusaoreportadodia}
                  placeholder="Descrição completa"
                  disabled
                />
              </div>

              <div className="col-sm-4">
                Data de Validação da Instalação (Dia)
                <Input
                  type="date"
                  onChange={(e) => setdatavalidacaoinstalacaodia(e.target.value)}
                  value={datavalidacaoinstalacaodia}
                  placeholder="Código SKU ou referência"
                  disabled
                />
              </div>
            </div>

            <div className="row g-3">
              <div className="col-sm-4">
                Data de Integração (Planejado) (Dia)
                <Input
                  type="date"
                  onChange={(e) => setdataintegracaoplanejadodia(e.target.value)}
                  value={dataintegracaoplanejadodia}
                  placeholder="Descrição completa"
                />
              </div>

              <div className="col-sm-4">
                Data de Validação ERIBOX (Dia)
                <Input
                  type="date"
                  onChange={(e) => setdatavalidacaoeriboxedia(e.target.value)}
                  value={datavalidacaoeriboxedia}
                  placeholder="Descrição completa"
                  disabled
                />
              </div>

              <div className="col-sm-4">
                Aceitação Final (Dia)
                <Input
                  type="date"
                  onChange={(e) => setaceitacao(e.target.value)}
                  value={aceitacao}
                  placeholder="Descrição completa"
                  disabled
                />
              </div>
            </div>
          </div>
          <br />
          <div className="row g-3">
            <div className="col-sm-12">
              Pendências Obras
              <Input
                type="text"
                onChange={(e) => setpendencia(e.target.value)}
                value={pendencia}
                placeholder="Pendências Obras"
                disabled
              />
            </div>
          </div>
        </CardBody>
        <br />
        <b>Tarefas</b>
        <hr style={{ marginTop: '0px', width: '100%' }} />
        <CardBody className="px-4 , pb-2">
          <div className="row g-3">
            <div className=" col-sm-12 d-flex flex-row-reverse">
              <Button color="primary" onClick={() => novocadastrotarefa()}>
                Cadastrar Tarefa <Icon.Plus />
              </Button>
              {telacadastrotarefa ? (
                <>
                  {' '}
                  <Tarefaedicao
                    show={telacadastrotarefa}
                    setshow={settelacadastrotarefa}
                    ididentificador={ididentificadortarefa}
                    atualiza={listapormigo}
                    titulotopo={titulotarefa}
                    siteid={site}
                    obra={numero}
                  />{' '}
                </>
              ) : null}
            </div>
          </div>
          <br />
          <Box sx={{ height: '400%', width: '100%', minHeight: '20vh' }}>
            <DataGrid
              rows={listamigo}
              columns={columnsmigo}
              loading={loading}
              pageSize={pageSize}
              onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
              disableSelectionOnClick
              experimentalFeatures={{ newEditingApi: true }}
              components={{
                Pagination: CustomPagination,
                LoadingOverlay: LinearProgress,
                NoRowsOverlay: CustomNoRowsOverlay,
              }}
              localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
              paginationModel={paginationModeltarefa}
              onPaginationModelChange={setPaginationModeltarefa}
            />
          </Box>
        </CardBody>
        <br />
        <b>Documentação</b>
        <hr style={{ marginTop: '0px', width: '100%' }} />
        <CardBody className="px-4 , pb-2">
          INSTALAÇÃO (ARQUIVO DOCUMENTAÇÃO DA OBRA FINAL)
          <Box sx={{ height: 400, width: '100%' }}>
            <DataGrid
              rows={documentacaoobrafinal}
              columns={obrafinal}
              loading={loading}
              pageSize={pageSize}
              onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
              disableSelectionOnClick
              experimentalFeatures={{ newEditingApi: true }}
              components={{
                Pagination: CustomPagination,
                LoadingOverlay: LinearProgress,
                NoRowsOverlay: CustomNoRowsOverlay,
              }}
              localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
              paginationModel={paginationModelobrafinal}
              onPaginationModelChange={setPaginationModelobrafinal}
            />
          </Box>
          <br></br>
          INSTALAÇÃO (ARQUIVO DOCUMENTAÇÃO CIVIL WORK)
          <Box sx={{ height: 400, width: '100%' }}>
            <DataGrid
              rows={documentacaocivilwork}
              columns={civilwork}
              loading={loading}
              pageSize={pageSize}
              onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
              disableSelectionOnClick
              experimentalFeatures={{ newEditingApi: true }}
              components={{
                Pagination: CustomPagination,
                LoadingOverlay: LinearProgress,
                NoRowsOverlay: CustomNoRowsOverlay,
              }}
              localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
              paginationModel={paginationModelcivilwork}
              onPaginationModelChange={setPaginationModelcivilwork}
            />
          </Box>
        </CardBody>
        <br />
        <b>Acionamentos</b>
        <hr style={{ marginTop: '0px', width: '100%' }} />
        <CardBody className="px-4 , pb-2">
          <div className="row g-3">
            <br />
            Atividades
            <hr style={{ marginTop: '0px', width: '100%' }} />
            <Box sx={{ height: 400, width: '100%' }}>
              <DataGrid
                rows={poservicolista}
                columns={columnsescopo}
                loading={loading}
                pageSize={pageSize}
                onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                disableSelectionOnClick
                checkboxSelection
                onRowSelectionModelChange={(newRowSelectionModel) => {
                  setRowSelectionModel(newRowSelectionModel);
                }}
                rowSelectionModel={rowSelectionModel}
                experimentalFeatures={{ newEditingApi: true }}
                components={{
                  Pagination: CustomPaginationclt,
                  LoadingOverlay: LinearProgress,
                  NoRowsOverlay: CustomNoRowsOverlay,
                }}
                localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                paginationModel={paginationModeltarefa}
                onPaginationModelChange={setPaginationModeltarefa}
              />
            </Box>
          </div>
          <br></br>
          Dados do Colaborador CLT
          <hr style={{ marginTop: '0px', width: '100%' }} />
          <div className="row g-3">
            <div className="col-sm-8">
              Funcionário
              <Select
                isClearable
                isSearchable
                name="colaboradorclt"
                options={colaboradorlistaclt}
                placeholder="Selecione"
                isLoading={loading}
                onChange={handleChangecolaboradorclt}
                value={selectedoptioncolaboradorclt}
              />
            </div>
            <div className="col-sm-2">
              Data Início
              <Input
                type="date"
                onChange={(e) => setdatainicioclt(e.target.value)}
                value={datainicioclt}
              />
            </div>
            <div className="col-sm-2">
              Data Final
              <Input
                type="date"
                onChange={(e) => setdatafinalclt(e.target.value)}
                value={datafinalclt}
              />
            </div>
            <div className="col-sm-3">
              Horas Normais
              <Input
                type="number"
                onChange={(e) => sethoranormalclt(e.target.value)}
                value={horanormalclt}
              />
            </div>
            <div className="col-sm-3">
              Horas 50%
              <Input
                type="number"
                onChange={(e) => sethora50clt(e.target.value)}
                value={hora50clt}
              />
            </div>
            <div className="col-sm-3">
              Horas 100%
              <Input
                type="number"
                onChange={(e) => sethora100clt(e.target.value)}
                value={hora100clt}
              />
            </div>
            <div className="col-sm-3">
              Total de Horas
              <Input
                type="number"
                onChange={(e) => settotalhorasclt(e.target.value)}
                value={totalhorasclt}
              />
            </div>
            <div className="col-sm-12">
              Observação
              <Input
                type="textarea"
                onChange={(e) => setobservacaoclt(e.target.value)}
                value={observacaoclt}
              />
            </div>
          </div>
          <br />
          <div className=" col-sm-12 d-flex flex-row-reverse">
            <Button color="primary" onClick={execacionamentoclt} disabled={modoVisualizador()}>
              Adicionar Acionamento CLT <Icon.Plus />
            </Button>
          </div>
          <br />
          <Box sx={{ height: 400, width: '100%' }}>
            <DataGrid
              rows={pacotesacionadosclt}
              columns={colunaspacotesacionadosclt}
              loading={loading}
              disableSelectionOnClick
              components={{
                Pagination: CustomPagination,
                LoadingOverlay: LinearProgress,
                NoRowsOverlay: CustomNoRowsOverlay,
              }}
              localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
              paginationModel={paginationModelacionamentoclt}
              onPaginationModelChange={setPaginationModelacionamentoclt}
            />
          </Box>
          <br />
          Dados do Colaborador PJ
          <hr style={{ marginTop: '0px', width: '100%' }} />
          <div className="row g-3">
            <div className="col-sm-4">
              Empresa
              <Select
                isClearable
                isSearchable
                name="colaboradorpj"
                options={colaboradorlistapj}
                placeholder="Selecione"
                isLoading={loading}
                onChange={handleChangecolaboradorpj}
                value={selectedoptioncolaboradorpj}
              />
            </div>
            <div className="col-sm-4">
              LPUs
              <Select
                isClearable
                isSearchable
                name="lpuhistorico"
                options={lpulista}
                placeholder="Selecione"
                isLoading={loading}
                onChange={handleChangelpu}
                value={selectedoptionlpu}
              />
            </div>

            {lpuhistorico === 'NEGOCIADO' &&
              (usuario === '33' || usuario === '35' || usuario === '78') && (
                <div className="col-sm-2">
                  Valor Negociado
                  <NumericFormat
                    className="form-control"
                    value={valornegociado}
                    thousandSeparator="."
                    decimalSeparator=","
                    prefix="R$ "
                    allowNegative={false}
                    decimalScale={2}
                    fixedDecimalScale
                    onValueChange={({ floatValue }) => setvalornegociado(floatValue || 0)}
                  />
                </div>
              )}

            <div className="col-sm-12">
              Observação
              <Input
                type="textarea"
                onChange={(e) => setobservacaopj(e.target.value)}
                value={observacaopj}
              />
            </div>
          </div>
          <br />
          <div className=" col-sm-12 d-flex flex-row-reverse">
            <Button color="primary" onClick={svlista} disabled={modoVisualizador()}>
              Adicionar Acionamento PJ <Icon.Plus />
            </Button>
          </div>
          <br />
          <Box sx={{ height: 400, width: '100%' }}>
            <DataGrid
              rows={atividadepjlista}
              columns={colunaspacotesacionados}
              loading={loading}
              disableSelectionOnClick
              components={{
                Pagination: CustomPagination,
                LoadingOverlay: LinearProgress,
                NoRowsOverlay: CustomNoRowsOverlay,
              }}
              checkboxSelection
              onRowSelectionModelChange={(newRowSelectionModel) => {
                console.log('HERE');
                console.log(newRowSelectionModel);
                setRowSelectionModelPJ(newRowSelectionModel);
              }}
              localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
              paginationModel={paginationModelatividadepj}
              onPaginationModelChange={setPaginationModelatividadepj}
            />
          </Box>
          <div className="row g-3 mt-2">
            <div className="col-sm-12">
              E-mail PJ
              <Input
                type="text"
                onChange={(e) => setcolaboradoremail(e.target.value)}
                value={colaboradoremail}
              />
            </div>
            <div className="col-sm-12">
              E-mails adicionais
              <Input
                type="text"
                onChange={(e) => setemailadcional(e.target.value)}
                value={emailadcional}
              />
            </div>
            <div className="col-sm-12">
              Anexo
              <div className="d-flex flex-row-reverse custom-file">
                <InputGroup>
                  <Input
                    type="file"
                    onChange={(e) => setarquivoanexo(e.target.files[0])}
                    className="custom-file-input"
                    id="customFile3"
                  />
                  <Button color="primary" onClick={uploadanexo} disabled={modoVisualizador()}>
                    Anexar{' '}
                  </Button>
                </InputGroup>
              </div>
            </div>
            <div className=" col-sm-12 d-flex flex-row-reverse mt-2">
              <Button color="secondary" onClick={enviaremail} disabled={modoVisualizador()}>
                Enviar E-mail de Acionamento <Icon.Mail />
              </Button>
            </div>
          </div>
        </CardBody>
        <br />
        <b>Material e Serviço</b>
        <hr style={{ marginTop: '0px', width: '100%' }} />
        <CardBody className="px-4 , pb-2">
          {/**MATERIAL */}
          <div className="row g-3">
            <div className=" col-sm-12 d-flex flex-row-reverse">
              <Button
                color="primary"
                onClick={() => handleSolicitarMaterial()}
                disabled={modoVisualizador()}
              >
                Solicitar Material/Serviço <Icon.Plus />
              </Button>
            </div>
          </div>
          <br></br>
          <div className="row g-3">
            <Box sx={{ height: 400, width: '100%' }}>
              <DataGrid
                rows={materialeservico}
                columns={columnsdespesa}
                loading={loadingFinanceiro}
                pageSize={pageSize}
                onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                disableSelectionOnClick
                experimentalFeatures={{ newEditingApi: true }}
                components={{
                  Pagination: CustomPagination,
                  LoadingOverlay: LinearProgress,
                  NoRowsOverlay: CustomNoRowsOverlay,
                }}
                localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                paginationModel={paginationModelmaterial}
                onPaginationModelChange={setPaginationModelmaterial}
              />
            </Box>
          </div>
        </CardBody>
        <br />
        <b>Diárias</b>
        <hr style={{ marginTop: '0px', width: '100%' }} />
        <div className="row g-3">
          <CardBody className="px-4 , pb-2">
            <div className="row g-3">
              <div className="col-sm-6"></div>
              <div className=" col-sm-6 d-flex flex-row-reverse">
                <div className=" col-sm-6 d-flex flex-row-reverse">
                  <Button color="primary" onClick={() => novocadastrodiaria()}>
                    Solicitar Diária <Icon.Plus />
                  </Button>
                </div>
              </div>
            </div>
            <br></br>
            <div className="row g-3">
              <Box sx={{ height: 400, width: '100%' }}>
                <DataGrid
                  rows={solicitacaodiaria}
                  columns={colunasdiarias}
                  loading={loading}
                  disableSelectionOnClick
                  experimentalFeatures={{ newEditingApi: true }}
                  components={{
                    Pagination: CustomPagination,
                    LoadingOverlay: LinearProgress,
                    NoRowsOverlay: CustomNoRowsOverlay,
                  }}
                  paginationModel={paginationModeldiarias}
                  onPaginationModelChange={setPaginationModeldiarias}
                />
              </Box>
            </div>
          </CardBody>
        </div>
        <br />
        {ericFechamento === 1 ? (
          <>
            {/**Financeiro*/}
            <b>Financeiro</b>
            <hr style={{ marginTop: '0px', width: '100%' }} />
            <CardBody className="px-4 , pb-2">
              <>
                ACIONAMENTO ERICSSON (VALOR PO)
                <Box sx={{ height: 400, width: '100%' }}>
                  <DataGrid
                    rows={listamigo}
                    columns={valorpo}
                    loading={loading}
                    pageSize={pageSize}
                    onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                    disableSelectionOnClick
                    experimentalFeatures={{ newEditingApi: true }}
                    components={{
                      Pagination: CustomPagination,
                      LoadingOverlay: LinearProgress,
                      NoRowsOverlay: CustomNoRowsOverlay,
                    }}
                    localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                    paginationModel={paginationModelvalorpo}
                    onPaginationModelChange={setPaginationModelvalorpo}
                  />
                </Box>
                <br></br>
                ACIONAMENTO PJ
                <Box sx={{ height: 400, width: '100%' }}>
                  <DataGrid
                    rows={atividadepjlista}
                    columns={valorpopj}
                    loading={loadingpj}
                    pageSize={pageSize}
                    onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                    disableSelectionOnClick
                    experimentalFeatures={{ newEditingApi: true }}
                    components={{
                      Pagination: CustomPagination,
                      LoadingOverlay: LinearProgress,
                      NoRowsOverlay: CustomNoRowsOverlay,
                    }}
                    localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                    paginationModel={paginationModelacionamentopj}
                    onPaginationModelChange={setPaginationModelacionamentopj}
                  />
                </Box>
                <br></br>
                <div
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                  }}
                >
                  HISTORICO DE DESPESAS
                  <Typography variant="subtitle1" color="text.secondary">
                    Valor total:{' '}
                    <b>
                      {totalfinanceiro?.toLocaleString('pt-BR', {
                        style: 'currency',
                        currency: 'BRL',
                      })}{' '}
                    </b>
                  </Typography>
                </div>
                <Box sx={{ height: 400, width: '100%' }}>
                  <DataGrid
                    rows={relatorioDespesas}
                    columns={columnsFinanceiro}
                    loading={loadingFinanceiro}
                    pageSize={pageSize}
                    onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                    disableSelectionOnClick
                    experimentalFeatures={{ newEditingApi: true }}
                    components={{
                      Pagination: CustomPagination,
                      LoadingOverlay: LinearProgress,
                      NoRowsOverlay: CustomNoRowsOverlay,
                    }}
                    localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                    paginationModel={paginationModeldespesas}
                    onPaginationModelChange={setPaginationModeldespesas}
                  />
                </Box>
              </>
            </CardBody>
          </>
        ) : null}
      </ModalBody>

      <ModalFooter className="bg-white">
        <Button
          color="success"
          onClick={() => {
            atualiza();
            handleSalvar();
          }}
        >
          {loading ? 'Carregando...' : 'Salvar'}
        </Button>{' '}
        <Button color="secondary" onClick={() => setshow(false)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Rolloutericssonedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
  titulotopo: PropTypes.string.isRequired,
  atualiza: PropTypes.func.isRequired,
};

export default Rolloutericssonedicao;

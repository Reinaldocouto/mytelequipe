import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import {
  Modal,
  ModalHeader,
  ModalBody,
  ModalFooter,
  Label,
  Input,
  Button,
  CardBody,
  InputGroup,
} from 'reactstrap';
import Select from 'react-select';
import Box from '@mui/material/Box';
import {
  DataGrid,
  GridActionsCellItem,
  useGridApiContext,
  useGridSelector,
  gridPageSelector,
  gridPageCountSelector,
  GridOverlay,
} from '@mui/x-data-grid';
import * as Icon from 'react-feather';
import { LinearProgress } from '@mui/material';
import { toast, ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import DeleteIcon from '@mui/icons-material/Delete';
import { NumericFormat } from 'react-number-format';
import Pagination from '@mui/material/Pagination';

import Tarefaedicao from '../projeto/Tarefaedicao';
import Excluirregistro from '../../Excluirregistro';
import Solicitardiaria from '../projeto/Solicitardiaria';

//import { CustomPagination, CustomNoRowsOverlay } from '../../../components/CustomDataGrid';

import api from '../../../services/api';
import DiariasSection from '../projeto/components/DiariasSection';

const Rollouthuaweiedicao = ({
  show,
  setshow,
  ididentificador,
  titulotopo,
  atualiza,
  huaweiSelecionado,
}) => {
  // 1) estados de identificação
  const [numero, setNumero] = useState('');
  const [cliente, setCliente] = useState('');
  const [regiona, setRegiona] = useState('');
  const [site, setSite] = useState('');
  //const GRID_VIEWPORT_HEIGHT = 60;
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
  const [ididentificadortarefa] = useState('');
  const [loading, setloading] = useState(false);
  const [listamigo, setlistamigo] = useState([]);
  const [titulotarefa] = useState('');
  const [pageSize, setPageSize] = useState(10);
  const [paginationModeldiarias, setPaginationModeldiarias] = useState({
    pageSize: 5,
    page: 0,
  });
  const [identificadorsolicitacaodiaria, setidentificadorsolicitacaodiaria] = useState('');
  const [telacadastrosolicitacaodiaria, settelacadastrosolicitacaodiaria] = useState(false);
  const [titulodiaria, settitulodiaria] = useState('');
  const [solicitacaodiaria, setsolicitacaodiaria] = useState([]);
  const [iddiaria, setiddiaria] = useState(0);
  const [telaexclusaodiaria, settelaexclusaodiaria] = useState(false);
  const [telaexclusaopj, settelaexclusaopj] = useState(false);
  const [telaexclusaoclt, settelaexclusaoclt] = useState(false);
  const [idacionamentopj, setidacionamentopj] = useState(0);
  const [idacionamentoclt, setidacionamentoclt] = useState(0);

  // estados para acionamentos (CLT e PJ)
  const [pacotes, setpacotes] = useState([]);
  const [pacotesacionadospj, setpacotesacionadospj] = useState([]);
  const [pacotesacionadosclt, setpacotesacionadosclt] = useState([]);
  const [colaboradorlistapj, setcolaboradorlistapj] = useState([]);
  const [colaboradorlistaclt, setcolaboradorlistaclt] = useState([]);
  const [rowSelectionModel, setRowSelectionModel] = useState([]);
  const [rowSelectionModelpacotepj, setRowSelectionModelpacotepj] = useState([]);
  const [idcolaboradorpj, setidcolaboradorpj] = useState('');
  const [selectedoptioncolaboradorpj, setselectedoptioncolaboradorpj] = useState(null);
  const [regiao, setregiao] = useState('');
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
  const usuario = localStorage.getItem('sessionId');

  const [, setEnderecoSite] = useState('');
  const [municipio, setMunicipio] = useState('');
  const [latitude, setLatitude] = useState('');
  const [longitude, setLongitude] = useState('');

  const [tipoDeInfra, setTipoDeInfra] = useState('');
  const [quadrante, setQuadrante] = useState('');
  const [ddd, setDdd] = useState('');
  const [endereco, setEndereco] = useState('');
  const [detentorDaArea, setDetentorDaArea] = useState('');
  const [idDetentora, setIdDetentora] = useState('');
  const [idOutros, setIdOutros] = useState('');
  const [formaAcesso, setFormaAcesso] = useState('');
  const [observacaoDeAcesso, setObservacaoDeAcesso] = useState('');
  const [dataSolicitado, setDataSolicitado] = useState('');
  const [dataInicio, setDataInicio] = useState('');
  const [dataFim, setDataFim] = useState('');
  const [statusAcesso, setStatusAcesso] = useState('');
  const [numeroDeSolicitacao, setNumeroDeSolicitacao] = useState('');
  const [tratativaDeAcessos, setTratativaDeAcessos] = useState('');
  const [duId, setDuId] = useState('');
  const [duName, setDuName] = useState('');
  const [statusAtt, setStatusAtt] = useState('');
  const [equipeAtt, setEquipeAtt] = useState([]);
  const [metaPlan, setMetaPlan] = useState('');
  const [atividadeEscopo, setAtividadeEscopo] = useState('');
  const [acionamentosRecentes, setAcionamentosRecentes] = useState('');
  const [colaboradorLista, setColaraboradorLista] = useState([]);

  const sanitizeLabel = (s) => (s || '').replace(/\s+$/, '').replace(/@+$/, '').trim();

  // >>> ALTERAÇÃO 1: estado correto para guardar IDs pendentes da equipe <<<
  const [pendingEquipeIds, setPendingEquipeIds] = useState([]);

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    //idlocal: idsite,
    idprojetohuawei: ididentificador,
    idcontroleacessobusca: localStorage.getItem('sessionId'),
    //idempresas: idcolaboradorpj,
    deletado: 0,
    osouobra: site,
    obra: numero,
  };

  // === NOVO: montar payload e salvar "Acesso" ===
  const montarPayloadAcesso = () => ({
    idrollout: ididentificador,
    tipoDeInfra,
    quadrante,
    ddd,
    municipio,
    endereco,
    latitude,
    longitude,
    detentorDaArea,
    idDetentora,
    idOutros,
    formaAcesso,
    observacaoDeAcesso,
    dataSolicitado,
    dataInicio,
    dataFim,
    statusAcesso,
    numeroDeSolicitacao,
    tratativaDeAcessos,
    duId,
    duName,
    statusAtt,
    // envia somente os IDs/values da Equipe
    equipeAtt: Array.isArray(equipeAtt) ? equipeAtt.map((o) => (o?.value ?? o)).filter(Boolean) : [],
    metaPlan,
    atividadeEscopo,
    acionamentosRecentes,
    regiao,
    // contexto
    idcliente: params.idcliente,
    idusuario: params.idusuario,
    idloja: params.idloja,
  });

  const salvarAcesso = async () => {
    try {
      setloading(true);
      const payload = montarPayloadAcesso();
      const resp = await api.post('v1/projetohuawei/acesso', payload);
      if (resp.status === 200 || resp.status === 201) {
        toast.success('Acesso salvo');
        return true;
      }
      toast.error('Falha ao salvar Acesso');
      return false;
    } catch (err) {
      if (err?.response?.data?.erro) toast.error(err.response.data.erro);
      else toast.error('Erro ao salvar Acesso');
      return false;
    } finally {
      setloading(false);
    }
  };

  const handleSalvar = async () => {
    const ok = await salvarAcesso();
    if (ok) {
      atualiza();
      setshow(false);
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

  // 1) function
  function CustomPagination() {
    const apiRef = useGridApiContext();
    const page = useGridSelector(apiRef, gridPageSelector);
    const pageCount = useGridSelector(apiRef, gridPageCountSelector);

    return (
      <Pagination
        color="primary"
        count={pageCount}
        page={page + 1}
      //onChange={(event, value) => apiRef.current.setPage(value - 1)}
      />
    );
  }

  const listacolaborador = async () => {
    try {
      setloading(true);
      await api.get("v1/pessoa/select").then((response) => {
        const opts = (response.data || []).map(o => ({
          ...o,
          label: sanitizeLabel(o.label),
        }));
        setColaraboradorLista(opts);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  // 2) fetch de identificação
  const fetchIdentificacao = async () => {
    try {
      const response = await api.get('v1/projetohuaweiid', {
        params: {
          id: ididentificador,
          idcliente: params.idcliente,
          idusuario: params.idusuario,
          idloja: params.idloja,
        },
      });
      const data = response.data || {};

      // já existia:
      setNumero(data.numero || '');
      setCliente(data.cliente || '');
      setRegiona(data.regiona || '');
      setSite(data.siteid || '');

      // >>> ALTERAÇÃO 2: guardar somente os IDs vindos do backend <<<
      setPendingEquipeIds(Array.isArray(data.acesso_equipe) ? data.acesso_equipe : []);

      // >>> preenche ACESSO <<<
      setIdOutros(data.acessoIdOutros || '');
      setFormaAcesso(data.acessoFormaAcesso || '');
      setDetentorDaArea(data.acessoDetentorArea || '');
      setIdDetentora(data.acessoIdDetentora || '');
      setObservacaoDeAcesso(data.acessoObservacaoAcesso || '');
      setregiao(data.acessoRegiao || '');

      setTipoDeInfra(data.acessoTipoInfra || '');
      setQuadrante(data.acessoQuadrante || '');
      setDdd((data.acessoDdd ?? '').toString());
      setMunicipio(data.acessoMunicipio || '');
      setEndereco(data.acessoEndereco || '');
      setLatitude(data.acessoLatitude || '');
      setLongitude(data.acessoLongitude || '');
      setNumeroDeSolicitacao(data.acessoNumeroSolicitacao || '');
      setDataSolicitado(data.acessoDataSolicitado || '');
      setDataInicio(data.acessoDataInicio || '');
      setDataFim(data.acessoDataFim || '');
      setStatusAcesso(data.acessoStatusAcesso || '');
      setTratativaDeAcessos(data.acessoTratativaAcessos || '');
      setDuId(data.acessoDuId || '');
      setDuName(data.acessoDuName || '');
      setStatusAtt(data.acessoStatusAtt || '');
      setMetaPlan(data.acessoMetaPlan || '');
      setAtividadeEscopo(data.acessoAtividadeEscopo || '');
      setAcionamentosRecentes(data.acessoAcionamentosRecentes || '');
    } catch (err) {
      console.error('Erro ao carregar identificação', err);
    }
  };

  const listalpu = async () => {
    try {
      await api.get(`v1/projetotelefonica/listalpu`, { params }).then((response) => {
        setlpulista(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    }
  };

  const novocadastrotarefa = () => {
    api
      .post('v1/projetohuawei/novocadastrotarefa', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          settelacadastrotarefa(true);
        }
      });
  };

  const listapormigo = async () => {
    try {
      setloading(true);
      await api.get('v1/projetohuawei/listamigo', { params }).then((response) => {
        setlistamigo(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const columnsmigo = [
    { field: 'po', headerName: 'PO', width: 150, align: 'left', editable: false },
    { field: 'poritem', headerName: 'PO+Item', width: 150, align: 'left', editable: false },
    { field: 'datacriacaopo', headerName: 'Data Criação PO', width: 120, align: 'left', editable: false },
    { field: 'escopo', headerName: 'Escopo', width: 180, align: 'left', editable: false },
    { field: 'codigoservico', headerName: 'Código Serviço', width: 180, align: 'left', editable: false },
    { field: 'descricaoservico', headerName: 'Descrição Serviço', width: 300, align: 'left', editable: false },
    { field: 'qtyordered', headerName: 'Quantidade', width: 100, align: 'center', editable: false },
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
      width: 140,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
    { field: 'nome', headerName: 'Nome Colaborador', type: 'string', width: 300, align: 'left', editable: false },
    { field: 'descricao', headerName: 'Descrição', type: 'string', width: 300, align: 'left', editable: false },
    {
      field: 'valoroutrassolicitacoes',
      headerName: 'Outras Solicitações',
      type: 'number',
      width: 150,
      align: 'right',
      valueFormatter: (parametros) => {
        if (parametros.value == null) return '';
        return parametros.value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
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
        return parametros.value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
      },
      editable: false,
    },
    { field: 'solicitante', headerName: 'Solicitante', type: 'string', width: 250, align: 'left', editable: false },
  ];

  // colunas para pacotes e acionamentos
  const colunaspacotes = [
    { field: 'ts', headerName: 'TS', width: 150, align: 'left', editable: false },
    {
      field: 'brevedescricaoingles',
      headerName: 'BREVE DESCRIÇÃO EM INGLÊS',
      width: 300,
      align: 'left',
      editable: false,
      renderCell: (p) => <div style={{ whiteSpace: 'pre-wrap' }}>{p.value}</div>,
    },
    {
      field: 'brevedescricao',
      headerName: 'BREVE DESCRICAO',
      width: 400,
      align: 'left',
      editable: false,
      renderCell: (p) => <div style={{ whiteSpace: 'pre-wrap' }}>{p.value}</div>,
    },
    { field: 'codigolpuhuawei', headerName: 'CODIGO LPU HUAWEI', width: 150, align: 'left', editable: false },
  ];

  function deleteUser(stat) {
    setidacionamentopj(stat);
    settelaexclusaopj(true);
  }

  function deleteuserclt(stat) {
    setidacionamentoclt(stat);
    settelaexclusaoclt(true);
  }

  const colunaspacotesacionados = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (cellParams) => [
        <GridActionsCellItem
          icon={<DeleteIcon />}
          label="Delete"
          onClick={() => deleteUser(cellParams.id)}
        />,
      ],
    },
    { field: 'nome', headerName: 'COLABORADOR', width: 250, align: 'left', editable: false },
    { field: 'po', headerName: 'PO', width: 120, align: 'left', editable: false },
    { field: 'atividade', headerName: 'ATIVIDADE', width: 110, align: 'left', editable: false },
    { field: 'qtd', headerName: 'QTD', width: 60, align: 'left', editable: false },
    { field: 'ts', headerName: 'TS', width: 120, align: 'left', editable: false },
    {
      field: 'brevedescricao',
      headerName: 'BREVE DESCRICAO',
      width: 290,
      align: 'left',
      editable: false,
      renderCell: (p) => <div style={{ whiteSpace: 'pre-wrap' }}>{p.value}</div>,
    },
    { field: 'codigolpuhuawei', headerName: 'CODIGO LPU HUAWEI', width: 140, align: 'left', editable: false },
    {
      field: 'dataacionamento',
      headerName: 'DATA ACIONAMENTO',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (p) => (p.value ? new Date(p.value) : null),
      valueFormatter: (p) =>
        p.value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(p.value) : '',
    },
    {
      field: 'dataenvioemail',
      headerName: 'DATA ENVIO EMAIL',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (p) => (p.value ? new Date(p.value) : null),
      valueFormatter: (p) =>
        p.value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(p.value) : '',
    },
  ];

  const colunaspacotesacionadosclt = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (cellParams) => [
        <GridActionsCellItem
          icon={<DeleteIcon />}
          label="Delete"
          onClick={() => deleteuserclt(cellParams.id)}
        />,
      ],
    },
    { field: 'nome', headerName: 'COLABORADOR', width: 250, align: 'left', editable: false },
    { field: 'po', headerName: 'PO', width: 120, align: 'left', editable: false },
    { field: 'atividade', headerName: 'ATIVIDADE', width: 110, align: 'left', editable: false },
    {
      field: 't2codmatservsw',
      headerName: 'DESCRICAO',
      width: 290,
      align: 'left',
      editable: false,
      renderCell: (p) => <div style={{ whiteSpace: 'pre-wrap' }}>{p.value}</div>,
    },
    {
      field: 'dataincio',
      headerName: 'DATA INICIO',
      width: 140,
      align: 'left',
      type: 'date',
      valueGetter: (p) => (p.value ? new Date(p.value) : null),
      valueFormatter: (p) =>
        p.value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(p.value) : '',
    },
    {
      field: 'datafinal',
      headerName: 'DATA FIM',
      width: 140,
      align: 'left',
      type: 'date',
      valueGetter: (p) => (p.value ? new Date(p.value) : null),
      valueFormatter: (p) =>
        p.value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(p.value) : '',
    },
    {
      field: 'dataacionamento',
      headerName: 'DATA ACIONAMENTO',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (p) => (p.value ? new Date(p.value) : null),
      valueFormatter: (p) =>
        p.value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(p.value) : '',
    },
    {
      field: 'dataenvioemail',
      headerName: 'DATA ENVIO EMAIL',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (p) => (p.value ? new Date(p.value) : null),
      valueFormatter: (p) =>
        p.value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(p.value) : '',
    },
  ];

  const novocadastrodiaria = () => {
    api
      .post('v1/solicitacao/novocadastrodiaria', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setidentificadorsolicitacaodiaria(response.data.retorno);
          settitulodiaria('Cadastrar Solicitação de Diaria');
          settelacadastrosolicitacaodiaria(true);
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

  const listasolicitacaodiaria = async () => {
    try {
      setloading(true);
      await api.get('v1/projetohuawei/diaria', { params }).then((response) => {
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
      const response = await api.get('v1/empresas/selectpj', { params });
      const opts = (response.data || []).map(o => ({
        ...o,
        label: sanitizeLabel(o.label),
      }));
      setcolaboradorlistapj(opts);

      if (idcolaboradorpj) {
        const found = opts.find(o => String(o.value) === String(idcolaboradorpj));
        if (found) setselectedoptioncolaboradorpj(found);
      }
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const listacolaboradorclt = async () => {
    try {
      setloading(true);
      await api.get('v1/pessoa/selectclt').then((response) => {
        const opts = (response.data || []).map(o => ({
          ...o,
          label: sanitizeLabel(o.label),
        }));
        setcolaboradorlistaclt(opts);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const listapacotes = async (historico) => {
    try {
      setloading(true);
      await api.get(`v1/projetohuawei/pacotes/${historico}`, { params }).then((response) => {
        setpacotes(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const listapacotesacionados = async () => {
    try {
      setloading(true);
      await api.get('v1/projetohuawei/listaacionamentopj', { params }).then((response) => {
        setpacotesacionadospj(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const listapacotesacionadosclt = async () => {
    try {
      setloading(true);
      await api.get('v1/projetohuawei/listaacionamentoclt', { params }).then((response) => {
        setpacotesacionadosclt(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const uploadanexo = async (e) => {
    e.preventDefault();
    const formData = new FormData();
    formData.append('files', arquivoanexo);
    try {
      setloading(true);
      const response = await api.post('v1/uploadanexo', formData);
      if (response.status === 201) {
        toast.success('Arquivo Anexado');
      } else {
        toast.error('Erro ao Anexar arquivo!');
      }
    } catch (err) {
      toast.error('Erro: Tente novamente mais tarde!');
    } finally {
      setloading(false);
    }
  };

  const salvarpj = async (pacoteid, atividadeid) => {
    try {
      const response = await api.post('v1/projetohuawei/acionamentopj', {
        idrollout: ididentificador,
        idatividade: atividadeid,
        idpacote: pacoteid,
        idcolaborador: idcolaboradorpj,
        regiao,
        lpuhistorico,
        valornegociado,
        observacao: observacaopj,
        idfuncionario: localStorage.getItem('sessionId'),
      });
      return response.status === 201;
    } catch (err) {
      toast.error(err.message);
      return false;
    }
  };

  const salvarclt = async (atividadeid) => {
    try {
      const response = await api.post('v1/projetohuawei/acionamentoclt', {
        idrollout: ididentificador,
        idatividade: atividadeid,
        idcolaborador: idcolaboradorclt,
        datainicio: datainicioclt,
        datafinal: datafinalclt,
        horanormal: horanormalclt,
        hora50: hora50clt,
        hora100: hora100clt,
        totalhoras: totalhorasclt,
        observacao: observacaoclt,
        idfuncionario: localStorage.getItem('sessionId'),
      });
      return response.status === 201;
    } catch (err) {
      toast.error(err.message);
      return false;
    }
  };

  const execacionamentopj = async () => {
    if (!rowSelectionModel || rowSelectionModel.length !== 1) {
      toast.error('Selecione uma atividade');
      return;
    }
    if (!rowSelectionModelpacotepj || rowSelectionModelpacotepj.length === 0) {
      toast.error('Selecione um ou mais pacotes');
      return;
    }
    const resultados = await Promise.all(
      rowSelectionModelpacotepj.map((p) => salvarpj(p, rowSelectionModel[0])),
    );
    if (resultados.some((r) => r)) {
      toast.success('Acionamento salvo');
      listapacotesacionados();
    }
  };

  const execacionamentoclt = async () => {
    if (!rowSelectionModel || rowSelectionModel.length !== 1) {
      toast.error('Selecione uma atividade');
      return;
    }
    const ok = await salvarclt(rowSelectionModel[0]);
    if (ok) {
      toast.success('Acionamento salvo');
      listapacotesacionadosclt();
    }
  };

  const enviaremail = () => {
    if (!colaboradoremail) {
      toast.error('Falta preencher o E-mail!');
      return;
    }
    api
      .post('v1/email/acionamentopj', {
        destinatario: emailadcional,
        destinatario1: colaboradoremail,
        idcolaborador: idcolaboradorpj,
        idrollout: ididentificador,
        idusuario: localStorage.getItem('sessionId'),
      })
      .then((response) => {
        if (response.status === 200) {
          toast.success('Email Enviado');
          listapacotesacionados();
        } else {
          toast.error('Erro ao enviar a mensagem!');
        }
      })
      .catch((err) => {
        toast.error(err.message);
      });
  };

  // 3) dispara quando abrir ou mudar row
  useEffect(() => {
    if (!show) return;

    listacolaborador();

    if (huaweiSelecionado) {
      setMunicipio(huaweiSelecionado.municipio || '');
      setEnderecoSite(huaweiSelecionado.enderecoSite || '');
      setLatitude(huaweiSelecionado.latitude || '');
      setLongitude(huaweiSelecionado.longitude || '');
      setNumero(huaweiSelecionado.numero || '');
      setCliente(huaweiSelecionado.cliente || '');
      setRegiona(huaweiSelecionado.regiona || '');
      setSite(huaweiSelecionado.site || '');
    }

    if (ididentificador) {
      fetchIdentificacao();
      listasolicitacaodiaria();
    }

    if (3 + 3 === 999) {
      listacolaboradorpj();
      listacolaboradorclt();
      listapacotes('NEGOCIADO');
      listapacotesacionados();
      listapacotesacionadosclt();
      listalpu();
    }
  }, [show, ididentificador, huaweiSelecionado]);

  useEffect(() => {
    if (show) {
      listasolicitacaodiaria();
    }
  }, [telacadastrosolicitacaodiaria, telaexclusaodiaria]);

  useEffect(() => {
    // quando o modal de exclusão PJ fechar, atualiza a grid de acionamentos
    if (!telaexclusaopj && 3 + 3 === 999) {
      listapacotesacionados();
    }
  }, [telaexclusaopj]);

  useEffect(() => {
    // quando o modal de exclusão CLT fechar, atualiza a grid de acionamentos
    if (!telaexclusaoclt && 3 + 3 === 999) {
      listapacotesacionadosclt();
    }
  }, [telaexclusaoclt]);

  // >>> ALTERAÇÃO 3: pré-seleciona Equipe Att quando lista + IDs estiverem prontos <<<
  useEffect(() => {
    if (!pendingEquipeIds || pendingEquipeIds.length === 0) return;
    if (!colaboradorLista || colaboradorLista.length === 0) return;

    const idsStr = pendingEquipeIds.map(v => String(v));
    const matched = colaboradorLista.filter(opt => idsStr.includes(String(opt.value)));

    if (matched.length > 0) {
      setEquipeAtt(matched);
    } else {
      setEquipeAtt(pendingEquipeIds.map(id => ({ value: id, label: String(id) })));
    }
  }, [colaboradorLista, pendingEquipeIds]);

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

      <ModalBody className="bg-white">
        {/* === IDENTIFICAÇÃO === */}
        <CardBody className="bg-white pb-0">
          <h5 className="mb-2 fw-bold">Identificação</h5>
          <hr className="mt-0 mb-3" />

          <div className="bg-light p-3 rounded">
            <div className="row g-3">
              <div className="col-sm-3">
                <Label for="campoNumero" className="form-label">
                  Número
                </Label>
                <Input id="campoNumero" type="text" value={numero} disabled />
              </div>

              <div className="col-sm-3">
                <Label for="campoCliente" className="form-label">
                  Cliente
                </Label>
                <Input id="campoCliente" type="text" value={cliente} disabled />
              </div>

              <div className="col-sm-3">
                <Label for="campoRegiona" className="form-label">
                  Nome
                </Label>
                <Input id="campoRegiona" type="text" value={regiona} disabled />
              </div>

              <div className="col-sm-3">
                <Label for="campoSite" className="form-label">
                  Site
                </Label>
                <Input id="campoSite" type="text" value={site} disabled />
              </div>
            </div>
          </div>

          {/*ACESSO*/}
          <div>
            <b>Acesso</b>
            <hr style={{ marginTop: '0px', width: '100%' }} />
            <CardBody className="px-4 , pb-2">
              <div className="row g-3">
                <div className="col-sm-4">
                  ID OUTROS
                  <Input type="text" onChange={(e) => setIdOutros(e.target.value)} value={idOutros} />
                </div>

                <div className="col-sm-4">
                  FORMA DE ACESSO
                  <Input type="text" onChange={(e) => setFormaAcesso(e.target.value)} value={formaAcesso} />
                </div>

                <div className="col-sm-4">
                  DDD
                  <Input type="text" onChange={(e) => setDdd(e.target.value)} value={ddd} />
                </div>

                <div className="col-sm-4">
                  MUNICÍPIO
                  <Input type="text" onChange={(e) => setMunicipio(e.target.value)} value={municipio} />
                </div>

                <div className="col-sm-4">
                  ENDEREÇO
                  <Input type="text" onChange={(e) => setEndereco(e.target.value)} value={endereco} />
                </div>

                <div className="col-sm-4">
                  LATITUDE
                  <Input type="text" onChange={(e) => setLatitude(e.target.value)} value={latitude} />
                </div>

                <div className="col-sm-4">
                  LONGITUDE
                  <Input type="text" onChange={(e) => setLongitude(e.target.value)} value={longitude} />
                </div>

                <div className="col-sm-4">
                  Número de Solicitação
                  <Input
                    type="text"
                    onChange={(e) => setNumeroDeSolicitacao(e.target.value)}
                    value={numeroDeSolicitacao}
                  />
                </div>

                <div className="col-sm-4">
                  DATA-SOLICITAÇÃO
                  <Input type="date" onChange={(e) => setDataSolicitado(e.target.value)} value={dataSolicitado} />
                </div>

                <div className="col-sm-4">
                  DATA-INICIAL
                  <Input type="date" onChange={(e) => setDataInicio(e.target.value)} value={dataInicio} />
                </div>

                <div className="col-sm-4">
                  DATA-FINAL
                  <Input type="date" onChange={(e) => setDataFim(e.target.value)} value={dataFim} />
                </div>

                <div className="col-sm-4">
                  Tipo de Infra
                  <Input
                    type="select"
                    value={tipoDeInfra}
                    onChange={(e) => setTipoDeInfra(e.target.value)}
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

                <div className="col-sm-4">
                  Quadrante
                  <Input type="text" value={quadrante} onChange={(e) => setQuadrante(e.target.value)} />
                </div>

                <div className="col-sm-4">
                  Detentor da Área
                  <Input
                    type="text"
                    value={detentorDaArea}
                    onChange={(e) => setDetentorDaArea(e.target.value)}
                  />
                </div>

                <div className="col-sm-4">
                  ID Detentora
                  <Input type="text" value={idDetentora} onChange={(e) => setIdDetentora(e.target.value)} />
                </div>

                <div className="col-sm-4">
                  Observação de Acesso
                  <Input
                    type="text"
                    value={observacaoDeAcesso}
                    onChange={(e) => setObservacaoDeAcesso(e.target.value)}
                  />
                </div>

                <div className="col-sm-4">
                  Status Acesso
                  <Input
                    type="select"
                    value={statusAcesso}
                    onChange={(e) => setStatusAcesso(e.target.value)}
                  >
                    <option value="">Selecione</option>
                    <option value="Aguardando">Aguardando</option>
                    <option value="Cancelado">Cancelado</option>
                    <option value="Concluído">Concluído</option>
                    <option value="Liberado">Liberado</option>
                    <option value="Pedir">Pedir</option>
                    <option value="Rejeitado">Rejeitado</option>
                    <option value="Sem Acesso">Sem Acesso</option>
                  </Input>
                </div>

                <div className="col-sm-4">
                  Tratativa de Acessos
                  <Input
                    type="text"
                    value={tratativaDeAcessos}
                    onChange={(e) => setTratativaDeAcessos(e.target.value)}
                  />
                </div>

                <div className="col-sm-4">
                  DU ID
                  <Input type="text" value={duId} onChange={(e) => setDuId(e.target.value)} />
                </div>

                <div className="col-sm-4">
                  DU Name
                  <Input type="text" value={duName} onChange={(e) => setDuName(e.target.value)} />
                </div>

                <div className="col-sm-4">
                  Status Att
                  <Input
                    type="select"
                    value={statusAtt}
                    onChange={(e) => setStatusAtt(e.target.value)}
                  >
                    <option value="">Selecione</option>
                    <option value="Aguardar Acionamento">Aguardar Acionamento</option>
                    <option value="Cancelado | Baterias Entregue a TIM">Cancelado | Baterias Entregue a TIM</option>
                    <option value="Finalizado | QC Aprovado">Finalizado | QC Aprovado</option>
                    <option value="Finalizado | QC Pendente (SITE Vandalizado)">Finalizado | QC Pendente (SITE Vandalizado)</option>
                    <option value="Programado">Programado</option>
                    <option value="Programar">Programar</option>
                  </Input>
                </div>

                <div className="col-sm-4">
                  Equipe Att
                  <Select
                    isMulti
                    options={colaboradorLista}
                    value={equipeAtt}
                    onChange={setEquipeAtt}
                    placeholder="Selecione"
                  />
                </div>

                <div className="col-sm-4">
                  Meta Plan
                  <Input type="text" value={metaPlan} onChange={(e) => setMetaPlan(e.target.value)} />
                </div>

                <div className="col-sm-4">
                  Atividade / Escopo
                  <Input
                    type="text"
                    value={atividadeEscopo}
                    onChange={(e) => setAtividadeEscopo(e.target.value)}
                  />
                </div>

                <div className="col-sm-4">
                  Acionamentos Recentes
                  <Input
                    type="text"
                    value={acionamentosRecentes}
                    onChange={(e) => setAcionamentosRecentes(e.target.value)}
                  />
                </div>

                <div className="col-sm-4">
                  Região
                  <Input
                    type="select"
                    name="regiao"
                    onChange={(e) => setregiao(e.target.value)}
                    value={regiao}
                  >
                    <option value="">Selecione</option>
                    <option value="CAPITAL">CAPITAL</option>
                    <option value="INTERIOR">INTERIOR</option>
                  </Input>
                </div>
              </div>
            </CardBody>
          </div>


          {/* === Acompanhamento Financeiro === */}
          <div>
            <b>Acompanhamento Financeiro</b>
            <hr style={{ marginTop: '0px', width: '100%' }} />
            <CardBody className="px-4 , pb-2">
              <div className="row g-3">
                <Box>
                  <br />
                </Box>
              </div>
            </CardBody>
          </div>

          {/* === Acompanhamento Físico === */}
          <div>
            <CardBody className="pb-0 bg-white">
              <h5 className="mb-2 fw-bold">Acompanhamento Físico</h5>
              <div className="row g-3">
                <div className="col-sm-4">
                  Situação Implantação
                  <Input
                    type="select"
                    onChange={(e) => setsituacaoimplantacao(e.target.value)}
                    value={situacaoimplantacao}
                    name="Tipo Pessoa"
                  >
                    <option>Selecione</option>
                    <option>Aguardando aceite do ASP</option>
                    <option>Aguardando agendamento Bluebee</option>
                    <option>Aguardando definição de Equipe</option>
                    <option>Cancelado</option>
                    <option>Concluída</option>
                    <option>Em Aceitação</option>
                    <option>Fim do Período de Garantia</option>
                    <option>Iniciando cancelamento da Obra</option>
                    <option>Obra em Andamento</option>
                    <option>Paralisada por HSE</option>
                    <option>Período de Garantia</option>
                    <option>Retomada planejada</option>
                    <option>Revisar Finalização da Obra</option>
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
                    <option>Selecione</option>
                    <option>Completa</option>
                    <option>Em Andamento</option>
                    <option>Não Iniciou</option>
                  </Input>
                </div>
              </div>

              <hr />
              <div className="row g-3">
                <div className="row g-3">
                  <div className="col-sm-3">
                    Data da Criação Demanda (Dia)
                    <Input
                      type="date"
                      onChange={(e) => setdatadacriacaodademandadia(e.target.value)}
                      value={datadacriacaodademandadia}
                      placeholder="Descrição completa"
                      disabled
                    />
                  </div>

                  <div className="col-sm-3">
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
                  <div className="col-sm-3">
                    Data de Início / Entrega (MOS - Planejado) (Dia)
                    <Input
                      type="date"
                      onChange={(e) => setdatainicioentregamosplanejadodia(e.target.value)}
                      value={datainicioentregamosplanejadodia}
                      placeholder="Descrição completa"
                    />
                  </div>

                  <div className="col-sm-3">
                    Data de Recebimento do Site (MOS - Reportado) (Dia)
                    <Input
                      type="date"
                      onChange={(e) => setdatarecebimentodositemosreportadodia(e.target.value)}
                      value={datarecebimentodositemosreportadodia}
                      placeholder="Código SKU ou referência"
                      disabled
                    />
                  </div>
                </div>

                <div className="row g-3">
                  <div className="col-sm-3">
                    Data de Fim de Instalação (Planejado) (Dia)
                    <Input
                      type="date"
                      onChange={(e) => setdatafiminstalacaoplanejadodia(e.target.value)}
                      value={datafiminstalacaoplanejadodia}
                      placeholder="Descrição completa"
                    />
                  </div>

                  <div className="col-sm-3">
                    Data de Conclusão (Reportado) (Dia)
                    <Input
                      type="date"
                      onChange={(e) => setdataconclusaoreportadodia(e.target.value)}
                      value={dataconclusaoreportadodia}
                      placeholder="Descrição completa"
                      disabled
                    />
                  </div>

                  <div className="col-sm-3">
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
                  <div className="col-sm-3">
                    Data de Integração (Planejado) (Dia)
                    <Input
                      type="date"
                      onChange={(e) => setdataintegracaoplanejadodia(e.target.value)}
                      value={dataintegracaoplanejadodia}
                      placeholder="Descrição completa"
                    />
                  </div>

                  <div className="col-sm-3">
                    Data de Validação ERIBOX
                    <br />
                    (Dia)
                    <Input
                      type="date"
                      onChange={(e) => setdatavalidacaoeriboxedia(e.target.value)}
                      value={datavalidacaoeriboxedia}
                      placeholder="Descrição completa"
                      disabled
                    />
                  </div>

                  <div className="col-sm-3">
                    Aceitação Final
                    <br />
                    (Dia)
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
                <div className="col-sm-6">
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

              <br />
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
              <Box sx={{ height: '100%', width: '100%' }}>
                <DataGrid
                  rows={listamigo}
                  columns={columnsmigo}
                  loading={loading}
                  pageSize={pageSize}
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  checkboxSelection
                  rowSelectionModel={rowSelectionModel}
                  onRowSelectionModelChange={(newModel) => setRowSelectionModel(newModel)}
                  disableSelectionOnClick
                  experimentalFeatures={{ newEditingApi: true }}
                  components={{
                    Pagination: CustomPagination,
                    LoadingOverlay: LinearProgress,
                    NoRowsOverlay: CustomNoRowsOverlay,
                  }}
                />
              </Box>

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
                  numero={site}
                  idlocal={ididentificador}
                  sigla={site}
                  regional={regiona}
                  clientelocal="HUAWEI"
                  projetousual="HUAWEI"
                  novo="0"
                />
              ) : null}

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

              <div>
                <br />
                <b>Acionamentos</b>
                <hr style={{ marginTop: '0px', width: '100%' }} />
                <CardBody className="px-4 , pb-2">
                  <div className="row g-3">
                    <div className="col-sm-8">
                      Colaborador CLT
                      <Select
                        isClearable
                        isSearchable
                        name="colaboradorclt"
                        options={colaboradorlistaclt}
                        placeholder="Selecione"
                        isLoading={loading}
                        onChange={(e) =>
                          e
                            ? (setselectedoptioncolaboradorclt(e), setidcolaboradorclt(e.value))
                            : setselectedoptioncolaboradorclt(null)
                        }
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
                    <Button
                      color="primary"
                      onClick={execacionamentoclt}
                      disabled={modoVisualizador()}
                    >
                      Adicionar Acionamento CLT <Icon.Plus />
                    </Button>
                  </div>
                  <br />
                  <Box sx={{ height: 300, width: '100%' }}>
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
                    />
                  </Box>
                  <hr />
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
                        onChange={(e) =>
                          e
                            ? (setselectedoptioncolaboradorpj(e), setidcolaboradorpj(e.value))
                            : setselectedoptioncolaboradorpj(null)
                        }
                        value={selectedoptioncolaboradorpj}
                      />
                    </div>
                    <div className="col-sm-2">
                      Região
                      <Input
                        type="select"
                        name="regiao"
                        onChange={(e) => setregiao(e.target.value)}
                        value={regiao}
                      >
                        <option value="">Selecione</option>
                        <option value="CAPITAL">CAPITAL</option>
                        <option value="INTERIOR">INTERIOR</option>
                      </Input>
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
                        onChange={(e) => {
                          if (e) {
                            setlpuhistorico(e.label);
                            setselectedoptionlpu(e);
                            listapacotes(e.label);
                          } else {
                            setlpuhistorico('');
                            setselectedoptionlpu(null);
                          }
                        }}
                        value={selectedoptionlpu}
                      />
                    </div>

                    {lpuhistorico === 'NEGOCIADO' && // mostra só quando NEGOCIADO
                      (usuario === '33' || usuario === '35' || usuario === '78') && ( // opcional: filtra por usuário
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
                  <div className="row g-3">
                    <Box sx={{ height: 300, width: '100%' }}>
                      <DataGrid
                        rows={pacotes}
                        columns={colunaspacotes}
                        loading={loading}
                        checkboxSelection
                        onRowSelectionModelChange={(m) => setRowSelectionModelpacotepj(m)}
                        rowSelectionModel={rowSelectionModelpacotepj}
                        disableSelectionOnClick
                        components={{
                          Pagination: CustomPagination,
                          LoadingOverlay: LinearProgress,
                          NoRowsOverlay: CustomNoRowsOverlay,
                        }}
                      />
                    </Box>
                  </div>
                  <br />
                  <br />
                  <div>
                    {telaexclusaopj && (
                      <Excluirregistro
                        show={telaexclusaopj}
                        setshow={settelaexclusaopj}
                        ididentificador={idacionamentopj}
                        quemchamou="ATIVIDADEPJ"
                        atualiza={listapacotesacionados}
                      />
                    )}
                  </div>
                  <br />
                  <div>
                    {telaexclusaoclt && (
                      <Excluirregistro
                        show={telaexclusaoclt}
                        setshow={settelaexclusaoclt}
                        ididentificador={idacionamentoclt}
                        quemchamou="ATIVIDADECLT"
                        atualiza={listapacotesacionadosclt}
                      />
                    )}
                  </div>
                  <br />
                  <div className=" col-sm-12 d-flex flex-row-reverse">
                    <Button
                      color="primary"
                      onClick={execacionamentopj}
                      disabled={modoVisualizador()}
                    >
                      Adicionar Acionamento PJ <Icon.Plus />
                    </Button>
                  </div>
                  <br />
                  <Box sx={{ height: 300, width: '100%' }}>
                    <DataGrid
                      rows={pacotesacionadospj}
                      columns={colunaspacotesacionados}
                      loading={loading}
                      disableSelectionOnClick
                      components={{
                        Pagination: CustomPagination,
                        LoadingOverlay: LinearProgress,
                        NoRowsOverlay: CustomNoRowsOverlay,
                      }}
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
                          <Button
                            color="primary"
                            onClick={uploadanexo}
                            disabled={modoVisualizador()}
                          >
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
              </div>
            </CardBody>
          </div>
        </CardBody>

        {/* === DIÁRIAS (trocado para componente, resto intacto) === */}
        <CardBody className="bg-white pb-0">
          <DiariasSection
            rows={solicitacaodiaria}
            columns={colunasdiarias}
            loading={loading}
            paginationModel={paginationModeldiarias}
            onPaginationModelChange={setPaginationModeldiarias}
            onNovoCadastro={novocadastrodiaria}
          />
        </CardBody>

        {/* === aqui continua o restante do formulário (Acesso, Financeiro, etc.) === */}
      </ModalBody>

      <ModalFooter>
        <Button
          color="success"
          onClick={handleSalvar}
          disabled={loading}
        >
          Salvar
        </Button>{' '}
        <Button color="secondary" onClick={() => setshow(false)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Rollouthuaweiedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
  titulotopo: PropTypes.string.isRequired,
  atualiza: PropTypes.func.isRequired,
  huaweiSelecionado: PropTypes.object,
};

export default Rollouthuaweiedicao;

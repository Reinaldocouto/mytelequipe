import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import {
  Modal,
  ModalHeader,
  ModalBody,
  ModalFooter,
  // Form,
  // FormGroup,
  Label,
  // Col,
  Input,
  Button,
  CardBody,

   
} from 'reactstrap';
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
import Pagination from '@mui/material/Pagination';

import Tarefaedicao from '../projeto/Tarefaedicao';
import Excluirregistro from '../../Excluirregistro';
import Solicitardiaria from '../projeto/Solicitardiaria';

//import { CustomPagination, CustomNoRowsOverlay } from '../../../components/CustomDataGrid';

import api from '../../../services/api';

const Rolloutericssonedicao = ({
  show,
  setshow,
  ididentificador,
  titulotopo,
  atualiza,
  ericssonSelecionado,
  
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
  const [datarecebimentodositemosreportadodia, setdatarecebimentodositemosreportadodia] = useState('');
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



  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    //idlocal: idsite,
    idprojetoericsson: ididentificador,
    idcontroleacessobusca: localStorage.getItem('sessionId'),
    //idempresas: idcolaboradorpj,
    deletado: 0,
    osouobra: numero,
    obra: numero,
    //identificador pra mandar pro solicitação edição:
    //identificadorsolicitacao: ididentificador2,
  };

  
  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

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

  // 2) fetch de identificação
  const fetchIdentificacao = async () => {
    try {
      const response = await api.get(`v1/projetoericssonid/${ididentificador}`, {
        params: {
          idcliente: localStorage.getItem('sessionCodidcliente'),
          idusuario: localStorage.getItem('sessionId'),
          idloja: localStorage.getItem('sessionloja'),
        },
      });
      const {
        numero: num = '',
        cliente: cli = '',
        regiona: rg = '',
        site: st = '',
      } = response.data || {};

      setNumero(num);
      setCliente(cli);
      setRegiona(rg);
      setSite(st);
    } catch (err) {
      console.error('Erro ao carregar identificação', err);
    }
  };

  const novocadastrotarefa = () => {
    api
      .post('v1/projetoericsson/novocadastrotarefa', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          
          
          settelacadastrotarefa(true);
        } 
      })
      
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
    },
    {
      field: 'qtyordered',
      headerName: 'Quantidade',
      width: 100,
      align: 'center',
      editable: false,
    },
  ];

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
    {
      field: 'nome',
      headerName: 'Nome Colaborador',
      type: 'string',
      width: 300,
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
    { field: 'codigolpuvivo', headerName: 'CODIGO LPU VIVO', width: 150, align: 'left', editable: false },
  ];

  const colunaspacotesacionados = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (params) => [
        <GridActionsCellItem icon={<DeleteIcon />} label="Delete" onClick={() => deleteUser(params.id)} />,
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
    { field: 'codigolpuvivo', headerName: 'CODIGO LPU VIVO', width: 140, align: 'left', editable: false },
    {
      field: 'dataacionamento',
      headerName: 'DATA ACIONAMENTO',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (p) => (p.value ? new Date(p.value) : null),
      valueFormatter: (p) => (p.value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(p.value) : ''),
    },
    {
      field: 'dataenvioemail',
      headerName: 'DATA ENVIO EMAIL',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (p) => (p.value ? new Date(p.value) : null),
      valueFormatter: (p) => (p.value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(p.value) : ''),
    },
  ];

  const colunaspacotesacionadosclt = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (params) => [
        <GridActionsCellItem icon={<DeleteIcon />} label="Delete" onClick={() => deleteuserclt(params.id)} />,
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
      valueFormatter: (p) => (p.value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(p.value) : ''),
    },
    {
      field: 'datafinal',
      headerName: 'DATA FIM',
      width: 140,
      align: 'left',
      type: 'date',
      valueGetter: (p) => (p.value ? new Date(p.value) : null),
      valueFormatter: (p) => (p.value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(p.value) : ''),
    },
    {
      field: 'dataacionamento',
      headerName: 'DATA ACIONAMENTO',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (p) => (p.value ? new Date(p.value) : null),
      valueFormatter: (p) => (p.value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(p.value) : ''),
    },
    {
      field: 'dataenvioemail',
      headerName: 'DATA ENVIO EMAIL',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (p) => (p.value ? new Date(p.value) : null),
      valueFormatter: (p) => (p.value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(p.value) : ''),
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
      await api.get('v1/projetoericsson/diaria', { params }).then((response) => {
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
        setcolaboradorlistapj(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

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

  const listapacotes = async (historico) => {
    try {
      setloading(true);
      await api.get(`v1/projetoericsson/pacotes/${historico}`, { params }).then((response) => {
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
      await api.get('v1/projetoericsson/listaacionamentopj', { params }).then((response) => {
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
      await api.get('v1/projetoericsson/listaacionamentoclt', { params }).then((response) => {
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
      const response = await api.post('v1/projetoericsson/acionamentopj', {
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
      const response = await api.post('v1/projetoericsson/acionamentoclt', {
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

  function deletediaria(stat) {
    setiddiaria(stat);
    settelaexclusaodiaria(true);
  }

  function deleteUser(stat) {
    setidacionamentopj(stat);
    settelaexclusaopj(true);
  }

  function deleteuserclt(stat) {
    setidacionamentoclt(stat);
    settelaexclusaoclt(true);
  }

  // 3) dispara quando abrir ou mudar row
  useEffect(() => {
    if (!show) return;

    if (ericssonSelecionado) {
      setNumero(ericssonSelecionado.numero || '');
      setCliente(ericssonSelecionado.cliente || '');
      setRegiona(ericssonSelecionado.regiona || '');
      setSite(ericssonSelecionado.site || '');
    }

    if (ididentificador) {
      fetchIdentificacao();
      listasolicitacaodiaria();
      listacolaboradorpj();
      listacolaboradorclt();
      listapacotes('NEGOCIADO');
      listapacotesacionados();
      listapacotesacionadosclt();
    }
  }, [show, ididentificador, ericssonSelecionado]);

  useEffect(() => {
    if (show) {
      listasolicitacaodiaria();
    }
  }, [telacadastrosolicitacaodiaria, telaexclusaodiaria]);

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
                <div className="col-sm-2">
                  ID_VIVO
                  <Input type="text" value={null} disabled />
                </div>
                <div className="col-sm-2">
                  INFRA
                  <Input type="select" name="infra" onChange={(e) => e.target.value} value={null}>
                    <option value="">Selecione</option>
                    <option value="CAMUFLADO">CAMUFLADO</option>
                    <option value="GREENFIELD">GREENFIELD</option>
                    <option value="INDOOR">INDOOR</option>
                    <option value="MASTRO">MASTRO</option>
                    <option value="POSTE METÁLICO">POSTE METÁLICO</option>
                    <option value="ROOFTOP">ROOFTOP</option>
                    <option value="TORRE METALICA">TORRE METALICA</option>
                    <option value="SLS">SLS</option>
                  </Input>
                </div>
                <div className="col-sm-2">
                  DETENTORA
                  <Input type="text" value={null} disabled />
                </div>
                <div className="col-sm-2">
                  ID DETENTORA
                  <Input type="text" value={null} disabled />
                </div>
                <div className="col-sm-2">
                  FCU
                  <Input type="text" value={null} disabled />
                </div>
                <div className="col-sm-2">
                  RSO_RSA_SCI_STATUS
                  <Input type="text" value={null} disabled />
                </div>
                <div className="col-sm-6">
                  ATIVIDADE
                  <Input type="textarea" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-6">
                  COMENTÁRIOS
                  <Input type="textarea" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  OUTROS
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-4">
                  FORMA DE ACESSO
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-1">
                  DDD
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  MUNICÍPIO
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-3">
                  NOME VIVO
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>

                <div className="col-sm-6">
                  ENDEREÇO
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  LATITUDE
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  LONGITUDE
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  OBS
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>

                <div className="col-sm-4">
                  SOLICITAÇÃO
                  <Input type="text" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  DATA-SOLICITAÇÃO
                  <Input type="date" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  DATA-INICIAL
                  <Input type="date" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  DATA-FINAL
                  <Input type="date" onChange={(e) => e.target.value} value={null} />
                </div>
                <div className="col-sm-2">
                  STATUS
                  <Input
                    type="select"
                    name="statusacesso"
                    onChange={(e) => e.target.value}
                    value={null}
                  >
                    <option value="">Selecione</option>
                    <option value="AGUARDANDO">AGUARDANDO</option>
                    <option value="CANCELADO">CANCELADO</option>
                    <option value="CONCLUIDO">CONCLUIDO</option>
                    <option value="LIBERADO">LIBERADO</option>
                    <option value="PEDIR">PEDIR</option>
                    <option value="REJEITADO">REJEITADO</option>
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
                    disableSelectionOnClick
                    experimentalFeatures={{ newEditingApi: true }}
                    components={{
                      Pagination: CustomPagination,
                      LoadingOverlay: LinearProgress,
                      NoRowsOverlay: CustomNoRowsOverlay,
                    }}
                  />
                </Box>

                <div>
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
                </div>

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
                    sigla={regiona}
                    clientelocal="ERICSSON"
                    projetousual="ERICSSON"
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
                            e ? (setselectedoptioncolaboradorclt(e), setidcolaboradorclt(e.value)) : setselectedoptioncolaboradorclt(null)
                          }
                          value={selectedoptioncolaboradorclt}
                        />
                      </div>
                      <div className="col-sm-2">
                        Data Início
                        <Input type="date" onChange={(e) => setdatainicioclt(e.target.value)} value={datainicioclt} />
                      </div>
                      <div className="col-sm-2">
                        Data Final
                        <Input type="date" onChange={(e) => setdatafinalclt(e.target.value)} value={datafinalclt} />
                      </div>
                      <div className="col-sm-3">
                        Horas Normais
                        <Input type="number" onChange={(e) => sethoranormalclt(e.target.value)} value={horanormalclt} />
                      </div>
                      <div className="col-sm-3">
                        Horas 50%
                        <Input type="number" onChange={(e) => sethora50clt(e.target.value)} value={hora50clt} />
                      </div>
                      <div className="col-sm-3">
                        Horas 100%
                        <Input type="number" onChange={(e) => sethora100clt(e.target.value)} value={hora100clt} />
                      </div>
                      <div className="col-sm-3">
                        Total de Horas
                        <Input type="number" onChange={(e) => settotalhorasclt(e.target.value)} value={totalhorasclt} />
                      </div>
                      <div className="col-sm-12">
                        Observação
                        <Input type="textarea" onChange={(e) => setobservacaoclt(e.target.value)} value={observacaoclt} />
                      </div>
                    </div>
                    <br />
                    <div className=" col-sm-12 d-flex flex-row-reverse">
                      <Button color="primary" onClick={execacionamentoclt} disabled={modoVisualizador()}>
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
                        components={{ Pagination: CustomPagination, LoadingOverlay: LinearProgress, NoRowsOverlay: CustomNoRowsOverlay }}
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
                            e ? (setselectedoptioncolaboradorpj(e), setidcolaboradorpj(e.value)) : setselectedoptioncolaboradorpj(null)
                          }
                          value={selectedoptioncolaboradorpj}
                        />
                      </div>
                      <div className="col-sm-2">
                        Região
                        <Input type="select" name="regiao" onChange={(e) => setregiao(e.target.value)} value={regiao}>
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
                      <div className="col-sm-12">
                        Observação
                        <Input type="textarea" onChange={(e) => setobservacaopj(e.target.value)} value={observacaopj} />
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
                          components={{ Pagination: CustomPagination, LoadingOverlay: LinearProgress, NoRowsOverlay: CustomNoRowsOverlay }}
                        />
                      </Box>
                    </div>
                    <br />
                    <div className=" col-sm-12 d-flex flex-row-reverse">
                      <Button color="primary" onClick={execacionamentopj} disabled={modoVisualizador()}>
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
                        components={{ Pagination: CustomPagination, LoadingOverlay: LinearProgress, NoRowsOverlay: CustomNoRowsOverlay }}
                      />
                    </Box>
                    <div className="row g-3 mt-2">
                      <div className="col-sm-12">
                        E-mail PJ
                        <Input type="text" onChange={(e) => setcolaboradoremail(e.target.value)} value={colaboradoremail} />
                      </div>
                      <div className="col-sm-12">
                        E-mails adicionais
                        <Input type="text" onChange={(e) => setemailadcional(e.target.value)} value={emailadcional} />
                      </div>
                      <div className="col-sm-12">
                        Anexo
                        <div className="d-flex flex-row-reverse custom-file">
                          <InputGroup>
                            <Input type="file" onChange={(e) => setarquivoanexo(e.target.files[0])} className="custom-file-input" id="customFile3" />
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
                </div>
             
            </CardBody>
          </div>
        </CardBody>

        {/* === aqui continua o restante do formulário (Acesso, Financeiro, etc.) === */}
      </ModalBody>

      <ModalFooter>
        <Button
          color="success"
          onClick={() => {
            atualiza();
            setshow(false);
          }}
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

Rolloutericssonedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
  titulotopo: PropTypes.string.isRequired,
  atualiza: PropTypes.func.isRequired,
  ericssonSelecionado: PropTypes.object,
};

export default Rolloutericssonedicao;

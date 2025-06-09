import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { Modal, ModalHeader, ModalBody, Input, CardBody, Button, InputGroup, ModalFooter } from 'reactstrap';
import * as Icon from 'react-feather';
import { Box } from '@mui/material';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  GridActionsCellItem,
  useGridSelector,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Typography from '@mui/material/Typography';
import Select from 'react-select';
import DeleteIcon from '@mui/icons-material/Delete';
import { toast, ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import api from '../../../services/api';
import modoVisualizador from '../../../services/modovisualizador';
import Excluirregistro from '../../Excluirregistro';
import modofinanceiro from '../../../services/modofinanceiro';
import Solicitacaoedicao from '../suprimento/Solicitacaoedicao';
import Mensagemsimples from '../../Mensagemsimples';
import Solicitardiaria from '../projeto/Solicitardiaria';



const Rollouttelefonicaedicao = ({ setshow, show, titulotopo, ididentificador, pmuf, idr, idpmtslocal }) => {

  const [acompanhamentofinanceiro, setacompanhamentofinanceiro] = useState([]);
  const [pacotes, setpacotes] = useState([]);
  const [pacotesacionadospj, setpacotesacionadospj] = useState([]);
  const [atividades, setatividades] = useState([]);
  const [paginationModel, setPaginationModel] = useState({ pageSize: 10, page: 0 });
  const [paginationModelatividade, setPaginationModelatividade] = useState({
    pageSize: 5,
    page: 0,
  });
  const [paginationModelpacote, setPaginationModelpacote] = useState({
    pageSize: 5,
    page: 0,
  });
  const [paginationModelacionados, setPaginationModelacionados] = useState({
    pageSize: 5,
    page: 0,
  });
  const [paginationModeldiarias, setPaginationModeldiarias] = useState({
    pageSize: 5,
    page: 0,
  });
  const [paginationModelmaterialservico, setPaginationModelmaterialservico] = useState({
    pageSize: 5,
    page: 0,
  });
  const [loading, setloading] = useState(false);
  const [rowSelectionModel, setRowSelectionModel] = useState([]);
  const [colaboradorlistapj, setcolaboradorlistapj] = useState([]);
  const [rowSelectionModelpacotepj, setRowSelectionModelpacotepj] = useState([]);
  const [valornegociado, setvalornegociado] = useState('');
  const [idcolaboradorpj, setidcolaboradorpj] = useState('');
  const [colaboradoremail, setcolaboradoremail] = useState('');
  const [selectedoptioncolaboradorpj, setselectedoptioncolaboradorpj] = useState(null);
  const [selectedoptionlpu, setselectedoptionlpu] = useState(null);
  const [lpulista, setlpulista] = useState([]);
  const [lpuhistorico, setlpuhistorico] = useState('');
  const [regiao, setregiao] = useState('');
  const [emailadcional, setemailadcional] = useState(''); //('anna.christina@telequipeprojetos.com.br;ingrid.santos@telequipeprojetos.com.br;alex.costa@telequipeprojetos.com.br');
  const [arquivoanexo, setarquivoanexo] = useState('');
  const [retanexo, setretanexo] = useState('');
  const [materialeservico, setmaterialeservico] = useState([]);
  const [uididpmts, setuididpmts] = useState('');
  const [ufsigla, setufsigla] = useState('');
  const [uididcpomrf, setuididcpomrf] = useState('');
  const [pmouf, setpmouf] = useState('');
  const [pmoregional, setpmoregional] = useState('');
  const [pmosigla, setpmosigla] = useState('');
  const [rsorsadetentora, setrsorsadetentora] = useState('');
  const [rsorsaiddetentora, setrsorsaiddetentora] = useState('');
  const [rsorsasci, setrsorsasci] = useState('');
  const [rsorsascistatus, setrsorsascistatus] = useState('');
  const [acessoatividade, setacessoatividade] = useState('');
  const [acessocomentario, setacessocomentario] = useState('');
  const [acessooutros, setacessooutros] = useState('');
  const [acessoformaacesso, setacessoformaacesso] = useState('');
  const [mastersitecn, setmastersitecn] = useState('');
  const [ibgemunicipio, setibgemunicipio] = useState('');
  const [sciencenome, setsciencenome] = useState('');
  const [scienceendereco, setscienceendereco] = useState('');
  const [sciencelatitude, setsciencelatitude] = useState('');
  const [sciencelongitude, setsciencelongitude] = useState('');
  const [acessoobs, setacessoobs] = useState('');
  const [acessosolicitacao, setacessosolicitacao] = useState('');
  const [acessodatasolicitacao, setacessodatasolicitacao] = useState('');
  const [acessodatainicial, setacessodatainicial] = useState('');
  const [acessodatafinal, setacessodatafinal] = useState('');
  const [acessostatus, setacessostatus] = useState('');
  const [entregaplan, setentregaplan] = useState('');
  const [entregareal, setentregareal] = useState('');
  const [fiminstalacaoplan, setfiminstalacaoplan] = useState('');
  const [fiminstalacaoreal, setfiminstalacaoreal] = useState('');
  const [integracaoplan, setintegracaoplan] = useState('');
  const [integracaoreal, setintegracaoreal] = useState('');
  const [ativacao, setativacao] = useState('');
  const [documentacao, setdocumentacao] = useState('');
  const [dtplan, setdtplan] = useState('');
  const [dtreal, setdtreal] = useState('');
  const [statusobra, setstatusobra] = useState('');
  const [docaplan, setdocaplan] = useState('');
  const [ov, setov] = useState('');
  const [resumodafase, setresumodafase] = useState('');
  const [infravivo, setinfravivo] = useState('');
  const [rollout, setrollout] = useState('');
  const [acompanhamentofisicoobservacao, setacompanhamentofisicoobservacao] = useState('');
  const [telaexclusaopj, settelaexclusaopj] = useState(false);
  const [idacionamentopj, setidacionamentopj] = useState(0);
  const [idcolaboradorclt, setidcolaboradorclt] = useState('');
  const [selectedoptioncolaboradorclt, setselectedoptioncolaboradorclt] = useState(null);
  const [colaboradorlistaclt, setcolaboradorlistaclt] = useState([]);
  const [pacotesacionadosclt, setpacotesacionadosclt] = useState([]);
  const [datainicioclt, setdatainicioclt] = useState(null);
  const [datafinalclt, setdatafinalclt] = useState(null);
  const [totalhorasclt, settotalhorasclt] = useState(null);
  const [observacaoclt, setobservacaoclt] = useState(null);
  const [observacaopj, setobservacaopj] = useState('');
  const [horanormalclt, sethoranormalclt] = useState('');
  const [hora50clt, sethora50clt] = useState('');
  const [hora100clt, sethora100clt] = useState('');
  const [acionamentoatividade, setacionamentoatividade] = useState('');
  const [vistoriareal, setvistoriareal] = useState('');
  const [vistoriaplan, setvistoriaplan] = useState('');
  const [docplan, setdocplan] = useState('');
  const [docvitoriareal, setdocvitoriareal] = useState('');
  const [req, setreq] = useState('');
  const [infra, setinfra] = useState('');
  const [identificadorsolicitacao, setidentificadorsolicitacao] = useState('');
  const [identificadorsolicitacaodiaria, setidentificadorsolicitacaodiaria] = useState('');
  const [titulomaterial, settitulomaterial] = useState('');
  const [telacadastrosolicitacao, settelacadastrosolicitacao] = useState(false);
  const [mostra, setmostra] = useState('');
  const [motivo, setmotivo] = useState('');
  const [mensagemtela, setmensagemtela] = useState('');
  const [telacadastrosolicitacaodiaria, settelacadastrosolicitacaodiaria] = useState(false);
  const [titulodiaria, settitulodiaria] = useState('');
  const [solicitacaodiaria, setsolicitacaodiaria] = useState([]);

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idpmts: ididentificador,
    uf: pmuf,
    idrollout: idr,
    regiaolocal: regiao,
    osouobra: idpmtslocal,
    deletado: 0,
  };

  const togglecadastro = () => {
    setshow(!show);
  };

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado.</div>
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
        toast.error(`Erro: ${err.message}`);
      } else {
        toast.error('Erro: Tente novamente mais tarde!');
      }
    } finally {
      setloading(false);
    }
  };

  const listapacotes = async (ihistorico) => {
    try {
      setloading(true);
      await api.get(`v1/projetotelefonica/pacotes/${ihistorico}`, { params }).then((response) => {
        setpacotes(response.data);
      });
    } catch (err) {
      if (err.response) {
        toast.error(err.response.data.erro);
      } else {
        toast.error('Ocorreu um erro na requisição.');
      }
    } finally {
      setloading(false);
    }
  };

  const handleChangelpu = (stat) => {
    if (stat !== null) {
      setlpuhistorico(stat.label);
      setselectedoptionlpu({ value: stat.value, label: stat.label });
      listapacotes(stat.label);
    } else {
      setlpuhistorico('');
      setselectedoptionlpu({ value: null, label: null });
    }
  };

  const listaid = async () => {
    try {
      setloading(true);
      await api.get('v1/projetotelefonicaid', { params }).then((response) => {
        if (response.status === 200) {
          setuididpmts(response.data.uididpmts);
          setufsigla(response.data.ufsigla);
          setuididcpomrf(response.data.uididcpomrf);
          setpmouf(response.data.pmouf);
          setpmoregional(response.data.pmoregional);
          setpmosigla(response.data.pmosigla);
          setinfra(response.data.infra);
          setrsorsadetentora(response.data.rsorsadetentora);
          setrsorsaiddetentora(response.data.rsorsaiddetentora);
          setrsorsasci(response.data.rsorsasci);
          setrsorsascistatus(response.data.rsorsascistatus);
          setmastersitecn(response.data.ddd);
          setibgemunicipio(response.data.cidade);
          setsciencenome(response.data.sciencenome);
          setscienceendereco(response.data.scienceendereco);
          setsciencelatitude(response.data.sciencelatitude);
          setsciencelongitude(response.data.sciencelongitude);
          setacessoobs(response.data.acessoobs);
          setacessosolicitacao(response.data.acessosolicitacao);

          if (response.data.acessodatasolicitacao === '1899-12-30') {
            acessodatasolicitacao('');
          } else {
            setacessodatasolicitacao(response.data.acessodatasolicitacao);
          }

          if (response.data.acessodatainicial === '1899-12-30') {
            setacessodatainicial('');
          } else {
            setacessodatainicial(response.data.acessodatainicial);
          }
          if (response.data.acessodatafinal === '1899-12-30') {
            setacessodatafinal('');
          } else {
            setacessodatafinal(response.data.acessodatafinal);
          }
          setacessostatus(response.data.acessos);
          if (response.data.acessodatasolicitacao === '1899-12-30') {
            setacessodatasolicitacao('');
          } else {
            setacessodatasolicitacao(response.data.acessodatasolicitacao);
          }
          if (response.data.entregaplan === '1899-12-30') {
            setentregaplan('');
          } else {
            setentregaplan(response.data.entregaplan);
          }
          if (response.data.entregareal === '1899-12-30') {
            setentregareal('');
          } else {
            setentregareal(response.data.entregareal);
          }
          if (response.data.fiminstalacaoplan === '1899-12-30') {
            setfiminstalacaoplan('');
          } else {
            setfiminstalacaoplan(response.data.fiminstalacaoplan);
          }
          if (response.data.fiminstalacaoreal === '1899-12-30') {
            setfiminstalacaoreal('');
          } else {
            setfiminstalacaoreal(response.data.fiminstalacaoreal);
          }
          if (response.data.integracaoplan === '1899-12-30') {
            setintegracaoplan('');
          } else {
            setintegracaoplan(response.data.integracaoplan);
          }
          if (response.data.integracaoreal === '1899-12-30') {
            setintegracaoreal('');
          } else {
            setintegracaoreal(response.data.integracaoreal);
          }
          if (response.data.ativacao === '1899-12-30') {
            setativacao('');
          } else {
            setativacao(response.data.ativacao);
          }
          if (response.data.documentacao === '1899-12-30') {
            setdocumentacao('');
          } else {
            setdocumentacao(response.data.documentacao);
          }
          if (response.data.dtplan === '1899-12-30') {
            setdtplan('');
          } else {
            setdtplan(response.data.dtplan);
          }
          if (response.data.dtreal === '1899-12-30') {
            setdtreal('');
          } else {
            setdtreal(response.data.dtreal);
          }
          setstatusobra(response.data.statusobra);
          if (response.data.docaplan === '1899-12-30') {
            setdocaplan('');
          } else {
            setdocaplan(response.data.docaplan);
          }
          setov(response.data.ov);
          setresumodafase(response.data.resumodafase);
          setinfravivo(response.data.infravivo);
          setrollout(response.data.rollout);
          setacompanhamentofisicoobservacao(response.data.acompanhamentofisicoobservacao);
        } else {
          toast.error(`Erro: ${response.status}`);
        }
      });
    } catch (err) {
      if (err.response) {
        toast.error(err.response.data.erro);
      } else {
        toast.error('Ocorreu um erro na requisição.');
      }
    } finally {
      setloading(false);
    }
  }

  const listalpu = async () => {
    try {
      await api.get(`v1/projetotelefonica/listalpu`, { params }).then((response) => {
        setlpulista(response.data);
      });
    } catch (err) {
      console.log(err.message);
    } finally {
      console.log('');
      // setloading(false);
    }
  };

  const handleChangecolaboradorpj = (stat) => {
    if (stat !== null) {
      setidcolaboradorpj(stat.value);
      setselectedoptioncolaboradorpj({ value: stat.value, label: stat.label });
      setcolaboradoremail(stat.email.toLowerCase());
    } else {
      setidcolaboradorpj(0);
      setcolaboradoremail('');
      setselectedoptioncolaboradorpj({ value: null, label: null });
    }
  };

  const handleChangecolaboradorclt = (stat) => {
    if (stat !== null) {
      setidcolaboradorclt(stat.value);
      setselectedoptioncolaboradorclt({ value: stat.value, label: stat.label });
    } else {
      setidcolaboradorclt(0);
      setselectedoptioncolaboradorclt({ value: null, label: null });
    }
  };

  const handleChangeregiao = (stat) => {
    if (stat !== null) {
      listalpu(stat, pmouf);
      setregiao(stat);
    }
  };

  const handlechangetipo = (stat) => {
    if (stat !== null) {
      setacionamentoatividade(stat);
      if (stat === 'INSTALAÇÃO') {
        setdatainicioclt(entregareal);
        setdatafinalclt(fiminstalacaoreal);
      }
      if (stat === 'INTEGRAÇÃO') {
        setdatainicioclt(fiminstalacaoreal);
        setdatafinalclt(integracaoreal);
      }
      if (stat === 'VISTORIA') {
        setdatainicioclt(integracaoreal)
        setdatafinalclt(vistoriareal)
      }
    }
  };

  const listaacompanhamentofinanceiro = async () => {
    try {
      setloading(true);
      await api
        .get('v1/projetotelefonica/acompanhamentofinanceiro', { params })
        .then((response) => {
          if (response.status === 200) {
            setacompanhamentofinanceiro(response.data);
          } else {
            toast.error(`Erro: ${response.status}`);
          }
        });
    } catch (err) {
      if (err.response) {
        toast.error(err.response.data.erro);
      } else {
        toast.error('Ocorreu um erro na requisição.');
      }
    } finally {
      setloading(false);
    }
  };

  const colunasacompanhamentofinanceiro = [
    // { field: 'id', headerName: 'ID', width: 80, align: 'left', },
    /*  {
            field: 'rfp',
            headerName: 'RFP > Nome',
            width: 180,
            align: 'left',
            editable: false,
          }, */
    {
      field: 'po',
      headerName: 'PO',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 't2codmatservsw',
      headerName: 'T2 - COD MAT_SERV_SW',
      width: 300,
      align: 'left',
      editable: false,
    },
    {
      field: 't2descricaocod',
      headerName: 'T2 - DESCRIÇÃO COD',
      width: 400,
      align: 'left',
      editable: false,
    },
    {
      field: 'atividade',
      headerName: 'ATIVIDADE',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'codservico',
      headerName: 'CÓD SERV.',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'qtd',
      headerName: 'QTD',
      width: 80,
      align: 'left',
      editable: false,
    },

    ...(modofinanceiro()
      ? [
        {
          field: 'valor',
          headerName: 'VALOR R$',
          type: 'currency',
          width: 150,
          align: 'left',
          editable: false,
          valueFormatter: (parametros) => {
            if (parametros.value == null) return '';
            return parametros.value.toLocaleString('pt-BR', {
              style: 'currency',
              currency: 'BRL',
            });
          },
        },
        {
          field: 'valortotal',
          headerName: 'VALOR TOTAL',
          width: 150,
          align: 'left',
          editable: false,
          valueFormatter: (parametros) => {
            if (parametros.value == null) return '';
            return parametros.value.toLocaleString('pt-BR', {
              style: 'currency',
              currency: 'BRL',
            });
          },
        },
      ]
      : []),
    {
      field: 'statust2',
      headerName: 'STATUS T2',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'data',
      headerName: 'DATA T2',
      width: 150,
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
      field: 'reqaprovt2',
      headerName: 'REQ. APROV T2',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'pepnivel3',
      headerName: 'PEP NÍVEL 3',
      width: 250,
      align: 'left',
      editable: false,
    },
    {
      field: 'statust4',
      headerName: 'STATUS T4',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'datat4',
      headerName: 'DATA T4',
      width: 150,
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
      field: 'cartataf',
      headerName: 'CARTA TAF',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'dataenvio',
      headerName: 'DATA ENVIO',
      width: 150,
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
      field: 'autcpomgestor',
      headerName: 'AUT. CPOM GESTOR',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'statusfinan',
      headerName: 'STATUS FINANEIRO',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'nf',
      headerName: 'NOTA FISCAL',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'pagto',
      headerName: 'PAGTO',
      width: 300,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'obs',
      headerName: 'OBS',
      width: 500,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
  ];

  const listaatividades = async () => {
    try {
      setloading(true);
      await api
        .get('v1/projetotelefonica/acompanhamentofinanceiro', { params })
        .then((response) => {
          if (response.status === 200) {
            setatividades(response.data);
            console.log(response.data);
          } else {
            toast.error(`Erro: ${response.status}`);
          }
        });
    } catch (err) {
      if (err.response) {
        toast.error(err.response.data.erro);
      } else {
        toast.error('Ocorreu um erro na requisição.');
      }
    } finally {
      setloading(false);
    }
  };

  const colunasatividades = [
    {
      field: 'po',
      headerName: 'PO',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 't2codmatservsw',
      headerName: 'T2 - COD MAT_SERV_SW',
      width: 300,
      align: 'left',
      editable: false,
    },
    {
      field: 't2descricaocod',
      headerName: 'T2 - DESCRIÇÃO COD',
      width: 400,
      align: 'left',
      editable: false,
    },
    {
      field: 'atividade',
      headerName: 'ATIVIDADE',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'codservico',
      headerName: 'CÓD SERV.',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'qtd',
      headerName: 'QTD',
      width: 80,
      align: 'left',
      editable: false,
    },
  ];

  const listacolaboradorpj = async () => {
    try {
      setloading(true);
      await api.get('v1/empresas/selectpj', { params }).then((response) => {
        setcolaboradorlistapj(response.data);
      });
    } catch (err) {
      if (err.response) {
        toast.error(err.response.data.erro);
      } else {
        toast.error('Ocorreu um erro na requisição.');
      }
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
      if (err.response) {
        toast.error(err.response.data.erro);
      } else {
        toast.error('Ocorreu um erro na requisição.');
      }
    } finally {
      setloading(false);
    }
  };

  const colunaspacotes = [
    {
      field: 'ts',
      headerName: 'TS',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'brevedescricaoingles',
      headerName: 'BREVE DESCRIÇÃO EM INGLÊS',
      width: 300,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'brevedescricao',
      headerName: 'BREVE DESCRICAO',
      width: 400,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'codigolpuvivo',
      headerName: 'CODIGO LPU VIVO',
      width: 150,
      align: 'left',
      editable: false,
    },
  ];

  const listapacotesacionados = async () => {
    try {
      setloading(true);
      await api.get('v1/projetotelefonica/listaacionamentopj', { params }).then((response) => {
        setpacotesacionadospj(response.data);
      });
    } catch (err) {
      if (err.response) {
        toast.error(err.response.data.erro);
      } else {
        toast.error('Ocorreu um erro na requisição.');
      }
    } finally {
      setloading(false);
    }
  };

  const listapacotesacionadosclt = async () => {
    try {
      setloading(true);
      await api.get('v1/projetotelefonica/listaacionamentoclt', { params }).then((response) => {
        setpacotesacionadosclt(response.data);
      });
    } catch (err) {
      if (err.response) {
        toast.error(err.response.data.erro);
      } else {
        toast.error('Ocorreu um erro na requisição.');
      }
    } finally {
      setloading(false);
    }
  };

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
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<DeleteIcon />}
          disabled={modoVisualizador()}
          label="Delete"
          onClick={() => deleteUser(parametros.id)}
        />,
      ],
    },
    {
      field: 'nome',
      headerName: 'COLABORADOR',
      width: 250,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'po',
      headerName: 'PO',
      width: 120,
      align: 'left',
      editable: false,
    },
    {
      field: 'atividade',
      headerName: 'ATIVIDADE',
      width: 110,
      align: 'left',
      editable: false,
    },
    {
      field: 'qtd',
      headerName: 'QTD',
      width: 60,
      align: 'left',
      editable: false,
    },
    {
      field: 'ts',
      headerName: 'TS',
      width: 120,
      align: 'left',
      editable: false,
    },
    {
      field: 'brevedescricao',
      headerName: 'BREVE DESCRICAO',
      width: 290,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'codigolpuvivo',
      headerName: 'CODIGO LPU VIVO',
      width: 140,
      align: 'left',
      editable: false,
    },
    {
      field: 'dataacionamento',
      headerName: 'DATA ACIONAMENTO',
      width: 150,
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
      field: 'dataenvioemail',
      headerName: 'DATA ENVIO EMAIL',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
  ];

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
          disabled={modoVisualizador()}
          label="Delete"
          onClick={() => deleteUser(parametros.id)}
        />,
      ],
    },
    {
      field: 'nome',
      headerName: 'COLABORADOR',
      width: 250,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'po',
      headerName: 'PO',
      width: 120,
      align: 'left',
      editable: false,
    },
    {
      field: 'atividade',
      headerName: 'ATIVIDADE',
      width: 110,
      align: 'left',
      editable: false,
    },
    {
      field: 't2codmatservsw',
      headerName: 'DESCRICAO',
      width: 290,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'dataincio',
      headerName: 'DATA INICIO',
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
      field: 'datafinal',
      headerName: 'DATA FIM',
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
      field: 'dataacionamento',
      headerName: 'DATA ACIONAMENTO',
      width: 150,
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
      field: 'dataenvioemail',
      headerName: 'DATA ENVIO EMAIL',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (parametros) => (parametros.value ? new Date(parametros.value) : null),
      valueFormatter: (parametros) =>
        parametros.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(parametros.value)
          : '',
      editable: false,
    },
  ];


  const colunasmaterialeservico = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: () => [
        <GridActionsCellItem icon={<DeleteIcon />} label="Delete" title="Delete" />,
      ],
    },
    { field: 'id', headerName: 'ID', width: 60, align: 'center' },
    {
      field: 'data',
      headerName: 'Data',
      width: 100,
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
      headerName: 'Solicitante',
      type: 'string',
      width: 400,
      align: 'left',
      editable: false,
    },

    {
      field: 'status',
      headerName: 'Status',
      type: 'string',
      width: 250,
      align: 'left',
      editable: false,
    },
  ];


  const salvarpj = async (pacoteid, atividadeid) => {
    api
      .post('v1/projetotelefonica/acionamentopj', {
        idrollout: idr,
        idatividade: atividadeid,
        idpacote: pacoteid,
        idcolaborador: idcolaboradorpj,
        idpmts: uididpmts,
        lpuhistorico,
        observacaopj,
        idfuncionario: localStorage.getItem('sessionId'),
      })
      .then((response) => {
        if (response.status !== 201) {
          toast.error(response.status);
        } else {
          listapacotesacionados();
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

  const salvarclt = async (atividadeid) => {
    api
      .post('v1/projetotelefonica/acionamentoclt', {
        idrollout: idr,
        idatividade: atividadeid,
        idcolaborador: idcolaboradorclt,
        idpmts: uididpmts,
        atividade: acionamentoatividade,
        datainicioclt,
        datafinalclt,
        totalhorasclt,
        observacaoclt,
        horanormalclt,
        hora50clt,
        hora100clt,
        idfuncionario: localStorage.getItem('sessionId'),
      })
      .then((response) => {
        if (response.status !== 201) {
          toast.error(response.status);
        } else {
          setdatainicioclt('');
          setdatafinalclt('');
          settotalhorasclt('0');
          setobservacaoclt('0');
          sethoranormalclt('0');
          sethora50clt('0');
          sethora100clt('0');
          listapacotesacionadosclt();

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

  function ProcessaCadastro(e) {
    e.preventDefault();
    api
      .post('v1/projetotelefonica', {
        infra,
        acessoatividade,
        acessocomentario,
        acessooutros,
        acessoformaacesso,
        ddd: mastersitecn,
        cidade: ibgemunicipio,
        nomedosite: sciencenome,
        endereco: scienceendereco,
        latitude: sciencelatitude,
        longitude: sciencelongitude,
        acessoobs,
        acessodatainicial,
        acessodatafinal,
        acessodatasolicitacao,
        acessosolicitacao,
        entregaplan,
        entregareal,
        fiminstalacaoplan,
        fiminstalacaoreal,
        integracaoplan,
        integracaoreal,
        ativacao,
        documentacao,
        dtplan,
        dtreal,
        statusobra,
        docaplan,
        ov,
        uididcpomrf
      })
      .then((response) => {
        if (response.status === 201) {
          toast.success('Registro Salvo com sucesso!');
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
  }

  const execacionamentopj = async () => {
    try {
      if (rowSelectionModel.length > 1) {
        toast.error('Selecione apenas um item na lista de Atividade');
        return;
      }
      if (!rowSelectionModelpacotepj || rowSelectionModelpacotepj.length === 0) {
        toast.error('Selecione um ou mais itens na lista de pacotes');
        return;
      }

      let sucesso = false; // Flag para verificar se algum salvamento foi bem-sucedido

      await Promise.all(
        rowSelectionModelpacotepj.map(async (poite) => {
          try {
            const resultado = await salvarpj(poite, rowSelectionModel[0]);
            if (resultado) sucesso = true; // Define como sucesso se pelo menos um item for salvo
          } catch (erro) {
            console.error(`Erro ao salvar pacote ${poite}:`, erro);
          }
        })
      );

      if (sucesso) {
        toast.success('Acionamentos salvos com sucesso!');
      } else {
        toast.error('Erro ao salvar acionamentos.');
      }
    } catch (error) {
      toast.error(`Erro ao salvar itens: ${error.message || error}`);
      console.error(error);
    }
  };

  const execacionamentoclt = async () => {
    try {
      if ((datainicioclt === null) || (datafinalclt === null)) {
        toast.error('Não é possível salvar sem data de início ou fim do CLT');
        return;
      }
      if (!rowSelectionModel || rowSelectionModel.length === 0) {
        toast.error('Selecione um item na lista de Atividade');
        return; // Sai da função
      }


      if (!rowSelectionModel || rowSelectionModel.length === 0) {
        toast.error('Selecione um item na lista de Atividade');
        return; // Sai da função
      }
      if (rowSelectionModel.length > 1) {
        toast.error('Selecione apenas um item na lista de Atividade');
        return;
      }
      try {
        const sucesso = await salvarclt(rowSelectionModel[0]); // Aguarda a Promise

        if (sucesso) {
          listapacotesacionadosclt(); // Atualiza a lista após o sucesso
          toast.success('Acionamento salvo com sucesso!');
        } else {
          toast.error('Erro ao salvar acionamento.');
        }
      } catch (erro) {
        toast.error('Ocorreu um erro ao salvar.');
        console.error(erro);
      }
    } catch (error) {
      toast.error(`Erro ao salvar itens: ${error.message || error}`);
    }
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
          settitulomaterial('Cadastrar Solicitação de Produto');
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

  const listasolicitacao = async () => {
    try {
      setloading(true);
      await api.get('v1/solicitacaoid', { params }).then((response) => {
        setmaterialeservico(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    }
  };

  const enviaremail = () => {
    if (colaboradoremail == null || colaboradoremail === '' || colaboradoremail === undefined) {
      toast.error('Falta preencher o E-mail!');
      setmostra(true);
      setmotivo(2);
      return;
    }

    if (idcolaboradorpj.length === 0) {
      setmostra(true);
      setmotivo(2);
      setmensagemtela('Falta Selecionar o Colaborador!');
    } else {
      api
        .post('v1/email/acionamentopjtelefonica', {
          destinatario: emailadcional,
          destinatario1: colaboradoremail,
          uididpmts,
          assunto: 'ACIONAMENTO TELEFONICA',
          idusuario: localStorage.getItem('sessionId'),
        })
        .then((response) => {
          if (response.status === 200) {
            setmostra(true);
            setmotivo(1);
            setmensagemtela('Email Enviando com Sucesso!');
          } else {
            setmostra(true);
            setmotivo(2);
            setmensagemtela('Erro ao enviar a mensagem!');
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


  //tabela de dados de despesa diarias
  const colunasdiarias = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: () => [
        <GridActionsCellItem
          icon={<DeleteIcon />}
          label="Delete"
          title="Delete"
          onClick={() => null}
        />,
      ],
    },
    // { field: 'id', headerName: 'ID', width: 60, align: 'center' },
    {
      field: 'datasolicitacao',
      headerName: 'Data',
      width: 80,
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
      field: 'horasolicitacao',
      headerName: 'Hora',
      type: 'string',
      width: 80,
      align: 'left',
      editable: false,
    },
    {
      field: 'nomecolaborador',
      headerName: 'Nome',
      type: 'string',
      width: 250,
      align: 'right',
      editable: false,
    },
    {
      field: 'siteid',
      headerName: 'Identificação',
      type: 'string',
      width: 100,
      align: 'center',
      editable: false,
    },
    {
      field: 'descricao',
      headerName: 'Descrição',
      type: 'string',
      width: 300,
      align: 'center',
      editable: false,
    },
    {
      field: 'diarias',
      headerName: 'Diarias',
      type: 'string',
      width: 100,
      align: 'center',
      editable: false,
    },
    {
      field: 'valortotal',
      headerName: 'Valor Total',
      type: 'string',
      width: 100,
      align: 'center',
      editable: false,
    },
    {
      field: 'solicitante',
      headerName: 'Solicitante',
      type: 'string',
      width: 150,
      align: 'center',
      editable: false,
    },
  ];

  const listasolicitacaodiaria = async () => {
    try {
      setloading(true);
      await api.get('v1/solicitacaoid', { params }).then((response) => {
        setsolicitacaodiaria(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    }
  };

  const iniciatabelas = () => {
    listaid();
    listaacompanhamentofinanceiro();
    listaatividades();
    listacolaboradorpj();
    listacolaboradorclt();
    listapacotesacionados();
    listapacotesacionadosclt();
    listasolicitacao();
  };

  useEffect(() => {
    iniciatabelas();
    if (1 === 0) {
      console.log(colaboradoremail);
      console.log(retanexo);
    }
  }, []);

  return (
    <>
      <Modal
        isOpen={show}
        toggle={togglecadastro.bind(null)}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-fullscreen modal-dialog-scrollable modal-fullscreen "
      >
        <ModalHeader toggle={togglecadastro.bind(null)} style={{ backgroundColor: 'white' }}>
          {titulotopo}
        </ModalHeader>
        <ModalBody style={{ backgroundColor: 'white' }}>
          <div>
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

            {telaexclusaopj ? (
              <>
                <Excluirregistro
                  show={telaexclusaopj}
                  setshow={settelaexclusaopj}
                  ididentificador={idacionamentopj}
                  quemchamou="ATIVIDADEPJTELEFONICA"
                  atualiza={listapacotesacionados}
                />{' '}
              </>
            ) : null}

            {telacadastrosolicitacao ? (
              <Solicitacaoedicao
                show={telacadastrosolicitacao}
                setshow={settelacadastrosolicitacao}
                ididentificador={identificadorsolicitacao}
                atualiza={listasolicitacao}
                titulotopo={titulomaterial}
                //ver o que é isso aqui:
                novo="0"
                projetousual="TELEFONICA"
                numero={uididpmts}
              />
            ) : null}

            {mostra ? (
              <>
                {' '}
                <Mensagemsimples
                  show={mostra}
                  setshow={setmostra}
                  mensagem={mensagemtela}
                  motivo={motivo}
                  titulo="Enviar E-mail de Acionamento"
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
                //ver o que é isso aqui:
                novo="0"
                numero={uididpmts}
              />
            ) : null}

            <b>Identificação</b>
            <hr style={{ marginTop: '0px', width: '100%' }} />
            <CardBody className="px-4 , pb-2">
              <div className="row g-3">
                <div className="col-sm-2">
                  UID_IDPMTS
                  <Input
                    type="text"
                    value={uididpmts}
                    disabled
                  />
                </div>
                <div className="col-sm-2">
                  UF/SIGLA
                  <Input
                    type="text"
                    value={ufsigla}
                    disabled
                  />
                </div>
                <div className="col-sm-2">
                  UID_IDCPOMRF
                  <Input
                    type="text"
                    value={uididcpomrf}
                    disabled
                  />
                </div>
                <div className="col-sm-2">
                  PMO_UF
                  <Input
                    type="text"
                    value={pmouf}
                    disabled
                  />
                </div>
                <div className="col-sm-2">
                  PMO_REGIONAL
                  <Input
                    type="text"
                    value={pmoregional}
                    disabled
                  />
                </div>
              </div>
            </CardBody>
          </div>
          <div>
            <b>Acesso</b>
            <hr style={{ marginTop: '0px', width: '100%' }} />
            <CardBody className="px-4 , pb-2">
              <div className="row g-3">
                <div className="col-sm-2">
                  ID_VIVO
                  <Input
                    type="text"
                    value={pmosigla}
                    disabled
                  />
                </div>
                <div className="col-sm-2">
                  INFRA
                  <Input
                    type="select"
                    name="infra"
                    onChange={(e) => setinfra(e.target.value)}
                    value={infra}
                  >
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
                  <Input
                    type="text"
                    value={rsorsadetentora}
                    disabled
                  />
                </div>
                <div className="col-sm-2">
                  ID DETENTORA
                  <Input
                    type="text"
                    value={rsorsaiddetentora}
                    disabled
                  />
                </div>
                <div className="col-sm-2">
                  FCU
                  <Input
                    type="text"
                    value={rsorsasci}
                    disabled
                  />
                </div>
                <div className="col-sm-2">
                  RSO_RSA_SCI_STATUS
                  <Input
                    type="text"
                    value={rsorsascistatus}
                    disabled
                  />
                </div>
                <div className="col-sm-6">
                  ATIVIDADE
                  <Input
                    type="textarea"
                    onChange={(e) => setacessoatividade(e.target.value)}
                    value={acessoatividade}
                  />
                </div>
                <div className="col-sm-6">
                  COMENTÁRIOS
                  <Input
                    type="textarea"
                    onChange={(e) => setacessocomentario(e.target.value)}
                    value={acessocomentario}
                  />
                </div>
                <div className="col-sm-2">
                  OUTROS
                  <Input
                    type="text"
                    onChange={(e) => setacessooutros(e.target.value)}
                    value={acessooutros}
                  />
                </div>
                <div className="col-sm-4">
                  FORMA DE ACESSO
                  <Input
                    type="text"
                    onChange={(e) => setacessoformaacesso(e.target.value)}
                    value={acessoformaacesso}
                  />
                </div>
                <div className="col-sm-1">
                  DDD
                  <Input
                    type="text"
                    onChange={(e) => setmastersitecn(e.target.value)}
                    value={mastersitecn}
                  />
                </div>
                <div className="col-sm-2">
                  MUNICÍPIO
                  <Input
                    type="text"
                    onChange={(e) => setibgemunicipio(e.target.value)}
                    value={ibgemunicipio}
                  />
                </div>
                <div className="col-sm-3">
                  NOME VIVO
                  <Input
                    type="text"
                    onChange={(e) => setsciencenome(e.target.value)}
                    value={sciencenome}
                  />
                </div>

                <div className="col-sm-6">
                  ENDEREÇO
                  <Input
                    type="text"
                    onChange={(e) => setscienceendereco(e.target.value)}
                    value={scienceendereco}

                  />
                </div>
                <div className="col-sm-2">
                  LATITUDE
                  <Input
                    type="text"
                    onChange={(e) => setsciencelatitude(e.target.value)}
                    value={sciencelatitude}
                  />
                </div>
                <div className="col-sm-2">
                  LONGITUDE
                  <Input
                    type="text"
                    onChange={(e) => setsciencelongitude(e.target.value)}
                    value={sciencelongitude}
                  />
                </div>
                <div className="col-sm-2">
                  OBS
                  <Input
                    type="text"
                    onChange={(e) => setacessoobs(e.target.value)}
                    value={acessoobs}
                  />
                </div>

                <div className="col-sm-4">
                  SOLICITAÇÃO
                  <Input
                    type="text"
                    onChange={(e) => setacessosolicitacao(e.target.value)}
                    value={acessosolicitacao}
                  />
                </div>
                <div className="col-sm-2">
                  DATA-SOLICITAÇÃO
                  <Input
                    type="date"
                    onChange={(e) => setacessodatasolicitacao(e.target.value)}
                    value={acessodatasolicitacao}
                  />
                </div>
                <div className="col-sm-2">
                  DATA-INICIAL
                  <Input
                    type="date"
                    onChange={(e) => setacessodatainicial(e.target.value)}
                    value={acessodatainicial}
                  />
                </div>
                <div className="col-sm-2">
                  DATA-FINAL
                  <Input
                    type="date"
                    onChange={(e) => setacessodatafinal(e.target.value)}
                    value={acessodatafinal}
                  />
                </div>
                <div className="col-sm-2">
                  STATUS
                  <Input
                    type="select"
                    name="statusacesso"
                    onChange={(e) => setacessostatus(e.target.value)}
                    value={acessostatus}
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

          <div>
            <b>Acompanhamento Financeiro</b>
            <hr style={{ marginTop: '0px', width: '100%' }} />
            <CardBody className="px-4 , pb-2">
              <div className="row g-3">
                <Box
                  sx={{ height: acompanhamentofinanceiro.length > 0 ? '100%' : 500, width: '100%' }}
                >
                  <DataGrid
                    rows={acompanhamentofinanceiro}
                    columns={colunasacompanhamentofinanceiro}
                    loading={loading}
                    disableSelectionOnClick
                    experimentalFeatures={{ newEditingApi: true }}
                    components={{
                      Pagination: CustomPagination,
                      LoadingOverlay: LinearProgress,
                      NoRowsOverlay: CustomNoRowsOverlay,
                    }}
                    localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                    // Usa estado para controlar a paginação dinamicamente
                    paginationModel={paginationModel}
                    onPaginationModelChange={setPaginationModel}
                  />
                </Box>
              </div>
            </CardBody>
          </div>
          <div>
            <b>Acompanhamento Fisico</b>
            <hr style={{ marginTop: '0px', width: '100%' }} />
            <CardBody className="px-4 , pb-2">
              <div className="row g-3">
                <div className="col-sm-2">
                  Vistoria Plan
                  <Input type="date"
                    onChange={(e) => setvistoriaplan(e.target.value)}
                    value={vistoriaplan}
                  />
                </div>
                <div className="col-sm-2">
                  Vistoria Real
                  <Input
                    type="date"
                    onChange={(e) => setvistoriareal(e.target.value)}
                    value={vistoriareal}
                  />
                </div>
                <div className="col-sm-2">
                  Doc Plan
                  <Input
                    type="date"
                    onChange={(e) => setdocplan(e.target.value)}
                    value={docplan}
                  />
                </div>
                <div className="col-sm-2">
                  Documentação Vistoria Real
                  <Input
                    type="date"
                    onChange={(e) => setdocvitoriareal(e.target.value)}
                    value={docvitoriareal}
                  />
                </div>
                <div className="col-sm-2">
                  REQ
                  <Input
                    type="date"
                    onChange={(e) => setreq(e.target.value)}
                    value={req}
                  />
                </div>
              </div>
              <br />

              <div className="row g-3">
                <div className="col-sm-2">
                  Doca Plan
                  <Input
                    type="date"
                    onChange={(e) => setdocaplan(e.target.value)}
                    value={docaplan}
                  />
                </div>
                <div className="col-sm-2">
                  OV
                  <Input
                    type="text"
                    onChange={(e) => setov(e.target.value)}
                    value={ov}
                  />
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-2">
                  Entrega Plan
                  <Input
                    type="date"
                    onChange={(e) => setentregaplan(e.target.value)}
                    value={entregaplan}
                  />
                </div>
                <div className="col-sm-2">
                  Entrega Real
                  <Input
                    type="date"
                    onChange={(e) => setentregareal(e.target.value)}
                    value={entregareal}
                  />
                </div>
                <div className="col-sm-2">
                  Fim Instalação Plan
                  <Input
                    type="date"
                    onChange={(e) => setfiminstalacaoplan(e.target.value)}
                    value={fiminstalacaoplan}
                  />
                </div>
                <div className="col-sm-2">
                  Fim Instalação Real
                  <Input
                    type="date"
                    onChange={(e) => setfiminstalacaoreal(e.target.value)}
                    value={fiminstalacaoreal}
                  />
                </div>
                <div className="col-sm-2">
                  Integração Plan
                  <Input
                    type="date"
                    onChange={(e) => setintegracaoplan(e.target.value)}
                    value={integracaoplan}
                  />
                </div>
                <div className="col-sm-2">
                  Integração Real
                  <Input
                    type="date"
                    onChange={(e) => setintegracaoreal(e.target.value)}
                    value={integracaoreal}
                  />
                </div>
                <div className="col-sm-2">
                  Ativação
                  <Input
                    type="date"
                    onChange={(e) => setativacao(e.target.value)}
                    value={ativacao}
                  />
                </div>
                <div className="col-sm-2">
                  Documentação Instalação
                  <Input
                    type="date"
                    onChange={(e) => setdocumentacao(e.target.value)}
                    value={documentacao}
                  />
                </div>
                <div className="col-sm-2">
                  DT Plan
                  <Input
                    type="date"
                    onChange={(e) => setdtplan(e.target.value)}
                    value={dtplan}
                  />
                </div>
                <div className="col-sm-2">
                  DT Real
                  <Input
                    type="date"
                    onChange={(e) => setdtreal(e.target.value)}
                    value={dtreal}
                  />
                </div>
                <div className="col-sm-2">
                  Status Obra
                  <Input
                    type="select"
                    name="statusacesso"
                    onChange={(e) => setstatusobra(e.target.value)}
                    value={statusobra}
                  >
                    <option value="">Selecione</option>
                    <option value="AGENDAR">AGENDAR</option>
                    <option value="ATIVAÇÃO">ATIVAÇÃO</option>
                    <option value="CANCELADO">CANCELADO</option>
                    <option value="CONCLUIDO">CONCLUIDO</option>
                    <option value="DT">DT</option>
                    <option value="ENTREGA">ENTREGA</option>
                    <option value="INSTALAÇÃO">INSTALAÇÃO</option>
                    <option value="INTEGRAÇÃO">INTEGRAÇÃO</option>
                    <option value="PLANEJAMENTO">PLANEJAMENTO</option>
                    <option value="PROG. INTEGRAÇÃO">PROG. INTEGRAÇÃO</option>
                  </Input>
                </div>

                <div className="col-sm-6">
                  Resumo da Fase
                  <Input
                    type="textarea"
                    onChange={(e) => setresumodafase(e.target.value)}
                    value={resumodafase}
                  />
                </div>
                <div className="col-sm-6">
                  Infra Vivo
                  <Input
                    type="textarea"
                    onChange={(e) => setinfravivo(e.target.value)}
                    value={infravivo}
                  />
                </div>

                <div className="col-sm-12">
                  Rollout
                  <Input
                    type="textarea"
                    onChange={(e) => setrollout(e.target.value)}
                    value={rollout}
                  />
                </div>
                <div className="col-sm-12">
                  Observação
                  <Input
                    type="textarea"
                    onChange={(e) => setacompanhamentofisicoobservacao(e.target.value)}
                    value={acompanhamentofisicoobservacao}
                  />
                </div>
              </div>
            </CardBody>
          </div>

          <div>
            <b>Acionamento</b>
            <hr style={{ marginTop: '0px', width: '100%' }} />
            <CardBody className="px-4 , pb-2">
              <div className="row g-3">
                <Box sx={{ height: atividades.length > 0 ? '100%' : 400, width: '100%' }}>
                  Atividades
                  <hr style={{ marginTop: '0px', width: '100%' }} />
                  <DataGrid
                    rows={atividades}
                    columns={colunasatividades}
                    loading={loading}
                    disableSelectionOnClick
                    checkboxSelection
                    onRowSelectionModelChange={(newRowSelectionModel) => {
                      setRowSelectionModel(newRowSelectionModel);
                    }}
                    rowSelectionModel={rowSelectionModel}
                    experimentalFeatures={{ newEditingApi: true }}
                    components={{
                      Pagination: CustomPagination,
                      LoadingOverlay: LinearProgress,
                      NoRowsOverlay: CustomNoRowsOverlay,
                    }}
                    localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                    // Usa estado para controlar a paginação dinamicamente
                    paginationModel={paginationModelatividade}
                    onPaginationModelChange={setPaginationModelatividade}
                  />
                </Box>
              </div>
              <br />
              <br />
              Dados do Colaborador CLT
              <hr style={{ marginTop: '0px', width: '100%' }} />
              <div className="row g-3">
                <div className="col-sm-4">
                  Funcionario
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
                  STATUS
                  <Input
                    type="select"
                    name="atividade"
                    onChange={(e) => handlechangetipo(e.target.value)}
                    value={acionamentoatividade}
                  >
                    <option value="">Selecione</option>
                    <option value="INSTALAÇÃO">INSTALAÇÃO</option>
                    <option value="INTEGRAÇÃO">INTEGRAÇÃO</option>
                    <option value="VISTORIA">VISTORIA</option>
                  </Input>
                </div>

                <div className="col-sm-2">
                  Data Inicio
                  <Input
                    type="date"
                    onChange={(e) => setdatainicioclt(e.target.value)}
                    value={datainicioclt}
                    placeholder=""
                    disabled
                  />
                </div>
                <div className="col-sm-2">
                  Data Final
                  <Input
                    type="date"
                    onChange={(e) => setdatafinalclt(e.target.value)}
                    value={datafinalclt}
                    placeholder=""
                    disabled
                  />
                </div>
                <div className="col-sm-3">
                  Horas Normais
                  <Input
                    type="number"
                    onChange={(e) => sethoranormalclt(e.target.value)}
                    value={horanormalclt}
                    placeholder=""
                  />
                </div>
                <div className="col-sm-3">
                  Horas 50%
                  <Input
                    type="number"
                    onChange={(e) => sethora50clt(e.target.value)}
                    value={hora50clt}
                    placeholder=""
                  />
                </div>
                <div className="col-sm-3">
                  Horas 100%
                  <Input
                    type="number"
                    onChange={(e) => sethora100clt(e.target.value)}
                    value={hora100clt}
                    placeholder=""
                  />
                </div>
                <div className="col-sm-3">
                  Total de Horas
                  <Input
                    type="number"
                    onChange={(e) => settotalhorasclt(e.target.value)}
                    value={totalhorasclt}
                    placeholder=""
                  />
                </div>

                <div className="col-sm-12">
                  Observação
                  <Input
                    type="textarea"
                    onChange={(e) => setobservacaoclt(e.target.value)}
                    value={observacaoclt}
                    placeholder=""
                  />
                </div>
              </div>
              <br />
              <div className=" col-sm-12 d-flex flex-row-reverse">
                <Button color="primary" onClick={execacionamentoclt} disabled={modoVisualizador()}>
                  Adicionar Acionamento CLT <Icon.Plus />
                </Button>
              </div>
              Pacotes Acionados CLT
              <hr style={{ marginTop: '0px', width: '100%' }} />
              <div className="row g-3">
                <Box sx={{ height: pacotes.length > 0 ? '100%' : 400, width: '100%' }}>
                  <DataGrid
                    rows={pacotesacionadosclt}
                    columns={colunaspacotesacionadosclt}
                    loading={loading}
                    disableSelectionOnClick
                    experimentalFeatures={{ newEditingApi: true }}
                    components={{
                      Pagination: CustomPagination,
                      LoadingOverlay: LinearProgress,
                      NoRowsOverlay: CustomNoRowsOverlay,
                    }}
                    localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                    // Usa estado para controlar a paginação dinamicamente
                    paginationModel={paginationModelacionados}
                    onPaginationModelChange={setPaginationModelacionados}
                  />
                </Box>
                <br></br>
              </div>


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
                <div className="col-sm-2">
                  Região
                  <Input
                    type="select"
                    name="regiao"
                    onChange={(e) => handleChangeregiao(e.target.value)}
                    value={regiao}
                  >
                    <option value="Selecione">Selecione</option>
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
                    onChange={handleChangelpu}
                    value={selectedoptionlpu}
                  />
                </div>

                {lpuhistorico === 'NEGOCIADO' && (
                  <>
                    <div className="col-sm-2">
                      Valor Negociado
                      <Input
                        type="currency"
                        onChange={(e) => setvalornegociado(e.target.value)}
                        value={valornegociado}
                        placeholder=""
                      />
                    </div>
                  </>
                )}

                <div className="col-sm-12">
                  Observação
                  <Input
                    type="textarea"
                    onChange={(e) => setobservacaopj(e.target.value)}
                    value={observacaopj}
                    placeholder=""
                  />
                </div>
              </div>
              <br />
              Pacotes
              <hr style={{ marginTop: '0px', width: '100%' }} />
              <div className="row g-3">
                <Box sx={{ height: pacotes.length > 0 ? '100%' : 400, width: '100%' }}>
                  <DataGrid
                    rows={pacotes}
                    columns={colunaspacotes}
                    loading={loading}
                    disableSelectionOnClick
                    checkboxSelection
                    onRowSelectionModelChange={(newRowSelectionModelpacotepj) => {
                      setRowSelectionModelpacotepj(newRowSelectionModelpacotepj);
                    }}
                    rowSelectionModel={rowSelectionModelpacotepj}
                    experimentalFeatures={{ newEditingApi: true }}
                    components={{
                      Pagination: CustomPagination,
                      LoadingOverlay: LinearProgress,
                      NoRowsOverlay: CustomNoRowsOverlay,
                    }}
                    localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                    // Usa estado para controlar a paginação dinamicamente
                    paginationModel={paginationModelpacote}
                    onPaginationModelChange={setPaginationModelpacote}
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
              Pacotes Acionados PJ
              <hr style={{ marginTop: '0px', width: '100%' }} />
              <div className="row g-3">
                <Box sx={{ height: pacotes.length > 0 ? '100%' : 400, width: '100%' }}>
                  <DataGrid
                    rows={pacotesacionadospj}
                    columns={colunaspacotesacionados}
                    loading={loading}
                    disableSelectionOnClick
                    experimentalFeatures={{ newEditingApi: true }}
                    components={{
                      Pagination: CustomPagination,
                      LoadingOverlay: LinearProgress,
                      NoRowsOverlay: CustomNoRowsOverlay,
                    }}
                    localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                    // Usa estado para controlar a paginação dinamicamente
                    paginationModel={paginationModelacionados}
                    onPaginationModelChange={setPaginationModelacionados}
                  />
                </Box>
                <br></br>
                <div className="col-sm-12">
                  E-mail PJ
                  <Input
                    type="text"
                    onChange={(e) => setcolaboradoremail(e.target.value)}
                    value={colaboradoremail.toLowerCase()}
                    placeholder="Digite os e-mails separados por virgula"
                  />
                </div>
                <div className="col-sm-12">
                  E-mails adicionais
                  <Input
                    type="text"
                    onChange={(e) => setemailadcional(e.target.value)}
                    value={emailadcional}
                    placeholder="Digite os e-mails separados por virgula"
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

                <br></br>
                <div className=" col-sm-12 d-flex flex-row-reverse">
                  <Button color="secondary" onClick={enviaremail} disabled={modoVisualizador()}>
                    Enviar E-mail de Acionamento <Icon.Mail />
                  </Button>
                </div>
                <br></br>
              </div>
            </CardBody>
          </div>

          <div>
            <b>Matérial e Serviço</b>
            <hr style={{ marginTop: '0px', width: '100%' }} />
            <div className="row g-3">
              <CardBody className="px-4 , pb-2">
                <div className="row g-3">
                  <div className="col-sm-6"></div>
                  <div className=" col-sm-6 d-flex flex-row-reverse">
                    <div className=" col-sm-6 d-flex flex-row-reverse">
                      <Button color="primary" onClick={() => novocadastro()} disabled={modoVisualizador()}>
                        Solicitar Material/Serviço <Icon.Plus />
                      </Button>

                    </div>
                  </div>
                </div>
                <br></br>
                <div className="row g-3">
                  <Box sx={{ height: 400, width: '100%' }}>
                    <DataGrid
                      rows={materialeservico}
                      columns={colunasmaterialeservico}
                      loading={loading}
                      disableSelectionOnClick
                      experimentalFeatures={{ newEditingApi: true }}
                      components={{
                        Pagination: CustomPagination,
                        LoadingOverlay: LinearProgress,
                        NoRowsOverlay: CustomNoRowsOverlay,
                      }}
                      localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                      // Usa estado para controlar a paginação dinamicamente
                      paginationModel={paginationModelmaterialservico}
                      onPaginationModelChange={setPaginationModelmaterialservico}
                    />
                  </Box>
                </div>
              </CardBody>
            </div>
          </div>
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
                      localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                      // Usa estado para controlar a paginação dinamicamente
                      paginationModel={paginationModeldiarias}
                      onPaginationModelChange={setPaginationModeldiarias}
                    />
                  </Box>
                </div>
              </CardBody>
            </div>
          </div>

          <div>
            <b>Financeiro</b>
            <hr style={{ marginTop: '0px', width: '100%' }} />
            <div className="row g-3"></div>
          </div>
        </ModalBody>
        <ModalFooter style={{ backgroundColor: 'white' }}>
          <Button color="success" onClick={ProcessaCadastro} disabled={modoVisualizador()}>
            Salvar
          </Button>
          <Button color="secondary" onClick={togglecadastro.bind(null)}>
            Sair
          </Button>
        </ModalFooter>
      </Modal>
    </>
  );
};

Rollouttelefonicaedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  titulotopo: PropTypes.string.isRequired,
  ididentificador: PropTypes.string.isRequired,
  pmuf: PropTypes.string.isRequired,
  idr: PropTypes.number.isRequired,
  idpmtslocal: PropTypes.string.isRequired,
};

export default Rollouttelefonicaedicao;
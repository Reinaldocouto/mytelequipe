import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import {
  Modal,
  ModalHeader,
  ModalBody,
  Input,
  CardBody,
  Button,
  InputGroup,
  ModalFooter,
  Col,
  FormGroup,
} from 'reactstrap';
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
import { debounce } from 'lodash';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Typography from '@mui/material/Typography';
import Select from 'react-select';
import DeleteIcon from '@mui/icons-material/Delete';
import { toast, ToastContainer } from 'react-toastify';
import { NumericFormat } from 'react-number-format';
import 'react-toastify/dist/ReactToastify.css';
import api from '../../../services/api';
import modoVisualizador from '../../../services/modovisualizador';
import Excluirregistro from '../../Excluirregistro';
import modofinanceiro from '../../../services/modofinanceiro';
import Solicitacaoedicao from '../suprimento/Solicitacaoedicao';
import Mensagemsimples from '../../Mensagemsimples';
import Solicitardiaria from '../projeto/Solicitardiaria';
import Tarefaedicaotelefonica from '../projeto/Tarefaedicaotelefonica';
import S3Service from '../../../services/s3Service';

let s3Service;
const fetchS3Credentials = async () => {
  try {
    const response = await api.get('v1/credenciaiss3');
    if (response.status === 200) {
      const { acesskeyid, secretkey, region, bucketname } = response?.data[0];
      s3Service = new S3Service({
        region,
        accessKeyId: acesskeyid,
        secretAccessKey: secretkey,
        bucketName: bucketname,
      });
    } else {
      console.error('Credenciais do S3 não encontradas ou resposta malformada:', response.data);
    }
  } catch (error) {
    console.error('Erro ao buscar credenciais do S3:', error);
  }
};
const statusOptions = [
  { value: 'Aprovado', label: 'Aprovado' },
  { value: 'Em Progresso', label: 'Em Progresso' },
  { value: 'Incompleto', label: 'Incompleto' },
  { value: 'Reprovado', label: 'Reprovado' },
];

const Rollouttelefonicaedicao = ({
  setshow,
  show,
  titulotopo,
  ididentificador,
  pmuf,
  idr,
  idpmtslocal,
  deletadoidpmts,
}) => {
  const [acompanhamentofinanceiro, setacompanhamentofinanceiro] = useState([]);
  const [pacotes, setpacotes] = useState([]);
  const [pacotesacionadospj, setpacotesacionadospj] = useState([]);
  const [atividades, setatividades] = useState([]);
  const [paginationModelAcompanhamentoFinanceiro, setPaginationModelAcompanhamentoFinanceiro] =
    useState({ pageSize: 5, page: 0 });
  const [paginationModelFinanceiro, setPaginationModelFinanceiro] = useState({
    pageSize: 5,
    page: 0,
  });
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
  const [rowSelectionModelFinanceiro, setRowSelectionModelFinanceiro] = useState([]);
  const [valornegociado, setvalornegociado] = useState(0);
  const [idcolaboradorpj, setidcolaboradorpj] = useState('');
  const [colaboradorpj, setcolaboradorpj] = useState('');
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
  const [initialtunningstatus, setinitialtunningstatus] = useState('');
  const [initialtunningreal, setinitialtunningreal] = useState('');
  const [initialtunningrealfinal, setinitialtunningrealfinal] = useState('');
  const [dtreal, setdtreal] = useState('');
  const [aprovacaossv, setaprovacaossv] = useState('');
  const [dataimprodutiva, setdataimprodutiva] = useState('');
  const [statusaprovacaossv, setstatusaprovacaossv] = useState('');
  const [statusobra, setstatusobra] = useState('');
  const [docaplan, setdocaplan] = useState('');
  const [ov, setov] = useState('');
  const [resumodafase, setresumodafase] = useState('');
  const [infravivo, setinfravivo] = useState('');
  const [rollout, setrollout] = useState('');
  const [acompanhamentofisicoobservacao, setacompanhamentofisicoobservacao] = useState('');
  const [telaexclusaopj, settelaexclusaopj] = useState(false);
  const [telaexclusaoclt, settelaexclusaoclt] = useState(false);
  const [idacionamentopj, setidacionamentopj] = useState(0);
  const [idacionamentoclt, setidacionamentoclt] = useState(0);
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
  const [quantidade, setquantidade] = useState(0);
  const [iddiaria, setiddiaria] = useState(0);
  const [telaexclusaodiaria, settelaexclusaodiaria] = useState(false);
  const [equipe, setequipe] = useState('');
  const [tarefaedicao, settarefaedicao] = useState(false);
  const [usuario, setusuario] = useState('');
  const [valorTotal, setValorTotal] = useState(0);
  const [despesas, setdespesas] = useState([]);
  const [telaexclusaosolicitacao, settelaexclusaosolicitacao] = useState('');
  const [observacaoDocumentacao, setObservacaoDocumentacao] = useState('');
  const [fileDocumentacao, setFileDocumentacao] = useState();
  const [selectedOptionStatusDocumentacao, setSelectedStatusDocumentacao] = useState('');
  const [dataPostagemDoc, setDataPostagemDoc] = useState();
  const [dataExecucaoDoc, setDataExecucaoDoc] = useState();
  const [dataExecucaoDocVDVM, setDataExecucaoDocVDVM] = useState();
  const [dataPostagemDocVDVM, setDataPostagemDocVDVM] = useState();
  const [dataInventarioDesinstalacao, setDataInventarioDesinstalacao] = useState();
  const [uploadedFiles, setUploadedFiles] = useState([]);
  const [permissionStorage, setPermssionStorage] = useState();
  const [selectedRowsPackage, setSelectedRowsPackage] = useState([]);
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idpmts: ididentificador,
    uf: pmuf,
    idrollout: idr,
    regiaolocal: regiao,
    osouobra: idpmtslocal,
    idcolaborador: idcolaboradorpj,
    deletado: 0,
    projeto: 'TELEFONICA',
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
      if (stat.label === 'NEGOCIADO') {
        if (usuario !== '33' && usuario !== '35' && usuario !== '78') {
          setlpuhistorico('');
          setselectedoptionlpu({ value: null, label: null });
          toast.warning('Você não tem permissão para acionar PJ com valor negociado.');
        } else {
          setlpuhistorico(stat.label);
          setselectedoptionlpu({ value: stat.value, label: stat.label });
          listapacotes(stat.label);
        }
      } else {
        setlpuhistorico(stat.label);
        setselectedoptionlpu({ value: stat.value, label: stat.label });
        listapacotes(stat.label);
      }
    } else {
      setlpuhistorico('');
      setselectedoptionlpu({ value: null, label: null });
    }
  };

  const listaid = async () => {
    const trataData = (data) => (data === '1899-12-30' ? '' : data);

    try {
      setloading(true);

      const response = await api.get('v1/projetotelefonicaid', { params });

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
        setacessodatasolicitacao(trataData(response.data.acessodatasolicitacao));
        setacessodatainicial(trataData(response.data.acessodatainicial));
        setacessodatafinal(trataData(response.data.acessodatafinal));

        setacessostatus(response.data.acessostatus);
        setentregaplan(trataData(response.data.entregaplan));
        setentregareal(trataData(response.data.entregareal));
        setfiminstalacaoplan(trataData(response.data.fiminstalacaoplan));
        setfiminstalacaoreal(trataData(response.data.fiminstalacaoreal));
        setintegracaoplan(trataData(response.data.integracaoplan));
        setintegracaoreal(trataData(response.data.integracaoreal));
        setvistoriaplan(trataData(response.data.vistoriaplan));
        setvistoriareal(trataData(response.data.vistoriareal));
        setativacao(trataData(response.data.ativacao));
        setdocumentacao(trataData(response.data.documentacao));
        setdocplan(trataData(response.data.docplan));
        setdocvitoriareal(trataData(response.data.docvitoriareal));
        setDataInventarioDesinstalacao(trataData(response.data.datainventariodesinstalacao));
        setdtplan(trataData(response.data.dtplan));
        setdtreal(trataData(response.data.dtreal));
        setaprovacaossv(trataData(response.data.aprovacaossv));
        setdataimprodutiva(trataData(response.data.dataimprodutiva));
        setstatusaprovacaossv(response.data.statusaprovacaossv);
        setstatusobra(response.data.statusobra);
        setdocaplan(trataData(response.data.docaplan));
        setov(response.data.ov);
        setresumodafase(response.data.resumodafase);
        setinfravivo(response.data.infravivo);
        setrollout(response.data.rollout);
        setequipe(response.data.equipe);
        setacompanhamentofisicoobservacao(response.data.acompanhamentofisicoobservacao);
        setinitialtunningreal(trataData(response.data.initialtunningreal));
        setinitialtunningrealfinal(trataData(response.data.initialtunningrealfinal));
        setinitialtunningstatus(response.data.initialtunnigstatus);
        setDataExecucaoDoc(trataData(response.data.dataexecucaodoc));
        setDataPostagemDoc(trataData(response.data.datapostagemdoc));
        setSelectedStatusDocumentacao({
          value: response.data.statusdocumentacao,
          label: response.data.statusdocumentacao,
        });

        setDataExecucaoDocVDVM(trataData(response.data.dataexecucaodocvdvm));
        setDataPostagemDocVDVM(trataData(response.data.datapostagemdocvdvm));
        setObservacaoDocumentacao(response.data.observacaodocumentacao);
      } else {
        toast.error(`Erro: ${response.status}`);
      }
    } catch (err) {
      const msg = err.response?.data?.message || err.message || 'Erro inesperado';
      toast.error(`Erro: ${msg}`);
    } finally {
      setloading(false);
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
  const handleChangecolaboradorpj = (stat) => {
    if (stat !== null) {
      setidcolaboradorpj(stat.value);
      setcolaboradorpj(stat.label);
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
  async function listaValorTotal() {
    try {
      const response = await api.get('v1/projetotelefonica/ListaDespesas', {
        params: {
          idpmts: uididpmts,
          idmpst: uididpmts,
        },
      });
      setdespesas(response.data.dados);
      const parseValor = (valor) => {
        if (typeof valor === 'number') return valor;
        if (typeof valor === 'string') {
          const num = parseFloat(
            valor
              .replace(/[^0-9,-]/g, '')
              .replace(/\./g, '')
              .replace(',', '.'),
          );
          return Number.isNaN(num) ? 0 : num;
        }
        return 0;
      };
      const itensOriginais = response.data.dados || response.data || [];
      const itens = itensOriginais.map((item) => ({
        ...item,
        id: item.id ?? item.iddespesa ?? item.iditem,
        valor: parseValor(item.valor),
      }));
      setdespesas(itens);
      const ids = itens.map((item) => item.id);
      setRowSelectionModelFinanceiro(ids);
      const total = itens.reduce((acc, item) => acc + item.valor, 0);
      setValorTotal(total);
    } catch (err) {
      console.error(err.message);
    }
  }
  const handleChangeStatusRelatorioFotografico = (stat) => {
    if (stat !== null) {
      console.log(stat);
      console.log(stat.value);

      setSelectedStatusDocumentacao({ value: stat.value, label: stat.label });
    } else {
      setSelectedStatusDocumentacao({ value: null, label: null });
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
        setdatainicioclt(integracaoreal);
        setdatafinalclt(vistoriareal);
      }
    }
  };
  const handleGenerateDownloadLink = async (fileKey) => {
    try {
      // Usar a chave completa do arquivo diretamente
      const fileName = fileKey.split('/').pop(); // Extrair apenas o nome do arquivo para exibição
      const url = await s3Service.getFileUrl(fileKey);

      if (!url) {
        throw new Error('URL não gerado corretamente');
      }
      const link = document.createElement('a');
      link.href = url;
      link.download = fileName; // Força o download
      link.style.display = 'none';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);

      toast.success(`Download de "${fileName}" iniciado com sucesso!`);
    } catch (error) {
      console.error('Falha ao gerar o link de download', error);

      // Extrair nome do arquivo para mensagens de erro
      const fileName = fileKey ? fileKey.split('/').pop() : 'arquivo';

      // Tratamento específico para diferentes tipos de erro
      if (error.name === 'NoSuchKey' || error.message?.includes('NoSuchKey')) {
        toast.error(
          `Arquivo "${fileName}" não encontrado no servidor. Verifique se o arquivo ainda existe.`,
        );
      } else if (error.name === 'AccessDenied') {
        toast.error('Acesso negado. Você não tem permissão para baixar este arquivo.');
      } else if (error.message?.includes('Network')) {
        toast.error('Erro de conexão. Verifique sua internet e tente novamente.');
      } else {
        toast.error(`Erro ao baixar arquivo: ${error.message || 'Erro desconhecido'}`);
      }
    }
  };
  const handleDeleteFile = async (fileKey) => {
    try {
      await s3Service.deleteFile(fileKey);
      setUploadedFiles(uploadedFiles.filter((uploadedFile) => uploadedFile.key !== fileKey));
    } catch (error) {
      console.error('File deletion failed', error);
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
      await api.get('v1/projetotelefonica/listaatividade', { params }).then((response) => {
        if (response.status === 200) {
          setatividades(response.data);
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
    /*   {
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
       }, */
    {
      field: 'datainclusao',
      headerName: 'Data de Inclusão',
      width: 150,
      align: 'center',
      editable: false,
      valueFormatter: ({ value }) => {
        if (!value) return '';
        const s = String(value).slice(0, 10);
        const [y, m, d] = s.split('-');
        return d && m && y ? `${d}/${m}/${y}` : '';
      },
    },
    {
      field: 'quant',
      headerName: 'QTD',
      width: 80,
      align: 'center',
      type: 'number',
      editable: true,
    },
    {
      field: 'acesso',
      headerName: 'Acesso',
      width: 150,
      align: 'left',
      editable: true,
    },
    {
      field: 'infra',
      headerName: 'Infra',
      width: 150,
      align: 'left',
      editable: true,
      type: 'singleSelect',
      valueOptions: ['GREENFIELD', 'BROWNFIELD'], // Ajustar conforme opções reais
    },
    {
      field: 'rsorsadetentora',
      headerName: 'Detentora',
      width: 150,
      align: 'left',
      editable: true,
    },
    {
      field: 'rsorsaiddetentora',
      headerName: 'ID Detentora',
      width: 150,
      align: 'left',
      editable: true,
    },
    {
      field: 'rsorsasci',
      headerName: 'FCU',
      width: 150,
      align: 'left',
      editable: true,
    },
    {
      field: 'rsorsascistatus',
      headerName: 'RSO_RSA_SCI_STATUS',
      width: 150,
      align: 'left',
      editable: true,
    },
    {
      field: 'acessoatividade',
      headerName: 'Atividade',
      width: 200,
      align: 'left',
      editable: true,
    },
    {
      field: 'acessocomentario',
      headerName: 'Comentários',
      width: 200,
      align: 'left',
      editable: true,
    },
    {
      field: 'acessooutros',
      headerName: 'Outros',
      width: 150,
      align: 'left',
      editable: true,
    },
    {
      field: 'acessoformaacesso',
      headerName: 'Forma de Acesso',
      width: 150,
      align: 'left',
      editable: true,
    },
    {
      field: 'endereco',
      headerName: 'Endereço',
      width: 250,
      align: 'left',
      editable: true,
    },
    {
      field: 'ddd',
      headerName: 'DDD',
      width: 80,
      align: 'center',
      editable: true,
    },
    {
      field: 'cidade',
      headerName: 'Município',
      width: 200,
      align: 'left',
      editable: true,
    },
    {
      field: 'nomedosite',
      headerName: 'Nome Vivo',
      width: 200,
      align: 'left',
      editable: true,
    },
    {
      field: 'latitude',
      headerName: 'Latitude',
      width: 150,
      align: 'left',
      editable: true,
    },
    {
      field: 'longitude',
      headerName: 'Longitude',
      width: 150,
      align: 'left',
      editable: true,
    },
    {
      field: 'acessoobs',
      headerName: 'OBS',
      width: 200,
      align: 'left',
      editable: true,
    },
    {
      field: 'acessosolicitacao',
      headerName: 'Solicitação',
      width: 200,
      align: 'left',
      editable: true,
    },
    {
      field: 'acessodatasolicitacao',
      headerName: 'Data Solicitação',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (paramsacessodatasolicitacao) =>
        paramsacessodatasolicitacao.value ? new Date(paramsacessodatasolicitacao.value) : null,
      valueFormatter: (paramsacessodatasolicitacao) =>
        paramsacessodatasolicitacao.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(
              paramsacessodatasolicitacao.value,
            )
          : '',
      editable: true,
    },
    {
      field: 'acessodatainicial',
      headerName: 'Data Inicial',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (paramsacessodatainicial) =>
        paramsacessodatainicial.value ? new Date(paramsacessodatainicial.value) : null,
      valueFormatter: (paramsacessodatainicial) =>
        paramsacessodatainicial.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(
              paramsacessodatainicial.value,
            )
          : '',
      editable: true,
    },
    {
      field: 'acessodatafinal',
      headerName: 'Data Final',
      width: 150,
      align: 'left',
      type: 'date',
      valueGetter: (paramsacessodatafinal) =>
        paramsacessodatafinal.value ? new Date(paramsacessodatafinal.value) : null,
      valueFormatter: (paramsacessodatafinal) =>
        paramsacessodatafinal.value
          ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short' }).format(
              paramsacessodatafinal.value,
            )
          : '',
      editable: true,
    },
    {
      field: 'acessostatus',
      headerName: 'Status',
      width: 150,
      align: 'left',
      type: 'singleSelect',
      editable: true,
      valueOptions: ['AGUARDANDO', 'APROVADO', 'REPROVADO'], // Ajustar conforme regras reais
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
  function deleteuserclt(stat) {
    setidacionamentoclt(stat);
    settelaexclusaoclt(true);
  }

  const colunaspacotesacionados = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 100,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<DeleteIcon />}
          disabled={modoVisualizador() || deletadoidpmts === 1}
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
      field: 'usuario',
      headerName: 'ACIONADO POR',
      width: 200,
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
      field: 'valorpj',
      headerName: 'VALOR',
      width: 120,
      align: 'right',
      editable: false,
      valueFormatter: (parametros) =>
        parametros.value
          ? parametros.value.toLocaleString('pt-BR', {
              style: 'currency',
              currency: 'BRL',
            })
          : '',
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
          disabled={modoVisualizador() || deletadoidpmts === 1}
          label="Delete"
          onClick={() => deleteuserclt(parametros.id)}
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
      field: 'usuario',
      headerName: 'ACIONADO POR',
      width: 200,
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
      field: 'valor',
      headerName: 'VALOR',
      width: 120,
      align: 'right',
      editable: false,
      valueFormatter: (parametros) =>
        parametros.value
          ? parametros.value.toLocaleString('pt-BR', {
              style: 'currency',
              currency: 'BRL',
            })
          : '',
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

  function deletedespesa(stat) {
    settelaexclusaosolicitacao(true);
    setidentificadorsolicitacao(stat);
  }

  const colunasmaterialeservico = [
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
  /*  const salvarpj = async (pacoteid, atividadeid) => {
  
      if (lpuhistorico === 'NEGOCIAVEL') {
        const valorNumerico = parseFloat(valornegociado);
  
        if (Number.isNaN(valorNumerico) || valorNumerico <= 0) {
          toast.error('É necessário informar um valor válido para acionamento negociável.');
          return; // interrompe a execução
        }
      }
     
      try {
        const response = await api.post('v1/projetotelefonica/acionamentopj', {
          idrollout: idr,
          idatividade: atividadeid,
          idpacote: pacoteid,
          idcolaborador: idcolaboradorpj,
          idpmts: uididpmts,
          quantidade,
          lpuhistorico,
          valornegociado,
          observacaopj,
          idfuncionario: localStorage.getItem('sessionId'),
        });
  
        if (response.status !== 201) {
          throw new Error(`Erro ao salvar pacote ${pacoteid}: status ${response.status}`);
        }
  
        listapacotesacionados(); // você pode manter isso
        return true; // ✅ sinaliza que deu certo
      } catch (err) {
        const erroMsg = err.response?.data?.erro || 'Erro desconhecido na requisição';
        throw new Error(erroMsg); // ❌ faz a Promise ser rejeitada
      }
    }; */

  const salvarpj = async (pacoteid, atividadeid) => {
    if (lpuhistorico === 'NEGOCIAVEL') {
      const valorNumerico = parseFloat(valornegociado);

      if (Number.isNaN(valorNumerico) || valorNumerico <= 0) {
        toast.error('É necessário informar um valor válido para acionamento negociável.');
        return false; // <- retorno consistente
      }
    }
    const { t2descricaocod } = atividades.find((result) => result.id === atividadeid);
    const tipoInstalacao = t2descricaocod.split('-').pop().trim();

    try {
      const response = await api.post('v1/projetotelefonica/acionamentopj', {
        idrollout: idr,
        idatividade: atividadeid,
        idpacote: pacoteid,
        tipoInstalacao,
        idcolaborador: idcolaboradorpj,
        idpmts: uididpmts,
        quantidade,
        lpuhistorico,
        valornegociado,
        observacaopj,
        idfuncionario: localStorage.getItem('sessionId'),
      });

      if (response.status !== 201) {
        throw new Error(`Erro ao salvar pacote ${pacoteid}: status ${response.status}`);
      }

      listapacotesacionados();
      return true; // <- retorno consistente
    } catch (err) {
      const erroMsg = err.response?.data?.erro || 'Erro desconhecido na requisição';
      toast.error(erroMsg); // exibe o erro via toast
      return false; // <- retorno consistente
    }
  };

  const salvarclt = async (atividadeid) => {
    if (!datainicioclt) {
      toast.error('É necessário informar a data de início.');
      return;
    }

    if (!datafinalclt) {
      toast.error('É necessário informar a data de fim.');
      return;
    }
    console.log(rowSelectionModel);
    const { po, t2descricaocod } = atividades.find((result) => result.id === atividadeid);
    const tipoInstalacao = t2descricaocod.split('-').pop().trim();
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
        tipoInstalacao,
        hora100clt,
        po,
        idfuncionario: localStorage.getItem('sessionId'),
      })
      .then((response) => {
        if (response.status !== 201) {
          toast.error(response.status);
        } else {
          setdatainicioclt('');
          setdatafinalclt('');
          settotalhorasclt('0');
          setobservacaoclt('');
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
    const valueselectedOptionStatusDocumentacao = selectedOptionStatusDocumentacao?.value;
    const formatDate = (date) => (date ? new Date(date).toISOString().split('T')[0] : '');
    api
      .post('v1/projetotelefonica', {
        infra,
        infraviv: infravivo,
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
        acessostatus,
        entregaplan,
        entregareal,
        fiminstalacaoplan,
        fiminstalacaoreal,
        integracaoplan,
        integracaoreal,
        ativacao,
        documentacao,
        initialtunningstatus,
        initialtunningreal,
        initialtunningrealfinal,
        dtplan,
        dtreal,
        aprovacaossv,
        dataimprodutiva: formatDate(dataimprodutiva),
        statusaprovacaossv,
        statusobra,
        vistoriaplan,
        vistoriareal,
        docplan,
        docvitoriareal,
        req,
        docaplan,
        ov,
        uididcpomrf,
        resumodafase,
        rollout,
        acompanhamentofisicoobservacao,
        equipe,
        dataPostagemDoc,
        dataExecucaoDoc,
        dataExecucaoDocVDVM,
        dataPostagemDocVDVM,
        dataInventarioDesinstalacao,
        observacaoDocumentacao,
        selectedOptionStatusDocumentacao: valueselectedOptionStatusDocumentacao,
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
      if (!rowSelectionModel || rowSelectionModel.length !== 1) {
        toast.error('Selecione apenas um item na lista de Atividade');
        return;
      }

      if (!rowSelectionModelpacotepj || rowSelectionModelpacotepj.length === 0) {
        toast.error('Selecione um ou mais itens na lista de pacotes');
        return;
      }

      const resultados = await Promise.allSettled(
        rowSelectionModelpacotepj.map((poite) => salvarpj(poite, rowSelectionModel[0])),
      );

      const algumSucesso = resultados.some(
        (res) => res.status === 'fulfilled' && res.value === true,
      );

      const algumErro = resultados.some((res) => res.status === 'rejected');

      if (algumErro) {
        toast.warning('Alguns pacotes não foram salvos. Verifique os erros.');
      }

      resultados.forEach((res, index) => {
        if (res.status === 'rejected') {
          toast.error(`Erro ao salvar pacote ${rowSelectionModelpacotepj[index]}`);
          console.error(res.reason);
        }
      });
      listaValorTotal();
      if (algumSucesso) {
        toast.success('Acionamentos salvos com sucesso!');
      } else {
        toast.error('Erro ao salvar acionamentos');
      }
    } catch (error) {
      toast.error(`Erro ao salvar itens: ${error.message || error}`);
      console.error(error);
    }
  };
  const execacionamentoclt = async () => {
    // Validação das datas
    if (!datainicioclt || !datafinalclt) {
      toast.error('Não é possível salvar sem data de início ou fim do CLT');
      return;
    }

    // Validação da seleção
    if (!rowSelectionModel || rowSelectionModel.length === 0) {
      toast.error('Selecione um item na lista de Atividade');
      return;
    }

    if (rowSelectionModel.length > 1) {
      toast.error('Selecione apenas um item na lista de Atividade');
      return;
    }

    try {
      await salvarclt(rowSelectionModel[0]);

      await listapacotesacionadosclt();
      await listaValorTotal();
      toast.success('Acionamento salvo com sucesso!');
    } catch (erro) {
      console.error(erro);
      toast.error('Ocorreu um erro ao salvar.');
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
          listaValorTotal();
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
          listaValorTotal();
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
      await api.get('v1/solicitacao/listaporempresa', { params }).then((response) => {
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
          colaborador: idcolaboradorpj,
          uididpmts,
          ids: selectedRowsPackage.join(','),
          assunto: `ACIONAMENTO SIRIUS TELEFONICA ${pmoregional} ${colaboradorpj} ${ufsigla} - ${uididpmts}`,
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

  function deletediaria(stat) {
    setiddiaria(stat);
    settelaexclusaodiaria(true);
  }
  const colunasFinanceiro = [
    {
      field: 'tipo',
      headerName: 'Tipo',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'descricao',
      headerName: 'Descrição',
      width: 600,
      align: 'left',
      editable: false,
    },
    {
      field: 'valor',
      headerName: 'Valor (R$)',
      width: 200,
      align: 'right',
      type: 'number',
      valueFormatter: ({ value }) => {
        return value?.toLocaleString('pt-BR', {
          style: 'currency',
          currency: 'BRL',
        });
      },
      editable: false,
      cellClassName: ({ value }) => {
        return value >= 0 ? 'valor-positivo' : 'valor-negativo';
      },
    },
    {
      field: 'nome',
      headerName: 'Responsável',
      width: 200,
      align: 'left',
      editable: false,
    },
  ];
  //tabela de dados de despesa diarias
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
    }, // { field: 'id', headerName: 'ID', width: 60, align: 'center' },
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
  const calcularTotalDebounced = debounce((normal, h50, h100) => {
    settotalhorasclt(Number(normal) + Number(h50) + Number(h100));
  }, 200);

  useEffect(() => {
    if (!dtreal) {
      setaprovacaossv('');
      setstatusaprovacaossv('');
    }
  }, [dtreal]);

  useEffect(() => {
    if (!aprovacaossv) {
      setstatusaprovacaossv('');
    }
  }, [aprovacaossv]);
  const listFilesFromS3 = async () => {
    try {
      const prefix = `telequipe/rollout/${uididpmts}/`;
      const files = await s3Service.listFiles(prefix);
      const fileUrls = await Promise.all(
        files.map(async (filee) => {
          const url = await s3Service.getFileUrl(filee.Key);
          return { name: filee.Key.split('/').pop(), url, key: filee.Key };
        }),
      );
      console.log(fileUrls);
      setUploadedFiles(fileUrls);
    } catch (error) {
      console.error('Failed to list files', error);
    }
  };
  useEffect(() => {
    calcularTotalDebounced(horanormalclt, hora50clt, hora100clt);
  }, [horanormalclt, hora50clt, hora100clt]);
  const listasolicitacaodiaria = async () => {
    try {
      setloading(true);
      await api.get('v1/projetotelefonica/diaria', { params }).then((response) => {
        setsolicitacaodiaria(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    }
    setloading(false);
  };
  const handleFileUpload = async () => {
    if (!fileDocumentacao) {
      toast.error('Por favor, selecione um arquivo para fazer upload.');
      return;
    }

    const prefix = `telequipe/rollout/${uididpmts}/`;

    try {
      // Limpar arquivos existentes antes do upload
      const files = await s3Service.listFiles(prefix);
      if (files.length > 0) {
        await Promise.all(
          files
            .filter((file) => file.Key) // garante que a key existe
            .map((file) => s3Service.deleteFile(file.Key)),
        );
      }

      // Fazer upload do novo arquivo
      const key = `${prefix}${fileDocumentacao.name}`; // sem barra extra
      await s3Service.uploadFile(fileDocumentacao, key);

      // Obter URL do arquivo e atualizar lista
      const url = await s3Service.getFileUrl(key);

      // Atualizar a lista de arquivos com a estrutura correta (incluindo key)
      const newFile = {
        name: fileDocumentacao.name,
        url,
        key,
      };

      setUploadedFiles([newFile]); // Substituir lista com o novo arquivo

      // Recarregar lista do S3 para garantir consistência
      await listFilesFromS3();

      toast.success(`Arquivo "${fileDocumentacao.name}" enviado com sucesso!`);

      // Limpar o input de arquivo
      setFileDocumentacao(null);
    } catch (error) {
      console.error('File upload failed', error);

      // Tratamento específico de erros
      if (error.name === 'AccessDenied') {
        toast.error('Acesso negado. Você não tem permissão para fazer upload de arquivos.');
      } else if (error.message?.includes('Network')) {
        toast.error('Erro de conexão. Verifique sua internet e tente novamente.');
      } else if (error.message?.includes('file size')) {
        toast.error('Arquivo muito grande. Tente um arquivo menor.');
      } else {
        toast.error(`Erro ao enviar arquivo: ${error.message || 'Erro desconhecido'}`);
      }
    }
  };

  const emailadicional = async () => {
    try {
      const response = await api.get('v1/projetotelefonica/emailadicional', { params });
      setemailadcional(response.data.email);
    } catch (err) {
      console.error(err.message);
    }
  };

  const iniciatabelas = async () => {
    await listaid();
    await listaacompanhamentofinanceiro();
    await listaatividades();
    await listacolaboradorpj();
    await listacolaboradorclt();
    await listapacotesacionados();
    await listapacotesacionadosclt();
    await listasolicitacao();
    await listasolicitacaodiaria();
    await emailadicional();
    setusuario(localStorage.getItem('sessionId'));
  };

  useEffect(() => {
    listapacotesacionados();
  }, [motivo]);
  useEffect(() => {
    if (uididpmts) {
      listaValorTotal();
      fetchS3Credentials();
    }
  }, [uididpmts]);
  useEffect(() => {
    listFilesFromS3();
  }, [s3Service]);
  useEffect(() => {
    iniciatabelas();
    setPermssionStorage(JSON.parse(localStorage.getItem('permission')));
    if (1 === 0) {
      console.log(colaboradoremail);
      console.log(retanexo);
    }
  }, []);
  useEffect(() => {
    if (uididpmts) {
      listaValorTotal();
    }
  }, [
    telacadastrosolicitacaodiaria,
    telaexclusaopj,
    telaexclusaoclt,
    telaexclusaodiaria,
    telacadastrosolicitacao,
    tarefaedicao,
    telacadastrosolicitacaodiaria,
    mostra,
  ]);
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
            {telaexclusaoclt ? (
              <>
                <Excluirregistro
                  show={telaexclusaoclt}
                  setshow={settelaexclusaoclt}
                  ididentificador={idacionamentoclt}
                  quemchamou="ATIVIDADECLTTELEFONICA"
                  atualiza={listapacotesacionadosclt}
                />{' '}
              </>
            ) : null}

            {telaexclusaodiaria ? (
              <>
                <Excluirregistro
                  show={telaexclusaodiaria}
                  setshow={settelaexclusaodiaria}
                  ididentificador={iddiaria}
                  quemchamou="DIARIA"
                  atualiza={listasolicitacaodiaria}
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
                novo="1"
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

            {tarefaedicao ? (
              <>
                {' '}
                <Tarefaedicaotelefonica
                  show={tarefaedicao}
                  setshow={settarefaedicao}
                  titulo="Adicionar nova tarefa"
                  regiao={regiao}
                  regional={pmoregional}
                  atualiza={() => listapacotes('NEGOCIADO')}
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
                projetousual="TELEFONICA"
                numero={uididpmts}
                idlocal={uididpmts}
                sigla={ufsigla}
                clientelocal="VIVO"
              />
            ) : null}
            {telaexclusaosolicitacao ? (
              <>
                <Excluirregistro
                  show={telaexclusaosolicitacao}
                  setshow={settelaexclusaosolicitacao}
                  ididentificador={identificadorsolicitacao}
                  quemchamou="SOLICITACAOITENS"
                  atualiza={listasolicitacao}
                  idlojaatual={localStorage.getItem('sessionloja')}
                />{' '}
              </>
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

            <b>Identificação</b>
            <hr style={{ marginTop: '0px', width: '100%' }} />
            <CardBody className="px-4 , pb-2">
              <div className="row g-3">
                <div className="col-sm-2">
                  UID_IDPMTS
                  <Input type="text" value={uididpmts} disabled />
                </div>
                <div className="col-sm-2">
                  UF/SIGLA
                  <Input type="text" value={ufsigla} disabled />
                </div>
                <div className="col-sm-2">
                  UID_IDCPOMRF
                  <Input type="text" value={uididcpomrf} disabled />
                </div>
                <div className="col-sm-2">
                  PMO_UF
                  <Input type="text" value={pmouf} disabled />
                </div>
                <div className="col-sm-2">
                  PMO_REGIONAL
                  <Input type="text" value={pmoregional} disabled />
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
                  <Input type="text" value={pmosigla} disabled />
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
                  <Input type="text" value={rsorsadetentora} disabled />
                </div>
                <div className="col-sm-2">
                  ID DETENTORA
                  <Input type="text" value={rsorsaiddetentora} disabled />
                </div>
                <div className="col-sm-2">
                  FCU
                  <Input type="text" value={rsorsasci} disabled />
                </div>
                <div className="col-sm-2">
                  RSO_RSA_SCI_STATUS
                  <Input type="text" value={rsorsascistatus} disabled />
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
                    paginationModel={paginationModelAcompanhamentoFinanceiro}
                    onPaginationModelChange={setPaginationModelAcompanhamentoFinanceiro}
                  />
                </Box>
              </div>
            </CardBody>
          </div>
          {permissionStorage?.telefonicaedicaodocumentacao === 1 && (
            <div>
              <b>Documentação</b>
              <hr style={{ marginTop: '0px', width: '100%' }} />
              <CardBody className="px-4 pb-2">
                <div className="row g-3">
                  <div className="col-sm-2">
                    Data de Execução Doc.
                    <Input
                      type="date"
                      onChange={(e) => setDataExecucaoDoc(e.target.value)}
                      value={dataExecucaoDoc}
                      placeholder=""
                    />
                  </div>
                  <div className="col-sm-2">
                    Data da Postagem Doc.
                    <Input
                      type="date"
                      onChange={(e) => setDataPostagemDoc(e.target.value)}
                      value={dataPostagemDoc}
                      placeholder=""
                    />
                  </div>
                  <div className="col-sm-4">
                    Status do Relatório Fotográfico
                    <Select
                      isClearable
                      isSearchable
                      name="statusrelatoriofotografico"
                      options={statusOptions}
                      placeholder="Selecione"
                      isLoading={loading}
                      onChange={handleChangeStatusRelatorioFotografico}
                      value={selectedOptionStatusDocumentacao}
                    />
                  </div>
                </div>

                <div className="row g-3 mt-3">
                  <div className="col-sm-2">
                    Documentação Vistoria Plan
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
                    Documentação Instalação
                    <Input
                      type="date"
                      onChange={(e) => setdocumentacao(e.target.value)}
                      value={documentacao}
                    />
                  </div>
                  <div className="col-sm-2">
                    Data Inventário Desinstalação
                    <Input
                      type="date"
                      onChange={(e) => e.target.value}
                      value={dataInventarioDesinstalacao}
                    />
                  </div>
                </div>

                <div className="row g-3 mt-3">
                  <div className="col-sm-4">
                    Data da Execução Doc. VD/VM.
                    <Input
                      type="date"
                      onChange={(e) => setDataExecucaoDocVDVM(e.target.value)}
                      value={dataExecucaoDocVDVM}
                      placeholder=""
                    />
                  </div>
                  <div className="col-sm-4">
                    Data da Postagem Doc. VD/VM.
                    <Input
                      type="date"
                      onChange={(e) => setDataPostagemDocVDVM(e.target.value)}
                      value={dataPostagemDocVDVM}
                      placeholder=""
                    />
                  </div>

                  <div className="col-sm-12 mb-4">
                    Observação
                    <Input
                      type="textarea"
                      onChange={(e) => setObservacaoDocumentacao(e.target.value)}
                      value={observacaoDocumentacao}
                      placeholder=""
                    />
                  </div>
                </div>
                <div className="row g-3">
                  <Col md="12">
                    <FormGroup>
                      <div className="d-flex align-items-center">
                        <Input
                          type="file"
                          onChange={(e) => setFileDocumentacao(e.target.files[0])}
                        />
                        <Button
                          color="primary"
                          onClick={handleFileUpload}
                          className="ms-0"
                          disabled={!ididentificador}
                        >
                          Upload
                        </Button>
                      </div>
                    </FormGroup>
                    <div style={{ backgroundColor: 'white' }}>
                      <div className="col-sm-12">
                        <div className="d-flex flex-row-reverse custom-file">
                          <table className="table table-white-bg">
                            <thead>
                              <tr>
                                <th>Nome do arquivo</th>
                                <th>Download</th>
                                <th>Delete</th>
                              </tr>
                            </thead>
                            <tbody>
                              {uploadedFiles.map((uploadedFile) => (
                                <tr key={uploadedFile.name}>
                                  <td>{uploadedFile.name}</td>
                                  <td>
                                    <Button
                                      color="primary"
                                      onClick={() => handleGenerateDownloadLink(uploadedFile.key)}
                                    >
                                      Download
                                    </Button>
                                  </td>
                                  <td>
                                    <Button
                                      color="danger"
                                      onClick={() => handleDeleteFile(uploadedFile.key)}
                                    >
                                      Delete
                                    </Button>
                                  </td>
                                </tr>
                              ))}
                            </tbody>
                          </table>
                        </div>
                      </div>
                    </div>
                  </Col>
                </div>
              </CardBody>
            </div>
          )}

          <div>
            <b>Acompanhamento Fisico</b>
            <hr style={{ marginTop: '0px', width: '100%' }} />
            <CardBody className="px-4 , pb-2">
              <div className="row g-3">
                <div className="col-sm-2">
                  Vistoria Plan
                  <Input
                    type="date"
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
                  REQ
                  <Input type="date" onChange={(e) => setreq(e.target.value)} value={req} />
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
                  <Input type="text" onChange={(e) => setov(e.target.value)} value={ov} />
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
                  Initial Tunning Real Início
                  <Input
                    type="date"
                    onChange={(e) => setinitialtunningreal(e.target.value)}
                    value={initialtunningreal}
                    disabled={modoVisualizador() || deletadoidpmts === 1}
                  />
                </div>

                <div className="col-sm-2">
                  Initial Tunning Real Final
                  <Input
                    type="date"
                    onChange={(e) => setinitialtunningrealfinal(e.target.value)}
                    value={initialtunningrealfinal}
                    disabled={modoVisualizador() || deletadoidpmts === 1}
                  />
                </div>
                <div className="col-sm-2">
                  Initial Tunning Status
                  <Input
                    id="initialTunningStatus" /* ← corresponde ao htmlFor */
                    type="select"
                    value={initialtunningstatus}
                    onChange={(e) => setinitialtunningstatus(e.target.value)}
                    disabled={modoVisualizador() || deletadoidpmts === 1}
                  >
                    <option value="">Selecione...</option>
                    <option value="ABERTA">Aberta</option>
                    <option value="COMPLETADO_COM_PENDENCIAS">Completado Com Pendências</option>
                    <option value="COMPLETADO">Completado</option>
                  </Input>
                </div>

                <div className="col-sm-2">
                  DT Plan
                  <Input type="date" onChange={(e) => setdtplan(e.target.value)} value={dtplan} />
                </div>
                <div className="col-sm-2">
                  DT Real
                  <Input
                    type="date"
                    data-testid="dtreal"
                    onChange={(e) => setdtreal(e.target.value)}
                    value={dtreal}
                  />
                </div>
                <div className="col-sm-2">
                  Data Improdutiva
                  <Input
                    type="date"
                    onChange={(e) => setdataimprodutiva(e.target.value)}
                    value={dataimprodutiva}
                  />
                </div>
                {dtreal && (
                  <>
                    <div className="col-sm-2">
                      Aprovação de SSV
                      <Input
                        type="date"
                        onChange={(e) => setaprovacaossv(e.target.value)}
                        value={aprovacaossv}
                        disabled={modoVisualizador() || deletadoidpmts === 1}
                      />
                    </div>
                    {aprovacaossv && (
                      <div className="col-sm-2">
                        Status Aprovação SSV
                        <Input
                          type="select"
                          onChange={(e) => setstatusaprovacaossv(e.target.value)}
                          value={statusaprovacaossv}
                        >
                          <option value="">Selecione</option>
                          <option value="APROVADO">APROVADO</option>
                          <option value="REPROVADO">REPROVADO</option>
                        </Input>
                      </div>
                    )}
                    <div className="col-sm-2">
                      Status Aprovação de SSV
                      <Input
                        type="select"
                        value={statusaprovacaossv}
                        onChange={(e) => setstatusaprovacaossv(e.target.value)}
                        disabled={modoVisualizador() || deletadoidpmts === 1}
                      >
                        <option value="">Selecione...</option>
                        <option value="ABERTA">Aberta</option>
                        <option value="COMPLETADO_COM_PENDENCIAS">Completado Com Pendências</option>
                        <option value="COMPLETADO">Completado</option>
                      </Input>
                    </div>
                  </>
                )}
                <div className="col-sm-2">
                  Status Obra
                  <Input
                    type="select"
                    name="statusobra"
                    onChange={(e) => setstatusobra(e.target.value)}
                    value={statusobra}
                  >
                    <option value="">Selecione</option>
                    <option value="AGENDAR">AGENDAR</option>
                    <option value="AG. TX">AG. TX</option>
                    <option value="ATIVAÇÃO">ATIVAÇÃO</option>
                    <option value="CANCELADO">CANCELADO</option>
                    <option value="CONCLUIDO">CONCLUIDO</option>
                    <option value="DT">DT</option>
                    <option value="ENTREGA">ENTREGA</option>
                    <option value="INSTALAÇÃO">INSTALAÇÃO</option>
                    <option value="INTEGRAÇÃO">INTEGRAÇÃO</option>
                    <option value="PARALISADO">PARALISADO</option>
                    <option value="PLANEJAMENTO">PLANEJAMENTO</option>
                    <option value="PROG. INTEGRAÇÃO">PROG. INTEGRAÇÃO</option>
                    <option value="SSV ENTREGUE">SSV ENTREGUE</option>
                    <option value="VISTORIA">VISTORIA</option>
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

                <div className="col-sm-3">
                  Equipe
                  <Input type="text" onChange={(e) => setequipe(e.target.value)} value={equipe} />
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
                    processRowUpdate={(newRow) => {
                      // Atualiza a linha editada no estado
                      setatividades((prevRows) =>
                        prevRows.map((row) => (row.id === newRow.id ? newRow : row)),
                      );
                      return newRow;
                    }}
                    onRowSelectionModelChange={(newRowSelectionModel) => {
                      setRowSelectionModel(newRowSelectionModel);

                      const selecionados = atividades.filter((row) =>
                        newRowSelectionModel.includes(row.id),
                      );

                      const quantidadesSelecionadas = selecionados.map((row) => row.quant); // ou row.quantidade
                      setquantidade(quantidadesSelecionadas[0] ?? null);
                      console.log(quantidadesSelecionadas[0]);
                    }}
                    rowSelectionModel={rowSelectionModel}
                    experimentalFeatures={{ newEditingApi: true }}
                    components={{
                      Pagination: CustomPagination,
                      LoadingOverlay: LinearProgress,
                      NoRowsOverlay: CustomNoRowsOverlay,
                    }}
                    localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
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
                  />
                </div>
                <div className="col-sm-2">
                  Data Final
                  <Input
                    type="date"
                    onChange={(e) => setdatafinalclt(e.target.value)}
                    value={datafinalclt}
                    placeholder=""
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
                <Button
                  color="primary"
                  onClick={execacionamentoclt}
                  disabled={modoVisualizador() || deletadoidpmts === 1}
                >
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
                    {(usuario === '33' || usuario === '35' || usuario === '78') && (
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
                          onValueChange={(values) => {
                            const { floatValue } = values;
                            setvalornegociado(floatValue || 0);
                          }}
                        />
                      </div>
                    )}
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
              {lpuhistorico === 'NEGOCIADO' && (
                <div className=" col-sm-12 d-flex flex-row-reverse">
                  <div className=" col-sm-12 d-flex flex-row-reverse">
                    <Button
                      color="primary"
                      disabled={modoVisualizador() || deletadoidpmts === 1}
                      onClick={() => settarefaedicao(true)}
                    >
                      Adicionar Tarefa Avulso <Icon.Plus />
                    </Button>
                  </div>
                </div>
              )}
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
                <Button
                  color="primary"
                  onClick={execacionamentopj}
                  disabled={modoVisualizador() || deletadoidpmts === 1}
                >
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
                    checkboxSelection
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
                    onRowSelectionModelChange={(newSelection) => {
                      setSelectedRowsPackage(newSelection);
                    }}
                    rowSelectionModel={selectedRowsPackage}
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
                      <Button
                        color="primary"
                        onClick={uploadanexo}
                        disabled={modoVisualizador() || deletadoidpmts === 1}
                      >
                        Anexar{' '}
                      </Button>
                    </InputGroup>
                  </div>
                </div>

                <br></br>
                <div className=" col-sm-12 d-flex flex-row-reverse">
                  <Button
                    color="secondary"
                    onClick={enviaremail}
                    disabled={modoVisualizador() || deletadoidpmts === 1}
                  >
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
                      <Button
                        color="primary"
                        onClick={() => novocadastro()}
                        disabled={modoVisualizador() || deletadoidpmts === 1}
                      >
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
                      <Button
                        color="primary"
                        onClick={() => novocadastrodiaria()}
                        disabled={modoVisualizador() || deletadoidpmts === 1}
                      >
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
            <div className="col-sm-12 mt-3 mb-3 d-flex justify-content-between">
              <p className="text-muted text-sm mt-2">
                {rowSelectionModelFinanceiro.length} linhas selecionadas
              </p>
              <p className="text-end text-muted text-sm mt-2">
                Valor total:{' '}
                <strong>
                  {(valorTotal ?? 0).toLocaleString('pt-BR', {
                    style: 'currency',
                    currency: 'BRL',
                  })}
                </strong>
              </p>
            </div>
            <div className="row g-3">
              <div className="row g-3">
                <Box sx={{ height: 400, width: '100%' }}>
                  <DataGrid
                    rows={despesas}
                    columns={colunasFinanceiro}
                    loading={loading}
                    disableSelectionOnClick
                    checkboxSelection
                    rowSelectionModel={rowSelectionModelFinanceiro}
                    onRowSelectionModelChange={(newSelection) => {
                      setRowSelectionModelFinanceiro(newSelection);
                      const total = despesas
                        .filter((row) => newSelection.includes(row.id))
                        .reduce((acc, row) => acc + (Number(row.valor) || 0), 0);
                      setValorTotal(total);
                    }}
                    experimentalFeatures={{ newEditingApi: true }}
                    components={{
                      Pagination: CustomPagination,
                      LoadingOverlay: LinearProgress,
                      NoRowsOverlay: CustomNoRowsOverlay,
                    }}
                    localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                    paginationModel={paginationModelFinanceiro}
                    onPaginationModelChange={setPaginationModelFinanceiro}
                  />
                </Box>
              </div>
            </div>
          </div>
        </ModalBody>
        <ModalFooter style={{ backgroundColor: 'white' }}>
          <Button
            color="success"
            onClick={ProcessaCadastro}
            disabled={modoVisualizador() || deletadoidpmts === 1}
          >
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
  deletadoidpmts: PropTypes.number.isRequired,
};

export default Rollouttelefonicaedicao;

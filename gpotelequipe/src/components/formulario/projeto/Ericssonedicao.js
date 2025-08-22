import { useState, useEffect } from 'react';
import PaidIcon from '@mui/icons-material/Paid';
import { grey, yellow, green } from '@mui/material/colors';
import {
  Button,
  FormGroup,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
  Input,
  Label,
  InputGroup,
  //Row
} from 'reactstrap';
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
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import DeleteIcon from '@mui/icons-material/Delete';
//import SearchIcon from '@mui/icons-material/Search';
import * as Icon from 'react-feather';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Box from '@mui/material/Box';
import Select from 'react-select';
import Typography from '@mui/material/Typography';
import { toast, ToastContainer } from 'react-toastify';
import PropTypes from 'prop-types';
import modoVisualizador from '../../../services/modovisualizador';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import './textearea.css';
import Atividadeedicao from './Atividadeedicao';
import Excluirregistro from '../../Excluirregistro';
import Solicitacaoedicao from '../suprimento/Solicitacaoedicao';
import Mensagemsimples from '../../Mensagemsimples';
import Tarefaedicao from './Tarefaedicao';
import Solicitardiaria from './Solicitardiaria';

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

function a11yProps(index) {
  return {
    id: `simple-tab-${index}`,
    'aria-controls': `simple-tabpanel-${index}`,
  };
}

function a12yProps(index) {
  return {
    id: `simple-tab-${index}`,
    'aria-controls': `simple-tabpanel-${index}`,
  };
}

const Ericssonedicao = ({ setshow, show, ididentificador, ididentificador2, atualiza, idsite }) => {
  const [value, setValue] = useState(0);
  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  const [value1, setValue1] = useState(0);
  const handleChange1 = (event, newValue) => {
    setValue1(newValue);
  };

  const [telaexclusaoclt, settelaexclusaoclt] = useState('');
  const [telaexclusaopj, settelaexclusaopj] = useState('');
  const [loading, setloading] = useState(false);
  const [loadingpj, setloadingpj] = useState(false);
  const [loadingFinanceiro, setloadingFinanceiro] = useState(false);
  const [pageSize, setPageSize] = useState(10);
  const [listamigo, setlistamigo] = useState([]);
  const [documentacaoobrafinal, setdocumentacaoobrafinal] = useState([]);
  const [documentacaocivilwork, setdocumentacaocivilwork] = useState([]);
  const [lpulista, setlpulista] = useState([]);
  const [numero, setnumero] = useState('');
  const [numeroacio, setnumeroacio] = useState('');
  const [rfp, setrfp] = useState('');
  const [cliente, setcliente] = useState('');
  const [regiona, setregiona] = useState('');
  const [site, setsite] = useState('');
  const [fornecedor, setfornecedor] = useState('');
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
  const [pendencia, setpendencia] = useState('');
  const [aceitacao, setaceitacao] = useState('');

  const [dataintegracaoplanejadodia, setdataintegracaoplanejadodia] = useState('');
  const [datavalidacaoeriboxedia, setdatavalidacaoeriboxedia] = useState('');
  const [idcolaboradorclt, setidcolaboradorclt] = useState('');
  const [idcolaboradorpj, setidcolaboradorpj] = useState('');
  const [nomecolaboradorpj, setnomecolaboradorpj] = useState('');
  const [colaboradoremail, setcolaboradoremail] = useState('');

  const [datainicioclt, setdatainicioclt] = useState(Date);
  const [datafinalclt, setdatafinalclt] = useState(Date);
  const [identificadorsolicitacaodiaria, setidentificadorsolicitacaodiaria] = useState('');
  const [titulodiaria, settitulodiaria] = useState('');
  const [telacadastrosolicitacaodiaria, settelacadastrosolicitacaodiaria] = useState(false);


  const [totalhorasclt, settotalhorasclt] = useState('');
  const [observacaoclt, setobservacaoclt] = useState('');
  const [observacaopj, setobservacaopj] = useState('');
  const [titulo, settitulo] = useState('');
  const [telacadastrosolicitacao, settelacadastrosolicitacao] = useState('');
  const [telacadastroedicaosolicitacao, settelacadastroedicaosolicitacao] = useState('');
  const [telaexclusaosolicitacao, settelaexclusaosolicitacao] = useState('');
  const [solicitacao, setsolicitacao] = useState([]);
  const [rowSelectionModel, setRowSelectionModel] = useState([]);
  const [mostra, setmostra] = useState('');
  const [motivo, setmotivo] = useState('');
  const [mensagemtela, setmensagemtela] = useState('');
  const [telaexclusaodiaria, settelaexclusaodiaria] = useState(false);
  const [iddiaria, setiddiaria] = useState(0);
  const [solicitacaodiaria, setsolicitacaodiaria] = useState([]);

  const [identificadorsolicitacao, setidentificadorsolicitacao] = useState('');
  const [selectedoptioncolaboradorclt, setselectedoptioncolaboradorclt] = useState(null);
  const [selectedoptioncolaboradorpj, setselectedoptioncolaboradorpj] = useState(null);
  const [selectedoptionlpu, setselectedoptionlpu] = useState(null);
  const [atividadecltlista, setatividadecltlista] = useState([]);
  const [atividadepjlista, setatividadepjlista] = useState([]);
  const [colaboradorcltlista, setcolaboradorcltlista] = useState([]);
  const [colaboradorpjlista, setcolaboradorpjlista] = useState([]);
  const [poservicolista, setposervicolista] = useState([]);
  const [telaatividadeedicao, settelaatividadeedicao] = useState('');
  const [valorhora, setvalorhora] = useState('');
  const [horanormalclt, sethoranormalclt] = useState('');
  const [hora50clt, sethora50clt] = useState('');
  const [hora100clt, sethora100clt] = useState('');
  const [emailadcional, setemailadcional] = useState(''); //('anna.christina@telequipeprojetos.com.br;ingrid.santos@telequipeprojetos.com.br;alex.costa@telequipeprojetos.com.br');
  const [lpuhistorico, setlpuhistorico] = useState('');
  const [valornegociado, setvalornegociado] = useState('');
  const [telacadastrotarefa, settelacadastrotarefa] = useState('');
  const [titulotarefa, settitulotarefa] = useState('');
  const [ididentificadortarefa, setididentificadortarefa] = useState('');
  const [arquivoanexo, setarquivoanexo] = useState('');
  const [retanexo, setretanexo] = useState('');
  const [ericFechamento, setEricFechamento] = useState(0); // Armazena apenas o valor de ericfechamento
  const [relatorioDespesas, setRelatorioDespesas] = useState([]);
  const [totalfinanceiro, setTotalFinanceiro] = useState();
  const togglecadastro = () => {
    setshow(!show);
  };

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idlocal: idsite,
    idprojetoericsson: ididentificador,
    idcontroleacessobusca: localStorage.getItem('sessionId'),
    idempresas: idcolaboradorpj,
    deletado: 0,
    osouobra: ididentificador,
    obra: numero,
    projeto: 'ERICSSON',
    //identificador pra mandar pro solicitação edição:
    identificadorsolicitacao: ididentificador2,
  };

  const despesasrelaotrioericsson = async () => {
    try {
      setloadingFinanceiro(true);
      const response = await api.get('v1/projetoericsson/relatoriodespesas', {
        params: {
          site,
          ...params,
        },
      });

      // Verifica se a resposta tem dados e formata corretamente
      const dadosFormatados = response.data?.map((item) => ({
        ...item,
        id: item.id || Math.random().toString(36).substr(2, 9), // Garante um ID único
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
          onChange={(event, value2) => apiRef.current.setPage(value2 - 1)}
        />
      </Box>
    );
  }

  function CustomPaginationclt() {
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
          onChange={(event, value2) => apiRef.current.setPage(value2 - 1)}
        />
      </Box>
    );
  }

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

  const listaatividadeclt = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/listaatividadeclt', { params }).then((response) => {
        setatividadecltlista(response.data);
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

  const listaatividadepj = async () => {
    try {
      console.log('entrei no lista atividade');
      setloadingpj(true);
      await api.get('v1/projetoericsson/listaatividadepj', { params }).then((response) => {
        setatividadepjlista(response.data);
        //setselectedoptioncolaboradorpj({ value: response.data.idcolaboradorpj, label: response.data.colaboradorpj });
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloadingpj(false);
    }
  };


  const listasolicitacao = async () => {
    try {
      setloading(true);
      await api.get('v1/solicitacao/listaporempresa', { params }).then((response) => {
        setsolicitacao(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
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
    }
    setloading(false);
  };



  const columnsFinanceiro = [
    {
      field: 'idpmts',
      headerName: 'Site',
      width: 100,
      align: 'left',
      type: 'string',
    },
    {
      field: 'nome',
      headerName: 'NOME',
      width: 450,
      align: 'left',
      type: 'string',
    },
    {
      field: 'tipo',
      headerName: 'TIPO',
      width: 140,
      align: 'left',
      type: 'string',
    },
    {
      field: 'descricao',
      headerName: 'DESCRIÇÃO',
      width: 400,
      align: 'left',
      type: 'string',
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

  function deleteclt(stat) {
    console.log(stat);
    settelaexclusaoclt(true);
    setnumeroacio(stat);
    listaatividadeclt();
  }

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
      field: 'datadeenviodoemail',
      headerName: 'Data de Envio do E-mail',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'datadeacionamento',
      headerName: 'Data de Acionamento',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'pagamentoStatus',
      headerName: 'Pagamento status',
      width: 200,
      align: 'center',
      headerAlign: 'center', // Adicione esta linha
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

  const valorpoclt = [
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
          onClick={() => deleteclt(parametros.id)}
        />,
      ],
    },
    {
      field: 'colaboradorclt',
      headerName: 'Colaborador',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'po',
      headerName: 'PO',
      width: 120,
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
      field: 'totalhorasclt',
      headerName: 'Horas Trabalhadas',
      width: 140,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'valorhora',
      headerName: 'Valor Hora',
      width: 100,
      align: 'center',
      type: 'number',
      editable: false,
    },
    {
      field: 'horaxvalor',
      headerName: 'Total Horas X VL Hora',
      width: 170,
      align: 'center',
      type: 'number',
      editable: false,
    },
  ];

  //tabela de colaboradores do atividades CLT
  const columnsclt = [
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
          onClick={() => deleteclt(parametros.id)}
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
      width: 220,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'po',
      headerName: 'PO',
      width: 90,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'descricaoservico',
      headerName: 'Descrição Serviço',
      width: 220,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'totalhorasclt',
      headerName: 'Total de Horas',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
  ];

  //essa tabela aqui
  const columnsescopo = [
    {
      field: 'label',
      headerName: 'Descrição Serviço',
      width: 450,
      align: 'left',
      type: 'string',
      editable: false,
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

  const columnspj = [
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
            onClick={() => deletepj(parametros.id)}
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
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
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

  function deletedespesa(stat) {
    settelaexclusaosolicitacao(true);
    setidentificadorsolicitacao(stat);
  }

  //tabela de dados de despesa do atividades
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
      valueGetter: (parametros) => parametros.value ? new Date(`${parametros.value}T00:00:00`) : null,
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

  function deletediaria(stat) {
    setiddiaria(stat);
    settelaexclusaodiaria(true);
  }

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

  const listaid = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericssonid', { params }).then((response) => {
        setnumero(response.data.numero);
        setrfp(response.data.rfp);
        setcliente(response.data.cliente);
        setregiona(response.data.regiona);
        setsite(response.data.site);
        setfornecedor(response.data.fornecedor);
        setsituacaoimplantacao(response.data.situacaoimplantacao);
        setsituacaodaintegracao(response.data.situacaodaintegracao);
        setdatadacriacaodademandadia(response.data.datadacriacaodademandadia);
        //setdatalimiteaceitedia(response.data.datalimiteaceitedia)
        setdataaceitedemandadia(response.data.dataaceitedemandadia);
        //setdatainicioprevistasolicitantebaselinemosdia(response.data.datainicioprevistasolicitantebaselinemosdia)
        setdatainicioentregamosplanejadodia(response.data.datainicioentregamosplanejadodia);
        setdatarecebimentodositemosreportadodia(response.data.datarecebimentodositemosreportadodia);
        //setdatafimprevistabaselinefiminstalacaodia(response.data.datafimprevistabaselinefiminstalacaodia)
        setdatafiminstalacaoplanejadodia(response.data.datafiminstalacaoplanejadodia);
        setdataconclusaoreportadodia(response.data.dataconclusaoreportadodia);
        setdatavalidacaoinstalacaodia(response.data.datavalidacaoinstalacaodia);
        //setdataintegracaobaselinedia(response.data.dataintegracaobaselinedia)
        setdataintegracaoplanejadodia(response.data.dataintegracaoplanejadodia);
        setdatavalidacaoeriboxedia(response.data.datavalidacaoeriboxedia);
        setemailadcional(response.data.emailacionamento);
        //setlistadepos(response.data.listadepos)
        //setgestordeimplantacaonome(response.data.gestordeimplantacaonome)
        //setstatusrsa(response.data.statusrsa)
        //setrsarsa(response.data.rsarsa)
        //etstatusaceitacao(response.data.statusaceitacao)
        //setdatadefimdaaceitacaosydledia(response.data.datadefimdaaceitacaosydledia)
        //setordemdevenda(response.data.ordemdevenda)
        //setcoordenadoaspnome(response.data.coordenadoaspnome)
        //setrsavalidacaorsanrotrackerdatafimdia(response.data.rsavalidacaorsanrotrackerdatafimdia)
        //setfimdeobraplandia(response.data.fimdeobraplandia)
        //setfimdeobrarealdia(response.data.fimdeobrarealdia)
        //settipoatualizacaofam(response.data.tipoatualizacaofam)
        //setsinergia(response.data.sinergia)
        //setsinergia5g(response.data.sinergia5g)
        //setescoponome(response.data.escoponome)
        //setslapadraoescopodias(response.data.slapadraoescopodias)
        //settempoparalisacaoinstalacaodias(response.data.tempoparalisacaoinstalacaodias)
        //setlocalizacaositeendereco(response.data.localizacaositeendereco)
        //setlocalizacaositecidade(response.data.localizacaositecidade)
        //setdocumentacaosituacao(response.data.documentacaosituacao)
        //setsitepossuirisco(response.data.sitepossuirisco)
        setaceitacao(response.data.aceitacaofical);
        setpendencia(response.data.pendenciasobra);
        // setSelectedOptionfornecedor({ value: response.data.idfornecedor, label: response.data.nomefornecedor }); // Criar  logica de olhar na configuração se vai usar nome razão social ou nome fantasia
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const listalpu = async (idc, icr) => {
    try {
      //  setloading(true);
      await api.get(`v1/projetoericsson/listalpu/${idc}/${icr}`, { params }).then((response) => {
        setlpulista(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      console.log('');
      // setloading(false);
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
      //setemailadcional(stat.adicional)
      listalpu(stat.value);
    } else {
      setidcolaboradorpj(0);
      setcolaboradoremail('');
      setnomecolaboradorpj('');
      setselectedoptioncolaboradorpj({ value: null, label: null });
    }
  };

  const handleChangelpu = (stat) => {
    if (stat !== null) {
      setlpuhistorico(stat.label);
      setselectedoptionlpu({ value: stat.value, label: stat.label });
    } else {
      setlpuhistorico('');
      setselectedoptionlpu({ value: null, label: null });
    }
  };
  function ProcessaCadastro(e) {
    e.preventDefault();
    api
      .post('v1/projetoericsson', {
        numero: ididentificador,
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
      })
      .then((response) => {
        if (response.status === 201) {
          toast.success('Registro Salvo');
          setshow(!show);
          togglecadastro.bind(null);
          atualiza();
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

  const listacolaboradorclt = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/selectcolaboradorclt', { params }).then((response) => {
        setcolaboradorcltlista(response.data);
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
        setcolaboradorpjlista(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
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
          setididentificadortarefa(response.data.retorno);
          settitulotarefa('Cadastro nova tarefa');
          settelacadastrotarefa(true);
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

  function adicionaratividadeclt(e) {
    e.preventDefault();

    if (rowSelectionModel.length > 1) {
      toast.error('Selecione apenas uma atividades clt');
      return;
    }
    const poservico = poservicolista.find((item) => item.id === rowSelectionModel[0]);
    api
      .post('v1/projetoericsson/listaatividadeclt/salva', {
        numero: ididentificador,
        //idposervico, //descrição serviços
        po: poservico?.value,
        //escopo,
        idcolaboradorclt, //colaborador
        datainicioclt,
        datafinalclt,
        observacaoclt,
        totalhorasclt,
        descricaoservico: poservico?.label,
        valorhora,
        horanormalclt,
        hora50clt,
        hora100clt,
      })
      .then((response) => {
        if (response.status === 201) {
          toast.success('Registro Salvo');
          listaatividadeclt();
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

  const salvarpj = async (poit) => {
    api
      .post('v1/projetoericsson/listaatividadepj/salva', {
        numero: ididentificador,
        // idposervico, //descrição serviços
        // po,
        selecao: poit,
        // escopo,
        idcolaboradorpj, //colaborador
        observacaopj,
        //descricaoservico,
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
    const camposExistentes = [];
    rowSelectionModel.forEach((poite) => {
      const existe = atividadepjlista.some((item) => item.poitem.toString() === poite.toString());
      if (!existe) {
        salvarpj(poite);
      } else {
        camposExistentes.push(poite);
      }
    });
    listaatividadepj();
    if (camposExistentes.length > 0) {
      toast.error(
        `Existem campos já inseridos, remova para adicionar os novos. (${camposExistentes.join(
          ', ',
        )})`,
      );
    }
  };

  //abre tela de solicitação de material
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

  const handleSolicitarMaterial = () => {
    if (poservicolista.length === 0) {
      toast.error('Não há itens na tabela.');
    } else {
      novocadastro();
    }
  };

  const handleSolicitarDiaria = () => {
    if (poservicolista.length === 0) {
      toast.error('Não há itens na tabela.');
    } else {
      novocadastro();
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
          setmostra(true);
          setmotivo(1);
          setmensagemtela('Arquivo Anexado');
        } else {
          setretanexo('');
          setmostra(true);
          setmotivo(2);
          setmensagemtela('Erro ao Anexar arquivo!');
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

  const enviaremail = () => {
    if (colaboradoremail == null || colaboradoremail === '' || colaboradoremail === undefined) {
      setmensagemtela('Falta preencher o E-mail!');
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
        .post('v1/email/acionamentopj', {
          destinatario: emailadcional,
          destinatario1: colaboradoremail,
          assunto: 'ACIONAMENTO ERICSSON',
          cliente,
          numero,
          regiona,
          site,
          nomecolaboradorpj,
          retanexo,
          idpessoa: idcolaboradorpj,
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
            toast.error(err.response);
          } else {
            toast.error('Ocorreu um erro na requisição.');
          }
        });
    }
  };

  const acessoFinanceiro = async () => {
    try {
      const response = await api.get('v1/cadusuariosistemaid', { params });
      setEricFechamento(response.data.ericfechamento);
      console.log('o que a rota retorna: ', response.data);
      console.log('o que eu envio: ', params);
    } catch (err) {
      console.error(err.message);
    }
  };

  const iniciatabelas = () => {
    acessoFinanceiro();
    listaid();
    listapormigo();
    listapos();
    listacolaboradorclt();
    listacolaboradorpj();
    listaatividadeclt();
    listaatividadepj();
    listadocumentacaoobrafinal();
    listadocumentacaoobrafinalcivilwork();
    listasolicitacao();
    listasolicitacaodiaria();
  };
  useEffect(() => {
    if (site) {
      despesasrelaotrioericsson();
    }
  }, [site]);

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <Modal
      isOpen={show}
      toggle={togglecadastro.bind(null)}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-fullscreen modal-dialog-scrollable modal-fullscreen "
    >
      <ModalHeader toggle={togglecadastro.bind(null)} style={{ backgroundColor: 'white' }}>
        Cadastro Projeto Ericsson
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
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
        {telacadastrosolicitacaodiaria ? (
          <Solicitardiaria
            show={telacadastrosolicitacaodiaria}
            setshow={settelacadastrosolicitacaodiaria}
            ididentificador={identificadorsolicitacaodiaria}
            atualiza={listasolicitacaodiaria}
            titulotopo={titulodiaria}
            //ver o que é isso aqui:
            novo="0"
            projetousual="ERICSSON"
            numero={numero}
            idlocal={numero}
            sigla={site}
            clientelocal={cliente}
          />
        ) : null}
        {telaatividadeedicao ? (
          <>
            {' '}
            <Atividadeedicao
              show={telaatividadeedicao}
              setshow={settelaatividadeedicao}
              ididentificador={numero}
              titulotopo="Alterar Item"
            />{' '}
          </>
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
        {loading ? (
          <Loader />
        ) : (
          <FormGroup>
            <div className="row g-3">
              <div className="col-sm-2">
                <Input
                  type="hidden"
                  onChange={(e) => setrfp(e.target.value)}
                  value={rfp}
                  placeholder="rfp"
                />
                <div>
                  Número
                  <Input
                    type="text"
                    onChange={(e) => setnumero(e.target.value)}
                    value={numero}
                    placeholder="Numero"
                  />
                </div>
              </div>
              <div className="col-sm-3">
                Cliente
                <Input
                  type="text"
                  onChange={(e) => setcliente(e.target.value)}
                  value={cliente}
                  placeholder="cliente nome"
                />
              </div>
              <div className="col-sm-3">
                Regional
                <Input
                  type="text"
                  onChange={(e) => setregiona(e.target.value)}
                  value={regiona}
                  placeholder="regional nome"
                />
              </div>
              <div className="col-sm-3">
                <Input
                  type="hidden"
                  onChange={(e) => setfornecedor(e.target.value)}
                  value={fornecedor}
                  placeholder="rfp"
                />
                Site
                <Input
                  type="text"
                  onChange={(e) => setsite(e.target.value)}
                  value={site}
                  placeholder="site nome"
                />
              </div>
            </div>

            <Box sx={{ width: '100%' }}>
              <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
                <Tabs value={value} onChange={handleChange} aria-label="basic tabs">
                  <Tab label="Dados da Obra" {...a11yProps(0)} />
                  <Tab label="Documentação Obra" {...a11yProps(1)} />
                  {ericFechamento === 1 && <Tab label="Financeiro" {...a11yProps(2)} />}
                  <Tab label="Atividades" {...a11yProps(3)} />
                </Tabs>
              </Box>

              {/**DADOS DA OBRA */}
              <TabPanel value={value} index={0}>
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
              </TabPanel>

              {/**DOCUMENTAÇÃO OBRA */}
              <TabPanel value={value} index={1}>
                <Label>INSTALAÇÃO (ARQUIVO DOCUMENTAÇÃO DA OBRA FINAL)</Label>
                <Box sx={{ height: 500, width: '100%' }}>
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
                  />
                </Box>
                <br></br>
                <Label>INSTALAÇÃO (ARQUIVO DOCUMENTAÇÃO CIVIL WORK)</Label>
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
                  />
                </Box>
              </TabPanel>

              {/**FINANCEIRO */}
              {ericFechamento === 1 ? (
                <>
                  <TabPanel value={value} index={2}>
                    <Label>ACIONAMENTO ERICSSON (VALOR PO)</Label>
                    <Box sx={{ height: 500, width: '100%' }}>
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
                      />
                    </Box>
                    <br></br>
                    <Label>ACIONAMENTO PJ</Label>
                    <Box sx={{ height: 500, width: '100%' }}>
                      <DataGrid
                        rows={atividadepjlista}
                        columns={valorpopj}
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
                      />
                    </Box>
                    <br></br>
                    <Label>ACIONAMENTO CLT</Label>
                    <Box sx={{ height: 500, width: '100%' }}>
                      <DataGrid
                        rows={atividadecltlista}
                        columns={valorpoclt}
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
                      <Label>FINANCEIRO</Label>
                      <Typography variant="subtitle1" color="text.secondary">
                        <b>Total:</b> R$ {totalfinanceiro ? totalfinanceiro?.toFixed(2) : '0'}
                      </Typography>
                    </div>

                    <Box sx={{ height: 500, width: '100%' }}>
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
                      />
                    </Box>
                  </TabPanel>
                  {/**ATIVIDADES */}
                  <TabPanel value={value} index={3}>
                    <FormGroup>
                      <div className="row g-3">
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
                            //opções traduzidas da tabela
                            localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                          />
                        </Box>
                      </div>
                      <br></br>

                      <Box sx={{ width: '100%' }}>
                        <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
                          <Tabs
                            value={value1}
                            onChange={handleChange1}
                            aria-label="basic tabs example"
                            centered
                          >
                            <Tab label="Mão de Obra CLT" {...a12yProps(0)} />
                            <Tab label="Mão de Obra PJ" {...a12yProps(1)} />
                            <Tab label="Material/Serviço" {...a12yProps(2)} />
                            <Tab label="Diaria" {...a12yProps(3)} />
                          </Tabs>
                        </Box>
                        {/**MÃO DE OBRA CLT */}
                        <TabPanel value={value1} index={0}>
                          Dados do Colaborador CLT
                          <hr />
                          <div className="row g-3">
                            <div className="col-sm-8">
                              Colaborador
                              <Input
                                type="hidden"
                                onChange={(e) => setidcolaboradorclt(e.target.value)}
                                value={idcolaboradorclt}
                                name="idcolaborador"
                              />
                              <Select
                                isClearable
                                isSearchable
                                name="colaboradorclt"
                                options={colaboradorcltlista}
                                placeholder="Selecione"
                                isLoading={loading}
                                onChange={handleChangecolaboradorclt}
                                value={selectedoptioncolaboradorclt}
                              />
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
                          <br></br>
                          <div className=" col-sm-12 d-flex flex-row-reverse">
                            <Button
                              color="primary"
                              onClick={adicionaratividadeclt}
                              disabled={modoVisualizador()}
                            >
                              Adicionar <Icon.Plus />
                            </Button>
                          </div>
                          <br></br>
                          <div className="row g-3">
                            <Box sx={{ height: 400, width: '100%' }}>
                              <DataGrid
                                rows={atividadecltlista}
                                columns={columnsclt}
                                loading={loading}
                                pageSize={pageSize}
                                onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                                disableSelectionOnClick
                                experimentalFeatures={{ newEditingApi: true }}
                                components={{
                                  Pagination: CustomPaginationclt,
                                  LoadingOverlay: LinearProgress,
                                  NoRowsOverlay: CustomNoRowsOverlay,
                                }}
                                //opções traduzidas da tabela
                                localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                              />
                            </Box>
                          </div>
                        </TabPanel>

                        {/**MÃO DE OBRA PJ */}
                        <TabPanel value={value1} index={1}>
                          Dados do Colaborador PJ
                          <hr />
                          <div className="row g-3">
                            <div className="col-sm-6">
                              Empresa
                              <Select
                                isClearable
                                isSearchable
                                name="colaboradorpj"
                                options={colaboradorpjlista}
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
                          <br></br>
                          <div className=" col-sm-12 d-flex flex-row-reverse">
                            <Button color="primary" onClick={svlista} disabled={modoVisualizador()}>
                              Adicionar <Icon.Plus />
                            </Button>
                          </div>
                          <br></br>
                          <div className="row g-3">
                            <Box sx={{ height: 400, width: '100%' }}>
                              <DataGrid
                                rows={atividadepjlista}
                                columns={columnspj}
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
                              //opções traduzidas da tabela
                              // localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                              />
                            </Box>
                            <br></br>
                            <div className="col-sm-12">
                              E-mail PJ
                              <Input
                                type="text"
                                onChange={(e) => setcolaboradoremail(e.target.value)}
                                value={colaboradoremail}
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
                                  <Button color="primary" onClick={uploadanexo}>
                                    Anexar{' '}
                                  </Button>
                                </InputGroup>
                              </div>
                            </div>

                            <br></br>
                            <div className=" col-sm-12 d-flex flex-row-reverse">
                              <Button color="secondary" onClick={enviaremail}>
                                Enviar E-mail de Acionamento <Icon.Mail />
                              </Button>
                            </div>
                            <br></br>
                          </div>
                        </TabPanel>

                        {/**MATERIAL */}
                        <TabPanel value={value1} index={2}>
                          <div className="row g-3">
                            <div className="col-sm-6">Dados de Despesa</div>
                            <div className=" col-sm-6 d-flex flex-row-reverse">
                              <div className=" col-sm-6 d-flex flex-row-reverse">
                                <Button
                                  color="primary"
                                  onClick={() => handleSolicitarMaterial()}
                                  disabled={modoVisualizador()}
                                >
                                  Solicitar Material/Serviço <Icon.Plus />
                                </Button>
                                {telacadastrosolicitacao ? (
                                  <Solicitacaoedicao
                                    show={telacadastrosolicitacao}
                                    setshow={settelacadastrosolicitacao}
                                    ididentificador={identificadorsolicitacao}
                                    atualiza={listasolicitacao}
                                    titulotopo={titulo}
                                    //ver o que é isso aqui:
                                    novo="1"
                                    projetousual="ERICSSON"
                                    numero={numero}
                                  />
                                ) : null}
                                {telacadastroedicaosolicitacao ? (
                                  <>
                                    {' '}
                                    <Solicitacaoedicao
                                      show={telacadastroedicaosolicitacao}
                                      setshow={settelacadastroedicaosolicitacao}
                                      ididentificador={identificadorsolicitacao}
                                      atualiza={listasolicitacao}
                                      titulotopo={titulo}
                                      novo="0"
                                      projetousual="ERICSSON"
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
                                      quemchamou="SOLICITACAOITENS"
                                      atualiza={listasolicitacao}
                                      idlojaatual={localStorage.getItem('sessionloja')}
                                    />{' '}
                                  </>
                                ) : null}
                              </div>
                            </div>
                          </div>
                          <br></br>
                          <div className="row g-3">
                            <Box sx={{ height: 400, width: '100%' }}>
                              <DataGrid
                                rows={solicitacao}
                                columns={columnsdespesa}
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
                              //opções traduzidas da tabela
                              //localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                              />
                            </Box>
                          </div>
                        </TabPanel>
                        {/**diarias*/}
                        <TabPanel value={value1} index={3}>
                          <div className="row g-3">
                            <div className="col-sm-6">Dados da Diaria</div>
                            <div className=" col-sm-6 d-flex flex-row-reverse">
                              <div className=" col-sm-6 d-flex flex-row-reverse">
                                <Button color="primary" onClick={() => novocadastrodiaria()}>
                                  Solicitar Diária <Icon.Plus />
                                </Button>
                                {telacadastrosolicitacao ? (
                                  <Solicitardiaria
                                    show={telacadastrosolicitacao}
                                    setshow={settelacadastrosolicitacao}
                                    ididentificador={identificadorsolicitacao}
                                    atualiza={listasolicitacao}
                                    titulotopo={titulo}
                                    //ver o que é isso aqui:
                                    novo="1"
                                    numero={numero}
                                  />
                                ) : null}
                                {telacadastroedicaosolicitacao ? (
                                  <>
                                    {' '}
                                    <Solicitacaoedicao
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
                                pageSize={pageSize}
                                onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                                disableSelectionOnClick
                                experimentalFeatures={{ newEditingApi: true }}
                                components={{
                                  Pagination: CustomPagination,
                                  LoadingOverlay: LinearProgress,
                                  NoRowsOverlay: CustomNoRowsOverlay,
                                }}
                              //opções traduzidas da tabela
                              //localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                              />
                            </Box>
                          </div>
                        </TabPanel>
                      </Box>
                    </FormGroup>
                  </TabPanel>
                </>
              ) : (
                <>
                  <TabPanel value={value} index={2}>
                    <FormGroup>
                      <div className="row g-3">
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
                            //opções traduzidas da tabela
                            localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                          />
                        </Box>
                      </div>
                      <br></br>

                      <Box sx={{ width: '100%' }}>
                        <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
                          <Tabs
                            value={value1}
                            onChange={handleChange1}
                            aria-label="basic tabs example"
                            centered
                          >
                            <Tab label="Mão de Obra CLT" {...a12yProps(0)} />
                            <Tab label="Mão de Obra PJ" {...a12yProps(1)} />
                            <Tab label="Material/Serviço" {...a12yProps(2)} />
                            <Tab label="Diaria" {...a12yProps(3)} />
                          </Tabs>
                        </Box>
                        {/**MÃO DE OBRA CLT */}
                        <TabPanel value={value1} index={0}>
                          Dados do Colaborador CLT
                          <hr />
                          <div className="row g-3">
                            <div className="col-sm-8">
                              Colaborador
                              <Input
                                type="hidden"
                                onChange={(e) => setidcolaboradorclt(e.target.value)}
                                value={idcolaboradorclt}
                                name="idcolaborador"
                              />
                              <Select
                                isClearable
                                isSearchable
                                name="colaboradorclt"
                                options={colaboradorcltlista}
                                placeholder="Selecione"
                                isLoading={loading}
                                onChange={handleChangecolaboradorclt}
                                value={selectedoptioncolaboradorclt}
                              />
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
                          <br></br>
                          <div className=" col-sm-12 d-flex flex-row-reverse">
                            <Button color="primary" onClick={adicionaratividadeclt}>
                              Adicionar <Icon.Plus />
                            </Button>
                          </div>
                          <br></br>
                          <div className="row g-3">
                            <Box sx={{ height: 400, width: '100%' }}>
                              <DataGrid
                                rows={atividadecltlista}
                                columns={columnsclt}
                                loading={loading}
                                pageSize={pageSize}
                                onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                                disableSelectionOnClick
                                experimentalFeatures={{ newEditingApi: true }}
                                components={{
                                  Pagination: CustomPaginationclt,
                                  LoadingOverlay: LinearProgress,
                                  NoRowsOverlay: CustomNoRowsOverlay,
                                }}
                                //opções traduzidas da tabela
                                localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                              />
                            </Box>
                          </div>
                        </TabPanel>

                        {/**MÃO DE OBRA PJ */}
                        <TabPanel value={value1} index={1}>
                          Dados do Colaborador PJ
                          <hr />
                          <div className="row g-3">
                            <div className="col-sm-6">
                              Empresa
                              <Select
                                isClearable
                                isSearchable
                                name="colaboradorpj"
                                options={colaboradorpjlista}
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
                          <br></br>
                          <div className=" col-sm-12 d-flex flex-row-reverse">
                            <Button color="primary" onClick={svlista} disabled={modoVisualizador()}>
                              Adicionar <Icon.Plus />
                            </Button>
                          </div>
                          <br></br>
                          <div className="row g-3">
                            <Box sx={{ height: 400, width: '100%' }}>
                              <DataGrid
                                rows={atividadepjlista}
                                columns={columnspj}
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
                              //opções traduzidas da tabela
                              // localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                              />
                            </Box>
                            <br></br>
                            <div className="col-sm-12">
                              E-mail PJ
                              <Input
                                type="text"
                                onChange={(e) => setcolaboradoremail(e.target.value)}
                                value={colaboradoremail}
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
                                  <Button color="primary" onClick={uploadanexo}>
                                    Anexar{' '}
                                  </Button>
                                </InputGroup>
                              </div>
                            </div>

                            <br></br>
                            <div className=" col-sm-12 d-flex flex-row-reverse">
                              <Button color="secondary" onClick={enviaremail}>
                                Enviar E-mail de Acionamento <Icon.Mail />
                              </Button>
                            </div>
                            <br></br>
                          </div>
                        </TabPanel>

                        {/**MATERIAL */}
                        <TabPanel value={value1} index={2}>
                          <div className="row g-3">
                            <div className="col-sm-6">Dados de Despesa</div>
                            <div className=" col-sm-6 d-flex flex-row-reverse">
                              <div className=" col-sm-6 d-flex flex-row-reverse">
                                <Button
                                  color="primary"
                                  onClick={() => handleSolicitarMaterial()}
                                  disabled={modoVisualizador()}
                                >
                                  Solicitar Material/Serviço <Icon.Plus />
                                </Button>
                                {telacadastrosolicitacao ? (
                                  <Solicitacaoedicao
                                    show={telacadastrosolicitacao}
                                    setshow={settelacadastrosolicitacao}
                                    ididentificador={identificadorsolicitacao}
                                    atualiza={listasolicitacao}
                                    titulotopo={titulo}
                                    //ver o que é isso aqui:
                                    novo="1"
                                    numero={numero}
                                  />
                                ) : null}
                                {telacadastroedicaosolicitacao ? (
                                  <>
                                    {' '}
                                    <Solicitacaoedicao
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
                                      quemchamou="SOLICITACAOITENS"
                                      atualiza={listasolicitacao}
                                      idlojaatual={localStorage.getItem('sessionloja')}
                                    />{' '}
                                  </>
                                ) : null}
                              </div>
                            </div>
                          </div>
                          <br></br>
                          <div className="row g-3">
                            <Box sx={{ height: 400, width: '100%' }}>
                              <DataGrid
                                rows={solicitacao}
                                columns={columnsdespesa}
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
                              //opções traduzidas da tabela
                              //localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                              />
                            </Box>
                          </div>
                        </TabPanel>

                        {/**diarias*/}
                        <TabPanel value={value1} index={3}>
                          <div className="row g-3">
                            <div className="col-sm-6">Dados da Diaria</div>
                            <div className=" col-sm-6 d-flex flex-row-reverse">
                              <div className=" col-sm-6 d-flex flex-row-reverse">
                                <Button color="primary" onClick={() => handleSolicitarDiaria()}>
                                  Solicitar Diária <Icon.Plus />
                                </Button>
                                {telacadastrosolicitacao ? (
                                  <Solicitardiaria
                                    show={telacadastrosolicitacao}
                                    setshow={settelacadastrosolicitacao}
                                    ididentificador={identificadorsolicitacao}
                                    atualiza={listasolicitacao}
                                    titulotopo={titulo}
                                    //ver o que é isso aqui:
                                    novo="1"
                                    numero={numero}
                                  />
                                ) : null}
                                {telacadastroedicaosolicitacao ? (
                                  <>
                                    {' '}
                                    <Solicitacaoedicao
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
                              </div>
                            </div>
                          </div>
                          <br></br>
                          <div className="row g-3">
                            <Box sx={{ height: 400, width: '100%' }}>
                              <DataGrid
                                rows={solicitacao}
                                columns={colunasdiarias}
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
                              //opções traduzidas da tabela
                              //localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                              />
                            </Box>
                          </div>
                        </TabPanel>
                      </Box>
                    </FormGroup>
                  </TabPanel>
                </>
              )}
            </Box>
          </FormGroup>
        )}
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
  );
};

Ericssonedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  ididentificador2: PropTypes.number,
  idsite: PropTypes.string,
  atualiza: PropTypes.node,
};

export default Ericssonedicao;

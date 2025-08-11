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
import EditIcon from '@mui/icons-material/Edit';
//import SearchIcon from '@mui/icons-material/Search';
import * as Icon from 'react-feather';
import DeleteIcon from '@mui/icons-material/Delete';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Box from '@mui/material/Box';
import Select from 'react-select';
import Typography from '@mui/material/Typography';
import PropTypes from 'prop-types';
import { toast, ToastContainer } from 'react-toastify';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import './textearea.css';
import Atividadeedicao from './Atividadeedicao';
import Excluirregistro from '../../Excluirregistro';
import Solicitacaoedicao from '../suprimento/Solicitacaoedicao';
import Mensagemsimples from '../../Mensagemsimples';
import Solicitardiaria from './Solicitardiaria';
import Huaweiedicaotarefa from './Huaweiedicaotarefa';
import modoVisualizador from '../../../services/modovisualizador';

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

const HuaweiEdicao = ({
  setshow,
  show,
  ididentificador,
  atualiza,
  idsite,
  sn,
  oslocal,
  titulo,
  reg,
  sta,
  sid,
}) => {
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
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setloading] = useState(false);
  const [loadingpj, setloadingpj] = useState(false);
  const [pageSize, setPageSize] = useState(10);
  const [numero, setnumero] = useState('');
  const [idcolaboradorclt, setidcolaboradorclt] = useState('');
  const [idcolaboradorpj, setidcolaboradorpj] = useState('');
  const [nomecolaboradorpj, setnomecolaboradorpj] = useState('');
  const [colaboradoremail, setcolaboradoremail] = useState('');
  const [telacadastrotarefaedicao, settelacadastrotarefaedicao] = useState('');
  const [telacadastrotarefa, settelacadastrotarefa] = useState('');

  const [datainicioclt, setdatainicioclt] = useState(Date);
  const [datafinalclt, setdatafinalclt] = useState(Date);

  const [totalhorasclt, settotalhorasclt] = useState('');
  const [observacaoclt, setobservacaoclt] = useState('');
  const [observacaopj, setobservacaopj] = useState('');
  const [titulomaterial, settitulomaterial] = useState('');
  //const [titulodiaria, settitulodiaria] = useState('');
  const [telacadastrosolicitacao, settelacadastrosolicitacao] = useState('');
  const [telacadastroedicaosolicitacao, settelacadastroedicaosolicitacao] = useState('');
  const [telaexclusaosolicitacao, settelaexclusaosolicitacao] = useState('');
  const [solicitacao, setsolicitacao] = useState([]);
  const [rowSelectionModel, setRowSelectionModel] = useState([]);
  const [mostra, setmostra] = useState('');
  const [motivo, setmotivo] = useState('');
  const [mensagemtela, setmensagemtela] = useState('');
  //  const [lpulista, setlpulista] = useState([]);
  const [identificadorsolicitacao, setidentificadorsolicitacao] = useState('');
  const [selectedoptioncolaboradorclt, setselectedoptioncolaboradorclt] = useState(null);
  const [selectedoptioncolaboradorpj, setselectedoptioncolaboradorpj] = useState(null);
  const [selectedoptionlpu, setselectedoptionlpu] = useState(null);
  const [atividadecltlista, setatividadecltlista] = useState([]);
  const [atividadepjlista, setatividadepjlista] = useState([]);
  const [telaatividadeedicao, settelaatividadeedicao] = useState('');
  const [valorhora, setvalorhora] = useState('');
  const [horanormalclt, sethoranormalclt] = useState('');
  const [hora50clt, sethora50clt] = useState('');
  const [hora100clt, sethora100clt] = useState('');
  const [emailadcional, setemailadcional] = useState(''); //('anna.christina@telequipeprojetos.com.br;ingrid.santos@telequipeprojetos.com.br;alex.costa@telequipeprojetos.com.br');
  const [lpuhistorico, setlpuhistorico] = useState('');
  const [valornegociado, setvalornegociado] = useState(0.0);
  const [arquivoanexo, setarquivoanexo] = useState('');
  const [retanexo, setretanexo] = useState('');
  const [ericFechamento, setEricFechamento] = useState(''); // Armazena apenas o valor de ericfechamento
  const [poservicolista, setposervicolista] = useState([]);
  const [os, setos] = useState('');
  // const [regiao, setregiao] = useState('');
  const [porcentagempj, setporcentagempj] = useState(60);

  const [id, setid] = useState('');

  const [projectno, setprojectno] = useState('');
  const [region, setregion] = useState('');
  const [state, setstate] = useState('');
  const [sitename, setsitename] = useState('');
  const [siteid, setsiteid] = useState('');
  const [sitecode, setsitecode] = useState('');
  const [opnegociado, setopnegociado] = useState('');

  const [colaboradorcltlista, setcolaboradorcltlista] = useState([]);
  const [colaboradorpjlista, setcolaboradorpjlista] = useState([]);

  const [observacao, setobservacao] = useState('');

  const [publishdate, setpublishdate] = useState('');
  const [needbydate, setneedbydate] = useState('');
  const [approveddate, setapproveddate] = useState('');
  const [startdate, setstartdate] = useState('');
  const [creationdate, setcreationdate] = useState('');
  const [lastupdatedate, setlastupdatedate] = useState('');
  const [responsedate, setresponsedate] = useState('');
  const [promisedate, setpromisedate] = useState('');
  const [firstpromisedate, setfirstpromisedate] = useState('');
  const [opendate, setopendate] = useState('');
  const [dataacionamento, setdataacionamento] = useState('');
  const [dataenvioemail, setdataenvioemail] = useState('');
  const [authorizationstatus, setauthorizationstatus] = useState('');
  const [shipmentstatus, setshipmentstatus] = useState('');
  const [closedcode, setclosedcode] = useState('');

  const togglecadastro = () => {
    setshow(!show);
  };

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idlocal: ididentificador,
    site: idsite,
    idprojetoericsson: ididentificador,
    idcontroleacessobusca: localStorage.getItem('sessionId'),
    idempresas: idcolaboradorpj,
    siteid: sid,
    deletado: 0,
    obra: numero,
    osouobra: oslocal,
    sn1: sn,
    pros: oslocal,
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

    return (
      <Pagination
        color="primary"
        count={pageCount}
        page={page + 1}
        //onChange={(event, value) => apiRef.current.setPage(value - 1)}
      />
    );
  }

  function CustomPaginationclt() {
    const apiRef = useGridApiContext();
    const page = useGridSelector(apiRef, gridPageSelector);
    const pageCount = useGridSelector(apiRef, gridPageCountSelector);
    return (
      <>
        <Pagination color="primary" count={pageCount} page={page + 1} />
      </>
    );
  }

  const listaatividadeclt = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/listaatividadeclt', { params }).then((response) => {
        setatividadecltlista(response.data);
        setselectedoptioncolaboradorclt({
          value: response.data.idcolaboradorclt,
          label: response.data.colaboradorclt,
        });
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listaacionamento = async () => {
    try {
      setloadingpj(true);
      await api.get('v1/projetohuawei/listaacionamento', { params }).then((response) => {
        setatividadepjlista(response.data);
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloadingpj(false);
    }
  };

  const listasolicitacao = async () => {
    try {
      setloading(true);
      await api.get('v1/solicitacaoid', { params }).then((response) => {
        setsolicitacao(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  function listatarefa() {
    settelacadastrotarefa(true);
  }

  function deleteclt(stat) {
    settelaexclusaoclt(true);
    setnumero(stat);
    listaatividadeclt();
  }

  function deletepj(stat) {
    console.log(stat);
    settelaexclusaopj(true);
    setnumero(stat);
    listaacionamento();
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
                setmensagem('Já houve pagamento');
                setTimeout(() => {
                  setmensagem('');
                }, 5000);
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
      field: 'ponumber',
      headerName: 'PO NUMBER',
      width: 180,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'itemcode',
      headerName: 'ITEM CODE',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'itemdescription',
      headerName: 'ITEM DESCRIPTION',
      width: 450,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'quantity',
      headerName: 'QTY',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'unitofmeasure',
      headerName: 'UNIT OF MEASURE',
      width: 150,
      align: 'center',
      type: 'string',
      editable: false,
    },
    {
      field: 'cancelflag',
      headerName: 'CANCELADO',
      width: 110,
      align: 'center',
      type: 'string',
      editable: false,
    },
    {
      field: 'quantitycancelled',
      headerName: 'QTD CANCELADA',
      width: 150,
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
              disabled={modoVisualizador()}
              onClick={(event) => {
                event.stopPropagation();
                setmensagem('Já houve pagamento');
                setTimeout(() => {
                  setmensagem('');
                }, 5000);
              }}
            />,
          ];
        }
        return [
          <GridActionsCellItem
            icon={<DeleteIcon />}
            label="Delete"
            disabled={modoVisualizador()}
            title="Delete"
            onClick={() => deletepj(parametros.id)}
          />,
        ];
      },
    },
    {
      field: 'nome',
      headerName: 'Empresa',
      width: 250,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'ponumber',
      headerName: 'PO NUMBER',
      width: 180,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'itemcode',
      headerName: 'ITEM CODE',
      width: 150,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'itemdescription',
      headerName: 'ITEM DESCRIPTION',
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
      field: 'dataenvioemail',
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
  function alterardespesa(stat) {
    settelacadastroedicaosolicitacao(true);
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
          icon={<EditIcon />}
          label="Alterar"
          title="Alterar"
          onClick={() => alterardespesa(parametros.id)}
        />,
        <GridActionsCellItem
          icon={<DeleteIcon />}
          label="Delete"
          disabled={modoVisualizador()}
          title="Delete"
          onClick={() => deletedespesa(parametros.id)}
        />,
      ],
    },
    { field: 'id', headerName: 'ID', width: 60, align: 'center' },
    {
      field: 'data',
      headerName: 'Data',
      type: 'center',
      width: 100,
      align: 'left',
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

  //tabela de dados de despesa diarias
  const columnsdiarias = [
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
      type: 'string',
      width: 80,
      align: 'left',
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
      field: 'projeto',
      headerName: 'Projeto',
      type: 'string',
      width: 150,
      align: 'right',
      editable: false,
    },
    {
      field: 'siteid',
      headerName: 'Siteid',
      type: 'string',
      width: 80,
      align: 'center',
      editable: false,
    },
    {
      field: 'siglasite',
      headerName: 'Sigla Site',
      type: 'string',
      width: 80,
      align: 'center',
      editable: false,
    },
    {
      field: 'PO',
      headerName: 'PO',
      type: 'string',
      width: 100,
      align: 'center',
      editable: false,
    },
    {
      field: 'local',
      headerName: 'Local',
      type: 'string',
      width: 150,
      align: 'center',
      editable: false,
    },
    {
      field: 'descricao',
      headerName: 'Descrição',
      type: 'string',
      width: 150,
      align: 'center',
      editable: false,
    },
    {
      field: 'cliente',
      headerName: 'Cliente',
      type: 'string',
      width: 150,
      align: 'center',
      editable: false,
    },
    {
      field: 'valoroutrassolicitacoes',
      headerName: 'Outras Solicitações',
      type: 'string',
      width: 150,
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

  const listapos = async () => {
    try {
      setloading(true);
      await api.get('v1/projetohuaweipo', { params }).then((response) => {
        setposervicolista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listaid = async () => {
    try {
      setloading(true);

      const response = await api.get('v1/projetohuaweiid', { params });
      const { data } = response;

      setprojectno(data.projectno);
      setregion(data.biddingarea);
      setsiteid(data.siteid);
      setsitename(data.sitename);
      setsitecode(data.sitecode);
      setid(data.id);

      setpublishdate(data.publishdate);
      setneedbydate(data.needbydate);
      setapproveddate(data.approveddate);
      setstartdate(data.startdate);
      setcreationdate(data.creationdate);
      setlastupdatedate(data.lastupdatedate);
      setresponsedate(data.responsedate);
      setpromisedate(data.promisedate);
      setfirstpromisedate(data.firstpromisedate);
      setopendate(data.opendate);

      setdataacionamento(data.dataacionamento);
      setdataenvioemail(data.dataenvioemail);

      setauthorizationstatus(data.authorizationstatus);
      setshipmentstatus(data.shipmentstatus);
      setclosedcode(data.closedcode);
      setobservacao(data.observacaogeral);

      listapos();
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
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
      // listalpu();
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
    setmensagem('');
    setmensagemsucesso('');

    api
      .post('v1/projetohuawei', {
        id: ididentificador,
        observacao,
      })
      .then((response) => {
        if (response.status === 201) {
          toast.success('Registro Salvo');
          setmensagemsucesso('Registro Salvo');

          setTimeout(() => {
            togglecadastro();
          }, 2000);

          atualiza();
        } else {
          setmensagem(`Erro: ${response.status}`);
          setmensagemsucesso('');
        }
      })
      .catch((err) => {
        if (err.response && err.response.data && err.response.data.erro) {
          toast.error(err.response.data.erro);
          setmensagem(err.response.data.erro);
        } else {
          toast.error('Erro ao salvar registro.');
          setmensagem('Ocorreu um erro na requisição.');
        }
        setmensagemsucesso('');
      });
  }

  const listacolaboradorclt = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/selectcolaboradorclt', { params }).then((response) => {
        setcolaboradorcltlista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listacolaboradorpj = async () => {
    try {
      setloading(true);
      await api.get('v1/empresas/selectpj', { params }).then((response) => {
        setcolaboradorpjlista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  function adicionaratividadeclt(e) {
    e.preventDefault();
    setmensagem('');
    setmensagemsucesso('');
    if (rowSelectionModel.length > 1) {
      toast.error('Selecione apenas uma atividades clt');
      return;
    }
    const poservico = poservicolista.find((item) => item.id === rowSelectionModel[0]);
    console.log(poservico);
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
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          listaatividadeclt();
        } else {
          setmensagem(response.status);
          setmensagemsucesso('');
        }
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(err.response.data.erro);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
        setmensagemsucesso('');
      });
  }

  const salvarpj = async (poit) => {
    api
      .post('v1/projetohuawei/listaatividadepj/salva', {
        selecao: poit,
        os,
        porcentagempj,
        idcolaboradorpj,
        observacaopj,
        opnegociado,
        valornegociadonum: valornegociado.toString().replace('.', ','),
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          listaacionamento();
          listapos();
        } else {
          setmensagem(response.status);
          setmensagemsucesso('');
        }
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(err.response.data.erro);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
        setmensagemsucesso('');
      });
  };

  const svlista = async () => {
    try {
      if (!rowSelectionModel || rowSelectionModel.length === 0) {
        setmensagem('Selecione um ou mais itens para salvar');
        setmensagemsucesso('');
      } else {
        // Salva os itens selecionados
        await Promise.all(rowSelectionModel.map((poite) => salvarpj(poite)));

        // Atualiza as listas
        listaacionamento();
        listapos();

        // Exibe mensagem de sucesso
        setmensagem('');
        setmensagemsucesso('Itens salvos com sucesso!');
      }
    } catch (error) {
      console.error('Erro ao salvar itens:', error);
      setmensagem('Ocorreu um erro ao salvar os itens.');
      setmensagemsucesso('');
    }
  };

  //abre tela de solicitação de material
  const novocadastromaterial = () => {
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
          settitulomaterial('Cadastrar Solicitação de Produto');
          settelacadastrosolicitacao(true);
        } else {
          setmensagem(response.status);
        }
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(err.response.data.erro);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
      });
  };

  const handleSolicitarMaterial = () => {
    if (atividadepjlista.length === 0 && atividadecltlista.length === 0) {
      setmensagem('Não é possivel solicitar material sem acionamento de algum item !');
    } else {
      setmensagem('');
      novocadastromaterial();
    }
  };

  const handleSolicitarDiaria = () => {
    setmensagem('');
    // novocadastrodiaria();
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
        setmensagem(err.message);
        setmensagemsucesso('');
      } else {
        setmensagem('Erro: Tente novamente mais tarde!');
        setmensagemsucesso('');
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
      setmensagem('');
      setmensagemsucesso('');

      api
        .post('v1/email/acionamentopjhuawei', {
          destinatario: emailadcional,
          destinatario1: colaboradoremail,
          assunto: 'ACIONAMENTO PROJETO HUAWEI',
          os,
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
            setmensagem(err.response);
          } else {
            setmensagem('Ocorreu um erro na requisição.');
          }
          setmensagemsucesso('');
        });
    }
  };

  /*  const acessoFinanceiro = async () => {
      try {
        const response = await api.get('v1/cadusuariosistemaid', { params });
        setEricFechamento(response.data.ericfechamento);
      } catch (err) {
        console.error(err.message);
      }
    }  */

  console.log(setEricFechamento);

  const iniciatabelas = () => {
    if (titulo === 'Cadastrando HUAWEI') {
      setsitename(sn);
      setregion(reg);
      setstate(sta);
      setsiteid(sid);
      setos(oslocal);
      listaacionamento();
    } else {
      listaid();
      setos(oslocal);
      listacolaboradorclt();
      listacolaboradorpj();
      listaacionamento();
      listaatividadeclt();
    }
  };

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
        {titulo}
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
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
        {mensagemsucesso.length > 0 ? (
          <div className="alert alert-success" role="alert">
            {' '}
            Registro Salvo
          </div>
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
              ididentificador={numero}
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
              ididentificador={numero}
              quemchamou="ATIVIDADEPJ"
              atualiza={listaacionamento}
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

        {telacadastrotarefaedicao ? (
          <>
            <Huaweiedicaotarefa
              show={telacadastrotarefaedicao}
              setshow={settelacadastrotarefaedicao}
              ididentificador={ididentificador}
              region={region}
              atualiza={listapos}
            />
          </>
        ) : null}

        {telacadastrotarefa ? (
          <>
            <Huaweiedicaotarefa
              show={telacadastrotarefa}
              setshow={settelacadastrotarefa}
              ididentificador={ididentificador}
              regionlocal={region}
              sitenamelocal={sitename}
              estadolocal={state}
              siteidlocal={siteid}
              oslocal={os}
              projectnolocal={projectno}
              atualiza={listapos}
              sitecodelocal={sitecode}
              titulotopo="Criar Tarefa"
            />
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
                  onChange={(e) => setid(e.target.value)}
                  value={id}
                  placeholder="id"
                />
                Project No
                <Input
                  type="text"
                  onChange={(e) => setprojectno(e.target.value)}
                  value={projectno}
                  disabled={titulo !== 'Cadastrando HUAWEI'}
                />
              </div>
              <div className="col-sm-5">
                Site Name
                <Input
                  type="text"
                  onChange={(e) => setsitename(e.target.value)}
                  value={sitename}
                  disabled="true"
                />
              </div>
              <div className="col-sm-3">
                Site ID
                <Input
                  type="text"
                  onChange={(e) => setsiteid(e.target.value)}
                  value={siteid}
                  disabled={titulo === 'Cadastrando HUAWEI'}
                />
              </div>

              <div className="col-sm-2">
                Região
                <Input
                  type="text"
                  onChange={(e) => setregion(e.target.value)}
                  value={region}
                  disabled="true"
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
                {/* OS */}
                <div className="row g-3 mb-3">
                  <div className="col-sm-3">
                    OS
                    <Input
                      type="text"
                      value={os}
                      onChange={(e) => setos(e.target.value)}
                      placeholder="OS"
                      disabled
                    />
                  </div>
                </div>

                {/* Datas principais */}
                <div className="row g-3 mb-3">
                  <div className="col-sm-3">
                    Data de Publicação
                    <Input
                      type="datetime-local"
                      value={publishdate}
                      onChange={(e) => setpublishdate(e.target.value)}
                      disabled
                    />
                  </div>
                  <div className="col-sm-3">
                    Data Necessária
                    <Input
                      type="datetime-local"
                      value={needbydate}
                      onChange={(e) => setneedbydate(e.target.value)}
                      disabled
                    />
                  </div>
                  <div className="col-sm-3">
                    Data de Aprovação
                    <Input
                      type="datetime-local"
                      value={approveddate}
                      onChange={(e) => setapproveddate(e.target.value)}
                      disabled
                    />
                  </div>
                  <div className="col-sm-3">
                    Data de Criação
                    <Input
                      type="datetime-local"
                      value={creationdate}
                      onChange={(e) => setcreationdate(e.target.value)}
                      disabled
                    />
                  </div>
                </div>

                {/* Criação e atualização */}
                <div className="row g-3 mb-3">
                  <div className="col-sm-3">
                    Data de Início
                    <Input
                      type="date"
                      value={startdate}
                      onChange={(e) => setstartdate(e.target.value)}
                      disabled
                    />
                  </div>

                  <div className="col-sm-3">
                    Última Atualização
                    <Input
                      type="datetime-local"
                      value={lastupdatedate}
                      onChange={(e) => setlastupdatedate(e.target.value)}
                      disabled
                    />
                  </div>

                  <div className="col-sm-3">
                    Data de Resposta
                    <Input
                      type="datetime-local"
                      value={responsedate}
                      onChange={(e) => setresponsedate(e.target.value)}
                      disabled
                    />
                  </div>
                  <div className="col-sm-3">
                    Data Prometida
                    <Input
                      type="datetime-local"
                      value={promisedate}
                      onChange={(e) => setpromisedate(e.target.value)}
                      disabled
                    />
                  </div>
                  <div className="col-sm-3">
                    Primeira Data Prometida
                    <Input
                      type="datetime-local"
                      value={firstpromisedate}
                      onChange={(e) => setfirstpromisedate(e.target.value)}
                      disabled
                    />
                  </div>
                  <div className="col-sm-3">
                    Data de Abertura
                    <Input
                      type="datetime-local"
                      value={opendate}
                      onChange={(e) => setopendate(e.target.value)}
                      disabled
                    />
                  </div>

                  <div className="col-sm-3">
                    Data de Acionamento
                    <Input
                      type="datetime-local"
                      value={dataacionamento}
                      onChange={(e) => setdataacionamento(e.target.value)}
                      disabled
                    />
                  </div>
                  <div className="col-sm-3">
                    Data de Envio de Email
                    <Input
                      type="datetime-local"
                      value={dataenvioemail}
                      onChange={(e) => setdataenvioemail(e.target.value)}
                      disabled
                    />
                  </div>
                </div>

                {/* Status */}
                <div className="row g-3 mb-3">
                  <div className="col-sm-3">
                    Status de Autorização
                    <Input
                      type="text"
                      value={authorizationstatus}
                      onChange={(e) => setauthorizationstatus(e.target.value)}
                      disabled
                    />
                  </div>
                  <div className="col-sm-3">
                    Status da Remessa
                    <Input
                      type="text"
                      value={shipmentstatus}
                      onChange={(e) => setshipmentstatus(e.target.value)}
                      disabled
                    />
                  </div>
                  <div className="col-sm-3">
                    Código de Fechamento
                    <Input
                      type="text"
                      value={closedcode}
                      onChange={(e) => setclosedcode(e.target.value)}
                      disabled
                    />
                  </div>
                </div>

                {/* Observação */}
                <div className="row g-3 mb-3">
                  <div className="col-sm-12">
                    Observação
                    <Input
                      type="textarea"
                      value={observacao}
                      onChange={(e) => setobservacao(e.target.value)}
                      placeholder="Observação"
                    />
                  </div>
                </div>
              </TabPanel>

              {/**DOCUMENTAÇÃO OBRA */}
              <TabPanel value={value} index={1}>
                {/* <Label>INSTALAÇÃO (ARQUIVO DOCUMENTAÇÃO DA OBRA FINAL)</Label>
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
                </Box> */}
              </TabPanel>

              {/**FINANCEIRO */}
              {ericFechamento === 1 ? (
                <>
                  <TabPanel value={value} index={2}>
                    {/*  <Label>ACIONAMENTO ERICSSON (VALOR PO)</Label>
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
                  </Box>*/}
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
                  </TabPanel>
                  {/**ATIVIDADES */}
                  <TabPanel value={value} index={3}>
                    <FormGroup>
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
                            <div className="col-sm-4">
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
                            <div className="col-sm-2">
                              Região
                              <Input type="select">
                                <option value="Selecionar">Selecionar</option>
                                <option value="CAPITAL">CAPITAL</option>
                                <option value="INTERIOR">INTERIOR</option>
                              </Input>
                            </div>

                            <div className="col-sm-4">
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
                                /* options={lpulista} */
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
                            <Button color="primary">
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
                                <Button color="primary" onClick={() => handleSolicitarMaterial()}>
                                  Solicitar Material/Serviço <Icon.Plus />
                                </Button>
                                {telacadastrosolicitacao ? (
                                  <Solicitacaoedicao
                                    show={telacadastrosolicitacao}
                                    setshow={settelacadastrosolicitacao}
                                    ididentificador={identificadorsolicitacao}
                                    atualiza={listasolicitacao}
                                    titulotopo={titulomaterial}
                                    //ver o que é isso aqui:
                                    oslocal={os}
                                    novo="1"
                                    projetousual="HUAWEI"
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
                                      titulotopo={titulomaterial}
                                      oslocal={os}
                                      novo="0"
                                      projetousual="HUAWEI"
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
                                    titulotopo={titulomaterial}
                                    //ver o que é isso aqui:
                                    novo="1"
                                    numero={numero}
                                    oslocal={os}
                                    projetousual="HUAWEI"
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
                                      titulotopo={titulomaterial}
                                      novo="0"
                                      numero={numero}
                                      oslocal={os}
                                      projetousual="HUAWEI"
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
                                columns={columnsdiarias}
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
                      <>
                        <div className="row g-3">
                          <div className=" col-sm-12  d-flex flex-row-reverse">
                            <Button color="primary" onClick={listatarefa}>
                              Adicionar Tarefas <Icon.Plus />
                            </Button>
                          </div>
                        </div>
                      </>

                      <br />
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
                            <div className="col-sm-4">
                              <FormGroup check>
                                <Input
                                  type="checkbox"
                                  id="check1"
                                  checked={opnegociado}
                                  onChange={(e) => setopnegociado(e.target.checked)}
                                />
                                <Label check>Selecione para opção valor negociado</Label>
                              </FormGroup>
                            </div>
                          </div>
                          <div className="row g-3">
                            <div className="col-sm-4">
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
                            {opnegociado ? (
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
                            ) : (
                              <>
                                <div className="col-sm-2">
                                  Porcentagem
                                  <Input
                                    type="number"
                                    name="porcentagem"
                                    onChange={(e) => setporcentagempj(e.target.value)}
                                    value={porcentagempj}
                                  ></Input>
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
                            <Button color="primary" onClick={svlista}>
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
                                <Button color="primary" onClick={() => handleSolicitarMaterial()}>
                                  Solicitar Material/Serviço <Icon.Plus />
                                </Button>
                                {telacadastrosolicitacao ? (
                                  <Solicitacaoedicao
                                    show={telacadastrosolicitacao}
                                    setshow={settelacadastrosolicitacao}
                                    ididentificador={identificadorsolicitacao}
                                    atualiza={listasolicitacao}
                                    titulotopo={titulomaterial}
                                    projetousual="HUAWEI"
                                    //ver o que é isso aqui:
                                    novo="1"
                                    numero={ididentificador}
                                    oslocal={os}
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
                                      titulotopo={titulomaterial}
                                      projetousual="HUAWEI"
                                      novo="0"
                                      numero={ididentificador}
                                      oslocal={os}
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
                                <Button
                                  color="primary"
                                  onClick={() => handleSolicitarDiaria()}
                                  disabled={modoVisualizador()}
                                >
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
                                columns={columnsdiarias}
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

HuaweiEdicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  ididentificador2: PropTypes.number,
  idsite: PropTypes.string,
  atualiza: PropTypes.node,
  sn: PropTypes.string,
  oslocal: PropTypes.string,
  titulo: PropTypes.string,
  snf: PropTypes.string,
  reg: PropTypes.string,
  sta: PropTypes.string,
  sid: PropTypes.string,
};

export default HuaweiEdicao;

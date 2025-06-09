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
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import './textearea.css';
import Atividadeedicao from './Atividadeedicao';
import Excluirregistro from '../../Excluirregistro';
import Solicitacaoedicao from '../suprimento/Solicitacaoedicao';
import Mensagemsimples from '../../Mensagemsimples';
import Solicitardiaria from './Solicitardiaria';
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

const Cosmxedicao = ({ setshow, show, ididentificador, ididentificador2, atualiza, idsite }) => {
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
  const [listamigo, setlistamigo] = useState([]);
  const [lpulista, setlpulista] = useState([]);
  const [numero, setnumero] = useState('');
  const [regiona, setregiona] = useState('');
  const [siteid, setsiteid] = useState('');
  const [sitefromto, setsitefromto] = useState('');
  const [endereco, setendereco] = useState('');
  const [cidade, setcidade] = useState('');
  const [observacao, setobservacao] = useState('');
  const [infrasyte, setinfrasyte] = useState('');
  const [typesite, settypesite] = useState('');
  const [batsw, setbatsw] = useState('');
  const [qty, setqty] = useState('');
  const [owner, setowner] = useState('');
  const [installedby, setinstalledby] = useState('');
  const [uf, setuf] = useState('');

  const [idempresa, setidempresa] = useState('');
  const [lpu, setlpu] = useState('');
  const [inicioatividadeplanejado, setinicioatividadeplanejado] = useState('');
  const [inicioatividadereal, setinicioatividadereal] = useState('');
  const [nomerelatorioenviado1, setnomerelatorioenviado1] = useState('');
  const [dataenvio1, setdataenvio1] = useState('');
  const [enviadopor1, setenviadopor1] = useState('');
  const [status1, setstatus1] = useState('');
  const [nomerelatorioenviado2, setnomerelatorioenviado2] = useState('');
  const [dataenvio2, setdataenvio2] = useState('');
  const [enviadopor2, setenviadopor2] = useState('');
  const [status2, setstatus2] = useState('');
  const [aprovacaocosmx, setaprovacaocosmx] = useState('');
  const [valorlpu, setvalorlpu] = useState('');
  const [po, setpo] = useState('');

  const [idcolaboradorclt, setidcolaboradorclt] = useState('');
  const [colaboradoremail, setcolaboradoremail] = useState('');

  const [datainicioclt, setdatainicioclt] = useState(Date);
  const [datafinalclt, setdatafinalclt] = useState(Date);

  const [totalhorasclt, settotalhorasclt] = useState('');
  const [observacaoclt, setobservacaoclt] = useState('');
  const [observacaopj, setobservacaopj] = useState('');
  const [titulo, settitulo] = useState('');
  const [telacadastrosolicitacao, settelacadastrosolicitacao] = useState('');
  const [telacadastroedicaosolicitacao, settelacadastroedicaosolicitacao] = useState('');
  const [telaexclusaosolicitacao, settelaexclusaosolicitacao] = useState('');
  const [solicitacao, setsolicitacao] = useState([]);
  const [mostra, setmostra] = useState('');

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
  const [valornegociado, setvalornegociado] = useState('');
  const [notafiscal, setnotafiscal] = useState('');

  const togglecadastro = () => {
    setshow(!show);
  };

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idlocal: idsite,
    idprojetocosmx: ididentificador,
    idempresas: idempresa,
    deletado: 0,
    obra: numero,
    //identificador pra mandar pro solicitação edição:
    identificadorsolicitacao: ididentificador2,
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
    //   const itens = atividadecltlista.length;
    //   const totalhoras = atividadecltlista.reduce((total, atividade) => total + parseFloat(atividade.totalhorasclt), 0);

    /*   const calculatamanho = () => {
         if (itens < 10) return '88%';
         if (itens < 21) return '85%';
         if (itens < 31) return '82%';
         if (itens < 40) return '79%';
         return '70%';
       };  */

    return (
      <>
        {/* <Box className='col-sm-10 d-flex flex-row-reverse'>
          <Box sx={{ width: calculatamanho(totalhoras) }}>
            {itens !== 0 && `Total de Horas: ${totalhoras}`}
          </Box>
          <Box sx={{ width: calculatamanho(itens) }}>
            {itens !== 0 && `Total de Lançamentos: ${itens}`}
          </Box>
        </Box>  */}

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

  const listaatividadepj = async () => {
    try {
      console.log('entrei no lista atividade');
      setloadingpj(true);
      await api.get('v1/projetoericsson/listaatividadepj', { params }).then((response) => {
        setatividadepjlista(response.data);
        //setselectedoptioncolaboradorpj({ value: response.data.idcolaboradorpj, label: response.data.colaboradorpj });
        setmensagem('');
        console.log('dados dp data');
        console.log(response.data);
        console.log('dados da variavel');
        console.log(atividadepjlista);
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

  const valorpo = [
    {
      field: 'po1',
      headerName: 'PO',
      width: 160,
      align: 'left',
      editable: false,
    },
    {
      field: 'pohwitem',
      headerName: 'PO+Item',
      width: 160,
      align: 'left',
      editable: false,
    },
    {
      field: 'qty',
      headerName: 'Quantidade',
      width: 100,
      align: 'center',
      editable: false,
    },
    {
      field: 'valorpo',
      headerName: 'Valor Unitário R$',
      width: 140,
      align: 'left',
      editable: false,
    },
    {
      field: 'valorpototal',
      headerName: 'Total R$',
      width: 140,
      align: 'left',
      editable: false,
    },
  ];

  function deleteclt(stat) {
    settelaexclusaoclt(true);
    setnumero(stat);
    listaatividadeclt();
  }

  function deletepj(stat) {
    console.log('apagar o acionamento');
    console.log(stat);
    settelaexclusaopj(true);
    setnumero(stat);
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
            disabled={modoVisualizador()}
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
          disabled={modoVisualizador()}
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
          disabled={modoVisualizador()}
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
            disabled={modoVisualizador()}
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
          disabled={modoVisualizador()}
          label="Delete"
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
          disabled={modoVisualizador()}
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

  const listapormigo = async () => {
    try {
      setloading(true);
      await api.get('v1/projetocosmxpo', { params }).then((response) => {
        setlistamigo(response.data);
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
      await api.get('v1/projetocosmxid', { params }).then((response) => {
        console.log(response.data);

        setregiona(response.data.region);
        setsiteid(response.data.siteid);
        setpo(response.data.po);
        setsitefromto(response.data.sitefromto);

        setobservacao(response.data.obs2);

        setinfrasyte(response.data.infrasyte);
        settypesite(response.data.typesite);
        setbatsw(response.data.batsw);
        setqty(response.data.qty);
        setowner(response.data.owner);
        setinstalledby(response.data.installedby);

        setuf(response.data.uf);
        setregiona(response.data.region);

        setendereco(response.data.address);
        setcidade(response.data.city);
        setidempresa(response.data.idempresa);
        setvalorlpu(response.data.valorlpu);
        setnotafiscal(response.data.notafiscal);

        if (response.data.aprovacaocosmx === '1899-12-30') {
          setaprovacaocosmx('');
        } else {
          setaprovacaocosmx(response.data.aprovacaocosmx);
        }

        setnomerelatorioenviado1(response.data.nomerelatorioenviado1);

        if (response.data.dataenvio1 === '1899-12-30') {
          setdataenvio1('');
        } else {
          setdataenvio1(response.data.dataenvio1);
        }

        setenviadopor1(response.data.enviadopor1);
        setstatus1(response.data.status1);
        setnomerelatorioenviado2(response.data.nomerelatorioenviado2);

        if (response.data.dataenvio2 === '1899-12-30') {
          setdataenvio2('');
        } else {
          setdataenvio2(response.data.dataenvio2);
        }

        setstatus2(response.data.status2);

        setselectedoptioncolaboradorpj({
          value: response.data.idempresa,
          label: response.data.nome,
        });
        setselectedoptionlpu({ value: response.data.value, label: response.data.label });
        console.log(response.data.label);

        setmensagem('');
        // setSelectedOptionfornecedor({ value: response.data.idfornecedor, label: response.data.nomefornecedor }); // Criar  logica de olhar na configuração se vai usar nome razão social ou nome fantasia
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listalpu = async (idc) => {
    try {
      console.log(idc);
      await api.get(`v1/projetocosmxid/listalpu/${idc}`, { params }).then((response) => {
        setlpulista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
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
      setidempresa(stat.value);
      setselectedoptioncolaboradorpj({ value: stat.value, label: stat.label });
      setcolaboradoremail(stat.email);
      listalpu(stat.value);
    } else {
      setidempresa(0);
      setcolaboradoremail('');
      setselectedoptioncolaboradorpj({ value: null, label: null });
    }
  };

  const handleChangelpu = (stat) => {
    if (stat !== null) {
      setlpu(stat.value);
      setvalorlpu(stat.valor);
      console.log(stat.value);
      setselectedoptionlpu({ value: stat.value, label: stat.label });
    } else {
      setlpu(0);
      setvalorlpu(0);
      setselectedoptionlpu({ value: null, label: null });
    }
  };

  function ProcessaCadastro(e) {
    e.preventDefault();
    setmensagem('');
    setmensagemsucesso('');

    api
      .post('v1/projetocosmxid', {
        numero: ididentificador,
        regiona,
        idempresa,
        lpu,
        inicioatividadeplanejado,
        inicioatividadereal,
        nomerelatorioenviado1,
        dataenvio1,
        enviadopor1,
        status1,
        nomerelatorioenviado2,
        dataenvio2,
        enviadopor2,
        status2,
        aprovacaocosmx,
        valorlpu,
        observacao,
        siteid,
        sitefromto,
        endereco,
        cidade,
        infrasyte,
        typesite,
        batsw,
        qty,
        owner,
        installedby,
        uf,
        notafiscal,

        //idcliente: localStorage.getItem('sessionCodidcliente'),
        //idusuario: localStorage.getItem('sessionId'),
        //idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          setshow(!show);
          togglecadastro.bind(null);
          atualiza();
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

  const listapo = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/selectprojeto', { params }).then((response) => {
        setposervicolista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

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
    api
      .post('v1/projetoericsson/listaatividadeclt/salva', {
        numero: ididentificador,
        //idposervico, //descrição serviços
        //po,
        //escopo,
        idcolaboradorclt, //colaborador
        datainicioclt,
        datafinalclt,
        observacaoclt,
        totalhorasclt,
        //descricaoservico,
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

  /* async function salvarpj(poit) {
     try {
       const response = await api.post('v1/projetoericsson/listaatividadepj/salva', {
         numero: ididentificador,
         // idposervico, //descrição serviços
         // po,
         selecao: poit,
         // escopo,
         idcolaboradorpj, //colaborador
         observacaopj,
         // descricaoservico,
         lpuhistorico,
         valornegociadonum: valornegociado.toString().replace('.', ','),
       });
       return response;
     } catch (err) {
       return err;
     }
   } */

  /* const svlista = async () => {
     try {
       const responses = await Promise.all(rowSelectionModel.map(async (poite) => salvarpj(poite)));
       const responseFaily = responses.find((item) => item.response.status === 500);
       if (responseFaily) {
         setmensagem(responseFaily.response.data.erro);
         setmensagemsucesso('');
         console.error('Erro: uma ou mais requisições falharam com status 500', responseFaily);
       } else {
         setmensagemsucesso('Registro Salvo');
         setmensagem('');
         listaatividadepj();
         console.log('Todas as requisições foram bem-sucedidas', responses);
       }
     } catch (err) {
       console.error('Erro ao salvar lista:', err);
     }
   };  */

  /*
    const salvarpj = async (poit) => {
      api.post('v1/projetoericsson/listaatividadepj/salva', {
        numero: ididentificador,
        // idposervico, //descrição serviços
        // po,
        selecao: poit,
        // escopo,
        idcolaboradorpj, //colaborador
        observacaopj,
        //descricaoservico,
        lpuhistorico,
        valornegociadonum: valornegociado.toString().replace(".", ","),
      })
        .then(response => {
          if (response.status === 201) {
            setmensagem('');
            setmensagemsucesso('Registro Salvo');
            listaatividadepj();
          } else {
            setmensagem(response.status);
            setmensagemsucesso('');
          }
        })
        .catch(err => {
          if (err.response) {
            setmensagem(err.response.data.erro);
          } else {
            setmensagem('Ocorreu um erro na requisição.');
          }
          setmensagemsucesso('');
        });
    }
  */

  const svlista = async () => {
    //   salvarpj();
    listaatividadepj();
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
    if (poservicolista.length === 0) {
      setmensagem('Não há itens na tabela.');
    } else {
      setmensagem('');
      novocadastro();
    }
  };

  const handleSolicitarDiaria = () => {
    if (poservicolista.length === 0) {
      setmensagem('Não há itens na tabela.');
    } else {
      setmensagem('');
      novocadastro();
    }
  };

  /*
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
    };  */

  /* const enviaremail = () => {
     if (colaboradoremail == null || colaboradoremail === '' || colaboradoremail === undefined) {
       setmensagemtela('Falta preencher o E-mail!');
       setmostra(true);
       setmotivo(2);
       return;
     }
 
     if (idempresa.length === 0) {
       setmostra(true);
       setmotivo(2);
       setmensagemtela('Falta Selecionar o Colaborador!');
     } else {
       setmensagem('');
       setmensagemsucesso('');
 
       api
         .post('v1/email/acionamentopj', {
           destinatario: emailadcional,
           destinatario1: colaboradoremail,
           assunto: 'ACIONAMENTO ERICSSON',
           numero,
           regiona,
           siteid,
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
   }; */

  const iniciatabelas = () => {
    listaid();
    listapo();
    listapormigo();
    listacolaboradorpj();
    if (1 === 0) {
      listacolaboradorclt();
      listaatividadeclt();
      listaatividadepj();
      listasolicitacao();
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
        Controle Cosmx
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
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
              mensagem=""
              motivo=""
              titulo="Enviar E-mail de Acionamento"
            />{' '}
          </>
        ) : null}
        {loading ? (
          <Loader />
        ) : (
          <FormGroup>
            <div className="row g-3">
              <div className="col-sm-2">
                SITE ID
                <Input type="text" onChange={(e) => setsiteid(e.target.value)} value={siteid} />
              </div>
              <div className="col-sm-2">
                SITE FROM/TO
                <Input
                  type="text"
                  onChange={(e) => setsitefromto(e.target.value)}
                  value={sitefromto}
                />
              </div>
              <div className="col-sm-2">
                PO
                <Input type="text" onChange={(e) => setpo(e.target.value)} value={po} />
              </div>
              <div className="col-sm-6">
                Observacao
                <Input
                  type="textarea"
                  onChange={(e) => setobservacao(e.target.value)}
                  value={observacao}
                />
              </div>
            </div>

            <div className="row g-3">
              <div className="col-sm-2">
                Infra Syte
                <Input
                  type="text"
                  onChange={(e) => setinfrasyte(e.target.value)}
                  value={infrasyte}
                />
              </div>
              <div className="col-sm-2">
                Type of Site
                <Input type="text" onChange={(e) => settypesite(e.target.value)} value={typesite} />
              </div>
              <div className="col-sm-2">
                BAT SW
                <Input type="text" onChange={(e) => setbatsw(e.target.value)} value={batsw} />
              </div>
              <div className="col-sm-2">
                Qty
                <Input type="text" onChange={(e) => setqty(e.target.value)} value={qty} />
              </div>
              <div className="col-sm-2">
                Owner
                <Input type="text" onChange={(e) => setowner(e.target.value)} value={owner} />
              </div>
              <div className="col-sm-2">
                Installed By
                <Input
                  type="text"
                  onChange={(e) => setinstalledby(e.target.value)}
                  value={installedby}
                />
              </div>
            </div>
            <br />
            <div className="row g-3">
              <div className="col-sm-6">
                Endereço
                <Input type="text" onChange={(e) => setendereco(e.target.value)} value={endereco} />
              </div>

              <div className="col-sm-3">
                Cidade
                <Input type="text" onChange={(e) => setcidade(e.target.value)} value={cidade} />
              </div>

              <div className="col-sm-1">
                UF
                <Input type="text" onChange={(e) => setuf(e.target.value)} value={uf} />
              </div>

              <div className="col-sm-2">
                Regional
                <Input type="text" onChange={(e) => setregiona(e.target.value)} value={regiona} />
              </div>
            </div>

            <Box sx={{ width: '100%' }}>
              <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
                <Tabs value={value} onChange={handleChange} aria-label="basic tabs">
                  <Tab label="Dados da Obra" {...a11yProps(0)} />
                  <Tab label="Financeiro" {...a11yProps(1)} />
                </Tabs>
              </Box>

              {/**DADOS DA OBRA */}
              <TabPanel value={value} index={0}>
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

                  {lpu === 'NEGOCIADO' && (
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
                </div>

                <br />
                <div className="row g-3">
                  <div className="col-sm-3">
                    Inicio Atividade(Planejado)
                    <Input
                      type="date"
                      onChange={(e) => setinicioatividadeplanejado(e.target.value)}
                      value={inicioatividadeplanejado}
                    />
                  </div>

                  <div className="col-sm-3">
                    Inicio Atividade(Real)
                    <Input
                      type="date"
                      onChange={(e) => setinicioatividadereal(e.target.value)}
                      value={inicioatividadereal}
                    />
                  </div>

                  <div className="col-sm-3">
                    Nota Fiscal
                    <Input
                      type="string"
                      onChange={(e) => setnotafiscal(e.target.value)}
                      value={notafiscal}
                    />
                  </div>
                </div>
                <br />

                <div className="row g-3">
                  <div className="col-sm-4">
                    Nome Relatório Enviado
                    <Input
                      type="text"
                      onChange={(e) => setnomerelatorioenviado1(e.target.value)}
                      value={nomerelatorioenviado1}
                    />
                  </div>

                  <div className="col-sm-2">
                    Data Envio 1º
                    <Input
                      type="date"
                      onChange={(e) => setdataenvio1(e.target.value)}
                      value={dataenvio1}
                    />
                  </div>

                  <div className="col-sm-4">
                    Enviado Por
                    <Input
                      type="text"
                      onChange={(e) => setenviadopor1(e.target.value)}
                      value={enviadopor1}
                    />
                  </div>

                  <div className="col-sm-2">
                    Status
                    <select
                      className="form-control"
                      onChange={(e) => setstatus1(e.target.value)}
                      value={status1}
                    >
                      <option value="" disabled>
                        Escolha uma opção
                      </option>
                      <option value="Pendente">Pendente</option>
                      <option value="Enviado">Enviado</option>
                      <option value="Rejeitado">Rejeitado</option>
                      <option value="Aprovado">Aprovado</option>
                    </select>
                  </div>
                </div>

                <br />
                <div className="row g-3">
                  <div className="col-sm-4">
                    Nome Relatório Enviado
                    <Input
                      type="text"
                      onChange={(e) => setnomerelatorioenviado2(e.target.value)}
                      value={nomerelatorioenviado2}
                    />
                  </div>

                  <div className="col-sm-2">
                    Data Envio 2º
                    <Input
                      type="date"
                      onChange={(e) => setdataenvio2(e.target.value)}
                      value={dataenvio2}
                    />
                  </div>

                  <div className="col-sm-4">
                    Enviado Por
                    <Input
                      type="text"
                      onChange={(e) => setenviadopor2(e.target.value)}
                      value={enviadopor2}
                    />
                  </div>

                  <div className="col-sm-2">
                    Status
                    <select
                      className="form-control"
                      onChange={(e) => setstatus2(e.target.value)}
                      value={status2}
                    >
                      <option value="" disabled>
                        Escolha uma opção
                      </option>

                      <option value="Pendente">Pendente</option>
                      <option value="Enviado">Enviado</option>
                      <option value="Rejeitado">Rejeitado</option>
                      <option value="Aprovado">Aprovado</option>
                    </select>
                  </div>
                </div>

                <br />
                <div className="row g-3">
                  <div className="col-sm-3">
                    Validação de faturamento
                    <Input
                      type="date"
                      onChange={(e) => setaprovacaocosmx(e.target.value)}
                      value={aprovacaocosmx}
                    />
                  </div>
                </div>
              </TabPanel>

              {/**FINANCEIRO */}
              <TabPanel value={value} index={1}>
                <Label>Valor PO</Label>
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
              </TabPanel>

              {/**ATIVIDADES */}
              <TabPanel value={value} index={2}>
                <FormGroup>
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

                        {lpu === 'NEGOCIADO' && (
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
                          <div className="d-flex flex-row-reverse custom-file"></div>
                        </div>

                        <br></br>
                        <div className=" col-sm-12 d-flex flex-row-reverse"></div>
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

Cosmxedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  ididentificador2: PropTypes.number,
  idsite: PropTypes.string,
  atualiza: PropTypes.node,
};

export default Cosmxedicao;

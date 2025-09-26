import { useState, useEffect } from 'react';
import './style.css';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter, FormGroup, Input } from 'reactstrap';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import * as Icon from 'react-feather';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import PropTypes from 'prop-types';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Box from '@mui/material/Box';
//import SearchIcon from '@mui/icons-material/Search';
import Typography from '@mui/material/Typography';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import Mensagemescolha from '../../Mensagemescolha';
import exportExcel from '../../../data/exportexcel/Excelexport';
import Extratofechamentotelefonica from './Extratofechamentotelefonica';
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

const Fechamentotelefonicaedicao = ({ setshow, show, idempresa, empresa, email }) => {
  const [value, setValue] = useState(0);
  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  const [projeto, setprojeto] = useState([]);
  const [projetohistorico, setprojetohistorico] = useState([]);
  const [loading, setloading] = useState(false);
  const [pageSize, setPageSize] = useState(10);
  const [mensagem, setmensagem] = useState('');
  const [mensagemmostrar, setmensagemmostrar] = useState('');
  const [geralfechamento, setgeralfechamento] = useState('');
  const [datapagamento, setdatapagamento] = useState('');
  const [porcpag, setporcpag] = useState('');
  const [valorpago, setvalorpago] = useState('');
  const [observacao, setobservacao] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [telaextrato, settelaextrato] = useState('');
  const [porcentagemg, setporcentagemg] = useState('');
  const [selectedIds, setSelectedIds] = useState([]);
  const [somaValorPj, setSomaValorPj] = useState(0);
  //const [linhasSelecionadas, setLinhasSelecionadas] = useState([]);
  const [pmosiglalocal, setpmosiglalocal] = useState('');
  const [tipopagamento, settipopagamento] = useState('ANTECIPAÇÃO');
  const [diapagamento, setdiapagamento] = useState('');
  const [regionallocal, setregionallocal] = useState('');

  const togglecadastro = () => {
    setshow(!show);
  };

  const params = {
    idgeralfechamento: geralfechamento,
    idempresalocal: idempresa,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    fechamento: datapagamento,
    pmo: pmosiglalocal,
    diafec: diapagamento,
    mespagamento: datapagamento,
    deletado: 0,
  };

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

  function Numerosemana() {
    const currentdate = new Date(datapagamento);
    const oneJan = new Date(currentdate.getFullYear(), 0, 1); // Primeiro dia do ano
    const ano = currentdate.getFullYear(); // Pegando o ano corretamente
    const numberOfDays = Math.floor((currentdate - oneJan) / (24 * 60 * 60 * 1000)); // Dias desde 1º de janeiro
    const result = Math.ceil((numberOfDays + oneJan.getDay() + 1) / 7); // Número da semana
    console.log(`${ano}/${result}`);
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

  const lista = async () => {
    setmensagemsucesso('');
    setloading(true);

    try {
      const response = await api.get('v1/projetotelefonica/listaacionamentosf', {
        params: {
          ...params,
          fechamento: null,
          diafec: null,
          mespagamento: null,
        },
      });

      const dados = response.data ?? [];

      if (dados.length > 0) {
        setprojeto(dados);
        setregionallocal(dados[0].regional || '');
        setmensagem('');
      }
    } catch (err) {
      setmensagem(err?.response?.data?.message || err.message || 'Erro ao buscar dados');
    } finally {
      setloading(false);
    }
  };

  /* const listahistorico = async () => {
    try {
      setloading(true);
      setmensagem('');
      lista();
    } catch (err) {
      setmensagem(err.message);
      console.log(err.message);
    } finally {
      setloading(false);
    }
  }; */

  const listahistorico = async () => {
    setmensagemsucesso('');
    try {
      setloading(true);
      await api
        .get('v1/projetotelefonica/listaacionamentoshistorico', {
          params: {
            fechamento: null,
            diafec: null,
            ...params,
            mespagamento: null,
          },
        })
        .then((response) => {
          setprojetohistorico(response.data);
          setmensagem('');
        });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  /* useEffect(() => {
       if (datapagamento && numerol) {
         listahistorico();
       }
     }, [datapagamento, numerol]);
   
     useEffect(() => {
       lista();
     }, []);  */

  const iniciatabelas = () => {
    setporcentagemg(100);
    lista();
    listahistorico();
    if (1 === 0) {
      console.log(setgeralfechamento(0));
    }
  };
  useEffect(() => {
    if (datapagamento) {
      Numerosemana();
    }
  }, [datapagamento]);

  const historicopagamento = [
    {
      field: 'idpmts',
      headerName: 'IDMPTS',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'pmoregional',
      headerName: 'REGIONAL',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'po',
      headerName: 'PO',
      width: 140,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'pmosigla',
      headerName: 'PMOSIGLA',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'ufsigla',
      headerName: 'UFSIGLA',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },

    {
      field: 'atividade',
      headerName: 'ATIVIDADE',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'quantidade',
      headerName: 'QUANT.',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'codigolpuvivo',
      headerName: 'CODIGO LPU VIVO',
      width: 250,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'brevedescricao',
      headerName: 'TAREFAS',
      width: 350,
      type: 'string',
      align: 'left',

      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'valor',
      headerName: 'VALOR PJ',
      width: 150,
      align: 'right',
      type: 'number', // Melhor usar 'number' para valores monetários
      editable: false,
      valueFormatter: (parametros) => {
        if (parametros.value == null) return ''; // Caso o valor seja nulo
        return parametros.value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
      },
    },
    {
      field: 'dataacionamento',
      headerName: 'DATA ACIONAMENTO',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },

    {
      field: 'dataenvioemail',
      headerName: 'DATA ENVIO EMAIL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'nome',
      headerName: 'COLABORADOR',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'observacao',
      headerName: 'OBSERVAÇÃO',
      width: 250,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => (
        <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>
      ),
    },
    /*  {
        field: 'entregarequest',
        headerName: 'ENTREGA REQUEST',
        width: 150,
        align: 'center',
        type: 'date', // Use 'date' para o DataGrid entender o tipo
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined
  
          const date = new Date(parametros.value);
          // Verifica se a data é 30/12/1899
          if (
            date.getDate() === 30 &&
            date.getMonth() === 11 && // Dezembro (0-based)
            date.getFullYear() === 1899
          ) {
            return '';
          }
  
          return date.toLocaleDateString('pt-BR');
        },
      },
      {
        field: 'entregaplan',
        headerName: 'ENTREGA PLAN',
        width: 150,
        align: 'center',
        type: 'date', // Use 'date' para o DataGrid entender o tipo
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined
  
          const date = new Date(parametros.value);
          // Verifica se a data é 30/12/1899
          if (
            date.getDate() === 30 &&
            date.getMonth() === 11 && // Dezembro (0-based)
            date.getFullYear() === 1899
          ) {
            return '';
          }
  
          return date.toLocaleDateString('pt-BR');
        },
      }, */

    {
      field: 'vistoriareal',
      headerName: 'VISTORIA REAL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },

    {
      field: 'entregareal',
      headerName: 'ENTREGA REAL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    /*  {
        field: 'fiminstalacaoplan',
        headerName: 'FIM INSTALACAO PLAN',
        width: 150,
        align: 'center',
        type: 'date', // Use 'date' para o DataGrid entender o tipo
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined
  
          const date = new Date(parametros.value);
          // Verifica se a data é 30/12/1899
          if (
            date.getDate() === 30 &&
            date.getMonth() === 11 && // Dezembro (0-based)
            date.getFullYear() === 1899
          ) {
            return '';
          }
  
          return date.toLocaleDateString('pt-BR');
        },
      }, */
    {
      field: 'fiminstalacaoreal',
      headerName: 'FIM INSTALACAO REAL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    /*   {
         field: 'integracaoplan',
         headerName: 'INTEGRACAO PLAN',
         width: 150,
         align: 'center',
         type: 'date', // Use 'date' para o DataGrid entender o tipo
         editable: false,
         valueFormatter: (parametros) => {
           if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined
   
           const date = new Date(parametros.value);
           // Verifica se a data é 30/12/1899
           if (
             date.getDate() === 30 &&
             date.getMonth() === 11 && // Dezembro (0-based)
             date.getFullYear() === 1899
           ) {
             return '';
           }
   
           return date.toLocaleDateString('pt-BR');
         },
       },  */
    {
      field: 'integracaoreal',
      headerName: 'INTEGRACAO REAL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'ativacao',
      headerName: 'ATIVACAO',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'documentacao',
      headerName: 'DOCUMENTACAO',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    /*  {
        field: 'dtplan',
        headerName: 'DT PLAN',
        width: 150,
        align: 'center',
        type: 'date', // Use 'date' para o DataGrid entender o tipo
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined
  
          const date = new Date(parametros.value);
          // Verifica se a data é 30/12/1899
          if (
            date.getDate() === 30 &&
            date.getMonth() === 11 && // Dezembro (0-based)
            date.getFullYear() === 1899
          ) {
            return '';
          }
  
          return date.toLocaleDateString('pt-BR');
        },
      },  */
    {
      field: 'initialtunningreal',
      headerName: 'INITIAL TUNNING',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },

    {
      field: 'dtreal',
      headerName: 'DT REAL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'dataimprodutiva',
      headerName: 'DATA IMPRODUTIVA',
      width: 180,
      align: 'center',
      type: 'date',
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return '';
        const date = new Date(parametros.value);
        if (date.getDate() === 30 && date.getMonth() === 11 && date.getFullYear() === 1899) {
          return '';
        }
        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'aprovacaossv',
      headerName: 'APROVAÇÃO SSV',
      width: 180,
      align: 'center',
      type: 'date',
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return '';
        const date = new Date(parametros.value);
        if (date.getDate() === 30 && date.getMonth() === 11 && date.getFullYear() === 1899) {
          return '';
        }
        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'statusaprovacaossv',
      headerName: 'STATUS APROVAÇÃO SSV',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'statusobra',
      headerName: 'STATUS OBRA',
      width: 180,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'mespagamento',
      headerName: 'MES PAGAMENTO',
      width: 180,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'datapagamento',
      headerName: 'DATA PAGAMENTO',
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'valorpagamento',
      headerName: 'VALOR PAGO',
      width: 150,
      align: 'right',
      type: 'number', // Melhor usar 'number' para valores monetários
      editable: false,
      valueFormatter: (parametros) => {
        if (parametros.value == null) return ''; // Caso o valor seja nulo
        return parametros.value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
      },
    },
    {
      field: 'porcentagem',
      headerName: '% PAGO',
      width: 80,
      align: 'right',
      type: 'number',
      editable: false,
      valueFormatter: (parametros) => {
        if (parametros.value == null) {
          return '0%';
        }
        return `${(parametros.value * 100).toFixed(2)}%`;
      },
    },
    {
      field: 'tipopagamento',
      headerName: 'TIPO PAGAMENTO',
      width: 180,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'observacao',
      headerName: 'OBSERVAÇÃO',
      width: 250,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => (
        <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>
      ),
    },
  ];

  const columns = [
    {
      field: 'idpmts',
      headerName: 'IDMPTS',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'regional',
      headerName: 'REGIONAL',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
      valueGetter: (parametros) => parametros.row.regional || parametros.row.pmoregional,
    },
    {
      field: 'po',
      headerName: 'PO',
      width: 140,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'pmosigla',
      headerName: 'PMOSIGLA',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'ufsigla',
      headerName: 'UFSIGLA',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },

    {
      field: 'atividade',
      headerName: 'ATIVIDADE',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'quantidade',
      headerName: 'QUANT.',
      width: 100,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'codigolpuvivo',
      headerName: 'CODIGO LPU VIVO',
      width: 250,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'tarefas',
      headerName: 'TAREFAS',
      width: 350,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'valor',
      headerName: 'VALOR PJ',
      width: 150,
      align: 'right',
      type: 'number', // Melhor usar 'number' para valores monetários
      editable: false,
      valueFormatter: (parametros) => {
        if (parametros.value == null) return ''; // Caso o valor seja nulo
        return parametros.value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
      },
    },
    {
      field: 'dataacionamento',
      headerName: 'DATA ACIONAMENTO',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },

    {
      field: 'dataenvioemail',
      headerName: 'DATA ENVIO EMAIL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'nome',
      headerName: 'COLABORADOR',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    /*  {
        field: 'entregarequest',
        headerName: 'ENTREGA REQUEST',
        width: 150,
        align: 'center',
        type: 'date', // Use 'date' para o DataGrid entender o tipo
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined
  
          const date = new Date(parametros.value);
          // Verifica se a data é 30/12/1899
          if (
            date.getDate() === 30 &&
            date.getMonth() === 11 && // Dezembro (0-based)
            date.getFullYear() === 1899
          ) {
            return '';
          }
  
          return date.toLocaleDateString('pt-BR');
        },
      },
      {
        field: 'entregaplan',
        headerName: 'ENTREGA PLAN',
        width: 150,
        align: 'center',
        type: 'date', // Use 'date' para o DataGrid entender o tipo
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined
  
          const date = new Date(parametros.value);
          // Verifica se a data é 30/12/1899
          if (
            date.getDate() === 30 &&
            date.getMonth() === 11 && // Dezembro (0-based)
            date.getFullYear() === 1899
          ) {
            return '';
          }
  
          return date.toLocaleDateString('pt-BR');
        },
      }, */
    {
      field: 'vistoriareal',
      headerName: 'VISTORIA REAL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'entregareal',
      headerName: 'ENTREGA REAL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    /*  {
        field: 'fiminstalacaoplan',
        headerName: 'FIM INSTALACAO PLAN',
        width: 150,
        align: 'center',
        type: 'date', // Use 'date' para o DataGrid entender o tipo
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined
  
          const date = new Date(parametros.value);
          // Verifica se a data é 30/12/1899
          if (
            date.getDate() === 30 &&
            date.getMonth() === 11 && // Dezembro (0-based)
            date.getFullYear() === 1899
          ) {
            return '';
          }
  
          return date.toLocaleDateString('pt-BR');
        },
      }, */
    {
      field: 'fiminstalacaoreal',
      headerName: 'FIM INSTALACAO REAL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    /*   {
         field: 'integracaoplan',
         headerName: 'INTEGRACAO PLAN',
         width: 150,
         align: 'center',
         type: 'date', // Use 'date' para o DataGrid entender o tipo
         editable: false,
         valueFormatter: (parametros) => {
           if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined
   
           const date = new Date(parametros.value);
           // Verifica se a data é 30/12/1899
           if (
             date.getDate() === 30 &&
             date.getMonth() === 11 && // Dezembro (0-based)
             date.getFullYear() === 1899
           ) {
             return '';
           }
   
           return date.toLocaleDateString('pt-BR');
         },
       },  */
    {
      field: 'integracaoreal',
      headerName: 'INTEGRACAO REAL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'ativacao',
      headerName: 'ATIVACAO',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'documentacao',
      headerName: 'DOCUMENTACAO',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    /*  {
        field: 'dtplan',
        headerName: 'DT PLAN',
        width: 150,
        align: 'center',
        type: 'date', // Use 'date' para o DataGrid entender o tipo
        editable: false,
        valueFormatter: (parametros) => {
          if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined
  
          const date = new Date(parametros.value);
          // Verifica se a data é 30/12/1899
          if (
            date.getDate() === 30 &&
            date.getMonth() === 11 && // Dezembro (0-based)
            date.getFullYear() === 1899
          ) {
            return '';
          }
  
          return date.toLocaleDateString('pt-BR');
        },
      },  */

    {
      field: 'initialtunningreal',
      headerName: 'INITIAL TUNNING',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'dtreal',
      headerName: 'DT REAL',
      width: 150,
      align: 'center',
      type: 'date', // Use 'date' para o DataGrid entender o tipo
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return ''; // Caso o valor seja nulo ou undefined

        const date = new Date(parametros.value);
        // Verifica se a data é 30/12/1899
        if (
          date.getDate() === 30 &&
          date.getMonth() === 11 && // Dezembro (0-based)
          date.getFullYear() === 1899
        ) {
          return '';
        }

        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'dataimprodutiva',
      headerName: 'DATA IMPRODUTIVA',
      width: 180,
      align: 'center',
      type: 'date',
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return '';
        const date = new Date(parametros.value);
        if (date.getDate() === 30 && date.getMonth() === 11 && date.getFullYear() === 1899) {
          return '';
        }
        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'aprovacaossv',
      headerName: 'APROVAÇÃO SSV',
      width: 180,
      align: 'center',
      type: 'date',
      editable: false,
      valueFormatter: (parametros) => {
        if (!parametros.value) return '';
        const date = new Date(parametros.value);
        if (date.getDate() === 30 && date.getMonth() === 11 && date.getFullYear() === 1899) {
          return '';
        }
        return date.toLocaleDateString('pt-BR');
      },
    },
    {
      field: 'statusaprovacaossv',
      headerName: 'STATUS APROVAÇÃO SSV',
      width: 200,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'statusobra',
      headerName: 'STATUS OBRA',
      width: 180,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'valorpago',
      headerName: 'VALOR PAGO',
      width: 150,
      align: 'right',
      type: 'number', // Melhor usar 'number' para valores monetários
      editable: false,
      valueFormatter: (parametros) => {
        if (parametros.value == null) return ''; // Caso o valor seja nulo
        return parametros.value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
      },
    },
    {
      field: 'observacao',
      headerName: 'Observação',
      width: 300,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'porcentagem',
      headerName: '% PAGO',
      width: 80,
      align: 'right',
      type: 'number',
      editable: false,
      valueFormatter: (parametros) => {
        if (parametros.value == null) {
          return '0%';
        }
        return `${(parametros.value * 100).toFixed(2)}%`;
      },
    },
  ];

  function extratopagamento() {
    if (!datapagamento) {
      setmensagem('Informe o MES e ANO de pagamento');
      return;
    }
    settelaextrato(true);
  }

  function salvapagamento(id) {
    setmensagem('');
    setmensagemsucesso('');
    api
      .post('v1/projetotelefonica/salvapagamento', {
        idacionamentovivo: id,
        mespagamento: datapagamento,
        porcentagem: porcentagemg,
        observacao,
        diapagamento,
        tipopagamento,
        idfuncionario: localStorage.getItem('sessionId'),
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          setobservacao('');
          setvalorpago(0);
          setporcpag(0);
          lista();
        } else {
          setmensagem(response.status);
          setmensagemsucesso('');
        }
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(err.response.data.erro);
          if (err.response.data.erro === 'Já existe pagamento nesse periodo') {
            setmensagemmostrar(true);
          }
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
        setmensagemsucesso('');
      });
  }

  function salvapagamentoalterar() {
    setmensagem('');
    setmensagemsucesso('');
    api
      .post('v1/projetozte/fechamento/salvapagamento', {
        dataenviofechamento: datapagamento,
        porcentagem: porcpag,
        fechamento: datapagamento,
        idfechamento: geralfechamento,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          iniciatabelas();
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

  function confirmacao(resposta) {
    setmensagemmostrar(false);
    if (resposta === 1) {
      salvapagamentoalterar();
    }
  }

  const salvarPagamentosSelecionados = () => {
    if (!datapagamento) {
      setmensagem('Informe o MES e ANO de pagamento');
      return;
    }
    if (!diapagamento) {
      setmensagem('Informe a data de controle para o pagamento');
      return;
    }

    const selecionados = projeto.filter((row) => selectedIds.includes(row.id));
    const ultrapassaLimite = selecionados.some(
      (item) => item.porcentagem * 100 + Number(porcentagemg) > 100,
    );

    if (ultrapassaLimite) {
      setmensagem('Pagamento inválido: o valor informado ultrapassa 100% do valor do site.');
      return;
    }

    selectedIds.forEach((id) => {
      salvapagamento(id);
    });
  };

  const gerarexcelpag = () => {
    if (projeto.length === 0) {
      setmensagem('Sem dados para exportar.');
      return;
    }
    setmensagem('');

    const excelData = projeto.map((item) => {
      return {
        IDMPTS: item.idpmts,
        REGIONAL: item.pmoregional || item.regional,
        PO: item.po,
        PMOSIGLA: item.pmosigla,
        UFSIGLA: item.ufsigla,
        ATIVIDADE: item.atividade,
        QUANTIDADE: item.quantidade,
        'CODIGO LPU VIVO': item.codigolpuvivo,
        TAREFAS: item.tarefas,
        VALOR: item.valor?.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }),
        OBSERVAÇÃO: item.observacao,
      };
    });
    exportExcel({ excelData, fileName: 'Fechamento_aguardando_pagamento' });
  };

  const gerarexcelhist = () => {
    const excelData = projetohistorico.map((item) => {
      const formatarData = (data) => {
        if (!data) return '';
        const d = new Date(data);
        if (d.getFullYear() === 1899 && d.getMonth() === 11 && d.getDate() === 30) {
          return '';
        }
        return d.toLocaleDateString('pt-BR');
      };

      return {
        IDMPTS: item.idpmts,
        REGIONAL: item.pmoregional,
        PO: item.po,
        PMOSIGLA: item.pmosigla,
        UFSIGLA: item.ufsigla,
        ATIVIDADE: item.atividade,
        QUANTIDADE: item.quantidade,
        'CODIGO LPU VIVO': item.codigolpuvivo,
        TAREFAS: item.tarefas,
        VALOR: item.valor?.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }),
        'DATA ACIONAMENTO': formatarData(item.dataacionamento),
        'DATA ENVIO EMAIL': formatarData(item.dataenvioemail),
        COLABORADOR: item.nome,
        'VISTORIA REAL': formatarData(item.vistoriareal),
        'ENTREGA REAL': formatarData(item.entregareal),
        'FIM INSTALACAO REAL': formatarData(item.fiminstalacaoreal),
        'INTEGRACAO REAL': formatarData(item.integracaoreal),
        ATIVACAO: formatarData(item.ativacao),
        DOCUMENTACAO: formatarData(item.documentacao),
        'INITIAL TUNNING REAL': formatarData(item.initialtunningreal),
        'DT REAL': formatarData(item.dtreal),
        'DATA IMPRODUTIVA': formatarData(item.dataimprodutiva),
        'APROVAÇÃO SSV': formatarData(item.aprovacaossv),
        'STATUS APROVAÇÃO SSV': item.statusaprovacaossv,
        'STATUS OBRA': item.statusobra,
        'MES PAGAMENTO': item.mespagamento,
        'DATA PAGAMENTO': formatarData(item.datapagamento),
        'VALOR PAGO': item.valorpagamento?.toLocaleString('pt-BR', {
          style: 'currency',
          currency: 'BRL',
        }),
        '% PAGO': item.porcentagem ? `${(item.porcentagem * 100).toFixed(2)}%` : '0%',
        'TIPO PAGAMENTO': item.tipopagamento,
        OBSERVAÇÃO: item.observacao,
      };
    });

    exportExcel({ excelData, fileName: 'Relatório - Historico Fechamento' });
  };

  useEffect(() => {
    const selecionados = projeto.filter((row) => selectedIds.includes(row.id));
    const soma = selecionados.reduce((acc, curr) => acc + (Number(curr.valor) || 0), 0);

    setSomaValorPj(soma);
    setvalorpago(soma * (porcentagemg / 100));
  }, [selectedIds, projeto]);

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
        Fechamento Telefonica
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
        {mensagem.length !== 0 ? (
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
        {mensagemmostrar && (
          <>
            {' '}
            <Mensagemescolha
              show={mensagemmostrar}
              setshow={setmensagemmostrar}
              titulotopo="Alteração"
              mensagem="Já existe pagamento nesse site com esse periodo, deseja alterar o pagamento feito?"
              respostapergunta={confirmacao}
            />{' '}
          </>
        )}
        {loading ? (
          <Loader />
        ) : (
          <FormGroup>
            <div className="row g-3">
              <div className="col-sm-4">
                Empresa
                <Input type="text" value={empresa} disabled />
              </div>
              <div className="col-sm-1">
                PMOSigla
                <Input
                  type="text"
                  onChange={(e) => setpmosiglalocal(e.target.value)}
                  value={pmosiglalocal}
                />
              </div>

              <div className="col-sm-2">
                <br />
                <Button color="primary" onClick={() => listahistorico()}>
                  Pesquisar
                </Button>
              </div>

              <div className="col-sm-2">
                Mês Pagamento
                <Input
                  type="month"
                  onChange={(e) => setdatapagamento(e.target.value)}
                  value={datapagamento}
                  placeholder="cliente nome"
                />
              </div>
              <div className="col-sm-2">
                Data Pagamento
                <Input
                  type="date"
                  onChange={(e) => setdiapagamento(e.target.value)}
                  value={diapagamento}
                  placeholder="cliente nome"
                />
              </div>
              <div className="col-sm-1">
                Status
                <Input
                  type="select"
                  onChange={(e) => settipopagamento(e.target.value)}
                  value={tipopagamento}
                >
                  <option value="ANTECIPAÇÃO">ANTECIPAÇÃO</option>
                  <option value="MENSAL">MENSAL</option>
                </Input>
              </div>
            </div>

            <Box sx={{ width: '100%' }}>
              <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
                <Tabs value={value} onChange={handleChange} aria-label="basic tabs">
                  <Tab label="Pagamentos em Aberto" {...a11yProps(0)} />
                  <Tab label="Históricos" {...a11yProps(1)} />
                </Tabs>
              </Box>

              {/** Pagamentos em Aberto */}
              <TabPanel value={value} index={0}>
                {/**gerar excel*/}
                <Button color="link" onClick={() => gerarexcelpag()}>
                  Exportar Excel
                </Button>
                <Button color="link" onClick={() => gerarexcelpag()}>
                  Limpar Seleção
                </Button>
                <div className="row g-3">
                  <div className="col-sm-9">
                    Acionamentos
                    <Box sx={{ height: 'calc(98vh - 385px)', width: '100%' }}>
                      <DataGrid
                        rows={projeto}
                        columns={columns}
                        loading={loading}
                        pageSize={pageSize}
                        checkboxSelection
                        onRowSelectionModelChange={(newSelection) => {
                          setSelectedIds(newSelection);
                          /*const selecionadas = projeto.filter((row) => newSelection.includes(row.id));
                          setLinhasSelecionadas(selecionadas); */
                        }}
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
                  </div>

                  <div className="col-sm-3">
                    <div className="row g-3">
                      <div className="col-sm-6">
                        Porcentagem
                        <Input
                          id="porcentagemg"
                          type="number"
                          max={100}
                          min={0}
                          onChange={(e) => {
                            const valueporc = Math.min(Number(e.target.value), 100);
                            setporcentagemg(valueporc);
                            setvalorpago(somaValorPj * (valueporc / 100));
                          }}
                          value={porcentagemg}
                        />
                      </div>
                    </div>
                    <br />
                    <div className="row g-3">
                      <div className="col-sm-6">
                        Valor Selecionado
                        <Input
                          type="text"
                          value={new Intl.NumberFormat('pt-BR', {
                            style: 'currency',
                            currency: 'BRL',
                          }).format(somaValorPj)}
                          placeholder="Valor do Pagamento"
                          disabled
                        />
                      </div>
                      <div className="col-sm-6">
                        Valor a Pagar
                        <Input
                          type="text"
                          onChange={(e) => setvalorpago(e.target.value)}
                          value={new Intl.NumberFormat('pt-BR', {
                            style: 'currency',
                            currency: 'BRL',
                          }).format(valorpago)}
                          placeholder="Valor do Pagamento"
                          disabled
                        />
                      </div>
                    </div>
                    <br />
                    <div className="row g-3">
                      <br />
                      <div className="col-sm-12">
                        Observação
                        <Input
                          type="textarea"
                          onChange={(e) => setobservacao(e.target.value)}
                          value={observacao}
                          placeholder="Observacao"
                        />
                      </div>
                    </div>
                    <br />
                    <div className="row g-3">
                      <div className="col-sm-12">
                        <div className="d-flex flex-row-reverse custom-file">
                          <Button
                            color="success"
                            onClick={salvarPagamentosSelecionados}
                            disabled={modoVisualizador()}
                          >
                            Salvar Pagamento
                          </Button>
                        </div>
                      </div>
                    </div>
                    <br />
                  </div>
                </div>
              </TabPanel>

              {/** Históricos */}
              <TabPanel value={value} index={1}>
                {/**gerar excel*/}
                <Button color="link" onClick={() => gerarexcelhist()}>
                  Exportar Excel
                </Button>
                <div className="row g-3">
                  <div className="col-sm-12">
                    Histórico de Pagamento
                    <Box sx={{ height: 'calc(100vh - 340px)', width: '100%' }}>
                      <DataGrid
                        rows={projetohistorico}
                        columns={historicopagamento}
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
                        localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                      />
                    </Box>
                  </div>
                </div>
              </TabPanel>
            </Box>
          </FormGroup>
        )}
      </ModalBody>
      <ModalFooter style={{ backgroundColor: 'white' }}>
        {telaextrato && (
          <>
            {' '}
            <Extratofechamentotelefonica
              show={telaextrato}
              setshow={settelaextrato}
              empresa={empresa}
              mespg={datapagamento}
              email={email}
              regional={regionallocal}
              idempresalocal={idempresa}
              tipopagamento={tipopagamento}
              datapagamento={diapagamento}
            />{' '}
          </>
        )}
        {/*value === 0 && valorPGAberto && (
          <Button color="">
            Total: {valorPGAberto.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}
          </Button>
        )*/}

        <Button color="primary" onClick={extratopagamento}>
          Gerar Extrato de Pagamento <Icon.BookOpen />
        </Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair <Icon.LogOut />
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Fechamentotelefonicaedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  idempresa: PropTypes.number,
  atualiza: PropTypes.node,
  idsite: PropTypes.string,
  email: PropTypes.string,
  empresa: PropTypes.string,
};

export default Fechamentotelefonicaedicao;

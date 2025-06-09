import { useState, useEffect } from 'react';
import {
  Button,
  //FormGroup,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
  Input,
  //Label,
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
import Mensagemsimples from '../../Mensagemsimples';
import Excluirregistro from '../../Excluirregistro';
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

const Ericssonedicaoadic = ({ setshow, show, ididentificador, atualiza }) => {
  const [value, setValue] = useState(0);

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [pageSize, setPageSize] = useState(10);
  const [loading, setloading] = useState(false);
  const [idcolaboradorclt, setidcolaboradorclt] = useState('');
  const [colaboradorcltlista, setcolaboradorcltlista] = useState([]);
  const [atividadecltlista, setatividadecltlista] = useState([]);
  const [colaboradorpjlista, setcolaboradorpjlista] = useState([]);
  const [atividadepjlista, setatividadepjlista] = useState([]);
  const [lpulista, setlpulista] = useState([]);
  const [selectedoptioncolaboradorclt, setselectedoptioncolaboradorclt] = useState(null);
  const [selectedoptioncolaboradorpj, setselectedoptioncolaboradorpj] = useState(null);
  const [telaexclusaopj, settelaexclusaopj] = useState('');
  const [datainicioclt, setdatainicioclt] = useState(Date);
  const [datafinalclt, setdatafinalclt] = useState(Date);
  const [valorhora, setvalorhora] = useState('');
  const [horanormalclt, sethoranormalclt] = useState('');
  const [hora50clt, sethora50clt] = useState('');
  const [hora100clt, sethora100clt] = useState('');
  const [totalhorasclt, settotalhorasclt] = useState('');
  const [observacaoclt, setobservacaoclt] = useState('');
  const [emailadcional, setemailadcional] = useState('');
  const [idcolaboradorpj, setidcolaboradorpj] = useState('');
  const [nomecolaboradorpj, setnomecolaboradorpj] = useState('');
  const [colaboradoremail, setcolaboradoremail] = useState('');
  const [lpuhistorico, setlpuhistorico] = useState('');
  const [valornegociado, setvalornegociado] = useState('');
  const [selectedoptionlpu, setselectedoptionlpu] = useState(null);
  const [mostra, setmostra] = useState('');
  const [motivo, setmotivo] = useState('');
  const [mensagemtela, setmensagemtela] = useState('');
  const [observacaopj, setobservacaopj] = useState('');
  const [numpo, setnumpo] = useState('');
  const [numpoitem, setnumpoitem] = useState('');
  const [codigo, setcodigo] = useState('');
  const [descricao, setdescricao] = useState('');
  const [numero, setnumero] = useState('');
  const [obraid, setobraid] = useState('');

  const [nome, setnome] = useState('');
  const [regional, setregional] = useState('');
  const [site, setsite] = useState('');

  //  const [telacadastrosolicitacao, settelacadastrosolicitacao] = useState('');
  // const [telacadasttroedicaosolicitacao, settelacadastroedicaosolicitacao] = useState('');
  // const [telaexclusaosolicitacao, settelaexclusaosolicitacao] = useState('');
  // const [solicitacao, setsolicitacao] = useState([]);

  const togglecadastro = () => {
    setshow(!show);
  };

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idporitem: ididentificador,
    deletado: 0,
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

  const listaatividadepj = async () => {
    try {
      setloading(true);
      await api
        .get('v1/projetoericsson/listaatividadepjengenharia', { params })
        .then((response) => {
          setatividadepjlista(response.data);
          //setselectedoptioncolaboradorpj({ value: response.data.idcolaboradorpj, label: response.data.colaboradorpj });
          setmensagem('');
        });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  //Funções
  function deleteclt(stat) {
    console.log(stat);
  }

  function deletepj(stat) {
    settelaexclusaopj(true);
    setnumero(stat);
    listaatividadepj();
  }

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
      headerName: 'Data Inicio',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'datafin',
      headerName: 'Data Final',
      width: 120,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'colaboradorclt',
      headerName: 'Colaborador',
      width: 250,
      align: 'left',
      type: 'string',
      editable: false,
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
      width: 260,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'totalhorasclt',
      headerName: 'Total de Horas',
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
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<DeleteIcon />}
          label="Delete"
          title="Delete"
          onClick={() => deletepj(parametros.id)}
        />,
      ],
    },
    {
      field: 'fantasia',
      headerName: 'Colaborador',
      width: 350,
      align: 'left',
      type: 'string',
      editable: false,
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
      field: 'poitem',
      headerName: 'PO ITEM',
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
      field: 'valorservico',
      headerName: 'Valor Serviço',
      width: 200,
      align: 'left',
      type: 'currency',
      editable: false,
    },
  ];
  /*
     const columnsdespesa = [
       {
         field: 'actions',
         headerName: 'Ação',
         type: 'actions',
         width: 120,
         align: 'center',
         getActions: () => [
           <GridActionsCellItem
             icon={<EditIcon />}
             label="Alterar"
             title='Alterar'
             onClick={() => null}
           />,
           <GridActionsCellItem
             icon={<DeleteIcon />}
             label="Delete"
             title='Delete'
             onClick={() => null}
           />,
         ],
       },
       { field: 'id', headerName: 'ID', width: 80, align: 'center', },
       {
         field: 'data',
         headerName: 'Data',
         type: 'string',
         width: 120,
         align: 'left',
         editable: false,
       },
       {
         field: 'nome',
         headerName: 'Nome',
         type: 'string',
         width: 300,
         align: 'right',
         editable: false,
       },
       {
         field: 'fantasia',
         headerName: 'Fantasia',
         type: 'string',
         width: 300,
         align: 'right',
         editable: false,
       },
       {
         field: 'numero',
         headerName: 'Número',
         type: 'string',
         width: 120,
         align: 'center',
         editable: false,
       },
       {
         field: 'po',
         headerName: 'PO',
         type: 'string',
         width: 120
         ,
         align: 'center',
         editable: false,
       },
       {
         field: 'descricaoservico',
         headerName: 'Descrição do Serviço',
         type: 'string',
         width: 300,
         align: 'center',
         editable: false,
       },
       {
         field: 'status',
         headerName: 'Status',
         type: 'string',
         width: 100,
         align: 'center',
         editable: false,
       },
     ];  */

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

  const listasolicitacao = async () => {
    try {
      setloading(true);
      await api.get('v1/solicitacaoid', { params }).then((response) => {
        //setsolicitacao(response.data);
        console.log(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listalpu = async (idc, icr) => {
    try {
      //  setloading(true);
      await api.get(`v1/projetoericsson/listalpu/${idc}/${icr}`).then((response) => {
        setlpulista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      console.log();
      // setloading(false);
    }
  };

  const listacolaboradorpj = async () => {
    try {
      setloading(true);
      await api.get('v1/empresas/selectpj').then((response) => {
        setcolaboradorpjlista(response.data);
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
      await api.get('v1/projetoericsson/selectcolaboradorclt').then((response) => {
        setcolaboradorcltlista(response.data);
        setmensagem('');
      });
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

  const handleChangelpu = (stat) => {
    if (stat !== null) {
      setlpuhistorico(stat.label);
      setselectedoptionlpu({ value: stat.value, label: stat.label });
    } else {
      setlpuhistorico('');
      setselectedoptionlpu({ value: null, label: null });
    }
  };

  const salvarpj = async () => {
    api
      .post('v1/projetoericsson/listaatividadepj/salvaengenharia', {
        numpo,
        numpoitem,
        codigo,
        descricao,
        idcolaboradorpj,
        observacaopj,
        lpuhistorico,
        valornegociadonum: valornegociado.toString().replace('.', ','),
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          listaatividadepj();
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

  const criarsite = async () => {
    api
      .post('v1/projetoericsson/criarsite', {
        obraid,
        site,
        regional,
        nome,
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
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

  const enviaremail = () => {
    if (idcolaboradorpj.length === 0) {
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
          nomecolaboradorpj,
          idpessoa: idcolaboradorpj,
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
          console.log(err);
          if (err.response) {
            setmensagem(err.response);
          } else {
            setmensagem('Ocorreu um erro na requisição.');
          }
          setmensagemsucesso('');
        });
    }
  };

  const listaadicid = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericssonadicid', { params }).then((response) => {
        setnumpo(response.data.po);
        setnumpoitem(response.data.poritem);
        setcodigo(response.data.codigoservico);
        setdescricao(response.data.descricaoservico);
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

  function ProcessaCadastro(e) {
    e.preventDefault();
    setmensagem('');
    setmensagemsucesso('');
    api
      .post('v1/projetoericsson/salvaengenharia', {
        obraid,
        numpoitem,
        numpo,
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
          console.log(listasolicitacao);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
        setmensagemsucesso('');
      });
  }

  const iniciatabelas = () => {
    const a = false;
    if (a) {
      console.log(enviaremail);
    }

    listacolaboradorclt();
    listacolaboradorpj();
    listaadicid();

    //listaatividadeclt();
    listaatividadepj();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <Modal
      isOpen={show}
      toggle={togglecadastro.bind(null)}
      className="modal-dialog modal-xl modal-fullscreen "
    >
      <ModalHeader toggle={togglecadastro.bind(null)}>Listagem de Tarefa</ModalHeader>
      <ModalBody>
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
        {telaexclusaopj ? (
          <>
            <Excluirregistro
              show={telaexclusaopj}
              setshow={settelaexclusaopj}
              ididentificador={numero}
              quemchamou="ATIVIDADEPJENGENHARIA"
              atualiza={listaatividadepj}
            />{' '}
          </>
        ) : null}

        {loading ? (
          <Loader />
        ) : (
          <>
            <p>
              <b>Identificação da Obra</b>
            </p>
            <div className="row g-3">
              <div className="col-sm-2">
                Numero
                <Input
                  type="text"
                  onChange={(e) => setobraid(e.target.value)}
                  value={obraid}
                  placeholder="Numero"
                  style={{ textTransform: 'uppercase' }}
                />
              </div>
              <div className="col-sm-3">
                Cliente Nome
                <Input
                  type="text"
                  onChange={(e) => setnome(e.target.value)}
                  value={nome}
                  placeholder="cliente nome"
                  style={{ textTransform: 'uppercase' }}
                />
              </div>
              <div className="col-sm-2">
                Regional Nome
                <Input
                  type="text"
                  onChange={(e) => setregional(e.target.value)}
                  value={regional}
                  placeholder="regional nome"
                  style={{ textTransform: 'uppercase' }}
                />
              </div>
              <div className="col-sm-3">
                Site Nome
                <Input
                  type="text"
                  onChange={(e) => setsite(e.target.value)}
                  value={site}
                  placeholder="site nome"
                  style={{ textTransform: 'uppercase' }}
                />
              </div>
              <div className=" col-sm-2 d-flex flex-row-reverse">
                <Button
                  color="primary"
                  onClick={criarsite}
                  style={{
                    height: '38px',
                    fontSize: '14px',
                    padding: '6px 12px',
                    marginTop: '20px',
                  }}
                >
                  Criar Site <Icon.Plus />
                </Button>
              </div>
            </div>
            <hr />
            <p>
              <b>Tarefa</b>
            </p>
            <div className="row g-3">
              <div className="col-sm-3">
                PO
                <Input
                  type="text"
                  onChange={(e) => setnumpo(e.target.value)}
                  value={numpo}
                  placeholder="PO"
                  disabled
                />
              </div>
              <div className="col-sm-3">
                PO Item
                <Input
                  type="text"
                  onChange={(e) => setnumpoitem(e.target.value)}
                  value={numpoitem}
                  placeholder="PO Item"
                  disabled
                />
              </div>
              <div className="col-sm-4">
                Codigo
                <Input
                  type="text"
                  onChange={(e) => setcodigo(e.target.value)}
                  value={codigo}
                  placeholder="codigo"
                  disabled
                />
              </div>
            </div>
            <br></br>
            <div className="row g-3">
              <div className="col-sm-6">
                Descrição
                <Input
                  type="text"
                  onChange={(e) => setdescricao(e.target.value)}
                  value={descricao}
                  placeholder="Descrição"
                  disabled
                />
              </div>
            </div>
            <hr />
            <p>
              <b>Enviar para Fechamento</b>
            </p>

            <Box sx={{ width: '100%' }}>
              <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
                <Tabs
                  value={value}
                  onChange={handleChange}
                  aria-label="basic tabs example"
                  centered
                >
                  <Tab label="Mão de Obra CLT" {...a11yProps(0)} />
                  <Tab label="Mão de Obra PJ" {...a11yProps(1)} />
                  <Tab label="Material" {...a11yProps(2)} />
                </Tabs>
              </Box>
              <TabPanel value={value} index={0}>
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

              <TabPanel value={value} index={1}>
                Dados do Colaborador PJ
                <hr />
                <div className="row g-3">
                  <div className="col-sm-6">
                    Colaborador
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
                          type="number"
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
                  <Button color="primary" onClick={salvarpj} disabled={modoVisualizador()}>
                    Adicionar <Icon.Plus />
                  </Button>
                </div>
                <br></br>
                <div className="row g-3">
                  <Box sx={{ height: 400, width: '100%' }}>
                    <DataGrid
                      rows={atividadepjlista}
                      columns={columnspj}
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
                  <br></br>
                  {/*
                  <div className="col-sm-12">
                    E-mails adicionais 
                    <Input type="hidden" onChange={(e) => setemailadcional(e.target.value)} value={emailadcional} placeholder="Digite os e-mails separados por virgula" />
                  </div>
                  <br></br>
                  <div className=" col-sm-12 d-flex flex-row-reverse">
                    <Button color="secondary" onClick={enviaremail} >
                      Enviar E-mail de Acionamento  <Icon.Mail />
                    </Button>
                  </div>
                  <br></br>
                  */}
                </div>
              </TabPanel>

              <TabPanel value={value} index={2}></TabPanel>
            </Box>
          </>
        )}
      </ModalBody>
      <ModalFooter>
        <Button color="success" onClick={ProcessaCadastro}>
          Salvar
        </Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Ericssonedicaoadic.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.node,
};

export default Ericssonedicaoadic;

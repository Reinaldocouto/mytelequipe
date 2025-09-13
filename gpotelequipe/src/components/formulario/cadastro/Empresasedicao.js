import { useState, useEffect } from 'react';
import {
  Button,
  Input,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
  FormGroup,
  InputGroup,
} from 'reactstrap';
import {
  DataGrid,
  GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
} from '@mui/x-data-grid';
import { Box } from '@mui/material';
import PropTypes from 'prop-types';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Pagination from '@mui/material/Pagination';
import EditIcon from '@mui/icons-material/Edit';
import AttachMoneyIcon from '@mui/icons-material/AttachMoney';
import LinearProgress from '@mui/material/LinearProgress';
import Typography from '@mui/material/Typography';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import Empresasedicaocontrato from './Pessoaedicaocontrato';
import Veiculosedicao from './Veiculosedicao';
import DespesasVeiculo from './DespesasVeiculo';
import modoVisualizador from '../../../services/modovisualizador';

function TabPanel(props) {
  const { children, value, index, ...other } = props;

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
};

function a11yProps(index) {
  return {
    id: `simple-tab-${index}`,
    'aria-controls': `simple-tabpanel-${index}`,
  };
}

const Empresasedicao = ({ setshow, show, ididentificador, atualiza }) => {
  const [value, setValue] = useState(0);

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setLoading] = useState(false);
  const [nome, setnome] = useState();
  const [fantasia, setfantasia] = useState();
  const [cnpj, setcnpj] = useState();
  const [outros, setoutros] = useState();
  const [outrosdata, setoutrosdata] = useState();
  const [outros2, setoutros2] = useState();
  const [outros2data, setoutros2data] = useState();
  const [porte, setporte] = useState();
  const [idempresa, setidempresa] = useState('');

  const [cnaep, setcnaep] = useState('');
  const [cnaes, setcnaes] = useState('');

  const [codigodescricaoatividades1, setcodigodescricaoatividades1] = useState('');
  const [codigodescricaoatividades2, setcodigodescricaoatividades2] = useState('');
  const [codigodescricaoatividades3, setcodigodescricaoatividades3] = useState('');
  const [codigodescricaoatividades4, setcodigodescricaoatividades4] = useState('');
  const [cnaes1, setcnaes1] = useState('');
  const [cnaes2, setcnaes2] = useState('');
  const [cnaes3, setcnaes3] = useState('');
  const [cnaes4, setcnaes4] = useState('');

  const [codigodescricaonatureza, setcodigodescricaonatureza] = useState('');
  const [logradouro, setlogradouro] = useState('');
  const [cidade, setcidade] = useState('');
  const [numero, setnumero] = useState('');
  const [complemento, setcomplemento] = useState('');
  const [cep, setcep] = useState('');
  const [bairro, setbairro] = useState('');
  const [uf, setuf] = useState('');
  const [situacaocadastral, setsituacaocadastral] = useState('');
  const [pgr, setpgr] = useState('');
  const [pcmso, setpcmso] = useState('');
  const [contratos, setcontratos] = useState('');
  const [nomeresponsavel, setnomeresponsavel] = useState('');
  const [telefone, settelefone] = useState('');
  const [email, setemail] = useState('');
  const [pageSize, setPageSize] = useState(10);
  const [colaboradorlista, setcolaboradorlista] = useState([]);
  const [veiculolista, setveiculolista] = useState([]);
  const [telacadastroedicaocontrato, settelacadastroedicaocontrato] = useState('');
  const [idpessoacontrato, setidpessoacontrato] = useState('');
  const [colaborador, setcolaborador] = useState('');
  const [idveiculo, setidveiculo] = useState('');
  const [telacadastroedicaoveiculo, settelacadastroedicaoveiculo] = useState('');
  const [telalistadespesasveiculo, settelalistadespesasveiculo] = useState('');
  const [idveiculodespesas, setidveiculodespesas] = useState('');
  const [titulo, settitulo] = useState('');
  const [tipopj, settipopj] = useState('');
  const [statusTelequipe, setStatusTelequipe] = useState('');
  const [filtraColaboradores, setFiltraColaboradores] = useState([]);
  const [statusFiltro, setStatusFiltro] = useState('TODOS');

  //Parametros
  const params = {
    idcliente: 1, //localStorage.getItem('sessionCodidcliente'),
    idusuario: 1, //localStorage.getItem('sessionId'),
    idloja: 1, //localStorage.getItem('sessionloja'),
    idempresabusca: ididentificador,
    empresanome: nome,
    deletado: 0,
  };

  function apenasNumeros(string) {
    const numsStr = string.replace(/[^0-9]/g, '');
    return numsStr;
  }

  const handleSearch = async () => {
    try {
      await api.get(`v1/empresas/cnpj/${apenasNumeros(cnpj)}`).then((response) => {
        if (response.status === 200) {
          if (response.data.status === 'OK') {
            setnome(response.data.nome);
            settipopj(response.data.tipopj);
            setStatusTelequipe(response.data.statusTelequipe);
            setfantasia(response.data.fantasia);
            setporte(response.data.porte);
            setcnaep(response.data.atividade_principal[0].code);
            setcnaes(response.data.atividades_secundarias[0].code);
            setcodigodescricaonatureza(response.data.natureza_juridica);
            setlogradouro(response.data.logradouro);
            setcidade(response.data.municipio);
            setnumero(response.data.numero);
            setcomplemento(response.data.complemento);
            setcep(response.data.cep);
            setbairro(response.data.bairro);
            setuf(response.data.uf);
            setsituacaocadastral(response.data.situacao);
            settelefone(response.data.telefone);
            setemail(response.data.email);

            setcnaes1(response.data.atividades_secundarias[0].code);
            setcodigodescricaoatividades1(response.data.atividades_secundarias[0].text);
            setcnaes2(response.data.atividades_secundarias[1].code);
            setcodigodescricaoatividades2(response.data.atividades_secundarias[1].text);
            setcnaes3(response.data.atividades_secundarias[2].code);
            setcodigodescricaoatividades3(response.data.atividades_secundarias[2].text);
            setcnaes4(response.data.atividades_secundarias[3].code);
            setcodigodescricaoatividades4(response.data.atividades_secundarias[3].text);
          } else {
            setmensagem(response.data.message);
          }
        } else {
          setmensagem('Erro ao consultar CNPJ');
        }
      });
    } catch (e) {
      console.log(e);
    }
  };

  const togglecadastro = () => {
    setshow(!show);
  };

  const filtrarColaboradores = () => {
    if (statusFiltro === 'TODOS') {
      setFiltraColaboradores(colaboradorlista);
    } else {
      const filtrados = colaboradorlista.filter((colaborad) => colaborad.status === statusFiltro);
      setFiltraColaboradores(filtrados);
    }
  };

  const listacolaborador = () => {
    setLoading(true);
    api
      .get('v1/empresas/colaborador', { params })
      .then((response) => {
        setcolaboradorlista(response.data);
        setFiltraColaboradores(response.data);
      })
      .finally(() => setLoading(false));
  };

  const listaveiculo = () => {
    api.get('v1/empresas/veiculo', { params }).then((response) => {
      console.log('veiculos listasdsfobe: ', response.data);
      setveiculolista(response.data);
    });
  };

  const listaempresa = async () => {
    try {
      setLoading(true);
      await api.get('v1/empresasid', { params }).then((response) => {
        setidempresa(response.data.idempresa);
        setcnpj(response.data.cnpj);
        settipopj(response.data.tipopj);
        setStatusTelequipe(response.data.statustelequipe);
        setnome(response.data.nome);
        setfantasia(response.data.fantasia);
        setporte(response.data.porte);
        setcnaep(response.data.cnaep);
        setcnaes(response.data.cnaes);

        setcnaes1(response.data.cnae1);
        setcodigodescricaoatividades1(response.data.cnaedescricao1);
        setcnaes2(response.data.cnae2);
        setcodigodescricaoatividades2(response.data.cnaedescricao2);
        setcnaes3(response.data.cnae3);
        setcodigodescricaoatividades3(response.data.cnaedescricao3);
        setcnaes4(response.data.cnae4);
        setcodigodescricaoatividades4(response.data.cnaedescricao4);

        setcodigodescricaonatureza(response.data.codigodescricaonatureza);
        setlogradouro(response.data.logradouro);
        setcidade(response.data.cidade);
        setnumero(response.data.numero);
        setcomplemento(response.data.complemento);
        setcep(response.data.cep);
        setbairro(response.data.bairro);
        setuf(response.data.uf);
        setsituacaocadastral(response.data.situacaocadastral);
        setpgr(response.data.pgr);
        setpcmso(response.data.pcmso);
        setcontratos(response.data.contratos);
        setnomeresponsavel(response.data.nomeresponsavel);
        settelefone(response.data.telefone);
        setemail(response.data.email);
        setoutros(response.data.outros);
        if (response.data.outrosdata === '1899-12-30') {
          setoutrosdata('');
        } else {
          setoutrosdata(response.data.outrosdata);
        }
        setoutros2(response.data.outros2);
        if (response.data.outros2data === '1899-12-30') {
          setoutros2data('');
        } else {
          setoutros2data(response.data.outros2data);
        }

        listacolaborador();
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  function CustomPagination() {
    const apiRef = useGridApiContext();
    const page = useGridSelector(apiRef, gridPageSelector);
    const pageCount = useGridSelector(apiRef, gridPageCountSelector);

    return (
      <Pagination
        color="primary"
        count={pageCount}
        page={page + 1}
        onChange={(event, value1) => apiRef.current.setPage(value1 - 1)}
      />
    );
  }

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

  function alterarUser(stat, colab) {
    settelacadastroedicaocontrato(true);
    setidpessoacontrato(stat);
    setcolaborador(colab);
  }

  function alterarUser1(stat) {
    settelacadastroedicaoveiculo(true);
    settitulo('Dados do veiculo');
    setidveiculo(stat);
  }
  
  function verDespesasVeiculo(stat) {
    setidveiculodespesas(stat);
    settelalistadespesasveiculo(true);
  }

  const colaboradortabela = [
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
          hint="Alterar"
          onClick={() => alterarUser(parametros.id, parametros.row.nome)}
        />,
      ],
    },
    // { field: 'id', headerName: 'ID', width: 65, align: 'center', visible: 'false' },
    {
      field: 'nome',
      headerName: 'Nome',
      width: 450,
      align: 'left',
      editable: false,
    },
    {
      field: 'contrato',
      headerName: 'Contrato',
      width: 300,
      align: 'left',
      editable: false,
    },
    {
      field: 'status',
      headerName: 'Status',
      width: 180,
      align: 'left',
      editable: false,
    },
  ];

  const veiculotabela = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 100,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          hint="Alterar"
          onClick={() => alterarUser1(parametros.id)}
        />,
        <GridActionsCellItem
          icon={<AttachMoneyIcon />}
          label="Despesas"
          hint="Despesas"
          onClick={() => verDespesasVeiculo(parametros.id)}
        />,
      ],
    },
    {
      field: 'modelo',
      headerName: 'Modelo',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'ativo',
      headerName: 'Status',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'funcionario',
      headerName: 'Funcionário Responsável',
      width: 300,
      align: 'left',
      editable: false,
    },
    {
      field: 'placa',
      headerName: 'PLACA',
      width: 300,
      align: 'left',
      editable: false,
    },
  ];

  function ProcessaCadastro(e) {
    e.preventDefault();
    setmensagem('');
    setmensagemsucesso('');
    api
      .post('v1/empresas', {
        idempresa: ididentificador,
        cnpj,
        tipopj,
        statusTelequipe,
        nome,
        fantasia,
        porte,
        cnaep,
        cnaes,
        codigodescricaoatividades1,
        codigodescricaoatividades2,
        codigodescricaoatividades3,
        codigodescricaoatividades4,
        cnaes1,
        cnaes2,
        cnaes3,
        cnaes4,
        codigodescricaonatureza,
        logradouro,
        cidade,
        numero,
        complemento,
        cep,
        bairro,
        uf,
        situacaocadastral,
        pgr,
        pcmso,
        contratos,
        nomeresponsavel,
        telefone,
        email,
        outros,
        outrosdata,
        outros2,
        outros2data,
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

  const iniciatabelas = () => {
    listaempresa();
    listaveiculo();
  };

  useEffect(() => {
    listacolaborador();
  }, []);

  useEffect(() => {
    filtrarColaboradores();
  }, [statusFiltro, colaboradorlista]);

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <Modal
      isOpen={show}
      toggle={togglecadastro.bind(null)}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-xl modal-dialog-scrollable  modal-fullscreen  "
    >
      <ModalHeader toggle={togglecadastro.bind(null)} style={{ backgroundColor: 'white' }}>
        Cadastro de Empresas
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
        {telacadastroedicaocontrato ? (
          <>
            {' '}
            <Empresasedicaocontrato
              show={telacadastroedicaocontrato}
              setshow={settelacadastroedicaocontrato}
              ididentificador={idpessoacontrato}
              atualiza={listacolaborador}
              funcionario={colaborador}
            />{' '}
          </>
        ) : null}
        {telacadastroedicaoveiculo ? (
          <>
            {' '}
            <Veiculosedicao
              show={telacadastroedicaoveiculo}
              setshow={settelacadastroedicaoveiculo}
              ididentificador={idveiculo}
              atualiza={listaveiculo}
              titulotopo={titulo}
            />{' '}
          </>
        ) : null}
        {telalistadespesasveiculo ? (
          <>
            {' '}
            <DespesasVeiculo
              show={telalistadespesasveiculo}
              setshow={settelalistadespesasveiculo}
              idveiculo={idveiculodespesas}
            />{' '}
          </>
        ) : null}
        {loading ? (
          <Loader />
        ) : (
          <Box sx={{ width: '100%' }}>
            <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
              <Tabs value={value} onChange={handleChange} aria-label="basic tabs example">
                <Tab label="DADOS CADASTRAIS - PESSOA JURÍDICA" {...a11yProps(0)} />
                <Tab label="VEÍCULOS" {...a11yProps(0)} />
                <Tab label="COLABORADORES" {...a11yProps(0)} />
              </Tabs>
            </Box>
            <TabPanel value={value} index={0}>
              <div className="row g-3">
                <div className="col-sm-5">
                  <FormGroup>
                    NÚMERO DE INSCRIÇÃO - CNPJ*
                    <InputGroup>
                      <Input
                        type="hidden"
                        onChange={(e) => setidempresa(e.target.value)}
                        value={idempresa}
                      />
                      <Input type="text" onChange={(e) => setcnpj(e.target.value)} value={cnpj} />
                      <Button
                        color="primary"
                        onClick={() => handleSearch()}
                        title="Clique para pesquisar o CNPJ"
                      >
                        <i className="bi bi-search"></i>{' '}
                      </Button>
                    </InputGroup>
                  </FormGroup>
                </div>
                <div className="col-sm-3">
                  Tipo PJ
                  <Input
                    type="select"
                    onChange={(e) => settipopj(e.target.value)}
                    value={tipopj}
                    name="Tipo PJ"
                  >
                    <option value="Selecione">Selecione</option>
                    <option value="PRESTADOR DE SERVIÇO">PRESTADOR DE SERVIÇO</option>
                    <option value="FORNECEDOR">FORNECEDOR</option>
                  </Input>
                </div>
                <div className="col-sm-3">
                  Status telequipe
                  <Input
                    type="select"
                    onChange={(e) => setStatusTelequipe(e.target.value)}
                    value={statusTelequipe}
                    name="Status telequipe"
                  >
                    <option value="Selecione">Selecione</option>
                    <option value="ATIVO">ATIVO</option>
                    <option value="INATIVO">INATIVO</option>
                  </Input>
                </div>
              </div>
              <div className="row g-3">
                <div className="col-sm-6">
                  NOME EMPRESARIAL
                  <Input type="text" onChange={(e) => setnome(e.target.value)} value={nome} />
                </div>
                <div className="col-sm-6">
                  NOME FANTASIA
                  <Input
                    type="text"
                    onChange={(e) => setfantasia(e.target.value)}
                    value={fantasia}
                  />
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-4">
                  PORTE
                  <Input type="text" onChange={(e) => setporte(e.target.value)} value={porte} />
                </div>
                <div className="col-sm-4">
                  CNAE (PRINCIPAL)
                  <Input type="text" onChange={(e) => setcnaep(e.target.value)} value={cnaep} />
                </div>
                <div className="col-sm-4">
                  CNAE (SECUNDÁRIO)
                  <Input type="text" onChange={(e) => setcnaes(e.target.value)} value={cnaes} />
                </div>
              </div>
              <br />
              CÓDIGO E DESCRIÇÃO DAS ATIVIDADES ECONÔMICAS SECUNDÁRIAS
              <div className="row g-3">
                <div className="col-sm-4">
                  <Input
                    type="text"
                    disabled
                    onChange={(e) => setcnaes1(e.target.value)}
                    value={cnaes1}
                    style={{ backgroundColor: 'white' }}
                  />
                </div>
                <div className="col-sm-8">
                  <Input
                    type="text"
                    disabled
                    onChange={(e) => setcodigodescricaoatividades1(e.target.value)}
                    value={codigodescricaoatividades1}
                    style={{ backgroundColor: 'white' }}
                  />
                </div>

                <div className="col-sm-4">
                  <Input
                    type="text"
                    disabled
                    onChange={(e) => setcnaes2(e.target.value)}
                    value={cnaes2}
                    style={{ backgroundColor: 'white' }}
                  />
                </div>
                <div className="col-sm-8">
                  <Input
                    type="text"
                    disabled
                    onChange={(e) => setcodigodescricaoatividades2(e.target.value)}
                    value={codigodescricaoatividades2}
                    style={{ backgroundColor: 'white' }}
                  />
                </div>

                <div className="col-sm-4">
                  <Input
                    type="text"
                    disabled
                    onChange={(e) => setcnaes3(e.target.value)}
                    value={cnaes3}
                    style={{ backgroundColor: 'white' }}
                  />
                </div>
                <div className="col-sm-8">
                  <Input
                    type="text"
                    disabled
                    onChange={(e) => setcodigodescricaoatividades3(e.target.value)}
                    value={codigodescricaoatividades3}
                    style={{ backgroundColor: 'white' }}
                  />
                </div>

                <div className="col-sm-4">
                  <Input
                    type="text"
                    disabled
                    onChange={(e) => setcnaes4(e.target.value)}
                    value={cnaes4}
                    style={{ backgroundColor: 'white' }}
                  />
                </div>
                <div className="col-sm-8">
                  <Input
                    type="text"
                    disabled
                    onChange={(e) => setcodigodescricaoatividades4(e.target.value)}
                    value={codigodescricaoatividades4}
                    style={{ backgroundColor: 'white' }}
                  />
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-12">
                  CÓDIGO E DESCRIÇÃO DA NATUREZA JURÍDICA
                  <Input
                    type="text"
                    onChange={(e) => setcodigodescricaonatureza(e.target.value)}
                    value={codigodescricaonatureza}
                  />
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-6">
                  LOGRADOURO
                  <Input
                    type="text"
                    onChange={(e) => setlogradouro(e.target.value)}
                    value={logradouro}
                  />
                </div>
                <div className="col-sm-2">
                  NÚMERO
                  <Input type="text" onChange={(e) => setnumero(e.target.value)} value={numero} />
                </div>
                <div className="col-sm-4">
                  COMPLEMENTO
                  <Input
                    type="text"
                    onChange={(e) => setcomplemento(e.target.value)}
                    value={complemento}
                  />
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-3">
                  BAIRRO/DISTRITO
                  <Input type="text" onChange={(e) => setbairro(e.target.value)} value={bairro} />
                </div>
                <div className="col-sm-3">
                  CIDADE
                  <Input type="text" onChange={(e) => setcidade(e.target.value)} value={cidade} />
                </div>
                <div className="col-sm-2">
                  CEP
                  <Input type="text" onChange={(e) => setcep(e.target.value)} value={cep} />
                </div>
                <div className="col-sm-1">
                  UF
                  <Input type="text" onChange={(e) => setuf(e.target.value)} value={uf} />
                </div>
                <div className="col-sm-3">
                  SITUAÇÃO CADASTRAL
                  <Input
                    type="text"
                    onChange={(e) => setsituacaocadastral(e.target.value)}
                    value={situacaocadastral}
                  />
                </div>
              </div>
              <hr />
              <br />
              <div className="row g-3">
                <div className="col-sm-5">
                  PROGRAMA DE GERENCIAMENTO DE RISCOS - PGR
                  <Input type="date" onChange={(e) => setpgr(e.target.value)} value={pgr} />
                </div>
                <div className="col-sm-7">
                  PROGR. DE CONTROLE MÉDICO DE SAÚDE OCUPACIONAL - PCMSO
                  <Input type="date" onChange={(e) => setpcmso(e.target.value)} value={pcmso} />
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-6">
                  OUTROS
                  <div className="row g-3">
                    <div className="col-sm-8">
                      <Input
                        type="text"
                        onChange={(e) => setoutros(e.target.value)}
                        value={outros}
                      />
                    </div>
                    <div className="col-sm-4">
                      <Input
                        type="date"
                        onChange={(e) => setoutrosdata(e.target.value)}
                        value={outrosdata}
                      />
                    </div>
                  </div>
                </div>
                <div className="col-sm-6">
                  OUTROS
                  <div className="row g-3">
                    <div className="col-sm-8">
                      <Input
                        type="text"
                        onChange={(e) => setoutros2(e.target.value)}
                        value={outros2}
                      />
                    </div>
                    <div className="col-sm-4">
                      <Input
                        type="date"
                        onChange={(e) => setoutros2data(e.target.value)}
                        value={outros2data}
                      />
                    </div>
                  </div>
                </div>
              </div>
              <br />
              <div className="row g-3">
                <div className="col-sm-5">
                  CONTRATOS (TELEQUIPE X SUBCONTRATADA)
                  <Input
                    type="select"
                    onChange={(e) => setcontratos(e.target.value)}
                    value={contratos}
                    name="Tipo Pessoa"
                  >
                    <option value="0">Selecione</option>
                    <option value="1">EM ELABORAÇÃO</option>
                    <option value="2">ENVIADO</option>
                    <option value="3">ASSINADO</option>
                  </Input>
                </div>
              </div>
              <br />
              <div className="row g-4">
                <div className="col-sm-5">
                  NOME DO RESPONSÁVEL LEGAL
                  <Input
                    type="text"
                    onChange={(e) => setnomeresponsavel(e.target.value)}
                    value={nomeresponsavel}
                  />
                </div>
                <div className="col-sm-4">
                  EMAIL
                  <Input type="text" onChange={(e) => setemail(e.target.value)} value={email} />
                </div>
                <div className="col-sm-3">
                  TELEFONE
                  <Input
                    type="text"
                    onChange={(e) => settelefone(e.target.value)}
                    value={telefone}
                  />
                </div>
              </div>
            </TabPanel>

            <TabPanel value={value} index={1}>
              <div className="row g-3">
                <Box sx={{ height: 450, width: '100%' }}>
                  <DataGrid
                    rows={veiculolista}
                    columns={veiculotabela}
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
              </div>
            </TabPanel>

            <div className="row g-3"></div>
            <TabPanel value={value} index={2}>
              <div className="row g-3">
                <Box sx={{ height: 450, width: '100%' }}>
                  <div className="col-sm-3">
                    Filtro Status
                    <Input
                      type="select"
                      onChange={(e) => setStatusFiltro(e.target.value)}
                      value={statusFiltro}
                      name="Status Filtro"
                    >
                      <option value="TODOS">TODOS</option>
                      <option value="ATIVO">ATIVO</option>
                      <option value="INATIVO">INATIVO</option>
                      <option value="BLOQUEADO">BLOQUEADO</option>
                    </Input>
                  </div>
                  <br />
                  <DataGrid
                    rows={filtraColaboradores}
                    columns={colaboradortabela}
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
              </div>
            </TabPanel>
          </Box>
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

Empresasedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.node,
  titulotopo: PropTypes.string,
};
export default Empresasedicao;

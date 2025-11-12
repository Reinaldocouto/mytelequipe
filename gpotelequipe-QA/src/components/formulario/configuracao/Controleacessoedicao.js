import { useState, useEffect } from 'react';
import {
  Col,
  Button,
  FormGroup,
  Row,
  Label,
  Input,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
  Form,
} from 'reactstrap';
import PropTypes from 'prop-types';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import { toast, ToastContainer } from 'react-toastify';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import SaltPassword from '../../../services/md5';
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

const Controleacessoedicao = ({ setshow, show, atualiza, ididentificador }) => {
  const [mensagem, setMensagem] = useState('');
  const [mensagemsucesso, setMensagemsucesso] = useState('');
  const [loading, setLoading] = useState(false);

  const [idusuario, setidusuario] = useState();
  const [nome, setnome] = useState();
  const [email, setemail] = useState();
  const [senha, setsenha] = useState();
  const [ativo, setativo] = useState(true);
  const [datacriacao, setdatacriacao] = useState();
  const [observacao, setobservacao] = useState();

  //selecionar todos
  const [selecionarTodos, setselecionarTodos] = useState('');

  const [modovisualizador, setmodovisualizador] = useState('');

  //cadastro
  const [pessoas, setpessoas] = useState('');
  const [produtos, setprodutos] = useState('');
  const [empresas, setempresas] = useState('');
  const [rh, setrh] = useState('');

  //gestão de frotas
  const [veiculos, setveiculos] = useState('');
  const [gestaoMultas, setgestaoMultas] = useState('');
  const [despesas, setdespesas] = useState('');
  const [monitoramento, setmonitoramento] = useState('');

  //suprimentos
  const [controleestoque, setcontroleestoque] = useState('');
  const [compras, setcompras] = useState('');
  const [solicitacao, setsolicitacao] = useState('');
  const [requisicao, setrequisicao] = useState('');
  const [solicitacaoavulsa, setsolicitacaoavulsa] = useState('');
  //Ericsson
  const [ericAcionamento, setEricAcionamento] = useState('');
  const [ericAdicional, setEricAdicional] = useState('');
  const [ericControleLpu, setEricControleLpu] = useState('');
  const [ericRelatorio, setEricRelatorio] = useState('');
  const [ericFaturamento, setEricFaturamento] = useState('');

  //Huawei
  const [huaAcionamento, setHuaAcionamento] = useState('');
  const [huaAdicional, setHuaAdicional] = useState('');
  const [huaControleLpu, setHuaControleLpu] = useState('');
  const [huaRelatorio, setHuaRelatorio] = useState('');

  //ZTE
  const [zteAcionamento, setZteAcionamento] = useState('');
  const [zteAdicional, setZteAdicional] = useState('');
  const [zteControleLpu, setZteControleLpu] = useState('');
  const [zteRelatorio, setZteRelatorio] = useState('');

  //COSMX
  const [cosControle, setCosControle] = useState('');
  const [cosRelatorio, setCosRelatorio] = useState('');
  const [cosControleLpu, setCosControleLpu] = useState('');

  const [telefonicaControle, setTelefonicaControle] = useState('');
  const [telefonicaRelatorio, setTelefonicaRelatorio] = useState('');
  const [telefonicaControleLpu, setTelefonicaControleLpu] = useState('');
  const [telefonicaEdicaoDocumentacao, setTelefonicaEdicaoDocumentacao] = useState('');
  const [telefonicaT4, setTelefonicaT4] = useState('');
  const [adicionarSiteManualmenteTelefonica, setAdicionarSiteManualmenteTelefonica] = useState('');
  const [marcarDesmarcarSiteAvulsoTelefonica, setMarcarDesmarcarSiteAvulsoTelefonica] =
    useState('');

  //Fechamento
  const [ericfechamento, setericfechamento] = useState('');
  const [huafechamento, sethuafechamento] = useState('');
  const [ztefechamento, setztefechamento] = useState('');
  const [cosfechamento, setcosfechamento] = useState('');
  const [telefonicafechamento, settelefonicafechamento] = useState('');

  //demonstrativo
  const [demonstrativo, setdemonstrativo] = useState('');

  //configurações
  const [controleacesso, setcontroleacesso] = useState('');

  const togglecadastro = () => {
    setshow(!show);
  };
  const [value, setValue] = useState(0);
  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idcontroleacessobusca: ididentificador,
    deletado: 0,
  };

  console.log(setLoading);
  console.log(params);

  const listacontroleacesso = async () => {
    try {
      setLoading(true);
      await api.get('v1/cadusuariosistemaid', { params }).then((response) => {
        setidusuario(response.data.idusuario);
        setnome(response.data.nome);
        setemail(response.data.email);
        //setsenha(response.data.senha);
        setativo(response.data.ativo);
        setdatacriacao(response.data.datacriacao);
        setobservacao(response.data.observacao);

        //selecionar todos
        setselecionarTodos(response.data.selecionarTodos);
        setmodovisualizador(response.data.modovisualizador);

        //cadastro
        setpessoas(response.data.pessoas);
        setprodutos(response.data.produtos);
        setempresas(response.data.empresas);
        setrh(response.data.rh);

        //gestao de frotas
        setveiculos(response.data.veiculos);
        setgestaoMultas(response.data.gestaomultas);
        setdespesas(response.data.despesas);
        setmonitoramento(response.data.monitoramento);

        //suprimentos
        setcontroleestoque(response.data.controleestoque);
        setcompras(response.data.compras);
        setsolicitacao(response.data.solicitacao);
        setrequisicao(response.data.requisicao);
        setsolicitacaoavulsa(response.data.solicitacaoavulsa);

        //Ericsson teste
        setEricAcionamento(response.data.ericacionamento);
        setEricAdicional(response.data.ericadicional);
        setEricControleLpu(response.data.ericcontrolelpu);
        setEricRelatorio(response.data.ericrelatorio);
        setEricFaturamento(response.data.ericfaturamento);

        //Huawei teste
        setHuaAcionamento(response.data.huaacionamento);
        setHuaAdicional(response.data.huaadicional);
        setHuaControleLpu(response.data.huacontrolelpu);
        setHuaRelatorio(response.data.huarelatorio);

        //ZTE teste
        setZteAcionamento(response.data.zteacionamento);
        setZteAdicional(response.data.zteadicional);
        setZteControleLpu(response.data.ztecontrolelpu);
        setZteRelatorio(response.data.zterelatorio);

        //COSMX teste
        setCosControle(response.data.coscontrole);
        setCosRelatorio(response.data.cosrelatorio);
        setCosControleLpu(response.data.coscontrolelpu);

        //Telefonica teste
        setTelefonicaControle(response.data.telefonicacontrole);
        setTelefonicaRelatorio(response.data.telefonicarelatorio);
        setTelefonicaControleLpu(response.data.telefonicacontrolelpu);
        setTelefonicaEdicaoDocumentacao(response.data.telefonicaedicaodocumentacao);
        setTelefonicaT4(response.data?.telefonicat4);
        setAdicionarSiteManualmenteTelefonica(response.data?.adicionarsitemanualmentetelefonica);
        setMarcarDesmarcarSiteAvulsoTelefonica(response.data?.marcardesmarcarsiteavulso);

        //Fechamento teste
        setericfechamento(response.data.ericfechamento);
        sethuafechamento(response.data.huafechamento);
        setztefechamento(response.data.ztefechamento);
        setcosfechamento(response.data.cosfechamento);
        settelefonicafechamento(response.data.telefonicafechamento);

        //demonstrativo teste
        setdemonstrativo(response.data.demonstrativo);

        //configurações
        setcontroleacesso(response.data.controleacesso);

        setMensagem('');
      });
    } catch (err) {
      setMensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  function ProcessaCadastro(e) {
    e.preventDefault();
    setMensagem('');
    setMensagemsucesso('');
    const novosErros = {};

    if (!nome) novosErros.nome = 'Por favor, preencha o nome';
    if (!email) novosErros.email = 'Por favor, preencha o e-mail';
    if (!datacriacao) novosErros.datacriacao = 'Por favor, informe a data de criação';

    // Mostra erros via toast e sai da função
    if (Object.keys(novosErros).length > 0) {
      Object.values(novosErros).forEach((msg) =>
        toast.error(msg, { position: 'top-right', autoClose: 3000 }),
      );
      return;
    }

    const dados = {
      idusuario: ididentificador,
      nome,
      email,
      ativo,
      observacao,
      datacriacao,
      selecionarTodos,
      modovisualizador,
      pessoas,
      produtos,
      empresas,
      rh,
      veiculos,
      gestaoMultas,
      despesas,
      monitoramento,
      controleestoque,
      compras,
      solicitacao,
      requisicao,
      solicitacaoavulsa,
      ericAcionamento,
      ericAdicional,
      ericControleLpu,
      ericRelatorio,
      ericFaturamento,
      huaAcionamento,
      huaAdicional,
      huaControleLpu,
      huaRelatorio,
      zteAcionamento,
      zteAdicional,
      zteControleLpu,
      telefonicaT4,
      zteRelatorio,
      cosControle,
      cosRelatorio,
      cosControleLpu,
      telefonicafechamento,
      telefonicaControle,
      telefonicaRelatorio,
      telefonicaControleLpu,
      telefonicaEdicaoDocumentacao,
      ericfechamento,
      huafechamento,
      ztefechamento,
      cosfechamento,
      demonstrativo,
      controleacesso,
      adicionarSiteManualmenteTelefonica,
      marcarDesmarcarSiteAvulsoTelefonica,
      idcliente: localStorage.getItem('sessionCodidcliente'),
      idloja: localStorage.getItem('sessionloja'),
    };

    if (senha) {
      dados.senha = SaltPassword(senha);
    } else {
      console.log('Sem senha');
      console.log('dados de atualização: ', dados);
    }

    console.log('Dados enviados:', dados);

    api
      .post('v1/cadusuariosistema', dados)
      .then((response) => {
        if (response.status === 201) {
          setMensagem('');
          setMensagemsucesso('Registro Salvo');
          setTimeout(() => {
            setshow(!show);
          }, 2000);
          atualiza();
          toast.success('Registro Salvo', {
            position: 'top-right',
            autoClose: 2000,
          });
          togglecadastro.bind(null);
          atualiza();
        } else {
          setMensagem(response.status);
          setMensagemsucesso('');
        }
      })
      .catch((err) => {
        if (err.response) {
          setMensagem(err.response.data.erro);
        } else {
          setMensagem('Ocorreu um erro na requisição.');
        }
        setMensagemsucesso('');
      });
  }

  useEffect(() => {
    listacontroleacesso();
  }, []);
  return (
    <div style={{ position: 'relative' }}>
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

      <Modal
        isOpen={show}
        toggle={togglecadastro.bind(null)}
        className="modal-dialog modal-xl modal-dialog-centered modal-fullscreen "
      >
        <ModalHeader toggle={togglecadastro.bind(null)}>Cadastro Usuários do Sistema</ModalHeader>
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
          {loading ? (
            <Loader />
          ) : (
            <>
              <Row>
                <Col md="12">
                  <div className="row g-3">
                    <div className="col-sm-3">
                      <Input
                        type="hidden"
                        onChange={(e) => setidusuario(e.target.value)}
                        value={idusuario}
                      />
                      Nome
                      <Input
                        type="text"
                        onChange={(e) => setnome(e.target.value)}
                        value={nome}
                        placeholder=""
                      />
                    </div>
                    <div className="col-sm-3">
                      Email
                      <Input
                        type="text"
                        onChange={(e) => setemail(e.target.value)}
                        value={email}
                        placeholder=""
                      />
                    </div>
                    <div className="col-sm-2">
                      Senha
                      <Input
                        type="password"
                        onChange={(e) => setsenha(e.target.value)}
                        //value={senhaa}
                        placeholder=""
                      />
                    </div>
                    <div className="col-sm-2">
                      Data Criação
                      <Input
                        type="date"
                        onChange={(e) => setdatacriacao(e.target.value)}
                        value={datacriacao}
                        placeholder=""
                      />
                    </div>
                    <div className="col-sm-2">
                      Status
                      <Form inline>
                        <div className="form-check form-check-inline">
                          <Input
                            className="form-check-input"
                            type="checkbox"
                            id="inlineCheckbox2"
                            checked={ativo}
                            onChange={(e) => setativo(e.target.checked)}
                          />
                          <Label for="inlineCheckbox2">Ativo</Label>
                        </div>
                      </Form>
                    </div>
                  </div>
                </Col>
              </Row>
              <br />
              <Row>
                <Col md="12">
                  <div className="row g-3">
                    <FormGroup>
                      Observação
                      <Input
                        type="textarea"
                        onChange={(e) => setobservacao(e.target.value)}
                        value={observacao}
                        placeholder=""
                      />
                    </FormGroup>
                  </div>
                </Col>
              </Row>
              <Row>
                <Col md="12">
                  <div className="row g-1">
                    <FormGroup check>
                      <Input
                        type="checkbox"
                        id="checkVisualizador"
                        onChange={(e) => setmodovisualizador(e.target.checked)}
                        checked={modovisualizador}
                      />
                      <Label check>Modo Visualizador</Label>
                    </FormGroup>
                  </div>
                </Col>
              </Row>
              <Row>
                <Col md="12">
                  <div className="row g-1">
                    <FormGroup check>
                      <Input
                        type="checkbox"
                        id="check7"
                        onChange={(e) => setselecionarTodos(e.target.checked)}
                        checked={selecionarTodos}
                      />
                      <Label check>Selecionar Todos</Label>
                    </FormGroup>
                  </div>
                </Col>
              </Row>

              <Box sx={{ width: '100%' }}>
                <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
                  <Tabs value={value} onChange={handleChange} aria-label="basic tabs example">
                    <Tab label="Cadastros" {...a11yProps(0)} />
                    <Tab label="Gestão de Frotas" {...a11yProps(1)} />
                    <Tab label="Suprimentos" {...a11yProps(2)} />
                    <Tab label="Ericsson" {...a11yProps(3)} />
                    <Tab label="Huawei" {...a11yProps(4)} />
                    <Tab label="ZTE" {...a11yProps(5)} />
                    <Tab label="COSMX" {...a11yProps(6)} />
                    <Tab label="Telefonica" {...a11yProps(7)} />
                    <Tab label="Fechamento" {...a11yProps(8)} />
                    <Tab label="Demonstrativo" {...a11yProps(9)} />
                    <Tab label="Configurações" {...a11yProps(10)} />
                  </Tabs>
                </Box>
                <TabPanel value={value} index={0}>
                  <Row>
                    <Col md="12">
                      <FormGroup>
                        <div className="row g-3">
                          <div className="col-sm-6">
                            {/**CADASTRO */}
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check1"
                                checked={pessoas}
                                onChange={(e) => setpessoas(e.target.checked)}
                              />
                              <Label check>Pessoas</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check2"
                                checked={produtos}
                                onChange={(e) => setprodutos(e.target.checked)}
                              />
                              <Label check>Produtos</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check3"
                                checked={empresas}
                                onChange={(e) => setempresas(e.target.checked)}
                              />
                              <Label check>Empresas</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check4"
                                checked={rh}
                                onChange={(e) => setrh(e.target.checked)}
                              />
                              <Label check>RH</Label>
                            </FormGroup>
                          </div>
                        </div>
                      </FormGroup>
                    </Col>
                  </Row>
                </TabPanel>
                <TabPanel value={value} index={1}>
                  <Row>
                    <Col md="12">
                      <FormGroup>
                        <div className="row g-3">
                          <div className="col-sm-6">
                            {/**GESTÃO DE FROTAS*/}
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check7"
                                onChange={(e) => setveiculos(e.target.checked)}
                                checked={veiculos}
                              />
                              <Label check>Veículos</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check7"
                                onChange={(e) => setgestaoMultas(e.target.checked)}
                                checked={gestaoMultas}
                              />
                              <Label check>Gestão de Multas</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check7"
                                onChange={(e) => setdespesas(e.target.checked)}
                                checked={despesas}
                              />
                              <Label check>Despesas</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check7"
                                onChange={(e) => setmonitoramento(e.target.checked)}
                                checked={monitoramento}
                              />
                              <Label check>Monitoramento</Label>
                            </FormGroup>
                          </div>
                        </div>
                      </FormGroup>
                    </Col>
                  </Row>
                </TabPanel>
                <TabPanel value={value} index={2}>
                  <Row>
                    <Col md="12">
                      <FormGroup>
                        <div className="row g-3">
                          <div className="col-sm-6">
                            {/**SUPRIMENTOS */}
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setcontroleestoque(e.target.checked)}
                                checked={controleestoque}
                              />
                              <Label check>Controle de Estoque</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setcompras(e.target.checked)}
                                checked={compras}
                              />
                              <Label check>Compras</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setsolicitacao(e.target.checked)}
                                checked={solicitacao}
                              />
                              <Label check>Solicitação de Material</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setrequisicao(e.target.checked)}
                                checked={requisicao}
                              />
                              <Label check>Requisição de Material</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setsolicitacaoavulsa(e.target.checked)}
                                checked={solicitacaoavulsa}
                              />
                              <Label check>Solicitação de Material Avulso</Label>
                            </FormGroup>
                          </div>
                        </div>
                      </FormGroup>
                    </Col>
                  </Row>
                </TabPanel>
                <TabPanel value={value} index={3}>
                  <Row>
                    <Col md="12">
                      <FormGroup>
                        <div className="row g-3">
                          <div className="col-sm-6">
                            {/**ERICSSON */}
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setEricAcionamento(e.target.checked)}
                                checked={ericAcionamento}
                              />
                              <Label check>Acionamento</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setEricAdicional(e.target.checked)}
                                checked={ericAdicional}
                              />
                              <Label check>Adicional</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setEricControleLpu(e.target.checked)}
                                checked={ericControleLpu}
                              />
                              <Label check>Controle LPU</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setEricRelatorio(e.target.checked)}
                                checked={ericRelatorio}
                              />
                              <Label check>Relatório</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setEricFaturamento(e.target.checked)}
                                checked={ericFaturamento}
                              />
                              <Label check>Faturamento</Label>
                            </FormGroup>
                          </div>
                        </div>
                      </FormGroup>
                    </Col>
                  </Row>
                </TabPanel>
                <TabPanel value={value} index={4}>
                  <Row>
                    <Col md="12">
                      <FormGroup>
                        <div className="row g-3">
                          <div className="col-sm-6">
                            {/**HUAWEI */}
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setHuaAcionamento(e.target.checked)}
                                checked={huaAcionamento}
                              />
                              <Label check>Acionamento</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setHuaAdicional(e.target.checked)}
                                checked={huaAdicional}
                              />
                              <Label check>Adicional</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setHuaControleLpu(e.target.checked)}
                                checked={huaControleLpu}
                              />
                              <Label check>Controle LPU</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setHuaRelatorio(e.target.checked)}
                                checked={huaRelatorio}
                              />
                              <Label check>Relatório</Label>
                            </FormGroup>
                          </div>
                        </div>
                      </FormGroup>
                    </Col>
                  </Row>
                </TabPanel>
                <TabPanel value={value} index={5}>
                  <Row>
                    <Col md="12">
                      <FormGroup>
                        <div className="row g-3">
                          <div className="col-sm-6">
                            {/**ZTE */}
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setZteAcionamento(e.target.checked)}
                                checked={zteAcionamento}
                              />
                              <Label check>Acionamento</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setZteAdicional(e.target.checked)}
                                checked={zteAdicional}
                              />
                              <Label check>Adicional</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setZteControleLpu(e.target.checked)}
                                checked={zteControleLpu}
                              />
                              <Label check>Controle LPU</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setZteRelatorio(e.target.checked)}
                                checked={zteRelatorio}
                              />
                              <Label check>Relatório</Label>
                            </FormGroup>
                          </div>
                        </div>
                      </FormGroup>
                    </Col>
                  </Row>
                </TabPanel>
                <TabPanel value={value} index={6}>
                  <Row>
                    <Col md="12">
                      <FormGroup>
                        <div className="row g-3">
                          <div className="col-sm-6">
                            {/**COSMX */}
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setCosControle(e.target.checked)}
                                checked={cosControle}
                              />
                              <Label check>Controle</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setCosRelatorio(e.target.checked)}
                                checked={cosRelatorio}
                              />
                              <Label check>Relatório</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setCosControleLpu(e.target.checked)}
                                checked={cosControleLpu}
                              />
                              <Label check>Controle LPU</Label>
                            </FormGroup>
                          </div>
                        </div>
                      </FormGroup>
                    </Col>
                  </Row>
                </TabPanel>
                <TabPanel value={value} index={7}>
                  <Row>
                    <Col md="12">
                      <FormGroup>
                        <div className="row g-3">
                          <div className="col-sm-6">
                            {/**Telefonica*/}
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setTelefonicaControle(e.target.checked)}
                                checked={telefonicaControle}
                              />
                              <Label check>Controle</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setTelefonicaRelatorio(e.target.checked)}
                                checked={telefonicaRelatorio}
                              />
                              <Label check>Relatório</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setTelefonicaControleLpu(e.target.checked)}
                                checked={telefonicaControleLpu}
                              />
                              <Label check>Controle LPU</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check23"
                                onChange={(e) => setTelefonicaEdicaoDocumentacao(e.target.checked)}
                                checked={telefonicaEdicaoDocumentacao}
                              />
                              <Label check>Edição da documentação</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check23"
                                onChange={(e) => setTelefonicaT4(e.target.checked)}
                                checked={telefonicaT4}
                              />
                              <Label check>Faturamento</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check25"
                                onChange={(e) =>
                                  setAdicionarSiteManualmenteTelefonica(e.target.checked)
                                }
                                checked={adicionarSiteManualmenteTelefonica}
                              />
                              <Label check>Adicionar SITE manualmente</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check26"
                                onChange={(e) =>
                                  setMarcarDesmarcarSiteAvulsoTelefonica(e.target.checked)
                                }
                                checked={marcarDesmarcarSiteAvulsoTelefonica}
                              />
                              <Label check>Marcação/Desmarcação de site como avulso</Label>
                            </FormGroup>
                          </div>
                        </div>
                      </FormGroup>
                    </Col>
                  </Row>
                </TabPanel>
                <TabPanel value={value} index={8}>
                  <Row>
                    <Col md="12">
                      <FormGroup>
                        <div className="row g-3">
                          <div className="col-sm-6">
                            {/**ZTE */}
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setericfechamento(e.target.checked)}
                                checked={ericfechamento}
                              />
                              <Label check>Ericsson</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => sethuafechamento(e.target.checked)}
                                checked={huafechamento}
                              />
                              <Label check>Huawei</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setztefechamento(e.target.checked)}
                                checked={ztefechamento}
                              />
                              <Label check>ZTE</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setcosfechamento(e.target.checked)}
                                checked={cosfechamento}
                              />
                              <Label check>COSMX</Label>
                            </FormGroup>
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => settelefonicafechamento(e.target.checked)}
                                checked={telefonicafechamento}
                              />
                              <Label check>Telefonica</Label>
                            </FormGroup>
                          </div>
                        </div>
                      </FormGroup>
                    </Col>
                  </Row>
                </TabPanel>
                <TabPanel value={value} index={9}>
                  <Row>
                    <Col md="12">
                      <FormGroup>
                        <div className="row g-3">
                          <div className="col-sm-6">
                            {/**DEMONSTRATIVO*/}
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setdemonstrativo(e.target.checked)}
                                checked={demonstrativo}
                              />
                              <Label check>Demonstrativo</Label>
                            </FormGroup>
                          </div>
                        </div>
                      </FormGroup>
                    </Col>
                  </Row>
                </TabPanel>
                <TabPanel value={value} index={10}>
                  <Row>
                    <Col md="12">
                      <FormGroup>
                        <div className="row g-3">
                          <div className="col-sm-6">
                            {/**CONFIGURAÇÕES*/}
                            <FormGroup check>
                              <Input
                                type="checkbox"
                                id="check22"
                                onChange={(e) => setcontroleacesso(e.target.checked)}
                                checked={controleacesso}
                              />
                              <Label check>Controle de acesso</Label>
                            </FormGroup>
                          </div>
                        </div>
                      </FormGroup>
                    </Col>
                  </Row>
                </TabPanel>
              </Box>
            </>
          )}
        </ModalBody>
        <ModalFooter>
          <Button color="success" onClick={ProcessaCadastro} disabled={modoVisualizador()}>
            Salvar
          </Button>
          <Button color="secondary" onClick={togglecadastro.bind(null)}>
            Sair
          </Button>
        </ModalFooter>
      </Modal>
    </div>
  );
};

Controleacessoedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.node,
};

export default Controleacessoedicao;

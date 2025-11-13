import { useState, useEffect } from 'react';
import {
  Col,
  Button,
  //Form,
  FormGroup,
  Input,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
} from 'reactstrap';
import PropTypes from 'prop-types';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import Codigobarrasadicional from './Codigobarrasadicional';
import Excluirregistro from '../../Excluirregistro';
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

const Produtosedicao = ({ setshow, show, ididentificador, atualiza }) => {
  const [value, setValue] = useState(0);
  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  const [mensagem, setMensagem] = useState('');
  const [mensagemsucesso, setMensagemsucesso] = useState('');
  const [loading, setLoading] = useState(false);
  const [idproduto, setidproduto] = useState('');
  const [descricao, setdescricao] = useState('');
  const [codigo, setcodigo] = useState('');
  const [origem, setorigem] = useState('');
  const [tipoproduto, settipoproduto] = useState('');
  const [ncm, setncm] = useState('');
  const [codigobarra, setcodigobarra] = useState('');
  const [cest, setcest] = useState('');
  const [preco, setpreco] = useState('');
  const [unidade, setunidade] = useState('');
  const [pesoliquido, setpesoliquido] = useState(0);
  const [pesobruto, setpesobruto] = useState(0);
  const [larguraembalagem, setlarguraembalagem] = useState(0);
  const [alturaembalagem, setalturaembalagem] = useState(0);
  const [comprimentoembalagem, setcomprimentoembalagem] = useState(0);
  const [tipoembalagem, settipoembalagem] = useState('');
  const [tabelamedidas, settabelamedidas] = useState('');
  const [descricaocomplementar, setdescricaocomplementar] = useState('');
  const [controlarestoque, setcontrolarestoque] = useState('');
  const [estoque, setestoque] = useState('');
  const [estoqueinicial, setestoqueinicial] = useState('');
  const [estminimo, setestminimo] = useState('');
  const [estmaximo, setestmaximo] = useState('');
  const [sobencomenda, setsobencomenda] = useState('');
  const [localizacao, setlocalizacao] = useState('');
  const [diasparapreparacao, setdiasparapreparacao] = useState('');
  const [categoria1, setcategoria1] = useState('');
  const [categoria2, setcategoria2] = useState('');
  const [categoria3, setcategoria3] = useState('');
  const [subcategoria1, setsubcategoria1] = useState('');
  const [subcategoria2, setsubcategoria2] = useState('');
  const [subcategoria3, setsubcategoria3] = useState('');
  const [marca, setmarca] = useState('');
  const [anexo, setanexo] = useState('');
  const [linkvideo, setlinkvideo] = useState('');
  const [tituloseo, settituloseo] = useState('');
  const [descricaoseo, setdescricaoseo] = useState('');
  const [keywords, setkeywords] = useState('');
  const [slug, setslug] = useState('');
  const [unidadecaixa, setunidadecaixa] = useState('');
  const [custo, setcusto] = useState('');
  const [custocomposto, setcustocomposto] = useState('');
  const [linhaproduto, setlinhaproduto] = useState('');
  const [garantia, setgarantia] = useState('');
  const [eantributavel, seteantributavel] = useState('');
  const [fatorconversao, setfatorconversao] = useState('');
  const [codigoipi, setcodigoipi] = useState('');
  const [valoripi, setvaloripi] = useState('');
  const [cstipi, setcstipi] = useState('');
  const [unidadetributavel, setunidadetributavel] = useState('');
  const [nomefornecedor, setnomefornecedor] = useState('');
  const [codigofornecedor, setcodigofornecedor] = useState('');
  const [observacaogeral, setobservacaogeral] = useState('');
  const [telacadastro, settelacadastro] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [enderecoimagem, setenderecoimagem] = useState('');
  const [ativo, setativo] = useState('');
  const [categoria, setcategoria] = useState('');

  const togglecadastro = () => {
    setshow(!show);
  };

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idprodutobusca: ididentificador,
    deletado: 0,
    aviso: 'PRODUTO EDICAO',
  };

  const listaprodutos = async () => {
    try {
      setLoading(true);
      await api.get('/v1/produtoid', { params }).then((response) => {
        setidproduto(response.data.idproduto);
        setdescricao(response.data.descricao);
        setcodigo(response.data.codigosku);
        setorigem(response.data.idorigem);
        settipoproduto(response.data.idtipoproduto);
        setcategoria(response.data.categoria);
        setncm(response.data.ncm);
        setcodigobarra(response.data.codigobarra);
        setcest(response.data.cest);
        setpreco(response.data.preco);
        setunidade(response.data.unidade);
        setpesoliquido(response.data.pesoliquido);
        setpesobruto(response.data.pesobruto);
        setlarguraembalagem(response.data.larguraembalagem);
        setalturaembalagem(response.data.alturaembalagem);
        setcomprimentoembalagem(response.data.comprimentoembalagem);
        settipoembalagem(response.data.tipoembalagem);
        setcontrolarestoque(response.data.controlarestoque);
        setestoque(response.data.estoque);
        setestoqueinicial(response.data.estoqueinicial);
        setestminimo(response.data.estminimo);
        setestmaximo(response.data.estmaximo);
        setsobencomenda(response.data.sobencomenda);
        setlocalizacao(response.data.localizacao);
        setdiasparapreparacao(response.data.diasparapreparacao);
        setdescricaocomplementar(response.data.descricaocomplementar);
        setcategoria1(response.data.idcategoria1);
        setcategoria2(response.data.idcategoria2);
        setcategoria3(response.data.idcategoria3);
        setsubcategoria1(response.data.idsubcategoria1);
        setsubcategoria2(response.data.idsubcategoria2);
        setsubcategoria3(response.data.idsubcategoria3);
        setmarca(response.data.idmarca);
        setlinkvideo(response.data.linkvideo);
        settituloseo(response.data.tituloseo);
        setdescricaoseo(response.data.descricaoseo);
        setkeywords(response.data.keywords);
        setslug(response.data.slug);
        setunidadecaixa(response.data.unidadecaixa);
        setcusto(response.data.custo);
        setcustocomposto(response.data.custocomposto);
        setlinhaproduto(response.data.linhaproduto);
        setgarantia(response.data.garantia);
        seteantributavel(response.data.eantributavel);
        setfatorconversao(response.data.fatorconversao);
        setcodigoipi(response.data.codigoipi);
        setvaloripi(response.data.valoripi);
        setcstipi(response.data.cstipi);
        setunidadetributavel(response.data.unidadetributavel);
        setnomefornecedor(response.data.nomefornecedor);
        setcodigofornecedor(response.data.codigofornecedor);
        setobservacaogeral(response.data.observacaogeral);
        setanexo(response.data.anexo);
        settabelamedidas(response.data.tabelamedidas);
        setenderecoimagem(response.data.enderecoimagem);
        setMensagem('');
        setativo(response.data.ativo);
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
    api
      .post('v1/produto', {
        idproduto: ididentificador,
        descricao,
        codigo,
        origem,
        tipoproduto,
        ncm,
        codigobarra,
        cest,
        preco,
        unidade,
        categoria,
        pesoliquido,
        pesobruto,
        larguraembalagem,
        alturaembalagem,
        comprimentoembalagem,
        tipoembalagem,
        controlarestoque,
        estoque,
        estoqueinicial,
        estminimo,
        estmaximo,
        sobencomenda,
        localizacao,
        diasparapreparacao,
        descricaocomplementar,
        categoria1,
        categoria2,
        categoria3,
        subcategoria1,
        subcategoria2,
        subcategoria3,
        marca,
        linkvideo,
        tituloseo,
        descricaoseo,
        keywords,
        slug,
        unidadecaixa,
        custo,
        custocomposto,
        linhaproduto,
        garantia,
        eantributavel,
        fatorconversao,
        codigoipi,
        valoripi,
        cstipi,
        unidadetributavel,
        nomefornecedor,
        codigofornecedor,
        observacaogeral,
        anexo,
        tabelamedidas,
        enderecoimagem,
        ativo,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setMensagem('');
          setMensagemsucesso('Registro Salvo');
          setshow(!show);
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

  const iniciatabelas = () => {
    listaprodutos();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <Modal
      isOpen={show}
      toggle={togglecadastro}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-xl modal-dialog-scrollable modal-fullscreen "
    >
      <ModalHeader toggle={togglecadastro} style={{ backgroundColor: 'white' }}>
        Cadastro Produtos
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
        {mensagem.length > 0 ? (
          <div className="alert alert-danger mt-2" role="alert">
            {mensagem}
          </div>
        ) : null}
        {mensagemsucesso.length > 0 ? (
          <div className="alert alert-success" role="alert">
            Registro Salvo
          </div>
        ) : null}
        {telacadastro ? (
          <Codigobarrasadicional
            show={telacadastro}
            setshow={settelacadastro}
            ididentificador={ididentificador}
            titulotopo="Novo Código de Barras"
          />
        ) : null}
        {telaexclusao ? (
          <>
            <Excluirregistro
              show={telaexclusao}
              setshow={settelaexclusao}
              ididentificador={ididentificador}
              quemchamou="CODIGOBARRAADICIONAL"
              idlojaatual={localStorage.getItem('sessionloja')}
            />{' '}
          </>
        ) : null}

        {loading ? (
          <Loader />
        ) : (
          <Box sx={{ width: '100%' }}>
            <Box sx={{ borderBottom: 1, borderColor: 'divider', textAlign: 'right' }}>
              <Tabs value={value} onChange={handleChange} aria-label="basic tabs example">
                <Tab label="Dados Gerais" {...a11yProps(0)} />
              </Tabs>
            </Box>

            <TabPanel value={value} index={0}>
              <Col m="12">
                <FormGroup>
                  <p>
                    <b>Dados do Produto</b>
                  </p>
                  <div className="row g-3">
                    <div className="col-sm-9">
                      <Input
                        type="hidden"
                        onChange={(e) => setidproduto(e.target.value)}
                        value={idproduto}
                        placeholder="Descrição completa"
                      />
                      Descrição
                      <Input
                        type="text"
                        onChange={(e) => setdescricao(e.target.value)}
                        value={descricao}
                        placeholder="Descrição completa"
                      />
                    </div>
                    <div className="col-sm-3">
                      Codigo SKU
                      <Input
                        type="text"
                        onChange={(e) => setcodigo(e.target.value)}
                        value={codigo}
                        placeholder="Código SKU ou referência"
                      />
                    </div>
                  </div>
                </FormGroup>
              </Col>
              <Col m="12">
                <FormGroup>
                  <div className="row g-3">
                    <div className="col-sm-3">
                      Origem
                      <Input
                        type="select"
                        onChange={(e) => setorigem(e.target.value)}
                        value={origem}
                        name="origem"
                      >
                        <option value="0">Selecione</option>
                        <option value="1">Nacional</option>
                        <option value="2">Estrangeira</option>
                      </Input>
                    </div>
                    <div className="col-sm-3">
                      Categoria
                      <Input
                        type="select"
                        onChange={(e) => setcategoria(e.target.value)}
                        value={categoria}
                        name="categoria"
                      >
                        <option>Selecione</option>
                        <option>ATIVOS</option>
                        <option>CIVIL</option>
                        <option>ELETRICA</option>
                        <option>EPIs</option>
                        <option>ESTRUTURA METALICA</option>
                        <option>FERRAMENTAL</option>
                        <option>FROTA</option>
                        <option>PRESTACAO SERVICO </option>
                        <option>USO E CONSUMO </option>
                      </Input>
                    </div>
                    <div className="col-sm-3">
                      Unidade
                      <Input
                        type="select"
                        onChange={(e) => setunidade(e.target.value)}
                        value={unidade}
                        name=""
                      >
                        <option>Selecione</option>
                        <option>unidade</option>
                        <option>Barra (BR)</option>
                        <option>Bobina (BOB)</option>
                        <option>Caixa (CX)</option>
                        <option>Conjunto (CJ)</option>
                        <option>Galão (GL)</option>
                        <option>Jogo (JG)</option>
                        <option>Kit (KI)</option>
                        <option>Kit (KIT</option>)<option>Lata (LATA)</option>
                        <option>Litro (LT)</option>
                        <option>Metro (M)</option>
                        <option>Metro (METRO)</option>
                        <option>Metro Quadrado (M2)</option>
                        <option>Pacote (PAC)</option>
                        <option>Pacote (PCT)</option>
                        <option>Par (PAR)</option>
                        <option>Par (PR)</option>
                        <option>Peça (PC)</option>
                        <option>Quilograma (KG)</option>
                        <option>Rolo (RL)</option>
                        <option>Saco (SC)</option>
                        <option>Unidade (UN)</option>
                        <option>Unidade (UND)</option>
                        <option>Unidade (UNID)</option>
                        <option>Verba (VB)</option>
                      </Input>
                    </div>
                    <div className="col-sm-3">
                      Ativo
                      <Input
                        type="select"
                        onChange={(e) => setativo(e.target.value)}
                        value={ativo}
                        name="ativo"
                      >
                        <option value="0">Habilitado</option>
                        <option value="1">Desabilitado Total</option>
                        <option value="2">Desabilitado Parcial</option>
                      </Input>
                    </div>
                  </div>
                </FormGroup>
              </Col>
              <hr />
              <p>
                <b>Estoque</b>
              </p>
              <Col m="12">
                <FormGroup>
                  <div className="row g-3">
                    <div className="col-sm-2">
                      Controlar Estoque
                      <Input
                        type="select"
                        onChange={(e) => setcontrolarestoque(e.target.value)}
                        value={controlarestoque}
                        name=""
                      >
                        <option value="0">Selecione</option>
                        <option value="1">Sim</option>
                        <option value="2">Não</option>
                      </Input>
                    </div>
                    {/* 
                                        <div className="col-sm-2">
                                            Estoque Inicial
                                            <Input type="text" onChange={(e) => setestoqueinicial(e.target.value)} value={estoqueinicial} placeholder="0" />
                                        </div>
                                        */}
                    <div className="col-sm-2">
                      Estoque Mínimo
                      <Input
                        type="text"
                        onChange={(e) => setestminimo(e.target.value)}
                        value={estminimo}
                        placeholder="0"
                      />
                    </div>
                    <div className="col-sm-2">
                      Estoque Máximo
                      <Input
                        type="text"
                        onChange={(e) => setestmaximo(e.target.value)}
                        value={estmaximo}
                        placeholder="0"
                      />
                    </div>
                    <div className="col-sm-2">
                      Localização
                      <Input
                        type="text"
                        onChange={(e) => setlocalizacao(e.target.value)}
                        value={localizacao}
                        placeholder="Localização Física"
                      />
                    </div>
                    <div className="col-sm-2">
                      Sob Encomenda
                      <Input
                        type="select"
                        onChange={(e) => setsobencomenda(e.target.value)}
                        value={sobencomenda}
                        name=""
                      >
                        <option value="0">Selecione</option>
                        <option value="1">Sim</option>
                        <option value="2">Não</option>
                      </Input>
                    </div>
                    <div className="col-sm-2">
                      Dias para Preparação
                      <Input
                        type="text"
                        onChange={(e) => setdiasparapreparacao(e.target.value)}
                        value={diasparapreparacao}
                        placeholder="0"
                      />
                    </div>
                  </div>
                </FormGroup>
              </Col>
            </TabPanel>
          </Box>
        )}
      </ModalBody>
      <ModalFooter style={{ backgroundColor: 'white' }}>
        <Button color="success" onClick={ProcessaCadastro} disabled={modoVisualizador()}>
          Salvar
        </Button>
        <Button color="secondary" onClick={togglecadastro}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Produtosedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.node,
};

export default Produtosedicao;

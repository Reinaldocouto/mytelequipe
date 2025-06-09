import { useState, useEffect } from 'react';
import {
    Col,
    Button,
    FormGroup,
    InputGroup,
    Row,
    Input,
    Modal,
    ModalBody,
    ModalHeader,
    ModalFooter
} from 'reactstrap';
import { Box } from '@mui/material';
import PropTypes from 'prop-types';
import Typography from '@mui/material/Typography';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
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

const Fornecedoredicao = ({ setshow, show, ididentificador, atualiza, titulotopo }) => {

    const [mensagem, setmensagem] = useState('');
    const [mensagemsucesso, setmensagemsucesso] = useState('');
    const [loading, setLoading] = useState(false);
    const [nome, setnome] = useState();
    const [fantasia, setfantasia] = useState();
    const [logradouro, setlogradouro] = useState();
    const [bairro, setbairro] = useState();
    const [numero, setnumero] = useState();
    const [cidade, setcidade] = useState();
    const [uf, setuf] = useState();
    const [cep, setcep] = useState();
    const [complemento, setcomplemento] = useState();

    const [celular, setcelular] = useState();
    const [email, setemail] = useState();
    const [telefone, settelefone] = useState();

    const [idfornecedor, setidfornecedor] = useState();

    const togglecadastro = () => {
        setshow(!show);
    }

    //Parametros
    const params = {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        idpessoabusca: ididentificador,
        deletado: 0
    };

    const listafornecedor = async () => {
        try {
            setLoading(true);
            await api.get('/v1/fornecedorid', { params })
                .then(response => {
                    setidfornecedor(response.data.idfornecedor);
                    setnome(response.data.nome);
                    setfantasia(response.data.fantasia);
                    setlogradouro(response.data.logradouro);
                    setbairro(response.data.bairro);
                    setnumero(response.data.numero);
                    setcidade(response.data.cidade);
                    setuf(response.data.uf);
                    setcep(response.data.cep);
                    setcomplemento(response.data.complemento);
                    setcelular(response.data.celular);
                    settelefone(response.data.telefone);
                    setemail(response.data.email);
                    setmensagem('');
                })
        } catch (err) {
            setmensagem(err.message);
        } finally {
            setLoading(false);
        }
    }

    const consultacep = (cepdigitado) => {
        fetch(`https://viacep.com.br/ws/${cepdigitado}/json/`)
            .then(res => res.json()).then(data => {
                setlogradouro(data.logradouro)
                setbairro(data.bairro)
                setcidade(data.localidade)
                setuf(data.uf)
            })
    }

    function ProcessaCadastro(e) {
        e.preventDefault();
        setmensagem('');
        setmensagemsucesso('');
        api.post('v1/fornecedor', {
            idfornecedor: ididentificador,
            nome,
            fantasia,
            logradouro,
            bairro,
            numero,
            cidade,
            uf,
            cep,
            complemento,
            celular,
            telefone,
            email,
            idcliente: localStorage.getItem('sessionCodidcliente'),
            idusuario: localStorage.getItem('sessionId'),
            idloja: localStorage.getItem('sessionloja'),
        })
            .then(response => {
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
            .catch(err => {
                if (err.response) {
                    setmensagem(err.response.data.erro);
                } else {
                    setmensagem('Ocorreu um erro na requisição.');
                }
                setmensagemsucesso('');
            });
    }

    function mexernocep(evento) {
        if (evento !== null) {
            setcep(evento);
        }
        else {
            setcep('');
            setlogradouro('');
            setnumero('');
            setbairro('');
            setcidade('');
            setuf('');
        }
    }

    const iniciatabelas = () => {
        if (titulotopo !== 'Novo Fornecedor') {
            listafornecedor();
        }
    }

    useEffect(() => {iniciatabelas();}, []);
    return (
      <Modal
        isOpen={show}
        toggle={togglecadastro.bind(null)}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-xl modal-dialog-scrollable"
      >
        <ModalHeader toggle={togglecadastro.bind(null)}>Fornecedor</ModalHeader>
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
            <FormGroup>
              <Box sx={{ width: '100%' }}>
                <Col md="12">
                  <FormGroup>
                    <p>
                      <b>Dados</b>
                    </p>
                    <div className="row g-3">
                      <div className="col-sm-6">
                        <Input
                          type="hidden"
                          onChange={(e) => setidfornecedor(e.target.value)}
                          value={idfornecedor}
                        />
                        Nome*
                        <Input
                          type="text"
                          onChange={(e) => setnome(e.target.value)}
                          value={nome}
                          placeholder="Nome ou Razão Social"
                        />
                      </div>
                      <div className="col-sm-6">
                        Fantasia
                        <Input
                          type="text"
                          onChange={(e) => setfantasia(e.target.value)}
                          value={fantasia}
                          placeholder=""
                        />
                      </div>
                    </div>
                  </FormGroup>
                </Col>
                <hr />
                <p>
                  <b>Endereço</b>
                </p>
                <div className="row g-3">
                  <Col md="2">
                    <FormGroup>
                      CEP
                      <InputGroup>
                        <Input
                          type="search"
                          onChange={(e) => mexernocep(e.target.value)}
                          value={cep}
                          placeholder=""
                        />
                        <Button
                          color="primary"
                          onClick={() => consultacep(cep)}
                          title="Clique para pesquisar o CEP"
                        >
                          <i className="bi bi-search"></i>
                        </Button>
                      </InputGroup>
                    </FormGroup>
                  </Col>
                  <Col md="8">
                    <FormGroup>
                      Endereço
                      <Input
                        type="text"
                        onChange={(e) => setlogradouro(e.target.value)}
                        value={logradouro}
                        placeholder=""
                      />
                    </FormGroup>
                  </Col>
                  <Col md="2">
                    <FormGroup>
                      Número
                      <Input
                        type="text"
                        onChange={(e) => setnumero(e.target.value)}
                        value={numero}
                        placeholder=""
                      />
                    </FormGroup>
                  </Col>
                  <Col md="4">
                    <FormGroup>
                      Complemento
                      <Input
                        type="text"
                        onChange={(e) => setcomplemento(e.target.value)}
                        value={complemento}
                        placeholder=""
                      />
                    </FormGroup>
                  </Col>
                  <Col md="3">
                    <FormGroup>
                      Bairro
                      <Input
                        type="text"
                        onChange={(e) => setbairro(e.target.value)}
                        value={bairro}
                        placeholder=""
                      />
                    </FormGroup>
                  </Col>
                  <Col md="3">
                    <FormGroup>
                      Cidade
                      <Input
                        type="text"
                        onChange={(e) => setcidade(e.target.value)}
                        value={cidade}
                        placeholder=""
                      />
                    </FormGroup>
                  </Col>
                  <Col md="2">
                    <FormGroup>
                      UF
                      <Input
                        type="text"
                        onChange={(e) => setuf(e.target.value)}
                        value={uf}
                        name="UF"
                      ></Input>
                    </FormGroup>
                  </Col>
                </div>
                <hr />
                <p>
                  <b>Contato</b>
                </p>
                <Row>
                  <Col md="4">
                    <FormGroup>
                      Celular
                      <Input
                        type="email"
                        onChange={(e) => setcelular(e.target.value)}
                        value={celular}
                        placeholder=""
                      />
                    </FormGroup>
                  </Col>
                  <Col md="4">
                    <FormGroup>
                      Telefone
                      <Input
                        type="email"
                        onChange={(e) => settelefone(e.target.value)}
                        value={telefone}
                        placeholder=""
                      />
                    </FormGroup>
                  </Col>
                  <Col md="4">
                    <FormGroup>
                      Email
                      <Input
                        type="email"
                        onChange={(e) => setemail(e.target.value)}
                        value={email}
                        placeholder=""
                      />
                    </FormGroup>
                  </Col>
                </Row>
              </Box>
            </FormGroup>
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
    );
}
Fornecedoredicao.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
    ididentificador: PropTypes.number,
    atualiza: PropTypes.node,
    titulotopo: PropTypes.string
};
export default Fornecedoredicao;
import { useState, useEffect } from 'react';
import { Button, FormGroup, Input, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
import PropTypes from 'prop-types';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import modoVisualizador from '../../../services/modovisualizador';

const Planocontaedicao = ({ setshow, show, ididentificador, atualiza }) => {
  const [mensagem, setMensagem] = useState('');
  const [mensagemsucesso, setMensagemsucesso] = useState('');
  const [loading, setLoading] = useState(false);
  const [idplanoconta, setidplanoconta] = useState('');
  const [codigo, setcodigo] = useState('');
  const [descricao, setdescricao] = useState('');
  const [tipo, settipo] = useState('');
  const [naocontabilizado, setnaocontabilizado] = useState('');

  const togglecadastro = () => {
    setshow(!show);
  };

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idplanocontabusca: ididentificador,
    deletado: 0,
  };

  //Funções
  const listaplanoconta = async () => {
    try {
      setLoading(true);
      await api.get('/v1/planocontaid', { params }).then((response) => {
        setidplanoconta(response.data.idplanoconta);
        setcodigo(response.data.codigo);
        setdescricao(response.data.descricao);
        settipo(response.data.tipo);
        setnaocontabilizado(response.data.naocontabilizado);
        setMensagem('');
      });
    } catch (err) {
      setMensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  function LimpaCampos() {
    setidplanoconta(0);
    setcodigo('');
    setdescricao('');
    settipo('');
    setnaocontabilizado('');
    setMensagem('');
  }

  function ProcessaCadastro(e) {
    e.preventDefault();
    setMensagem('');
    setMensagemsucesso('');
    api
      .post('v1/planoconta', {
        idplanoconta: ididentificador,
        codigo,
        descricao,
        tipo,
        naocontabilizado,
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

  function ProcessaContinua(e) {
    e.preventDefault();
    setMensagem('');
    api
      .post('v1/planoconta', {
        idplanoconta,
        codigo,
        descricao,
        tipo,
        naocontabilizado,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setMensagem('');
          setMensagemsucesso('Registro Salvo');
          LimpaCampos();
          atualiza();
        } else {
          setMensagem(response.status);
          setMensagemsucesso('');
        }
      })
      .catch((err) => console.log(err));
  }

  useEffect(() => {
    listaplanoconta();
  }, []);
  return (
    <Modal isOpen={show} toggle={togglecadastro.bind(null)} className="modal-dialog modal-xl">
      <ModalHeader toggle={togglecadastro.bind(null)}>Cadastro Plano de Conta</ModalHeader>
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
            <div className="row g-3">
              <div className="col-sm-2 ">
                Código
                <Input
                  type="text"
                  onChange={(e) => setcodigo(e.target.value)}
                  value={codigo}
                  placeholder=""
                />
              </div>
              <div className="col-sm-6">
                Plano de Conta
                <Input
                  type="text"
                  onChange={(e) => setdescricao(e.target.value)}
                  value={descricao}
                  placeholder=""
                />
              </div>
              <div className="col-sm-2 ">
                Tipo
                <Input
                  type="select"
                  onChange={(e) => settipo(e.target.value)}
                  value={tipo}
                  name="input"
                  id="input"
                >
                  <option value="0">Selecione</option>
                  <option value="1">Receita</option>
                  <option value="2">Despesa</option>
                </Input>
              </div>
              <div className="col-sm-2 ">
                Não Contabilizado
                <Input
                  type="select"
                  onChange={(e) => setnaocontabilizado(e.target.value)}
                  value={naocontabilizado}
                  name="input"
                  id="input"
                >
                  <option>Selecione</option>
                  <option>Sim</option>
                  <option>Não</option>
                </Input>
              </div>
            </div>
          </FormGroup>
        )}
      </ModalBody>
      <ModalFooter>
        <Button color="success" onClick={ProcessaCadastro} disabled={modoVisualizador()}>
          Salvar
        </Button>
        <Button color="primary" onClick={ProcessaContinua} disabled={modoVisualizador()}>
          Salvar e Continuar
        </Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Planocontaedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.node,
};

export default Planocontaedicao;

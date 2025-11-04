import { useState, useEffect } from 'react';
import { Button, FormGroup, Input, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
import PropTypes from 'prop-types';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import modoVisualizador from '../../../services/modovisualizador';

const Tarefaedicao = ({ setshow, show, ididentificador, atualiza, titulotopo, obra, siteid }) => {
  const [mensagem, setMensagem] = useState('');
  const [mensagemsucesso, setMensagemsucesso] = useState('');
  const [loading, setLoading] = useState(false);
  const [data, setdata] = useState('');
  const [descricao, setdescricao] = useState('');
  const [codigoservico, setcodigoservico] = useState('');

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
      const response = await api.get('/v1/planocontaid', { params });
      setdata(response.data.datacriacaopo);
      setdescricao(response.data.descricaoservico);
      setcodigoservico(response.data.codigoservico);
      setMensagem('');
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
      .post('v1/projetoericsson/salvatarefa', {
        idtarefa: ididentificador,
        nobra: obra,
        codigoservico,
        site: siteid,
        data,
        descricao,
      })
      .then((response) => {
        if (response.status === 201) {
          setMensagem('');
          setMensagemsucesso('Registro Salvo');
          setshow(!show);
          if (atualiza) {
            atualiza();
          }
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
    console.log(ididentificador);
    if (ididentificador) listaplanoconta();
  }, [ididentificador]);
  return (
    <Modal isOpen={show} toggle={togglecadastro.bind(null)} className="modal-dialog modal-sm">
      <ModalHeader toggle={togglecadastro.bind(null)}>{titulotopo}</ModalHeader>
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
              <div className="col-sm-12 ">
                Data Criação
                <Input
                  type="date"
                  onChange={(e) => setdata(e.target.value)}
                  value={data}
                  placeholder=""
                />
              </div>
              <div className="col-sm-12">
                Codigo de Serviço
                <Input
                  type="text"
                  onChange={(e) => setcodigoservico(e.target.value)}
                  value={codigoservico}
                  placeholder=""
                />
              </div>
              <div className="col-sm-12">
                Descrição
                <Input
                  type="text"
                  onChange={(e) => setdescricao(e.target.value)}
                  value={descricao}
                  placeholder=""
                />
              </div>
            </div>
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
};

Tarefaedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.func,
  obra: PropTypes.string,
  siteid: PropTypes.string,
  titulotopo: PropTypes.string,
};

export default Tarefaedicao;
